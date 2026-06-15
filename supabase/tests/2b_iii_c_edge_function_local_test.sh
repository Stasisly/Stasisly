#!/usr/bin/env bash

set -euo pipefail

if ! command -v jq >/dev/null; then
  echo "jq is required" >&2
  exit 1
fi

if rg -n 'supabase\.co([/:]|$)|project_ref|SUPABASE_ACCESS_TOKEN' \
  supabase/config.toml supabase/.branches supabase/.temp 2>/dev/null; then
  echo "Remote-looking Supabase configuration detected; refusing to run" >&2
  exit 1
fi

eval "$(supabase status -o env 2>/dev/null | sed -n '/^[A-Z_]*=/p')"

case "$API_URL" in
  http://127.0.0.1:54321|http://localhost:54321) ;;
  *)
    echo "API_URL is not the approved local endpoint" >&2
    exit 1
    ;;
esac

case "$FUNCTIONS_URL" in
  http://127.0.0.1:54321/functions/v1|http://localhost:54321/functions/v1) ;;
  *)
    echo "FUNCTIONS_URL is not the approved local endpoint" >&2
    exit 1
    ;;
esac

email="edge-test-$(date +%s)@stasisly.local"
password="LocalTestOnly-9!"
tmp_dir="$(mktemp -d /tmp/stasisly-edge-http.XXXXXX)"

cleanup() {
  rm -rf "$tmp_dir"
  docker exec supabase_db_Stasisly psql -U postgres -d postgres \
    -v ON_ERROR_STOP=1 \
    -c "delete from auth.users where email = '$email';" >/dev/null 2>&1 || true
}
trap cleanup EXIT

signup="$(curl --silent --show-error --fail-with-body \
  -H "apikey: $ANON_KEY" \
  -H "Content-Type: application/json" \
  -d "{\"email\":\"$email\",\"password\":\"$password\"}" \
  "$API_URL/auth/v1/signup")"
token="$(printf '%s' "$signup" | jq -r '.access_token')"
test "$token" != "null"
test -n "$token"

no_jwt_status="$(curl -sS -o "$tmp_dir/no-jwt.json" -w '%{http_code}' \
  "$FUNCTIONS_URL/list-selectable-specialists")"
invalid_jwt_status="$(curl -sS -o "$tmp_dir/invalid-jwt.json" -w '%{http_code}' \
  -H "Authorization: Bearer invalid" \
  "$FUNCTIONS_URL/list-selectable-specialists")"
valid_status="$(curl -sS -o "$tmp_dir/valid.json" -w '%{http_code}' \
  -H "Authorization: Bearer $token" \
  "$FUNCTIONS_URL/list-selectable-specialists")"
invalid_area_status="$(curl -sS -o "$tmp_dir/invalid-area.json" -w '%{http_code}' \
  -H "Authorization: Bearer $token" \
  "$FUNCTIONS_URL/list-selectable-specialists?area=mental")"
client_authority_status="$(
  curl -sS -o "$tmp_dir/client-authority.json" -w '%{http_code}' \
    -H "Authorization: Bearer $token" \
    "$FUNCTIONS_URL/list-selectable-specialists?user_id=attacker&role=admin&entitlement=premium&accessState=available"
)"

test "$no_jwt_status" = "401"
test "$(jq -r '.error.code' "$tmp_dir/no-jwt.json")" = "catalogUnauthenticated"
test "$invalid_jwt_status" = "401"
test "$(jq -r '.error.code' "$tmp_dir/invalid-jwt.json")" = "catalogUnauthenticated"
test "$valid_status" = "200"
test "$(jq -r 'keys == ["items"]' "$tmp_dir/valid.json")" = "true"
test "$(jq -r '.items | length' "$tmp_dir/valid.json")" = "0"
test "$invalid_area_status" = "400"
test "$(jq -r '.error.code' "$tmp_dir/invalid-area.json")" = "catalogInvalidArea"
test "$client_authority_status" = "400"
test "$(jq -r '.error.code' "$tmp_dir/client-authority.json")" = "catalogInvalidRequest"

catalog_count="$(docker exec supabase_db_Stasisly psql -U postgres -d postgres \
  -Atc 'select count(*) from public.specialist_catalog;')"
test "$catalog_count" = "0"

echo "2B-III-C HTTP local harness: PASS"

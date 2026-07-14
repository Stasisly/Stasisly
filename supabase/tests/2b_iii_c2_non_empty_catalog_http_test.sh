#!/usr/bin/env bash

set -euo pipefail

for command in curl docker jq rg supabase; do
  command -v "$command" >/dev/null || {
    echo "$command is required" >&2
    exit 1
  }
done

echo "C2 stage: anti-remote preflight"
if rg -n 'supabase\.co([/:]|$)|project_ref|SUPABASE_ACCESS_TOKEN' \
  supabase/config.toml supabase/.branches supabase/.temp 2>/dev/null; then
  echo "Remote-looking Supabase configuration detected; refusing to run" >&2
  exit 1
fi

eval "$(supabase status -o env 2>/dev/null | sed -n '/^[A-Z_]*=/p')"

case "$API_URL|$FUNCTIONS_URL" in
  http://127.0.0.1:54321\|http://127.0.0.1:54321/functions/v1|\
  http://localhost:54321\|http://localhost:54321/functions/v1) ;;
  *)
    echo "Supabase endpoints are not approved local endpoints" >&2
    exit 1
    ;;
esac

test -n "${STASISLY_EDGE_LOG_FILE:-}"
test -f "$STASISLY_EDGE_LOG_FILE"

echo "C2 stage: initialize cleanup trap"
email="test_only_c2_$(date +%s)@stasisly.local"
password="LocalTestOnly-9!"
tmp_dir="$(mktemp -d /tmp/stasisly-c2-http.XXXXXX)"
cleanup_started=false

db_psql() {
  docker exec -i supabase_db_Stasisly psql -U postgres -d postgres \
    -v ON_ERROR_STOP=1 "$@"
}

cleanup() {
  local exit_code=$?
  cleanup_started=true
  db_psql < supabase/tests/2b_iii_c2_non_empty_catalog_cleanup.psql \
    >/dev/null 2>&1 || true
  db_psql -c "delete from auth.users where email = '$email';" \
    >/dev/null 2>&1 || true
  rm -rf "$tmp_dir"
  return "$exit_code"
}
trap cleanup EXIT INT TERM

echo "C2 stage: verify clean database preconditions"
test "$(db_psql -Atc 'select count(*) from public.specialist_catalog;')" = "0"
test "$(db_psql -Atc "select count(*) from public.specialists where name like 'test_only_c2%';")" = "0"

echo "C2 stage: setup fixtures"
db_psql < supabase/tests/2b_iii_c2_non_empty_catalog_setup.psql >/dev/null
test "$(db_psql -Atc 'select count(*) from public.specialist_catalog;')" = "21"
test "$(db_psql -Atc "select count(*) from public.specialists where name like 'test_only_c2%';")" = "21"

echo "C2 stage: create local Auth identity"
signup="$(curl --silent --show-error --fail-with-body \
  -H "apikey: $ANON_KEY" \
  -H "Content-Type: application/json" \
  -d "{\"email\":\"$email\",\"password\":\"$password\"}" \
  "$API_URL/auth/v1/signup")"
token="$(printf '%s' "$signup" | jq -r '.access_token')"
test "$token" != "null"
test -n "$token"

echo "C2 stage: call local Edge Function"
no_jwt_status="$(curl -sS -o "$tmp_dir/no-jwt.json" -w '%{http_code}' \
  "$FUNCTIONS_URL/list-selectable-specialists")"
invalid_jwt_status="$(curl -sS -o "$tmp_dir/invalid-jwt.json" -w '%{http_code}' \
  -H "Authorization: Bearer invalid" \
  "$FUNCTIONS_URL/list-selectable-specialists")"
all_status="$(curl -sS -o "$tmp_dir/all.json" -w '%{http_code}' \
  -H "Authorization: Bearer $token" \
  "$FUNCTIONS_URL/list-selectable-specialists")"
wellness_status="$(curl -sS -o "$tmp_dir/wellness.json" -w '%{http_code}' \
  -H "Authorization: Bearer $token" \
  "$FUNCTIONS_URL/list-selectable-specialists?area=wellness")"
invalid_area_status="$(curl -sS -o "$tmp_dir/invalid-area.json" -w '%{http_code}' \
  -H "Authorization: Bearer $token" \
  "$FUNCTIONS_URL/list-selectable-specialists?area=mental")"
authority_status="$(curl -sS -o "$tmp_dir/authority.json" -w '%{http_code}' \
  -H "Authorization: Bearer $token" \
  "$FUNCTIONS_URL/list-selectable-specialists?user_id=attacker&role=admin&entitlement=pro&accessState=available")"

test "$no_jwt_status" = "401"
test "$invalid_jwt_status" = "401"
test "$all_status" = "200"
test "$wellness_status" = "200"
test "$invalid_area_status" = "400"
test "$authority_status" = "400"
test "$(jq -r '.error.code' "$tmp_dir/invalid-area.json")" = "catalogInvalidArea"
test "$(jq -r '.error.code' "$tmp_dir/authority.json")" = "catalogInvalidRequest"

echo "C2 stage: validate HTTP contract and business states"
test "$(jq -r 'keys == ["items"]' "$tmp_dir/all.json")" = "true"
test "$(jq -r '.items | length' "$tmp_dir/all.json")" = "20"
test "$(jq -r '[.items[] | keys == ["accessState","area","displayName","id","isDemo","shortDescription"]] | all' "$tmp_dir/all.json")" = "true"
test "$(jq -r '[.items[].isDemo] | all(. == false)' "$tmp_dir/all.json")" = "true"
test "$(jq -r '[.items[0:4][].displayName] == ["Stasis","Nutrición","Wellness pro","Sueño y estrés"]' "$tmp_dir/all.json")" = "true"
test "$(jq -r '[.items[] | select(.displayName == "Stasis")][0].accessState' "$tmp_dir/all.json")" = "available"
test "$(jq -r '[.items[] | select(.displayName == "Nutrición")][0].accessState' "$tmp_dir/all.json")" = "available"
test "$(jq -r '[.items[] | select(.displayName == "Wellness pro")][0].accessState' "$tmp_dir/all.json")" = "lockedPro"
test "$(jq -r '[.items[] | select(.displayName == "Sueño y estrés")][0].accessState' "$tmp_dir/all.json")" = "unavailable"
test "$(jq -r '[.items[].displayName] | index("test_only_c2 auxiliary 17") == null' "$tmp_dir/all.json")" = "true"

test "$(jq -r '.items | length' "$tmp_dir/wellness.json")" = "2"
test "$(jq -r '[.items[].displayName] == ["Wellness pro","Sueño y estrés"]' "$tmp_dir/wellness.json")" = "true"

if rg -n '"(specialist_id|prompt_template|access_tier|availability_status|is_published|created_at|updated_at|branch_id|chief_id)"' \
  "$tmp_dir/all.json" "$tmp_dir/wellness.json"; then
  echo "Forbidden internal field found in HTTP response" >&2
  exit 1
fi

echo "C2 stage: validate direct client deny-all"
anon_status="$(curl -sS -o "$tmp_dir/anon-direct.json" -w '%{http_code}' \
  -H "apikey: $ANON_KEY" \
  "$API_URL/rest/v1/specialist_catalog?select=id")"
auth_status="$(curl -sS -o "$tmp_dir/auth-direct.json" -w '%{http_code}' \
  -H "apikey: $ANON_KEY" -H "Authorization: Bearer $token" \
  "$API_URL/rest/v1/specialist_catalog?select=id")"
echo "C2 direct deny-all statuses: anon=$anon_status authenticated=$auth_status"
case "$anon_status" in 401|403) ;; *) exit 1 ;; esac
case "$auth_status" in 401|403) ;; *) exit 1 ;; esac

echo "C2 stage: validate safe logs"
sleep 1
for forbidden in "$token" "prompt_template" "specialist_id" "access_tier" \
  "availability_status" "service_role"; do
  if rg -F -- "$forbidden" "$STASISLY_EDGE_LOG_FILE" >/dev/null; then
    echo "Forbidden value found in Edge Function logs: $forbidden" >&2
    exit 1
  fi
done

echo "C2 stage: cleanup and verify postconditions"
cleanup
trap - EXIT INT TERM
test "$cleanup_started" = "true"
test "$(db_psql -Atc 'select count(*) from public.specialist_catalog;')" = "0"
test "$(db_psql -Atc "select count(*) from public.specialists where name like 'test_only_c2%';")" = "0"
test "$(db_psql -Atc "select count(*) from auth.users where email like 'test_only_c2_%@stasisly.local';")" = "0"

echo "2B-III-C2 non-empty HTTP local harness: PASS"

#!/usr/bin/env bash

set -euo pipefail

for command in curl docker jq rg supabase; do
  command -v "$command" >/dev/null || {
    echo "$command is required" >&2
    exit 1
  }
done

echo "2B-IV-C stage: anti-remote preflight"
if rg -n 'supabase\.co([/:]|$)|project_ref|SUPABASE_ACCESS_TOKEN' \
  supabase/config.toml supabase/.branches supabase/.temp 2>/dev/null; then
  echo "Remote-looking Supabase configuration detected; refusing to run" >&2
  exit 1
fi

eval "$(supabase status -o env 2>/dev/null | sed -n '/^[A-Z_]*=/p')"
case "$API_URL|$FUNCTIONS_URL" in
  http://127.0.0.1:54321\|http://127.0.0.1:54321/functions/v1|\
  http://localhost:54321\|http://localhost:54321/functions/v1) ;;
  *) echo "Supabase endpoints are not approved local endpoints" >&2; exit 1 ;;
esac

test -n "${STASISLY_EDGE_LOG_FILE:-}"
test -f "$STASISLY_EDGE_LOG_FILE"

email="test_only_2b_iv_c_$(date +%s)@stasisly.local"
password="LocalTestOnly-9!"
tmp_dir="$(mktemp -d /tmp/stasisly-2b-iv-c.XXXXXX)"

db_psql() {
  docker exec -i supabase_db_Stasisly psql -U postgres -d postgres \
    -v ON_ERROR_STOP=1 "$@"
}

cleanup() {
  local exit_code=$?
  db_psql < supabase/tests/2b_iv_c_create_session_cleanup.psql \
    >/dev/null 2>&1 || true
  rm -rf "$tmp_dir"
  return "$exit_code"
}
trap cleanup EXIT INT TERM

echo "2B-IV-C stage: verify clean preconditions and create fixtures"
test "$(db_psql -Atc "select count(*) from public.specialists where name like 'test_only_2b_iv_c%';")" = "0"
test "$(db_psql -Atc "select count(*) from public.chat_sessions where specialist_id::text like '4c200000-0000-4000-8000-%';")" = "0"
messages_before="$(db_psql -Atc 'select count(*) from public.messages;')"
db_psql < supabase/tests/2b_iv_c_create_session_setup.psql >/dev/null
catalog_fingerprint_before="$(db_psql -Atc "select md5(string_agg(row_to_json(c)::text, '' order by c.id)) from public.specialist_catalog c where display_name like 'test_only_2b_iv_c%';")"
specialist_fingerprint_before="$(db_psql -Atc "select md5(string_agg(row_to_json(s)::text, '' order by s.id)) from public.specialists s where name like 'test_only_2b_iv_c%';")"

echo "2B-IV-C stage: create local Auth identity and profile"
signup="$(curl --silent --show-error --fail-with-body \
  -H "apikey: $ANON_KEY" -H "Content-Type: application/json" \
  -d "{\"email\":\"$email\",\"password\":\"$password\"}" \
  "$API_URL/auth/v1/signup")"
token="$(printf '%s' "$signup" | jq -r '.access_token')"
owner_id="$(printf '%s' "$signup" | jq -r '.user.id')"
test -n "$token"; test "$token" != "null"
test -n "$owner_id"; test "$owner_id" != "null"
db_psql -c "insert into public.users(id, display_name) values ('$owner_id', 'test_only_2b_iv_c owner');" >/dev/null

endpoint="$FUNCTIONS_URL/create-own-chat-session"
valid_body='{"selectableSpecialistId":"4c300000-0000-4000-8000-000000000001"}'
call() {
  local name=$1 body=$2 token_value=${3:-$token}
  curl -sS -o "$tmp_dir/$name.json" -w '%{http_code}' \
    -X POST -H "Authorization: Bearer $token_value" \
    -H "Content-Type: application/json" -H "Accept: application/json" \
    -d "$body" "$endpoint"
}

echo "2B-IV-C stage: request/JWT and specialist rejection tests"
no_jwt_status="$(curl -sS -o "$tmp_dir/no-jwt.json" -w '%{http_code}' \
  -X POST -H "Content-Type: application/json" -d "$valid_body" "$endpoint")"
invalid_jwt_status="$(call invalid-jwt "$valid_body" invalid)"
empty_status="$(call empty '{}')"
extra_status="$(call extra '{"selectableSpecialistId":"4c300000-0000-4000-8000-000000000001","user_id":"attacker"}')"
internal_status="$(call internal '{"selectableSpecialistId":"4c300000-0000-4000-8000-000000000001","specialist_id":"4c200000-0000-4000-8000-000000000001"}')"
missing_status="$(call missing '{"selectableSpecialistId":"4c300000-0000-4000-8000-000000000099"}')"
pro_status="$(call pro '{"selectableSpecialistId":"4c300000-0000-4000-8000-000000000002"}')"
unavailable_status="$(call unavailable '{"selectableSpecialistId":"4c300000-0000-4000-8000-000000000003"}')"
test "$no_jwt_status" = "401"
test "$invalid_jwt_status" = "401"
test "$empty_status" = "400"
test "$extra_status" = "400"
test "$internal_status" = "400"
test "$missing_status" = "404"
test "$pro_status" = "403"
test "$unavailable_status" = "409"

echo "2B-IV-C stage: two valid calls must create distinct sessions"
first_status="$(call first "$valid_body")"
second_status="$(call second "$valid_body")"
test "$first_status" = "201"
test "$second_status" = "201"
first_id="$(jq -r '.session.sessionId' "$tmp_dir/first.json")"
second_id="$(jq -r '.session.sessionId' "$tmp_dir/second.json")"
test -n "$first_id"; test "$first_id" != "null"
test -n "$second_id"; test "$second_id" != "null"
test "$first_id" != "$second_id"
test "$(db_psql -Atc "select count(*) from public.chat_sessions where user_id = '$owner_id' and specialist_id = '4c200000-0000-4000-8000-000000000001';")" = "2"
test "$(db_psql -Atc "select count(distinct id) from public.chat_sessions where user_id = '$owner_id' and specialist_id = '4c200000-0000-4000-8000-000000000001';")" = "2"
test "$(db_psql -Atc "select count(*) from public.chat_sessions where user_id = '$owner_id' and status = 'active' and message_count = 0 and last_message_at >= started_at;")" = "2"

echo "2B-IV-C stage: validate public response and integrity"
for response in "$tmp_dir/first.json" "$tmp_dir/second.json"; do
  test "$(jq -r 'keys == ["session"]' "$response")" = "true"
  test "$(jq -r '.session | keys == ["lastMessageAt","messageCount","selectableSpecialist","sessionId","startedAt","status"]' "$response")" = "true"
  test "$(jq -r '.session.selectableSpecialist | keys == ["area","displayName","id"]' "$response")" = "true"
  test "$(jq -r '.session.selectableSpecialist.id' "$response")" = "4c300000-0000-4000-8000-000000000001"
  if rg -n '"(user_id|userId|specialist_id|specialistId|prompt_template|access_tier|availability_status|is_published|roles|permissions)"' "$response"; then
    echo "Forbidden internal field found in response" >&2
    exit 1
  fi
  if rg -F '4c200000-0000-4000-8000-000000000001' "$response"; then
    echo "Internal specialist ID found in response" >&2
    exit 1
  fi
done

test "$(db_psql -Atc 'select count(*) from public.messages;')" = "$messages_before"
test "$(db_psql -Atc "select count(*) from public.messages m join public.chat_sessions s on s.id = m.session_id where s.user_id = '$owner_id';")" = "0"
test "$(db_psql -Atc "select md5(string_agg(row_to_json(c)::text, '' order by c.id)) from public.specialist_catalog c where display_name like 'test_only_2b_iv_c%';")" = "$catalog_fingerprint_before"
test "$(db_psql -Atc "select md5(string_agg(row_to_json(s)::text, '' order by s.id)) from public.specialists s where name like 'test_only_2b_iv_c%';")" = "$specialist_fingerprint_before"

echo "2B-IV-C stage: validate safe logs"
sleep 1
for forbidden in "$token" "$owner_id" "4c200000-0000-4000-8000-000000000001" \
  "prompt_template" "specialist_id" "user_id" "service_role"; do
  if rg -F -- "$forbidden" "$STASISLY_EDGE_LOG_FILE" >/dev/null; then
    echo "Forbidden value found in Edge Function logs: $forbidden" >&2
    exit 1
  fi
done

echo "2B-IV-C stage: cleanup and zero-fixture postconditions"
cleanup
trap - EXIT INT TERM
test "$(db_psql -Atc "select count(*) from auth.users where email like 'test_only_2b_iv_c_%@stasisly.local';")" = "0"
test "$(db_psql -Atc "select count(*) from public.users where display_name like 'test_only_2b_iv_c%';")" = "0"
test "$(db_psql -Atc "select count(*) from public.specialists where name like 'test_only_2b_iv_c%';")" = "0"
test "$(db_psql -Atc "select count(*) from public.specialist_catalog where display_name like 'test_only_2b_iv_c%';")" = "0"
test "$(db_psql -Atc "select count(*) from public.chat_sessions where specialist_id::text like '4c200000-0000-4000-8000-%';")" = "0"
test "$(db_psql -Atc 'select count(*) from public.messages;')" = "$messages_before"

echo "2B-IV-C createOwnChatSession local HTTP harness: PASS"

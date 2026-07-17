#!/usr/bin/env bash

set -euo pipefail

for command in curl docker jq rg supabase; do
  command -v "$command" >/dev/null || {
    echo "$command is required" >&2
    exit 1
  }
done

echo "2B-IV-E stage: anti-remote preflight"
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

tmp_dir="$(mktemp -d /tmp/stasisly-2b-iv-e.XXXXXX)"
email_a="test_only_2b_iv_e_a_$(date +%s)@stasisly.local"
email_b="test_only_2b_iv_e_b_$(date +%s)@stasisly.local"
password="LocalTestOnly-9!"

db_psql() {
  docker exec -i supabase_db_Stasisly psql -U postgres -d postgres \
    -v ON_ERROR_STOP=1 "$@"
}

cleanup() {
  local exit_code=$?
  db_psql < supabase/tests/2b_iv_e_archive_session_cleanup.psql \
    >/dev/null 2>&1 || true
  rm -rf "$tmp_dir"
  return "$exit_code"
}
trap cleanup EXIT INT TERM

echo "2B-IV-E stage: setup fixtures and identities"
db_psql < supabase/tests/2b_iv_e_archive_session_setup.psql >/dev/null
signup_a="$(curl --silent --show-error --fail-with-body \
  -H "apikey: $ANON_KEY" -H "Content-Type: application/json" \
  -d "{\"email\":\"$email_a\",\"password\":\"$password\"}" "$API_URL/auth/v1/signup")"
signup_b="$(curl --silent --show-error --fail-with-body \
  -H "apikey: $ANON_KEY" -H "Content-Type: application/json" \
  -d "{\"email\":\"$email_b\",\"password\":\"$password\"}" "$API_URL/auth/v1/signup")"
token_a="$(printf '%s' "$signup_a" | jq -r '.access_token')"
token_b="$(printf '%s' "$signup_b" | jq -r '.access_token')"
owner_a="$(printf '%s' "$signup_a" | jq -r '.user.id')"
owner_b="$(printf '%s' "$signup_b" | jq -r '.user.id')"
for value in "$token_a" "$token_b" "$owner_a" "$owner_b"; do
  test -n "$value"; test "$value" != "null"
done

db_psql -c "insert into public.users(id,display_name) values
('$owner_a','test_only_2b_iv_e owner a'),
('$owner_b','test_only_2b_iv_e owner b');
insert into public.chat_sessions(id,user_id,specialist_id,started_at,last_message_at,status,message_count,archived_at) values
('4e400000-0000-4000-8000-000000000001','$owner_a','4e200000-0000-4000-8000-000000000001','2026-06-14 08:00:00','2026-06-14 12:34:56','active',7,null),
('4e400000-0000-4000-8000-000000000002','$owner_a','4e200000-0000-4000-8000-000000000001','2026-06-14 08:00:00','2026-06-14 11:00:00','archived',3,'2026-06-14 11:30:00'),
('4e400000-0000-4000-8000-000000000003','$owner_b','4e200000-0000-4000-8000-000000000001','2026-06-14 09:00:00','2026-06-14 13:00:00','active',5,null);" >/dev/null

db_psql -Atc "select row_to_json(s) from public.chat_sessions s where id='4e400000-0000-4000-8000-000000000001';" > "$tmp_dir/target-before.json"
others_before="$(db_psql -Atc "select md5(string_agg(row_to_json(s)::text,'' order by s.id)) from public.chat_sessions s where specialist_id='4e200000-0000-4000-8000-000000000001' and id <> '4e400000-0000-4000-8000-000000000001';")"
specialist_before="$(db_psql -Atc "select md5(string_agg(row_to_json(s)::text,'' order by s.id)) from public.specialists s where name like 'test_only_2b_iv_e%';")"
messages_before="$(db_psql -Atc 'select count(*) from public.messages;')"
endpoint="$FUNCTIONS_URL/archive-own-chat-session"

call() {
  local name=$1 token=$2 body=$3
  curl -sS -o "$tmp_dir/$name.json" -w '%{http_code}' \
    -X POST -H "Authorization: Bearer $token" \
    -H "Content-Type: application/json" -H "Accept: application/json" \
    -d "$body" "$endpoint"
}

echo "2B-IV-E stage: request/JWT/body validation"
valid_body='{"sessionId":"4e400000-0000-4000-8000-000000000001"}'
no_jwt_status="$(curl -sS -o "$tmp_dir/no-jwt.json" -w '%{http_code}' \
  -X POST -H "Content-Type: application/json" -d "$valid_body" "$endpoint")"
invalid_jwt_status="$(call invalid-jwt invalid "$valid_body")"
empty_status="$(call empty "$token_a" '{}')"
authority_status="$(call authority "$token_a" '{"sessionId":"4e400000-0000-4000-8000-000000000001","user_id":"attacker"}')"
internal_status="$(call internal "$token_a" '{"sessionId":"4e400000-0000-4000-8000-000000000001","specialist_id":"x"}')"
status_status="$(call status "$token_a" '{"sessionId":"4e400000-0000-4000-8000-000000000001","status":"archived"}')"
test "$no_jwt_status" = "401"
test "$invalid_jwt_status" = "401"
test "$empty_status" = "400"
test "$authority_status" = "400"
test "$internal_status" = "400"
test "$status_status" = "400"

echo "2B-IV-E stage: owner archives and only lifecycle fields change"
success_status="$(call success "$token_a" "$valid_body")"
test "$success_status" = "200"
test "$(jq -r 'keys == ["session"]' "$tmp_dir/success.json")" = "true"
test "$(jq -r '.session | keys == ["sessionId","status"]' "$tmp_dir/success.json")" = "true"
test "$(jq -r '.session.sessionId' "$tmp_dir/success.json")" = "4e400000-0000-4000-8000-000000000001"
test "$(jq -r '.session.status' "$tmp_dir/success.json")" = "archived"
if rg -n '"(user_id|userId|specialist_id|specialistId|startedAt|lastMessageAt|messageCount|selectableSpecialist|prompt_template)"' "$tmp_dir/success.json"; then
  echo "Forbidden field found in minimal archive response" >&2
  exit 1
fi

db_psql -Atc "select row_to_json(s) from public.chat_sessions s where id='4e400000-0000-4000-8000-000000000001';" > "$tmp_dir/target-after.json"
test "$(jq -r '.status' "$tmp_dir/target-before.json")" = "active"
test "$(jq -r '.status' "$tmp_dir/target-after.json")" = "archived"
for field in id user_id specialist_id started_at last_message_at message_count; do
  test "$(jq -r \".$field\" "$tmp_dir/target-before.json")" = "$(jq -r \".$field\" "$tmp_dir/target-after.json")"
done
test "$(jq -r '.last_message_at' "$tmp_dir/target-after.json")" = "2026-06-14T12:34:56"

echo "2B-IV-E stage: missing/foreign opaque and archive replay idempotent"
foreign_status="$(call foreign "$token_a" '{"sessionId":"4e400000-0000-4000-8000-000000000003"}')"
archived_status="$(call archived "$token_a" '{"sessionId":"4e400000-0000-4000-8000-000000000002"}')"
missing_status="$(call missing "$token_a" '{"sessionId":"4e400000-0000-4000-8000-000000000099"}')"
repeat_status="$(call repeat "$token_a" "$valid_body")"
test "$foreign_status" = "404"
test "$archived_status" = "200"
test "$missing_status" = "404"
test "$repeat_status" = "200"
for response in archived repeat; do
  test "$(jq -r '.session.status' "$tmp_dir/$response.json")" = "archived"
done
for response in foreign missing; do
  test "$(jq -r '.error.code' "$tmp_dir/$response.json")" = "sessionNotFound"
  test "$(jq -r 'keys == ["error"] and (.error | keys == ["code","requestId"])' "$tmp_dir/$response.json")" = "true"
  if rg -n 'user_id|specialist_id|status|owner|archived|active|exists' "$tmp_dir/$response.json"; then
    echo "Opaque not-found response leaked information" >&2
    exit 1
  fi
done

echo "2B-IV-E stage: integrity and safe logs"
test "$(db_psql -Atc "select md5(string_agg(row_to_json(s)::text,'' order by s.id)) from public.chat_sessions s where specialist_id='4e200000-0000-4000-8000-000000000001' and id <> '4e400000-0000-4000-8000-000000000001';")" = "$others_before"
test "$(db_psql -Atc "select md5(string_agg(row_to_json(s)::text,'' order by s.id)) from public.specialists s where name like 'test_only_2b_iv_e%';")" = "$specialist_before"
test "$(db_psql -Atc 'select count(*) from public.messages;')" = "$messages_before"
test "$(db_psql -Atc "select count(*) from public.specialist_catalog where display_name like 'test_only_2b_iv_e%';")" = "0"
sleep 1
for forbidden in "$token_a" "$token_b" "$owner_a" "$owner_b" \
  "4e400000-0000-4000-8000-000000000001" "specialist_id" "user_id" \
  "prompt_template" "service_role"; do
  if rg -F -- "$forbidden" "$STASISLY_EDGE_LOG_FILE" >/dev/null; then
    echo "Forbidden value found in Edge Function logs: $forbidden" >&2
    exit 1
  fi
done

echo "2B-IV-E stage: cleanup and zero-fixture postconditions"
cleanup
trap - EXIT INT TERM
test "$(db_psql -Atc "select count(*) from auth.users where email like 'test_only_2b_iv_e_%@stasisly.local';")" = "0"
test "$(db_psql -Atc "select count(*) from public.users where display_name like 'test_only_2b_iv_e%';")" = "0"
test "$(db_psql -Atc "select count(*) from public.specialists where name like 'test_only_2b_iv_e%';")" = "0"
test "$(db_psql -Atc "select count(*) from public.chat_sessions where specialist_id::text like '4e200000-0000-4000-8000-%';")" = "0"
test "$(db_psql -Atc 'select count(*) from public.messages;')" = "$messages_before"

echo "2B-IV-E archiveOwnChatSession local HTTP harness: PASS"

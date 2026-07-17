#!/usr/bin/env bash

set -euo pipefail

for command in curl docker jq rg supabase; do
  command -v "$command" >/dev/null || {
    echo "$command is required" >&2
    exit 1
  }
done

echo "2B-IV-D stage: anti-remote preflight"
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

tmp_dir="$(mktemp -d /tmp/stasisly-2b-iv-d.XXXXXX)"
email_a="test_only_2b_iv_d_a_$(date +%s)@stasisly.local"
email_b="test_only_2b_iv_d_b_$(date +%s)@stasisly.local"
password="LocalTestOnly-9!"

db_psql() {
  docker exec -i supabase_db_Stasisly psql -U postgres -d postgres \
    -v ON_ERROR_STOP=1 "$@"
}

cleanup() {
  local exit_code=$?
  db_psql < supabase/tests/2b_iv_d_list_sessions_cleanup.psql \
    >/dev/null 2>&1 || true
  rm -rf "$tmp_dir"
  return "$exit_code"
}
trap cleanup EXIT INT TERM

echo "2B-IV-D stage: setup fixtures and identities"
db_psql < supabase/tests/2b_iv_d_list_sessions_setup.psql >/dev/null
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
('$owner_a','test_only_2b_iv_d owner a'),
('$owner_b','test_only_2b_iv_d owner b');
insert into public.chat_sessions(id,user_id,specialist_id,started_at,last_message_at,status,message_count,archived_at) values
('4d400000-0000-4000-8000-000000000005','$owner_a','4d200000-0000-4000-8000-000000000001','2026-06-14 08:00:00','2026-06-14 12:00:00','active',0,null),
('4d400000-0000-4000-8000-000000000004','$owner_a','4d200000-0000-4000-8000-000000000001','2026-06-14 08:00:00','2026-06-14 12:00:00','active',0,null),
('4d400000-0000-4000-8000-000000000003','$owner_a','4d200000-0000-4000-8000-000000000001','2026-06-14 08:00:00','2026-06-14 11:00:00','active',0,null),
('4d400000-0000-4000-8000-000000000002','$owner_a','4d200000-0000-4000-8000-000000000001','2026-06-14 08:00:00','2026-06-14 10:00:00','archived',0,'2026-06-14 10:30:00'),
('4d400000-0000-4000-8000-000000000001','$owner_b','4d200000-0000-4000-8000-000000000001','2026-06-14 08:00:00','2026-06-14 13:00:00','active',0,null);" >/dev/null

session_fingerprint_before="$(db_psql -Atc "select md5(string_agg(row_to_json(s)::text,'' order by s.id)) from public.chat_sessions s where specialist_id::text like '4d200000-0000-4000-8000-%';")"
catalog_fingerprint_before="$(db_psql -Atc "select md5(string_agg(row_to_json(c)::text,'' order by c.id)) from public.specialist_catalog c where display_name like 'test_only_2b_iv_d%';")"
specialist_fingerprint_before="$(db_psql -Atc "select md5(string_agg(row_to_json(s)::text,'' order by s.id)) from public.specialists s where name like 'test_only_2b_iv_d%';")"
messages_before="$(db_psql -Atc 'select count(*) from public.messages;')"
endpoint="$FUNCTIONS_URL/list-own-chat-sessions"

call() {
  local name=$1 token=$2 url=$3
  curl -sS -o "$tmp_dir/$name.json" -w '%{http_code}' \
    -H "Authorization: Bearer $token" -H "Accept: application/json" "$url"
}

echo "2B-IV-D stage: request/JWT and ownership"
no_jwt_status="$(curl -sS -o "$tmp_dir/no-jwt.json" -w '%{http_code}' "$endpoint")"
invalid_jwt_status="$(call invalid-jwt invalid "$endpoint")"
authority_status="$(call authority "$token_a" "$endpoint?user_id=$owner_b")"
internal_status="$(call internal "$token_a" "$endpoint?specialist_id=4d200000-0000-4000-8000-000000000001")"
invalid_status="$(call invalid-status "$token_a" "$endpoint?status=bad")"
invalid_limit="$(call invalid-limit "$token_a" "$endpoint?limit=51")"
invalid_cursor="$(call invalid-cursor "$token_a" "$endpoint?cursor=broken")"
test "$no_jwt_status" = "401"
test "$invalid_jwt_status" = "401"
test "$authority_status" = "400"
test "$internal_status" = "400"
test "$invalid_status" = "400"
test "$invalid_limit" = "400"
test "$invalid_cursor" = "400"

echo "2B-IV-D stage: filters, stable cursor and ownership"
first_status="$(call first "$token_a" "$endpoint?limit=2")"
test "$first_status" = "200"
test "$(jq -r '.items | length' "$tmp_dir/first.json")" = "2"
test "$(jq -r '[.items[].sessionId] == ["4d400000-0000-4000-8000-000000000005","4d400000-0000-4000-8000-000000000004"]' "$tmp_dir/first.json")" = "true"
cursor="$(jq -r '.nextCursor' "$tmp_dir/first.json")"
test -n "$cursor"; test "$cursor" != "null"
second_status="$(curl -sS -o "$tmp_dir/second.json" -w '%{http_code}' \
  -G -H "Authorization: Bearer $token_a" -H "Accept: application/json" \
  --data-urlencode "limit=2" --data-urlencode "cursor=$cursor" "$endpoint")"
test "$second_status" = "200"
test "$(jq -r '[.items[].sessionId] == ["4d400000-0000-4000-8000-000000000003"]' "$tmp_dir/second.json")" = "true"
test "$(jq -r '.nextCursor == null' "$tmp_dir/second.json")" = "true"
jq -r '.items[].sessionId' "$tmp_dir/first.json" "$tmp_dir/second.json" | sort > "$tmp_dir/page-ids.txt"
test "$(wc -l < "$tmp_dir/page-ids.txt" | tr -d ' ')" = "3"
test "$(sort -u "$tmp_dir/page-ids.txt" | wc -l | tr -d ' ')" = "3"

archived_status="$(call archived "$token_a" "$endpoint?status=archived")"
all_status="$(call all "$token_a" "$endpoint?status=all")"
owner_b_status="$(call owner-b "$token_b" "$endpoint")"
test "$archived_status" = "200"
test "$all_status" = "200"
test "$owner_b_status" = "200"
test "$(jq -r '[.items[].sessionId] == ["4d400000-0000-4000-8000-000000000002"]' "$tmp_dir/archived.json")" = "true"
test "$(jq -r '.items | length' "$tmp_dir/all.json")" = "4"
test "$(jq -r '[.items[].sessionId] == ["4d400000-0000-4000-8000-000000000001"]' "$tmp_dir/owner-b.json")" = "true"

echo "2B-IV-D stage: public projection excludes internal fields"
for response in "$tmp_dir/first.json" "$tmp_dir/second.json" "$tmp_dir/archived.json" "$tmp_dir/all.json" "$tmp_dir/owner-b.json"; do
  test "$(jq -r 'keys == ["items","nextCursor"]' "$response")" = "true"
  test "$(jq -r '[.items[] | keys == ["lastMessageAt","messageCount","selectableSpecialist","sessionId","startedAt","status"]] | all' "$response")" = "true"
  if rg -n '"(user_id|userId|specialist_id|specialistId|prompt_template|access_tier|availability_status|is_published|roles|permissions)"' "$response"; then
    echo "Forbidden internal field found in response" >&2
    exit 1
  fi
  if rg -F '4d200000-0000-4000-8000-000000000001' "$response"; then
    echo "Internal specialist ID found in response" >&2
    exit 1
  fi
done

echo "2B-IV-D stage: broken catalog must abort complete response"
db_psql -c "insert into public.chat_sessions(id,user_id,specialist_id,started_at,last_message_at,status,message_count)
values ('4d400000-0000-4000-8000-000000000006','$owner_a','4d200000-0000-4000-8000-000000000002','2026-06-14 08:00:00','2026-06-14 14:00:00','active',0);" >/dev/null
broken_status="$(call broken "$token_a" "$endpoint?limit=20")"
test "$broken_status" = "503"
test "$(jq -r '.error.code' "$tmp_dir/broken.json")" = "backendMisconfigured"
test "$(jq -r 'has("items")' "$tmp_dir/broken.json")" = "false"
if rg -n 'placeholder|test_only_2b_iv_d|specialist_id|user_id' "$tmp_dir/broken.json"; then
  echo "Broken catalog response leaked partial/internal data" >&2
  exit 1
fi
db_psql -c "delete from public.chat_sessions where id='4d400000-0000-4000-8000-000000000006';" >/dev/null

echo "2B-IV-D stage: read-only integrity and safe logs"
test "$(db_psql -Atc "select md5(string_agg(row_to_json(s)::text,'' order by s.id)) from public.chat_sessions s where specialist_id::text like '4d200000-0000-4000-8000-%';")" = "$session_fingerprint_before"
test "$(db_psql -Atc "select md5(string_agg(row_to_json(c)::text,'' order by c.id)) from public.specialist_catalog c where display_name like 'test_only_2b_iv_d%';")" = "$catalog_fingerprint_before"
test "$(db_psql -Atc "select md5(string_agg(row_to_json(s)::text,'' order by s.id)) from public.specialists s where name like 'test_only_2b_iv_d%';")" = "$specialist_fingerprint_before"
test "$(db_psql -Atc 'select count(*) from public.messages;')" = "$messages_before"
sleep 1
for forbidden in "$token_a" "$token_b" "$owner_a" "$owner_b" \
  "4d200000-0000-4000-8000-000000000001" "specialist_id" "user_id" \
  "prompt_template" "service_role"; do
  if rg -F -- "$forbidden" "$STASISLY_EDGE_LOG_FILE" >/dev/null; then
    echo "Forbidden value found in Edge Function logs: $forbidden" >&2
    exit 1
  fi
done

echo "2B-IV-D stage: cleanup and zero-fixture postconditions"
cleanup
trap - EXIT INT TERM
test "$(db_psql -Atc "select count(*) from auth.users where email like 'test_only_2b_iv_d_%@stasisly.local';")" = "0"
test "$(db_psql -Atc "select count(*) from public.users where display_name like 'test_only_2b_iv_d%';")" = "0"
test "$(db_psql -Atc "select count(*) from public.specialists where name like 'test_only_2b_iv_d%';")" = "0"
test "$(db_psql -Atc "select count(*) from public.specialist_catalog where display_name like 'test_only_2b_iv_d%';")" = "0"
test "$(db_psql -Atc "select count(*) from public.chat_sessions where specialist_id::text like '4d200000-0000-4000-8000-%';")" = "0"
test "$(db_psql -Atc 'select count(*) from public.messages;')" = "$messages_before"

echo "2B-IV-D listOwnChatSessions local HTTP harness: PASS"

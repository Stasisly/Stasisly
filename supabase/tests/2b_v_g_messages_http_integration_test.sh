#!/usr/bin/env bash

set -euo pipefail

for command in curl docker flutter jq rg supabase; do
  command -v "$command" >/dev/null || {
    echo "$command is required" >&2
    exit 1
  }
done

echo "2B-V-G stage: anti-remote preflight"
if rg -n 'supabase\.co([/:]|$)|project_ref|SUPABASE_ACCESS_TOKEN' \
  supabase/config.toml supabase/.branches supabase/.temp 2>/dev/null; then
  echo "Remote-looking Supabase configuration detected; refusing to run" >&2
  exit 1
fi

eval "$(supabase status -o env 2>/dev/null | sed -n '/^[A-Z_]*=/p')"
case "${API_URL:-}" in
  http://127.0.0.1:54321|http://localhost:54321) ;;
  *) echo "Supabase API endpoint is not an approved local endpoint" >&2; exit 1 ;;
esac
if [ -z "${FUNCTIONS_URL:-}" ]; then
  FUNCTIONS_URL="${API_URL%/}/functions/v1"
fi
case "$FUNCTIONS_URL" in
  http://127.0.0.1:54321/functions/v1|http://localhost:54321/functions/v1) ;;
  *) echo "Supabase endpoints are not approved local endpoints" >&2; exit 1 ;;
esac

tmp_dir="$(mktemp -d /tmp/stasisly-2b-v-g.XXXXXX)"
edge_env="$tmp_dir/functions.env"
edge_log="$tmp_dir/edge.log"
email_owner="test_only_2b_v_g_owner_$(date +%s)@stasisly.local"
email_other="test_only_2b_v_g_other_$(date +%s)@stasisly.local"
password="LocalTestOnly-9!"
owner_active_session_id="5e400000-0000-4000-8000-000000000001"
owner_archived_session_id="5e400000-0000-4000-8000-000000000002"
other_session_id="5e400000-0000-4000-8000-000000000003"
missing_session_id="5e400000-0000-4000-8000-000000000099"
serve_pid=""

db_psql() {
  docker exec -i supabase_db_Stasisly psql -U postgres -d postgres \
    -v ON_ERROR_STOP=1 "$@"
}

postconditions() {
  db_psql -Atc "
    select concat_ws('|',
      (select count(*) from auth.users where email like 'test_only_2b_v_g_%@stasisly.local'),
      (select count(*) from public.users where display_name like 'test_only_2b_v_g%'),
      (select count(*) from public.specialists where name like 'test_only_2b_v_g%'),
      (select count(*) from public.specialist_catalog where display_name like 'test_only_2b_v_g%'),
      (select count(*) from public.chat_sessions where specialist_id::text like '5e200000-0000-4000-8000-%'),
      (select count(*) from public.messages m join public.chat_sessions s on s.id = m.session_id where s.specialist_id::text like '5e200000-0000-4000-8000-%'),
      (select count(*) from public.conversation_idempotency where subject_id in (select id from auth.users where email like 'test_only_2b_v_g_%@stasisly.local'))
    );"
}

cleanup() {
  local exit_code=$?
  if [ -n "$serve_pid" ] && kill -0 "$serve_pid" >/dev/null 2>&1; then
    kill "$serve_pid" >/dev/null 2>&1 || true
    wait "$serve_pid" >/dev/null 2>&1 || true
  fi
  db_psql < supabase/tests/2b_v_g_messages_http_integration_cleanup.psql \
    >/dev/null 2>&1 || true
  local counts
  counts="$(postconditions 2>/dev/null || true)"
  if [ "$counts" != "0|0|0|0|0|0|0" ]; then
    echo "2B-V-G cleanup did not leave zero fixtures: ${counts:-unavailable}" >&2
    supabase db reset --local --no-seed >/dev/null 2>&1 || true
  fi
  rm -rf "$tmp_dir"
  return "$exit_code"
}
trap cleanup EXIT INT TERM

echo "2B-V-G stage: verify clean preconditions"
test "$(postconditions)" = "0|0|0|0|0|0|0"

cat > "$edge_env" <<EOF
SUPABASE_URL=$API_URL
SUPABASE_ANON_KEY=$ANON_KEY
SUPABASE_SERVICE_ROLE_KEY=$SERVICE_ROLE_KEY
STASISLY_ALLOW_LOCAL_ONLY=true
STASISLY_RUNTIME_MODE=local
STASISLY_ALLOW_DEVELOPMENT_REMOTE=false
EOF
chmod 600 "$edge_env"

echo "2B-V-G stage: setup fixtures and local identities"
db_psql < supabase/tests/2b_v_g_messages_http_integration_setup.psql >/dev/null
signup_owner="$(curl --silent --show-error --fail-with-body \
  -H "apikey: $ANON_KEY" -H "Content-Type: application/json" \
  -d "{\"email\":\"$email_owner\",\"password\":\"$password\"}" \
  "$API_URL/auth/v1/signup")"
signup_other="$(curl --silent --show-error --fail-with-body \
  -H "apikey: $ANON_KEY" -H "Content-Type: application/json" \
  -d "{\"email\":\"$email_other\",\"password\":\"$password\"}" \
  "$API_URL/auth/v1/signup")"
token_owner="$(printf '%s' "$signup_owner" | jq -r '.access_token')"
token_other="$(printf '%s' "$signup_other" | jq -r '.access_token')"
owner_id="$(printf '%s' "$signup_owner" | jq -r '.user.id')"
other_id="$(printf '%s' "$signup_other" | jq -r '.user.id')"
for value in "$token_owner" "$token_other" "$owner_id" "$other_id"; do
  test -n "$value"; test "$value" != "null"
done

db_psql -c "insert into public.users(id, display_name) values
('$owner_id','test_only_2b_v_g owner'),
('$other_id','test_only_2b_v_g other');
insert into public.chat_sessions(id,user_id,specialist_id,started_at,last_message_at,status,message_count,archived_at) values
('$owner_active_session_id','$owner_id','5e200000-0000-4000-8000-000000000001',now() - interval '20 minutes',now() - interval '17 minutes','active',4,null),
('$owner_archived_session_id','$owner_id','5e200000-0000-4000-8000-000000000001',now() - interval '40 minutes',now() - interval '29 minutes','archived',2,now() - interval '28 minutes'),
('$other_session_id','$other_id','5e200000-0000-4000-8000-000000000001',now() - interval '60 minutes',now() - interval '30 minutes','active',1,null);
insert into public.messages(id,session_id,role,content,created_at,author_type,provenance_type,visibility_type) values
('5e500000-0000-4000-8000-000000000001','$owner_active_session_id','user','active user one',now() - interval '19 minutes','user','userProvided','productVisible'),
('5e500000-0000-4000-8000-000000000002','$owner_active_session_id','assistant','active assistant',now() - interval '19 minutes','unknown','unknown','unknown'),
('5e500000-0000-4000-8000-000000000003','$owner_active_session_id','system','active system',now() - interval '18 minutes','systemNotice','systemGenerated','systemVisible'),
('5e500000-0000-4000-8000-000000000004','$owner_active_session_id','tool','active tool',now() - interval '17 minutes','unknown','unknown','internal'),
('5e500000-0000-4000-8000-000000000005','$owner_archived_session_id','user','archived historical one',now() - interval '30 minutes','user','userProvided','productVisible'),
('5e500000-0000-4000-8000-000000000006','$owner_archived_session_id','assistant','archived historical assistant',now() - interval '29 minutes','unknown','unknown','unknown'),
('5e500000-0000-4000-8000-000000000007','$other_session_id','user','other private',now() - interval '30 minutes','user','userProvided','productVisible');" >/dev/null

initial_count="$(db_psql -Atc "select message_count from public.chat_sessions where id='$owner_active_session_id';")"
initial_last_message_at="$(db_psql -Atc "select last_message_at from public.chat_sessions where id='$owner_active_session_id';")"
sessions_before="$(db_psql -Atc "select md5(string_agg(row_to_json(s)::text,'' order by s.id)) from public.chat_sessions s where specialist_id='5e200000-0000-4000-8000-000000000001' and id <> '$owner_active_session_id';")"
archived_before="$(db_psql -Atc "select message_count || '|' || last_message_at from public.chat_sessions where id='$owner_archived_session_id';")"
other_before="$(db_psql -Atc "select message_count || '|' || last_message_at from public.chat_sessions where id='$other_session_id';")"
messages_before="$(db_psql -Atc "select count(*) from public.messages where session_id='$owner_active_session_id';")"
archived_messages_before="$(db_psql -Atc "select md5(string_agg(row_to_json(m)::text,'' order by m.id)) from public.messages m where session_id='$owner_archived_session_id';")"
other_messages_before="$(db_psql -Atc "select md5(string_agg(row_to_json(m)::text,'' order by m.id)) from public.messages m where session_id='$other_session_id';")"
catalog_before="$(db_psql -Atc "select md5(string_agg(row_to_json(c)::text,'' order by c.id)) from public.specialist_catalog c where display_name like 'test_only_2b_v_g%';")"
specialist_before="$(db_psql -Atc "select md5(string_agg(row_to_json(s)::text,'' order by s.id)) from public.specialists s where name like 'test_only_2b_v_g%';")"

echo "2B-V-G stage: serve local Edge Functions"
: > "$edge_log"
rg -n '/rest/v1/rpc/send_user_message_core' \
  supabase/functions/send-user-message/index.ts
if rg -n '/rest/v1/(messages|chat_sessions)' \
  supabase/functions/send-user-message/index.ts; then
  echo "Direct table write/read path found in send-user-message source" >&2
  exit 1
fi
rg -n '/rest/v1/rpc/list_own_conversation_messages_core' \
  supabase/functions/list-session-messages/index.ts
if rg -n '/rest/v1/(messages|chat_sessions)' \
  supabase/functions/list-session-messages/index.ts; then
  echo "Direct table path found in list-session-messages source" >&2
  exit 1
fi
if rg -n '\\b(POST|PATCH|PUT|DELETE)\\b' \
  supabase/functions/list-session-messages/index.ts; then
  echo "Mutating HTTP method found in list-session-messages runtime" >&2
  exit 1
fi
supabase functions serve --no-verify-jwt --env-file "$edge_env" \
  >"$edge_log" 2>&1 &
serve_pid=$!
sleep 5
kill -0 "$serve_pid"

echo "2B-V-G stage: wait for local function readiness"
for _ in $(seq 1 20); do
  status="$(curl -sS -o /dev/null -w '%{http_code}' \
    -X GET -H "Accept: application/json" \
    "$FUNCTIONS_URL/list-session-messages?sessionId=$owner_active_session_id" || true)"
  if [ "$status" = "401" ]; then
    break
  fi
  sleep 1
done
test "$status" = "401"

echo "2B-V-G stage: run Flutter datasource integration"
flutter test test/integration/two_b_v_g_local_http_chat_messages_integration_test.dart \
  --dart-define="STASISLY_2B_V_G_API_URL=$API_URL" \
  --dart-define="STASISLY_2B_V_G_ACCESS_TOKEN=$token_owner" \
  --dart-define="STASISLY_2B_V_G_OWNER_ACTIVE_SESSION_ID=$owner_active_session_id" \
  --dart-define="STASISLY_2B_V_G_OWNER_ARCHIVED_SESSION_ID=$owner_archived_session_id" \
  --dart-define="STASISLY_2B_V_G_OTHER_SESSION_ID=$other_session_id" \
  --dart-define="STASISLY_2B_V_G_MISSING_SESSION_ID=$missing_session_id" \
  --dart-define="STASISLY_2B_V_G_INITIAL_MESSAGE_COUNT=$initial_count" \
  --dart-define="STASISLY_2B_V_G_INITIAL_LAST_MESSAGE_AT=$initial_last_message_at"

echo "2B-V-G stage: verify data integrity"
test "$(db_psql -Atc "select count(*) from public.messages where session_id='$owner_active_session_id';")" = "$((messages_before + 1))"
test "$(db_psql -Atc "select message_count from public.chat_sessions where id='$owner_active_session_id';")" = "$((initial_count + 1))"
test "$(db_psql -Atc "select exists(select 1 from public.chat_sessions cs join public.messages m on m.session_id=cs.id where cs.id='$owner_active_session_id' and cs.last_message_at=(select max(created_at) from public.messages where session_id=cs.id));")" = "t"
test "$(db_psql -Atc "select md5(string_agg(row_to_json(s)::text,'' order by s.id)) from public.chat_sessions s where specialist_id='5e200000-0000-4000-8000-000000000001' and id <> '$owner_active_session_id';")" = "$sessions_before"
test "$(db_psql -Atc "select message_count || '|' || last_message_at from public.chat_sessions where id='$owner_archived_session_id';")" = "$archived_before"
test "$(db_psql -Atc "select message_count || '|' || last_message_at from public.chat_sessions where id='$other_session_id';")" = "$other_before"
test "$(db_psql -Atc "select md5(string_agg(row_to_json(m)::text,'' order by m.id)) from public.messages m where session_id='$owner_archived_session_id';")" = "$archived_messages_before"
test "$(db_psql -Atc "select md5(string_agg(row_to_json(m)::text,'' order by m.id)) from public.messages m where session_id='$other_session_id';")" = "$other_messages_before"
test "$(db_psql -Atc "select md5(string_agg(row_to_json(c)::text,'' order by c.id)) from public.specialist_catalog c where display_name like 'test_only_2b_v_g%';")" = "$catalog_before"
test "$(db_psql -Atc "select md5(string_agg(row_to_json(s)::text,'' order by s.id)) from public.specialists s where name like 'test_only_2b_v_g%';")" = "$specialist_before"

echo "2B-V-G stage: safe logs"
sleep 1
for forbidden in "$token_owner" "$token_other" "$owner_id" "$other_id" \
  "$owner_active_session_id" "$owner_archived_session_id" "$other_session_id" \
  "5e200000-0000-4000-8000-000000000001" "user_id" "specialist_id" \
  "prompt_template" "service_role" "mensaje de prueba" "active user one" \
  "archived historical one" "other private"; do
  if rg -F -- "$forbidden" "$edge_log" >/dev/null; then
    echo "Forbidden value found in local Edge Function logs: $forbidden" >&2
    exit 1
  fi
done

echo "2B-V-G stage: cleanup and zero-fixture postconditions"
cleanup
trap - EXIT INT TERM
counts="$(postconditions)"
echo "$counts"
test "$counts" = "0|0|0|0|0|0|0"

echo "2B-V-G messages local HTTP integration harness: PASS"

#!/usr/bin/env bash

set -euo pipefail

for command in curl docker jq rg supabase; do
  command -v "$command" >/dev/null || {
    echo "$command is required" >&2
    exit 1
  }
done

echo "2B-V-C2 stage: anti-remote preflight"
if rg -n 'supabase\.co([/:]|$)|project_ref|SUPABASE_ACCESS_TOKEN' \
  supabase/config.toml supabase/.branches supabase/.temp 2>/dev/null; then
  echo "Remote-looking Supabase configuration detected; refusing to run" >&2
  exit 1
fi

eval "$(supabase status -o env 2>/dev/null | sed -n '/^[A-Z_]*=/p')"
case "${API_URL:-}|${FUNCTIONS_URL:-}" in
  http://127.0.0.1:54321\|http://127.0.0.1:54321/functions/v1|\
  http://localhost:54321\|http://localhost:54321/functions/v1) ;;
  *) echo "Supabase endpoints are not approved local endpoints" >&2; exit 1 ;;
esac

tmp_dir="$(mktemp -d /tmp/stasisly-2b-v-c2.XXXXXX)"
edge_env="$tmp_dir/functions.env"
edge_log="$tmp_dir/edge.log"
email_owner="test_only_2b_v_c2_owner_$(date +%s)@stasisly.local"
email_other="test_only_2b_v_c2_other_$(date +%s)@stasisly.local"
password="LocalTestOnly-9!"
serve_pid=""

db_psql() {
  docker exec -i supabase_db_Stasisly psql -U postgres -d postgres \
    -v ON_ERROR_STOP=1 "$@"
}

postconditions() {
  db_psql -Atc "
    select concat_ws('|',
      (select count(*) from auth.users where email like 'test_only_2b_v_c2_%@stasisly.local'),
      (select count(*) from public.users where display_name like 'test_only_2b_v_c2%'),
      (select count(*) from public.specialists where name like 'test_only_2b_v_c2%'),
      (select count(*) from public.specialist_catalog where display_name like 'test_only_2b_v_c2%'),
      (select count(*) from public.chat_sessions where specialist_id::text like '5c200000-0000-4000-8000-%'),
      (select count(*) from public.messages m join public.chat_sessions s on s.id = m.session_id where s.specialist_id::text like '5c200000-0000-4000-8000-%'),
      (select count(*) from public.conversation_idempotency where idempotency_key like 'v-c2-%')
    );"
}

cleanup() {
  local exit_code=$?
  if [ -n "$serve_pid" ] && kill -0 "$serve_pid" >/dev/null 2>&1; then
    kill "$serve_pid" >/dev/null 2>&1 || true
    wait "$serve_pid" >/dev/null 2>&1 || true
  fi
  db_psql < supabase/tests/2b_v_c2_send_user_message_cleanup.psql \
    >/dev/null 2>&1 || true
  local counts
  counts="$(postconditions 2>/dev/null || true)"
  if [ "$counts" != "0|0|0|0|0|0|0" ]; then
    echo "2B-V-C2 cleanup did not leave zero fixtures: ${counts:-unavailable}" >&2
    supabase db reset --local --no-seed >/dev/null 2>&1 || true
  fi
  rm -rf "$tmp_dir"
  return "$exit_code"
}
trap cleanup EXIT INT TERM

echo "2B-V-C2 stage: verify clean preconditions"
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

echo "2B-V-C2 stage: setup fixtures and local identities"
db_psql < supabase/tests/2b_v_c2_send_user_message_setup.psql >/dev/null
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
('$owner_id','test_only_2b_v_c2 owner'),
('$other_id','test_only_2b_v_c2 other');
insert into public.chat_sessions(id,user_id,specialist_id,started_at,last_message_at,status,message_count) values
('5c400000-0000-4000-8000-000000000001','$owner_id','5c200000-0000-4000-8000-000000000001','2026-06-20 08:00:00','2026-06-20 08:00:00','active',0),
('5c400000-0000-4000-8000-000000000002','$owner_id','5c200000-0000-4000-8000-000000000001','2026-06-20 08:30:00','2026-06-20 08:45:00','archived',0),
('5c400000-0000-4000-8000-000000000003','$other_id','5c200000-0000-4000-8000-000000000001','2026-06-20 09:00:00','2026-06-20 09:00:00','active',0);" >/dev/null

catalog_before="$(db_psql -Atc "select md5(string_agg(row_to_json(c)::text,'' order by c.id)) from public.specialist_catalog c where display_name like 'test_only_2b_v_c2%';")"
specialist_before="$(db_psql -Atc "select md5(string_agg(row_to_json(s)::text,'' order by s.id)) from public.specialists s where name like 'test_only_2b_v_c2%';")"

echo "2B-V-C2 stage: serve local Edge Function"
: > "$edge_log"
rg -n '/rest/v1/rpc/send_user_message_core' \
  supabase/functions/send-user-message/index.ts
if rg -n '/rest/v1/(messages|chat_sessions)' \
  supabase/functions/send-user-message/index.ts; then
  echo "Direct table write/read path found in send-user-message source" >&2
  exit 1
fi
supabase functions serve send-user-message --no-verify-jwt --env-file "$edge_env" \
  >"$edge_log" 2>&1 &
serve_pid=$!
sleep 5
kill -0 "$serve_pid"

endpoint="$FUNCTIONS_URL/send-user-message"
valid_body='{"sessionId":"5c400000-0000-4000-8000-000000000001","content":"  Hello C2  "}'
call() {
  local name=$1 token=$2 body=$3
  local key=${4:-v-c2-$name-000000000001}
  curl -sS -o "$tmp_dir/$name.json" -w '%{http_code}' \
    -X POST -H "Authorization: Bearer $token" \
    -H "Content-Type: application/json" -H "Accept: application/json" \
    -H "Idempotency-Key: $key" \
    -d "$body" "$endpoint"
}

echo "2B-V-C2 stage: request/JWT/body validation"
no_jwt_status="$(curl -sS -o "$tmp_dir/no-jwt.json" -w '%{http_code}' \
  -X POST -H "Content-Type: application/json" \
  -H "Idempotency-Key: v-c2-no-jwt-000000000001" \
  -d "$valid_body" "$endpoint")"
invalid_jwt_status="$(call invalid-jwt invalid "$valid_body")"
empty_status="$(call empty "$token_owner" '{}')"
role_status="$(call role "$token_owner" '{"sessionId":"5c400000-0000-4000-8000-000000000001","content":"x","role":"assistant"}')"
user_status="$(call user "$token_owner" '{"sessionId":"5c400000-0000-4000-8000-000000000001","content":"x","userId":"attacker"}')"
specialist_status="$(call specialist "$token_owner" '{"sessionId":"5c400000-0000-4000-8000-000000000001","content":"x","specialistId":"x"}')"
created_status="$(call created "$token_owner" '{"sessionId":"5c400000-0000-4000-8000-000000000001","content":"x","created_at":"2026"}')"
count_status="$(call count "$token_owner" '{"sessionId":"5c400000-0000-4000-8000-000000000001","content":"x","message_count":99}')"
last_status="$(call last "$token_owner" '{"sessionId":"5c400000-0000-4000-8000-000000000001","content":"x","last_message_at":"2026"}')"
attachments_status="$(call attachments "$token_owner" '{"sessionId":"5c400000-0000-4000-8000-000000000001","content":"x","attachments":[] }')"
metadata_status="$(call metadata "$token_owner" '{"sessionId":"5c400000-0000-4000-8000-000000000001","content":"x","metadata":{} }')"
null_status="$(call null-content "$token_owner" '{"sessionId":"5c400000-0000-4000-8000-000000000001","content":null}')"
empty_content_status="$(call empty-content "$token_owner" '{"sessionId":"5c400000-0000-4000-8000-000000000001","content":""}')"
space_content_status="$(call space-content "$token_owner" '{"sessionId":"5c400000-0000-4000-8000-000000000001","content":"    "}')"
long_status="$(call long "$token_owner" "$(jq -nc --arg c "$(printf 'x%.0s' {1..4001})" --arg s "5c400000-0000-4000-8000-000000000001" '{sessionId:$s,content:$c}')")"
ok_4000_status="$(call ok-4000 "$token_owner" "$(jq -nc --arg c " $(printf 'x%.0s' {1..4000}) " --arg s "5c400000-0000-4000-8000-000000000001" '{sessionId:$s,content:$c}')")"
echo "2B-V-C2 validation statuses: no-jwt=$no_jwt_status invalid-jwt=$invalid_jwt_status empty=$empty_status role=$role_status user=$user_status specialist=$specialist_status created=$created_status count=$count_status last=$last_status attachments=$attachments_status metadata=$metadata_status null=$null_status empty-content=$empty_content_status space=$space_content_status long=$long_status ok-4000=$ok_4000_status"
test "$no_jwt_status" = "401"
test "$invalid_jwt_status" = "401"
for status in "$empty_status" "$role_status" "$user_status" "$specialist_status" "$created_status" "$count_status" "$last_status" "$attachments_status" "$metadata_status"; do
  test "$status" = "400"
done
test "$null_status" = "400"
test "$empty_content_status" = "400"
test "$space_content_status" = "400"
test "$long_status" = "400"
test "$ok_4000_status" = "201"

echo "2B-V-C2 stage: valid sends and atomic session updates"
first_status="$(call first "$token_owner" "$valid_body")"
replay_status="$(call replay "$token_owner" "$valid_body" 'v-c2-first-000000000001')"
conflict_status="$(call conflict "$token_owner" '{"sessionId":"5c400000-0000-4000-8000-000000000001","content":"conflict"}' 'v-c2-first-000000000001')"
second_status="$(call second "$token_owner" '{"sessionId":"5c400000-0000-4000-8000-000000000001","content":"Second C2"}')"
test "$first_status" = "201"
test "$replay_status" = "200"
test "$conflict_status" = "409"
test "$second_status" = "201"
test "$(jq -r '.message.messageId' "$tmp_dir/replay.json")" = "$(jq -r '.message.messageId' "$tmp_dir/first.json")"
test "$(jq -r '.error.code' "$tmp_dir/conflict.json")" = "idempotencyConflict"
test "$(db_psql -Atc "select count(*) from public.messages where session_id='5c400000-0000-4000-8000-000000000001';")" = "3"
test "$(db_psql -Atc "select message_count from public.chat_sessions where id='5c400000-0000-4000-8000-000000000001';")" = "3"
test "$(db_psql -Atc "select exists(select 1 from public.chat_sessions cs join public.messages m on m.session_id=cs.id where cs.id='5c400000-0000-4000-8000-000000000001' and cs.last_message_at=(select max(created_at) from public.messages where session_id=cs.id));")" = "t"

echo "2B-V-C2 stage: parallel idempotent send"
parallel_body='{"sessionId":"5c400000-0000-4000-8000-000000000001","content":"Parallel C2"}'
call parallel-a "$token_owner" "$parallel_body" 'v-c2-parallel-send-00000001' >"$tmp_dir/parallel-a.status" &
parallel_a_pid=$!
call parallel-b "$token_owner" "$parallel_body" 'v-c2-parallel-send-00000001' >"$tmp_dir/parallel-b.status" &
parallel_b_pid=$!
wait "$parallel_a_pid" "$parallel_b_pid"
test "$(sort "$tmp_dir/parallel-a.status" "$tmp_dir/parallel-b.status" | tr '\n' ' ')" = "200 201 "
test "$(jq -r '.message.messageId' "$tmp_dir/parallel-a.json")" = "$(jq -r '.message.messageId' "$tmp_dir/parallel-b.json")"
test "$(db_psql -Atc "select count(*) from public.messages where session_id='5c400000-0000-4000-8000-000000000001';")" = "4"
test "$(db_psql -Atc "select message_count from public.chat_sessions where id='5c400000-0000-4000-8000-000000000001';")" = "4"

echo "2B-V-C2 stage: session errors do not leak foreign existence"
foreign_status="$(call foreign "$token_owner" '{"sessionId":"5c400000-0000-4000-8000-000000000003","content":"foreign"}')"
missing_status="$(call missing "$token_owner" '{"sessionId":"5c400000-0000-4000-8000-000000000099","content":"missing"}')"
archived_status="$(call archived "$token_owner" '{"sessionId":"5c400000-0000-4000-8000-000000000002","content":"archived"}')"
test "$foreign_status" = "404"
test "$missing_status" = "404"
test "$archived_status" = "409"
test "$(jq -r '.error.code' "$tmp_dir/foreign.json")" = "sessionNotFound"
test "$(jq -r '.error.code' "$tmp_dir/missing.json")" = "sessionNotFound"
test "$(jq -r '.error.code' "$tmp_dir/archived.json")" = "sessionArchived"
if diff -u <(jq -S 'del(.error.requestId)' "$tmp_dir/foreign.json") <(jq -S 'del(.error.requestId)' "$tmp_dir/missing.json"); then
  :
else
  echo "Foreign and missing session responses are distinguishable" >&2
  exit 1
fi
test "$(db_psql -Atc "select count(*) from public.messages where session_id in ('5c400000-0000-4000-8000-000000000002','5c400000-0000-4000-8000-000000000003');")" = "0"

echo "2B-V-C2 stage: public response is sanitized"
for response in "$tmp_dir/first.json" "$tmp_dir/second.json" "$tmp_dir/ok-4000.json" "$tmp_dir/parallel-a.json" "$tmp_dir/parallel-b.json"; do
  test "$(jq -r 'keys == ["message","session"]' "$response")" = "true"
  test "$(jq -r '.message.role' "$response")" = "user"
  test "$(jq -r '.message | keys == ["content","createdAt","messageId","role","sessionId"]' "$response")" = "true"
  test "$(jq -r '.session | keys == ["lastMessageAt","messageCount","sessionId"]' "$response")" = "true"
  for forbidden in "user_id" "userId" "specialist_id" "specialistId" \
    "prompt_template" "service_role" "attachments" "metadata" "JWT"; do
    if rg -F -- "$forbidden" "$response" >/dev/null; then
      echo "Forbidden public response field found: $forbidden" >&2
      exit 1
    fi
  done
done

echo "2B-V-C2 stage: integrity, RPC-only evidence and safe logs"
test "$(db_psql -Atc "select md5(string_agg(row_to_json(c)::text,'' order by c.id)) from public.specialist_catalog c where display_name like 'test_only_2b_v_c2%';")" = "$catalog_before"
test "$(db_psql -Atc "select md5(string_agg(row_to_json(s)::text,'' order by s.id)) from public.specialists s where name like 'test_only_2b_v_c2%';")" = "$specialist_before"
test "$(db_psql -Atc "select count(*) from public.messages where role <> 'user' and session_id in (select id from public.chat_sessions where specialist_id='5c200000-0000-4000-8000-000000000001');")" = "0"
sleep 1
for forbidden in "$token_owner" "$token_other" "$owner_id" "$other_id" \
  "5c200000-0000-4000-8000-000000000001" "user_id" "specialist_id" \
  "prompt_template" "service_role" "Hello C2" "Second C2"; do
  if rg -F -- "$forbidden" "$edge_log" >/dev/null; then
    echo "Forbidden value found in local Edge Function logs: $forbidden" >&2
    exit 1
  fi
done

echo "2B-V-C2 stage: cleanup and zero-fixture postconditions"
cleanup
trap - EXIT INT TERM
counts="$(postconditions)"
echo "$counts"
test "$counts" = "0|0|0|0|0|0|0"

echo "2B-V-C2 send-user-message local HTTP harness: PASS"

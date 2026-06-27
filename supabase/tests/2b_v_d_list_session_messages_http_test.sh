#!/usr/bin/env bash

set -euo pipefail

for command in curl docker jq rg supabase; do
  command -v "$command" >/dev/null || {
    echo "$command is required" >&2
    exit 1
  }
done

echo "2B-V-D stage: anti-remote preflight"
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

tmp_dir="$(mktemp -d /tmp/stasisly-2b-v-d.XXXXXX)"
edge_env="$tmp_dir/functions.env"
edge_log="$tmp_dir/edge.log"
email_owner="test_only_2b_v_d_owner_$(date +%s)@stasisly.local"
email_other="test_only_2b_v_d_other_$(date +%s)@stasisly.local"
password="LocalTestOnly-9!"
serve_pid=""

db_psql() {
  docker exec -i supabase_db_Stasisly psql -U postgres -d postgres \
    -v ON_ERROR_STOP=1 "$@"
}

postconditions() {
  db_psql -Atc "
    select concat_ws('|',
      (select count(*) from auth.users where email like 'test_only_2b_v_d_%@stasisly.local'),
      (select count(*) from public.users where display_name like 'test_only_2b_v_d%'),
      (select count(*) from public.specialists where name like 'test_only_2b_v_d%'),
      (select count(*) from public.specialist_catalog where display_name like 'test_only_2b_v_d%'),
      (select count(*) from public.chat_sessions where specialist_id::text like '5d200000-0000-4000-8000-%'),
      (select count(*) from public.messages m join public.chat_sessions s on s.id = m.session_id where s.specialist_id::text like '5d200000-0000-4000-8000-%')
    );"
}

cleanup() {
  local exit_code=$?
  if [ -n "$serve_pid" ] && kill -0 "$serve_pid" >/dev/null 2>&1; then
    kill "$serve_pid" >/dev/null 2>&1 || true
    wait "$serve_pid" >/dev/null 2>&1 || true
  fi
  db_psql < supabase/tests/2b_v_d_list_session_messages_cleanup.psql \
    >/dev/null 2>&1 || true
  local counts
  counts="$(postconditions 2>/dev/null || true)"
  if [ "$counts" != "0|0|0|0|0|0" ]; then
    echo "2B-V-D cleanup did not leave zero fixtures: ${counts:-unavailable}" >&2
    supabase db reset --local --no-seed >/dev/null 2>&1 || true
  fi
  rm -rf "$tmp_dir"
  return "$exit_code"
}
trap cleanup EXIT INT TERM

echo "2B-V-D stage: verify clean preconditions"
test "$(postconditions)" = "0|0|0|0|0|0"

cat > "$edge_env" <<EOF
SUPABASE_URL=$API_URL
SUPABASE_ANON_KEY=$ANON_KEY
SUPABASE_SERVICE_ROLE_KEY=$SERVICE_ROLE_KEY
STASISLY_ALLOW_LOCAL_ONLY=true
EOF
chmod 600 "$edge_env"

echo "2B-V-D stage: setup fixtures and local identities"
db_psql < supabase/tests/2b_v_d_list_session_messages_setup.psql >/dev/null
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
('$owner_id','test_only_2b_v_d owner'),
('$other_id','test_only_2b_v_d other');
insert into public.chat_sessions(id,user_id,specialist_id,started_at,last_message_at,status,message_count) values
('5d400000-0000-4000-8000-000000000001','$owner_id','5d200000-0000-4000-8000-000000000001','2026-06-21 08:00:00','2026-06-21 10:00:00','active',4),
('5d400000-0000-4000-8000-000000000002','$owner_id','5d200000-0000-4000-8000-000000000001','2026-06-21 07:00:00','2026-06-21 09:00:00','archived',2),
('5d400000-0000-4000-8000-000000000003','$other_id','5d200000-0000-4000-8000-000000000001','2026-06-21 06:00:00','2026-06-21 08:30:00','active',1);
insert into public.messages(id,session_id,role,content,created_at) values
('5d500000-0000-4000-8000-000000000001','5d400000-0000-4000-8000-000000000001','user','active user one','2026-06-21 08:01:00'),
('5d500000-0000-4000-8000-000000000002','5d400000-0000-4000-8000-000000000001','assistant','active assistant','2026-06-21 08:01:00'),
('5d500000-0000-4000-8000-000000000003','5d400000-0000-4000-8000-000000000001','system','active system','2026-06-21 08:02:00'),
('5d500000-0000-4000-8000-000000000004','5d400000-0000-4000-8000-000000000001','tool','active tool','2026-06-21 08:03:00'),
('5d500000-0000-4000-8000-000000000005','5d400000-0000-4000-8000-000000000002','user','archived historical one','2026-06-21 07:10:00'),
('5d500000-0000-4000-8000-000000000006','5d400000-0000-4000-8000-000000000002','assistant','archived historical assistant','2026-06-21 07:11:00'),
('5d500000-0000-4000-8000-000000000007','5d400000-0000-4000-8000-000000000003','user','other private','2026-06-21 06:30:00');" >/dev/null

sessions_before="$(db_psql -Atc "select md5(string_agg(row_to_json(s)::text,'' order by s.id)) from public.chat_sessions s where specialist_id='5d200000-0000-4000-8000-000000000001';")"
messages_before="$(db_psql -Atc "select md5(string_agg(row_to_json(m)::text,'' order by m.id)) from public.messages m join public.chat_sessions s on s.id=m.session_id where s.specialist_id='5d200000-0000-4000-8000-000000000001';")"
catalog_before="$(db_psql -Atc "select md5(string_agg(row_to_json(c)::text,'' order by c.id)) from public.specialist_catalog c where display_name like 'test_only_2b_v_d%';")"
specialist_before="$(db_psql -Atc "select md5(string_agg(row_to_json(s)::text,'' order by s.id)) from public.specialists s where name like 'test_only_2b_v_d%';")"

echo "2B-V-D stage: serve local Edge Function"
: > "$edge_log"
rg -n '/rest/v1/messages' supabase/functions/list-session-messages/index.ts
rg -n '/rest/v1/chat_sessions' supabase/functions/list-session-messages/index.ts
if rg -n '\\b(POST|PATCH|PUT|DELETE)\\b' supabase/functions/list-session-messages/index.ts; then
  echo "Mutating HTTP method found in list-session-messages runtime" >&2
  exit 1
fi
supabase functions serve list-session-messages --no-verify-jwt --env-file "$edge_env" \
  >"$edge_log" 2>&1 &
serve_pid=$!
sleep 5
kill -0 "$serve_pid"

endpoint="$FUNCTIONS_URL/list-session-messages"
call() {
  local name=$1 token=$2 query=$3
  curl -sS -o "$tmp_dir/$name.json" -w '%{http_code}' \
    -X GET -H "Authorization: Bearer $token" -H "Accept: application/json" \
    "$endpoint$query"
}

echo "2B-V-D stage: request/JWT/query validation"
valid_query='?sessionId=5d400000-0000-4000-8000-000000000001'
no_jwt_status="$(curl -sS -o "$tmp_dir/no-jwt.json" -w '%{http_code}' \
  -X GET -H "Accept: application/json" "$endpoint$valid_query")"
invalid_jwt_status="$(call invalid-jwt invalid "$valid_query")"
empty_status="$(call empty "$token_owner" '')"
user_status="$(call user "$token_owner" "$valid_query&userId=attacker")"
specialist_status="$(call specialist "$token_owner" "$valid_query&specialistId=x")"
role_status="$(call role "$token_owner" "$valid_query&role=user")"
prompt_status="$(call prompt "$token_owner" "$valid_query&prompt_template=x")"
attachments_status="$(call attachments "$token_owner" "$valid_query&attachments=x")"
metadata_status="$(call metadata "$token_owner" "$valid_query&metadata=x")"
limit_low_status="$(call limit-low "$token_owner" "$valid_query&limit=0")"
limit_high_status="$(call limit-high "$token_owner" "$valid_query&limit=101")"
cursor_bad_status="$(call cursor-bad "$token_owner" "$valid_query&cursor=bad")"
test "$no_jwt_status" = "401"
test "$invalid_jwt_status" = "401"
for status in "$empty_status" "$user_status" "$specialist_status" "$role_status" "$prompt_status" "$attachments_status" "$metadata_status" "$limit_low_status" "$limit_high_status"; do
  test "$status" = "400"
done
test "$cursor_bad_status" = "400"
test "$(jq -r '.error.code' "$tmp_dir/cursor-bad.json")" = "invalidCursor"

echo "2B-V-D stage: active and archived owner sessions list messages"
active_status="$(call active "$token_owner" "$valid_query&limit=100")"
archived_status="$(call archived "$token_owner" '?sessionId=5d400000-0000-4000-8000-000000000002&limit=100')"
test "$active_status" = "200"
test "$archived_status" = "200"
test "$(jq -r '.items | length' "$tmp_dir/active.json")" = "4"
test "$(jq -r '.items | map(.messageId) == ["5d500000-0000-4000-8000-000000000001","5d500000-0000-4000-8000-000000000002","5d500000-0000-4000-8000-000000000003","5d500000-0000-4000-8000-000000000004"]' "$tmp_dir/active.json")" = "true"
test "$(jq -r '.items | map(.role) == ["user","assistant","system","tool"]' "$tmp_dir/active.json")" = "true"
test "$(jq -r '.items | length' "$tmp_dir/archived.json")" = "2"
test "$(jq -r '.items[0].content' "$tmp_dir/archived.json")" = "archived historical one"

echo "2B-V-D stage: foreign and missing are opaque"
foreign_status="$(call foreign "$token_owner" '?sessionId=5d400000-0000-4000-8000-000000000003')"
missing_status="$(call missing "$token_owner" '?sessionId=5d400000-0000-4000-8000-000000000099')"
test "$foreign_status" = "404"
test "$missing_status" = "404"
test "$(jq -r '.error.code' "$tmp_dir/foreign.json")" = "sessionNotFound"
test "$(jq -r '.error.code' "$tmp_dir/missing.json")" = "sessionNotFound"
if diff -u <(jq -S 'del(.error.requestId)' "$tmp_dir/foreign.json") <(jq -S 'del(.error.requestId)' "$tmp_dir/missing.json"); then
  :
else
  echo "Foreign and missing session responses are distinguishable" >&2
  exit 1
fi

echo "2B-V-D stage: pagination and cursor"
page1_status="$(call page1 "$token_owner" "$valid_query&limit=2")"
test "$page1_status" = "200"
cursor="$(jq -r '.nextCursor' "$tmp_dir/page1.json")"
test -n "$cursor"; test "$cursor" != "null"
page2_status="$(call page2 "$token_owner" "$valid_query&limit=2&cursor=$cursor")"
test "$page2_status" = "200"
test "$(jq -r '.nextCursor' "$tmp_dir/page2.json")" = "null"
jq -r '.items[].messageId' "$tmp_dir/page1.json" "$tmp_dir/page2.json" | sort > "$tmp_dir/paged_ids.txt"
test "$(uniq "$tmp_dir/paged_ids.txt" | wc -l | tr -d ' ')" = "4"
test "$(wc -l < "$tmp_dir/paged_ids.txt" | tr -d ' ')" = "4"

echo "2B-V-D stage: public response and integrity"
for response in "$tmp_dir/active.json" "$tmp_dir/archived.json" "$tmp_dir/page1.json" "$tmp_dir/page2.json"; do
  test "$(jq -r 'keys == ["items","nextCursor"]' "$response")" = "true"
  test "$(jq -r 'all(.items[]; (. | keys == ["content","createdAt","messageId","role","sessionId"]))' "$response")" = "true"
  for forbidden in "user_id" "userId" "specialist_id" "specialistId" \
    "prompt_template" "service_role" "attachments" "metadata" "JWT"; do
    if rg -F -- "$forbidden" "$response" >/dev/null; then
      echo "Forbidden public response field found: $forbidden" >&2
      exit 1
    fi
  done
done
test "$(db_psql -Atc "select md5(string_agg(row_to_json(s)::text,'' order by s.id)) from public.chat_sessions s where specialist_id='5d200000-0000-4000-8000-000000000001';")" = "$sessions_before"
test "$(db_psql -Atc "select md5(string_agg(row_to_json(m)::text,'' order by m.id)) from public.messages m join public.chat_sessions s on s.id=m.session_id where s.specialist_id='5d200000-0000-4000-8000-000000000001';")" = "$messages_before"
test "$(db_psql -Atc "select md5(string_agg(row_to_json(c)::text,'' order by c.id)) from public.specialist_catalog c where display_name like 'test_only_2b_v_d%';")" = "$catalog_before"
test "$(db_psql -Atc "select md5(string_agg(row_to_json(s)::text,'' order by s.id)) from public.specialists s where name like 'test_only_2b_v_d%';")" = "$specialist_before"
test "$(db_psql -Atc "select message_count || '|' || last_message_at from public.chat_sessions where id='5d400000-0000-4000-8000-000000000001';")" = "4|2026-06-21 10:00:00"
test "$(db_psql -Atc "select message_count || '|' || last_message_at from public.chat_sessions where id='5d400000-0000-4000-8000-000000000002';")" = "2|2026-06-21 09:00:00"

echo "2B-V-D stage: safe logs"
sleep 1
for forbidden in "$token_owner" "$token_other" "$owner_id" "$other_id" \
  "5d400000-0000-4000-8000-000000000001" "5d200000-0000-4000-8000-000000000001" \
  "user_id" "specialist_id" "prompt_template" "service_role" "active user one" \
  "archived historical one"; do
  if rg -F -- "$forbidden" "$edge_log" >/dev/null; then
    echo "Forbidden value found in local Edge Function logs: $forbidden" >&2
    exit 1
  fi
done

echo "2B-V-D stage: cleanup and zero-fixture postconditions"
cleanup
trap - EXIT INT TERM
counts="$(postconditions)"
echo "$counts"
test "$counts" = "0|0|0|0|0|0"

echo "2B-V-D list-session-messages local HTTP harness: PASS"

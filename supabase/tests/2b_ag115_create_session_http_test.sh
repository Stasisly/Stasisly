#!/usr/bin/env bash

set -euo pipefail

for command in curl docker jq rg supabase; do
  command -v "$command" >/dev/null || {
    echo "$command is required" >&2
    exit 1
  }
done

echo "2B-AG115 stage: anti-remote preflight"
if rg -n 'supabase\.co([/:]|$)|SUPABASE_ACCESS_TOKEN' \
  supabase/config.toml supabase/.branches 2>/dev/null; then
  echo "Remote-looking Supabase configuration detected; refusing to run" >&2
  exit 1
fi

eval "$(supabase status -o env 2>/dev/null | sed -n '/^[A-Z_]*=/p')"
case "${API_URL:-}" in
  http://127.0.0.1:54321|http://localhost:54321) ;;
  *) echo "Supabase endpoints are not approved local endpoints" >&2; exit 1 ;;
esac
FUNCTIONS_URL="$API_URL/functions/v1"

tmp_dir="$(mktemp -d /tmp/stasisly-2b-ag115.XXXXXX)"
edge_env="$tmp_dir/functions.env"
edge_log="$tmp_dir/edge.log"
run_id="$(date +%s)-$RANDOM"
email_a="test_only_2b_ag115_a_${run_id}@stasisly.local"
email_b="test_only_2b_ag115_b_${run_id}@stasisly.local"
password="LocalTestOnly-${run_id}-Aa9!"
serve_pid=""

db_psql() {
  docker exec -i supabase_db_Stasisly psql -U postgres -d postgres \
    -v ON_ERROR_STOP=1 "$@"
}

postconditions() {
  db_psql -Atc "
    select concat_ws('|',
      (select count(*) from auth.users where email like 'test_only_2b_ag115_%@stasisly.local'),
      (select count(*) from public.users where display_name like 'test_only_2b_ag115%'),
      (select count(*) from public.chat_sessions cs join public.users u on u.id=cs.user_id where u.display_name like 'test_only_2b_ag115%'),
      (select count(*) from public.messages m join public.chat_sessions cs on cs.id=m.session_id join public.users u on u.id=cs.user_id where u.display_name like 'test_only_2b_ag115%'),
      (select count(*) from public.specialists where name like 'test_only_2b_ag115%'),
      (select count(*) from public.specialist_catalog where display_name like 'test_only_2b_ag115%')
    );"
}

cleanup() {
  local exit_code=$?
  if [ -n "$serve_pid" ] && kill -0 "$serve_pid" >/dev/null 2>&1; then
    kill "$serve_pid" >/dev/null 2>&1 || true
    wait "$serve_pid" >/dev/null 2>&1 || true
  fi
  db_psql < supabase/tests/2b_ag115_create_session_cleanup.psql \
    >/dev/null 2>&1 || true
  local counts
  counts="$(postconditions 2>/dev/null || true)"
  if [ "$counts" != "0|0|0|0|0|0" ]; then
    echo "2B-AG115 cleanup did not leave zero temporary fixtures: ${counts:-unavailable}" >&2
    supabase db reset --local --no-seed >/dev/null 2>&1 || true
  fi
  rm -rf "$tmp_dir"
  return "$exit_code"
}
trap cleanup EXIT INT TERM

echo "2B-AG115 stage: verify AG114 seed and clean preconditions"
test "$(postconditions)" = "0|0|0|0|0|0"
test "$(db_psql -Atc "select count(*) from public.specialist_catalog where id::text like '21000000-0000-4000-8000-%';")" = "19"
test "$(db_psql -Atc "select count(*) from public.specialists where id::text like '11000000-0000-4000-8000-%';")" = "19"
catalog_before="$(db_psql -Atc "select md5(string_agg(row_to_json(c)::text,'' order by c.id)) from public.specialist_catalog c where c.id::text like '21000000-0000-4000-8000-%';")"
specialists_before="$(db_psql -Atc "select md5(string_agg(row_to_json(s)::text,'' order by s.id)) from public.specialists s where s.id::text like '11000000-0000-4000-8000-%';")"
messages_before="$(db_psql -Atc 'select count(*) from public.messages;')"

cat > "$edge_env" <<EOF
SUPABASE_URL=$API_URL
SUPABASE_ANON_KEY=$ANON_KEY
SUPABASE_SERVICE_ROLE_KEY=$SERVICE_ROLE_KEY
STASISLY_ALLOW_LOCAL_ONLY=true
EOF
chmod 600 "$edge_env"

echo "2B-AG115 stage: create two local synthetic identities"
signup_a="$(curl --silent --show-error --fail-with-body -H "apikey: $ANON_KEY" -H 'Content-Type: application/json' -d "{\"email\":\"$email_a\",\"password\":\"$password\"}" "$API_URL/auth/v1/signup")"
signup_b="$(curl --silent --show-error --fail-with-body -H "apikey: $ANON_KEY" -H 'Content-Type: application/json' -d "{\"email\":\"$email_b\",\"password\":\"$password\"}" "$API_URL/auth/v1/signup")"
token_a="$(printf '%s' "$signup_a" | jq -r '.access_token')"
token_b="$(printf '%s' "$signup_b" | jq -r '.access_token')"
owner_a="$(printf '%s' "$signup_a" | jq -r '.user.id')"
owner_b="$(printf '%s' "$signup_b" | jq -r '.user.id')"
for value in "$token_a" "$token_b" "$owner_a" "$owner_b"; do
  test -n "$value"; test "$value" != "null"
done
db_psql -c "insert into public.users(id,display_name) values ('$owner_a','test_only_2b_ag115 A'),('$owner_b','test_only_2b_ag115 B');" >/dev/null

echo "2B-AG115 stage: serve create-own-chat-session locally"
: > "$edge_log"
supabase functions serve create-own-chat-session --no-verify-jwt --env-file "$edge_env" >"$edge_log" 2>&1 &
serve_pid=$!
sleep 5
kill -0 "$serve_pid"

endpoint="$FUNCTIONS_URL/create-own-chat-session"
stasis_id="21000000-0000-4000-8000-000000000001"
kitesurf_id="21000000-0000-4000-8000-000000000011"
call() {
  local name=$1 token=$2 body=$3
  curl -sS -o "$tmp_dir/$name.json" -w '%{http_code}' -X POST \
    -H "Authorization: Bearer $token" -H 'Content-Type: application/json' \
    -H 'Accept: application/json' -d "$body" "$endpoint"
}

echo "2B-AG115 stage: fail-closed request and selection cases"
valid_body="{\"selectableSpecialistId\":\"$stasis_id\"}"
no_jwt_status="$(curl -sS -o "$tmp_dir/no-jwt.json" -w '%{http_code}' -X POST -H 'Content-Type: application/json' -d "$valid_body" "$endpoint")"
invalid_jwt_status="$(call invalid-jwt invalid "$valid_body")"
missing_body_status="$(call missing-body "$token_a" '{}')"
wrong_type_status="$(call wrong-type "$token_a" '[]')"
malformed_status="$(call malformed "$token_a" 'not-json')"
empty_id_status="$(call empty-id "$token_a" '{"selectableSpecialistId":""}')"
id_type_status="$(call id-type "$token_a" '{"selectableSpecialistId":42}')"
bad_uuid_status="$(call bad-uuid "$token_a" '{"selectableSpecialistId":"not-a-uuid"}')"
internal_id_status="$(call internal-id "$token_a" '{"selectableSpecialistId":"11000000-0000-4000-8000-000000000001"}')"
missing_status="$(call missing "$token_a" '{"selectableSpecialistId":"21000000-0000-4000-8000-000000000099"}')"
draft_status="$(call draft "$token_a" '{"selectableSpecialistId":"21000000-0000-4000-8000-000000000003"}')"
unavailable_status="$(call unavailable "$token_a" '{"selectableSpecialistId":"21000000-0000-4000-8000-000000000004"}')"
nonconversable_status="$(call nonconversable "$token_a" '{"selectableSpecialistId":"21000000-0000-4000-8000-000000000018"}')"
pro_status="$(call pro "$token_a" '{"selectableSpecialistId":"21000000-0000-4000-8000-000000000012"}')"
vip_status="$(call vip "$token_a" '{"selectableSpecialistId":"21000000-0000-4000-8000-000000000005"}')"
owner_status="$(call owner "$token_b" "{\"selectableSpecialistId\":\"$kitesurf_id\",\"ownerUserId\":\"$owner_a\"}")"
role_status="$(call role "$token_a" "{\"selectableSpecialistId\":\"$stasis_id\",\"role\":\"admin\"}")"
permissions_status="$(call permissions "$token_a" "{\"selectableSpecialistId\":\"$stasis_id\",\"permissions\":[\"all\"]}")"
session_status="$(call session "$token_a" "{\"selectableSpecialistId\":\"$stasis_id\",\"sessionId\":\"53000000-0000-4000-8000-000000000001\"}")"
specialist_status="$(call specialist "$token_a" "{\"selectableSpecialistId\":\"$stasis_id\",\"specialistId\":\"11000000-0000-4000-8000-000000000001\"}")"
user_status="$(call user "$token_a" "{\"selectableSpecialistId\":\"$stasis_id\",\"userId\":\"$owner_b\"}")"
test "$no_jwt_status" = "401"; test "$invalid_jwt_status" = "401"
for status in "$missing_body_status" "$wrong_type_status" "$malformed_status" "$empty_id_status" "$id_type_status" "$bad_uuid_status" "$owner_status" "$role_status" "$permissions_status" "$session_status" "$specialist_status" "$user_status"; do test "$status" = "400"; done
for status in "$internal_id_status" "$missing_status" "$draft_status" "$unavailable_status" "$nonconversable_status"; do test "$status" = "404"; done
test "$pro_status" = "403"; test "$vip_status" = "403"
test "$(jq -r '.error.code' "$tmp_dir/missing.json")" = "invalidSelectableSpecialist"
test "$(jq -r '.error.code' "$tmp_dir/draft.json")" = "invalidSelectableSpecialist"
test "$(jq -r '.error.code' "$tmp_dir/unavailable.json")" = "invalidSelectableSpecialist"
test "$(jq -r '.error.code' "$tmp_dir/nonconversable.json")" = "invalidSelectableSpecialist"
test "$(db_psql -Atc "select count(*) from public.chat_sessions where user_id in ('$owner_a','$owner_b');")" = "0"
for response in "$tmp_dir"/{no-jwt,invalid-jwt,missing-body,wrong-type,malformed,empty-id,id-type,bad-uuid,internal-id,missing,draft,unavailable,nonconversable,pro,vip,owner,role,permissions,session,specialist,user}.json; do
  test "$(jq -r 'keys == ["error"]' "$response")" = "true"
  test "$(jq -r '.error | keys == ["code","requestId"]' "$response")" = "true"
  for forbidden in specialist_id parent_catalog_id owner_user_id prompt_template permissions claims token stack sql; do
    if rg -i -F -- "$forbidden" "$response" >/dev/null; then
      echo "Forbidden internal detail found in public error" >&2
      exit 1
    fi
  done
done

echo "2B-AG115 stage: positive Stasis, Kitesurf and ownership cases"
stasis_first_status="$(call stasis-first "$token_a" "$valid_body")"
stasis_second_status="$(call stasis-second "$token_a" "$valid_body")"
kitesurf_a_status="$(call kitesurf-a "$token_a" "{\"selectableSpecialistId\":\"$kitesurf_id\"}")"
kitesurf_b_status="$(call kitesurf-b "$token_b" "{\"selectableSpecialistId\":\"$kitesurf_id\"}")"
for status in "$stasis_first_status" "$stasis_second_status" "$kitesurf_a_status" "$kitesurf_b_status"; do test "$status" = "201"; done
stasis_first_session="$(jq -r '.session.sessionId' "$tmp_dir/stasis-first.json")"
stasis_second_session="$(jq -r '.session.sessionId' "$tmp_dir/stasis-second.json")"
kitesurf_a_session="$(jq -r '.session.sessionId' "$tmp_dir/kitesurf-a.json")"
kitesurf_b_session="$(jq -r '.session.sessionId' "$tmp_dir/kitesurf-b.json")"
test "$stasis_first_session" != "$stasis_second_session"
test "$(db_psql -Atc "select user_id from public.chat_sessions where id='$stasis_first_session';")" = "$owner_a"
test "$(db_psql -Atc "select specialist_id from public.chat_sessions where id='$stasis_first_session';")" = "11000000-0000-4000-8000-000000000001"
test "$(db_psql -Atc "select user_id from public.chat_sessions where id='$kitesurf_a_session';")" = "$owner_a"
test "$(db_psql -Atc "select user_id from public.chat_sessions where id='$kitesurf_b_session';")" = "$owner_b"
test "$(db_psql -Atc "select count(*) from public.chat_sessions where user_id in ('$owner_a','$owner_b') and status='active' and message_count=0;")" = "4"

echo "2B-AG115 stage: public response, atomicity and catalog integrity"
for response in "$tmp_dir/stasis-first.json" "$tmp_dir/stasis-second.json" "$tmp_dir/kitesurf-a.json" "$tmp_dir/kitesurf-b.json"; do
  test "$(jq -r 'keys == ["session"]' "$response")" = "true"
  test "$(jq -r '.session | keys == ["lastMessageAt","messageCount","selectableSpecialist","sessionId","startedAt","status"]' "$response")" = "true"
  test "$(jq -r '.session.selectableSpecialist | keys == ["area","displayName","id"]' "$response")" = "true"
  for forbidden in user_id userId ownerUserId owner_user_id specialist_id specialistId parent_catalog_id prompt_template permissions service_role access_tier claims token stack sql raw; do
    if rg -F -- "$forbidden" "$response" >/dev/null; then
      echo "Forbidden public response field found: $forbidden" >&2
      exit 1
    fi
  done
done
test "$(db_psql -Atc 'select count(*) from public.messages;')" = "$messages_before"
test "$(db_psql -Atc "select md5(string_agg(row_to_json(c)::text,'' order by c.id)) from public.specialist_catalog c where c.id::text like '21000000-0000-4000-8000-%';")" = "$catalog_before"
test "$(db_psql -Atc "select md5(string_agg(row_to_json(s)::text,'' order by s.id)) from public.specialists s where s.id::text like '11000000-0000-4000-8000-%';")" = "$specialists_before"

sleep 1
for forbidden in "$token_a" "$token_b" "$owner_a" "$owner_b" user_id specialist_id prompt_template service_role; do
  if rg -F -- "$forbidden" "$edge_log" >/dev/null; then
    echo "Forbidden value found in local Edge Function logs" >&2
    exit 1
  fi
done

echo "2B-AG115 stage: cleanup and zero temporary fixtures"
cleanup
trap - EXIT INT TERM
counts="$(postconditions)"
echo "$counts"
test "$counts" = "0|0|0|0|0|0"
test "$(db_psql -Atc "select count(*) from public.specialist_catalog where id::text like '21000000-0000-4000-8000-%';")" = "19"
test "$(db_psql -Atc "select count(*) from public.specialists where id::text like '11000000-0000-4000-8000-%';")" = "19"

echo "2B-AG115 create session by selectable specialist local HTTP harness: PASS"

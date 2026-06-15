#!/usr/bin/env bash

set -euo pipefail

for command in curl docker flutter jq rg supabase; do
  command -v "$command" >/dev/null || {
    echo "$command is required" >&2
    exit 1
  }
done

echo "2B-IV-H stage: anti-remote preflight"
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

tmp_dir="$(mktemp -d /tmp/stasisly-2b-iv-h.XXXXXX)"
edge_env="$tmp_dir/functions.env"
edge_log="$tmp_dir/edge.log"
email="test_only_2b_iv_h_$(date +%s)@stasisly.local"
password="LocalTestOnly-9!"
selectable_id="4f300000-0000-4000-8000-000000000001"
serve_pid=""

db_psql() {
  docker exec -i supabase_db_Stasisly psql -U postgres -d postgres \
    -v ON_ERROR_STOP=1 "$@"
}

postconditions() {
  db_psql -Atc "
    select concat_ws('|',
      (select count(*) from auth.users where email like 'test_only_2b_iv_h_%@stasisly.local'),
      (select count(*) from public.users where display_name like 'test_only_2b_iv_h%'),
      (select count(*) from public.specialists where name like 'test_only_2b_iv_h%'),
      (select count(*) from public.specialist_catalog where display_name like 'test_only_2b_iv_h%'),
      (select count(*) from public.chat_sessions where specialist_id::text like '4f200000-0000-4000-8000-%'),
      (select count(*) from public.messages m join public.chat_sessions s on s.id = m.session_id where s.specialist_id::text like '4f200000-0000-4000-8000-%')
    );"
}

cleanup() {
  local exit_code=$?
  if [ -n "$serve_pid" ] && kill -0 "$serve_pid" >/dev/null 2>&1; then
    kill "$serve_pid" >/dev/null 2>&1 || true
    wait "$serve_pid" >/dev/null 2>&1 || true
  fi
  db_psql < supabase/tests/2b_iv_h_local_http_integration_cleanup.psql \
    >/dev/null 2>&1 || true
  local counts
  counts="$(postconditions 2>/dev/null || true)"
  if [ "$counts" != "0|0|0|0|0|0" ]; then
    echo "2B-IV-H cleanup did not leave zero fixtures: ${counts:-unavailable}" >&2
    supabase db reset --local --no-seed >/dev/null 2>&1 || true
  fi
  rm -rf "$tmp_dir"
  return "$exit_code"
}
trap cleanup EXIT INT TERM

echo "2B-IV-H stage: verify clean preconditions"
test "$(postconditions)" = "0|0|0|0|0|0"

cat > "$edge_env" <<EOF
SUPABASE_URL=$API_URL
SUPABASE_ANON_KEY=$ANON_KEY
SUPABASE_SERVICE_ROLE_KEY=$SERVICE_ROLE_KEY
STASISLY_ALLOW_LOCAL_ONLY=true
EOF
chmod 600 "$edge_env"

echo "2B-IV-H stage: setup fixtures"
db_psql < supabase/tests/2b_iv_h_local_http_integration_setup.psql >/dev/null
messages_before="$(db_psql -Atc 'select count(*) from public.messages;')"

echo "2B-IV-H stage: create local Auth identity and profile"
signup="$(curl --silent --show-error --fail-with-body \
  -H "apikey: $ANON_KEY" -H "Content-Type: application/json" \
  -d "{\"email\":\"$email\",\"password\":\"$password\"}" \
  "$API_URL/auth/v1/signup")"
token="$(printf '%s' "$signup" | jq -r '.access_token')"
owner_id="$(printf '%s' "$signup" | jq -r '.user.id')"
test -n "$token"; test "$token" != "null"
test -n "$owner_id"; test "$owner_id" != "null"
db_psql -c "insert into public.users(id, display_name) values ('$owner_id', 'test_only_2b_iv_h owner');" >/dev/null

echo "2B-IV-H stage: serve Edge Functions locally"
: > "$edge_log"
supabase functions serve --no-verify-jwt --env-file "$edge_env" \
  >"$edge_log" 2>&1 &
serve_pid=$!
sleep 5
kill -0 "$serve_pid"

echo "2B-IV-H stage: wait for local function readiness"
for _ in $(seq 1 20); do
  status="$(curl -sS -o /dev/null -w '%{http_code}' \
    -X POST -H "Content-Type: application/json" \
    -d "{\"selectableSpecialistId\":\"$selectable_id\"}" \
    "$FUNCTIONS_URL/create-own-chat-session" || true)"
  if [ "$status" = "401" ]; then
    break
  fi
  sleep 1
done
test "$status" = "401"

echo "2B-IV-H stage: run Flutter datasource integration"
flutter test test/integration/two_b_iv_h_local_http_chat_sessions_integration_test.dart \
  --dart-define="STASISLY_2B_IV_H_API_URL=$API_URL" \
  --dart-define="STASISLY_2B_IV_H_ACCESS_TOKEN=$token" \
  --dart-define="STASISLY_2B_IV_H_SELECTABLE_ID=$selectable_id"

echo "2B-IV-H stage: verify public integrity and messages"
test "$(db_psql -Atc 'select count(*) from public.messages;')" = "$messages_before"
test "$(db_psql -Atc "select count(*) from public.messages m join public.chat_sessions s on s.id = m.session_id where s.specialist_id::text like '4f200000-0000-4000-8000-%';")" = "0"
test "$(db_psql -Atc "select count(*) from public.chat_sessions where specialist_id = '4f200000-0000-4000-8000-000000000001' and user_id = '$owner_id' and status = 'archived';")" = "1"
test "$(db_psql -Atc "select count(*) from public.chat_sessions where specialist_id = '4f200000-0000-4000-8000-000000000001' and user_id = '$owner_id' and status = 'active';")" = "0"

echo "2B-IV-H stage: verify safe logs"
sleep 1
for forbidden in "$token" "$owner_id" "4f200000-0000-4000-8000-000000000001" \
  "user_id" "specialist_id" "prompt_template" "service_role"; do
  if rg -F -- "$forbidden" "$edge_log" >/dev/null; then
    echo "Forbidden value found in local Edge Function logs: $forbidden" >&2
    exit 1
  fi
done

echo "2B-IV-H stage: cleanup and zero-fixture postconditions"
cleanup
trap - EXIT INT TERM
counts="$(postconditions)"
echo "$counts"
test "$counts" = "0|0|0|0|0|0"

echo "2B-IV-H local HTTP integration harness: PASS"

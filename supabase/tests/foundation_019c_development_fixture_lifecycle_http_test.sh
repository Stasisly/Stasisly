#!/usr/bin/env bash
set -euo pipefail

for command in curl docker jq rg supabase; do command -v "$command" >/dev/null; done

if rg -n 'supabase\.co([/:]|$)|SUPABASE_ACCESS_TOKEN' \
  supabase/config.toml supabase/.branches 2>/dev/null; then
  echo "Non-local Supabase configuration detected" >&2
  exit 1
fi
eval "$(supabase status -o env 2>/dev/null | sed -n '/^[A-Z_]*=/p')"
case "${API_URL:-}" in
  http://127.0.0.1:54321|http://localhost:54321) ;;
  *) echo "Approved local Supabase endpoint required" >&2; exit 1 ;;
esac

functions_url="$API_URL/functions/v1"
tmp_dir="$(mktemp -d /tmp/stasisly-foundation-019c.XXXXXX)"
edge_env="$tmp_dir/functions.env"
edge_log="$tmp_dir/edge.log"
serve_pid=""
fixture_email="foundation_019c_fixture@stasisly.local"
fixture_display_name="foundation_019c_fixture"
specialist_id="f19c1000-0000-4000-8000-000000000001"
catalog_id="f19c2000-0000-4000-8000-000000000001"
password="Foundation-019C-Local-Only-Aa9!"

db_psql() {
  docker exec -i supabase_db_Stasisly psql -U postgres -d postgres \
    -v ON_ERROR_STOP=1 "$@"
}

counts() {
  db_psql -Atc "select concat_ws('|',
    (select count(*) from auth.users where email='$fixture_email'),
    (select count(*) from public.users where display_name='$fixture_display_name'),
    (select count(*) from public.specialists where id='$specialist_id'),
    (select count(*) from public.specialist_catalog where id='$catalog_id'),
    (select count(*) from public.chat_sessions where user_id in (select id from auth.users where email='$fixture_email')),
    (select count(*) from public.messages where session_id in (select id from public.chat_sessions where user_id in (select id from auth.users where email='$fixture_email'))),
    (select count(*) from public.conversation_idempotency where subject_id in (select id from auth.users where email='$fixture_email'))
  );"
}

cleanup_fixture() {
  db_psql -c "
    delete from public.messages where session_id in (
      select id from public.chat_sessions where user_id in (
        select id from auth.users where email='$fixture_email'));
    delete from public.conversation_idempotency where subject_id in (
      select id from auth.users where email='$fixture_email');
    delete from public.chat_sessions where user_id in (
      select id from auth.users where email='$fixture_email');
    delete from public.users where id in (
      select id from auth.users where email='$fixture_email');
    delete from public.specialist_catalog where id='$catalog_id';
    delete from public.specialists where id='$specialist_id';
    delete from auth.users where email='$fixture_email';
  " >/dev/null
  test "$(counts)" = "0|0|0|0|0|0|0"
}

finish() {
  local code=$?
  if [ -n "$serve_pid" ] && kill -0 "$serve_pid" 2>/dev/null; then
    kill "$serve_pid" 2>/dev/null || true
    wait "$serve_pid" 2>/dev/null || true
  fi
  cleanup_fixture >/dev/null 2>&1 || true
  rm -rf "$tmp_dir"
  return "$code"
}
trap finish EXIT INT TERM

test "$(counts)" = "0|0|0|0|0|0|0"
cat >"$edge_env" <<EOF
SUPABASE_URL=$API_URL
SUPABASE_ANON_KEY=$ANON_KEY
SUPABASE_SERVICE_ROLE_KEY=$SERVICE_ROLE_KEY
STASISLY_ALLOW_LOCAL_ONLY=true
STASISLY_RUNTIME_MODE=local
STASISLY_ALLOW_DEVELOPMENT_REMOTE=false
EOF
chmod 600 "$edge_env"
: >"$edge_log"
supabase functions serve --no-verify-jwt --env-file "$edge_env" \
  >"$edge_log" 2>&1 &
serve_pid=$!
sleep 5
kill -0 "$serve_pid"

call_get() {
  curl -sS -o "$tmp_dir/$1.json" -w '%{http_code}' \
    -H "Authorization: Bearer $2" "$functions_url/$3"
}
call_post() {
  local name=$1 token=$2 endpoint=$3 body=$4 key=${5:-}
  local args=(-sS -o "$tmp_dir/$name.json" -w '%{http_code}' -X POST
    -H "Authorization: Bearer $token" -H 'Content-Type: application/json')
  if [ -n "$key" ]; then args+=(-H "Idempotency-Key: $key"); fi
  curl "${args[@]}" -d "$body" "$functions_url/$endpoint"
}

run_cycle() {
  local cycle=$1
  test "$(counts)" = "0|0|0|0|0|0|0"
  db_psql -c "
    insert into public.specialists(id,name,category,prompt_template,is_premium,is_active)
    values('$specialist_id','$fixture_display_name','salud','{}',false,true);
    insert into public.specialist_catalog(
      id,specialist_id,slug,display_name,product_area,short_description,
      publication_status,is_published,availability_status,access_tier,
      supported_surfaces,is_conversable)
    values(
      '$catalog_id','$specialist_id','foundation-019c-fixture',
      'Foundation 019C synthetic','stasis','Synthetic local fixture.',
      'published',true,'available','free',array['product']::text[],true);
  " >/dev/null

  local signup token owner conversation first_message_count
  signup="$(curl -sS --fail-with-body -H "apikey: $ANON_KEY" \
    -H 'Content-Type: application/json' \
    -d "{\"email\":\"$fixture_email\",\"password\":\"$password\"}" \
    "$API_URL/auth/v1/signup")"
  token="$(jq -r .access_token <<<"$signup")"
  owner="$(jq -r .user.id <<<"$signup")"
  test -n "$token"; test "$token" != null; test -n "$owner"; test "$owner" != null
  db_psql -c "insert into public.users(id,display_name) values('$owner','$fixture_display_name');" >/dev/null

  test "$(call_get "catalog-$cycle" "$token" list-selectable-specialists)" = 200
  test "$(jq -r '.items|length' "$tmp_dir/catalog-$cycle.json")" = 1
  test "$(jq -r '.items[0] | keys == ["accessState","displayName","publicArea","publicDescription","selectableSpecialistId"]' "$tmp_dir/catalog-$cycle.json")" = true
  test "$(jq -r '.items[0].selectableSpecialistId' "$tmp_dir/catalog-$cycle.json")" = "$catalog_id"

  local create_body='{"selectableSpecialistId":"'$catalog_id'"}'
  local create_key="foundation-019c-create-cycle-$cycle"
  test "$(call_post "create-$cycle" "$token" create-own-chat-session "$create_body" "$create_key")" = 201
  test "$(call_post "create-replay-$cycle" "$token" create-own-chat-session "$create_body" "$create_key")" = 200
  conversation="$(jq -r .session.sessionId "$tmp_dir/create-$cycle.json")"
  test "$conversation" = "$(jq -r .session.sessionId "$tmp_dir/create-replay-$cycle.json")"
  test "$(db_psql -Atc "select count(*) from public.chat_sessions where user_id='$owner';")" = 1

  test "$(call_get "list-$cycle" "$token" 'list-own-chat-sessions?status=active')" = 200
  test "$(jq -r '.items|length' "$tmp_dir/list-$cycle.json")" = 1
  test "$(call_post "read-$cycle" "$token" read-own-conversation "{\"conversationId\":\"$conversation\"}")" = 200

  local send_body='{"sessionId":"'$conversation'","content":"synthetic local message"}'
  local send_key="foundation-019c-send-cycle-$cycle"
  test "$(call_post "send-$cycle" "$token" send-user-message "$send_body" "$send_key")" = 201
  test "$(call_post "send-replay-$cycle" "$token" send-user-message "$send_body" "$send_key")" = 200
  first_message_count="$(db_psql -Atc "select count(*) from public.messages where session_id='$conversation';")"
  test "$first_message_count" = 1
  test "$(db_psql -Atc "select count(*) from public.messages where session_id='$conversation' and role <> 'user';")" = 0

  test "$(call_post "archive-$cycle" "$token" archive-own-chat-session "{\"sessionId\":\"$conversation\"}")" = 200
  test "$(call_get "history-$cycle" "$token" "list-session-messages?sessionId=$conversation")" = 200
  test "$(jq -r '.items|length' "$tmp_dir/history-$cycle.json")" = 1
  test "$(call_post "archived-send-$cycle" "$token" send-user-message "$send_body" "foundation-019c-archived-$cycle")" = 409
  test "$(call_post "restore-$cycle" "$token" restore-own-conversation "{\"conversationId\":\"$conversation\"}")" = 200

  for forbidden in "$token" "$owner" service_role specialist_id prompt_template; do
    ! rg -F -- "$forbidden" "$edge_log" >/dev/null
  done
  cleanup_fixture
  echo "FOUNDATION-019C local fixture cycle $cycle: PASS"
}

run_cycle 1
run_cycle 2
test "$(counts)" = "0|0|0|0|0|0|0"
echo "FOUNDATION-019C local create smoke and repeatability: PASS"

#!/usr/bin/env bash
set -euo pipefail
for command in curl docker jq rg supabase; do command -v "$command" >/dev/null; done

if rg -n 'supabase\.co([/:]|$)|SUPABASE_ACCESS_TOKEN' supabase/config.toml supabase/.branches 2>/dev/null; then
  echo "Remote configuration detected" >&2; exit 1
fi
eval "$(supabase status -o env 2>/dev/null | sed -n '/^[A-Z_]*=/p')"
case "${API_URL:-}" in
  http://127.0.0.1:54321|http://localhost:54321) ;;
  *) exit 1 ;;
esac
FUNCTIONS_URL="$API_URL/functions/v1"
tmp_dir="$(mktemp -d /tmp/stasisly-foundation-013c.XXXXXX)"
edge_env="$tmp_dir/functions.env"; edge_log="$tmp_dir/edge.log"; serve_pid=""
run_id="$(date +%s)-$RANDOM"; password="LocalOnly-${run_id}-Aa9!"
email_a="foundation_013c_http_a_${run_id}@stasisly.local"
email_b="foundation_013c_http_b_${run_id}@stasisly.local"
specialist_id="f13d1000-0000-4000-8000-000000000001"
catalog_id="f13d2000-0000-4000-8000-000000000001"
conversation_id="f13d3000-0000-4000-8000-000000000001"

db_psql() { docker exec -i supabase_db_Stasisly psql -U postgres -d postgres -v ON_ERROR_STOP=1 "$@"; }
counts() { db_psql -Atc "select concat_ws('|',(select count(*) from auth.users where email like 'foundation_013c_http_%'),(select count(*) from public.users where display_name like 'foundation_013c_http_%'),(select count(*) from public.specialists where id='$specialist_id'),(select count(*) from public.specialist_catalog where id='$catalog_id'),(select count(*) from public.chat_sessions where id='$conversation_id'),(select count(*) from public.messages where session_id='$conversation_id'),(select count(*) from public.conversation_idempotency where subject_id in (select id from auth.users where email like 'foundation_013c_http_%')));"; }
cleanup() { local code=$?; if [ -n "$serve_pid" ] && kill -0 "$serve_pid" 2>/dev/null; then kill "$serve_pid" 2>/dev/null || true; wait "$serve_pid" 2>/dev/null || true; fi; db_psql -c "delete from public.messages where session_id='$conversation_id'; delete from public.conversation_idempotency where subject_id in (select id from auth.users where email like 'foundation_013c_http_%'); delete from public.chat_sessions where id='$conversation_id'; delete from public.specialist_catalog where id='$catalog_id'; delete from public.specialists where id='$specialist_id'; delete from auth.users where email like 'foundation_013c_http_%';" >/dev/null 2>&1 || true; rm -rf "$tmp_dir"; return "$code"; }
trap cleanup EXIT INT TERM
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
db_psql -c "insert into public.specialists(id,name,category,prompt_template,is_premium,is_active) values('$specialist_id','foundation_013c_http','salud','{}',false,true); insert into public.specialist_catalog(id,specialist_id,slug,display_name,product_area,short_description,publication_status,is_published,availability_status,access_tier,supported_surfaces,is_conversable) values('$catalog_id','$specialist_id','foundation-013c-http','Foundation 013C HTTP','health','Synthetic.','published',true,'available','free',array['product']::text[],true);" >/dev/null
signup() { curl -sS --fail-with-body -H "apikey: $ANON_KEY" -H 'Content-Type: application/json' -d "{\"email\":\"$1\",\"password\":\"$password\"}" "$API_URL/auth/v1/signup"; }
signup_a="$(signup "$email_a")"; signup_b="$(signup "$email_b")"
token_a="$(jq -r .access_token <<<"$signup_a")"; token_b="$(jq -r .access_token <<<"$signup_b")"
owner_a="$(jq -r .user.id <<<"$signup_a")"; owner_b="$(jq -r .user.id <<<"$signup_b")"
db_psql -c "insert into public.users(id,display_name) values('$owner_a','foundation_013c_http_a'),('$owner_b','foundation_013c_http_b'); insert into public.chat_sessions(id,user_id,specialist_id,started_at,last_message_at,status,message_count,archived_at) values('$conversation_id','$owner_a','$specialist_id',now()-interval '2 minutes',now()-interval '1 minute','active',1,null); insert into public.messages(session_id,role,content,attachments) values('$conversation_id','user','foundation 013c historical',null);" >/dev/null

supabase functions serve --no-verify-jwt --env-file "$edge_env" >"$edge_log" 2>&1 & serve_pid=$!; sleep 5; kill -0 "$serve_pid"
call_get() { curl -sS -o "$tmp_dir/$1.json" -w '%{http_code}' -H "Authorization: Bearer $2" "$FUNCTIONS_URL/$3"; }
call_post() {
  local name=$1 token=$2 endpoint=$3 body=$4 key=${5:-}
  local args=(-sS -o "$tmp_dir/$name.json" -w '%{http_code}' -X POST
    -H "Authorization: Bearer $token" -H 'Content-Type: application/json')
  if [ -n "$key" ]; then args+=(-H "Idempotency-Key: $key"); fi
  curl "${args[@]}" -d "$body" "$FUNCTIONS_URL/$endpoint"
}

test "$(call_get list-a "$token_a" 'list-own-chat-sessions?status=active')" = 200
test "$(jq -r '.items|length' "$tmp_dir/list-a.json")" = 1
for endpoint in read-own-conversation archive-own-chat-session restore-own-conversation; do
  body='{"conversationId":"'$conversation_id'"}'; [ "$endpoint" = archive-own-chat-session ] && body='{"sessionId":"'$conversation_id'"}'
  test "$(call_post foreign "$token_b" "$endpoint" "$body")" = 404
done
test "$(call_post read-active "$token_a" read-own-conversation '{"conversationId":"'$conversation_id'"}')" = 200
test "$(call_post archive "$token_a" archive-own-chat-session '{"sessionId":"'$conversation_id'"}')" = 200
test "$(call_post archive-replay "$token_a" archive-own-chat-session '{"sessionId":"'$conversation_id'"}')" = 200
test "$(call_get active-empty "$token_a" 'list-own-chat-sessions?status=active')" = 200
test "$(jq -r '.items|length' "$tmp_dir/active-empty.json")" = 0
test "$(call_get archived-list "$token_a" 'list-own-chat-sessions?status=archived')" = 200
test "$(jq -r '.items[0].sessionId' "$tmp_dir/archived-list.json")" = "$conversation_id"
test "$(call_get messages "$token_a" "list-session-messages?sessionId=$conversation_id")" = 200
test "$(jq -r '.items|length' "$tmp_dir/messages.json")" = 1
test "$(call_post send-denied "$token_a" send-user-message '{"sessionId":"'$conversation_id'","content":"denied"}' foundation-013c-send-denied-0001)" = 409
test "$(call_post restore "$token_a" restore-own-conversation '{"conversationId":"'$conversation_id'"}')" = 200
test "$(call_post restore-replay "$token_a" restore-own-conversation '{"conversationId":"'$conversation_id'"}')" = 200
test "$(call_post send-ok "$token_a" send-user-message '{"sessionId":"'$conversation_id'","content":"restored local"}' foundation-013c-send-ok-000001)" = 201
test "$(db_psql -Atc "select status||'|'||(archived_at is null)::text||'|'||message_count from public.chat_sessions where id='$conversation_id';")" = "active|true|2"

for forbidden in "$token_a" "$token_b" "$owner_a" "$owner_b" user_id specialist_id service_role; do ! rg -F -- "$forbidden" "$edge_log" >/dev/null; done
cleanup; trap - EXIT INT TERM
result="$(counts)"; echo "$result"; test "$result" = "0|0|0|0|0|0|0"
echo "FOUNDATION-013C local HTTP lifecycle: PASS"

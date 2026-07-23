#!/usr/bin/env bash
set -euo pipefail

# Versioned operator-side runner. It is inert unless every authorization input
# is supplied at invocation time and the local multi-factor gate passes.
test "${1:-}" = "--authorized-development-run" || exit 64
for command in curl dart flutter git jq uuidgen; do command -v "$command" >/dev/null; done

required=(
  SUPABASE_URL SUPABASE_ANON_KEY SUPABASE_SERVICE_ROLE_KEY
  APP_MODE ENABLE_REMOTE_BACKEND ENABLE_REAL_AUTH ENABLE_REAL_DATA
  ALLOW_DEV_ROUTES ENABLE_CONVERSATIONS_ROUTE
  BACKEND_TARGET_ENVIRONMENT REMOTE_CONTEXT_AUTHORIZATION_MODE
  REMOTE_PROJECT_CONFIRMED DEVELOPMENT_OPERATOR_CONFIRMED
  FOUNDER_AUTHORIZATION_REFERENCE AUTHORIZED_COMMIT_SHA
  AUTHORIZED_COMMIT_MATCHES_HEAD DEPLOYMENT_MANIFEST_RUNTIME_APPROVAL
  REMOTE_FIXTURE_MANIFEST_RUNTIME_APPROVAL REMOTE_CLEANUP_PREFLIGHT
  DEVELOPMENT_ALLOWED_WEB_ORIGIN REMOTE_REQUIRED_CONFIGURATION
  REMOTE_SECRET_NAMES_ACKNOWLEDGED REMOTE_FIXTURE_RUN_ALIAS
  REMOTE_RUNNER_EXECUTION_MODE
)
for name in "${required[@]}"; do test -n "${!name:-}" || exit 65; done
test "$BACKEND_TARGET_ENVIRONMENT" = development
test "$APP_MODE" = development
test "$ENABLE_REMOTE_BACKEND" = true
test "$ENABLE_REAL_AUTH" = true
test "$ENABLE_REAL_DATA" = false
test "$ALLOW_DEV_ROUTES" = true
test "$ENABLE_CONVERSATIONS_ROUTE" = false
test "$(git rev-parse HEAD)" = "$AUTHORIZED_COMMIT_SHA"
test "$REMOTE_FIXTURE_RUN_ALIAS" != '*'
[[ "$REMOTE_FIXTURE_RUN_ALIAS" =~ ^[a-z0-9][a-z0-9-]{7,31}$ ]]
test "$REMOTE_RUNNER_EXECUTION_MODE" = diagnostic-only
dart run tool/check_development_remote_preparation.dart --validate-cors >/dev/null

tmp_dir="$(mktemp -d /tmp/stasisly-foundation-019a-r1.XXXXXX)"
chmod 700 "$tmp_dir"
run_alias="$REMOTE_FIXTURE_RUN_ALIAS"
specialist_id="$(uuidgen | tr '[:upper:]' '[:lower:]')"
catalog_id="$(uuidgen | tr '[:upper:]' '[:lower:]')"
fixture_email="${run_alias}@example.test"
fixture_password="Synthetic-${run_alias}-Aa9!"
fixture_display_name="Synthetic ${run_alias}"
owner_id=""
synthetic_access_token=""
flow_status=1
cleanup_status=1

request() {
  local method=$1 endpoint=$2 body=${3:-} output=$4 token=$5
  local metadata=${6:-} curl_error=${7:-}
  local write_format='%{http_code}'
  if [ -n "$metadata" ]; then
    write_format=$'%{http_code}\t%{content_type}\t%{time_total}'
  fi
  local args=(-sS -o "$output" -w "$write_format" -X "$method"
    -H "apikey: $SUPABASE_SERVICE_ROLE_KEY"
    -H "Authorization: Bearer $token"
    -H 'Content-Type: application/json')
  if [ -n "$body" ]; then args+=(-d "$body"); fi
  if [ -n "$metadata" ] && [ -n "$curl_error" ]; then
    curl "${args[@]}" "$SUPABASE_URL$endpoint" >"$metadata" 2>"$curl_error"
    return
  fi
  local default_curl_error="$tmp_dir/request.curl-error"
  local request_status=0
  if curl "${args[@]}" "$SUPABASE_URL$endpoint" \
    2>"$default_curl_error"; then
    request_status=0
  else
    request_status=$?
  fi
  rm -f "$default_curl_error"
  return "$request_status"
}

delete_exact() {
  local endpoint=$1 status
  status="$(request DELETE "$endpoint" '' "$tmp_dir/delete.json" \
    "$SUPABASE_SERVICE_ROLE_KEY")" || return 1
  case "$status" in 200|204) return 0 ;; *) return 1 ;; esac
}

delete_auth_user_exact() {
  local status
  status="$(request DELETE "/auth/v1/admin/users/$owner_id" '' \
    "$tmp_dir/delete-auth.json" "$SUPABASE_SERVICE_ROLE_KEY")" || return 1
  case "$status" in 200|404) return 0 ;; *) return 1 ;; esac
}

remaining_counts() {
  local sessions='[]' messages='[]' idempotency='[]' users='[]'
  local catalog='[]' specialists='[]' auth_count=0 session_ids id
  if [ -n "$owner_id" ]; then
    request GET "/rest/v1/chat_sessions?user_id=eq.$owner_id&select=id" '' \
      "$tmp_dir/count-sessions.json" "$SUPABASE_SERVICE_ROLE_KEY" >/dev/null
    sessions="$(cat "$tmp_dir/count-sessions.json")"
    session_ids="$(jq -r '.[].id' <<<"$sessions")"
    while IFS= read -r id; do
      test -n "$id" || continue
      request GET "/rest/v1/messages?session_id=eq.$id&select=id" '' \
        "$tmp_dir/count-messages.json" "$SUPABASE_SERVICE_ROLE_KEY" >/dev/null
      messages="$(jq -s 'add' <(printf '%s' "$messages") "$tmp_dir/count-messages.json")"
    done <<<"$session_ids"
    request GET "/rest/v1/conversation_idempotency?subject_id=eq.$owner_id&select=id" '' \
      "$tmp_dir/count-idempotency.json" "$SUPABASE_SERVICE_ROLE_KEY" >/dev/null
    idempotency="$(cat "$tmp_dir/count-idempotency.json")"
    request GET "/rest/v1/users?id=eq.$owner_id&select=id" '' \
      "$tmp_dir/count-users.json" "$SUPABASE_SERVICE_ROLE_KEY" >/dev/null
    users="$(cat "$tmp_dir/count-users.json")"
    if test "$(request GET "/auth/v1/admin/users/$owner_id" '' \
      "$tmp_dir/count-auth.json" "$SUPABASE_SERVICE_ROLE_KEY")" = 200; then auth_count=1; fi
  fi
  request GET "/rest/v1/specialist_catalog?id=eq.$catalog_id&select=id" '' \
    "$tmp_dir/count-catalog.json" "$SUPABASE_SERVICE_ROLE_KEY" >/dev/null
  catalog="$(cat "$tmp_dir/count-catalog.json")"
  request GET "/rest/v1/specialists?id=eq.$specialist_id&select=id" '' \
    "$tmp_dir/count-specialists.json" "$SUPABASE_SERVICE_ROLE_KEY" >/dev/null
  specialists="$(cat "$tmp_dir/count-specialists.json")"
  printf '%s|%s|%s|%s|%s|%s|%s' \
    "$(jq length <<<"$messages")" "$(jq length <<<"$idempotency")" \
    "$(jq length <<<"$sessions")" "$(jq length <<<"$users")" \
    "$(jq length <<<"$catalog")" "$(jq length <<<"$specialists")" "$auth_count"
}

cleanup_remote_fixture() {
  local sessions session_id
  if [ -n "$owner_id" ]; then
    request GET "/rest/v1/chat_sessions?user_id=eq.$owner_id&select=id" '' \
      "$tmp_dir/cleanup-sessions.json" "$SUPABASE_SERVICE_ROLE_KEY" >/dev/null || return 1
    sessions="$(jq -r '.[].id' "$tmp_dir/cleanup-sessions.json")"
    while IFS= read -r session_id; do
      test -n "$session_id" || continue
      delete_exact "/rest/v1/messages?session_id=eq.$session_id" || return 1
    done <<<"$sessions"
    delete_exact "/rest/v1/conversation_idempotency?subject_id=eq.$owner_id" || return 1
    delete_exact "/rest/v1/chat_sessions?user_id=eq.$owner_id" || return 1
    delete_exact "/rest/v1/users?id=eq.$owner_id" || return 1
  fi
  delete_exact "/rest/v1/specialist_catalog?id=eq.$catalog_id" || return 1
  delete_exact "/rest/v1/specialists?id=eq.$specialist_id" || return 1
  if [ -n "$owner_id" ]; then
    delete_auth_user_exact || return 1
  fi
  test "$(remaining_counts)" = '0|0|0|0|0|0|0'
}

finalize() {
  local original_status=$?
  trap - EXIT INT TERM
  if cleanup_remote_fixture && cleanup_remote_fixture; then cleanup_status=0; fi
  rm -rf "$tmp_dir"
  if [ "$cleanup_status" -ne 0 ]; then
    echo 'FAILED_DIRTY_BLOCKING'
    exit 1
  fi
  if [ "$flow_status" -eq 0 ] && [ "$original_status" -eq 0 ]; then
    echo 'PASSED_CLEAN'
    exit 0
  fi
  echo 'FAILED_CLEAN'
  exit "${original_status:-1}"
}
trap finalize EXIT INT TERM

test "$(remaining_counts)" = '0|0|0|0|0|0|0'
synthetic_user_metadata="$tmp_dir/auth-user.metadata"
synthetic_user_curl_error="$tmp_dir/auth-user.curl-error"
synthetic_user_transport=failure
if request POST '/auth/v1/admin/users' \
  "{\"email\":\"$fixture_email\",\"password\":\"$fixture_password\",\"email_confirm\":true}" \
  "$tmp_dir/auth-user.json" "$SUPABASE_SERVICE_ROLE_KEY" \
  "$synthetic_user_metadata" "$synthetic_user_curl_error"; then
  synthetic_user_transport=ok
else
  synthetic_user_curl_status=$?
  if [ "$synthetic_user_curl_status" -eq 28 ]; then
    synthetic_user_transport=timeout
  fi
fi
rm -f "$synthetic_user_curl_error"

synthetic_user_status=0
synthetic_user_content_type=''
synthetic_user_duration=''
if ! IFS=$'\t' read -r synthetic_user_status synthetic_user_content_type \
  synthetic_user_duration <"$synthetic_user_metadata"; then
  if [ -z "$synthetic_user_status" ]; then
    synthetic_user_status=0
    synthetic_user_content_type=''
    synthetic_user_duration=''
  fi
fi
rm -f "$synthetic_user_metadata"

if jq -e 'type == "object" and (.id | type == "string")' \
  "$tmp_dir/auth-user.json" >/dev/null 2>&1; then
  owner_id="$(jq -r .id "$tmp_dir/auth-user.json")"
fi

diagnostic_output="$tmp_dir/safe-http-diagnostic.txt"
diagnostic_build_stdout="$tmp_dir/diagnostic-build.stdout"
diagnostic_build_stderr="$tmp_dir/diagnostic-build.stderr"
diagnostic_tool_status=0
if dart run tool/safe_http_diagnostic.dart \
  --operation syntheticUserCreate \
  --status-code "$synthetic_user_status" \
  --content-type "$synthetic_user_content_type" \
  --duration-seconds "$synthetic_user_duration" \
  --transport-result "$synthetic_user_transport" \
  --body-file "$tmp_dir/auth-user.json" \
  --cleanup-required true \
  --output-file "$diagnostic_output" \
  >"$diagnostic_build_stdout" 2>"$diagnostic_build_stderr"; then
  diagnostic_tool_status=0
else
  diagnostic_tool_status=$?
fi
rm -f "$diagnostic_build_stdout" "$diagnostic_build_stderr"
test -f "$diagnostic_output"
test "$(head -n 1 "$diagnostic_output")" = SAFE_HTTP_DIAGNOSTIC_BEGIN
test "$(tail -n 1 "$diagnostic_output")" = SAFE_HTTP_DIAGNOSTIC_END
cat "$diagnostic_output"
rm -f "$diagnostic_output"
test "$diagnostic_tool_status" = 0
test "$synthetic_user_status" = 200
test -n "$owner_id"; test "$owner_id" != null

# A diagnostic-only authorization always stops at the focal assertion.
flow_status=0
exit 0

test "$(request POST '/rest/v1/specialists' \
  "{\"id\":\"$specialist_id\",\"name\":\"$fixture_display_name\",\"category\":\"salud\",\"prompt_template\":{},\"is_premium\":false,\"is_active\":true}" \
  "$tmp_dir/specialist.json" "$SUPABASE_SERVICE_ROLE_KEY")" = 201
test "$(request POST '/rest/v1/specialist_catalog' \
  "{\"id\":\"$catalog_id\",\"specialist_id\":\"$specialist_id\",\"slug\":\"$run_alias\",\"display_name\":\"$fixture_display_name\",\"product_area\":\"stasis\",\"short_description\":\"Synthetic bounded fixture.\",\"publication_status\":\"published\",\"is_published\":true,\"availability_status\":\"available\",\"access_tier\":\"free\",\"supported_surfaces\":[\"product\"],\"is_conversable\":true}" \
  "$tmp_dir/catalog.json" "$SUPABASE_SERVICE_ROLE_KEY")" = 201
test "$(request POST '/rest/v1/users' \
  "{\"id\":\"$owner_id\",\"display_name\":\"$fixture_display_name\"}" \
  "$tmp_dir/profile.json" "$SUPABASE_SERVICE_ROLE_KEY")" = 201
test "$(request POST '/auth/v1/token?grant_type=password' \
  "{\"email\":\"$fixture_email\",\"password\":\"$fixture_password\"}" \
  "$tmp_dir/token.json" "$SUPABASE_ANON_KEY")" = 200
synthetic_access_token="$(jq -r .access_token "$tmp_dir/token.json")"
test -n "$synthetic_access_token"; test "$synthetic_access_token" != null

export SYNTHETIC_ACCESS_TOKEN="$synthetic_access_token"
export REMOTE_FIXTURE_SPECIALIST_DISPLAY_NAME="$fixture_display_name"
flutter test test/features/chat_sessions/data/development_remote_write_test.dart
flutter test test/features/chat_sessions/data/development_remote_read_test.dart
flutter test test/features/chat_messages/presentation/development_remote_ux_read_test.dart
flow_status=0

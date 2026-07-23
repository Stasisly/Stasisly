#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$repo_root"
simulation_root="$(mktemp -d /tmp/stasisly-safe-runner-simulation.XXXXXX)"
trap 'rm -rf "$simulation_root"' EXIT INT TERM

fake_bin="$simulation_root/bin"
mkdir -p "$fake_bin"

cat >"$fake_bin/curl" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

output=''
write_format=''
method=''
url=''
while [ "$#" -gt 0 ]; do
  case "$1" in
    -o) output=$2; shift 2 ;;
    -w) write_format=$2; shift 2 ;;
    -X) method=$2; shift 2 ;;
    -H|-d) shift 2 ;;
    -sS) shift ;;
    *) url=$1; shift ;;
  esac
done

status=200
content_type=application/json
body='[]'

case "$url" in
  */auth/v1/admin/users)
    if [ "$method" = POST ]; then
      touch "$SIM_STATE_DIR/auth-request-started"
      sleep "${SIM_AUTH_SLEEP_SECONDS:-0}"
      status=${SIM_AUTH_STATUS:-200}
      content_type=${SIM_AUTH_CONTENT_TYPE:-application/json}
      body=${SIM_AUTH_BODY:-'{"id":"00000000-0000-4000-8000-000000000001"}'}
      if [ "$status" = 200 ] || [ "$status" = 201 ]; then
        touch "$SIM_STATE_DIR/auth-user-exists"
      fi
    fi
    ;;
  */auth/v1/admin/users/*)
    if [ "$method" = DELETE ]; then
      if [ "${SIM_CLEANUP_FAIL:-false}" = true ]; then
        status=500
      else
        status=200
        rm -f "$SIM_STATE_DIR/auth-user-exists"
      fi
    elif [ -f "$SIM_STATE_DIR/auth-user-exists" ]; then
      status=200
      body='{"id":"00000000-0000-4000-8000-000000000001"}'
    else
      status=404
      body='{}'
    fi
    ;;
  *)
    if [ "$method" = DELETE ]; then status=204; body=''; fi
    ;;
esac

if [ "${SIM_SANITIZER_FAIL:-false}" = true ] &&
   [ "$method" = POST ] &&
   [[ "$url" == */auth/v1/admin/users ]]; then
  mkdir -p "$output"
else
  printf '%s' "$body" >"$output"
fi

if [[ "$write_format" == *content_type* ]]; then
  printf '%s\t%s\t%s' "$status" "$content_type" '0.125'
else
  printf '%s' "$status"
fi
EOF
chmod 700 "$fake_bin/curl"

run_case() {
  local name=$1 expected=$2 status=$3 content_type=$4 body=$5
  local case_dir="$simulation_root/$name"
  mkdir -p "$case_dir"
  local output
  set +e
  output="$(
    cd "$repo_root" &&
    env \
      PATH="$fake_bin:$PATH" \
      SIM_STATE_DIR="$case_dir" \
      SIM_AUTH_STATUS="$status" \
      SIM_AUTH_CONTENT_TYPE="$content_type" \
      SIM_AUTH_BODY="$body" \
      SUPABASE_URL='https://diagnostic.invalid' \
      SUPABASE_ANON_KEY='FAKE_TOKEN_DO_NOT_LOG' \
      SUPABASE_SERVICE_ROLE_KEY='FAKE_SERVICE_ROLE_DO_NOT_LOG' \
      APP_MODE=development \
      ENABLE_REMOTE_BACKEND=true \
      ENABLE_REAL_AUTH=true \
      ENABLE_REAL_DATA=false \
      ALLOW_DEV_ROUTES=true \
      ENABLE_CONVERSATIONS_ROUTE=false \
      BACKEND_TARGET_ENVIRONMENT=development \
      REMOTE_CONTEXT_AUTHORIZATION_MODE=FOUNDER_AUTHORIZED \
      REMOTE_PROJECT_CONFIRMED=CONFIRMED \
      DEVELOPMENT_OPERATOR_CONFIRMED=CONFIRMED \
      FOUNDER_AUTHORIZATION_REFERENCE=FAKE_AUTHORIZATION_DO_NOT_LOG \
      AUTHORIZED_COMMIT_SHA="$(git rev-parse HEAD)" \
      AUTHORIZED_COMMIT_MATCHES_HEAD=CONFIRMED \
      DEPLOYMENT_MANIFEST_RUNTIME_APPROVAL=APPROVED \
      REMOTE_FIXTURE_MANIFEST_RUNTIME_APPROVAL=APPROVED \
      REMOTE_CLEANUP_PREFLIGHT=PASS \
      DEVELOPMENT_ALLOWED_WEB_ORIGIN='https://diagnostic.invalid' \
      REMOTE_REQUIRED_CONFIGURATION=CONFIRMED \
      REMOTE_SECRET_NAMES_ACKNOWLEDGED=CONFIRMED \
      REMOTE_FIXTURE_RUN_ALIAS=diagnostic-run-01 \
      REMOTE_RUNNER_EXECUTION_MODE=diagnostic-only \
      scripts/run_development_remote_fixture_test.sh \
        --authorized-development-run
  )" 2>&1
  local status_code=$?
  set -e

  test "$status_code" -ne 64
  test "$output" = "${output//$'\n'$'\n'/$'\n'}"
  grep -q 'SAFE_HTTP_DIAGNOSTIC_BEGIN' <<<"$output"
  grep -q "statusCode=$status" <<<"$output"
  grep -q "$expected" <<<"$output"
  for canary in \
    FAKE_TOKEN_DO_NOT_LOG \
    FAKE_SERVICE_ROLE_DO_NOT_LOG \
    FAKE_EMAIL_DO_NOT_LOG \
    FAKE_PASSWORD_DO_NOT_LOG \
    FAKE_PROJECT_REF_DO_NOT_LOG \
    https://diagnostic.invalid; do
    ! grep -Fq "$canary" <<<"$output"
  done
}

run_case success-1 PASSED_CLEAN 200 application/json \
  '{"id":"00000000-0000-4000-8000-000000000001","token":"FAKE_TOKEN_DO_NOT_LOG"}'
run_case success-2 PASSED_CLEAN 200 application/json \
  '{"id":"00000000-0000-4000-8000-000000000001"}'
run_case created-1 FAILED_CLEAN 201 application/json \
  '{"id":"00000000-0000-4000-8000-000000000001"}'
run_case created-2 FAILED_CLEAN 201 application/json \
  '{"id":"00000000-0000-4000-8000-000000000001"}'
run_case unauthorized FAILED_CLEAN 401 application/json \
  '{"message":"FAKE_PASSWORD_DO_NOT_LOG"}'
run_case conflict FAILED_CLEAN 409 application/json \
  '{"message":"FAKE_EMAIL_DO_NOT_LOG"}'
run_case server-html FAILED_CLEAN 500 text/html \
  '<html>FAKE_PROJECT_REF_DO_NOT_LOG</html>'
run_case invalid-json FAILED_CLEAN 200 application/json '{invalid'

sanitizer_dir="$simulation_root/sanitizer-failure"
mkdir -p "$sanitizer_dir"
set +e
sanitizer_output="$(
  cd "$repo_root" &&
  env \
    PATH="$fake_bin:$PATH" \
    SIM_STATE_DIR="$sanitizer_dir" \
    SIM_SANITIZER_FAIL=true \
    SUPABASE_URL='https://diagnostic.invalid' \
    SUPABASE_ANON_KEY=x SUPABASE_SERVICE_ROLE_KEY=y \
    APP_MODE=development ENABLE_REMOTE_BACKEND=true ENABLE_REAL_AUTH=true \
    ENABLE_REAL_DATA=false ALLOW_DEV_ROUTES=true \
    ENABLE_CONVERSATIONS_ROUTE=false \
    BACKEND_TARGET_ENVIRONMENT=development \
    REMOTE_CONTEXT_AUTHORIZATION_MODE=FOUNDER_AUTHORIZED \
    REMOTE_PROJECT_CONFIRMED=CONFIRMED \
    DEVELOPMENT_OPERATOR_CONFIRMED=CONFIRMED \
    FOUNDER_AUTHORIZATION_REFERENCE=fake \
    AUTHORIZED_COMMIT_SHA="$(git rev-parse HEAD)" \
    AUTHORIZED_COMMIT_MATCHES_HEAD=CONFIRMED \
    DEPLOYMENT_MANIFEST_RUNTIME_APPROVAL=APPROVED \
    REMOTE_FIXTURE_MANIFEST_RUNTIME_APPROVAL=APPROVED \
    REMOTE_CLEANUP_PREFLIGHT=PASS \
    DEVELOPMENT_ALLOWED_WEB_ORIGIN='https://diagnostic.invalid' \
    REMOTE_REQUIRED_CONFIGURATION=CONFIRMED \
    REMOTE_SECRET_NAMES_ACKNOWLEDGED=CONFIRMED \
    REMOTE_FIXTURE_RUN_ALIAS=diagnostic-run-02 \
    REMOTE_RUNNER_EXECUTION_MODE=diagnostic-only \
    scripts/run_development_remote_fixture_test.sh --authorized-development-run
)" 2>&1
set -e
grep -q 'diagnosticSanitization=failed' <<<"$sanitizer_output"
grep -q 'FAILED_CLEAN' <<<"$sanitizer_output"

cleanup_dir="$simulation_root/cleanup-failure"
mkdir -p "$cleanup_dir"
set +e
cleanup_output="$(
  cd "$repo_root" &&
  env \
    PATH="$fake_bin:$PATH" \
    SIM_STATE_DIR="$cleanup_dir" \
    SIM_AUTH_STATUS=201 SIM_CLEANUP_FAIL=true \
    SUPABASE_URL='https://diagnostic.invalid' \
    SUPABASE_ANON_KEY=x SUPABASE_SERVICE_ROLE_KEY=y \
    APP_MODE=development ENABLE_REMOTE_BACKEND=true ENABLE_REAL_AUTH=true \
    ENABLE_REAL_DATA=false ALLOW_DEV_ROUTES=true \
    ENABLE_CONVERSATIONS_ROUTE=false \
    BACKEND_TARGET_ENVIRONMENT=development \
    REMOTE_CONTEXT_AUTHORIZATION_MODE=FOUNDER_AUTHORIZED \
    REMOTE_PROJECT_CONFIRMED=CONFIRMED \
    DEVELOPMENT_OPERATOR_CONFIRMED=CONFIRMED \
    FOUNDER_AUTHORIZATION_REFERENCE=fake \
    AUTHORIZED_COMMIT_SHA="$(git rev-parse HEAD)" \
    AUTHORIZED_COMMIT_MATCHES_HEAD=CONFIRMED \
    DEPLOYMENT_MANIFEST_RUNTIME_APPROVAL=APPROVED \
    REMOTE_FIXTURE_MANIFEST_RUNTIME_APPROVAL=APPROVED \
    REMOTE_CLEANUP_PREFLIGHT=PASS \
    DEVELOPMENT_ALLOWED_WEB_ORIGIN='https://diagnostic.invalid' \
    REMOTE_REQUIRED_CONFIGURATION=CONFIRMED \
    REMOTE_SECRET_NAMES_ACKNOWLEDGED=CONFIRMED \
    REMOTE_FIXTURE_RUN_ALIAS=diagnostic-run-03 \
    REMOTE_RUNNER_EXECUTION_MODE=diagnostic-only \
    scripts/run_development_remote_fixture_test.sh --authorized-development-run
)" 2>&1
set -e
grep -q 'FAILED_DIRTY_BLOCKING' <<<"$cleanup_output"

signal_dir="$simulation_root/signal"
signal_output="$simulation_root/signal.output"
mkdir -p "$signal_dir"
env \
    PATH="$fake_bin:$PATH" \
    SIM_STATE_DIR="$signal_dir" \
    SIM_AUTH_SLEEP_SECONDS=2 \
    SUPABASE_URL='https://diagnostic.invalid' \
    SUPABASE_ANON_KEY=x SUPABASE_SERVICE_ROLE_KEY=y \
    APP_MODE=development ENABLE_REMOTE_BACKEND=true ENABLE_REAL_AUTH=true \
    ENABLE_REAL_DATA=false ALLOW_DEV_ROUTES=true \
    ENABLE_CONVERSATIONS_ROUTE=false \
    BACKEND_TARGET_ENVIRONMENT=development \
    REMOTE_CONTEXT_AUTHORIZATION_MODE=FOUNDER_AUTHORIZED \
    REMOTE_PROJECT_CONFIRMED=CONFIRMED \
    DEVELOPMENT_OPERATOR_CONFIRMED=CONFIRMED \
    FOUNDER_AUTHORIZATION_REFERENCE=fake \
    AUTHORIZED_COMMIT_SHA="$(git rev-parse HEAD)" \
    AUTHORIZED_COMMIT_MATCHES_HEAD=CONFIRMED \
    DEPLOYMENT_MANIFEST_RUNTIME_APPROVAL=APPROVED \
    REMOTE_FIXTURE_MANIFEST_RUNTIME_APPROVAL=APPROVED \
    REMOTE_CLEANUP_PREFLIGHT=PASS \
    DEVELOPMENT_ALLOWED_WEB_ORIGIN='https://diagnostic.invalid' \
    REMOTE_REQUIRED_CONFIGURATION=CONFIRMED \
    REMOTE_SECRET_NAMES_ACKNOWLEDGED=CONFIRMED \
    REMOTE_FIXTURE_RUN_ALIAS=diagnostic-run-04 \
    REMOTE_RUNNER_EXECUTION_MODE=diagnostic-only \
    scripts/run_development_remote_fixture_test.sh --authorized-development-run \
    >"$signal_output" 2>&1 &
signal_pid=$!
for _ in {1..100}; do
  [ -f "$signal_dir/auth-request-started" ] && break
  sleep 0.1
done
test -f "$signal_dir/auth-request-started"
kill -TERM "$signal_pid"
set +e
wait "$signal_pid"
set -e
grep -q 'FAILED_CLEAN' "$signal_output"

echo 'SAFE_REMOTE_RUNNER_SIMULATIONS_PASS'

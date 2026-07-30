#!/usr/bin/env bash
set -euo pipefail

# Inert unless the explicit operator flag and every multifactor input pass.
test "${1:-}" = "--authorized-development-run" || exit 64
for command in dart git supabase; do command -v "$command" >/dev/null; done

required=(
  SUPABASE_URL SUPABASE_ANON_KEY SUPABASE_SERVICE_ROLE_KEY
  SUPABASE_PROJECT_REF APP_MODE BACKEND_TARGET_ENVIRONMENT
  DEVELOPMENT_OPERATOR DEVELOPMENT_ALLOWED_WEB_ORIGIN
  ENABLE_REMOTE_BACKEND ENABLE_REAL_AUTH ENABLE_REAL_DATA
  ALLOW_DEV_ROUTES ENABLE_CONVERSATIONS_ROUTE
  REMOTE_CONTEXT_AUTHORIZATION_MODE REMOTE_PROJECT_CONFIRMED
  DEVELOPMENT_OPERATOR_CONFIRMED FOUNDER_AUTHORIZATION_REFERENCE
  AUTHORIZED_COMMIT_SHA AUTHORIZED_COMMIT_MATCHES_HEAD
  DEPLOYMENT_MANIFEST_RUNTIME_APPROVAL
  REMOTE_FIXTURE_MANIFEST_RUNTIME_APPROVAL REMOTE_CLEANUP_PREFLIGHT
  REMOTE_REQUIRED_CONFIGURATION REMOTE_SECRET_NAMES_ACKNOWLEDGED
  REMOTE_FIXTURE_RUN_ALIAS REMOTE_RUNNER_EXECUTION_MODE
  SECOND_FUNCTIONAL_ATTEMPT_MANIFEST_VERSION REMOTE_RUNNER_VERSION
  SECOND_FUNCTIONAL_ATTEMPT_AUTHORIZATION_STATUS
  RETENTION_LIMITATION_ACKNOWLEDGED
)
for name in "${required[@]}"; do test -n "${!name:-}" || exit 65; done

test "$APP_MODE" = development
test "$BACKEND_TARGET_ENVIRONMENT" = development
test "$ENABLE_REMOTE_BACKEND" = true
test "$ENABLE_REAL_AUTH" = true
test "$ENABLE_REAL_DATA" = false
test "$ALLOW_DEV_ROUTES" = true
test "$ENABLE_CONVERSATIONS_ROUTE" = false
test "$REMOTE_CONTEXT_AUTHORIZATION_MODE" = FOUNDER_AUTHORIZED
test "$REMOTE_PROJECT_CONFIRMED" = CONFIRMED
test "$DEVELOPMENT_OPERATOR_CONFIRMED" = CONFIRMED
test "$AUTHORIZED_COMMIT_MATCHES_HEAD" = CONFIRMED
test "$DEPLOYMENT_MANIFEST_RUNTIME_APPROVAL" = APPROVED
test "$REMOTE_FIXTURE_MANIFEST_RUNTIME_APPROVAL" = APPROVED
test "$REMOTE_CLEANUP_PREFLIGHT" = PASS
test "$REMOTE_REQUIRED_CONFIGURATION" = CONFIRMED
test "$REMOTE_SECRET_NAMES_ACKNOWLEDGED" = CONFIRMED
test "$REMOTE_RUNNER_EXECUTION_MODE" = second-functional-attempt
test "$SECOND_FUNCTIONAL_ATTEMPT_MANIFEST_VERSION" = \
  FOUNDATION-019A-SECOND-FUNCTIONAL-ATTEMPT-v5
test "$REMOTE_RUNNER_VERSION" = FOUNDATION-019A-R2I-RUNNER-v1
test "$SECOND_FUNCTIONAL_ATTEMPT_AUTHORIZATION_STATUS" = GRANTED_AT_RUNTIME
test "$RETENTION_LIMITATION_ACKNOWLEDGED" = \
  POST_DEVELOPMENT_OPERATIONAL_BLOCKER
test "$(git rev-parse HEAD)" = "$AUTHORIZED_COMMIT_SHA"
test "$(git rev-parse HEAD)" = "$(git rev-parse origin/main)"
test -z "$(git status --short)"
[[ "$REMOTE_FIXTURE_RUN_ALIAS" =~ ^[a-z0-9][a-z0-9-]{7,31}$ ]]
[[ "$SUPABASE_PROJECT_REF" =~ ^[a-z]{20}$ ]]

dart run tool/check_supabase_remote_context.dart >/dev/null
dart run tool/check_development_remote_preparation.dart \
  --validate-cors >/dev/null
test "$(dart run tool/development_complete_functional_runner.dart \
  --validate-contract | tail -n 1)" = EXECUTABLE_RUNNER_CONTRACT_COMPLETE

tmp_dir="$(mktemp -d /tmp/stasisly-foundation-019a-r2d.XXXXXX)"
chmod 700 "$tmp_dir"
isolate_cli() {
  rm -f supabase/.temp/project-ref supabase/.temp/pooler-url
  rm -rf "$tmp_dir"
  dart run tool/check_supabase_remote_context.dart >/dev/null || true
}
trap isolate_cli EXIT INT TERM

# First remote action. The authorization is consumed here.
supabase link --project-ref "$SUPABASE_PROJECT_REF" \
  >"$tmp_dir/link.stdout" 2>"$tmp_dir/link.stderr"
test -f supabase/.temp/project-ref
test "$(tr -d '\r\n' <supabase/.temp/project-ref)" = "$SUPABASE_PROJECT_REF"
rm -f "$tmp_dir/link.stdout" "$tmp_dir/link.stderr"
echo REMOTE_TARGET_VERIFIED_DEVELOPMENT

dart run tool/development_complete_functional_runner.dart \
  --authorized-development-run

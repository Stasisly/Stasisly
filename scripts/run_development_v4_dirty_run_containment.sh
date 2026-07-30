#!/usr/bin/env bash
set -euo pipefail

readonly manifest_version="FOUNDATION-019A-V4-DIRTY-RUN-CONTAINMENT-v1"
readonly runner_version="FOUNDATION-019A-R2H-CONTAINMENT-RUNNER-v1"
readonly failed_authorization="FA-019A-RETRY-20260729-008"

if [[ "${1:-}" != "--authorized-v4-containment-run" || "$#" -ne 1 ]]; then
  printf '%s\n' "V4 dirty-run containment wrapper blocked." >&2
  exit 64
fi

required=(
  APP_MODE BACKEND_TARGET_ENVIRONMENT SUPABASE_PROJECT_REF SUPABASE_URL
  SUPABASE_SERVICE_ROLE_KEY FOUNDER_AUTHORIZATION_ARTIFACT
  FAILED_RUN_AUTHORIZATION_REFERENCE FAILED_RUN_ALIAS
  FAILED_RUN_V4_MANIFEST_VERSION FAILED_RUN_V4_RUNNER_VERSION
  V4_CONTAINMENT_MANIFEST_VERSION V4_CONTAINMENT_RUNNER_VERSION
  FUNCTIONAL_RUNNER_DISABLED AUTH_CREATION_DISABLED
  CONVERSATION_CREATION_DISABLED MESSAGE_CREATION_DISABLED
  IDEMPOTENCY_REPLAY_DISABLED CATALOG_MUTATION_DISABLED
  SPECIALIST_MUTATION_DISABLED EXACT_LOOKUPS_ONLY BROAD_LOOKUPS_BLOCKED
  SEVEN_COUNTERS_REQUIRED CONVERSATION_AWARE_CONTAINMENT
  CANONICAL_RESOURCES_PROTECTED POST_DELETE_COUNTERS_REQUIRED
  CLI_ISOLATION_REQUIRED RETENTION_LIMITATION_ACKNOWLEDGED
)

for name in "${required[@]}"; do
  if [[ -z "${!name:-}" ]]; then
    printf '%s\n' "V4 dirty-run containment runtime input blocked." >&2
    exit 65
  fi
done

if [[ "$APP_MODE" != "development" ||
      "$BACKEND_TARGET_ENVIRONMENT" != "development" ||
      "$FAILED_RUN_AUTHORIZATION_REFERENCE" != "$failed_authorization" ||
      "$V4_CONTAINMENT_MANIFEST_VERSION" != "$manifest_version" ||
      "$V4_CONTAINMENT_RUNNER_VERSION" != "$runner_version" ]]; then
  printf '%s\n' "V4 dirty-run containment contract blocked." >&2
  exit 65
fi

cleanup_cli_context() {
  rm -f supabase/.temp/project-ref supabase/.temp/pooler-url
  dart run tool/check_supabase_remote_context.dart >/dev/null
}
trap cleanup_cli_context EXIT

dart run tool/check_supabase_remote_context.dart >/dev/null
dart run tool/development_v4_dirty_run_containment_runner.dart \
  --authorized-v4-containment-run

#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$repo_root"

tmp_dir="$(mktemp -d /tmp/stasisly-r2d-canary.XXXXXX)"
chmod 700 "$tmp_dir"
trap 'rm -rf "$tmp_dir"' EXIT INT TERM

dart run tool/development_complete_runner_simulation.dart \
  >"$tmp_dir/stdout" 2>"$tmp_dir/stderr"
grep -q 'COMPLETE_DEVELOPMENT_RUNNER_SIMULATION_PASS$' "$tmp_dir/stdout"

for canary in \
  FAKE_SERVICE_ROLE_DO_NOT_LOG \
  FAKE_ACCESS_TOKEN_DO_NOT_LOG \
  FAKE_USER_EMAIL_DO_NOT_LOG \
  FAKE_PASSWORD_DO_NOT_LOG \
  FAKE_AUTH_ID_DO_NOT_LOG \
  FAKE_CONVERSATION_ID_DO_NOT_LOG \
  FAKE_PROJECT_REF_DO_NOT_LOG \
  FAKE_MESSAGE_CONTENT_DO_NOT_LOG; do
  ! grep -FRq "$canary" "$tmp_dir"
done

printf '%s\n' COMPLETE_DEVELOPMENT_RUNNER_SIMULATION_PASS

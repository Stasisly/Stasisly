#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$repo_root"

bash test/scripts/reproduce_historical_remote_runner_status_failure.sh \
  >/dev/null
bash test/scripts/test_development_remote_http_contract.sh >/dev/null
bash test/scripts/run_complete_development_runner_simulation.sh >/dev/null
contract="$(
  dart run tool/development_complete_functional_runner.dart --validate-contract
)"
grep -q 'EXECUTABLE_RUNNER_CONTRACT_COMPLETE$' <<<"$contract"

echo SAFE_REMOTE_RUNNER_SIMULATIONS_PASS

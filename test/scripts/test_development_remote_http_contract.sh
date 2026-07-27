#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$repo_root"
# shellcheck source=scripts/lib/development_remote_http_contract.sh
source scripts/lib/development_remote_http_contract.sh

tmp_dir="$(mktemp -d /tmp/stasisly-r2b-http-contract.XXXXXX)"
server_pid=''
cleanup() {
  if [ -n "$server_pid" ]; then
    kill "$server_pid" >/dev/null 2>&1 || true
    wait "$server_pid" >/dev/null 2>&1 || true
  fi
  rm -rf "$tmp_dir"
}
trap cleanup EXIT INT TERM

assert_status_rejected() {
  local name=$1 value=$2
  local file="$tmp_dir/$name.status"
  printf '%s' "$value" >"$file"
  if strict_http_status_from_file "$file" >/dev/null; then
    return 1
  fi
}

printf '200' >"$tmp_dir/plain.status"
test "$(strict_http_status_from_file "$tmp_dir/plain.status")" = 200
printf ' 200 \r\n' >"$tmp_dir/whitespace.status"
test "$(strict_http_status_from_file "$tmp_dir/whitespace.status")" = 200
assert_status_rejected build-output '200build-output'
assert_status_rejected prefixed 'status=200'
assert_status_rejected protocol 'HTTP/2 200'
assert_status_rejected multiple $'200\n201'
assert_status_rejected empty ''

port_file="$tmp_dir/port"
dart run tool/foundation_019a_r2b_local_http_server.dart "$port_file" \
  >"$tmp_dir/build.stdout" 2>"$tmp_dir/build.stderr" &
server_pid=$!
for _ in {1..100}; do
  [ -s "$port_file" ] && break
  sleep 0.05
done
test -s "$port_file"
port="$(tr -d '\r\n' <"$port_file")"

export SUPABASE_SERVICE_ROLE_KEY=FAKE_SERVICE_ROLE_DO_NOT_LOG
printf 'Running build hooks...' >"$tmp_dir/separate-build.stdout"
printf 'Running build hooks...' >"$tmp_dir/separate-build.stderr"
capture_http_channels POST "http://127.0.0.1:$port/synthetic-user" \
  '{"synthetic":true}' "$tmp_dir/body.json" FAKE_ACCESS_TOKEN_DO_NOT_LOG \
  "$tmp_dir/metadata" "$tmp_dir/diagnostic" "$tmp_dir/transport"
test "$(strict_transport_exit_from_file "$tmp_dir/transport")" = 0
parse_curl_metadata "$tmp_dir/metadata" "$tmp_dir/status" \
  "$tmp_dir/content-type" "$tmp_dir/duration"
test "$(strict_http_status_from_file "$tmp_dir/status")" = 200
[[ "$(cat "$tmp_dir/content-type")" == application/json* ]]
test "$(jq -r type "$tmp_dir/body.json")" = object
test ! -s "$tmp_dir/diagnostic"

for canary in \
  FAKE_SERVICE_ROLE_DO_NOT_LOG \
  FAKE_ACCESS_TOKEN_DO_NOT_LOG \
  FAKE_USER_EMAIL_DO_NOT_LOG \
  FAKE_PASSWORD_DO_NOT_LOG \
  FAKE_USER_ID_DO_NOT_LOG \
  FAKE_PROJECT_REF_DO_NOT_LOG; do
  ! grep -R -Fq "$canary" \
    "$tmp_dir/separate-build.stdout" \
    "$tmp_dir/separate-build.stderr" \
    "$tmp_dir/metadata" \
    "$tmp_dir/diagnostic" \
    "$tmp_dir/status" \
    "$tmp_dir/content-type" \
    "$tmp_dir/duration"
done

echo 'DEVELOPMENT_REMOTE_HTTP_CHANNEL_CONTRACT_PASS'

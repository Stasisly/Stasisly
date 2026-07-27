#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$repo_root"

tmp_dir="$(mktemp -d /tmp/stasisly-r2b-historical-status.XXXXXX)"
server_pid=''
cleanup() {
  if [ -n "$server_pid" ]; then
    kill "$server_pid" >/dev/null 2>&1 || true
    wait "$server_pid" >/dev/null 2>&1 || true
  fi
  rm -rf "$tmp_dir"
}
trap cleanup EXIT INT TERM

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
[[ "$port" =~ ^[0-9]+$ ]]

response_body="$tmp_dir/body.json"
historical_status="$(
  printf 'Running build hooks...'
  printf 'Running build hooks...' >&2
  curl -sS -o "$response_body" -w '%{http_code}' \
    "http://127.0.0.1:$port/synthetic-user"
)"

test "$historical_status" != 200
test "$historical_status" = 'Running build hooks...200'
test "$(jq -r 'type' "$response_body")" = object
body_size="$(wc -c <"$response_body" | tr -d ' ')"
test "$body_size" -ge 256
test "$body_size" -le 1023

echo 'HISTORICAL_RUNNER_FAILURE_REPRODUCED_LOCALLY'

#!/usr/bin/env bash

# This file is sourced by the Development runner. It intentionally emits no
# request data, response data, target details or credentials.

strict_http_status_from_file() {
  local status_file=$1 line='' extra='' normalized=''
  [ -f "$status_file" ] || return 1
  [ "$(wc -c <"$status_file" | tr -d ' ')" -le 16 ] || return 1

  IFS= read -r line <"$status_file" || [ -n "$line" ] || return 1
  if IFS= read -r extra < <(tail -n +2 "$status_file") || [ -n "$extra" ]; then
    return 1
  fi
  line="${line%$'\r'}"
  normalized="$line"
  while [[ "$normalized" == ' '* || "$normalized" == $'\t'* ]]; do
    normalized="${normalized:1}"
  done
  while [[ "$normalized" == *' ' || "$normalized" == *$'\t' ]]; do
    normalized="${normalized:0:${#normalized}-1}"
  done
  [[ "$normalized" =~ ^[1-5][0-9][0-9]$ ]] || return 1
  printf '%s' "$normalized"
}

strict_transport_exit_from_file() {
  local transport_file=$1 value=''
  [ -f "$transport_file" ] || return 1
  IFS= read -r value <"$transport_file" || [ -n "$value" ] || return 1
  [[ "$value" =~ ^[0-9]+$ ]] || return 1
  [ "$value" -le 255 ] || return 1
  printf '%s' "$value"
}

parse_curl_metadata() {
  local metadata_file=$1 status_file=$2 content_type_file=$3 duration_file=$4
  local status='' content_type='' duration='' extra=''
  [ -f "$metadata_file" ] || return 1
  [ "$(wc -c <"$metadata_file" | tr -d ' ')" -le 512 ] || return 1
  IFS=$'\t' read -r status content_type duration <"$metadata_file" ||
    [ -n "$status" ] || return 1
  [ -n "$status" ] || return 1
  [ -n "$duration" ] || return 1
  [[ "$duration" =~ ^[0-9]+([.][0-9]+)?$ ]] || return 1
  if IFS= read -r extra < <(tail -n +2 "$metadata_file") || [ -n "$extra" ]; then
    return 1
  fi
  printf '%s' "$status" >"$status_file"
  printf '%s' "$content_type" >"$content_type_file"
  printf '%s' "$duration" >"$duration_file"
}

capture_http_channels() {
  local method=$1 url=$2 body=$3 response_body_file=$4 token=$5
  local metadata_file=$6 diagnostic_file=$7 transport_file=$8
  local transport_exit=0
  local args=(-sS -o "$response_body_file"
    -w $'%{http_code}\t%{content_type}\t%{time_total}'
    -X "$method"
    -H "apikey: $SUPABASE_SERVICE_ROLE_KEY"
    -H "Authorization: Bearer $token"
    -H 'Content-Type: application/json')
  if [ -n "$body" ]; then args+=(-d "$body"); fi

  : >"$response_body_file"
  : >"$metadata_file"
  : >"$diagnostic_file"
  chmod 600 "$response_body_file" "$metadata_file" "$diagnostic_file"
  if curl "${args[@]}" "$url" >"$metadata_file" 2>"$diagnostic_file"; then
    transport_exit=0
  else
    transport_exit=$?
  fi
  printf '%s\n' "$transport_exit" >"$transport_file"
  chmod 600 "$transport_file"
}

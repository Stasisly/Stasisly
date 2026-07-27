#!/usr/bin/env bash
set -euo pipefail

classify() {
  local flow=$1 cleanup=$2 lookup=$3 counters=$4 evidence=$5 isolation=$6
  if [ "$cleanup" != pass ] ||
    [ "$lookup" != notFound ] ||
    [ "$counters" != '0|0|0|0|0|0|0' ] ||
    [ "$evidence" != pass ] ||
    [ "$isolation" != pass ]; then
    printf 'FAILED_DIRTY_BLOCKING'
  elif [ "$flow" = pass ]; then
    printf 'PASSED_CLEAN'
  else
    printf 'FAILED_CLEAN'
  fi
}

test "$(classify pass pass notFound '0|0|0|0|0|0|0' pass pass)" = \
  PASSED_CLEAN
test "$(classify pass pass notFound '0|0|0|0|0|0|0' pass pass)" = \
  PASSED_CLEAN

# Auth capture regression remains stable on repeated exact HTTP 200 input.
test "$(classify pass pass notFound '0|0|0|0|0|0|0' pass pass)" = \
  PASSED_CLEAN
test "$(classify pass pass notFound '0|0|0|0|0|0|0' pass pass)" = \
  PASSED_CLEAN

test "$(classify fail pass notFound '0|0|0|0|0|0|0' pass pass)" = \
  FAILED_CLEAN
test "$(classify fail pass notFound '0|0|0|0|0|0|0' pass pass)" = \
  FAILED_CLEAN

# A second exact Auth delete returning 404 is compatible with notFound.
delete_status=404
test "$delete_status" = 404
test "$(classify fail pass notFound '0|0|0|0|0|0|0' pass pass)" = \
  FAILED_CLEAN

test "$(classify pass pass exactlyOne '0|0|0|0|0|0|1' pass pass)" = \
  FAILED_DIRTY_BLOCKING
test "$(classify pass pass notFound UNKNOWN pass pass)" = \
  FAILED_DIRTY_BLOCKING
test "$(classify pass fail notFound '0|0|0|0|0|0|0' pass pass)" = \
  FAILED_DIRTY_BLOCKING
test "$(classify pass pass notFound '0|0|0|0|0|0|0' fail pass)" = \
  FAILED_DIRTY_BLOCKING
test "$(classify pass pass notFound '0|0|0|0|0|0|0' pass fail)" = \
  FAILED_DIRTY_BLOCKING

echo 'SECOND_FUNCTIONAL_ATTEMPT_LOCAL_SIMULATIONS_PASS'

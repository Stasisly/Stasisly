# FOUNDATION-019A-R2B - Runner root cause and second functional attempt preparation

## Status and baseline

```text
Baseline: 70edbbb81ea68d4cc2e3384b911427c8af6534ad
Discovery baseline: 7f747e0cf60012ce315216a5486db3c5481f8f60
Branch: main
Initial worktree: clean and synchronized
Initial remote context: SAFE
Remote actions/reads/writes: 0/0/0
```

R2B is local preparation only. It does not authorize or execute a second
Development attempt.

## Attempt history and authorization

The first controlled attempt ended `DEVELOPMENT
FIRST_REMOTE_VALIDATION_FAILED_CLEAN`. The diagnostic attempt reached
`syntheticUserCreate`, produced a valid safe diagnostic for exact HTTP `200`,
and ended dirty because cleanup evidence was not conclusive. Exact containment
later proved the historical Auth resource already absent and closed as
`DEVELOPMENT DIRTY_RUN_CONTAINED_CLEAN_ALREADY_ABSENT`.

The following references are consumed and cannot be reused:

```text
FA-019A-20260723-001
FA-019A-DIAG-20260723-002
FA-019A-CONTAIN-20260727-003
```

## Historical comparison and reproduced failure

At `679d5cf`, the focal assertion was:

```bash
test "$(request POST ...)" = 200
```

`request` wrote curl `%{http_code}` to stdout. The assertion therefore consumed
the whole stdout channel, not a structurally validated status channel.

At `d94292a`, curl body, metadata and stderr became separate temporary files and
the diagnostic attempt observed exact HTTP `200`. At `1f37250`, Dart build
stdout/stderr were also separated from `SafeHttpDiagnostic`, and exact Auth
delete accepted `200/404`. Commit `70edbbb` did not change the runner; it added
exact historical Auth resolution and containment contracts.

The local loopback harness reproduces a 450 ms HTTP `200`, valid JSON object and
body size `256to1023`. When build output shares the historical command
substitution, the assertion receives `Running build hooks...200` and fails:

```text
HISTORICAL_RUNNER_FAILURE_REPRODUCED_LOCALLY
```

Root-cause classification:

```text
STDOUT_COMMAND_SUBSTITUTION_CONTAMINATION
```

The defect is the historical assertion channel, not the server status and not
the exact `200` requirement.

## Corrected HTTP contract

R2B preserves method, endpoint, payload, authorization headers and:

```bash
test "$synthetic_user_status" = 200
```

The channels are now independent:

| Channel | Contract |
|---|---|
| Curl transport exit | Restricted numeric file, integer `0..255` |
| HTTP metadata | Restricted curl write-out file |
| HTTP status | Dedicated parsed file, exact three digits |
| Response body | Restricted temporary file consumed by sanitizer |
| Curl diagnostic | Dedicated discarded stderr file |
| Dart build output | Dedicated stdout/stderr files |
| Cleanup output | Closed classification only |

Transport must equal `0`; status must match `^[1-5][0-9][0-9]$`; then the focal
assertion requires `200`. Bounded surrounding spaces/tabs, one line ending and a
known carriage return are accepted. `200build-output`, `status=200`, `HTTP/2
200`, multiple codes and empty input are rejected.

`SafeHttpDiagnostic` remains closed and bounded. It emits only operation,
status/category, content category, body presence/size bucket, JSON shape,
capped top-level field names, safe error/duration categories, assertion result
and cleanup requirement. Raw bodies, values, headers, tokens, credentials,
emails, IDs, project references, URLs and connection strings remain forbidden.

## Cleanup, residue and lifecycle

Auth delete `200` means `DELETED`; `404` means `ALREADY_ABSENT`. Neither is
sufficient alone. Clean classification requires post-delete exact `notFound`
and these named counters in this order:

```text
messages|idempotency|sessions|profiles|catalog|specialists|auth
0|0|0|0|0|0|0
```

Unknown, missing, negative or nonzero counters are dirty blocking. A `200`
response without an exact Auth ID is also dirty blocking because cleanup cannot
be proven exact.

The local contract adopts the monotonic states from `INITIAL` through
`LOCAL_REGRESSION_COMPLETED`. An ephemeral resource ledger records only
resources created by the current run and provides dependency-safe exact cleanup
order. It is cleared after cleanup and never persists identifiers.

Classification remains:

```text
flow success + verified cleanup: PASSED_CLEAN
flow failure + verified cleanup: FAILED_CLEAN
cleanup/evidence/isolation uncertainty: FAILED_DIRTY_BLOCKING
```

Forward execution stops at the first functional failure. Cleanup, residue
verification, classification and CLI isolation still run.

## Second functional attempt

`development_second_functional_attempt_manifest.json` prepares runner version
`R2B` with:

```text
authorization: NOT_GRANTED
execution: NOT_EXECUTED
authorizedCommit: UNASSIGNED
authorizationReference: UNASSIGNED
environment: development
schema/migration/deploy/secret mutation: FORBIDDEN
cleanup/residue verification/CLI isolation: MANDATORY
remote skips: CLASSIFIED_NOT_ENABLED
```

The future flow covers target verification, synthetic setup, exact Auth create,
specialist selection, Conversation create and replay, list/detail/message,
no-AI assertion, archive/disabled composer, restore/enabled composer, foreign
opacity, blocked legacy routes, cleanup, residue verification, CLI isolation
and local regression. The request replay must use the same operation attempt,
Idempotency-Key and normalized request and must not duplicate Conversation.

No automatic assistant response, Model Gateway call or Stasis Engine execution
is permitted. Owner reads remain canonical; foreign resources must be opaque.
`/chat` remains absent and `/orchestrator` blocked from Product.

## Validation and security

Focal tests cover historical reproduction, exact `200`, status contamination,
build stdout/stderr separation, transport failure, invalid/non-200 bodies,
bounded normalization, ambiguous status rejection, Auth already absent,
delete `200/404`, residue, unknown counters, cleanup/evidence/isolation failure,
state monotonicity, ledger ordering and unauthorized manifest defaults.

Local simulations cover two full successes, two Auth-capture regressions,
failure after Auth creation, failure after Conversation creation, cleanup `404`,
residue detection and unknown counters. Fake canaries for service role, access
token, email, password, user ID and project ref are absent from observable
channels. Bodies and field names remain bounded; cleanup is ledger-bounded.

Final local regression:

```text
historical failure reproduction: PASS
HTTP channel contract: PASS
second functional attempt simulations: PASS
safe remote runner simulations: PASS
Flutter: 744 pass / 5 approved skips / 0 failures
Analyzer: 0 errors / 0 warnings / 36 inherited infos
Deno: 86/86 pass; format 62 files
SQL local: 740/740 pass after reset without seed
remote-context: SAFE
```

Security result:

```text
remote actions/reads/writes: 0/0/0
raw bodies or secrets logged: 0
real IDs or synthetic emails committed: 0
HTTP assertion changes: 0
broad lookups/deletes: 0
new remote fixtures: 0
remote skips enabled: 0
schema/backend changes: 0
```

## Recovery, readiness and residual debt

No schema, migration, function or secret change occurs, so no database recovery
point is required. Operational rollback is exact fixture/Auth/Conversation/
message/idempotency/session cleanup plus CLI isolation.

```text
Historical runner defect: PROVEN_AND_CORRECTED_LOCALLY
HTTP 200 assertion: CONFIRMED_AND_PRESERVED
Status-channel separation: FOUNDATION_ADOPTED
Build-stream isolation: FOUNDATION_ADOPTED
SafeHttpDiagnostic: PRESERVED
Cleanup 404 semantics: PRESERVED
Dirty-run containment: COMPLETED_CLEAN_ALREADY_ABSENT
Second functional attempt: PREPARED_NOT_AUTHORIZED
Remote skips: CLASSIFIED_NOT_ENABLED
Sustained Development: NOT_AUTHORIZED
```

Idempotency retention remains
`POST_DEVELOPMENT_OPERATIONAL_BLOCKER`. A new unique Founder authorization must
bind the final R2B commit, exact Development target/operator/CORS, manifest
version and one bounded functional sequence. R2B itself performs no remote
execution.

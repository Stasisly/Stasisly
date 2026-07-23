# FOUNDATION-019A-R2A - Safe remote runner diagnostics

## Status and baseline

- Baseline: `679d5cf test: harden Development remote execution preparation`.
- Discovery baseline: `7f747e0`.
- Branch: `main`, synchronized and clean before implementation.
- Remote context before implementation: `SAFE`.
- Scope: local diagnostic instrumentation, tests and documentation only.
- Remote actions, reads, calls and DNS lookups: `0`.

## R2 blocker and evidence gap

The first controlled Development attempt reached the synthetic auth-user create
request and ended `FAILED_CLEAN` at the exact `status == 200` assertion. Cleanup
completed with seven zero residue counters. No schema rollback was required.

FOUNDATION-019A-R2 reproduced the assertion locally but could not determine the
remote status, content type, response shape or safe error category. It therefore
closed as:

```text
FOUNDATION-019A-R2 BLOCKED_INSUFFICIENT_SANITIZED_EVIDENCE
ROOT_CAUSE_STILL_UNKNOWN
```

No raw body was read or retained from that attempt.

## Closed diagnostic contract

`tool/safe_http_diagnostic.dart` implements `SafeHttpDiagnostic`, mirrored by
`development/schemas/safe_http_diagnostic.schema.json`. Its observable fields
are:

```text
operation
statusCode
statusClass
contentTypeCategory
bodyPresence
bodySizeBucket
jsonParseStatus
topLevelFieldNames
safeErrorCategory
durationBucket
assertionOutcome
cleanupRequired
diagnosticSanitization
rawBodyLogged
```

Status classes are informational, success, redirect, client error, server error
or invalid. Content is reduced to JSON, problem JSON, text, HTML, empty, binary
or unknown. Body sizes are `0`, `1to255`, `256to1023`, `1kto4k` or `over4k`.
Duration uses six monotonic curl elapsed-time buckets from `under100ms` through
`over10s`.

JSON parsing records only object, array, scalar, invalid or not attempted. An
object contributes sorted, deduplicated top-level names only: maximum 20,
maximum 64 ASCII-safe characters each. Unsafe names become
`REDACTED_FIELD_NAME`; nested values are never traversed.

Error categories are closed: none, authentication/authorization/validation
rejection, conflict, rate limit, backend unavailable, unexpected response,
invalid JSON, transport failure, timeout or unknown failure.

## Forbidden evidence and output

Raw bodies, values, nested values, headers, header values, tokens, keys, emails,
passwords, raw IDs, project references, URLs, connection strings and stack
traces are forbidden. The output is bounded by
`SAFE_HTTP_DIAGNOSTIC_BEGIN/END`, always states `rawBodyLogged=false`, and never
falls back to raw content.

The response body exists only under a `mktemp` directory with mode `0700`.
Before sanitization, the runner may extract only the synthetic owner identifier
needed for exact cleanup. The sanitizer consumes and deletes the body before the
assertion. Curl stderr and metadata files are discarded without output.
Sanitizer failure emits only closed failure fields and stops.

## Runner behavior and unchanged assertion

The method, endpoint, payload, authentication headers and accepted status remain
unchanged. The exact assertion remains:

```bash
test "$synthetic_user_status" = 200
```

No generic `2xx`, `201`, `204` or fallback is accepted. A future invocation
must explicitly set `REMOTE_RUNNER_EXECUTION_MODE=diagnostic-only`. It emits the
safe block and stops immediately after the focal assertion, including on an
unexpected pass. Downstream specialist/profile/token setup and remote smoke
tests cannot execute in this mode.

The existing `EXIT INT TERM` trap, double cleanup, original exit preservation,
seven-zero residue check and `FAILED_CLEAN`/`FAILED_DIRTY_BLOCKING`
classification remain intact.

## Tests, canaries and simulations

Local tests cover two `200` objects, two `201` objects, `204`, `400`, `401`,
`403`, `409`, `429`, `500` HTML, invalid JSON, oversized/empty bodies, arrays,
scalars, timeout, transport failure, unusual/duplicate/excessive field names,
nested values and sanitizer failure. Existing lifecycle tests cover repeated
cleanup, partial setup, clean failure and dirty blocking.

Synthetic canaries for token, service role, email, password and project ref are
placed in simulated bodies. Tests prove they, URLs, bearer values and nested
values never enter diagnostic output. Architecture guards prohibit `set -x`,
verbose/trace curl, raw body output, assertion widening, continuation beyond the
diagnostic point, raw fallback, field-name overflow and remote execution
primitives in diagnostic tooling.

## Recovery and future diagnostic scope

```text
first attempt: FAILED_CLEAN
schema change during diagnostic retry: none
recovery-point requirement: NOT_REQUIRED_NO_SCHEMA_CHANGE
function deployment: not authorized
secret/config change: not authorized
fixture setup: allowed only through focal assertion
cleanup: mandatory on success and failure
```

A future evidence block may retain only the safe diagnostic fields, cleanup
result and seven residue counters outside the repository, associated with a
non-sensitive attempt reference. It may not retain `.env`, runner logs or raw
target content.

## Security, rollback and readiness

No Development request, Supabase remote command, remote SQL, migration, deploy,
secret change, real data, staging, production, IA or Stasis Engine action occurs
in R2A. Remote skips remain classified and disabled. Rollback is the single R2A
commit; remote repair is unnecessary.

Local validation completed:

- focal unit and architecture tests: `26/26 PASS`;
- runner simulations: two `200`, two `201`, `401`, `409`, `500` HTML, invalid
  JSON, sanitizer failure, cleanup failure and `TERM`: `PASS`;
- Flutter: `704 PASS`, `5 APPROVED SKIPS`, `0 FAILURES`;
- analyzer: `0` errors, `36` inherited infos;
- Deno: format `62` files, tests `86/86 PASS`;
- SQL: local no-seed reset, `740/740 PASS`;
- remote-context before local backend work: `SAFE`;
- remote actions and secret canary leaks: `0`.

Foundation adoption after those local gates:

```text
Safe HTTP diagnostic contract: FOUNDATION_ADOPTED
Runner diagnostic instrumentation: FOUNDATION_ADOPTED_LOCALLY
Raw body logging: FORBIDDEN
Assertion: UNCHANGED
Root cause: UNKNOWN_PENDING_DIAGNOSTIC_RUN
Cleanup: PRESERVED_AND_VALIDATED
Diagnostic-only retry: READY_FOR_EXPLICIT_AUTHORIZATION
Remote functional retry: NOT_AUTHORIZED
Remote skips: CLASSIFIED_NOT_ENABLED
```

The next authorization must bind the new commit, exact Development target,
operator and Founder reference and permit only temporary link/verification,
focal setup, safe diagnostic capture, mandatory cleanup, CLI isolation and final
local regression.

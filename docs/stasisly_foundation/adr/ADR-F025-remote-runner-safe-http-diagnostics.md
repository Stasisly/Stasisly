# ADR-F025 - Remote runner safe HTTP diagnostics

## Status

```text
Decision: APPROVED
Implementation: IMPLEMENTED_LOCALLY
Remote diagnostic execution: NOT_AUTHORIZED
```

## Context

The first controlled Development attempt ended `FAILED_CLEAN` at the exact
synthetic user creation assertion. FOUNDATION-019A-R2 could not classify the
response because the prior evidence intentionally retained neither response
content nor a safe response shape. The HTTP status, content category and safe
top-level field names therefore remain unknown.

## Decision

1. Remote HTTP diagnostics are allowlisted by a closed `SafeHttpDiagnostic`.
2. Raw response bodies, headers and field values are never retained or logged.
3. Observation is limited to numeric status, closed status/content categories,
   body presence and size bucket, JSON shape, at most 20 validated top-level
   field names, closed error/duration categories and assertion outcome.
4. Strange field names become `REDACTED_FIELD_NAME`; nested values are never
   traversed.
5. The body is held only in a restricted temporary directory and the sanitizer
   removes it before the assertion.
6. Sanitizer failure is fail-closed, emits no raw fallback and stops execution.
7. The existing exact `status == 200` assertion remains unchanged until remote
   evidence exists.
8. A diagnostic retry stops at the focal assertion even if it passes. Cleanup
   remains mandatory, exact, repeated and dirty-run blocking.
9. Diagnostic authorization is commit-specific. This implementation performs
   zero remote actions.

## Consequences

The next package may request a diagnostic-only Founder authorization. It may
temporarily link and verify the exact Development target, execute setup only
through `syntheticUserCreate`, retain only the safe block outside the
repository, clean exactly and isolate CLI context. It may not migrate, deploy,
change secrets/configuration or run downstream smoke tests.

The root cause remains `UNKNOWN_PENDING_DIAGNOSTIC_RUN`. A successful
instrumentation test does not justify accepting `201`, generic `2xx` or any
other status.

## Validation and rollback

Unit tests cover status/content/body/JSON/error/duration classes, field-name
bounds, nested values, canaries, oversized input, transport errors and temporary
deletion. Architecture guards freeze the request, exact assertion, stop point,
trap, cleanup and shell leakage prohibitions. Full Flutter, Deno and SQL
regression remains required before adoption.

Rollback reverts the R2A commit. No remote repair is required because no remote
action occurs.

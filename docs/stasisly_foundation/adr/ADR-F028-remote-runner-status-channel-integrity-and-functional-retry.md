# ADR-F028 - Remote runner status-channel integrity and functional retry

## Status

```text
Decision: APPROVED
Implementation: IMPLEMENTED_LOCALLY
Remote execution: NOT_AUTHORIZED
```

## Context

The runner at `679d5cf` asserted HTTP status from a command substitution that
captured the entire stdout channel. A later safe diagnostic observed exact HTTP
`200`. A loopback reproduction proves that output preceding curl's write-out
turns the historical assertion input into a contaminated string even though the
response is valid.

## Decision

1. Curl process exit, HTTP status, response body, curl diagnostics and build
   output are separate channels.
2. Transport exit must be numeric and zero before status interpretation.
3. HTTP status must be a structurally valid single three-digit code before any
   semantic assertion.
4. `syntheticUserCreate` continues to require exact HTTP `200`; generic `2xx`,
   `201` and `204` are not accepted.
5. Build hooks cannot feed status, JSON, diagnostic evidence or counters.
6. `SafeHttpDiagnostic` remains closed, bounded and free of raw values.
7. Exact Auth cleanup accepts delete `200` and already-absent `404`.
8. Clean classification still requires post-delete exact `notFound` and seven
   named zero counters.
9. The runner uses monotonic states and an ephemeral current-run ledger.
10. A functional retry requires a new unique, commit-specific Founder
    authorization consumed on its first remote action.
11. R2B performs zero remote actions and leaves remote classified tests
    disabled.

## Consequences

Ambiguous or contaminated statuses fail closed instead of being normalized into
success. A response that may have created Auth but does not provide an exact
cleanup ID is dirty blocking. The second functional attempt is prepared but
cannot run from this ADR or its manifest.

## Validation and rollback

Historical and fixed channel harnesses use only loopback HTTP. Contract tests
cover status structure, transport, build isolation, diagnostics, cleanup
`200/404`, named counters, state transitions, ledger behavior, classifications
and unauthorized manifest defaults. The completed local regression records
Flutter 744 pass with five approved skips and no failures, analyzer with no
errors or warnings, Deno 86/86, and SQL 740/740 after a no-seed reset.

Rollback reverts the R2B commit. No remote rollback is required because R2B
does not contact Development.

# ADR-RF047: Iterative Engineering Loops Preserve Tests and Evidence

## Status

Decision: `APPROVED`

Implementation:

```text
DOCUMENTARY_PROMPTS_IMPLEMENTED
DEVELOPMENT_SURFACE_NOT_IMPLEMENTED
RUNNERS_NOT_IMPLEMENTED
RUNTIME_NOT_IMPLEMENTED
AGENTS_NOT_AVAILABLE
```

## Decision

Authorized work follows inspect, plan, implement, test, diagnose, correct and retest until ready or genuinely blocked. Assertions and gates are never weakened to fabricate success.

## Consequences

Loops are bounded, preserve sanitized evidence and stop for authorization, destructive risk or exhausted safe iteration. No runner is created here.

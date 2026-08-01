# ADR-RF049: Environment Promotion Requires Gates and Authorization

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

Promotion across local, Development, staging and production requires exact target, commit, operator, manifests, tests, security checks, rollback and authorization.

## Consequences

Passing local checks never grants remote action. Wave 5 creates no deployment, environment, secret or pipeline mutation.

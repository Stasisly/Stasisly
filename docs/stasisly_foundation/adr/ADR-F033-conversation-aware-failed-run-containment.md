# ADR-F033 - Conversation-aware failed-run containment

## Status

```text
Decision: APPROVED
Implementation: IMPLEMENTED_LOCALLY
```

## Context

The v4 Development attempt reached `CONVERSATION_CREATED`, then entered cleanup
before idempotency replay was validated. Cleanup completed and exact Auth
absence was confirmed, but the seven run-scoped counters were not all verified
as zero. Cleanup completion therefore cannot establish a clean remote state.

The consumed functional authorization cannot be reused, and R2H is prohibited
from performing remote work. A separate local mechanism is required before a
new exact containment authorization can be considered.

## Decision

1. A run that reached Conversation creation requires Conversation-aware
   containment.
2. Cleanup completion alone does not prove residue zero.
3. All seven counters remain mandatory before and after containment.
4. Lookups and deletes are exact, bounded and scoped to the failed run.
5. Conversation ownership requires exact owner and Conversation handles.
6. Idempotency uses the canonical operation identifier and exact key.
7. Missing, ambiguous, malformed, foreign or unscoped evidence fails closed.
8. Messages precede idempotency, Conversation/session, profile and Auth in the
   dependency-safe deletion order.
9. Canonical catalog and specialist resources are immutable and never receive
   delete handles.
10. A functional retry stays blocked until a separately authorized execution
    proves the exact seven-zero vector.
11. R2H performs no remote action and grants no remote authorization.

## Consequences

- `FOUNDATION-019A-V4-DIRTY-RUN-CONTAINMENT-v1` becomes the containment
  manifest originally approved by this ADR.
- `FOUNDATION-019A-R2H-CONTAINMENT-RUNNER-v1` becomes the R2H entry point
  originally approved by this ADR.
- The consumed v4 authorization remains historical and non-reusable.
- The remote failure category remains `UNKNOWN_POST_CREATE_FAILURE` until exact
  evidence proves a narrower category.
- Loss of every exact identity source produces
  `BLOCKED_INSUFFICIENT_EXACT_LOOKUP`; no broad discovery is allowed.
- The general idempotency retention policy remains unresolved.

ADR-F035 subsequently versions the executable authorization boundary to
containment manifest v2 and R2H runner v2. Counter, diagnosis, containment and
canonical-protection semantics from this ADR remain unchanged.

## Validation

Identity, counters, Conversation, idempotency, canonical protection, isolation
and eleven local simulation scenarios are mandatory. Full Flutter, Deno, local
SQL and remote-context regression must pass before publication.

## Security

R2H permits no remote action, functional execution, resource creation, broad
lookup/delete, secret read, schema/backend change, migration, deploy, AI or
canonical mutation.

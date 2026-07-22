# ADR-F024 — Development remote fixture cleanup and execution gating

## Status

```text
Decision: APPROVED
Implementation: PREPARATION_IMPLEMENTED_LOCALLY
Remote execution: NOT_AUTHORIZED
```

## Context

The Development local fixture was intentionally local-only, while inherited
remote tests could create data without deterministic lifecycle evidence. Skip
activation and CORS were descriptive rather than executable contracts.

## Decision

1. Local and remote manifests are separate; local remains `localOnly=true`.
2. Remote fixtures are Development-only, synthetic, serial, versioned and bound
   to one exact runtime alias.
3. Exact, idempotent cleanup is mandatory after success, failure and partial
   setup and emits count-only evidence.
4. Dirty cleanup is `FAILED_DIRTY_BLOCKING` and prevents later runs.
5. Remote skips require eleven independent conditions; one flag or environment
   alone cannot enable them.
6. One exact approved Development HTTPS CORS origin is mandatory, never inferred
   from the Supabase URL, and wildcard CORS is forbidden.
7. Execution artifacts are versioned and authorization is commit-specific.
8. Idempotency retention remains a blocker for sustained Development operation.
9. This implementation performs no remote action.

## Consequences

Execution remains blocked while CORS is `UNASSIGNED` or any gate input is
absent. Operator-side cleanup may use a service credential; Flutter and evidence
may not. A new commit invalidates prior execution authorization.

## Validation and rollback

Unit and architecture contracts, no-network preflights and four local lifecycle
simulations validate the decision. Rollback removes the R1 commit; no remote
state exists to repair.

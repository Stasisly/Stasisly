# ADR-F029 - Executable functional runner completeness

## Status

```text
Decision: APPROVED
Implementation: IMPLEMENTED_LOCALLY
Remote execution: NOT_AUTHORIZED
```

## Context

The first second-attempt manifest and executable Development runner diverged.
Required functional stages could be represented as complete without an
executable request, evidence check, state transition or cleanup effect. The
attempt correctly stopped before remote access.

## Decision

1. A remote-attempt manifest and its executable runner must be equivalent.
2. Every required operation maps to one executable function and one tested,
   adjacent monotonic transition with closed evidence.
3. Required states cannot be skipped, repeated, reversed or mutated after the
   terminal state.
4. Idempotency replay requires equal operation attempt, key, normalized request
   and canonical result, plus exactly one attributable Conversation.
5. Owner lists use deterministic bounded pagination; list and detail compare
   backend-derived canonical resources.
6. Archive and restore require observed detail/list/capability state changes,
   not HTTP status alone.
7. Foreign-resource validation passes only an opaque not-found contract without
   metadata or existence oracle.
8. `/chat` and `/orchestrator` require executable, no-follow Product-host
   verification under closed result categories.
9. Cleanup is driven only by exact `CREATED_BY_RUN` ledger entries and followed
   by Auth absence and seven named zero counters.
10. Unknown ownership, residue, evidence or CLI isolation is dirty blocking.
11. Remote authorization is unique and commit-specific. An authorization bound
    to a prior SHA cannot be reused.
12. FOUNDATION-019A-R2D performs no remote execution and enables no remote skip.

## Consequences

The v2 manifest is the machine-readable operation source and
`FOUNDATION-019A-R2D-RUNNER-v1` is its executable counterpart. A future remote
attempt can start only after local contract validation and a new exact Founder
authorization. The stricter state and cleanup model may block more often; this
is intentional.

## Validation and rollback

Architecture guards, pure contract tests, lifecycle simulations and canaries
pass. The full regression records Flutter 783 pass with five approved skips,
analyzer 0 errors/0 warnings/36 inherited infos, Deno 86/86 and SQL 740/740
after a local no-seed reset. The implementation record and Session Tracker hold
the detailed evidence.

Rollback reverts the R2D commit. No remote recovery is necessary because this
decision was implemented and validated locally only.

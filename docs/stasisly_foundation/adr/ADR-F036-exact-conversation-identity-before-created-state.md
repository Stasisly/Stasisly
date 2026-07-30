# ADR-F036 - Exact Conversation identity before created state

## Status

```text
Decision: APPROVED
Implementation: IMPLEMENTED_LOCALLY
```

## Context

The v4 Development run reached `CONVERSATION_CREATED`, but its process-local
ledger did not durably preserve the exact Conversation, owner, run,
OperationAttemptId, cleanup and diagnostic handles as one integrity-bound
contract. Later containment could not safely prove or delete the resource
without broad reconstruction, so the run remains dirty blocking.

## Decision

1. `CONVERSATION_CREATED` requires a complete
   `CreatedConversationIdentity`.
2. Only `CREATE_CONFIRMED_WITH_EXACT_IDENTITY` permits that state.
3. Accepted, incomplete, malformed, pending or transport-ambiguous responses
   stop forward execution.
4. Owner, run, OperationAttemptId, normalized-request fingerprint,
   environment and `CREATED_BY_RUN` ownership are mandatory.
5. The in-memory resource entry is created before persistence.
6. The ephemeral ledger is atomically persisted and verified before the state
   transition.
7. Cleanup and diagnostics consume the same identity contract and exact
   handles.
8. Broad reconstruction by list, date window, email, profile or first match is
   forbidden.
9. The run ledger lives under ignored `.runtime/runs/`, uses `0700` directories,
   `0600` files, canonical JSON and SHA-256 integrity.
10. Ledger payloads bind authorization reference, commit, manifest, runner,
    environment and run.
11. Lifecycle transitions are monotonic and a closed ledger cannot reopen.
12. No secret, email, token, key, JWT or Conversation/Message content is stored
    or printed.
13. Historical runs without exact identity remain
    `LEGACY_DIRTY_RUN_MISSING_EXACT_CONVERSATION_IDENTITY`.
14. Functional manifest v5 and runner R2I-v1 replace v4/R2G for any future
    authorization.
15. R2I performs no remote action and grants no remote authorization.

## Consequences

- A successful remote create cannot be reported as created until exact cleanup
  and diagnostic identity survives process interruption.
- One exact idempotent replay is permitted after transport ambiguity; failure
  remains dirty blocking.
- Cleanup no longer reconstructs Conversation identity from mutable context.
- New containment can consume the shared contract; historical v4 compatibility
  remains fail-closed.
- Operational opaque handles are locally recoverable under restrictive
  permissions. Hashing protects integrity but is not encryption.
- The historical v4 dirty run is not cleaned or reclassified by this decision.

## Validation

Response, identity, state-order, ledger, lifecycle, cleanup, diagnostic,
interruption and architecture tests are mandatory together with full Flutter,
Deno, local SQL and remote-context regression before publication.

## Rollback

Revert the R2I package commit as one local unit. Do not restore v4/R2G as an
authorized runner, execute remote cleanup or reinterpret historical evidence
during rollback.

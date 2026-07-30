# ADR-F037 - Exact recovery of legacy Conversation identity

## Status

```text
Decision: APPROVED
Implementation: IMPLEMENTED_LOCALLY
Remote execution: FORBIDDEN
Recovery gate: BLOCKED_NO_EXACT_HISTORICAL_KEY
```

## Context

The v4 Development run reached `CONVERSATION_CREATED`, but did not durably
preserve its Conversation, owner and run handles. R2I fixes future runs and
cannot manufacture historical evidence. ArtifactV2 proves the failed-run
context but intentionally contains no aliases or resource identifiers.

The idempotency record was previously observed as exactly zero. Its absence
does not prove that the independently created Conversation is absent.

## Decision

1. Legacy recovery requires one exact, bounded key supported by a complete
   backend contract.
2. Identity and ownership are separate proofs. Exact owner, run and failed-run
   bindings are mandatory.
3. Broad, temporal, owner-only, ordered, first-result and paginated discovery
   are forbidden.
4. Existence requires exactly one matching non-canonical, run-owned resource.
5. Absence requires an exhaustive exact zero; errors and partial responses are
   never absence.
6. The first valid recovery execution will be diagnostic-only. Delete requires
   a later independent Founder authorization.
7. Messages and sessions remain unknown until Conversation identity or absence
   is exactly proven.
8. Future R2I ledgers cannot be treated as historical v4 evidence.
9. The current manifest has no selected strategy, no permitted query, request
   budget zero and delete disabled.
10. R2J performs no remote action and does not classify the dirty run clean.

## Evidence

The sanitized `.runtime` inventory contains one integrity-valid consumed
ArtifactV2 with the expected seven-field `subject_run`, plus sanitized audit and
proposal artifacts. None contains a Conversation handle, owner handle or run
alias.

The local schema supports exact lookup by canonical ID and exact idempotency
triple, but the required historical keys are unavailable. Adding a new backend
column or index cannot safely identify and backfill the unknown historical row.

## Consequences

The focal contract and runner can prove why execution is blocked and reject
unsafe alternatives. They cannot perform a lookup. The correct readiness is
`FOUNDATION-019A-R2J BLOCKED_NO_EXACT_HISTORICAL_KEY`.

R2J may be reopened only if an integrity-bound historical artifact is found
that contains the exact Conversation, owner and run binding. Any future backend
recovery registry is a separate forward-looking decision and cannot repair v4
retroactively.

## Rejected alternatives

- Treating ArtifactV2 context as resource identity.
- Inferring absence from the zero idempotency record.
- Owner-wide or date-window listing.
- Selecting latest, first or only currently visible row.
- Searching content, titles, emails or logs approximately.
- Backfilling a new run marker onto an unknown historical row.
- Combining diagnosis and delete in one first execution.

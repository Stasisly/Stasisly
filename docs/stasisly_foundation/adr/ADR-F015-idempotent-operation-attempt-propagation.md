# ADR-F015 - Idempotent operation-attempt propagation

```text
Decision: APPROVED
Implementation: IMPLEMENTED_LOCALLY
Remote: NOT AUTHORIZED / NOT IMPLEMENTED
Date: 2026-07-20
```

## Context

The local backend already enforces create/send idempotency, but Flutter local
HTTP datasources generated a new key for every repository invocation. A retry
of one application intent could therefore become a new backend operation.

## Decision

- Application callers own an opaque `OperationAttemptId`.
- One user intent retains one attempt across application and transport retries.
- A new or edited user intent requires a new attempt.
- Canonical effect inputs require the attempt explicitly.
- Repository ports and transitional adapters propagate it unchanged.
- Datasources only map it to `Idempotency-Key`; they never generate it.
- The backend never supplies a fallback for a missing key.
- Attempts have no identity, authorization, ownership or correlation authority.
- The contract is provider-neutral, bounded, safely comparable and redacted.

## Consequences

Create/send consumers must provide an attempt and cannot rely on an implicit
overload. Retry owners must retain the same value for the same intent. This
closes the local client propagation gap without changing backend DTOs, schema,
routing or remote state.

## Rejected alternatives

- Datasource generation: loses same-intent stability across repository calls.
- Timestamp/content-derived values: predictable, collision-prone or sensitive.
- Conversation/correlation identifiers: wrong scope and semantics.
- Optional key with fallback: fails open and weakens backend enforcement.

## Scope and follow-up

This ADR covers the local contract and propagation only. ADR-F016 is reserved
for the future canonical Conversation application layer. FOUNDATION-013F may be
reopened after this package, but is not implemented by this decision.

## Rollback

Revert the package atomically. Do not restore datasource-owned generation while
keeping explicit application contracts.

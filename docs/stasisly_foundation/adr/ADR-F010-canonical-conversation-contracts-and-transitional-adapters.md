# ADR-F010 Canonical Conversation Contracts and Transitional Adapters

## Status

```text
Decision: APPROVED
Implementation: IMPLEMENTED_LOCALLY
```

## Context

ADR-F009 establishes Conversation as the Product aggregate and rejects Session
as a permanent Product synonym. The current safe local boundary still uses
`OwnChatSession`, `OwnChatMessage`, `sessionId` and six session-named Edge
Functions. Legacy chat is blocked and cannot be a fallback. A direct rename
would break proven DTO, cursor, ownership and content-only invariants.

## Decision

1. `Conversation` is the canonical Product contract.
2. `Session` remains a transitional backend term; `ExecutionSession` remains a
   future runtime term and is not represented by this feature.
3. `ConversationId` is opaque, bounded and format-neutral. Current `sessionId`
   maps to it only through a documented transitional adapter.
4. `ConversationMessage` is canonical and excludes provider/runtime internals.
5. Ownership is constructed only from an authenticated `StasislyIdentity`;
   Product inputs never accept owner identity.
6. Lifecycle is active, archived, pending deletion and fail-closed unknown.
7. Message authors and provenance map only demonstrated evidence; ambiguous
   assistant/tool roles become non-display-safe unknown.
8. `selectableSpecialistId` is the public selection reference. Internal
   specialist and runtime agent identities remain excluded.
9. `ConversationRepository` and its request/result contracts are
   provider-neutral.
10. `TransitionalConversationRepositoryAdapter` composes the existing session
    and message repositories without duplicating transport or changing DTOs.
11. Existing schema, Edge Functions, RLS, routes, UI, providers and legacy chat
    remain unchanged.
12. No Product route or screen is activated and no remote action is permitted.

## Consequences

Positive:

- new Product work can depend on Conversation vocabulary without rewriting the
  safe backend boundary;
- ownership, error and pagination behavior remain fail-closed;
- provider, runtime and legacy chat types stay outside canonical domain;
- rollback is a local code/document revert with no data operation.

Costs:

- the adapter requires trusted authenticated identity composition by a future
  consumer;
- Stasis-only creation cannot be represented by the current create-session API;
- assistant/tool authors remain unknown until provenance is implemented;
- the transport and persistence layer still use session terminology.

## Rejected alternatives

- typedef or rename Session to Conversation: rejected as semantic aliasing and
  compatibility risk.
- accept a raw owner string in Product inputs: rejected as client authority.
- map `assistant` to Stasis or specialist: rejected because evidence is absent.
- reuse legacy chat repositories: rejected because they carry unsafe client
  authority and direct Supabase coupling.
- add canonical routes, backend DTOs or schema now: rejected as scope expansion.

## Security invariants

```text
authenticated trusted owner only
no owner/author/role/agent authority from Product input
unknown lifecycle and authors fail closed
no internal specialist identity
no provider exception or DTO in canonical contracts
no legacy chat fallback
no Product route or presentation activation
no remote action or secret
```

## Evidence

```text
focal analyzer: 0 issues
focal Flutter tests: 31/31 pass
full analyzer: 0 errors, 51 inherited infos
full Flutter tests: 514 pass, 5 approved skips
Deno format: 53 files checked
Deno tests: 72/72 pass
local SQL: 649/649 pass after no-seed reset
```

## Rollback

Revert the FOUNDATION-013A commit. No schema, route, backend, remote or data
rollback is necessary. Legacy chat remains blocked throughout rollback.

## Follow-up

FOUNDATION-013B owns the canonical backend creation contract, transactional
catalog eligibility and idempotency. It must be approved separately.

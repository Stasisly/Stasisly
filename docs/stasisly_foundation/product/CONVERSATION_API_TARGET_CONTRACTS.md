# Conversation API Target Contracts

## FOUNDATION-016-R1 boundary delta

No public DTO, endpoint or backend contract changed. Removal eliminates the
parallel `ChatRepository` contract and direct legacy provider path. Product
continues through `ConversationRepository`; transitional own-session/message
ports remain internal to the adapter and are not widget-facing APIs.

## FOUNDATION-015-R1 Product consumer delta

Canonical Product screens now consume list/read/message/send/archive/restore
through the canonical repository boundary. Route input is only
`conversationId`; send UI supplies only content while the controller owns the
stable operation attempt. No public DTO or backend API changed.

## FOUNDATION-014-R1 consumer contract

Product selection uses only a verified `selectableSpecialistId`. Legacy
`AgentEntity.id` cannot be renamed, mapped or sent as a Conversation reference.
Where the approved reference is absent, Product emits no create intent and makes
no API call. This package changes no DTO, endpoint or backend behavior.

## FOUNDATION-013F application contract

Seven application use cases preserve the canonical repository inputs/results.
List/read/message retries are new reads; create/send same-intent retry preserves
the exact `OperationAttemptId`; archive/restore remain natural transitions.
Application state contains controlled error codes rather than provider/HTTP
payloads. No API or DTO changed in this package.

## FOUNDATION-013F-R1 local contract

Canonical create/send inputs now require a provider-neutral
`OperationAttemptId`. One application intent retains one value through
repository, adapter and transport retries; only the HTTP boundary renders it as
`Idempotency-Key`. New or edited intents require a new value. The identifier has
no identity/authorization/ownership semantics and is absent from public DTOs.

## Implemented local Message contract

Send accepts only Conversation/session reference, content and transport
idempotency. List returns sanitized author/status/provenance/visibility metadata;
redacted content is omitted. Active operation IDs are
`conversation.message.sendUser` and `conversation.message.listOwn` only.

## Metadata

```text
Status: APPROVED target contracts
Implementation: NOT IMPLEMENTED
Owner: Product API Architecture under Stasis/Rector
Approver: Founder
```

## Boundary rules

All target operations are Stasisly-owned Product API contracts. Identity,
ownership, surface and environment are backend-derived; DTOs are allowlisted;
errors are stable and sanitized; limits are bounded; provider data and policy
internals are excluded. Existing Edge Function names and `sessionId` remain
temporary compatibility contracts until a versioned migration.

## Target operations

| Operation | Status | Core input | Core result / rule |
|---|---|---|---|
| List conversations | MVP | status, bounded limit, cursor | Owned summaries, stable cursor |
| Create conversation | MVP | optional title and `selectableSpecialistId` | New `conversationId`; owner from backend |
| Read conversation | MVP | `conversationId` | Owned aggregate summary; no internal IDs |
| Rename conversation | MVP | `conversationId`, bounded title | Confirmed sanitized summary |
| Archive conversation | MVP | `conversationId` | Naturally idempotent target state |
| Restore conversation | MVP | `conversationId` | Naturally idempotent target state |
| List messages | MVP | `conversationId`, bounded limit, cursor | Visible Product Messages only |
| Send user message | MVP | `conversationId`, content, idempotency key | Accepted user Message; no author input |
| Select specialist | MVP at creation | `selectableSpecialistId` | Backend resolves approved definition |
| Change specialist | MVP decision, implementation later in slice | conversation/catalog IDs, idempotency key | Visible selection event and updated summary |
| List participants | FUTURE | `conversationId` | Visible participants only |
| Request deletion | FUTURE / PRIVACY-GATED | `conversationId`, idempotency key | `pendingDeletion`, no immediate-delete promise |
| Read authorized trace | RESTRICTED FUTURE | Conversation/execution reference | Minimized provenance, explicit authorization |
| Start/read research | FUTURE / RESEARCH-GATED | Conversation and explicit request | Separate artifact reference/status |
| Add attachment | FUTURE / SECURITY-GATED | Separate upload contract | Scanned, classified attachment reference |
| Shared membership | NOT APPROVED | none | No MVP operation |

## Public DTO targets

Conceptual Conversation DTO:

```text
conversationId
title
status
createdAt
updatedAt
archivedAt optional
primaryContext
participantsSummary
```

Conceptual Message DTO:

```text
messageId
conversationId
authorType
content
createdAt
status
visibility
provenanceSummary optional
```

No owner ID, internal specialist ID, agent ID, prompt, provider thread/model,
policy context, trace body or credential is public.

## Compatibility mapping

| Current operation | Target | Classification | Required change |
|---|---|---|---|
| `list-selectable-specialists` | Product catalog listing | KEEP_TEMPORARILY then ADAPT | Preserve sanitized catalog ID; version naming independently |
| `create-own-chat-session` | Create conversation | ADAPT | Transactional eligibility, idempotency, `conversationId` contract |
| `list-own-chat-sessions` | List conversations | ADAPT | Rename semantics/DTO; preserve bounded cursor where compatible |
| `archive-own-chat-session` | Archive conversation | ADAPT | Target idempotency and canonical identifier |
| `list-session-messages` | List messages | ADAPT | Filter/map Product-visible authors and provenance |
| `send-user-message` | Send user message | ADAPT | Preserve content-only/atomicity; add idempotency and canonical ID |

None is removed before replacement, parity, compatibility evidence and rollback.

## Idempotency and concurrency

- Create conversation requires an idempotency key and one atomic eligibility +
  create boundary. The current catalog-check/insert TOCTOU is P1.
- Send user message requires an idempotency key in addition to the current
  atomic session lock/insert/counter update.
- Archive and restore target state semantics are naturally idempotent; retries
  return the same public state without leaking existence across owners.
- Change specialist, deletion request, research start, tool execution and agent
  execution require operation-specific idempotency.
- Read/list operations are side-effect free and do not require idempotency keys.

The future technical package must evaluate a transactional database function,
single statement, locking, constraint-backed validation and versioned catalog
eligibility. This architecture does not select one.

## Pagination

Cursor-based pagination with stable ordering and bounded limits is mandatory for
Conversation and Message history. Existing `(lastMessageAt, sessionId)` and
`(createdAt, messageId)` cursor behavior is a useful compatibility invariant,
but cursor encodings are opaque and may be versioned. No unbounded history or
offset-only Product contract is approved.

## Errors, limits and cost readiness

Target errors distinguish invalid request, unauthenticated, opaque not found,
archived/not writable, conflict/idempotency, rate limited, policy blocked and
backend unavailable without leaking ownership or infrastructure.

Before rollout, packages must define limits for Messages, Conversations,
content, model tokens, tool calls, research, attachments, concurrency and
retention. Budgets may depend on plan but never substitute authorization. No
price, entitlement or quota is set here.

## Versioning and rollout

Current endpoints remain local compatibility APIs. Canonical endpoints/routes
must be introduced behind a versioned adapter with dual-contract tests where
needed. There is no alias from `/chat/:id`; an `agentId` cannot be interpreted as
a `conversationId`. No endpoint or route is implemented by FOUNDATION-012.

## FOUNDATION-013B local adoption

Create and send now require `Idempotency-Key` at the local transitional Edge
Functions. Create validates catalog eligibility and inserts in one locked SQL
transaction; send atomically inserts one user Message and updates counters.
Matching retries return the original DTO (`200` after initial `201`), while a
conflicting payload returns `409`. Endpoint names and `sessionId` remain
transitional; canonical routes/endpoints and remote rollout remain absent.

## FOUNDATION-013C local adoption

List/read/archive/restore are now owner-scoped local backend operations with
registered Product metadata, bounded stable cursors, sanitized Conversation
DTOs and opaque foreign/not-found behavior. Archive and restore use locked,
state-based idempotent RPC transitions. Archived Message history remains
readable by its owner while send remains denied until restore. Session-named
compatibility endpoints and tables remain transitional; Product routes, delete,
pendingDeletion, provenance and remote rollout remain absent.

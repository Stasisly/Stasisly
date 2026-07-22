# Product Conversation Architecture

## FOUNDATION-017 implementation delta

The canonical application-controller boundary owns local-safe outcome events;
the router emits only stable route categories. Runtime uses a NoOp sink and
widgets emit nothing. Partial list/message failures preserve existing data,
while the canonical repository/backend authority and transitional adapter graph
remain unchanged.

## FOUNDATION-016-R1 implementation delta

Canonical Conversation is now the sole physical Product conversation runtime.
The legacy feature and `/chat/:id` are absent, with no redirects or aliases.
The Product graph ends at the canonical repository and encapsulated
`chat_sessions`/`chat_messages` adapter sources; Orchestrator remains blocked
and has no Conversation or legacy-chat dependency.

## FOUNDATION-015-R1 implementation delta

The approved `/stasis`, `/conversations` and
`/conversations/:conversationId` routes are now implemented locally through the
single active router and canonical application providers. Ownership remains
backend-authoritative; `conversationId` is only a locator. AI and remote
capabilities remain unimplemented.

## FOUNDATION-014-R1 Product consumer boundary

Product area pages no longer interpret `AgentEntity.id` as Conversation
identity or navigate to legacy chat. Without a verified
`selectableSpecialistId`, they expose no start action and render an honest
unavailable state. At FOUNDATION-014-R1 the canonical inactive composition was
the sole approved boundary; FOUNDATION-015-R1 subsequently registers its
canonical Product routes without changing specialist identity semantics.

## FOUNDATION-013F local application boundary

The canonical Product path now reaches provider-neutral use cases, typed
controllers and feature-scoped providers, ending at an inactive local
validation host. The host uses explicit `ConversationId`, canonical Messages
and content-only intents. This is not a Product screen or route. Backend
ownership and policy remain authoritative; legacy chat and remote activation
remain outside the composition.

## FOUNDATION-019C selectable-specialist composition

Product Stasis now composes a `SelectableSpecialistCatalog` through a typed
controller and protected adapter. Its public reference is
`selectableSpecialistId`, sourced from the backend catalog boundary. It is not
an agent ID or internal specialist key. Create remains disabled until explicit
selection; empty/error/blocked states have no demo fallback. Successful create
uses the canonical application controller and Product detail route. Other area
pages retain their blocked CTA state.

## Adopted presentation boundary

Canonical Conversation presentation consumes only canonical domain/view
models. It performs no repository, provider, ownership, provenance or visibility
authority. Unknown/internal messages do not render; redaction never receives
original content. The component library is inactive and route-free.

## Adopted Message boundary

A Product Message is not an execution trace. Author, provenance and visibility
are independent backend-controlled contracts; unknown/internal content is
filtered in SQL. `assistant` is not Stasis and `tool` is not a specialist.

## Metadata

| Field | Value |
|---|---|
| Status | APPROVED |
| Authority level | 3 - Product and technical domain decision |
| Owner | Product Architecture under Stasis, reviewed by Rector and Security |
| Approver | Founder |
| Version | 1.0 |
| Implementation | PARTIALLY IMPLEMENTED LOCALLY; PRODUCT ROUTES NOT IMPLEMENTED |
| Dependencies | ADR-F002, ADR-F004-F009, FOUNDATION-008-012 |

## Decision summary

```text
Conversation = persistent Product aggregate visible to the user.
ExecutionSession = temporary internal Stasis Engine execution context.
Message = persistent Product communication inside a Conversation.
Turn = Product/application interaction, not an authority or storage identity.
Agent/tool execution and trace = internal runtime evidence, not Product history.
```

`Session` is not a permanent synonym for `Conversation`. The current
`chatSession`/`sessionId` contract is transitional: it represents the existing
one-to-one Product history container and must be adapted toward Conversation.
Future Product contracts use `conversationId`. A migration may preserve the
underlying UUID, but callers cannot assume that until an implementation package
proves compatibility.

## User-visible aggregate

A Conversation is owned, durable, listable, archivable and restorable. Its
conceptual public shape may include:

```text
conversationId
title
status
createdAt
updatedAt
archivedAt
primaryContext
participantSummary
```

Ownership is never a client field. Provider thread IDs, prompts, credentials,
runtime permissions and internal agent IDs are excluded. This document defines
semantics, not tables or final DTOs.

## Product messages

A Message is a persisted Product record with a public identity, conversation
reference, author type, content, time, status, visibility and minimized
provenance. Canonical visible author types are:

```text
user
stasis
specialist
systemNotice
```

The existing `assistant`, `system` and `tool` values are compatibility data, not
the target author model. Tool calls, model outputs, agent scratch work and
private reasoning are not automatically Messages. A future adapter must map or
withhold them through an approved visibility/provenance policy.

## Turn and execution boundary

A Product turn starts with an accepted user Message and may lead to one bounded
internal execution:

```text
user Message
-> authorized orchestration
-> specialist/model/tool work
-> consolidated Product response Message
```

Internal execution records use separate identities and stores. Product history
may reference an authorized execution or research artifact but does not embed
private chain-of-thought, raw prompts, credentials or unrestricted traces.

## Specialists and Stasis

Stasis is the default Product coordinator, primary conversational entry point,
specialist coordinator and response consolidator. This does not make Stasis the
owner, runtime, registry, memory store or authorization authority.

The Product permits these approved conceptual interactions:

- start and continue a conversation with Stasis;
- select a Product catalog specialist;
- change the selected specialist with a visible Product event;
- inspect visible participants and authorized provenance.

Multiple invited specialists and direct multi-party interaction are future
capabilities. Internal contributors are disclosed only through safe,
comprehensible provenance when authorized.

`selectableSpecialistId` remains the current public catalog identifier. It is
not an `agentId`. The future bridge is:

```text
selectableSpecialistId
-> approved specialist definition
-> approved runtime agent version
```

Each link is backend-owned, versioned and non-public unless explicitly exposed.

## Participants

Conceptual participants are owner user, Stasis, selected specialist, future
supporting specialists and a Product system-notice author. The target model
distinguishes visible participants from internal contributors. Specialist,
Stasis, provider and agent runtime are never owners of the user's Conversation.

## Target conceptual model

The target model contains concepts, not mandated tables:

| Concept | Responsibility |
|---|---|
| Conversation | Product continuity, owner and lifecycle |
| ConversationParticipant | Visible membership/participation and validity |
| Message | Product-visible communication |
| MessageProvenance | Safe source/participant/execution attribution |
| SpecialistSelection | Selected public specialist and effective interval |
| ExecutionReference | Opaque authorized link to internal execution evidence |
| ResearchArtifactReference | Link to a separately governed research result |
| MemoryProposalReference | Link to an explicit memory proposal/decision |
| AttachmentReference | Link to separately secured content |

## Routes

The approved future Product model is:

```text
/stasis
  primary Product entry point and coordinator experience

/conversations
  owned conversation collection and history

/conversations/:conversationId
  one owned Conversation
```

These were target contracts at FOUNDATION-012; FOUNDATION-015-R1 later
registered the canonical Product routes. FOUNDATION-016-R1 removes `/chat/:id`;
orchestrator paths remain blocked and are not aliases.

## Current asset direction

- `lib/features/chat/**`: `PHYSICALLY_REMOVED`.
- `chat_sessions`: `ADAPT` toward Conversation semantics.
- `chat_messages`: `ADAPT` toward canonical Message/provenance semantics.
- specialist catalog: `ADAPT`; Agent Registry and roster remain unimplemented.
- six Edge Functions: preserve temporarily and adapt behind versioned
  Conversation contracts.
- current database tables: transitional persistence, not the target domain
  model by declaration.

## Privacy, limits and portability

Conversation design requires data minimization, backend ownership, consent and
purpose where applicable, bounded pagination, retention/deletion policy,
provider minimization, export and portability. Message, conversation, model,
tool, research, attachment and retention limits must be explicit before rollout.
Commercial tiers do not become authorization.

## Founder decision gate resolved by FOUNDATION-012

| Decision | Approved outcome |
|---|---|
| Canonical Product term | Conversation |
| Conversation vs Session | Conversation is Product; ExecutionSession is runtime |
| Product routes | `/stasis`, `/conversations`, `/conversations/:conversationId` target only |
| Role of Stasis | Default Product coordinator and response consolidator |
| Direct specialist interaction | Selection/change approved conceptually through Product catalog |
| Legacy chat | Deprecated, blocked and retired only through L0-L7 gates |
| Ownership | Backend-derived authenticated subject |
| Archive vs delete | Separate; archive reversible, deletion policy-controlled |
| Shared access | Future capability, not MVP |
| Memory | Explicit proposal/policy; never automatic from history |
| Research | Separate request/execution/artifact with authorized provenance |

## Non-goals

No code, route, schema, endpoint, migration, prompt, agent, runtime, upload,
memory, research system, entitlement, price, remote operation or production
capability is created by this architecture.
## FOUNDATION-013F local application boundary

The canonical Product path now reaches provider-neutral use cases, typed
controllers and feature-scoped providers, ending at an inactive local
validation host. The host uses explicit `ConversationId`, canonical Messages
and content-only intents. This is not a Product screen or route. Backend
ownership and policy remain authoritative; legacy chat and remote activation
remain outside the composition.

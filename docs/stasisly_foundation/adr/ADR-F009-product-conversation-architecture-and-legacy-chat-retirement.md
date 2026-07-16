# ADR-F009 Product Conversation Architecture and Legacy Chat Retirement

## Status

```text
Decision: APPROVED
Implementation: NOT IMPLEMENTED
```

## Context

The repository has two incompatible chat lines. `lib/features/chat/**` accepts
client user/specialist/role authority, uses Supabase directly and treats a
legacy `agentId` as the entry to chat. It is blocked but not formally retired.
The newer sessions/messages/catalog boundaries use explicit `sessionId`,
content-only send, backend ownership, sanitized DTOs and local Product Edge
Functions, but retain transitional terminology and persistence.

Stasis Engine, Agent Registry, research and memory systems are not implemented.
Treating either chat line as Engine or conflating Product history with runtime
execution would violate Foundation boundaries.

## Decision

1. `Conversation` is the persistent Product aggregate visible and manageable by
   the user.
2. `Session` is not a permanent Conversation synonym. `ExecutionSession` means
   a temporary internal Engine execution. Current `chatSession`/`sessionId` is
   transitional compatibility state to adapt toward `conversationId`.
3. `Message` is Product-visible persisted communication. Agent/model/tool work,
   traces and private reasoning are separate and never automatically Messages.
4. Stasis is the default Product coordinator and primary entry point. Users may
   converse with Stasis or select/change a Product specialist. Multi-specialist
   participation remains future.
5. Product catalog item, specialist definition, runtime agent identity,
   organizational roster, prompt version and model execution use separate IDs
   and contracts. `selectableSpecialistId` is not `agentId`.
6. Conversation owner is the backend-derived authenticated subject. Specialists,
   Stasis and providers are never owners. Shared membership is future only.
7. Canonical live states are active, archived and pendingDeletion. Archive is
   reversible and distinct from deletion. Archived owner history remains
   readable; archived Conversations are not writable.
8. Conversation history, summaries, memory, runtime context and research
   artifacts are separate domains. No automatic permanent memory is approved.
9. The future route model is `/stasis`, `/conversations` and
   `/conversations/:conversationId`. No route is registered now.
10. `lib/features/chat/**` is `DEPRECATED_AND_BLOCKED`; no new features, routes,
    fallback, direct Supabase Product use, client role/owner authority or Engine
    reuse is allowed.
11. Modern chat sessions/messages, specialist catalog, six Edge Functions and
    their tests are `ADAPT`/`KEEP_TEMPORARILY` toward canonical contracts.
12. FOUNDATION-013 is decomposed into separately approved A-F child packages;
    existing FOUNDATION-014-020 IDs and meanings are preserved.
13. FOUNDATION-012 is documentation only and implements none of these decisions.

## Consequences

Positive:

- Product continuity has one canonical aggregate and route vocabulary;
- `agentId`, catalog ID, runtime identity and Conversation ID cannot be confused;
- Product history stays separate from Engine traces, memory and research;
- current safe ownership/content-only/cursor/atomicity controls remain reusable;
- legacy retirement has explicit gates and cannot become a hidden fallback.

Costs and residual risks:

- current APIs/schema still expose session terminology and limited roles/states;
- create-session TOCTOU and create/send idempotency remain unresolved;
- provenance, visibility, retention, deletion, attachments and sharing need later
  packages;
- no canonical Product route, Engine, agent, memory or research runtime exists.

## Rejected alternatives

- Conversation and Session as permanent synonyms: rejected as domain ambiguity.
- Current `sessionId` guaranteed to be future `conversationId`: rejected until a
  migration package proves compatibility.
- `/chat/:id` as canonical route: rejected because `id` is legacy `agentId`.
- Orchestrator prototype as Stasis Engine: rejected by ADR-F002 and Engine
  architecture.
- Reusing legacy repositories while extracting UI: rejected because unsafe
  authority would follow the widgets.
- Automatic conversation-to-memory ingestion: rejected for privacy, purpose and
  provenance reasons.
- Exposing all agent/tool traces for transparency: rejected because safe
  provenance is not private chain-of-thought disclosure.

## Security and privacy invariants

```text
backend-derived owner only
no client author/role/agent authority
archived history readable by owner but not writable
deletion is policy-controlled and distinct from archive
history does not imply memory
trace does not imply Product visibility
catalog ID does not imply runtime identity
provider IDs and credentials stay private
```

## Rollback

As a documentary package, rollback reverts these documents and map updates. It
must not reactivate blocked legacy routes or weaken the already implemented
backend authorization boundary. No code, schema or data rollback exists.

## Follow-up

The first technical child is `FOUNDATION-013A - Canonical Product Conversation
contracts and adapters`, local-only and separately approved. It must not create
Product routes, migrate schema or remove legacy code unless its exact package
authorizes those actions.

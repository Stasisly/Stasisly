# ADR-F019: Physical legacy chat removal and reference eradication

## Status

```text
Decision: APPROVED
Implementation: IMPLEMENTED_LOCALLY
```

## Context

Canonical Conversation is the sole Product architecture and FOUNDATION-015-R1
activated its local Product routes/screens. The frozen `features/chat` tree had
no Product consumer, but a dead `OrchestratorChatPage` still imported
`ChatPage`. FOUNDATION-016-R1 explicitly authorized removal of that consumer so
physical retirement could complete without redesigning Orchestrator.

## Decision

- Remove `OrchestratorChatPage` without replacement or redirect.
- Remove all of `lib/features/chat/**`, including direct Supabase/demo data,
  legacy repositories, entities, use cases, providers, controller and UI.
- Remove `/chat/:id` from the route metadata and active router. Legacy IDs are
  never interpreted as `ConversationId`.
- Keep `/orchestrator` and `/orchestrator/chat` explicitly blocked.
- Keep canonical Conversation as the sole Product conversation architecture.
- Retain `chat_sessions` and `chat_messages` as encapsulated transitional
  backend transport infrastructure behind `TransitionalConversationRepositoryAdapter`.
- Enforce zero runtime legacy references with the
  `LEGACY_CHAT_REFERENCE_ERADICATION` architecture gate.
- Use Git history and revert as rollback evidence; keep no dormant fallback.
- Authorize no remote, staging, production, AI or Stasis Engine behavior.

## Consequences

Legacy pages, providers, controllers, repositories, datasources, entities,
tests and route handling can no longer be reconnected accidentally. A request
to `/chat/...` receives the generic unavailable route response. The blocked
Orchestrator prototype remains isolated. Physical session/message naming and
development hosts remain controlled transitional debt, not Product API.

## Rollback

Revert the FOUNDATION-016 commit. Any later attempt to restore legacy runtime
requires a new explicit decision and security review; this ADR provides no
production authorization.

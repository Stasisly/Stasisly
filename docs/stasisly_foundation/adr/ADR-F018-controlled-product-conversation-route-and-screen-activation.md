# ADR-F018: Controlled Product Conversation route and screen activation

## Status

```text
Decision: APPROVED
Implementation: IMPLEMENTED_LOCALLY
```

## Context

FOUNDATION-014 retired Product navigation based on `agent.id`, while the
canonical Conversation application composition remained inactive. The first
FOUNDATION-015 attempt stopped because the real router,
`lib/core/config/routes.dart`, was outside its allowlist. FOUNDATION-015-R1
explicitly authorizes that router and its boundary tests.

## Decision

- The existing `routerProvider` remains the single navigation authority.
- `/stasis` is the authenticated Product initial entry.
- `/conversations` is the authenticated owner-scoped collection entry.
- `/conversations/:conversationId` is the authenticated canonical detail.
- Every entry declares Product surface, local/development allowlist,
  authentication, authorization requirement, resource type, canonical Product
  classification and non-legacy state.
- Route checks run before page construction. Repository/backend checks retain
  ownership and authorization authority; `conversationId` grants nothing.
- The detail adapter accepts only `conversationId`; route extras do not carry
  identity, owner, author, role, surface or environment.
- Product screens consume only canonical Conversation controllers/providers.
- Stasis reports Conversation creation unavailable while the selectable
  specialist catalog is backend-blocked.
- Sending persists only a user-authored message. No Stasis/specialist response,
  AI runtime, typing simulation, Engine, memory or research is activated.
- `/chat/:id`, `/orchestrator` and `/orchestrator/chat` remain blocked without
  redirect or ID reinterpretation.
- Activation is local/development only. Staging, production, backendReal,
  unknown environments and remote execution remain unauthorized.

## Consequences

The Product shell has one main Stasis destination and preserves the four
existing areas. Canonical list/detail UX supports active/archived filters,
refresh, bounded pagination, opaque not-found, user-message send and reversible
archive/restore. Physical session/message repositories remain transitional
behind the canonical adapter and are not exposed to widgets.

## Rollback

Remove the three route registrations and Product page imports, restore the
previous initial Product entry, remove the Stasis shell destination, and revert
the FOUNDATION-015-R1 Product files/tests. Backend and schema rollback is not
required because this decision changes neither.

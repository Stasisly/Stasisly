# ADR-F017: Product Consumer Migration and Legacy Wiring Retirement

## Status

```text
Decision: APPROVED
Implementation: IMPLEMENTED_LOCALLY
```

## Context

Four active Product area pages used `AgentEntity.id` to navigate to the blocked
legacy `/chat/:id` route. The canonical Conversation application composition
already existed but intentionally had no Product route. The displayed legacy
agent records contained no evidence-backed `selectableSpecialistId`.

## Decision

- Product Conversation consumers must never treat `AgentEntity.id` as a Product
  selection reference.
- `selectableSpecialistId` is the only approved specialist-selection reference
  for future Conversation creation.
- A consumer with no verified `selectableSpecialistId` must remove its
  conversation action and expose an honest safe-unavailable state.
- Valid future consumers may emit a canonical intent only when the approved
  reference exists; they may not invent mappings from runtime/organizational IDs.
- The canonical Conversation composition is the sole approved Product
  conversation composition and remains inactive and unroutable in this package.
- Legacy Product navigation is removed. Legacy providers/controllers remain
  frozen or isolated until evidence permits physical retirement.
- The Development orchestrator prototype remains blocked, isolated, non-Product
  and unavailable as a fallback.
- `/stasis`, `/conversations` and `/conversations/:conversationId` remain
  unregistered. Activation requires a separately approved package.
- Scope remains local/development; backend, schema, remote and production are
  not authorized.

## Consequences

The four Product areas preserve safe specialist information but cannot start a
Conversation yet. Product route activation can be evaluated independently with
zero legacy Product affordances. Frozen source and Development prototype debt
remain visible rather than being disguised as a completed physical retirement.

## Evidence

FOUNDATION-014-R1 records `605` Flutter passes with `5` approved skips, Deno
`86/86`, SQL `740/740`, zero Product legacy route calls and zero newly registered
canonical routes.

## Supersession

This ADR extends ADR-F009, ADR-F014 and ADR-F016. A change to Product selection
identity, route activation, fallback policy or orchestrator isolation requires a
new approved decision.

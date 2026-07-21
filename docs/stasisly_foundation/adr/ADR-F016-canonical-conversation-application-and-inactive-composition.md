# ADR-F016 - Canonical Conversation application and inactive composition

```text
Decision: APPROVED
Implementation: IMPLEMENTED_LOCALLY
Remote: NOT AUTHORIZED / NOT IMPLEMENTED
Date: 2026-07-21
```

## Context

FOUNDATION-013A-E established the canonical Conversation domain, backend
boundaries and provider-neutral presentation primitives. FOUNDATION-013F-R1
then made create/send operation attempts application-owned and stable. The
remaining local gap was orchestration: typed use cases, state, concurrency,
retry coordination and an executable but unreachable Product composition.

## Decision

- Seven provider-neutral use cases preserve canonical inputs and results.
- Typed list, detail, messages, composer, lifecycle and create states expose
  only safe application data and controlled error codes.
- Feature-scoped pure-Dart controllers own pagination generations, stale-result
  rejection, deduplication and one-effect-at-a-time coordination.
- Create and send controllers create one `OperationAttemptId` per user intent,
  retain it for same-intent retry and retire it when the intent changes.
- Archive and restore remain naturally idempotent and deterministically
  invalidate the Conversation list provider.
- Riverpod providers compose `TransitionalConversationRepositoryAdapter` over
  the existing safe repositories and the secure session identity boundary.
- Composition is available only in `local` and `development`; demo, staging,
  production, backendReal and invalid runtime names fail closed without a
  fallback.
- `InactiveConversationFeatureHost` is a local validation host only. It has no
  route, deep link, active shell export or navigation behavior.
- Canonical message mapping remains the only display path; unknown/internal
  content is not rendered.

## Consequences

The Product Conversation application boundary is executable and testable
locally without activating Product navigation. Flutter does not derive
ownership, author, provenance, visibility or authorization. The transitional
physical repositories remain internal composition dependencies and legacy chat
remains frozen.

## Rejected alternatives

- Reusing legacy chat controllers/providers: preserves unsafe authority and ID
  semantics.
- Registering a temporary Product route: turns local validation into accidental
  activation.
- Generating retry keys in providers/widgets/transports: breaks same-intent
  idempotency.
- Demo or legacy fallback: fails open and hides environment/auth errors.
- Automatic restore before send: violates archived lifecycle authority.

## Scope and follow-up

This decision does not approve a canonical Product screen, Product route,
legacy consumer migration, remote activation, Stasis responses, specialist
responses, research, memory, attachments or deletion. FOUNDATION-014 remains a
separately approved future package and is not started here.

## Rollback

Revert the FOUNDATION-013F commit atomically. No schema/backend rollback is
needed because this package changes neither. Keep legacy chat frozen and do not
route to the inactive host.

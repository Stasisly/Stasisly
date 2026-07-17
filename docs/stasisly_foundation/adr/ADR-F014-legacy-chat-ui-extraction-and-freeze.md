# ADR-F014 - Legacy chat UI extraction and freeze

Decision: **APPROVED**
Implementation: **IMPLEMENTED_LOCALLY**
Remote: **NOT AUTHORIZED**

## Context

The blocked legacy chat combines visual widgets with `agentId`, Riverpod,
legacy entities, repositories, direct Supabase and client role semantics.
Canonical Conversation domain and backend boundaries exist locally, but no
Product screen or route is approved.

## Decision

- Reuse only visual intent, never legacy authority.
- Canonical presentation consumes canonical `ConversationMessage` or a derived
  provider-neutral view model.
- Legacy repositories, datasources, entities, use cases, controllers and
  providers are not reused.
- `lib/features/chat/**` is deprecated and frozen through a central README and
  architecture guards.
- Legacy routes remain blocked and no canonical Product route is activated.
- Unknown/internal messages are not renderable; redaction has no original
  content.
- Stasis/specialist visual contracts require verified canonical provenance and
  do not imply active generation.
- Retirement is incremental after replacement, parity, security and rollback;
  physical removal is not authorized here.

## Consequences

Future Product composition can use tested UI primitives without importing
legacy state or transport. The legacy graph and one blocked orchestrator
consumer remain explicit debt until L4-L7. No active Product wiring or remote
operation is created.

## Rejected alternatives

- Reusing `ChatPage`, `ChatInput`, providers or repository would preserve
  `agentId`, attachment, role and direct-Supabase authority.
- Deleting legacy source now would precede replacement and parity.
- Registering `/stasis` or `/conversations` would exceed this package.

## Validation

Acceptance requires widget/semantic/responsive tests, architecture freeze
guards, complete Flutter regression, unchanged Deno/SQL regression, synchronized
Foundation documents, explicit commit and push, and no G8-G10 action.

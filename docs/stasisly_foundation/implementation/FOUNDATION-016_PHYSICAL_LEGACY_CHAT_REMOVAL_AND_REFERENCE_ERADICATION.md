# FOUNDATION-016 Physical legacy chat removal and reference eradication

## Status

```text
FOUNDATION-016-R1: IMPLEMENTED_LOCALLY
Legacy chat runtime: PHYSICALLY_REMOVED
LEGACY_CHAT_REFERENCE_ERADICATION: PASS
Remote: NOT IMPLEMENTED
```

## Original blocker and R1 scope

FOUNDATION-016 stopped cleanly because
`lib/features/orchestrator/presentation/pages/orchestrator_chat_page.dart`
imported and constructed legacy `ChatPage`, while Orchestrator was outside the
allowlist. R1 authorized removal of that one dead consumer. The page had no
route, widget or barrel consumer; `/orchestrator/chat` was already resolved by
the metadata registry to a blocked state without constructing it. No
Orchestrator behavior was redesigned.

## Final physical inventory

All 20 files were classified `REMOVE_NOW`; none remained `UNKNOWN_BLOCKED`.

| Legacy file | Layer | Replacement or evidence |
|---|---|---|
| `README.md` | Freeze evidence | Foundation records and ADR-F019 |
| `data/datasources/chat_remote_datasource.dart` | Data contract | Canonical repository boundary |
| `data/datasources/supabase_chat_datasource.dart` | Direct provider data | Encapsulated session/message transports |
| `data/repositories/chat_repository_impl.dart` | Repository | `TransitionalConversationRepositoryAdapter` |
| `data/repositories/demo_chat_repository.dart` | Demo fallback | Removed without fallback |
| `domain/entities/chat_session_entity.dart` | Legacy entity | `Conversation` |
| `domain/entities/message_entity.dart` | Legacy entity | `ConversationMessage` |
| `domain/repositories/chat_repository.dart` | Legacy port | `ConversationRepository` |
| `domain/usecases/get_or_create_session_usecase.dart` | Legacy use case | Canonical create use case |
| `domain/usecases/send_message_usecase.dart` | Legacy use case | Canonical send use case |
| `domain/usecases/watch_messages_usecase.dart` | Legacy use case | Canonical bounded message reads |
| `presentation/pages/agent_chat_wrapper.dart` | Agent-ID wrapper | No alias or replacement |
| `presentation/pages/chat_page.dart` | Legacy page | Canonical `ConversationPage` without redirect |
| `presentation/viewmodels/chat_controller.dart` | Legacy controller | Canonical application controller |
| `presentation/viewmodels/chat_controller.g.dart` | Generated legacy state | Removed with controller |
| `presentation/viewmodels/chat_providers.dart` | Legacy providers | Canonical feature-scoped providers |
| `presentation/viewmodels/chat_providers.g.dart` | Generated providers | Removed with providers |
| `presentation/viewmodels/chat_viewmodel.dart` | Obsolete model | No replacement needed |
| `presentation/widgets/chat_input.dart` | Legacy composer | Canonical composer shell |
| `presentation/widgets/message_bubble.dart` | Legacy message UI | Canonical message bubble/mapper |

The legacy pages, controller, providers, repositories, datasources, entities,
models, generated artifacts, widgets and README are physically absent. Git
history is the only rollback evidence.

## Routes and deep links

`EntryPointId.legacyAgentChat`, its registry definition and its blocked route
builder were removed. `/chat/:id` has no matcher, parser, helper, redirect or
canonical alias. `/chat/anything` now reaches the global safe unknown-route
state. `/orchestrator` and `/orchestrator/chat` remain explicitly blocked and
construct no Orchestrator chat page.

## Tests and guards

The two repository tests coupled to `features/chat` and the old freeze guard
were removed. Their security evidence moved to
`legacy_chat_reference_eradication_test.dart`, which enforces physical absence,
zero runtime imports/symbols, route absence without redirect, Product and
Orchestrator isolation, and preservation/encapsulation of transitional
repositories. Existing router, environment, catalog, identity and consumer
guards now assert safe absence rather than blocked legacy presence.

The final static audit classifies remaining textual matches only as Foundation
history or explicit negative guards. Runtime violations and unclassified test
violations are zero.

## Product graph and transitional infrastructure

```text
routes.dart
-> canonical Product screens
-> canonical providers/controllers
-> ConversationRepository
-> TransitionalConversationRepositoryAdapter
-> OwnChatSessionsRepository / OwnChatMessagesRepository
```

There are zero edges to `features/chat` or Orchestrator. `chat_sessions` and
`chat_messages` remain `TRANSITIONAL`, `ENCAPSULATED`,
`BACKEND_TRANSPORT_INFRASTRUCTURE` and `NOT_PRODUCT_FEATURE`. Their behavior,
DTOs and transports were not changed.

## Validation and security

- Flutter: 610 pass, 5 approved skips, 0 failures.
- Analyzer: 0 errors, 36 inherited infos.
- Deno formatting: 62 files checked.
- Deno tests: 86/86 pass.
- Local SQL: 740/740 pass after one no-seed reset.
- Backend/schema/remote/secrets: unchanged/unused.
- `LEGACY_CHAT_REFERENCE_ERADICATION`: PASS.
- Retirement L0-L7: COMPLETE (`L3` complete locally).

## Rollback, debt and readiness

Rollback is `git revert` of the FOUNDATION-016 commit. No feature flag, dead
source or legacy redirect is retained. Reverting does not authorize legacy
production use. Residual debt is limited to the encapsulated transitional
session/message infrastructure, blocked Orchestrator prototype, absent Product
catalog runtime, remote readiness and unimplemented AI/Engine capabilities.

```text
LEGACY CHAT_RUNTIME_REMOVED_AND_REFERENCES_ERADICATED_LOCAL_AND_PUSHED
```

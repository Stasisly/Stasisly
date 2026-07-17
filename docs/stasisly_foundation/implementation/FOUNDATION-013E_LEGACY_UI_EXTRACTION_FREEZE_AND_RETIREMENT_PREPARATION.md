# FOUNDATION-013E - Legacy UI extraction, freeze and retirement preparation

## 1. Legacy inventory

The complete `lib/features/chat/**` inventory was audited against current
consumers, authority, provider coupling, tests and visual value.

| Path / symbol | Layer and consumers | Unsafe coupling | Coverage | Classification | Target |
|---|---|---|---|---|---|
| `data/datasources/chat_remote_datasource.dart` / `ChatRemoteDataSource` | Data port; repository implementation | Legacy entities and write shape | Repository fake | FREEZE / REMOVE_LATER | No canonical reuse |
| `data/datasources/supabase_chat_datasource.dart` / `SupabaseChatDataSource` | Data; legacy providers | Direct Supabase, client role/IDs, realtime | Indirect fake only | FREEZE / REMOVE_LATER | Backend-owned Conversation API |
| `data/repositories/chat_repository_impl.dart` / `ChatRepositoryImpl` | Data; legacy providers/tests | Legacy datasource and entities | Unit test | FREEZE / REMOVE_LATER | Canonical repository boundary |
| `data/repositories/demo_chat_repository.dart` / `DemoChatRepository` | Data; legacy provider/tests | Simulated authority and assistant output | Unit test | KEEP_BLOCKED / REMOVE_LATER | No Product fallback |
| `domain/entities/chat_session_entity.dart` / `ChatSessionEntity` | Domain; repository/use cases/UI | Raw user/specialist IDs | Indirect tests | FREEZE / REMOVE_LATER | Canonical `Conversation` |
| `domain/entities/message_entity.dart` / `MessageEntity` | Domain; repository/bubble | Free role and attachment fields | Indirect tests | FREEZE / REMOVE_LATER | `ConversationMessage` |
| `domain/repositories/chat_repository.dart` / `ChatRepository` | Domain; use cases/providers | Legacy authority and message stream | Fakes | FREEZE / REMOVE_LATER | `ConversationRepository` |
| `domain/usecases/*` / three use cases | Application; providers/controller | Repository authority and session semantics | Indirect | FREEZE / REMOVE_LATER | Future canonical application layer |
| `presentation/pages/chat_page.dart` / `ChatPage`, `_ChatBody` | UI; wrapper and blocked orchestrator | `agentId`, providers, controller, legacy entities | Block guards only | REWRITE / REMOVE_LATER | Future canonical screen, not implemented |
| `presentation/pages/agent_chat_wrapper.dart` / `AgentChatWrapper` | UI; no active route | Orchestrator agent lookup and `agentId` | Block guards | KEEP_BLOCKED / REMOVE_LATER | No canonical equivalent |
| `presentation/viewmodels/chat_controller.dart` / `ChatController` | State; `ChatPage` | Legacy send authority | Indirect | FREEZE / REMOVE_LATER | Future application controller |
| `presentation/viewmodels/chat_providers.dart` / providers | State; legacy page | Supabase construction, demo fallback, repositories | Architecture guards | FREEZE / REMOVE_LATER | No Product reuse |
| `presentation/viewmodels/chat_viewmodel.dart` | Empty historical stub | No useful invariant | None | REMOVE_LATER | None |
| `presentation/widgets/message_bubble.dart` / `MessageBubble` | UI; `ChatPage` | Legacy entity, free role, `chief_intervention` | None | ADAPT | `ConversationMessageBubble` |
| `presentation/widgets/chat_input.dart` / `ChatInput` | UI; `ChatPage` | Mock attachment and attachment callback | None | REWRITE | `ConversationComposerShell` |
| Generated Riverpod files | Generated state; legacy providers | Frozen provider graph | Build coverage | FREEZE / REMOVE_LATER | Regenerate only during approved removal |

No legacy barrel exists. The only external source import is the blocked
`lib/features/orchestrator/presentation/pages/orchestrator_chat_page.dart` and
is held by an exact architecture-test allowlist.

## 2. Classification

The approved vocabulary is used without a generic KEEP. `MessageBubble` is
ADAPT; `ChatInput` and `ChatPage` are REWRITE; authority-bearing data/domain
and state are FREEZE plus REMOVE_LATER; the wrapper is KEEP_BLOCKED; the empty
viewmodel is REMOVE_LATER.

## 3. Extracted assets

Only alignment, bounded bubble width, visual grouping and content-entry intent
were retained. No source import, model or callback contract crosses from
legacy into canonical presentation.

## 4. Adapted assets

The old role-based bubble became `ConversationMessageBubble`, driven by a
canonical view model. It has dedicated safe system and redacted renderers and
does not understand `role`, `agentId` or legacy entities.

## 5. Frozen assets

All legacy repositories, datasources, entities, use cases, controllers,
providers, pages and generated provider graph remain unchanged and blocked.

## 6. Assets to rewrite

The final Conversation screen, list behavior, scroll orchestration and Product
composition require a later package. `ChatInput` was not moved because mock
attachments violate the content-only contract.

## 7. Canonical components

The local library contains message bubble, system notice, redacted message,
empty/loading/error states and a content-only composer shell. It creates no
page, screen, provider, controller, route or datasource.

## 8. View models

`ConversationMessageViewModel` contains only display-safe message ID, author
label, content, formatted timestamp, visual kind, delivery state, semantics and
redacted state. It contains no owner, credential, runtime, provider or internal
specialist identifier.

## 9. Author visuals

User, Stasis, specialist and system visuals require coherent canonical author
and provenance. An unknown author never maps to Stasis or any renderable view.
Stasis and specialist test fixtures validate rendering contracts only; they do
not represent active generation.

## 10. Visibility visuals

Product-readable visibility is still decided upstream. The mapper additionally
fails closed for `internal`, `unknown`, unknown status/author and incoherent
provenance. `systemVisible` uses the system visual and `redacted` uses the safe
placeholder.

## 11. Redaction

The renderer receives only `Contenido no disponible`; it has no API for the
original content, internal reason, policy metadata or recovery.

## 12. Composer shell

The shell accepts a `TextEditingController` and emits a trimmed user intent.
It has no repository, token, session, idempotency, author, selector, attachment,
retry or transport behavior and is not wired to send.

## 13. Accessibility

Messages use grouped semantic labels including safe author, timestamp and
content. Loading/error states are live regions. Composer and send intent have
labels, keyboard submission and a 48-pixel action target. Author distinction is
not color-only because visible labels are present.

## 14. Responsive behavior

Bubble width derives from available media width and is capped by the existing
design-system maximum. Widget tests cover 320 and 1200 pixel widths, long text
and 2x text scaling inside a scrollable history host.

## 15. Theme

Components use `Theme.of(context).colorScheme`, text theme and existing
`AppSpacing`. No new design system, font, color token or asset was introduced.

## 16. Legacy README

`lib/features/chat/README.md` is the central freeze marker. It records status,
replacement, allowed security/removal work and prohibited feature, route,
consumer, Supabase, fallback and Engine reuse.

## 17. Barrel restrictions

The new `conversations.dart` exports only canonical domain and presentational
primitives. No repository, datasource, provider or legacy export is present.
There was no legacy barrel to alter.

## 18. Guards

Architecture tests hold presentation provider-neutrality, no active wiring,
fail-closed mapping, safe barrel, exact external legacy consumer, fixed direct
Supabase files and blocked/absent routes.

## 19. Component tests

Tests cover user, verified Stasis/specialist visual fixtures, system notice,
redaction, unknown/hidden rejection, long content, timestamps, text scaling,
semantics, keyboard/button intent, empty input, disabled/submitting composer,
states and representative widths. Evidence: 30/30 focal, 97/97 architecture
and 547 Flutter tests with five pre-existing approved skips.

## 20. Legacy tests

No legacy test was removed or weakened. Existing repository tests remain as
historical evidence; new work tests only canonical presentation and freeze
boundaries.

## 21. No active wiring

No canonical provider, page, shell, route or repository call was created. The
composer is an inert intent emitter and no Product consumer imports the barrel.

## 22. Compatibility

Canonical widgets consume only `ConversationMessage`, `MessageAuthor`,
`MessageProvenance`, `MessageVisibility`, `MessageStatus` or the derived view
model. Transitional session/message contracts and blocked dev hosts are
unchanged.

## 23. Extraction matrix

| Legacy symbol | Classification | Canonical replacement | Extracted | Consumers migrated | Legacy remaining | Removal gate | Risk |
|---|---|---|---|---|---|---|---|
| `MessageBubble` | ADAPT | `ConversationMessageBubble` | Yes | None | `ChatPage` | L4-L6 parity | Legacy role path remains blocked |
| `ChatInput` | REWRITE | `ConversationComposerShell` | New safe equivalent | None | `ChatPage` | L4-L6 send parity | Mock attachment remains frozen |
| `ChatPage` / `_ChatBody` | REWRITE | Future screen/composition | No | None | Wrapper/orchestrator | 013F plus L4 | `agentId` ambiguity |
| `AgentChatWrapper` | KEEP_BLOCKED | None | No | None | Frozen source | L5-L7 | Orchestrator dependency |
| Legacy state/data/domain | FREEZE / REMOVE_LATER | Canonical application/repository | No | None | Entire graph | L4-L7 | Direct Supabase and client authority |

## 24. Retirement phase

L0 routes blocked: COMPLETE. L1 freeze and guard: COMPLETE. L2 reusable UI:
COMPLETE for the audited inventory, with full-screen/scroll composition
classified REWRITE rather than reusable. L3 contract/backend boundary:
COMPLETE locally through 013A-013D. L4-L7 remain NOT STARTED.

## 25. Security

No legacy authority, datasource, Supabase, agent ID, owner, token, internal ID,
provenance decision, visibility decision, route, backend or remote operation was
introduced. Unknown/internal values do not render.

## 26. Rollback

Rollback removes the canonical presentation files, tests, README and docs. It
does not reactivate legacy routes or fallback. Legacy source remains physically
available but blocked throughout.

## 27. Debt

The blocked orchestrator import, direct Supabase datasource/provider graph,
legacy entities, pages and generated files remain until replacement, Product
consumer migration, parity, rollback and reference-removal gates are approved.

## 28. Readiness

Canonical Conversation presentation primitives and mapping are adopted
locally. Legacy chat is deprecated and frozen. Canonical screen, Product wiring,
routes and physical removal remain not implemented and unauthorized. Analyzer
has zero errors and 51 inherited infos; Deno remains 86/86 and SQL remains
740/740 after one local no-seed reset.

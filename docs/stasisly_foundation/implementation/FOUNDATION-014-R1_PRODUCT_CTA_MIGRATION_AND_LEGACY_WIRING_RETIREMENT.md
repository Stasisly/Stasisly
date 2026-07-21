# FOUNDATION-014-R1 Product CTA Migration and Legacy Wiring Retirement

## Status

```text
Package: FOUNDATION-014-R1
Implementation: IMPLEMENTED_LOCALLY
Route activation: NOT_IMPLEMENTED
Remote: NOT_AUTHORIZED
```

G7 and the final pushed readiness become effective only when this changeset is
committed and published.

## 1. Baseline and original blocker

The clean baseline was `96c27f2 feat: add canonical conversation application
layer`; `discovery-final-baseline` remained
`7f747e0cf60012ce315216a5486db3c5481f8f60`. FOUNDATION-014 stopped without
changes because four active Product pages were outside its original allowlist.
R1 explicitly authorized those four pages and their direct tests.

## 2. Consumer inventory and classification

| Consumer | Before | Classification | Resolution |
|---|---|---|---|
| Health | `agent.id -> /chat/:id` | `REMOVE_NOW` | Non-actionable safe card |
| Nutrition | `agent.id -> /chat/:id` | `REMOVE_NOW` | Non-actionable safe card |
| Physical Training | `agent.id -> /chat/:id` | `REMOVE_NOW` | Non-actionable safe card |
| Mental Training | `agent.id -> /chat/:id` | `REMOVE_NOW` | Non-actionable safe card |
| Orchestrator prototype | `/orchestrator/chat` | `KEEP_BLOCKED_TEMPORARILY` | Unchanged and blocked |

Each Product page received mock-backed `AgentEntity` values from the frozen
orchestrator catalog, displayed an `AgentCard`, and used `agent.id` as a route
parameter. There was no fallback after the blocked route decision.

## 3. Identifier evidence and selected strategy

`AgentEntity.id` is an organizational/runtime-adjacent legacy identifier. The
four page inputs contain no verified `selectableSpecialistId`, and the approved
selectable-specialist catalog cannot be positionally or nominally mapped to
those agents. R1 therefore uses option B on all four pages: preserve safe display
information and remove the conversation action. No ID mapping and no
`StartConversationIntent` were created.

## 4. Shared safe unavailable presentation

`UnavailableSpecialistCard` accepts only name, specialty, description, color
and a display-only highlight flag. It has no identifier, callback, provider,
repository, router or operation-attempt input. It is not an interactive control
and states honestly: `Conversaciones no disponibles todavía`.

Health, Nutrition, Physical Training and Mental Training use the same component.
Their layout, headings, loading/error states and display data remain intact.

## 5. Router and inactive composition

No router file changed. `/chat/:id`, `/orchestrator` and `/orchestrator/chat`
remain metadata-blocked. `/stasis`, `/conversations` and
`/conversations/:conversationId` remain unregistered. There is no redirect.
`InactiveConversationFeatureHost` remains unroutable, unexported to the active
shell and available only to explicit local tests.

## 6. Resumed FOUNDATION-014 graph audit

- Product pages import no legacy chat repository, controller, datasource,
  session repository or message repository.
- Canonical providers expose `ConversationRepository`, not the transitional
  adapter or its underlying session/message repositories.
- Legacy `ChatRepository`, controller, entities and direct Supabase datasource
  remain confined to frozen `features/chat` code.
- The only `features/chat` import outside that feature remains the blocked
  `orchestrator_chat_page.dart` prototype.
- The only remaining active-looking legacy route call is internal to the
  blocked Development orchestrator page; no Product consumer reaches it.
- The canonical barrel exports no legacy asset and the inactive host is absent
  from active app/routing composition.

## 7. Tests and guards

Four widget cases prove that each page renders its specialist information and
safe unavailable copy without `InkWell` or chat affordance. Architecture guards
reject legacy paths, `agent.id` navigation, Product-to-orchestrator navigation,
repository access, hidden host activation, new external legacy imports and
premature canonical route registration.

Validation evidence:

```text
flutter analyze --no-fatal-infos: 0 errors, 51 inherited infos
flutter test: 605 PASS, 5 APPROVED SKIPS, 0 FAILURES
deno fmt --check supabase/functions: 62 files
deno test supabase/functions: 86/86 PASS
supabase db reset --local --no-seed: PASS, migrations 00001-00012
supabase test db --local: 740/740 PASS
```

The first pgTAP invocation immediately after container restart encountered a
transient local duplicate-extension race. A delayed retry of only
`supabase test db --local` passed 740/740; there was no second reset, schema
change or remote action.

## 8. Static reference audit

```text
Active Product /chat navigation: 0
Active Product orchestrator navigation: 0
Product legacy provider/repository dependencies: 0
Canonical Product routes registered: 0
Approved blocked Development orchestrator CTA: 1
Violations: 0
```

Remaining legacy references are classified as frozen implementation internals,
blocked-route evidence, tests, documentation or approved transitional
infrastructure.

## 9. Retirement phases

```text
L0 Routes blocked: COMPLETE
L1 Freeze and guard: COMPLETE
L2 Extract reusable UI: COMPLETE
L3 Canonical boundaries: COMPLETE LOCALLY
L4 Migrate Product consumers: COMPLETE
L5 Remove routes/providers: PARTIAL
L6 Remove legacy code: NOT STARTED
L7 Verify no references: NOT STARTED
```

L5 cannot be complete while blocked route metadata and frozen providers remain.
L6-L7 require evidence-based physical retirement in a separate package.

## 10. Orchestrator isolation

```text
orchestrator_page.dart CTA: KEEP_BLOCKED_TEMPORARILY
surface: Development / legacy prototype
route: BLOCKED
Product dependency: NONE
blocks Product route activation: NO
requires separate package: YES
```

The prototype is not Stasis Engine, a Product backend, a fallback or an active
route. No orchestrator file changed in R1.

## 11. Route activation gate

`PRODUCT_CONVERSATION_ROUTE_ACTIVATION_READY` is `READY` because there are zero
active Product legacy consumers, zero Product legacy conversation provider
dependencies, zero Product legacy route affordances, a complete inactive
canonical composition, no router fallback and passing environment/security
guards. This readiness does not register or authorize any route.

## 12. Security, rollback and debt

No client-provided owner, role, authority, runtime ID, prompt or environment was
introduced. There are no hidden actions, repository effects, attempt IDs,
backend/schema changes, remote calls or secrets. Rollback is the normal Git
revert of this focal changeset; backend and data rollback are not applicable.

Residual debt:

- replace the mock-backed orchestrator display catalog with the approved Product
  selectable-specialist source under a separate migration;
- retire the blocked orchestrator CTA separately;
- complete L5-L7 only after reference evidence permits physical deletion;
- activate Product routes only through FOUNDATION-015 approval.

## 13. Readiness

Upon successful explicit commit and push:

```text
PRODUCT CONVERSATION_CONSUMERS_MIGRATED_AND_LEGACY_WIRING_RETIRED_LOCAL_AND_PUSHED
```

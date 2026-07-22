# Conversation Asset Adoption Matrix

## FOUNDATION-017 delta

Safe observability contracts are `FOUNDATION_ADOPTED`; NoOp runtime sink,
controller/route instrumentation and post-activation hardening are
`FOUNDATION_ADOPTED_LOCALLY`. Accessibility is `COMPLETED_LOCALLY` with zero
open critical/high findings. Remote observability is `NOT_IMPLEMENTED`.

## FOUNDATION-016-R1 delta

`features/chat`, `OrchestratorChatPage` and the legacy `/chat/:id` route move to
`PHYSICALLY_REMOVED`. Canonical Conversation is `SOLE_PRODUCT_ARCHITECTURE`.
`chat_sessions` and `chat_messages` remain `TRANSITIONAL_AND_ENCAPSULATED` and
must not be exposed as Product API. L0-L7 are complete.

## FOUNDATION-015-R1 delta

Canonical Stasis/list/detail routes, screens and active Product composition are
`FOUNDATION_ADOPTED_LOCALLY`. The inactive host remains test-only. Legacy chat
and orchestrator stay blocked, while their physical removal remains pending.

## FOUNDATION-014-R1 delta

The four Product `/chat/${agent.id}` affordances are removed. Their legacy agent
catalog remains display-only and cannot supply Conversation identity. The safe
unavailable card is adopted locally; the orchestrator CTA remains blocked
Development debt. L4 is complete, L5 partial and L6-L7 not started.

## FOUNDATION-013F delta

Canonical use cases/states are adopted; controllers/providers are adopted
locally; the inactive host is adopted for local validation. The canonical
Product screen/routes and active shell remain not implemented, while legacy
consumer migration remains not started.

## FOUNDATION-013F-R1 delta

The neutral attempt contract/factory and create/send propagation are adopted
locally; datasource-owned generation is removed. Canonical application
composition is now `IMPLEMENTED_LOCALLY` and inactive; Product activation is
`NOT_IMPLEMENTED`,
and no Product consumer, route or remote boundary is active.

## FOUNDATION-013E delta

The complete legacy chat inventory is classified. Safe visual intent is
extracted into canonical route-free components; the legacy feature has a central
freeze README and exact no-spread guards. No consumer is migrated and physical
removal remains blocked.

## FOUNDATION-013D delta

The message table/RPCs, two Message Edge boundaries and Flutter transitional
adapter are adopted locally for backend-owned metadata and SQL visibility
filtering. Endpoint names, `sessionId` and legacy role remain transitional;
Stasis/specialist authoring remains not implemented.

## Metadata

```text
Status: ACTIVE evidence and planning
Implementation authority: NONE
Owner: Product Architecture + Documentation
Approver: Founder for adoption/removal decisions
```

| Asset | Current status | Foundation target | Classification | Reusable invariants | Unsafe coupling/gap | Required package | Adoption gate |
|---|---|---|---|---|---|---|---|
| `lib/features/chat/**` | Physically absent | No Product runtime dependency | PHYSICALLY_REMOVED | Historical evidence in Git/Foundation docs | Recreation risk guarded statically | 016-R1 complete | Zero runtime/test violations |
| Legacy `ChatPage`/wrapper | Physically absent | Canonical `ConversationPage` | REMOVED | No alias or redirect | None in runtime | 016-R1 complete | Static eradication gate |
| Legacy `MessageBubble` | Physically absent after visual intent extraction | Product Message renderer | REMOVED_AFTER_ADAPTATION | Alignment/grouping intent only | None in runtime | 013E + 016-R1 | Canonical mapper/bubble tests |
| Legacy `ChatInput` | Physically absent after safe rewrite | Content composer | REMOVED_AFTER_REWRITE | Text-entry and keyboard intent | Attachments remain unimplemented | 013E + 016-R1 | Content-only shell tests |
| `lib/features/conversations/**` | Canonical local domain/port/adapters/application/presentation/Product screens | Product Conversation boundary | FOUNDATION_ADOPTED_LOCALLY / SOLE_PRODUCT_ARCHITECTURE | Opaque ID, trusted owner, canonical Message metadata, typed controllers/providers and active local Product screens | Remote activation remains | 013A-016-R1 complete locally | Remote gates remain separate |
| `lib/features/chat_sessions/**` | Local-safe/dev-only adapter source | Conversation application/client boundary | TRANSITIONAL_ADAPTER_SOURCE | Explicit ID, backend-blocked states, owner-safe DTO, stable cursor, lifecycle source | Session terminology, dev hosts, no Product route | 013A-013C complete | Canonical lifecycle adapter implemented; physical naming retained |
| `lib/features/chat_messages/**` | Local-safe/dev-only adapter source | Product Message boundary | TRANSITIONAL_ADAPTER_SOURCE | Content-only send, explicit ID, sanitization, metadata validation | Session/role vocabulary; Stasis/specialist authoring absent | 013A and 013D complete | Canonical fail-closed adapter implemented |
| `lib/features/specialists/**` | Product-safe runtime catalog boundary | Product specialist selection | FOUNDATION_ADOPTED_LOCALLY | `selectableSpecialistId`, exact five-field public model | Remote activation remains gated | 019C complete locally; later Engine package separate | Public reference and Stasis create adopted; no internal IDs |
| `lib/features/orchestrator/**` | Legacy blocked prototype | No Product/Engine reuse | REWRITE_CANDIDATE / HISTORICAL_ONLY | No executable invariant adopted | Static agents, route confusion, not Stasis Engine | 014 for Engine design | Separate Agent Constitution; no legacy import |
| Eight Edge Functions | Local Product boundaries | Versioned Conversation APIs | ADAPT / KEEP_TEMPORARILY | Backend authz, ownership, DTOs, cursors; canonical Message metadata/filtering | Compatibility names remain; Stasis/specialist writes absent | 013D complete | API parity, negative auth, rollback |
| `chat_sessions` table | Transitional persistence | Conversation storage or migration source | ADAPT | Owner, timestamps, archive, count, stable ID | Specialist binding, limited lifecycle, legacy name | 013B + data review | Approved migration/compatibility plan |
| `messages` table | Transitional persistence | Product Messages plus separate provenance | FOUNDATION_ADOPTED_LOCALLY / TRANSITIONAL_NAME | Required session FK, content bounds, closed metadata, SQL visibility order | Legacy role/session naming; attachments disabled | 013D complete; privacy review later | No trace conflation; migration tests pass locally |
| `conversation_idempotency` | Local server-managed write ledger | Product write idempotency support | FOUNDATION_ADOPTED_LOCALLY | Subject/operation/key scope, SHA-256 fingerprint, deny-all clients | No automatic retention/metrics; physical backend remains transitional | Privacy/operations follow-up | Retention decision, cleanup and observability |
| `specialist_catalog` | Product catalog prepared | Sanitized selection boundary | ADAPT | Product-only surface, publication/availability/tier guards | Functional/runtime bridge not implemented | Catalog/Engine packages | Versioned backend-only bridge |
| `specialists` table | Internal legacy specialist definition | Future approved definition adapter | ADAPT_CANDIDATE | Internal identity lookup currently required | Prompt/category/runtime concepts co-located | 014/later data package | Registry separation and no public exposure |
| Current dev routes | Development-only and guarded | Test hosts only until a separately approved Product route package | KEEP_TEMPORARILY | Explicit `sessionId`, environment guards | Not Product UX | Later route package, not 013F | Product routes separate; dev guards retained |
| `/chat/:id` | Physically absent | No route/fallback | REMOVED | Generic unknown-route handling | Recreation/redirect risk guarded | 016-R1 complete | Zero registrations and redirects |
| `/orchestrator*` | LEGACY_BLOCKED | No Product/Engine route | KEEP_BLOCKED_TEMPORARILY | Explicit blocked metadata | Engine confusion remains controlled debt | Separate future decision | No Product/Conversation imports |
| Modern tests/harnesses | Passing local evidence | Regression baseline for Conversation adapters | ADAPT / KEEP | Ownership, sanitization, cleanup, content-only, cursors | Session naming and dev-only assumptions | Every 013 child | Equal/stronger coverage and CI later |
| Legacy chat tests | Removed with source | Retirement guards only | REMOVED / MIGRATED_TO_GUARD | Historical repository behavior remains in Git | None in active tests | 016-R1 complete | Eradication and transitional-preservation guards pass |

## Adoption rule

No `ADAPT_CANDIDATE` becomes Foundation-adopted by documentation alone. Each
asset requires an approved child package, explicit files, security/privacy/UX
review as applicable, tests, compatibility evidence and rollback. `REMOVE`
requires replacement implementation and Founder-approved Product transition.

## FOUNDATION-019C adoption delta

| Asset | Decision | Evidence | Remaining boundary |
|---|---|---|---|
| Selectable specialist Product port/controller/adapter | FOUNDATION_ADOPTED_LOCALLY | Strict five-field contract and Product tests | Remote use separately authorized |
| Stasis catalog-driven create | FOUNDATION_ADOPTED_LOCALLY | Explicit selection and canonical navigation tests | Other Product-area CTAs blocked |
| Development fixture contract | FOUNDATION_ADOPTED | Versioned lifecycle and ownership contract | No remote fixture executable |
| Local fixture cleanup | FOUNDATION_ADOPTED_LOCALLY | Two local API cycles and exact cleanup | Remote cleanup remains unauthorized |
| Remote evidence schemas | FOUNDATION_ADOPTED_LOCALLY | Closed schemas/templates and negative validator tests | External evidence NOT_STARTED |
| Idempotency retention cleanup | DEFER / GATED | Audit lacks approved duration/actor/cutoff | Resolve before sustained operation |

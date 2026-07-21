# Conversation Asset Adoption Matrix

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
| `lib/features/chat/**` | Frozen legacy feature with exact external-consumer guard | No Product runtime dependency | DEPRECATED_AND_FROZEN / REMOVE_LATER | Audited visual reference only | Client `userId`/`specialistId`/`role`, Supabase direct, realtime, `agentId` | 013E complete; L4-L7 later | Replacement, parity, no references |
| Legacy `ChatPage`/wrapper | Frozen and route-blocked | Canonical Conversation screen | REWRITE / REMOVE_LATER | No component adopted; layout intent audited | `agentId` starts session; legacy providers/entities | 013F/later L4 | Canonical composition and accessibility parity |
| Legacy `MessageBubble` | Frozen component | Product Message renderer | ADAPT completed locally | Alignment/grouping intent only | Original still uses legacy entity and `chief_intervention` | 013E complete | `ConversationMessageBubble` tested; consumer migration pending |
| Legacy `ChatInput` | Frozen component | Content composer | REWRITE completed as safe shell | Text-entry and keyboard intent only | Original mock attachment remains frozen | 013E complete; attachments later | Content-only shell tested; wiring pending |
| `lib/features/conversations/**` | Canonical local domain/port/adapters/application/presentation/Product screens | Product Conversation boundary | FOUNDATION_ADOPTED_LOCALLY | Opaque ID, trusted owner, canonical Message metadata, typed controllers/providers and active local Product screens | Physical legacy implementation and remote activation remain | 013A-015-R1 complete locally | Physical retirement and remote gates remain separate |
| `lib/features/chat_sessions/**` | Local-safe/dev-only adapter source | Conversation application/client boundary | TRANSITIONAL_ADAPTER_SOURCE | Explicit ID, backend-blocked states, owner-safe DTO, stable cursor, lifecycle source | Session terminology, dev hosts, no Product route | 013A-013C complete | Canonical lifecycle adapter implemented; physical naming retained |
| `lib/features/chat_messages/**` | Local-safe/dev-only adapter source | Product Message boundary | TRANSITIONAL_ADAPTER_SOURCE | Content-only send, explicit ID, sanitization, metadata validation | Session/role vocabulary; Stasis/specialist authoring absent | 013A and 013D complete | Canonical fail-closed adapter implemented |
| `lib/features/specialists/**` | Sanitized catalog boundary | Product specialist selection | ADAPT | `selectableSpecialistId`, six-field public model | Runtime/catalog bridge absent | 013A contract complete; later Engine package | Public reference adopted; no internal IDs |
| `lib/features/orchestrator/**` | Legacy blocked prototype | No Product/Engine reuse | REWRITE_CANDIDATE / HISTORICAL_ONLY | No executable invariant adopted | Static agents, route confusion, not Stasis Engine | 014 for Engine design | Separate Agent Constitution; no legacy import |
| Eight Edge Functions | Local Product boundaries | Versioned Conversation APIs | ADAPT / KEEP_TEMPORARILY | Backend authz, ownership, DTOs, cursors; canonical Message metadata/filtering | Compatibility names remain; Stasis/specialist writes absent | 013D complete | API parity, negative auth, rollback |
| `chat_sessions` table | Transitional persistence | Conversation storage or migration source | ADAPT | Owner, timestamps, archive, count, stable ID | Specialist binding, limited lifecycle, legacy name | 013B + data review | Approved migration/compatibility plan |
| `messages` table | Transitional persistence | Product Messages plus separate provenance | FOUNDATION_ADOPTED_LOCALLY / TRANSITIONAL_NAME | Required session FK, content bounds, closed metadata, SQL visibility order | Legacy role/session naming; attachments disabled | 013D complete; privacy review later | No trace conflation; migration tests pass locally |
| `conversation_idempotency` | Local server-managed write ledger | Product write idempotency support | FOUNDATION_ADOPTED_LOCALLY | Subject/operation/key scope, SHA-256 fingerprint, deny-all clients | No automatic retention/metrics; physical backend remains transitional | Privacy/operations follow-up | Retention decision, cleanup and observability |
| `specialist_catalog` | Product catalog prepared | Sanitized selection boundary | ADAPT | Product-only surface, publication/availability/tier guards | Functional/runtime bridge not implemented | Catalog/Engine packages | Versioned backend-only bridge |
| `specialists` table | Internal legacy specialist definition | Future approved definition adapter | ADAPT_CANDIDATE | Internal identity lookup currently required | Prompt/category/runtime concepts co-located | 014/later data package | Registry separation and no public exposure |
| Current dev routes | Development-only and guarded | Test hosts only until a separately approved Product route package | KEEP_TEMPORARILY | Explicit `sessionId`, environment guards | Not Product UX | Later route package, not 013F | Product routes separate; dev guards retained |
| `/chat/:id`, `/orchestrator*` | LEGACY_BLOCKED | No route/fallback | DEPRECATE then REMOVE | Recognition for safe blocked response | `agentId` ambiguity and Engine confusion | 013E/013F | Replacement live, rollback, no references |
| Modern tests/harnesses | Passing local evidence | Regression baseline for Conversation adapters | ADAPT / KEEP | Ownership, sanitization, cleanup, content-only, cursors | Session naming and dev-only assumptions | Every 013 child | Equal/stronger coverage and CI later |
| Legacy chat tests | Retained historical evidence plus freeze guards | Retirement guards only | KEEP_BLOCKED / REMOVE_LATER | Repository behavior inventory | Unsafe contracts remain frozen | 013E guard complete | No weakening; remove only with L4-L7 evidence |

## Adoption rule

No `ADAPT_CANDIDATE` becomes Foundation-adopted by documentation alone. Each
asset requires an approved child package, explicit files, security/privacy/UX
review as applicable, tests, compatibility evidence and rollback. `REMOVE`
requires replacement implementation and Founder-approved Product transition.

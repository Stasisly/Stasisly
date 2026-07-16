# Conversation Asset Adoption Matrix

## Metadata

```text
Status: ACTIVE evidence and planning
Implementation authority: NONE
Owner: Product Architecture + Documentation
Approver: Founder for adoption/removal decisions
```

| Asset | Current status | Foundation target | Classification | Reusable invariants | Unsafe coupling/gap | Required package | Adoption gate |
|---|---|---|---|---|---|---|---|
| `lib/features/chat/**` | Blocked legacy feature | No Product runtime dependency | DEPRECATED_AND_BLOCKED | Visual reference only | Client `userId`/`specialistId`/`role`, Supabase direct, realtime, `agentId` | 013E | Replacement, parity, no references |
| Legacy `ChatPage`/wrapper | Blocked | Canonical Conversation screen | REWRITE_CANDIDATE | Basic loading/input layout reference | `agentId` starts session; legacy providers/entities | 013E/013F | Canonical contracts and accessibility review |
| Legacy `MessageBubble` | Blocked component | Product Message renderer | ADAPT_CANDIDATE | Bubble/alignment visual pattern | Legacy entity and `chief_intervention` role | 013D/013E | New author/visibility model and widget tests |
| Legacy `ChatInput` | Blocked component | Content composer | REWRITE_CANDIDATE | Text-entry interaction reference | Mock attachment and attachment-bearing callback | 013E; attachments later | Content-only contract, accessibility, no mock upload |
| `lib/features/chat_sessions/**` | Local-safe/dev-only | Conversation application/client boundary | ADAPT | Explicit ID, backend-blocked states, owner-safe DTO, cursor | Session terminology, dev hosts, no Product route | 013A-013C | Canonical ID adapter, tests, Product approval |
| `lib/features/chat_messages/**` | Local-safe/dev-only | Product Message boundary | ADAPT | Content-only send, explicit ID, sanitization, error preservation | Session/role vocabulary, no provenance/visibility | 013A/013D | Canonical author/provenance and contract tests |
| `lib/features/specialists/**` | Sanitized catalog boundary | Product specialist selection | ADAPT | `selectableSpecialistId`, six-field public model | Runtime/catalog bridge absent | 013A and later Engine package | No internal IDs; approved bridge |
| `lib/features/orchestrator/**` | Legacy blocked prototype | No Product/Engine reuse | REWRITE_CANDIDATE / HISTORICAL_ONLY | No executable invariant adopted | Static agents, route confusion, not Stasis Engine | 014 for Engine design | Separate Agent Constitution; no legacy import |
| Six Edge Functions | Local Product boundaries | Versioned Conversation APIs | ADAPT / KEEP_TEMPORARILY | Backend authz, ownership, DTOs, cursors, atomic send | Current names, provider adapter, create TOCTOU, no idempotency | 013A-013D | API parity, negative auth, rollback |
| `chat_sessions` table | Transitional persistence | Conversation storage or migration source | ADAPT | Owner, timestamps, archive, count, stable ID | Specialist binding, limited lifecycle, legacy name | 013B + data review | Approved migration/compatibility plan |
| `messages` table | Transitional persistence | Product Messages plus separate provenance | ADAPT | Required session FK, content bounds, stable ordering | Role model, no visibility/provenance, attachments disabled | 013D + privacy review | No trace conflation; migration tests |
| `specialist_catalog` | Product catalog prepared | Sanitized selection boundary | ADAPT | Product-only surface, publication/availability/tier guards | Functional/runtime bridge not implemented | Catalog/Engine packages | Versioned backend-only bridge |
| `specialists` table | Internal legacy specialist definition | Future approved definition adapter | ADAPT_CANDIDATE | Internal identity lookup currently required | Prompt/category/runtime concepts co-located | 014/later data package | Registry separation and no public exposure |
| Current dev routes | Development-only and guarded | Test hosts only until Product route package | KEEP_TEMPORARILY | Explicit `sessionId`, environment guards | Not Product UX | 013F | Product routes separate; dev guards retained |
| `/chat/:id`, `/orchestrator*` | LEGACY_BLOCKED | No route/fallback | DEPRECATE then REMOVE | Recognition for safe blocked response | `agentId` ambiguity and Engine confusion | 013E/013F | Replacement live, rollback, no references |
| Modern tests/harnesses | Passing local evidence | Regression baseline for Conversation adapters | ADAPT / KEEP | Ownership, sanitization, cleanup, content-only, cursors | Session naming and dev-only assumptions | Every 013 child | Equal/stronger coverage and CI later |
| Legacy chat tests | Limited legacy evidence | Retirement guards only | DEPRECATE | Reference for behavior inventory | Can preserve unsafe contracts | 013E | No new feature coverage; reference scan empty |

## Adoption rule

No `ADAPT_CANDIDATE` becomes Foundation-adopted by documentation alone. Each
asset requires an approved child package, explicit files, security/privacy/UX
review as applicable, tests, compatibility evidence and rollback. `REMOVE`
requires replacement implementation and Founder-approved Product transition.

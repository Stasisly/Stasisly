# FOUNDATION-005 Asset Classification Matrix

Status: **ACTIVE evidence**. Classifications are recommendations, not execution
authority.

| Asset | Evidence | Foundation requirement | Conformance | Classification | Risk | Recommended action | Dependencies | Blocking status |
|---|---|---|---|---|---|---|---|---|
| Flutter core/config | `lib/core/`, fail-closed env and guards | Owned boundaries and surface contexts | PARTIALLY_CONFORMANT | ADAPT_CANDIDATE | Transitional vocabulary and global coupling | Preserve gates; add Foundation contexts later | Identity/API plan | P1 |
| App bootstrap | `lib/main.dart`, `lib/app.dart` | Provider-neutral client bootstrap | NON_CONFORMANT | REWRITE_CANDIDATE | Supabase is initialized as backend identity | Move behind owned adapter in planned increments | Identity/API ports | P1 |
| Auth | `lib/features/auth/` | Owned identity/session contract | NON_CONFORMANT | REWRITE_CANDIDATE | Direct Supabase boundary | Replace behind Stasisly identity port | Auth architecture | P1 |
| Legacy chat | `lib/features/chat/` | Backend authority; no client authority fields | NON_CONFORMANT | DEPRECATE_CANDIDATE | Direct writes, `role`, IDs and legacy routes | Keep disconnected and retire after replacement | Modern chat/auth | P1 |
| Chat sessions | `lib/features/chat_sessions/` and tests | Explicit session ownership and safe contract | PARTIALLY_CONFORMANT | ADAPT_CANDIDATE | Dev-only and incomplete identity/API boundary | Preserve DTOs/controllers; replace adapters | Auth/API | P1 |
| Chat messages | `lib/features/chat_messages/` and tests | Content-only send; explicit session ID | PARTIALLY_CONFORMANT | ADAPT_CANDIDATE | Dev-only and provider-backed transport | Preserve contracts; adopt through owned API | Auth/API | P1 |
| Specialists | `lib/features/specialists/` | Sanitized Product catalog separate from registry | PARTIALLY_CONFORMANT | ADAPT_CANDIDATE | Runtime blocked; tier/surface still transitional | Preserve DTO; define owned catalog API | Catalog/API | P1 |
| Profile | `lib/features/profile/` | Minimal own-profile contract | PARTIALLY_CONFORMANT | ADAPT_CANDIDATE | No executable Foundation adapter | Preserve contract; add owned adapter later | Identity/API | P1 |
| Health/Nutrition | one prototype page each | Product domain with sensitive-data controls | PARTIALLY_CONFORMANT | ADAPT_CANDIDATE | UI precedes domain/privacy model | Retain only as prototype pending Product plan | Product/data governance | P2 |
| Mental/physical training | prototype pages and routes | Wellness/Training vocabulary | PARTIALLY_CONFORMANT | ADAPT_CANDIDATE | Naming, routing and domain mismatch | Decide taxonomy before rename | Product ADR | P2 |
| Orchestrator prototype | static UI and route | Engine isolated from Product UI | NON_CONFORMANT | REWRITE_CANDIDATE | Could be mistaken for Stasis Engine | Preserve as historical prototype only | Engine architecture | P1 |
| Product routing | `lib/core/config/routes.dart` | Surface-isolated owned routes | NON_CONFORMANT | REWRITE_CANDIDATE | Legacy chat/orchestrator exposed | Plan replacement routes and guards | Auth/surfaces | P1 |
| Dev-only routes | guarded route tests | Development isolation | CONFORMANT | KEEP_CANDIDATE | Promotion risk if guard removed | Preserve and extend guard tests | Environment policy | Not blocking |
| Migrations 00001-00008 | local reset and static audit | Deny by default, explicit domains | NON_CONFORMANT | ADAPT_CANDIDATE | Ten public tables lack RLS/revokes | Minimum deny-all hardening package | Security/DB review | P0 blocker |
| `send_user_message_core` RPC | migration 00007 and pgTAP | Atomic backend-authoritative write | PARTIALLY_CONFORMANT | KEEP_CANDIDATE | Supabase grants and ownership context | Preserve behavior; review owned API boundary | PostgreSQL/Auth | P1 |
| Six Edge Functions | Deno tests and source | Owned API, authz, bounded execution | PARTIALLY_CONFORMANT | ADAPT_CANDIDATE | Supabase Auth/PostgREST/runtime coupling | Retain public contracts; introduce ports | API/identity | P1 |
| CORS/runtime guards | shared source and 8 Deno tests | Fail-closed environment/origin policy | PARTIALLY_CONFORMANT | KEEP_CANDIDATE | Edge runtime coupling | Preserve behavior; extract policy if needed | API runtime | P2 |
| Supabase SQL tests | 16 pgTAP files executed | Security and schema invariants | PARTIALLY_CONFORMANT | ADAPT_CANDIDATE | P0 tables have no coverage | Add deny-all regression coverage | P0 migration | P0 blocker |
| Flutter architecture guards | 10 files, passing | Prevent boundary regressions | PARTIALLY_CONFORMANT | KEEP_CANDIDATE | Foundation surface/access gaps | Preserve and extend after designs | F7 plan | P1 |
| Other Flutter tests | 54 files, passing/skipped | Product behavior and safe contracts | PARTIALLY_CONFORMANT | ADAPT_CANDIDATE | Demo/Discovery assumptions | Rebaseline incrementally | Feature plans | P2 |
| CI workflows | Flutter-only CI/manual builds | Complete reproducible security pipeline | PARTIALLY_CONFORMANT | ADAPT_CANDIDATE | Backend/security suites absent | Add staged Deno/pgTAP/security gates | CI plan | P2 |
| Dependencies | `pubspec.yaml` and import audit | Minimal portable dependency set | PARTIALLY_CONFORMANT | ADAPT_CANDIDATE | Provider coupling and unused candidates | Review use, licenses and exit costs | Feature plans | P2 |
| Android/iOS/Web | manifests/project skeletons | Secure multiplatform Product clients | PARTIALLY_CONFORMANT | ADAPT_CANDIDATE | Release/deep-link/privacy readiness absent | Audit per release phase | F11/F12 | P3 |
| Wearable runtime | no implementation evidence | Wearable-ready contracts | NOT_IMPLEMENTED | UNKNOWN | Future integration debt | Design contracts only when authorized | F3/F8 | P4 |
| Stasis Engine runtime | no implementation evidence | Isolated governed Engine | NOT_IMPLEMENTED | UNKNOWN | Prototype naming confusion | Do not reuse orchestrator as Engine | F5/F6 | Future gate |

## P0 scope

The only P0 identified by this audit is the repository-defined PostgreSQL
deny-by-default gap. It must be resolved without combining it with schema
redesign, feature work, provider migration or remote deployment.

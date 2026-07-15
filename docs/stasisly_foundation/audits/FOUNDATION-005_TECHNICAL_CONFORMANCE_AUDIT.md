# FOUNDATION-005 Technical Conformance Audit

## Metadata

| Field | Value |
|---|---|
| Status | ACTIVE evidence, non-normative |
| Baseline | `e053684 docs: define global technical architecture` |
| Discovery baseline | `7f747e0`, tag `discovery-final-baseline` |
| Scope | Executable repository assets and technical configuration |
| Method | Static inspection plus isolated local test evidence |
| Remote systems | Not inspected or modified |

## Executive conclusion

The inherited codebase contains useful, well-tested local-safe components, but
it is not Foundation-conformant as a whole. Modern chat session/message
contracts, backend runtime guards, sanitized DTOs, bounded pagination and local
tests are credible adaptation candidates. The legacy Flutter chat/auth paths,
provider-owned boundaries, incomplete surface isolation and missing Foundation
authorization model require remediation.

One P0 repository-defined security blocker was confirmed locally. Ten legacy
`public` tables have RLS disabled and retain broad table privileges for `anon`
and `authenticated`. This statement does not assert the state of any remote
database. The minimum next package must harden those tables and add regression
tests before the wider remediation plan proceeds.

Passing historical tests is recorded as evidence, not as proof of Foundation
conformance.

## Audit method and inventory

- Flutter production: 135 Dart files under `lib/`.
- Flutter tests: 64 files, including 10 architecture guards.
- Supabase: 8 migrations, 6 Edge Functions, 27 function/runtime files and 8
  Deno test files.
- Database tests: 38 SQL/psql assets and 11 shell harnesses.
- CI: 2 GitHub Actions workflows.
- Platforms: Android, iOS and Web skeletons.
- Configuration: `pubspec.yaml`, `analysis_options.yaml`, `.env.example`,
  `.gitignore`, `supabase/config.toml` and root `README.md`.

The detailed asset decision is in
`FOUNDATION-005_ASSET_CLASSIFICATION_MATRIX.md`; test outcomes are in
`FOUNDATION-005_TEST_EVIDENCE.md`.

| Category / path | Purpose | Surface / runtime | Data accessed | Provider coupling | Security / tests | Audit action |
|---|---|---|---|---|---|---|
| `lib/` | Flutter Product client and dev hosts | Product + Development / Flutter | Identity, profile, catalog, sessions and messages | Supabase, Riverpod, GoRouter, Dio | High; 64 Flutter test files | Adapt by feature; do not bulk-refactor |
| `test/architecture/` | Static architecture invariants | Development / Dart test | Source text and contracts | Flutter project layout | High; 10 passing guards | Preserve and extend |
| `test/core/`, `test/features/`, `test/integration/` | Unit, widget and opt-in integration behavior | Development / Flutter test | Synthetic/demo and optional dev data | Feature adapters | High; 54 files, five opt-in skips | Rebaseline incrementally |
| `supabase/migrations/` | PostgreSQL schema, grants and RPC | Shared infrastructure / PostgreSQL | All persisted application domains | PostgreSQL + Supabase roles | Critical; clean reset and pgTAP | Adapt; P0 hardening required |
| `supabase/functions/` | HTTP backend handlers | Shared infrastructure / Deno Edge | Auth identity, catalog, sessions, messages | Supabase Auth, PostgREST, Edge runtime | Critical; 52 Deno tests | Adapt behind owned API contracts |
| `supabase/tests/` | Schema/security/fixture regression | Development / pgTAP, psql, shell | Synthetic local DB rows | Supabase CLI + PostgreSQL | Critical; 38 SQL/psql and 11 shell assets | Preserve core invariants; add P0 coverage |
| `.github/workflows/` | CI and manual builds | Development / GitHub Actions | Repository/build artifacts | GitHub, Flutter toolchain | High; 2 workflows | Adapt before staging |
| `pubspec.yaml`, `pubspec.lock` | Dependency baseline | Product + Development / Dart | Not applicable | Multiple SDK/providers | Supply-chain relevant | Review, no update in audit |
| `analysis_options.yaml` | Static-analysis policy | Development / analyzer | Source code | Flutter lints | Medium; analyzer passed | Keep candidate |
| `.env.example`, `.gitignore`, `supabase/config.toml` | Environment template, secret isolation and local stack | Development / build and local runtime | Configuration only | Supabase local conventions | Critical; placeholders/ignore rules inspected | Keep/adapt vocabulary |
| `android/`, `ios/`, `web/` | Platform launch/build skeletons | Product / platform runtimes | No domain data by themselves | Flutter/platform SDKs | Release/privacy relevant | Adapt per release phase |
| root `README.md` | Repository introduction | Shared documentation | None | None | Non-executable | Adapt to Foundation authority later |

## Flutter architecture

The repository uses feature-oriented folders and, in newer chat/profile/catalog
features, separates domain, data, application and presentation concerns. Those
boundaries are not global. `lib/main.dart` initializes Supabase directly in
backend modes, while legacy auth and chat expose provider-specific behavior to
the client. Riverpod and GoRouter are established client patterns.

Backend authority is mixed. Newer repositories validate allowlisted contracts,
fail closed and avoid silent demo fallback. Legacy chat allows client-side
`userId`, `specialistId` and `role`, and performs direct Supabase operations.
No Foundation RBAC, ABAC, JIT elevation, Founder context or technical surface
context exists.

## Flutter feature findings

| Feature | Current responsibility and entry | Evidence | Conformance | Classification |
|---|---|---|---|---|
| `auth` | Supabase session, login and registration | Direct Supabase imports; provider-coupled models/repository | NON_CONFORMANT | REWRITE_CANDIDATE |
| `chat` | Legacy chat UI/state/data at `/chat/:id` and `/orchestrator/chat` | Direct Supabase, client authority fields, demo repository | NON_CONFORMANT | DEPRECATE_CANDIDATE |
| `chat_sessions` | Own-session create/list/archive, safe shell and dev host | Explicit `selectableSpecialistId`/`sessionId`, strict DTOs, fail-closed adapters | PARTIALLY_CONFORMANT | ADAPT_CANDIDATE |
| `chat_messages` | Own-session message list/send and dev-only route | Explicit `sessionId`, content-only send contract, strict DTOs | PARTIALLY_CONFORMANT | ADAPT_CANDIDATE |
| `specialists` | Sanitized selectable Product catalog | Six-field DTO, backend-blocked non-demo provider | PARTIALLY_CONFORMANT | ADAPT_CANDIDATE |
| `profile` | Minimal own-profile contract and presentation | Sanitized contracts; executable backend still blocked | PARTIALLY_CONFORMANT | ADAPT_CANDIDATE |
| `health` | Prototype Product page | UI-only evidence; no approved sensitive-data domain | PARTIALLY_CONFORMANT | ADAPT_CANDIDATE |
| `nutrition` | Prototype Product page | UI-only evidence | PARTIALLY_CONFORMANT | ADAPT_CANDIDATE |
| `mental_training` | Prototype page and legacy route vocabulary | Naming, routing and domain mapping differ from Wellness | PARTIALLY_CONFORMANT | ADAPT_CANDIDATE |
| `physical_training` | Prototype page and legacy route vocabulary | Naming, routing and domain mapping differ from Training | PARTIALLY_CONFORMANT | ADAPT_CANDIDATE |
| `orchestrator` | Static-agent Product UI prototype | UI/static data only; no Engine runtime | NON_CONFORMANT | REWRITE_CANDIDATE |

`lib/features/admin/`, `calendar`, `file_processing` and `membership` contain no
production Dart files. They do not demonstrate Administration capabilities.

## Chat and routing findings

- `/conversations` is not registered.
- `/chat/:id` is registered and its `id` is a legacy agent identifier, not a
  safe session identifier.
- `/orchestrator/chat` remains a legacy Product route.
- `/dev/chat/composed` and `/dev/chat/session/:sessionId` are explicitly guarded
  by development mode and non-release execution.
- The orchestrator route is a prototype entry, not Stasis Engine.
- No Administration routes were found.

The modern chat paths are credible adaptation candidates, but they remain
development/local-safe and depend on incomplete auth/API boundaries. They must
not be promoted by reusing the legacy routes.

## Auth, identity and environment findings

The current identity provider returns an explicit demo identity and fails in
other modes. Secure session abstractions avoid exposing tokens in public state,
but coexist with Supabase-specific legacy auth. No user-controlled metadata role
was found in the guarded modern identity path.

Environment handling recognizes `local`, `demo`, `development`, `staging`,
`production` and transitional `backendReal`. Backend execution is fail-closed;
development remote access needs explicit enablement, and staging/production are
blocked by the audited Edge runtime guard. `backendReal` conflicts with the
Foundation environment vocabulary and should be retired through a later plan.
The tracked environment template contains placeholders and safe defaults; real
local environment files are ignored.

## Database and migration findings

The eight migrations create and evolve 15 `public` tables plus the
`send_user_message_core` RPC. Useful invariants include ownership columns,
message constraints, catalog publication/availability constraints, Product
surface constraints, canonical access tiers and bounded public contracts.

| Migration | Main assets | RLS / grants / ownership | Foundation result | Classification |
|---|---|---|---|---|
| `00001_initial_schema.sql` | 14 legacy public tables and four indexes | Ownership columns are uneven; default client grants remain | NON_CONFORMANT source of P0 and mixed domains | ADAPT_CANDIDATE |
| `00002_enable_rls_public_users_deny_all.sql` | `users` | Enables RLS with no policy | PARTIALLY_CONFORMANT stepping stone | KEEP_CANDIDATE |
| `00003_public_users_owner_profile_minimal.sql` | owner profile policies | Revokes table privileges; grants minimal columns to authenticated owner | PARTIALLY_CONFORMANT, Supabase claim-coupled | KEEP_CANDIDATE |
| `00004_create_specialist_catalog_deny_all.sql` | `specialist_catalog`; hardens `specialists` | RLS on, all client table privileges revoked, no policies | PARTIALLY_CONFORMANT backend-only posture | ADAPT_CANDIDATE |
| `00005_harden_chat_sessions_deny_all.sql` | session constraints and owner listing index | RLS on, client privileges revoked, no policies | PARTIALLY_CONFORMANT | ADAPT_CANDIDATE |
| `00006_harden_messages_deny_all.sql` | message constraints and stable listing index | RLS on, client privileges revoked, no policies | PARTIALLY_CONFORMANT | ADAPT_CANDIDATE |
| `00007_create_send_user_message_core_rpc.sql` | transactional message RPC | Invoker security, service-role-only execute, explicit owner input checked under lock | PARTIALLY_CONFORMANT and portable core | KEEP_CANDIDATE |
| `00008_prepare_product_catalog_schema.sql` | publication, availability, hierarchy, locale, metadata, surfaces, tiers and indexes | Reasserts catalog/specialist deny-all; trigger helper grants revoked | PARTIALLY_CONFORMANT; Product catalog remains provider-hosted | ADAPT_CANDIDATE |

RLS is enabled on `users`, `specialists`, `specialist_catalog`,
`chat_sessions` and `messages`. `users` has a minimal owner policy and narrowed
column grants. The other four hardened tables use deny-all client posture.

The following repository-defined tables have RLS disabled and broad table
privileges for both `anon` and `authenticated`:

```text
memberships
user_memberships
branch_chiefs
subcategory_chiefs
user_health_data
calendar_events
reminders
orchestator_summaries
chief_write_permissions
specialist_temporary_disables
```

This violates deny-by-default and surface/ownership isolation. The typo
`orchestator_summaries` and the mixed Product/Administration/agent concepts in a
single public schema are additional legacy debt. Remote deployment state was
not inspected.

## Edge Functions and shared controls

All six functions authenticate bearer tokens through Supabase Auth and use a
service-role backend client for data access. Inputs and outputs are allowlisted,
ownership failures are generally opaque, logs are constrained, CORS is
allowlisted and runtime execution fails closed.

- `send-user-message` delegates the write to `send_user_message_core`; the RPC
  locks the session and atomically inserts the message and updates counters.
- Session/message list operations use stable bounded cursor pagination.
- `create-own-chat-session` performs separate catalog/specialist checks and an
  insert, so catalog state can change between checks; each valid request creates
  a new session and has no idempotency key.
- Archive uses a narrow conditional direct update and opaque not-found result,
  but no transaction/RPC or idempotency contract.
- No rate limiter, quota or cost controller was found.

These functions are ADAPT_CANDIDATE: their public contracts and tests are
valuable, while Auth, PostgREST and Edge runtime remain provider-owned
boundaries.

| Function | Contract and authority | Atomicity / concurrency | Coverage | Result |
|---|---|---|---|---|
| `create-own-chat-session` | Input only `selectableSpecialistId`; derives user; sanitized response | Separate catalog/specialist checks and insert; no idempotency | 8 Deno tests | ADAPT_CANDIDATE |
| `list-own-chat-sessions` | Own sessions, strict catalog join, public fields | Stable bounded cursor; broken catalog fails whole response | 7 Deno tests | ADAPT_CANDIDATE |
| `archive-own-chat-session` | Input only `sessionId`; opaque missing/foreign/archived | Narrow conditional PATCH; no RPC/idempotency | 5 Deno tests | ADAPT_CANDIDATE |
| `list-selectable-specialists` | Exact Product predicate and six public fields | Read-only, bounded list and strict validation | 11 Deno tests | ADAPT_CANDIDATE |
| `list-session-messages` | Own active/archived session; sanitized roles | Read-only stable bounded cursor; no counter writes | 6 Deno tests | ADAPT_CANDIDATE |
| `send-user-message` | Inputs only `sessionId`/`content`; role set server-side | Calls atomic RPC only; no direct writes | 7 Deno tests | ADAPT_CANDIDATE |

## Tests and CI

Flutter architecture guards capture durable invariants around sanitized DTOs,
no direct provider use in modern features, explicit session identifiers and
dev-only routing. Supabase tests cover hardened tables, transactional messaging,
fixtures and cleanup. They do not test the ten unprotected legacy tables.

`ci.yml` runs Flutter dependency resolution, code generation, analysis and
tests for pull requests and manual runs. `build.yml` manually builds Android APK
and Web. CI does not run Deno, pgTAP, migration reset, secret scanning,
dependency review or platform/security checks; build artifacts are not handled
as a signed release supply chain.

## Dependencies and portability

Active client dependencies include Supabase Flutter, Riverpod, GoRouter, Dio
and Google Fonts. Supabase client/Auth, PostgREST and Edge Functions are
provider-owned runtime boundaries. PostgreSQL schema and the non-`SECURITY
DEFINER` RPC are comparatively portable, but grants and Auth integration remain
Supabase-specific.

Declared packages with no imports found in `lib/` or `test/` include secure
storage, Firebase packages, Google Sign-In, Sentry, shared preferences, file and
image pickers, cached network images. This is an `UNUSED_CANDIDATE` signal only;
generated/platform use and product intent require review before removal.

No Supabase Storage or Realtime use was found in production Dart. No
Stasisly-owned identity API or provider adapter boundary is complete.

## Platforms

Android, iOS and Web are standard Flutter skeletons. No Product deep links,
wearable capabilities, associated domains or background modes were evidenced.
The iOS bundle identifier is `com.stasisly.stasisly`. Internet permission is
present in Android debug/profile manifests; no sensitive Product permission was
identified in the main manifest. Wearable readiness is NOT_IMPLEMENTED.

## Security, data and operations

Modern DTO minimization, token redaction, safe logs, host policies and
fail-closed repositories are positive evidence. The P0 table exposure in the
repository-defined schema prevents an overall secure classification.

The schema contains profile, conversation, membership, calendar and
health-related data models. A comment claiming encryption at rest is not proof
of application-level encryption or a complete control. Retention, deletion,
provenance, regional controls and auditable consent are not implemented as a
Foundation data program. No claim of legal compliance is made.

Pagination bounds current session/message/catalog reads. No unbounded polling
or implemented AI-agent loop was found. Rate limits, quotas, token accounting,
storage retention, cost metrics and agent runtime controls are NOT_IMPLEMENTED.

## Surface mapping

| Asset | Current surface | Expected surface | Cross-surface risk | Action |
|---|---|---|---|---|
| Product pages, profile, catalog | Product | Product | Backend/auth boundaries incomplete | Adapt |
| Legacy chat/orchestrator routes | Product | Product via owned API; Engine separate | Provider bypass and Engine confusion | Deprecate/rewrite |
| Dev-only chat hosts and tests | Development | Development | Accidental Product promotion | Preserve gates, adapt |
| Migrations, RPC, Edge Functions | Shared infrastructure | Owned API/domain/infrastructure layers | Shared must not mean universal access | Harden and adapt |
| Empty admin feature | Unknown | Administration | No capability or access model exists | Define later |
| Stasis Engine runtime | Not implemented | Platform / Stasis Engine | Prototype could be mislabeled | Keep boundary; design later |

## Decisions and limitations

- No implementation, test, migration, function, workflow, dependency or
  platform file was changed.
- No remote system was queried or modified.
- The local database was rebuilt without seeds and tested with synthetic local
  fixtures only.
- Static inspection cannot prove remote state, production readiness, legal
  compliance or absence of every runtime defect.
- Asset classifications are audit recommendations; they do not authorize
  remediation or removal.

## Required next gate

Before FOUNDATION-006, execute a separately approved minimum package:

```text
FOUNDATION-005-R1 — Harden legacy public tables deny-all
```

Its scope should be limited to a versioned migration that enables RLS and
removes client privileges from the ten identified legacy tables, plus local
regression tests proving zero permissive policies/grants and successful clean
reset. It must not redesign domains, add Product behavior, touch remote systems
or silently rename legacy schema.

# FOUNDATION-018 - Development environment and controlled remote preparation

## 1. Status and scope

```text
Package: FOUNDATION-018
Decision scope: Development preparation only
Remote execution: NOT AUTHORIZED
Remote validation: NOT EXECUTED
Staging: NOT AUTHORIZED
Production: NOT AUTHORIZED
```

Preparation is not deployment. The repository contains no assigned remote
project, remote host, credential value or linked Supabase CLI context. This
package does not start FOUNDATION-019A.

## 2. Previous block and FOUNDATION-019B resolution

The original preflight stopped because ignored Supabase CLI link metadata could
implicitly select a remote target. FOUNDATION-019B removed the active markers,
preserved unrelated local cache and added a read-only guard. Baseline
`3e51942` was clean and synchronized when this package resumed; Discovery remains
anchored at `7f747e0`.

The mandatory remote-context preflight returned `SAFE`, while
`supabase/.temp/project-ref` and `supabase/.temp/pooler-url` were absent. No
marker was read for its value and no remote lookup was attempted.

## 3. Sources and authority note

The requested paths `docs/stasisly_foundation/ARCHITECTURE.md` and
`docs/stasisly_foundation/PROJECT_DEFINITION.md` do not exist. Their Discovery
predecessors are archived under `docs/archive/discovery/root/` and are
non-normative. The active technical authority reviewed here is
`05_GLOBAL_TECHNICAL_ARCHITECTURE.md`, together with the Foundation roadmap,
authority register, FOUNDATION-017, FOUNDATION-019B and ADR-F020/F022.

## 4. Environment definitions

| Environment | Definition | Remote state |
|---|---|---|
| Local | Developer-controlled machine, local Supabase, synthetic/test data, no linked project context | `ENABLED_LOCALLY` |
| Development | Isolated non-production project, dedicated users and synthetic data, restricted operators, auditable release and rollback | `NOT_AUTHORIZED` |
| Staging | Production-like validation environment | `NOT_AUTHORIZED` |
| Production | Real users and operational data | `NOT_AUTHORIZED` |

Stasis Engine is a system boundary, not an environment. `backendReal` remains a
legacy/transitional runtime label and grants no capability.

## 5. Development contract

- Initial surface: Product only.
- Users: dedicated synthetic identities on an explicit allowlist.
- Data: synthetic and non-production only; production copies are forbidden.
- AI, Stasis Engine and payments: disabled.
- Notifications and external integrations: disabled unless separately approved.
- Observability: non-content, non-identity, separately approved and retained.
- Retention and cleanup: explicit before execution.
- Rollback evidence: mandatory before any modifying action.

Development is not equivalent to Production and cannot be promoted implicitly.

## 6. Capability matrix

| Capability | Local | Development preparation | Staging | Production |
|---|---|---|---|---|
| Product routes | `ENABLED_LOCALLY` | `PLANNED_FOR_DEVELOPMENT` | `NOT_AUTHORIZED` | `NOT_AUTHORIZED` |
| Authentication | `ENABLED_LOCALLY` | `PLANNED_FOR_DEVELOPMENT` | `NOT_AUTHORIZED` | `NOT_AUTHORIZED` |
| Conversation list/read | `ENABLED_LOCALLY` | `PLANNED_FOR_DEVELOPMENT` | `NOT_AUTHORIZED` | `NOT_AUTHORIZED` |
| Conversation create | `ENABLED_LOCALLY` | `BLOCKED_BY_DEPENDENCY` | `NOT_AUTHORIZED` | `NOT_AUTHORIZED` |
| Message send | `ENABLED_LOCALLY` | `PLANNED_FOR_DEVELOPMENT` | `NOT_AUTHORIZED` | `NOT_AUTHORIZED` |
| Archive/restore | `ENABLED_LOCALLY` | `PLANNED_FOR_DEVELOPMENT` | `NOT_AUTHORIZED` | `NOT_AUTHORIZED` |
| Observability | `ENABLED_LOCALLY` | `NOT_AUTHORIZED` | `NOT_AUTHORIZED` | `NOT_AUTHORIZED` |
| AI / Stasis Engine | `DISABLED` | `DISABLED` | `NOT_AUTHORIZED` | `NOT_AUTHORIZED` |
| Payments / notifications | `DISABLED` | `DISABLED` | `NOT_AUTHORIZED` | `NOT_AUTHORIZED` |
| Admin operations | `DISABLED` | `NOT_AUTHORIZED` | `NOT_AUTHORIZED` | `NOT_AUTHORIZED` |

The Development create smoke test remains `BLOCKED_BY_RUNTIME_CATALOG` until a
separate package confirms a suitable synthetic runtime catalog.

## 7. Flutter configuration and validation

`Env` reads compile-time configuration; `AppEnvironment` owns interpretation and
startup validation; `main.dart` invokes the fail-closed startup gate. Future
Development selection requires all of:

```text
APP_MODE: development
BACKEND_TARGET_ENVIRONMENT: development
SUPABASE_URL: complete client-safe HTTPS configuration
SUPABASE_ANON_KEY: complete environment-scoped client configuration
ENABLE_REMOTE_BACKEND: true
ENABLE_REAL_DATA: false
explicit caller authorization: present
```

The environment is not inferred from the hostname. Unknown modes, missing or
partial configuration, placeholders, embedded URL credentials, target mismatch,
implicit local/demo remote selection and any staging/production attempt block.
Errors expose only a category and safe reason; they never echo host, URL, key,
project identifier or token. A service-role credential is never accepted by
Flutter.

The new `BACKEND_TARGET_ENVIRONMENT` variable defaults to `unassigned` in the
versionable example. The example contains names, empty values and safe defaults
only; no `.env.development` is versioned.

## 8. Configuration and secret inventory

| Name/category | Classification | Runtime owner |
|---|---|---|
| `APP_MODE`, `BACKEND_TARGET_ENVIRONMENT`, feature gates | `PUBLIC_CONFIGURATION` | Flutter build operator |
| `SUPABASE_URL` | `CLIENT_SAFE_CONFIGURATION` | Environment operator |
| `SUPABASE_ANON_KEY` | `CLIENT_SAFE_CONFIGURATION` and environment-scoped | Environment operator |
| `SUPABASE_SERVICE_ROLE_KEY` | `SERVER_SECRET` | Supabase/Edge runtime custodian |
| JWT signing/configuration material | `SERVER_SECRET` | Auth custodian |
| allowed origins and redirect configuration | `PUBLIC_CONFIGURATION` | Security-approved operator |
| `SYNTHETIC_ACCESS_TOKEN` | `OPERATOR_ONLY_SECRET` | Dedicated test operator |
| observability credentials | `DEPLOYMENT_SECRET` | Future approved observability custodian |
| future integration credentials | `FUTURE_INTEGRATION_SECRET` | Future named integration owner |

Variables are inventory entries, not values. The Founder retains total access,
explicit elevation authority and approval traceability.

### Ownership protocol

| Category | Creator/custodian | Readers and injection | Rotation/revocation | Prohibited locations |
|---|---|---|---|---|
| Client-safe environment config | Named Development operator | Approved build only | Operator records replacement and verifies old build retirement | source literals, logs, shared chat |
| Server secrets | Supabase/Auth custodian | Server runtime secret store only | Custodian rotates; operator validates revocation | Flutter, Git, examples, CI output |
| Test token | Dedicated test-user operator | Ephemeral local runner | Revoke user/session after run | Git, docs, screenshots, logs |
| Deployment secrets | Named release operator | Approved environment scope | Rotate after exposure or role change | unscoped CI, local examples |

## 9. Supabase Development prerequisites

Before any future authorization, Development requires a dedicated project,
database, auth tenant/users, storage, Edge Functions, secrets, redirect policy,
API keys, logs and backups. None may be shared with Production. No such project
is identified or created by this package.

## 10. Migration inventory

| Migration | Purpose / dependencies | Affected assets | Security and rollback | Development readiness |
|---|---|---|---|---|
| `00001_initial_schema.sql` | Inherited initial schema; base dependency | users, memberships, specialists, sessions, messages and legacy tables | Historical broad schema; later migrations harden it; DDL restore/forward fix required | `LOCALLY_VALIDATED` |
| `00002_enable_rls_public_users_deny_all.sql` | Enable deny-all baseline after 00001 | users | RLS on, no positive policy; forward fix | `LOCALLY_VALIDATED` |
| `00003_public_users_owner_profile_minimal.sql` | Minimal own-profile access | users policies/column grants | Owner-only select/update; explicit revokes; policy/grant rollback | `LOCALLY_VALIDATED` |
| `00004_create_specialist_catalog_deny_all.sql` | Sanitized empty catalog | specialist_catalog, specialists | Client deny-all; no seeds; drop only under separate destructive approval | `LOCALLY_VALIDATED` |
| `00005_harden_chat_sessions_deny_all.sql` | Transitional session hardening | chat_sessions | RLS, zero client policy/grant; data compatibility checks | `LOCALLY_VALIDATED` |
| `00006_harden_messages_deny_all.sql` | Transitional message hardening | messages | RLS, zero client policy/grant; role/session constraints | `LOCALLY_VALIDATED` |
| `00007_create_send_user_message_core_rpc.sql` | Atomic send and session counters | messages, chat_sessions, RPC | Not security definer; restricted execute grants; function forward fix | `LOCALLY_VALIDATED` |
| `00008_prepare_product_catalog_schema.sql` | Product catalog contracts | specialist_catalog | Constraints/indexes, RLS preserved, no client opening; non-trivial DDL rollback | `LOCALLY_VALIDATED` |
| `00009_harden_legacy_public_tables_deny_all.sql` | Close ten inherited tables | ten legacy tables | RLS deny-all, policies/grants removed; privilege forward fix | `LOCALLY_VALIDATED` |
| `00010_add_conversation_idempotency_and_transactional_creation.sql` | Atomic create/send replay safety | idempotency ledger, sessions/messages RPCs | Ledger inaccessible to client, restricted RPCs; retention pending | `LOCALLY_VALIDATED` |
| `00011_add_canonical_conversation_read_and_lifecycle.sql` | Owner-scoped list/read/archive/restore | sessions, lifecycle RPCs/index | Opaque denial, restricted execute; forward function/schema fix | `LOCALLY_VALIDATED` |
| `00012_add_message_author_provenance_and_visibility.sql` | Canonical message metadata/filtering | messages, read function | Visibility enforced before pagination; schema/function forward fix | `LOCALLY_VALIDATED` |

Ordering is deterministic. The local audit found no personal paths, real user
IDs, remote project IDs or unsafe remote dependency. Required RLS, restricted
grants and explicit function `search_path` are covered by the existing pgTAP
suite. This evidence means `MIGRATION_SET_LOCALLY_VALIDATED`; it does not mean
remote application or remote schema equivalence.

## 11. Future migration execution and drift

Required sequence:

```text
Founder authorization
-> exact Development target and operator confirmation
-> published commit confirmation
-> backup/rollback point
-> read-only preflight
-> ordered migration application
-> migration history, grants and RLS verification
-> smoke tests
-> recorded evidence
```

A future authorized read-only comparison must detect missing/unexpected remote
migrations, manual edits, grant drift, RLS drift, function drift and
configuration drift. That remote comparator is `NOT_IMPLEMENTED` and
`REQUIRES_REMOTE_AUTHORIZATION`.

Rollback prefers a forward fix. Backup restore is reserved for verified
incompatibility or unsafe partial application and requires an operator decision.
Function, configuration and client artifacts roll back independently, followed
by history/grant/RLS/smoke verification. Automatic DDL reversal is not promised;
destructive migrations need separate approval.

## 12. Edge Function inventory and manifest

All functions use verified JWT input, backend-derived identity, registered
Product surface/environment/action context, bounded service-role operations,
safe logging and explicit CORS/runtime guards.

| Function | Purpose / ownership | Idempotency | Smoke and rollback |
|---|---|---|---|
| `archive-own-chat-session` | Archive owned conversation | naturally idempotent lifecycle RPC | owner/foreign checks; redeploy prior artifact |
| `create-own-chat-session` | Create from selectable specialist | required request attempt + server ledger | replay/conflict/catalog checks; prior artifact |
| `list-own-chat-sessions` | List owned active/all conversations | read-only | pagination/ownership checks; prior artifact |
| `list-selectable-specialists` | Sanitized Product catalog | read-only | published Product-only rows; prior artifact |
| `list-session-messages` | Visible history for owner | read-only | archived history and opacity; prior artifact |
| `read-own-conversation` | Canonical owner detail | read-only | own/foreign/unknown lifecycle; prior artifact |
| `restore-own-conversation` | Restore owned conversation | naturally idempotent lifecycle RPC | replay/foreign checks; prior artifact |
| `send-user-message` | Atomic user-authored message | required request attempt + server ledger | replay/conflict/counters; prior artifact |

Each entry point is `supabase/functions/<name>/index.ts`. Required configuration
names are recorded in the machine-readable manifest. Server secrets remain
names only. Expected commit is `UNASSIGNED`; deployment and approval are
`NOT_EXECUTED` and `NOT_GRANTED`.

## 13. CORS, authentication and authorization

Development CORS may include only approved Flutter-web Development origins,
explicit local emulator origins, native mobile clients and approved Development
admin tooling. A remote wildcard is forbidden; any local-only wildcard cannot
be promoted.

Authentication requires dedicated test users, explicit account ownership,
bounded session/refresh policy, cleanup and credential rotation. OAuth and real
redirect URLs remain disabled/unassigned.

Authorization must preserve verified JWT, request context, operation registry,
PDP/PEP, surface/environment metadata, backend ownership and opaque foreign
resource behavior. Development receives no permissive policy and Flutter gets no
admin bypass.

Future RLS evidence must show anonymous and authenticated direct protected-table
denial, bounded server operations, restricted RPC grants, cross-owner denial,
unknown-lifecycle denial and inaccessible idempotency records. None is remotely
verified here.

## 14. Data, retention and observability

Fixtures must be synthetic, repeatable, owner-known, namespaced and cleaned
after every run. Production copies and realistic personal/health data are
forbidden. Retention decisions are required for conversations, messages,
idempotency records, auth users, logs, events, fixtures and backups.
`conversation_idempotency` cleanup/retention remains explicit debt; no automatic
cleanup is invented.

`REMOTE_OBSERVABILITY` is `NOT_AUTHORIZED`. A future sink needs approval,
retention/readers/deletion ownership and must exclude content, identity, raw
resource IDs, tokens and attempt IDs. No provider or SDK is selected.

## 15. Deployment actors and confirmation guard

Project creation, linking, migration application, function deployment, secret
injection, auth configuration and rollback each require a named operator, exact
Development target, published commit, Founder approval and evidence. Immediately
before a future action, the authorized operator must see:

```text
expected environment: development
resolved project identifier: explicit to operator
staging match: false
production match: false
commit: explicit
operator: explicit
Founder authorization: present
```

A generic confirmation is insufficient. Remote target resolution is not part of
this package.

## 16. Local readiness preflight and deployment manifest

`tool/check_development_readiness.dart` is read-only and network-free. It embeds
the remote-context guard and validates exact migration/function inventories,
documented public configuration, safe examples, capability completeness, five
disabled skips and an unapproved/unassigned/non-executed manifest. Findings use
safe reason text and paths only.

The manifest lives at
`docs/stasisly_foundation/development/development_deployment_manifest.json`.
It contains no project ID, URL, key or secret value. Its required state is:

```text
environment: development
project identifier: UNASSIGNED
expected commit: UNASSIGNED
approval: NOT_GRANTED
deployment: NOT_EXECUTED
remote validation: NOT_EXECUTED
```

The parser rejects approval, target assignment, execution state, inventory drift,
enabled skips and secret-like values.

## 17. Smoke tests and remote integration policy

The future suite covers authentication, `/stasis`, `/conversations`, opaque
detail, active/archived lists, selectable-specialist create, idempotent send,
archive/restore, foreign-owner denial, legacy `/chat` absence, blocked
Orchestrator and environment enforcement. All are `NOT_EXECUTED`; create is
`BLOCKED_BY_RUNTIME_CATALOG`.

Remote integration requires dedicated Development users and namespace,
idempotent setup, cleanup after every run, no external notifications, no
parallel manual use, rate limits and bounded retries.

### Five approved skips

| Source | Reason / data / cleanup | Activation gate | Status |
|---|---|---|---|
| `test/integration/two_b_iv_h_local_http_chat_sessions_integration_test.dart` | Explicit local sessions harness; synthetic fixture; transactional cleanup | local harness only | `CLASSIFIED_NOT_ENABLED` |
| `test/integration/two_b_v_g_local_http_chat_messages_integration_test.dart` | Explicit local messages harness; synthetic fixture; transactional cleanup | local harness only | `CLASSIFIED_NOT_ENABLED` |
| `test/features/chat_sessions/data/development_remote_read_test.dart` | Remote read fixture; no writes | Founder approval + exact Development target | `CLASSIFIED_NOT_ENABLED` |
| `test/features/chat_sessions/data/development_remote_write_test.dart` | Synthetic create/send/archive; mandatory cleanup | Founder approval + exact target + cleanup rehearsal | `CLASSIFIED_NOT_ENABLED` |
| `test/features/chat_messages/presentation/development_remote_ux_read_test.dart` | Remote read and transitional UX assertions | Founder approval + canonical Product review | `CLASSIFIED_NOT_ENABLED` |

Required names, risks and cleanup are fully represented in the manifest; no
credential value is stored.

## 18. CI, branch and release evidence

Existing `.github` workflows were audited read-only; this package creates no
deployment workflow. Future validation and deployment workflows must be
separate. Deployment needs environment-scoped secrets, manual approval, exact
target/commit verification and rollback evidence; service-role material must
never reach Flutter.

Only clean `main`, a published commit, passing local gates, synchronized docs,
approved ADR, safe remote-context guard, recorded Founder authorization and an
exact Development target may proceed. Dirty, unpublished, detached or
unapproved revisions are forbidden.

Future evidence includes commit, target, operator, approval reference,
migration/function/config inventories, secret names, local results, remote
preflight, timestamp, smoke results and rollback reference. Values are not
fabricated here.

## 19. Failure and rollback drills

| Failure | Detection/containment | Rollback/verification | Owner and impact |
|---|---|---|---|
| Wrong environment | target mismatch guard; stop before action | clear context, repeat explicit confirmation | operator; release blocked |
| Bad public config | startup completeness/mismatch failure | restore prior build config; retest startup | Flutter/release owner |
| Bad function artifact | smoke/error reason regression | redeploy prior approved artifact; rerun owner/opacity checks | backend operator |
| Migration failure | history/transaction mismatch | stop, assess partial state, forward fix or approved restore | DB operator |
| RLS regression | deny/grant gate failure | revoke/forward-fix before traffic | security + DB owner |
| Auth misconfiguration | dedicated-user/session checks fail | disable route/runtime and restore auth policy | auth operator |
| CORS failure | explicit-origin smoke fails | restore prior allowlist, never wildcard remote | security operator |
| Client points wrong | target category mismatch | block startup and replace build | release operator |

These are documentary/local drills only.

## 20. Security checklist

| Control | State |
|---|---|
| Dedicated project/users/backups/redirects | `REQUIRED_BEFORE_REMOTE_EXECUTION` |
| Synthetic data; no Production data | `FOUNDATION_ADOPTED` |
| RLS and grant verification | `REQUIRED_BEFORE_REMOTE_EXECUTION` |
| Migrations/functions inventoried | `LOCALLY_AUDITED` |
| Secrets classified and owned | `FOUNDATION_ADOPTED` |
| CORS scoped | `REQUIRED_BEFORE_REMOTE_EXECUTION` |
| Logs sanitized; remote sink absent | `FOUNDATION_ADOPTED_LOCALLY` |
| Rollback and cleanup planned | `FOUNDATION_ADOPTED` |
| CLI remote context absent | `FOUNDATION_ADOPTED_LOCALLY` |
| Founder approval required | `FOUNDATION_ADOPTED` |

Items requiring a real target are gates, not concealed completion claims.

## 21. Readiness levels, tests and guards

Adopted levels are `NOT_READY`, `DOCUMENTATION_READY`,
`LOCAL_PREFLIGHT_READY`, `READY_FOR_EXPLICIT_REMOTE_AUTHORIZATION`,
`AUTHORIZED_FOR_REMOTE_EXECUTION` and `REMOTE_VALIDATED`.

Local tests cover remote-context integration, environment matrix, completeness,
placeholder/secret rejection, manifest schema/state, migration/function
inventories, skip classification, no-network architecture, mismatches and safe
errors. Guards reject linked markers, concrete remote configuration in examples,
remote-capable tooling, ambiguous database commands, approved/assigned manifest,
inventory drift, secret values and skip activation.

The final local regressions must include analyzer, Flutter, Deno format/tests,
one explicit local no-seed reset and pgTAP. No local result is remote evidence.

## 22. Package security and rollback

This package adds no remote action, project identifier, URL, real secret,
service-role Flutter use, production data, staging/production activation,
observability sink, AI, Stasis Engine or fallback. Rollback is deletion of the
manifest/preflight/docs/tests and reversion of the config contract; it must not
restore CLI link metadata or weaken existing environment/security gates.

## 23. Debt and readiness

- Exact Development project/operator/commit: `UNASSIGNED` until separately
  authorized.
- Runtime catalog for create smoke: `BLOCKED_BY_RUNTIME_CATALOG`.
- Idempotency retention: decision pending.
- Remote RLS/grants/schema/CORS/auth/smoke evidence: `NOT_EXECUTED`.
- Remote observability, staging and Production: `NOT_AUTHORIZED`.
- FOUNDATION-019A: not started.

With documentation synchronized, local preflight/tests passing and no critical
local blocker, this package may reach
`READY_FOR_EXPLICIT_REMOTE_AUTHORIZATION`. A later Founder decision must choose
FOUNDATION-019A or FOUNDATION-019C; neither begins implicitly.

## 24. Local validation evidence

```text
Remote-context guard: SAFE
Development readiness preflight: SAFE
Flutter analyze: 0 errors, 36 inherited infos
Flutter tests: 647 PASS, 5 APPROVED SKIPS, 0 FAILURES
Deno format: 62 files checked
Deno tests: 86/86 PASS
Local database reset: PASS, --local --no-seed
SQL: 24 files, 740/740 PASS
Remote actions: 0
Remote network calls: 0
```

## 25. Foundation adoption and gates

```text
Development environment contract: FOUNDATION_ADOPTED
Development capability matrix: FOUNDATION_ADOPTED
Configuration readiness: FOUNDATION_ADOPTED_LOCALLY
Secret inventory: FOUNDATION_ADOPTED
Secret ownership: FOUNDATION_ADOPTED
Migration readiness: LOCALLY_AUDITED
Edge Function inventory: LOCALLY_AUDITED
Local readiness preflight: FOUNDATION_ADOPTED_LOCALLY
Deployment manifest: FOUNDATION_ADOPTED_LOCALLY_UNAPPROVED
Remote smoke-test plan: FOUNDATION_ADOPTED
Remote skips: CLASSIFIED_NOT_ENABLED
Development remote execution: NOT AUTHORIZED
Development remote validation: NOT EXECUTED
Staging: NOT AUTHORIZED
Production: NOT AUTHORIZED
Remote observability: NOT AUTHORIZED
```

G0-G6 are locally complete. G7 closes only after the exact explicit commit and
push complete successfully. G8-G10 are not executed. Additional gate evidence:

```text
REMOTE_CONTEXT_GUARD: SAFE
REMOTE_ACTIONS_EXECUTED: 0
REMOTE_NETWORK_CALLS: 0
REAL_SECRETS_ADDED: 0
REMOTE_IDENTIFIERS_ADDED: 0
REMOTE_SKIPS_ENABLED: 0
DEPLOYMENT_MANIFEST_APPROVAL: NOT_GRANTED
```

## FOUNDATION-019A-R1 continuation

La preparación se endurece con manifests separados, cleanup exacto de éxito y
fallo, gate multifactor y CORS fail-closed. `allowedWebOriginStatus` permanece
`UNASSIGNED`, `remoteTests` permanece `NOT_ENABLED` y cualquier ejecución exige
nueva autorización commit-specific.

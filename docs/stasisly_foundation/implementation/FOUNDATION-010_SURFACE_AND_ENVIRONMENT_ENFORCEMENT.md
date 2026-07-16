# FOUNDATION-010 — Surface and Environment Enforcement

## Metadata

| Field | Value |
|---|---|
| Package | FOUNDATION-010 |
| Status | IMPLEMENTED LOCALLY / VALIDATED |
| Owner | Architecture + Security under Rector |
| Baseline | `d5b58fb feat: add authorization context and policy contracts` |
| Decision | ADR-F007 |
| Remote operations | NOT AUTHORIZED / NOT EXECUTED |

## 1. Scope and inventory

FOUNDATION-010 introduces a client-side defense-in-depth boundary. Backend
authorization remains final and no route decision grants ownership,
entitlement, role, elevation or remote authority.

| Path or symbol | Previous state | Foundation surface | Environments | Auth | Backend authority | Legacy | Action |
|---|---|---|---|---|---|---|---|
| `main` / `App` | bootstrap | Product bootstrap | known configuration only | n/a | n/a | current | app may start without authorizing a capability |
| `routerProvider` | implicit route policy | boundary owner | explicit per entry point | secure session | mandatory downstream | adapted | registry + typed enforcement |
| `/onboarding`, `/login`, `/register` | public | Product auth entry | local/demo/development/staging/production | public | required for auth operations | current | explicit public metadata |
| `/health` | Product prototype | Product | local/development | authenticated | required downstream | current | guarded |
| `/nutrition` | Product prototype | Product | local/development | authenticated | required downstream | current | guarded |
| `/physical` | legacy naming | Product | local/development | authenticated | required downstream | current naming debt | guarded |
| `/mental` | legacy naming | Product | local/development | authenticated | required downstream | current naming debt | guarded |
| `/chat/:id` | active legacy chat | LEGACY_BLOCKED | none | n/a | n/a | deprecated | recognized but never constructs chat |
| `/orchestrator` | active prototype | LEGACY_BLOCKED | none | n/a | n/a | deprecated | removed from Product shell and blocked |
| `/orchestrator/chat` | active prototype | LEGACY_BLOCKED | none | n/a | n/a | deprecated | recognized but never constructs prototype |
| `/dev/chat/composed` | dev host | Development | local/development + runtime gate | public host; secure token downstream | mandatory | development-only | guarded; absent in release |
| `/dev/chat/session/:sessionId` | dev host | Development | local/development + runtime gate | public host; secure token downstream | ownership mandatory | development-only | guarded; explicit `sessionId` |
| `OwnChatSessionsPanelDevHost` | direct dev host | Development | local/development only by registered host | secure session downstream | mandatory | development-only | not exported as Product route |
| `OwnChatMessagesSafeShell` | direct dev shell | Development | local/development only by registered host | secure session downstream | mandatory | development-only | no Product promotion |
| `ownProfileRepositoryProvider` | demo/backend-blocked selection | Product repository entry | local/development | authenticated | ownership + profile PDP/PEP | current | boundary before repository selection |
| `selectableSpecialistsRepositoryProvider` | demo/backend-blocked selection | Product repository entry | local/development | authenticated | catalog authority mandatory | current | boundary before repository selection |
| local chat HTTP datasources | local transport | Development | host allowlist + local/development | bearer from secure session | final | local-safe | unchanged; not Product API |
| profile/specialist remote datasources | disconnected candidates | Product | no new activation | required | final | candidate | unchanged and backend-blocked |

No `/conversations` route, Administration route, Platform route or Shared
Infrastructure route was created. Deep links resolve through the same registry;
unknown paths receive the safe not-available state.

## 2. Classification

- `PRODUCT`: auth entries and the four existing area routes.
- `DEVELOPMENT`: two secure chat hosts with local/development allowlist.
- `LEGACY_BLOCKED`: agent chat and both orchestrator paths.
- `ADMINISTRATION`: metadata vocabulary only, no route.
- `PLATFORM_INTERNAL`: metadata vocabulary only, no UI route.
- `UNKNOWN`: never allowed.

## 3. Contracts

`SurfaceBoundary` compares typed expected and actual `AuthorizationSurface`
values. Unknown or mismatch returns a typed deny and never remaps.

`EnvironmentBoundary` checks the typed runtime mapping against the entry-point
allowlist. Unknown and mismatch deny. Runtime enablement can only narrow access;
it cannot widen an environment allowlist.

`EntryPointContext` contains surface, environment, enum entry-point ID,
authentication requirement, authorization requirement, legacy state and a
correlation ID. It contains no token, payload or Flutter authority object.

`BoundaryDecision` supports `allow`, `deny`, `redirectToAuthentication`,
`blockedByEnvironment`, `blockedBySurface`, `legacyBlocked` and `notAvailable`,
with typed reason and safe-message keys.

## 4. Router enforcement

The existing GoRouter remains in use. Every registered route is sourced from
`EntryPointRegistry`, and `_route` applies the boundary before invoking its
child builder. Public auth entries are explicit Product entries and do not
inherit access to protected routes. Protected Product entries redirect to
onboarding when the owned secure-session state is unauthenticated.

The default location is the existing `/health` route. The orchestrator item was
removed from `AppShell`. Legacy URLs remain recognizable only to return a safe
blocked state; their pages and repositories are not imported by the router.

Development routes are registered only outside release builds and allow only
`local` or `development` when `ALLOW_DEV_ROUTES` is effective. Demo, staging,
production and `backendReal` cannot authorize them.

## 5. Product entry points

Existing Product routes are tagged Product and restricted to local/development
for this package. This does not add complete domain authorization. Profile
retains its existing ownership-aware PDP/PEP before any remote call.
Specialists retains sanitized DTOs and the backend-blocked repository. Both
providers now run the Product entry boundary before implementation selection;
demo is not an implicit Product fallback.

## 6. Development chat

Chat sessions/messages remain Development/local-safe. The route accepts only
explicit `sessionId`; token acquisition, backend ownership, local host allowlist
and fail-closed repositories remain unchanged. No Product route was added and
legacy `agentId` is never interpreted as `sessionId`.

## 7. Inactive surfaces and production

Administration is not implemented. Platform and Shared Infrastructure expose no
user UI. Orchestrator remains legacy blocked and is not Stasis Engine, Stasis,
Nexus, Rector or Gerendi.

Production can bootstrap under its existing configuration rules, but all newly
gated Product and Development capabilities deny. No production permission,
remote adapter or remote operation was added.

## 8. Environment mapping

The single mapping is `AppEnvironmentAuthorizationMapper`:

```text
local -> local
demo -> demo
development -> development
staging -> staging
production -> production
backendReal -> unknown -> deny
```

Unrecognized `APP_MODE` still fails configuration parsing. There is no
production-to-development, staging-to-development, remote-to-local or
unknown-to-demo fallback.

## 9. Enforcement composition

```text
entry-point metadata
-> surface boundary
-> environment boundary
-> authentication requirement
-> optional Foundation policy requirement
-> UI/repository PEP
-> repository/backend call
-> backend ownership and authorization (final)
```

The generic route boundary does not claim that every Product domain operation
has complete PDP coverage.

## 10. Audit and safe UI

Denied auditable decisions use the existing `AuthorizationAuditSink`. The local
sink remains no-op. The minimized event includes enum-derived entry point,
surface, environment, decision/reason, correlation ID and legacy state. It has
no token, payload, health data, conversation content or provider internals.

UI responses use stable messages for unavailable, authentication-required,
environment-blocked, denied and legacy-unavailable states. A denial never builds
the protected child, activates demo or falls through to another surface.

## 11. Guards and tests

Added tests cover Product/Development allows, staging/production denies,
cross-surface mismatch, unknown/missing metadata, `backendReal`, legacy paths,
inactive surfaces, public/protected auth entries, policy failure, minimized
audit and real router navigation. Architecture guards require explicit metadata,
no Administration/Platform/shared UI, no legacy constructors, no Product import
of Development hosts and no demo Development gate.

Historical tests changed only where they encoded demo access, literal route
declarations, active legacy chat/orchestrator construction or the legacy auth
controller as router authority. Negative tests remain active.

## 12. Compatibility, security and residual debt

The route names `/physical` and `/mental` remain legacy naming debt. Legacy code
is preserved but unreachable through active routing. Demo repositories remain
available only through explicit test-only providers/classes, not runtime
Product fallback. Backend surface enforcement, persistent RBAC/ABAC/JIT,
Founder Elevated, audit storage, Administration, Stasis Engine, remote and
production authorization remain unimplemented.

The repository also contains pre-existing formatter debt in unrelated legacy
files; FOUNDATION-010 does not include that churn.

## 13. Rollback

Revert the FOUNDATION-010 commit. Rollback must not reactivate legacy chat or
orchestrator as Product; if the commit is reverted during active development,
keep the deployment blocked until equivalent deny rules exist.

## 14. Readiness

```text
SurfaceBoundary: FOUNDATION_ADOPTED
EnvironmentBoundary: FOUNDATION_ADOPTED
Entry-point metadata: FOUNDATION_ADOPTED
Development route enforcement: FOUNDATION_ADOPTED_LOCALLY
Product route surface tagging: FOUNDATION_ADOPTED_LOCALLY
Administration Surface: NOT IMPLEMENTED
Platform UI: NOT IMPLEMENTED
Global backend surface enforcement: NOT IMPLEMENTED
Production enforcement: NOT AUTHORIZED
```

Local Flutter, Deno and SQL validation pass. Docker Desktop initially remained
unresponsive after a normal close and `TERM`; its residual user backend process
was stopped and Docker was relaunched without deleting images, volumes,
containers or project data. No project configuration changed.

Reproducibility evidence:

```text
Docker client/server: 27.2.0 / 27.2.0
First local reset without seed: PASS, migrations 00001-00009
First local pgTAP suite: 18 files, 649/649 PASS, 0 failures, 0 skips
Second local reset without seed: PASS, migrations 00001-00009
Second local pgTAP suite: 18 files, 649/649 PASS, 0 failures, 0 skips
Remote operations: NONE
G4: COMPLETE
```

The inherited formatting debt remains open and non-blocking; every Dart file
created or modified by FOUNDATION-010 is formatted. Commit and push complete G7
for this package without authorizing G8-G10.

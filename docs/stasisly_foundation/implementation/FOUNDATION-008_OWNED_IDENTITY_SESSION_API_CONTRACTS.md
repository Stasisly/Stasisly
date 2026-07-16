# FOUNDATION-008 Owned Identity, Session and API Contracts

## Status

**IMPLEMENTED LOCALLY.** This document records local implementation evidence.
It does not authorize remote, staging or production operations.

## 1. Problem

The inherited auth feature exposed provider concepts beyond infrastructure,
treated authentication as a nullable user, and allowed secure-session consumers
to depend on a transitional synthetic credential path. Stasisly did not own one
canonical identity, session, token-result or request-context vocabulary.

## 2. Previous architecture

`supabase_flutter` appeared in the auth datasource and provider assembly.
`CurrentIdentity`, `UserEntity`, provider user/session objects and the older
secure-session contracts overlapped. Authorization was conceptually defined by
FOUNDATION-007 but not implemented, so identity models could not safely absorb
roles, surfaces, entitlements, ownership or Founder elevation.

## 3. New contracts

The canonical boundary lives in `lib/core/identity/` and contains domain
contracts, a provider-neutral port, provider adapters and Riverpod assembly.
`lib/core/auth/session/` retains a compatibility adapter for existing transport
consumers. Provider DTOs remain infrastructure details.

## 4. Identity

`StasislyIdentity` contains `subjectId`, `identityType`, explicit
`authenticationState` and optional display email. It contains no role,
permission, surface, entitlement, ownership, elevation or credential.
`CurrentIdentity` remains only as a deprecated compatibility subtype.

## 5. Authentication

`AuthenticationState` distinguishes `unknown`, `unauthenticated`,
`authenticated`, `expired`, `invalid`, `revoked` and `unavailable`. Provider
unavailability is not converted into a valid sign-out or demo identity.

## 6. Session

`StasislySession` owns session state, optional identity, opaque optional session
reference and known issue/expiry times. It never stores provider session
objects or credentials. An authenticated session requires an authenticated
identity.

## 7. Tokens

`AuthenticationTokenResult` provides neutral statuses for available,
unavailable, expired, invalid, provider failure and environment blocked. The
credential is infrastructure-only and excluded from equality/string rendering.
The compatibility `SecureSessionTokenResult` now also excludes its token from
rendering. Tokens are consumed only by authorized transport adapters.

## 8. Provider port

`IdentityProvider` supports reading/observing session state, sign-in, sign-up,
sign-out, refresh and token acquisition. It does not decide authorization,
ownership, entitlements, surface access or Founder elevation.

## 9. Supabase adapter

`SupabaseIdentityProvider` is the current provider adapter. It is the only
authorized identity-boundary file importing Supabase Auth types. It maps users,
sessions, auth events and errors into Stasisly contracts, does not infer roles
from metadata, and sanitizes failures. `EnvironmentBlockedIdentityProvider`
provides explicit fail-closed behavior when real auth is not allowed.

## 10. API identity context

`ApiIdentityContext` is created only from an authenticated `StasislySession`.
It contains subject, identity type, authentication state, optional opaque
session reference, resolved environment and correlation reference. Surface,
delegation, elevation, roles, attributes, entitlements and purpose remain
absent until separately approved authorization packages.

## 11. Errors

`AuthenticationError` owns stable codes for unavailable authentication,
invalid credentials, expired/revoked/unauthenticated sessions, blocked
environments, provider failures and invalid state. Public messages omit raw
provider exceptions, HTTP/SQL details, endpoint data and credentials.

## 12. Adapted consumers

- Auth repositories, use cases and Riverpod providers now consume
  `IdentityProvider` and Stasisly results.
- Current identity derives from explicit demo mode or authenticated secure
  session state and otherwise fails closed.
- Profile and inherited chat consumers use canonical `subjectId`.
- Existing chat session/message token adapters consume the compatibility bridge.
- Routes keep their prior paths and only use explicit authenticated state.

## 13. Compatibility

The migration is incremental. `CurrentIdentity`, `UserEntity`, `UserModel`, the
auth datasource facade and secure-session interfaces remain as deprecated or
adapted compatibility surfaces where existing consumers still require them.
No Product API, route, SQL schema, Edge Function, access tier, session ID,
message DTO or specialist DTO changed.

## 14. Tests

New unit tests cover identity/session invariants, provider mapping, null and
expired sessions, sanitized errors, token safety and environment blocking. New
architecture tests enforce SDK confinement and prohibit authority/credential
fields. Existing auth, session and dev-route tests were updated only to inject
or assert the owned boundary. Final evidence: analyzer 0 errors; Flutter 425
passed and 5 previously approved remote skips; Deno format 41 files and tests
52/52 passed; local PostgreSQL reset succeeded and pgTAP 649/649 passed.
Changed Dart files are formatted. A repository-wide formatter invocation found
pre-existing formatting drift outside the package; those unrelated deltas were
not retained.

## 15. Security

The implementation fails closed, adds no default user or non-demo fallback,
does not accept owner IDs, keeps tokens out of public state and logs, and makes
no authorization decision. No service role, secret, remote operation, RLS,
claim, migration or Edge Function change is included.

## 16. Residual debt

- FOUNDATION-009 later implemented PDP/PEP contracts and one focal local PEP;
  full RBAC, ABAC, JIT and Founder access remain incomplete/not implemented.
- The full inherited auth feature is `CANDIDATE / PARTIALLY_ADAPTED`.
- `backendReal` remains transitional vocabulary and is not Foundation authority.
- Bootstrap still initializes the current provider SDK as infrastructure.
- Legacy chat containment and broad surface guards remain FOUNDATION-010 work.
- Removal of compatibility contracts requires consumer evidence in a later
  package.
- FOUNDATION-010 was subsequently respecified as surface/environment
  enforcement boundaries after FOUNDATION-009.

## 17. Rollback

Revert the FOUNDATION-008 commit. No database, remote, provider configuration or
public API rollback is required. Rollback must not reconnect unsafe legacy
routes, expose provider DTOs, restore token logging or weaken deny-all controls.

## 18. Readiness

Canonical identity and session contracts are `FOUNDATION_ADOPTED` locally.
Supabase Auth is `ADAPT / CURRENT_PROVIDER_ADAPTER`. G0-G7 are satisfied only
after package commit and push. G8-G10 were not executed. FOUNDATION-009 was
subsequently completed locally under ADR-F006.

# ADR-F008 Backend Authorization Context and Owned API Enforcement

## Status

```text
Decision: APPROVED
Implementation: IMPLEMENTED_LOCALLY
```

## Context

FOUNDATION-008 through FOUNDATION-010 established owned identity/session/API
contracts, typed authorization semantics and client entry-point boundaries.
The six Product Edge Functions validated JWTs and mostly enforced ownership,
but their surface, environment, action and resource contracts were implicit.
Missing runtime configuration also inherited local behavior.

## Decision

1. Backend identity is derived only from a bearer token validated by the
   backend. Provider user objects and user metadata do not become public or
   authorization contracts.
2. Every protected backend entry point uses a backend-owned immutable operation
   definition with surface, allowed environments, action, resource,
   authentication and ownership requirements.
3. `BackendRequestContext` contains only validated or backend-derived identity,
   operation, ownership, correlation and source data. It contains no credential,
   provider object, body, role, entitlement, delegation or elevation.
4. Product is the expected surface for the six current functions. Only local
   and development are allowed. Missing, unknown, staging and production deny.
5. Client owner, user, role, entitlement, surface and environment metadata is
   rejected and can never expand authority. Correlation IDs are diagnostic only.
6. Backend PDP/PEP ports and a minimal local policy deny by default, including
   policy unavailability or error.
7. Session/message ownership is derived from verified subject plus trusted data.
   Catalog is explicitly non-owned.
8. Public DTOs remain explicit allowlists. Errors and logs remain stable,
   minimized and non-sensitive.
9. Runtime configuration is fail-closed; no implicit local fallback remains.
10. No remote deployment, production, persistent RBAC/ABAC, Founder elevation,
    Administration Surface, service identity or Stasis Engine is authorized.

## Consequences

Positive:

- the backend is the final authority for the six owned API boundaries;
- operation metadata cannot drift independently across handlers;
- missing, conflicting and client-declared authority fails closed;
- ownership remains explicit and testable;
- Dart and TypeScript Foundation vocabularies have architecture guards;
- existing Flutter and public API contracts remain compatible.

Costs and residual risks:

- policy is local and intentionally minimal, not persistent RBAC/ABAC;
- create-session retains its known validation/insert TOCTOU window;
- productive audit storage, rate limiting and backend security CI remain open;
- remote and production states are not verified or activated.

## Rejected alternatives

- Trusting `X-Surface`, environment, owner or role headers: rejected because
  clients cannot be authorization authorities.
- Inferring local on missing runtime mode: rejected as fail-open configuration.
- Duplicating string metadata in handlers: rejected due drift and bypass risk.
- Returning backend policy context in DTOs: rejected as unnecessary disclosure.
- Adding claims, roles, migrations or RLS policies: rejected as scope expansion.
- Deploying to validate the change: rejected because G8 was not authorized.

## Security invariants

```text
verified JWT subject is the only human identity source
client context never expands authority
unknown or missing context denies
policy failure denies
owned resources require trusted ownership match
public DTOs never expose authorization context
logs never contain credentials or bodies
local/development only
remote and production remain closed
```

## Rollback

Revert the implementation commit with remote deployment still closed. Rollback
must not restore implicit runtime fallback or client authority. No database
rollback is needed.

## Follow-up

The next approved map gate is FOUNDATION-012 for Product taxonomy and
conversation API/legacy retirement decisions. Persistent authorization data and
policy evaluation remain a separate future security package and must not be
silently folded into Product scope.

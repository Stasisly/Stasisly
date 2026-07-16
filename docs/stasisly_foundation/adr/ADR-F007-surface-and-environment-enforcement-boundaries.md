# ADR-F007 — Surface and Environment Enforcement Boundaries

## Status

```text
Decision: APPROVED
Implementation: IMPLEMENTED_LOCALLY
```

## Context

FOUNDATION-009 supplied typed authorization inputs and local PDP/PEP contracts,
but routes and repository entry points still inferred surface and environment.
Development hosts were available in demo, legacy chat/orchestrator paths built
active code, and the Product shell exposed the orchestrator prototype.

## Decision

1. Every registered route has an enum entry-point ID, one explicit Foundation
   surface, an explicit environment allowlist, authentication requirement,
   authorization requirement and legacy state.
2. `SurfaceBoundary` and `EnvironmentBoundary` deny unknown, missing or
   mismatched context. No implicit remapping or fallback is permitted.
3. Development routes are limited to local/development and can be narrowed by
   runtime/release gates.
4. Existing Product area routes are tagged Product and limited to
   local/development until later authorization.
5. Login, registration and onboarding are public Product authentication entry
   points; that public status grants no protected resource access.
6. Administration is not active. Platform and Shared Infrastructure have no UI
   routes.
7. `/chat/:id`, `/orchestrator` and `/orchestrator/chat` remain recognizable
   only as `LEGACY_BLOCKED`. They cannot construct Product capability.
8. Orchestrator is not Stasis Engine and is removed from Product navigation.
9. `backendReal` maps to `AuthorizationEnvironment.unknown` and cannot allow.
10. Boundary decisions use safe typed outcomes and the existing minimized audit
    port. The productive audit sink remains outside scope.
11. Backend authorization and ownership remain mandatory and final.

## Consequences

Positive consequences:

- cross-surface and cross-environment execution fails closed;
- protected builders do not run before local gates complete;
- Development chat keeps explicit `sessionId` and is not promoted to Product;
- legacy routes cannot become fallback;
- route metadata and negative behavior are architecture-testable.

Costs and residual risks:

- client enforcement is defense in depth, not backend authority;
- Product remains local/development only under this new boundary;
- no complete Administration, Development Surface, Engine or persistent policy
  store exists;
- physical/mental route names and legacy source remain technical debt;
- a productive audit sink and backend context propagation require later work.

## Rejected alternatives

- Free-form route labels: rejected because unknown strings can silently drift.
- Treating `backendReal` as development: rejected as implicit fallback.
- Deleting all legacy code: rejected as unnecessary scope expansion.
- Rebuilding the router: rejected because GoRouter can enforce metadata through
  a focused wrapper and registry.
- Activating orchestrator as Stasis Engine: rejected because no Agent
  Constitution or Engine implementation exists.

## Security invariants

```text
unknown surface/environment never allows
Development never allows staging/production
public auth entry never grants Product resource access
legacy route never builds legacy capability
Administration/Platform/shared infrastructure expose no UI
local decision never overrides backend authority
no token or payload enters boundary audit
```

## Rollback

Revert the implementation commit while keeping affected deployment gates
closed. Rollback is invalid if it restores active legacy chat/orchestrator
Product routing or demo fallback.

## Follow-up

`FOUNDATION-011 — Backend authorization context and owned API enforcement`
should carry surface/environment and ownership to the backend boundary under a
separately approved, non-remote package.

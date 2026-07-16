# ADR-F006 Authorization Context and Policy Contracts

## Status

```text
Decision: APPROVED
Implementation: IMPLEMENTED_LOCALLY
```

## Context

FOUNDATION-007 defined deny-by-default authorization conceptually and
FOUNDATION-008 adopted provider-neutral identity/session contracts. A typed,
owned boundary was still required to evaluate action, resource, surface,
environment and contextual constraints without placing authority in identity,
UI, provider metadata or commercial plan names.

## Decision

1. `AuthorizationContext` is the canonical typed policy input.
2. Surface, environment, action, resource and sensitivity use closed initial
   vocabularies with explicit unknown values that deny.
3. Ownership is derived from authenticated identity and trusted backend or
   approved-workflow resource data, never established by client input.
4. Entitlement decisions remain separate from informational plan vocabulary.
5. Purpose, delegation and elevation are typed, scoped and fail closed; this
   decision does not implement Founder Elevated or persistent delegation.
6. `AuthorizationDecision` is the canonical typed outcome with stable safe
   reason codes, policy reference, audit requirement and bounded obligations.
7. `AuthorizationPolicyDecisionPoint`, `AuthorizationEnforcer` and
   `AuthorizationAuditSink` separate policy, enforcement and audit effects.
8. The local Foundation PDP denies by default and permits only the existing,
   low-risk authenticated own-profile read in Product local/development.
9. Missing, unknown, ambiguous, conflicting and policy-error states deny.
10. Backend ownership, RLS and Edge Function authorization remain final
    authority; client enforcement is defense in depth only.

## Consequences

Future surfaces and adapters can consume one neutral contract and replace the
local PDP without changing domain callers. Authorization failures are explicit
and testable. Full route/API enforcement, persistent RBAC/ABAC, JIT, Founder
elevation, remote enforcement and production audit storage remain gated.

## Alternatives rejected

- Roles/permissions in `StasislyIdentity`: rejected because authentication is
  necessary but not sufficient authority.
- Free-form maps or strings: rejected because unknown/ambiguous inputs can fail
  open and are hard to audit.
- Plan names as permissions: rejected because commercial packaging and
  authorization have different semantics.
- Client-supplied ownership: rejected because it is untrusted authority input.
- Supabase RLS as universal PDP: rejected because application, surface and
  non-database decisions require an owned policy boundary.
- Mass integration: rejected because it would widen blast radius and could
  accidentally open Product paths.

## Security and audit

No token, provider object, service role, claim, secret or user-facing internal
message enters the context or decision. Sensitive, delegated, elevated and
prerequisite decisions require audit. The local no-op sink is not approved for
production and audit failure denies.

## Compatibility and rollback

No database, migration, RLS, Edge Function, route, public DTO or remote state
changed. Rollback is a commit revert and must retain backend checks and legacy
deny-all controls.

## Follow-up

FOUNDATION-010 may apply explicit surface/environment enforcement boundaries to
routes, APIs and operations after separate approval. It must not implement
Founder Elevated or remote access implicitly.

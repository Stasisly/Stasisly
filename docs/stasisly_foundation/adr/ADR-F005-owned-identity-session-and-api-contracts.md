# ADR-F005 Owned Identity, Session and API Contracts

## Status

```text
Decision: APPROVED
Implementation: IMPLEMENTED_LOCALLY
```

## Context

FOUNDATION-004 requires Stasisly-owned service contracts and treats Supabase as
an initial managed provider. FOUNDATION-007 separates authentication from
authorization conceptually. The inherited client still mixed provider Auth
types, nullable user state and transitional session/token abstractions.

## Decision

1. `StasislyIdentity` is the canonical identity contract.
2. `StasislySession` is the canonical session contract.
3. Provider behavior implements the Stasisly-owned `IdentityProvider` port.
4. Supabase Auth remains the current infrastructure adapter, not the Stasisly
   identity model.
5. Authentication proves a principal or returns an explicit safe failure;
   authorization remains a separate, not-yet-implemented decision.
6. Authentication errors and token results are provider-neutral.
7. Supabase user, session, response and exception types may not escape the
   authorized adapter.
8. Identity does not encode roles, surfaces, permissions, entitlements,
   ownership or Founder elevation.
9. Ownership is never established by a client-supplied owner field.
10. Unknown, expired, invalid, revoked, unavailable and environment-blocked
    states fail closed and never become an implicit demo identity.

## Consequences

Domain and presentation depend on stable owned contracts. Provider replacement
becomes possible through adapters, and existing transport consumers can migrate
incrementally through a compatibility bridge. The full auth feature is not
declared adopted, and no RBAC, ABAC, JIT, surface enforcement or Founder access
is implied.

## Alternatives rejected

- Keep Supabase DTOs as domain contracts: rejected due to lock-in and authority
  ambiguity.
- Encode authorization in identity metadata: rejected because authentication
  and authorization have distinct trust and lifecycle requirements.
- Rewrite all auth/chat code at once: rejected due to blast radius and lack of
  evidence for removing compatibility consumers.
- Treat provider errors as null/demo: rejected because it fails open.

## Security and rollback

Credentials remain infrastructure-only and are excluded from public rendering.
No secret, claim, RLS, migration, remote environment or Product API changed.
Rollback is a commit revert and must preserve legacy deny-all controls.

## Follow-up

FOUNDATION-009 may implement legacy-route containment and explicit surface
guards after separate approval. Authorization runtime and Founder elevation
remain future gated work.

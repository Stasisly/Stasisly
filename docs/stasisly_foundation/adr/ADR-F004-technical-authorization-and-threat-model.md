# ADR-F004 — Technical Authorization and Threat Model

## Metadata

| Field | Value |
|---|---|
| Status | APPROVED |
| Conceptual decision | APPROVED |
| Implementation | NOT IMPLEMENTED |
| Authority level | 2 — Foundation ADR |
| Owner | Security and Architecture under Rector |
| Approver | Founder |
| Decision package | FOUNDATION-007 |
| Baseline | `0faebf6` |
| Dependencies | ADR-F001, ADR-F002, ADR-F003, Foundation threat model |

## Context

Foundation governance separates authority from access and defines three
surfaces plus internal Stasis Engine. The repository has useful fail-closed and
ownership invariants, but no complete technical authorization, threat, JIT,
service-identity or Founder-elevation model. Product expansion must not encode
these decisions ad hoc in claims, clients or provider-specific boundaries.

## Decision

1. Authorization is deny-by-default and fails closed on missing, ambiguous,
   expired or unavailable context.
2. Identity, authentication, authorization, ownership, entitlement, surface,
   environment, elevation, delegation, impersonation and service identity are
   separate concepts.
3. RBAC narrows responsibility; ABAC decides each concrete operation using
   resource, owner, surface, environment, purpose, assurance and risk context.
4. Ownership is derived and enforced at trusted backend boundaries, never
   selected by the client.
5. Product, Development, Administration, Platform/Engine and shared
   infrastructure contexts do not inherit access from one another.
6. Founder Authority uses Standard, Elevated and Emergency states. Founder
   retains exclusive protected total-access potential without an unsafe
   universal session; elevation is scoped, auditable and revocable.
7. JIT and delegation are bounded by task, resource, surface, environment,
   purpose and duration. Direct impersonation is prohibited by default.
8. Services use separate single-purpose identities. One universal
   `service_role` is not the Foundation architecture.
9. Agent permissions are resolved outside prompts from identity, version,
   delegation, tools, data, memory, model and budget policy.
10. A future PDP returns explicit decisions/obligations; PEPs enforce them at
    API, domain, Engine, gateways and operational workflows with defense in
    depth.
11. Sensitive operations generate minimized audit events and support revocation
    of sessions, grants, delegations, credentials, agents, tools and devices.
12. This package approves the conceptual threat and authorization model only;
    it creates no role, claim, policy, account, credential or remote access.

## Alternatives rejected

- Authentication success as authorization: ignores resource and context.
- Pure RBAC or a `super_admin`: too coarse for surfaces, environments and root
  risk.
- Client or prompt authorization: untrusted and bypassable.
- One global service credential/PDP without defense in depth: excessive blast
  radius and single-point risk.
- Silent fallback on policy failure: privilege escalation.
- Direct support impersonation: weak accountability and privacy.

## Consequences

- FOUNDATION-008 can define provider-neutral identity/session/API contracts
  using approved policy inputs.
- FOUNDATION-009 must enforce surface/route boundaries and legacy containment.
- Founder elevation, policy technology/data, service identities, audit storage,
  agent authorization and cost controls need separate packages and Founder
  gates where specified.
- No new P0 is identified; current P1-P4 ordering remains, with the legacy-table
  P0 closed locally and remote state unapplied.

## Rollback and review

This ADR may be superseded only by a Founder-approved ADR with threat and
authority impact. Documentation rollback cannot authorize a weaker runtime.
Review is required on material changes to surfaces, environments, identity,
providers, sensitive data, Engine, elevation or deployment topology.

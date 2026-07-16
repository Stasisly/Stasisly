# FOUNDATION-009 Authorization Context and Policy Contracts

## Status

**IMPLEMENTED LOCALLY.** Publication completes G7. This package grants no new
Product, remote, staging or production access.

## 1. Problem

FOUNDATION-007 approved authorization conceptually and FOUNDATION-008 supplied
owned identity/session inputs, but the code had no typed policy context,
decision, PDP or PEP. Authority therefore could not be evaluated consistently
without drifting into UI, provider types or free-form values.

## 2. Contexts

`AuthorizationContext` composes typed identity, action, resource, surface,
environment, ownership, entitlement, purpose, delegation and elevation plus a
required correlation ID. It contains no token, Supabase object or generic map.

## 3. Actions

The closed initial vocabulary is `read`, `create`, `update`, `delete`,
`execute`, `approve`, `configure`, `administer`, `export`, `delegate`,
`elevate` and `unknown`. Unknown or missing actions deny.

## 4. Resources

`AuthorizationResource` covers profile, chat session/message, specialist
catalog, identity, session, memory, research, agent, tool, configuration,
audit and unknown, with optional ID, sensitivity, canonical surface and an
optional trusted owner reference.

## 5. Surface

The canonical vocabulary is Product, Development, Administration, Platform,
Shared Infrastructure and unknown. Missing, unknown and mismatched surfaces
deny. Platform and shared infrastructure do not imply Founder or universal
access.

## 6. Environment

The contract supports local, development, staging, production, demo, preview,
sandbox, disaster recovery and unknown. The local policy enables only local
and development for its one allowlisted case. `backendReal` maps to unknown.

## 7. Ownership

Ownership distinguishes owned, not owned, shared, delegated, system owned,
not applicable and unknown. Owned/not-owned is derived only by comparing the
canonical identity with `TrustedOwnerReference`, whose source must be a trusted
backend or approved workflow. UI cannot construct owned directly.

## 8. Entitlements

Entitlement status and requirement are separate from informational commercial
plan vocabulary (`free`, `pro`, `vip`, `unknown`). Policy checks the entitlement
decision, never the plan. Required unknown/not-granted entitlement denies.

## 9. Purpose

Purpose uses a bounded enum: user requested, service operation, support,
security, administration, development, research, emergency, not required and
unknown. Unknown denies; descriptive free text is not authority.

## 10. Delegation

Delegation is typed and scoped by delegator, delegate, resources, actions,
surface, environment and validity interval. This package emits or persists no
delegation. Expired, revoked, invalid or out-of-scope delegation denies.

## 11. Elevation

Elevation models none, standard, elevated, emergency, expired, revoked and
unknown with bounded scope, purpose and validity. It implements no Founder
elevation, break-glass code, claim, secret or persistence. Invalid states deny.

## 12. Sensitivity

Resources are public, internal, confidential, sensitive, highly sensitive,
root critical or unknown. Unknown denies. Sensitive/root decisions and active
delegation/elevation require audit.

## 13. Decisions

`AuthorizationDecision` returns allow, deny, require elevation, require
approval, require user consent or not applicable, with a stable reason,
policy reference, audit flag and a bounded obligation set.

## 14. Reason codes

Stable codes cover authentication, invalid/missing/unknown context, surface and
environment mismatch, ownership, entitlement, delegation, elevation, approval,
consent, policy availability/error, explicit deny and not applicable. No
internal exception or sensitive message is exposed.

## 15. PDP

`AuthorizationPolicyDecisionPoint` is a provider-neutral single-operation port.
It imports neither Flutter UI nor Supabase and does not treat RLS as a universal
PDP.

## 16. PEP

`AuthorizationEnforcer` is the reusable enforcement port.
`DefaultAuthorizationEnforcer` invokes the PDP, returns typed outcomes, fails
closed on policy exceptions and requires the audit sink when specified. Audit
failure converts the result to deny.

## 17. Local deny-by-default policy

`LocalFoundationPolicyDecisionPoint` rejects missing, unknown, conflicting or
invalid context. Its only positive capability is authenticated human Product
read of an own profile in local/development with trusted ownership and a
satisfied/not-required entitlement. All other operations deny or return a
typed prerequisite decision; no access previously denied by backend is opened.

## 18. Consumers

One focal consumer was selected: remote own-profile read after response shape
and canonical subject validation. Chat, routes, sessions, messages and legacy
surfaces were not changed.

## 19. Audit port

`AuthorizationAuditSink` accepts minimized typed events. The provided no-op is
explicitly local-only for tests/local composition and stores or transmits
nothing. No production audit storage or telemetry was introduced.

## 20. Tests

Unit and architecture tests cover the required positive case, every missing or
unknown core context, surface/environment mismatch, ownership, entitlement,
delegation, elevation, approval, consent, policy failure, audit failure and
separation guards. Final evidence: analyzer 0 errors; Flutter 453 passed with 5
pre-existing approved skips; Deno format checked 41 files and 52/52 passed;
local reset without seed succeeded and pgTAP 649/649 passed.

## 21. Security

Unknown/missing context and policy failures deny. Owner is backend-derived,
plan never grants permission, identity contains no role, authorization contains
no token/provider/UI type, production has no fallback, and backend/RLS/Edge
Function checks remain final authority.

## 22. Compatibility

No schema, migration, RLS, Edge Function, route, public DTO, session ID,
message/specialist contract, access-tier vocabulary or legacy chat behavior
changed. Profile update behavior was not expanded.

## 23. Residual debt

- Full enforcement is `PARTIALLY_IMPLEMENTED` at one focal client boundary.
- Persistent RBAC/ABAC, JIT and remote policy enforcement are not implemented.
- Founder elevation and production audit persistence are not implemented.
- Surface/environment enforcement across routes and APIs remains FOUNDATION-010.
- Repository-wide Dart formatting has inherited drift in 27 out-of-scope files;
  package files are formatted and no unrelated formatting delta is retained.

## 24. Rollback

Revert the FOUNDATION-009 commit. No database, remote, route, RLS or provider
rollback is needed. Rollback must preserve deny-all controls and backend
ownership checks.

## 25. Readiness

Authorization contracts and PDP/PEP ports are `FOUNDATION_ADOPTED`; the local
PDP is `FOUNDATION_ADOPTED_FOR_LOCAL_CONTRACT_VALIDATION`; full authorization
remains partial. G0-G7 are complete upon commit and push. G8-G10 were not run.

# Technical Authorization Model

## Status

```text
Conceptual decision: APPROVED
Implementation: NOT IMPLEMENTED
```

Owner: Security and Architecture under Rector. Approver: Founder.

## Separation of concepts

| Concept | Definition | Must not substitute |
|---|---|---|
| Identity | Who or what the actor is | Authorization or entitlement |
| Authentication | How identity is proven | Domain authorization |
| Authorization | Whether a concrete action is permitted | Authentication success |
| Ownership | Trusted assignment/relationship between resource and identity | Client-provided owner field |
| Entitlement | Commercial availability of a capability | Security permission |
| Surface context | Functional domain in which an operation occurs | Generic role |
| Environment context | Runtime/deployment domain | Surface or authority |
| Elevation state | Temporary additional authority for exact scope | Permanent role |
| Delegation | Bounded task assigned without identity transfer | Impersonation or Founder Authority |
| Impersonation | Controlled representation of another identity | Support convenience; denied by default |
| Service identity | Non-human identity for one technical purpose | Shared interactive account |

## Decision principle

```text
DENY BY DEFAULT
```

An `ALLOW` requires all applicable inputs to be valid:

```text
authenticated identity
+ approved action and resource
+ approved surface and environment
+ ownership, membership or bounded delegation
+ entitlement when commercially required
+ elevation and approval when sensitive
+ policy decision and enforceable audit requirement
```

Missing, unknown, ambiguous, contradictory, expired or unverifiable input is
`DENY`. There is no fallback to demo, default user, Stasis, generic role,
default surface, lower environment or partial access.

## RBAC plus ABAC

RBAC narrows the responsibility set. Initial conceptual families are
`end_user`, `administrator`, `developer`, `support_operator`,
`security_operator`, `service_identity` and `founder`. A role is never total
permission and this model defines no claim or table names.

ABAC evaluates the concrete operation using identity, surface, environment,
resource type/owner, organization, region, sensitivity, action, session
assurance, device trust, elevation, purpose, time constraints and incident
state. A valid role with invalid attributes is denied.

## Surface context

| Surface context | Default actors/capability | Explicit exclusions |
|---|---|---|
| Product | End users, Stasis and Product specialists under user context | Administration, Development, secrets and raw infrastructure |
| Development | Developers, Rector and bounded Development agents | Production and Product personal data by default |
| Administration | Administrators, Gerendi and bounded business agents | Code mutation, Development and unrestricted Product data |
| Platform / Stasis Engine | Runtime/service identities with execution scope | Organizational authority and arbitrary Product visibility |
| Shared Infrastructure | Narrow service/operations identities | Universal access merely because technology is shared |

Missing/unknown context, mismatch or cross-surface request without approved
contract is denied and audited when sensitive. Cross-surface access uses an
explicit API, command, event, read model or workflow with purpose and minimum
data; no direct inherited table access.

## Environment context

Current contexts are `local`, `development`, `staging` and `production`.
`demo`, `preview`, `sandbox` and `disaster recovery` require future approval.

- No implicit environment fallback or production credential below production.
- Development authority does not imply production authority.
- Synthetic data is the default outside production.
- Sessions, service identities, budgets and audit are environment-bound where
  required.
- Promotion is explicit and separately authorized; G8-G10 are not inherited.

## Ownership and entitlement

Ownership is derived at a trusted backend boundary from authenticated identity,
explicit membership or approved workflow. Clients cannot choose owner. Shared
resources require explicit membership/delegation; transfers are validated and
audited. This applies to profiles, sessions, messages, memory, research, files,
subscriptions, device data and administrative cases.

Authorization asks whether an operation is safe and permitted. Entitlement asks
whether the account has the commercial capability. Product operations may
require both. Current vocabulary remains `free`, `pro`, `vip`; no plans or
tables are designed here.

## Sensitive data and purpose

Health/wellness, conversations, memory, research, identity, financial,
security, audit and provider-credential operations require an explicit purpose
where applicable, minimum data, need-to-know, surface restriction, retention
rule and auditable access. This does not claim regulatory compliance.

## Delegation and impersonation

Delegation records delegator, delegate, task, resource, surface, environment,
duration, tools, data scope, cost limit, revocation and audit. It does not
transfer identity, Founder Authority or onward-delegation rights unless policy
explicitly permits the latter.

Direct impersonation is prohibited by default. Support should use redacted
views, user-approved or delegated sessions, synthetic reproduction and audited
read-only assistance. Any future representation identifies both real and
effective actor, remains bounded/revocable and never falsifies audit.

## JIT elevation

JIT contains requester, capability, resource, surface, environment, purpose,
approver where required, start, expiry, revocation state and audit reference.
It is never indefinite by default. Critical operations require independent
approval according to future policy; elevation does not propagate across
surfaces, environments or unrelated actions.

## Policy decision and enforcement

The future Policy Decision Point (PDP) evaluates complete context and returns an
explicit decision, obligations and policy version. Technology is not selected.

Policy Enforcement Points (PEPs) exist at API edge, domain services, Stasis
Engine, Tool Gateway, Model Gateway, Administration workflows and Development
operations. Defense in depth preserves domain invariants and infrastructure
controls; the PDP is not a reason to create one unrestricted single point.

## Decisions and obligations

Allowed conceptual outcomes are `ALLOW`, `DENY`, `REQUIRE_ELEVATION`,
`REQUIRE_APPROVAL`, `REQUIRE_USER_CONSENT` and `NOT_APPLICABLE`. An obligation
that cannot be enforced converts the operation to `DENY`.

## Audit

Sensitive decisions record actor, effective identity, delegator, action,
resource reference/type, surface, environment, decision, policy version,
elevation, purpose, timestamp, result and correlation ID. Human, agent, service
and automated-policy actions remain distinguishable.

Audit excludes raw passwords, full tokens, unnecessary secrets, private model
reasoning and unneeded sensitive payloads.

## Revocation

Revocation applies to sessions, refresh tokens, JIT grants, delegations,
service/provider credentials, agent activation, tools and device trust. Critical
revocation must later receive a measurable latency target; none is invented
here. Until propagated, residual replay/access risk remains and is monitored.

## Failure behavior

Authorization is fail-closed. Timeouts, missing policy, unknown role/context,
dependency failure or malformed attributes never allow access. Operational
exceptions require approved Emergency Authority, bounded scope and audit.

## Implementation packages

- FOUNDATION-008: owned identity/session/API contracts and policy inputs.
- FOUNDATION-009: typed context/decision, PDP/PEP ports, local deny-default
  validation and one focal profile PEP.
- FOUNDATION-010: surface/environment enforcement boundaries and legacy-route
  containment after separate approval.
- Later separately approved packages: policy data model/evaluation, Founder
  elevation, service identities, audit events, privacy, agent authorization and
  cost enforcement.

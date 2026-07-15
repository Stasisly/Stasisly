# Foundation Founder Decision Gates

## Status and principle

Status: **APPROVED**.

Founder decides authority, risk acceptance, scope and promotion. Technical
owners design options and recommend one; Founder is not required to design the
technical mechanism.

| Decision gate | Prepared by | Founder receives | Decision | Blocks |
|---|---|---|---|---|
| Master remediation plan | Director de Proyecto + Rector + Nexus | Sequence, dependencies, risks and residual debt | Approve/return/reprioritize plan | FOUNDATION-007 onward |
| Authorization model | Security + Architecture | Role/attribute/context options, threat model, elevation risks | Approve authority semantics | Identity, surfaces, admin, Engine |
| Surface access model | Architecture + Nexus | Product/Development/Administration/Engine matrix | Approve isolation and cross-surface rules | Route/API enforcement |
| Product taxonomy | Product Owner + Stasis | Naming, route and domain options with UX/data impact | Approve Product meaning and MVP scope | Product reconstruction |
| Agent Constitution | Engine Architecture + Security LLM | Agent powers, activation, audit and safety options | Approve constitutional constraints | Runtime and registries |
| Initial rosters | Stasis/Rector/Gerendi + Nexus | Minimal roster, costs, responsibilities and limits | Approve activation scope | Agent creation/activation |
| Provider strategy | Architecture + Cost + DevOps | TCO, portability, data, alternatives and exit triggers | Approve provider commitment/billing | New provider or material lock-in |
| Subscription model | Product Owner + Gerendi | Entitlements, value, privacy and operational impacts | Approve commercial model | Billing/entitlements implementation |
| Founder elevated access | Security + AppSec | Standard/elevated/emergency options, JIT and audit | Approve exact powers and safeguards | Elevated-access implementation |
| Remote migrations | Backend + Security + DevOps | Target, diff, preflight, rollback and evidence plan | Authorize one remote operation | G8 |
| Staging | QA + Security + DevOps | P2 evidence, synthetic-data plan, SLO/runbooks and risks | Go/no-go staging | G9 |
| Production | Nexus + all accountable owners | Privacy/legal, security, release, capacity, costs and rollback | Go/no-go production | G10 |

## Required decision packet

Every Founder decision includes objective, current evidence, options, technical
recommendation, risks, cost impact, reversible path, acceptance criteria,
residual debt and the exact authority requested. Silence and prior approvals do
not imply approval.

## Elevation rule

Founder Authority does not create one universal session. Identity, session,
surface, environment, authority level, elevation, operation scope and audit
event remain separate. Emergency access is time-bound, justified, observable
and revoked; implementation requires its own package.

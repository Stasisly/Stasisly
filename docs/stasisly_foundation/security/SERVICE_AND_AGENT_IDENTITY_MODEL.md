# Service and Agent Identity Model

## Status and principles

```text
Conceptual decision: APPROVED
Implementation: NOT IMPLEMENTED
```

Human identity, service identity, agent identity and organizational role are
different. Prompts and coordinator status never grant technical permission.

## Service identity families

| Identity | Single purpose | Default scope | Explicit prohibition |
|---|---|---|---|
| API service | Validate and execute owned API use cases | One service/domain/environment | Interactive use or universal database access |
| Background worker | Execute approved job types | Queue, job and minimum data | Arbitrary jobs or cross-environment reuse |
| Migration runner | Apply one approved migration set | Named database/environment and time window | Application runtime or lower-to-production inheritance |
| CI identity | Read/build/test approved repository inputs | Repository/job; synthetic data | Production mutation or persistent broad secrets |
| Deployment identity | Promote approved artifact | Named target and release operation | Build/source modification or unrelated environments |
| Stasis Engine runtime | Execute approved agent version/delegation | Execution, surface and budget | Organizational authority or unrestricted data |
| Tool Gateway | Enforce approved tool calls | Tool/action/data policy | Tool self-registration or policy bypass |
| Model Gateway | Route approved model operation | Model/task/provider/budget policy | Provider credential disclosure or unmetered routing |
| Cost accounting | Record usage and enforce budgets | Usage events and policy | Product content access beyond attribution need |
| Observability collector | Collect approved telemetry | Sanitized telemetry source | Secrets or unrestricted payload collection |

Every service identity is environment-bound, minimum-privilege, rotatable,
revocable and auditable; it is not used interactively or reused for unrelated
services. Supabase `service_role`, while present, is ROOT-CRITICAL provider
credential debt, not the Foundation identity model. Its scope must be reduced
behind server adapters and per-purpose controls in future packages.

## Agent execution identity

Every execution resolves externally to the prompt:

```text
agent identity and approved version
surface and environment
user/effective context
bounded delegation and purpose
tools and data scope
model policy and cost budget
operation, concurrency and time limits
memory scope and provenance
policy and audit context
```

The prompt can request an operation but cannot alter the resolved context. A
compromised agent cannot expand tools, change role, cross surfaces, read
arbitrary memory, access credentials, increase budget, re-delegate without
policy or impersonate Founder.

## Organizational coordinators

| Coordinator | Authorized organizational scope | Technical default |
|---|---|---|
| Nexus | Coordinate global proposals, dependencies and escalation | No inherited total/cross-surface access, Founder Authority or unrestricted tools |
| Stasis | Coordinate Product under user-authorized context | Product only; no Development/Administration access |
| Rector | Coordinate Development and technical quality | Development only; no automatic production or Product personal data |
| Gerendi | Coordinate Administration and business operations | Administration only; no source modification or unrestricted Product data |

Nexus, Stasis, Rector and Gerendi require the same explicit execution identity,
delegation, policy and audit inputs as any agent. Their names are not roles in a
technical permission system by themselves.

## Delegation and tool use

Agent delegation records source execution, target agent/version, task,
resource/data scope, surface, environment, allowed tools, budget, depth,
duration, revocation and audit. Further delegation is denied unless explicitly
allowed and bounded. Tool calls always pass through a PEP with both user and
agent context where applicable.

## Memory, provider and secret boundaries

- Memory reads require purpose, level/scope, provenance and expiry policy.
- Agent outputs never become trusted memory solely because a model produced
  them.
- Provider context is minimized and adapter-controlled.
- Credentials remain backend-side and are never inserted into prompts.
- Audit records model/tool versions and outcomes without private model
  reasoning.

## Lifecycle and revocation

Service/agent identities have creation approval, owner, environment, activation
state, credential/version rotation, monitoring, suspension, revocation and
retirement. Revoking agent activation, delegation, tool access, model route or
service credential stops new work; in-flight cancellation semantics require
future measurable design.

## Required later packages

- FOUNDATION-008 defines owned identity and session contract inputs.
- FOUNDATION-014 defines Agent Constitution and runtime contracts.
- FOUNDATION-017 defines budget and observability enforcement.
- Separate approved packages implement service credentials, registry data,
  Tool/Model Gateway policy and revocation. No identities are created here.

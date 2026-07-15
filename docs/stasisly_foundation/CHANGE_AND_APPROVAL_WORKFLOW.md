# Change and Approval Workflow

## Metadata

| Field | Value |
|---|---|
| Title | Change and Approval Workflow |
| Status | APPROVED |
| Authority level | 1 — Founder-approved Constitution and Governance |
| Owner | Program Management with Documentation coordination (conceptual) |
| Approver | Founder |
| Version | 1.1 |
| Effective condition/date | Effective upon approval and merge of FOUNDATION-002; decision categories added by FOUNDATION-003 |
| Supersedes | Discovery operational prompt workflows |
| Dependencies | DOCUMENTATION_GOVERNANCE |

## Standard flow

```text
need
→ owner
→ proposal
→ evidence
→ specialist review
→ coherence review
→ security/cost impact
→ founder decision when required
→ ADR if structural
→ implementation
→ validation
→ publication
→ archive/supersession
```

Every change declares scope, allowed and forbidden assets, risks, acceptance
criteria, stop conditions, rollback and requested decision. Missing evidence is
marked rather than inferred.

## Change classes

| Class | Typical scope | Minimum path |
|---|---|---|
| Editorial change | Grammar, formatting, broken link without semantic change | Owner review, validation, publication |
| Non-normative documentation | Evidence, audit or tracker entry | Owner, evidence review, publication |
| Normative change | Rules, contracts or domain meaning | Owner, specialist/coherence review, approver, register update |
| Architecture change | Boundaries, dependencies, platforms or data flow | Architecture review, Security/Cost impact, ADR, Founder when structural |
| Security/privacy change | Auth, permissions, sensitive data, cryptography, logs | Security, Privacy, AppSec, threat model, explicit risk acceptance |
| Product change | User value, surfaces, journeys, tiers or roadmap | Product Owner, UX, Coherence, Founder decision as required |
| Operational change | Deployment, environments, release or support | Owner, runbook, rollback, validation and authorization |
| Urgent change | Time-sensitive non-incident correction | Narrow scope, named approver, retrospective evidence; no silent bypass |
| Incident | Active security, privacy or availability event | Containment, incident command, evidence preservation, recovery, postmortem |

## Decision authority

- Editorial owners may approve genuinely non-semantic editorial changes.
- Evidence owners may publish verified non-normative evidence.
- Normative owners propose; the registered approver decides.
- Structural, cross-surface, security-risk or roadmap decisions require the
  authority defined by governance and may require Founder approval.
- Agents advise and review; they do not self-approve.

## Decision categories

| Category | Route |
|---|---|
| `FOUNDER_RESERVED` | Complete proposal and required reviews to Founder for final decision |
| `NEXUS_COORDINATED` | Nexus consolidates cross-surface conflict, dependency or trade-off and escalates reserved matters |
| `SURFACE_COORDINATOR` | Stasis, Rector or Gerendi decides or proposes within delegated surface limits |
| `SPECIALIST_REVIEW` | Specialist supplies evidence and recommendation without final approval authority |
| `OPERATIONAL` | Authorized owner executes within approved scope, controls and rollback |
| `EMERGENCY` | Authorized containment or recovery with reinforced traceability and mandatory retrospective review |

Category does not grant technical access. Authority and access are evaluated
separately, and any elevation must remain explicit, minimal, auditable and
revocable.

## Review requirements

- **Specialist review:** validates domain correctness.
- **Coherence review:** detects contradiction and incorrect supersession.
- **Security/privacy review:** required when access, data, identity, prompts,
  memory, tools, payments or logs are affected.
- **Cost review:** required for variable or potentially unbounded consumption.
- **Founder decision:** required for constitutional authority, strategic veto,
  cross-surface powers, roadmap priority or explicitly reserved decisions.

## ADR gate

Create a Foundation ADR when a change is structural, difficult to reverse,
crosses surfaces, changes security posture, introduces material lock-in, or
alters a previously approved architecture decision. ADR numbering will be
defined separately; Discovery ADR numbers are not reused or silently continued.

## Implementation and validation

Approval authorizes only the declared scope. Implementation must remain small,
reversible and verifiable. Validation evidence identifies commands, environment,
result and residual risk without exposing secrets.

## Publication and supersession

Publication updates indexes, authority register, links and metadata. A replaced
document names its successor and becomes `SUPERSEDED` or `ARCHIVED`; history is
not rewritten to imply that the new rule always existed.

## Urgent and incident paths

Urgency does not create authority. An urgent change may abbreviate sequencing
only when an authorized human owns the risk, scope is minimal, rollback exists
and retrospective review is mandatory. Incidents prioritize containment and
evidence preservation; permanent policy changes return to the standard flow.

## Stop conditions

Stop when authority is unclear, evidence is missing, reviewers disagree on a
critical risk, secrets are exposed, scope expands, rollback is absent for a
high-impact change, or a lower-level document contradicts higher authority.

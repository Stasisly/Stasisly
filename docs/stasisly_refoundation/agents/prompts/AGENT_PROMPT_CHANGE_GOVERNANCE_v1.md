# Agent Prompt Change Governance v1

## Workflow

```text
proposal -> owner review -> duplication review -> risk review
-> security/privacy review -> surface coordinator review
-> cross-surface review when required -> Founder approval when required
-> version assignment -> implementation -> evaluation -> release
```

## Roles and catalog mapping

| Role | Default mapping | Responsibility |
|---|---|---|
| Prompt Owner | Assigned human owner or catalog agent under review | Proposes differentiated content; cannot self-approve |
| Surface Prompt Steward | Stasis `AG-PRO-0001`, Rector `AG-DEV-0001`, Gerendi `AG-ADM-0001`, Nexus `AG-TRV-0001` | Surface consistency after its prompt is approved |
| Domain Reviewer | Approved domain coordinator from catalog | Domain correctness and overlap |
| Security Reviewer | `AG-TRV-0006` future role plus human security reviewer | Threat and tool boundaries |
| Privacy Reviewer | `AG-TRV-0004` future role plus human privacy reviewer | Data, consent and retention |
| Evaluation Reviewer | `AG-DEV-0011` or `AG-DEV-0020` future role plus human reviewer | Evaluation sufficiency |
| Founder Approver | Human Founder only | Decisions reserved to Founder |

Mappings describe future responsibility and grant no present authority.

## Founder-required changes

Founder approval is mandatory for global coordinator changes, Founder control,
critical authority, Founder-only access, constitutional policy, critical risk
acceptance and cross-surface emergency powers. Routine bounded PATCH changes do
not require Founder unless their risk review escalates them.

## Evidence and rollback

Every change records owner, reviewers, decision, version impact, test plan,
compatibility and rollback tuple. Rejected or superseded drafts remain auditable
without becoming runtime inputs.

## Wave 7 change impact

Changes to a family, specialty or overlay require an explicit affected-agent
set, deterministic recomposition, hash comparison and targeted individual gate
reruns. A shared component approval never bulk-approves dependent agents.

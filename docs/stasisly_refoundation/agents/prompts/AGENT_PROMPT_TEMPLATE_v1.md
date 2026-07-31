# Agent Prompt Template v1

This is a governance template, not an implemented agent prompt.

## 1. Metadata

```yaml
prompt_schema_version: 1.0.0
agent_id: REQUIRED_FROM_CATALOG
canonical_name: REQUIRED_FROM_CATALOG
display_name: REQUIRED_FROM_CATALOG
surface: REQUIRED_FROM_CATALOG
domain: REQUIRED_FROM_CATALOG
family: REQUIRED_FROM_CATALOG
agent_type: REQUIRED_FROM_CATALOG
coordination_level: REQUIRED_FROM_CATALOG
risk_level: REQUIRED_FROM_CATALOG
data_access_class: REQUIRED_FROM_CATALOG
tool_access_class: REQUIRED_FROM_CATALOG
memory_scope: REQUIRED_FROM_CATALOG
reports_to: REQUIRED_FROM_CATALOG
lifecycle_status: DESIGNED
prompt_status: DRAFT
prompt_version: 1.0.0
prompt_owner: REQUIRED_AGENT_ID_OR_HUMAN_ROLE
approval_status: DRAFT
approved_by: NONE
approved_at: NONE
source_catalog_version: 1.0.0
supersedes: NONE
```

## 2. Identity

State the stable identity without prestige claims or human impersonation.

## 3. Canonical role

Describe the differentiated role and policy layers it inherits.

## 4. Mission

Define one bounded outcome aligned with the catalog mission.

## 5. Surface

State surface ownership and permitted cross-surface liaison only.

## 6. Domain and family

Bind the exact catalog taxonomy and domain policy versions.

## 7. Scope

List supported decisions, resources, environments and user contexts.

## 8. Responsibilities

List observable responsibilities with evidence expectations.

## 9. Explicit non-responsibilities

List adjacent roles and decisions this agent must not assume.

## 10. Authority

Separate advice, review, approval recommendation and enforced runtime action.

## 11. Prohibited actions

Forbid authority escalation, secret access, impersonation, approval bypass,
unbounded retrieval and destructive action without an external authorization.

## 12. Inputs

Define typed, bounded inputs and reject unknown authority-bearing fields.

## 13. Outputs

Define typed outputs, uncertainty, evidence and safe redaction.

## 14. Data access class

Reference catalog class; bind actual resources only in runtime configuration.

## 15. Tool access class

Reference catalog class; tool grants remain external and deny-by-default.

## 16. Memory scope

Reference scope, purpose, retention, provenance, correction and deletion rules.

## 17. Coordination

Define allowed handoffs, inputs, outputs and conflict protocol.

## 18. Reports-to relationship

Reference the catalog parent without implying unrestricted delegation.

## 19. Human escalation

Define triggers, recipient, minimum evidence and safe stopped state.

## 20. Founder escalation

Use only for approved constitutional, critical-risk or Founder-only decisions.

## 21. Risk controls

Bind risk tier to refusals, review depth and escalation thresholds.

## 22. Privacy controls

Apply minimization, purpose limitation, consent and bounded retention.

## 23. Security controls

Apply instruction isolation, least privilege, safe tool use and exfiltration
resistance.

## 24. Evidence and traceability

Require source attribution, policy decisions, participants and version bindings.

## 25. Failure handling

Fail closed, preserve partial evidence and never invent capability.

## 26. Conflict resolution

Apply layer precedence and escalate unresolved policy conflicts.

## 27. Quality criteria

Define correctness, relevance, safety, clarity, accessibility and bounded cost.

## 28. Evaluation requirements

Reference a separately versioned evaluation suite covering P0-P14 risks.

## 29. Lifecycle

Record current agent and prompt states without claiming availability.

## 30. Versioning

Explain the semantic version impact and independent runtime/evaluation versions.

## 31. Change history

Record proposal, owner, reviewers, decision, date and superseded version.

## 32. Prompt body

Contain only differentiated agent-specific instructions after shared layer
references. Never include secrets, runtime grants or copied constitutional text.

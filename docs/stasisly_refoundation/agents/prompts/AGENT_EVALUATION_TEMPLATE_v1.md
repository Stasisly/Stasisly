# Agent Evaluation Template v1

## Metadata

```yaml
evaluation_schema_version: 1.0.0
evaluation_version: 1.0.0
agent_id: REQUIRED
prompt_version: REQUIRED
policy_layer_versions: REQUIRED
owner: REQUIRED
approval_status: DRAFT
approved_by: NONE
approved_at: NONE
```

## Case contract

Each case defines a synthetic input, authorized context, expected behavior,
forbidden behavior, severity, deterministic assertions, reviewer and evidence.
No production data or secrets are permitted.

## Required categories

1. Role adherence.
2. Scope adherence.
3. Authority boundaries.
4. Refusal behavior.
5. Human escalation.
6. Founder escalation.
7. Privacy.
8. Security.
9. Tool safety.
10. Memory safety.
11. Hallucination control.
12. Source attribution.
13. Cross-agent coordination.
14. Conflict handling.
15. Failure recovery.
16. Output quality.

## Adversarial minimum

Test prompt injection, indirect instruction injection, authority spoofing,
cross-surface data requests, secret solicitation, tool abuse, memory poisoning,
malformed structured data, unavailable dependencies and conflicting policies.

## Result

Record pass/fail per case, critical failures, residual risks and reviewer
decision. Evaluation success alone does not configure or make an agent
available; P15-P17 remain separate gates.

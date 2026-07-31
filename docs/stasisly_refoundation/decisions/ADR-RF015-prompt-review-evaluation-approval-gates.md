# ADR-RF015 - Prompt Review, Evaluation and Approval Gates

## Status

`Decision: APPROVED`

```text
Implementation: PROMPT_GOVERNANCE_DOCUMENTED
Historical prompts: HISTORICAL_PROMPTS_NOT_MIGRATED
New prompts: NEW_PROMPTS_NOT_CREATED
Runtime: RUNTIME_NOT_IMPLEMENTED
```

## Decision

Require P0-P14 for documentary prompt design and approval. Runtime
configuration, testing and availability use distinct P15-P17 gates in later
packages. Evaluation suites cover role, scope, authority, privacy, security,
tools, memory, coordination, failure and quality.

## Consequences

Critical failures block progression. No agent, coordinator or committee may
self-approve when mandatory review applies.

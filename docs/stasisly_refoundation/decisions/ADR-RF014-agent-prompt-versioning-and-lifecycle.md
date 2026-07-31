# ADR-RF014 - Agent Prompt Versioning and Lifecycle

## Status

`Decision: APPROVED`

```text
Implementation: PROMPT_GOVERNANCE_DOCUMENTED
Historical prompts: HISTORICAL_PROMPTS_NOT_MIGRATED
New prompts: NEW_PROMPTS_NOT_CREATED
Runtime: RUNTIME_NOT_IMPLEMENTED
```

## Decision

Version prompt schema, agent prompt, runtime configuration and evaluation suite
independently. Apply semantic MAJOR, MINOR and PATCH impact rules. Prompt
creation, approval, configuration, testing and availability remain separate
states.

## Consequences

`PROMPT_CREATED` never means `AVAILABLE`. Approved changes create immutable
version evidence and a complete rollback tuple.

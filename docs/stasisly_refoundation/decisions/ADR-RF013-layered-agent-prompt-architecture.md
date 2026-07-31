# ADR-RF013 - Layered Agent Prompt Architecture

## Status

`Decision: APPROVED`

```text
Implementation: PROMPT_GOVERNANCE_DOCUMENTED
Historical prompts: HISTORICAL_PROMPTS_NOT_MIGRATED
New prompts: NEW_PROMPTS_NOT_CREATED
Runtime: RUNTIME_NOT_IMPLEMENTED
```

## Decision

Compose future prompts from independently versioned constitutional, surface,
domain/family, agent-specific, runtime, task and temporary-instruction layers.
Earlier policy layers prevail and later layers cannot broaden authority.

## Consequences

Agent files remain differentiated and small. Runtime authorization stays
external to prompt text. Every tested composition binds exact layer versions
and hashes; missing or conflicting layers fail closed.

# ADR-RF016 - Historical Prompt Migration by Controlled Waves

## Status

`Decision: APPROVED`

```text
Implementation: PROMPT_GOVERNANCE_DOCUMENTED
Historical prompts: HISTORICAL_PROMPTS_NOT_MIGRATED
New prompts: NEW_PROMPTS_NOT_CREATED
Runtime: RUNTIME_NOT_IMPLEMENTED
```

## Decision

Migrate prompts through bounded design waves ordered by governance, security
and architectural dependency. Wave 1 is exactly Nexus, Stasis, Rector and
Gerendi. The 43 historical prompts are assigned to later waves and are not
migrated simultaneously.

## Consequences

Each wave needs a separate approved package. Historical sources remain
unchanged evidence until a replacement prompt passes its required gates.

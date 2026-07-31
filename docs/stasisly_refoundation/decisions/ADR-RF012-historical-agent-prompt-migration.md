# ADR-RF012 - Historical Agent Prompt Migration

## Status

`Decision: APPROVED`

```text
Implementation: CATALOG_IMPLEMENTED
Prompts: PROMPTS_NOT_IMPLEMENTED
Runtime: RUNTIME_NOT_IMPLEMENTED
```

## Decision

Map the 43 historical prompt files once into the Re-foundation catalog without
copying or editing their contents. Preserve `PROMPT_CREATED` as historical
evidence, assign 40 entries to `MIGRATE_AND_UPDATE` and three to `RECLASSIFY`,
and keep every mapped entry `NOT_IMPLEMENTED` and `NOT_AVAILABLE`.

Historical prompt migration is deferred to approved waves. Each prompt must be
reviewed against current scope, safety, tools, memory and human escalation
before configuration or testing.

## Consequences

The crosswalk is complete but does not assert that a historical prompt is
current, safe or callable. No prompt file moves, merges or automatic generation
occur in this decision.

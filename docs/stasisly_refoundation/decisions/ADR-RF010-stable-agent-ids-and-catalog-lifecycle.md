# ADR-RF010 - Stable Agent IDs and Catalog Lifecycle

## Status

`Decision: APPROVED`

```text
Implementation: CATALOG_IMPLEMENTED
Prompts: PROMPTS_NOT_IMPLEMENTED
Runtime: RUNTIME_NOT_IMPLEMENTED
```

## Decision

Agent IDs are immutable within their assigned surface ranges. Display names
may evolve, while `agent_id` remains stable and `canonical_name` changes only
through an explicit versioned migration.

The normal lifecycle is `CATALOGED -> DESIGNED -> PROMPT_CREATED -> CONFIGURED
-> TESTED -> AVAILABLE -> ACTIVE`. Suspension, return, retirement and archive
use only the transitions defined by `AGENT_LIFECYCLE_AND_GOVERNANCE_v1.md`.
Direct promotion from cataloged to active is forbidden.

## Consequences

Catalog records are not callable merely because they exist. Access classes are
future review metadata and grant no data, tool or memory permission.

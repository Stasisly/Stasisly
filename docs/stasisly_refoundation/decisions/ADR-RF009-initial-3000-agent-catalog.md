# ADR-RF009 - Initial 3,000-Agent Catalog and Coverage-Driven Expansion

## Status

`Decision: APPROVED`

```text
Implementation: CATALOG_IMPLEMENTED
Prompts: PROMPTS_NOT_IMPLEMENTED
Runtime: RUNTIME_NOT_IMPLEMENTED
```

## Decision

Adopt the deterministic `AgentCatalogEntryV1` catalog with 3,000 metadata
records: Product 1,050, Development 1,200, Administration 700 and Transversal
50. The allocation is a coverage baseline, not a maximum or an activation
target.

Expansion requires a demonstrated capability gap, duplicate review, taxonomy,
owner, risk and lifecycle approval. Catalog size remains unbounded under
governance; global design does not authorize speculative runtime provision.

## Consequences

CSV and JSON are canonical machine-readable views generated from a versioned
specification. Markdown views, duplication analysis and gap analysis are
derived evidence. New prompts, runtime registrations, tools and memory require
later packages.

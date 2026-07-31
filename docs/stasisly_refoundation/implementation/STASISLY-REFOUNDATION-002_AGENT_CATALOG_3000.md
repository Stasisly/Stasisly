# STASISLY-REFOUNDATION-002 - Agent Catalog 3000

## 1. Objective

Establish the definitive initial taxonomy and a reproducible metadata catalog
without creating prompts, runtime agents, permissions or memory instances.

## 2. Distribution

Product 1,050; Development 1,200; Administration 700; Transversal 50; total
3,000. The allocation is coverage-driven, initial and not a maximum.

## 3. Taxonomy

`Surface -> Domain -> Family -> Area -> Subarea -> Specialty -> Subspecialty ->
Function -> Agent`. Optional levels remain explicit empty strings in canonical
machine views.

## 4. Schema

`AgentCatalogEntryV1` defines 29 required keys. Closed vocabularies and the
non-provisioning meaning of access metadata are documented in the schema.

## 5. Identifiers

Stable ranges are `AG-PRO-0001..1050`, `AG-DEV-0001..1200`,
`AG-ADM-0001..0700` and `AG-TRV-0001..0050`. IDs are never reused.

## 6. Lifecycle

New entries begin `CATALOGED`, `NOT_CREATED`, `NOT_IMPLEMENTED` and
`NOT_AVAILABLE`. Historical entries preserve justified `PROMPT_CREATED` state
but remain unimplemented and unavailable.

## 7. Product

Product covers Stasis coordination, health, nutrition, training, wellness,
memory and personalization, research, user safety, accessible communication,
sensors and integrations, and product quality. Health is its largest branch.

## 8. Development

Development covers architecture, all clients, backend and APIs, PostgreSQL and
Supabase, routing and sharding, security, AI systems, prompts and memory, QA,
platform operations, scalability, integrations, commerce and engineering
operations.

## 9. Administration

Administration covers operations, accounts and permissions, finance, customer
operations, trust, legal and risk, catalog and analytics, mandatory marketing
and growth, audience, partnerships, people, incidents and continuity.

## 10. Transversal

Transversal covers Nexus, global strategy, risk, security, privacy, enterprise
architecture, audit, quality, conflict resolution, costs, resilience,
compliance and Founder liaison.

## 11. Historical 43 Agents

The exact RF-001 inventory maps 43/43 prompt files. Decisions are 40
`MIGRATE_AND_UPDATE` and three `RECLASSIFY`; no historical content is changed.

## 12. Duplicates

IDs, canonical names, display names and missions are unique. Similar functions
across bounded specialties are intentional specialization. No automatic merge
is performed.

## 13. Coverage Gaps

The catalog records unresolved evidence for clinical review, provider consent,
data residency, AI benchmarks, legal and tax jurisdictions, resilience drills
and implemented Founder control. Count does not imply complete coverage.

## 14. Validations

The generator verifies counts, ranges, names, fields, enums, state, parent and
coordinate references, cycles, liaison boundaries, mission length, historical
mapping and principal coordinators. Tests verify CSV/JSON parity and byte-stable
regeneration.

## 15. Security

This package performs zero remote actions and Supabase mutations, reads no
secrets, modifies no environment files and provisions no tools, memory or data
access. Access classes are catalog metadata only.

## 16. Results

The catalog is reproducible from
`AGENT_CATALOG_GENERATION_SPEC_v1.json` and the exact historical inventory.
Canonical CSV and JSON contain all 3,000 complete records; Markdown provides
human views and evidence reports.

```text
Catalog and architecture guards: 10/10 new tests pass
Flutter: 1002 pass / 5 approved skips / 0 failures
Analyzer: 0 errors / 0 warnings / 36 inherited infos
Deno: 86/86 pass; format 62 files
SQL local: 740/740 pass after no-seed reset
Remote context: SAFE
```

## 17. Readiness

Catalog metadata is implemented. Individual prompts and all runtime behavior
remain explicitly unimplemented and unavailable.

## 18. Next Step

Founder must select one future package: controlled prompt migration and wave
planning, controlled legacy archive migration, or clean Supabase Development
architecture. This package authorizes none of them.

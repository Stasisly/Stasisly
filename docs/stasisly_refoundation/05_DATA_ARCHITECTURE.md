# Data Architecture

## Decisions

```text
Canonical database: PostgreSQL
Initial provider: Supabase
Initial topology: one primary database per environment
Portability: REQUIRED
Horizontal sharding: PREPARED / NOT_IMPLEMENTED
```

## Logical path

```text
User or Tenant
→ authorization context
→ Data Router
→ Shard Directory
→ placement policy
→ PostgreSQL/Supabase shard
```

Initially all Development users map conceptually to
`development-shard-001`. This is a logical placement name, not a created remote
resource.

## Placement inputs

Future placement may consider region, legal residency, tenant, organization,
volume, load, risk, cost, isolation and subscription. Fixed numeric user-ID
blocks are rejected as the primary strategy.

## Contracts

Data Router, Shard Directory, Data Placement Policy, Shard Migration Policy and
Regional Data Policy require versioned contracts before implementation.
Portability includes export, migration, verification, rollback and audit.

## Scale trigger

Real sharding requires metrics, a dedicated ADR, operational ownership,
observability, test evidence and rollback. This baseline creates no shards and
changes no schema.

PostgreSQL is the canonical database contract and Supabase is the initial
replaceable provider. One principal database per environment is the initial
implementation model. Data Router and Shard Directory are `NOT_IMPLEMENTED`;
fixed 1000-user placement blocks are forbidden. Memory, RAG indexes, research
evidence and evaluations have separate provenance, access and retention.

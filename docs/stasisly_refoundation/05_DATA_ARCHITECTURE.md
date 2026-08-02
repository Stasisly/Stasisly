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

Wave 4 further requires federated Product memory to preserve consent, scope,
provenance, timestamp, confidence, retention, deletion and supersession. A
conflict must remain visible until resolved and may not be silently overwritten.
Research artifacts separately preserve mode, participants, sources, uncertainty
and decision traceability. No memory store, RAG index or research runtime is
created by these documentary contracts.

W7-003 makes purpose, legal basis, data category, jurisdiction, retention,
deletion, backup, derived-data, residency, transfer and processor evidence
explicit. Sensitive health and private data remain need-to-know and minimized.
No schema, remote data, transfer, deletion, export or operational request is
created by this documentary baseline.

W7-004 distinguishes customer, account, subscription, entitlement, invoice,
transaction, charge, refund, dispute, settlement, payout, ledger and
reconciliation evidence. Currency, amount, period, provider, source,
idempotency and immutable provenance remain explicit. No schema, credential,
financial record or operational mutation is created.

W7-005 keeps service, environment, region, release, severity, impact, signal,
timeline, owner, decision, stop condition and verification evidence explicit.
Telemetry is minimized and redacted; secrets and cross-tenant data are
forbidden. No schema, credential, production access, runtime memory or
operational mutation is created.

W7-006 keeps provider, merchant, store, environment, transaction lineage,
amount, currency, minor-unit representation, event provenance, idempotency and
reconciliation evidence explicit. Provider events are not canonical ledger
truth. Data access remains `NO_USER_DATA`; no credential, payment record,
schema, ledger write or commerce mutation is created.

W7-007 keeps asset, subject, tenant, environment, purpose, threat, control,
dependency, artifact provenance, forensic custody and authorization evidence
explicit. Security-restricted data is minimized, redacted, purpose-bound and
case-scoped. Raw secrets, keys and credentials are forbidden; no schema,
personal-data expansion, access grant, cryptographic operation or mutation is
created.

W7-008 keeps user, subject, tenant, purpose, consent, symptoms, clinical
context, source, units, recency, uncertainty, safety flags and accountable owner
explicit. Sensitive health evidence is minimum-necessary, redacted and
user/tenant/case-scoped. No schema, health record, diagnosis, prescription,
memory, access grant or operational mutation is created.

W7-009 preserves the same health-data boundary for gastroenterology, geriatrics,
gynecology, health education, health monitoring and hematology. Evidence keeps
subject, tenant, purpose, consent, source, units, recency, uncertainty and owner
explicit. No schema, health record, diagnosis, memory, access grant or mutation
is created.

Wave 5 requires versioned API and data contracts, bounded pagination, explicit
errors, idempotency and compatible migration paths. PostgreSQL changes require
constraints, indexes, RLS, grants, local validation and rollback. Jobs, events,
workflows, cache and search require ownership, limits, retries, deduplication,
tenant isolation and observable failure recovery. These are documentary
requirements; no schema or service is changed by Wave 5.
## Wave 6 Administration data contracts

Identity, account, profile, role, permission, entitlement, subscription, support history and status are distinct. Plan, price, trial, invoice, payment intent, payment, refund, dispute and ledger entry are also distinct. Administration evidence is minimized, purpose-bound, retained explicitly and auditable; no real data or mutation is authorized by the documentary baseline.

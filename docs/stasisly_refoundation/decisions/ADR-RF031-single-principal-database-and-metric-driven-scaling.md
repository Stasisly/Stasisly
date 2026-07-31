# ADR-RF031 - Single Principal Database and Metric-Driven Scaling

Status: `APPROVED`

## Decision

Use one principal PostgreSQL database per environment initially. Partitioning, replicas, sharding and service extraction require measured pressure, a migration plan and a separate ADR. Fixed 1000-user blocks are forbidden. `RUNTIME_NOT_IMPLEMENTED`; `AGENTS_NOT_AVAILABLE`.

## Consequences

Global design is retained while implementation stays proportional to verified demand.

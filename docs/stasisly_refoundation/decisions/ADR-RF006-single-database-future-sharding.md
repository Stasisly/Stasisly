# ADR-RF006 - Single database per environment with future sharding readiness

## Status

`Decision: APPROVED`

`Implementation: PLANNED`

## Decision

Begin with one primary database per environment and define Data Router, Shard
Directory and placement/migration policies as contracts. Do not implement real
sharding until metrics and a dedicated ADR justify it.

Fixed numeric user-ID ranges are rejected as the primary placement strategy.

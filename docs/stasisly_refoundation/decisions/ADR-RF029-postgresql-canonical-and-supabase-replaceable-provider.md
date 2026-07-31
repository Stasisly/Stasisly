# ADR-RF029 - PostgreSQL Canonical and Supabase Replaceable Provider

Status: `APPROVED`

## Decision

PostgreSQL is the canonical database contract. Supabase is the initial provider behind versioned adapters and remains replaceable. `RUNTIME_NOT_IMPLEMENTED`; `AGENTS_NOT_AVAILABLE`.

## Consequences

Provider-specific behavior cannot become an implicit product contract. Portability requires schema, data export, authorization and rollback evidence.

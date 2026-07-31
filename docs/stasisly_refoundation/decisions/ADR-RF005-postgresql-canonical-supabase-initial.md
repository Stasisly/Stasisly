# ADR-RF005 - PostgreSQL canonical and Supabase initial provider

## Status

`Decision: APPROVED`

`Implementation: DOCUMENTED`

## Decision

PostgreSQL is the canonical database technology. Supabase is the initial
provider, not a permanent architectural dependency. Data, auth and storage
contracts require portability, export and migration paths.

Existing Supabase assets are legacy evidence and are not automatically adopted.

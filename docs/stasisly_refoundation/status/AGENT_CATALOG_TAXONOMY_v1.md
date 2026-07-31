# Agent Catalog Taxonomy v1

## Status

`APPROVED_BASELINE / CATALOG_NOT_GENERATED`

## Canonical path

`surface → domain → family → area → subarea → specialty → subspecialty → function → agent`

Each level is optional only where semantically inapplicable; missing values use
an explicit neutral classification, never an overloaded free-form string.

## Naming and duplication

- `agent_id` is immutable and opaque.
- `canonical_name` is stable, unique and machine-oriented.
- `display_name` is localizable and may change.
- Aliases cannot create a second canonical identity.
- Same mission and authority means merge or explicit version succession.
- Related but distinct scopes require documented specialization boundaries.
- Surface, environment or market variants reference a shared family when
  appropriate rather than duplicating prompts blindly.

## Type and coordination

Agent types may include coordinator, specialist, reviewer, executor, auditor or
temporary incident role. Coordination level records global, surface, domain,
area, subarea or none. Neither field grants runtime authority.

## Versioning

Every material prompt, tool, policy or scope change increments the agent
version and records compatibility, tests and rollback.

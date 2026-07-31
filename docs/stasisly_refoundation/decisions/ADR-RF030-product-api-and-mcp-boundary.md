# ADR-RF030 - Product API and MCP Boundary

Status: `APPROVED`

## Decision

Product clients consume a versioned API. MCP is an internal tool protocol and is not the Product API. Flutter holds no service credentials, cross-surface authorization or sensitive backend logic. `RUNTIME_NOT_IMPLEMENTED`; `AGENTS_NOT_AVAILABLE`.

## Consequences

Every tool invocation requires a governed server-side adapter, explicit authorization, bounded input and auditable output.

# ADR-RF050: Client Applications Do Not Exclusively Own Sensitive Logic

## Status

Decision: `APPROVED`

Implementation:

```text
DOCUMENTARY_PROMPTS_IMPLEMENTED
DEVELOPMENT_SURFACE_NOT_IMPLEMENTED
RUNNERS_NOT_IMPLEMENTED
RUNTIME_NOT_IMPLEMENTED
AGENTS_NOT_AVAILABLE
```

## Decision

Flutter, iOS, Android and Web clients may own presentation and bounded local state, but authorization, tenant isolation, secrets and durable sensitive invariants require backend enforcement.

## Consequences

Clients consume versioned APIs and replaceable adapters. MCP is not a Product API and service-role credentials never belong in clients.

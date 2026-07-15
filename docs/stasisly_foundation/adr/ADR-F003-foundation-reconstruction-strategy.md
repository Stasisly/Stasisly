# ADR-F003 — Foundation Reconstruction Strategy

## Metadata

| Field | Value |
|---|---|
| Status | APPROVED |
| Authority level | 2 — Foundation ADR |
| Owner | Architecture under Rector with Nexus coordination |
| Approver | Founder |
| Decision package | FOUNDATION-006 |
| Baseline | `3562083` |
| Dependencies | ADR-F001, ADR-F002, FOUNDATION-005, FOUNDATION-005-R1 |

## Context

The inherited codebase contains validated local-safe invariants and unsafe
legacy/provider boundaries. A full rewrite would discard evidence and increase
risk; adopting current code wholesale would preserve non-conformant authority,
surface and portability assumptions. R1 closed the table-level P0 locally but
did not make the codebase Foundation-conformant.

## Decision

Stasisly adopts controlled, package-based reconstruction:

1. Remediate security and authorization before Product expansion.
2. Preserve validated invariants after conformance review.
3. Replace unsafe boundaries and contain legacy paths before adoption.
4. Deliver coherent packages with implementation, tests, documentation, commit
   and push when local and reversible.
5. Separate remote, production, real-data, secret, elevation, billing and
   irreversible actions behind explicit approval.
6. Start Stasis Engine and platform capabilities as modular responsibilities,
   not premature microservices.
7. Require the Foundation adoption gate before any asset is called
   `FOUNDATION_ADOPTED`.
8. Treat Supabase and other providers as adapters, not the identity of Stasisly
   contracts.

## Alternatives considered

- **Wholesale rewrite:** rejected; loses tested invariants and delays risk
  reduction without evidence that every component is unsalvageable.
- **Adopt current code then refactor:** rejected; promotes client authority,
  legacy routes and provider coupling into Foundation.
- **Independent parallel feature work:** rejected until shared authorization,
  identity and surface decisions are stable.
- **Immediate microservices:** rejected; operational complexity is unjustified.

## Consequences

- FOUNDATION-007 authorization/threat-model work is the next package.
- Product, Engine and Administration implementation remain gated.
- Asset classification and execution priority are tracked separately.
- Existing deny-all, ownership, DTO, fail-closed, explicit-ID, atomicity and
  reproducibility tests are preserved when their assumptions remain valid.
- Planning overhead is accepted to reduce unsafe coupling and hidden authority.

## Adoption and rollback

An asset requires an approved contract, surface assignment, security review,
provider boundary, tests, synchronized documentation, no hidden legacy
authority and accepted residual debt. Before adoption, it remains `CANDIDATE`.

This ADR can be superseded by a Founder-approved ADR. Individual packages roll
back by explicit revert or disabled local entry point; rollback must not reopen
legacy access or weaken deny-all. No remote action is authorized here.

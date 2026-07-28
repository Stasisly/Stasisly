# ADR-F032 - Catalog envelope adaptation and clean diagnostic classification

## Status

```text
Decision: APPROVED
Implementation: IMPLEMENTED_LOCALLY
```

## Context

The Product catalog API returns an exact `{items}` object while the R2E
functional runner required a raw list. The R2F diagnostic used a separate
bounded raw database list parser. The catalog itself contained one available
canonical candidate, but divergent envelope semantics blocked the functional
attempt. R2F also emitted `containedClean` despite executing no containment
action.

## Decision

1. Functional and diagnostic tooling share
   `DevelopmentCatalogEnvelopeAdapter`.
2. Every external envelope is selected by an explicit source category.
3. Product supports only the exact one-field `items` object demonstrated by the
   Edge Function and Product contract.
4. Diagnostic tooling supports a raw list only for its explicit bounded direct
   REST source.
5. `CanonicalSelectableSpecialistPage` is the internal representation.
6. Unsupported, ambiguous, malformed, unversioned or pagination-incoherent
   shapes fail closed.
7. Pagination metadata cannot be ignored. A full 20-item page without a cursor
   contract blocks.
8. Exact-one selection runs only after valid bounded adaptation.
9. Zero residue with zero containment actions is
   `DIAGNOSED_FAILED_CLEAN`.
10. Successful exact removal followed by seven zeros is `CONTAINED_CLEAN`.
11. R2G performs no remote execution and does not change Product or backend
    behavior.

## Consequences

- Functional manifest v4 and runner R2G-v1 replace v3/R2E-v1 for future
  authorization.
- Diagnostic manifest v2 and diagnostic runner R2G-v1 correct future clean
  classification.
- Historical R2F output remains immutable and is recorded together with its
  governance-normalized result.
- A future cursor-bearing catalog contract requires a new adapter version,
  tests and authorization.

## Validation

Envelope, pagination, candidate, classification, shared-adapter and historical
root-cause regression tests are mandatory. Full Flutter, Deno and local SQL
regression must pass before publication.

## Security

No remote action, secret read, fixture creation, catalog/specialist mutation,
Auth/Conversation creation, migration, deploy or Product/backend change is
authorized by this ADR.

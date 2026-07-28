# ADR-F030 — Canonical specialist resolution policy

## Status

```text
Decision: APPROVED
Implementation: IMPLEMENTED_LOCALLY
Remote validation: NOT_EXECUTED
```

## Context

FOUNDATION-019A-R2D left two incompatible specialist semantics: the executable
runner always created a synthetic specialist/catalog pair, while the next
Founder authorization required a verified preexisting canonical specialist.
The retry was stopped before remote and its authorization was not consumed.

The public `SelectableSpecialistCatalog` contract exposes a bounded list of at
most 20 sanitized entries with `selectableSpecialistId`, display data, public
area and access state. It exposes no canonical alias. Product and backend are
outside the scope of R2E.

## Decision

The FOUNDATION-019A functional Development validation uses:

```text
policy: VERIFIED_PREEXISTING_READ_ONLY
source: SELECTABLE_SPECIALIST_CATALOG
selection: EXACT_ONE_AVAILABLE_IN_CANONICAL_AREA
canonical area: stasis
maximum candidates: 20
ambiguity: BLOCK
```

The runner accepts exactly one valid `available` catalog entry in the requested
canonical area. Zero, multiple, malformed, unavailable, unauthorized or
environment-incompatible results fail closed. It never selects the first entry,
uses a hardcoded identifier or creates a fallback.

The selected catalog and specialist resources are ledgered as
`VERIFIED_PREEXISTING_READ_ONLY`, with no cleanup handle and no delete
operation. Specialist/catalog residue counters mean run-owned fixtures
remaining. Because this manifest forbids those fixtures, their expected count
is contractually zero and does not require a broad remote lookup.

## Extensibility

`SpecialistResolutionPolicy` is the versioned substitution boundary.
`VerifiedPreexistingReadOnlyPolicy` is the only implemented and authorized
policy for this attempt. A synthetic-fixture or explicitly authorized policy
requires its own implementation, manifest, ledger semantics, cleanup contract,
tests and Founder authorization.

This applies global design with proportional implementation: the policy
boundary is extensible, while no speculative provider or unused policy is
implemented.

## Consequences

- Manifest v3 and runner R2E-v1 have one specialist semantic.
- Product and backend contracts remain unchanged.
- Specialist and catalog mutations are forbidden in this attempt.
- Cleanup can act only on `CREATED_BY_RUN`.
- The 25-state machine remains unchanged.
- Any future remote execution requires a new commit-bound Founder authorization.

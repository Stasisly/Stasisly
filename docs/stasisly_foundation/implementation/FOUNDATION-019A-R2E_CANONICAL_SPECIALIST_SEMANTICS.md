# FOUNDATION-019A-R2E — Canonical specialist semantics

## Baseline and blocked retry

R2E started from `73ba53e0b1399944b6945581ba88a0a8d377b515`, with Discovery
baseline `7f747e0cf60012ce315216a5486db3c5481f8f60`, a clean synchronized
`main` and remote context `SAFE`.

`FA-019A-RETRY-20260728-005` was not consumed. It remains bound to the old
commit and becomes invalid after R2E. No remote action, lookup or `.env` access
occurred.

The exact contradiction was:

```text
runner: always create run-owned specialist/catalog fixtures
manifest v2: VERIFIED_OR_RUN_OWNED
Founder order: VERIFIED_PREEXISTING_READ_ONLY only
```

## Adopted model

```text
manifest: FOUNDATION-019A-SECOND-FUNCTIONAL-ATTEMPT-v3
runner: FOUNDATION-019A-R2E-RUNNER-v1
policy: VERIFIED_PREEXISTING_READ_ONLY
source: SELECTABLE_SPECIALIST_CATALOG
selection: EXACT_ONE_AVAILABLE_IN_CANONICAL_AREA
area: stasis
limit: 20
ambiguity: BLOCK
```

The real catalog contract has no public alias. R2E therefore uses the approved
deterministic-category option and requires exactly one available result. It
does not derive an ID locally, choose the first candidate, invent a specialist
or widen Product/backend.

`SpecialistResolutionPolicy` provides the extensible boundary. Only
`VerifiedPreexistingReadOnlyPolicy` is implemented and selected. Other policy
families remain unimplemented and unauthorized.

## Runner, ledger and cleanup

`resolveSpecialistFromCanonicalCatalog()` performs the authenticated bounded
catalog read, strict five-field validation and closed policy evaluation. It
records catalog and specialist as `VERIFIED_PREEXISTING_READ_ONLY`, marks their
verification complete and stores no cleanup handle.

The functional runner contains no specialist/catalog create endpoint and no
specialist/catalog delete endpoint. Attempting to route either category through
cleanup throws `READ_ONLY_CLEANUP_BLOCKED`. Cleanup still operates exclusively
on `CREATED_BY_RUN`.

The seven counters remain:

```text
messages | idempotency | sessions | profiles | catalog | specialists | auth
```

`catalog` and `specialists` count only run-owned fixtures. Manifest v3 forbids
their creation, so the ledger verifies both categories read-only and emits zero
without broad listing or deletion.

## State machine, matrix and gates

The 25 states are unchanged. `AUTH_USER_CREATED → SPECIALIST_RESOLVED` now
requires canonical catalog validation, exact deterministic selection, read-only
ledger classification and no fixture creation.

The manifest matrix maps specialist resolution to:

```text
runner: resolveSpecialistFromCanonicalCatalog
ledger: VERIFIED_PREEXISTING_READ_ONLY
cleanup: NONE
```

Local contract validation returns:

```text
CANONICAL_SPECIALIST_CONTRACT_PASS
EXECUTABLE_RUNNER_CONTRACT_COMPLETE
MANIFEST_RUNNER_SPECIALIST_SEMANTICS_MATCH
```

## Guards, tests and simulations

Guards reject fixture helpers, specialist/catalog REST mutations, first-item
fallbacks, dual manifest semantics, mismatched versions and read-only cleanup.
Resolution tests cover one/zero/multiple candidates, canonical-area selection,
unavailable/malformed catalogs, invalid fields/status/ID/area, environment and
authorization mismatch, and the 20-entry bound.

Ledger tests prove read-only verification, no cleanup handle, exclusion from the
cleanup plan, unknown-ownership blocking and deletion rejection. Integral
simulation runs the valid path twice and exercises closed failure cases.

Final local regression:

```text
focal contracts/architecture: 77 pass
Flutter: 797 pass / 5 approved skips / 0 failures
Analyzer: 0 errors / 0 warnings / 36 inherited infos
Deno: 86/86 pass
SQL: 740/740 pass after local no-seed reset
```

## Security and readiness

```text
remote actions: 0
specialist/catalog creates: 0
specialist/catalog deletes: 0
hardcoded real IDs: 0
broad specialist lookups/deletes: 0
remote skips: CLASSIFIED_NOT_ENABLED
schema/backend/Product changes: 0
```

Remote execution remains unauthorized. A future order must use the R2E commit,
manifest v3, runner R2E-v1, exact Development context, the canonical read-only
policy and a new unique Founder reference. Suggested reference:
`FA-019A-RETRY-20260728-006`; this document does not grant it.

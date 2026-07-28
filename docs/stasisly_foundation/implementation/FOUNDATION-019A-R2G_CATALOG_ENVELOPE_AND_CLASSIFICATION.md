# FOUNDATION-019A-R2G - Catalog envelope and clean classification

## 1. Baseline

R2G starts from
`df872c95bf0ee67d3e314987e9ba4000d18b5936` on synchronized `main`,
with a clean worktree, Discovery baseline
`7f747e0cf60012ce315216a5486db3c5481f8f60` and Supabase remote context
`SAFE`. R2G performs no remote action and does not read `.env`.

## 2. Diagnosed-clean evidence

The authorized R2F diagnostic confirmed one available canonical candidate,
seven zero counters, zero containment actions, zero residue and final CLI
isolation. Its semantic result is `DEVELOPMENT FAILED_RUN_DIAGNOSED_CLEAN`.
No candidate identity or raw remote response is retained here.

## 3. Root cause

The Product catalog Edge Function and Product repository contract use an exact
object envelope with one `items` field. The R2E functional policy instead
required the complete response body to be a raw list. The R2F diagnostic read a
bounded database list directly and applied separate row classification. Valid
catalog content therefore reached two incompatible envelope parsers.

## 4. Supported envelopes

R2G supports exactly two source-qualified forms:

- `productItemsEnvelope`: an object with exactly `items`;
- `diagnosticDirectRawList`: a raw list accepted only for the explicit bounded
  diagnostic REST source.

A Product raw list, a diagnostic object, an object with unknown fields or an
object mixing `items` and `data` fails closed. R2G does not add a generic data
envelope because no versioned contract demonstrates one.

## 5. Canonical internal representation

`CanonicalSelectableSpecialistPage` owns `items`, `nextCursor`, `hasMore`,
`contractVersion` and `sourceCategory`. External shape is removed before
candidate semantics run. Contract version
`FOUNDATION-019A-R2G-CATALOG-v1` is mandatory.

## 6. Shared adapter

`DevelopmentCatalogEnvelopeAdapter` is the single tooling adapter used by the
functional specialist policy and the diagnostic HTTP gateway. Source category
is explicit at each call site; there is no payload-shape guessing. Guard
`CATALOG_ADAPTER_SHARED` prevents parser divergence.

## 7. Fail-closed parsing

The adapter distinguishes supported, unsupported, ambiguous, malformed,
unsupported-version, invalid-items and invalid-pagination outcomes. Missing or
null `items` is never interpreted as an empty catalog. Non-map items and
oversized pages block before candidate selection.

## 8. Pagination

The current approved attempt remains bounded to one page and 20 items. Both
external sources cap their backing query at 20 but expose no cursor. A full
20-item page cannot prove exhaustion and therefore returns
`pageLimitReached`; exact-one selection cannot proceed. Cursor/`hasMore`
inconsistency, cycles, pending pages and unsupported versions also block.

## 9. Candidate semantics

After successful adaptation, the existing policy remains unchanged:
canonical area `stasis`, at most 20 candidates, exactly one `available`
candidate, backend-derived identity and
`VERIFIED_PREEXISTING_READ_ONLY` ownership. Zero or multiple candidates block.
Catalog and specialist mutation or cleanup remain forbidden.

## 10. Classification correction

Clean classification now depends on actual containment action count:

```text
zero actions + seven zeros -> DIAGNOSED_FAILED_CLEAN
one or more successful exact actions + seven zeros -> CONTAINED_CLEAN
unnecessary/incomplete containment or unknown residue -> FAILED_DIRTY_BLOCKING
```

The prior execution remains historical evidence: R2F emitted
`containedClean`; governance normalized the zero-action result to
`DIAGNOSED_FAILED_CLEAN`. R2G does not rewrite that evidence.

## 11. Versions

The executable contract changes require:

```text
functional manifest: FOUNDATION-019A-SECOND-FUNCTIONAL-ATTEMPT-v4
functional runner: FOUNDATION-019A-R2G-RUNNER-v1
diagnostic manifest: FOUNDATION-019A-CONTAINMENT-DIAGNOSTIC-v2
diagnostic runner: FOUNDATION-019A-R2G-DIAGNOSTIC-RUNNER-v1
```

All earlier commit-bound authorizations remain consumed or invalid and cannot
authorize these versions.

## 12. Guards and tests

Local tests cover both explicit envelopes, unsupported and ambiguous objects,
missing/null/scalar/object items, invalid items, unknown fields, unsupported
versions, empty/one/multiple/full/oversized pages, cursor consistency, page
limits, cursor cycles, exact-one selection and all clean classifications. A
sanitized regression proves that the historical object/raw-list divergence now
produces one canonical page.

Validation completed with 105 focal tests, 838 full Flutter tests and five
approved skips, analyzer at zero errors/zero warnings with 36 inherited infos,
Deno format over 62 files and 86/86 tests, and a local no-seed reset followed
by 740/740 SQL tests.

## 13. Security and scope

```text
remote actions: 0
secret reads: 0
.env modifications: 0
catalog/specialist mutations: 0/0
Auth/Conversation creations: 0/0
schema/backend/Product changes: 0
functional remote executions: 0
```

## 14. Readiness and next authorization

R2G may reach
`FOUNDATION-019A CATALOG_ENVELOPE_AND_CLASSIFICATION_FIXED_LOCAL_AND_PUSHED`
only after full local regression, explicit commit and push. A future functional
attempt requires a new unique Founder reference bound to the resulting SHA,
manifest v4, runner R2G-v1, exact Development target/operator/CORS, mandatory
cleanup, seven counters, CLI isolation and the existing retention
acknowledgement. No remote execution is implied.

## 15. Residual debt

`conversation_idempotency` retention remains
`POST_DEVELOPMENT_OPERATIONAL_BLOCKER`. The current catalog API has no cursor;
the safe one-page attempt blocks at a full page rather than claiming complete
pagination. Sustained Development remains unauthorized.

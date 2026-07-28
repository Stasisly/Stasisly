# FOUNDATION-019A-R2F - Containment and catalog diagnostic

## Baseline and failed run

R2F started from synchronized clean `main` at
`7a37dd651ad2f867b851dfca4def00377d802f44`; Discovery remained at
`7f747e0cf60012ce315216a5486db3c5481f8f60` and the Supabase remote context
was `SAFE`, with both target markers absent.

The prior Development attempt ended
`DEVELOPMENT SECOND_FUNCTIONAL_ATTEMPT_V3_FAILED_DIRTY_BLOCKING` during
canonical specialist resolution. `FA-019A-RETRY-20260728-006` is `CONSUMED`,
bound to that commit and not reusable. Auth cleanup completed and its exact
post-lookup was absent. Conversation creation, message send, idempotency
reservation and catalog/specialist mutation were not sent. Seven-counter
verification did not complete, so current remote residue remains
`UNKNOWN_BLOCKING`.

## Run identity

The run alias is available only ephemerally. Operation-attempt, synthetic
principal and idempotency-key derivations are reconstructable exactly without
printing them. Owner Auth and Conversation identifiers are unavailable.
Specialist and catalog identifiers are unsafe for lookup because they identify
canonical read-only resources. No raw handle is persisted or emitted.

## Catalog diagnosis

The versioned backend vocabulary confirms `stasis` as a canonical Product area.
The catalog function applies area, published, available, Product-surface and
conversable filters server-side and bounds the result to 20. Its current
contract has no cursor and no additional page.

The failed-run cause is locally demonstrable:

```text
backend response: {"items": [...]}
R2E policy input: complete response body
R2E policy contract: raw List
classification: CATALOG_CONTRACT_INVALID
```

This diagnosis does not inspect or alter remote catalog data. The new
`CanonicalSpecialistCatalogDiagnostic` preserves explicit categories for
transport, HTTP, JSON, contract, area, pagination, cursor, candidate status,
Product availability, environment and unknown failures. Future output contains
only categories and bounded count classes.

## Seven-counter contract

| Counter | Exact basis | Bound | Clean evidence | Containment |
|---|---|---:|---|---|
| messages | request not sent | 0 | `ZERO` | none |
| idempotency | request not sent | 0 | `ZERO` | none |
| sessions | Conversation request not sent | 0 | `ZERO` | none |
| profiles | exact derived profile marker | 2 | future exact check | exact owner match required |
| catalog | mutation forbidden and not sent | 0 | `ZERO` | forbidden |
| specialists | mutation forbidden and not sent | 0 | `ZERO` | forbidden |
| auth | prior exact post-lookup absent | 0 | `ZERO` | none |

Every counter supports `ZERO`, `NONZERO_EXACT`, `UNKNOWN_BLOCKING`,
`QUERY_NOT_EXECUTED` and `QUERY_FAILED`. Nulls, parse failures, partial or
global counts never become zero.

The `public.users` owner profile has an `ON DELETE CASCADE` foreign key to
`auth.users`, but R2F does not infer cleanup from that alone. The future profile
query is exact and bounded. A derived display marker is discovery evidence, not
deletion authority: deletion additionally requires the independently supplied
exact failed-run owner identifier to match the sole row.

## Exact containment and protection

The dependency order is messages, idempotency, sessions, profiles, catalog,
specialists and Auth. Planning accepts only:

```text
CREATED_BY_FAILED_RUN
+ EXACT_OWNERSHIP_PROOF
+ EXACT_DELETE_HANDLE
```

It rejects `VERIFIED_PREEXISTING_READ_ONLY`, `UNKNOWN_OWNERSHIP`,
`GLOBAL_RESOURCE` and `UNSCOPED_RESOURCE`. Catalog and specialist deletion is
unconditionally blocked. The future HTTP adapter permits only bounded `GET`
and an exact profile `DELETE`; no functional endpoint or Auth creation exists.
No containment operation was executed in R2F.

## Manifest, runner and gate

The manifest is `FOUNDATION-019A-CONTAINMENT-DIAGNOSTIC-v1`; the separate
runner is `FOUNDATION-019A-R2F-CONTAINMENT-RUNNER-v1`. Contract validation is
local and inert. The authorized mode remains closed unless every future gate
matches the new commit, Development target, manifest, runner, exact-lookup
policy, seven counters, canonical protection and CLI isolation.

The consumed functional authorization cannot activate containment. A future
containment authorization cannot activate the functional runner. The suggested
reference `FA-019A-CONTAIN-DIAG-20260728-007` is only a recommendation and
remains `NOT_GRANTED`.

## Tests and simulations

Focal tests cover all catalog categories; zero, one, multiple, unknown, parse,
transport and global/unscoped cases for every counter; exact containment,
canonical deletion blocks and runner isolation. Simulations cover catalog
zero/multiple/invalid, profile/session residue, Auth absence, unknown counters,
forbidden canonical deletion, attempted functional action and CLI isolation
failure.

Final local regression:

```text
focal contracts/architecture: 25 pass
Flutter: 822 pass / 5 approved skips / 0 failures
Analyzer: 0 errors / 0 warnings / 36 inherited infos
Deno formatting: 62 files
Deno: 86/86 pass
SQL: 740/740 pass after local no-seed reset
Remote context: SAFE
```

## Security and readiness

R2F read no `.env`, secret, remote target or resource identity. It performed no
remote action, functional execution, Auth/Conversation creation, mutation,
broad lookup, broad delete, schema change, migration or deploy.

Current remote residue is still unknown. The package only prepares a safe,
fail-closed mechanism for a separately authorized diagnostic and exact
containment. A future authorization must be bound to the published R2F commit
and cannot authorize a functional retry, new fixtures, AI, migration, deploy
or sustained Development operation.

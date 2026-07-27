# FOUNDATION-019A-R2C-R1: Exact Auth resource resolution

## 1. Baseline

Repository baseline `1f37250`, Discovery baseline `7f747e0`, branch `main`,
clean and synchronized. Supabase CLI remote context was `SAFE`.

## 2. R2C result

R2C corrected exact Auth delete idempotency for `200/404`, isolated diagnostic
output and blocked remote cleanup because the exact Auth user ID was unavailable.

## 3. Residual uncertainty

At most one synthetic Auth user may remain. Remote state is still `UNKNOWN`.
This package neither inspects nor changes it.

## 4. Historical identity derivation

Runner `d94292a` used the immutable run alias plus the reserved synthetic domain
template `{runAlias}@example.test`. The password used a separate deterministic
synthetic derivation and is neither needed nor reproduced.

## 5. Lookup key

`SyntheticAuthLookupKey` is deterministic, normalized, synthetic-only and bound
to attempt alias, namespace and fixture version. Historical compatibility
returns `HISTORICAL_SYNTHETIC_AUTH_LOOKUP_KEY_MATCH`.

## 6. Safe representation

The operational exact value exists only in memory at an authorized runtime.
Committed evidence uses `AUTH_RESOURCE_DIAG_002`; no literal synthetic email,
raw ID or persistent hash is stored.

## 7. Exact lookup contract

`ExactSyntheticAuthLookup` accepts Development environment, exact target
confirmation, immutable attempt binding, Founder reference, authorized commit
and operator. It performs no network or provider access.

## 8. Zero, one and multiple semantics

- `0`: `notFound`, clean-compatible.
- `1`: `exactlyOne`, eligible for an ephemeral delete target.
- `>1`: `multipleMatchesBlocking`, no delete target.

## 9. Supabase Auth Admin constraints

A future adapter must remain operator-side, use service-role credentials only
under authorization, discard unrelated records immediately and emit only safe
closed statuses. Flutter never receives credentials or directory records.

## 10. Pagination constraints

Pagination is deterministic, limited to ten pages and must reach one definitive
last page. Empty, excessive, incomplete or contradictory pagination is rejected.

## 11. Attempt binding

Attribution requires exact lookup match, derivation binding, Development,
confirmed target, attempt `diag-20260723-002`, namespace
`foundation-019a-r1-diag-20260723-002` and fixture version
`FOUNDATION-019A-R1-v1`.

## 12. Delete target

`ExactSyntheticAuthDeleteTarget` holds the exact Auth ID only in ephemeral
memory after exactly one match. Its string representation is redacted and the
ID is never committed.

## 13. Delete semantics

`200` means deleted; `404` means already absent. No other status is accepted.

## 14. Post-delete verification

A future containment must repeat exact lookup, require `notFound`, require all
seven counters at zero and isolate the CLI context.

## 15. Seven counters

Order remains messages, conversation idempotency, chat sessions, public user
profiles, specialist catalog entries, specialists and synthetic Auth users.
The Auth count derives only from exact-match lookup.

## 16. Authorization inputs

Required inputs are the new commit SHA, unique Founder reference, exact
Development project and operator, dirty attempt alias, exact namespace, fixture
version, derivation version, allowed lookup/delete operations, seven-counter
contract and mandatory CLI isolation.

## 17. Preflight

The local preflight verifies historical reconstruction and emits only aliases
and closed states. Future remote gating must additionally verify authorization,
commit, target and operator before any lookup.

## 18. Tests

Tests cover stable derivation, changed bindings, invalid inputs, historical
match, exact 0/1/>1 outcomes, case and partial mismatch, bounded pagination,
transport and authorization failures, unrelated users and redacted outputs.
The focal suite passes `24/24`; the full Flutter suite passes `737` tests with
the existing five approved skips and zero failures. Analyzer reports zero
errors or warnings and 36 inherited infos. Backend regression passes `86/86`
after checking 62 formatted files. A local no-seed reset applies migrations
`00001` through `00012`, and the SQL suite passes `740/740`.

## 19. Simulations

Local simulations pass for already absent, delete `200`, delete race `404`,
identity collision and unverifiable post-check. Collisions and unknown
verification remain blocking.

## 20. Security

Remote actions, remote listings, real IDs, literal synthetic emails, secrets,
broad lookup, broad delete, fixtures, skips and schema changes are all zero.
The Supabase CLI remote-context preflight is `SAFE`. Remote residue remains
`UNKNOWN`; no remote inference is made from local validation.

## 21. Recovery

`DATABASE_RECOVERY: NOT_REQUIRED_NO_SCHEMA_CHANGE`. There is no reliable
rollback for deleting a wrong user, so any ambiguity blocks before deletion.

## 22. Readiness

`FOUNDATION-019A EXACT_AUTH_RESOLUTION_READY_FOR_CONTAINMENT_AUTHORIZATION_LOCAL_AND_PUSHED`
after validation, commit and push complete. Before publication, the same
preparation remains local and does not authorize containment.

## 23. Next authorization requirements

Issue a containment-only Founder authorization bound to the new commit. It may
allow temporary Development link, exact target verification, key derivation,
bounded exact-match lookup, delete only on exactly one match, post-delete exact
lookup, seven counters and CLI isolation. It must not authorize fixtures,
smokes, migrations, functions, secrets or broad directory operations.

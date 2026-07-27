# ADR-F027: Exact synthetic Auth resource resolution

## Status

```text
Decision: APPROVED
Implementation: PREPARATION_IMPLEMENTED_LOCALLY
Remote resolution: NOT_AUTHORIZED
```

## Context

The Development diagnostic attempt `diag-20260723-002` may have left one
synthetic Auth user. FOUNDATION-019A-R2C corrected cleanup idempotency but could
not resolve the resource because its raw Auth ID was ephemeral.

The historical runner at `d94292a` deterministically derived the synthetic
email from the immutable run alias. That derivation can be reconstructed without
the password, secrets, `.env`, remote access or personal data.

## Decision

1. Dirty-run Auth resources are resolved by an immutable exact synthetic lookup
   key reconstructed from the historical runner contract.
2. The operational key is bound to attempt alias, run namespace and fixture
   manifest version.
3. Committed evidence uses `AUTH_RESOURCE_DIAG_002`; the literal operational
   lookup value is not committed.
4. Matching is exact and case-sensitive. Prefix, substring, date, latest-user
   and fuzzy matching are prohibited.
5. Pagination is bounded to ten pages and must reach a definitive end.
6. Zero exact matches means already absent.
7. One exact match may create an ephemeral delete-by-ID target.
8. Multiple exact matches block containment.
9. Raw Auth IDs are ephemeral and never committed or logged.
10. Delete success remains restricted to `200` or `404`.
11. Post-delete exact `notFound`, all seven counters at zero and CLI isolation
    are mandatory.
12. Containment authorization is separate, Founder-issued and commit-specific.
13. No remote resolution or deletion occurs during this local implementation.

## Supabase Admin boundary

Any future provider adapter is operator-side and may use service-role
credentials only during an explicitly authorized containment. It must discard
unrelated records immediately, emit only closed safe statuses and never expose
credentials, headers, bodies, IDs or emails to Flutter or committed evidence.
If definitive bounded pagination cannot be proven, lookup is rejected.

## Consequences

- Historical identity is locally reconstructible without persisting it.
- Ambiguous lookup cannot produce a delete target.
- New fixtures and functional retry remain blocked.
- Remote residue remains `UNKNOWN` until a separately authorized containment.

## Verification

Unit tests cover derivation, historical compatibility, exact matching,
pagination, authorization, collisions, canaries and five containment
simulations. Architecture guards prohibit network, process, environment and
broad-match primitives.

## Recovery

`NOT_REQUIRED_NO_SCHEMA_CHANGE`. Revert the R1 commit to remove local contracts.
Remote state is unchanged because this package performs no remote action.

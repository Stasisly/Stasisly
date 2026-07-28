# ADR-F031 - Failed-run containment and exact diagnostics

## Status

```text
Decision: APPROVED
Implementation: IMPLEMENTED_LOCALLY
Remote validation: NOT_EXECUTED
```

## Context

The functional Development attempt bound to
`FA-019A-RETRY-20260728-006` and commit
`7a37dd651ad2f867b851dfca4def00377d802f44` stopped during canonical
specialist resolution. Auth cleanup completed and the exact post-lookup was
absent, but the seven-counter verification was incomplete. The authorization
is consumed and cannot be reused.

Versioned code proves the catalog failure category locally. The
`list-selectable-specialists` function returns an `items` envelope, while the
R2E runner passed the complete response body to a policy that accepts only a
raw list. This is `CATALOG_CONTRACT_INVALID`; it is not evidence that the
remote catalog is empty or malformed.

## Decision

Unknown attributable residue remains blocking. No further functional retry,
fixture, Auth principal or Conversation may be created while that state is
unresolved.

Containment and diagnosis use the separate
`FOUNDATION-019A-R2F-CONTAINMENT-RUNNER-v1` and
`FOUNDATION-019A-CONTAINMENT-DIAGNOSTIC-v1`. A future invocation requires a
new commit-bound Founder authorization scoped only to:

- bounded read-only catalog diagnosis;
- seven exact run-scoped counters;
- exact containment of `CREATED_BY_FAILED_RUN` resources;
- post-containment verification and CLI isolation.

Every lookup is exact and bounded. Broad lookup and broad deletion are
forbidden. Catalog and specialist resources are
`VERIFIED_PREEXISTING_READ_ONLY`; they cannot acquire cleanup handles.
`UNKNOWN_BLOCKING`, query failure, parse failure and missing exact ownership
remain dirty blocking and never become zero.

The current failed-run evidence is sufficient to classify messages,
idempotency and sessions as zero because their requests were not sent. Catalog
and specialist mutation was forbidden and not sent. The prior exact Auth
post-lookup proved absence. Profile verification remains the only potentially
mutable remote check: it is bounded to two results and deletion is impossible
without a separately supplied exact owner identifier matching the single
result.

## Consequences

- R2F performs no remote execution and grants no authorization.
- Functional and containment entry points are physically separate.
- Sanitized evidence contains categories, never raw identities or payloads.
- A future diagnostic may still end `FAILED_DIRTY_BLOCKING`.
- The recommended future reference
  `FA-019A-CONTAIN-DIAG-20260728-007` remains `NOT_GRANTED`.
- Product, schema, migrations, Edge Functions and functional backend behavior
  are unchanged.

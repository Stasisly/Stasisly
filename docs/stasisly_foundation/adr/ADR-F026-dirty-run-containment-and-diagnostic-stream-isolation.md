# ADR-F026: Dirty-run containment and diagnostic stream isolation

## Status

```text
Decision: APPROVED
Implementation: PREPARATION_IMPLEMENTED_LOCALLY
Remote containment: NOT_AUTHORIZED
```

## Context

The bounded Development diagnostic attempt `diag-20260723-002`, executed from
commit `d94292a`, reached only synthetic Auth-user creation. Its HTTP assertion
passed, but finalization reported `FAILED_DIRTY_BLOCKING`.

The runner deliberately invokes exact cleanup twice to prove idempotency. The
first Auth deletion could return `200`; the second could return `404` because
the exact resource was already absent. Treating only `200` as success produced
a false dirty classification. Separately, `dart run` build-hook output could
precede the safe diagnostic markers on stdout.

The exact run namespace is
`foundation-019a-r1-diag-20260723-002`. No downstream fixture operation was
reachable. A synthetic Auth user is therefore the only possible residue.
Its raw user identifier was ephemeral and is not present in safe evidence.

## Decision

1. Exact Auth deletion is idempotently successful only for `200` or `404`.
2. All other delete statuses remain failures.
3. The diagnostic helper writes its safe block to an explicit file.
4. Dart/build output is captured separately and deleted; only a block with the
   exact begin and end markers enters runner stdout.
5. Residue evidence uses seven named counters in a fixed order.
6. The dirty-attempt alias, namespace, commit and fixture contract are immutable.
7. No broad Auth-user listing, wildcard cleanup or inferred identifier is
   allowed.
8. Remote containment remains blocked until an exact authorized Auth-user
   identifier or an approved exact-resolution mechanism is available.
9. Dirty runs block all new fixture execution.
10. Any future containment authorization is separate and commit-specific.
11. Cleanup must follow the dependency-safe seven-counter order and stop on
    unknown residue.

## Consequences

- Local simulation can prove repeated cleanup without false dirty status.
- Diagnostic evidence is parseable and does not mix with build output.
- The repository does not claim the remote residue is absent.
- No new fixture or remote run may start while containment is unresolved.

## Verification

The decision is guarded by unit tests, architecture tests and the shell runner
simulation. Full Flutter, Deno and local SQL baselines remain required before
publication.

## Rollback

Revert the R2C commit. This restores the prior runner behavior but does not
inspect, create or remove any remote resource.

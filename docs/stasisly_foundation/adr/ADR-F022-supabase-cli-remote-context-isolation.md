# ADR-F022: Supabase CLI Remote Context Isolation

## Status

```text
Decision: APPROVED
Implementation: IMPLEMENTED_LOCALLY
Remote execution: NOT_AUTHORIZED
```

## Context

FOUNDATION-018 detected ignored Supabase CLI metadata that retained an implicit
remote project target. A clean Git worktree did not make local-only operations
safe. Recording or validating that target would itself exceed the authorized
scope.

## Decision

Local-only Foundation packages require zero active linked remote CLI context.
Ignored metadata is security-relevant operational state. Known remote link
markers are isolated without recording their values, while cache/runtime files
needed by local Supabase are preserved.

Local database commands must state their local destination explicitly. A
read-only, no-network preflight fails closed on link metadata, dangerous
executable tooling, ambiguous local commands, concrete project references or
remote targets in versionable examples. It emits only safe categories and
relative paths.

Remote linking is a separate founder-authorized package. It must identify the
target and operator explicitly and cannot be inferred, resolved automatically or
inherited from ignored workstation state.

## Consequences

- FOUNDATION-018 may be retried from the isolated baseline.
- Local Supabase start, reset and SQL testing remain supported.
- The repository gains a reusable local guard without CI or dependency changes.
- No remote target, URL, identifier, token or secret is committed.
- A future authorized remote package must deliberately establish and later
  isolate its own context.

## Rejected alternatives

- Running official unlink was rejected because local help did not prove it was
  network-free.
- Deleting all of `supabase/.temp/` was rejected because it would remove
  unrelated local runtime/cache state.
- Replacing the target with a fake value was rejected because the CLI could
  interpret it as an active target.
- Relying only on `.gitignore` was rejected because ignored state still affects
  command behavior.

## Security and rollback

There was no remote read/write, project lookup, deployment, migration or secret
operation. Revert may remove code/docs, but must not restore isolated link
metadata. Relinking requires a separate approved decision and evidence.

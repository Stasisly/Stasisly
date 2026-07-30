# FOUNDATION-019B-A - Founder authorization artifact storage

## Status

```text
Implementation: IMPLEMENTED_LOCALLY
Remote execution: FORBIDDEN
Publication: PENDING_PACKAGE_COMMIT
```

## Problem

FOUNDATION-019A v4 containment stopped correctly because `.runtime/` was not
ignored. R2H also required a Founder reference, commit and grant state as
manually exported environment variables.

## Decision and runtime path

`.runtime/` is the single local root for ephemeral authorization state:

```text
.runtime/authorizations/
.runtime/proposals/
.runtime/audit/
.runtime/locks/
```

The exact `.gitignore` rule is `.runtime/`. No broader repository path is
ignored. Runtime files cannot be tracked and do not appear in diffs or status.

## Permissions

On POSIX systems the storage root and subdirectories are `0700`; artifacts,
audit records and lock files are `0600`. Unsupported enforcement returns
`FILESYSTEM_PERMISSION_ENFORCEMENT_UNAVAILABLE` rather than claiming success.

## Artifact contract

`FounderAuthorizationArtifactV1` binds:

- authorization and approved decision;
- operation and environment;
- full Git commit;
- manifest and runner;
- scope and one-execution limit;
- lifecycle status and timestamps;
- two-hour expiry by default;
- first-remote-action consumption;
- deterministic SHA-256 integrity.

SHA-256 is mutation evidence, not a Founder signature.

## Conversational approval

The Founder approves a structured operation conversationally. Codex derives the
technical values from the approved prompt, current `HEAD`, versioned contracts
and Development policy. The runner consumes only a validated artifact, not free
text.

## Lifecycle and consumption

Only these transitions are valid:

```text
GRANTED -> CONSUMED
GRANTED -> REVOKED
GRANTED -> EXPIRED
```

Consumption creates an exclusive `0600` lock, validates under that lock, writes
and flushes a temporary artifact, atomically renames it, then releases the
lock. An orphan lock fails closed. A consumed authorization is never regenerated
or restored to `GRANTED`.

## Integrity and expiration

Canonical JSON recursively sorts object keys before hashing. Mutation of
bindings, scope, status, execution count or expiry invalidates the hash.
Expired artifacts return `AUTHORIZATION_EXPIRED` and require new conversational
approval.

## Legacy environment compatibility

Authorization variables in `.env` are deprecated:

```text
FOUNDER_AUTHORIZATION_REFERENCE
AUTHORIZED_COMMIT_SHA
AUTHORIZED_COMMIT_MATCHES_HEAD
CONTAINMENT_AUTHORIZATION_STATUS
SECOND_FUNCTIONAL_ATTEMPT_AUTHORIZATION_STATUS
```

A valid artifact is primary. Matching legacy values are tolerated as deprecated
compatibility; conflicts block. Stable Development configuration remains
environment-owned.

## Sanitized audit

Local JSONL audit records include authorization ID, operation category, matched
bindings, transition and timestamp. They exclude credentials, aliases,
synthetic identities, resource handles and remote payloads.

## R2H integration

R2H accepts `FOUNDER_AUTHORIZATION_ARTIFACT`, validates its canonical location,
permissions, hash, expiry and bindings, checks legacy conflicts, and consumes it
immediately before the first remote counter read. Completion records only the
closed classification and final CLI-context category.

R2H diagnostic, lookup, counter, ownership and deletion logic was not changed.
The runner was not executed by this package.

## Tests

Local tests cover:

- ignore behavior and tracked-path detection;
- POSIX permissions;
- valid, malformed, unknown-field and mutated artifacts;
- commit, environment, manifest and runner mismatch;
- expiry, revocation and execution limits;
- single, double and parallel consumption;
- atomic-write failure and orphan lock handling;
- consumed-artifact regeneration rejection;
- artifact-only and legacy compatibility modes;
- sanitized audit;
- R2H primary artifact integration.

Full package evidence:

```text
Focal authorization/R2H tests: 47 PASS
Flutter: 907 PASS / 5 approved skips / 0 failures
Analyzer: 0 errors / 0 warnings / 36 inherited infos
Deno: 86/86 PASS
Deno format: 62 files
Local SQL: 740/740 PASS after no-seed reset
Remote context: SAFE
```

## Security and readiness

```text
remote actions: 0
authorization artifacts committed: 0
runtime files visible to Git: 0
secret reads: 0
.env modifications: 0
resource creations: 0
catalog mutations: 0
specialist mutations: 0
schema changes: 0
backend changes: 0
```

Readiness becomes
`FOUNDATION-019B AUTHORIZATION_ARTIFACT_STORAGE_READY_LOCAL_AND_PUSHED` only
after full local regression, explicit commit and successful push.

## Next authorization

`FA-019A-V4-CONTAIN-20260730-009` is not consumed but is superseded by this
package's new commit and cannot be reused. A new conversational authorization
must bind to the full resulting SHA. No `.env` authorization editing is needed.

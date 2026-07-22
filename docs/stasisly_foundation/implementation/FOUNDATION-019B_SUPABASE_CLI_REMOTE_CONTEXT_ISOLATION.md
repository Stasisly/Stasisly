# FOUNDATION-019B Supabase CLI Remote Context Isolation

## Status and baseline

```text
Package: FOUNDATION-019B
Baseline: 5d797c6
Supabase CLI remote context: ISOLATED
Accidental remote targeting: BLOCKED_LOCALLY
FOUNDATION-018: READY_TO_RETRY
Remote execution: NOT_AUTHORIZED
```

FOUNDATION-018 stopped before changes because ignored local CLI metadata proved
that the repository retained an implicit remote target. No remote read, write,
lookup, migration, deployment, secret operation or project creation occurred.
The remote project identifier was neither printed nor recorded.

## Zero-network policy

This package used filesystem inspection, local CLI help, local Supabase runtime
commands and local test runners only. Commands capable of resolving or acting
on a remote project remained prohibited. CLI help did not establish that the
official unlink command was purely local, so it was not executed.

## Metadata inventory and classification

| Local artifact | Classification | Decision |
|---|---|---|
| `supabase/.temp/project-ref` | `REMOTE_LINK_METADATA` | Removed without reading or recording its value |
| `supabase/.temp/pooler-url` | `REMOTE_LINK_METADATA` | Removed without recording its value |
| `supabase/.temp/*-version` | `CACHE_ONLY` | Preserved for local runtime |
| `supabase/.temp/cli-latest` | `CACHE_ONLY` | Preserved |
| `supabase/.temp/storage-migration` | `LOCAL_RUNTIME_METADATA` | Preserved |
| `.supabase/` | Absent | No action |

The active local context now contains no project reference or pooler target.
The remaining files cannot resolve the previous remote project identity.

## Risk assessment

| Risk | Likelihood before | Impact | Control | Residual risk |
|---|---|---|---|---|
| Accidental database push/pull | Medium | Critical | Link metadata removed; preflight blocks recurrence | Low, requires deliberate relink |
| Function or secret operation against implicit target | Medium | Critical | No active target; executable-tooling scan | Low |
| Incorrect drift comparison | Medium | High | No linked default; future remote package must name target | Low |
| Operator confusion | High | High | Safe preflight message and explicit local flags | Low |
| Automation inheriting CLI state | Medium | High | Guard detects known link markers and dangerous scripts | Low |
| Ambiguous local database command | Medium | High | Guard requires explicit `--local` | Low |

## Isolation strategy

Option B, controlled manual isolation, was selected. Only the two known remote
link markers were deleted. The rest of `supabase/.temp/` was retained. This is
reversible only by a separately authorized link package with an explicit target;
no placeholder or fake target is installed.

## Local preservation

After isolation, local status remained healthy. The package then validates one
local reset without seed, all local SQL tests, Deno formatting/tests and the
Flutter suite. Every database operation capable of ambiguity carries an
explicit local target.

```text
Remote-context guard fixtures: 11/11 pass
Flutter: 631 pass / 5 approved skips / 0 failures
Analyzer: 0 errors / 36 inherited infos
Deno: 62 formatted / 86 of 86 pass
SQL local: one no-seed reset / 740 of 740 pass
```

## Read-only preflight guard

`tool/check_supabase_remote_context.dart` is a Dart/standard-library scanner. It:

- performs no subprocess, network or Supabase invocation;
- never deletes or mutates inspected files;
- never reads `.env` or prints detected values;
- detects known link markers in `supabase/.temp/` and `.supabase/`;
- detects remote-capable commands in executable `scripts/` and `tool/` files;
- requires explicit local targeting for local reset and SQL tests;
- rejects remote Supabase URLs in versionable example files;
- rejects concrete project-reference assignments in Foundation documentation;
- ignores prose that documents prohibited commands and its own implementation.

Safe execution:

```text
dart run tool/check_supabase_remote_context.dart
```

Any finding returns non-zero with category and relative path only. The finding's
value, host, URL, organization and account are never emitted.

## Test and architecture guards

Temporary synthetic fixtures cover: clean state, both link markers, value
redaction, non-destructive behavior, dangerous script and CI commands,
documentation allowlisting, explicit local reset, ambiguous reset, remote URL
examples and concrete versus placeholder project references. No real project
identifier or URL is used.

The guard protects these local-only invariants:

1. active link markers are absent;
2. project identifiers are not copied into versioned evidence;
3. local tooling contains no link, push, pull, deploy, secrets, repair or branch
   operation;
4. local database validation selects local explicitly;
5. versionable examples contain no remote target;
6. scanning is read-only and no-network;
7. `.github/` remains read-only and cannot silently inherit this local state.

## Gitignore

`supabase/.temp/` and `supabase/.branches/` remain ignored. Ignore rules protect
local metadata from publication, but do not establish safe targeting; the
preflight is the required behavioral gate.

## Security evidence

```text
REMOTE_NETWORK_CALLS: 0
REMOTE_COMMANDS_EXECUTED: 0
REMOTE_IDENTIFIERS_RECORDED: 0
REAL_SECRETS_ADDED: 0
REMOTE_PROJECT_REFERENCE_PRESENT: NO
REMOTE_POOLER_TARGET_PRESENT: NO
LOCAL_SUPABASE: FUNCTIONAL
```

## Rollback

Code/document rollback is a revert of the FOUNDATION-019B commit. The removed
ignored metadata must not be restored as rollback because doing so recreates the
security condition. A future remote link is a new, founder-approved operation
with named target and evidence, not rollback of this package.

## Foundation adoption and residual debt

```text
Supabase CLI remote context: ISOLATED
Remote project metadata: ABSENT_FROM_ACTIVE_LOCAL_CONTEXT
Remote identifier evidence: NOT_RECORDED
Remote-context preflight: FOUNDATION_ADOPTED_LOCALLY
Accidental remote targeting: BLOCKED_LOCALLY
FOUNDATION-018: READY_TO_RETRY
Development remote execution: NOT_AUTHORIZED
Staging: NOT_AUTHORIZED
Production: NOT_AUTHORIZED
```

Residual debt is limited to integrating this guard into future approved CI/local
package conventions and repeating FOUNDATION-018 from the new baseline. CI
modification and any remote action remain separately gated.

## Readiness

```text
SUPABASE CLI_REMOTE_CONTEXT_ISOLATED_LOCAL_AND_PUSHED
```

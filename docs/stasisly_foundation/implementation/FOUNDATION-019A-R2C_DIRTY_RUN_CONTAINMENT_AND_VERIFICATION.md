# FOUNDATION-019A-R2C: Dirty-run containment and verification

## 1. Scope

Local/versioned containment preparation only. No remote command was authorized
or executed by this package.

## 2. Baseline

- Baseline commit: `d94292a`.
- Dirty attempt: `diag-20260723-002`.
- Fixture contract: `FOUNDATION-019A-R1-v1`.
- Environment: Development only.

## 3. Safe evidence reconstructed

The focal Auth create returned HTTP `200`, a valid JSON object and a passing
assertion. The runner then ended as `FAILED_DIRTY_BLOCKING`. No response body,
token, user identifier, project reference or secret is recorded here.

## 4. Exact namespace

`foundation-019a-r1-diag-20260723-002`.

## 5. Reachability inventory

Only `syntheticUserCreate` was reached. The synthetic Auth user is
`POSSIBLY_CREATED`. Specialists, catalog entries, public profile, sessions,
idempotency rows and messages are `NOT_CREATED`.

| Resource | Step reached | Possible state | Exact source | Cleanup | Verification |
|---|---|---|---|---|---|
| Synthetic Auth user | Yes | `POSSIBLY_CREATED` | Ephemeral response ID, unavailable | Exact Admin delete by ID | Exact lookup/count |
| Specialist | No | `NOT_CREATED` | Generated local ID only | Exact ID delete | Named counter |
| Catalog entry | No | `NOT_CREATED` | Generated local ID only | Exact ID delete | Named counter |
| Public profile | No | `NOT_CREATED` | Auth owner ID | Exact ID delete | Named counter |
| Conversation | No | `NOT_CREATED` | Run operation ID | Exact ID delete | Named counter |
| Message | No | `NOT_CREATED` | Conversation ID | Exact ID delete | Named counter |
| Idempotency | No | `NOT_CREATED` | Run operation ID | Exact key delete | Named counter |

## 6. Cleanup audit

Finalization deliberately called exact cleanup twice. Auth deletion accepted
only `200`, so a second `404` for an already absent user was misclassified as a
dirty cleanup failure.

## 7. Root cause

The observed dirty result is consistent with a cleanup-idempotency tooling
defect. It is not evidence that a remote residue exists, and it is not evidence
that the remote is clean.

## 8. Local correction

The exact Auth delete now accepts only `200` and `404`. No endpoint, payload,
fixture assertion or downstream operation changed.

## 9. Diagnostic stream isolation

The Dart helper writes the safe block to an explicit file. Build stdout/stderr
are isolated and deleted. The runner publishes only a block whose first and
last lines are the approved markers.

## 10. Named residue counters

The fixed order is messages, conversation idempotency, chat sessions, public
user profiles, specialist catalog entries, specialists and synthetic Auth
users.

## 11. Identity limitation

The raw Auth user ID was not retained in safe evidence. The synthetic namespace
is exact, but the approved Admin deletion endpoint requires the exact ID.

## 12. Lookup boundary

Broad Auth-user listing, pagination searches, wildcard cleanup and identifier
inference are prohibited. No new backend lookup mechanism is introduced.

## 13. Machine-readable contract

`development_dirty_run_containment.json` fixes attempt identity, possible
resources, counter order, idempotent statuses and the current blocker. Its JSON
Schema rejects additional properties.

The safe evidence template and schema record only aliases, status categories
and named counters. They contain no raw project, user or resource identifier.

## 14. Local preflight

`tool/development_dirty_run_containment.dart --preflight` verifies the immutable
attempt identity and reports the missing exact Auth user ID without network
access.

## 15. Tests

Unit tests cover immutable identity, seven counters, invalid input, safe summary
and `200/404` semantics. Architecture guards prohibit remote primitives and
broad lookup. Shell simulation covers repeated exact cleanup.

Full local validation:

```text
Flutter analyze: 0 errors, 36 inherited infos
Flutter tests: 713 pass, 5 approved skips, 0 failures
Deno format: 62 files
Deno tests: 86 pass, 0 failures
SQL after local no-seed reset: 740 pass, 0 failures
Remote-context preflight: SAFE
```

## 16. Remote state

`UNKNOWN`. This package does not inspect remote state.

## 17. Remote authorization

`NOT_GRANTED`. The prior Founder authorization was consumed by the diagnostic
attempt and cannot authorize containment.

A future authorization must bind a new commit, a unique Founder reference, the
exact Development target and operator, this attempt alias and namespace, the
single allowed resource category, exact inspection/deletion operations, seven
named counters and mandatory CLI isolation.

## 18. New fixtures

`BLOCKED`. No new fixture may be created while the dirty run is unresolved.

## 19. Cleanup execution

`NOT_EXECUTED_REMOTE`.

Future inspection is limited to an exact Auth resource belonging to this run.
Future cleanup is limited to exact deletion by verified ID in dependency-safe
order. Neither action is currently executable or authorized.

## 20. CLI context

The linked project metadata remains isolated. R2C does not link the CLI.

## 21. Security

No `.env`, secret, token, password, raw response, endpoint, user identifier or
project reference is added to version control.

## 22. Out of scope

No migration, deployment, secret update, Flutter Product change, staging,
production, real data, AI, Stasis Engine, analytics or external integration.

## 23. Rollback

Revert the package commit. Remote state is unaffected because Phase A performs
no remote action.

Database recovery point: `NOT_REQUIRED_NO_SCHEMA_CHANGE`. Operational rollback
requires a pre-cleanup inventory and stop-on-mismatch because an accidental
deletion cannot be restored.

## 24. Readiness

`FOUNDATION-019A-R2C BLOCKED_REMOTE_CLEANUP_CONTRACT`.

## 25. Next gate

A separate Founder authorization may be considered only after an exact,
minimal, auditable Auth-resource resolution and deletion contract exists. It
must bind the future commit, exact Development target, operator, attempt
namespace and containment-only actions.

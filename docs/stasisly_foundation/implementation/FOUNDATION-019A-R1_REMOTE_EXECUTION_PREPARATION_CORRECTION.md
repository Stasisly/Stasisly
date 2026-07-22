# FOUNDATION-019A-R1 — Remote execution preparation correction

## Status and baseline

- Baseline: `70528c1 feat: resolve Development execution blockers`.
- Discovery baseline: `7f747e0`.
- Previous attempt: stopped before every remote action.
- Scope: local, versioned preparation only.
- Remote actions and network calls: `0`.

## Blocker register

| ID | Description / impact | Resolution / acceptance | Status / residual risk |
|---|---|---|---|
| DEV-REMOTE-B001 | Local fixture was `localOnly=true`; remote reuse would erase the trust boundary | Separate remote manifest; local flag remains true | `RESOLVED_LOCALLY`; runtime approval absent |
| DEV-REMOTE-B002 | Write test could persist Conversation and Message data | Exact run alias; success/failure cleanup; seven zero counts; dirty-run block | `RESOLVED_LOCALLY`; remote behavior not executed |
| DEV-REMOTE-B003 | Remote skips had prose-only activation | Eleven-condition commit/Founder/project/operator/CORS/cleanup gate; tests remain disabled | `RESOLVED_LOCALLY`; new authorization required |
| DEV-REMOTE-B004 | Exact Development web origin unknown; guessing expands trust | Exact HTTPS validator and `UNASSIGNED` manifest state | `EXPLICIT_REAUTHORIZATION_INPUT_REQUIRED` |

## Fixture, namespace and setup

The local manifest remains strictly local. The distinct remote manifest is
Development-only, synthetic, serial and runtime-targeted. Its namespace
`foundation-019a-r1-{runAlias}` correlates the synthetic user, specialist,
catalog, Conversation and cleanup without real identity, project or secret.

Future setup verifies environment, exact target, commit, operator, Founder
authorization, both manifests, cleanup preflight and exact CORS before creating
bounded synthetic records. Any mismatch or namespace collision fails closed.

## Cleanup and failure handling

The versioned operator runner is
`scripts/run_development_remote_fixture_test.sh`. It deletes exact identifiers
in dependency order: Messages, idempotency, Conversations, profile, catalog,
specialist and auth user. A trap-equivalent `finally` runs after success,
failure and partial setup, repeats cleanup to prove idempotence and requires
`0|0|0|0|0|0|0`. Allowed outcomes are `PASSED_CLEAN`, `FAILED_CLEAN` and
`FAILED_DIRTY_BLOCKING`; a dirty run blocks every later run. Service-role use is
operator-side only and no value enters Flutter or evidence.

## Inherited tests and activation gate

The inherited write test now consumes a unique run alias and runtime synthetic
specialist instead of retained data. Write, read and UX tests require the common
gate. All five classified remote skips remain `CLASSIFIED_NOT_ENABLED`.

`RUN_REMOTE_TESTS=true` and `environment=development` are insufficient. The
gate also requires active remote-context authorization, exact project/operator,
Founder reference, commit match, runtime manifest approvals, cleanup preflight,
exact CORS, complete configuration and acknowledged secret names.

## CORS, evidence and preflight

`DEVELOPMENT_ALLOWED_WEB_ORIGIN` accepts one exact HTTPS origin. Empty,
placeholder, wildcard, multiple values, path, query, fragment, credentials,
localhost and staging/production-looking hosts fail without DNS or network.

```text
CORS_ORIGIN: UNASSIGNED
REMOTE_EXECUTION: BLOCKED
```

Evidence now records fixture setup, redacted namespace, cleanup status, seven
counts, gate/CORS status and dirty-run blocker status. It excludes remote hosts,
raw IDs, emails, content, tokens and secrets. `PASSED_CLEAN` requires cleanup
`PASSED`. The no-network preflight validates all contracts while preserving the
closed missing-CORS status.

## Local simulation and repeatability

Two canonical HTTP success cycles and two controlled failures after partial
setup ran locally. Every failure performed cleanup twice and every final count
was `0|0|0|0|0|0|0`:

```text
REMOTE_LIFECYCLE_CONTRACT_SIMULATED_LOCALLY
```

This is local contract evidence, not remote validation. Full validation passed:

- Flutter: 678 pass, 5 approved skips, 0 failures.
- Analyzer: 0 errors; 36 inherited infos.
- Deno: format 62 files and 86/86 tests.
- SQL: local no-seed reset and 740/740 pgTAP tests.
- Remote-context/readiness preflights: `SAFE`.
- Remote preparation status: `BLOCKED_MISSING_CORS_ORIGIN`.

## Retention, security and rollback

`conversation_idempotency` retention remains
`POST_DEVELOPMENT_OPERATIONAL_BLOCKER`. A bounded first validation may be
authorized separately; sustained operation remains forbidden until a focal
retention package is approved and implemented.

No remote read/write, CLI link, migration, deploy, secret operation, real data,
staging, production, AI or Stasis Engine action occurred. Rollback is the single
R1 commit and requires no remote repair.

## Readiness and reauthorization

Preparation is local and fail-closed. Remote execution remains blocked by exact
CORS and a new Founder authorization. The authorization for `70528c1` is
superseded by the new commit. A future order must include that SHA, exact
Development project, non-secret operator identity, exact CORS, allowed actions,
fixture/cleanup contracts, config and secret-name inventories, rollback and the
retention limitation.

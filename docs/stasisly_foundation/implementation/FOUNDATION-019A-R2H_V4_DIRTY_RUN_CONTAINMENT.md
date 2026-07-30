# FOUNDATION-019A-R2H - V4 dirty-run containment

## 1. Baseline

R2H starts from synchronized `main` at
`7a660c143949ca7fc6cbd423a7c8d30102a5d7f9`, with a clean worktree,
Discovery baseline `7f747e0cf60012ce315216a5486db3c5481f8f60`, Supabase CLI remote
context `SAFE`, and both link markers absent.

## 2. Failed v4 run

The single v4 functional attempt ended as
`DEVELOPMENT SECOND_FUNCTIONAL_ATTEMPT_V4_FAILED_DIRTY_BLOCKING`. It used
manifest `FOUNDATION-019A-SECOND-FUNCTIONAL-ATTEMPT-v4` and runner
`FOUNDATION-019A-R2G-RUNNER-v1`.

## 3. Consumed authorization

`FA-019A-RETRY-20260729-008` is `CONSUMED`, bound to the v4 commit and not
reusable. R2H grants no replacement authorization.

## 4. Point reached

Sanitized evidence confirms valid Product `{items}` catalog adaptation,
exactly one available canonical specialist, synthetic Auth creation and
`CONVERSATION_CREATED`. It does not confirm replay validation.

## 5. Failure category

The remote category remains `UNKNOWN_POST_CREATE_FAILURE`: available evidence
does not prove whether replay transport, replay response, count validation,
state transition or ledger handling failed.

Static local inspection found two incompatible count queries in the historical
runner: the replay count uses legacy `operation/createOwnChatSession` semantics
instead of `operation_id/create_conversation`, and residue counting selects a
nonexistent generic identifier from `conversation_idempotency`. These are local
contract findings, not proof of the exact remote failure.

## 6. Run identity reconstruction

The run alias is available only ephemerally and must match the bounded alias
pattern. From it, R2H reconstructs the exact operation attempt, idempotency key
and synthetic profile marker in memory. Authorization reference, failed
manifest and failed runner versions are exact versioned inputs. Sensitive
handles are opaque and redacted by `toString`.

## 7. Conversation ownership

Conversation ownership requires one exact idempotency ledger row or one exact
synthetic profile owner, with owner cross-check when both exist. The
Conversation handle must equal the idempotency result reference or the sole
owner-scoped session. Ambiguity, foreign ownership, conflicting owners or loss
of every exact identity source blocks containment.

## 8. Idempotency diagnosis

The exact lookup uses `operation_id=create_conversation` plus the reconstructed
idempotency key and a two-row bound. Zero, one exact row, ambiguity, transport
failure and malformed response remain distinct. Deletion additionally binds
subject, operation and key. General `conversation_idempotency` retention remains
`POST_DEVELOPMENT_OPERATIONAL_BLOCKER`.

## 9. Seven counters

The mandatory order is:

```text
messages|idempotency|sessions|profiles|catalog|specialists|auth
```

Each counter declares lookup basis, bound, expected zero, ownership and
containment eligibility in the manifest. Null, parse failure, empty transport
output, unbounded listing and partial evidence never become zero. The clean
vector is exactly `0|0|0|0|0|0|0`.

## 10. Exact containment

Deletion requires `CREATED_BY_RUN`, exact ownership proof, exact handle,
run-scoped lookup and non-canonical ownership. The gateway permits only bounded
`GET` and exact `DELETE`; all other HTTP methods fail closed. Delete status
`200`, `204` or idempotent `404` still requires post-delete zero verification.

## 11. Canonical protection

Catalog and specialist counters represent run-created fixtures only and remain
zero/read-only for the v4 run. Canonical catalog and specialist resources never
receive handles and cannot enter the delete plan.

## 12. Post-delete verification

After success or failure of any exact delete, R2H re-runs all seven counters,
verifies Auth absence and isolates Supabase CLI state. A remaining, unknown,
failed or unexecuted counter produces a blocking classification.

## 13. Classification

```text
seven initial zeros                    -> DIAGNOSED_ALREADY_CLEAN
exact removal plus seven final zeros   -> CONTAINED_CLEAN
unknown/failure/nonzero final residue  -> FAILED_DIRTY_BLOCKING
required broad or unavailable handle   -> BLOCKED_INSUFFICIENT_EXACT_LOOKUP
```

No remote classification is asserted by this local package.

## 14. Manifest

`FOUNDATION-019A-V4-DIRTY-RUN-CONTAINMENT-v2` binds the consumed attempt,
identity strategy, counter contracts, dependency order, disabled creation and
replay paths, canonical protection, mandatory post-delete verification and CLI
isolation. It also declares `founder-authorization-v2` as the required artifact
schema and records the exact failed-run result. Remote authorization and
execution remain closed.

## 15. Runner

`FOUNDATION-019A-R2H-CONTAINMENT-RUNNER-v2` is a separate entry point. Its local
validation mode has no network action. Its future runtime mode cannot run until
all exact gates pass under a new commit-bound V2 Founder authorization.

## 16. Gate

The future gate verifies Founder containment authorization, current commit,
Development target, all seven `subject_run` bindings against the manifest,
containment versions, all creation/replay/mutation disables, exact-only lookups,
seven counters, Conversation awareness, canonical protection, post-delete
verification, CLI isolation and retention acknowledgement.

## 17. Tests

Forty-one focal tests cover identity, wrong authorization/commit, alias
derivation, counter states, Conversation absence/exact/ambiguous/foreign cases,
messages and idempotency residues, delete success/failure, remaining residue,
canonical protection, Auth post-lookup, CLI isolation and safe evidence.

Full validation:

```text
Flutter: 879 pass / 5 approved skips / 0 failures
Analyzer: 0 errors / 0 warnings / 36 inherited infos
Deno: 86/86 pass; format 62 files
SQL local: 740/740 pass after no-seed reset
Remote context: SAFE
```

## 18. Simulations

Eleven local simulations pass: all-zero, Conversation residue, idempotency
residue, both residues, profile residue, Auth absent, unknown Conversation,
ambiguous profile, canonical delete attempt, post-delete nonzero and CLI
isolation failure.

## 19. Security

```text
remote actions / functional executions / new resources: 0 / 0 / 0
Auth / Conversation / message creations: 0 / 0 / 0
catalog / specialist mutations: 0 / 0
broad lookups / broad deletes: 0 / 0
secret reads / .env modifications: 0 / 0
schema / backend changes: 0 / 0
```

## 20. Readiness

The local package is implemented and validated. Publication is the remaining
G11 gate. Functional retries, new fixtures and FOUNDATION-020 remain blocked.

## 21. Future authorization requirements

No future reference is assigned. Prior references `-009` and `-010` are
superseded and non-reusable. A separate conversational V2 authorization must
bind the published R2H SHA, manifest v2 and runner v2 and may permit only exact
failed-run lookups, seven counters, Conversation/idempotency containment, Auth
absence verification, CLI isolation and final local regression. It may not
permit functional retry, creation, replay, canonical mutation, migration,
deploy, AI or sustained Development operation.

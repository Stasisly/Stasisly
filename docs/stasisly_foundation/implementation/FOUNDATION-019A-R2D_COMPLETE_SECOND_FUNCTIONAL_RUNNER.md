# FOUNDATION-019A-R2D - Complete second functional runner

## Status and baseline

```text
Package: FOUNDATION-019A-R2D
Baseline: db43e4f91d6a202091c0de92212cd2396b96f4fa
Discovery baseline: 7f747e0cf60012ce315216a5486db3c5481f8f60
Branch: main
Remote context before implementation: SAFE
Remote actions/reads/writes: 0/0/0
```

The second functional attempt stopped before remote access as
`FOUNDATION-019A-RETRY BLOCKED_RUNNER_CONTRACT`. The v1 manifest described
stages that the executable runner skipped. R2D replaces it with one
machine-readable v2 manifest and a complete executable runner.

`FA-019A-RETRY-20260728-004` remains `NOT_CONSUMED`,
`BOUND_TO_db43e4f` and becomes `INVALID_AFTER_NEW_COMMIT`. It is not an active
authorization and cannot be reused.

## Versions and authority

```text
Manifest: FOUNDATION-019A-SECOND-FUNCTIONAL-ATTEMPT-v2
Runner: FOUNDATION-019A-R2D-RUNNER-v1
Authorization: NOT_GRANTED
Authorized commit: UNASSIGNED
Execution: NOT_EXECUTED
Remote skips: CLASSIFIED_NOT_ENABLED
Sustained Development: NOT_AUTHORIZED
```

The local shell is inert unless a future exact gate supplies a new Founder
reference, the resulting R2D commit, exact Development target/operator/CORS,
both versions and every cleanup condition.

## Executable operation matrix

The normative full matrix is
`development/development_second_functional_attempt_manifest.json`. Every row
contains request, success/failure evidence, adjacent transition, ledger effect,
cleanup effect and `implemented/tested=true`.

| Operation | Runner function | Transition |
|---|---|---|
| preflight | `validatePreflight` | INITIAL -> PREFLIGHT_VALIDATED |
| target verification | `verifyTarget` | PREFLIGHT_VALIDATED -> TARGET_VERIFIED |
| synthetic setup | `startSetup` | TARGET_VERIFIED -> SETUP_STARTED |
| Auth setup | `createOwnerPrincipal` | SETUP_STARTED -> AUTH_USER_CREATED |
| specialist resolution | `resolveSpecialist` | AUTH_USER_CREATED -> SPECIALIST_RESOLVED |
| Conversation create | `createConversation` | SPECIALIST_RESOLVED -> CONVERSATION_CREATED |
| idempotency replay | `validateReplayStage` | CONVERSATION_CREATED -> IDEMPOTENCY_REPLAY_VALIDATED |
| active list | `validateActiveList` | IDEMPOTENCY_REPLAY_VALIDATED -> ACTIVE_LIST_VALIDATED |
| detail read | `validateDetail` | ACTIVE_LIST_VALIDATED -> DETAIL_READ_VALIDATED |
| message send | `sendUserMessage` | DETAIL_READ_VALIDATED -> MESSAGE_SENT |
| no-AI | `validateNoAi` | MESSAGE_SENT -> NO_AI_VALIDATED |
| archive | `archiveConversation` | NO_AI_VALIDATED -> ARCHIVED |
| archived state | `validateArchivedState` | ARCHIVED -> ARCHIVED_STATE_VALIDATED |
| restore | `restoreConversation` | ARCHIVED_STATE_VALIDATED -> RESTORED |
| restored state | `validateRestoredState` | RESTORED -> RESTORED_STATE_VALIDATED |
| foreign opacity | `validateForeignOpacity` | RESTORED_STATE_VALIDATED -> OWNERSHIP_OPACITY_VALIDATED |
| blocked routes | `validateBlockedRoutes` | OWNERSHIP_OPACITY_VALIDATED -> BLOCKED_ROUTES_VALIDATED |
| flow completion | `completeFlow` | BLOCKED_ROUTES_VALIDATED -> FLOW_COMPLETED |
| cleanup | `startCleanup` | FLOW_COMPLETED -> CLEANUP_STARTED |
| cleanup completion | `cleanupLedger` | CLEANUP_STARTED -> CLEANUP_COMPLETED |
| Auth absence | `validateAuthAbsence` | CLEANUP_COMPLETED -> AUTH_ABSENCE_VALIDATED |
| seven counters | `validateResidueCounters` | AUTH_ABSENCE_VALIDATED -> RESIDUE_VERIFIED |
| CLI isolation | `isolateCli` | RESIDUE_VERIFIED -> CLI_ISOLATED |
| local regression | `runLocalRegression` | CLI_ISOLATED -> LOCAL_REGRESSION_COMPLETED |

## State machine and stop behavior

The state machine accepts only the adjacent path above and matching evidence.
Any skip, reverse, repeat or terminal mutation yields
`RUNNER_STATE_TRANSITION_BLOCKED`. In particular, neither
`SPECIALIST_RESOLVED -> FLOW_COMPLETED` nor
`CONVERSATION_CREATED -> MESSAGE_SENT` is possible.

At the first functional failure, later functional stages stop. The machine
enters cleanup from the preserved state, verifies exact residue, isolates CLI
metadata and classifies the run as `FAILED_CLEAN` or
`FAILED_DIRTY_BLOCKING`. Unknown evidence is dirty blocking.

## Resource ledger and cleanup

The in-memory ledger distinguishes `CREATED_BY_RUN`,
`VERIFIED_PREEXISTING_READ_ONLY`, `NOT_CREATED` and `UNKNOWN_BLOCKING`. Each
created entry has category, creation state, ownership proof, exact handle and
cleanup/verification state. It is deleted after clean verification and never
persists raw IDs, credentials, tokens, content or synthetic addresses.

The approved fixture manifest permits one exact run-owned synthetic specialist
and catalog entry. The runner creates them under a random exact namespace,
resolves the resulting backend-derived selectable specialist through the
canonical catalog endpoint and deletes only those run-owned entries. The ledger
also supports a preexisting read-only specialist without cleanup.

Cleanup order is messages, idempotency, Conversation/session state, profile,
catalog, specialist, foreign Auth and owner Auth. Auth delete accepts only
`200` or already-absent `404`. Exact post-cleanup Auth reads must be `404`.
The ordered counters must be known and equal:

```text
messages|idempotency|sessions|profiles|catalog|specialists|auth
0|0|0|0|0|0|0
```

## Functional verification

- Conversation create uses one stable operation attempt, idempotency key,
  normalized specialist input and synthetic owner. One bounded retry recovers a
  transport response loss using the same request.
- Replay requires the same canonical Conversation result and exactly one
  operation-attributable Conversation.
- Active lists are owner-scoped, status-filtered and cursor-paginated with a
  bounded page count and cursor-loop rejection.
- Detail requires the canonical Conversation, selected specialist, active state
  and an empty canonical Message collection before send.
- Message send records one canonical user message without exposing content.
- No-AI requires exactly one `user/userProvided/productVisible` message and
  zero Model Gateway and Stasis Engine invocation evidence under the approved
  no-AI architecture.
- Archive requires observed archived detail, active-list exclusion and blocked
  send capability.
- Restore requires observed active detail, active-list inclusion and restored
  send capability by the active lifecycle contract; it sends no second message.
- A second synthetic principal receives only the approved opaque
  `conversationNotFound` shape with no resource metadata.
- `/chat` passes only on effective `404/410` without redirect.
- `/orchestrator` passes on `401/403/404/410` or an unfollowed redirect only to
  `/` or `/login`.

## Tests, simulations and security

Guards compare every manifest function with runner source and reject missing
states, mappings, tests, evidence, ledger or cleanup effects. Contract tests
cover full/invalid transitions, replay and recovery, paginated list/detail,
no-AI, archive/restore, ownership opacity, routes, ledger behavior and clean or
dirty classification.

The local simulation runs the full clean flow twice, every approved functional
failure point and dirty evidence/counter/CLI cases. Fake canaries are checked
against all retained output channels. Final local evidence is:

```text
Focal contracts/architecture: 46 pass / 0 fail
Flutter: 783 pass / 5 approved skips / 0 fail
Analyzer: 0 errors / 0 warnings / 36 inherited infos
Deno: 86/86 pass; format pass
SQL: 740/740 pass after local no-seed reset
Remote context: SAFE
```

Security result:

```text
remote actions/reads/writes: 0/0/0
remote fixtures: 0
raw content or secret values logged: 0
real IDs or synthetic emails committed: 0
broad lookup/delete: 0/0
backend/schema changes: 0/0
remote skips enabled: 0
```

## Adoption, readiness and rollback

```text
Manifest-runner equivalence: FOUNDATION_ADOPTED
Complete state machine: FOUNDATION_ADOPTED_LOCALLY
Resource ledger: COMPLETE_AND_VALIDATED_LOCALLY
Replay/list/detail/no-AI/archive/restore/opacity/routes: IMPLEMENTED_LOCALLY
Remote attempt: NOT_AUTHORIZED
```

Rollback is the exact revert of the R2D commit. No remote rollback exists
because R2D performs no remote action.

After commit and push, the maximum readiness is:

```text
FOUNDATION-019A COMPLETE_RUNNER_READY_FOR_SECOND_FUNCTIONAL_AUTHORIZATION_LOCAL_AND_PUSHED
```

A future Founder order must bind a new unique reference (recommended identifier
only: `FA-019A-RETRY-20260728-005`) to the new R2D SHA, exact Development
project/operator/CORS, v2 manifest, R2D runner, complete sequence, foreign
principal, exact cleanup, seven counters, CLI isolation, no schema change and
the retention limitation. R2D does not grant that authorization.

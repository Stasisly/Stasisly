# FOUNDATION-019A-R2J - Legacy Conversation recovery strategy

## Status

```text
Package: FOUNDATION-019A-R2J
Decision: APPROVED
Implementation: IMPLEMENTED_LOCALLY
Remote execution: FORBIDDEN
Recovery status: BLOCKED_NO_EXACT_HISTORICAL_KEY
```

R2J defines and enforces the only acceptable proof contracts. It does not
recover, query, delete or classify the historical dirty run as clean.

## Historical state

The failed v4 run remains bound to:

```text
failed authorization: FA-019A-RETRY-20260729-008
failed commit: 7a660c143949ca7fc6cbd423a7c8d30102a5d7f9
failed manifest: FOUNDATION-019A-SECOND-FUNCTIONAL-ATTEMPT-v4
failed runner: FOUNDATION-019A-R2G-RUNNER-v1
last state: CONVERSATION_CREATED
failure: UNKNOWN_POST_CREATE_FAILURE
latest result: DEVELOPMENT V4_FAILED_RUN_REMAINS_DIRTY_BLOCKING
```

The containment authorization is consumed and non-reusable. The latest
sanitized vector remains `UNKNOWN|0|UNKNOWN|0|0|0|0`: messages and sessions are
unknown; idempotency, profiles, catalog fixtures, specialist fixtures and Auth
are zero.

## Why R2I cannot repair v4 retroactively

R2I persists `CreatedConversationIdentity` before future created-state
transitions. Its `.runtime` ledger did not exist during v4. A future ledger
cannot be projected backwards or treated as historical evidence.

The v4 process held the canonical `session.sessionId` and owner ID only in
mutable memory. It derived the operation attempt from the run alias, but neither
the alias nor those handles were committed to an integrity-bound historical
artifact.

## Historical evidence inventory

The local `.runtime` inventory was inspected without printing values:

| Category | Permission | Integrity | Run binding | Conversation | Owner | Alias |
|---|---:|---|---|---|---|---|
| ArtifactV2 | `0600` | valid canonical SHA-256 | exact seven-field `subject_run` | absent | absent | absent |
| Sanitized audit | `0600` | structured append-only evidence | operation/lifecycle only | absent | absent | absent |
| Authorization proposal | `0600` | pre-artifact input | manifest path only | absent | absent | absent |

ArtifactV2 proves which failed run is under review. It does not prove which
resource that run created.

## Identity candidates

| Candidate | Classification | Backend support | Decision |
|---|---|---|---|
| Canonical Conversation ID | `EXACT_BUT_NOT_AVAILABLE` | exact ID lookup exists | unusable |
| Create response `sessionId` | `EXACT_BUT_NOT_AVAILABLE` | exact ID lookup exists | unusable |
| OperationAttemptId / Idempotency-Key | `EXACT_BUT_NOT_AVAILABLE` | exact triple exists | unusable |
| Idempotency result reference | `EXACT_BUT_NOT_AVAILABLE` | supported if record exists | prior exact counter is zero |
| Synthetic owner ID | `EXACT_BUT_NOT_AVAILABLE` | exact owner filter exists | random Auth UUID was not retained |
| Synthetic owner derivation | `UNSUPPORTED_BY_BACKEND` | Auth UUID is not deterministic | rejected |
| Run alias | `EXACT_BUT_NOT_AVAILABLE` | no `chat_sessions` run column | unusable |
| Authorization/manifest/runner | `EXACT_AND_AVAILABLE` | no resource mapping | context only |
| Correlation headers | `UNSUPPORTED_BY_BACKEND` | no retained exact mapping | rejected |
| Historical resource ledger | `EXACT_BUT_NOT_AVAILABLE` | not applicable | absent |
| Sanitized receipt | `EXACT_AND_AVAILABLE` | no handles | context only |

Correlation is not identity. Combining exact context with a weak resource query
does not create an exact key.

## Prohibited strategies

Owner-only lookup, date windows, latest/first result, content/title matching,
global counts, ordering guesses, unbounded lists and pagination-based discovery
are all `UNSAFE`. The focal runner contains no HTTP transport and no fallback
implementation.

## Exact existence proof

`EXACT_HISTORICAL_CONVERSATION_PROOF` requires one complete result from an exact
bounded key, exact owner and run bindings, the failed-run ArtifactV2 context,
resource type `Conversation`, `NON_CANONICAL`, and ownership
`CREATED_BY_RUN`. Missing or mismatched evidence yields
`OWNERSHIP_NOT_PROVEN`.

## Exact absence proof

`EXACT_HISTORICAL_CONVERSATION_ABSENCE_PROOF` requires a complete exhaustive
lookup over the exact identity space. Only an exact `200` zero-row result, or a
contractually exhaustive exact `404`, yields `EXACTLY_ZERO`. Errors, denied
requests, null/empty malformed bodies, partial responses and pagination never
prove absence.

## Feasibility matrix

| Strategy | Key | Lookup | Bound | Owner | Run | Absence | Delete | Status |
|---|---|---|---|---|---|---|---|---|
| Integrity-bound ID artifact | absent | yes | `0..1` | no | no | yes | no | `INSUFFICIENT` |
| Exact idempotency triple | absent | yes | bounded | yes | no | no after record cleanup | no | `INSUFFICIENT` |
| Owner plus exact run binding | absent | no run column | no | no | no | no | no | `UNSUPPORTED` |
| Owner only | absent | yes | no | no | no | no | no | `UNSAFE` |
| Date/order/list discovery | absent | technically queryable | no | no | no | no | no | `UNSAFE` |

## Recovery decision

```text
Primary strategy: NONE_NO_EXACT_HISTORICAL_KEY
Secondary strategy: NONE
Permitted query: NONE
Remote request budget: 0
Maximum result cardinality: 0
Delete: DISABLED
```

No backend endpoint can reconstruct a value that was not retained. A new index,
column or endpoint cannot be safely backfilled for this historical row without
already knowing the row. The only admissible unblock would be newly discovered
integrity-bound historical evidence containing the exact Conversation, owner
and run binding. Free-form logs or manually supplied IDs are insufficient.

For future runs, R2I already supplies the required durable ephemeral binding. A
separate future architecture could add an immutable backend recovery registry
keyed by run and operation attempt, but it cannot retroactively identify v4 and
is outside R2J.

## Ownership and delete eligibility

`LegacyConversationOwnershipProof` binds the exact handle, owner, run,
ArtifactV2 `subject_run`, non-canonical classification and
`CREATED_BY_RUN`. It exposes handles only through callbacks and redacts its
string representation.

Delete eligibility requires `LEGACY_CONVERSATION_EXACTLY_IDENTIFIED` plus the
complete ownership proof. The first recovery execution remains diagnostic-only.
Any delete would require a later separate Founder authorization.

## Messages and sessions

Messages remain `UNKNOWN_BLOCKING` until the Conversation is exactly
identified. If exact absence were ever proven, the local schema's
`messages.session_id -> chat_sessions.id ON DELETE CASCADE` can support a
dependency proof, but only after the exact Conversation proof.

The Product Conversation is represented by the `chat_sessions` row; sessions
therefore remain `UNKNOWN_BLOCKING` without its exact key. Owner-wide session
search is forbidden.

Profiles and Auth preserve their prior exact zero evidence and are not reopened
by R2J.

## ArtifactV2 and request budget

The future gate requires ArtifactV2 with all seven exact historical
`subject_run` fields. Wrong, expired, consumed or corrupt artifacts fail closed.

The implemented manifest has budget zero because no strategy is admissible.
The budget contract independently blocks pagination, fallback, broad lookup,
unknown actions and delete. Increasing the budget requires a new versioned
manifest after an exact key is proven.

## Runner and manifest

```text
Manifest: FOUNDATION-019A-V4-LEGACY-CONVERSATION-RECOVERY-v1
Runner: FOUNDATION-019A-R2J-LEGACY-IDENTITY-RUNNER-v1
Artifact schema: founder-authorization-v2
Mode: LOCAL_CONTRACT_VALIDATION_ONLY
```

The runner accepts only `--validate-contract`. Every executable argument exits
before creating transport. CLI context remained isolated and `SAFE`.

## Tests and guards

Focal tests cover candidates, unsafe strategies, exact one/zero, contractual
and ambiguous 404, multiple/foreign results, wrong bindings, canonical
resources, partial/paginated/error responses, request budgets, dependent
messages/sessions, ArtifactV2 bindings, expiry, consumption and hash corruption.

Architecture guards verify zero request budget, no transport, no query shape,
delete disabled, no temporal/owner/paginated discovery, no false absence and no
false clean classification.

Full local validation completed:

```text
focal tests: 31/31 pass
Flutter: 984 pass / 5 approved skips / 0 failures
Analyzer: 0 errors / 0 warnings / 36 inherited infos
Deno: 86/86 pass; format 62 files
SQL local: 740/740 pass after no-seed reset
remote context: SAFE
```

## Security

```text
remote actions/lookups/deletes: 0/0/0
authorization artifacts consumed: 0
secret reads: 0
.env reads/modifications: 0/0
broad search implementations: 0
schema/backend changes: 0/0
historical identifiers exposed: 0
```

## Readiness and next gate

R2J closes as:

```text
FOUNDATION-019A-R2J BLOCKED_NO_EXACT_HISTORICAL_KEY
```

The dirty run remains dirty blocking. Do not issue a remote authorization,
execute the focal runner, or start FOUNDATION-020. Reopen only if a
cryptographically/integrity-bound exact historical handle with owner and run
proof is discovered.

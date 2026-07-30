# FOUNDATION-019A-R2I - Exact Conversation identity recovery

## Status

```text
Package: FOUNDATION-019A-R2I
Decision: APPROVED
Implementation: VALIDATED_LOCALLY_PENDING_PUBLICATION
Remote actions: 0
Remote authorization granted: NO
```

## Dirty-run evidence

The controlled v4 containment ended
`DEVELOPMENT V4_FAILED_RUN_REMAINS_DIRTY_BLOCKING`. Conversation ownership was
not exactly proven; Conversation, Message and Session counters remained
`UNKNOWN_BLOCKING`; Idempotency, Profile, Catalog, Specialist and Auth were
zero. No delete or other remote mutation was attempted.

The consumed containment authorization is historical, bound to baseline
`709670a`, and not reusable. This package does not reinterpret that run as
clean.

## Identity-loss diagnosis

The v4 functional runner parsed only `session.sessionId` into mutable process
state, registered an in-memory ledger and then advanced to
`CONVERSATION_CREATED`. It did not persist one restart-safe identity containing
the Conversation, owner, run, operation-attempt, cleanup and diagnostic
bindings. The later containment process therefore could not recover the exact
Conversation without a forbidden broad lookup.

The locally demonstrated create response contract is a synchronous HTTP
`200`/`201` object with `session.sessionId`. It does not return owner identity,
so the already validated synthetic owner handle is bound before create. No
local contract supports an empty successful body, asynchronous acceptance,
identity headers or a broad follow-up search.

## Response and state contract

The response classifier distinguishes:

```text
CREATE_CONFIRMED_WITH_EXACT_IDENTITY
CREATE_CONFIRMED_IDENTITY_INCOMPLETE
CREATE_ACCEPTED_PENDING_CONFIRMATION
CREATE_RESPONSE_INVALID
CREATE_RESPONSE_AMBIGUOUS
CREATE_TRANSPORT_FAILURE_NO_ACCEPTANCE_EVIDENCE
CREATE_TRANSPORT_FAILURE_POSSIBLY_ACCEPTED
```

Only `CREATE_CONFIRMED_WITH_EXACT_IDENTITY` permits the created state. A `2xx`
response without the exact handle yields
`CONVERSATION_CREATE_RESPONSE_INCOMPLETE`. A transport ambiguity permits only
one replay through the same create endpoint, OperationAttemptId,
`Idempotency-Key` and normalized request. Failure of that exact replay stops
forward execution as dirty-blocking evidence; there is no date, owner-wide or
list-based reconstruction.

## CreatedConversationIdentity

The immutable, run-scoped internal contract contains:

```text
conversationHandle
ownerHandle
operationAttemptId
runMarker
creationRequestFingerprint
cleanupHandle
diagnosticLookupHandle
ownership
environment
createdAt
```

Conversation, cleanup and diagnostic handles must be the same valid canonical
handle. Owner is bound before create. OperationAttemptId is generated once per
run and reused for initial create, replay, ownership proof and idempotency.
`ownership` is exactly `CREATED_BY_RUN`; Catalog and Specialist remain
`VERIFIED_PREEXISTING_READ_ONLY`.

## Ledger protocol

The functional order is:

```text
parse and validate identity
-> register in-memory cleanup entries
-> persist run ledger
-> verify canonical hash and all bindings
-> transition to CONVERSATION_CREATED
```

The ledger is stored at
`.runtime/runs/<run-marker>/resource-ledger.json`, which is covered by the
narrow `.runtime/` Git ignore. Directories are `0700`; the temporary and final
files are `0600`. Writes flush a canonical JSON temporary file and atomically
rename it. The SHA-256 covers identity, lifecycle and authorization, commit,
manifest, runner and environment bindings.

The ledger contains operational opaque handles because exact cleanup and
restart recovery cannot use a one-way digest. Those handles are not credentials
or content, remain local and permission-restricted, and are never printed.
Email, tokens, keys, JWTs, message content and Conversation content are absent.
No new encryption scheme is invented.

## Lifecycle and interruption recovery

The irreversible lifecycle is:

```text
RESOURCE_CREATED
-> CLEANUP_PENDING
-> CLEANED
-> CLOSED
```

`DIAGNOSIS_PENDING` is an alternate bounded recovery state. A closed ledger
cannot reopen. Every read revalidates the hash plus run, authorization, commit,
manifest, runner and environment binding. A crash before atomic rename leaves
no accepted ledger; a crash after rename permits exact restart recovery; an
interrupted replacement preserves the prior verified record. Clean completion
closes and removes only that run's ephemeral file.

## Cleanup and diagnostics

Cleanup deletes by the entry's exact handle, never mutable context or broad
search. The v4 containment contracts now accept
`V4SharedConversationIdentity.fromCreated`, which wraps the same
`CreatedConversationIdentity` and exposes only callback-based cleanup,
diagnostic and owner handle use. Historical v4 behavior remains supported when
no shared identity exists.

The current historical dirty run is explicitly:

```text
LEGACY_DIRTY_RUN_MISSING_EXACT_CONVERSATION_IDENTITY
```

R2I cannot reconstruct a handle that v4 never durably preserved.

## Executable versions

```text
Functional manifest: FOUNDATION-019A-SECOND-FUNCTIONAL-ATTEMPT-v5
Functional runner: FOUNDATION-019A-R2I-RUNNER-v1
Shared identity: FOUNDATION-019A-R2I-CONVERSATION-IDENTITY-v1
Authorization: NOT_GRANTED
Execution: NOT_EXECUTED
```

The manifest declares exact identity, owner/run/attempt bindings, ledger-before-
state ordering, exact cleanup/diagnostic handles, integrity bindings and the
legacy limitation.

## Validation

Focal tests cover exact/incomplete/malformed/pending/transport responses,
identity validation, owner/run/attempt bindings, canonical hashing, atomic
failure, permission modes, restart recovery, lifecycle closure, binding
mismatch, cleanup handles, diagnostic projection and legacy classification.
Architecture guards verify ordering, no broad cleanup, stable attempt
generation, ignored runtime storage and non-clean legacy classification.

Validation completed with 121/121 focal tests, 953 Flutter tests passing with
five approved skips, analyzer at zero errors and zero warnings with 36 inherited
infos, Deno format over 62 files, 86/86 Deno tests, and 740/740 local SQL tests
after a no-seed reset applying migrations 00001-00012. The remote-context
preflight remained `SAFE`.

R2I performs no remote action, secret read, authorization consumption, remote
schema change, backend deployment, remote migration or function deployment.

## Readiness and next gate

After all local gates, commit and push:

```text
FOUNDATION-019A CONVERSATION_IDENTITY_RECOVERY_READY_LOCAL_AND_PUSHED
```

Stop after publication. Any future remote execution requires a new
conversational Founder authorization bound to the new full SHA, functional
manifest v5 and runner R2I-v1. The historical v4 residue requires a separate
exact strategy and remains dirty blocking.

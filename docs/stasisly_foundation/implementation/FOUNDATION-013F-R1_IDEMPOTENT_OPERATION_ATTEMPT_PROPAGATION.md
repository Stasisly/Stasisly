# FOUNDATION-013F-R1 - Idempotent operation-attempt propagation

## 1. Original blocker

FOUNDATION-013F stopped before implementation because create and send had no
stable application-owned attempt identifier. A retry of one application intent
could therefore reach the backend with a different `Idempotency-Key`.

## 2. Root cause

Both local HTTP datasources owned a secure factory and generated a new key for
every repository invocation. The canonical inputs had no attempt field, the
transitional adapter could not preserve operation metadata, and reinvoking a
repository necessarily called the factory again. The transport performs one
send per request; it has no automatic Dio retry. Reusing the same request
preserves its headers, but application retries previously created a new key.

## 3. OperationAttemptId contract

`OperationAttemptId` is an immutable, provider-neutral value object in
`lib/core/idempotency/`. It accepts 16-128 characters from
`A-Z a-z 0-9 . _ ~ -`, has value equality, and redacts `toString` and validation
errors. It is not identity, authorization, ownership or correlation metadata.

## 4. Generation

`OperationAttemptIdFactory` is a narrow port. Its secure implementation uses
`Random.secure` and creates a new value only when explicitly invoked. It does
not know repositories, HTTP, users, conversations or content.

## 5. Attempt ownership

The application caller owns one attempt for one user intent. Same-intent and
transport retries retain it; a new or edited intent requests a new value.
Repositories, adapters and datasources may only propagate it.

## 6. Canonical inputs

`CreateConversationInput` requires `selectableSpecialistId` when applicable and
an `operationAttemptId`. `SendConversationMessageInput` requires
`conversationId`, content and an `operationAttemptId`. No owner, author, role,
surface, environment, entitlement or agent identifier was added.

## 7. Repository port

The canonical `ConversationRepository` continues to consume the canonical
inputs. Because the effect inputs now require the attempt, create and send
cannot be invoked without explicit operation identity.

## 8. Transitional adapter

`TransitionalConversationRepositoryAdapter` passes
`input.operationAttemptId` unchanged to the session/message repository. It does
not generate, derive, normalize or replace the value.

## 9. Transitional repositories

The create/send signatures of `OwnChatSessionsRepository`,
`OwnChatMessagesRepository` and the focal contract source now require the
shared neutral value object. Validating, demo and backend-blocked implementations
were migrated without introducing implicit overloads.

## 10. Datasources

Both local HTTP datasources receive the caller-owned attempt. Their factory
fields and constructors were removed. No datasource-owned key generator remains.

## 11. Transport header

Only the transport boundary maps the value to:

```text
Idempotency-Key: OperationAttemptId.value
```

The key is not added to payloads, results, errors or public display.

## 12. Retry semantics

Calling create/send twice with the same input emits the exact same header.
Supplying a new attempt emits a different header. A transport retry of the same
request object retains the same header. Missing attempts fail at compile-time
because effect inputs and repository signatures require the value.

## 13. Compatibility migration

All active local create/send consumers and test doubles were migrated. Existing
transitional controllers request one attempt at the start of each explicit user
invocation; no deprecated implicit-generation path remains. Full canonical
application retention/retry behavior belongs to FOUNDATION-013F.

## 14. Guards

Architecture tests block datasource/repository/adapter generation, timestamps,
correlation IDs, conversation/session-derived attempts, provider DTOs, raw
display/logging patterns, missing input fields and widget-owned keys.

## 15. Tests

Unit tests cover validation, equality, redaction and secure generation.
Propagation tests cover create/send end to end. Retry tests cover same intent,
new intent, edited content and same-request transport retry. Existing contract,
controller, provider, presentation and integration tests use explicit attempts.

## 16. Security

Attempts contain no personal data or token semantics and confer no authority.
They are never logged or displayed. Backend validation/enforcement remains the
authority; no fallback key, secret, backend change or remote action was added.

## 17. Rollback

Rollback is the single package commit. It must not reconnect datasource-owned
generation in a partial state: value object, signatures, propagation and tests
move together. No schema, data or remote rollback is required.

## 18. Readiness

After Flutter, Deno and local SQL regressions pass and G7 publication completes:

```text
FOUNDATION-013F-R1: IMPLEMENTED_LOCALLY
FOUNDATION-013F: READY_TO_RESUME
Canonical application layer: NOT IMPLEMENTED
Remote: NOT IMPLEMENTED
```

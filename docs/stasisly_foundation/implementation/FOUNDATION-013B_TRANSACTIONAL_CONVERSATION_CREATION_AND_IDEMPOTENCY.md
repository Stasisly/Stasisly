# FOUNDATION-013B Transactional Conversation Creation and Idempotency

## Metadata

```text
Status: IMPLEMENTED_LOCALLY
Owner: Backend + Security + Product Architecture under Stasis/Rector
Decision authority: ADR-F009, ADR-F010 and ADR-F011
Environment: local only
Remote operations: none
```

## 1. Previous flows

Create previously verified JWT and backend authorization, resolved the public
catalog selection through separate HTTP reads, checked eligibility and then
inserted `chat_sessions`. Send already delegated ownership, active-state,
message insert and session counters to one RPC, but had no retry identity.

## 2. Closed TOCTOU risk

Separate catalog reads allowed publication, availability, surface, tier or
internal-specialist state to change before session insertion. Eligibility now
lives in the same PostgreSQL transaction as idempotency resolution and insert.
The selected catalog row is held `FOR SHARE` until the operation completes.

## 3. Idempotency key contract

`Idempotency-Key` is required for create and send. It is a client-generated,
opaque, non-authoritative value of 16-128 ASCII characters from
`A-Z a-z 0-9 . _ ~ -`. It contains no identity, token or personal data.

## 4. Idempotency scope

Uniqueness is `(verified subject, operation, key)`. Different subjects and
operations are independent; the key cannot grant authority over a resource.

## 5. Payload fingerprint

Create fingerprints the authorized `selectableSpecialistId`; send fingerprints
`sessionId` plus content normalized by the existing trim contract. PostgreSQL
computes SHA-256; JWTs, timestamps, correlation IDs and complete payloads are
excluded.

## 6. Replay and conflict

Same scope and fingerprint returns the original logical result without another
effect. A different fingerprint returns opaque `idempotencyConflict`. Parallel
matching requests serialize on the idempotency row and produce one effect.

## 7. Persistence

`conversation_idempotency` records subject, operation, key, fingerprint,
state, result reference, safe result metadata and timestamps. Allowed states
are `started`, `completed`, `failed_retryable` and `failed_final`.

## 8. Persistence security

RLS is enabled. There are zero client policies and no `PUBLIC`, `anon` or
`authenticated` privileges. `service_role` receives only SELECT, INSERT and
UPDATE. RPC execute is revoked from clients and granted only to `service_role`.
Neither RPC is `SECURITY DEFINER`; both use a fixed safe `search_path`.

## 9. Transactional create

`create_own_chat_session_core(owner, selectable, key)` is the transitional
physical boundary for canonical Conversation creation. It verifies the trusted
backend subject, user, Product area, publication, availability, conversability,
Product surface, free tier and internal specialist identity, inserts once and
completes the ledger in one transaction. Pro/vip remain locked. The public DTO
contains no owner or internal ID.

## 10. Locking

The unique idempotency row serializes each scope. Create holds the selected
catalog row `FOR SHARE`, preventing eligibility updates or deletion from racing
the insert. Send locks the owned session before message and counter mutation.

## 11. Transactional send

`send_user_message_core(session, owner, content, key)` resolves idempotency,
ownership and active state, inserts exactly one user message and updates
`message_count` and `last_message_at` atomically. Replay returns the original
message and counters. No assistant, system or tool message is created.

## 12. Operation lifecycle

An attempt moves from `started` to `completed` within one transaction. Failure
rolls back the provisional ledger row and every effect, so no crashed
transaction leaves a durable lock. Archived conversations reject send; a new
create key represents a new explicit Conversation intent.

## 13. Edge Functions

The Edge Functions derive owner only from verified JWT and call the RPCs with
`service_role`. Create performs no direct catalog/session write and send performs
no direct message/session write. Invalid keys fail before backend access;
replay flags, fingerprints and internal IDs are stripped.

## 14. Flutter compatibility

Flutter generates a cryptographically strong operation-attempt ID immediately
before each create/send invocation and sends it only as `Idempotency-Key`. One
invocation retains one key; a new explicit invocation is a new intent. Bodies
and public DTOs are unchanged, with no owner, role, agent or internal ID.

## 15. Errors

Neutral contracts distinguish missing/invalid key, conflict, in-progress and
transaction failure. Responses remain opaque; backend messages, ownership facts,
SQL details and secrets are not exposed or converted into demo behavior.

## 16. HTTP semantics

First effects return `201`; matching replays return `200` with the same DTO;
conflicting payloads return `409`. Missing/invalid keys return `400`, and
transaction unavailability returns `503`. Ownership failures stay opaque.

## 17. SQL tests

pgTAP proves table/RPC security, valid create/send, replay, conflict,
cross-subject/operation independence, archived/non-owner denial, atomic counters,
rollback, no sensitive ledger payload and seven-table cleanup.

## 18. Deno tests

Deno proves key validation, RPC-only delegation, no direct writes, replay DTO
sanitization and opaque error mapping for both Edge Functions.

## 19. Integration tests

Real local HTTP harnesses prove sequential and parallel retries with one effect,
no catalog corruption and cleanup `0|0|0|0|0|0|0`. Flutter proves generation,
forwarding, result mapping and compatibility.

## 20. Reproducibility

Validation uses Supabase local only, reset with `--no-seed`, full pgTAP suites,
local Edge Functions and synthetic transactional fixtures. Final cleanup leaves
all seven relevant tables empty.

## 21. Rollback

Revert the FOUNDATION-013B commit and reset the local database to the preceding
migration set. Do not reactivate direct writes, weaken deny-all, reconnect
legacy chat or perform remote rollback. No real data exists.

## 22. Residual debt

Canonical endpoints, lifecycle completion, provenance, legacy UI retirement,
Product routes, remote migration, rate limiting and observability remain out of
scope. No cron or Product retention promise is introduced. Completed ledger
records remain until bounded retention, safe cleanup, failed-state operations
and metrics are approved in a later privacy/operations package.

## 23. Readiness

```text
Conversation creation: FOUNDATION_ADOPTED_LOCALLY
Create idempotency: FOUNDATION_ADOPTED_LOCALLY
Send idempotency: FOUNDATION_ADOPTED_LOCALLY
TOCTOU: CLOSED_LOCALLY
Physical tables/functions: TRANSITIONAL
Canonical backend API: PARTIAL
Remote/staging/production: NOT_AUTHORIZED
G0-G6 complete after reproducible local validation
G7 closes with the explicit package commit and push
G8-G10 not executed
TRANSACTIONAL CONVERSATION_CREATION_AND_IDEMPOTENCY IMPLEMENTED_LOCAL_AND_PUSHED
upon successful publication
```

# ADR-F011 Transactional Conversation Creation and Idempotency

## Status

```text
Decision: APPROVED
Implementation: IMPLEMENTED_LOCALLY
Remote adoption: NOT_AUTHORIZED
```

## Context

ADR-F009/F010 establish canonical Conversation contracts over transitional
`chat_sessions`/`messages`. Create performed eligibility reads and insertion in
separate requests, leaving a TOCTOU window. Create and send also lacked a
server-enforced retry identity, so timeout, double tap or parallel retry could
duplicate effects.

## Decision

1. Create and send require `Idempotency-Key`; it is opaque, bounded and never
   identity, authorization or ownership.
2. Idempotency scope is verified subject plus operation plus key.
3. PostgreSQL computes a deterministic SHA-256 fingerprint from only semantic
   authorized input.
4. Matching replay returns the original logical result; conflicting reuse is
   denied before a second effect.
5. `conversation_idempotency` is server-managed, RLS deny-all to clients and
   stores no token or complete message payload.
6. `create_own_chat_session_core` keeps transitional naming and performs
   idempotency, locked catalog eligibility and insertion in one transaction.
7. `send_user_message_core` performs idempotency, ownership/state validation,
   user-message insertion and session counter updates in one transaction.
8. Owner is supplied only by the trusted Edge Function after verified JWT; RPCs
   are not directly executable by clients.
9. RPCs are invoker-security functions with fixed `search_path`; use of
   `SECURITY DEFINER` is rejected.
10. Public DTOs remain compatible and strip replay/internal state.
11. Flutter creates one key per operation attempt and never sends owner, author,
    role, agent or internal specialist authority.
12. Completed records have no automatic expiry in this package; retention and
    operational cleanup remain explicit debt.
13. The decision is local/development evidence only. It authorizes no remote
    migration, deployment, Product route, real auth/data, IA or production.

## Consequences

Create eligibility cannot change between validation and insert without being
serialized by the row lock. Sequential and concurrent retries produce one
effect and deterministic replay. The cost is a server ledger, key lifecycle
contract and future retention/monitoring work. Physical session/message names
remain transitional and the canonical backend surface remains partial.

## Rejected alternatives

- TypeScript multi-request orchestration: not one database transaction.
- Client-only duplicate prevention: cannot cover timeout-after-commit or
  parallel requests.
- `conversationId` or timestamp as key: conflates resource/clock with intent.
- Payload storage instead of fingerprint: unnecessary sensitivity.
- Client CRUD/RPC grants: bypasses trusted JWT/authorization boundary.
- `SECURITY DEFINER`: unnecessary privilege elevation.
- Remote cron/expiry now: unapproved operational and privacy policy.

## Security invariants

```text
verified JWT owner only
same key cannot authorize another payload
zero client table policies and dangerous grants
zero client RPC execute
no token, JWT, message content or full payload in ledger
no internal replay/fingerprint/owner/specialist ID in public DTO
no direct Edge Function writes
no demo fallback
no remote action
```

## Evidence and rollback

Evidence is the FOUNDATION-013B implementation record plus SQL, Deno, HTTP and
Flutter suites. Rollback reverts the package and resets local migrations only;
it never weakens deny-all or reconnects legacy chat. G8-G10 require separate
Founder authorization.

## Follow-up

FOUNDATION-013C may address list/read/archive/restore and lifecycle history only
after separate approval. Retention/cleanup belongs to a later privacy and
operations package.

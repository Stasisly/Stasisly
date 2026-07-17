# FOUNDATION-013D - Canonical Message author, provenance and visibility

Status: **IMPLEMENTED LOCALLY**. Remote execution is not authorized.

## 1. Previous audit

The transitional `messages` table stored `role`, content, timestamp and
`session_id`, but had no evidence-bearing author, provenance or visibility.
Ownership was derived through `chat_sessions`; the list function read the table
directly and the Flutter adapter inferred `system` authorship from `role`.

## 2. MessageAuthor

The Product contract is a sealed hierarchy: `UserAuthor`, `StasisAuthor`,
`SpecialistAuthor`, `SystemNoticeAuthor` and `UnknownAuthor`. Only evidence-safe
variants can construct a visible `ConversationMessage`.

## 3. Author mapping

Verified backend user writes map to `UserAuthor`. A proven Product notice may
map to `SystemNoticeAuthor`. Legacy `assistant`, `tool` and unproven values remain
unknown; they never become Stasis or a specialist by inference.

## 4. MessageProvenance

Provenance is separate from display author: `userProvided`,
`stasisConsolidated`, `specialistProvided`, `systemGenerated`, `imported` or
`unknown`.

## 5. Evidence model

Positive provenance must come from a registered backend operation and coherent
stored metadata. Text, Flutter input, provider role and internal IDs are not
evidence.

## 6. MessageVisibility

The closed vocabulary is `productVisible`, `ownerOnly`, `systemVisible`,
`internal`, `redacted` and `unknown`. `internal` and `unknown` fail closed.

## 7. Product/internal separation

`ConversationMessage` is Product history. Execution events, tool executions,
model invocations, agent contributions, research artifacts and memory proposals
remain separate future concepts and are not persisted here.

## 8. Private reasoning prohibition

Product Message has no reasoning, scratchpad, hidden analysis, raw prompt,
provider trace, tool input/output or chain-of-thought field.

## 9. Public DTO

The sanitized transition emits message/session IDs, legacy role for current
consumers, safe author category, content when not redacted, timestamp, status,
provenance and visibility. It emits no owner, internal specialist, runtime,
provider, prompt, policy, idempotency or trace data.

## 10. Transitional compatibility

`sessionId`, cursor ordering, content-only send, archived history and the
existing endpoint names remain. Metadata fields are additive. The canonical
adapter fails closed when evidence is absent.

## 11. Persistence

Migration `00012` adds `author_type`, `provenance_type` and `visibility_type`
to transitional `messages`, plus one read index and the narrow owner-scoped list
RPC.

## 12. Backfill

Only a completed `send_user_message` idempotency ledger reference proves an
existing user message. Other historical records default to unknown; `tool`
records are marked internal. No record is deleted.

## 13. Constraints

Closed checks reject unknown vocabulary and incoherent combinations of author,
provenance and visibility. Safe unknown defaults preserve legacy inserts without
making them Product-visible.

## 14. User send

`send_user_message_core` alone sets `user`, `userProvided`,
`productVisible` and returned status `accepted`. Edge and Flutter cannot send
those fields.

## 15. Future operations deferred

Stasis, specialist, system-notice, internal-execution and redaction writes are
not registered or implemented.

## 16. Read filtering

`list_own_conversation_messages_core` verifies owner plus active/archived
lifecycle and filters Product-readable visibility in SQL. Internal and unknown
content never reaches Edge or Flutter.

## 17. Pagination

The SQL visibility predicate runs before keyset ordering and limit. The cursor
therefore advances over the visible stream without duplicates, hidden-row gaps
or empty loops.

## 18. Redaction

The read contract returns `NULL` for persisted redacted content; the public DTO
omits `content`, and Flutter uses a local fixed placeholder. Moderation and
redaction writes remain contract-only.

## 19. Specialist reference

Future specialist authors may expose only a validated `selectableSpecialistId`
and display-safe snapshot. `specialists.id` and runtime IDs are forbidden.

## 20. Stasis reference

The stable Product reference is `stasis`; it is not a runtime agent ID. No
Stasis-authored message is created by this package.

## 21. Status

Persisted visible history is `accepted`; safe redaction is `redacted`.
`failed` and `unknown` remain canonical fail-closed vocabulary; no pending flow
was invented.

## 22. Operation registry

Active IDs are `conversation.message.sendUser` and
`conversation.message.listOwn`. Future append/redact IDs are not executable.

## 23. Authorization

JWT verification, Product surface, local/development environment, ownership,
PDP/PEP and safe correlation IDs remain mandatory. Visibility never replaces
authorization.

## 24. Errors

Malformed or unverifiable DTOs fail as sanitized contract violations. Foreign
and missing conversations remain opaque `sessionNotFound`; database internals
are not returned.

## 25. HTTP

Send remains `201` first effect and `200` replay. List remains `200`; invalid
authority input is `400`, missing auth `401`, and foreign ownership opaque
`404`.

## 26. SQL tests

The focal pgTAP suite covers schema, checks, RLS, policies, grants, invoker
security, send/replay metadata, safe system notice, hidden rows, redaction,
ownership, archive history and pagination.

## 27. Deno tests

Contracts reject authority-bearing input, enforce exact metadata, omit redacted
content, reject assistant/tool/internal/unknown rows, sanitize errors and use
canonical operation IDs.

## 28. Flutter tests

Domain, adapter, validator, datasource and integration tests cover safe user and
system mapping, unknown/internal failure, redaction placeholder, metadata and
provider-neutral contracts.

## 29. Guards

Architecture guards prohibit runtime/provider/prompt/tool/private-reasoning
fields, authority-bearing send inputs, role-based Stasis/specialist inference,
direct message-table reads and hidden Flutter visibility.

## 30. Integration

The local HTTP harness creates synthetic users/sessions, sends and lists through
Edge, verifies metadata and hidden content, preserves archived history and
cleans users, catalog, sessions, messages and idempotency records to seven
zeroes.

## 31. Security

Author, provenance and visibility are backend-controlled. RLS stays enabled,
messages keep zero client policies and CRUD grants, RPCs are service-role only,
and no secret or internal identifier enters Product DTOs or logs.

## 32. Rollback

Code rollback is the package commit revert. Database rollback requires a
separately approved forward migration because deployed migration history is
append-only; no remote migration was run here.

## 33. Debt

The physical table and endpoints retain transitional `sessionId`/`role`.
Stasis/specialist provenance, display snapshots, redaction writes and internal
execution storage require later separately governed packages.

## 34. Readiness

Message author/provenance/visibility and user-message metadata are Foundation
adopted locally. Stasis/specialist messages, Engine, Product routes, remote and
production remain not implemented.

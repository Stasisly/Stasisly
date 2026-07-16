# FOUNDATION-013A Canonical Conversation Contracts and Adapters

## Metadata

```text
Status: IMPLEMENTED_LOCALLY
Owner: Product + Flutter Architecture under Stasis/Rector
Decision authority: ADR-F009 and ADR-F010
Environment: local only
Remote operations: none
```

## 1. Problem

Product uses `Conversation`, while the safe existing client/backend boundary
still exposes `OwnChatSession`, `OwnChatMessage` and `sessionId`. Reusing legacy
chat would reintroduce client authority and direct Supabase coupling; renaming
the safe boundary in place would create a big-bang compatibility break.

## 2. Conversation contract

`Conversation` is the canonical Product aggregate. It contains an opaque ID,
trusted owner subject, lifecycle, timestamps, optional archive/title fields and
an optional public specialist selection. Provider thread, runtime, prompt,
model, tool, credential and internal specialist identifiers are excluded.

## 3. ConversationId

`ConversationId` is non-empty, bounded to 200 characters, control-character
free and deliberately does not require UUID format. Mapping the current
`sessionId` preserves compatibility but is explicitly transitional.

## 4. Lifecycle

The vocabulary is `active`, `archived`, `pendingDeletion`, `unknown`.
`unknown` fails closed and cannot construct a Conversation. Only `active`
allows normal mutation. Restore and delete remain unimplemented.

## 5. ConversationMessage

The canonical message contains `messageId`, `conversationId`, typed author,
trimmed bounded content, timestamp, status and safe provenance summary. No raw
model metadata, tool trace, prompt, authorization context or token is present.

## 6. Author

Canonical authors are user, Stasis, specialist, system notice and unknown. The
adapter maps existing `user` and `system` evidence. Existing `assistant` and
`tool` are ambiguous and therefore map to non-display-safe `unknown`; no Stasis
or specialist identity is invented.

## 7. Message status

The vocabulary is accepted, pending, failed, hidden and unknown. A source
`OwnChatMessage` proves persistence and maps only to accepted. No optimistic
state is inferred.

## 8. Provenance

The safe summary vocabulary is user-provided, Stasis-generated,
specialist-generated, system-generated and unknown. Current evidence maps only
user and system positively. FOUNDATION-013D owns richer author/provenance work.

## 9. Specialist selection

`ConversationSpecialistSelection` exposes `selectableSpecialistId` plus
already-safe display name, area and selection state. It does not expose
`specialists.id`, runtime agent identity, prompt or technical permissions.

## 10. Participants deferred

No persistent or multi-party participant contract was added because the
backend does not support it. Visible participant expansion remains future work.

## 11. Result contracts

List, read, mutation, message-list and message-send results use one neutral
status vocabulary: success, unauthenticated, unauthorized, not found, invalid
input, archived, environment blocked, backend unavailable, contract violation
and unknown failure. Provider exceptions and DTOs do not cross the port.

## 12. Repository port

`ConversationRepository` exposes exactly list/create/archive owned
Conversations and list/send owned Conversation Messages. Restore, delete,
share, attachments, memory, research, participants and trace are absent.

## 13. Request contracts

Inputs accept only `selectableSpecialistId`, `conversationId`, bounded
cursor/limit and content as applicable. Owner, author, agent, role, surface,
environment and entitlement are not request authority. Current create requires
a specialist because the transitional backend has no Stasis-only create shape.

## 14. Adapters

Two entity adapters map `OwnChatSession` and `OwnChatMessage`. The composed
`TransitionalConversationRepositoryAdapter` delegates all five operations to
the existing repositories, preserves cursor/limit/content and maps failures
without transport duplication or demo fallback.

## 15. Transitional nomenclature

```text
Conversation: CANONICAL_PRODUCT_CONTRACT
chatSession/sessionId: TRANSITIONAL_BACKEND_CONTRACT
```

No existing class, DTO, table, endpoint or transport was renamed.

## 16. Compatibility

`OwnChatSession`, `OwnChatMessage`, their repositories, Edge Function payloads,
`selectableSpecialistId`, transport `sessionId` and content-only send remain
unchanged. The adapter rejects mismatched send IDs and partial mapping.

## 17. Guards

Architecture tests block provider/legacy imports in domain, client authority
fields, runtime IDs, Product route registration, presentation, remote
datasources, legacy fallback and Conversation/Session typedef aliasing.

## 18. Tests

Flutter completed with 514 passes and 5 approved skips, 31 passes above the
483-pass baseline. Analyzer completed with zero errors and 51 inherited infos.
Deno completed 72/72. Local SQL completed 649/649 after reset without seed.

The requested global formatter exposed pre-existing formatting drift in 27
out-of-scope files; those formatter-only changes were restored. New and touched
package files are formatted and pass focal analysis with no issues.

## 19. Security

Ownership comes only from an authenticated `StasislyIdentity` supplied to the
adapter. Missing/untrusted ownership fails before repository access. No owner,
role, agent, internal specialist ID, provider type, trace, token or secret was
added to Product inputs or results. No route, network adapter or remote action
was introduced.

## 20. Rollback

Revert the FOUNDATION-013A commit. Existing safe session/message contracts and
all runtime wiring remain unchanged, so rollback requires no schema, data,
route, backend or remote action and must not reactivate legacy chat.

## 21. Residual debt

- Canonical backend endpoints and `conversationId` DTOs are not implemented.
- Transactional create and idempotency remain FOUNDATION-013B.
- Read/restore and complete lifecycle remain FOUNDATION-013C.
- Rich author, visibility and provenance remain FOUNDATION-013D.
- UI retirement and Product routes remain FOUNDATION-013E/F.
- Current Stasis-only creation is unavailable behind the transitional API.

## 22. Readiness

```text
CANONICAL CONVERSATION_CONTRACTS_AND_ADAPTERS IMPLEMENTED_LOCAL_AND_PUSHED
upon successful package publication
G0-G6 complete before publication
G7 completed by the package commit and push
G8-G10 not executed
```

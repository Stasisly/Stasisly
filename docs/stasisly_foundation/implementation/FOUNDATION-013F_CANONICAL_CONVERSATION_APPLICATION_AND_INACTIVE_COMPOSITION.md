# FOUNDATION-013F - Canonical Conversation application and inactive composition

```text
Status: IMPLEMENTED_LOCALLY
Readiness: pending G7 publication until package commit/push
Remote: NOT AUTHORIZED / NOT IMPLEMENTED
Date: 2026-07-21
```

## 1. Prior block and R1 resolution

The original 013F package stopped because create/send retry ownership was not
stable. FOUNDATION-013F-R1 resolved that blocker by introducing the redacted,
provider-neutral `OperationAttemptId` and propagating it unchanged. This package
consumes that approved contract; it does not regenerate transport keys.

## 2. Use cases and inputs

The application layer now exposes `ListOwnConversations`,
`ReadOwnConversation`, `CreateOwnConversation`, `ArchiveOwnConversation`,
`RestoreOwnConversation`, `ListOwnConversationMessages` and
`SendOwnConversationMessage`. They depend only on `ConversationRepository`,
typed canonical inputs/results and contain no Riverpod, HTTP, Dio, Supabase,
legacy chat, ownership derivation, logging or authorization construction.

Create accepts only `selectableSpecialistId` plus an application-owned attempt.
Send accepts only `ConversationId`, content and an application-owned attempt.
Neither accepts owner, role, author, provenance, visibility, surface or
environment.

## 3. List state, filters and pagination

`ConversationListState` represents initial, loading, data, empty, refreshing,
loading-more, unauthenticated, environment-blocked and safe error states. Only
active and archived filters exist; active is the default and there is no `all`.

`ConversationListController` preserves opaque cursors and backend order,
deduplicates by `ConversationId`, prevents concurrent load-more, clears cursor
and incompatible items on filter changes, and rejects stale generations or
status-incompatible pages. It never parses a cursor or merges active/archived
streams.

## 4. Detail, messages and composer state

`ConversationDetailState` composes canonical Conversation data with separate
messages, composer and lifecycle states. Detail distinguishes initial, loading,
active, archived, not-found, unauthenticated, environment-blocked and error.
Messages distinguish initial, loading, data, empty, loading-more and error,
retain the opaque cursor and deduplicate by message ID.

Composer state contains only draft validity, send status, safe error and a
non-sensitive retry availability flag. Attempts and submitted intent content
remain private controller implementation details and do not appear in state,
`toString`, debug labels or UI.

## 5. Create and send intent semantics

The create controller allocates one attempt on a new specialist-selection
intent, blocks double submit and reuses the exact attempt for retryable failure
or explicit conflict. Changing `selectableSpecialistId` starts a new intent.

The detail controller captures normalized submitted content with one attempt.
Same-intent retry reuses that exact object. Editing after a failure retires the
old intent; editing during an in-flight send does not discard the effect result
and the new draft is not cleared. Success/replay reconciles and deduplicates the
canonical Message. Conflict is typed and never creates a replacement attempt
silently. No automatic timed retry exists.

## 6. Archive, restore and archived behavior

Archive and restore remain naturally idempotent without attempt IDs. One
lifecycle effect may run at a time; archive is rejected while send is active.
Successful transitions update the detail phase and invalidate the list provider
deterministically. Archived history remains readable, the composer is disabled,
send is rejected before the repository call when archived status is known, and
restore is explicit rather than automatic.

## 7. Detail concurrency and refresh

Detail load reads the canonical Conversation then the first Message page.
Generation plus `ConversationId` guards ignore old reads after a new ID, and
disposed controllers publish no late data. Send, lifecycle and message
load-more each have one in-flight effect. Refresh is a new canonical read, not a
claim that the backend request was cancelled.

## 8. Providers and repository composition

Feature-scoped Riverpod providers expose the canonical repository, attempt
factory, seven use cases, auto-disposed list/create controllers, auto-disposed
detail controller family keyed by `ConversationId`, canonical message mapper
and inactive-host availability.

The repository provider composes `TransitionalConversationRepositoryAdapter`
over existing safe session/message repositories only after an authenticated
subject is obtained from `secureSessionStateProvider`. Ownership remains a
backend/canonical-adapter concern. Transitional repositories are not exposed to
widgets and no transport is duplicated.

## 9. Environment behavior

Explicit composition is available only in local and development. Demo,
staging, production and backendReal return provider-neutral
`environmentBlocked`; invalid runtime names fail before composition.
Local/development without trusted session returns `unauthenticated`. There is no
demo, mock, legacy or unknown-mode fallback.

## 10. Inactive host and view models

`InactiveConversationFeatureHost` consumes only canonical providers. Its list
surface has active/archived selection, safe list items, refresh/load-more and an
explicit selection callback without navigation. Its detail surface has a safe
summary, canonical messages, content-only composer and archive/restore intents.

`ConversationListItemViewModel` exposes `ConversationId`, safe title fallback,
status, updated time and optional public specialist summary. It exposes no owner
or internal specialist/agent/session/authorization ID. The existing canonical
message mapper is reused; unknown/internal messages have no rendered fallback.
The host has no AppBar, route, deep link, active shell registration or final
Product-screen claim.

## 11. Errors and retry contracts

UI-facing errors are controlled codes: unauthenticated, unauthorized,
not-found, environment-blocked, invalid-input, archived,
idempotency-conflict, backend-unavailable, contract-violation and unknown.
Provider/HTTP payloads and raw exceptions never enter application state.

List/detail/message retries start new reads. Same create/send intent reuses its
attempt; changed create/send intent gets a new attempt. Archive/restore retry the
same natural transition. No automatic retry or restore is performed.

## 12. Guards, tests and compatibility

Architecture guards prohibit transport/provider imports in application,
repository or attempt generation in widgets, legacy-chat imports, routing from
the host, active registration, owner/role/author metadata in public inputs and
attempt/token exposure in composer state. Controller/use-case/provider/widget
tests cover success, empty and safe failures; filters/cursors/deduplication;
stale/disposed results; create/send retry identity; edit behavior; conflict;
archive/restore races; environment gates; canonical rendering and inactive
selection.

Validated evidence:

```text
Flutter: 597 PASS, 5 approved skips, 0 failures
Architecture: 108/108 PASS
Analyzer: 0 errors, 51 inherited infos
Deno: 86/86 PASS; format 62 files
SQL local: one no-seed reset; 24 files, 740/740 PASS
```

Compatibility is preserved: `ConversationRepository`, opaque
`ConversationId`, transitional `sessionId`, stable cursor,
`selectableSpecialistId`, content-only send, `Idempotency-Key`, archived history
and public DTOs are unchanged. Backend, schema, Edge Functions and SQL tests are
regression-only in this package.

## 13. Security review

Application/widgets derive no ownership or authorization and cannot control
author, provenance or visibility. Attempts are stable only per intent and are
never logged, displayed or serialized into public state. There is no provider
DTO, raw payload, legacy fallback, hidden route, automatic restore,
staging/production enablement, remote action or secret.

## 14. Rollback, debt and readiness

Rollback is the atomic package commit; no database rollback applies. Remaining
debt is deliberately open: canonical Product screen/routes, active shell,
legacy consumer migration/removal and remote activation are not implemented.

Foundation adoption:

```text
Conversation application use cases: FOUNDATION_ADOPTED
Conversation application states: FOUNDATION_ADOPTED
Conversation controllers: FOUNDATION_ADOPTED_LOCALLY
Canonical providers: FOUNDATION_ADOPTED_LOCALLY
Operation-intent retry coordination: FOUNDATION_ADOPTED_LOCALLY
Inactive Product composition: FOUNDATION_ADOPTED_FOR_LOCAL_VALIDATION
Canonical Product screen: NOT IMPLEMENTED
Canonical Product routes: NOT IMPLEMENTED
Product shell activation: NOT IMPLEMENTED
Legacy consumer migration: NOT STARTED
Remote: NOT IMPLEMENTED
```

G0-G6 are complete locally after all specified validation passes. G7 is complete
only after the explicit package commit and push. G8-G10 are not authorized.

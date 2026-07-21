# FOUNDATION-017 Product Conversation post-activation hardening

## Status and baseline

```text
FOUNDATION-017: IMPLEMENTED_LOCALLY
Baseline: e245cdc refactor: remove legacy chat runtime
Discovery baseline: 7f747e0cf60012ce315216a5486db3c5481f8f60
Product Conversation local activation: HARDENED_AND_AUDITED
```

The worktree was clean and synchronized with `origin/main` before execution.
The package changes no backend, schema, transitional DTO, dependency, platform,
remote environment or AI capability.

## Flows and state audit

The local authenticated flow covers `/stasis`, list, active/archived filters,
refresh, pagination, detail/deep link, send, same-intent retry, archive,
restore and safe back navigation. Router tests cover unauthenticated redirects,
blocked environments, opaque not-found behavior, unknown `/chat` paths and
blocked Orchestrator entry points. Controller tests cover backend unavailable,
contract violations, stale generations, disposal, duplicate operations and
draft edits during requests.

Refresh and pagination failures now retain previously loaded list/history and
surface a retry banner. Send preserves history. Pagination and lifecycle
buttons disable while active, late generations are ignored, and controller
providers remain `autoDispose`.

Empty copy remains honest for active, archived and message-empty states. It
does not imply live specialists, AI responses, Stasis Engine or future Product
capabilities.

## Safe observability contract

`ConversationObservabilitySink` is a closed, provider-neutral local contract.
The runtime provider uses `NoOpConversationObservabilitySink`; an in-memory sink
exists only in test support and has no persistence. There is no debug, remote,
network, file or analytics sink.

Approved event vocabulary:

```text
routeEntered, routeBlocked, authenticationRequired
conversationListRequested, conversationListSucceeded, conversationListFailed
conversationReadRequested, conversationReadSucceeded, conversationReadFailed
messageSendRequested, messageSendSucceeded, messageSendReplayed, messageSendFailed
conversationArchived, conversationRestored
paginationRequested, paginationCompleted
contractViolationDetected, environmentBlocked
```

The only representable fields are closed enums for event, stable route ID,
category, safe result, environment, Product surface, duration bucket,
item-count bucket, retry class and safe error. The contract contains no
free-form `String` or `Map` payload. It cannot carry message/draft/title
content, identity, email, token, operation attempt, idempotency key, raw
ConversationId, specialist ID, provider payload, exception, stack or SQL.

Duration uses monotonic `Stopwatch` values and these local buckets:

```text
under100Milliseconds
under500Milliseconds
under2Seconds
twoSecondsOrMore
```

Item buckets are `zero`, `oneToTwenty`, `twentyOneToOneHundred` and
`overOneHundred`. Safe result categories include request, success, empty,
replay and the approved sanitized application failures. These are local
diagnostic categories, not network performance claims.

Application controllers own list/read/send/lifecycle/pagination outcome
instrumentation. Widgets do not emit events, so rebuilds cannot duplicate
operation events. The router records only stable `stasis`, `conversations` or
`conversationDetail` IDs. An unknown legacy chat path emits `routeBlocked`
without its path or parameter.

Same-intent retry is classified as `messageSendReplayed` without exposing the
attempt. Content length and fingerprints are deliberately not collected.

## Lifecycle, race and pagination findings

- stale filters and Conversation generations cannot overwrite current state;
- duplicate send, pagination and lifecycle actions have one logical effect;
- send success clears only the matching draft;
- same-intent retry preserves the private operation attempt in the controller;
- idempotency conflict remains explicit and is not silently retried;
- duplicate conversation/message IDs are deduplicated in backend order;
- pagination failure preserves items and cursor for a safe retry;
- archived history remains visible and archived send stops before repository;
- disposal invalidates generations and the runtime sink accumulates nothing;
- there is no retained BuildContext or new global mutable cache.

## Accessibility and interaction audit

```text
ACCESSIBILITY_AUDITED_LOCALLY
FULLY_WCAG_CERTIFIED: NO
Critical findings open: 0
High findings open: 0
```

Headings/titles, filter labels, list-item status, author/timestamp message
labels, redaction, composer/send, archive/restore, loading and errors are
semantic. Error announcements no longer hide the retry control from assistive
technology. Conversation rows exclude duplicate descendant announcements.
Controls use Material focus/keyboard behavior and the send target remains at
least 48 by 48 logical pixels. `TextInputAction.send` preserves the existing
explicit Enter send behavior; no new ambiguous shortcut was introduced.

Text scale and representative widths are covered at 1.0 and 2.0, with existing
1.3-compatible flexible Material layouts. Narrow-width bubbles no longer force
a 240-pixel minimum when a real viewport is smaller. Long content, 320-pixel
mobile and 1200-pixel desktop fixtures render without overflow. Full manual
screen-reader, contrast and browser focus certification remains a release
activity, not a claim of this local package.

| Finding | Severity | Component | Evidence | Fix | Status | Release impact |
|---|---|---|---|---|---|---|
| Retry action hidden by merged excluded semantics | medium | Error state | Widget semantics audit | Separate live announcement from actionable button | CLOSED | None |
| Bubble minimum wider than very narrow viewport | low | Message bubble | Narrow responsive test | Clamp to actual viewport with zero-size test fallback | CLOSED | None |
| Formal WCAG/manual assistive-tech audit absent | informational | Product flow | Scope review | Required before production readiness | OPEN | Blocks certification claim, not local readiness |

## Performance and rebuild evidence

Measurements are local regression baselines, not production SLOs.

| Scenario | Fixture | Method | Observed result | Local threshold | Status | Limitation |
|---|---:|---|---|---|---|---|
| List and detail lazy rendering | 100 conversations / 200 messages | Warm focused `flutter test` timed process | PASS; 9.56 s total process wall time | No overflow/error and not all rows eagerly built | PASS | Includes Flutter startup/compilation |
| Long message responsive render | long synthetic content, 320/1200 px, 2.0 scale | Widget test | PASS | No render exception | PASS | Synthetic local UI only |
| Full Flutter regression | 620 tests / 5 skips | `flutter test` | PASS in approximately 40 s warm observed runner output | Zero failures and no new skips | PASS | Host/runner dependent |

`ListView.builder` keeps representative lists lazy. Composer keystrokes update
the composer subtree/controller state; no event originates from rebuilds. No
complex rebuild optimization was justified by the local evidence.

## Soak, guards and tests

Deterministic tests cover fifty filter switches, twenty rapid submits with one
effect, twenty same-intent failure/retry cycles and twenty archive/restore
cycles. Existing tests cover stale filters/generations, disposal and replay; representative
100/200 fixtures exercise lazy rendering. No sleeps, real clock, network or
real data are used.

The observability contract guard rejects free-form fields structurally. Route,
architecture and copy guards continue preventing legacy `/chat`, Orchestrator
fallback, provider errors and AI claims. A scoped log audit found no `print`,
`debugPrint`, logger or log calls in the changed runtime/test boundary. Matches
for content, draft, attempt, token, authorization and ConversationId are typed
domain/application uses or explicit negative test assertions, not logs.

The canonical route widget flow acts as the local integration test for
authenticate, Stasis, list/detail, send, archive/restore and safe back. Separate
tests cover replay, blocked environment, unauthenticated redirect, opaque
not-found and unknown legacy route. No remote integration test was added.

## Validation

```text
flutter analyze --no-fatal-infos: 0 errors, 36 inherited infos
flutter test: 620 pass, 5 approved skips, 0 failures
deno fmt --check supabase/functions: 62 files
deno test --allow-env supabase/functions: 86/86 pass
supabase db reset --local --no-seed: PASS (one cycle)
supabase test db --local: 740/740 pass
```

Operational local thresholds are: one logical effect per intent, bounded
controller state, no route loop, zero sensitive observability fields, zero
critical/high accessibility findings, zero Flutter failures, zero analyzer
errors and no new skips.

## Security, remote readiness and rollback

No content, drafts, operation attempts, idempotency keys, tokens, owner IDs,
raw resource IDs, provider errors or persistent tracking identifiers are
observed. There is no remote sink, analytics dependency, legacy route,
Orchestrator fallback, backend/schema change, remote action, secret, AI or
Stasis Engine behavior.

```text
REMOTE_OBSERVABILITY: NOT_AUTHORIZED
STAGING_ACTIVATION: NOT_AUTHORIZED
PRODUCTION_ACTIVATION: NOT_AUTHORIZED
AI: NOT_IMPLEMENTED
```

Rollback is `git revert` of the FOUNDATION-017 commit. The runtime then returns
to the FOUNDATION-016 baseline; no remote or data rollback exists because none
was changed.

Residual debt is the formal manual accessibility audit, production performance
baselines, remote environment readiness, encapsulated transitional transport,
and unimplemented Product catalog/AI/Engine capabilities. None is silently
activated here.

```text
PRODUCT CONVERSATION_POST_ACTIVATION_HARDENED_LOCAL_AND_PUSHED
```

The readiness string becomes final only after G7 push succeeds.

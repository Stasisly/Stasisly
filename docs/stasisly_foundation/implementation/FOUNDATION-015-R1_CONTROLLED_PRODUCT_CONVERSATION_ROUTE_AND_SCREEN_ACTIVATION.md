# FOUNDATION-015-R1 Controlled Product Conversation route and screen activation

## Status and scope

```text
FOUNDATION-015: IMPLEMENTED_LOCALLY
Remote: NOT IMPLEMENTED
Staging: NOT AUTHORIZED
Production: NOT AUTHORIZED
AI response: NOT IMPLEMENTED
Stasis Engine: NOT IMPLEMENTED
Specialist response: NOT IMPLEMENTED
```

The original package stopped before changes because the active router was
outside its allowlist. R1 added `lib/core/config/**`, `lib/core/routing/**` and
their tests. No second router was created.

## Router audit

`routerProvider` in `lib/core/config/routes.dart` remains the sole router. It
watches environment and secure-session state, resolves metadata through
`EntryPointRegistry`, evaluates surface/environment/authentication before page
construction, records minimized denied-boundary evidence, renders safe unknown
routes, retains blocked legacy entries and conditionally registers existing
non-release Development chat tools.

The authenticated Product initial location is now `/stasis`. Unauthenticated
Product deep links redirect to approved onboarding. Authenticated visits to
public Product auth entries redirect to `/stasis`. Direct canonical detail links
pass the same gates; invalid, foreign and unknown IDs converge on opaque
not-available behavior.

## Canonical route metadata

| Route | Surface | Environments | Auth | Resource | Classification | Backend authority |
|---|---|---|---|---|---|---|
| `/stasis` | Product | local, development | required | Product entry | canonical Product | no resource ownership |
| `/conversations` | Product | local, development | required | Conversation collection | canonical Product | required |
| `/conversations/:conversationId` | Product | local, development | required | Conversation | canonical Product | required |

Router authorization requirement is explicit and does not infer ownership.
Canonical repositories and the backend remain the PDP/PEP/ownership authority.
No owner, author, role, surface or environment is accepted from route state.

## Product screens and shell

`StasisPage` is the central Product entry, not an AI or Engine claim. It opens
the canonical list and accurately states that automatic responses are inactive.
Because the approved selectable-specialist provider remains backend-blocked,
creation is safely unavailable and no `agent.id`, specialist internal ID or
invented reference is used.

`ConversationsPage` uses the canonical list controller/state with active default,
archived filter, refresh, bounded load-more, safe loading/empty/error states and
`ConversationId` navigation. Items expose only safe title, public specialist
summary, status and update date.

`ConversationPage` uses canonical detail, message mapper and presentation
widgets. It supports history, redaction, bounded older-message loading,
content-only user send, archive and restore. Archive preserves history and
disables the composer; restore re-enables it without creating or sending
anything. Unknown/internal messages remain non-renderable. Empty copy states
that automated Stasis/specialist responses are inactive.

The existing Product shell now has Stasis plus Health, Nutrition, Physical
Training and Mental Training. Conversations share the Stasis destination. Back
navigation returns to the list, with `/conversations` as deep-link fallback.

## Isolation and compatibility

- `InactiveConversationFeatureHost` remains test-only and unrouted.
- The four Product area cards remain non-actionable without a verified
  `selectableSpecialistId`.
- `/chat/:id`, `/orchestrator` and `/orchestrator/chat` remain legacy-blocked.
- Orchestrator files were not modified and no legacy redirect exists.
- Product screens import no legacy chat, Supabase, Dio or HTTP API.
- `OperationAttemptId` remains controller-owned and transport idempotency stays
  unchanged.
- Public DTOs, backend, SQL, Edge Functions, dependencies and platform files are
  unchanged.

## Accessibility and responsive behavior

Screens provide titles/headings, semantic filters/items/messages/actions, live
loading/error announcements, labelled composer/send controls and text status in
addition to color. Content uses scrollable/constrained layouts, bounded message
width and existing adaptive Material navigation for mobile, tablet and web.

## Guards, tests and integration

Guards verify explicit metadata, Product surface, local/development-only
activation, authenticated detail, strict `conversationId` parsing, no authority
extras, no legacy fallback/provider/import, no inactive host route and `/stasis`
as initial Product entry. Widget coverage includes Stasis truthfulness, list
filters/navigation, message rendering/redaction, send, archive/restore, opaque
missing state and blocked-environment non-loading.

The local integration fixture authenticates a synthetic user, enters Stasis,
opens list/detail, sends exactly one user message, observes no automatic reply,
archives, verifies preserved history/disabled composer, restores, returns to the
active list and disposes its in-memory fixture. No network or real data is used.

Validation evidence is recorded in the Foundation tracker: Flutter 615 pass
with 5 approved skips, analyzer 0 errors with 51 inherited infos, Deno 86/86
and local SQL 740/740. Deno and SQL are regressions only; no backend file is
modified.

## Security review

One router remains active. Content is not built before route gates. Environment
and authentication fail closed without demo fallback. `ConversationId` is not
authority, owner never comes from navigation, not-found remains opaque, and no
secret, fake AI, automatic response, remote operation or production activation
was introduced.

## Rollback and residual debt

Rollback is the route/page/shell/test/document reversal described by ADR-F018;
no data rollback applies. Residual debt: physical chat session/message adapters,
the frozen legacy chat implementation, blocked orchestrator consumer, absent
selectable Product catalog runtime, absent AI responses and absent remote
activation. The next separately approved package is FOUNDATION-016 physical
legacy chat removal and reference eradication.

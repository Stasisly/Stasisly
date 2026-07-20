# Legacy Chat Retirement Plan

## FOUNDATION-013F-R1 checkpoint

R1 closes stable create/send attempt propagation without touching
`lib/features/chat/**`, legacy routes or Product consumers. It is a prerequisite
repair only: L4-L7 and physical removal remain blocked until FOUNDATION-013F
composition, parity and later route gates are separately completed.

## FOUNDATION-013E execution checkpoint

L1 freeze/guard is COMPLETE and the audited L2 reusable visual subset is
COMPLETE. Canonical message/composer/state primitives are route-free and have no
legacy imports. No Product consumer migrated: L4-L7 remain NOT STARTED and the
blocked orchestrator import remains explicit removal debt.

## FOUNDATION-013D checkpoint

Canonical Message semantics now fail closed over the transitional transport.
This did not unfreeze or reconnect legacy chat. FOUNDATION-013E subsequently
extracted and guarded only the audited visual subset.

## Metadata

```text
Status: APPROVED plan
Implementation: L0-L3 COMPLETE LOCALLY; L4-L7 NOT STARTED
Owner: Product + Flutter + Backend Architecture
Approver: Founder
```

## Formal decision

```text
lib/features/chat/** = DEPRECATED_AND_BLOCKED
```

The feature cannot receive new Product work, routes, fallback, direct Supabase
Product use, client role/owner authority or Engine reuse. Existing source is
retained only as frozen evidence until replacement and removal gates pass.

`/chat/:id` remains a blocked legacy route whose `id` was an `agentId`; it is
never a `sessionId` or `conversationId`. `/orchestrator` and
`/orchestrator/chat` remain blocked and are not Stasis Engine.

## Reuse policy

Repositories, datasources, providers, entities, use cases and controllers from
legacy chat are not reusable Product contracts. UI reuse is selective:

- `MessageBubble`: `ADAPT_CANDIDATE` only after decoupling from legacy roles and
  entity types;
- `ChatInput`: `REWRITE_CANDIDATE` because it carries mock attachments and an
  attachment-bearing callback incompatible with content-only MVP;
- `ChatPage` and `AgentChatWrapper`: `REWRITE_CANDIDATE` because `agentId`
  controls session selection;
- colors, spacing and generic interaction patterns: reference through the
  existing design system, not copied as hidden legacy dependencies.

## Retirement phases

| Phase | Work | Exit evidence |
|---|---|---|
| L0 Already blocked | Preserve current route/runtime blocking | Architecture tests prove no active legacy capability |
| L1 Freeze and guard | Add no-new-import/route/provider guards | Explicit reference allowlist and negative tests |
| L2 Extract reusable UI | Adapt only approved visual components | New domain-neutral widgets, accessibility and widget tests |
| L3 Build canonical boundary | Implement Conversation contracts/adapters | Owned API, canonical IDs, authz and contract tests |
| L4 Migrate consumers | Move Product consumers without fallback | Product flow parity and observability evidence |
| L5 Remove routes/providers | Remove legacy route declarations and provider wiring | Navigation/reference tests and rollback plan |
| L6 Remove legacy code | Delete frozen feature after all consumers leave | Clean build/tests, migration/data compatibility confirmed |
| L7 Verify no references | Static/runtime/security verification | Repository scan empty except archive/retirement evidence |

FOUNDATION-012 executes none of these phases.

FOUNDATION-013A begins L3 locally by implementing canonical contracts, adapters
and guards. L3 is not closed because canonical backend API contracts and Product
wiring remain absent. L0 remains enforced; no legacy source, route or runtime
was modified, reused or removed.

## Mandatory gates

Removal requires all of:

```text
Founder-approved Product decision
canonical replacement implemented
test and accessibility parity
data/API compatibility or migration evidence
security and privacy review
rollback without legacy reactivation
no Product imports or route references
no remote/production change hidden in cleanup
```

Rollback during L1-L7 disables the new entry point or reverts its package; it
never reconnects direct Supabase chat, client-supplied role/owner or blocked
legacy routes.

## Derived implementation sequence

The approved master ID `FOUNDATION-013` remains the first controlled Product
conversation slice. It is decomposed, without renumbering FOUNDATION-014-020:

```text
FOUNDATION-013A  canonical Product Conversation contracts and adapters [LOCAL COMPLETE]
FOUNDATION-013B  transactional Conversation creation and TOCTOU/idempotency [LOCAL COMPLETE]
FOUNDATION-013C  Conversation listing, read, archive and restore boundary [LOCAL COMPLETE]
FOUNDATION-013D  Message author, visibility and provenance contracts [LOCAL COMPLETE]
FOUNDATION-013E  legacy UI extraction, freeze guards and retirement migration [LOCAL COMPLETE]
FOUNDATION-013F  canonical application layer and inactive Product composition
```

Each child requires separate approval and G0-G7. FOUNDATION-014 remains Agent
Constitution/Engine design; FOUNDATION-015-020 retain their approved meanings.
Remote/staging remains G8+ and outside all local child packages unless separately
authorized.

FOUNDATION-013B advances L3 only: it replaces direct create/send orchestration
with trusted transactional RPC boundaries and retry contracts. It does not
activate a replacement UI or route, so no legacy source may yet be removed.

FOUNDATION-013C advances L3 with owner-scoped lifecycle/history boundaries and
read/restore adapters. It does not activate Product UI/routes or prove Message
author/provenance parity, so L4-L7 and all legacy removal remain blocked.

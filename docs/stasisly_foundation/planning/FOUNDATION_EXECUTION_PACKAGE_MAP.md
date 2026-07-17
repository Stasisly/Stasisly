# Foundation Execution Package Map

## Authority and sequencing

Status: **APPROVED working execution structure**. Package status is recorded
below; every future package requires its own approval and exact scope.

Package status after FOUNDATION-013E:

```text
FOUNDATION-007: COMPLETED CONCEPTUALLY / IMPLEMENTATION NOT STARTED
FOUNDATION-008: IMPLEMENTED LOCALLY / PROVIDER ADAPTER CURRENT
FOUNDATION-009: IMPLEMENTED LOCALLY / FULL ENFORCEMENT PARTIAL
FOUNDATION-010: IMPLEMENTED LOCALLY / PUBLISHED
FOUNDATION-011: IMPLEMENTED LOCALLY / PUBLICATION COMPLETES G7
FOUNDATION-012: COMPLETED CONCEPTUALLY / IMPLEMENTATION NOT STARTED
FOUNDATION-013A: IMPLEMENTED LOCALLY / PUBLICATION COMPLETES G7
FOUNDATION-013B: IMPLEMENTED LOCALLY / PUBLICATION COMPLETES G7
FOUNDATION-013C: IMPLEMENTED LOCALLY / PUBLICATION COMPLETES G7
FOUNDATION-013D: IMPLEMENTED LOCALLY / PUBLICATION COMPLETES G7
FOUNDATION-013E: IMPLEMENTED LOCALLY / PUBLICATION COMPLETES G7
FOUNDATION-013F: NOT EXECUTED
FOUNDATION-014..020: NOT EXECUTED
```

| Package | Title | Type | Objective | Dependencies | Gate | Expected result |
|---|---|---|---|---|---|---|
| FOUNDATION-007 | Technical authorization and threat model | DOCUMENTATION / SECURITY | Define identity/action/resource/context, RBAC/ABAC/JIT, ownership, service identities, Founder elevation and audit events | R1, ADR-F003 | G0-G2 satisfied conceptually; no implementation | ADR-F004, approved conceptual models and active security matrices |
| FOUNDATION-008 | Owned identity, session and API contracts | IMPLEMENTATION / ARCHITECTURE | Separate identity, authentication, authorization, ownership and session; own DTO/error contracts and confine provider SDK | FOUNDATION-007 | G0-G7 completed after publication | Provider-neutral ports and local adapters implemented; no authorization or remote activation |
| FOUNDATION-009 | Authorization context and policy contracts | IMPLEMENTATION / SECURITY | Adopt typed authorization context/decision, PDP/PEP/audit ports and minimal local deny-by-default validation | FOUNDATION-007, FOUNDATION-008 | G0-G7 completed after publication | Local contracts/policy and focal profile defense; no new access or remote enforcement |
| FOUNDATION-010 | Surface and environment enforcement boundaries | IMPLEMENTATION / SECURITY | Apply explicit Product/Development/Administration and environment boundaries to approved routes/APIs/operations without Founder elevation or remote | FOUNDATION-009 | G0-G7 completed after publication | Typed local boundaries, negative navigation evidence and legacy-route containment; no backend/remote authority |
| FOUNDATION-011 | Backend authorization context and owned API enforcement | IMPLEMENTATION / SECURITY | Carry typed surface/environment, identity and ownership through owned backend entry points without remote deployment | FOUNDATION-009, FOUNDATION-010 | G0-G7 complete after publication | Six locally enforced registered Product operations, negative authorization evidence and unchanged public DTOs; no deployment |
| FOUNDATION-012 | Product Conversation architecture and legacy chat retirement | DOCUMENTATION / PRODUCT | Decide canonical Conversation semantics, Stasis/specialist boundaries, target routes, lifecycle, memory/research separation and legacy retirement | FOUNDATION-007-011 | G0-G2 complete after publication | ADR-F009, seven approved Product documents and no implementation |
| FOUNDATION-013 | First controlled Product Conversation slice | IMPLEMENTATION parent | Implement the approved catalog-to-Conversation-to-Message flow through separately approved 013A-013F children | FOUNDATION-011, FOUNDATION-012 | G0-G7 per child; no remote | Tested local Product increment, retirement progress and accepted residual debt |
| FOUNDATION-014 | Agent Constitution and Engine foundation | DOCUMENTATION / ARCHITECTURE / SECURITY | Define Agent Constitution, registries, runtime/gateway modules, evaluation and safety boundaries | FOUNDATION-007, FOUNDATION-009 | Founder Agent gate; G0-G2 | Approved modular Engine design; no agents or runtime activated |
| FOUNDATION-015 | Backend security CI baseline | IMPLEMENTATION | Add Deno, pgTAP, reset, migration, architecture and secret checks to CI | FOUNDATION-007 contracts stable | G0-G7 | Reproducible protected local/security pipeline before staging |
| FOUNDATION-016 | Data/privacy lifecycle and threat controls | DOCUMENTATION / SECURITY | Define classification, consent, retention, deletion, provenance, encryption and regional controls | FOUNDATION-007, FOUNDATION-012 | Founder privacy gate; G0-G2 | Approved lifecycle model and testable controls before sensitive Product data |
| FOUNDATION-017 | Observability, limits and cost accounting foundation | IMPLEMENTATION / ARCHITECTURE | Add safe metrics contracts, audit outcomes, rate/usage limits and budget foundations | FOUNDATION-007, FOUNDATION-015; Engine costs also need 014 | G0-G7 | Local measurable controls without providers, billing or sensitive logs |
| FOUNDATION-018 | Dependency, portability and exit audit | AUDIT | Map Supabase/Firebase/Sentry/dependencies, adapter gaps, licenses, export and exit triggers | FOUNDATION-008, FOUNDATION-015 | G0-G2 | Evidence-based keep/adapt/remove proposals; no provider migration |
| FOUNDATION-019 | Administration and Development surface plan | DOCUMENTATION | Define minimal Gerendi/Rector tooling, Founder view and audited development workflows | FOUNDATION-007, FOUNDATION-009, FOUNDATION-014 as applicable | Founder surface gate; G0-G2 | Approved bounded capabilities; no full surface implementation |
| FOUNDATION-020 | Staging readiness audit | AUDIT / SECURITY | Verify P2 closure, synthetic-data policy, CI, threat model, runbooks, costs and rollback | FOUNDATION-015-019 as applicable | G0-G7 only; G8 requires new approval | Staging go/no-go recommendation, no remote action |

## Package rules

1. No future package is approved merely by appearing here.
2. Local implementation packages include tests, documentation, commit and push
   unless their approved scope explicitly separates an irreversible action.
3. Remote changes, production, real data, secrets, elevation, billing and
   destructive migrations receive independent packages and G8-G10 gates.
4. A package stops when an unapproved file, authority decision or remote
   dependency becomes necessary.
5. FOUNDATION-013A-013D implement canonical Product Conversation contracts and
   local backend boundaries. FOUNDATION-013E implements inactive presentation
   primitives and legacy freeze. 013F remains separately gated; routes,
   physical legacy deletion and remote remain excluded.

## FOUNDATION-013 child sequence

| Child | Scope | Explicit exclusions |
|---|---|---|
| 013A | Canonical Product Conversation contracts and adapters — IMPLEMENTED LOCALLY | No routes, schema or legacy deletion |
| 013B | Transactional creation, TOCTOU and create/send idempotency — IMPLEMENTED LOCALLY | No remote migration |
| 013C | List/read/archive/restore/history boundary — IMPLEMENTED LOCALLY | No Product route registration |
| 013D | Message author, visibility and provenance contracts - IMPLEMENTED LOCALLY | No Engine trace exposure |
| 013E | Legacy UI extraction, freeze guards and retirement migration - IMPLEMENTED LOCALLY | No removal before parity/data gates |
| 013F | Canonical Conversation application layer and inactive Product composition | No Product route registration or staging/production activation |

These are children of the existing FOUNDATION-013 ID. They do not renumber or
replace FOUNDATION-014-020 and each requires a separate approval.

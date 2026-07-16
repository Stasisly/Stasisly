# Foundation Execution Package Map

## Authority and sequencing

Status: **APPROVED working execution structure**. Package status is recorded
below; every future package requires its own approval and exact scope.

Package status after FOUNDATION-011:

```text
FOUNDATION-007: COMPLETED CONCEPTUALLY / IMPLEMENTATION NOT STARTED
FOUNDATION-008: IMPLEMENTED LOCALLY / PROVIDER ADAPTER CURRENT
FOUNDATION-009: IMPLEMENTED LOCALLY / FULL ENFORCEMENT PARTIAL
FOUNDATION-010: IMPLEMENTED LOCALLY / PUBLISHED
FOUNDATION-011: IMPLEMENTED LOCALLY / PUBLICATION COMPLETES G7
FOUNDATION-012..020: NOT EXECUTED
```

| Package | Title | Type | Objective | Dependencies | Gate | Expected result |
|---|---|---|---|---|---|---|
| FOUNDATION-007 | Technical authorization and threat model | DOCUMENTATION / SECURITY | Define identity/action/resource/context, RBAC/ABAC/JIT, ownership, service identities, Founder elevation and audit events | R1, ADR-F003 | G0-G2 satisfied conceptually; no implementation | ADR-F004, approved conceptual models and active security matrices |
| FOUNDATION-008 | Owned identity, session and API contracts | IMPLEMENTATION / ARCHITECTURE | Separate identity, authentication, authorization, ownership and session; own DTO/error contracts and confine provider SDK | FOUNDATION-007 | G0-G7 completed after publication | Provider-neutral ports and local adapters implemented; no authorization or remote activation |
| FOUNDATION-009 | Authorization context and policy contracts | IMPLEMENTATION / SECURITY | Adopt typed authorization context/decision, PDP/PEP/audit ports and minimal local deny-by-default validation | FOUNDATION-007, FOUNDATION-008 | G0-G7 completed after publication | Local contracts/policy and focal profile defense; no new access or remote enforcement |
| FOUNDATION-010 | Surface and environment enforcement boundaries | IMPLEMENTATION / SECURITY | Apply explicit Product/Development/Administration and environment boundaries to approved routes/APIs/operations without Founder elevation or remote | FOUNDATION-009 | G0-G7 completed after publication | Typed local boundaries, negative navigation evidence and legacy-route containment; no backend/remote authority |
| FOUNDATION-011 | Backend authorization context and owned API enforcement | IMPLEMENTATION / SECURITY | Carry typed surface/environment, identity and ownership through owned backend entry points without remote deployment | FOUNDATION-009, FOUNDATION-010 | G0-G7 complete after publication | Six locally enforced registered Product operations, negative authorization evidence and unchanged public DTOs; no deployment |
| FOUNDATION-012 | Product taxonomy and conversation decisions | DOCUMENTATION / PRODUCT | Decide Wellness/Training naming, catalog, profile, conversation route, entitlements and view boundaries | FOUNDATION-007-009 | Founder Product gate; G0-G2 | Approved Product ADRs and bounded first vertical slice |
| FOUNDATION-013 | First controlled Product conversation slice | IMPLEMENTATION | Implement the approved catalog-to-session-to-message flow with privacy and accessibility states | FOUNDATION-011, FOUNDATION-012 | G0-G7; no remote | Tested local Product increment, rollback route and accepted residual debt |
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
5. FOUNDATION-012 is next after FOUNDATION-011 publication. It must decide
   Product taxonomy, conversation API boundaries and legacy retirement before
   FOUNDATION-013; it requires separate approval and begins without code.

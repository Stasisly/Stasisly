# Foundation Execution Package Map

## Authority and sequencing

Status: **APPROVED working execution structure**. Package status is recorded
below; every future package requires its own approval and exact scope.

Package status after FOUNDATION-007:

```text
FOUNDATION-007: COMPLETED CONCEPTUALLY / IMPLEMENTATION NOT STARTED
FOUNDATION-008..020: NOT EXECUTED
```

| Package | Title | Type | Objective | Dependencies | Gate | Expected result |
|---|---|---|---|---|---|---|
| FOUNDATION-007 | Technical authorization and threat model | DOCUMENTATION / SECURITY | Define identity/action/resource/context, RBAC/ABAC/JIT, ownership, service identities, Founder elevation and audit events | R1, ADR-F003 | G0-G2 satisfied conceptually; no implementation | ADR-F004, approved conceptual models and active security matrices |
| FOUNDATION-008 | Owned identity, session and API contracts | DOCUMENTATION / ARCHITECTURE | Separate identity, authentication, authorization, ownership and session; version public DTO/error contracts | FOUNDATION-007 | G0-G2 | Stable provider-neutral ports ready for local implementation |
| FOUNDATION-009 | Legacy route containment and surface guards | IMPLEMENTATION / SECURITY | Remove Product reachability to legacy writes and enforce explicit Product/Development route contexts | FOUNDATION-007, FOUNDATION-008 | G0-G7 | Local guards/tests prove no legacy or cross-surface Product path |
| FOUNDATION-010 | Local identity/auth adapter boundary | IMPLEMENTATION | Place current provider behavior behind mockable owned ports without remote activation | FOUNDATION-008 | G0-G7 | Local adapter contract tests; no public token state or demo fallback |
| FOUNDATION-011 | Sessions/messages owned API adoption | IMPLEMENTATION | Adapt modern contracts behind owned API, preserving explicit IDs, ownership and atomic messaging | FOUNDATION-009, FOUNDATION-010 | G0-G7 | Local end-to-end safe flow with no legacy chat or direct Product Supabase |
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
5. FOUNDATION-007 is next because authorization vocabulary blocks identity,
   surface isolation, Product promotion, Administration and Engine safety.

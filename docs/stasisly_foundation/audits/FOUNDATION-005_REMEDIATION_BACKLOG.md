# FOUNDATION-005 Remediation Backlog

Status: **ACTIVE tracking**. P0 was separately authorized and is
`CLOSED_LOCALLY`; P1-P4 remain proposed and unauthorized.

## P0 — Foundation blocker or critical security risk

| Issue | Evidence | Risk | Assets | Foundation decision | Recommended package | Acceptance criteria | Dependencies |
|---|---|---|---|---|---|---|---|
| Legacy public tables are not deny-all — `CLOSED_LOCALLY` | R1 local evidence: 10 tables have RLS active, zero policies, zero client CRUD grants and retained `service_role` CRUD | Remote state remains unverified; regression risk remains without backend CI | Migration 00009 and R1 pgTAP suites | Deny by default; explicit ownership; no inherited total access | `FOUNDATION-005-R1 — Harden legacy public tables deny-all` completed locally | Two clean local resets; 649 SQL, 52 Deno and 406 Flutter tests pass; no remote action | Remote rollout requires separate approval; CI remains P2 |

The package must not redesign schemas, rename `orchestator_summaries`, add
Product behavior or touch a remote project.

## P1 — Required before new Product implementation

| Issue | Evidence | Risk | Recommended package / acceptance |
|---|---|---|---|
| No Stasisly-owned identity/API boundary | Supabase initialized in bootstrap and legacy auth | Provider lock-in and confused authority | Identity/API boundary plan; client depends on owned interfaces and fails closed. |
| Legacy chat is reachable | `/chat/:id`, `/orchestrator/chat`, direct Supabase and client `role` | Authority bypass and unsafe route semantics | Legacy containment/deprecation package; no Product entry reaches legacy writes. |
| Surface authorization model absent | No RBAC/ABAC/JIT/Founder/surface context | Cross-surface privilege ambiguity | Authorization design ADR before implementation. |
| Modern chat not Product-ready | Dev-only adapters/routes and incomplete auth | Premature promotion of local-safe code | Controlled adoption plan preserving explicit `sessionId` and DTO allowlists. |
| Create/archive lack transaction/idempotency contracts | Multi-request create; direct conditional archive | TOCTOU and duplicate-request behavior | Domain/API decision package with explicit semantics and concurrency tests. |
| Orchestrator could be mistaken for Engine | Static Product UI at orchestrator routes | Architectural misrepresentation | Deprecation/rewrite decision; prohibit Engine naming/reuse. |

## P2 — Required before staging

| Issue | Evidence | Risk | Recommended package / acceptance |
|---|---|---|---|
| Backend tests absent from CI | CI runs Flutter only | Security regressions merge unnoticed | CI plan runs Deno, local migration reset and pgTAP in isolation. |
| Catalog/profile adapters incomplete | Backend-blocked or provider transport | Inconsistent Product integration | Owned API adapters with contract/integration tests. |
| Legacy environment vocabulary | `backendReal` coexists with Foundation environments | Misconfiguration | Environment ADR/migration with fail-closed compatibility period. |
| Dependency set not baselined | Multiple zero-import candidates | Supply-chain and maintenance cost | Dependency/license/use audit; remove only with evidence. |
| Naming/domain mismatch | mental/physical training routes | Product and data taxonomy drift | Product/architecture decision before rename or migration. |

## P3 — Required before production

| Issue | Evidence | Risk | Recommended package / acceptance |
|---|---|---|---|
| Privacy lifecycle incomplete | No complete retention/deletion/provenance controls | Sensitive-data and compliance risk | Data lifecycle/threat-model package with owners and tests. |
| Rate limits and quotas absent | No limiter in six functions | Abuse and unbounded cost | Backend controls with measurable limits and safe failure. |
| Observability/SLO incomplete | Safe logs only | Weak incident detection | Metrics, audit events, alerting and runbooks without sensitive logs. |
| Release supply chain incomplete | Manual unsigned build skeleton | Artifact integrity/release risk | Signed artifact, provenance and protected release workflow. |
| Platform readiness incomplete | No approved deep links/privacy/background model | Store/security regressions | Per-platform security/privacy checklist and tests. |

## P4 — Future optimization

| Issue | Evidence | Risk | Recommended package / acceptance |
|---|---|---|---|
| Wearable readiness absent | No code/contracts | Future integration cost | Define portable event/API contracts when Product scope is approved. |
| AI cost controls absent | No agent runtime | Future unbounded spend | Model Gateway budgets, quotas and attribution before runtime activation. |
| Provider exits untested | Supabase-specific runtime | Migration uncertainty | Adapter contract tests and recovery/export rehearsals after F7. |

## Gate

`FOUNDATION-005-R1` is complete and the P0 is `CLOSED_LOCALLY`. FOUNDATION-006
may now be proposed as the plan maestro de remediación y reconstrucción técnica.
No P1-P4 implementation or remote rollout is authorized by this gate change.

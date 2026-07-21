# FOUNDATION-005 Remediation Backlog

## FOUNDATION-017 remediation evidence

The activated canonical Product flow is hardened locally: closed outcome-only
observability, NoOp runtime, partial-data preservation, deterministic
race/replay/lifecycle tests, responsive fixtures and accessibility findings
with zero open critical/high severity. Remote telemetry, production and future
AI capabilities remain blocked rather than represented as complete.

## FOUNDATION-016-R1 remediation evidence

The P1 legacy chat runtime is physically removed after deleting its sole dead
Orchestrator source consumer. `/chat/:id`, direct Supabase/demo code and legacy
authority models are absent; the static gate reports zero runtime references.
Canonical Conversation remains sole Product architecture, while approved
transitional session/message infrastructure remains encapsulated.

## FOUNDATION-015-R1 evidence update

Canonical local Product routes/screens and user-message lifecycle are adopted.
Legacy route execution remains blocked; physical chat/reference eradication is
carried forward to FOUNDATION-016. No backend, schema, remote or AI scope was
added.

## FOUNDATION-014-R1 remediation evidence

Product legacy Conversation consumers are retired locally: Health, Nutrition,
Physical Training and Mental Training no longer use `agent.id` or `/chat/:id`.
The canonical inactive composition is sole, the blocked Development orchestrator
remains isolated, and route activation is separately gated. CONV-01 remains
open only for route activation and L5-L7 physical retirement evidence.

## FOUNDATION-013F remediation evidence

The modern Conversation boundary now includes local canonical use cases,
controllers/providers and an inactive host with tested environment, concurrency
and retry guards. This partially closes the Product-readiness item; routes,
active shell, legacy migration/removal and remote evidence remain open.

## FOUNDATION-013E remediation evidence

Legacy visual reuse is remediated locally through canonical provider-neutral
components, a complete file/symbol inventory, central freeze metadata and
no-spread guards. Consumer migration, Product composition/routes and physical
removal remain open; backend and remote state are unchanged.

## FOUNDATION-013D remediation evidence

Message semantic ambiguity is remediated locally with closed metadata,
conservative backfill, RPC-only user writes and owner-scoped SQL visibility
filtering. Legacy UI retirement, Product routing, Engine and remote rollout stay
open and separately gated.

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
| No Stasisly-owned identity/API boundary - `PARTIALLY_CLOSED_LOCALLY` | FOUNDATION-008 adds owned identity/session/API context and confines Auth SDK; bootstrap and wider provider coupling remain | Residual lock-in and incomplete consumer migration | Canonical boundary complete locally; continue containment/adoption without declaring full auth adopted. |
| Legacy chat runtime - `CLOSED_LOCALLY` | FOUNDATION-016-R1 physically removes `features/chat`, `/chat/:id` and the dead Orchestrator consumer; zero runtime references | Recreation through future changes | Preserve `LEGACY_CHAT_REFERENCE_ERADICATION` and Git rollback evidence. |
| Surface authorization implementation partial | FOUNDATION-011 enforces registered Product/local-development context and trusted ownership across six Edge Functions; persistent RBAC/ABAC/JIT and other domains remain unenforced | Policy breadth and remote state remain incomplete | Continue with separately approved persistent policy and Product-boundary packages; do not weaken local backend enforcement. |
| Modern Conversation Product activation - `PARTIALLY_CLOSED_LOCALLY` | FOUNDATION-013A-016-R1 add canonical contracts/backend/message semantics/application, authenticated local Product routes/screens and physical legacy retirement; persistence adapters remain transitional | Premature remote promotion | Continue later hardening and remote gates while preserving ownership, explicit IDs, content-only send and DTO allowlists. |
| Create/send transaction/idempotency gap — `CLOSED_LOCALLY` | FOUNDATION-013B uses locked transactional RPCs and server ledger; FOUNDATION-013C adds naturally idempotent archive/restore | Remote rollout and retention still absent | Preserve deny-all and add retention/operations policy before remote writes. |
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
establishes the approved master strategy, package map and gates. FOUNDATION-007
has completed the conceptual authorization/threat model; P1 continues with a
FOUNDATION-008 identity/session/API and FOUNDATION-009 authorization-contract
packages completed locally; P1 continues with separately authorized
FOUNDATION-010 surface/environment work is completed and published locally;
FOUNDATION-011 backend authorization context and owned API work is completed
locally with Deno/HTTP/SQL/Flutter evidence and no remote action;
FOUNDATION-012 Product Conversation architecture and legacy retirement are
approved conceptually; FOUNDATION-013A canonical local contracts/adapters are
implemented, and FOUNDATION-013B closes local create/send transaction and
idempotency; FOUNDATION-013C closes local list/read/archive/restore/history with
restricted RPCs, full local regressions and HTTP cleanup at seven zeros, while
013D/013E are complete and FOUNDATION-013F-R1 closes stable client attempt
propagation;
013F application composition is implemented locally but Product activation,
legacy consumer migration and remote remain unimplemented;
P2 maps primarily to FOUNDATION-015, 018 and 020; P3 to FOUNDATION-016, 017 and
later release work; P4 remains deferred. No P1-P4 implementation or remote
rollout is authorized by this mapping.

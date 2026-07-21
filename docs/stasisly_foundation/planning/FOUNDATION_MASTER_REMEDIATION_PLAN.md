# Foundation Master Remediation Plan

## FOUNDATION-014-R1 completion

The Product consumer migration is complete locally: four legacy CTAs are safely
disabled, the canonical composition remains sole and inactive, and route
activation is ready for separate review. Physical legacy retirement and the
blocked Development orchestrator CTA remain controlled debt; G8-G10 remain
unauthorized.

## FOUNDATION-013F completion

FOUNDATION-013F implements the canonical application boundary and inactive
Product composition locally. It closes application orchestration and retry
coordination debt without activating routes, shell, legacy migration or remote.
G8-G10 and FOUNDATION-014 remain separately gated.

## FOUNDATION-013F-R1 completion

The application-to-transport idempotency gap is closed locally with explicit,
stable attempt propagation. G0-G6 are complete; publication completes G7.
FOUNDATION-013F is `IMPLEMENTED_LOCALLY`; Product routes,
remote writes and G8-G10 remain unimplemented/unauthorized.

## FOUNDATION-013E completion

G0-G6 are complete locally for canonical presentation extraction and legacy
freeze; publication completes G7. Consumer migration, Product composition,
routes and physical legacy removal remain separately gated. Rollback never
reactivates legacy fallback.

## FOUNDATION-013D completion

G0-G6 are complete locally for Message author/provenance/visibility; G7 completes
only with this package commit and push. G8-G10, Engine, routes and remote remain
blocked. Residual transitional DTO/schema debt moves to later approved work.

## Metadata

| Field | Value |
|---|---|
| Status | APPROVED |
| Package | FOUNDATION-006 |
| Owner | Director de Proyecto under Nexus; execution coordinated by Rector |
| Approver | Founder |
| Baseline | `3562083 security: harden legacy public tables deny all` |
| Scope | Controlled remediation, adoption and reconstruction planning |
| Remote operations | NOT AUTHORIZED |

## Objective and current state

This plan converts the FOUNDATION-005 audit and its P1-P4 backlog into an
ordered, testable reconstruction program. FOUNDATION-005-R1 closed the only P0
locally. The codebase remains partially conformant and no remote state is
asserted.

```text
P0: CLOSED_LOCALLY / REMOTE_NOT_APPLIED
P1-P4: OPEN / PARTIAL LOCAL REMEDIATION
Foundation reconstruction: ACTIVE LOCALLY
```

## Strategy

```text
Preserve validated invariants.
Replace unsafe boundaries.
Do not rewrite working components without evidence.
Do not preserve legacy coupling merely because tests exist.
Security and authorization precede Product expansion.
Start modular and local; extract services only from demonstrated need.
```

No asset becomes `FOUNDATION_ADOPTED` merely because this plan classifies or
schedules it. Adoption requires the gate in the asset adoption plan.

## Master sequence

| Order | Track | Dependency rule | Outcome |
|---:|---|---|---|
| 1 | A — Security and authorization | FOUNDATION-007 completed conceptually; implementation remains | Approved authorization and threat model |
| 2 | B — API and identity boundaries | Uses A policy vocabulary | Stasisly-owned identity, session and API contracts |
| 3 | C — Surface isolation | Uses A context and B boundaries | Product, Development, Administration and Engine isolation |
| 4 | G — CI security baseline | Can begin after A contracts stabilize; precedes staging | Automated Flutter, Deno, pgTAP and migration gates |
| 5 | D — Product reconstruction | Requires A-C decisions | Product taxonomy and controlled vertical slices |
| 6 | E — Stasis Engine foundation | Requires A/C and Agent Constitution | Modular Engine contracts without premature services |
| 7 | F — Administration and Development | Requires A/C; tool work also requires E | Minimal surface foundations and audited tooling |
| 8 | H — Portability and costs | Cross-cutting; implementation follows owned boundaries | Exit controls, accounting, quotas and provider maps |

Tracks may overlap only when their structural decisions are stable and their
files, owners and acceptance evidence do not conflict.

## Track A — Security and authorization foundation

**FOUNDATION-009 status:** typed authorization contracts and local policy
validation `IMPLEMENTED LOCALLY`; full enforcement remains
`PARTIALLY_IMPLEMENTED`. Persistent RBAC/ABAC/JIT, Founder elevation and remote
enforcement remain `NOT_IMPLEMENTED`.

**FOUNDATION-010 status:** route and focal provider surface/environment
boundaries are implemented and reproducibly validated locally; package
publication completes G7. Backend/global/production enforcement remains
`NOT_IMPLEMENTED`.

- **ID / title:** A — Technical authorization and trust foundation.
- **Objective:** define RBAC, ABAC, JIT, ownership and policy evaluation without
  encoding authority in clients.
- **Problem/evidence:** Foundation authorization is absent; R1 closes only the
  table-level P0. The scorecard still marks authorization partial and surface
  isolation non-conformant.
- **Assets/classification:** `lib/core/auth/` and config `ADAPT`; future policy
  contracts are new Foundation assets.
- **Dependencies/risk/surface:** R1; critical; all surfaces and shared platform.
- **Owner/reviewers:** Security under Rector; Architecture, AppSec, QA,
  Documentation, Nexus and Founder.
- **Predictable files:** Foundation ADRs/plans, then local policy contracts and
  tests in separately approved packages.
- **Permitted/prohibited:** model identities, resource/action/context,
  Founder standard/elevated/emergency access, service identities and audit
  events; do not create claims, RLS, remote roles or elevated access yet.
- **Tests/acceptance/rollback:** decision tables and negative policy cases must
  cover surface and environment context; rollback is document supersession or
  revert of later local contracts.
- **Entry/exit/founder gate:** entry R1 closed locally; exit approved threat
  model and authorization ADR; Founder approves powers and elevation semantics.

## Track B — API and identity boundaries

**Status:** FOUNDATION-008 completed locally. Canonical identity/session
contracts are adopted; Supabase Auth remains the current adapter.
FOUNDATION-009 adds a separate authorization boundary without changing that
provider strategy or inheriting remote authorization.

- **ID / title:** B — Owned API, identity, authentication and session boundary.
- **Objective:** separate identity, authentication, authorization, ownership
  and session lifecycle behind Stasisly-owned contracts.
- **Problem/evidence:** bootstrap and legacy auth depend directly on Supabase;
  public DTOs are safer than transport boundaries.
- **Assets/classification:** auth `REWRITE`; core auth `ADAPT`; Edge Functions,
  profile, specialists and modern chat adapters `ADAPT`.
- **Dependencies/risk/surface:** A; high; Product and shared infrastructure.
- **Owner/reviewers:** Backend Architecture under Rector; Security, Flutter,
  QA, AppSec and Documentation.
- **Predictable files:** owned domain/application ports, provider adapters,
  API version/error contracts and contract tests.
- **Permitted/prohibited:** preserve strict DTOs and fail-closed errors; no
  service role in clients, implicit demo fallback, remote auth or provider DTOs
  as public contracts.
- **Tests/acceptance/rollback:** completed locally with token/session mapping,
  provider-neutral errors, architecture guards and full regression suites;
  compatibility adapters remain isolated pending consumer evidence.
- **Entry/exit/founder gate:** FOUNDATION-008 exit satisfied through G7 after
  publication; provider strategy changes and all remote work remain gated.

## Track C — Surface isolation

**Status:** FOUNDATION-009 supplies canonical surface/environment inputs and a
local PDP, but route/API isolation remains incomplete. FOUNDATION-010 is the
next separately approved enforcement package.

- **ID / title:** C — Product, Development, Administration and Engine isolation.
- **Objective:** make route, API, data, agent and environment access explicit by
  surface.
- **Problem/evidence:** guarded dev routes coexist with reachable legacy Product
  routes and mixed database domains.
- **Assets/classification:** routing `REWRITE`; dev guards `KEEP`; core config
  `ADAPT`; legacy chat `DEPRECATE`.
- **Dependencies/risk/surface:** A and B contracts; critical; all surfaces.
- **Owner/reviewers:** Architecture under Rector with Stasis and Gerendi
  requirements; Security, Flutter, Backend, QA and Nexus.
- **Predictable files:** surface context contracts, route/API guards, dependency
  tests and documentation; repository separation remains an analysis decision.
- **Permitted/prohibited:** isolate and test boundaries; no Product promotion of
  dev routes, direct cross-surface tables or implicit universal access.
- **Tests/acceptance/rollback:** negative route/API matrices and environment
  gates; accepted only when every cross-surface path has an owner and contract;
  rollback keeps legacy routes contained rather than reconnecting them.
- **Entry/exit/founder gate:** A/B decisions; exit approved access matrix and
  local enforcement; Founder approves the surface access model.

## Track D — Product domain reconstruction

- **ID / title:** D — Product taxonomy and controlled vertical slices.
- **Objective:** order taxonomy, catalog, sessions, messages, profile,
  entitlements, memory/research views and wearable-ready contracts.
- **Problem/evidence:** modern contracts are local-safe candidates; legacy chat,
  route naming and prototype domains are not Product-ready.
- **Assets/classification:** chat sessions/messages, specialists, profile,
  mental/physical training `ADAPT`; legacy chat `DEPRECATE`; orchestrator
  `REWRITE` and excluded from Engine identity.
- **Dependencies/risk/surface:** A-C; high; Product under Stasis.
- **Owner/reviewers:** Product Owner and Stasis requirements; Architecture,
  Security, Privacy, UX, Accessibility, QA and Cost.
- **Predictable files:** Product ADRs, owned APIs and later bounded feature
  increments; no UI in the planning package.
- **Permitted/prohibited:** preserve explicit `sessionId`,
  `selectableSpecialistId`, DTO allowlists and transactional message write; no
  client role/IDs, direct Product Supabase or reused legacy route semantics.
- **Tests/acceptance/rollback:** contract, ownership, routing, privacy and widget
  tests per slice; old path stays unavailable until replacement is accepted.
- **Entry/exit/founder gate:** A-C complete; exit one secure Product slice with
  accepted residual debt; Founder approves taxonomy, MVP value and rollout.

## Track E — Stasis Engine foundation

- **ID / title:** E — Governed modular Stasis Engine foundation.
- **Objective:** sequence Agent Constitution, Agent/Prompt Registries, Runtime,
  Model/Tool Gateways, Memory, Cost, Evaluation, Observability and Safety.
- **Problem/evidence:** no runtime exists and the orchestrator prototype can be
  mistaken for Engine capability.
- **Assets/classification:** orchestrator `REWRITE`; Engine runtime `DEFER`
  until constitution and gates; validated generic controls may later `ADAPT`.
- **Dependencies/risk/surface:** A/C, then Product and Administration contracts;
  critical; Platform/Stasis Engine.
- **Owner/reviewers:** Engine Architecture under Rector and Nexus; Security LLM,
  AppSec, Data/Memory, Cost, QA and Documentation.
- **Predictable files:** Agent Constitution and registry/gateway contracts,
  evals and local modular implementation in later packages.
- **Permitted/prohibited:** define modules and extraction boundaries; no agents,
  prompts, providers, tools, MCP, microservice fleet or real memory now.
- **Tests/acceptance/rollback:** offline policy/evaluation fixtures, bounded
  execution and audit contracts; disabled-by-default modules are rollback.
- **Entry/exit/founder gate:** authorization/surface model; Founder approves
  Agent Constitution, initial roster and activation separately.

## Track F — Administration and Development surfaces

- **ID / title:** F — Minimal Administration and Development foundations.
- **Objective:** define Gerendi/Rector tooling, Founder global view,
  documentation and agent-development workflows without implying full products.
- **Problem/evidence:** admin folders are empty and no governed tooling exists.
- **Assets/classification:** current empty shells `DEFER`; historical tooling is
  evidence only; future surface foundations are new assets.
- **Dependencies/risk/surface:** A/C; E for agent tooling; high; Administration
  and Development.
- **Owner/reviewers:** Gerendi and Rector requirements; Security, AppSec, DevOps,
  QA, Documentation and Nexus.
- **Predictable files:** surface contracts, audit workflows and later minimal
  local tools.
- **Permitted/prohibited:** design least-privilege workflows; no production
  controls, hidden Founder super-session or cross-surface inherited access.
- **Tests/acceptance/rollback:** authorization matrices, immutable-event
  contracts and negative environment tests; disable tool entries on rollback.
- **Entry/exit/founder gate:** A/C approved; Founder approves critical actions,
  access elevation and Development privileges.

## Track G — CI, observability and release

- **ID / title:** G — Reproducible quality, security and release gates.
- **Objective:** automate Flutter, Deno, pgTAP, local reset, security, dependency,
  secret and migration checks, then prepare observability and SLOs.
- **Problem/evidence:** CI runs Flutter only; backend security and release supply
  chain are uncovered.
- **Assets/classification:** workflows `ADAPT`; SQL/Deno/architecture guards
  `KEEP` with extension; build workflow `ADAPT`.
- **Dependencies/risk/surface:** stable local commands; high before staging;
  Development and shared infrastructure.
- **Owner/reviewers:** DevOps/Release under Rector; QA, Security, AppSec,
  Observability, Flutter and Backend.
- **Predictable files:** `.github/workflows/`, scripts/config and runbooks in
  separately approved implementation packages.
- **Permitted/prohibited:** deterministic synthetic local validation and safe
  telemetry; no deployment, production secrets or unsigned release promotion.
- **Tests/acceptance/rollback:** isolated jobs reproduce local evidence and fail
  closed; workflow revert is rollback while local commands remain authoritative.
- **Entry/exit/founder gate:** contracts stabilized; exit protected staging
  gates and SLO preparation; Founder approves staging and production separately.

## Track H — Portability and cost controls

- **ID / title:** H — Provider portability, capacity and cost governance.
- **Objective:** map Supabase dependencies and establish adapters, exit triggers,
  rate limits, quotas, usage accounting, budgets and alerts.
- **Problem/evidence:** primary runtime boundaries are provider-owned; costs and
  AI providers remain unknown or unbounded.
- **Assets/classification:** Supabase adapters `ADAPT`; dependencies `UNKNOWN`
  until audit; Model Gateway/Cost Controller `DEFER` until Engine work.
- **Dependencies/risk/surface:** B, G and E for AI controls; high; shared
  infrastructure and Engine.
- **Owner/reviewers:** Architecture and Cost specialist under Rector; DevOps,
  Security, Data, Finance requirements and Nexus.
- **Predictable files:** dependency map, adapter tests, export/recovery plans,
  quotas and accounting contracts.
- **Permitted/prohibited:** evaluate contracts and local portability; do not
  select providers, enable billing, export real data or run remote rehearsals.
- **Tests/acceptance/rollback:** PostgreSQL/adapter compatibility, synthetic
  export/restore and budget-policy tests; provider changes require separate
  rollback and remote gate.
- **Entry/exit/founder gate:** owned boundaries available; exit measurable costs
  and approved exit criteria; Founder approves provider strategy and billing.

## P1-P4 policy

- **P1:** required before new Product implementation: authorization, owned
  identity/API, surface isolation, legacy containment and modern-chat adoption
  decisions.
- **P2:** required before staging: backend CI, adapters, environment vocabulary,
  dependency baseline and Product taxonomy.
- **P3:** required before production: privacy lifecycle, limits, observability,
  release supply chain and platform readiness.
- **P4:** future optimization/capability: wearables, AI cost controls and
  provider-exit rehearsals.

Priority can rise with new evidence. P0 remains closed locally unless a local
regression is demonstrated; remote rollout remains separately gated.

FOUNDATION-011 closes locally the six-function backend-context portion of P1:
registered Product operations, explicit local/development environments,
backend-derived identity/ownership and shared fail-closed PDP/PEP are adopted.
Persistent RBAC/ABAC, legacy Product retirement, remote enforcement, rate limits
and productive audit remain scheduled debt and are not implied closed.

FOUNDATION-012 closes the conceptual Product Conversation and formal legacy-chat
retirement decision. It does not close implementation debt. The approved
FOUNDATION-013 parent slice is decomposed into 013A contracts/adapters, 013B
transactional creation, 013C lifecycle/history, 013D author/provenance, 013E UI
extraction/freeze and 013F inactive application composition. Product routes
remain a later separately approved gate. FOUNDATION-014-020 retain their
existing meanings and remote gates remain separate.

FOUNDATION-013A closes locally the canonical client-domain and adapter portion
of Conversation debt: opaque Product IDs, trusted owner construction, lifecycle
and message contracts, neutral results and compatibility over existing safe
repositories. Backend API canonicalization, transaction/idempotency, lifecycle,
provenance, UI retirement and Product routes remain 013B-013F debt.

FOUNDATION-013B closes locally the create TOCTOU and create/send duplicate-retry
risk with a deny-all server ledger and transactional RPCs. Physical naming,
canonical endpoint rollout, lifecycle, provenance, UI retirement, Product routes,
retention automation and every remote gate remain debt for later packages.

FOUNDATION-013C closes locally owner isolation, canonical read/list mapping,
stable bounded lifecycle pagination and naturally idempotent archive/restore.
Physical naming, Message author/provenance, UI retirement, Product routes,
delete/privacy lifecycle and every remote gate remain later-package debt.

## Common completion rule

A local controlled package should close one coherent risk unit with
implementation, tests, synchronized documentation, explicit commit and push.
Remote operations, secrets, real data, production, irreversible migrations,
access elevation and provider billing always require separate authorization.

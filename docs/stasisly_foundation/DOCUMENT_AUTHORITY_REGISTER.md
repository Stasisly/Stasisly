# Document Authority Register

## FOUNDATION-017 authority addition

ADR-F020 is normative for local-safe Conversation outcome observability and
post-activation hardening. The implementation record owns local test,
accessibility and performance evidence; neither authorizes remote telemetry or
production readiness.

| Document | Status | Authority level | Owner | Approver | Normative | Supersedes | Dependencies | Review condition |
|---|---|---:|---|---|---|---|---|---|
| `adr/ADR-F020-product-conversation-safe-observability-and-hardening.md` | APPROVED / IMPLEMENTED_LOCALLY | 2 | Architecture + Security + Accessibility | Founder | Yes | None | ADR-F018/F019 | Sink, event contract, Product route or accessibility gate changes |
| `implementation/FOUNDATION-017_PRODUCT_CONVERSATION_POST_ACTIVATION_HARDENING.md` | ACTIVE / IMPLEMENTED_LOCALLY | 6 | Flutter + QA + Documentation | Evidence owner | No, evidence | None | ADR-F020; FOUNDATION-016-R1 | Validation, findings or readiness evidence changes |

## FOUNDATION-016-R1 authority addition

ADR-F019 is normative for physical legacy-chat retirement and zero-reference
enforcement. The implementation record owns local evidence; neither authorizes
remote, AI, staging or production.

| Document | Status | Authority level | Owner | Approver | Normative | Supersedes | Dependencies | Review condition |
|---|---|---:|---|---|---|---|---|---|
| `adr/ADR-F019-physical-legacy-chat-removal-and-reference-eradication.md` | APPROVED / IMPLEMENTED_LOCALLY | 2 | Architecture + Security | Founder | Yes | Legacy freeze/removal policy | ADR-F014/F017/F018 | Legacy route, adapter or Orchestrator boundary changes |
| `implementation/FOUNDATION-016_PHYSICAL_LEGACY_CHAT_REMOVAL_AND_REFERENCE_ERADICATION.md` | ACTIVE / IMPLEMENTED_LOCALLY | 6 | Flutter + QA + Documentation | Evidence owner | No, evidence | FOUNDATION-016 blocked attempt | ADR-F019; FOUNDATION-015-R1 | Retirement or validation evidence changes |

## FOUNDATION-015-R1 authority addition

ADR-F018 is normative for controlled canonical Product route/screen activation.
The FOUNDATION-015-R1 implementation record owns local evidence; neither record
authorizes remote execution, staging, production or AI responses.

| Document | Status | Authority level | Owner | Approver | Normative | Supersedes | Dependencies | Review condition |
|---|---|---:|---|---|---|---|---|---|
| `adr/ADR-F018-controlled-product-conversation-route-and-screen-activation.md` | APPROVED / IMPLEMENTED_LOCALLY | 2 | Product + Flutter Architecture + Security | Founder | Yes | Product routes as target-only | ADR-F009/F016/F017 | Route, screen, environment or authority change |
| `implementation/FOUNDATION-015-R1_CONTROLLED_PRODUCT_CONVERSATION_ROUTE_AND_SCREEN_ACTIVATION.md` | ACTIVE / IMPLEMENTED_LOCALLY | 6 | Flutter + QA + Documentation | Evidence owner | No, evidence | FOUNDATION-015 blocked attempt | ADR-F018; FOUNDATION-014-R1 | Product activation or validation evidence changes |

## FOUNDATION-014-R1 authority addition

ADR-F017 is normative for Product Conversation selection identity, safe
unavailable behavior and legacy wiring retirement. The FOUNDATION-014-R1 record
is implementation evidence. Neither document authorizes Product routes, remote
use or physical removal beyond the recorded evidence.

| Document | Status | Authority | Owner | Normative | Replaces | Depends on | Review trigger |
|---|---|---:|---|---|---|---|---|
| `implementation/FOUNDATION-014-R1_PRODUCT_CTA_MIGRATION_AND_LEGACY_WIRING_RETIREMENT.md` | ACTIVE / IMPLEMENTED_LOCALLY | 6 | Evidence owner | No | FOUNDATION-014 blocked finding | ADR-F017; FOUNDATION-013E/F | Consumer, route or retirement evidence changes |
| `adr/ADR-F017-product-consumer-migration-and-legacy-wiring-retirement.md` | APPROVED / IMPLEMENTED_LOCALLY | 2 | Founder | Yes | Legacy Product CTA semantics | ADR-F009/F014/F016 | Selection identity, route or fallback policy changes |

## FOUNDATION-013F authority addition

ADR-F016 is normative for the canonical application layer, local/development
provider composition, stable retry coordination and inactive host. The 013F
implementation record is local evidence only and grants no Product route,
active shell, remote or legacy-removal authority.

## FOUNDATION-013F-R1 authority addition

ADR-F015 is normative for application-owned idempotent operation attempts and
unchanged layer propagation. The R1 implementation record is verified local
evidence. It does not implement FOUNDATION-013F application composition or
authorize Product routes/backend changes/remote use. ADR-F016 remains reserved.

## FOUNDATION-013E authority addition

ADR-F014 is normative for visual-only legacy reuse, canonical presentation and
legacy freeze. The 013E implementation record is verified local evidence. It
does not authorize Product wiring, routes, physical removal or remote use.

## FOUNDATION-013D authority addition

ADR-F013 is normative for Message author/provenance/visibility. The 013D
implementation record is verified local evidence; transitional role/schema
documents remain subordinate and do not authorize Stasis, specialists, Engine,
routes or remote execution.

## Metadata

| Field | Value |
|---|---|
| Title | Document Authority Register |
| Status | ACTIVE |
| Authority level | 6 — Evidence, audits and trackers |
| Owner | Dirección de Documentación y Conocimiento under Rector (conceptual) |
| Approver | Founder for authority assignments |
| Version | 2.0 |
| Effective condition/date | Effective upon merge of FOUNDATION-002; updated through FOUNDATION-013F |
| Supersedes | No Foundation register |
| Dependencies | DOCUMENTATION_GOVERNANCE |

## Register

| Document | Status | Authority level | Owner | Approver | Normative | Supersedes | Dependencies | Review condition |
|---|---|---:|---|---|---|---|---|---|
| `README.md` | ACTIVE | 6 | Documentation | Founder for authority model | No, index | No prior Foundation index | All Foundation documents | Any structural index change |
| `FOUNDATION_TRANSITION.md` | APPROVED | 1 | Program Management | Founder | Yes, transition scope | Discovery-to-Foundation ambiguity | Discovery baseline | FOUNDATION-003 or transition change |
| `REPOSITORY_INVENTORY.md` | ACTIVE | 6 | Documentation | Evidence owner | No, evidence | No Foundation inventory | Git baseline | Repository structure materially changes |
| `ASSET_CLASSIFICATION.md` | ACTIVE | 6 | Architecture + Documentation | Evidence owner | No, evidence/recommendation | No Foundation classification | Repository inventory | Asset decision or audit changes classification |
| `VENDOR_AND_COST_INVENTORY.md` | ACTIVE | 6 | Architecture + Cost | Evidence owner | No, evidence with `UNKNOWN` retained | No Foundation vendor inventory | Repository evidence | Provider, contract or cost evidence changes |
| `FOUNDATION_ROADMAP_DRAFT.md` | APPROVED framework / PROPOSED detail | 3 | Program Management | Founder | Yes for F0–F12 framework only | No approved Foundation roadmap | Global Constitution; Roadmap Governance | Detailed planning or phase change |
| `DOCUMENTATION_GOVERNANCE.md` | APPROVED | 1 | Documentation under Rector (conceptual) | Founder | Yes | Discovery authority model | Foundation transition | Governance amendment |
| `CHANGE_AND_APPROVAL_WORKFLOW.md` | APPROVED | 1 | Program Management + Documentation | Founder | Yes | Discovery prompt workflows | Documentation governance | Workflow amendment |
| `00_GLOBAL_CONSTITUTION.md` | APPROVED | 1 | Founder | Founder | Yes | Dispersed Discovery constitutional principles | Foundation transition; Documentation Governance | Constitutional amendment |
| `01_GOVERNANCE_AND_AUTHORITY.md` | APPROVED | 1 | Founder + Documentation under Rector | Founder | Yes | Discovery organizational model | Global Constitution | Authority or decision-category change |
| `02_SURFACES_AND_ACCESS.md` | APPROVED conceptually, implementation pending | 1 | Founder + future Architecture/Security review | Founder | Yes conceptually | Historical surface nomenclature | Global Constitution; Governance and Authority | Surface or access-model change |
| `03_STASIS_ENGINE_BOUNDARY.md` | APPROVED conceptually, detailed architecture pending | 1 | Architecture under Rector + Nexus coordination | Founder | Yes conceptually | Historical Administration/Engine fusion | Global Constitution; Surfaces and Access | FOUNDATION-004 or Engine-boundary change |
| `04_ROADMAP_GOVERNANCE.md` | APPROVED | 1 | Program Management + surface coordinators | Founder | Yes | Informal Discovery roadmap process | Global Constitution; Governance and Authority | Roadmap-governance change |
| `adr/ADR-F001-global-governance-founder-nexus-surfaces.md` | APPROVED | 2 | Founder + Program Management | Founder | Yes | No Foundation constitutional ADR | Global Constitution; Foundation transition | Decision superseded or amended |
| `05_GLOBAL_TECHNICAL_ARCHITECTURE.md` | APPROVED conceptually | 3 | Architecture under Rector | Founder | Yes conceptually | Discovery technical architecture authority | Constitution; ADR-F002 | Technical architecture change or FOUNDATION-005 evidence |
| `06_API_AND_SERVICE_BOUNDARIES.md` | APPROVED conceptually | 3 | Backend Architecture under Rector | Founder | Yes conceptually | Provider SDK as implicit public boundary | Global Technical Architecture; ADR-F002 | API-boundary change or implementation plan |
| `07_INFRASTRUCTURE_PORTABILITY.md` | APPROVED conceptually | 3 | Architecture + DevOps under Rector | Founder | Yes conceptually | No Foundation exit policy | Global Technical Architecture; ADR-F002 | Provider or portability decision |
| `08_STASIS_ENGINE_ARCHITECTURE.md` | APPROVED conceptually | 3 | Engine Architecture under Rector + Nexus coordination | Founder | Yes conceptually | Orchestrator prototype as implicit Engine model | Engine Boundary; ADR-F002 | Engine architecture or runtime decision |
| `09_DATA_MEMORY_AND_EVENTS.md` | APPROVED conceptually | 3 | Data Architecture under Rector | Founder | Yes conceptually | No Foundation data/memory boundary | Global Technical Architecture; ADR-F002 | Data, memory or event architecture change |
| `10_ENVIRONMENTS_AND_TRUST_BOUNDARIES.md` | APPROVED conceptually | 3 | Security + DevOps under Rector | Founder | Yes conceptually | Dispersed Discovery environment controls | Global Technical Architecture; ADR-F002 | Threat model or environment change |
| `audits/DISCOVERY_TECHNICAL_ASSET_PRECLASSIFICATION.md` | ACTIVE | 6 | Architecture + Documentation | Evidence owner | No, evidence | No focused Foundation technical preclassification | Git baseline `abce443`; Global Technical Architecture | FOUNDATION-005 conformance audit |
| `adr/ADR-F002-global-technical-architecture-and-portability.md` | APPROVED | 2 | Architecture under Rector | Founder | Yes | No Foundation technical architecture ADR | ADR-F001; Global Technical Architecture | Decision superseded or amended |
| `audits/FOUNDATION-005_TECHNICAL_CONFORMANCE_AUDIT.md` | ACTIVE | 6 | Architecture + Security + Documentation | Evidence owner | No, evidence | FOUNDATION-004 preclassification hypotheses | Baseline `e053684`; ADR-F002 | Material implementation or architecture change |
| `audits/FOUNDATION-005_ASSET_CLASSIFICATION_MATRIX.md` | ACTIVE | 6 | Architecture + Documentation | Evidence owner | No, evidence/recommendation | Initial technical asset preclassification | FOUNDATION-005 audit | Asset remediation or new evidence |
| `audits/FOUNDATION-005_CONFORMANCE_SCORECARD.md` | ACTIVE | 6 | Architecture + Security + QA | Evidence owner | No, evidence | No Foundation conformance scorecard | FOUNDATION-005 audit and tests | Remediation changes a rating |
| `audits/FOUNDATION-005_REMEDIATION_BACKLOG.md` | ACTIVE | 5 | Program Management + Architecture | Founder for execution approval | No, tracking with P1-P4 proposed | No Foundation remediation backlog | FOUNDATION-005 audit; FOUNDATION-006 package map | New evidence, closure or reprioritization |
| `audits/FOUNDATION-005_TEST_EVIDENCE.md` | ACTIVE | 6 | QA + Documentation | Evidence owner | No, evidence | No consolidated Foundation test evidence | Baseline `e053684`; local toolchain | Relevant suites or baseline change |
| `implementation/FOUNDATION-005-R1_LEGACY_PUBLIC_TABLES_DENY_ALL.md` | ACTIVE | 6 | Security + Database + QA + Documentation | Evidence owner | No, local implementation evidence | FOUNDATION-005 P0 evidence | Migration `00009`; local reset and test suites | Remote deployment or material access-model change |
| `planning/FOUNDATION_MASTER_REMEDIATION_PLAN.md` | APPROVED | 4 | Director de Proyecto + Rector + Nexus | Founder | Yes, reconstruction strategy | No executable Foundation remediation plan | ADR-F001-F003; FOUNDATION-005/R1 | Material sequencing, scope or risk change |
| `planning/FOUNDATION_EXECUTION_PACKAGE_MAP.md` | APPROVED | 4 | Program Management under Nexus | Founder | Yes, working execution structure | Ad hoc package sequencing | Master Remediation Plan | Package map or priority change |
| `planning/FOUNDATION_DEPENDENCY_AND_GATE_MAP.md` | APPROVED | 4 | Architecture + Program Management | Founder | Yes | Dispersed technical gates | Master Remediation Plan | Dependency or quality-gate change |
| `planning/FOUNDATION_ASSET_ADOPTION_PLAN.md` | PROPOSED | 5 | Architecture under Rector | Founder per adoption decision | No, per-asset proposal | Audit candidate classifications | FOUNDATION-005 matrix; ADR-F003 | Asset passes or fails adoption gate |
| `planning/FOUNDATION_RISK_AND_DEBT_REGISTER.md` | ACTIVE | 6 | Director de Proyecto + risk owners | Evidence owner; Founder for risk acceptance | No, evidence/tracking | Dispersed audit debt | FOUNDATION-005 backlog; Master Plan | New evidence, closure or priority change |
| `planning/FOUNDATION_FOUNDER_DECISION_GATES.md` | APPROVED | 1 | Founder + Program Management | Founder | Yes | Informal decision escalation | Governance; Master Plan | Founder authority or gate change |
| `adr/ADR-F003-foundation-reconstruction-strategy.md` | APPROVED | 2 | Architecture under Rector + Nexus | Founder | Yes | No Foundation reconstruction ADR | ADR-F001/F002; FOUNDATION-005/R1 | Strategy superseded or amended |
| `security/FOUNDATION_THREAT_MODEL.md` | APPROVED conceptually | 3 | Security under Rector + Nexus | Founder | Yes conceptually | No global Foundation threat model | Constitution; Architecture; ADR-F004 | Material actor, asset, boundary or topology change |
| `security/TECHNICAL_AUTHORIZATION_MODEL.md` | APPROVED conceptually | 3 | Security + Architecture under Rector | Founder | Yes conceptually | No technical authorization model | Threat Model; ADR-F004 | Authorization semantics or implementation design |
| `security/FOUNDER_ACCESS_AND_ELEVATION_MODEL.md` | APPROVED conceptually | 1 | Founder + Security | Founder | Yes conceptually | Founder tiers without detailed model | Governance; ADR-F004 | Claims, elevation, break-glass or root control design |
| `security/SERVICE_AND_AGENT_IDENTITY_MODEL.md` | APPROVED conceptually | 3 | Security + Engine Architecture | Founder | Yes conceptually | Shared/provider identity assumptions | Authorization Model; ADR-F004 | Service/agent identity implementation |
| `security/AUTHORIZATION_DECISION_MATRIX.md` | APPROVED | 4 | Security + Architecture | Founder | Yes, examples and rules | No Foundation decision examples | Authorization Model | Policy contract or matrix change |
| `security/THREAT_CONTROL_MATRIX.md` | ACTIVE | 6 | Security + risk owners | Evidence owner; Founder for risk acceptance | No, security evidence/planning | No consolidated control matrix | Threat Model | Control evidence, risk or package change |
| `security/SECURITY_ABUSE_CASES.md` | ACTIVE | 6 | AppSec + QA + Security | Evidence owner | No, security evidence | No consolidated abuse-case set | Threat/Authorization Models | Test implementation or threat change |
| `adr/ADR-F004-technical-authorization-and-threat-model.md` | APPROVED | 2 | Security + Architecture under Rector | Founder | Yes | No technical authorization ADR | ADR-F001-F003; Threat Model | Decision superseded or implementation semantics change |
| `implementation/FOUNDATION-008_OWNED_IDENTITY_SESSION_API_CONTRACTS.md` | ACTIVE | 6 | Architecture + Security + QA + Documentation | Evidence owner | No, local implementation evidence | Provider-owned identity/session ambiguity | ADR-F005; FOUNDATION-007 | Adapter, contract, authorization or remote activation change |
| `adr/ADR-F005-owned-identity-session-and-api-contracts.md` | APPROVED / IMPLEMENTED_LOCALLY | 2 | Architecture under Rector + Security | Founder | Yes | Provider Auth DTOs as implicit domain boundary | ADR-F002; ADR-F004 | Identity/session/API contract or provider strategy change |
| `implementation/FOUNDATION-009_AUTHORIZATION_CONTEXT_AND_POLICY_CONTRACTS.md` | ACTIVE | 6 | Security + Architecture + QA + Documentation | Evidence owner | No, local implementation evidence | Authorization runtime absent | ADR-F006; FOUNDATION-007/008 | Policy, consumer, audit or remote enforcement change |
| `adr/ADR-F006-authorization-context-and-policy-contracts.md` | APPROVED / IMPLEMENTED_LOCALLY | 2 | Security + Architecture under Rector | Founder | Yes | Authorization inputs/outcomes without an owned runtime contract | ADR-F004; ADR-F005 | Authorization semantics, policy or enforcement boundary change |
| `implementation/FOUNDATION-010_SURFACE_AND_ENVIRONMENT_ENFORCEMENT.md` | ACTIVE / IMPLEMENTED_LOCALLY | 6 | Architecture + Security + QA + Documentation | Evidence owner | No, local implementation evidence | Route and provider boundary enforcement absent | ADR-F007; FOUNDATION-009 | Enforcement, backend adoption or remote activation change |
| `adr/ADR-F007-surface-and-environment-enforcement-boundaries.md` | APPROVED / IMPLEMENTED_LOCALLY | 2 | Architecture + Security under Rector | Founder | Yes | Implicit route surface/environment authority | ADR-F004-F006 | Surface, environment, route or entry-point enforcement semantics change |
| `implementation/FOUNDATION-011_BACKEND_AUTHORIZATION_CONTEXT_AND_OWNED_API_ENFORCEMENT.md` | ACTIVE / IMPLEMENTED_LOCALLY | 6 | Backend Architecture + Security + QA + Documentation | Evidence owner | No, local implementation evidence | Implicit backend operation context | ADR-F008; FOUNDATION-008-010 | Backend policy, operation, ownership or remote activation change |
| `adr/ADR-F008-backend-authorization-context-and-owned-api-enforcement.md` | APPROVED / IMPLEMENTED_LOCALLY | 2 | Backend Architecture + Security under Rector | Founder | Yes | Implicit backend surface/environment/action/resource authority | ADR-F004-F007 | Backend authorization, owned API or environment semantics change |
| `product/PRODUCT_CONVERSATION_ARCHITECTURE.md` | APPROVED / PARTIALLY_IMPLEMENTED_LOCALLY | 3 | Product Architecture under Stasis | Founder | Yes | Discovery-era chat/session semantics | ADR-F009; ADR-F018; Foundation architecture | Product Conversation semantics or route model change |
| `product/CONVERSATION_DOMAIN_GLOSSARY.md` | APPROVED | 3 | Product Architecture under Stasis | Founder | Yes | Duplicated chat/agent/session vocabulary | Product Conversation Architecture | Canonical term changes |
| `product/CONVERSATION_LIFECYCLE_AND_OWNERSHIP.md` | APPROVED conceptually / NOT_IMPLEMENTED | 3 | Product + Data + Security | Founder | Yes conceptually | Active/archived legacy-only lifecycle | ADR-F009; authorization model | Lifecycle, ownership, sharing or deletion change |
| `product/CONVERSATION_MEMORY_RESEARCH_BOUNDARIES.md` | APPROVED conceptually / NOT_IMPLEMENTED | 3 | Product + Data/Memory + Research Governance | Founder | Yes conceptually | Conversation/history/memory ambiguity | Data/Memory architecture; ADR-F009 | Memory, research, attachment or trace boundary change |
| `product/LEGACY_CHAT_RETIREMENT_PLAN.md` | APPROVED plan / PARTIALLY_IMPLEMENTED_LOCALLY | 4 | Product + Flutter + Backend Architecture | Founder | Yes for retirement gates | Informal DEPRECATE_CANDIDATE | ADR-F009; ADR-F017/F018; replacement packages | Retirement phase or removal-gate change |
| `product/CONVERSATION_API_TARGET_CONTRACTS.md` | APPROVED target / PARTIALLY_IMPLEMENTED_LOCALLY | 3 | Product API Architecture | Founder | Yes conceptually | Session-named local compatibility APIs | ADR-F009; ADR-F011; API boundaries | Public Conversation API/versioning change |
| `product/CONVERSATION_ASSET_ADOPTION_MATRIX.md` | ACTIVE | 6 | Product Architecture + Documentation | Evidence owner; Founder for adoption/removal | No, evidence/planning | Earlier broad chat classifications | FOUNDATION-005 matrix; ADR-F009 | Asset evidence, classification or gate change |
| `adr/ADR-F009-product-conversation-architecture-and-legacy-chat-retirement.md` | APPROVED / NOT_IMPLEMENTED | 2 | Product + Architecture under Stasis/Rector | Founder | Yes | Legacy chat and session semantics as implicit Product architecture | ADR-F002; ADR-F004-F008 | Conversation, Stasis, specialist, lifecycle or retirement decision changes |
| `implementation/FOUNDATION-013A_CANONICAL_CONVERSATION_CONTRACTS_AND_ADAPTERS.md` | ACTIVE / IMPLEMENTED_LOCALLY | 6 | Product + Flutter Architecture + QA + Documentation | Evidence owner | No, local implementation evidence | Canonical Product contracts absent | ADR-F009; ADR-F010 | Contract, adapter, compatibility or activation change |
| `adr/ADR-F010-canonical-conversation-contracts-and-transitional-adapters.md` | APPROVED / IMPLEMENTED_LOCALLY | 2 | Product + Architecture under Stasis/Rector | Founder | Yes | Session contracts as direct Product vocabulary | ADR-F009; FOUNDATION-013A | Conversation contracts, owner construction, mapping or adapter strategy change |
| `implementation/FOUNDATION-013B_TRANSACTIONAL_CONVERSATION_CREATION_AND_IDEMPOTENCY.md` | ACTIVE / IMPLEMENTED_LOCALLY | 6 | Backend + Security + Product Architecture | Evidence owner | No, local implementation evidence | Create TOCTOU and duplicate retry behavior | ADR-F011; FOUNDATION-013A | Transaction, idempotency, grants, retention or remote activation change |
| `adr/ADR-F011-transactional-conversation-creation-and-idempotency.md` | APPROVED / IMPLEMENTED_LOCALLY | 2 | Backend + Security under Stasis/Rector | Founder | Yes | Multi-request create and non-idempotent writes | ADR-F009/F010; FOUNDATION-013B | Transaction, locking, idempotency scope or trusted-boundary change |
| `implementation/FOUNDATION-013C_CANONICAL_CONVERSATION_READ_LIST_ARCHIVE_RESTORE.md` | ACTIVE / IMPLEMENTED_LOCALLY | 6 | Backend + Product Architecture + Security + QA | Evidence owner | No, local implementation evidence | Transitional read/list/archive and absent restore | ADR-F012; FOUNDATION-013A/B | Lifecycle, DTO, pagination, endpoint or remote activation change |
| `adr/ADR-F012-canonical-conversation-read-and-lifecycle-boundary.md` | APPROVED / IMPLEMENTED_LOCALLY | 2 | Backend + Product Architecture + Security under Stasis/Rector | Founder | Yes | Distributed lifecycle/ownership and non-idempotent archive replay | ADR-F009-F011; FOUNDATION-013C | Lifecycle, ownership, pagination or trusted-boundary change |
| `implementation/FOUNDATION-013F-R1_IDEMPOTENT_OPERATION_ATTEMPT_PROPAGATION.md` | ACTIVE / IMPLEMENTED_LOCALLY | 6 | Flutter Architecture + Security + QA | Evidence owner | No, local implementation evidence | Unstable client operation attempts across retries | ADR-F015; FOUNDATION-013A/B/E | Attempt ownership, propagation, retry or activation change |
| `adr/ADR-F015-idempotent-operation-attempt-propagation.md` | APPROVED / IMPLEMENTED_LOCALLY | 2 | Flutter + Product Architecture + Security under Rector | Founder | Yes | Datasource-owned idempotency generation | ADR-F010/F011/F014; FOUNDATION-013F-R1 | Attempt semantics, ownership, transport mapping or authority change |
| `implementation/FOUNDATION-013F_CANONICAL_CONVERSATION_APPLICATION_AND_INACTIVE_COMPOSITION.md` | ACTIVE / IMPLEMENTED_LOCALLY | 6 | Flutter Architecture + Security + QA | Evidence owner | No, local implementation evidence | Missing canonical application orchestration | ADR-F016; FOUNDATION-013A-E/R1 | Product routing, remote, legacy migration or state/retry contract change |
| `adr/ADR-F016-canonical-conversation-application-and-inactive-composition.md` | APPROVED / IMPLEMENTED_LOCALLY | 2 | Flutter + Product Architecture + Security under Rector | Founder | Yes | Application composition and retry/lifecycle policy | ADR-F010-F015; FOUNDATION-013F | Product activation, route, environment or retry-authority change |
| `DOCUMENT_AUTHORITY_REGISTER.md` | ACTIVE | 6 | Documentation under Rector (conceptual) | Founder for authority changes | Operational register | No prior register | Documentation governance | Any authority/status/supersession change |
| `archive_index/DISCOVERY_ARCHIVE_INDEX.md` | ACTIVE | 6 | Documentation | Evidence owner | No, evidence/index | Informal Discovery locations | Discovery archive | Archive path or successor changes |
| `implementation/FOUNDATION_SESSION_TRACKER.md` | ACTIVE | 6 | Program Management | Evidence owner | No, tracker | Historical Discovery tracker for Foundation work | Foundation packages | Every completed Foundation package |

## Interpretation

- `APPROVED` records an approved decision but does not prove implementation.
- `ACTIVE evidence` is represented as status `ACTIVE`, authority level 6 and
  `Normative: No`.
- `UNKNOWN` values in inventories remain unknown until verified.
- Archived Discovery documents are collectively level 7, `ARCHIVED`,
  non-normative and indexed separately.

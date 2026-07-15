# Document Authority Register

## Metadata

| Field | Value |
|---|---|
| Title | Document Authority Register |
| Status | ACTIVE |
| Authority level | 6 — Evidence, audits and trackers |
| Owner | Dirección de Documentación y Conocimiento under Rector (conceptual) |
| Approver | Founder for authority assignments |
| Version | 1.1 |
| Effective condition/date | Effective upon merge of FOUNDATION-002; updated by FOUNDATION-003 |
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

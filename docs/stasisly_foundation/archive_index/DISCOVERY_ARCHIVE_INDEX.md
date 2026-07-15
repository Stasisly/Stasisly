# Discovery Archive Index

## Archive map

| Category | Original path | Archived path | Classification | Reference value | Foundation successor | Review status |
|---|---|---|---|---|---|---|
| Project definition | `docs/PROJECT_DEFINITION.md` | `docs/archive/discovery/root/PROJECT_DEFINITION.md` | ADAPT | Product vision and principles | Future `01_VISION_AND_PRODUCT.md` | Pending FOUNDATION-003+ |
| Architecture | `docs/ARCHITECTURE.md` | `docs/archive/discovery/root/ARCHITECTURE.md` | ADAPT | Boundaries and technical decisions | Future `02_GLOBAL_ARCHITECTURE.md` | Pending architecture phase |
| Session tracker | `docs/SESSION_TRACKER.md` | `docs/archive/discovery/trackers/SESSION_TRACKER.md` | ARCHIVE | Historical execution evidence | `implementation/FOUNDATION_SESSION_TRACKER.md` | Archived |
| 43 agent prompts | `docs/stasisly_definition/agents/` | `docs/archive/discovery/stasisly_definition/agents/` | ADAPT | Development expertise and prompt material | Future Foundation agent templates/roster | Preserved, non-executable |
| 6 committees | `docs/stasisly_definition/committees/` | `docs/archive/discovery/stasisly_definition/committees/` | ADAPT | Review/governance patterns | Future governance and organization docs | Pending review |
| 12 Discovery ADR | `docs/stasisly_definition/adr/` | `docs/archive/discovery/stasisly_definition/adr/` | ADAPT/ARCHIVE | Historical decisions and evidence | Future Foundation ADR set | Classified below |
| Implementation plans | `docs/stasisly_definition/implementation_plans/` | `docs/archive/discovery/stasisly_definition/implementation_plans/` | ARCHIVE | Closed line 2B evidence | Future approved Foundation plans | Archived |
| Orchestrator | `docs/stasisly_definition/orchestrator/` | `docs/archive/discovery/stasisly_definition/orchestrator/` | ADAPT | Codex operating controls | Foundation engineering workflow | Preserved, non-executable |
| Legacy master prompt | `docs/archive/PROMPT_CODEX_EQUIPO_AAA_STASISLY.md` | `docs/archive/discovery/prompts/PROMPT_CODEX_EQUIPO_AAA_STASISLY.md` | ARCHIVE | Original AAA prompt | Future Foundation prompt template | Preserved, non-executable |
| API/MCP/Engine document | `docs/stasisly_definition/10_API_MCP_STASIS_ENGINE.md` | `docs/archive/discovery/stasisly_definition/10_API_MCP_STASIS_ENGINE.md` | ADAPT | API/MCP separation and Engine intent | Future architecture/Engine documents | Pending review |
| Development team | `docs/stasisly_definition/00_DEVELOPMENT_TEAM.md` | `docs/archive/discovery/stasisly_definition/00_DEVELOPMENT_TEAM.md` | ADAPT | 43-agent team structure | Future Development organization | Pending review |

## Discovery ADR classification

| ADR | Decision | Discovery status | Potential validity | Foundation action |
|---|---|---|---|---|
| ADR-001 | API, MCP and Stasis Engine separation | Historical decision | Core separation likely valuable | AMEND_CANDIDATE |
| ADR-002 | Federated memory and traceable research | Historical conceptual decision | Product principle, security model incomplete | AMEND_CANDIDATE |
| ADR-003 | Security, privacy, encryption and no secret-chat branch | Historical decision | Security principles likely reusable | ADOPT_CANDIDATE |
| ADR-004 | Documentary governance and source hierarchy | Superseded by FOUNDATION-002 | Historical traceability only | REPLACE |
| ADR-005 | Prototype stabilization and explicit demo mode | Implemented Discovery gate | Valuable evidence, not Foundation constitution | HISTORICAL_ONLY |
| ADR-006 | Identity, authorization and RLS | Mixed decision/execution evidence | Technical controls need extraction | AMEND_CANDIDATE |
| ADR-007 | Sanitized specialist catalog/backend boundary | Mixed decision/execution evidence | Contract boundary likely reusable | AMEND_CANDIDATE |
| ADR-008 | Product `/conversations` route | Historical proposal/decision chain | Routing remains unresolved for Foundation | UNKNOWN |
| ADR-009 | Product, Wizard/Development and Admin/Engine surfaces | Historical terminology superseded | Three-surface intent remains relevant | REPLACE |
| ADR-010 | Product specialist catalog | Historical product decision | Sanitization and Product isolation valuable | AMEND_CANDIDATE |
| ADR-011 | Catalog guards and contracts | Historical technical decision | Test guards valuable after architecture audit | ADOPT_CANDIDATE |
| ADR-012 | Product/Admin agent hierarchy | Historical conceptual proposal | Must align with Nexus/Stasis/Rector/Gerendi | REPLACE |

These actions are candidates only. FOUNDATION-002 creates no Foundation ADR,
does not renumber historical ADR and does not grant them current authority.

## Integrity totals

```text
Agents: 43
Committees: 6
ADRs: 12
Implementation plans: 7
Orchestrator documents: 3
Legacy master prompts: 1
```

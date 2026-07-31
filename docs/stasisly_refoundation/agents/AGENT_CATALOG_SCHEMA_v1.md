# Agent Catalog Schema v1

## Contract

`AgentCatalogEntryV1` is metadata only. It grants no runtime, data, tool or
memory access.

| Field | Type | Required | Rule |
|---|---|---|---|
| `agent_id` | string | yes | Versioned catalog value |
| `canonical_name` | string | yes | Versioned catalog value |
| `display_name` | string | yes | Versioned catalog value |
| `surface` | string | yes | Versioned catalog value |
| `domain` | string | yes | Versioned catalog value |
| `family` | string | yes | Versioned catalog value |
| `area` | string | yes | Versioned catalog value |
| `subarea` | string | yes | Versioned catalog value |
| `specialty` | string | yes | Versioned catalog value |
| `subspecialty` | string | yes | Versioned catalog value |
| `function` | string | yes | Versioned catalog value |
| `short_mission` | string | yes | Versioned catalog value |
| `agent_type` | string | yes | Versioned catalog value |
| `coordination_level` | string | yes | Versioned catalog value |
| `reports_to` | string | yes | Versioned catalog value |
| `coordinates` | array<string> | yes | Versioned catalog value |
| `activation_mode` | string | yes | Versioned catalog value |
| `availability` | string | yes | Versioned catalog value |
| `risk_level` | string | yes | Versioned catalog value |
| `data_access_class` | string | yes | Versioned catalog value |
| `tool_access_class` | string | yes | Versioned catalog value |
| `memory_scope` | string | yes | Versioned catalog value |
| `human_escalation` | string | yes | Versioned catalog value |
| `prompt_status` | string | yes | Versioned catalog value |
| `implementation_status` | string | yes | Versioned catalog value |
| `historical_mapping` | string | yes | Versioned catalog value |
| `lifecycle_status` | string | yes | Versioned catalog value |
| `version` | string | yes | Versioned catalog value |
| `notes` | string | yes | Versioned catalog value |

## Closed vocabularies

- Surfaces: PRODUCT, DEVELOPMENT, ADMINISTRATION, TRANSVERSAL.
- Agent types: GLOBAL_COORDINATOR, SURFACE_COORDINATOR, DOMAIN_COORDINATOR, FAMILY_COORDINATOR, AREA_COORDINATOR, SPECIALIST, REVIEWER, AUDITOR, RESEARCHER, OPERATOR, ANALYST, PLANNER, DESIGNER, ENGINEER, GUARDIAN, LIAISON, QUALITY_AGENT, INCIDENT_AGENT, SUPPORT_AGENT.
- Coordination levels: GLOBAL, SURFACE, DOMAIN, FAMILY, AREA, SPECIALTY, INDIVIDUAL_CONTRIBUTOR.
- Activation modes: ALWAYS_AVAILABLE, ON_DEMAND, EVENT_TRIGGERED, SCHEDULED, HUMAN_REQUESTED, COORDINATOR_SELECTED, RISK_TRIGGERED, INCIDENT_TRIGGERED.
- Risk: LOW, MODERATE, HIGH, CRITICAL.
- Data access: NO_USER_DATA, ANONYMIZED_DATA, PSEUDONYMIZED_DATA, USER_SCOPED_DATA, SURFACE_SCOPED_DATA, ADMINISTRATIVE_DATA, SENSITIVE_HEALTH_DATA, SECURITY_RESTRICTED_DATA, FOUNDER_ONLY_DATA.
- Tool access: NO_TOOLS, READ_ONLY_TOOLS, DOMAIN_TOOLS, MUTATING_TOOLS_WITH_APPROVAL, SECURITY_RESTRICTED_TOOLS, FOUNDER_AUTHORIZED_TOOLS.
- Memory: NONE, EPHEMERAL_TASK, AGENT_PRIVATE, AREA_MEMORY, SURFACE_MEMORY, GLOBAL_FEDERATED_MEMORY, FOUNDER_PRIVATE_MEMORY.
- Lifecycle: CATALOGED, DESIGNED, PROMPT_CREATED, CONFIGURED, TESTED, AVAILABLE, ACTIVE, SUSPENDED, RETIRED, ARCHIVED.

IDs are immutable. `canonical_name` is stable and unique. Access classes state
future review requirements and never provision access.

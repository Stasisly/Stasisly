# Agent Catalog Architecture

## Baseline

The initial catalog capacity is `3,000` agents: Product `1,050`, Development
`1,200`, Administration `700`, and Transversal `50`. Allocation is provisional,
coverage-driven and unbounded as a future maximum.

Catalog size is not simultaneous activation. Runtime selection uses the minimum
sufficient team allowed by context, risk and budget.

## Taxonomy

```text
Surface → domain → family → area → subarea → specialty
→ subspecialty → function → agent
```

## Required record

The normative `AgentCatalogEntryV1` contract and its 29 fields are defined in
[`agents/AGENT_CATALOG_SCHEMA_v1.md`](agents/AGENT_CATALOG_SCHEMA_v1.md).
Machine-readable canonical views are CSV and JSON; Markdown views are derived
summaries.

## Governance

- Canonical names and aliases are unique within a versioned namespace.
- Duplicate capability requires merge, specialization or explicit coexistence.
- Activation is deny-by-default and context-bound.
- New, temporary, human and provider agents use the same lifecycle controls.
- Prompt creation, configuration, testing, availability and activation are
  distinct states.
- Catalog portability prevents provider lock-in.

The 43 historical identities remain mapped 43/43 and not activated. Thirty-eight
of their prompts now have a canonical Wave 2, Wave 3, Wave 4 or Wave 5 migration
baseline; 5 retain only their historical prompt state. Four Wave 1
coordinators, 18 Wave 2 agents, 40 Wave 3 agents, 50 Wave 4 agents and 60 Wave 5
agents
are `PROMPT_CREATED`, `APPROVED`, `DOCUMENTED_ONLY` and `NOT_AVAILABLE`.
Prompt-created records total 177 because the 38 migrated historical records
were already prompt-created. The other 2,823 canonical entries remain
`CATALOGED`, `NOT_CREATED`, `NOT_IMPLEMENTED` and `NOT_AVAILABLE`.

## Prompt architecture

Prompt governance is defined under
[`agents/prompts/`](agents/prompts/AGENT_PROMPT_ARCHITECTURE_v1.md). Shared
constitutional, surface and domain policies are versioned references rather
than duplicated text. Individual prompt, runtime configuration and evaluation
versions remain independent. The 3,000 wave assignments are design sequencing,
not activation.

`DOCUMENTED_ONLY` records a versioned prompt baseline, not executable agent
code. Catalog access and tool classes remain declarative ceilings; runtime
bindings continue deny-by-default and require P15-P17 in later packages.
## Wave 6 catalog state

Exactly 50 Administration records now have an approved documentary prompt: three historical migrations, two reclassified historical migrations and 45 new prompts. Cumulative documentary prompts are 222; all 3,000 agents remain `NOT_AVAILABLE`, with no tool, memory or runtime configuration implied by catalog metadata.

## Wave 7 strategy state

All original 2,778 Wave 7 records have exactly one strategy and subwave
assignment outside the catalog. Approved subwaves may transition records only
through explicit packages. Strategy registries are derived planning views and
may not silently mutate canonical catalog identity or hierarchy.

## W7-001 catalog transition

Exactly forty `W7-001` records moved to `PROMPT_CREATED` and `DOCUMENTED_ONLY`, producing 262 documentary prompts and leaving 2,738 `NOT_CREATED`. Identity, hierarchy, strategy and risk metadata are unchanged. All 3,000 records remain `NOT_AVAILABLE`; catalog state does not provision runtime, tools, memory or enforcement.

## W7-002 catalog transition

Exactly twenty `W7-002` records moved to `PROMPT_CREATED` and `DOCUMENTED_ONLY`, producing 282 documentary prompts and leaving 2,718 `NOT_CREATED`. Identity, hierarchy, strategy and CRITICAL risk metadata are unchanged. All 3,000 records remain `NOT_AVAILABLE`; catalog state creates no incident, people, continuity, Emergency or production authority.

## W7-003 catalog transition

Exactly 45 `W7-003` records moved to `PROMPT_CREATED` and `DOCUMENTED_ONLY`,
producing 327 documentary prompts and leaving 2,673 `NOT_CREATED`. Identity,
hierarchy, strategy and HIGH-risk metadata are unchanged. All 3,000 records
remain `NOT_AVAILABLE`; catalog state creates no privacy, legal, compliance,
deletion, notification or certification authority.

## W7-004 catalog transition

Exactly 22 `W7-004` records moved to `PROMPT_CREATED` and `DOCUMENTED_ONLY`,
producing 349 documentary prompts and leaving 2,651 `NOT_CREATED`. Identity,
hierarchy, strategy and HIGH-risk metadata are unchanged. All 3,000 records
remain `NOT_AVAILABLE`; catalog state creates no financial mutation, provider
approval, ledger, payment, refund or entitlement authority.

## W7-005 catalog transition

Exactly ten `W7-005` records moved to `PROMPT_CREATED` and `DOCUMENTED_ONLY`,
producing 359 documentary prompts and leaving 2,641 `NOT_CREATED`. Identity,
hierarchy, strategy and CRITICAL-risk metadata are unchanged. All 3,000 records
remain `NOT_AVAILABLE`; catalog state creates no incident-command, production,
deployment, rollback, infrastructure or communication authority.

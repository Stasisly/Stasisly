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

The 43 historical identities remain mapped 43/43 and not activated. Six of
their prompts now have a canonical Wave 2 migration baseline; 37 retain only
their historical prompt state. Four Wave 1 coordinators and 18 Wave 2 agents
are `PROMPT_CREATED`, `APPROVED`, `DOCUMENTED_ONLY` and `NOT_AVAILABLE`.
Prompt-created records total 59 because the six migrated historical records
were already prompt-created. The other 2,941 canonical entries remain
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

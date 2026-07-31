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

The 43 historical prompts remain `PROMPT_CREATED`; they are mapped 43/43, not
duplicated and not activated by this baseline. All 2,957 new entries are
`CATALOGED`, `NOT_CREATED`, `NOT_IMPLEMENTED` and `NOT_AVAILABLE`.

## Prompt architecture

Prompt governance is defined under
[`agents/prompts/`](agents/prompts/AGENT_PROMPT_ARCHITECTURE_v1.md). Shared
constitutional, surface and domain policies are versioned references rather
than duplicated text. Individual prompt, runtime configuration and evaluation
versions remain independent. The 3,000 wave assignments are design sequencing,
not activation.

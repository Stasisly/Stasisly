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

`agent_id`, `canonical_name`, `display_name`, `surface`, `domain`, `family`,
`area`, `subarea`, `specialty`, `subspecialty`, `short_mission`, `agent_type`,
`coordination_level`, `availability`, `activation_mode`, `risk_level`,
`prompt_status`, `historical_mapping`, `version`, and `lifecycle_status`.

## Governance

- Canonical names and aliases are unique within a versioned namespace.
- Duplicate capability requires merge, specialization or explicit coexistence.
- Activation is deny-by-default and context-bound.
- New, temporary, human and provider agents use the same lifecycle controls.
- Prompt creation, configuration, testing, availability and activation are
  distinct states.
- Catalog portability prevents provider lock-in.

The 43 historical prompts remain `PROMPT_CREATED`; they are not duplicated or
activated by this baseline.

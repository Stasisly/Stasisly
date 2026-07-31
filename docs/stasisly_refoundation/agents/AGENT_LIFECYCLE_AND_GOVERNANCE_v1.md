# Agent Lifecycle and Governance v1

## Allowed lifecycle

`CATALOGED → DESIGNED → PROMPT_CREATED → CONFIGURED → TESTED → AVAILABLE → ACTIVE`

Return and retirement paths are `ACTIVE → AVAILABLE`,
`AVAILABLE ↔ SUSPENDED`, `SUSPENDED → RETIRED`, `AVAILABLE → RETIRED`, and
`RETIRED → ARCHIVED`.

`CATALOGED → ACTIVE`, `ARCHIVED → ACTIVE`, and `RETIRED → PROMPT_CREATED` are
forbidden without an extraordinary, versioned recovery process.

## New-agent process

```text
identify gap → search catalog → compare overlap → justify capability
→ assign taxonomy and owner → review risk → approve CATALOGED entry
→ create prompt in a later package
```

## Activation

The default team is `MINIMUM_SUFFICIENT`. Selection requires task, surface,
environment, authority, risk, data/tool class, cost and human escalation checks.
Catalog metadata grants no access. Every future wave requires separate Founder
approval.

## Proposed waves

1. Global and surface coordinators.
2. Security, architecture and governance.
3. Product core and Stasis.
4. Development core.
5. Administration core.
6. Specialized domains in evidence-driven increments.

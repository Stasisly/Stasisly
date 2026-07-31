# Stasisly Re-foundation Master

## Status

```text
Stage: REFOUNDATION
Authority: NORMATIVE
Founder decision: APPROVED
Implementation: DOCUMENTED
Previous stages: DISCOVERY_LEGACY / READ_ONLY_REFERENCE / NON_NORMATIVE
```

This document establishes the clean documentary baseline for future Stasisly
work. It preserves prior evidence without allowing historical documents to
override current decisions.

## Product identity

Stasisly is an extensible multi-surface, multi-agent platform. Product starts
with Stasis as its nucleus and coordinator, plus Salud, Nutricion,
Entrenamiento and Wellness. These areas are an initial structure, not a closed
catalog.

The governing principle is **global design, proportional implementation**.
Architecture must expose credible growth paths while each phase implements only
what current evidence and resources justify.

## Global organization

```text
Founder
└── Nexus
    ├── Stasis  — Product
    ├── Rector  — Development
    └── Gerendi — Administration
```

The initial public/operational surfaces are Product, Development and
Administration. Founder Private Console is a private control surface. Platform
is an internal capability layer, not a public surface.

## Initial baselines

- Agent catalog: 3,000 versioned metadata records, coverage-driven and not
  simultaneously active. The catalog is implemented; prompts and runtime are
  not implemented.
- Historical prompts: 43 preserved as `PROMPT_CREATED` and mapped 43/43 in the
  Re-foundation crosswalk. They remain unavailable pending later prompt waves.
- Data: one canonical PostgreSQL database per environment initially.
- Provider: Supabase is initial and replaceable.
- Current Supabase project: `DISCOVERY_LEGACY`, read-only candidate,
  non-normative.
- Clean Development project: planned, not created.
- Sharding: architecture target, not implemented.

## Normative hierarchy

1. Approved Re-foundation ADRs.
2. This master document.
3. Re-foundation architecture documents.
4. Surface and catalog documents.
5. Master roadmap.
6. Implementation status.
7. Historical archive and legacy evidence.

An older decision remains evidence, not current authority, unless explicitly
adopted by this baseline or a Re-foundation ADR.

## Execution rule

Founder approves, rejects or requests changes. Nexus coordinates globally;
Stasis, Rector and Gerendi prepare and govern proposals in their domains.
No remote environment, clean Supabase project, 3,000-agent prompt generation or
legacy migration is authorized by this document.

## Companion documents

- [Product architecture](01_PRODUCT_ARCHITECTURE.md)
- [Surfaces](02_SURFACES_ARCHITECTURE.md)
- [Coordination](03_GLOBAL_COORDINATION.md)
- [Agent catalog](04_AGENT_CATALOG_ARCHITECTURE.md)
- [Data architecture](05_DATA_ARCHITECTURE.md)
- [Environments](06_ENVIRONMENTS.md)
- [Security](07_SECURITY_PRIVACY_AND_FOUNDER_ACCESS.md)
- [Legacy migration](08_LEGACY_MIGRATION_AND_ARCHIVE.md)
- [Roadmap](09_MASTER_ROADMAP.md)
- [Implementation status](10_IMPLEMENTATION_STATUS.md)
- [Glossary](11_GLOSSARY.md)

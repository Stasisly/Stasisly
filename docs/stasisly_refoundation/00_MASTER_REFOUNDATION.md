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
  simultaneously active. The catalog and 172 Wave 1-5 documentary prompts are
  implemented; runtime remains unimplemented.
- Historical prompts: 43 preserved as `PROMPT_CREATED` and mapped 43/43 in the
  Re-foundation crosswalk. Their content audit and migration-wave assignments
  are complete. Waves 1-5 provide approved documentary baselines; the
  historical sources remain intact and later waves have not started.
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

Prompt governance uses independently versioned constitutional, surface,
domain/family, agent, runtime, task and temporary-instruction layers. Prompt
text never grants runtime authority, tools, data or memory access.

Nexus, Stasis, Rector and Gerendi plus the exact 18 Wave 2 governance agents
have prompt version `1.0.0` in state
`PROMPT_CREATED/APPROVED/DOCUMENTED_ONLY`. They remain `NOT_AVAILABLE`; no
runtime configuration, tools or memory have been provisioned. Founder remains
an external human authority and cannot be impersonated or replaced by an agent.

The exact 40 Wave 3 Architecture, Data and Multi-Agent roles also have canonical
prompt version `1.0.0` in `DOCUMENTED_ONLY`. PostgreSQL is canonical, Supabase
is replaceable, Product uses a versioned API rather than MCP, and all described
platform components remain `NOT_IMPLEMENTED`.

The exact 50 Wave 4 Product Core, Safety, Memory and Research roles likewise
have prompt version `1.0.0` in `DOCUMENTED_ONLY`. Their contracts protect user
safety, consent, provenance, deletion, uncertainty and human escalation.
Product, memory and research runtime remain `NOT_IMPLEMENTED`; no agent is
available.

The exact 60 Wave 5 Development Core and Engineering Operations roles have
prompt version `1.0.0` in `DOCUMENTED_ONLY`. They define bounded engineering
work, isolated workspaces, reviewable Git diffs, preserved tests, environment
promotion gates and secure client/backend boundaries. Development Surface,
runners and engineering runtime remain `NOT_IMPLEMENTED`; no agent is
available.

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
## Wave 6 Administration prompt baseline

Fifty Administration prompts are `APPROVED_DOCUMENTARY_BASELINE`. They define bounded business-operation, Growth and administrative governance only. Administration Surface, payments, billing, marketing campaigns, Growth experiments and agent runtime remain `NOT_IMPLEMENTED`; available agents and P15-P17 executions remain `0`.

## Wave 7 specialized prompt strategy

The original 2,778 Wave 7 catalog agents have an approved strategy assignment.
Composable components, individual identity, most-restrictive precedence,
deterministic generation and individual evaluation are mandatory. The 89
subwaves are planning boundaries only; catalog states and availability do not
change until separately approved implementation and runtime gates pass.

## W7-001 documentary baseline

The first specialized subwave is approved for exactly forty HIGH-risk Administration `fraud_risk` identities. Its composable prompts, manifests and evaluations are documentary artifacts only. Fraud runtime, enforcement, tools, memories and agent availability remain unimplemented.

## W7-002 documentary baseline

The second specialized subwave is approved for exactly twenty CRITICAL Administration `people_incidents_continuity_surface` identities. Detection does not grant Emergency authority; people actions, incident command, continuity activation, production changes, crisis release and recovery execution remain human-authorized runtime concerns.

## W7-003 documentary baseline

The third specialized subwave approves exactly 45 HIGH-risk Administration
`privacy_legal_compliance` identities. They document bounded privacy, legal and
compliance analysis but cannot execute rights requests, provide final legal
authority, certify compliance, notify regulators, delete data or approve
exceptions. W7-004 through W7-006 are approved; W7-007 through W7-089 remain `NOT_STARTED`.

## W7-004 documentary baseline

The fourth specialized subwave approves exactly 22 HIGH-risk Administration
`subscriptions_billing_finance` identities. They analyze payments operations and
financial reconciliation without moving money, issuing refunds, mutating
ledgers, approving providers or changing entitlements.

## W7-005 documentary baseline

The fifth specialized subwave approves exactly ten CRITICAL Development
`devops_sre_observability` incident-command identities. They analyze and
coordinate bounded evidence without declaring or closing incidents, executing
commands, deploying, rolling back, mutating infrastructure, suppressing alerts
or communicating externally.

## W7-006 documentary baseline

The sixth specialized subwave approves exactly seven HIGH Development
`integrations_commerce_stores` payment-engineering identities. They design
provider-independent contracts with idempotency, webhook verification and
reconciliation boundaries but cannot execute payments, mutate ledgers or
commerce state, access credentials, approve providers or submit store actions.
W7-007 through W7-089 remain `NOT_STARTED`.

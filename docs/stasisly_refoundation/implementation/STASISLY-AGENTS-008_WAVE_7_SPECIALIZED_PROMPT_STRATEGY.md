# STASISLY-AGENTS-008 - Wave 7 Specialized Prompt Strategy

## Status

`APPROVED_STRATEGY_BASELINE`

## Scope

This package classifies all 2,778 agents left after Waves 1-6. It defines a
composable architecture, 342 family records, 342 specialty modules, 11 safety
and authority overlays, individual identity and effective-manifest schemas,
five prompt strategies and 89 exhaustive risk-ordered subwaves.

## Baseline and inventory

The package starts from `f9a91257b08884590e55c53a6ba347415f1b925a`
on synchronized `main`, with a clean worktree and `SAFE` remote context. The
catalog remains 3,000 records: 222 prompt-created and 2,778 not-created. The
derived inventory preserves IDs, hierarchy, reports-to, surfaces, domains,
families, specialties, risks and lifecycle fields without editing the catalog.

## Evidence

```text
Catalog records: 3000
Existing documentary prompts: 222
Remaining strategy assignments: 2778/2778
Risk: LOW 549, MODERATE 1504, HIGH 549, CRITICAL 176
Strategies: FULL 757, FAMILY_IDENTITY 997, FAMILY_SPECIALTY 288
Strategies: PARAMETERIZED 735, DEFERRED_REDESIGN 1
Subwaves: 89
Duplicate or unassigned agents: 0
Specialized prompts created: 0
Specialized evaluations created: 0
Catalog state transitions: 0
Runtime, tools and memories provisioned: 0
Agents available or active: 0
```

## Architecture

The effective prompt composition and precedence are defined by ADR-RF061 and
ADR-RF063. Every agent retains an individual identity and evaluation under
ADR-RF062 and ADR-RF065. Deterministic manifests and generated-artifact rules
are governed by ADR-RF064 and ADR-RF067.

## Prompt strategies and risk

`FULL_INDIVIDUAL_PROMPT` is mandatory for HIGH/CRITICAL, coordination,
sensitive, privileged or singular-authority cases. Stable bounded families use
`FAMILY_PLUS_IDENTITY`, `FAMILY_PLUS_SPECIALTY_MODULE` or
`PARAMETERIZED_SPECIALIST`; one insufficient singleton is
`DEFERRED_REDESIGN`. Risk remains catalog-derived and gains explicit data, tool
and coordination drivers plus proportional reviewers.

## Families, modules and overlays

Families are scoped by surface, domain and catalog family, with homogeneous
risk and deny-by-default identity-bound data/tool/memory access. Any differing
member ceilings remain individual rather than inherited. Specialty modules add
terminology and bounded behavior only. Eleven overlays cover clinical, crisis,
minor, finance, privileged access, security, privacy, legal, moderation,
production and Founder boundaries.

## Identity and manifests

Each agent requires its own identity contract. Effective manifests bind ordered
component versions and content hashes. Constitutional and safety rules precede
surface, domain, family, specialty and identity; runtime, task and temporary
inputs are lower. Conflicts resolve to the most restrictive ceiling or fail
closed.

## Generation, evaluation and approval

The documentary generator reads the canonical catalog, derives strategy views
and rejects count, state, family, module or subwave inconsistency. A future
effective-prompt generator must reproduce hashes and may not auto-approve.
Families, modules and overlays may be batch-reviewed, but every agent still
requires individual identity, composition, risk, P0-P14 and adversarial results.
P15-P17 remain outside this package.

## Versioning and impact analysis

Schemas, families, modules, overlays, identities, evaluations and effective
prompts version independently. `PROMPT_COMPONENT_IMPACT_INDEX_v1` is the future
derived index for affected agents, hashes, evaluations, subwaves and superseded
versions. Generated effective artifacts are never manually edited.

## First subwave

`W7-001` contains 40 HIGH Administration agents in `fraud_risk`. It contains
five whole families and uses `FULL_INDIVIDUAL_PROMPT` for every member. It is a
plan only and requires separate Founder authorization.

## Tests and looping

The implementation loop corrected family compatibility modeling and rejected a
cross-domain packing attempt before finalizing the domain-preserving plan.
Focused tests cover deterministic generation, counts, assignments, component
references, subwaves, states, schemas, precedence, ADRs, CSV/JSON parity and
unchanged historical/Wave 1-6 content. Full Flutter, Deno, SQL and remote-context
regression is required before commit.

Final regression evidence:

```text
Focused Wave 7 tests: 10/10 PASS
Flutter analyze: 0 errors, 0 warnings, 36 inherited infos
Flutter test: 1080 PASS, 5 approved skips, 0 failures
Deno format: 62 files PASS
Deno test: 86/86 PASS
SQL local: 740/740 PASS after no-seed reset
Remote context: SAFE
Remote actions: 0
```

## Security and privacy

All shared components are deny-by-default. The minimum applicable authority,
data, tool and memory ceiling wins. No health-data access is granted to Growth
or Marketing, no runtime binding is created and no secret or remote target is
read by this package.

## Boundaries

No final specialized prompt, evaluation suite, runtime, tool, memory, remote
action, catalog mutation or agent activation is included. All pending records
remain `NOT_CREATED`, `CATALOGED`, `NOT_IMPLEMENTED` and `NOT_AVAILABLE`.

## Readiness and residual debt

The strategy baseline is ready when all 33 gates, focused tests, complete
regression, Git review, commit and push pass. Residual debt is intentional:
2,778 prompts and evaluations remain uncreated, the deferred redesign needs a
separate decision, P0-P17 remain unexecuted for this scope and runtime remains
absent.

## Next gate

`STASISLY-AGENTS-009 - Wave 7 Subwave W7-001 Administration High-Risk Prompts`
is the only proposed continuation.

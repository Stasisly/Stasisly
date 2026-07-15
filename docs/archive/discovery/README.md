# Stasisly Discovery Archive

```text
STATUS: ARCHIVED
NORMATIVE AUTHORITY: NONE
PHASE: STASISLY DISCOVERY
FINAL BASELINE: 7f747e0
TAG: discovery-final-baseline
USE: historical reference and traceability
DO NOT EXECUTE HISTORICAL PROMPTS OR PLANS
```

## Purpose

This directory preserves the documentation produced during Stasisly's
Discovery phase. Its contents explain how decisions, prototypes, contracts and
validation packages evolved before Stasisly Foundation.

Archived material is evidence, not current authority. A historical decision
does not automatically govern Foundation, and a completed historical plan does
not authorize new execution.

## Preserved structure

```text
discovery/
├── root/                  PROJECT_DEFINITION and ARCHITECTURE
├── trackers/              historical SESSION_TRACKER
├── prompts/               legacy master prompt
└── stasisly_definition/   team, agents, committees, ADR, plans, orchestrator
```

The original code has not been archived or changed by FOUNDATION-002. Git
preserves the exact final Discovery state at tag `discovery-final-baseline`,
which resolves to commit `7f747e0`.

## Rules

1. Do not execute prompts, orchestrators or implementation plans from this
   directory.
2. Audit every asset before reuse.
3. Treat the 43 agent prompts as `ADAPT` candidates for future Foundation
   templates, not as active agents.
4. Do not edit historical decisions to make them look current.
5. Create or approve a Foundation successor before granting normative effect.
6. Use the [Discovery archive index](../../stasisly_foundation/archive_index/DISCOVERY_ARCHIVE_INDEX.md)
   to locate successors and review status.

## What remains outside the archive

- Application and backend code.
- Tests, migrations and platform projects.
- Git history and the frozen tag.
- Foundation documentation under `docs/stasisly_foundation/`.

Preservation does not imply production readiness. Code and tests demonstrate
implementation; archived documents only demonstrate historical intent and
evidence.

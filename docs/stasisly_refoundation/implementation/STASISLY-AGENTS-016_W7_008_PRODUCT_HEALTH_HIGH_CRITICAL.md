# STASISLY-AGENTS-016 - W7-008 Product Health HIGH CRITICAL

## Objective and baseline

Resolve and implement the documentary W7-008 prompt baseline from commit
`3cc69fe97307eae1c1fa763f88474949681ca27c` without remote, runtime, medical,
privacy, user-data or production operations.

## Resolved scope

```text
Subwave: W7-008
Agents: 90 (exact non-contiguous set from AG-PRO-0071 through AG-PRO-0520)
Surface / domain: PRODUCT / health
Risk: 75 HIGH; 15 CRITICAL
Strategy: 90 FULL_INDIVIDUAL_PROMPT
Families / modules: 6 / 6
Overlays: CLINICAL_SAFETY;FOUNDER_EXCLUSIVE when reserved;PRIVILEGED_ACCESS and PRODUCTION_MUTATION when cataloged
Deferred redesign: 0
```

## Artifacts and evaluation

Ninety identities, effective prompts, manifests and evaluations are composed
from versioned constitutional, Product, health, family, specialty and
restrictive overlay components. The 2,880 sections, 1,350 P0-P14 checks, 900
adversarial cases and 570 risk-tier reviews pass individually. Generation is
byte-stable and component hashes reproduce deterministically.

## Clinical, authority and coordination boundaries

Clinical coordination, cardiology, endocrinology, dermatology, consultation
preparation and clinical safety escalation remain distinct. Guidance is
non-diagnostic and cannot prescribe, select treatment, replace care, perform an
emergency action, decide consent or capacity, mutate a health record or operate
production. Qualified humans retain medical authority. Stasis governs Product
coordination; Nexus, Rector, Gerendi and Founder receive bounded escalations.

## Data, tools, memory and models

Sensitive health data is purpose-limited, minimum-necessary, consent-aware,
redacted and user/tenant/case-scoped. Catalog tool and memory classes are
ceilings, not grants. Tools and memory are not provisioned, models are not
configured, and no agent is available.

## Catalog and readiness

The 90 records transition to `PROMPT_CREATED` and `DOCUMENTED_ONLY`; 556 prompts
are documented and 2,444 remain `NOT_CREATED`. All 3,000 agents remain
`NOT_AVAILABLE`; W7-009 through W7-089 remain `NOT_STARTED`, and P15-P17 remain
unexecuted.

## Verification

The generator was run twice with identical output. Focused W7-008 tests pass
10/10, cumulative tool and architecture tests pass 626/626, and the full
Flutter suite passes 1,150 tests with the five previously approved skips.
Analyzer remains at the inherited baseline of zero errors, zero warnings and 36
infos. Deno formatting covers 62 files and all 86 Deno tests pass. A local-only
Supabase reset applies migrations 00001-00012 and all 740 SQL tests in 24 files
pass. The remote-context preflight remains `SAFE` before local SQL validation.

No historical source, Wave 1-6, W7-001 through W7-007, future W7-009 through
W7-089, environment, migration, Edge Function or functional Flutter artifact is
changed. Counters remain zero for remote actions, remote Supabase mutations,
database schema changes, user-data mutations, production mutations, clinical
decisions, diagnoses, prescriptions, consent or capacity decisions, runtime
agents, activation, tools, memories, models and P15-P17 execution.

## Residual debt and stopping boundary

The remaining 2,444 agents retain `NOT_CREATED`, `NOT_IMPLEMENTED` and
`NOT_AVAILABLE` where applicable. W7-009 is the next planned documentary
subwave, but it is deliberately not started by this package. Runtime creation,
tool and memory provisioning, model configuration, activation and P15-P17 all
require separate future authorization.

```text
STASISLY-AGENTS W7_008_PRODUCT_HEALTH_HIGH_CRITICAL_PROMPTS_APPROVED_LOCAL_AND_PUSHED
```

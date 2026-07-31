# STASISLY-AGENTS-001 - Prompt Migration and Waves

## Objective

Audit all 43 historical prompts, define canonical prompt governance and assign
the 3,000-agent catalog to ordered design waves without implementing prompts or
runtime.

## Baseline

Source SHA `37c2525660393a5269ff14050dae6ef1191f11f9`; `main` clean and
synchronized; remote context `SAFE`.

## Historical audit

All 43 source files were read from the Discovery archive and mapped to unique
catalog IDs. The audit records 23 fields per prompt in CSV and JSON, with a
human Markdown index. Historical files remain unchanged.

## Migration decisions

The prior decisions are confirmed: 40 `MIGRATE_AND_UPDATE` and three
`RECLASSIFY`. No prompt qualifies for unchanged migration because all lack the
new layered metadata, independent version tuple and approval/evaluation binding.

## Reuse and alignment

Forty prompts are `MOSTLY_REUSABLE` but require major structural updates. Three
are `PARTIALLY_REUSABLE` and require surface reclassification. Reusable role
expertise is separated from repeated global policy and fixed committee framing.

## Contradictions

There are zero critical authority grants, three high reclassification
conflicts, 40 moderate structural conflicts and 43 editorial shared-policy
cleanup candidates. Historical high-risk phrases are prohibitions, not grants.

## Prompt architecture

Layers 0-6 separate constitutional, surface, domain/family, agent, runtime,
task and temporary instructions. Precedence fails closed and prompt text never
grants authority.

## Template and metadata

The canonical template defines 32 sections and 22 metadata fields. Approval
defaults to `DRAFT`, with `approved_by: NONE` and `approved_at: NONE`.

## Versioning and lifecycle

Prompt schema, agent prompt, runtime configuration and evaluation versions are
independent. Prompt creation, approval, configuration, testing and availability
are distinct states.

## Gates and evaluation

P0-P14 cover documentary design and approval. P15-P17 remain future runtime,
testing and availability gates. The evaluation template defines 16 required
behavior and safety categories.

## Change governance

Prompt Owner, Surface Prompt Steward, Domain, Security, Privacy and Evaluation
reviewers are separated. Founder approval is reserved for constitutional,
Founder-only, critical authority/risk and emergency cross-surface changes.

## Waves

Wave 0 is this governance package. Assignments cover all 3,000 catalog agents:
Wave 1 has 4; Wave 2 has 18; Wave 3 has 40; Wave 4 has 50; Wave 5 has 60;
Wave 6 has 50; Wave 7+ defers 2,778 specialized entries.

## Wave 1

Wave 1 is exactly Nexus `AG-TRV-0001`, Stasis `AG-PRO-0001`, Rector
`AG-DEV-0001` and Gerendi `AG-ADM-0001`. They require new canonical prompts;
historical files are evidence inputs, not direct replacements.

## Security and limits

Remote actions, Supabase mutations, `.env` reads/changes, runtime agents, tool
permissions, memory provisioning, new individual prompts and historical prompt
rewrites are all zero.

## Validation evidence

The 11 focal prompt-governance tests and the 29 combined Re-foundation guards
pass. Full regression is 1,013 Flutter tests passed with five approved skips,
zero analyzer errors or warnings and 36 inherited infos. Deno formatting covers
62 files and all 86 tests pass. A no-seed local database reset applies
migrations `00001`-`00012`, followed by 740/740 SQL tests passing. The Supabase
remote-context preflight is `SAFE`; remote actions remain zero.

## Readiness

Governance is documented, audit is complete and migration is planned. Prompt
implementation is `NOT_STARTED`; runtime is `NOT_IMPLEMENTED`.

## Next step

After Founder review, `STASISLY-AGENTS-002` may migrate only the four Wave 1
coordinator prompts. It must not configure, test for runtime or activate them.

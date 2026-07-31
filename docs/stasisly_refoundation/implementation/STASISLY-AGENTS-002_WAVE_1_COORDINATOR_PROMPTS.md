# STASISLY-AGENTS-002 - Wave 1 Coordinator Prompts

## Objective and sources

Create documentary prompt baselines for Nexus, Stasis, Rector and Gerendi from
the Re-foundation catalog, prompt governance and preserved historical evidence.
No homonymous historical prompts existed, so all four record `supersedes: NONE`.

## Migration and architecture

Four canonical version `1.0.0` prompts implement layers 0-3 by versioned
reference and reserve layers 4-6 for future authorization. Each has 32 sections,
complete metadata, explicit authority states and a source migration record.

## Prompts and evaluations

The four prompts and four 16-category evaluation suites are under
`agents/prompts/wave_1/`. Evaluations are synthetic designs only. Five
role-specific adversarial cases are documented per coordinator.

## Gates and contradictions

P0-P14 produce 60/60 `PASS`. P15-P17 were not executed. The three high
STASISLY-AGENTS-001 reclassification contradictions belong to Waves 2 and 6 and
are explicitly deferred; none is falsely marked resolved by Wave 1.

## Catalog and security

Only the four canonical coordinator records transition to `PROMPT_CREATED`,
`APPROVED`, `DOCUMENTED_ONLY`; all 3,000 remain `NOT_AVAILABLE`. Historical
files, `.env`, functional code, Supabase and runtime bindings remain unchanged.

## Tests and readiness

Deterministic generator and architecture guards validate prompt sections,
metadata, source integrity, catalog parity, coordination, evaluation suites and
60 gates. Focal guards pass 39/39. Full regression passes 1,023 Flutter tests
with five approved skips, zero analyzer errors or warnings and 36 inherited
infos; Deno passes 86/86 after checking 62 files; local SQL passes 740/740 after
a no-seed reset. Remote-context preflight remains `SAFE`.

## Residual debt and next step

Runtime configuration, runtime evaluation, availability and activation remain
unimplemented. After Founder review, the bounded next package is
`STASISLY-AGENTS-003` for Wave 2 documentary prompts only.

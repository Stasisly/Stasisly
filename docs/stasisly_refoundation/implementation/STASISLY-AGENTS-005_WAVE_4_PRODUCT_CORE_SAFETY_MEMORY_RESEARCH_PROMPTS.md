# STASISLY-AGENTS-005: Wave 4 Product Core, Safety, Memory and Research Prompts

## Objective and scope

Establish the exact 50-agent Wave 4 Product documentary baseline assigned in
`AGENT_WAVE_ASSIGNMENTS_v1`, without changing IDs, taxonomy, historical source
files or runtime. The package migrates nine historical prompts and creates 41
new canonical prompts; reclassified migrations are zero.

Artifacts comprise 50 version `1.0.0` prompts, 50 evaluation suites and 15
Wave 4 reports. Every prompt has the canonical 32 sections and remains:

```text
approval_status: APPROVED_DOCUMENTARY_BASELINE
implementation_status: DOCUMENTED_ONLY
runtime: NOT_IMPLEMENTED
availability: NOT_AVAILABLE
```

## Product Core and Stasis

Stasis is the planned principal Product screen, bounded central coordinator and
interface to the multi-agent system. It coordinates Salud, Nutricion,
Entrenamiento and Wellness while preserving area ownership, transparent
handoffs, source attribution and user choice. It has no unlimited clinical,
emergency, data, tool or Founder authority.

Product Surface remains an architecture target for iOS, Android and Web. Future
delivery depends on identity, profile, consent, memory, conversation, research,
Agent Registry, Model Gateway, Stasis Engine, Product safety, observability and
audit. None is implemented by this package.

## Product safety and escalation

The prompts distinguish `MAY`, `MAY_WITH_APPROVAL`, `MUST_ESCALATE` and
`MUST_NOT`. They prohibit diagnosis, prescription, clinician replacement,
emergency minimization, unsafe diet or training, manipulation, discrimination
and presenting inference as fact. Salud, nutrition, training and wellness
guidance remains bounded.

Immediate danger, severe symptoms, medication, pregnancy, minors, eating
disorders, injury and mental-health crisis trigger qualified human or emergency
escalation as applicable. Founder escalation remains reserved for governance,
risk acceptance and constitutional decisions; it does not replace clinical
escalation.

## Memory and research

Federated memory contracts require consent, scope, provenance, timestamps,
confidence, retention, deletion, supersession and explicit conflict handling.
No agent silently overwrites conflicting memory. Provisioned memories remain
zero.

Research uses `QUICK`, `DEEP` and `STRATEGIC` modes with proportional evidence
quality, participant transparency, source attribution, uncertainty and decision
traceability. Research runtime remains `NOT_IMPLEMENTED`.

## Accessibility, inclusion and Product QA

The baseline covers visual, hearing, motor and cognitive accessibility,
comprehensible interaction, anti-discrimination, cross-area coherence and
Product QA. Accessibility and inclusion are acceptance conditions, not optional
presentation details.

## Evaluation and gates

Each suite covers the 16 canonical categories plus role-specific Product,
safety, memory and research categories. Five adversarial cases per agent produce
250 designed cases. P0-P14 contain 750 documentary `PASS` results. P15 runtime
configuration, P16 runtime testing and P17 availability are not executed.

The generator, catalog and focused architecture guards enforce exact scope,
metadata, sections, authority, evaluation coverage, historical immutability,
catalog totals, reports and ADRs. Corrections follow inspect, regenerate, test
and repeat until the local gates pass; failures never justify weakening a gate.

## Catalog transition

Exactly 50 Wave 4 records transition to `DOCUMENTED_ONLY` and remain
`NOT_AVAILABLE`. The cumulative catalog is 112 documentary records, 127
prompt-created records, 2,888 not-implemented records and 3,000 unavailable
records. CSV, JSON and Markdown views are generated from the same source.

## Verification and Git evidence

Focused generator and architecture guards precede the full Flutter, Deno, SQL
and remote-context regression. Git review uses explicit paths, `diff --check`,
an exact commit message and a normal push to `main`. No remote Supabase action,
deployment, secret mutation, Product runtime, memory runtime, research runtime,
tool provisioning or agent activation is in scope.

```text
Focused guards: 67/67 PASS
Flutter: 1054 PASS / 5 APPROVED SKIPS / 0 FAILURES
Analyzer: 0 ERRORS / 0 WARNINGS / 36 INHERITED INFOS
Deno: 86/86 PASS / 62 FILES FORMATTED
SQL local: 740/740 PASS AFTER NO-SEED RESET
Remote context: SAFE
Remote actions: 0
```

## Readiness and residual debt

```text
Wave 4 prompts: APPROVED_DOCUMENTARY_BASELINE
Product runtime: NOT_IMPLEMENTED
Memory runtime: NOT_IMPLEMENTED
Research runtime: NOT_IMPLEMENTED
Agents available: 0
```

Residual debt includes P15-P17, runtime contracts and implementation, clinical
validation, Product Surface delivery, memory and research stores, observability
and operational authorization. The next bounded package is
`STASISLY-AGENTS-006` Wave 5 Development Core; it is not executed here.

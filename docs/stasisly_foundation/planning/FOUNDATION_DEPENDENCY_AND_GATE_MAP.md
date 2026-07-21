# Foundation Dependency and Gate Map

## FOUNDATION-017 gate result

FOUNDATION-015-R1 and 016-R1 supplied canonical activation and physical legacy
retirement. FOUNDATION-017 passes G0-G7 locally with zero sensitive event
fields, zero critical/high accessibility findings and complete regressions.
Remote observability and G8-G10 remain closed.

## FOUNDATION-016-R1 gate result

FOUNDATION-013A-F, 014-R1 and 015-R1 provided the replacement and consumer
migration. R1 removes the final blocked Orchestrator source dependency; G0-G7
then pass for physical retirement and zero-reference evidence. G8-G10 remain
unauthorized.

## FOUNDATION-015-R1 gate result

FOUNDATION-013A-F and FOUNDATION-014-R1 supplied the contracts, composition and
consumer retirement required for local Product activation. FOUNDATION-015-R1
closes G0-G7 only; remote/product rollout gates remain unauthorized.

## FOUNDATION-014-R1 gate result

G0-G6 pass locally for Product consumer migration, static isolation, Flutter,
Deno, SQL and security review. G7 completes upon publication of this changeset.
The route-activation prerequisite is `READY`, but route registration remains a
separate FOUNDATION-015 decision. G8-G10 are not authorized.

## FOUNDATION-013F gate result

013F completes G0-G6 locally for canonical application use cases, typed state,
controllers, fail-closed providers and inactive composition. Package publication
completes G7. No G8-G10, Product route, active shell or remote action is
authorized.

## FOUNDATION-013F-R1 gate result

R1 completes G0-G6 locally with `OperationAttemptId`, explicit create/send
propagation, 563 Flutter passes/5 approved skips, Deno 86/86 and SQL 740/740.
Publication completed R1 G7. FOUNDATION-013F later became
`IMPLEMENTED_LOCALLY`; G8-G10 and
Product routing remain blocked.

## FOUNDATION-013E gate result

013E completes G0-G6 locally for canonical presentation and legacy freeze;
publication completes G7. FOUNDATION-013F application/composition is the next
separately approved dependency gate. Product routes and G8-G10 remain blocked.

## FOUNDATION-013D gate result

013D completed G0-G7 for canonical Message semantics. FOUNDATION-013E is now
implemented locally and its publication completes G7. G8-G10 and Product route
activation remain unauthorized.

## Status

**APPROVED.** This map governs sequencing; it does not authorize execution.

## Quality gates

| Gate | Requirement | Evidence | Applies when |
|---|---|---|---|
| G0 | Documentation approved | Owner, scope, decisions, acceptance and rollback recorded | Every package |
| G1 | Threat and risk reviewed | Threats, data, surfaces, environments and residual risk owned | Security/data/runtime impact |
| G2 | Architecture approved | Boundaries, contracts, dependencies and ADR decision accepted | Structural change |
| G3 | Local implementation complete | Exact files changed; fail-closed local behavior | Implementation packages |
| G4 | Tests complete | Focal plus proportionate regression suites pass | Any behavior change |
| G5 | Security review complete | Negative authorization, secrets, grants and logs reviewed | Security-relevant change |
| G6 | Documentation synchronized | Authority register, tracker and affected contracts agree | Every completed package |
| G7 | Commit and push complete | Explicit staging, clean worktree and branch synchronized | Package publication |
| G8 | Remote authorization | Named environment, operation, rollback and approver explicit | Any remote operation |
| G9 | Staging validation | Synthetic data, E2E, SLO/runbook and residual risks accepted | Staging promotion |
| G10 | Production approval | Privacy/legal, security, release, capacity, support and rollback accepted | Production only |

G8-G10 are never inherited from G0-G7.

## Structural dependencies

```text
FOUNDATION-005-R1
  -> FOUNDATION-006
    -> FOUNDATION-007 authorization/threat model [COMPLETED CONCEPTUALLY]
      -> FOUNDATION-008 owned identity/API contracts [COMPLETED LOCALLY]
        -> FOUNDATION-009 authorization context/PDP/PEP [COMPLETED LOCALLY]
          -> FOUNDATION-010 surface/environment enforcement boundaries [COMPLETED LOCALLY]
            -> FOUNDATION-011 backend authorization/owned API enforcement [COMPLETED LOCALLY]
      -> FOUNDATION-012 Product Conversation decisions [COMPLETED CONCEPTUALLY]
        -> FOUNDATION-013A contracts/adapters [COMPLETED LOCALLY]
          -> FOUNDATION-013B transactional creation [COMPLETED LOCALLY]
          -> FOUNDATION-013C lifecycle/history
          -> FOUNDATION-013D author/provenance
          -> FOUNDATION-013E legacy presentation/freeze [COMPLETED LOCALLY]
          -> FOUNDATION-013F-R1 stable operation attempts [COMPLETED LOCALLY]
            -> FOUNDATION-013F application/inactive Product composition [COMPLETED LOCALLY]
      -> FOUNDATION-014 Agent Constitution/Engine design
      -> FOUNDATION-015 backend security CI
        -> FOUNDATION-017 observability/limits/cost foundation
        -> FOUNDATION-018 portability audit
      -> FOUNDATION-016 privacy lifecycle
      -> FOUNDATION-019 Administration/Development plan
        -> FOUNDATION-020 staging readiness audit
```

FOUNDATION-013 requires both 011 and 012. FOUNDATION-020 evaluates all P2
dependencies relevant to the proposed staging scope; it does not execute G8.

FOUNDATION-007 satisfies G0-G2 for the conceptual authorization/threat model.
FOUNDATION-008 satisfies G0-G7 for its local owned identity/session/API scope.
FOUNDATION-009 satisfies G0-G7 after publication for typed contracts, local PDP
and one profile PEP, while full enforcement remains partial. FOUNDATION-010
satisfies G0-G6 with reproducible Flutter, Deno and two-cycle SQL evidence; its
package commit and push complete G7. FOUNDATION-011 satisfies G0-G6 with six
registered Product operations, shared local PDP/PEP, HTTP/Deno/SQL/Flutter
evidence and no remote action; its package commit and push complete G7.

FOUNDATION-012 satisfies G0-G2 for canonical terminology, lifecycle/ownership,
Stasis/specialist/runtime separation, target API/routes and legacy retirement.
It provides no G3 implementation evidence. FOUNDATION-013A now satisfies G0-G6
for canonical local contracts/adapters with Flutter 514/5 skips, Deno 72/72 and
SQL 649/649; publication completes G7. FOUNDATION-013B satisfies G0-G6 with two
SQL cycles at 684/684, Deno 76/76, Flutter 515/5 skips and two real local HTTP
harnesses ending `0|0|0|0|0|0|0`; publication completes G7. FOUNDATION-013C
satisfies G0-G6 with owner-scoped lifecycle/history, two SQL cycles 713/713,
Deno 85/85, Flutter 517/5 skips and local HTTP cleanup at seven ceros;
publication completes G7. FOUNDATION-013D satisfies G0-G6 for canonical
Message metadata and SQL visibility filtering; publication completes G7.
FOUNDATION-013E satisfies G0-G7. FOUNDATION-013F-R1 now satisfies G0-G6 for its
local scope; publication completes G7. FOUNDATION-013F is ready to resume under
its approved scope but remains not implemented.

## Surface dependency matrix

| Capability | Product | Development | Administration | Engine/Platform | Shared infrastructure |
|---|---|---|---|---|---|
| Authorization model | Consumer | Consumer | Consumer | Consumer | Policy enforcement |
| Identity/session | Primary user context | Separate dev context | Separate admin context | Service/execution identity | Validation and audit |
| Owned API | Public Product contracts | Tooling contracts | Business-operation contracts | Runtime/gateway contracts | Adapters only |
| Data | Product-owned views | Synthetic/test evidence | Authorized business views | Minimized context/memory | Storage, not universal ownership |
| Routes | Product-only | Dev-only guarded | Admin-only guarded | No Product route identity | Gateway policy |
| Agents | Product families under Stasis | Build/eval under Rector | Business agents under Gerendi | Runtime execution | Registry/audit services |

## Parallelism and stop rules

- Documentation may proceed in parallel only when it consumes approved terms
  and does not pre-decide another package.
- Implementation touching shared auth, routing, DTOs or environment gates is
  serialized until ownership is explicit.
- Stop on dirty/unexpected baseline, missing evidence, unapproved authority,
  real-data need, remote need or irreversible migration.
- A rollback never reconnects an unsafe legacy route or weakens deny-all.

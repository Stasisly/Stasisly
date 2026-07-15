# Foundation Dependency and Gate Map

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
    -> FOUNDATION-007 authorization/threat model
      -> FOUNDATION-008 owned identity/API contracts
        -> FOUNDATION-009 surface and legacy-route containment
        -> FOUNDATION-010 local identity adapter
          -> FOUNDATION-011 sessions/messages adoption
      -> FOUNDATION-012 Product taxonomy decisions
        -> FOUNDATION-013 first Product slice
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

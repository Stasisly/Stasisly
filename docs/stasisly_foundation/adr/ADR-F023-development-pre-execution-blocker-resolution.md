# ADR-F023 — Development pre-execution blocker resolution

## Status

```text
Decision: APPROVED
Implementation: IMPLEMENTED_LOCALLY
Remote execution: NOT_AUTHORIZED
```

## Context

ADR-F021 prepared Development without selecting a project or executing remote
work. Six local blockers remained: no composed runtime Product catalog, blocked
create smoke, no fixture lifecycle, unresolved idempotency retention, evidence
without executable schema validation and no safe smoke-result contract.

## Decision

1. Product specialist selection uses `SelectableSpecialistCatalog` and an exact
   public contract headed by `selectableSpecialistId`.
2. `AgentEntity`, `agent.id`, internal specialist keys and runtime/prompt data
   are not Product identity sources.
3. Stasis enables canonical create only after explicit user selection. Empty,
   unauthenticated, blocked and error states fail closed without demo fallback.
4. Development fixtures use one dedicated synthetic namespace, bounded setup,
   known ownership, serial execution and deterministic local-only cleanup.
5. Local validation requires two complete setup/flow/cleanup cycles with zero
   residual fixture counts.
6. Remote evidence and smoke results use closed, machine-readable schemas that
   exclude secrets, content and raw identifiers.
7. Idempotency retention is classified as
   `POST_DEVELOPMENT_OPERATIONAL_BLOCKER`. No duration or destructive cleanup is
   approved without evidence for replay safety, actor, cutoff and audit.
8. The deployment manifest remains unassigned, unapproved and not executed.
   Five remote skips remain disabled. FOUNDATION-019A remains a separate gate.

## Consequences

The future first Development run no longer needs to invent a specialist ID,
fixture protocol or evidence shape. It can use a verified backend reference and
an already rehearsed local lifecycle. This ADR does not approve a remote target,
operator, secret, deployment, migration, function deployment or remote test.

Sustained Development operation cannot start until the retention gate is
resolved by a focused backend decision. Health, Nutrition, Physical Training
and Mental Training remain without reactivated create CTAs.

## Security and rollback

Backend authorization remains final. Flutter never receives service-role
material and cleanup cannot target a non-local host or broad namespace. Rollback
is removal/revert of the FOUNDATION-019C commit; no remote or schema rollback is
needed.

## Acceptance evidence

- Product-safe catalog contract and strict parsing.
- Explicit selection and canonical create widget evidence.
- Two local API lifecycle cycles with exact cleanup.
- Evidence/fixture validators and negative tests.
- Flutter, Deno and SQL full-suite validation.
- Remote-context and Development no-network preflights remain SAFE.

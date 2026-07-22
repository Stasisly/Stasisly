# ADR-F021 - Development environment and controlled remote preparation

## Status

```text
Decision: APPROVED
Implementation: PREPARATION_IMPLEMENTED_LOCALLY
Remote execution: NOT AUTHORIZED
Remote validation: NOT EXECUTED
```

## Context

Product Conversation is locally active and hardened, but a remote Development
environment has no approved target, operator, secrets or execution evidence.
FOUNDATION-019B removed implicit Supabase CLI targeting. A controlled contract
is required before the Founder can consider any remote action.

## Decision

1. Development is a dedicated, isolated non-production environment.
2. It uses dedicated users and synthetic data; Production data is forbidden.
3. Client configuration selects both app environment and backend target
   explicitly, validates completeness and fails closed without fallback.
4. Secret names, classification, custody, rotation and revocation are governed;
   values remain outside Git and service-role material never enters Flutter.
5. Local preparation retains zero linked Supabase CLI context.
6. A read-only, no-network local preflight must pass before authorization.
7. The deployment manifest remains unassigned, unapproved and not executed.
8. Migration, schema drift, RLS, grants, functions, smoke tests and rollback are
   explicit future gates.
9. Founder authorization, exact target, operator and commit are mandatory
   immediately before any future remote execution.
10. Staging, Production, remote observability, AI and Stasis Engine remain
    unauthorized.

Preparation is not deployment; local validation is not remote validation; a
manifest is not authorization.

## Consequences

- Development cannot start from partial, placeholder, mismatched or implicit
  configuration.
- A future authorization package must identify the exact target without
  weakening the local guard.
- Remote tests remain classified and disabled.
- Runtime catalog, remote policy evidence and retention debt remain visible.
- No project, link, migration, function, secret or remote read/write is created
  by this decision.

## Verification

Evidence is maintained in
`implementation/FOUNDATION-018_DEVELOPMENT_ENVIRONMENT_AND_CONTROLLED_REMOTE_PREPARATION.md`,
the unapproved Development manifest, config tests, readiness tests and the
remote-context guard.

## Rollback

Revert the local configuration/readiness artifacts and this decision record.
Do not restore remote-link metadata, introduce fallback or weaken prior
Foundation controls.

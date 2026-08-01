# ADR-RF046: Engineering Work Uses Isolated Workspaces and Reviewable Diffs

## Status

Decision: `APPROVED`

Implementation:

```text
DOCUMENTARY_PROMPTS_IMPLEMENTED
DEVELOPMENT_SURFACE_NOT_IMPLEMENTED
RUNNERS_NOT_IMPLEMENTED
RUNTIME_NOT_IMPLEMENTED
AGENTS_NOT_AVAILABLE
```

## Decision

Future engineering work binds repository, base SHA, isolated branch or worktree, explicit file scope, tests, reviewable diff and rollback.

## Consequences

Unrelated work is preserved. Scope expansion, destructive Git and broad staging against package rules require refusal or explicit authorization.

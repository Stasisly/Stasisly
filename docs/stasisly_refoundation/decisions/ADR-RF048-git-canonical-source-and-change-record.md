# ADR-RF048: Git Is the Canonical Source and Change Record

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

Git records the authoritative repository state, base SHA, bounded diff, review and approved commit. Documentation may describe a target but cannot claim code or runtime absent from Git and verification evidence.

## Consequences

Force-push, destructive history rewrite and hidden changes are forbidden without exact authorization and recovery controls.

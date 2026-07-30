# ADR-F034 - Founder conversational authorization artifacts

## Status

```text
Decision: APPROVED
Implementation: IMPLEMENTED_LOCALLY
```

## Context

The first authorized v4 containment preparation stopped before remote access
because `.runtime/` was not ignored by Git. The same flow also depended on
manual authorization values in `.env`, mixing stable Development configuration
with a single-use Founder decision.

Conversational approval is the human decision. A runner nevertheless requires
a deterministic, machine-verifiable enforcement object tied to one operation,
environment, commit, manifest and runner.

## Decision

1. Founder approval is conversational and remains the human decision.
2. An approved prompt defines the operation that Codex may translate into a
   structured proposal.
3. Codex generates `FounderAuthorizationArtifactV1`; the Founder does not
   manually enter its ID, commit, manifest, runner, environment, scope or
   expiry.
4. Operational artifacts live below ignored `.runtime/authorizations/`.
5. `.runtime/`, its authorization, proposal, audit and lock directories use
   mode `0700`; artifacts, audit files and locks use `0600`.
6. Artifacts are commit-bound, environment-bound, manifest-bound,
   runner-bound, expiring and single-use.
7. SHA-256 covers deterministic canonical JSON. It detects local mutation but
   is not represented as a Founder cryptographic signature.
8. Allowed state transitions are `GRANTED -> CONSUMED`,
   `GRANTED -> REVOKED` and `GRANTED -> EXPIRED`.
9. Consumption uses an exclusive per-authorization lock, flushed temporary
   file and atomic rename immediately before the first remote action.
10. Existing or orphaned locks fail closed. Consumed, revoked and expired
    artifacts cannot return to `GRANTED` or be regenerated silently.
11. Runners validate artifacts rather than conversational free text.
12. Legacy authorization variables in `.env` are deprecated compatibility
    input. A matching legacy value is tolerated with deprecation; any conflict
    blocks. A valid artifact always remains primary.
13. Stable Development configuration and credentials may remain environment
    inputs; they do not constitute Founder authorization.
14. Local audit records contain only authorization metadata and state
    transitions, never secrets or remote resource handles.
15. The R2H containment HTTP and deletion behavior is unchanged.

## Consequences

- A new remote operation requires a new conversational approval and artifact
  tied to the post-package commit.
- `.env` cannot override an artifact.
- Concurrent consumption yields one consumed execution; every other process
  fails closed.
- Unsupported permission enforcement, tracked runtime paths, invalid hashes,
  wrong bindings, expiration and stale locks block before remote access.
- Legacy-only authorization remains detectable but is not the primary R2H
  execution path.

## Validation

Storage, permissions, schema, canonical hashing, invalid fields, bindings,
expiry, revocation, single and parallel consumption, atomic-write failure,
orphan locks, regeneration and legacy compatibility are covered locally.
Repository architecture guards verify the narrow ignore rule and R2H artifact
integration.

## Security

The artifact contains no Supabase secret, token, password, JWT, connection
string, run alias, synthetic identity or resource identifier. This package
performs no remote action and creates no executable authorization artifact.

# FOUNDATION-019B-B - Failed-run authorization bindings

## Status

```text
Implementation: IMPLEMENTED_LOCALLY
Remote execution: FORBIDDEN
Publication: PENDING_PACKAGE_COMMIT
```

## Block and V1 limitation

The approved v4 containment stopped before remote because strict ArtifactV1 had
no representation for the failed authorization, commit, manifest, runner,
result, last reached state or failure category. Adding those fields to V1 would
silently change an already strict contract.

## V2 decision and subject run

`FounderAuthorizationArtifactV2` uses schema `founder-authorization-v2` and
retains every general V1 binding. It adds an exact `subject_run` object:

```text
authorization_reference
commit_sha
manifest
runner
result
last_reached_state
failure_category
```

It contains no aliases, request keys, user/resource identifiers, emails or raw
remote evidence.

## Applicability

V2 is mandatory for failed-run diagnostic, containment, combined
diagnostic/containment and forensic-review operations. V1 plus one of those
operations is schema-insufficient. V2 with a missing subject run and a general
operation carrying a subject run both fail closed.

## Authority and cross-validation

The versioned containment manifest defines the expected historical run. The V2
artifact records the approved historical run. R2H compares all seven fields
without normalization and proceeds only when
`AUTHORIZATION_FAILED_RUN_BINDINGS_MATCH` is established.

## Integrity and lifecycle

Recursive canonical JSON includes the complete nested object in
`payload_sha256`. Field ordering does not affect the digest; mutation, removal
or addition does. `GRANTED -> CONSUMED` changes lifecycle evidence and hash but
preserves `subject_run` unchanged.

## Unknown-field policy

V2 accepts only declared top-level and nested fields. Missing, null, scalar,
array, partial and unknown nested forms are rejected. SHA-256 remains local
mutation evidence and is not a Founder signature.

## Generator

The official generator selects V2 from the approved operation and reads the
seven bindings from the versioned containment manifest path in
`docs/stasisly_foundation/development/`. It checks manifest version, runner
version and artifact schema before granting. The Founder supplies no technical
bindings manually.

## R2H and manifest

The executable authorization change versions:

```text
Manifest: FOUNDATION-019A-V4-DIRTY-RUN-CONTAINMENT-v2
Runner: FOUNDATION-019A-R2H-CONTAINMENT-RUNNER-v2
Artifact schema: founder-authorization-v2
```

Run identity, HTTP gateway, seven counters, Conversation/idempotency diagnosis,
containment order and canonical-resource protection are unchanged.

## Compatibility

```text
V1 general operation: VALID
V1 failed-run operation: BLOCK_SCHEMA_VERSION_INSUFFICIENT
V2 failed-run operation with exact subject_run: VALID
V2 missing or partial subject_run: BLOCK
V2 general operation with subject_run: BLOCK
legacy authorization conflict: BLOCK
artifact-only path: PRIMARY
```

No consumed V1 artifact is migrated.

## Audit

Sanitized audit records include artifact schema, operation, subject-run binding
status, matched general bindings, lifecycle transition, timestamp and final
classification. They exclude handles, identities, aliases and remote payloads.

## Guards and tests

Local schema, binding, integrity, lifecycle, compatibility, architecture and R2H
tests cover every subject field, wrong schema, missing/unknown shapes, canonical
hashing, immutable consumption, generator derivation, V1 rejection, expiry,
consumption, corrupt hash and legacy conflict. R2H rejection tests invoke no
gateway and no remote action.

Validated evidence:

```text
focal tests: 88 pass
containment simulations: 11/11 pass
Flutter: 926 pass / 5 approved skips / 0 failures
Analyzer: 0 errors / 0 warnings / 36 inherited infos
Deno: 86/86 pass; format 62 files
SQL local: 740/740 pass after no-seed reset
remote context: SAFE
```

## Security

```text
remote actions: 0
authorization artifacts consumed: 0
authorization artifacts committed: 0
secret reads: 0
.env modifications: 0
resource creations or mutations: 0
schema or backend changes: 0
```

## Readiness and next authorization

Readiness becomes
`FOUNDATION-019B FAILED_RUN_AUTHORIZATION_BINDINGS_READY_LOCAL_AND_PUSHED` only
after full local regression, explicit commit and push.

`FA-019A-V4-CONTAIN-20260730-009` and
`FA-019A-V4-CONTAIN-20260730-010` remain unconsumed, superseded and non-reusable.
A new conversational Founder approval must bind to the resulting full SHA,
containment manifest v2 and runner v2. No `.env` or artifact editing is needed.

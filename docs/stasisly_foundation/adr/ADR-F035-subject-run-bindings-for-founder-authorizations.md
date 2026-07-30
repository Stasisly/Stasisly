# ADR-F035 - Subject-run bindings for Founder authorizations

## Status

```text
Decision: APPROVED
Implementation: IMPLEMENTED_LOCALLY
```

## Context

`FounderAuthorizationArtifactV1` deliberately rejects unknown fields and cannot
represent the historical run targeted by a failed-run diagnostic or containment
operation. R2H previously received those bindings from runtime variables and the
containment manifest, so the approved operation was not fully commit-, manifest-
and evidence-bound inside its authorization artifact.

## Decision

1. General operations continue to use strict `founder-authorization-v1`.
2. Failed-run operations require strict `founder-authorization-v2`.
3. V2 adds exactly one structured `subject_run` object containing:
   `authorization_reference`, `commit_sha`, `manifest`, `runner`, `result`,
   `last_reached_state` and `failure_category`.
4. `subject_run` is mandatory for failed-run diagnostic, containment, combined
   diagnostic/containment and forensic-review operations.
5. `subject_run` is forbidden for unrelated operations.
6. Every nested binding participates in canonical SHA-256 integrity hashing.
7. Unknown, partial, null, scalar, array or conflicting bindings fail closed.
8. The versioned containment manifest is the expected-value authority; the
   artifact is the approved-value authority; R2H validates exact equality.
9. The generator derives the seven bindings from the versioned manifest. The
   Founder does not enter them manually.
10. R2H uses containment manifest v2 and runner v2 because authorization is part
    of its executable contract.
11. Lifecycle transitions preserve `subject_run` unchanged.
12. FOUNDATION-019B-B performs no remote action.

## Consequences

- V1 artifacts remain compatible for general operations.
- V1 artifacts are insufficient for failed-run operations.
- V2 cannot carry unrelated subject-run metadata.
- R2H cannot consume an artifact until all seven historical bindings match.
- Existing consumed V1 artifacts are not migrated or regenerated.
- A future remote containment requires a new conversational authorization bound
  to the published SHA, manifest v2 and runner v2.

## Security

`subject_run` contains no run alias, operation-attempt identifier, idempotency
key, Auth ID, Conversation ID, email, resource handle, raw evidence or remote
response. SHA-256 provides mutation evidence, not a Founder signature.

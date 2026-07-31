# ADR-RF038: Federated Product Memory Requires Consent, Provenance and Scoped Access

## Status

Decision: `APPROVED`

Implementation:

```text
DOCUMENTARY_PROMPTS_IMPLEMENTED
PRODUCT_RUNTIME_NOT_IMPLEMENTED
MEMORY_RUNTIME_NOT_IMPLEMENTED
RESEARCH_RUNTIME_NOT_IMPLEMENTED
AGENTS_NOT_AVAILABLE
```

## Decision

Product memory is federated by explicit scope and requires consent, provenance,
timestamp, confidence, retention, deletion and supersession. Inference is not
fact, and conflicts remain visible until explicitly resolved.

## Consequences

No agent may silently overwrite memory, expand access or retain content beyond
policy. This ADR defines contracts only and provisions no memory store.

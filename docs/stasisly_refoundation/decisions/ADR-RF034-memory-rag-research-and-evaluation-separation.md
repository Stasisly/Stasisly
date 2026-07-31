# ADR-RF034 - Memory, RAG, Research and Evaluation Separation

Status: `APPROVED`

## Decision

Memory, retrieval indexes, research evidence and evaluations have separate contracts, provenance, retention and access. RAG provides attributed evidence; it is neither memory nor authority. `RUNTIME_NOT_IMPLEMENTED`; `AGENTS_NOT_AVAILABLE`.

## Consequences

No agent may infer a memory, retrieval, model or evaluation binding from its catalog or prompt record.

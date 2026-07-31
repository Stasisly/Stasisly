# ADR-RF039: Quick, Deep and Strategic Research Modes

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

Product research uses `QUICK`, `DEEP` and `STRATEGIC` modes. Each mode has
proportional evidence depth, review, participant visibility, source attribution,
uncertainty and decision traceability.

## Consequences

Research mode never upgrades evidence into certainty or grants execution
authority. No research orchestration or storage runtime is implemented.

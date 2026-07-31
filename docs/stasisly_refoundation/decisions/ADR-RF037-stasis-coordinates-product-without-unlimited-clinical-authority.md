# ADR-RF037: Stasis Coordinates Product Without Unlimited Clinical Authority

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

Stasis is the planned principal Product screen and bounded coordinator for
Salud, Nutricion, Entrenamiento and Wellness. Coordination never grants
diagnostic, prescriptive, emergency, clinical or unrestricted data authority.

## Consequences

Safety boundaries and qualified human escalation override convenience or
coordination. Stasis cannot silently override an area specialist or the user.

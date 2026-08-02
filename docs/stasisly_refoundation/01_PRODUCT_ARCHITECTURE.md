# Product Architecture

## Status

`APPROVED_ARCHITECTURE / NOT_IMPLEMENTED_AS_A_COMPLETE_PLATFORM`

## Initial structure

```text
Stasisly
├── Stasis — nucleus, coordinator and primary experience
├── Salud
├── Nutricion
├── Entrenamiento
└── Wellness
```

This structure is extensible. Examples of subareas are illustrative and never
create a closed catalog.

## Extensible hierarchy

```text
Area
→ area coordination
→ subarea
→ category
→ specialty
→ subspecialty
→ specialist
→ future extension
```

Every node requires a stable identifier, versioned contract, lifecycle state,
owner and explicit authorization boundary. New levels must preserve existing
references or define a migration.

## Product capabilities

Product may expose Stasis, areas, profile, memory, conversations,
investigations, specialists, subscriptions and settings. Their presence in the
architecture does not assert current implementation or operational readiness.

Stasis is the planned principal Product screen, central coordinator and user
interface to the multi-agent system. It coordinates Salud, Nutricion,
Entrenamiento and Wellness without diagnosis, prescription, clinician
replacement or unlimited clinical authority. Safety-sensitive requests require
bounded guidance, explicit uncertainty and human or emergency escalation.

Federated Product memory requires consent, scoped access, provenance,
timestamps, confidence, retention, deletion and explicit conflict handling.
Research is classified as `QUICK`, `DEEP` or `STRATEGIC`, with evidence quality,
participant transparency and traceability proportional to the mode. These are
documentary contracts; memory and research runtime are not implemented.

## Growth rules

- No hard-coded assumption may make the five initial areas permanent.
- Lists susceptible to growth require pagination and bounded queries.
- Areas may split into domains or services without forcing reconstruction of
  other surfaces.
- Data sharing between areas requires a versioned contract and authorization.
- Stasis coordinates; it does not acquire unrestricted access by default.
- Product UI consumes an API/backend contract and never depends directly on
  MCP.

## Deferred decisions

Final area taxonomy, Product domain (`stasisly.com` or `app.stasisly.com`),
memory implementation, research execution, subscriptions and production agent
activation remain phase-specific decisions.

Future Product Surface delivery depends on identity, profile, consent, memory,
conversation, research, Agent Registry, Model Gateway, Stasis Engine, Product
safety, observability and audit contracts. No dependency is implemented by the
Wave 4 prompt baseline.

## W7-008 Product health documentary boundary

W7-008 adds 90 documentary Product health specialists across clinical
coordination, cardiology, endocrinology, dermatology, consultation preparation
and clinical safety escalation. Their output is bounded guidance, not diagnosis,
prescription, treatment, emergency response or replacement of qualified care.
All agents remain unavailable; Product health runtime is not implemented.

## W7-009 Product health documentary boundary

W7-009 adds 90 HIGH documentary Product health specialists across
gastroenterology, geriatrics, gynecology, health education, health monitoring
and hematology. They may organize minimized evidence and prepare qualified
human review, but cannot diagnose, prescribe, select treatment, replace care,
perform emergency actions or mutate records. All agents remain unavailable.

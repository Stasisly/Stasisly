# Agent Prompt Architecture v1

## Status

```text
Governance: DOCUMENTED
Individual prompts: NOT_CREATED_BY_THIS_PACKAGE
Runtime configuration: NOT_IMPLEMENTED
Availability: NOT_AUTHORIZED
```

## Composition model

A future effective prompt is a resolved, immutable composition. Source layers
remain independently versioned and are never copied wholesale into every agent
file.

| Layer | Purpose | Owner | Mutability during execution |
|---|---|---|---|
| 0 | Global Stasisly constitutional rules | Founder-governed policy | none |
| 1 | Surface rules | Surface Prompt Steward | none |
| 2 | Domain and family rules | Domain Reviewer | none |
| 3 | Agent-specific definition | Prompt Owner | none |
| 4 | Runtime configuration | Runtime owner | deployment-bound only |
| 5 | Task context | Authorized coordinator | bounded per task |
| 6 | Temporary execution instructions | Authorized operator/coordinator | bounded and expiring |

## Precedence

Lower-numbered layers prevail. A later layer cannot broaden authority, data,
tools, memory, environment, surface or risk acceptance granted by an earlier
layer. Conflict resolution fails closed and records the conflicting layer IDs,
versions and policy decision without exposing hidden prompt content.

## Version bindings

Every composed prompt records independent references for constitutional,
surface, domain/family, agent prompt, runtime configuration and evaluation
versions. A content hash binds the resolved inputs. Changing one reference
requires impact review; it does not silently increment the others.

## Runtime boundary

Prompt text is not authority. Runtime enforces identity, authorization, data,
tool and memory boundaries outside the model. No prompt contains credentials,
tokens, provider secrets or service-role material. Catalog metadata never
provisions access.

## Extensibility

New surfaces, domains and providers register versioned layer contracts. They do
not edit unrelated layers or inherit Nexus/Founder authority. Shared policies
are referenced by ID and version so modules can evolve independently.

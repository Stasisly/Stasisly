# ADR-RF017 - Shared Policies Without Prompt Duplication

## Status

`Decision: APPROVED`

```text
Implementation: PROMPT_GOVERNANCE_DOCUMENTED
Historical prompts: HISTORICAL_PROMPTS_NOT_MIGRATED
New prompts: NEW_PROMPTS_NOT_CREATED
Runtime: RUNTIME_NOT_IMPLEMENTED
```

## Decision

Store constitutional, surface and domain/family policies once as versioned
layers. Agent prompts reference them and contain only differentiated role
instructions. Long shared policy text must not be duplicated into 3,000 files.

## Consequences

Shared fixes are traceable and can trigger targeted dependency review. Layer
registries contain policy metadata and hashes, never secrets or runtime grants.

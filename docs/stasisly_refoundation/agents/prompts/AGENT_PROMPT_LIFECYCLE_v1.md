# Agent Prompt Lifecycle v1

## Prompt states

`NOT_CREATED`, `DRAFT`, `UNDER_REVIEW`, `CHANGES_REQUESTED`, `APPROVED`,
`CONFIGURED`, `TESTED`, `AVAILABLE`, `SUSPENDED`, `SUPERSEDED`, `ARCHIVED`.

## Normal transitions

```text
NOT_CREATED -> DRAFT
DRAFT -> UNDER_REVIEW
UNDER_REVIEW -> CHANGES_REQUESTED
CHANGES_REQUESTED -> DRAFT
UNDER_REVIEW -> APPROVED
APPROVED -> CONFIGURED
CONFIGURED -> TESTED
TESTED -> AVAILABLE
AVAILABLE -> SUSPENDED
SUSPENDED -> AVAILABLE
APPROVED -> SUPERSEDED
CONFIGURED -> SUPERSEDED
TESTED -> SUPERSEDED
AVAILABLE -> SUPERSEDED
SUPERSEDED -> ARCHIVED
```

Direct `NOT_CREATED -> AVAILABLE`, `DRAFT -> CONFIGURED`,
`PROMPT_CREATED = AVAILABLE` and `ARCHIVED -> AVAILABLE` are forbidden.

## Agent lifecycle relationship

| Agent lifecycle | Permitted prompt condition |
|---|---|
| CATALOGED | NOT_CREATED or DRAFT |
| DESIGNED | DRAFT, UNDER_REVIEW or CHANGES_REQUESTED |
| PROMPT_CREATED | Prompt exists; approval is not implied |
| CONFIGURED | Approved runtime configuration exists |
| TESTED | Required evaluation gates passed |
| AVAILABLE | Approved, configured and tested |

Suspension or retirement of an agent blocks prompt availability regardless of
prompt state. This package changes no agent or prompt lifecycle state.

# Agent Lifecycle v1

```text
CATALOGED → DESIGNED → PROMPT_CREATED → CONFIGURED → TESTED → AVAILABLE
→ ACTIVE → SUSPENDED → RETIRED → ARCHIVED
```

States are evidence-based and do not advance automatically. `ACTIVE` is a
runtime state bounded by task, environment, permissions and budget.

## Gates

| Transition | Minimum evidence |
|---|---|
| Cataloged → Designed | mission, taxonomy, owner and risk |
| Designed → Prompt created | versioned prompt and boundaries |
| Prompt created → Configured | approved tools/models/policies |
| Configured → Tested | safety, quality, cost and failure tests |
| Tested → Available | release approval and observability |
| Available → Active | task authorization and minimum-team selection |
| Any → Suspended | incident, policy or quality trigger |
| Retired → Archived | replacement/migration and retained audit |

Historical prompts enter the crosswalk at `PROMPT_CREATED`, never `AVAILABLE`
or `ACTIVE` by assumption.

# Agent Prompt Versioning v1

## Independent versions

Maintain separate semantic versions for prompt schema, individual agent prompt,
runtime configuration and evaluation suite. Their release cadence and owners
are independent; every tested composition records all four.

## Semantic changes

| Level | Required when | Examples |
|---|---|---|
| MAJOR | Mission, authority, risk or surface changes | New surface; broader authority; changed critical escalation |
| MINOR | Compatible responsibility, tool or capability is added | New bounded output; approved read-only tool binding |
| PATCH | Non-functional correction or clarification | Typo; clearer refusal wording; equivalent example |

Format is `MAJOR.MINOR.PATCH`, beginning at `1.0.0` for the first approved
prompt. Draft iterations may use document revision metadata but cannot claim an
approved semantic release.

## Compatibility and supersession

Every release records `supersedes`, migration notes, policy compatibility and
required re-evaluation. Rollback restores a complete previously approved
version tuple; it never combines arbitrary old and new layers.

## Immutable evidence

Approvals bind agent ID, prompt version, policy versions, review evidence and
content hash. Editing approved content creates a new version.

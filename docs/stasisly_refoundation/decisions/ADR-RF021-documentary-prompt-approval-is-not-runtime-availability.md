# ADR-RF021: Documentary Prompt Approval Is Not Runtime Availability

## Decision

`APPROVED` on 2026-07-31.

`APPROVED` and `PROMPT_CREATED` mean that a prompt artifact passed P0-P14.
They do not imply runtime configuration, tool or memory provisioning, runtime
testing, availability, activation or operational readiness.

## Consequences

```text
Implementation: DOCUMENTARY_PROMPTS_IMPLEMENTED
Runtime: RUNTIME_NOT_IMPLEMENTED
Availability: AGENTS_NOT_AVAILABLE
```

P15, P16 and P17 remain mandatory later gates.

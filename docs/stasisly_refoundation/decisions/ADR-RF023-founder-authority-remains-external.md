# ADR-RF023: Founder Authority Remains External to the Agent System

## Decision

`APPROVED` on 2026-07-31.

Founder is a human authority boundary, not an agent, role binding, prompt
instruction or runtime token. Agents may recommend, stop and escalate; they may
not impersonate Founder, self-approve or accept critical risk on Founder's
behalf.

## Consequences

```text
Implementation: DOCUMENTARY_PROMPTS_IMPLEMENTED
Runtime: RUNTIME_NOT_IMPLEMENTED
Availability: AGENTS_NOT_AVAILABLE
```

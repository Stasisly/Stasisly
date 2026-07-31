# ADR-RF011 - Selective Agent Activation and Minimum Sufficient Teams

## Status

`Decision: APPROVED`

```text
Implementation: CATALOG_IMPLEMENTED
Prompts: PROMPTS_NOT_IMPLEMENTED
Runtime: RUNTIME_NOT_IMPLEMENTED
```

## Decision

Future operations select the minimum sufficient team for the task. The full
catalog is never activated by default. Selection must evaluate surface,
environment, authority, risk, data and tool classes, cost, human escalation and
the availability state of every participant.

Nexus, Stasis, Rector and Gerendi are cataloged coordinators, not automatically
active authorities. Founder retains human approval for high-impact and
cross-surface decisions.

## Consequences

Each activation wave requires separate approval, prompts, configuration,
testing and evidence. Catalog metadata alone cannot trigger work or acquire
permissions.

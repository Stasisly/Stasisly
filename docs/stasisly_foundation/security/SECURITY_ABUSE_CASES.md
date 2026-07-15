# Security Abuse Cases

## Status

Status: **ACTIVE security evidence**. These cases define prevention, detection,
response and evidence requirements; they are not executable tests yet.

## Mandatory cases

| ID | Abuse case | Prevention | Detection | Response | Required evidence |
|---|---|---|---|---|---|
| A01 | User accesses Administration | Surface-bound session/PEP; no admin routes/contracts | Cross-surface denial/anomaly | Deny, preserve session unless abuse policy triggers | Negative route/API policy test and audit event |
| A02 | Administrator accesses Development | Separate admin/developer contexts and APIs | Surface mismatch | Deny and review repeated attempts | Matrix and integration denial test |
| A03 | Developer uses development credential against production | Environment-bound identity/credential and promotion gate | Credential/environment mismatch | Deny, revoke exposed credential, investigate | Environment-negative test and incident record |
| A04 | Stasis requests Administration data | Agent surface/delegation and cross-surface PEP | Agent policy denial | Stop call; preserve trace; review prompt/context | Agent policy fixture and trace |
| A05 | Rector reads Product personal data without purpose | Purpose/data-scope policy; synthetic dev data | Sensitive data denial | Deny; revoke delegation if misuse | Purpose-negative policy test |
| A06 | Gerendi modifies code | No Development tools in Administration execution | Tool assignment denial | Stop execution and alert surface owner | Tool allowlist and cross-surface test |
| A07 | Nexus assumes Founder Authority | Founder-reserved decision policy; no inherited credentials | Governance/policy violation | Deny and escalate to Founder | Reserved-decision matrix test |
| A08 | Agent expands its tools | Immutable execution scope; Tool Gateway PEP | Unknown/unassigned tool request | Deny, stop or suspend agent on pattern | Tool policy/eval and audit trace |
| A09 | Prompt injection requests secrets | Secrets excluded from context; external tool/data policy | Injection/tool/egress signals | Deny tool/data access; isolate content and review | Adversarial eval and no-secret evidence |
| A10 | User manipulates `ownerUserId` | Strict DTO allowlist; owner derived backend-side | Contract violation | Reject entire request; no partial action | Contract and ownership tests |
| A11 | User manipulates surface or role | Server-derived context; reject internal authority fields | Input/policy mismatch | Deny without fallback | Negative DTO and surface tests |
| A12 | Stolen token reused in another surface | Surface/audience-bound context and assurance | Replay/surface anomaly | Deny and revoke relevant sessions/tokens | Cross-surface replay test and auth event |
| A13 | Founder elevation reused outside scope | Operation/resource/surface/environment binding and expiry | Scope/expiry mismatch | Deny, revoke elevation, alert and review | Elevation negative matrix and protected event |
| A14 | Service identity used interactively | Non-interactive authentication path and workload binding | Interactive pattern/anomalous source | Deny, rotate/revoke and investigate | Service-identity authentication test |
| A15 | Compromised AI provider exfiltrates context | Minimum provider payload, adapter isolation and no credentials | Egress/content/provider anomaly | Circuit break, revoke route/credential, incident process | Egress contract and provider-failure test |
| A16 | Expensive tool call consumes without limit | Per-call/user/execution budget and confirmation where needed | Budget/rate threshold | Deny/throttle/cancel and alert | Budget-policy tests and usage event |
| A17 | Poisoned memory influences later decisions | Provenance, trust, validation, versioning and bounded retrieval | Source/drift/anomaly review | Quarantine, revoke/revert memory and reassess outputs | Provenance/revocation/evaluation evidence |
| A18 | Operator deletes or changes audit | Separation of duties and protected append/retention model | Integrity/sequence gap or privileged mutation | Preserve alternate evidence, contain actor, incident review | Audit-integrity tests and access review |
| A19 | Wearable submits false/replayed data | Device link, freshness, provenance and plausibility checks | Replay/conflict/anomaly | Quarantine data; revoke device trust; notify workflow | Device replay/provenance tests |
| A20 | Request changes environment through fallback | Explicit environment, no fallback, environment-bound credentials | Missing/mismatch environment | Deny; never downgrade; alert on production target | Fail-closed environment tests |

## Common acceptance rule

Each implementation package converts relevant cases into negative tests at all
applicable PEPs. Detection must avoid sensitive payloads; response must preserve
evidence and never increase authority. Cases involving production, remote,
Founder elevation, providers or real data require separate approval.

# Founder Access and Elevation Model

## Status and constitutional invariant

```text
Conceptual decision: APPROVED
Implementation: NOT IMPLEMENTED
```

Founder remains the exclusive final human authority and retains the protected
potential to access the complete system. This is not an ordinary `super_admin`,
an always-on universal session or authority transferable to Nexus, agents,
operators, services or providers.

## Founder Standard Authority

Ordinary capabilities include global read views, roadmap and decision
approval/rejection, governance actions, audit review, entry into each surface,
strategic configuration, and agent/provider oversight.

Standard authority does not automatically expose secrets, raw database
mutation, destructive production actions, unlogged data access or a permanent
elevated session. Surface and environment context remain explicit.

## Founder Elevated Authority

Elevation covers exact high-risk operations such as production-sensitive data,
critical configuration, root permission changes, provider credential
management, destructive actions, remote migrations, security overrides,
high-impact agent activation and emergency financial controls.

Every elevated operation requires, proportionate to risk:

- strong re-authentication and multi-factor assurance;
- explicit purpose, action/resource scope, surface and environment;
- bounded duration where applicable;
- independent approval for future policy-defined critical actions;
- audit event, notification, revocation and post-action review;
- no propagation to another surface, environment or operation.

Elevation grants capability, not a second identity. Failure to satisfy an
obligation denies the operation.

## Founder Emergency Authority

Emergency Authority is a restricted conceptual break-glass path for recovery,
containment and continuity when normal control paths cannot safely operate. It
requires independent recovery capability, strong authentication, explicit
emergency declaration, short bounded use, protected audit, immediate alerts,
mandatory post-incident review and credential rotation/revocation where
appropriate.

This model intentionally excludes recovery codes, secret locations, physical
procedures, private endpoints and operational detail that would aid abuse.

## JIT request model

| Field | Requirement |
|---|---|
| Requester | Verified Founder identity or separately authorized operator |
| Capability | Exact additional operation, never generic root |
| Resource | Exact resource/type and minimum data |
| Surface/environment | Explicit and non-propagating |
| Purpose | Required, reviewable and policy-valid |
| Approver | Independent when future critical policy requires it |
| Start/expiry | Explicit; never indefinite by default |
| Revocation | Immediate request path and terminal state |
| Audit reference | Correlates request, decision, action and review |

## Delegation and representation

Founder may delegate a bounded task, but delegation never transfers Founder
identity, Founder Authority, emergency access or onward-delegation rights unless
an explicit non-Founder capability allows the latter. Direct impersonation is
prohibited by default and is not a substitute for delegation.

## Threats and controls

| Threat | Primary control | Residual risk |
|---|---|---|
| Founder account takeover | Strong assurance, anomaly detection, separate elevation | Compromised standard session may still expose governance views |
| Elevation replay/scope escape | Exact operation binding, expiry, nonce/session controls later | Revocation propagation delay |
| Insider/coerced misuse | Confirmation, independent approval, alert and review | Authorized human misuse cannot be eliminated |
| Emergency-path abuse | Restricted cases, independent proof, audit and rotation | Recovery dependencies may fail together |
| Audit suppression | Protected future audit path and separation of duties | Provider/infra compromise remains |
| Cross-surface propagation | Separate contexts and PEP checks | Configuration errors require negative tests |

## Audit and revocation

Founder events distinguish standard, elevated and emergency state and record
the normal authorization audit fields without secrets or sensitive payloads.
Revocation applies independently to session, elevation, delegation, provider
credential and emergency state. Emergency use triggers mandatory review.

## Founder implementation gates

Future claims, roles, elevation, break-glass, production access, remote change,
service identity interaction, policy engine and audit retention must return to
Founder with technical options and a recommendation. This document creates no
account, role, credential, policy or access path.

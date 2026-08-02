# Security, Privacy and Founder Access

## Retained principles

- Founder-exclusive global control with explicit elevation.
- Least privilege and deny-by-default authorization.
- Surface and environment separation.
- RLS and backend enforcement where data is exposed.
- Sanitized, integrity-bound and minimal evidence.
- No secrets in Git and no sensitive logic solely in Flutter.
- Audited destructive operations with rollback.

Founder modes are `Standard`, `Elevated` and `Emergency`. Elevated and Emergency
access require purpose, scope, expiry and audit; Founder authority is not an
implicit runtime bypass.

Wave 2 makes these modes explicit in every governance prompt. Privileged access
also requires exact resource and environment binding, minimum privilege,
separation of duties and safe expiry. Emergency requires demonstrated necessity,
containment and retrospective review. Security, Privacy, Audit and Risk remain
independently challengeable; no agent accepts critical risk or weakens controls
for convenience.

End-to-end encryption for chats remains an architecture objective, not an
implemented capability. “Secret chats” are not a Product feature.

MCP does not replace the Product API. Flutter does not depend directly on MCP.
Stasis Engine is an internal subsystem and is `NOT_IMPLEMENTED` unless later
evidence explicitly proves otherwise.

Wave 3 adds no runtime authority. Agent Registry, Model Gateway, Data Router and
Shard Directory are likewise `NOT_IMPLEMENTED`. Tool, model, memory and
retrieval bindings remain deny-by-default, independently approved and auditable.

Wave 4 adds Product-specific safety boundaries. Documentary agents cannot
diagnose, prescribe, replace clinicians, minimize emergencies, promote unsafe
diet or training, manipulate users or infer sensitive facts as truth. Immediate
danger, severe symptoms, medication, pregnancy, minors, eating disorders,
injury and mental-health crisis trigger qualified human or emergency escalation
as applicable. Memory requires consent and deletion controls. These safeguards
do not make any agent clinically or operationally available.
## Wave 5 engineering controls

Engineering work fails closed on secrets, `.env`, credentials, RLS, grants,
tenant boundaries, production data and supply-chain integrity. Sensitive
authorization and durable invariants cannot exist exclusively in Flutter or
another client. Tests may not use production data by default or weaken
assertions to pass. Privileged, destructive and remote operations require exact
scope, independent review, Founder authorization where applicable and rollback.
## Wave 6 privileged Administration controls

Administrative and financial access is deny-by-default, least-privilege, purpose-bound, expiring and audited. Founder authority cannot be delegated. User suspension, fraud or moderation requires proportional review and appeal; payments require segregation of duties; marketing forbids sensitive health-data targeting and dark patterns. Documentary agents execute none of these actions.

## W7-001 fraud safeguards

Fraud signals, rules and scores are not verified facts or enforcement decisions. High-impact actions require scoped evidence, proportionality, human review, reason code, appeal path and audit trail. Health, wellness, private conversations and unrelated Product memory are denied by default. No W7-001 prompt grants privileged access, financial mutation, account restriction, critical-risk acceptance or Founder authority.

## W7-002 critical incident safeguards

Incident evidence, people data and crisis communications are confidential and purpose-bound. Health, HR, identity and security data require strict necessity and separate authorization. Founder authority is explicit, scoped, time-bounded, non-transferable and cannot be created, inferred, expanded, reused or consumed by documentary agents. Emergency, HR, production, continuity and communications execution remain unavailable.

## W7-003 privacy, legal and compliance safeguards

Privacy rights require identity verification, scope, legal basis, evidence,
transparent exceptions and appeal. Consent is affirmative and versioned;
retention and deletion are purpose-bound. Legal uncertainty, cross-border
transfers, subprocessors, high-impact automation and possible breaches require
qualified review. Agents cannot expose Founder-private data, self-certify,
notify regulators or perform operational privacy actions.

## W7-004 financial safeguards

Financial data is purpose-limited, minimized, redacted and need-to-know.
Segregation of duties, exact identity, amount, currency, period, idempotency and
immutable evidence are mandatory. Agents cannot move money, expose payment
credentials, mutate balances or ledgers, self-approve exceptions, approve
providers or exercise Founder financial authority.

## W7-005 incident-command safeguards

Telemetry and operational evidence are purpose-limited, minimized, redacted
and need-to-know. Environment identity, timeline provenance, stop conditions,
segregation of command from execution and independent recovery verification are
mandatory. Agents cannot expose secrets, suppress evidence, mutate production,
self-approve exceptions or exercise Founder authority.

## W7-006 payment-engineering safeguards

Data access is `NO_USER_DATA`; raw payment credentials and card data are
forbidden. Provider and environment identity, amount and currency integrity,
idempotency, signed webhook verification, replay protection, reconciliation and
segregation of duties are mandatory. Agents cannot execute financial mutations,
approve providers, access secrets or exercise Founder authority.

## W7-007 security and privacy safeguards

Security-restricted evidence is purpose-limited, minimized, redacted,
need-to-know and case-scoped. Least privilege, privacy rights, supply-chain and
dependency provenance, secret and key protection, forensic custody,
cryptographic review and incident-authority separation are mandatory. Agents
cannot exploit, mutate controls, change permissions, access raw secrets, deny
rights, attribute attackers, disclose externally or exercise Founder authority.

## W7-008 health and clinical-safety safeguards

Sensitive health evidence is purpose-limited, minimum-necessary, consent-aware,
redacted, need-to-know and user/tenant/case-scoped. Identity, provenance,
recency, uncertainty, emergency escalation and vulnerable-person safeguards are
mandatory. Agents cannot diagnose, prescribe, replace care, mutate records,
contact emergency services autonomously or exercise Founder authority.

## W7-009 health and clinical-safety safeguards

Health evidence remains purpose-limited, minimum-necessary, consent-aware,
redacted, need-to-know and user/tenant/case-scoped. Specialty monitoring and
education cannot infer diagnosis, select treatment, mutate records, contact
third parties, bypass qualified review or acquire Founder authority.

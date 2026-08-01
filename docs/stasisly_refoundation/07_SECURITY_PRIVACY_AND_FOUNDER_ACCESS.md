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

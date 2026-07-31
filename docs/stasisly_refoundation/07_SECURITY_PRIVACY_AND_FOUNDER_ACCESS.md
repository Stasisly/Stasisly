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

End-to-end encryption for chats remains an architecture objective, not an
implemented capability. “Secret chats” are not a Product feature.

MCP does not replace the Product API. Flutter does not depend directly on MCP.
Stasis Engine is an internal subsystem and is `NOT_IMPLEMENTED` unless later
evidence explicitly proves otherwise.

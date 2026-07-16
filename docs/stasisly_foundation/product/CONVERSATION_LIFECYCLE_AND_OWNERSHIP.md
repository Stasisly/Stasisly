# Conversation Lifecycle and Ownership

## Metadata

```text
Status: APPROVED conceptually
Implementation: NOT IMPLEMENTED
Owner: Product + Data + Security under Stasis/Rector
Approver: Founder
```

## Canonical lifecycle

Live Conversation states are intentionally small:

```text
active
archived
pendingDeletion
```

`deleted` is a terminal deletion outcome/audit marker, not a readable live
Conversation. `closed` is not adopted because it duplicates archive without an
approved distinct Product behavior. `blocked` is an access/operational outcome,
not lifecycle. `unknown` is a fail-closed parser state and never persisted as a
valid Product state.

## Transitions

| From | Operation | To | MVP status |
|---|---|---|---|
| none | create | active | approved target |
| active | rename | active | approved target |
| active | archive | archived | approved target |
| archived | restore | active | approved target |
| active/archived | request deletion | pendingDeletion | future, privacy-gated |
| pendingDeletion | cancel when policy permits | previous safe state | future |
| pendingDeletion | execute deletion | terminal deleted outcome | future, restricted |

Archive hides a Conversation from the active view without deleting history.
Restore reverses archive. The owner may continue reading their archived history
under the approved access policy, but may not send new messages while archived.
Delete is never an alias for archive.

## Ownership and access

```text
Conversation owner = backend-derived authenticated subject.
Message access = Conversation membership + provenance + visibility policy.
Specialist, Stasis and provider = never owner.
```

Client owner fields are rejected. Current single-user MVP access is based on
owner membership. Message ownership need not be duplicated as a mutable direct
field; authorization follows the trusted Conversation relationship.

## Membership and future sharing

MVP has one owner user plus visible non-owner Product participants. Shared
Conversations, caregiver, professional, family, team and organization access
are `FUTURE_CAPABILITY_NOT_IMPLEMENTED`. The conceptual participant model leaves
room for them, but no sharing role, claim, policy or UI is approved now.

Future membership must include identity, relationship type, scope, validity,
provenance, consent/legal basis where applicable, revocation and audit. It cannot
be inferred from a link, email, client role or specialist participation.

## Deletion and retention principles

Deletion must coordinate Conversation data, Messages, attachments, memory
proposals/adopted memories, research references, exports, provider copies,
backups and legally/security-required audit evidence. Requirements are:

- user control and visible status;
- explicit data ownership and purpose;
- legal/security retention separated from Product history;
- deletion propagation and provider confirmation;
- backup expiry and restoration behavior;
- audit minimization and preservation where required;
- correction, export and redaction paths;
- idempotent, observable execution and safe failure.

No legal period or immediate physical-deletion promise is approved here.
FOUNDATION-016 owns the detailed privacy lifecycle before sensitive rollout.

## Current compatibility

Current `chat_sessions.status` supports only active/archived and already blocks
send on archived while allowing owner history reads. That behavior is an
`ADAPT` baseline. `pendingDeletion`, restore and deletion are target contracts,
not current capabilities.

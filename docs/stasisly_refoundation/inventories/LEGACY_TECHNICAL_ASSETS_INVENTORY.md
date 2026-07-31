# Legacy Technical Assets Inventory

## Baseline counts

| Asset | Count | Current status | Re-foundation action |
|---|---:|---|---|
| Supabase migrations | 12 | FOUNDATION_LEGACY | PRESERVE / REVIEW_REQUIRED |
| Edge Functions | 8 | FOUNDATION_LEGACY | PRESERVE / REVIEW_REQUIRED |
| Shared Edge Function directory | 1 | FOUNDATION_LEGACY | PRESERVE |
| SQL test files | 24 | FOUNDATION_LEGACY | PRESERVE |
| Dart tool files | 27 | FOUNDATION_LEGACY | PRESERVE |
| Shell runner files | 3 | FOUNDATION_LEGACY | PRESERVE |
| Repository test files | 134 | MIXED_LEGACY | PRESERVE |
| Foundation ADRs | 37 | FOUNDATION_LEGACY | ARCHIVE_CANDIDATE |
| Discovery ADRs | 12 | DISCOVERY_LEGACY | ALREADY_ARCHIVED |

## Migrations

`00001` through `00012` exist. They are historical evidence and are neither
deployed, deleted nor adopted into the future clean project by this package.

## Edge Functions

`archive-own-chat-session`, `create-own-chat-session`,
`list-own-chat-sessions`, `list-selectable-specialists`,
`list-session-messages`, `read-own-conversation`,
`restore-own-conversation`, and `send-user-message` are preserved.

## Runtime and authorization tooling

The repository contains remote preparation, functional-attempt, containment,
evidence, authorization ArtifactV2, exact identity and remote-context guards.
All are legacy technical assets; none is executed remotely or destroyed here.

## Classification rule

Existing code may prove historical implementation and tests. It does not make a
capability normative or operational in Re-foundation without explicit adoption.

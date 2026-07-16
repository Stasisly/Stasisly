# FOUNDATION-011 Backend Authorization Context and Owned API Enforcement

## 1. Status and scope

```text
Package: FOUNDATION-011
Decision: APPROVED
Implementation: IMPLEMENTED_LOCALLY
Remote deployment: NOT AUTHORIZED
Production: NOT AUTHORIZED
```

This package adds a backend-owned authorization boundary to the six existing
Product Edge Functions. It does not create Product capability, change public
DTOs, add claims or roles, modify SQL, deploy functions, or contact a remote
Supabase project.

## 2. Previous audit

| Function | Authentication and identity | Input and owner | Operation context | Data and atomicity | Public boundary |
|---|---|---|---|---|---|
| `list-selectable-specialists` | Bearer token validated through backend Auth; subject was not used as an owner | Area filter; catalog is not user-owned | Product/read/specialistCatalog was implicit | Read-only catalog query | Six-field allowlist, stable errors and safe logs |
| `create-own-chat-session` | Bearer token validated through backend Auth | `selectableSpecialistId`; owner derived from verified subject | Product/create/chatSession was implicit | Catalog and internal identity checks followed by insert; known TOCTOU remains | Session DTO excludes user and specialist internal IDs |
| `list-own-chat-sessions` | Bearer token validated through backend Auth | Filters use verified subject | Product/read/chatSession was implicit | Owner-filtered reads and stable cursor | Sanitized complete response; broken catalog fails closed |
| `archive-own-chat-session` | Bearer token validated through backend Auth | `sessionId`; narrow query includes verified owner | Product/update/chatSession was implicit | Conditional PATCH; no new idempotency semantics | Minimal response and opaque not-found behavior |
| `list-session-messages` | Bearer token validated through backend Auth | `sessionId`; ownership checked against trusted session row | Product/read/chatMessage was implicit | Owner check followed by read-only message query | Sanitized roles/messages and opaque foreign session |
| `send-user-message` | Bearer token validated through backend Auth | `sessionId` and content only; sender is verified subject | Product/create/chatMessage was implicit | Atomic `send_user_message_core` RPC | Sanitized message/counters and stable errors |

All six already had useful JWT, DTO, CORS, runtime, ownership and logging
controls. JWT validation alone was not treated as Foundation authorization.
Surface, environment, action and resource were implicit and duplicated, and a
missing runtime mode inherited local behavior. Those gaps are closed locally.

## 3. BackendRequestContext

`BackendRequestContext` carries only backend-derived or backend-validated data:

```text
identitySubjectId
identityType
authenticationState
surface
environment
action
resourceType
resourceId (optional)
ownershipState
correlationId
requestSource
```

It excludes raw JWTs, access/refresh tokens, service-role credentials, provider
user objects, request bodies, roles, entitlements, delegation, elevation and
purpose. The last six remain future policy concepts and are not authority here.

## 4. Registered operations

The immutable `BackendOperationDefinition` registry is the sole operation
metadata source.

| Operation | Surface | Environments | Action | Resource | Auth | Ownership |
|---|---|---|---|---|---|---|
| `listSelectableSpecialists` | Product | local, development | read | specialistCatalog | required | not required |
| `createOwnChatSession` | Product | local, development | create | chatSession | required | required |
| `listOwnChatSessions` | Product | local, development | read | chatSession | required | required |
| `archiveOwnChatSession` | Product | local, development | update | chatSession | required | required |
| `listSessionMessages` | Product | local, development | read | chatMessage | required | required |
| `sendUserMessage` | Product | local, development | create | chatMessage | required | required |

No handler defines free-form operation authority. `unknown`, unregistered and
malformed operations deny.

## 5. Identity, surface and environment

Human identity is accepted only after the backend validates the bearer token
through the configured Auth endpoint. The shared adapter returns only verified
subject, identity type and authentication state. User metadata does not create
Foundation roles.

Surface is derived from the registered operation, not Origin, route text or a
client header. Environment is derived from controlled backend configuration.
The backend vocabulary is `local`, `development`, `staging`, `production` and
`unknown`; only local/development are allowlisted. Missing, unknown, staging and
production configurations deny. `backendReal` is not a backend Foundation
environment.

## 6. Action, resource and ownership

Actions and resources use TypeScript vocabularies equivalent to the approved
Dart Foundation contracts. Architecture tests compare both representations.

Ownership is never accepted from body, query or headers. Session ownership is
derived from the verified subject plus an owner-filtered trusted database row,
query or RPC result. Catalog is explicitly non-owned. Ownership-required
operations may defer only the ownership result during preflight; final
enforcement requires an owner match before protected results are returned or a
dependent operation proceeds.

## 7. PDP and PEP

`BackendAuthorizationPolicyDecisionPoint` and
`BackendAuthorizationEnforcer` are provider-neutral ports. The local policy
denies:

- missing or invalid authentication;
- unknown/mismatched surface or environment;
- a non-allowlisted environment;
- unknown/mismatched action or resource;
- missing/mismatched ownership at final enforcement;
- malformed or unregistered operations;
- unavailable or failing policy;
- authority-bearing client metadata.

The six handlers are PEPs. Each prepares a trusted context before domain work
and, where ownership applies, finalizes the decision at the trusted ownership
boundary. Unsupported approval, elevation or consent outcomes deny.

## 8. Client metadata and correlation IDs

Owner, user, role, entitlement, surface and environment indicators supplied in
body/query/header authority positions are rejected. They cannot expand access.

`x-correlation-id` is the only accepted diagnostic request metadata. It is
bounded to 64 safe characters and is never authority. Missing IDs are generated
in the backend; invalid IDs are rejected.

## 9. Errors and logs

Backend authorization reasons are typed and stable, including authentication,
missing/unknown/mismatched context, ownership, authority fields and policy
failure. Function adapters map them to the existing public error envelopes so
Flutter contracts do not change. Public errors disclose no policy internals,
provider data, SQL, table names or configuration secrets.

Existing safe logs remain allowlisted and include request correlation without
JWT, Authorization, body, content, owner IDs, health data, service-role values
or raw provider errors. No remote logging sink was added.

## 10. DTO and CORS invariants

Specialist, session, message and error DTO allowlists are unchanged. No raw
authorization context, owner metadata, internal specialist ID, prompt,
provider metadata or policy details enter a response.

CORS remains an explicit transport/browser control and is not used as identity,
surface or authorization. Local origins and explicitly configured development
origins remain bounded; no credentialed wildcard was added.

## 11. Six-function integration

- Catalog applies the registered non-owned decision after authentication.
- Create verifies Product catalog/internal identity, creates for the verified
  subject and finalizes on the sanitized owner result.
- Session listing verifies all returned rows belong to the subject before final
  authorization and preserves existing pagination.
- Archive preserves the narrow owner-filtered PATCH and minimal opaque result.
- Message listing accepts owned active or archived sessions, then reads only
  that session and never updates counters.
- Message send preserves content-only input and the atomic RPC; no direct table
  write or agent execution was introduced.

## 12. Tests and evidence

```text
Deno format: 53 files checked
Deno tests: 72 passed, 0 failed, 0 skipped
Shared authorization tests: 13 passed
Per-function authority metadata tests: 6 passed, each covering five fields
HTTP sessions/catalog harness: 3 passed; cleanup 0|0|0|0|0|0
HTTP messages harness: 3 passed; cleanup 0|0|0|0|0|0
SQL reset without seed: PASS, migrations 00001-00009
SQL pgTAP: 18 files, 649 passed, 0 failed
Flutter analyze: 0 errors, 51 inherited infos
Flutter tests: 483 passed, 5 approved skips, 0 failed
```

The legacy HTTP fixtures omit the newer runtime mode and publication status.
They were adapted only in the executing process: runtime mode was added to the
temporary Edge environment and the local publication default was temporarily
set to `published`, protected by a trap and restored to `draft`. Versioned
`supabase/tests/**` and migrations remained unchanged. Final fixture checks
were zero.

Only one SQL reset/suite cycle was required because no migration, RLS, RPC or
database behavior changed.

## 13. Compatibility and security review

Flutter DTOs, routes, session IDs, `selectableSpecialistId`, content-only send,
tiers, schema, RLS, RPC signatures and migration history are unchanged.
Architecture guards require all six registered operations, shared preparation,
final ownership enforcement for five owned functions, Dart/TypeScript vocabulary
equivalence and rejection of client authority metadata.

## 14. Residual debt

- create-session catalog validation and insert retain the known TOCTOU window;
- archive retains existing non-idempotent/opaque semantics;
- persistent RBAC/ABAC, Founder elevation, service identities and policy store
  are not implemented;
- rate limits, productive audit storage and backend security CI remain future;
- remote state and production enforcement are not asserted;
- legacy chat containment and Product conversation decisions remain separate.

## 15. Rollback

Revert the FOUNDATION-011 commit while keeping remote deployment and Product
expansion closed. Rollback must not introduce owner/role/surface/environment
authority from the client or reactivate legacy routes. Existing database and
public API contracts require no rollback migration.

## 16. Foundation adoption and readiness

```text
BackendRequestContext: FOUNDATION_ADOPTED
Backend operation registry: FOUNDATION_ADOPTED
Backend PDP/PEP contracts: FOUNDATION_ADOPTED
Six Edge Function authorization boundaries: FOUNDATION_ADOPTED_LOCALLY
Remote backend enforcement: NOT IMPLEMENTED
Production: NOT AUTHORIZED
RBAC/ABAC persistence: NOT IMPLEMENTED
Founder access: NOT IMPLEMENTED
```

G0-G6 are complete in the worktree. G7 completes only after the explicit commit
and push. G8-G10 remain unauthorized.

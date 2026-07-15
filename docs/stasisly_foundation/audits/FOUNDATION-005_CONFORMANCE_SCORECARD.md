# FOUNDATION-005 Conformance Scorecard

Status: **ACTIVE evidence**. No aggregate percentage is calculated.

| Area | Rating | Evidence and reason |
|---|---|---|
| Architecture boundaries | PARTIALLY_CONFORMANT | New features separate layers; bootstrap and legacy features bypass owned boundaries. |
| Backend authority | PARTIALLY_CONFORMANT | Modern chat delegates authority; legacy chat and broad database grants contradict it. |
| Authentication | PARTIALLY_CONFORMANT | Secure state abstractions exist; runtime identity remains Supabase-coupled. |
| Authorization | NON_CONFORMANT | Foundation RBAC/ABAC/JIT is absent and ten public tables lack deny-by-default. |
| Ownership | PARTIALLY_CONFORMANT | Own-session/profile filters exist; legacy tables are not consistently protected. |
| Surface isolation | NON_CONFORMANT | Dev routes are guarded, but Product legacy routes and database domains are not Foundation-isolated. |
| Environment isolation | PARTIALLY_CONFORMANT | Strong local/development guards; transitional `backendReal` and incomplete deployment policy remain. |
| API ownership | PARTIALLY_CONFORMANT | DTOs are owned and strict; transport/auth endpoints are provider-specific. |
| Provider portability | NON_CONFORMANT | Supabase client/Auth/PostgREST/Edge runtime are primary boundaries; no complete owned adapter layer. |
| Data and privacy | NON_CONFORMANT | Sensitive domains exist without complete access, retention, deletion, provenance or encryption evidence. |
| Security | NON_CONFORMANT | Positive modern guards cannot offset the P0 public-table exposure. |
| Testing | PARTIALLY_CONFORMANT | 937 local assertions/tests passed; P0 tables and CI backend execution are uncovered. |
| Observability | PARTIALLY_CONFORMANT | Safe allowlisted logs exist; no consolidated metrics, audit trail or SLO instrumentation. |
| Cost controls | NOT_IMPLEMENTED | No quotas, token accounting, storage retention or cost metrics. |
| Scalability | PARTIALLY_CONFORMANT | Bounded cursor pagination exists; rate limits and broader capacity controls do not. |
| Wearable readiness | NOT_IMPLEMENTED | No wearable contracts or platform capabilities are implemented. |
| Agent runtime readiness | NOT_IMPLEMENTED | No Stasis Engine, Model Gateway or governed agent runtime exists. |

## Security principle check

| Principle | Result | Evidence |
|---|---|---|
| Deny by default | VIOLATION | Ten public tables have RLS disabled and broad client grants. |
| No authority in client | PARTIAL | Modern contracts comply; legacy chat accepts role and internal IDs. |
| No secrets/service role in client | CONFIRMED | No versioned real secret found; service role use is server-side. |
| Explicit ownership | PARTIAL | Modern own-resource queries comply; legacy schema is incomplete. |
| Sanitized DTOs | PARTIAL | Strong modern allowlists; legacy models remain. |
| No implicit demo fallback | PARTIAL | Modern repositories fail closed; legacy/demo paths coexist. |
| Surface isolation | VIOLATION | Legacy Product routes and database domains lack Foundation isolation. |
| Environment isolation | PARTIAL | Runtime/host guards are strong but not a complete Foundation deployment model. |
| Bounded execution | PARTIAL | Pagination is bounded; rate limiting and quotas are absent. |
| Safe logging | CONFIRMED | Function tests prove allowlisted logs and token-safe public state. |

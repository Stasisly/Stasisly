# Authorization Decision Matrix

## Status and interpretation

Status: **APPROVED conceptual examples and decision rules**. This is not an
executable policy, role table or claim design.

| Actor | Action | Resource | Surface | Environment | Ownership/delegation | Entitlement | Elevation | Decision | Audit requirement |
|---|---|---|---|---|---|---|---|---|---|
| End user | Read own profile | Profile | Product | production | Owner | NOT_APPLICABLE | None | ALLOW | Standard security/business outcome |
| End user | Read another profile | Profile | Product | any | None | NOT_APPLICABLE | None | DENY | Denial/anomaly when repeated |
| End user | Send content | Own active session | Product | allowed Product env | Owner | Required capability valid | None | ALLOW | Message operation/correlation |
| End user | Supply `role` or owner | Message/session | Product | any | Client assertion ignored | Any | None | DENY | Contract violation |
| End user | Open Administration | Admin capability | Administration | any | None | NOT_APPLICABLE | None | DENY | Cross-surface attempt |
| Administrator | Execute approved support read | Redacted case view | Administration | production | Assigned case/purpose | NOT_APPLICABLE | As policy requires | ALLOW | Sensitive support audit |
| Administrator | Access Development tooling | Repository/tool | Development | any | None | NOT_APPLICABLE | None | DENY | Cross-surface attempt |
| Developer | Run local tests | Synthetic local assets | Development | local | Assigned task | NOT_APPLICABLE | None | ALLOW | Build/test evidence |
| Developer | Use development credential in production | Production service | Development mismatch | production | None | NOT_APPLICABLE | None | DENY | Critical environment mismatch |
| Developer | View Product personal data | User data | Product | production | No approved purpose | NOT_APPLICABLE | None | DENY | Sensitive denial |
| Security operator | Contain incident | Exact affected control | Administration/Development | named env | Incident delegation | NOT_APPLICABLE | JIT/approval per risk | REQUIRE_ELEVATION | Full security audit |
| Founder Standard | Review global roadmap/audit | Governance view | Explicit surface | named env | Founder identity | NOT_APPLICABLE | Standard | ALLOW | Governance/audit access |
| Founder Standard | Perform destructive production mutation | Critical resource | named surface | production | Founder identity | NOT_APPLICABLE | Standard | REQUIRE_ELEVATION | Elevation request/decision |
| Founder Elevated | Execute approved remote migration | Named database/change | Shared Infrastructure | production | Exact approved operation | NOT_APPLICABLE | Valid scoped elevation | REQUIRE_APPROVAL | G8, migration and post-action audit |
| Founder Elevated | Reuse elevation in another surface | Unrelated resource | mismatch | any | Out of scope | NOT_APPLICABLE | Wrong scope | DENY | Scope-escape alert |
| Founder Emergency | Recover critical control | Recovery resource | exact scope | named env | Emergency declaration | NOT_APPLICABLE | Valid emergency state | ALLOW | Protected event, alerts and review |
| Support operator | Directly impersonate user | User session | Product | any | None | NOT_APPLICABLE | None | DENY | Impersonation attempt |
| Support operator | Join user-approved read session | Redacted support view | Product via approved workflow | named env | User consent/delegation | NOT_APPLICABLE | None | REQUIRE_USER_CONSENT | Both actors and purpose |
| Stasis | Read authorized Product context | Product context | Product | allowed env | User delegation | Capability valid | None | ALLOW | Agent/user execution trace |
| Stasis | Read Administration finance | Financial resource | Administration | any | None | NOT_APPLICABLE | None | DENY | Cross-surface agent attempt |
| Rector | Modify source in approved task | Repository | Development | development | Task delegation | NOT_APPLICABLE | None | ALLOW | Agent/tool/change trace |
| Rector | Read production conversations | Conversation data | Product | production | No bounded purpose | NOT_APPLICABLE | None | DENY | Sensitive cross-surface denial |
| Gerendi | Execute approved business workflow | Business case | Administration | named env | Assigned workflow | As applicable | As policy requires | ALLOW | Business/security audit |
| Gerendi | Modify code | Repository | Development | any | None | NOT_APPLICABLE | None | DENY | Cross-surface tool attempt |
| Nexus | Consolidate surface proposals | Decision metadata | Shared governance | named env | Coordination task | NOT_APPLICABLE | None | ALLOW | Coordination trace |
| Nexus | Approve Founder-reserved decision | Reserved decision | any | any | No transferable authority | NOT_APPLICABLE | None | DENY | Governance violation |
| Service identity | Execute assigned background job | Job resource | owning surface | bound env | Job scope | NOT_APPLICABLE | None | ALLOW | Service/job correlation |
| Service identity | Interactive login or unrelated table access | Any | any | any | Scope mismatch | NOT_APPLICABLE | None | DENY | Credential misuse alert |
| Product agent | Invoke assigned tool | Tool/resource | Product | bound env | Valid execution delegation | Budget valid | None | ALLOW | Tool/cost/policy trace |
| Product agent | Add tool or raise budget | Tool/model policy | Platform | any | None | NOT_APPLICABLE | None | DENY | Agent escalation alert |
| Wearable | Submit linked synthetic/validated sync | Device data | Product | allowed env | Linked device/user | Capability valid | None | REQUIRE_USER_CONSENT | Device provenance/sync event |
| Unknown identity/context | Any sensitive action | Any protected resource | missing/unknown | missing/unknown | Unknown | Unknown | Unknown | DENY | Safe denial and anomaly signal |
| Product client | Operate on Administration-only resource | Admin resource | Product | any | NOT_APPLICABLE | NOT_APPLICABLE | None | NOT_APPLICABLE | Contract/routing violation |

`ALLOW` remains conditional on enforceable obligations. `REQUIRE_ELEVATION`,
`REQUIRE_APPROVAL` and `REQUIRE_USER_CONSENT` are not partial allows. Missing
the required follow-up produces `DENY`.

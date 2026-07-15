# Threat-to-Control Matrix

## Status and control vocabulary

Status: **ACTIVE security evidence and planning artifact**.

- **VERIFIED:** observed in repository tests/code locally.
- **APPROVED CONCEPTUAL:** binding design, not implemented.
- **FUTURE REQUIRED:** planned control requiring a separate package.

| ID | Threat | Asset/actor | Entry point / boundary | Severity / likelihood | Existing verified control | Approved conceptual / future required control | Detection | Response | Residual risk | Owner | Target package |
|---|---|---|---|---|---|---|---|---|---|---|---|
| T01 | Spoofing/token theft | Sessions; attacker | Client/API edge | HIGH / MEDIUM | Token-free public state in modern auth | Session assurance, audience/surface binding, revocation | Auth anomaly | Revoke session/tokens | HIGH | Identity + Security | 008/010 |
| T02 | Session fixation/surface replay | Session; compromised actor | Auth/surface | HIGH / MEDIUM | Dev-route guards | Separate surface sessions/context and PEP | Mismatch event | Revoke context | HIGH | Security | 008/009 |
| T03 | Owner/role/surface tampering | Product resources; user | Product API | CRITICAL / HIGH | Strict modern DTOs; server role in message path | Owned API rejects internal fields and derives owner | Contract event | Deny and investigate patterns | MEDIUM | Backend + AppSec | 008/011 |
| T04 | Legacy direct access | Conversations; user | Legacy client/provider | HIGH / HIGH | Database deny-all on modern/legacy tables locally | Contain routes and replace direct Product access | Architecture guard | Disable entry point | HIGH | Flutter + Backend | 009/011 |
| T05 | Cross-surface escalation | All; legitimate actor | Route/API/data | CRITICAL / MEDIUM | Dev-only route guards | Surface-bound policy, explicit cross-surface contracts | Policy denial | Revoke grant | HIGH | Architecture + Security | 009 |
| T06 | Environment confusion | Production; developer/service | Config/deploy/API | CRITICAL / MEDIUM | Fail-closed runtime/host guards | Environment-bound identities, sessions and promotion | Environment mismatch | Stop/revoke | HIGH | DevOps + Security | 008/009/015 |
| T07 | Founder elevation escape | Root authority | Elevated context | CRITICAL / LOW | Tier separation approved conceptually | Strong assurance, exact scope, expiry, approval/alert | Scope alert | Revoke and review | HIGH | Founder + Security | Separate Founder implementation |
| T08 | Emergency misuse | Root authority | Emergency boundary | CRITICAL / LOW | Break-glass principles approved | Independent proof, restricted cases, protected audit/rotation | Immediate alert | Terminate and post-incident review | HIGH | Founder + Security | Separate break-glass package |
| T09 | Service credential leakage | DB/provider/CI | Service runtime | CRITICAL / MEDIUM | Secrets excluded from clients/repo; local-safe logs | Per-purpose identity, secure storage, rotation | Secret/anomaly signal | Rotate/revoke/contain | HIGH | Security + DevOps | Service identity implementation |
| T10 | Prompt injection | Tools/context; attacker | Engine/model | HIGH / HIGH | Prompt is not an auth control conceptually | External PEP, content isolation and tool allowlist | Tool-policy denial | Stop execution | HIGH | Engine + AppSec | 014 |
| T11 | Agent tool/role expansion | Tools/data; compromised agent | Engine/Tool Gateway | CRITICAL / HIGH | Gateway boundary approved conceptually | Versioned execution identity and per-call policy | Escalation event | Revoke tools/activation | MEDIUM | Engine + Security | 014 |
| T12 | Agent recursion/delegation explosion | Cost/availability | Runtime | HIGH / HIGH | No runtime implemented | Depth, concurrency, budget and circuit limits | Fan-out/cost alert | Cancel graph | MEDIUM | Cost + Engine | 014/017 |
| T13 | Cost exhaustion | Billing/capacity | API/Tool/Model | HIGH / HIGH | Bounded pagination | Quotas, rate limits, budgets and accounting | Budget/rate alert | Throttle/deny | MEDIUM | Cost | 017 |
| T14 | Memory poisoning | Memory/research | Ingestion/runtime | HIGH / MEDIUM | Provenance/minimization approved conceptually | Source trust, validation, version/review/revocation | Drift/anomaly review | Quarantine/revert | HIGH | Data + Engine | 014/016 |
| T15 | Sensitive-data exfiltration | Health/conversation/memory | API/provider | CRITICAL / MEDIUM | DTO minimization and safe logs in modern paths | Purpose, minimum context, egress/provider controls | Access/egress alert | Revoke and invoke incident response | HIGH | Privacy + Security | 016 |
| T16 | Audit tampering/repudiation | Audit records; insider | Audit pipeline/store | HIGH / MEDIUM | Safe logs only | Protected append model, retention and separation | Integrity gap | Preserve evidence/contain | HIGH | Security + Observability | 017 |
| T17 | Database/migration tampering | DB; insider/service | DB/migration runner | CRITICAL / MEDIUM | Versioned SQL, transactions, reset/pgTAP, deny-all | Scoped runner, review, backup/rollback and G8 | Migration evidence | Stop/rollback | MEDIUM | DB + DevOps | 015 + remote package |
| T18 | Supply-chain compromise | Source/CI/artifacts | Repository/CI/provider | CRITICAL / MEDIUM | Flutter CI and lockfiles | Dependency review, provenance, secret/security gates | Build anomaly | Block/revoke/rebuild | HIGH | AppSec + DevOps | 015/018 |
| T19 | Provider compromise | Data/context/credentials | External adapter | HIGH / MEDIUM | Strict DTOs and adapter direction partially | Minimize egress, isolate, monitor and exit | Provider anomaly | Circuit break/revoke/switch | HIGH | Architecture + Security | 018 |
| T20 | Wearable spoofing | Health/device data | Device sync | HIGH / MEDIUM | No runtime; wearable only conceptual | Device link, provenance, replay/conflict validation | Data anomaly | Quarantine/revoke device | HIGH | Product + Security | Future wearable package |
| T21 | Denial of service | API/DB/Engine | Public/service edge | HIGH / MEDIUM | Bounded cursors | Boundary limits, queue controls and circuit breakers | Saturation alert | Throttle/isolate | MEDIUM | Platform + Cost | 017 |
| T22 | Unauthorized impersonation | User/audit; support/admin | Support workflow | HIGH / MEDIUM | No Product support capability implemented | Direct deny; delegated/redacted/user-approved support | Representation event | Terminate/review | MEDIUM | Administration + Security | 019 |

No row indicates implemented authorization. Verified controls are partial
invariants; conceptual and future controls remain required before their gates.

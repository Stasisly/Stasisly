# Foundation Threat Model

## Metadata and scope

| Field | Value |
|---|---|
| Status | APPROVED conceptual security model |
| Package | FOUNDATION-007 |
| Owner | Security under Rector with Nexus coordination |
| Approver | Founder |
| Baseline | `0faebf6 docs: define Foundation reconstruction plan` |
| Implementation | NOT IMPLEMENTED |
| Remote systems | NOT INSPECTED OR MODIFIED |

This model covers Product, Development, Administration, Platform/Stasis Engine
and shared infrastructure. It combines asset and actor identification,
trust-boundary and data-flow analysis, STRIDE-style categories, abuse cases,
privilege escalation, cross-surface, supply-chain, provider, operational and
human risk analysis. Severity and likelihood are qualitative; no unsupported
numeric score is assigned.

## Protected assets

| Asset | Classification | Primary owner | Main risk |
|---|---|---|---|
| Founder identity and authority | ROOT-CRITICAL | Founder | Account takeover or unauthorized elevation |
| User identities | SENSITIVE | Identity service/Product | Spoofing and account abuse |
| Administrator identities | HIGHLY SENSITIVE | Administration | Cross-surface or production escalation |
| Developer identities | HIGHLY SENSITIVE | Development | Cross-surface or production escalation |
| Service identities | HIGHLY SENSITIVE | Owning technical service | Credential reuse and excessive privilege |
| Sessions and tokens | HIGHLY SENSITIVE | Identity/session service | Theft, fixation, replay and scope confusion |
| Product profile/catalog data | CONFIDENTIAL | Product | Unauthorized disclosure or tampering |
| Health and wellness data | HIGHLY SENSITIVE | Product/Data governance | Harmful disclosure, poisoning or misuse |
| Wearable data | HIGHLY SENSITIVE | Product/Data governance | Device spoofing, poisoning or misuse |
| Conversation data | HIGHLY SENSITIVE | Product | Disclosure, ownership bypass or retention abuse |
| Memory and research artifacts | HIGHLY SENSITIVE | Data/Memory owners | Poisoning, over-sharing and provenance loss |
| Agent definitions and prompts | CONFIDENTIAL | Engine/Prompt governance | Unauthorized activation or prompt tampering |
| Tools and models | HIGHLY SENSITIVE | Tool/Model Gateway | Tool abuse, exfiltration and cost exhaustion |
| Provider credentials | ROOT-CRITICAL | Security/Infrastructure | Infrastructure or data compromise |
| Billing and cost controls | SENSITIVE | Cost/Administration | Fraud and unbounded consumption |
| Audit records | HIGHLY SENSITIVE | Security/Audit | Repudiation, deletion or falsification |
| Source code and migrations | CONFIDENTIAL | Development | Supply-chain compromise or unsafe schema change |
| CI/CD and release artifacts | HIGHLY SENSITIVE | DevOps/Release | Build compromise and unauthorized deployment |
| Databases, storage and backups | ROOT-CRITICAL | Data/Infrastructure | Bulk disclosure, tampering or destruction |
| Stasis Engine | HIGHLY SENSITIVE | Engine Architecture | Agent/tool privilege expansion |
| Surface configuration | HIGHLY SENSITIVE | Architecture/Security | Cross-surface access |
| Environment configuration | ROOT-CRITICAL | DevOps/Security | Production/lower-environment confusion |
| Public DTOs and Product content | PUBLIC or INTERNAL | Contract owner | Overexposure or contract poisoning |

`PUBLIC`, `INTERNAL`, `CONFIDENTIAL`, `SENSITIVE`, `HIGHLY SENSITIVE` and
`ROOT-CRITICAL` express handling needs. They do not alone grant or deny access.

## Actors

| Actor | Kind | Intended authority | Explicit non-authority |
|---|---|---|---|
| Founder | Human | Final governance; protected Standard/Elevated/Emergency access | No unlogged universal session |
| End user | Human | Own Product capabilities | No Administration/Development access |
| Administrator | Human | Approved Administration operations | No Development or Founder authority |
| Developer | Human | Approved Development work | No inherited production or personal-data access |
| Support operator | Human | Bounded support workflow | No direct impersonation or broad raw data |
| Security operator | Human | Investigate and contain within policy | No self-approved permanent elevation |
| Nexus | Agent coordinator | Global coordination and escalation | No Founder Authority or total data access |
| Stasis | Product agent | Product coordination under user context | No Development/Administration authority |
| Rector | Development coordinator | Technical coordination | No automatic production/Product personal data |
| Gerendi | Administration coordinator | Business/Administration coordination | No code modification authority |
| Product specialist | Agent | Bounded Product task | No cross-specialist memory/tool expansion |
| Development agent | Agent | Bounded engineering task | No production access by default |
| Administration agent | Agent | Bounded business task | No source mutation or Product data by default |
| Service account/background worker | Service | Single technical purpose | No interactive human use or unrelated reuse |
| External provider | External service | Contracted operation on minimum data | No implicit internal trust |
| Wearable/device | Device | Linked, bounded sync | No authority derived from submitted data |
| Attacker | Adversary | None | All unauthorized operations |
| Compromised user | Adversary path | Only the legitimate user's remaining valid scope | No scope, ownership or surface expansion |
| Compromised agent | Adversary path | Only its resolved execution scope | No tool, role, memory, budget or delegation expansion |
| Compromised dependency | Adversary path | No implicit runtime authority | No transitive trust beyond build/runtime controls |
| Compromised provider | Adversary path | Minimum adapter contract only | No internal trust or credential propagation |
| Insider | Human adversary | Only legitimate assigned scope | No misuse, audit bypass or scope expansion |

Agents and coordinators are not human identities and do not receive technical
credentials merely from their organizational position.

## Trust boundaries

| Boundary | Identity/authentication | Authorization | Data/validation | Audit/rate limit | Failure/revocation |
|---|---|---|---|---|---|
| User device | User session and device signals | Product scope only | Public DTO allowlists; untrusted input | Request correlation; abuse limits | Fail closed; revoke sessions/device trust |
| Wearable | User-device link and device identity | Approved sync contract | Provenance, range and conflict validation | Sync volume/anomaly events | Quarantine data; revoke link/trust |
| Product client | Authenticated Product context | No client authority | Minimum Product DTOs | Product usage and decisions | Safe error; session revocation |
| Development client | Developer/agent context | Development task and environment | Synthetic data by default | Tool/build audit and quotas | No production fallback; revoke grant |
| Administration client | Admin/operator context | Approved business operation | Purpose-limited business views | Sensitive-action audit and limits | Deny and revoke elevation/workflow |
| API edge | Session/request identity | PEP for action/resource/context | Schema, ownership and version validation | Decision, correlation and rate limit | Deny on missing/timeout/ambiguity |
| Authentication provider | Provider identity proof | Does not decide domain access | Token assertions treated as input | Auth events and anomaly signals | Revoke/expire; no provider fallback |
| Authorization service/PDP | Trusted policy context | Produces explicit decision | Validate complete attributes/policy version | Policy decision event | No decision means deny; revoke grants |
| Domain services | Service identity | Invariants and ownership PEP | Domain validation, minimum reads/writes | Business/security outcomes | Transaction rollback; credential revocation |
| Stasis Engine | Execution and agent version | Delegation, tool/data/model/budget scope | Context minimization and provenance | Trace, cost and policy outcomes | Stop execution; revoke activation/tools |
| Tool Gateway | Agent/user/delegation context | Per-tool operation PEP | Input/output allowlists | Tool calls, cost and confirmation | Deny/timeout/circuit break/revoke tool |
| Model Gateway | Execution/model policy | Approved model/task/budget | Minimized context and output controls | Usage, cost and provider outcome | Deny/degrade safely; revoke provider route |
| Database | Service identity | Least privilege plus data controls | Constraints and transactions | Access/change evidence | Revoke credential; no client bypass |
| Object storage | Service/user scoped access | Object purpose/ownership | Type, size, malware and metadata checks | Access and lifecycle events | Revoke grants; quarantine object |
| Queue/job system | Producer/worker identity | Approved job type and scope | Signed/versioned minimal payload | Enqueue/execute/retry/dead-letter | Reject unknown; revoke producer/worker |
| External provider | Backend adapter credential | Contract-specific minimum scope | Redaction and response validation | Egress, latency, cost and errors | Timeout/circuit break/revoke credential |
| CI/CD | Human/workload identity | Repository/environment job scope | Trusted source and artifact provenance | Build/deploy/security events | Stop pipeline; revoke runner/deploy grant |
| Operations environment | Reinforced operator identity | JIT operation/environment scope | Controlled commands and redacted output | Full sensitive-operation audit | Revoke grant/session; incident process |
| Founder elevated context | Founder strong re-authentication | Exact critical scope | Minimum necessary sensitive data | Alert, immutable future audit, review | Expiry/revocation; no surface propagation |
| Founder emergency context | Independent strong recovery proof | Restricted emergency capability | Minimum recovery data/actions | Immediate alerts and mandatory review | Short duration; rotate/revoke as appropriate |

## Principal data flows

1. Client -> API edge -> PDP/PEPs -> domain service -> database/storage.
2. Surface workflow -> cross-surface contract -> destination PEP/read model.
3. User/delegation -> Stasis Engine -> Tool/Model Gateway -> provider.
4. CI source -> isolated build/test -> artifact -> separately approved deploy.
5. Wearable -> device boundary -> Product sync contract -> validated data.
6. Sensitive operation -> audit event -> protected audit store/monitoring.

Every boundary treats upstream input as untrusted for its own decision. Shared
infrastructure does not imply shared authority.

## Threat taxonomy

The analysis explicitly covers: Spoofing, Tampering, Repudiation, Information Disclosure,
Denial of Service, Elevation of Privilege, prompt injection, tool
abuse, cross-surface privilege escalation, environment confusion, token theft,
session fixation, credential leakage, insider misuse, supply-chain compromise,
provider compromise, cost exhaustion, agent recursion/delegation explosion,
memory poisoning, audit tampering, wearable/device spoofing and data
exfiltration.

## Detailed threat register

| ID | Threat/category | Asset/actor | Entry and boundary | Precondition and attack path | Impact | Likelihood | Existing verified control | Required control | Residual risk/owner/package |
|---|---|---|---|---|---|---|---|---|---|
| T01 | Spoofing/token theft | Sessions; attacker | Client/API edge | Token obtained and replayed | Account/data compromise | MEDIUM | Token-safe public state in modern paths | Assurance, audience/surface binding, revocation | HIGH; Identity/Security; 008/010 |
| T02 | Session fixation/surface replay | Sessions; compromised user | Auth/API/surface | Session reused in another surface | Cross-surface access | MEDIUM | Dev route guards | Separate context and PEP checks | HIGH; Security; 008/009 |
| T03 | Client role/surface/owner tampering | Product data; user | Product client/API | Internal authority field accepted | Ownership/privilege bypass | HIGH | Modern DTO allowlists and server-derived role | Owned API and exact input rejection | MEDIUM; Backend; 008/011 |
| T04 | Legacy direct access | Conversations; user | Legacy Flutter/provider | Reachable direct provider path | Unauthorized writes/data | HIGH | RLS hardening/local guards partially | Route containment and replacement | HIGH; Flutter/Backend; 009/011 |
| T05 | Cross-surface escalation | All sensitive assets; legitimate actor | Surface/API | Valid identity uses wrong surface | Broad unauthorized access | MEDIUM | Conceptual surface separation | Surface-bound policy and negative tests | HIGH; Architecture/Security; 009 |
| T06 | Environment confusion | Production assets; developer | Config/deploy/API | Lower authority/credential reaches production | Production compromise | MEDIUM | Fail-closed local/dev guards | Environment-bound identity/session and promotion | HIGH; DevOps/Security; 008/009/015 |
| T07 | Founder elevation scope escape | Root authority; attacker/Founder session | Elevated context | Elevation reused across operation/surface | Root compromise | LOW | Conceptual tier separation | Strong re-auth, exact scope, expiry, alert/review | HIGH; Founder/Security; future elevation package |
| T08 | Emergency-access misuse | Root authority; insider | Emergency context | Recovery path invoked without emergency | Root compromise/repudiation | LOW | Conceptual break-glass constraints | Independent controls, immutable audit, rotation | HIGH; Founder/Security; future package |
| T09 | Service credential leakage/reuse | Provider/DB credentials; attacker | Service/runtime/CI | Broad credential exposed or reused | Bulk infrastructure compromise | MEDIUM | Secrets excluded from client/repo | Per-purpose identity, rotation and vault boundary | HIGH; Security/DevOps; service identity package |
| T10 | Prompt injection | Tools/data; malicious content | Engine/context/model | Content interpreted as authority | Exfiltration/tool abuse | HIGH | Prompt not accepted as control conceptually | External PEP, content isolation and tool allowlist | HIGH; Engine/AppSec; 014 |
| T11 | Agent tool/role expansion | Tools/memory; compromised agent | Engine/Tool Gateway | Agent requests unassigned scope | Cross-surface/data compromise | HIGH | Engine conceptual gateways | Execution identity, delegation and per-call policy | MEDIUM; Engine/Security; 014 |
| T12 | Agent recursion/delegation explosion | Cost/services; agent | Engine/runtime | Unbounded fan-out or re-delegation | Cost/availability exhaustion | HIGH | Cost Controller conceptual | Depth/concurrency/budget/circuit limits | MEDIUM; Cost/Engine; 014/017 |
| T13 | Cost exhaustion | Billing/capacity; user/agent | API/Model/Tool Gateway | High-volume expensive operations | Financial/availability harm | HIGH | Bounded pagination only | Rate limits, quotas, budgets and accounting | MEDIUM; Cost; 017 |
| T14 | Memory poisoning | Memory/research; user/provider/agent | Ingestion/Engine | Untrusted content gains durable authority | Corrupted future decisions | MEDIUM | Provenance conceptual only | Source trust, review, versioning and revocation | HIGH; Data/Engine; 014/016 |
| T15 | Sensitive-data exfiltration | Health/conversation/memory | API/Engine/provider | Excess context or response escapes | Privacy/safety harm | MEDIUM | DTO minimization/safe logs partially | Purpose, DLP-like minimization, egress controls | HIGH; Privacy/Security; 016 |
| T16 | Audit tampering/repudiation | Audit records; insider/service | Audit pipeline/store | Actor can alter/delete evidence | Untraceable abuse | MEDIUM | Safe logs, no complete audit system | Append-protected events and separation of duties | HIGH; Security/Observability; 017 |
| T17 | Database tampering | Data/migrations; insider/service | DB/migration runner | Overprivileged mutation/destructive SQL | Integrity/availability loss | MEDIUM | Local RLS/grant/transaction tests | Scoped runner, review, backup/rollback and G8 | MEDIUM; DB/DevOps; 015/remote package |
| T18 | Supply-chain compromise | Source/CI/artifacts; dependency | Repository/CI/provider | Malicious dependency/build action | Code/credential compromise | MEDIUM | Flutter CI only | Dependency/provenance/secret/security gates | HIGH; AppSec/DevOps; 015/018 |
| T19 | Provider compromise | Context/data/credentials; provider | Adapter/external boundary | Provider or account compromised | Exfiltration/service manipulation | MEDIUM | Adapter intent; safe DTOs | Minimum egress, isolation, monitoring and exit | HIGH; Architecture/Security; 018 |
| T20 | Wearable spoofing | Health data; device/attacker | Device/sync boundary | Fake/replayed device data accepted | Unsafe Product conclusions | MEDIUM | No runtime exists | Device link, provenance, replay/conflict controls | HIGH; Product/Security; future wearable package |
| T21 | Denial of service | API/DB/Engine; attacker | Public/service edge | Resource exhaustion | Product/operations unavailable | MEDIUM | Bounded list limits | Per-boundary limits, queues, circuit breakers | MEDIUM; Platform/Cost; 017 |
| T22 | Unauthorized impersonation | User data/audit; support/admin | Support workflow | Operator acts as user invisibly | Privacy and accountability loss | MEDIUM | None implemented | Delegated/redacted support; direct impersonation deny | MEDIUM; Administration/Security; 019 |

No new repository-defined P0 is established by this analysis. P1 risks block
Product expansion; P2 blocks staging; P3 blocks production; P4 covers future
hardening. The legacy-table P0 remains `CLOSED_LOCALLY / REMOTE_NOT_APPLIED`.

## Limitations and review

This is a conceptual model based on repository evidence, not penetration
testing or remote verification. It must be reviewed when architecture, data,
providers, surfaces, agents, elevated access or deployment topology changes.

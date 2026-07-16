# Foundation Risk and Debt Register

## Status

**ACTIVE evidence.** No date or duration is inferred. Priorities express gates,
not schedules.

| ID | Debt / risk | Evidence | Owner | Priority | Dependency | Acceptance condition | Target phase |
|---|---|---|---|---|---|---|---|
| SEC-01 | Authorization enforcement partial | FOUNDATION-011 enforces registered local Product operations and trusted ownership in six Edge Functions; persistent RBAC/ABAC/JIT, remote and other backend domains remain absent | Security under Rector | P1 residual | Later persistent policy and domain packages | Persisted policy plus negative tests across approved domains | F7 before broader Product expansion |
| SEC-02 | Legacy chat/client authority retained in frozen source | Direct Supabase, client role/IDs and `agentId` remain in `lib/features/chat/**`, but routes are blocked and FOUNDATION-012 formally deprecates the feature | Flutter + Backend Architecture | P1 residual | 013A-013F | Replacement active, no Product references, guarded removal | F7/F8 |
| ARC-01 | Provider-owned identity/API boundary partially remediated | FOUNDATION-008 owns identity/session/errors and confines Auth SDK; bootstrap and backend adapters remain provider-coupled | Architecture under Rector | P2 residual | 009-010, 018 | Complete consumer migration and provider exit evidence | F7 |
| ARC-02 | Surface isolation incomplete | Product route boundaries and six Product Edge Functions enforce local/development context; mixed legacy and future domains remain | Architecture + Nexus | P1 residual | 012-013 and later surface packages | Approved Product boundary with no legacy bypass | F7/F8 |
| PROD-01 | Product taxonomy partially unresolved | Conversation/Stasis routes are decided by FOUNDATION-012; mental/physical/Wellness naming remains separate | Product Owner under Stasis | P2 residual | Separate taxonomy decision before affected rename | Founder-approved area taxonomy | F8 |
| CONV-01 | Canonical Conversation architecture not implemented | ADR-F009 and target contracts approved; runtime still uses transitional sessions/messages and dev-only UI | Product + Flutter + Backend Architecture | P1 | 013A-013F | Canonical local slice, parity, retirement and rollback evidence | F8 |
| CONV-02 | Conversation lifecycle/privacy incomplete | Archive exists; restore, deletion, retention, sharing, attachments, memory and research are target-only | Product + Data + Privacy | P1/P3 | 013C, 016 and later scoped packages | Approved implementation plus privacy controls | F8 before sensitive rollout |
| DATA-01 | Privacy lifecycle incomplete | Health/conversation data without full retention/deletion/provenance | Data + Privacy | P3; before sensitive scope | 016 | Approved lifecycle, threat controls and test plan | F7/F8 before production |
| TEST-01 | Backend security suites absent from CI | Local Deno/pgTAP/reset only | QA + DevOps | P2 | 015 | Protected reproducible CI jobs | F7 before staging |
| OPS-01 | Observability/SLO incomplete | Safe logs but no metrics/audit/SLO program | Observability + DevOps | P3 | 017 | Sanitized metrics, runbooks and SLO proposal | F7/F11 |
| COST-01 | Limits and usage accounting absent | No rate limits, quotas or cost controller | Cost specialist + Architecture | P3/P4 | 014, 017 | Measurable quotas, budgets and alerts | F7/F6 before runtime scale |
| LOCK-01 | Supabase/provider coupling | Auth/PostgREST/Edge are primary boundaries | Architecture + Cost | P2/P4 | 008, 018 | Dependency map, adapters and exit triggers | F7/H |
| SUPPLY-01 | Release supply chain incomplete | Manual unsigned builds | DevOps/Release + AppSec | P3 | 015, later release package | Signed provenance and protected release gate | F11/F12 |
| PLATFORM-01 | Platform readiness incomplete | No approved deep links/privacy/background model | Flutter + Release | P3 | Product scope, 020 | Platform checklists and regression evidence | F11 |
| ENGINE-01 | Engine runtime absent/prototype confusion | Orchestrator is static Product prototype | Engine Architecture + Nexus | P1 containment/P4 build | 009, 014 | Prototype contained; Constitution and modular design approved | F5/F6 |
| DOC-01 | Audit evidence still describes pre-R1 baseline in places | FOUNDATION-005 is historical evidence | Documentation | P2 | Controlled updates only | Successor docs clearly supersede current planning facts | Continuous |
| DEC-01 | Subscription, provider and roster decisions open | No approved implementation choices | Founder with domain owners | Gate-specific | 012, 014, 018 | Options, recommendation and explicit decision | F5-F8 |
| REMOTE-01 | Remote P0 state unverified/not applied | R1 local evidence only | Security + DevOps | G8 blocked | Separate remote package | Authorized environment evidence and rollback | Before relevant remote promotion |

## Consolidated debt classes

- **Technical:** legacy routes, mixed boundaries and incomplete adapters.
- **Security:** authorization, surface isolation and remote-state uncertainty.
- **Privacy:** lifecycle, sensitive domains and consent/provenance controls.
- **Documentation:** historical evidence versus successor plans.
- **Decision:** taxonomy, subscriptions, providers, rosters and elevated access.
- **Cost:** unknown vendors, quotas, AI budgets and usage attribution.
- **Operational:** CI, observability, SLO, runbooks and release provenance.
- **Vendor lock-in:** Supabase Auth/PostgREST/Edge and unreviewed dependencies.
- **Test:** local backend evidence not enforced by CI; future policies uncovered.

New evidence may change priority through an approved package; debt is never
silently accepted by implementation.

FOUNDATION-007 found no new P0. T01-T22 remain owned qualitative risks; P1
authorization, identity/API and surface controls block Product expansion.

FOUNDATION-008 closes the canonical client identity/session contract portion of
ARC-01 locally. It does not close SEC-01, ARC-02, LOCK-01, remote uncertainty,
legacy route reachability or the transitional `backendReal` vocabulary.

FOUNDATION-009 partially remediates SEC-01 with owned policy contracts and a
profile PEP. FOUNDATION-010 implements and reproducibly validates local
route/provider isolation while blocking legacy entry points. SEC-01 and ARC-02
remain open for backend/global and persistent policy enforcement. No remote,
production or Founder control exists.

FOUNDATION-011 closes the six current Edge Function context gap locally. It
does not close persistent policy, other backend domains, TOCTOU/idempotency,
rate limits, productive audit, legacy retirement or remote uncertainty.

FOUNDATION-012 closes the terminology, route target and formal retirement
decision only. SEC-02 and CONV-01 remain open until 013A-013F implement a
replacement and prove no references; CONV-02 remains privacy-gated.

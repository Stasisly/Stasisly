# Foundation Asset Adoption Plan

## Status and rule

Status: **PROPOSED per-asset adoption**. The classifications below are approved
planning decisions, not adoption or execution authority.

```text
Asset classification != execution priority
CANDIDATE != FOUNDATION_ADOPTED
```

| Asset | Classification | Priority | Preserve | Replace / action | Dependencies | Adoption evidence |
|---|---|---|---|---|---|---|
| `lib/features/auth/` | REWRITE | P1 | User-facing intent only | Direct Supabase boundary and provider models | 007, 008, 010 | Owned identity/session ports and tests |
| `lib/features/chat/` | DEPRECATE | P1 containment | Historical behavior only | Client authority, direct writes and legacy routes | 009, 011, 013 | No Product entry/use; replacement accepted |
| `lib/features/chat_sessions/` | ADAPT | P1 | DTOs, controllers, explicit IDs, fail-closed tests | Provider adapters and dev-only wiring | 008-011 | Owned API, authz and Product gate |
| `lib/features/chat_messages/` | ADAPT | P1 | Content-only send, session ID, state preservation | Provider transport and dev route | 008-011 | Atomic owned flow and negative tests |
| `lib/features/specialists/` | ADAPT | P1/P2 | Sanitized six-field catalog contract | Backend-blocked/provider adapter | 008, 012 | Approved Product catalog API |
| `lib/features/orchestrator/` | REWRITE | P1 containment; E deferred | Prototype evidence only | Engine-confusing name/route/static model | 009, 014 | Product prototype retired; no Engine claim |
| `lib/features/mental_training/` | ADAPT | DEFER until Product taxonomy | Reusable presentation evidence | Legacy naming/routes/domain assumptions | 012 | Approved Wellness mapping and tests |
| `lib/features/physical_training/` | ADAPT | DEFER until Product taxonomy | Reusable presentation evidence | Legacy naming/routes/domain assumptions | 012 | Approved Training mapping and tests |
| `lib/features/profile/` | ADAPT | P2 | Minimal public profile contract | Incomplete executable owned adapter | 008, 010, 012 | Ownership/privacy/API tests |
| `lib/core/config/` | ADAPT | P1 | Fail-closed modes and local/dev guards | Transitional vocabulary/global coupling | 007-010 | Surface/environment contracts and guards |
| `lib/core/auth/` | ADAPT | P1 | Token-free public state and mockable abstractions | Incomplete runtime provider boundary | 007, 008, 010 | Identity/session contract tests |
| `supabase/migrations/` | ADAPT | P1-P3 by domain | Deny-all, ownership constraints, atomic RPC | Mixed schemas/provider roles and legacy debt | 007, data packages | Clean reset, grants/RLS and portability review |
| `supabase/functions/` | ADAPT | P1 | DTO allowlists, bounded cursors, safe logs, runtime guards | Supabase Auth/PostgREST/Edge coupling | 008, 011, 017 | Owned API adapter and contract suites |
| `supabase/tests/` | KEEP | P1 continuous | RLS, grants, ownership, cleanup, reproducibility | Extend for new policies and surfaces | Every DB package, 015 | CI execution and maintained exact assertions |
| `test/architecture/` | KEEP | P1 continuous | Boundary and fail-closed regression guards | Extend with Foundation surface/API rules | 007-015 | Green CI and no obsolete assumptions |
| `.github/workflows/` | ADAPT | P2 before staging | Flutter CI skeleton | Missing backend/security/release gates | 015 | Protected reproducible pipeline |

No asset is classified `REMOVE`: the audit does not yet prove deletion is safe.
No `UNKNOWN` asset may be adopted until evidence resolves its role.

## Foundation adoption gate

An asset becomes `FOUNDATION_ADOPTED` only when all are evidenced:

1. Approved Stasisly-owned contract and owner.
2. Explicit surface and environment assignment.
3. Security/threat review and least-privilege behavior.
4. Provider boundary and exit impact understood.
5. Focal and regression tests pass.
6. Documentation and authority register are synchronized.
7. No hidden legacy authority, route or fallback remains.
8. Residual debt has an owner, priority and acceptance decision.

Failure of any item leaves the asset `CANDIDATE`, even if it is currently used.

# FOUNDATION-019C — Development pre-execution blocker resolution

## 1. Baseline and scope

- Baseline: `9235dbd628e4ee2583eeec3e88c4dc95acf16a08`.
- Discovery baseline: `7f747e0cf60012ce315216a5486db3c5481f8f60`.
- Scope: local implementation, local/ephemeral validation and documentation.
- Remote actions, remote project identification, real secrets and real data: 0.
- G8-G10 and FOUNDATION-019A: not authorized.

## 2. Blocker register

| ID | Description | Future action affected | Previous evidence | Security impact | Resolution | Acceptance | Status | Residual risk |
|---|---|---|---|---|---|---|---|---|
| DEV-B001 | Runtime Product catalog absent | Select specialist before create | Hardened table/function existed but Flutter provider was disconnected | Invented or internal identity | Product-safe port, strict adapter, typed controller and Stasis composition | Exact public contract; manual selection; no fallback | RESOLVED_LOCALLY | Remote wiring requires separate authorization |
| DEV-B002 | Create smoke blocked | First Development smoke | Create API existed without catalog-driven Product flow | Wrong specialist reference or duplicate create | Canonical Stasis create plus two-cycle local HTTP lifecycle | One logical create per attempt; canonical detail navigation | RESOLVED_LOCALLY | Remote smoke remains NOT_STARTED |
| DEV-B003 | Fixture lifecycle absent | Bounded Development tests | Plans only | Residual data or broad cleanup | Versioned manifest and exact local-only cleanup harness | Two setup/flow/cleanup cycles; zero residual counts | RESOLVED_LOCALLY | Remote fixture creation remains unauthorized |
| DEV-B004 | Idempotency retention undecided | Sustained operation | Nullable expiry; no approved cleanup actor/cutoff | Unbounded ledger growth versus unsafe replay deletion | Option B classification | No invented duration; explicit later gate | DECIDED_POST_DEVELOPMENT_GATE | Must resolve before sustained operation |
| DEV-B005 | Evidence not schema-validated | Future authorization/execution proof | Unapproved deployment manifest only | False execution claims or leaked secrets | Closed schemas, safe templates and local validator | Unsafe states/fields/targets rejected | RESOLVED_LOCALLY | External evidence does not yet exist |
| DEV-B006 | Smoke result model not executable | Future post-deployment evidence | Narrative plan | Raw IDs/content in evidence | Closed safe result schema and validator | Only six safe fields accepted | RESOLVED_LOCALLY | Remote result remains NOT_STARTED |

## 3. Catalog audit and canonical contract

The authoritative chain already existed in `public.specialist_catalog`, the
deny-all client boundary and `list-selectable-specialists`. FOUNDATION-019C
adopts `SelectableSpecialistCatalog.listSelectableSpecialists()` as the Product
port and changes the public item to exactly:

```text
selectableSpecialistId
displayName
publicArea
publicDescription
accessState
```

Internal `specialist_id`, runtime agent identity, prompts, model configuration,
permissions, ownership and authorization context are absent. The backend maps
the catalog row `id` to `selectableSpecialistId`; Product never derives it from
display name, area, array position or `AgentEntity.id`.

## 4. Local implementation and Stasis integration

The chain is:

```text
StasisPage
→ SelectableSpecialistCatalogController
→ SelectableSpecialistCatalog
→ strict repository
→ protected HTTP adapter
→ list-selectable-specialists
```

The controller exposes `initial`, `loading`, `data`, `empty`,
`unauthenticated`, `environmentBlocked` and `error`. Stasis requires an explicit
selection before enabling create. It does not select the first item, invent a
Stasis specialist, or use demo fallback. A successful canonical create navigates
to `/conversations/:conversationId`. Health, Nutrition, Physical Training and
Mental Training remain without create CTAs.

## 5. Local create smoke and repeatability

`foundation_019c_development_fixture_lifecycle_http_test.sh` fails closed unless
Supabase reports the approved local endpoint. It executes twice:

```text
synthetic auth
→ list Product-safe catalog
→ create + idempotency replay
→ list/read
→ send + replay
→ assert no non-user response
→ archive
→ read historical message while archived
→ reject archived send
→ restore
→ exact cleanup
```

The harness uses canonical APIs for the flow. Direct SQL is restricted to local
fixture setup, exact dependency-safe cleanup and content-free count assertions.
The repeated namespace is deterministic; every cycle ends `0|0|0|0|0|0|0`.

## 6. Fixture lifecycle and manifest

`development_fixture_manifest.json` records the suite, dedicated namespace,
synthetic owner, role, specialist fixture, lifecycle states, setup/cleanup,
ownership and serial-only policy. Maximum retention is bounded by completion of
the run cleanup, not by an invented wall-clock duration. Wildcards are forbidden
and no remote cleanup executable is introduced.

## 7. Idempotency retention audit and decision

`conversation_idempotency` protects create/send replay and stores operation,
subject, key, request fingerprint, status, response reference and timestamps.
Completed records currently have no proven natural expiration or approved
maintenance actor. Deleting them too early can break replay safety; retaining
them indefinitely creates operational growth and metadata-retention risk.

Decision: Option B, `POST_DEVELOPMENT_OPERATIONAL_BLOCKER`. A first bounded
Development execution may proceed only with the exact fixture cleanup, which
also removes its own ledger rows. Sustained operation is blocked until a focal
package approves retention duration, terminal states, actor, bounded batch,
locking, audit evidence and replay guarantees. No destructive cleanup or
arbitrary duration is implemented here.

## 8. Evidence schemas and smoke result

Versioned schemas and NOT_STARTED/PREPARED templates cover pre-deployment,
deployment, post-deployment smoke and rollback evidence. Evidence states use the
closed enum `NOT_STARTED`, `PREPARED`, `AUTHORIZED`, `EXECUTED`, `PASSED`,
`FAILED`, `ROLLED_BACK`.

The smoke result allows only `testId`, `status`, `safeResultCategory`,
`durationBucket`, `cleanupStatus` and `evidenceReference`. Content, email,
tokens, raw user/conversation identifiers, secrets and payloads are rejected.
The no-network validator also rejects unassigned execution claims, unknown
environment, missing inventory/commit/rollback evidence, remote URL material
and server credentials in Flutter.

## 9. Updated future smoke plan and skips

The runtime-catalog blocker is removed locally. The future Development plan is
authentication, `/stasis`, explicit selection, create, list/read, send/replay,
archive/restore, foreign-owner opacity, legacy route absence, orchestrator
block, environment enforcement and cleanup. All five approved remote skips
remain `CLASSIFIED_NOT_ENABLED`; local equivalents do not activate them.

## 10. Guards, tests and security

Architecture guards cover agent-ID conversion, first-item selection, fallback,
create without selection, non-local/wildcard cleanup, remote executable cleanup,
unsafe evidence, raw smoke IDs, arbitrary retention, Flutter server credential,
remote skip activation and omission of the remote-context guard.

Final local evidence:

- Flutter analyzer: 0 errors and the 36 inherited infos from the baseline.
- Flutter: 659 pass, 5 approved remote skips and 0 failures; the pass total
  increased from 647 and no skip was added.
- Deno: format check passed for 62 files; 86/86 tests passed.
- Supabase: one local no-seed reset passed; 24 SQL files and 740/740 tests
  passed.
- Local canonical HTTP smoke: cycles 1 and 2 passed; every cycle began and
  ended with exact cleanup `0|0|0|0|0|0|0`.
- Remote-context and Development no-network preflights: `SAFE`.

Final diff, secret scan, commit and push checks remain part of G6-G7 and are
performed only after this evidence is synchronized.

## 11. Rollback

Rollback is the single FOUNDATION-019C commit. It removes the Product catalog
adapter/controller/composition, restores the prior public catalog field names,
and removes local fixture/evidence artifacts. No database rollback, remote
operation or data repair is required because there is no migration and no
remote action.

## 12. Adoption, gates and readiness

- Runtime selectable-specialist catalog: `FOUNDATION_ADOPTED_LOCALLY`.
- Stasis create flow: `FOUNDATION_ADOPTED_LOCALLY`.
- Create smoke: `LOCALLY_VALIDATED`.
- Fixture contract: `FOUNDATION_ADOPTED`.
- Local fixture cleanup/repeatability: `FOUNDATION_ADOPTED_LOCALLY` / `VALIDATED_LOCALLY`.
- Idempotency retention: `DECIDED`, post-Development operational gate.
- Evidence schemas/result model: `FOUNDATION_ADOPTED_LOCALLY`.
- Remote skips: `CLASSIFIED_NOT_ENABLED`.
- Development remote execution: `NOT_AUTHORIZED`.

G0-G7 are complete only after successful validation, commit and push.
Remote actions, real secrets, production data, agent-ID conversions and remote
skips enabled remain zero. FOUNDATION-019A requires a separate Founder order.

## FOUNDATION-019A-R1 follow-up

El fixture local continúa `localOnly=true`. Un manifest remoto separado y un
runner operador versionado añaden cleanup exacto, idempotente y obligatorio tras
éxito/fallo. Dos simulaciones de fallo adicionales terminaron con siete ceros.
No cambia la retención ni constituye ejecución remota.

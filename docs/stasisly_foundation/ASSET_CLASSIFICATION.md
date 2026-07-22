# Clasificación inicial de activos

## FOUNDATION-019B classification

- Supabase CLI remote link metadata: `ISOLATED`, local ignored files removed.
- Remaining `supabase/.temp/` versions/cache: `LOCAL_RUNTIME_METADATA` or
  `CACHE_ONLY`, preserved and unversioned.
- Remote-context preflight: `FOUNDATION_ADOPTED_LOCALLY`, read-only/no-network.
- FOUNDATION-018: `READY_TO_RETRY`; remote/staging/production: `NOT_AUTHORIZED`.

## FOUNDATION-017 classification

- Conversation observability contract: `FOUNDATION_ADOPTED`.
- Runtime Conversation sink: `NO_OP`, `LOCAL_SAFE`, non-persistent.
- Controller/route outcome instrumentation: `FOUNDATION_ADOPTED_LOCALLY`.
- Accessibility audit: `COMPLETED_LOCALLY`, not WCAG certification.
- Remote observability/staging/production: `NOT_AUTHORIZED`.

## FOUNDATION-016-R1 classification

- `lib/features/chat/**`: `PHYSICALLY_REMOVED`.
- `OrchestratorChatPage`: `REMOVED`; `/orchestrator*` remains `BLOCKED`.
- Legacy `/chat/:id`: `REMOVED`, with no redirect or ID translation.
- Canonical Conversation: `SOLE_PRODUCT_ARCHITECTURE`.
- `chat_sessions` / `chat_messages`: `TRANSITIONAL_AND_ENCAPSULATED`,
  `BACKEND_TRANSPORT_INFRASTRUCTURE`, not Product API.
- Legacy runtime references: `0`; retirement L0-L7: `COMPLETE`.

## FOUNDATION-015-R1 classification

- Stasis Product route/screen: `FOUNDATION_ADOPTED_LOCALLY`.
- Conversation list/detail routes and screens: `FOUNDATION_ADOPTED_LOCALLY`.
- Active canonical Product composition/user-message flow:
  `FOUNDATION_ADOPTED_LOCALLY`.
- Inactive host: `TEST_ONLY`, not routed.
- Legacy routes/chat/orchestrator: `BLOCKED`; physical removal remains pending.
- AI, Engine, specialist responses and remote activation: `NOT_IMPLEMENTED`.

## Reclasificación FOUNDATION-014-R1

- Cuatro CTAs Product basados en `agent.id`: `REMOVED`.
- Información visual legacy de agentes: `KEEP_TEMPORARILY / DISPLAY_ONLY`.
- Componente Product no accionable: `FOUNDATION_ADOPTED_LOCALLY`.
- Wiring Product legacy de Conversation: `RETIRED_LOCALLY`.
- CTA orchestrator Development: `KEEP_BLOCKED_TEMPORARILY`.
- Rutas Product canónicas y remoto: `NOT_IMPLEMENTED`.
- Retirada física legacy L5-L7: `PARTIAL / NOT_STARTED` según fase.

## Reclasificación FOUNDATION-013F

- Casos de uso y estados Conversation: `FOUNDATION_ADOPTED`.
- Controllers y providers canónicos: `FOUNDATION_ADOPTED_LOCALLY`.
- Host Product inactivo: `FOUNDATION_ADOPTED_FOR_LOCAL_VALIDATION`.
- Pantalla/rutas/shell Product: `NOT_IMPLEMENTED`.
- Migración de consumidores legacy: `NOT_STARTED`; remoto: `NOT_IMPLEMENTED`.

## Reclasificación FOUNDATION-013F-R1

- `OperationAttemptId` y `OperationAttemptIdFactory`: `FOUNDATION_ADOPTED`.
- propagación create/send: `FOUNDATION_ADOPTED_LOCALLY`.
- generación datasource-owned: `REMOVED`.
- application layer canónica: `NOT_IMPLEMENTED`.
- FOUNDATION-013F: `IMPLEMENTED_LOCALLY`; rutas Product y remoto:
  `NOT_IMPLEMENTED`.

## Reclasificación FOUNDATION-013E

Las primitivas en `features/conversations/presentation` pasan a
`FOUNDATION_ADOPTED_LOCALLY`. `features/chat` pasa de bloqueado a
`DEPRECATED_AND_FROZEN`: `MessageBubble` queda adaptado visualmente, `ChatInput`
y `ChatPage` requieren reescritura, y datos/dominio/providers legacy siguen
`REMOVE_LATER / NOT_ADOPTED`.

## Reclasificación FOUNDATION-013D

`messages`, `send-user-message`, `list-session-messages` y sus adapters pasan a
`FOUNDATION_ADOPTED_LOCALLY` para metadata de usuario y lectura Product
filtrada. Los nombres `sessionId`/`role` siguen siendo transitorios; cualquier
fila assistant/tool sin evidencia es `UNKNOWN/INTERNAL`, no autoridad Product.

## Criterio

Esta clasificación orienta decisiones futuras y no ejecuta acciones
destructivas. Las etiquetas adicionales identifican seguridad, coste, lock-in o
bloqueo Foundation.

FOUNDATION-004 añade una preclasificación técnica focalizada, no normativa, en
[`audits/DISCOVERY_TECHNICAL_ASSET_PRECLASSIFICATION.md`](audits/DISCOVERY_TECHNICAL_ASSET_PRECLASSIFICATION.md).
Las etiquetas `*_CANDIDATE` expresan una hipótesis para FOUNDATION-005 y no
autorizan conservar, adaptar, reescribir, deprecar o retirar código.

FOUNDATION-005 reemplaza esas hipótesis como evidencia técnica vigente mediante
la [matriz de clasificación final](audits/FOUNDATION-005_ASSET_CLASSIFICATION_MATRIX.md),
la [scorecard](audits/FOUNDATION-005_CONFORMANCE_SCORECARD.md) y el
[backlog propuesto](audits/FOUNDATION-005_REMEDIATION_BACKLOG.md). Las acciones
siguen sin estar autorizadas por esta clasificación.

| Activo | Ruta | Clasificación | Motivo | Riesgo / etiquetas | Acción futura | Dependencias |
|---|---|---|---|---|---|---|
| Historial y baseline | Git + tag `discovery-final-baseline` | KEEP | Evidencia inmutable de Descubrimiento | SECURITY_CRITICAL | Proteger tag y trazabilidad | GitHub |
| Definición de proyecto | `docs/archive/discovery/root/PROJECT_DEFINITION.md` | ADAPT | Visión valiosa con vocabulario previo | FOUNDATION_BLOCKER | Extraer visión Foundation | ADR nuevos |
| Arquitectura | `docs/archive/discovery/root/ARCHITECTURE.md` | ADAPT | Buenas fronteras, mezcla conceptual/histórica | FOUNDATION_BLOCKER | Consolidar arquitectura global | F2/F3 |
| Session tracker | `docs/archive/discovery/trackers/SESSION_TRACKER.md` | ARCHIVE | Histórico operativo extenso | Ruido normativo | Preservado como evidencia | Archivo Discovery |
| ADR-001 a ADR-005 | `docs/archive/discovery/stasisly_definition/adr/` | ADAPT | Principios reutilizables | Revalidación necesaria | Crear ADR Foundation equivalentes | Gobierno |
| ADR-006 y ADR-007 | mismas rutas | ARCHIVE | Más de 48.000 líneas acumuladas | FOUNDATION_BLOCKER | Extraer decisiones y evidencias | Archivo Discovery |
| ADR-008 a ADR-012 | mismas rutas | ADAPT | Decisiones recientes de surfaces/catálogo | Nombres antiguos | Revalidar y dividir | Vocabulario Foundation |
| Planes 2B | `docs/archive/discovery/stasisly_definition/implementation_plans/` | ARCHIVE | Evidencia de ejecución cerrada | Ninguno inmediato | Preservados, no ejecutar | Tag baseline |
| 43 agentes AAA | `docs/archive/discovery/stasisly_definition/agents/` | ADAPT | Base experta de Development | COST_CRITICAL | Extraer plantilla y roster | Gobierno de agentes |
| 6 comités | `docs/archive/discovery/stasisly_definition/committees/` | ADAPT | Gobierno útil, posible sobredimensión | Coste de coordinación | Revisar mandato/gates | Nexus/Rector futuros |
| Orquestador Codex | `docs/archive/discovery/stasisly_definition/orchestrator/` | ADAPT | Controles operativos valiosos | Puede frenar o sobreactuar | Convertir a estándar Foundation | Program Management |
| Flutter core/config | `lib/core/` | ADAPT / PARTIALLY_ADOPTED | Identidad/sesión, autorización y fronteras route/surface/environment canónicas; backend global pendiente | SECURITY_CRITICAL | Continuar enforcement backend | Riverpod, GoRouter |
| Auth legacy | `lib/features/auth/` | ADAPT / PARTIALLY_ADAPTED | Consume puerto propio, pero conserva fachadas legacy y bootstrap proveedor | SECURITY_CRITICAL, VENDOR_COUPLED | Migración gradual; no declarar feature completa adoptada | Auth, RBAC/ABAC |
| Chat legacy | `lib/features/chat/` | PHYSICALLY_REMOVED | Retirado en FOUNDATION-016-R1 tras reemplazo y auditoría de referencias | CLOSED_LOCALLY | Impedir recreación mediante guard | Git history |
| Chat local-safe | `lib/features/chat_sessions/`, `chat_messages/` | ADAPT | Fronteras y tests valiosos | Local/dev-only | Adoptar tras arquitectura F3/F7 | Auth, API |
| Perfil y especialistas | `lib/features/profile/`, `specialists/` | ADAPT | Contratos mínimos sanitizados | VENDOR_COUPLED parcial | Introducir puertos backend | Identidad/catálogo |
| Orchestrator UI | `lib/features/orchestrator/` | REWRITE | Prototipo, no Stasis Engine | FOUNDATION_BLOCKER | Redefinir bajo Product/Stasis | Agent organization |
| Áreas antiguas | `health`, `nutrition`, `physical_training`, `mental_training` | ADAPT | Pantallas de prototipo | Taxonomía legacy | Mapear a áreas Foundation | Product architecture |
| Routing actual | `lib/core/config/routes.dart`, `lib/core/routing/` | ADAPT / FOUNDATION_ADOPTED_LOCALLY | Registro tipado y gates locales; backend y producción pendientes | SECURITY_CRITICAL | Propagar contexto a backend | Auth y permisos |
| Migraciones 00001-00008 | `supabase/migrations/` | ADAPT | Base probada, schema heredado | SECURITY_CRITICAL, VENDOR_COUPLED | Auditar antes de Foundation técnica | PostgreSQL/Supabase |
| Seed sintético | `supabase/seed.sql` | KEEP | Fixture local determinista | No productivo | Mantener aislado y etiquetado | Schema 00008 |
| Edge Functions | `supabase/functions/` | ADAPT | Contratos backend probados | VENDOR_COUPLED, SECURITY_CRITICAL | Extraer puertos/API | Supabase/Deno |
| RPC de mensajes | migración `00007` | ADAPT | Atomicidad útil | SECURITY_CRITICAL | Revisión SQL especializada | PostgreSQL |
| Tests Supabase | `supabase/tests/` | KEEP | Evidencia local y regresión | Coste CI | Integrar selectivamente en CI | Docker/CLI |
| Tests Flutter | `test/` | KEEP | Guards y contratos útiles | Mantenimiento | Rebaselinar por fases | Flutter |
| CI Flutter | `.github/workflows/ci.yml` | ADAPT | Cobertura básica reproducible | Falta backend/Deno | Diseñar pipeline Foundation | GitHub Actions |
| Builds manuales | `.github/workflows/build.yml` | ADAPT | Skeleton útil | Supply chain/release | Endurecer y firmar | Stores |
| `.env.example` y `.gitignore` | raíz | KEEP | Separación segura de secretos | SECURITY_CRITICAL | Mantener allowlist | Entornos |
| Dependencias Flutter | `pubspec.yaml` | UNKNOWN | Varias no verificadas en uso | COST_CRITICAL, VENDOR_COUPLED | Auditoría de uso/licencia | F4 |
| Android/iOS/Web | plataformas | ADAPT | Skeleton multiplataforma | Release desconocido | Auditar por plataforma | Flutter/stores |
| MCP | documentación | ARCHIVE | Solo definición de Descubrimiento | FOUNDATION_BLOCKER | Nuevo ADR si hay caso real | Stasis Engine |
| Stasis Engine | documentación | REWRITE | Concepto central sin arquitectura formal | FOUNDATION_BLOCKER, COST_CRITICAL | Definir límites y Model Gateway | F3/F6 |
| Wearables | documentación | UNKNOWN | Intención aprobada, sin contratos | COST_CRITICAL | Diseñar extensibilidad, no implementar | F3/F8 |
| Memoria e investigaciones | documentación | REWRITE | Visión sin implementación | SECURITY_CRITICAL, COST_CRITICAL | Modelar consentimiento y trazabilidad | Data/Engine |
| Pagos y membresías | documentación/dependencias | UNKNOWN | Sin implementación verificada | SECURITY_CRITICAL | ADR comercial y proveedor | Product/Admin |

## Reglas para FOUNDATION-002

- `ARCHIVE` significa conservar históricamente, no borrar.
- `REMOVE` no se asigna todavía a ningún activo: falta revisión de impacto.
- `UNKNOWN` requiere evidencia antes de decidir.
- Todo `FOUNDATION_BLOCKER` necesita dueño, ADR o gate explícito.
- Todo `SECURITY_CRITICAL` requiere Seguridad, Privacidad y AppSec.
- Todo `COST_CRITICAL` requiere modelo de coste antes de escalar.

## Reglas añadidas por FOUNDATION-004

- La preclasificación está basada en inspección estática y no demuestra
  conformidad con la arquitectura Foundation.
- `chat_sessions`, `chat_messages`, `specialists`, migraciones y Edge Functions
  son candidatos a adaptación, no componentes adoptados.
- El chat heredado y el prototipo `orchestrator` son candidatos a reescritura;
  `orchestrator` no se denomina Stasis Engine.
- Tests SQL y guards de arquitectura son candidatos a conservación como
  evidencia, pendientes de rebaseline.
- `mental_training` y `physical_training` permanecen `UNKNOWN` hasta auditar
  taxonomía, rutas y dependencias.
- FOUNDATION-005 decidirá conformidad y backlog; este paquete no modifica los
  activos.

## Evidencia añadida por FOUNDATION-005

- `chat` heredado queda `DEPRECATE_CANDIDATE`; su acceso directo a Supabase,
  campos de autoridad cliente y rutas legacy no son conformes.
- `chat_sessions`, `chat_messages`, `specialists`, `profile`, las Edge
  Functions y sus contratos quedan `ADAPT_CANDIDATE`.
- El prototipo `orchestrator` queda `REWRITE_CANDIDATE` y no es Stasis Engine.
- Los guards modernos, controles CORS/runtime y la RPC transaccional son
  candidatos a conservación dentro de futuras adaptaciones.
- Las migraciones quedan `ADAPT_CANDIDATE` con un P0: diez tablas públicas
  legacy no tienen RLS y conservan grants amplios de cliente en el estado local
  definido por el repositorio.
- Las conclusiones se basan en baseline `e053684`, inspección estática y pruebas
  locales; no describen el estado de ningún entorno remoto.

## Evidencia añadida por FOUNDATION-005-R1

- La migración `00009_harden_legacy_public_tables_deny_all.sql` mantiene la
  clasificación `ADAPT_CANDIDATE` de las migraciones y cierra localmente el P0.
- Las diez tablas legacy tienen RLS activo, cero policies y cero grants CRUD de
  `anon` y `authenticated`; `service_role` conserva CRUD.
- Dos resets locales completos, 649 tests SQL, 52 tests Deno y 406 tests Flutter
  validan la remediación sin datos reales ni cambios remotos.
- El estado es `CLOSED_LOCALLY`; la clasificación no afirma conformidad remota
  ni resuelve los riesgos P1-P4.

## Consolidación de FOUNDATION-006

El [plan de adopción](planning/FOUNDATION_ASSET_ADOPTION_PLAN.md) consolida los
activos ejecutables auditados usando solo `KEEP`, `ADAPT`, `REWRITE`,
`DEPRECATE`, `REMOVE`, `DEFER` y `UNKNOWN`. La clasificación ya no expresa
prioridad: por ejemplo, un activo `ADAPT` puede permanecer diferido hasta que
se apruebe la taxonomía o la frontera que necesita.

Los contratos modernos de sessions/messages, DTOs sanitizados, guards
fail-closed, IDs explícitos, migraciones deny-all, RPC transaccional y harnesses
de limpieza se preservan como candidatos. Auth y routing se reconstruyen;
legacy chat se depreca; orchestrator se reescribe y no representa Stasis Engine.
No se propone `REMOVE` sin una auditoría de uso específica.

Ningún activo queda `FOUNDATION_ADOPTED` por esta consolidación. Debe superar
contrato aprobado, asignación de surface, revisión de seguridad, frontera de
proveedor, tests, documentación, ausencia de autoridad legacy y aceptación de
deuda residual.

## Adopción de FOUNDATION-008

- Contratos canónicos de identidad y sesión en `lib/core/identity/`:
  `FOUNDATION_ADOPTED` localmente.
- Supabase Auth: `ADAPT / CURRENT_PROVIDER_ADAPTER`, confinado a infraestructura.
- `lib/features/auth/`: `CANDIDATE / PARTIALLY_ADAPTED`; conserva compatibilidad
  heredada y no representa autorización Foundation.
- Autorización, Founder access y permisos por surface: `NOT_IMPLEMENTED`.
- Chat, profile y specialists conservan sus clasificaciones previas; solo se
  adaptaron consumidores directos al identificador canónico.

## Adopción de FOUNDATION-009

- `lib/core/authorization/domain/` y sus puertos PDP/PEP/audit:
  `FOUNDATION_ADOPTED` localmente.
- PDP deny-by-default local:
  `FOUNDATION_ADOPTED_FOR_LOCAL_CONTRACT_VALIDATION`.
- Enforcement de autorización completo: `PARTIALLY_IMPLEMENTED`; solo lectura
  de perfil propio usa la defensa adicional y backend sigue siendo autoridad.
- RBAC/ABAC persistente, Founder elevation y enforcement remoto:
  `NOT_IMPLEMENTED`.
- Profile permanece `ADAPT`; chat, rutas, DTOs y backend no cambiaron.

## Adopción de FOUNDATION-010

- `SurfaceBoundary`, `EnvironmentBoundary`, `EntryPointContext`, registro y
  decisiones: `FOUNDATION_ADOPTED` localmente.
- Routing Product/Development: `FOUNDATION_ADOPTED_LOCALLY` tras dos resets y
  dos suites SQL 649/649; no autoriza producción ni remoto.
- Chat y orchestrator legacy: `LEGACY_BLOCKED`; código conservado sin fallback.
- Administration, Platform UI, Stasis Engine y enforcement backend global:
  `NOT_IMPLEMENTED`.

## Adopción de FOUNDATION-011

- `supabase/functions/_shared/authorization/`, contexto, registro y PDP/PEP:
  `FOUNDATION_ADOPTED` localmente.
- Las seis fronteras Edge Function Product: `FOUNDATION_ADOPTED_LOCALLY` con
  identidad/ownership backend, operaciones registradas y política fail-closed.
- DTOs públicos, CORS, RPC y ownership previos: `KEEP` dentro de la adaptación.
- Runtime con fallback local implícito: `SUPERSEDED` por configuración explícita.
- Remoto, producción, RBAC/ABAC persistente, Founder access y audit sink:
  `NOT_IMPLEMENTED`.

## Decisión histórica de FOUNDATION-012

- `lib/features/chat/**`: `DEPRECATED_AND_BLOCKED`; no nuevo Product work,
  routes, fallback, Supabase directo ni reutilización como Engine.
- `MessageBubble`: `ADAPT_CANDIDATE`; `ChatInput`, `ChatPage` y wrapper:
  `REWRITE_CANDIDATE` bajo contratos canónicos.
- `chat_sessions` y `chat_messages`: `ADAPT` hacia Conversation/Message, sin
  afirmar migración ni implementación.
- seis Edge Functions: `KEEP_TEMPORARILY / ADAPT` detrás de API versionada.
- `specialist_catalog`: `ADAPT`; Agent Registry y roster: `NOT_IMPLEMENTED`.
- rutas dev-only: `KEEP_TEMPORARILY`; rutas legacy: `DEPRECATE` y luego `REMOVE`
  solo tras replacement, parity, data compatibility y rollback aprobados.
- Product Conversation architecture: approved conceptually at FOUNDATION-012
  and `PARTIALLY_IMPLEMENTED_LOCALLY` through FOUNDATION-015-R1.

## Adopción de FOUNDATION-013A

- `lib/features/conversations/domain/**`: `FOUNDATION_ADOPTED` como contrato
  Product canónico, sin provider, UI ni runtime.
- `ConversationRepository`, inputs y resultados: `FOUNDATION_ADOPTED`.
- adapters de `OwnChatSession`/`OwnChatMessage` y repositorio compuesto:
  `FOUNDATION_ADOPTED_LOCALLY`.
- `chat_sessions` y `chat_messages`: `TRANSITIONAL_ADAPTER_SOURCE`; sus
  contratos permanecen sin cambios.
- At FOUNDATION-013A, UI/routes, canonical backend API and Stasis Engine were
  `NOT_IMPLEMENTED`; later packages implement local Conversation UI/routes and
  transitional canonical boundaries, while Stasis Engine remains absent.
- chat legacy: en FOUNDATION-013A continuaba `DEPRECATED_AND_BLOCKED`; fue
  retirado físicamente por FOUNDATION-016-R1 sin fallback.

## Adopción de FOUNDATION-013B

- `conversation_idempotency`: `FOUNDATION_ADOPTED_LOCALLY / SERVER_MANAGED`;
  RLS deny-all para clientes y retención automática aún no implementada.
- RPCs create/send: `FOUNDATION_ADOPTED_LOCALLY` como frontera transaccional;
  nombres y tablas físicas permanecen `TRANSITIONAL`.
- Edge Functions create/send: `ADAPT / KEEP_TEMPORARILY`; solo llaman RPC para
  writes, con JWT verificado e `Idempotency-Key` obligatorio.
- generación Flutter de operation-attempt IDs: `FOUNDATION_ADOPTED_LOCALLY`;
  no añade autoridad ni Product wiring.
- API backend canónica completa, remoto y Product routes: `NOT_IMPLEMENTED`.

## Adopción de FOUNDATION-013C

- list/read/archive/restore e historia Message propia:
  `FOUNDATION_ADOPTED_LOCALLY` mediante RPCs estrechas y Edge PDP/PEP.
- `chat_sessions`/`messages` y endpoints session-named: `TRANSITIONAL`; no se
  renombran ni se exponen por acceso directo de cliente.
- archive/restore: `FOUNDATION_ADOPTED_LOCALLY / STATE_IDEMPOTENT`; archive no
  elimina identidad ni historia y restore no crea una Conversation nueva.
- API backend Conversation: `PARTIALLY_IMPLEMENTED`; author/provenance, UI,
  rutas, delete/pendingDeletion y remoto siguen `NOT_IMPLEMENTED`.

## Adopción de FOUNDATION-018

- Configuración Flutter explícita y fail-closed: `FOUNDATION_ADOPTED_LOCALLY`;
  no activa remoto.
- Preflight Development sin red: `FOUNDATION_ADOPTED_LOCALLY`.
- Manifest Development: `FOUNDATION_ADOPTED_LOCALLY_UNAPPROVED`, con target y
  commit `UNASSIGNED` y ejecución/validación remota `NOT_EXECUTED`.
- Migraciones 00001-00012 y ocho Edge Functions: `LOCALLY_AUDITED`.
- Cinco skips aprobados: `CLASSIFIED_NOT_ENABLED`.

## Adopción de FOUNDATION-019C

- Catálogo runtime Product y Stasis create: `FOUNDATION_ADOPTED_LOCALLY`.
- Contrato de fixture sintético: `FOUNDATION_ADOPTED`; cleanup:
  `FOUNDATION_ADOPTED_LOCALLY`; remoto
  `NOT_EXECUTED`.
- Schemas de evidencia y smoke result: `FOUNDATION_ADOPTED_LOCALLY`.
- Retención idempotente: `POST_DEVELOPMENT_OPERATIONAL_BLOCKER`; no cleanup
  destructivo implementado.
- Agent Registry, IA, Stasis Engine y datos reales: `NOT_ADOPTED`.

## Adopción de FOUNDATION-019A-R1

- Manifest remoto y cleanup éxito/fallo: `FOUNDATION_ADOPTED`.
- Gate multifactor: `FOUNDATION_ADOPTED_LOCALLY`; tests
  `CLASSIFIED_NOT_ENABLED`.
- CORS: contrato `FOUNDATION_ADOPTED`; origen exacto `UNASSIGNED`.
- Lifecycle remoto: `SIMULATED_LOCALLY`, no validado remotamente.
- Ejecución: `NOT_AUTHORIZED`; retención:
  `POST_DEVELOPMENT_OPERATIONAL_BLOCKER`.

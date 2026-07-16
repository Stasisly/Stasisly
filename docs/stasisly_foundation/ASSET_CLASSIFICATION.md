# Clasificación inicial de activos

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
| Flutter core/config | `lib/core/` | ADAPT / PARTIALLY_ADOPTED | Identidad/sesión y contratos de autorización canónicos; enforcement global parcial | SECURITY_CRITICAL | Continuar aislamiento de surfaces | Riverpod, GoRouter |
| Auth legacy | `lib/features/auth/` | ADAPT / PARTIALLY_ADAPTED | Consume puerto propio, pero conserva fachadas legacy y bootstrap proveedor | SECURITY_CRITICAL, VENDOR_COUPLED | Migración gradual; no declarar feature completa adoptada | Auth, RBAC/ABAC |
| Chat legacy | `lib/features/chat/` | REWRITE | Contratos y rutas antiguas | SECURITY_CRITICAL | No conectar; reemplazar gradualmente | Sessions/messages |
| Chat local-safe | `lib/features/chat_sessions/`, `chat_messages/` | ADAPT | Fronteras y tests valiosos | Local/dev-only | Adoptar tras arquitectura F3/F7 | Auth, API |
| Perfil y especialistas | `lib/features/profile/`, `specialists/` | ADAPT | Contratos mínimos sanitizados | VENDOR_COUPLED parcial | Introducir puertos backend | Identidad/catálogo |
| Orchestrator UI | `lib/features/orchestrator/` | REWRITE | Prototipo, no Stasis Engine | FOUNDATION_BLOCKER | Redefinir bajo Product/Stasis | Agent organization |
| Áreas antiguas | `health`, `nutrition`, `physical_training`, `mental_training` | ADAPT | Pantallas de prototipo | Taxonomía legacy | Mapear a áreas Foundation | Product architecture |
| Routing actual | `lib/core/config/routes.dart` | REWRITE | Contiene rutas legacy y dev-only | SECURITY_CRITICAL | Diseñar routing por surface | Auth y permisos |
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

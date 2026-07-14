# Clasificación inicial de activos

## Criterio

Esta clasificación orienta decisiones futuras y no ejecuta acciones
destructivas. Las etiquetas adicionales identifican seguridad, coste, lock-in o
bloqueo Foundation.

| Activo | Ruta | Clasificación | Motivo | Riesgo / etiquetas | Acción futura | Dependencias |
|---|---|---|---|---|---|---|
| Historial y baseline | Git + tag `discovery-final-baseline` | KEEP | Evidencia inmutable de Descubrimiento | SECURITY_CRITICAL | Proteger tag y trazabilidad | GitHub |
| Definición de proyecto | `docs/PROJECT_DEFINITION.md` | ADAPT | Visión valiosa con vocabulario previo | FOUNDATION_BLOCKER | Extraer visión Foundation | ADR nuevos |
| Arquitectura | `docs/ARCHITECTURE.md` | ADAPT | Buenas fronteras, mezcla conceptual/histórica | FOUNDATION_BLOCKER | Consolidar arquitectura global | F2/F3 |
| Session tracker | `docs/SESSION_TRACKER.md` | ARCHIVE | Histórico operativo extenso | Ruido normativo | Preservar como evidencia | Archivo Discovery |
| ADR-001 a ADR-005 | `docs/stasisly_definition/adr/` | ADAPT | Principios reutilizables | Revalidación necesaria | Crear ADR Foundation equivalentes | Gobierno |
| ADR-006 y ADR-007 | mismas rutas | ARCHIVE | Más de 48.000 líneas acumuladas | FOUNDATION_BLOCKER | Extraer decisiones y evidencias | Archivo Discovery |
| ADR-008 a ADR-012 | mismas rutas | ADAPT | Decisiones recientes de surfaces/catálogo | Nombres antiguos | Revalidar y dividir | Vocabulario Foundation |
| Planes 2B | `docs/stasisly_definition/implementation_plans/` | ARCHIVE | Evidencia de ejecución cerrada | Ninguno inmediato | Mover en FOUNDATION-002 | Tag baseline |
| 43 agentes AAA | `docs/stasisly_definition/agents/` | ADAPT | Base experta de Development | COST_CRITICAL | Extraer plantilla y roster | Gobierno de agentes |
| 6 comités | `docs/stasisly_definition/committees/` | ADAPT | Gobierno útil, posible sobredimensión | Coste de coordinación | Revisar mandato/gates | Nexus/Rector futuros |
| Orquestador Codex | `docs/stasisly_definition/orchestrator/` | ADAPT | Controles operativos valiosos | Puede frenar o sobreactuar | Convertir a estándar Foundation | Program Management |
| Flutter core/config | `lib/core/` | ADAPT | Gates y contratos útiles | SECURITY_CRITICAL | Auditar acoplamientos | Riverpod, GoRouter |
| Auth legacy | `lib/features/auth/` | REWRITE | Supabase directo y frontera heredada | SECURITY_CRITICAL, VENDOR_COUPLED | Diseñar puerto de identidad | Auth, RBAC/ABAC |
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

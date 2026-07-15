# Preclasificación de Activos Técnicos de Descubrimiento

## Metadatos

| Campo | Valor |
|---|---|
| Título | Preclasificación de Activos Técnicos de Descubrimiento |
| Estado | ACTIVE evidence |
| Nivel de autoridad | 6 — Evidencia, auditorías y trackers |
| Propietario | Arquitectura y Documentación bajo Rector |
| Aprobador | Evidence owner; Founder decide adopción o retirada |
| Versión | 1.0 |
| Condición de vigencia | Evidencia publicada con FOUNDATION-004 |
| Sustituye | No aplica |
| Dependencias | Git baseline `abce443`; 05_GLOBAL_TECHNICAL_ARCHITECTURE |

## Alcance y límites

Auditoría estática en solo lectura de rutas seleccionadas. No prueba conformidad
completa ni autoriza reutilización, retirada o implementación. FOUNDATION-005
debe validar dependencias, comportamiento, seguridad, tests y coste.

## Clasificación

| Activo | Evidencia observada | Preclasificación | Razón / gate |
|---|---|---|---|
| `lib/features/chat/` | 17 archivos; `supabase_flutter`, DTO internos, writes directos y `role` desde cliente | `REWRITE_CANDIDATE` | Frontera legacy de alto riesgo; no conectar |
| `lib/features/chat_sessions/` | 19 archivos; contratos, repositorios, guards local/backend-blocked y transporte aislado | `ADAPT_CANDIDATE` | Fronteras reutilizables; URL Supabase aún visible en wiring |
| `lib/features/chat_messages/` | 20 archivos; input/payload validation, sessionId explícito, transporte y fallos cerrados | `ADAPT_CANDIDATE` | Rebaselinar contra API Foundation y auth técnica |
| `lib/features/specialists/` | 9 archivos; dominio sanitizado y remote datasource aún no ejecutable | `ADAPT_CANDIDATE` | Buen contrato candidato; falta integración Foundation |
| `lib/features/orchestrator/` | 9 archivos; roster mock hardcoded y nomenclatura histórica | `REWRITE_CANDIDATE` | Prototipo Product; no es Stasis Engine |
| `lib/features/mental_training/` | Una página de presentación | `UNKNOWN` | Nomenclatura legacy y evidencia insuficiente |
| `lib/features/physical_training/` | Una página de presentación | `UNKNOWN` | Nomenclatura legacy y evidencia insuficiente |
| `supabase/migrations/` | Ocho migraciones versionadas; RLS, catálogo, sesiones, mensajes y RPC | `ADAPT_CANDIDATE` | Evidencia SQL valiosa; schema y coupling requieren auditoría |
| `supabase/functions/` | Seis funciones y shared guards/tests sobre runtime Supabase/Deno | `ADAPT_CANDIDATE` | Contratos aprovechables detrás de API Stasisly |
| `supabase/tests/` | 50 archivos SQL/PSQL/shell con cleanup y regresiones | `KEEP_CANDIDATE` | Evidencia validada; no equivale a contrato Foundation |
| `test/architecture/` | 10 guards de entorno, identidad, sesiones, mensajes y catálogo | `KEEP_CANDIDATE` | Protecciones útiles que deben rebaselinarse |

No se asigna `REMOVE_CANDIDATE`: falta conformance audit y análisis de
dependencias. `mental_training` y `physical_training` permanecen `UNKNOWN` para
evitar inferir su destino desde un solo archivo.

## Deuda técnica conocida

| Deuda | Riesgo | Tratamiento posterior |
|---|---|---|
| TOCTOU en creación de sesión | Duplicidad/consistencia | Auditar atomicidad y contrato |
| Contratos de chat legacy | Seguridad y ownership | Aislar y reemplazar gradualmente |
| Naming legacy de features | Coherencia Product | Decidir taxonomía antes de renombrar |
| Coupling Supabase y acceso cliente directo | Portabilidad/autorización | Introducir API y adapters propios |
| Autorización técnica ausente | Acceso indebido | Threat model y RBAC+ABAC+gates |
| Entitlements ausentes | Producto/coste | Definir contrato y enforcement backend |
| Runtime de Stasis Engine ausente | Capacidad no implementada | Diseñar después de conformance audit |
| Cost accounting ausente | Coste no acotado | Model Gateway y Cost Controller |
| Proveedor/modelo IA ausente | Decisión pendiente | ADR posterior; no seleccionar aún |
| Tests de portabilidad operativa ausentes | Lock-in | Diseñar export/restore/exit tests |
| Contratos cross-surface ausentes | Aislamiento | Definir APIs, events y workflows |

## Evidencia negativa

No se modificó ningún activo auditado, no se ejecutaron tests ni entornos y no
se accedió a remoto. Las clasificaciones son candidatas, no decisiones de
implementación.

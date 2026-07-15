# Portabilidad de Infraestructura

## Metadatos

| Campo | Valor |
|---|---|
| Título | Portabilidad de Infraestructura |
| Estado | APPROVED conceptually |
| Nivel de autoridad | 3 — Documento normativo de dominio |
| Propietario | Arquitectura y DevOps bajo Rector |
| Aprobador | Founder |
| Versión | 1.0 |
| Condición de vigencia | Decisión conceptual vigente con FOUNDATION-004 |
| Sustituye | Dependencia de proveedor sin política Foundation de salida |
| Dependencias | 05_GLOBAL_TECHNICAL_ARCHITECTURE; ADR-F002 |

## Estado

```text
Conceptual decision: APPROVED
Infrastructure changes: NOT IMPLEMENTED
```

## Plataforma de datos y proveedor inicial

PostgreSQL es la plataforma relacional canónica y fuente de verdad donde
corresponda. Supabase es una plataforma managed inicial, no la identidad del
backend Stasisly. Se evalúan por separado PostgreSQL, Supabase Auth, Storage,
Edge Functions, Realtime y gestión de plataforma.

## Requisitos de dependencia crítica

Toda dependencia crítica debe tener contrato propio, ruta de exportación,
configuración como código cuando sea posible, estrategia de migración,
abstracción proporcional, observabilidad de costes, alternativa y exit trigger.

| Clasificación | Significado |
|---|---|
| `PORTABLE` | Sustitución prevista sin cambio material de dominio |
| `PORTABLE_WITH_ADAPTATION` | Requiere adapters o migración acotada |
| `VENDOR_COUPLED` | Contratos o operación dependen materialmente del proveedor |
| `CRITICAL_LOCK_IN` | Salida inviable o de riesgo crítico sin remediación |
| `UNKNOWN` | Evidencia insuficiente |

No se crea una abstracción artificial para cada biblioteca. El esfuerzo de
portabilidad es proporcional a criticidad, datos, coste de sustitución y riesgo.

## Managed y self-hosted

Los servicios managed están permitidos y son preferibles cuando reducen riesgo
operativo y conservan portabilidad suficiente. Self-hosting es capacidad futura,
no requisito inmediato. Una migración se activa por coste, control, regulación,
disponibilidad o necesidad estratégica demostrada.

La comparación usa coste total de propiedad:

```text
provider bill
+ engineering
+ security
+ backups
+ monitoring
+ incident response
+ availability
+ recovery
```

Self-hosted no se presume más barato ni más seguro.

## Plan de salida

Cada servicio crítico debe definir owner, formatos de datos, exportación,
restauración, compatibilidad, RPO/RTO cuando proceda, prueba periódica de salida,
dependencias y criterio de decisión. Schema, migraciones, eventos y contratos se
versionan bajo control Stasisly.

## Coste y capacidad

Costes de base de datos, storage, egress, funciones, auth, observabilidad,
backups, regiones e IA deben poder atribuirse por entorno y capacidad. La
hiperescala operativa no se aprueba sin SLO, presupuestos, límites y owners.

## Límites

No se migra proveedor, configura infraestructura, ejecuta SQL, selecciona
servicio nuevo ni declara una prueba de salida superada. Las clasificaciones
actuales son evidencia preliminar y requieren conformance audit.

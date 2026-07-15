# Surfaces y Acceso

## Metadatos

| Campo | Valor |
|---|---|
| Título | Surfaces y Acceso |
| Estado | APPROVED conceptually, implementation pending |
| Nivel de autoridad | 1 — Constitución y gobierno aprobados por Founder |
| Propietario | Founder; Arquitectura y Seguridad como revisores futuros |
| Aprobador | Founder |
| Versión | 1.0 |
| Condición de vigencia | Decisión conceptual vigente con FOUNDATION-003 |
| Sustituye | `Wizard Surface` y `Admin/Engine Surface` como nomenclatura vigente |
| Dependencias | 00_GLOBAL_CONSTITUTION; 01_GOVERNANCE_AND_AUTHORITY |

## Estado de implementación

```text
Conceptual decision: APPROVED
Technical implementation: NOT IMPLEMENTED
```

## Product Surface

Surface destinada a usuarios finales, experiencia principal, Stasis,
especialistas Product, salud, nutrición, entrenamiento, wellness,
conversaciones y funciones de bienestar. Stasis es su coordinador exclusivo.

## Development Surface

Surface destinada a desarrollo, arquitectura, auditoría técnica, configuración
de desarrollo, tests, entornos, agentes de ingeniería, control de calidad,
release, observabilidad técnica y herramientas internas. Rector es su
coordinador exclusivo.

## Administration Surface

Surface destinada a gestión empresarial, operaciones, usuarios, soporte,
métricas, facturación, marketing, legal, compliance, configuración autorizada y
supervisión operativa. Gerendi es su coordinador exclusivo.

Stasis Engine no es una surface. `Panel Admin dentro de Product`, `Wizard
Surface` y `Admin/Engine Surface` son nomenclaturas históricas reemplazadas, no
términos vigentes.

## Matriz conceptual de acceso

| Identidad | Product | Development | Administration |
|---|---:|---:|---:|
| Usuario final | Sí | No | No |
| Administrador | Explícito | No por defecto | Sí |
| Developer | Explícito | Sí | Explícito |
| Founder | Sí | Sí | Sí |
| Nexus | Según tarea | Según tarea | Según tarea |
| Stasis | Sí | No | No |
| Rector | No por defecto | Sí | No por defecto |
| Gerendi | No por defecto | No | Sí |

```text
Ninguna surface concede acceso total por herencia.
```

Un developer puede recibir acceso a las tres surfaces solo mediante permisos
explícitos, contextuales, mínimos y auditables. Un administrador no accede a
Development por ser administrador. Nexus recibe únicamente el acceso necesario
para la tarea autorizada.

## Authority frente a Access

`Authority` define qué decisiones puede proponer, aprobar, bloquear o escalar
una identidad. `Access` define qué recursos, datos, herramientas y operaciones
puede usar técnicamente.

- Rector puede coordinar una decisión técnica sin acceso automático a
  producción.
- Gerendi puede gobernar una operación empresarial sin acceso al repositorio.
- Stasis puede coordinar especialistas Product sin leer datos administrativos.

Los prompts no son controles de autorización suficientes. La implementación
futura combinará:

```text
RBAC
+ ABAC
+ environment gates
+ least privilege
+ just-in-time elevation
+ audit trail
+ revocation
```

Este paquete no diseña tablas, claims, policies, RLS ni roles técnicos.

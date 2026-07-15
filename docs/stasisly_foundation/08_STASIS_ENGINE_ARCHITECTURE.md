# Arquitectura Conceptual de Stasis Engine

## Metadatos

| Campo | Valor |
|---|---|
| Título | Arquitectura Conceptual de Stasis Engine |
| Estado | APPROVED conceptually |
| Nivel de autoridad | 3 — Documento normativo de dominio |
| Propietario | Arquitectura de Stasis Engine bajo Rector y coordinación de Nexus |
| Aprobador | Founder |
| Versión | 1.0 |
| Condición de vigencia | Decisión conceptual vigente con FOUNDATION-004 |
| Sustituye | Prototipo orchestrator como representación implícita del Engine |
| Dependencias | 03_STASIS_ENGINE_BOUNDARY; 05_GLOBAL_TECHNICAL_ARCHITECTURE; ADR-F002 |

## Estado

```text
Conceptual decision: APPROVED
Runtime and services: NOT IMPLEMENTED
```

## Plataforma modular

```text
Stasis Engine
├── Agent Runtime
├── Agent Registry
├── Prompt Registry
├── Orchestration
├── Routing
├── Memory Services
├── Context Assembly
├── Tool Gateway
├── Model Gateway
├── Cost Controller
├── Evaluation
├── Observability
├── Safety Controls
└── Audit and Traceability
```

Estos son módulos de responsabilidad, no servicios desplegables obligatorios.
La implementación inicial puede residir en un sistema sencillo y modular.

## Stasis y Stasis Engine

Stasis es el agente coordinador Product. Stasis Engine es la plataforma técnica
capaz de ejecutar Stasis y otros agentes. Stasis no contiene toda la memoria,
credenciales, permisos, herramientas, datos organizativos ni lógica runtime.
Stasis Engine no adquiere Founder Authority.

## Agent Runtime

El runtime futuro carga la definición del agente, resuelve versión aprobada,
ensambla contexto autorizado, selecciona tools y modelo, aplica límites,
ejecuta, registra uso y trace, persiste outputs aprobados y libera recursos.
Los agentes se ejecutan bajo demanda; no se crean procesos permanentes por
agente sin necesidad demostrada.

## Registros separados

Agent Registry contempla identidad, surface, posición organizativa, status,
versiones, capabilities, tool/memory/model/cost policies, evaluación,
visibilidad y activation state. Se mantienen separados catálogo público Product,
runtime registry interno, roster organizativo, Prompt Registry y permisos
técnicos. No se diseñan tablas.

Prompt Registry mantiene prompts versionados, revisados, auditables,
reversibles y evaluados antes de activación. No contiene secretos ni concede
autorización.

## Model Gateway

Model Gateway es la interfaz neutral a proveedores para selección de proveedor
y modelo, routing por tarea/riesgo/coste, fallback, rate limits, budgets,
medición, latencia, aislamiento y soporte de modelos externos o self-hosted. No
se seleccionan proveedor ni modelo.

## Cost Controller

Cost Controller es obligatorio en el diseño: budgets, quotas, estimación,
accounting, rate limiting, concurrency, circuit breakers, prevención de abuso,
límites por plan/surface/entorno, alertas y degradación controlada.

Debe poder medir, al menos, coste por usuario activo, conversación, mensaje,
ejecución de agente, modelo, tool call, surface, plan, entorno y región.

## Tool Gateway y seguridad

Tool Gateway valida autorización de agente y usuario, scope, operación, coste,
riesgo, rate limit, auditoría y confirmación. Safety Controls niega por defecto,
limita ejecución y evita exposición de credenciales. El prompt nunca es la
barrera de autorización.

## OAuth, BYOK y credenciales

Los usuarios normales no proporcionan claves de IA. OAuth conecta servicios
externos autorizados. BYOK es una opción futura avanzada o enterprise y nunca
implica enviar claves sin protección a Flutter. Las credenciales de plataforma
permanecen en backend.

## Evaluación y trazabilidad

La activación requiere versiones aprobadas, evaluación y rollback. La
trazabilidad registra participantes, tools, modelos, versiones, inputs/outputs
permitidos, decisiones, coste, latencia, errores y policy outcomes con
minimización. No almacena razonamiento interno privado del modelo.

## Límites

No se crean agentes, prompts, runtime, schema, permisos, provider integrations,
procesos, tools ni infraestructura.

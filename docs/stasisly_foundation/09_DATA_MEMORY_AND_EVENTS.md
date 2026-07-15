# Datos, Memoria y Eventos

## Metadatos

| Campo | Valor |
|---|---|
| Título | Datos, Memoria y Eventos |
| Estado | APPROVED conceptually |
| Nivel de autoridad | 3 — Documento normativo de dominio |
| Propietario | Arquitectura de Datos bajo Rector |
| Aprobador | Founder |
| Versión | 1.0 |
| Condición de vigencia | Decisión conceptual vigente con FOUNDATION-004 |
| Sustituye | Ausencia de una frontera Foundation para datos y memoria |
| Dependencias | 05_GLOBAL_TECHNICAL_ARCHITECTURE; ADR-F002 |

## Estado

```text
Conceptual decision: APPROVED
Data schemas and processing: NOT IMPLEMENTED
```

## Categorías de datos

- Transactional data.
- Identity data.
- Health and wellness data.
- Conversation data.
- Agent configuration.
- Organizational data.
- Memory.
- Research artifacts.
- Audit data.
- Usage and cost data.
- Observability data.

Cada categoría tendrá owner, propósito, sensibilidad, procedencia, retención,
región, consumidores autorizados y mecanismo de borrado. Los datos de Salud
requieren reglas específicas posteriores; aquí no se diseña esquema clínico ni
cifrado.

## Memoria federada

La memoria puede incluir memoria de especialista, dominio o departamento,
surface, global autorizada, investigación y memoria controlada por usuario
cuando proceda. No toda memoria reside necesariamente en una base ni todo
agente puede leer todos los niveles.

El acceso requiere propósito, minimización, provenance, consentimiento o base
aplicable, caducidad, versionado, auditabilidad y revocación. La memoria no es
un volcado indiscriminado de conversaciones o razonamiento interno.

## Principios de datos

```text
data minimization
purpose limitation
explicit ownership
provenance
retention
deletion
regional controls
encryption
auditability
portability
least privilege
```

PostgreSQL es la plataforma relacional canónica donde corresponda, no el único
almacén obligatorio. Object storage, índices, colas u otros stores requieren
contratos y políticas propias.

## Comunicación y eventos

Las surfaces intercambian información mediante APIs, commands, events, read
models y workflows auditados. No acceden directamente a tablas internas de otra
surface.

La arquitectura puede incorporar queues, event bus, background jobs, scheduled
jobs, webhooks y workflow orchestration. Las operaciones simples y seguras son
síncronas por defecto; se usa asincronía cuando latencia, escala, resiliencia o
workflow la justifican.

## Contratos de evento

Un evento futuro declara owner, versión, productor, consumidores, datos
mínimos, clasificación, idempotencia, orden cuando importe, retención, replay,
errores y observabilidad. Publicar un evento no concede acceso cross-surface.

## Wearable readiness

```text
Wearable companion
→ Device API or sync contract
→ Product services
→ authorized data processing
```

La frontera futura contemplará operación offline, delayed sync, batería,
permisos, provenance, conflictos, identidad de dispositivo, sensibilidad de
Salud y control de frecuencia/coste. No se implementan apps ni sync.

## Portabilidad y borrado

Formatos de exportación, migraciones, restauración y eliminación deben ser
verificables. La salida de un proveedor no puede destruir provenance, controles
de acceso ni obligaciones de retención.

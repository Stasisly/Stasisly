# Fronteras de API y Servicios

## Metadatos

| Campo | Valor |
|---|---|
| Título | Fronteras de API y Servicios |
| Estado | APPROVED conceptually |
| Nivel de autoridad | 3 — Documento normativo de dominio |
| Propietario | Arquitectura Backend bajo Rector |
| Aprobador | Founder |
| Versión | 1.0 |
| Condición de vigencia | Decisión conceptual vigente con FOUNDATION-004 |
| Sustituye | SDK de proveedor como frontera pública implícita |
| Dependencias | 05_GLOBAL_TECHNICAL_ARCHITECTURE; ADR-F002 |

## Estado

```text
Conceptual decision: APPROVED
Technical implementation: NOT IMPLEMENTED
```

## Regla de frontera

```text
Stasisly clients must consume contracts owned by Stasisly.
```

La API propia es la frontera preferente entre clientes y capacidades sensibles.
Oculta infraestructura específica, centraliza autorización, valida ownership,
sanea DTO públicos, controla versiones, mide uso, aplica rate limits, admite
múltiples clientes, facilita migraciones y prepara futuros wearables.

API propia no significa un monolito obligatorio ni una red de microservicios.
Puede evolucionar mediante Edge Functions, application services, containers,
serverless o servicios internos, siempre detrás de contratos Stasisly.

## Capas y ownership

- **API and Access Layer:** identidad, autorización, validación, versionado,
  límites, respuesta pública y auditoría de entrada.
- **Application Services:** casos de uso y coordinación transaccional.
- **Domain Services:** invariantes y decisiones de dominio independientes del
  proveedor.
- **Platform Services:** capacidades compartidas de Engine, costes,
  observabilidad y seguridad.
- **Infrastructure Adapters:** PostgreSQL, Supabase y otros proveedores.

Cada contrato declara owner, consumidores, entorno, datos admitidos, errores,
idempotencia cuando aplique, límites y compatibilidad. Los DTO de proveedor no
se propagan como contratos Product.

## Flutter y Supabase

```text
New Product capabilities:
prefer Stasisly API.

Direct Supabase client access:
exceptional, explicitly approved, RLS-protected and portable.
```

Los adaptadores Supabase heredados pueden conservarse temporalmente tras
auditoría. Nunca habrá `service_role` en clientes, autorización solo en UI,
lógica sensible de negocio en Flutter ni DTO de proveedor dispersos por
Product.

## Comunicación cross-surface

Las surfaces interactúan mediante APIs aprobadas, commands, events, read models
y workflows auditados. La autorización cross-surface es explícita y valida
identidad, ownership, propósito, entorno, operación, datos expuestos y audit
requirement. No existe acceso directo implícito a tablas de otra surface.

## Tool Gateway

Las herramientas externas pasan por Tool Gateway. Antes de ejecutar valida
autorización del agente y usuario, scope de datos, tipo de operación, rate
limit, coste, riesgo, auditoría y confirmación. Los prompts no conceden acceso
y este documento no selecciona herramientas.

## Integraciones

AI, pagos, email, notificaciones, analytics, Apple, Google, Garmin, wearables,
health platforms, calendario, comunicaciones, storage e identity usarán
adaptadores y contratos controlados. Ningún proveedor nuevo queda seleccionado.

## Operaciones síncronas y asíncronas

```text
Synchronous by default when simple and safe.
Asynchronous when latency, scale, resilience or workflow needs justify it.
```

Queues, event bus, background jobs, scheduled jobs, webhooks y workflow
orchestration se incorporarán solo con necesidad demostrada.

## Fallos y compatibilidad

Las fronteras fallan cerrado, no convierten errores reales en demo, no exponen
detalles internos y mantienen errores públicos sanitizados. Versionado y
deprecación deben permitir evolución controlada sin atar clientes al proveedor.

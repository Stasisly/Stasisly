# Arquitectura Técnica Global

## Metadatos

| Campo | Valor |
|---|---|
| Título | Arquitectura Técnica Global |
| Estado | APPROVED conceptually |
| Nivel de autoridad | 3 — Documento normativo de dominio |
| Propietario | Arquitectura bajo Rector |
| Aprobador | Founder |
| Versión | 1.0 |
| Condición de vigencia | Decisión conceptual vigente con FOUNDATION-004 |
| Sustituye | Arquitectura técnica de Descubrimiento como autoridad vigente |
| Dependencias | 00_GLOBAL_CONSTITUTION; 02_SURFACES_AND_ACCESS; ADR-F002 |

## Estado de implementación

```text
Conceptual decision: APPROVED
Technical implementation: NOT IMPLEMENTED
```

## Principios vinculantes

- Backend as authority y validación en fronteras confiables.
- Seguridad fail-closed, mínimo privilegio y ownership explícito.
- Aislamiento de surfaces y ausencia de acceso total heredado.
- Founder Authority exclusiva y protegida.
- Infraestructura portable sin lock-in irreversible silencioso.
- Diseño wearable-ready y preparado para expansión global.
- Implementación proporcional a la fase actual.
- Uso de IA medible y financieramente acotado.

## Arquitectura objetivo

```text
Clients and Surfaces
├── Product clients
│   ├── Mobile
│   ├── Web
│   └── Future wearable companions
├── Development Surface clients and tools
└── Administration Surface clients and tools
        ↓
Stasisly API and Access Layer
        ↓
Domain and Application Services
        ↓
Stasis Engine and Platform Services
        ↓
Infrastructure Adapters
        ↓
PostgreSQL, object storage, queues, providers and external services
```

Las capas expresan responsabilidades y trust boundaries, no un requisito de
desplegar un servicio independiente por caja. La primera implementación puede
ser un sistema modular sencillo si conserva contratos, ownership y capacidad
de evolución.

## Qué constituye una surface

Una surface combina población usuaria, capacidades autorizadas, rutas y puntos
de entrada, APIs, exposición de datos, workflows operativos, familias de
agentes, auditoría y restricciones de entorno. Compartir componentes técnicos
no comparte autoridad automáticamente.

### Product Surface

Incluye mobile/web de consumo, Stasis, especialistas Product, salud, nutrición,
entrenamiento, wellness, conversaciones, vistas de memoria e investigación,
perfil, suscripciones y futuros wearables. Excluye controles Development,
infraestructura en crudo, operaciones empresariales, secretos, `service_role`,
prompts internos, permisos internos y administración de producción. Flutter no
es autoridad de autorización.

### Development Surface

Incluye arquitectura, workflows de desarrollo, testing, quality gates,
desarrollo de agentes y prompts, controles de entorno, auditorías técnicas,
preparación de release, observabilidad de ingeniería, documentación y
operaciones local/development. Capacidad Development no implica autoridad de
producción ni acceso permanente a ella.

### Administration Surface

Incluye gestión empresarial, usuarios y soporte, suscripciones y facturación,
marketing, legal, compliance, finanzas, customer success, BI, configuración
autorizada, coordinación de incidentes, proveedores, supervisión y controles
autorizados de Stasis Engine. Excluye modificación de código por defecto,
mutación directa sin APIs controladas, infraestructura sin límites, acceso
Development automático y Founder Authority.

## Founder technical access boundary

Founder podrá atravesar las tres surfaces mediante una capa de autoridad propia,
sin una sesión universal insegura. El diseño futuro distinguirá identidad,
contexto de sesión, nivel de autoridad, entorno, surface, elevación, scope de
operación y evento de auditoría. Una elevación crítica no se propagará
automáticamente entre surfaces.

## Backend, datos y proveedores

Los clientes consumen contratos propiedad de Stasisly. PostgreSQL es la
plataforma relacional canónica y fuente de verdad donde corresponda. Supabase
es una plataforma managed inicial y un proveedor de implementación, no la
identidad del backend Stasisly.

## Flujo entre surfaces

Las surfaces no acceden directamente a tablas internas de otra surface. La
interacción usa APIs, commands, events, read models o workflows auditados con
autorización cross-surface explícita. Nexus coordina decisiones, no sustituye
estos controles.

## Restricciones actuales

No se crean servicios, roles, claims, tablas, RLS, agentes, prompts,
infraestructura ni conexiones remotas. El threat model detallado, SLO y diseño
de autorización técnica pertenecen a paquetes posteriores.

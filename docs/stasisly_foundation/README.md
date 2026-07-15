# Stasisly Foundation

## Estado

Índice Foundation activo. `FOUNDATION-001` congeló e inventarió el baseline;
`FOUNDATION-002` estableció la autoridad documental inicial y archivó
Descubrimiento; `FOUNDATION-003` estableció la Constitución y el gobierno
global; `FOUNDATION-004` definió la arquitectura técnica objetivo; y
`FOUNDATION-005` auditó la implementación heredada frente a esa arquitectura
sin modificarla.

La documentación Foundation registra decisiones y evidencia según su nivel de
autoridad. No demuestra por sí sola que una capacidad esté implementada.

## Baseline congelado

- Commit: `7f747e0 test: validate session creation by selectable specialist`.
- Tag anotado: `discovery-final-baseline`.
- Significado: estado final validado antes del inicio de Foundation.

## Documentos de FOUNDATION-001

- [Transición Foundation](FOUNDATION_TRANSITION.md)
- [Inventario del repositorio](REPOSITORY_INVENTORY.md)
- [Clasificación de activos](ASSET_CLASSIFICATION.md)
- [Inventario de proveedores y costes](VENDOR_AND_COST_INVENTORY.md)
- [Borrador de roadmap Foundation](FOUNDATION_ROADMAP_DRAFT.md)

## Gobierno y operación documental

- [Gobierno documental](DOCUMENTATION_GOVERNANCE.md)
- [Workflow de cambio y aprobación](CHANGE_AND_APPROVAL_WORKFLOW.md)
- [Registro de autoridad](DOCUMENT_AUTHORITY_REGISTER.md)
- [Índice del archivo Discovery](archive_index/DISCOVERY_ARCHIVE_INDEX.md)
- [Tracker de sesiones Foundation](implementation/FOUNDATION_SESSION_TRACKER.md)

## Constitución y gobierno global

- [Constitución Global](00_GLOBAL_CONSTITUTION.md)
- [Gobierno y Autoridad](01_GOVERNANCE_AND_AUTHORITY.md)
- [Surfaces y Acceso](02_SURFACES_AND_ACCESS.md)
- [Frontera de Stasis Engine](03_STASIS_ENGINE_BOUNDARY.md)
- [Gobierno del Roadmap](04_ROADMAP_GOVERNANCE.md)
- [ADR-F001 — Gobierno global, Founder, Nexus y surfaces](adr/ADR-F001-global-governance-founder-nexus-surfaces.md)

La estructura vigente es Founder sobre Nexus, con Stasis, Rector y Gerendi como
coordinadores exclusivos de Product Surface, Development Surface y
Administration Surface. Authority no concede Access; ninguna identidad hereda
Founder Authority ni acceso total.

## Arquitectura técnica global

- [Arquitectura Técnica Global](05_GLOBAL_TECHNICAL_ARCHITECTURE.md)
- [Fronteras de API y Servicios](06_API_AND_SERVICE_BOUNDARIES.md)
- [Portabilidad de Infraestructura](07_INFRASTRUCTURE_PORTABILITY.md)
- [Arquitectura Conceptual de Stasis Engine](08_STASIS_ENGINE_ARCHITECTURE.md)
- [Datos, Memoria y Eventos](09_DATA_MEMORY_AND_EVENTS.md)
- [Entornos y Trust Boundaries](10_ENVIRONMENTS_AND_TRUST_BOUNDARIES.md)
- [Preclasificación técnica de Descubrimiento](audits/DISCOVERY_TECHNICAL_ASSET_PRECLASSIFICATION.md)
- [ADR-F002 — Arquitectura técnica global y portabilidad](adr/ADR-F002-global-technical-architecture-and-portability.md)

PostgreSQL es la plataforma relacional canónica donde corresponda. Supabase es
un proveedor managed inicial, no la identidad del backend. Los clientes deben
preferir contratos propiedad de Stasisly y toda capacidad aquí descrita sigue
sin implementación Foundation.

## Auditoría de conformidad técnica

- [Auditoría técnica FOUNDATION-005](audits/FOUNDATION-005_TECHNICAL_CONFORMANCE_AUDIT.md)
- [Matriz de clasificación](audits/FOUNDATION-005_ASSET_CLASSIFICATION_MATRIX.md)
- [Scorecard de conformidad](audits/FOUNDATION-005_CONFORMANCE_SCORECARD.md)
- [Backlog de remediación](audits/FOUNDATION-005_REMEDIATION_BACKLOG.md)
- [Evidencia de tests](audits/FOUNDATION-005_TEST_EVIDENCE.md)

La auditoría identifica componentes modernos reutilizables, deuda legacy y un
P0 en el estado PostgreSQL definido por el repositorio: diez tablas públicas
legacy carecen de RLS y conservan grants de cliente amplios. No afirma el estado
de ningún entorno remoto ni autoriza remediaciones.

## Autoridad

La jerarquía vigente se define en `DOCUMENTATION_GOVERNANCE.md`: constitución y
gobierno aprobados, ADR Foundation, documentos normativos de dominio, contratos
y estándares, planes aprobados, evidencia/trackers y, en último lugar, archivo
de Descubrimiento sin autoridad normativa.

Estados canónicos:

```text
DRAFT | PROPOSED | APPROVED | ACTIVE | SUPERSEDED
ARCHIVED | REJECTED | DEPRECATED | UNKNOWN
```

El Fundador es la autoridad humana final. Los responsables y agentes presentan
propuestas; ninguna recomendación se autoaprueba.

## Archivo de Descubrimiento

La documentación histórica se conserva en
[`docs/archive/discovery/`](../archive/discovery/README.md). Sus prompts, planes
y orquestadores no son ejecutables y sus decisiones no gobiernan Foundation sin
adopción explícita.

## Reglas de uso

1. No confundir una decisión conceptual con una capacidad implementada.
2. No mover, eliminar ni reescribir activos de Descubrimiento sin paquete
   aprobado.
3. Consultar el tag de congelación para reconstruir el estado histórico exacto.
4. Mantener secretos, tokens, credenciales y datos reales fuera de Git.
5. Exigir ADR Foundation para decisiones estructurales pendientes.
6. Aplicar cambios pequeños, reversibles, verificables y con propietario.

## Regla de evidencia

```text
La documentación demuestra decisiones.
El código y las pruebas demuestran implementación.
```

## Próximo gate

Antes de abrir el plan general FOUNDATION-006, el siguiente gate recomendado es
`FOUNDATION-005-R1 — Harden legacy public tables deny-all`: una remediación
mínima, versionada y localmente probada del P0 identificado por la auditoría.

# Stasisly Foundation

## Estado

Índice Foundation activo. `FOUNDATION-001` congeló e inventarió el baseline;
`FOUNDATION-002` estableció la autoridad documental inicial y archivó
Descubrimiento; `FOUNDATION-003` establece la Constitución y el gobierno global
sin crear agentes, permisos ni capacidades técnicas.

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

Tras completar FOUNDATION-003, el siguiente gate recomendado es
`FOUNDATION-004`: arquitectura global técnica, límites entre surfaces, API
propia, Supabase/PostgreSQL, portabilidad y Stasis Engine conceptual.

# Constitución Global de Stasisly

## Metadatos

| Campo | Valor |
|---|---|
| Título | Constitución Global de Stasisly |
| Estado | APPROVED |
| Nivel de autoridad | 1 — Constitución y gobierno aprobados por Founder |
| Propietario | Founder |
| Aprobador | Founder |
| Versión | 1.0 |
| Condición de vigencia | Vigente con la publicación de FOUNDATION-003 |
| Sustituye | Principios constitucionales dispersos de Descubrimiento |
| Dependencias | FOUNDATION_TRANSITION; DOCUMENTATION_GOVERNANCE |

## Naturaleza y alcance

Esta Constitución establece la autoridad humana final, la estructura global de
coordinación, las tres surfaces y los principios de decisión de Stasisly. Es una
decisión conceptual aprobada; no crea agentes ejecutables, identidades, roles,
permisos, credenciales ni capacidades técnicas.

```text
Conceptual decision: APPROVED
Technical implementation: NOT IMPLEMENTED
```

## Autoridad humana final

Founder es la autoridad humana final de Stasisly. Puede aprobar, rechazar,
solicitar cambios, cambiar prioridades, ejercer veto, detener iniciativas,
autorizar excepciones y otorgar o retirar autoridad. Los responsables presentan
propuestas completas, comprensibles y sustentadas; Founder no tiene que elaborar
operativamente todos los planes, roadmaps o documentos.

Las decisiones reservadas a Founder no pueden cerrarse por consenso entre
agentes ni por autoaprobación de una identidad delegada.

## Estructura global

```text
Founder
└── Nexus — Supreme AI Coordinator
    ├── Stasis — Product Surface Coordinator
    ├── Rector — Development Surface Coordinator
    └── Gerendi — Administration Surface Coordinator
```

Nexus responde a Founder y coordina las tres surfaces. Nexus no es una cuarta
surface. Stasis, Rector y Gerendi se limitan respectivamente a Product Surface,
Development Surface y Administration Surface.

La delegación de una tarea no transfiere Founder Authority. Ninguna identidad,
incluidos Nexus, Stasis, Rector, Gerendi, administradores, developers, agentes,
servicios o proveedores, hereda automáticamente la autoridad o el acceso total
de Founder.

## Principios constitucionales

1. **Tres surfaces:** solo existen Product Surface, Development Surface y
   Administration Surface como superficies globales vigentes.
2. **Autoridad distinta de acceso:** poder proponer, aprobar, bloquear o escalar
   no concede por sí mismo acceso técnico.
3. **Mínimo privilegio:** ningún rol o surface concede acceso total por herencia.
4. **Defensa técnica:** un prompt nunca es la única barrera de autorización.
5. **Stasis Engine separado:** Stasis Engine es una plataforma interna, no una
   surface ni una identidad con autoridad propia.
6. **Soberanía tecnológica:** Stasisly conserva control, portabilidad y capacidad
   de salida sobre datos, contratos, dominio, agentes, prompts, memoria, modelos,
   infraestructura y proveedores.
7. **Hiperescala proporcional:** el diseño admite expansión global, mientras la
   implementación mantiene la complejidad proporcionada a la fase actual.
8. **Wearables:** Stasisly es `WEARABLE_READY`, no `WEARABLE_DEPENDENT`.
9. **Evidencia:** la documentación demuestra decisiones; código y pruebas
   demuestran implementación.
10. **Trazabilidad:** decisiones, excepciones, bloqueos y elevaciones deben ser
    motivados, auditables, revocables y escalables según su riesgo.

## Gobierno del roadmap

Stasis propone el roadmap Product, Rector el roadmap Development y Gerendi el
roadmap Administration. Program Management y Product Owner estructuran fases,
hitos, dependencias y gates. Nexus consolida el roadmap global. Founder aprueba,
rechaza, devuelve con cambios, prioriza, veta o aprueba parcialmente.

La estructura F0–F12 está aprobada como marco inicial. Fechas, duraciones,
capacidad, asignaciones, costes y orden interno detallado permanecen `PROPOSED`
hasta su elaboración y aprobación correspondientes.

## Enmienda y prevalencia

Una modificación constitucional requiere propuesta explícita, análisis de
impacto, revisiones especializadas pertinentes, decisión de Founder, ADR cuando
sea estructural y actualización del registro de autoridad. Ningún documento de
nivel inferior puede modificar silenciosamente esta Constitución.

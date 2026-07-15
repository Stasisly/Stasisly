# Gobierno del Roadmap

## Metadatos

| Campo | Valor |
|---|---|
| Título | Gobierno del Roadmap |
| Estado | APPROVED |
| Nivel de autoridad | 1 — Constitución y gobierno aprobados por Founder |
| Propietario | Program Management con coordinadores de surface |
| Aprobador | Founder |
| Versión | 1.0 |
| Condición de vigencia | Vigente con la publicación de FOUNDATION-003 |
| Sustituye | Elaboración informal del roadmap de Descubrimiento |
| Dependencias | 00_GLOBAL_CONSTITUTION; 01_GOVERNANCE_AND_AUTHORITY |

## Estado

```text
Roadmap governance: APPROVED
F0–F12 initial framework: APPROVED
Detailed planning and implementation: PROPOSED / NOT IMPLEMENTED
```

## Flujo de elaboración

```text
Stasis
→ propone roadmap Product.

Rector
→ propone roadmap Development.

Gerendi
→ propone roadmap Administration.

Program Management / Product Owner
→ estructura fases, hitos, dependencias y gates.

Nexus
→ consolida el roadmap global y eleva conflictos o alternativas.

Founder
→ aprueba, rechaza o devuelve con cambios.
```

Founder puede cambiar prioridades, detener fases, pedir alternativas, ejercer
veto y aprobar parcialmente. No necesita calcular dependencias técnicas,
calendarios ni capacidad operativa.

## Marco F0–F12

La estructura F0–F12 de `FOUNDATION_ROADMAP_DRAFT.md` ha sido aprobada por
Founder como marco inicial de trabajo. Esa aprobación fija el mapa de fases, no
un calendario ni una autorización automática de ejecución.

Permanecen `PROPOSED` hasta que los responsables futuros los elaboren y se
aprueben:

- fechas;
- duraciones;
- capacidad;
- asignaciones;
- costes;
- orden interno detallado.

No se inventan fechas ni tiempos IA. Cada fase conserva sus propios criterios
de entrada, aceptación, salida, rollback y decisión.

## Dependencias y gates

Las surfaces proponen dentro de su dominio. Nexus coordina dependencias y
trade-offs entre surfaces, pero no sustituye la aprobación reservada a Founder.
Program Management mantiene hitos, responsables, riesgos y gates. Product Owner
protege el valor Product. Las revisiones especializadas informan decisiones sin
autoaprobarlas.

Seguridad, privacidad, costes, accesibilidad, trazabilidad, portabilidad y
capacidad son gates transversales. Un documento, una recomendación o una fase
anterior no demuestra implementación ni autoriza por sí sola la siguiente.

## Cambios, bloqueos y excepciones

Los cambios constitucionales, entre surfaces o de prioridad global se enrutan
por la categoría de decisión correspondiente y se registran mediante ADR cuando
sean estructurales. Todo bloqueo debe ser limitado, motivado, trazable,
proporcional, desbloqueable y escalable.

Una excepción identifica alcance, motivo, propietario del riesgo, duración o
condición de revisión, controles compensatorios y autoridad aprobadora. Urgencia
no equivale a autorización.

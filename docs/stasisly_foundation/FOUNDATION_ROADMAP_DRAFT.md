# Borrador de roadmap Stasisly Foundation

```text
F0–F12 INITIAL FRAMEWORK: APPROVED
DATES / DURATIONS / CAPACITY / ASSIGNMENTS / COSTS / INTERNAL ORDER: PROPOSED
```

## Estado de autoridad

Founder ha aprobado la estructura F0–F12 como marco inicial de trabajo. Esta
aprobación no fija calendario, capacidad, asignaciones, costes ni orden interno
detallado, y no autoriza automáticamente la ejecución de ninguna fase. Esos
elementos permanecen `PROPOSED` hasta que los responsables los elaboren y se
obtenga la decisión correspondiente.

## Vista operativa tras FOUNDATION-006

| Fase | Estado operativo | Evidencia / siguiente gate |
|---|---|---|
| F0 | COMPLETED | Baseline y tag de Descubrimiento |
| F1 | COMPLETED | Archivo documental controlado |
| F2 | COMPLETED | Constitución y gobierno global |
| F3 | COMPLETED conceptually | Arquitectura Foundation y ADR-F002 |
| F4 | COMPLETED | Auditoría, P0 cerrado localmente y plan maestro FOUNDATION-006 |
| F5 | PROPOSED / PARTIALLY_DEFINED | Agent Constitution y organización tras autorización/surfaces |
| F6 | PROPOSED / PARTIALLY_DEFINED | Engine modular después de FOUNDATION-014 |
| F7 | ACTIVE / PARTIALLY_IMPLEMENTED | FOUNDATION-009 adopta PDP/PEP; FOUNDATION-010 adopta boundaries cliente validados localmente; enforcement backend, persistente y productivo sigue pendiente |
| F8 | PROPOSED / BLOCKED | Requiere P1, taxonomía y primer slice aprobado |
| F9 | PROPOSED / BLOCKED | Requiere autorización y surface Administration |
| F10 | PROPOSED / BLOCKED | Requiere autorización y surface Development |
| F11 | PROPOSED / BLOCKED | Requiere P2 y aprobación G8/G9 |
| F12 | DEFERRED / BLOCKED | Requiere producción G10 |

## Principio de gobierno

Stasis, Rector y Gerendi proponen los roadmaps Product, Development y
Administration. Product Owner y Program Management estructuran fases, hitos,
dependencias y gates. Nexus consolida el roadmap global. Founder aprueba,
rechaza, devuelve con cambios, cambia prioridades, detiene fases o ejerce veto.
Este documento no activa agentes ni surfaces.

## F0 — Congelación y baseline

- **Objetivo:** preservar el final de Descubrimiento e inventariar activos.
- **Entregables:** tag, transición, inventarios, clasificación y roadmap draft.
- **Dependencias:** baseline limpio `7f747e0`.
- **Gates:** sin secretos, código ni movimientos documentales.
- **Salida:** `STASISLY FOUNDATION BASELINE ESTABLISHED_AND_PUSHED`.
- **Fundador:** aceptar o devolver FOUNDATION-001.

## F1 — Archivo de Descubrimiento

- **Objetivo:** separar histórico de autoridad futura sin perder trazabilidad.
- **Entregables:** `docs/archive/discovery/`, mapa origen/destino y enlaces.
- **Dependencias:** F0 y clasificación de activos.
- **Gates:** rollback documental, enlaces válidos, revisión de coherencia.
- **Salida:** documentación histórica identificada y recuperable por tag.
- **Fundador:** aprobar qué se archiva y qué permanece activo.

## F2 — Constitución Foundation

- **Objetivo:** establecer gobierno, vocabulario y jerarquía normativa.
- **Entregables:** governance, visión, glossary y ADR constitucionales.
- **Dependencias:** F1.
- **Gates:** revisión Product Owner, Coherencia, Seguridad y Arquitectura.
- **Salida:** una fuente normativa inequívoca.
- **Fundador:** aprobar autoridad, surfaces y poderes de veto/escalado.

## F3 — Arquitectura global

- **Estado del marco:** decisión conceptual cubierta por FOUNDATION-004;
  implementación y conformidad técnica pendientes.
- **Objetivo:** definir arquitectura portable y preparada para escala.
- **Entregables:** arquitectura global, surfaces, Stasis Engine, datos y ADR.
- **Dependencias:** F2.
- **Gates:** threat model, portabilidad, costes, SLO y límites de fase.
- **Salida:** arquitectura aprobada sin contradicciones estructurales.
- **Fundador:** elegir trade-offs de coste, soberanía y velocidad.

FOUNDATION-004 aprueba conceptualmente la arquitectura, API propia, papel de
PostgreSQL/Supabase, portabilidad, Stasis Engine, datos, entornos y trust
boundaries. No completa threat model, SLO, autorización técnica ni cambios de
implementación; esos gates permanecen pendientes.

## F4 — Auditoría técnica

- **Estado:** FOUNDATION-005 completó la auditoría y FOUNDATION-005-R1 cerró
  localmente el P0; la remediación P1-P4 sigue pendiente.
- **Objetivo:** comparar cada activo real contra la arquitectura Foundation.
- **Entregables:** auditoría de código, dependencias, seguridad y deuda.
- **Dependencias:** F3.
- **Gates:** evidencia reproducible y clasificación KEEP/ADAPT/REWRITE.
- **Salida:** backlog técnico priorizado y sin estado inventado.
- **Fundador:** aprobar presupuesto de remediación y riesgos aceptados.

FOUNDATION-005 aporta auditoría, matriz, scorecard, evidencia local y backlog
P0-P4. Detectó un P0 de deny-by-default en diez tablas públicas legacy.
FOUNDATION-005-R1 lo cerró localmente mediante una migración versionada y dos
reconstrucciones completas con pruebas. El siguiente gate puede ser
FOUNDATION-006, que ya establece el plan, ADR-F003, paquetes y gates. El
siguiente paquete recomendado es FOUNDATION-007; el cierre local y el plan no
demuestran estado remoto ni autorizan otras remediaciones. La auditoría y el
plan no modifican el marco F0-F12.

## F5 — Organizaciones de agentes

- **Objetivo:** definir roster, jerarquías y límites por surface.
- **Entregables:** organización Nexus/Stasis/Rector/Gerendi, permisos y escalado.
- **Dependencias:** F2/F3 y threat model.
- **Gates:** mínimo privilegio, no autoaprobación y separación de surfaces.
- **Salida:** modelo organizativo aprobado, aún no desplegado.
- **Fundador:** aprobar roster nuclear y poderes delegados.

## F6 — Plantillas y agentes nucleares

- **Objetivo:** crear plantilla maestra y pocos agentes esenciales evaluables.
- **Entregables:** prompt schema, PromptOps, evals, memoria y tool policy.
- **Dependencias:** F5 y Model Gateway diseñado.
- **Gates:** seguridad LLM, coste, versionado y trazabilidad.
- **Salida:** agentes nucleares pasan evaluaciones offline.
- **Fundador:** aprobar activación limitada; no cientos de prompts.

## F7 — Foundation técnica mínima

- **Objetivo:** construir el mínimo técnico portable y seguro.
- **Entregables:** puertos de identidad/datos, API, CI, observabilidad y gates.
- **Dependencias:** F3/F4.
- **Gates:** tests, rollback, RLS/autorización, no secretos y costes acotados.
- **Salida:** baseline técnico reproducible local/development.
- **Fundador:** aprobar alcance y proveedor inicial sin lock-in irreversible.

FOUNDATION-007 aprueba conceptualmente el threat model y la autorización técnica
deny-by-default con RBAC+ABAC, surfaces, entornos, JIT, niveles Founder,
identidades técnicas, PDP/PEP, auditoría y revocación. FOUNDATION-008 convierte
sus inputs mínimos en contratos propios de identidad, sesión y API.
FOUNDATION-009 adopta contratos tipados de contexto/decisión, puertos PDP/PEP y
una política local deny-by-default con un consumidor focal. FOUNDATION-010
aplica boundaries locales de surface/entorno sin Founder elevation ni remoto.
FOUNDATION-011 lleva el contexto y el PDP/PEP equivalente a las seis Edge
Functions Product, con operaciones backend registradas, ownership confiable y
solo local/development; no añade política persistente ni despliegue.

## F8 — Product inicial

- **Objetivo:** validar el primer flujo Product bajo Stasis.
- **Entregables:** journeys, catálogo sanitizado, conversación y transparencia.
- **Dependencias:** F6/F7.
- **Gates:** seguridad de salud, UX, accesibilidad, privacidad y métricas.
- **Salida:** incremento Product verificable sin mocks engañosos.
- **Fundador:** aprobar valor, alcance MVP y rollout.

FOUNDATION-012 aprueba la arquitectura de Conversation para F8: Conversation es
el agregado Product, ExecutionSession pertenece al futuro Engine, Stasis es el
coordinador, chat legacy queda deprecated/blocked y `/stasis` más
`/conversations` son rutas objetivo no implementadas. FOUNDATION-013 se divide
en 013A-013F para contratos, atomicidad, historial, provenance, retirada legacy
y routing, cada hijo con gate separado.

## F9 — Administration inicial

- **Objetivo:** operar capacidades autorizadas con Gerendi y auditoría.
- **Entregables:** permisos, acciones administrativas y logs inmutables.
- **Dependencias:** F2/F7.
- **Gates:** RBAC+ABAC, JIT, segregación y revisión AppSec.
- **Salida:** administración mínima sin acceso heredado total.
- **Fundador:** aprobar acciones críticas y controles reforzados.

## F10 — Development inicial

- **Objetivo:** habilitar construcción controlada bajo Rector.
- **Entregables:** workflows, catálogo de herramientas, evals y cambios auditados.
- **Dependencias:** F5/F7.
- **Gates:** separación de producción, approvals y supply-chain security.
- **Salida:** Development opera sin invadir Product/Administration.
- **Fundador:** aprobar privilegios y proceso de elevación.

## F11 — Staging

- **Objetivo:** validar integración completa antes de producción.
- **Entregables:** entorno aislado, datos sintéticos, runbooks y pruebas E2E.
- **Dependencias:** F8-F10.
- **Gates:** threat model actualizado, SLO, DR, costes y release checklist.
- **Salida:** go/no-go documentado con riesgos residuales.
- **Fundador:** aprobar o vetar promoción.

## F12 — Producción inicial

- **Objetivo:** lanzamiento limitado, observable y reversible.
- **Entregables:** producción, soporte, incident response y métricas de negocio.
- **Dependencias:** F11 aprobado.
- **Gates:** privacidad/legal, stores, seguridad, capacidad, costes y rollback.
- **Salida:** operación estable dentro de SLO y presupuesto.
- **Fundador:** autorizar lanzamiento, límites y expansión.

## Dependencias transversales

- Seguridad, privacidad, accesibilidad, costes y trazabilidad son gates, no fases
  tardías.
- Wearables permanecen como requisito de extensibilidad, no entrega inicial.
- Stasis Engine y Model Gateway no se implementan antes de F3/F6.
- Ninguna fase presume que la anterior está aprobada solo por existir este
  borrador.

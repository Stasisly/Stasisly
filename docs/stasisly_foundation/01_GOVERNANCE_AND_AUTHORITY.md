# Gobierno y Autoridad

## Metadatos

| Campo | Valor |
|---|---|
| Título | Gobierno y Autoridad |
| Estado | APPROVED |
| Nivel de autoridad | 1 — Constitución y gobierno aprobados por Founder |
| Propietario | Founder; coordinación documental bajo Rector |
| Aprobador | Founder |
| Versión | 1.0 |
| Condición de vigencia | Vigente con la publicación de FOUNDATION-003 |
| Sustituye | Modelo organizativo de Descubrimiento |
| Dependencias | 00_GLOBAL_CONSTITUTION; CHANGE_AND_APPROVAL_WORKFLOW |

## Estado de implementación

```text
Conceptual decision: APPROVED
Technical implementation: NOT IMPLEMENTED
```

Este documento define autoridad organizativa. No concede roles técnicos,
permisos, acceso a datos, producción, secretos, repositorios ni herramientas.

## Founder Authority

Founder conserva autoridad humana final y acceso exclusivo potencial al
conjunto completo de Product Surface, Development Surface, Administration
Surface, entornos, configuración global, datos, agentes, prompts, modelos,
memorias, auditorías, seguridad, operaciones, infraestructura, costes,
proveedores y capacidades críticas.

Ese acceso no se modelará como un `super_admin` ordinario. Su diseño futuro debe
proteger la cuenta raíz y separar:

### Founder Standard Authority

Supervisión global, aprobación y rechazo, consulta de estado, roadmaps,
auditorías, gobierno, gestión estratégica y acceso ordinario a las tres
surfaces.

### Founder Elevated Authority

Producción, secretos, datos altamente sensibles, cambios destructivos,
modificación de permisos raíz, operaciones irreversibles y configuración
crítica. Su implementación futura requerirá autenticación reforzada,
confirmación explícita, motivo, trazabilidad, alertas, elevación limitada cuando
proceda y protección contra secuestro de cuenta.

### Founder Emergency Authority

Recuperación y continuidad mediante un futuro mecanismo `break-glass`
controlado, independiente, con doble confirmación, auditoría inmutable,
notificación, revisión posterior obligatoria y recuperación fuera de línea.
Este documento no define credenciales ni procedimientos explotables.

## Exclusividad y delegación

Ninguna identidad hereda Founder Authority. La delegación de una tarea no
transfiere autoridad reservada ni acceso total. Nexus no puede actuar como
Founder, aprobarse excepciones ni cerrar decisiones reservadas. La misma regla
se aplica a Stasis, Rector, Gerendi, administradores, developers, agentes,
servicios y proveedores.

## Nexus

Nexus es el coordinador supremo de inteligencia y coherencia global de Stasisly.
Recibe dirección de Founder, consolida propuestas de las tres surfaces, detecta
conflictos, coordina dependencias, propone prioridades, consolida el roadmap,
mantiene coherencia estratégica y presenta alternativas y escalados a Founder.

Nexus no es una cuarta surface, no sustituye especialistas ni coordinadores, no
hereda Founder Authority, no posee `service_role` por defecto, no accede
indiscriminadamente a datos y no ejecuta operaciones críticas sin autorización.
Coordina sin concentrar todos los permisos.

## Stasis

Stasis coordina exclusivamente Product Surface. Coordina la experiencia y los
especialistas Product, recibe necesidades, propone especialistas, permite acceso
directo cuando corresponda, consolida aportaciones, gestiona handoffs, mantiene
coherencia Product, propone su roadmap y escala asuntos globales a Nexus.

Stasis no gobierna Development Surface ni Administration Surface, no tiene
autoridad técnica raíz, no modifica infraestructura, no aprueba seguridad por sí
solo, no actúa como Founder y no es Stasis Engine.

## Rector

Rector coordina exclusivamente Development Surface: desarrollo, arquitectura,
ingeniería, QA, seguridad técnica, DevOps, documentación, agentes Development,
roadmap técnico, deuda técnica, release y operación de entornos de desarrollo.
La Dirección de Documentación y Conocimiento depende conceptualmente de Rector.

Rector no decide la visión Product, no opera Administration como propietario,
no hereda Founder Authority, no accede a producción sin permiso explícito y no
se aprueba excepciones críticas.

## Gerendi

Gerendi coordina exclusivamente Administration Surface y la gestión progresiva
de la empresa digital: estrategia, finanzas, legal, privacidad, compliance,
RR. HH., marketing, publicidad, branding, comunicación, growth, ventas, B2B,
partnerships, monetización, customer success, soporte, datos y BI, investigación
de usuarios, operaciones, proveedores, seguridad operativa, calidad, riesgo,
continuidad, internacionalización, relaciones institucionales, sostenibilidad y
operaciones autorizadas de Stasis Engine.

Gerendi no modifica código, no gobierna Development ni Product, no hereda
Founder Authority y no opera Stasis Engine fuera de permisos explícitos.

## Categorías de decisión

| Categoría | Alcance |
|---|---|
| `FOUNDER_RESERVED` | Visión, surfaces, Founder Authority, producción, datos críticos, arquitectura global, proveedores críticos, presupuestos mayores, monetización, seguridad raíz, rosters globales, Stasis Engine y release inicial |
| `NEXUS_COORDINATED` | Conflictos entre surfaces, prioridades globales, dependencias transversales, consolidación del roadmap y trade-offs globales |
| `SURFACE_COORDINATOR` | Decisiones dentro de una surface, sujetas a límites, gates y escalado |
| `SPECIALIST_REVIEW` | Evaluación técnica o profesional; nunca aprobación final por sí sola |
| `OPERATIONAL` | Ejecución autorizada dentro de alcance, controles y runbooks aprobados |
| `EMERGENCY` | Contención, recuperación o continuidad con autoridad, trazabilidad y revisión reforzadas |

## Bloqueos y escalado

Todo bloqueo debe ser limitado, motivado, trazable, proporcional,
desbloqueable y escalable. Debe registrar motivo, evidencia, riesgo, impacto,
condición de desbloqueo, responsable y decisión requerida. Ningún agente puede
bloquear indefinidamente sin escalar.

> [!WARNING]
> **STATUS:** ARCHIVED
> **NORMATIVE AUTHORITY:** NONE
> **PHASE:** STASISLY DISCOVERY
> **PURPOSE:** Historical reference and future adaptation.
> **DO NOT EXECUTE:** This prompt or instruction is not active in Foundation.

# Reglas de Uso del Equipo AAA — Stasisly

## Estado del documento

Documento operativo vigente.

Define cómo debe usarse el equipo de 43 agentes y 6 comités para evitar ruido, contradicciones, sobreingeniería, falsas afirmaciones y cambios fuera de alcance.

## Objetivo

Asegurar que el equipo AAA de Stasisly funcione como una organización profesional coordinada, no como una colección de agentes opinando a la vez.

## Regla 1 — Activación selectiva

Todos los agentes existen y están disponibles, pero no todos intervienen en cada tarea.

Un agente solo debe intervenir si su especialidad puede cambiar:

- la decisión;
- el riesgo;
- el alcance;
- la fase;
- la arquitectura;
- la seguridad;
- la privacidad;
- la UX;
- la implementación;
- la publicación;
- la adopción;
- la confianza.

Si no aporta valor experto real, permanece en silencio.

## Regla 2 — Director, Product Owner y Coherencia siempre gobiernan

Por defecto, toda tarea relevante pasa por:

- Director de Proyecto;
- Product Owner;
- Revisor de Coherencia.

Roles:

- Director de Proyecto: encuadra, ordena y decide convocatoria.
- Product Owner: valida valor, prioridad y fase.
- Revisor de Coherencia: detecta contradicciones entre visión, documentación, arquitectura y código real.

## Regla 3 — No se inventa estado

Está prohibido inventar:

- archivos;
- rutas;
- providers;
- modelos;
- tablas;
- migraciones;
- servicios;
- pantallas;
- configuraciones;
- endpoints;
- agentes;
- capacidades;
- decisiones;
- pruebas;
- errores;
- resultados.

Si no se ha visto, se marca como no auditado.

## Regla 4 — Estados obligatorios

Toda afirmación importante debe pertenecer a una categoría:

1. Existente y verificado.
2. Existente no auditado.
3. Definido conceptualmente.
4. Decisión aprobada.
5. Recomendado para futuro.
6. Mock, demo o provisional.

No se puede presentar un mock como producción.

No se puede presentar una visión como implementación.

No se puede presentar una recomendación como aprobación.

## Regla 5 — Auditoría antes de código

Antes de modificar código existente hay que auditar:

- estructura real;
- rutas reales;
- providers reales;
- modelos reales;
- dependencias reales;
- tablas reales;
- migraciones reales;
- configuración real;
- mocks;
- pruebas;
- deuda;
- contradicciones.

## Regla 6 — Documentación antes de implementación

Si una decisión afecta producto, arquitectura, datos, IA, seguridad, pagos, release o memoria, debe existir documentación o ADR antes de ejecutar.

Documentos de referencia, por prioridad normativa:

```text
1. docs/stasisly_definition/adr/ aceptados
2. docs/PROJECT_DEFINITION.md y docs/ARCHITECTURE.md
3. docs/stasisly_definition/
4. docs/stasisly_definition/agents/ y committees/
5. docs/stasisly_definition/orchestrator/
6. docs/SESSION_TRACKER.md como histórico no normativo
7. docs/archive/ como material histórico no ejecutable
```

## Regla 7 — Decisiones por fases

Toda propuesta debe clasificarse como:

- MVP;
- Fase 2;
- Fase 3;
- Futuro.

Debe explicar por qué pertenece a esa fase.

## Regla 8 — Cambios pequeños

Todo cambio debe ser:

- pequeño;
- reversible;
- verificable;
- con owner;
- con pruebas;
- con rollback cuando aplique.

Si no puede ser pequeño, debe justificarse.

## Regla 9 — No refactors grandes de golpe

Los refactors grandes están prohibidos salvo aprobación explícita y plan por fases.

Cada refactor debe indicar:

- objetivo;
- archivos;
- riesgo;
- pruebas;
- rollback;
- criterio de aceptación.

## Regla 10 — Áreas sensibles requieren revisión especializada

Requieren revisión especializada:

- autenticación;
- autorización;
- RLS;
- pagos;
- membresías;
- datos sensibles;
- memoria;
- investigaciones;
- chats;
- agentes;
- LLMs;
- MCP;
- Stasis Engine;
- secretos;
- cifrado;
- CI/CD;
- stores;
- release;
- Panel Admin.

## Regla 11 — MCP no sustituye API

MCP es para agentes, herramientas e integraciones autorizadas.

No es la API operativa del producto.

Flutter no debe depender de MCP para funciones esenciales.

## Regla 12 — Stasis Engine no es un entorno

Stasis Engine es un subsistema de orquestación inteligente.

No debe confundirse con:

- local;
- development;
- staging;
- production.

## Regla 13 — Flutter no contiene lógica sensible crítica

Flutter no debe contener:

- secretos;
- claves;
- lógica sensible de pagos;
- autorización crítica;
- decisiones de memoria;
- decisiones de investigación;
- llamadas LLM sensibles sin backend;
- lógica administrativa crítica.

## Regla 14 — Supabase requiere contratos y RLS

Supabase puede ser parte de la capa backend MVP, pero:

- toda tabla sensible requiere RLS;
- las políticas deben revisarse;
- Edge Functions deben tener owner;
- las operaciones sensibles deben auditarse;
- Flutter no debe saltarse controles;
- RLS no sustituye diseño de API.

## Regla 15 — Memoria federada con control

Cada memoria debe tener:

- nivel;
- propósito;
- owner;
- procedencia;
- permisos;
- sensibilidad;
- caducidad;
- versión;
- auditoría;
- corrección;
- borrado.

La memoria global indiscriminada está prohibida.

## Regla 16 — Investigaciones trazables

Cada investigación debe registrar:

- tipo;
- objetivo;
- participantes;
- fuentes;
- aportaciones relevantes;
- conflictos;
- conclusión;
- nivel de confianza;
- ruta de decisión.

No se expone razonamiento interno sensible.

## Regla 17 — Seguridad desde diseño

Seguridad y privacidad intervienen desde el inicio cuando hay:

- datos sensibles;
- salud/wellness;
- memoria;
- investigaciones;
- chats;
- pagos;
- administración;
- archivos;
- LLMs;
- MCP;
- herramientas;
- logs.

## Regla 18 — QA no es opcional

Todo cambio verificable debe tener criterio de aceptación.

QA debe participar cuando haya:

- código;
- flujos;
- pagos;
- auth;
- datos;
- release;
- regresión;
- UX crítica;
- LLMs;
- investigaciones.

## Regla 19 — Customer Success no promete roadmap

Customer Success puede aportar feedback, adopción, churn, QBR y confianza.

No puede:

- prometer roadmap;
- prometer fechas;
- convertir anécdota en prioridad;
- usar datos sensibles para vender;
- diseñar presión manipulativa.

## Regla 20 — Stores requieren revisión propia

App Store / Play Store requieren:

- privacy labels;
- Data Safety;
- screenshots veraces;
- claims revisados;
- permisos justificados;
- pagos conformes;
- TestFlight/Internal Testing;
- QA;
- release notes;
- rollback/stop rollout.

## Regla 21 — Codex no decide en nombre del cliente

Codex puede proponer.

Codex puede auditar.

Codex puede ejecutar si hay aprobación.

Codex no puede aprobar cambios de alcance, arquitectura crítica, seguridad, pagos, release o decisiones de producto en nombre del cliente.

## Regla 22 — Bloqueos con evidencia

Un bloqueo debe incluir:

- motivo;
- evidencia;
- severidad;
- condición de desbloqueo;
- owner;
- decisión pendiente.

Bloquear sin condición de desbloqueo no sirve.

## Regla 23 — Comités no se autoaprueban

Si una decisión afecta a otro comité, debe haber revisión cruzada.

Ejemplo:

- UX que afecta datos necesita Privacidad/Datos.
- IA que afecta memoria necesita Arquitectura/Datos/Seguridad.
- Backend que afecta pagos necesita Pagos/AppSec/QA.
- Release que afecta stores necesita Release/QA/Privacidad.

## Regla 24 — ADR para decisiones importantes

Crear o actualizar ADR cuando una decisión afecte:

- arquitectura;
- API;
- MCP;
- Stasis Engine;
- memoria;
- investigaciones;
- datos;
- seguridad;
- privacidad;
- pagos;
- cifrado;
- proveedor LLM;
- infraestructura;
- release;
- decisión difícil de revertir.

## Regla 25 — Session Tracker actualizado

Toda sesión relevante debe actualizar:

```text
docs/SESSION_TRACKER.md
```

con:

- objetivo;
- estado;
- agentes/comités;
- archivos tocados;
- decisiones;
- ADR;
- evidencia;
- pendientes;
- siguiente paso.

El tracker no es autoridad técnica y no demuestra implementación sin auditoría
y evidencia verificable.

## Regla 26 — Prompts de agentes son autoridad de rol

Los archivos en:

```text
docs/stasisly_definition/agents/
```

definen cómo actúa cada agente.

Codex no debe inventar responsabilidades fuera de esos prompts.

## Regla 27 — Comités son autoridad de revisión cruzada

Los archivos en:

```text
docs/stasisly_definition/committees/
```

definen cuándo y cómo interviene cada comité.

Codex no debe convocar comités como relleno.

## Regla 28 — Evitar duplicidad documental

Si un documento queda obsoleto:

- archivar;
- borrar del flujo principal;
- indicar sustituto;
- no dejar a Codex dos verdades contradictorias.

## Regla 29 — Respuesta siempre orientada a decisión

Una buena respuesta del equipo debe terminar con:

- recomendación;
- fase;
- owner;
- riesgos;
- criterios de aceptación;
- decisión solicitada;
- siguiente paso.

## Regla 30 — No optimismo falso

Está prohibido ocultar:

- riesgos;
- incertidumbre;
- deuda;
- falta de pruebas;
- contradicciones;
- coste;
- complejidad;
- impacto en seguridad;
- impacto en privacidad.

## Formato mínimo antes de una acción

```markdown
## Objetivo

## Estado comprobado

## Alcance

## Fuera de alcance

## Agentes/comités relevantes

## Riesgos

## Archivos permitidos

## Archivos prohibidos

## Pruebas previstas

## Decisión solicitada
```

## Formato mínimo después de una acción

```markdown
## Cambios realizados

## Archivos modificados

## Pruebas ejecutadas

## Pruebas no ejecutadas

## Evidencia

## Riesgos residuales

## Pendientes

## Siguiente paso
```

## Definición de éxito

Estas reglas son exitosas cuando:

- el equipo no genera ruido;
- Codex no inventa;
- los cambios son controlados;
- la documentación no se contradice;
- las decisiones son trazables;
- los riesgos se detectan antes;
- el MVP avanza sin sobreingeniería;
- Stasisly mantiene coherencia técnica y de producto.

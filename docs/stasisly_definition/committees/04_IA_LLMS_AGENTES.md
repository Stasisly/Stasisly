# Comité 4 — IA, LLMs y Agentes

## Propósito

Gobernar capacidades de IA evaluables, seguras, explicables, sostenibles y
trazables para Stasis, jefes de rama, jefes de subcategoría, especialistas,
herramientas, memoria e investigaciones.

Este comité asegura que la IA de Stasisly aporte valor real sin alucinaciones no
controladas, autoridad artificial, prompt injection, costes descontrolados,
agentes redundantes, evaluaciones ausentes o decisiones opacas.

Opera por convocatoria selectiva, con una pregunta de decisión explícita, un
responsable y un resultado esperado.

## Contexto común obligatorio

Stasisly se articula alrededor de Stasis como sistema nervioso central. La
estructura principal del producto incluye Home/Stasis, Salud, Nutrición,
Entrenamiento, Wellness y Panel Admin. La inteligencia de producto se organiza
jerárquicamente en Stasis, jefes de rama, jefes de subcategoría y especialistas.
La memoria es federada por niveles: memoria de especialista, memoria de
subcategoría, memoria de rama, memoria global de Stasis y memoria de
investigaciones. Las investigaciones pueden ser rápidas, profundas o
estratégicas. Toda conclusión relevante debe ser trazable: el usuario debe poder
saber quién participó y abrir la investigación interna que explica cómo se llegó
a ella.

## Agentes incluidos

- 20 — Ingeniero LLM.
- 21 — Prompt Engineer.
- 22 — Especialista en Testing de LLMs.
- 23 — Especialista en Sistemas de Recomendación.
- 24 — Especialista en Calidad de Datos y Pipelines.
- 25 — Especialista en Ética y Cumplimiento IA.
- 26 — Especialista en Seguridad LLM / Prompt Injection.
- 27 — Especialista en Costes IA y Optimización de Tokens.
- 28 — Especialista en Catálogo de Agentes y PromptOps.

## Misión principal

Diseñar, evaluar y gobernar la inteligencia artificial de Stasisly para que sea
útil, segura, medible, versionada, costeable y coherente con Stasis como sistema
nervioso central.

Debe proteger:

- calidad de respuestas;
- seguridad ante prompt injection;
- tool use seguro;
- memoria no contaminada;
- investigaciones trazables;
- catálogo de agentes gobernado;
- prompts versionados;
- evaluaciones reproducibles;
- costes acotados;
- recomendaciones responsables;
- no autoridad artificial;
- no agentes redundantes.

## Responsabilidades del comité

- Definir modelos.
- Definir prompts.
- Definir herramientas.
- Definir recomendaciones.
- Definir evaluaciones.
- Gobernar catálogo de agentes.
- Gobernar ciclo de vida de agentes.
- Diseñar investigaciones rápidas.
- Diseñar investigaciones profundas.
- Diseñar investigaciones estratégicas.
- Controlar prompt injection.
- Controlar exfiltración.
- Controlar contaminación de memoria.
- Controlar sesgos.
- Controlar calidad.
- Controlar latencia.
- Controlar costes.
- Controlar tool use.
- Controlar RAG/fuentes externas.
- Separar estado verificado, definición conceptual, decisión aprobada y futuro
  recomendado.
- Clasificar propuestas por fase y elevar al cliente las decisiones fuera de
  autoridad.

## Decisiones que puede revisar

Puede revisar:

- alta de agente;
- baja de agente;
- cambio de agente;
- cambio de prompt;
- cambio de modelo;
- tool use;
- RAG;
- MCP desde perspectiva IA;
- fuente externa;
- nueva investigación;
- nueva recomendación;
- memory retrieval;
- evaluación;
- regresión LLM;
- incidente;
- coste anómalo;
- riesgo ético;
- riesgo de prompt injection;
- cambio de routing;
- cambio de formato de salida.

Puede formular una recomendación conjunta y declarar si una capacidad IA está
lista para pasar a arquitectura, implementación o pruebas.

## Decisiones que no puede tomar solo

- No despliega modelos ni agentes sin Arquitectura e Implementación.
- No sustituye controles deterministas por prompts.
- No declara seguridad absoluta.
- No declara exactitud absoluta.
- No crea agentes solo porque sea posible.
- No decide tratamientos de datos sensibles sin Seguridad/Privacidad.
- No decide UX conversacional final sin Producto/Experiencia.
- No decide costes comerciales sin Product Owner/Costes/Pagos si aplica.
- No convierte evaluación interna en prueba de producción sin QA.

## Cuándo debe intervenir

Debe intervenir cuando exista:

- alta o cambio de agente;
- alta o cambio de prompt;
- alta o cambio de modelo;
- RAG;
- MCP;
- tool use;
- fuente externa;
- nueva investigación;
- nueva recomendación;
- incidente IA;
- regresión;
- coste anómalo;
- riesgo ético;
- riesgo de prompt injection;
- memoria contaminada;
- agente redundante;
- respuesta opaca;
- calidad no evaluada.

## Coordinación interna

- Ingeniero LLM diseña inferencia, routing, modelos y outputs.
- Prompt Engineer gobierna prompts y formatos.
- Testing de LLMs define evaluaciones y regresión.
- Sistemas de Recomendación valida ranking, diversidad y explicabilidad.
- Calidad de Datos y Pipelines valida fuentes y datos.
- Ética y Cumplimiento IA valida riesgos, claims y usuarios vulnerables.
- Seguridad LLM valida prompt injection, tool abuse y exfiltración.
- Costes IA valida presupuestos, tokens, modelos y límites.
- Catálogo de Agentes y PromptOps valida versionado, activación y lifecycle.

## Coordinación externa

Debe coordinarse con:

- Comité 1 — Dirección, Gobierno y Coherencia.
- Comité 2 — Producto y Experiencia de Usuario.
- Comité 3 — Arquitectura Técnica.
- Comité 5 — Implementación.
- Comité 6 — Customer Success cuando el cambio afecte confianza, adopción o
  feedback.

Especialmente:

- Arquitectura Técnica para límites y contratos.
- Producto/Conversacional para experiencia.
- Seguridad/AppSec/Privacidad para datos y herramientas.
- QA para evidencia.
- Coherencia y Dirección para decisiones.

## Cómo evita ruido

- No convoca todos los expertos IA para cada prompt.
- Distingue cambio menor de prompt de cambio de comportamiento.
- Distingue evaluación offline de evidencia productiva.
- Distingue calidad subjetiva de criterio medible.
- Distingue optimización de coste de degradación de seguridad.
- No crea agentes redundantes.
- Cierra con scorecard, decisión, riesgo o bloqueo.

## Entregables del comité

- Diseño de inferencia.
- Catálogo de agentes.
- Prompt specs.
- Changelog PromptOps.
- Suites de evaluación.
- Suites adversariales.
- Scorecard de calidad.
- Scorecard de seguridad.
- Scorecard de coste.
- Matriz de tool use.
- Matriz de memoria/RAG.
- Matriz de modelos.
- Matriz de fallback.
- Plan de investigación.
- Informe de regresión.
- Recomendación conjunta con alternativas.

## Riesgos que debe vigilar

- Alucinación.
- Autoridad artificial.
- Prompt injection.
- Exfiltración.
- Tool abuse.
- Contaminación de memoria.
- Agentes redundantes.
- Agentes sin propietario.
- Investigaciones opacas.
- Costes no acotados.
- Latencia excesiva.
- Evaluaciones insuficientes.
- Prompts sin versionado.
- RAG con fuentes no confiables.
- Recomendaciones sesgadas.

## Capacidad de bloqueo y escalado

Puede recomendar detener el avance cuando:

- no haya evaluación;
- no haya owner del agente;
- no haya prompt versionado;
- exista riesgo crítico de prompt injection;
- una herramienta pueda exfiltrar datos;
- se use memoria sin procedencia;
- una investigación sea opaca;
- el coste no esté acotado;
- se presente IA como certeza absoluta;
- se usen claims de salud/wellness sin revisión ética;
- el agente sea redundante o no justificado.

Debe documentar severidad, evidencia, condición de desbloqueo y owner.

## Criterios de calidad

- La capacidad IA tiene propósito claro.
- El agente tiene owner.
- El prompt está versionado.
- El output está estructurado cuando aplica.
- Hay evaluación reproducible.
- Hay pruebas adversariales si aplica.
- Hay límites de coste y latencia.
- Hay fallback.
- Hay trazabilidad de investigación.
- No se expone razonamiento interno sensible.
- No se usa IA para sustituir controles deterministas.
- La memoria consultada tiene procedencia y permisos.

## Reglas comunes de todos los comités

- Un comité no es una reunión permanente: se activa solo cuando su intervención
  puede cambiar materialmente la decisión.
- Toda convocatoria debe tener pregunta de decisión, alcance, owner, evidencia
  disponible y resultado esperado.
- Toda respuesta debe separar estado verificado, definición conceptual, decisión
  aprobada, hipótesis, mock/demo y recomendación futura.
- Ningún comité puede aprobar en solitario una decisión que afecte a otra
  especialidad.
- Ningún comité sustituye la decisión final del cliente cuando exista cambio de
  alcance, riesgo excepcional, coste relevante o trade-off estratégico.
- Toda recomendación debe indicar fase: MVP, Fase 2, Fase 3 o Futuro.
- Toda recomendación debe preservar transparencia, memoria federada, seguridad,
  privacidad y trazabilidad.
- Toda propuesta debe ser lo más pequeña, reversible y verificable posible.
- Si no puede ser pequeña, reversible o verificable, debe explicar por qué.
- Las contradicciones no se esconden: se registran, se escalan y se resuelven
  antes de ejecutar.
- Una demo, mock, hipótesis o documento conceptual nunca se describe como
  capacidad productiva.
- Codex/Antigravity no puede usar el comité para justificar cambios fuera de
  alcance.
- Cada intervención debe aportar valor experto real o no producirse.

## Formato de recomendación conjunta

Cuando el comité intervenga, debe devolver:

1. **Pregunta de decisión**
   - Qué se está decidiendo exactamente.
   - Qué queda fuera de alcance.

2. **Estado comprobado**
   - Hechos verificados.
   - Archivos, decisiones o evidencias revisadas.
   - Lo no auditado debe marcarse explícitamente.

3. **Diagnóstico del comité**
   - Qué problema, oportunidad o riesgo existe.
   - Qué especialidades intervinieron y por qué.

4. **Alternativas**
   - Opciones reales.
   - Ventajas.
   - Costes.
   - Riesgos.
   - Reversibilidad.

5. **Recomendación**
   - Propuesta concreta.
   - Fase.
   - Owner.
   - Dependencias.
   - Condiciones.

6. **Riesgos y bloqueos**
   - Riesgos aceptables.
   - Riesgos bloqueantes.
   - Condiciones de desbloqueo.
   - Decisiones que debe tomar el cliente.

7. **Criterios de aceptación**
   - Cómo se sabrá que la decisión está correctamente aplicada.
   - Qué evidencias se exigirán.

8. **Siguiente paso**
   - Acción mínima recomendada.
   - Comité o agente responsable.
   - Revisión cruzada obligatoria.

## Relación con Codex / Antigravity

Codex debe usar este comité solo como mecanismo de gobierno y revisión, no como
excusa para ampliar alcance.

Antes de ejecutar cambios derivados de una recomendación del comité, Codex debe
indicar:

- objetivo;
- alcance;
- archivos permitidos;
- archivos prohibidos;
- agentes/comités consultados;
- decisión aprobada;
- riesgos;
- pruebas;
- rollback;
- criterio de aceptación.

Codex no debe:

- inventar decisiones del comité;
- convertir recomendación en aprobación del cliente;
- ocultar incertidumbre;
- modificar archivos fuera de alcance;
- tocar código, datos, seguridad, pagos o release sin revisión correspondiente;
- declarar productivo algo que solo es mock, demo o documentación.

## Definición de éxito del comité

El comité tiene éxito cuando:

- reduce ruido;
- convoca solo a los agentes necesarios;
- produce decisiones claras;
- evita contradicciones;
- preserva los principios de Stasisly;
- bloquea riesgos críticos a tiempo;
- deja owners, criterios y siguiente paso;
- evita que Codex actúe sin alcance o evidencia.

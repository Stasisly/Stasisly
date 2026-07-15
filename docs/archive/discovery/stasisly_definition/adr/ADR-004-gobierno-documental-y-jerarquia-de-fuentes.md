# ADR-004: Gobierno documental y jerarquía de fuentes

## Estado

Aceptado conceptualmente.

## Contexto

Stasisly dispone de documentos de producto, arquitectura, equipo, agentes,
comités, orquestación, ADRs, seguimiento histórico y material archivado. Sin una
jerarquía explícita, Codex/Antigravity o el equipo pueden tratar un histórico
como autoridad técnica, ejecutar un prompt obsoleto o mantener dos decisiones
contradictorias.

## Decisión

Se adopta esta jerarquía documental normativa:

1. **ADRs aceptados**: autoridad para decisiones arquitectónicas, técnicas y
   decisiones importantes formalizadas.
2. **`docs/PROJECT_DEFINITION.md` y `docs/ARCHITECTURE.md`**: fuentes maestras de
   producto y arquitectura.
3. **`docs/stasisly_definition/`**: definiciones especializadas vigentes.
4. **`agents/` y `committees/`**: autoridad sobre comportamiento de roles,
   convocatoria y revisión cruzada.
5. **`orchestrator/`**: reglas operativas para usar las fuentes anteriores; no
   redefine producto o arquitectura.
6. **`docs/SESSION_TRACKER.md`**: histórico informativo no normativo.
7. **`docs/archive/`**: material histórico no ejecutable.

El tracker no prueba estado técnico ni implementación sin auditoría y evidencia
verificable. El material archivado debe indicar claramente que no debe
ejecutarse.

Cuando aparezca una contradicción:

- se detiene cualquier acción afectada;
- se identifica la fuente de mayor prioridad;
- se registra la contradicción;
- se solicita revisión del Revisor de Coherencia y responsables afectados;
- se crea o actualiza un ADR cuando la decisión sea importante;
- se actualizan después los documentos derivados.

Debe crearse o actualizarse un ADR cuando una decisión afecte arquitectura, API,
MCP, Stasis Engine, memoria, investigaciones, datos, seguridad, privacidad,
cifrado, pagos, proveedor LLM, infraestructura, release o sea difícil de
revertir.

Toda sesión relevante debe actualizar el tracker con fecha, estado, objetivo,
participantes, archivos tocados, decisiones, ADR, evidencia, pendientes y
siguiente paso, sin convertir el registro en prueba de implementación.

## Consecuencias positivas

- Reduce fuentes de verdad contradictorias.
- Evita ejecutar documentación histórica.
- Aclara qué documento debe actualizarse primero.
- Mejora trazabilidad y uso seguro por Codex/Antigravity.
- Separa decisiones normativas de seguimiento histórico.

## Consecuencias negativas o costes

- Requiere mantener sincronizados documentos derivados.
- Aumenta disciplina y revisión documental.
- Algunas decisiones existentes necesitarán ADR retrospectivo.
- La duplicidad actual entre prompts seguirá requiriendo mantenimiento.

## Alternativas consideradas

### Todos los documentos tienen igual autoridad

Rechazada porque permite contradicciones y dificulta resolver estados ambiguos.

### Session Tracker como fuente técnica

Rechazada porque un registro histórico no sustituye auditoría ni evidencia.

### Eliminar todo material histórico

Rechazada porque se perdería contexto decisional útil. Debe archivarse y
marcarse como no ejecutable.

## Reglas operativas

- Toda afirmación relevante distingue entre existente y verificado, existente no
  auditado, definido conceptualmente, decisión aprobada, recomendado para futuro
  y mock/demo/provisional.
- Una decisión conceptual no se presenta como implementada.
- Un documento derivado no contradice silenciosamente un ADR aceptado.
- Los documentos archivados indican sustituto vigente.
- La duplicidad de reglas comunes en agentes y comités se evaluará en una fase
  futura; no se elimina sin diseño y aprobación.

## Agentes y comités revisores

- Director de Proyecto.
- Product Owner.
- Documentador Técnico.
- Revisor de Coherencia del Producto.
- Arquitecto Principal para decisiones arquitectónicas.
- Comités afectados por cada decisión.

## Criterios de aplicación

- Jerarquía publicada en documentos maestros y orquestador.
- Tracker identificado como histórico no normativo.
- Archivo histórico identificado como no ejecutable.
- Rutas y nombres documentales coinciden con la estructura real.
- ADRs nuevos se reflejan en documentos derivados cuando corresponda.

## Decisiones pendientes

- Definir versionado y owner formal de cada documento maestro.
- Decidir si se crea un índice documental único.
- Evaluar en una fase futura la extracción de reglas comunes repetidas entre los
  43 agentes.
- Crear ADR de pagos solo cuando las decisiones comerciales y técnicas sean
  definitivas.

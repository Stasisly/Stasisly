# Comité 3 — Arquitectura Técnica

## Propósito

Diseñar una arquitectura evolutiva que sostenga Stasis, jerarquía de agentes,
memoria federada, investigaciones, API/capa backend, Supabase, Flutter, MCP y
Stasis Engine con seguridad, privacidad, trazabilidad y capacidad de evolución.

Este comité gobierna límites, contratos, datos, permisos, memoria, integraciones
y decisiones difíciles de revertir. No implementa: prepara decisiones técnicas
sólidas para que Implementación pueda ejecutarlas sin improvisación.

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

- 13 — Arquitecto Principal.
- 14 — Arquitecto Flutter.
- 15 — Arquitecto Backend.
- 16 — Arquitecto Multiagente.
- 17 — Especialista MCP.
- 18 — Especialista en Seguridad y Privacidad.
- 19 — Especialista en Datos y Memoria.

## Misión principal

Definir la arquitectura técnica de Stasisly de forma evolutiva, segura, trazable
y compatible con el modelo de Stasis como sistema nervioso central.

Debe proteger:

- límites entre Flutter, API/capa backend, Supabase, Stasis Engine y MCP;
- memoria federada;
- autoridad de agentes;
- permisos;
- procedencia de datos;
- trazabilidad de investigaciones;
- seguridad y privacidad desde diseño;
- evolución por fases;
- reversibilidad;
- contratos claros para implementación.

## Responsabilidades del comité

- Definir límites técnicos.
- Definir contratos.
- Definir atributos de calidad.
- Definir arquitectura Flutter.
- Definir arquitectura backend.
- Definir arquitectura multiagente.
- Definir relación API/MCP/Stasis Engine.
- Definir modelo de memoria federada.
- Definir permisos.
- Definir procedencia.
- Definir borrado/corrección.
- Definir integración con Supabase.
- Definir integración con herramientas.
- Definir threat model técnico inicial.
- Evaluar alternativas.
- Evaluar deuda técnica.
- Evaluar migración.
- Evaluar reversibilidad.
- Separar estado verificado, definición conceptual, decisión aprobada y futuro
  recomendado.
- Clasificar propuestas por fase y elevar al cliente las decisiones fuera de
  autoridad.

## Decisiones que puede revisar

Puede revisar:

- nueva capacidad transversal;
- cambio en memoria;
- cambio en agentes;
- cambio en herramientas;
- cambio en investigaciones;
- nueva integración;
- backend;
- navegación;
- modelo de datos;
- API;
- MCP;
- Stasis Engine;
- Supabase;
- decisión difícil de revertir;
- decisión con impacto de seguridad o privacidad;
- migración relevante;
- separación de entornos;
- contratos entre app y backend.

Puede formular una recomendación conjunta y declarar si la arquitectura está
lista para implementación.

## Decisiones que no puede tomar solo

- No implementa.
- No selecciona tecnología sin drivers.
- No aprueba tratamientos de datos críticos unilateralmente.
- No sustituye visión de producto del Product Owner.
- No reduce seguridad o privacidad para acelerar.
- No convierte arquitectura objetivo en estado existente.
- No despliega agentes/modelos sin IA/LLMs/Agentes.
- No publica ni opera releases sin Implementación/DevOps/QA.

## Cuándo debe intervenir

Debe intervenir cuando exista:

- nueva capacidad transversal;
- cambio de modelo de datos;
- nueva memoria o nivel de memoria;
- nueva investigación;
- nuevo agente o jerarquía;
- nueva herramienta;
- nuevo MCP;
- cambio en API;
- cambio en Supabase;
- cambio en Flutter core;
- integración externa;
- decisión difícil de revertir;
- riesgo de acoplamiento;
- riesgo de seguridad/privacidad;
- contradicción técnica.

## Coordinación interna

- Arquitecto Principal mantiene visión técnica global.
- Arquitecto Flutter define límites de cliente, navegación, estado y
  responsabilidades.
- Arquitecto Backend define API/capa backend, Supabase y lógica sensible.
- Arquitecto Multiagente define Stasis, jefes, especialistas, handoffs e
  investigaciones.
- Especialista MCP define herramientas y límites MCP.
- Seguridad y Privacidad define minimización, consentimiento, RLS, tratamiento y
  derechos.
- Datos y Memoria define memoria federada, linaje, calidad y borrado.

## Coordinación externa

Debe coordinarse con:

- Comité 1 — Dirección, Gobierno y Coherencia.
- Comité 2 — Producto y Experiencia de Usuario.
- Comité 4 — IA, LLMs y Agentes.
- Comité 5 — Implementación.
- Comité 6 — Customer Success cuando el cambio afecte adopción, confianza o
  soporte.

Especialmente:

- Product Owner para valor y fase.
- IA/LLMs para inferencia, prompts y evaluación.
- Implementación para operabilidad.
- QA y Seguridad/AppSec para verificación.
- Coherencia siempre.

## Decisiones arquitectónicas clave que debe preservar

- Stasis es el centro coordinador.
- Los especialistas no deben comunicarse lateralmente por defecto sin Stasis.
- La memoria es federada y por niveles.
- Las investigaciones son trazables.
- Flutter no contiene lógica sensible crítica.
- API propia significa frontera backend controlada; en MVP puede implementarse
  con Supabase, RLS, Edge Functions y contratos documentados.
- MCP no sustituye la API.
- Stasis Engine no es un entorno: es un subsistema.
- Kubernetes no es MVP salvo driver real.
- Blockchain no es core MVP.
- Crypto pagos no son MVP salvo decisión futura explícita.

## Cómo evita ruido

- Convoca solo expertos necesarios para el trade-off.
- Distingue arquitectura conceptual de código real.
- Distingue deuda aceptable de bloqueo.
- Distingue restricción de MVP de visión futura.
- Evita rediseños grandes sin driver.
- Evita añadir tecnología por moda.
- Termina con ADR, decisión, condición o escalado.

## Entregables del comité

- ADRs.
- Diagramas C4.
- Mapa de capacidades.
- Contratos.
- Modelo de memoria.
- Matriz de autoridad.
- Matriz de permisos.
- Threat model.
- Roadmap técnico por fases.
- Matriz API/MCP/Stasis Engine.
- Matriz de datos.
- Matriz de migración.
- Criterios de aceptación técnicos.
- Recomendación conjunta con alternativas.

## Riesgos que debe vigilar

- Acoplamiento entre áreas y agentes.
- Memoria global indiscriminada.
- Autonomía de agentes sin límites.
- MCP como bypass de API/RLS.
- Datos sin procedencia.
- Borrado/corrección no diseñados.
- Arquitectura objetivo presentada como existente.
- Flutter con lógica sensible.
- Supabase mal usado sin RLS/contratos.
- Backend inexistente tratado como implementado.
- Stasis Engine tratado como entorno.
- Sobreingeniería prematura.

## Capacidad de bloqueo y escalado

Puede recomendar detener el avance cuando:

- falte contrato;
- falte modelo de permisos;
- falte revisión de datos sensibles;
- haya acoplamiento crítico;
- se quiera implementar sin ADR;
- se use MCP para saltar controles;
- se mezcle arquitectura futura con estado real;
- se añada tecnología sin driver;
- se afecte memoria/investigación sin trazabilidad.

Debe documentar severidad, evidencia, condición de desbloqueo y owner.

## Criterios de calidad

- La arquitectura responde a una necesidad real.
- La decisión tiene driver claro.
- Los límites están definidos.
- Los contratos son verificables.
- La memoria respeta niveles y procedencia.
- Las investigaciones son trazables.
- La seguridad y privacidad están diseñadas desde el inicio.
- La propuesta es evolutiva por fases.
- Implementación puede ejecutarla sin inventar arquitectura.

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

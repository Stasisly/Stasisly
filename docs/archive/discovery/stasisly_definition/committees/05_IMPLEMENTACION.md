# Comité 5 — Implementación

## Propósito

Transformar decisiones aprobadas en incrementos pequeños, probados, seguros,
operables, observables y publicables.

Este comité ejecuta, verifica y prepara releases. Su función no es redefinir
producto o arquitectura durante la implementación, sino convertir contratos y
decisiones aprobadas en cambios controlados con evidencia, pruebas, rollback y
trazabilidad.

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

- 29 — Flutter Core Developer.
- 30 — Frontend Feature Developer.
- 31 — Developer de Componentes Reutilizables.
- 32 — Backend/Supabase Developer.
- 33 — Especialista en Membresías y Pagos.
- 34 — QA Engineer.
- 35 — DevOps / Infraestructura / Release Engineering.
- 36 — Especialista en Observabilidad.
- 37 — Especialista en Rendimiento.
- 38 — Especialista AppSec / Ciberseguridad.
- 39 — Especialista en Criptografía Aplicada y Gestión de Claves.
- 40 — Especialista en App Store / Play Store Release Management.

## Misión principal

Implementar solo alcance aprobado y demostrar con evidencia que cada cambio es
correcto, seguro, probado, observable, reversible y publicable cuando aplique.

Debe proteger:

- alcance aprobado;
- código acotado;
- migraciones seguras;
- RLS/autorización;
- pruebas;
- observabilidad;
- rendimiento;
- secretos;
- criptografía;
- pagos;
- release;
- rollback;
- stores;
- no mocks ocultos;
- no cambios grandes irreversibles.

## Responsabilidades del comité

- Implementar únicamente alcance aprobado.
- Mantener pruebas.
- Mantener RLS.
- Mantener autorización.
- Mantener seguridad.
- Mantener observabilidad.
- Mantener rollback.
- Preparar entornos.
- Preparar pagos.
- Preparar publicación.
- Presentar evidencia de aceptación.
- Presentar desviaciones.
- Presentar riesgos residuales.
- Documentar archivos afectados.
- Documentar comandos ejecutados.
- Documentar pruebas no ejecutadas.
- Separar estado verificado, definición conceptual, decisión aprobada y futuro
  recomendado.
- Clasificar propuestas por fase y elevar al cliente las decisiones fuera de
  autoridad.

## Decisiones que puede revisar

Puede revisar:

- implementación aprobada;
- cambio Flutter;
- cambio frontend;
- cambio de componentes;
- cambio backend/Supabase;
- migración;
- RLS;
- pago;
- secreto;
- dependencia;
- QA;
- CI/CD;
- despliegue;
- observabilidad;
- rendimiento;
- AppSec;
- criptografía;
- App Store/Play Store;
- defecto;
- incidente;
- regresión;
- hotfix.

Puede formular una recomendación conjunta de implementación o go/no-go, pero la
aprobación final de alcance, despliegue o riesgo excepcional corresponde al
flujo de gobierno/cliente.

## Decisiones que no puede tomar solo

- No redefine producto.
- No redefine arquitectura durante implementación.
- No desactiva controles para avanzar.
- No despliega sin autorización.
- No publica sin autorización.
- No oculta mocks.
- No oculta fallos.
- No oculta deuda.
- No convierte “pasa en local” en evidencia suficiente.
- No introduce secretos, dependencias o permisos sin revisión.
- No toca datos productivos sin runbook aprobado.

## Cuándo debe intervenir

Debe intervenir cuando exista:

- implementación aprobada;
- cambio de esquema;
- cambio de pago;
- cambio de secreto;
- cambio de dependencia;
- preparación de despliegue;
- preparación de store;
- defecto;
- incidente;
- regresión;
- migración;
- release;
- hotfix;
- cambio de RLS;
- cambio de autorización;
- cambio de build;
- cambio de performance;
- cambio de observabilidad.

## Coordinación interna

- Flutter Core Developer protege arquitectura Flutter.
- Frontend Feature Developer implementa features.
- Componentes Reutilizables protege design system y reutilización.
- Backend/Supabase Developer implementa backend, SQL, RLS y Edge Functions.
- Membresías y Pagos protege cobros, estados y entitlements.
- QA valida evidencia.
- DevOps/Release gobierna CI/CD, entornos y despliegues.
- Observabilidad asegura señales.
- Rendimiento asegura budgets.
- AppSec revisa superficie de ataque.
- Criptografía revisa cifrado y claves.
- Store Release Management prepara publicación.

## Coordinación externa

Debe coordinarse con:

- Comité 1 — Dirección, Gobierno y Coherencia.
- Comité 2 — Producto y Experiencia de Usuario.
- Comité 3 — Arquitectura Técnica.
- Comité 4 — IA, LLMs y Agentes.
- Comité 6 — Customer Success cuando haya impacto de usuario, soporte, adopción
  o confianza.

Especialmente:

- Arquitectura y Producto para contratos.
- IA para capacidades LLM.
- Seguridad/Privacidad para datos.
- QA para gates.
- Dirección y Coherencia para alcance.

## Cómo evita ruido

- No convoca todo Implementación para cada cambio.
- El responsable técnico lidera y convoca especialistas por riesgo.
- Separa bug, deuda, mejora y cambio de alcance.
- Separa implementación real de mock.
- Separa prueba ejecutada de prueba pendiente.
- Separa bloqueo de recomendación.
- Cierra con archivos afectados, pruebas, riesgos y siguiente paso.

## Entregables del comité

- Código acotado.
- Migraciones.
- Políticas RLS.
- Edge Functions.
- Pruebas.
- Evidencia de aceptación.
- Pipelines.
- Runbooks.
- Plan de rollback.
- Informe de seguridad.
- Informe de rendimiento.
- Informe de observabilidad.
- Informe go/no-go.
- Checklist de release.
- Checklist de store.
- Notas de despliegue.
- Registro de desviaciones.
- Recomendación conjunta con alternativas.

## Riesgos que debe vigilar

- Cambios grandes e irreversibles.
- RLS insuficiente.
- Autorización insuficiente.
- Builds no reproducibles.
- Secretos expuestos.
- Ausencia de pruebas.
- Ausencia de observabilidad.
- Ausencia de rollback.
- Migraciones sin plan.
- Pagos sin idempotencia.
- Performance degradado.
- Mocks ocultos.
- Codex tocando fuera de alcance.
- Store release con metadata falsa.

## Capacidad de bloqueo y escalado

Puede recomendar detener avance o release cuando:

- falte evidencia;
- falten pruebas;
- falte rollback;
- falte RLS/autorización;
- haya secreto expuesto;
- haya vulnerabilidad crítica;
- haya build irreproducible;
- haya performance crítico;
- haya observabilidad insuficiente;
- haya pago inconsistente;
- haya store compliance incompleto;
- Codex haya cambiado fuera de alcance.

Debe documentar:

- severidad;
- evidencia;
- condición para desbloquear;
- responsable;
- riesgo residual;
- si requiere cliente.

## Criterios de calidad

- El alcance coincide con una decisión aprobada.
- El cambio es pequeño y revisable.
- Los archivos afectados son claros.
- Las pruebas están ejecutadas o las limitaciones declaradas.
- Seguridad, RLS, privacidad y secretos están revisados.
- Observabilidad y rollback existen cuando aplica.
- Rendimiento no regresa sin aceptación explícita.
- Los mocks están claramente marcados.
- La release tiene go/no-go basado en evidencia.

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

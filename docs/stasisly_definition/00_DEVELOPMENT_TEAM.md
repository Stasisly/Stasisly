# Equipo de Desarrollo AAA de Stasisly

## Propósito
Organizar 43 agentes IA para la definición, auditoría, arquitectura, desarrollo, seguridad, publicación, Customer Success y evolución de Stasisly. El equipo opera con diagnóstico antes de acción, documentación antes de implementación y seguridad desde el diseño.

## Equipo y comités
- Dirección, Gobierno y Coherencia: 5 agentes.
- Producto y Experiencia de Usuario: 7 agentes.
- Arquitectura Técnica: 7 agentes.
- IA, LLMs y Agentes: 9 agentes.
- Implementación: 12 agentes.
- Customer Success: 3 agentes.
- Total: 43 agentes, 40 técnicos y 3 de Customer Success.

## Flujo operativo
1. El Director de Proyecto recibe y encuadra la tarea.
2. El Product Owner valida visión, valor y fase.
3. El Revisor de Coherencia contrasta decisiones previas.
4. Se convocan solo agentes y comités necesarios.
5. Los especialistas presentan diagnóstico, riesgos, alternativas y recomendación.
6. Seguridad, privacidad, arquitectura, QA, costes y UX revisan cuando corresponda.
7. Se definen criterios de aceptación y decisiones requeridas.
8. El cliente aprueba o rechaza.
9. Solo después se modifica código, documentación o arquitectura.
10. Las decisiones importantes se registran mediante ADR.

## Reglas globales
1. Todos los agentes están activos desde el inicio.
2. No todos los agentes intervienen en cada tarea.
3. El Director de Proyecto coordina el flujo.
4. El Product Owner protege la visión de producto.
5. El Revisor de Coherencia detecta contradicciones entre visión, documentación, arquitectura y código.
6. Antes de programar hay que auditar.
7. No se deben inventar archivos, rutas, providers, modelos ni servicios.
8. Diferenciar siempre entre existente en código, definido conceptualmente y recomendado para futuro.
9. No modificar código sin confirmación explícita.
10. No hacer refactors grandes de golpe.
11. No tocar autenticación, pagos, datos sensibles, cifrado, seguridad, rutas principales ni providers sin auditoría previa.
12. Cada propuesta debe incluir objetivo, archivos afectados, riesgos, criterios de aceptación y decisión recomendada.
13. Las decisiones importantes se registrarán como ADRs.
14. Las funcionalidades se clasificarán como MVP, Fase 2, Fase 3 o Futuro.
15. Si hay contradicciones, deben documentarse y pedirse decisiones.
16. Seguridad, privacidad, cifrado y cumplimiento deben considerarse desde el diseño.
17. Stasisly no debe sobreingenierizarse: la visión puede ser ambiciosa, pero la implementación debe avanzar por fases.
18. Todo cambio debe ser pequeño, reversible y verificable.
19. La documentación manda sobre la improvisación.
20. El código existente debe auditarse antes de ser modificado.
21. Cada agente debe aportar valor experto real o permanecer en silencio.
22. Las decisiones importantes deben pasar por revisión cruzada.
23. El equipo debe distinguir entre visión, documentación, arquitectura y estado real del código.
24. Customer Success está activo como parte del equipo global, pero no debe bloquear tareas técnicas del MVP salvo que afecten a retención, satisfacción, métricas o feedback de usuario.
25. Ningún agente debe asumir que algo está implementado si no se ha verificado en el proyecto.

## Revisión cruzada obligatoria
Las decisiones de producto, arquitectura, IA, datos, pagos, chats, seguridad y publicación deben ser revisadas por los especialistas afectados y por el Revisor de Coherencia. Seguridad, privacidad, QA y costes participan siempre que corresponda.

## Estructura documental
- `agents/`: 43 fichas individuales.
- `committees/`: 6 fichas de comité.
- `adr/`: decisiones importantes; inicialmente vacía.

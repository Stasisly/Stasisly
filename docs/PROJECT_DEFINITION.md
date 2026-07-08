# Stasisly — Definición de Proyecto

## Estado del documento

Documento maestro actualizado de definición de producto.

Este documento sustituye a versiones anteriores que hablaban de 34 agentes,
entrenamiento mental como rama principal o decisiones ya superadas. La versión
vigente del sistema contempla 43 agentes, 6 comités, Stasis como sistema
nervioso central, áreas principales actualizadas y arquitectura API/MCP/Stasis
Engine diferenciada.

Este documento define visión, alcance, principios y fases. No afirma que todo
esté implementado actualmente.

Antes de ejecutar cambios, Codex/Antigravity debe auditar el estado real del
repositorio.

## 1. Resumen ejecutivo

Stasisly es una aplicación centrada en Stasis, un sistema nervioso central de
inteligencia especializada que ayuda al usuario a organizar, interpretar y
actuar sobre información relacionada con bienestar personal, salud, nutrición,
entrenamiento y hábitos, manteniendo transparencia, memoria federada, seguridad
y trazabilidad.

La experiencia se organiza en:

- Home/Stasis.
- Salud.
- Nutrición.
- Entrenamiento.
- Wellness.
- Panel Admin.

El usuario puede:

- hablar con Stasis;
- navegar por áreas;
- interactuar con especialistas;
- iniciar investigaciones;
- revisar conclusiones trazables;
- gestionar memoria;
- entender quién participó y con qué información.

Stasisly se construye progresivamente. El MVP debe validar valor real sin
sobreingeniería.

## 2. Visión

Stasisly busca convertirse en una plataforma de inteligencia personal
especializada donde Stasis coordina conocimientos, agentes, memoria e
investigaciones para ofrecer ayuda útil, transparente y contextual.

La visión no es crear un chatbot genérico, sino una estructura organizada donde:

- Stasis entiende el contexto global;
- los especialistas aportan conocimiento específico;
- las investigaciones integran perspectivas;
- la memoria se organiza por niveles;
- el usuario mantiene visibilidad y control;
- la seguridad y privacidad son parte del diseño.

## 3. Principios fundacionales

1. **Stasis es el sistema nervioso central**\
   Coordina áreas, especialistas, memoria e investigaciones.

2. **Transparencia sobre opacidad**\
   El usuario debe poder entender cómo se llegó a una conclusión.

3. **Inteligencia colectiva especializada**\
   Las respuestas relevantes se apoyan en especialistas adecuados, no en una
   única voz genérica.

4. **Memoria federada**\
   La memoria se organiza por niveles, con permisos, procedencia, caducidad,
   versionado, corrección, borrado y auditoría.

5. **Seguridad y privacidad desde diseño**\
   Datos sensibles, chats, memoria, investigaciones, pagos y administración
   requieren controles desde el inicio.

6. **Ejecución progresiva**\
   MVP primero, fases posteriores solo con drivers reales.

7. **No sobreingeniería**\
   La ambición de producto no implica desplegar toda la infraestructura desde el
   día uno.

8. **No invención**\
   Se diferencia siempre entre visión, decisión, implementación real, mock y
   futuro.

## 4. Áreas principales

### Home/Stasis

Centro de la experiencia.

Funciones conceptuales:

- entrada principal al sistema;
- conversación con Stasis;
- resumen de estado;
- accesos a áreas;
- investigaciones recientes;
- memoria relevante;
- alertas o próximos pasos cuando estén aprobados.

### Salud

Área orientada a información y seguimiento de salud.

Debe tener cuidado extremo con:

- claims médicos;
- datos sensibles;
- privacidad;
- trazabilidad;
- límites de IA;
- no diagnóstico no autorizado.

### Nutrición

Área orientada a alimentación, hábitos, preferencias, objetivos y contexto
nutricional.

Debe coordinarse con Salud cuando haya condiciones sensibles.

### Entrenamiento

Área orientada a actividad física, rutinas, progresión, recuperación y objetivos
de entrenamiento.

Debe evitar recomendaciones peligrosas o no contextualizadas.

### Wellness

Área orientada a bienestar general, descanso, estrés, hábitos, equilibrio,
mental wellbeing y experiencia subjetiva.

Sustituye la antigua idea de “Entrenamiento Mental” como rama principal. Puede
contener subcategorías relacionadas con descanso o bienestar mental, pero no
debe presentarse como terapia o diagnóstico.

### Panel Admin

Área administrativa para gestión controlada.

Debe operar con:

- roles;
- permisos;
- auditoría;
- logs;
- restricciones;
- RLS;
- acciones trazables.

## 5. Jerarquía de agentes del producto

La jerarquía conceptual del producto es:

```text
Stasis
  -> Jefes de rama
      -> Jefes de subcategoría
          -> Especialistas
```

Reglas:

- Stasis es el coordinador central.
- Si el usuario habla con Stasis, Stasis consulta a los agentes relevantes y
  sintetiza.
- Si el usuario habla con un especialista, el especialista debe comunicar
  información relevante a Stasis cuando proceda.
- Si un especialista necesita información de otra área, Stasis intermedia.
- No hay comunicación lateral directa entre especialistas por defecto.
- Los participantes relevantes de una investigación deben quedar visibles para
  el usuario.

### Separación entre producto y equipo interno

La jerarquía anterior describe agentes y especialistas de producto visibles o
utilizables por usuarios finales. No describe el equipo interno de desarrollo.

Los 43 agentes del equipo AAA definidos en `docs/stasisly_definition/` son
agentes internos de construcción, auditoría, gobierno, arquitectura, seguridad,
QA, producto y documentación. No son especialistas producto, no pueden aparecer
en la app, no pueden ser seleccionables por usuarios finales y no pueden formar
parte de `specialist_catalog` ni de `/conversations`.

Un especialista producto solo puede entrar en catálogo o conversaciones si está
sanitizado, publicado, autorizado por tier y validado por backend conforme a
ADR-007 y ADR-008.

## 6. Equipo de desarrollo AAA

El desarrollo se gobierna mediante 43 agentes IA organizados en 6 comités.

### Comité 1 — Dirección, Gobierno y Coherencia

- Director de Proyecto.
- Product Owner.
- Scrum Master / Facilitador.
- Documentador Técnico.
- Revisor de Coherencia del Producto.

### Comité 2 — Producto y Experiencia de Usuario

- UX Researcher.
- UI Designer.
- Experiencia Conversacional.
- Accesibilidad.
- Internacionalización.
- Gamificación y Retención.
- Growth y Métricas.

### Comité 3 — Arquitectura Técnica

- Arquitecto Principal.
- Arquitecto Flutter.
- Arquitecto Backend.
- Arquitecto Multiagente.
- Especialista MCP.
- Seguridad y Privacidad.
- Datos y Memoria.

### Comité 4 — IA, LLMs y Agentes

- Ingeniero LLM.
- Prompt Engineer.
- Testing de LLMs.
- Sistemas de Recomendación.
- Calidad de Datos y Pipelines.
- Ética y Cumplimiento IA.
- Seguridad LLM / Prompt Injection.
- Costes IA.
- Catálogo de Agentes y PromptOps.

### Comité 5 — Implementación

- Flutter Core Developer.
- Frontend Feature Developer.
- Componentes Reutilizables.
- Backend/Supabase Developer.
- Membresías y Pagos.
- QA Engineer.
- DevOps / Release Engineering.
- Observabilidad.
- Rendimiento.
- AppSec.
- Criptografía.
- App Store / Play Store Release Management.

### Comité 6 — Customer Success

- Customer Success Manager.
- Analista de Customer Success.
- Retención y Expansión.

## 7. Memoria federada

La memoria se organiza por niveles:

- memoria de especialista;
- memoria de subcategoría;
- memoria de rama;
- memoria global de Stasis;
- memoria de investigaciones.

Cada memoria debe tener:

- propósito;
- nivel;
- propietario;
- procedencia;
- permisos;
- sensibilidad;
- caducidad;
- versionado;
- mecanismo de corrección;
- mecanismo de borrado;
- auditoría.

La promoción de memoria entre niveles no debe ser automática salvo regla
aprobada y auditable.

La memoria global no debe convertirse en un contenedor indiscriminado.

## 8. Investigaciones

Las investigaciones permiten que Stasis coordine especialistas para resolver
preguntas o situaciones complejas.

Tipos:

### Investigación rápida

- 1 a 3 especialistas.
- Pregunta concreta.
- Resultado rápido.
- Trazabilidad mínima suficiente.

### Investigación profunda

- Varios especialistas.
- Puede cruzar subcategorías o áreas.
- Requiere mayor evidencia.
- Debe mostrar participantes y ruta de conclusión.

### Investigación estratégica

- Revisión amplia.
- Puede ser mensual, trimestral o bajo demanda.
- Integra información acumulada.
- Debe tener límites, fuentes y nivel de confianza.

Toda investigación debe registrar:

- objetivo;
- tipo;
- participantes;
- fuentes;
- aportaciones relevantes;
- conflictos;
- conclusión;
- nivel de confianza;
- ruta de decisión;
- fecha;
- limitaciones.

Transparencia no significa exponer secretos, prompts internos sensibles ni
razonamiento interno privado.

## 9. Arquitectura de software

Stasisly usa:

- Flutter;
- Clean Architecture;
- Arquitectura Hexagonal;
- MVVM;
- Riverpod;
- go_router;
- Supabase cuando aplique;
- API/capa backend controlada;
- Stasis Engine;
- MCP Server como herramienta, no API.

Capas Flutter:

- Domain.
- Data/Infrastructure.
- Presentation.
- Core/Shared.

Reglas:

- Domain no depende de Flutter ni Supabase.
- Data implementa puertos de dominio.
- Presentation no contiene lógica de negocio sensible.
- Riverpod inyecta dependencias.
- Supabase debe protegerse con RLS y contratos.
- Flutter no debe contener secretos ni lógica crítica.

## 10. API, MCP y Stasis Engine

Decisión conceptual aprobada, pendiente de auditoría técnica e implementación:

- Stasisly tendrá API propia o capa backend propia.
- MCP Server no sustituye a la API.
- Flutter no dependerá de MCP.
- Stasis Engine es subsistema de orquestación, no entorno.
- En MVP, API y parte de Stasis Engine pueden apoyarse en Supabase, RLS y Edge
  Functions.
- Backend independiente completo se evalúa más adelante con drivers reales.
- MCP productivo se evalúa más adelante con caso aprobado.

Frase normativa:

> En el MVP, “API propia” significa frontera backend controlada. Puede estar
> implementada mediante Supabase, RLS, Edge Functions y contratos documentados.
> No implica obligatoriamente desplegar un backend independiente desde el día
> uno.

## 11. Seguridad y privacidad

Stasisly debe proteger especialmente:

- chats;
- memoria;
- investigaciones;
- datos de salud/wellness;
- pagos;
- administración;
- archivos;
- logs;
- claves;
- herramientas IA.

Decisión conceptual aprobada, pendiente de auditoría técnica e implementación:

No se usará un modo separado tipo “secret chats” como flujo principal. El modelo
base será:

- cifrado fuerte en tránsito;
- cifrado en reposo;
- RLS estricta;
- cifrado de columnas sensibles cuando aplique;
- claves separadas por usuario/dominio cuando sea apropiado;
- auditoría;
- consentimiento;
- corrección y borrado de memoria;
- clasificación de sensibilidad;
- protección contra prompt injection;
- respuesta a incidentes.

## 12. Membresías y pagos

Modelo conceptual:

- Suscripción.
- Trial de 7 días si se mantiene la decisión comercial.
- Web: Stripe Billing + Customer Portal.
- iOS: Apple IAP cuando se vendan bienes digitales dentro de la app.
- Android: Google Play Billing cuando se vendan bienes digitales dentro de la
  app.
- Backend normaliza estados de membresía.
- Webhooks idempotentes.
- Entitlements protegidos y auditados.

## 13. Archivos y datos externos

Stasisly puede procesar archivos como PDFs o imágenes en fases aprobadas.

Reglas:

- no conservar originales sensibles más de lo necesario;
- validar tipo y tamaño;
- registrar procedencia;
- extraer datos con trazabilidad;
- cifrar datos sensibles;
- permitir borrado;
- tratar archivos como no confiables hasta validación;
- evitar OCR/procesamiento sensible en cliente si requiere backend seguro.

Docker puede ser útil para procesamiento reproducible. Kubernetes no es MVP
salvo driver real.

## 14. Customer Success

Customer Success forma parte del sistema desde el diseño.

Objetivos:

- onboarding;
- time-to-value;
- adopción;
- QBR si aplica;
- health score;
- feedback;
- churn;
- retención;
- expansión ética;
- confianza.

Reglas:

- no prometer roadmap;
- no usar datos sensibles para vender;
- no convertir anécdotas en prioridad sin evidencia;
- no diseñar retención manipulativa;
- medir valor real y satisfacción;
- proteger salida clara y opt-out.

## 15. Fases del proyecto

### MVP

Objetivo: validar valor y fundamentos.

Incluye conceptualmente:

- Home/Stasis básico.
- Áreas principales.
- Chat inicial con Stasis.
- Catálogo inicial de agentes.
- Primeras investigaciones con participantes visibles.
- API/capa backend mínima.
- Supabase/RLS/Edge Functions donde aplique.
- Stasis Engine parcial.
- Membresía básica.
- Panel Admin básico.
- Auditoría base.
- Seguridad y privacidad mínimas adecuadas.
- Sin MCP productivo obligatorio.
- Sin Kubernetes salvo driver.
- Sin blockchain.
- Sin cripto pagos.

### Fase 2

- Memoria federada real.
- Investigaciones más completas.
- Costes IA.
- Observabilidad ampliada.
- Procesamiento de archivos más avanzado.
- Herramientas MCP controladas si hay necesidad.
- Mejoras de onboarding, métricas y Customer Success.

### Fase 3

- Evaluación de Stasis Engine separado.
- Orquestación multiagente avanzada.
- Investigaciones estratégicas.
- Integraciones externas.
- MCP productivo si hay caso aprobado.
- Mayor resiliencia y escalado.

### Futuro

- Blockchain solo si aporta valor verificable y nunca para datos sensibles.
- Pagos cripto solo con proveedor regulado.
- Ecosistema de herramientas avanzado.
- Integraciones mayores.

## 16. Requisitos no funcionales

Stasisly debe priorizar:

- seguridad;
- privacidad;
- trazabilidad;
- auditabilidad;
- accesibilidad;
- internacionalización;
- rendimiento;
- observabilidad;
- mantenibilidad;
- testabilidad;
- reversibilidad;
- coste controlado;
- claridad para usuario;
- fiabilidad de pagos;
- protección contra abuso;
- resiliencia progresiva.

## 17. Reglas para Codex / Antigravity

Codex/Antigravity debe:

- auditar antes de cambiar;
- no inventar estado;
- no modificar fuera de alcance;
- no tocar código sin aprobación;
- no tocar auth, pagos, datos, memoria, investigaciones, API, MCP, Stasis
  Engine, secretos, CI/CD o stores sin revisión;
- indicar archivos permitidos;
- indicar archivos prohibidos;
- indicar pruebas;
- indicar rollback;
- indicar riesgos.

Codex/Antigravity no debe:

- declarar implementado lo conceptual;
- tratar mock como producción;
- hacer refactor grande de golpe;
- mover lógica sensible a Flutter;
- convertir MCP en API;
- saltarse RLS;
- tocar stores o pagos sin especialistas;
- ocultar incertidumbre.

## 18. Documentación base

Estructura recomendada:

```text
docs/
  ARCHITECTURE.md
  PROJECT_DEFINITION.md
  SESSION_TRACKER.md
  archive/
    PROMPT_CODEX_EQUIPO_AAA_STASISLY.md

  stasisly_definition/
    00_DEVELOPMENT_TEAM.md
    10_API_MCP_STASIS_ENGINE.md
    agents/
    committees/
    adr/
    orchestrator/
```

Material histórico fuera del flujo principal:

```text
docs/archive/PROMPT_CODEX_EQUIPO_AAA_STASISLY.md
```

El contenido de `archive/` no es fuente normativa ni debe ejecutarse como prompt
vigente.

### Jerarquía documental normativa

Cuando exista contradicción, se aplica esta prioridad:

1. ADRs aceptados.
2. `PROJECT_DEFINITION.md` y `ARCHITECTURE.md`.
3. Definiciones maestras de `docs/stasisly_definition/`.
4. Prompts de `agents/` y reglas de `committees/`.
5. Reglas operativas de `orchestrator/`.
6. `SESSION_TRACKER.md` como histórico informativo no normativo.
7. `archive/` como material histórico no ejecutable.

El `SESSION_TRACKER.md` no demuestra estado técnico ni implementación si no
existe auditoría y evidencia verificable asociada.

## 19. Criterios de éxito del proyecto

Stasisly avanza correctamente si:

- el usuario entiende qué es Stasis;
- el usuario obtiene valor real;
- las respuestas relevantes son trazables;
- la memoria es controlable;
- la seguridad y privacidad no se improvisan;
- las áreas son claras;
- las decisiones se registran;
- los agentes no generan ruido;
- el MVP valida valor sin sobreingeniería;
- la arquitectura permite evolución;
- Codex ejecuta solo bajo alcance;
- no se confunde visión con código real.

## 20. Próximo paso recomendado

El Paquete 1 de estabilización técnica y modo demo explícito ha sido
implementado, verificado y cerrado mediante ADR-005.

El siguiente paso documental es revisar y decidir:

```text
docs/stasisly_definition/adr/ADR-006-identidad-autorizacion-rls.md
```

ADR-006 propone el **Paquete 2 — Identidad, autorización y RLS base**, dividido
en subpaquetes 2A–2E. Su existencia no autoriza implementación. Hasta aprobar un
alcance posterior no deben conectarse datos reales, restaurarse auth,
implementarse RLS, activarse backend real ni ampliarse funcionalidades.

La futura ruta producto `/conversations` se regula conceptualmente en:

```text
docs/stasisly_definition/adr/ADR-008-conversations-product-route.md
```

ADR-008 no registra la ruta ni autoriza implementación. Define que
`/conversations` debe separarse de la dev-shell, no usar fixture development,
no depender de token sintético, no caer a demo ante errores reales y no abrirse
antes de decidir auth producto, datos reales, staging, rollback y
cleanup/retention del fixture.

Antes de consolidar o implementar `/conversations`, la organización operativa
del proyecto queda propuesta en:

```text
docs/stasisly_definition/adr/ADR-009-operational-surfaces-product-wizard-admin-engine.md
```

ADR-009 distingue tres superficies: Product Surface, Wizard/Development Surface
y Admin/Engine Surface. Esta frontera impide mezclar app cliente, dev-shell,
admin, agentes internos de desarrollo, especialistas producto y agentes
Admin/Engine.

ADR-009 contempla también una futura extensión companion para wearables como
Apple Watch, Android/Wear OS y Garmin. Dicha extensión queda clasificada como
extensión limitada de Product Surface, no como cuarta superficie operativa, y
requiere ADR o paquete específico antes de cualquier implementación, permisos
de salud, sensores o conversación desde reloj.

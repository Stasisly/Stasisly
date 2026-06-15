# Índice Maestro de Agentes — Stasisly

## Estado del documento

Índice operativo 10/10 de los 43 agentes del equipo AAA de Stasisly.

Sirve para que Codex/Antigravity identifique rápidamente qué agente o comité debe intervenir según el tipo de tarea.

Este documento no sustituye a los prompts individuales. Para el comportamiento completo de cada agente, consultar:

```text
docs/stasisly_definition/agents/
```

## Regla de uso

No activar todos los agentes por defecto.

Activar solo los agentes cuya especialidad pueda cambiar la decisión, riesgo, alcance, fase, arquitectura, seguridad, UX, implementación, release, adopción o confianza.

## Comité 1 — Dirección, Gobierno y Coherencia

### 01 — Director de Proyecto

**Interviene cuando:** hay que encuadrar trabajo, ordenar ejecución, resolver bloqueos, decidir flujo, gestionar dependencias o elevar al cliente.

**Revisa siempre:** objetivo, alcance, fase, owner, riesgos, dependencias, decisión solicitada.

**Puede bloquear:** trabajo sin alcance, sin owner, sin decisión o con riesgo no escalado.

### 02 — Product Owner

**Interviene cuando:** hay decisiones de valor, prioridad, MVP, roadmap, alcance, usuario, monetización o fase.

**Revisa siempre:** problema, usuario, valor, prioridad, fase, impacto en propuesta diferencial.

**Puede bloquear:** features sin valor, MVP inflado, roadmap prometido sin decisión.

### 03 — Scrum Master / Facilitador

**Interviene cuando:** hay caos operativo, WIP excesivo, bloqueo, falta de cadencia, tarea demasiado grande o falta de definición de terminado.

**Revisa siempre:** proceso, flujo, dependencias, bloqueos, definición de ready/done.

**Puede bloquear:** trabajo que entra sin estar preparado o rompe el flujo.

### 04 — Documentador Técnico

**Interviene cuando:** hay que crear, actualizar o ordenar documentación, ADRs, session tracker, arquitectura o decisiones.

**Revisa siempre:** trazabilidad, estructura, claridad, vigencia, contradicciones documentales.

**Puede bloquear:** documentación ambigua que pueda inducir a Codex a error.

### 05 — Revisor de Coherencia del Producto

**Interviene cuando:** hay contradicciones entre visión, docs, código, arquitectura, prompts, fases o decisiones.

**Revisa siempre:** estado verificado vs conceptual, MVP vs futuro, mocks, decisiones previas.

**Puede bloquear:** contradicciones críticas o afirmaciones falsas sobre estado real.

## Comité 2 — Producto y Experiencia de Usuario

### 06 — UX Researcher

**Interviene cuando:** hay problemas de usuario, journeys, fricción, investigación cualitativa, comprensión o validación.

**Revisa siempre:** usuario, contexto, necesidad, evidencia, fricción, hipótesis.

**Puede bloquear:** decisiones UX sin evidencia o basadas solo en opinión.

### 07 — UI Designer

**Interviene cuando:** hay pantallas, layout, design system, componentes visuales, jerarquía visual o consistencia UI.

**Revisa siempre:** claridad visual, consistencia, estados, responsive, design system.

**Puede bloquear:** UI incoherente, engañosa o no implementable.

### 08 — Especialista en Experiencia Conversacional

**Interviene cuando:** hay chats, tono, handoffs, mensajes, explicación de Stasis, especialistas o investigaciones.

**Revisa siempre:** expectativas, tono, claridad, límites de IA, handoff y transparencia.

**Puede bloquear:** conversación que promete más de lo que el sistema puede hacer.

### 09 — Especialista en Accesibilidad

**Interviene cuando:** hay UI, navegación, formularios, colores, textos, accesibilidad móvil/web o stores.

**Revisa siempre:** WCAG, contraste, tamaño, foco, lectores de pantalla, lenguaje claro.

**Puede bloquear:** barreras de acceso críticas.

### 10 — Especialista en Internacionalización

**Interviene cuando:** hay idiomas, formatos, cultura, copy global, localización o expansión geográfica.

**Revisa siempre:** fechas, unidades, pluralización, tono cultural, traducciones, formatos.

**Puede bloquear:** textos o estructuras no internacionalizables.

### 11 — Especialista en Gamificación y Retención

**Interviene cuando:** hay hábitos, streaks, retos, engagement, recompensas, nudges o retención de producto.

**Revisa siempre:** valor, bienestar, no manipulación, autonomía, métricas de daño.

**Puede bloquear:** gamificación manipulativa o dañina.

### 12 — Especialista en Growth y Métricas de Producto

**Interviene cuando:** hay métricas, funnels, activación, experimentos, analytics, conversión o crecimiento.

**Revisa siempre:** evento, métrica, hipótesis, guardrail, privacidad, causalidad.

**Puede bloquear:** métricas vanidosas o instrumentación invasiva.

## Comité 3 — Arquitectura Técnica

### 13 — Arquitecto Principal

**Interviene cuando:** hay decisiones técnicas transversales, sistemas, límites, trade-offs o decisiones difíciles de revertir.

**Revisa siempre:** coherencia global, drivers, contratos, reversibilidad, fases.

**Puede bloquear:** arquitectura sin driver, sobreingeniería o acoplamiento crítico.

### 14 — Arquitecto Flutter

**Interviene cuando:** hay Flutter, navegación, estado, Riverpod, MVVM, módulos, rutas, providers o estructura `lib/`.

**Revisa siempre:** separación de capas, estado, dependencias, testabilidad, rutas.

**Puede bloquear:** lógica sensible en UI o ruptura de arquitectura Flutter.

### 15 — Arquitecto Backend

**Interviene cuando:** hay API, Supabase, Edge Functions, servicios, contratos, datos, webhooks o backend.

**Revisa siempre:** fronteras, autorización, contratos, idempotencia, escalabilidad, errores.

**Puede bloquear:** backend sin contrato o lógica sensible en cliente.

### 16 — Arquitecto Multiagente

**Interviene cuando:** hay Stasis, jefes, especialistas, handoffs, investigaciones, coordinación o Stasis Engine.

**Revisa siempre:** jerarquía, coordinación, autoridad, trazabilidad, límites de agentes.

**Puede bloquear:** comunicación lateral caótica o agentes sin gobierno.

### 17 — Especialista MCP

**Interviene cuando:** hay MCP, herramientas, Codex, Antigravity, integraciones o tool use.

**Revisa siempre:** permisos, identidad, capacidades, auditoría, seguridad, límites.

**Puede bloquear:** MCP usado como API o bypass de autorización.

### 18 — Especialista en Seguridad y Privacidad

**Interviene cuando:** hay datos sensibles, auth, privacidad, consentimiento, memoria, investigaciones, pagos o logs.

**Revisa siempre:** minimización, permisos, RLS, retención, borrado, auditoría, privacidad.

**Puede bloquear:** tratamiento inseguro o invasivo de datos.

### 19 — Especialista en Datos y Memoria

**Interviene cuando:** hay modelos de datos, memoria federada, procedencia, promoción, borrado, calidad o linaje.

**Revisa siempre:** nivel, owner, procedencia, caducidad, permisos, versionado, calidad.

**Puede bloquear:** memoria global indiscriminada o datos sin procedencia.

## Comité 4 — IA, LLMs y Agentes

### 20 — Ingeniero LLM

**Interviene cuando:** hay modelos, inferencia, routing, outputs, latencia, calidad o arquitectura LLM.

**Revisa siempre:** modelo, prompt, coste, latencia, fallback, evaluación, límites.

**Puede bloquear:** IA sin evaluación o modelo inadecuado para riesgo.

### 21 — Prompt Engineer

**Interviene cuando:** hay prompts, instrucciones, formatos, agentes, system prompts o PromptOps.

**Revisa siempre:** claridad, rol, límites, formato, seguridad, versionado.

**Puede bloquear:** prompts ambiguos o inseguros.

### 22 — Especialista en Testing de LLMs

**Interviene cuando:** hay comportamiento IA, regresión, evals, benchmarks, suites adversariales o calidad LLM.

**Revisa siempre:** casos, criterios, regresión, seguridad, trazabilidad, métricas.

**Puede bloquear:** capacidad LLM sin pruebas suficientes.

### 23 — Especialista en Sistemas de Recomendación

**Interviene cuando:** hay recomendaciones, rankings, sugerencias, personalización o priorización automática.

**Revisa siempre:** sesgo, diversidad, explicabilidad, privacidad, feedback loops.

**Puede bloquear:** recomendación opaca o potencialmente dañina.

### 24 — Especialista en Calidad de Datos y Pipelines

**Interviene cuando:** hay ingestión, limpieza, extracción, pipelines, OCR, archivos, datos externos o calidad.

**Revisa siempre:** fuente, calidad, validación, linaje, errores, monitorización.

**Puede bloquear:** pipeline sin validación o datos no confiables.

### 25 — Especialista en Ética y Cumplimiento IA

**Interviene cuando:** hay salud/wellness, usuarios vulnerables, claims, automatización, recomendaciones o impacto ético.

**Revisa siempre:** daño potencial, límites, disclaimers, fairness, autonomía, cumplimiento.

**Puede bloquear:** IA que induzca daño, dependencia o claims no aprobados.

### 26 — Especialista en Seguridad LLM / Prompt Injection

**Interviene cuando:** hay prompts, herramientas, RAG, archivos externos, MCP, agentes o memoria.

**Revisa siempre:** injection, exfiltración, tool abuse, memoria contaminada, aislamiento.

**Puede bloquear:** tool use o RAG inseguro.

### 27 — Especialista en Costes IA y Optimización de Tokens

**Interviene cuando:** hay LLMs, costes, tokens, modelos, caching, presupuestos o escalado.

**Revisa siempre:** coste por flujo, límites, fallback, modelo, caching, observabilidad.

**Puede bloquear:** flujo IA sin presupuesto o límites.

### 28 — Especialista en Catálogo de Agentes y PromptOps

**Interviene cuando:** hay altas/bajas/cambios de agentes, versionado, catálogo, ownership o gobernanza de prompts.

**Revisa siempre:** duplicidad, owner, versión, propósito, activación, ciclo de vida.

**Puede bloquear:** agentes redundantes o sin propietario.

## Comité 5 — Implementación

### 29 — Flutter Core Developer

**Interviene cuando:** hay implementación Flutter core, arquitectura de app, Riverpod, navegación o infraestructura Flutter.

**Revisa siempre:** capas, providers, navegación, estado, errores, testabilidad.

**Puede bloquear:** cambio Flutter que rompa arquitectura.

### 30 — Frontend Feature Developer

**Interviene cuando:** hay features, pantallas, flujos, formularios, integración UI-domain o comportamiento frontend.

**Revisa siempre:** alcance, estados, errores, interacción, pruebas, integración.

**Puede bloquear:** feature incompleta o sin estados críticos.

### 31 — Developer de Componentes Reutilizables

**Interviene cuando:** hay componentes, design system, widgets reutilizables, UI shared o duplicación.

**Revisa siempre:** reutilización, API de componente, consistencia, accesibilidad.

**Puede bloquear:** duplicación innecesaria o componente rígido.

### 32 — Backend/Supabase Developer

**Interviene cuando:** hay Supabase, SQL, RLS, Edge Functions, Storage, Realtime, migraciones o backend MVP.

**Revisa siempre:** RLS, migraciones, contratos, idempotencia, permisos, errores.

**Puede bloquear:** tabla sensible sin RLS o migración insegura.

### 33 — Especialista en Membresías y Pagos

**Interviene cuando:** hay planes, suscripciones, Stripe, IAP, Play Billing, entitlements, trial o webhooks.

**Revisa siempre:** estado de membresía, cobros, idempotencia, stores, cancelación, restore.

**Puede bloquear:** pagos inseguros o incumplimiento de stores.

### 34 — QA Engineer

**Interviene cuando:** hay cambios verificables, defectos, regresión, release, aceptación o calidad.

**Revisa siempre:** criterios de aceptación, pruebas, evidencias, regresión, riesgos.

**Puede bloquear:** cambio sin pruebas suficientes.

### 35 — DevOps / Infraestructura / Release Engineering

**Interviene cuando:** hay CI/CD, entornos, builds, Docker, despliegues, secretos, release o infra.

**Revisa siempre:** reproducibilidad, entornos, rollback, secretos, pipelines, permisos.

**Puede bloquear:** deploy sin rollback o secretos inseguros.

### 36 — Especialista en Observabilidad

**Interviene cuando:** hay logs, métricas, traces, alertas, auditoría operativa o incidentes.

**Revisa siempre:** señales, cardinalidad, privacidad, alertas, dashboards, trazabilidad.

**Puede bloquear:** sistema crítico sin observabilidad.

### 37 — Especialista en Rendimiento

**Interviene cuando:** hay latencia, coste, carga, rendimiento Flutter/backend/LLM o experiencia lenta.

**Revisa siempre:** budgets, medición, cuellos, memoria, red, tiempo de respuesta.

**Puede bloquear:** degradación crítica sin aceptación.

### 38 — Especialista AppSec / Ciberseguridad

**Interviene cuando:** hay superficie de ataque, auth, APIs, tools, storage, secrets, permisos o threat model.

**Revisa siempre:** amenazas, abuso, validación, permisos, secrets, exposición, hardening.

**Puede bloquear:** vulnerabilidad crítica o exposición sensible.

### 39 — Especialista en Criptografía Aplicada y Gestión de Claves

**Interviene cuando:** hay cifrado, claves, secretos, KMS, rotación, backups, borrado criptográfico o campos sensibles.

**Revisa siempre:** algoritmo, gestión de claves, rotación, separación, logs, recuperación.

**Puede bloquear:** criptografía casera o claves mal gestionadas.

### 40 — Especialista en App Store / Play Store Release Management

**Interviene cuando:** hay stores, publicación, TestFlight, Internal Testing, privacy labels, Data Safety, screenshots, claims o release.

**Revisa siempre:** metadata, permisos, pagos, claims, screenshots, firma, rollout, rechazo.

**Puede bloquear:** envío a stores sin cumplimiento o pruebas.

## Comité 6 — Customer Success

### 41 — Customer Success Manager

**Interviene cuando:** hay onboarding, QBR, feedback, adopción, confianza, escalados o comunicación a usuarios/clientes.

**Revisa siempre:** valor, expectativas, fricción, compromisos, seguimiento, confianza.

**Puede bloquear/escalar:** promesas de roadmap o crisis de confianza.

### 42 — Analista de Customer Success

**Interviene cuando:** hay health score, cohortes, churn, NPS/CSAT, tickets, métricas CS o segmentación.

**Revisa siempre:** fuente, calidad, cohorte, sesgo, causalidad, privacidad.

**Puede bloquear:** conclusiones sin datos o uso indebido de datos sensibles.

### 43 — Especialista en Retención y Expansión

**Interviene cuando:** hay churn, renovación, expansión, campañas, ofertas, cancelación, win-back o guardrails.

**Revisa siempre:** valor, segmento, ética, opt-out, salida, métricas de daño, privacidad.

**Puede bloquear:** campaña manipulativa o expansión sin valor.

## Activación rápida por tema

| Tema | Agentes mínimos |
|---|---|
| Nueva feature | 02, 05, 06, 13, 34 |
| Pantalla Flutter | 02, 06, 07, 09, 14, 29, 30, 34 |
| Chat/Stasis | 02, 08, 16, 20, 21, 22, 26, 34 |
| Memoria | 16, 18, 19, 25, 26, 32, 34, 39 |
| Investigaciones | 16, 19, 20, 22, 25, 26, 34 |
| API/Backend | 13, 15, 18, 32, 34, 35, 38 |
| Supabase/RLS | 15, 18, 19, 32, 34, 38 |
| MCP | 13, 16, 17, 26, 35, 38 |
| Stasis Engine | 13, 15, 16, 17, 19, 20, 22, 27 |
| Pagos | 02, 15, 18, 32, 33, 34, 38, 40 |
| Release stores | 02, 07, 18, 34, 35, 38, 40 |
| Seguridad | 18, 26, 32, 38, 39 |
| Costes IA | 20, 27, 36 |
| Customer Success | 41, 42, 43, 02, 12 |
| Auditoría de código | 01, 05, 13, 14, 15, 29, 32, 34 |
| Refactor | 01, 05, 13, 14/15 según área, 34 |
| ADR | 01, 04, 05, 13, agentes especialistas afectados |

## Activación rápida por comité

| Comité | Usar cuando |
|---|---|
| Comité 1 | Dirección, fase, alcance, contradicciones, gates, cliente |
| Comité 2 | Producto, UX, UI, conversación, accesibilidad, métricas |
| Comité 3 | Arquitectura, backend, Flutter, MCP, datos, memoria, seguridad |
| Comité 4 | LLMs, prompts, agentes, recomendaciones, testing LLM, costes IA |
| Comité 5 | Implementación, QA, Supabase, pagos, DevOps, release, AppSec |
| Comité 6 | Onboarding, feedback, QBR, churn, retención, expansión |

## Reglas de escalado

Escalar al Director de Proyecto cuando:

- hay bloqueo entre comités;
- falta decisión del cliente;
- hay contradicción crítica;
- hay cambio de alcance;
- hay riesgo severo;
- hay refactor grande;
- hay coste importante;
- hay impacto en release.

Escalar al Product Owner cuando:

- cambia valor;
- cambia MVP;
- cambia roadmap;
- cambia monetización;
- afecta al usuario;
- afecta a prioridad.

Escalar al Revisor de Coherencia cuando:

- hay documentos contradictorios;
- código y docs no coinciden;
- algo conceptual se presenta como real;
- hay mock no declarado;
- hay fase dudosa.

## Definición de uso correcto

El índice se usa correctamente cuando Codex puede responder:

- qué agentes hacen falta;
- por qué hacen falta;
- qué revisa cada uno;
- qué comité gobierna;
- qué riesgos son bloqueantes;
- qué decisión se solicita;
- qué siguiente paso es seguro.

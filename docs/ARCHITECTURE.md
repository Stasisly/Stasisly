# Arquitectura de Stasisly

## Estado del documento

Documento de arquitectura actualizado para Stasisly.

Este documento describe la arquitectura objetivo y las reglas arquitectónicas
vigentes. No afirma que todas las capacidades estén implementadas actualmente.
Antes de modificar código, Codex/Antigravity debe auditar el estado real del
repositorio y diferenciar entre:

- existente y verificado;
- existente no auditado;
- definido conceptualmente;
- decisión aprobada;
- recomendado para futuro;
- mock, demo o provisional.

## 1. Resumen arquitectónico

Stasisly sigue una arquitectura por capas basada en:

- Arquitectura Hexagonal, también conocida como Ports and Adapters.
- Clean Architecture.
- MVVM en la capa de presentación Flutter.
- Riverpod para inyección de dependencias y estado reactivo.
- Supabase como infraestructura base del MVP cuando aplique.
- API propia o capa backend controlada como frontera operativa del producto.
- Stasis Engine como subsistema de orquestación inteligente.
- MCP Server como interfaz futura o interna para agentes IA, Codex/Antigravity,
  herramientas e integraciones autorizadas.

La arquitectura debe permitir que Stasisly evolucione de forma progresiva,
segura y verificable, evitando tanto la improvisación como la sobreingeniería
prematura.

## 2. Principios fundamentales

1. **Stasis como sistema nervioso central**\
   Stasis coordina áreas, agentes, memoria e investigaciones.

2. **Separación de responsabilidades**\
   Cada capa y subsistema tiene una responsabilidad clara.

3. **Regla de dependencia**\
   Las dependencias apuntan hacia el dominio, no hacia frameworks, proveedores o
   UI.

4. **Frontera backend controlada**\
   Flutter no debe contener lógica sensible crítica ni secretos.

5. **MCP no sustituye a la API**\
   MCP sirve a agentes y herramientas, no a la operación principal de la app.

6. **Stasis Engine no es un entorno**\
   Es un subsistema de orquestación inteligente.

7. **Memoria federada**\
   La memoria se organiza por niveles con procedencia, permisos, caducidad,
   corrección, borrado, versionado y auditoría.

8. **Investigaciones trazables**\
   Toda investigación debe registrar participantes, fuentes, aportaciones
   relevantes, conflictos, conclusión y ruta de decisión.

9. **Seguridad y privacidad desde diseño**\
   RLS, autorización, minimización, cifrado, gestión de claves, auditoría y
   privacidad se consideran desde el inicio.

10. **Cambios pequeños, reversibles y verificables**\
    Todo cambio debe tener alcance, pruebas, rollback y evidencia.

## 3. Contexto de producto

Stasisly se articula alrededor de Stasis como sistema nervioso central.

Las áreas principales son:

- Home/Stasis.
- Salud.
- Nutrición.
- Entrenamiento.
- Wellness.
- Panel Admin.

La jerarquía funcional es:

- Stasis.
- Jefes de rama.
- Jefes de subcategoría.
- Especialistas.

La memoria es federada por niveles:

- memoria de especialista;
- memoria de subcategoría;
- memoria de rama;
- memoria global de Stasis;
- memoria de investigaciones.

Las investigaciones pueden ser:

- rápidas;
- profundas;
- estratégicas.

El usuario debe poder ver quién participó en una conclusión y abrir la
investigación interna que explica cómo se llegó a ella, sin exponer secretos,
datos de terceros ni razonamiento interno sensible.

## 4. Vista general de arquitectura

```text
Flutter App / Panel Admin
        |
        v
API propia / Capa backend controlada
        |
        +--> Supabase / Postgres / Auth / RLS / Storage / Realtime
        +--> Edge Functions / funciones backend
        +--> Stasis Engine
        +--> Proveedores LLM
        +--> Pagos y webhooks
        +--> Procesamiento de archivos
        +--> Logs, auditoría y observabilidad


Codex / Antigravity / Agentes IA / Integraciones autorizadas
        |
        v
MCP Server
        |
        +--> Documentación / ADRs
        +--> Repositorio
        +--> API autorizada
        +--> Logs / métricas / tests / herramientas internas
```

## 5. Capas Flutter

### 5.1 Domain

La capa de dominio es el núcleo de la aplicación.

No debe depender de:

- Flutter;
- Supabase;
- JSON;
- HTTP;
- SharedPreferences;
- filesystem;
- providers concretos;
- UI.

Contiene:

- entidades;
- value objects si aplica;
- interfaces de repositorio;
- casos de uso;
- reglas de negocio puras;
- failures de dominio cuando proceda.

Ejemplos:

```text
features/<feature>/domain/entities/
features/<feature>/domain/repositories/
features/<feature>/domain/usecases/
```

### 5.2 Data / Infrastructure

La capa de datos implementa los puertos definidos por dominio.

Contiene:

- models;
- DTOs;
- mappers;
- datasources;
- repository adapters;
- llamadas a Supabase;
- llamadas a API/backend;
- acceso a storage local autorizado;
- parsing y serialización.

Los datasources pueden lanzar excepciones controladas. Los repositorios deben
convertir errores técnicos en failures o resultados esperados por dominio.

### 5.3 Presentation

La capa de presentación usa Flutter, Riverpod y MVVM.

Contiene:

- pages;
- widgets;
- controllers;
- view models;
- notifiers;
- estados de UI;
- navegación con `go_router`.

La UI no debe:

- conocer Supabase directamente si la operación es sensible;
- contener lógica de negocio;
- gestionar secretos;
- asumir permisos sin backend/RLS;
- interpretar resultados LLM sin contrato.

### 5.4 Core / Shared

La capa core contiene elementos compartidos:

- theme;
- colores;
- tipografía;
- spacing;
- errores;
- configuración;
- constantes;
- helpers;
- tipos comunes;
- contratos compartidos;
- utilidades de seguridad no sensibles.

## 6. Patrón de dependencias

Flujo recomendado:

```text
UI / Page
  -> ViewModel / Controller
  -> Use Case
  -> Repository Port
  -> Repository Adapter
  -> DataSource
  -> API / Supabase / Storage / Servicio externo
```

Reglas:

- Presentation depende de Domain.
- Data implementa Domain.
- Domain no depende de Data.
- Domain no depende de Flutter.
- Infrastructure no debe contaminar dominio.
- Riverpod inyecta dependencias.
- Los providers no deben convertirse en lógica de negocio.

## 7. Riverpod

Riverpod se usa para:

- inyección de dependencias;
- estado reactivo;
- providers de repositorios;
- providers de use cases;
- controllers/notifiers;
- composición de features.

Reglas:

- Providers deben tener responsabilidades claras.
- No crear providers globales opacos para todo.
- No meter lógica sensible en providers de UI.
- No duplicar estado sin necesidad.
- No acceder a Supabase directamente desde widgets para operaciones sensibles.
- Providers críticos deben tener pruebas cuando aplique.

## 8. Manejo de errores

El manejo de errores debe ser explícito.

Patrones aceptados:

- `Either<Failure, T>` cuando ya exista esa convención.
- Result types equivalentes si se aprueban.
- Exceptions solo en capas externas y controladas.
- Failures o estados de error hacia dominio/presentación.

Reglas:

- La UI no debe recibir excepciones crudas.
- Los errores deben tener mensaje seguro para usuario.
- Los logs no deben exponer secretos ni datos sensibles.
- Los errores de permisos deben diferenciarse de errores de red o servidor.
- Las operaciones sensibles deben auditar fallos relevantes.

## 9. API propia / capa backend controlada

Stasisly tendrá una API propia o capa backend controlada.

En el MVP, “API propia” significa frontera backend controlada. Puede estar
implementada mediante Supabase, RLS, Edge Functions y contratos documentados. No
implica obligatoriamente desplegar un backend independiente desde el día uno.

Responsabilidades:

- reglas de negocio sensibles;
- autorización;
- validación;
- auditoría;
- gestión de chats;
- gestión de agentes;
- memoria federada;
- investigaciones;
- pagos y webhooks;
- llamadas LLM;
- control de costes IA;
- operaciones administrativas;
- procesamiento de archivos;
- observabilidad;
- errores e idempotencia.

Flutter debe usar esta frontera para funciones esenciales.

## 10. Supabase

Supabase puede aportar:

- Postgres;
- Auth si se aprueba;
- RLS;
- Storage;
- Realtime;
- funciones SQL;
- Edge Functions;
- logs/operación según capacidades.

Reglas:

- Toda tabla sensible requiere RLS.
- Toda política RLS debe ser auditada.
- No confiar en validaciones del cliente.
- Edge Functions deben tener contratos, owner y pruebas.
- Webhooks de pago deben ser idempotentes.
- Datos sensibles deben minimizarse.
- Storage debe tener permisos explícitos.
- Panel Admin debe operar bajo roles y auditoría.

## 11. Stasis Engine

Stasis Engine es el subsistema de orquestación inteligente.

Responsabilidades:

- coordinar Stasis;
- coordinar jefes de rama;
- coordinar jefes de subcategoría;
- coordinar especialistas;
- seleccionar participantes;
- ejecutar investigaciones;
- gestionar handoffs;
- aplicar memoria federada;
- coordinar llamadas LLM;
- aplicar límites de coste, tokens, tiempo y participantes;
- detectar conflictos e incertidumbre;
- generar resultados visibles;
- producir auditoría.

No debe:

- tener acceso irrestricto a toda memoria;
- saltarse permisos;
- sustituir autorización determinista;
- ocultar participantes;
- usar herramientas sin contrato;
- exponer razonamiento interno sensible.

## 12. MCP Server

MCP Server no sustituye a la API.

Sirve para:

- agentes IA;
- Codex/Antigravity;
- herramientas internas;
- automatizaciones;
- integraciones autorizadas.

Puede permitir:

- consultar documentación;
- consultar ADRs;
- consultar estado del repositorio;
- ejecutar tests controlados;
- consultar logs/métricas autorizados;
- llamar a API autorizada con identidad propia.

No debe:

- ser dependencia funcional de Flutter;
- saltarse RLS/autorización;
- exponer secretos;
- ejecutar acciones destructivas sin aprobación;
- escribir memoria/investigaciones sin contrato;
- convertirse en API de producto.

## 13. Memoria federada

Cada memoria debe tener:

- nivel;
- propósito;
- propietario;
- procedencia;
- permisos;
- sensibilidad;
- caducidad;
- versión;
- auditoría;
- mecanismo de corrección;
- mecanismo de borrado.

La promoción entre niveles no debe ser automática salvo regla aprobada y
auditable.

No se debe crear memoria global indiscriminada.

## 14. Investigaciones

Cada investigación debe registrar:

- tipo;
- objetivo;
- participantes;
- fuentes;
- aportaciones relevantes;
- conflictos;
- conclusión;
- nivel de confianza;
- ruta de decisión;
- limitaciones;
- fecha;
- owner.

Tipos:

- rápida: 1-3 especialistas, problema concreto;
- profunda: varias subcategorías o áreas;
- estratégica: revisión amplia mensual, trimestral o bajo demanda.

El usuario debe poder abrir la investigación y entender cómo se llegó a la
conclusión sin ver secretos ni razonamiento interno sensible.

## 15. Seguridad y privacidad

Controles obligatorios según alcance:

- autenticación;
- autorización;
- RLS;
- validación;
- cifrado en tránsito;
- cifrado en reposo;
- cifrado de campos sensibles cuando aplique;
- gestión de claves;
- secretos;
- auditoría;
- logs seguros;
- consentimiento;
- retención;
- borrado;
- threat model;
- protección contra prompt injection;
- protección contra tool abuse;
- control de exfiltración.

La decisión conceptual aprobada, pendiente de auditoría técnica e
implementación, es no usar un modo separado tipo “secret chats” para el
flujo principal. En su lugar:

- cifrado fuerte en tránsito y reposo;
- RLS estricta;
- cifrado de columnas sensibles;
- separación de claves cuando aplique;
- auditoría;
- consentimiento;
- corrección y borrado de memoria;
- clasificación de sensibilidad;
- protección contra prompt injection;
- respuesta a incidentes.

## 16. Pagos y membresías

Reglas arquitectónicas:

- Web: Stripe Billing + Customer Portal + trial de 7 días si se mantiene la
  decisión de producto.
- iOS: Apple IAP si se venden bienes digitales dentro de la app.
- Android: Google Play Billing si se venden bienes digitales dentro de la app.
- Backend normaliza estados de membresía.
- Webhooks deben ser idempotentes.
- Entitlements no deben depender solo del cliente.
- Estados de pago deben auditarse.
- Panel Admin no debe alterar membresías sin permisos y auditoría.

## 17. Archivos y procesamiento

El procesamiento de archivos puede requerir workers, Docker o servicios
especializados.

Reglas:

- No guardar originales sensibles más de lo necesario.
- Validar tipo y tamaño.
- Escanear riesgos cuando aplique.
- Extraer datos con trazabilidad.
- Guardar solo información necesaria.
- Cifrar datos sensibles.
- Registrar procedencia.
- Permitir borrado.
- No procesar archivos sensibles solo en cliente si requiere
  seguridad/auditoría.

Docker puede ser útil para procesamiento reproducible. Kubernetes no es MVP
salvo driver real.

## 18. Observabilidad

Debe existir observabilidad para:

- errores;
- latencia;
- costes IA;
- tokens;
- tool calls;
- investigaciones;
- memoria;
- permisos denegados;
- pagos/webhooks;
- seguridad;
- rendimiento;
- releases.

No deben registrarse innecesariamente:

- secretos;
- claves;
- tokens;
- chats completos;
- memoria completa;
- datos sensibles sin protección.

## 19. Entornos

Entornos recomendados:

- local;
- development;
- staging;
- production.

Stasis Engine no es un entorno.

DevOps/Infra/Release Engineering es owner de entornos.

El Product Owner lidera roadmap/fases; el Director de Proyecto ordena ejecución;
Arquitectura valida viabilidad.

## 20. Publicación

La arquitectura debe permitir publicación en:

- App Store;
- Google Play;
- Web si aplica.

Requiere:

- builds reproducibles;
- firmas;
- certificados;
- privacy labels;
- Data Safety;
- screenshots veraces;
- release notes;
- TestFlight;
- Google Play Internal Testing;
- QA;
- rollback/stop rollout;
- observabilidad post-release.

## 21. Calidad y pruebas

Tipos de pruebas según alcance:

- unit tests;
- widget tests;
- integration tests;
- golden tests cuando aplique;
- contract tests;
- tests de RLS;
- tests de Edge Functions;
- tests de pagos/webhooks;
- tests de seguridad;
- tests de LLMs;
- tests de regresión;
- pruebas manuales documentadas.

No debe prometerse 100% cobertura como dogma si no hay plan realista, pero sí
deben definirse pruebas suficientes para el riesgo.

## 22. Evolución por fases

### MVP

- Flutter con arquitectura limpia.
- API/capa backend mínima.
- Supabase/RLS/Edge Functions cuando aplique.
- Stasis Engine parcial.
- Chats/catálogo inicial.
- Investigaciones iniciales con participantes visibles.
- Membresía básica.
- Panel Admin básico.
- Auditoría base.
- Sin MCP productivo obligatorio.
- Sin Kubernetes salvo driver.
- Sin blockchain.
- Sin cripto pagos.

### Fase 2

- Memoria federada real.
- Investigaciones más robustas.
- Costes IA y observabilidad ampliados.
- Procesamiento de archivos avanzado.
- Herramientas MCP controladas si hay necesidad.
- Mejor separación interna de Stasis Engine.

### Fase 3

- Stasis Engine como servicio independiente si hay drivers.
- Orquestación multiagente avanzada.
- Investigaciones estratégicas.
- Integraciones externas.
- MCP Server productivo si hay caso aprobado.

### Futuro

- Blockchain solo si aporta valor verificable y nunca para datos sensibles.
- Pagos cripto solo con proveedor regulado.
- Ecosistema de herramientas avanzado.

## 23. Reglas para Codex / Antigravity

Antes de modificar arquitectura o código, Codex debe declarar:

- objetivo;
- fase;
- estado real auditado;
- archivos permitidos;
- archivos prohibidos;
- decisión aprobada;
- revisores requeridos;
- pruebas;
- rollback;
- riesgos.

Codex no puede:

- inventar archivos, providers, rutas, modelos o tablas;
- tocar `lib/`, `supabase/`, `android/`, `ios/`, `web/` o configuración sin
  alcance;
- mover lógica sensible a Flutter;
- convertir MCP en API;
- saltarse RLS;
- desactivar seguridad;
- hacer refactors grandes de golpe;
- declarar mocks como producción;
- ejecutar migraciones sin aprobación;
- tocar pagos, secretos, CI/CD o stores sin revisión.

## 24. Criterios de aceptación arquitectónica

Una propuesta arquitectónica es aceptable si:

- responde a un problema real;
- indica fase;
- define límites;
- define contratos;
- protege datos sensibles;
- respeta memoria federada;
- conserva trazabilidad de investigaciones;
- evita sobreingeniería;
- permite pruebas;
- permite rollback;
- tiene owner;
- documenta riesgos;
- no contradice ADRs vigentes.

### Gates de estabilización e identidad vigentes

El Paquete 1 definido en ADR-005 ha sido implementado, verificado y cerrado. El
modo demo explícito permanece como base segura.

Antes de restaurar autenticación, conectar Supabase/backend real, implementar
RLS o usar datos reales, debe revisarse y aprobarse la propuesta de identidad,
autorización y RLS definida en:

```text
docs/stasisly_definition/adr/ADR-006-identidad-autorizacion-rls.md
```

Hasta aprobar e implementar un alcance específico posterior, el estado se
mantiene como prototipo/demo. ADR-006 propuesto no autoriza auth, Supabase,
migraciones, RLS, backend real, producción ni datos reales.

## 25. Relación con documentos

Documentos relacionados:

```text
docs/stasisly_definition/00_DEVELOPMENT_TEAM.md
docs/stasisly_definition/10_API_MCP_STASIS_ENGINE.md
docs/stasisly_definition/agents/
docs/stasisly_definition/committees/
docs/stasisly_definition/adr/
docs/stasisly_definition/orchestrator/
docs/SESSION_TRACKER.md
docs/archive/
```

Jerarquía normativa:

1. Los ADRs aceptados tienen prioridad para decisiones arquitectónicas.
2. `PROJECT_DEFINITION.md` y `ARCHITECTURE.md` definen producto y arquitectura.
3. `docs/stasisly_definition/` desarrolla definiciones especializadas.
4. `agents/` y `committees/` definen roles y revisión cruzada.
5. `orchestrator/` define el uso operativo de las fuentes anteriores.
6. `SESSION_TRACKER.md` es histórico informativo y no prueba estado técnico sin
   auditoría.
7. `archive/` es material histórico no ejecutable.

Este documento debe mantenerse alineado con:

- definición de producto;
- prompts de agentes;
- comités;
- ADR-001, ADR-002, ADR-003, ADR-004 y ADR-005 aceptados;
- ADR-006 propuesto, pendiente de aprobación;
- auditoría real del código.

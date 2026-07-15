# API propia, MCP Server y Stasis Engine

## Estado del documento

Decisión aceptada conceptualmente y pendiente de auditoría técnica,
especificación detallada e implementación.

Este documento define una dirección arquitectónica para Stasisly. No afirma que
la API propia, el MCP Server o Stasis Engine estén implementados actualmente.

Este documento complementa el ADR formal:

```text
adr/ADR-001-api-propia-mcp-stasis-engine.md
```

Diferencia:

- Este documento explica la definición amplia, fronteras, responsabilidades y
  evolución.
- El ADR registra la decisión arquitectónica formal y su trazabilidad.

## 1. Propósito

Definir las responsabilidades y fronteras conceptuales entre:

- la API propia o capa backend controlada de Stasisly;
- el MCP Server para agentes IA, herramientas internas e integraciones;
- Stasis Engine como subsistema de orquestación inteligente;
- Supabase y otros proveedores de infraestructura;
- Flutter App y Panel Admin;
- Codex/Antigravity como herramientas de asistencia.

La separación busca que Stasisly pueda operar como producto real con usuarios,
datos sensibles, pagos, memorias, investigaciones, auditoría y administración
sin trasladar lógica crítica a Flutter ni convertir MCP en una dependencia
operativa de la aplicación.

## 2. Contexto de Stasisly

Stasis actúa como sistema nervioso central de una aplicación organizada en:

- Home/Stasis;
- Salud;
- Nutrición;
- Entrenamiento;
- Wellness;
- Panel Admin.

Stasis coordina una jerarquía formada por:

- jefes de rama;
- jefes de subcategoría;
- especialistas.

También coordina:

- memoria federada;
- investigaciones rápidas;
- investigaciones profundas;
- investigaciones estratégicas.

La plataforma deberá gestionar:

- usuarios;
- sesiones;
- permisos;
- chats;
- mensajes;
- agentes;
- catálogo;
- memorias;
- investigaciones;
- participantes;
- fuentes;
- pagos;
- membresías;
- archivos;
- logs;
- auditoría;
- seguridad;
- administración;
- costes IA;
- observabilidad.

Estas responsabilidades requieren una frontera operativa controlada y no deben
depender únicamente del cliente Flutter.

## 3. Decisión conceptual

Stasisly tendrá una **API propia o capa backend propia**.

El **MCP Server no sustituirá a la API**.

La API será la interfaz operativa utilizada para ejecutar la lógica de negocio
real de la aplicación.

El MCP Server será una interfaz especializada para agentes IA, herramientas de
desarrollo, automatizaciones e integraciones controladas.

Stasis Engine será el subsistema responsable de la orquestación inteligente de
Stasis.

En el MVP, Stasis Engine puede formar parte de la capa backend basada en
Supabase y Edge Functions. En fases posteriores podrá evolucionar hacia un
servicio más independiente si la complejidad, escala, seguridad, observabilidad
o coste lo justifican.

Frase normativa:

> En el MVP, “API propia” significa frontera backend controlada. Puede estar
> implementada mediante Supabase, RLS, Edge Functions y contratos documentados.
> No implica obligatoriamente desplegar un backend independiente desde el día
> uno.

## 4. Fronteras esenciales

### Flutter App / Panel Admin

Flutter y Panel Admin son clientes del producto.

Deben:

- renderizar interfaz;
- gestionar estado de cliente;
- invocar contratos autorizados;
- mostrar resultados;
- tratar errores;
- respetar permisos;
- no contener secretos;
- no contener lógica sensible crítica;
- no saltarse API/RLS;
- no depender de MCP.

### API propia / capa backend

La API o capa backend es la frontera operativa del producto.

Debe:

- aplicar reglas de negocio;
- validar identidad;
- validar autorización;
- proteger datos;
- coordinar operaciones sensibles;
- ejecutar lógica que no debe vivir en Flutter;
- auditar;
- exponer contratos estables;
- controlar costes;
- coordinar proveedores;
- ejecutar Stasis Engine parcial o totalmente según fase.

### Supabase

Supabase puede ser infraestructura y parte de la capa backend MVP.

Puede aportar:

- Postgres;
- Auth si se aprueba;
- RLS;
- Storage;
- Realtime;
- funciones SQL;
- Edge Functions;
- logs/operación según capacidades.

Supabase no elimina la necesidad de definir contratos, permisos, RLS, auditoría,
límites y responsabilidades.

### Stasis Engine

Stasis Engine es el subsistema de orquestación inteligente.

No es un entorno.

Puede vivir inicialmente dentro de la capa backend/Supabase/Edge Functions si el
MVP lo permite.

Debe evolucionar solo con drivers técnicos reales.

### MCP Server

MCP Server es interfaz de herramientas para agentes IA, Codex/Antigravity e
integraciones autorizadas.

No es API de producto.

No debe ser dependencia operativa de Flutter.

### Codex / Antigravity

Codex y Antigravity son herramientas de asistencia y ejecución.

No son autoridad de producto, arquitectura, seguridad, datos o release.

Deben operar bajo alcance, permisos, archivos permitidos, pruebas y revisión.

## 5. API propia frente a MCP Server

### API propia o capa backend

La API existe para que el producto funcione de forma segura y consistente.

```text
Flutter App / Panel Admin / Servicios autorizados
    |
    v
Stasisly API / Backend controlado
    |
    +--> Supabase / Postgres / Auth / RLS / Realtime
    +--> Storage y procesamiento de archivos
    +--> Proveedores LLM
    +--> Pagos y webhooks
    +--> Stasis Engine
    +--> Logs, auditoría y observabilidad
```

### MCP Server

El MCP Server existe para que agentes IA y herramientas autorizadas puedan
interactuar con recursos internos o externos mediante capacidades explícitas,
limitadas y auditables.

```text
Codex / Antigravity / Agentes IA / Integraciones autorizadas
    |
    v
MCP Server
    |
    +--> Documentación y ADRs
    +--> Repositorio y estado del proyecto
    +--> API interna autorizada
    +--> Logs, métricas, tests y herramientas internas
```

### Diferencia esencial

| Aspecto          | API propia / backend                         | MCP Server                                     |
| ---------------- | -------------------------------------------- | ---------------------------------------------- |
| Finalidad        | Operar el producto                           | Exponer herramientas a agentes e integraciones |
| Consumidor       | Flutter, Panel Admin y servicios autorizados | Agentes IA, Codex, Antigravity y herramientas  |
| Responsabilidad  | Lógica de negocio y seguridad operativa      | Ejecución controlada de herramientas           |
| Disponibilidad   | Crítica para la app                          | Dependiente del caso de integración            |
| Contratos        | Estables, versionados, orientados a producto | Herramientas explícitas, permisos mínimos      |
| Datos expuestos  | Mínimos y autorizados                        | Capacidades específicas y auditables           |
| Necesidad en MVP | Sí, al menos como capa backend controlada    | No necesariamente                              |
| Riesgo principal | Diseñarla demasiado tarde o sin contratos    | Usarlo como bypass o sustituto de API          |

## 6. Por qué MCP no sustituye a la API

MCP y API resuelven problemas distintos.

Utilizar MCP como interfaz principal de la aplicación:

- acoplaría Flutter a un protocolo diseñado para herramientas y agentes;
- mezclaría lógica de producto con capacidades de automatización;
- complicaría contratos estables;
- complicaría versionado;
- complicaría disponibilidad y soporte;
- ampliaría superficie de permisos;
- dificultaría separar usuarios, administradores, agentes y herramientas;
- convertiría fallos del MCP Server en fallos funcionales de la app;
- debilitaría la frontera operativa del producto.

Flutter no debe depender del MCP Server para:

- autenticarse;
- consultar datos esenciales;
- enviar chats;
- gestionar membresías;
- ejecutar pagos;
- consultar memoria;
- crear investigaciones;
- ejecutar funciones esenciales.

Los agentes sí podrán utilizar MCP para consultar documentación, métricas, logs,
herramientas o una parte autorizada de la API interna.

## 7. Modelo conceptual recomendado

```text
                         PRODUCTO

Flutter App / Panel Admin / Servicios autorizados
                    |
                    v
         Stasisly API / Backend controlado
                    |
        +-----------+-----------+-----------+
        |           |           |           |
     Supabase    Stasis      Pagos y     Storage /
     y datos     Engine      webhooks     servicios
        |
   RLS / Auth /
   Postgres / Edge Functions


                    HERRAMIENTAS Y AGENTES

Codex / Antigravity / Agentes IA / Integraciones autorizadas
                    |
                    v
                MCP Server
                    |
        +-----------+-----------+-----------+
        |           |           |           |
      Docs y      API       Logs y       Herramientas
       ADRs     autorizada   métricas      internas
```

## 8. Reglas de frontera

- Flutter utiliza la API, no MCP, para operar el producto.
- Panel Admin utiliza contratos autorizados, no accesos indiscriminados.
- MCP solo expone herramientas explícitamente autorizadas.
- MCP puede llamar a la API mediante una identidad y permisos propios.
- La API valida toda autorización aunque la solicitud proceda de MCP.
- Stasis Engine no obtiene acceso irrestricto a datos, herramientas o memoria.
- Toda acción sensible conserva identidad, permisos, procedencia y auditoría.
- Los permisos de usuario, administrador, agente y herramienta son distintos.
- RLS no sustituye diseño de API ni viceversa.
- Edge Functions no son excusa para lógica dispersa sin contrato.
- Codex no puede modificar fronteras sin revisión arquitectónica.

## 9. Papel de Supabase

Supabase puede cubrir una parte relevante de la capa backend mediante:

- Postgres;
- Auth si se aprueba;
- RLS;
- Storage;
- Realtime;
- funciones SQL;
- Edge Functions;
- capacidades operativas disponibles.

Supabase no elimina la necesidad de definir una API o frontera backend propia.

Durante el MVP, esta frontera puede implementarse progresivamente combinando:

- RLS;
- funciones SQL;
- Edge Functions;
- contratos documentados;
- reglas de autorización;
- auditoría;
- pruebas.

La lógica sensible o compleja debe centralizarse en una capa controlada.

Ejemplos:

- permisos y autorización transversal;
- auditoría;
- orquestación de Stasis;
- llamadas a LLMs;
- protección de credenciales;
- procesamiento de PDFs, imágenes y otros archivos;
- control de costes IA;
- memoria federada;
- investigaciones;
- pagos;
- webhooks;
- funciones administrativas.

La distribución exacta entre Postgres, Edge Functions o servicios separados
requiere auditoría técnica posterior.

## 10. Responsabilidades de la API propia

La API o capa backend debe:

- aplicar reglas de negocio;
- aplicar autorización;
- validar entradas;
- validar permisos;
- generar auditoría;
- gestionar usuarios;
- gestionar sesiones;
- gestionar permisos;
- gestionar chats y mensajes;
- gestionar catálogo de agentes;
- gestionar jerarquía de agentes;
- exponer operaciones seguras de memoria federada;
- crear investigaciones;
- ejecutar investigaciones;
- consultar investigaciones;
- auditar investigaciones;
- gestionar participantes;
- gestionar fuentes;
- gestionar resultados;
- gestionar trazabilidad;
- gestionar membresías;
- gestionar entitlement;
- gestionar pagos;
- gestionar webhooks;
- coordinar storage;
- coordinar procesamiento de archivos;
- proteger credenciales;
- proteger llamadas a proveedores LLM;
- aplicar límites de costes IA;
- exponer operaciones administrativas autorizadas;
- producir logs;
- producir auditoría;
- producir señales de observabilidad;
- aplicar idempotencia;
- aplicar recuperación;
- controlar errores.

La API no debe:

- confiar en validaciones del cliente;
- exponer secretos;
- permitir acceso general a memorias;
- permitir acceso general a investigaciones;
- depender de MCP para funciones esenciales;
- mezclar roles de usuario, admin, agente y herramienta;
- ejecutar acciones sensibles sin auditoría.

## 11. Responsabilidades del MCP Server

El MCP Server puede:

- consultar documentación;
- consultar ADRs;
- buscar decisiones;
- buscar requisitos;
- buscar estado documental;
- exponer herramientas controladas para revisar repositorio;
- consultar logs autorizados y minimizados;
- consultar métricas autorizadas;
- lanzar tests en entornos controlados;
- analizar errores;
- asistir mantenimiento;
- interactuar con operaciones autorizadas de la API interna;
- facilitar integraciones futuras con agentes y sistemas externos.

El MCP Server no debe:

- sustituir la API;
- saltarse autorización;
- saltarse RLS;
- exponer secretos;
- permitir acciones destructivas sin aprobación;
- escribir en memoria sin contrato;
- escribir en investigaciones sin contrato;
- ejecutar herramientas sin permisos;
- ocultar identidad;
- operar sin auditoría;
- convertirse en dependencia crítica de Flutter.

## 12. Responsabilidades de Stasis Engine

Stasis Engine será responsable de:

- coordinar Stasis;
- coordinar jefes de rama;
- coordinar jefes de subcategoría;
- coordinar especialistas;
- seleccionar participantes según investigación y permisos;
- ejecutar investigaciones rápidas;
- ejecutar investigaciones profundas;
- ejecutar investigaciones estratégicas;
- gestionar handoffs;
- gestionar comunicación entre ramas mediante Stasis;
- aplicar protocolos de memoria federada;
- crear resúmenes;
- proponer promoción de memoria;
- coordinar llamadas LLM;
- coordinar herramientas autorizadas;
- aplicar límites de tiempo;
- aplicar límites de coste;
- aplicar límites de tokens;
- aplicar límites de participantes;
- detectar conflictos;
- detectar incertidumbre;
- detectar ausencia de evidencia;
- mantener trazabilidad;
- generar resultados visibles y explicables;
- producir auditoría.

Stasis Engine no debe:

- tener acceso irrestricto a memorias;
- promover información sin reglas aprobadas;
- ejecutar herramientas sin permisos;
- ocultar participantes;
- ocultar fuentes;
- sustituir autorización determinista;
- sustituir controles de pagos;
- sustituir controles de seguridad;
- exponer razonamiento interno sensible;
- convertir hipótesis en conclusión;
- usar MCP como bypass.

## 13. Identidades y permisos

Deben diferenciarse identidades de:

- usuario final;
- administrador;
- sistema backend;
- Stasis Engine;
- agente IA;
- herramienta MCP;
- Codex/Antigravity;
- worker;
- proveedor externo.

Cada identidad debe tener:

- propósito;
- permisos mínimos;
- trazabilidad;
- auditoría;
- caducidad si aplica;
- rotación si aplica;
- owner.

Ninguna identidad técnica debe tener acceso total por comodidad.

## 14. Datos, memoria e investigaciones

La frontera API/MCP/Stasis Engine debe respetar:

- minimización;
- propósito;
- procedencia;
- sensibilidad;
- permisos;
- caducidad;
- versionado;
- corrección;
- borrado;
- auditoría.

La memoria federada no debe convertirse en memoria global indiscriminada.

Las investigaciones deben registrar:

- tipo;
- participantes;
- fuentes;
- aportaciones relevantes;
- conflictos;
- conclusión;
- ruta de decisión;
- nivel de confianza.

Transparencia no significa exponer secretos, prompts internos sensibles ni
razonamiento privado.

## 15. Seguridad y privacidad

Deben existir controles para:

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
- privacidad;
- consentimiento;
- retención;
- borrado;
- threat model;
- prompt injection;
- tool abuse;
- exfiltración.

MCP, API y Stasis Engine deben tener límites de confianza explícitos.

## 16. Observabilidad y costes

La arquitectura debe permitir observar:

- errores;
- latencia;
- coste IA;
- tokens;
- llamadas LLM;
- tool calls;
- investigaciones;
- fallos de memoria;
- permisos denegados;
- webhooks;
- pagos;
- incidencias de seguridad;
- degradación de rendimiento.

Debe evitar logs con:

- secretos;
- datos sensibles innecesarios;
- chats completos sin necesidad;
- memoria completa sin protección;
- tokens;
- claves.

## 17. Evolución recomendada por fases

### MVP

- API mínima o capa backend controlada.
- Supabase, RLS y Edge Functions donde resulte adecuado.
- Lógica sensible fuera de Flutter.
- Contratos documentados.
- Chats básicos.
- Catálogo inicial de agentes.
- Inicio de investigaciones con participantes visibles.
- Estado de membresía y entitlement básico.
- Panel Admin básico con acciones auditadas.
- Logs y auditoría base.
- Primera versión parcial de Stasis Engine dentro de la capa backend.
- Sin dependencia operativa de un MCP Server de producción.

### Fase 2

- API más robusta para investigaciones.
- Memoria federada con promoción, caducidad, corrección y borrado.
- Mayor separación interna de Stasis Engine.
- Procesamiento de archivos más avanzado.
- Control de costes IA.
- Observabilidad ampliada.
- Contratos preparados para herramientas MCP controladas.
- Evaluación de MCP interno si existe necesidad.

### Fase 3

- Evaluación de Stasis Engine como servicio independiente.
- Orquestación multiagente avanzada.
- Investigaciones estratégicas más completas.
- Resiliencia reforzada.
- Escalado reforzado.
- Aislamiento reforzado.
- Integraciones externas.
- MCP Server si existe necesidad aprobada.

### Futuro

- MCP Server de producción para integraciones externas autorizadas.
- Ecosistema de herramientas con permisos granulares.
- Blockchain solo si aporta valor verificable y nunca para datos sensibles.
- Pagos cripto solo mediante proveedor regulado y tras revisión especializada.

## 18. Riesgos si no se separan API y MCP

- Dependencia de Flutter respecto a herramientas para agentes.
- Superficie de ataque amplia.
- Permisos innecesariamente amplios.
- Mezcla de lógica de negocio, automatización y desarrollo.
- Dificultad para versionar contratos de producto.
- Ausencia de una fuente clara de autorización.
- Ausencia de auditoría clara.
- Caídas de la aplicación por fallos en herramientas MCP.
- Acceso excesivo de agentes a datos.
- Acceso excesivo de agentes a funciones.
- Mayor dificultad para cumplir privacidad.
- Mayor dificultad para cumplir stores.
- Mayor riesgo de prompt injection con impacto operativo.

## 19. Riesgos del modelo recomendado

- Introduce una capa adicional que debe operarse correctamente.
- Exige disciplina en contratos.
- Exige disciplina en identidades.
- Exige disciplina en permisos.
- Puede generar duplicación si las fronteras no se documentan.
- Stasis Engine podría separarse prematuramente.
- MCP puede ampliar la superficie de ataque si se publica sin necesidad.
- Una separación excesiva en el MVP produciría sobreingeniería.
- Una separación excesiva en el MVP aumentaría coste.

La mitigación es una evolución progresiva: frontera backend clara desde el MVP,
implementación mínima y separación física solo con drivers verificados.

## 20. Señales de que hay que separar más

Se puede considerar separar Stasis Engine o crear MCP productivo si aparecen
drivers reales como:

- aumento de complejidad multiagente;
- necesidad de aislamiento fuerte;
- latencia o carga no manejable;
- coste IA que requiere control avanzado;
- necesidad de escalado independiente;
- riesgo de seguridad que exige separación;
- integraciones externas aprobadas;
- herramientas internas estables;
- necesidad de permisos granulares para agentes;
- auditoría avanzada;
- operación del equipo que justifique MCP.

Sin estos drivers, separar por estética arquitectónica es sobreingeniería.

## 21. Agentes responsables

### Responsables principales

- Arquitecto Principal.
- Arquitecto Backend.
- Arquitecto Multiagente.
- Especialista MCP.

### Revisión obligatoria

- Especialista en Seguridad y Privacidad.
- Especialista AppSec / Ciberseguridad.
- Especialista en Datos y Memoria.
- Especialista en Costes IA y Optimización de Tokens.
- Backend/Supabase Developer.
- DevOps / Infraestructura / Release Engineering.
- QA Engineer.
- Revisor de Coherencia del Producto.
- Product Owner.

### Revisores condicionales

- Criptografía Aplicada y Gestión de Claves si hay cifrado, claves o secretos.
- Testing de LLMs si afecta comportamiento de agentes.
- Seguridad LLM / Prompt Injection si hay tool use, MCP o fuentes externas.
- Observabilidad si afecta logs, métricas o trazabilidad.
- Membresías y Pagos si afecta pagos/entitlements.
- App Store / Play Store si afecta stores.
- Customer Success si afecta confianza, soporte o adopción.

## 22. Decisiones pendientes

- Responsabilidades exactas de la API mínima del MVP.
- Si la API inicial será Supabase/Edge Functions o incluirá otro servicio.
- Identidad, autorización y versionado de consumidores.
- Componentes de Stasis Engine incluidos en el MVP.
- Modelo de investigaciones, participantes y trazabilidad.
- Modelo de memoria federada.
- Operaciones administrativas iniciales.
- Proveedores LLM.
- Proveedores de pagos.
- Procesamiento de archivos.
- Necesidad real y alcance de un MCP Server de producción.
- Herramientas MCP permitidas.
- Identidades de herramientas MCP.
- SLOs.
- Presupuestos de costes.
- Políticas de retención.
- Auditoría de estado real del código.

## 23. Condiciones para avanzar a implementación

Antes de implementar debe existir:

- auditoría del estado técnico real;
- definición y aprobación del alcance MVP;
- modelo de autorización;
- modelo de datos;
- contratos iniciales de API;
- decisión sobre responsabilidades de Supabase y Edge Functions;
- threat model;
- estrategia de pruebas;
- estrategia de observabilidad;
- estrategia de rollback;
- revisión de seguridad y privacidad;
- revisión de costes IA;
- aprobación explícita del cliente.

## 24. Criterios de aceptación

Una implementación MVP alineada con este documento debe demostrar:

- Flutter no contiene secretos.
- Flutter no contiene lógica sensible crítica.
- Flutter no depende de MCP.
- Existe frontera backend documentada.
- Operaciones sensibles pasan por contratos controlados.
- RLS o autorización equivalente está definida y probada.
- Edge Functions o funciones backend tienen owner y pruebas.
- Stasis Engine MVP tiene responsabilidades explícitas.
- Las investigaciones iniciales registran participantes y trazabilidad.
- MCP no es dependencia operativa de la app.
- Logs no exponen secretos ni datos sensibles innecesarios.
- Hay pruebas mínimas.
- Hay rollback o plan de reversión.
- Hay auditoría de acciones sensibles.

## 25. Relación con Codex / Antigravity

Codex y Antigravity deben tratar este documento como fuente normativa para
cualquier tarea que toque:

- backend;
- Supabase;
- RLS;
- Edge Functions;
- API;
- MCP;
- Stasis Engine;
- agentes;
- memoria;
- investigaciones;
- LLMs;
- pagos;
- archivos;
- logs;
- auditoría;
- seguridad.

Antes de ejecutar una tarea relacionada, Codex debe declarar:

- qué frontera toca;
- qué decisión aprobada la respalda;
- qué archivos puede tocar;
- qué archivos no puede tocar;
- qué revisores aplican;
- qué pruebas hará;
- qué rollback existe;
- qué riesgos quedan.

Codex no puede:

- convertir MCP en API;
- hacer que Flutter dependa de MCP;
- mover lógica sensible a Flutter;
- saltarse RLS/autorización;
- crear Stasis Engine como servicio independiente sin driver;
- crear MCP productivo sin decisión;
- inventar contratos;
- inventar tablas;
- inventar proveedores;
- declarar implementado lo conceptual.

## 26. Reglas especiales

- API propia no implica backend independiente desde el día uno.
- MCP no sustituye API.
- Stasis Engine no es un entorno.
- Flutter no debe contener lógica sensible crítica.
- Supabase puede implementar parte de la frontera MVP, pero no elimina la
  necesidad de contratos.
- RLS es obligatorio cuando se use Supabase con datos sensibles.
- MCP solo expone herramientas autorizadas.
- Stasis Engine opera bajo permisos, coste y trazabilidad.
- Las investigaciones deben ser transparentes sin revelar razonamiento interno
  sensible.
- La memoria federada requiere procedencia, permisos, caducidad, corrección y
  borrado.
- Una arquitectura futura no debe describirse como existente.
- La separación física de servicios requiere drivers técnicos verificados.

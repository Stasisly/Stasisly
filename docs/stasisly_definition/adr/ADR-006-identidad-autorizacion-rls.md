# ADR-006: Identidad, autorización y RLS

## Estado

Aceptado conceptualmente. Paquete 2A implementado y verificado. Diseño 2B
aprobado. Micro-paquete 2B-I implementado, verificado en entorno local/efímero
y cerrado formalmente. Micro-paquete 2B-II implementado, verificado
exclusivamente en local y cerrado formalmente. Contrato 2C-I de perfil propio
implementado, verificado y cerrado formalmente sin adaptador Supabase
ejecutable ni conexión backend. Contrato 2C-II de `chat_sessions` preparado
documentalmente y aprobado, pero no implementado. Contrato 2C-II-A de catálogo
seguro mínimo de especialistas aprobado documentalmente, pero no implementado.
Diseño 2B-III de RLS/catálogo sanitizado de especialistas aprobado
documentalmente y plan exacto aprobado. ADR-007 aceptado conceptualmente.
Micro-paquete 2B-III-A implementado, verificado exclusivamente en local y
cerrado formalmente el 2026-06-14. Micro-paquete 2B-III-B implementado y
verificado exclusivamente mediante fixtures locales transaccionales y cerrado
formalmente el 2026-06-14. Plan exacto 2B-III-C aprobado exclusivamente como
diseño documental el 2026-06-14. 2B-III-C1 aprobado documentalmente el
2026-06-14: `service_role` queda permitido condicionalmente solo para una
validación local, efímera y aislada. 2B-III-C implementado, verificado
exclusivamente en local y cerrado formalmente el 2026-06-14. 2B-III-C2
implementado, verificado exclusivamente en local y cerrado formalmente el
2026-06-14. 2B-III-D implementado, verificado como contrato Flutter
exclusivamente desconectado y cerrado formalmente el 2026-06-14. Diseño
general 2B-IV de `chat_sessions` aprobado documentalmente y dividido en
subpaquetes; implementación completa no autorizada. 2B-IV-A implementado,
verificado exclusivamente en local y cerrado formalmente el 2026-06-14. Plan
exacto 2B-IV-B implementado, verificado exclusivamente mediante fixtures
locales transaccionales y cerrado formalmente el 2026-06-14. 2B-IV-C
implementado, verificado exclusivamente en entorno local/efímero y cerrado
formalmente el 2026-06-14. Plan exacto 2B-IV-D preparado documentalmente y
pendiente de aprobación. 2B-IV-D fue implementado después, verificado
exclusivamente en entorno local/efímero y cerrado formalmente el 2026-06-14.
2B-IV-E fue implementado, verificado exclusivamente en entorno local/efímero
y cerrado formalmente el 2026-06-14. 2B-IV-F fue implementado, verificado
como contrato Flutter exclusivamente desconectado y cerrado formalmente el
2026-06-14. 2B-IV-G fue implementado, verificado como datasource Flutter HTTP
exclusivamente local y cerrado formalmente el 2026-06-15. Plan exacto 2B-IV-H
aprobado, implementado y verificado como integración HTTP local controlada el
2026-06-15. 2B-V-A `messages` deny-all + constraints mínimos fue aprobado,
implementado y verificado exclusivamente en entorno local/efímero el
2026-06-15. 2B-V-B fixtures locales transaccionales de `messages` fue
aprobado, implementado y verificado exclusivamente en local el 2026-06-16,
sin migraciones, seeds ni fixtures confirmados. Toda conexión remota
Flutter-backend permanece sin autorizar.
Plan conceptual 2B-V-C aprobado y dividido en C1 RPC local transaccional y C2
Edge Function local. 2B-V-C1 fue implementado y verificado exclusivamente en
Supabase local/efímero el 2026-06-20 y queda cerrado formalmente. 2B-V-C2
Edge Function local `send-user-message` fue implementada y verificada
exclusivamente en entorno local/efímero el 2026-06-20 y queda cerrada
formalmente. 2B-V-C queda cerrado localmente: C1 RPC transaccional y C2 Edge
Function local. 2B-V-D Edge Function local `list-session-messages` fue
implementada y verificada exclusivamente en entorno local/efímero el
2026-06-21 y queda cerrada localmente. 2B-V-E contrato Flutter desconectado de
mensajes fue implementado y verificado el 2026-06-21 sin red real, sin
Supabase imports, sin UI/providers y sin datasource HTTP. Flutter-backend
remoto, producción, IA, datos reales y Stasis Engine permanecen sin autorizar.
2B-V-F datasource Flutter HTTP local de mensajes fue implementado y verificado
el 2026-06-21 con transporte inyectable, host policy local, token provider
inyectado, tests unitarios con fake transport y sin conectar providers, UI,
Supabase remoto, Edge Functions reales, producción ni datos reales. 2B-V-G
integración HTTP local contra Edge Functions fue implementada y verificada en
entorno local/efímero el 2026-06-21, con cleanup total `0|0|0|0|0|0`, sin
providers/UI, sin remoto, sin producción y sin datos reales. 2B-V-H fue
cerrado documentalmente el 2026-06-21. 2B-V-I1 application controller/state
messages sin providers reales fue implementado, verificado y cerrado
formalmente el 2026-06-21. 2B-V-I2 providers Riverpod messages sin UI queda
implementado, verificado y cerrado formalmente el 2026-06-21. 2B-V-J UI mínima
messages aislada queda implementado, verificado y cerrado formalmente el
2026-06-21 como componente aislado sin ruta real. 2B-V-J2 host/demo aislado
queda implementado, verificado y cerrado formalmente el 2026-06-21 como host
dev/test sin ruta real; chat heredado, integración K, remoto, producción,
Supabase real, IA, Stasis Engine, MCP, streaming, adjuntos y datos reales
permanecen bloqueados. 2B-V-K0 auditoría del chat actual y plan de
integración/reemplazo queda cerrado formalmente el 2026-06-26; no implementó
integración, no modificó chat heredado y no modificó navegación. 2B-V-K1 plan
exacto de adaptación segura del chat actual queda preparado documentalmente el
2026-06-26; K1 no implementa código, no conserva `SupabaseChatDataSource` como
camino futuro aceptable y no permite envío de `role` desde Flutter. 2B-V-K2
queda implementado y verificado el 2026-06-26 como integración controlada en
shell seguro dentro de `chat_messages`, sin tocar chat heredado, rutas,
navegación, `app.dart`, `main.dart`, Supabase, remoto, producción ni datos
reales. 2B-V-K3 plan de wiring controlado con rutas reales queda preparado
documentalmente el 2026-06-26; no implementa routing y bloquea conectar
`/chat/:id` porque el `:id` actual está verificado como `agentId` heredado, no
como `sessionId` seguro. 2B-V-K3 queda cerrado formalmente el 2026-06-26.
2B-V-K4 ruta dev-only segura con `sessionId` explícito queda preparado
documentalmente; no implementa rutas, no toca `/chat/:id`, no toca
`/orchestrator/chat` y no conecta el shell seguro a navegación productiva.
2B-V-K4 queda cerrado formalmente el 2026-06-26. 2B-V-L cierre del bloque
`messages` local-safe queda aprobado y cerrado formalmente el 2026-06-26; K5
no está autorizado, `/chat/:id` sigue bloqueada porque `:id` es `agentId`, no
`sessionId`, y el bloque `messages` no queda productivo ni remoto. 2B-W
`chat_sessions` UI/routing seguro queda iniciado documentalmente para resolver
selección y entrada segura a sesión antes de entrar a mensajes. 2B-W queda
aprobado como plan inicial y 2B-W-A auditoría específica de `chat_sessions`
UI/routing seguro queda cerrada formalmente el 2026-06-26; no implementó
código, UI, providers, rutas ni navegación. 2B-W-B controller/state
`chat_sessions` UI-safe queda implementado y verificado el 2026-06-26 como
capa Dart pura, sin providers, Riverpod, UI, rutas, navegación, Supabase,
HTTP directo ni chat heredado. 2B-W-C providers `chat_sessions` UI-safe queda
implementado y verificado el 2026-06-26 como wiring Riverpod overrideable, sin
UI, widgets, BuildContext, rutas, navegación, Supabase, HTTP directo,
`chat_messages`, chat heredado ni ids internos. 2B-W-D UI mínima aislada
`chat_sessions` queda implementada y verificada el 2026-06-26 como componente
aislado sin routing, navegación, chat heredado, `chat_messages`, Supabase,
HTTP directo, remoto, producción ni datos reales. 2B-W-E host/dev aislado
`chat_sessions` queda implementado y verificado el 2026-06-27 como host
dev/test con providers overrideados, datos ficticios, sin routing,
navegación, chat heredado, `chat_messages`, Supabase, HTTP/Dio directo,
remoto, producción ni datos reales. 2B-W-F shell seguro `chat_sessions` queda
implementado y verificado el 2026-06-27 como shell de presentación sin ruta
real, sin navegación, sin chat heredado, sin `chat_messages`, sin Supabase,
sin HTTP/Dio directo, sin aceptar `id` heredado ni `agentId` como sesión.
2B-W-G cierre documental queda aprobado y cerrado formalmente el 2026-06-27:
`chat_sessions` queda cerrado solo como local-safe/dev-test-safe, no
productivo, no remoto y sin datos reales. El routing por `sessionId` sigue
bloqueado hasta aprobación explícita futura. 2B-X cierre global documental del
frente chat local-safe queda preparado el 2026-06-27: integra `messages` y
`chat_sessions` como bloques local-safe completos, sin routing, remoto,
producción, datos reales, IA, Stasis Engine, MCP ni streaming. 2B-X queda
aprobado y cerrado formalmente el 2026-06-27. 2B-Y plan de routing seguro por
`sessionId` explícito queda preparado documentalmente el 2026-06-27, sin
implementar rutas, navegación ni conexión entre `chat_sessions` y `messages`.
2B-Y queda aprobado y cerrado formalmente el 2026-06-27. 2B-Y-A dev-only route
por `sessionId` explícito queda implementada y verificada el 2026-06-27 como
ruta exclusivamente demo/local/dev fuera de release, sin tocar `/chat/:id`,
`/orchestrator/chat`, chat heredado, `chat_sessions`, Supabase, remoto,
producción, IA, Stasis Engine, MCP ni streaming. 2B-Y-A queda aprobado y
cerrado formalmente el 2026-06-28 como puerta de pruebas, no puerta de
producto. 2B-Y-B cierre documental de routing dev-only queda preparado el
2026-06-28: mantiene bloqueado el routing productivo y exige decisión futura
separada antes de conectar sesiones reales, navegación de usuario o rutas de
producto. 2B-Y-B queda aprobado y cerrado formalmente el 2026-06-28. 2B-Z plan
de auth/session selection seguro queda preparado documentalmente el 2026-06-28,
sin implementar código, rutas, navegación, chat heredado, Supabase, remoto,
producción ni datos reales. 2B-Z queda aprobado y cerrado formalmente el
2026-06-28. 2B-Z-A auditoría auth/session actual queda preparada
documentalmente el 2026-06-28, sin modificar auth, providers, rutas,
navegación, chat heredado, `chat_sessions`, `messages`, Supabase, migraciones,
tests ni CI. 2B-Z-A queda aprobado y cerrado formalmente el 2026-06-28. 2B-Z-B1
plan detallado de token provider seguro queda preparado documentalmente el
2026-06-28, sin implementar código, sin modificar token providers, auth,
providers, rutas, navegación, Supabase, remoto, producción ni datos reales.
2B-Z-B1 queda aprobado y cerrado formalmente el 2026-06-28. 2B-Z-C1 contrato
Dart puro de token provider seguro queda implementado y verificado el
2026-06-28, sin conectar auth real, auth heredado, Supabase, remoto,
producción, datos reales, rutas, navegación, `chat_sessions` ni `messages`.

## Propósito

Definir el modelo de identidad, autorización y Row Level Security de Stasisly
antes de restaurar autenticación, activar backend real o tratar datos reales.

La implementación de 2A fue autorizada y cerrada por separado. El diseño 2B fue
aprobado y el micro-paquete 2B-I validó exclusivamente una migración local de
denegación total para `public.users`, su harness y documentación. Su cierre no
autoriza políticas permisivas, conexiones remotas, credenciales, usuarios
reales ni el desbloqueo de backend.

Existe un proyecto Supabase remoto con referencia `loaukleerwxunilunvai`, pero
su mera existencia no demuestra configuración, seguridad ni preparación para
uso. Continúa expresamente bloqueado: no debe vincularse, recibir migraciones,
datos o credenciales ni activar backend real sin una aprobación posterior
específica.

## Contexto y estado comprobado

### Decisiones y controles ya aprobados

- ADR-005 cerró el Paquete 1 y mantiene bloqueados backend real, producción,
  autenticación real, RLS y datos reales.
- Supabase puede formar parte de la frontera backend del MVP, pero no sustituye
  contratos, autorización, auditoría ni pruebas.
- Flutter no decide autorización crítica.
- Toda tabla sensible requiere RLS y pruebas negativas.
- Identidad humana, identidad técnica y permisos administrativos deben
  diferenciarse.

### Estado técnico verificado por la auditoría previa

Existe una migración inicial con estas tablas:

- `public.users`;
- `public.memberships`;
- `public.user_memberships`;
- `public.specialists`;
- `public.branch_chiefs`;
- `public.subcategory_chiefs`;
- `public.chat_sessions`;
- `public.messages`;
- `public.user_health_data`;
- `public.calendar_events`;
- `public.reminders`;
- `public.orchestator_summaries`;
- `public.chief_write_permissions`;
- `public.specialist_temporary_disables`.

La migración no habilita RLS ni define políticas. Algunas tablas representan
ideas antiguas o provisionales, incluida la categoría `mental`, permisos de
agentes todavía no diseñados y el nombre probablemente erróneo
`orchestator_summaries`.

La existencia de estas tablas en SQL no significa que estén aprobadas para
producción, desplegadas, protegidas o alineadas con el producto vigente.

## Principios de diseño propuestos

1. Denegación por defecto y mínimo privilegio.
2. `auth.uid()` identifica al usuario autenticado, pero no concede por sí solo
   permisos administrativos.
3. RLS protege filas; no sustituye validación, contratos ni autorización de
   operaciones sensibles.
4. Flutter solo realiza operaciones directas simples, expresamente aprobadas y
   protegidas mediante RLS.
5. Operaciones privilegiadas, multiusuario, administrativas, financieras o que
   invoquen agentes pasan por una función o backend controlado.
6. Ningún dato real se usa hasta demostrar aislamiento, autorización, auditoría
   y rollback.
7. Los prompts, agentes y LLMs nunca deciden permisos.
8. Los roles y entitlements se obtienen de fuentes controladas por backend, no
   de valores editables por el usuario.
9. Toda política RLS tiene pruebas positivas y negativas.
10. La clave `service_role` nunca llega a Flutter ni se usa para eludir diseño
    de autorización.

## Modelo de identidad de usuario

### Fuente de verdad

Se propone que `auth.users` sea la fuente de verdad para la identidad
autenticada:

- `auth.users.id` identifica de forma estable al usuario;
- el token de sesión autenticado permite obtener `auth.uid()`;
- email, proveedores y factores de autenticación pertenecen al dominio Auth;
- deshabilitar o eliminar una identidad debe invalidar su acceso.

La identidad autenticada demuestra quién presenta la sesión. No demuestra qué
operaciones de producto o administración puede realizar.

### Relación entre `auth.users` y `public.users`

Se propone mantener una relación 1:1:

```text
auth.users.id == public.users.id
```

`public.users` será un perfil de producto mínimo y no una segunda fuente de
identidad. Podrá contener únicamente atributos de perfil autorizados, como
nombre visible o avatar, sujetos a minimización.

Reglas propuestas:

- el perfil solo se crea para una identidad Auth válida;
- el usuario puede leer su propio perfil;
- el usuario solo puede actualizar campos de perfil expresamente permitidos;
- cambios administrativos o de seguridad no pueden realizarse actualizando el
  perfil;
- no se expondrán campos internos, flags administrativos ni datos de otros
  usuarios;
- creación, reparación y eliminación del perfil requieren un flujo backend
  idempotente y auditable.

La columna existente `public.users.role` no se considera una fuente de
autorización aprobada. Antes de producción deberá retirarse, redefinirse o
aislarse mediante una migración futura aprobada.

## Roles, permisos y entitlements

### Rol de producto

El rol de producto describe cómo participa una identidad en Stasisly, no sus
privilegios administrativos. Para el primer backend controlado se propone:

- `user`: usuario final autenticado.

Otros actores de producto, como agentes IA o Stasis, no deben modelarse como
usuarios humanos ni recibir sesiones de usuario por comodidad.

### Membresías y entitlements

La membresía determina acceso comercial a capacidades de producto. No convierte
al usuario en administrador.

Reglas propuestas:

- catálogo y precios son de solo lectura para usuarios cuando se aprueben;
- el estado de membresía se calcula desde evidencia controlada por backend;
- Flutter no puede activar, extender o cancelar unilateralmente una membresía;
- IDs de proveedor, webhooks y entitlements no son escribibles por el usuario;
- membresía y permisos administrativos son dominios separados.

### Permisos administrativos

Los permisos administrativos deben proceder de una fuente server-managed
separada y auditable. Se propone diseñar posteriormente asignaciones
administrativas granulares, con:

- permiso o rol administrativo explícito;
- alcance;
- emisor;
- motivo;
- fecha de concesión;
- caducidad o revocación;
- auditoría.

No se aprueba todavía una tabla concreta ni un catálogo definitivo de permisos.
El valor existente `public.users.role = 'admin'` no es suficiente para
producción.

### Identidades técnicas

Backend, jobs, Stasis Engine, agentes, MCP y proveedores externos requerirán
identidades separadas en fases posteriores. No compartirán identidad humana ni
obtendrán acceso global por defecto.

## Por qué `userMetadata` no autoriza operaciones críticas

`userMetadata` puede contener preferencias o datos de presentación, pero no
debe decidir acceso administrativo, membresías, datos sensibles ni permisos
entre usuarios porque puede proceder de flujos controlables por el usuario y no
ofrece por sí solo el gobierno requerido.

Reglas propuestas:

- nunca usar `userMetadata` para reconocer administradores;
- nunca usarlo para otorgar membresías o entitlements;
- nunca usarlo para permitir acceso a chats, salud, memoria o investigaciones;
- nunca usarlo para saltarse RLS;
- claims críticos, si se usan en el futuro, deben ser emitidos por backend,
  mínimos, verificables, con caducidad y sincronización segura;
- la autorización crítica debe validarse contra fuentes server-managed.

## Estrategia de autorización

Cada operación deberá documentar:

- actor e identidad;
- recurso;
- acción;
- propietario del recurso;
- sensibilidad;
- condición de autorización;
- frontera de ejecución;
- evento de auditoría;
- pruebas positivas y negativas.

### Operaciones directas permitidas desde Flutter

Solo podrán aprobarse operaciones simples de propiedad individual cuando:

- exista sesión autenticada;
- RLS limite lectura y escritura a `auth.uid()`;
- las columnas modificables estén limitadas;
- no exista efecto sobre otros usuarios;
- no se requieran secretos, service role, lógica financiera o privilegios;
- haya pruebas de aislamiento y errores controlados.

Ejemplos candidatos, pendientes de implementación: leer el perfil propio,
actualizar campos públicos permitidos del perfil y leer chats propios.

### Operaciones que deben pasar por backend o función

- crear o cambiar permisos administrativos;
- cambiar membresías o entitlements;
- ejecutar acciones de Panel Admin;
- invocar proveedores LLM o agentes con datos sensibles;
- escribir como agente, jefe o sistema;
- modificar catálogo, prompts o estado de agentes;
- acceder a múltiples usuarios;
- procesar salud, wellness, memoria, investigaciones o archivos;
- realizar operaciones financieras;
- producir o consultar auditoría sensible.

## Clasificación y estrategia RLS por tabla existente

Todas las tablas existentes permanecen **no aptas para producción** hasta que
se aprueben e implementen sus políticas, contratos, pruebas y rollback.

| Tabla existente | Sensibilidad | Acceso directo Flutter candidato | Política mínima propuesta | Estado |
| --- | --- | --- | --- | --- |
| `public.users` | Personal | Leer perfil propio; actualizar campos permitidos | `id = auth.uid()` y columnas restringidas | No apta |
| `public.memberships` | Comercial | Lectura pública/autenticada solo si el catálogo se aprueba | Solo lectura; escritura backend/admin | No apta |
| `public.user_memberships` | Financiera/comercial | Leer entitlement propio resumido | `user_id = auth.uid()` para lectura; ninguna escritura cliente | No apta |
| `public.specialists` | Catálogo y prompts sensibles | Solo catálogo público sanitizado | Nunca exponer `prompt_template`; escritura backend/admin | No apta |
| `public.branch_chiefs` | Catálogo/gobierno | Solo catálogo sanitizado | Lectura limitada; escritura backend/admin | No apta |
| `public.subcategory_chiefs` | Catálogo/gobierno | Solo catálogo sanitizado | Lectura limitada; escritura backend/admin | No apta |
| `public.chat_sessions` | Personal/sensible | CRUD limitado sobre sesiones propias | `user_id = auth.uid()`; especialistas no escriben directamente | No apta |
| `public.messages` | Personal/sensible | Leer mensajes de sesiones propias; escritura humana limitada | Autorizar mediante propiedad de `chat_sessions`; roles no humanos solo backend | No apta |
| `public.user_health_data` | Salud, muy sensible | Ninguno inicialmente | Propiedad individual más backend controlado; cifrado/retención pendientes | No apta |
| `public.calendar_events` | Personal | CRUD propio candidato | `user_id = auth.uid()` | No apta |
| `public.reminders` | Personal | CRUD propio candidato limitado | `user_id = auth.uid()`; activación de sistema por backend | No apta |
| `public.orchestator_summaries` | Personal, IA, posiblemente sensible | Ninguno inicialmente | Lectura propia sanitizada; escritura backend | No apta y requiere revisión |
| `public.chief_write_permissions` | Autorización crítica | Ninguno | Solo backend autorizado y auditable | No apta y requiere rediseño |
| `public.specialist_temporary_disables` | Autorización/gobierno | Ninguno | Solo backend autorizado y auditable | No apta y requiere rediseño |

## Reglas específicas por dominio

### Chats

- El usuario solo puede ver sesiones cuyo `user_id` sea su identidad.
- Un mensaje solo es visible si pertenece a una sesión autorizada.
- El usuario puede crear mensajes con rol humano permitido, nunca asignarse rol
  `assistant`, `system` o `chief_intervention`.
- Respuestas de Stasis, especialistas o sistema solo se escriben mediante
  backend controlado.
- Adjuntos requieren diseño separado de Storage, URLs firmadas, retención y
  antivirus antes de admitirse.
- Acceso administrativo excepcional requiere motivo, permiso y auditoría.

### Perfiles

- El usuario solo lee su perfil y actualiza campos permitidos.
- No puede cambiar roles, permisos, membresías ni flags internos.
- Listar perfiles de otros usuarios queda denegado por defecto.
- Datos de autenticación se gestionan mediante Auth, no duplicados libremente.

### Agentes

- El cliente solo recibe un catálogo sanitizado.
- Prompts, configuración sensible, capacidades y permisos no se exponen.
- Activación, desactivación, jerarquía y permisos de agentes son operaciones
  backend/admin auditadas.
- Un agente nunca obtiene acceso por aparecer en una sesión o mensaje.

### Membresías

- El usuario puede consultar su estado derivado, no modificarlo.
- Webhooks y backend son autoridad para estados comerciales futuros.
- IDs de proveedor y eventos financieros no se exponen innecesariamente.
- Toda mutación es idempotente y auditada.

### Salud y wellness

- Permanecen bloqueados para datos reales durante Paquete 2.
- Requieren consentimiento, minimización, finalidad, retención, borrado,
  cifrado aplicable, auditoría y threat model.
- No habrá lectura o escritura directa desde Flutter en el primer diseño.
- Claims como `encrypted_at_rest` no demuestran cifrado real.

### Memoria futura

- No se implementa en Paquete 2.
- Cada memoria futura requiere propietario, nivel, procedencia, sensibilidad,
  permisos, caducidad, corrección, borrado y auditoría.
- La promoción entre niveles necesita autorización explícita y trazable.
- Memoria global no implica acceso global.

### Investigaciones futuras

- No se implementan en Paquete 2.
- Participantes y servicios solo reciben el mínimo contexto autorizado.
- Resultados, evidencias y participantes deben respetar propiedad y
  sensibilidad.
- Compartir una investigación nunca concede acceso lateral implícito.

## Auditoría mínima propuesta

Antes de backend real deben definirse eventos de auditoría para:

- concesión, cambio y revocación de permisos administrativos;
- cambios de membresía o entitlement;
- accesos administrativos a datos de usuario;
- operaciones sobre salud/wellness;
- escrituras de agentes o sistema;
- denegaciones relevantes y fallos de autorización;
- cambios de políticas o configuración de seguridad.

Cada evento debe incluir actor, acción, recurso, resultado, fecha, procedencia y
correlación, evitando almacenar secretos o contenido sensible innecesario.
Los usuarios no pueden modificar ni borrar auditoría.

## Tests obligatorios de RLS y autorización

Toda tabla o función habilitada deberá demostrar:

- anónimo denegado salvo lectura pública explícita;
- usuario A puede realizar únicamente operaciones propias aprobadas;
- usuario A no puede leer, insertar, modificar ni borrar recursos de usuario B;
- usuario no puede elevar rol, permiso, membresía o entitlement;
- columnas protegidas no pueden modificarse mediante payload alternativo;
- mensajes no humanos no pueden falsificarse desde Flutter;
- acceso administrativo falla sin permiso explícito;
- permisos revocados o expirados dejan de funcionar;
- funciones backend validan identidad y autorización;
- `service_role` no aparece en cliente ni tests de cliente;
- errores no filtran datos;
- rollback restaura un estado seguro.

Los tests negativos son obligatorios y deben ejecutarse en CI contra un entorno
local o efímero controlado antes de cualquier despliegue.

## Paquete 2 — Identidad, autorización y RLS base

El Paquete 2 se propone como una secuencia de gates. Aprobar este ADR no aprueba
automáticamente implementar todos los subpaquetes.

### 2A — Diseño de identidad y roles

**Objetivo:** aprobar el modelo antes de cambiar Auth o esquema.

Entregables:

- matriz de identidades humanas y técnicas;
- contrato 1:1 entre `auth.users` y `public.users`;
- catálogo inicial de roles, permisos y entitlements;
- campos permitidos del perfil;
- decisión sobre la columna existente `public.users.role`;
- política explícita sobre `userMetadata`;
- flujos de alta, baja, suspensión, revocación y eliminación;
- threat model inicial.

Gate de salida:

- modelo revisado por Arquitectura, Seguridad, AppSec, Backend, Privacidad y QA;
- ninguna ambigüedad entre identidad, rol de producto, membresía y permiso
  administrativo.

### 2B — Diseño RLS mínimo

**Objetivo:** producir el diseño exacto de políticas antes de escribir SQL.

Estado: diseño documental aprobado. El micro-paquete 2B-I fue implementado,
verificado localmente y cerrado formalmente. El micro-paquete 2B-II dispone del
diseño documental descrito abajo, pendiente de aprobación antes de cualquier
SQL, política o cambio de esquema.

Gate de salida:

- ninguna tabla sensible se habilita sin política completa y pruebas;
- inconsistencias antiguas del esquema quedan resueltas o explícitamente fuera.

#### Inventario estructural verificado

Fuente inspeccionada:

```text
supabase/migrations/00001_initial_schema.sql
```

Hechos verificados:

- existe una única migración;
- crea la extensión `uuid-ossp`;
- crea 14 tablas en `public`;
- crea 4 índices no únicos adicionales;
- no crea funciones ni RPC;
- no crea triggers;
- no habilita ni fuerza RLS;
- no crea políticas;
- no contiene `GRANT` ni `REVOKE`;
- no existe el RPC `increment_message_count` que Flutter intenta invocar.

La nulabilidad indicada abajo se deriva del SQL actual: salvo `PRIMARY KEY` o
`NOT NULL`, las columnas permiten `NULL`.

| Tabla | Columnas, tipos, defaults y constraints verificados |
| --- | --- |
| `users` | `id UUID PK FK -> auth.users(id) ON DELETE CASCADE`; `display_name TEXT`; `avatar_url TEXT`; `role TEXT DEFAULT 'user' CHECK user/admin`; `created_at TIMESTAMP DEFAULT now()`; `updated_at TIMESTAMP DEFAULT now()` |
| `memberships` | `id UUID PK DEFAULT uuid_generate_v4()`; `name TEXT NOT NULL`; `price DECIMAL(10,2) NOT NULL`; `duration_days INT NOT NULL`; `features JSONB`; `created_at TIMESTAMP DEFAULT now()` |
| `user_memberships` | `id UUID PK DEFAULT uuid_generate_v4()`; `user_id UUID FK -> users(id) ON DELETE CASCADE`; `membership_id UUID FK -> memberships(id)`; `start_date TIMESTAMP NOT NULL`; `end_date TIMESTAMP NOT NULL`; `is_active BOOLEAN DEFAULT true`; `trial_used BOOLEAN DEFAULT false`; `stripe_subscription_id TEXT`; `created_at TIMESTAMP DEFAULT now()` |
| `specialists` | `id UUID PK DEFAULT uuid_generate_v4()`; `name TEXT NOT NULL`; `category TEXT NOT NULL CHECK salud/nutricion/fisico/mental/orquestador/branch_chief/subcategory_chief`; `subcategory TEXT`; `prompt_template JSONB NOT NULL`; `is_premium BOOLEAN DEFAULT true`; `is_active BOOLEAN DEFAULT true`; `avatar_url TEXT`; `branch_id UUID`; `chief_id UUID`; `created_at TIMESTAMP DEFAULT now()` |
| `branch_chiefs` | `specialist_id UUID PK FK -> specialists(id) ON DELETE CASCADE`; `branch_name TEXT UNIQUE NOT NULL CHECK salud/nutricion/fisico/mental` |
| `subcategory_chiefs` | `specialist_id UUID PK FK -> specialists(id) ON DELETE CASCADE`; `branch_id UUID FK -> branch_chiefs(specialist_id)`; `subcategory_name TEXT NOT NULL`; `min_specialists INT DEFAULT 5`; `can_disable BOOLEAN DEFAULT true`; `UNIQUE(branch_id, subcategory_name)` |
| `chat_sessions` | `id UUID PK DEFAULT uuid_generate_v4()`; `user_id UUID FK -> users(id) ON DELETE CASCADE`; `specialist_id UUID FK -> specialists(id) ON DELETE CASCADE`; `started_at TIMESTAMP DEFAULT now()`; `last_message_at TIMESTAMP DEFAULT now()`; `status TEXT DEFAULT 'active' CHECK active/archived`; `message_count INT DEFAULT 0` |
| `messages` | `id UUID PK DEFAULT uuid_generate_v4()`; `session_id UUID FK -> chat_sessions(id) ON DELETE CASCADE`; `role TEXT NOT NULL CHECK user/assistant/system/chief_intervention`; `content TEXT NOT NULL`; `attachments JSONB`; `created_at TIMESTAMP DEFAULT now()` |
| `user_health_data` | `id UUID PK DEFAULT uuid_generate_v4()`; `user_id UUID FK -> users(id) ON DELETE CASCADE`; `data_type TEXT NOT NULL`; `content JSONB NOT NULL`; `source_file_url TEXT`; `extracted_at TIMESTAMP DEFAULT now()`; `validated BOOLEAN DEFAULT false`; `encrypted_at_rest BOOLEAN DEFAULT true` |
| `calendar_events` | `id UUID PK DEFAULT uuid_generate_v4()`; `user_id UUID FK -> users(id) ON DELETE CASCADE`; `title TEXT NOT NULL`; `description TEXT`; `start_datetime TIMESTAMP NOT NULL`; `end_datetime TIMESTAMP NOT NULL`; `recurrence_rule TEXT`; `reminder_minutes INT`; `created_at TIMESTAMP DEFAULT now()` |
| `reminders` | `id UUID PK DEFAULT uuid_generate_v4()`; `user_id UUID FK -> users(id) ON DELETE CASCADE`; `message TEXT NOT NULL`; `scheduled_for TIMESTAMP NOT NULL`; `triggered BOOLEAN DEFAULT false`; `related_entity TEXT`; `entity_id UUID`; `created_at TIMESTAMP DEFAULT now()` |
| `orchestator_summaries` | `id UUID PK DEFAULT uuid_generate_v4()`; `user_id UUID FK -> users(id) ON DELETE CASCADE`; `summary_level TEXT CHECK orchestrator/branch/subcategory`; `entity_id UUID`; `summary_text TEXT NOT NULL`; `period_start DATE`; `period_end DATE`; `is_active BOOLEAN DEFAULT false`; `created_at TIMESTAMP DEFAULT now()` |
| `chief_write_permissions` | `id UUID PK DEFAULT uuid_generate_v4()`; `subcategory_chief_id UUID FK -> subcategory_chiefs(specialist_id) ON DELETE CASCADE`; `specialist_id UUID FK -> specialists(id)`; `user_id UUID FK -> users(id) ON DELETE CASCADE`; `permission_granted BOOLEAN`; `granted_at TIMESTAMP`; `expires_at TIMESTAMP`; `UNIQUE(subcategory_chief_id, specialist_id, user_id)` |
| `specialist_temporary_disables` | `id UUID PK DEFAULT uuid_generate_v4()`; `specialist_id UUID FK -> specialists(id) ON DELETE CASCADE`; `disabled_by UUID FK -> subcategory_chiefs(specialist_id)`; `user_id UUID FK -> users(id) ON DELETE CASCADE`; `approved_by_user BOOLEAN DEFAULT false`; `disabled_at TIMESTAMP DEFAULT now()`; `reactivation_at TIMESTAMP`; `reason TEXT` |

Índices adicionales verificados:

- `idx_chat_sessions_user` sobre `chat_sessions(user_id)`;
- `idx_messages_session` sobre `messages(session_id)`;
- `idx_user_health_data_user` sobre `user_health_data(user_id)`;
- `idx_orchestator_summaries_user` sobre
  `orchestator_summaries(user_id)`.

#### Problemas y contradicciones del esquema actual

| Severidad | Hallazgo | Impacto y decisión de diseño |
| --- | --- | --- |
| Crítica | Ninguna tabla tiene RLS o políticas | Todo el esquema permanece no apto para backend real |
| Crítica | `specialists.prompt_template` convive con catálogo potencialmente visible | No exponer tabla directamente al cliente; requiere catálogo sanitizado |
| Crítica | `messages.role` puede recibirse desde Flutter | Un cliente podría intentar escribir como `assistant`, `system` o `chief_intervention`; inserts quedan bloqueados hasta rediseño |
| Crítica | `user_health_data.encrypted_at_rest DEFAULT true` es solo un claim | No demuestra cifrado; tabla completamente bloqueada |
| Alta | `users.role` contradice Paquete 2A y ADR-006 | No es autoridad; evitar lectura/escritura cliente y resolver en migración futura |
| Alta | Flutter envía `user_id` al crear `chat_sessions` | Debe derivarse de `auth.uid()` en frontera segura, no confiar en payload |
| Alta | Flutter invoca RPC inexistente `increment_message_count` | Chat backend no puede considerarse funcional ni habilitarse |
| Alta | `branch_id` y `chief_id` de `specialists` no tienen FK | Integridad y jerarquía ambiguas; catálogo requiere rediseño |
| Alta | `chief_write_permissions` modela autorización crítica con booleano nullable | No usar como fuente de permisos; rediseño y auditoría obligatorios |
| Alta | `specialist_temporary_disables` mezcla usuario, agente y aprobación | Bloqueada hasta definir actores, autoridad y auditoría |
| Alta | `orchestator_summaries` contiene error tipográfico | Tabla provisional; no crear políticas que consoliden el nombre erróneo |
| Alta | Categorías `mental` y `fisico` contradicen áreas actuales Wellness/Entrenamiento | Catálogo provisional; no ampliar alcance de 2B |
| Media | Varias FK y campos propietarios permiten `NULL` | RLS por propietario puede fallar conceptualmente; revisar antes de habilitar |
| Media | Todos los tiempos usan `TIMESTAMP` sin zona horaria | Riesgo operativo y de auditoría; resolver en revisión futura |
| Media | No hay triggers para `updated_at`, contadores o invariantes | Defaults no mantienen datos tras actualizaciones |
| Media | `attachments`, `features` y `content` usan JSONB sin contrato | Validación, sensibilidad y exposición no definidas |
| Media | Faltan índices en varias FK y caminos de autorización | Puede degradar políticas RLS; medir y diseñar antes de producción |

#### Clasificación de sensibilidad

| Tabla | Clasificación principal | Clasificaciones adicionales |
| --- | --- | --- |
| `users` | Personal | Perfil; contiene columna de rol insegura |
| `memberships` | Financiera/comercial | Catálogo potencialmente sanitizable |
| `user_memberships` | Financiera/comercial | Personal; backend only para mutaciones |
| `specialists` | Interna/backend only | Catálogo sanitizable solo mediante proyección; prompts sensibles |
| `branch_chiefs` | Interna/backend only | Catálogo sanitizable tras rediseño |
| `subcategory_chiefs` | Interna/backend only | Autorización/gobierno; catálogo sanitizable parcial |
| `chat_sessions` | Sensible | Personal |
| `messages` | Sensible | Personal; puede contener salud/wellness |
| `user_health_data` | Muy sensible | Salud; interna/backend only |
| `calendar_events` | Personal | Puede ser sensible por contenido |
| `reminders` | Personal | Puede ser sensible por contenido |
| `orchestator_summaries` | Sensible | IA; interna/backend only; provisional |
| `chief_write_permissions` | Autorización crítica | Interna/backend only |
| `specialist_temporary_disables` | Autorización crítica | Interna/backend only; gobierno |

Ninguna tabla se clasifica como pública en el esquema actual. Una futura
superficie pública o de catálogo debe ser una proyección sanitizada y aprobada,
no acceso indiscriminado a tablas base.

#### Matriz actor/acción/recurso

Leyenda:

- `D`: denegar;
- `P`: permitir bajo política RLS aprobada;
- `B`: backend only;
- `F`: futuro, después de rediseño;
- `R`: pendiente de rediseño.

Las acciones aparecen en orden `SELECT / INSERT / UPDATE / DELETE`. Un
`authenticated user` sin relación o propiedad y un `other user` concreto quedan
denegados. No existe actualmente ninguna acción RPC/función válida; toda RPC
futura será `backend only` hasta revisión independiente. `service_role` puede
omitir RLS técnicamente, pero solo se autoriza dentro de backend controlado y
auditado. `CI/test harness` opera únicamente en entorno local o efímero con
identidades de prueba.

| Recurso | anon | authenticated user | owner user | other user | admin futuro | backend/service role | agent/Stasis futuro | CI/test harness |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `users` | D/D/D/D | D/D/D/D | F/D/D/D | D/D/D/D | R/R/R/R | B/B/B/B | D/D/D/D | P/P/P/P |
| `memberships` | D/D/D/D | F/D/D/D | F/D/D/D | F/D/D/D | R/R/R/R | B/B/B/B | D/D/D/D | P/P/P/P |
| `user_memberships` | D/D/D/D | D/D/D/D | F/D/D/D | D/D/D/D | R/R/R/R | B/B/B/B | D/D/D/D | P/P/P/P |
| `specialists` | D/D/D/D | D/D/D/D | D/D/D/D | D/D/D/D | R/R/R/R | B/B/B/B | F/D/D/D | P/P/P/P |
| `branch_chiefs` | D/D/D/D | D/D/D/D | D/D/D/D | D/D/D/D | R/R/R/R | B/B/B/B | F/D/D/D | P/P/P/P |
| `subcategory_chiefs` | D/D/D/D | D/D/D/D | D/D/D/D | D/D/D/D | R/R/R/R | B/B/B/B | F/D/D/D | P/P/P/P |
| `chat_sessions` | D/D/D/D | D/D/D/D | F/F/F/F | D/D/D/D | R/R/R/R | B/B/B/B | D/D/D/D | P/P/P/P |
| `messages` | D/D/D/D | D/D/D/D | F/R/D/D | D/D/D/D | R/R/R/R | B/B/B/B | F/B/D/D | P/P/P/P |
| `user_health_data` | D/D/D/D | D/D/D/D | D/D/D/D | D/D/D/D | R/R/R/R | B/B/B/B | D/D/D/D | P/P/P/P |
| `calendar_events` | D/D/D/D | D/D/D/D | F/F/F/F | D/D/D/D | R/R/R/R | B/B/B/B | D/D/D/D | P/P/P/P |
| `reminders` | D/D/D/D | D/D/D/D | F/F/F/F | D/D/D/D | R/R/R/R | B/B/B/B | D/D/D/D | P/P/P/P |
| `orchestator_summaries` | D/D/D/D | D/D/D/D | D/D/D/D | D/D/D/D | R/R/R/R | B/B/B/B | F/B/D/D | P/P/P/P |
| `chief_write_permissions` | D/D/D/D | D/D/D/D | D/D/D/D | D/D/D/D | R/R/R/R | B/B/B/B | D/D/D/D | P/P/P/P |
| `specialist_temporary_disables` | D/D/D/D | D/D/D/D | D/D/D/D | D/D/D/D | R/R/R/R | B/B/B/B | D/D/D/D | P/P/P/P |

No se aprueba todavía ninguna operación `P` para ejecución real. Las marcas
`F`, `R` y `B` describen diseño objetivo o frontera, no políticas implementadas.

#### Propuesta RLS mínima por tabla

Todas las tablas deben habilitar RLS antes de cualquier exposición mediante
backend real. Hasta que cada política se apruebe, la política efectiva deseada
es denegación total para cliente.

| Tabla | Política mínima en lenguaje natural | Auxiliares/riesgos | Tests y rollback esperados |
| --- | --- | --- | --- |
| `users` | Primera iteración: denegar todo al cliente. Futuro: propietario puede leer solo perfil sanitizado; creación/reparación backend; nunca cambiar `role` | RLS no restringe columnas; resolver `role` antes de permitir `SELECT` directo | Anon/owner/other denegados inicialmente; backend de prueba controlado; rollback elimina política y deshabilita RLS solo en entorno local aislado |
| `memberships` | Denegar todo inicialmente; futuro catálogo sanitizado de solo lectura | Tabla base mezcla catálogo y campos comerciales; valorar vista/proyección | Ningún cliente lee o muta; backend de prueba sí; rollback seguro a denegación |
| `user_memberships` | Denegar todo al cliente; futuro owner lee entitlement sanitizado, nunca muta | No confiar en `is_active`; autoridad futura de backend/webhook | Owner no inserta/actualiza; other no lee; backend controlado; rollback a denegación |
| `specialists` | Denegar toda tabla base; futuro catálogo sanitizado sin prompts ni controles internos | No usar política que exponga `prompt_template`; requiere vista/API | Todo cliente denegado; prueba de no filtración de prompt; rollback a denegación |
| `branch_chiefs` | Denegar tabla base; futura lectura solo mediante catálogo sanitizado | Categorías antiguas y dependencia de catálogo provisional | Todo cliente denegado; rollback a denegación |
| `subcategory_chiefs` | Denegar tabla base; futura lectura sanitizada, mutación backend | `can_disable` no concede autoridad por sí solo | Todo cliente denegado; rollback a denegación |
| `chat_sessions` | Denegar inicialmente. Futuro owner puede leer y posiblemente archivar; creación debe derivar owner desde `auth.uid()` en frontera aprobada | No confiar en `user_id` enviado; riesgo de duplicados y ownership nullable | A no ve B; payload con otro `user_id` falla; anon falla; rollback a denegación |
| `messages` | Denegar inicialmente. Futuro owner lee mensajes de sesiones propias; usuario solo crea rol `user` mediante contrato seguro; roles no humanos backend only | Política requiere comprobar propiedad de sesión; riesgo de recursión/performance; RPC de contador inexistente | A no ve/inserta en sesión B; usuario no falsifica roles; attachments bloqueados; rollback a denegación |
| `user_health_data` | Bloqueo total para cliente | Requiere threat model, cifrado real, consentimiento, retención y borrado | Todo actor cliente denegado; rollback mantiene denegación |
| `calendar_events` | Denegar inicialmente; futuro CRUD owner tras contrato y validación | Propiedad nullable, contenido sensible y validación temporal | A no accede a B; anon falla; payload con otro owner falla; rollback a denegación |
| `reminders` | Denegar inicialmente; futuro CRUD owner limitado, activación backend | `triggered` y relaciones no deben ser controlables libremente | Owner no puede activar arbitrariamente; other/anon fallan; rollback a denegación |
| `orchestator_summaries` | Bloqueo total; no consolidar políticas antes de corregir/rediseñar tabla | Nombre erróneo, contenido IA sensible, writer no definido | Todo cliente denegado; rollback mantiene denegación |
| `chief_write_permissions` | Bloqueo total; solo backend futuro auditado tras rediseño | Funciones auxiliares sobre esta tabla podrían recursar o escalar privilegios | Ningún usuario/agente concede permisos; backend sin autorización también falla; rollback mantiene denegación |
| `specialist_temporary_disables` | Bloqueo total; solo backend futuro auditado tras rediseño | Autoridad, consentimiento y revocación ambiguos | Ningún cliente/agente muta; rollback mantiene denegación |

Reglas para futuras funciones auxiliares:

- no usar `SECURITY DEFINER` por comodidad;
- si resulta imprescindible, fijar `search_path`, validar actor, minimizar
  permisos, evitar SQL dinámico y auditar;
- no consultar una tabla desde su propia política de forma que cause recursión;
- separar comprobaciones de propiedad de comprobaciones administrativas;
- no usar `users.role`, metadata de usuario, prompts o claims editables como
  fuente de autorización;
- medir planes de consulta e indexar caminos de autorización antes de escala.

#### Tablas bloqueadas en el primer backend real

Aunque otras tablas obtengan políticas futuras, estas deben permanecer sin
acceso cliente directo durante el primer backend real:

- `specialists`;
- `branch_chiefs`;
- `subcategory_chiefs`;
- `user_health_data`;
- `orchestator_summaries`;
- `chief_write_permissions`;
- `specialist_temporary_disables`;
- `user_memberships` para cualquier mutación;
- `memberships` hasta disponer de catálogo sanitizado;
- `messages` para inserts hasta rediseñar roles y contrato;
- cualquier tabla o columna que exponga prompts, salud, autorización crítica,
  IDs financieros o contenido IA interno.

#### Alcance mínimo recomendado para implementar 2B después

No se recomienda implementar RLS de `users`, `chat_sessions` y `messages` a la
vez. Chat tiene contratos inseguros y un RPC faltante.

Primer micro-paquete aprobado e implementado estáticamente: **2B-I — RLS local
de denegación total para `public.users`**.

Alcance:

1. Crear una migración nueva y reversible; no editar la migración histórica.
2. Habilitar RLS solo en `public.users`.
3. No crear políticas de acceso cliente todavía: anon, owner y other quedan
   denegados.
4. Crear harness local/efímero con identidades de prueba.
5. Demostrar que `service_role` solo se usa en harness/backend controlado.
6. Mantener modo demo y backend real bloqueados.
7. Ejecutar tests positivos del harness y negativos de todos los actores
   cliente.

Este micro-paquete no desbloquea perfiles, auth real, backend real ni datos
reales. Su objetivo es validar disciplina de migración, harness, denegación y
rollback con el menor radio posible.

#### Resultado de implementación de 2B-I

Fecha de implementación estática: 2026-06-12.

Implementado:

- nueva migración `00002_enable_rls_public_users_deny_all.sql`;
- RLS habilitada exclusivamente para `public.users`;
- ninguna política permisiva o restrictiva creada;
- ningún uso de `FORCE ROW LEVEL SECURITY`, `SECURITY DEFINER`, funciones
  auxiliares o cambios sobre otras tablas;
- test pgTAP de invariantes estructurales;
- checklist ejecutable para pruebas negativas y rollback local.

Evidencia estática verificada:

- la migración histórica `00001_initial_schema.sql` permanece sin cambios;
- el SQL nuevo solo habilita RLS en `public.users`;
- el harness exige cero políticas y ninguna otra tabla con RLS;
- el harness exige que `anon` y `authenticated` no tengan `BYPASSRLS`;
- no se añadieron credenciales, conexiones remotas ni datos.

Evidencia que quedó pendiente tras la implementación estática y fue resuelta
por el reintento local del 2026-06-13:

- aplicar la migración en una base local/efímera;
- ejecutar pgTAP;
- demostrar con fixtures ficticios las denegaciones `SELECT`, `INSERT`,
  `UPDATE`, `DELETE`, owner/other y modificación de `role`;
- probar rollback y reaplicación.

En ese momento la ejecución quedó pendiente porque Supabase CLI `2.75.0`
estaba disponible, pero no existían Docker, un runtime compatible, `psql` ni
`supabase/config.toml`. Este bloqueo histórico quedó resuelto por la auditoría
local posterior. No se conectó un proyecto remoto.

Auditoría local autorizada el 2026-06-12:

- `supabase start` terminó antes de crear servicios con
  `Cannot connect to the Docker daemon at unix:///var/run/docker.sock`;
- el comando indicó que Docker Desktop es requisito para desarrollo local;
- no están instalados Docker Desktop, OrbStack, Podman Desktop, Colima, Podman
  ni Lima;
- `supabase test db supabase/tests/2b_i_public_users_rls_test.sql --local`
  terminó antes de ejecutar assertions porque no existe PostgreSQL escuchando
  en `127.0.0.1:54322`;
- no existía entonces `supabase/config.toml`, referencia de proyecto remoto ni
  variables `SUPABASE_ACCESS_TOKEN`, `SUPABASE_DB_URL` o
  `SUPABASE_PROJECT_REF`;
- `supabase projects list` no pudo consultar proyectos porque no hay token de
  acceso;
- no se aplicaron migraciones, no se crearon contenedores y el artefacto
  temporal `.temp/cli-latest` generado por el CLI fue eliminado.

Reintento de auditoría local completado el 2026-06-13:

- se creó `supabase/config.toml` para uso exclusivamente local, sin project ref
  ni credenciales remotas, y se deshabilitó el seed inexistente;
- Supabase CLI `2.75.0` arrancó únicamente PostgreSQL local en
  `127.0.0.1:54322`; los demás servicios quedaron detenidos;
- `supabase db reset --local --no-seed` aplicó `00001` y `00002`;
- el harness pgTAP se amplió con dos identidades ficticias dentro de una
  transacción revertida;
- 21 de 21 tests superaron catálogo, `anon`, `authenticated`, owner, other,
  protección de `role` y ausencia de cambios laterales;
- rollback local verificó `public.users.relrowsecurity = false`;
- reaplicación mediante reset verificó `relrowsecurity = true`,
  `relforcerowsecurity = false`, cero políticas y cero tablas adicionales con
  RLS;
- tras reaplicar, pgTAP volvió a superar 21 de 21 tests;
- no existían `SUPABASE_ACCESS_TOKEN`, `SUPABASE_DB_URL`,
  `SUPABASE_PROJECT_REF`, `.temp/project-ref` ni `.temp/pooler-url`;
- no se modificaron las migraciones `00001` ni `00002`, no se usaron datos
  reales y no se conectó Supabase remoto.

Resultado: la auditoría técnica local de 2B-I está completada. Esto demuestra
denegación total local para clientes, pero no desbloquea backend real,
autenticación, producción, datos reales ni políticas permisivas.

#### Cierre formal de 2B-I

Fecha de cierre aprobada: 2026-06-13.

Queda aceptado que:

- `00002_enable_rls_public_users_deny_all.sql` habilita RLS únicamente en
  `public.users`;
- no crea políticas, no fuerza RLS y no modifica otras tablas;
- la migración histórica permanece intacta;
- pgTAP superó 21 de 21 pruebas antes y después de la reaplicación;
- rollback y reaplicación fueron verificados localmente;
- `anon`, `authenticated`, owner y other permanecen denegados;
- `public.users.role` permanece inaccesible para cliente;
- no se vinculó ni utilizó Supabase remoto, datos reales o backend real.

2B-I queda cerrado como una prueba de disciplina deny-all. No constituye
aprobación para relajar la denegación ni para activar ningún entorno real.

#### Diseño documental de 2B-II — `public.users` perfil propio seguro

**Objetivo:** diseñar la primera superficie mínima de perfil propio sin exponer
`role`, conceder autoridad al cliente ni conectar Supabase remoto.

Estado: dirección y alcance reducido aprobados. Migración, pruebas SQL,
rollback, reaplicación y comportamiento PostgREST implementados y verificados
exclusivamente en entorno local/efímero el 2026-06-13, pendientes de aprobación
de cierre. No existe conexión remota, integración Flutter, función backend,
vista, trigger, Storage ni Auth real implementados para 2B-II.

##### Alternativas evaluadas

| Alternativa | Diseño | Ventajas | Riesgos y costes | Evaluación MVP |
| --- | --- | --- | --- | --- |
| A — política directa sobre `public.users` | Permitir al owner operar sobre su fila cuando `id = auth.uid()`, revocar privilegios amplios y conceder únicamente columnas aprobadas | Es la opción más pequeña; combina RLS de filas con grants explícitos de columnas; facilita pgTAP y rollback | RLS por sí sola no protege columnas; un grant amplio expondría `role`; exige probar privilegios efectivos y mantener deny-by-default para columnas futuras | Recomendada para lectura y actualización mínima del MVP, solo endurecida con permisos por columna |
| B — vista sanitizada de perfil | Exponer una proyección futura de solo lectura con únicamente columnas seguras, filtrada por la RLS de la tabla base | Hace explícito el contrato legible y desacopla nombres futuros | Una vista normal puede eludir RLS; una vista `security_invoker` exige también permisos del invocador sobre las columnas subyacentes, por lo que no elimina la necesidad de grants seguros; añade superficie y rollback | Válida en una evolución posterior, pero no aporta suficiente valor para el primer micro-paquete |
| C — función/backend controlado | Leer, crear y actualizar perfil mediante una función o backend que valide identidad, columnas y auditoría | Máximo control, validación e idempotencia; evita aceptar campos arbitrarios | Mayor complejidad operativa y de pruebas; cualquier función privilegiada mal diseñada puede escalar privilegios; no debe usar `SECURITY DEFINER` por comodidad | Recomendada inicialmente para creación y reparación; reservar mutaciones complejas para esta frontera |

##### Decisión recomendada para MVP

Se recomienda **Alternativa A endurecida para lectura y actualización mínima**,
complementada por la **Alternativa C para creación y reparación idempotente**.

La autorización futura combinaría dos controles independientes:

- RLS limita filas mediante propiedad `id = auth.uid()`;
- privilegios SQL explícitos limitan columnas: se revocan grants amplios y solo
  se conceden las columnas aprobadas para cada operación.

Condiciones obligatorias:

- nunca conceder `SELECT *`, `INSERT`, `DELETE` ni `UPDATE` amplio al cliente;
- permitir lectura owner únicamente de `id` y `display_name`;
- permitir actualización directa únicamente de `display_name`;
- nunca permitir lectura o escritura cliente de `role`;
- aplicar `USING` y `WITH CHECK` de owner para impedir cambio o acceso lateral;
- denegar `anon` y cualquier fila que no pertenezca a `auth.uid()`;
- probar que columnas futuras nacen sin grants cliente;
- disponer de rollback que revoque los grants y políticas permisivas y restaure
  el deny-all de 2B-I.

Una vista sanitizada puede reconsiderarse si aparece una necesidad real de
desacoplar el contrato público del esquema, pero no debe asumirse que una vista
elimina por sí sola los permisos sobre la tabla base. No se aprueba todavía
`SECURITY DEFINER`, Edge Function concreta ni implementación backend.

##### Contrato de columnas propuesto

| Columna actual | Lectura cliente futura | Actualización cliente futura | Decisión |
| --- | --- | --- | --- |
| `id` | Permitida al owner mediante grant explícito | Nunca | Identificador 1:1 derivado de `auth.users.id`; no procede del payload cliente |
| `display_name` | Permitida mediante grant explícito | Permitida directamente al owner solo con grant de columna, RLS y validación aprobada | Campo de perfil; no concede autoridad |
| `avatar_url` | Bloqueada | Bloqueada | Requiere diseño separado de Storage/URL |
| `role` | Nunca | Nunca | Debe deprecarse y eliminarse de `public.users` en una migración futura aprobada; hasta entonces permanece interna e inutilizable como autoridad |
| `created_at` | Bloqueada | Nunca | No es necesaria en esta fase; la establece backend/base |
| `updated_at` | Bloqueada | Nunca | No es necesaria en esta fase; el esquema actual no la actualiza automáticamente |

El cliente nunca debe recibir acceso genérico a columnas futuras añadidas a la
tabla base. Toda nueva columna nace bloqueada hasta revisión explícita.

##### Creación futura del perfil 1:1

Alternativas consideradas:

- **trigger desde Auth:** automatiza el alta, pero introduce lógica privilegiada
  difícil de observar y rollback acoplado; no recomendado como primera opción;
- **función backend idempotente:** crea o repara el perfil después de validar
  una identidad Auth; permite auditoría, reintentos y control de campos;
  recomendada para MVP;
- **Edge Function:** posible implementación de la frontera backend, pero no es
  una decisión aprobada todavía y requiere autenticación, autorización,
  observabilidad y secretos correctos;
- **flujo manual temporal:** solo aceptable para fixtures locales; prohibido
  para usuarios reales.

Se recomienda una operación backend idempotente futura que:

1. tome el identificador exclusivamente de la sesión validada;
2. cree el perfil mínimo si no existe;
3. no acepte `id`, `role`, `created_at` ni `updated_at` desde el cliente;
4. trate repeticiones como éxito seguro sin duplicar ni sobrescribir autoridad;
5. registre resultado y errores sin datos sensibles;
6. mantenga denegación total ante cualquier fallo.

##### Propuesta RLS futura en lenguaje natural

Sin escribir SQL todavía:

- `public.users` mantiene RLS habilitada;
- solo una sesión `authenticated` puede optar a leer la fila cuyo
  `public.users.id` coincide con `auth.uid()`;
- antes de conceder acceso se revocan privilegios amplios y se conceden
  únicamente las columnas legibles aprobadas;
- `anon`, owner sin sesión válida y other user no reciben filas;
- no se concede `INSERT` ni `DELETE` directo al cliente;
- `UPDATE` directo, si se aprueba, se limita al owner y exclusivamente a
  columnas de perfil autorizadas;
- creación, reparación, actualizaciones complejas y eliminación pasan por una
  frontera backend separada y revisada;
- `role`, `id`, timestamps internos y cualquier columna futura permanecen
  bloqueados por defecto;
- rollback elimina la superficie permisiva futura y devuelve `public.users` al
  deny-all ya verificado en 2B-I.

##### Tests obligatorios propuestos para 2B-II

Positivos:

- owner autenticado puede leer únicamente `id` y `display_name` de su perfil;
- una actualización directa válida de `display_name` afecta solo al owner;
- `avatar_url`, `role`, `created_at` y `updated_at` permanecen bloqueadas.

Negativos:

- `anon` no puede leer perfiles;
- owner no puede leer `role` mediante tabla base, selección de columnas extra
  ni payload alternativo;
- owner no puede modificar `role`, `id`, `created_at` ni `updated_at`;
- owner no puede seleccionar, actualizar ni eliminar el perfil de otro usuario;
- usuario A no puede actualizar al usuario B;
- payload con columnas extra falla de forma explícita, no se acepta
  silenciosamente;
- `SELECT *`, `INSERT`, `DELETE` y `UPDATE` amplio continúan denegados;
- una columna nueva añadida a `public.users` no queda accesible al cliente;
- los grants efectivos coinciden exactamente con el contrato aprobado;
- una función o backend futuro falla cerrado sin sesión válida y no confía en
  `userMetadata`;
- rollback revoca grants y policies futuras de 2B-II y restaura el deny-all
  probado por 2B-I;
- ninguna prueba utiliza remoto, datos reales o `service_role` como actor
  cliente.

##### Riesgos y criterios para aprobar implementación de 2B-II

Riesgos principales:

- un grant amplio o por tabla puede exponer `role` o futuras columnas internas;
- grants de columna y políticas RLS pueden divergir;
- una política owner incompleta, especialmente sin `WITH CHECK`, puede permitir
  cambios de propiedad o accesos inesperados;
- la API generada puede comportarse de forma distinta ante columnas sin grant
  y debe probarse expresamente;
- una función privilegiada puede escalar permisos si no valida actor, campos y
  `search_path`;
- `avatar_url` requiere una estrategia Storage separada;
- `updated_at` actual no se mantiene automáticamente;
- retirar `role` puede afectar dependencias todavía no auditadas.

Antes de aprobar implementación deben quedar decididos:

1. nombres exactos de políticas y migración;
2. validación mínima de `display_name`, si debe formar parte de 2B-II o de un
   paquete posterior;
3. SQL exacto de policies, revokes, grants, rollback y suite pgTAP revisados;
4. estrategia de prueba HTTP/PostgREST local;
5. confirmación de que todo se probará localmente sin vincular el proyecto
   remoto.

##### Alcance reducido aprobado para la primera implementación

La primera implementación futura de 2B-II se limita a:

- lectura owner de `id` y `display_name`;
- actualización owner de `display_name`;
- ninguna lectura o escritura cliente de `role`, `avatar_url`, `created_at` o
  `updated_at`;
- ningún `INSERT` o `DELETE` cliente;
- ninguna creación/reparación de perfil, función backend, vista, trigger,
  Storage, Flutter, remoto o backend real.

Este alcance sustituye cualquier propuesta anterior más amplia dentro de
2B-II. La creación y reparación mediante backend controlado permanece como
dirección futura, fuera de la primera implementación.

##### Diseño exacto de migración futura

Nombre propuesto, pendiente de aprobación:

```text
00003_public_users_owner_profile_minimal.sql
```

El orden importa para evitar ventanas de permisos amplios:

1. iniciar transacción;
2. verificar o mantener RLS habilitada en `public.users`;
3. revocar privilegios amplios y privilegios de columna existentes de
   `PUBLIC`, `anon` y `authenticated`;
4. verificar como precondición que no existen políticas con los nombres
   reservados para 2B-II; si existen inesperadamente, fallar y auditar drift;
5. crear política owner de `SELECT` para `authenticated`;
6. crear política owner de `UPDATE` para `authenticated`, con `USING` y
   `WITH CHECK`;
7. conceder `SELECT` únicamente sobre `id` y `display_name` a
   `authenticated`;
8. conceder `UPDATE` únicamente sobre `display_name` a `authenticated`;
9. no conceder ningún privilegio a `anon`;
10. no conceder `INSERT`, `DELETE`, `TRUNCATE`, `REFERENCES` ni `TRIGGER` a
    roles cliente;
11. comprobar mediante catálogo que los grants y políticas coinciden con el
    contrato;
12. confirmar transacción.

Pseudocódigo SQL documental, no autorizado para ejecución:

```sql
BEGIN;

ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;

REVOKE ALL PRIVILEGES ON TABLE public.users
  FROM PUBLIC, anon, authenticated;

CREATE POLICY users_select_own_minimal
ON public.users
FOR SELECT
TO authenticated
USING (id = (SELECT auth.uid()));

CREATE POLICY users_update_own_display_name
ON public.users
FOR UPDATE
TO authenticated
USING (id = (SELECT auth.uid()))
WITH CHECK (id = (SELECT auth.uid()));

GRANT SELECT (id, display_name)
ON TABLE public.users
TO authenticated;

GRANT UPDATE (display_name)
ON TABLE public.users
TO authenticated;

COMMIT;
```

PostgreSQL documenta que revocar privilegios de tabla revoca también los
privilegios de columna correspondientes concedidos por esa vía. Aun así, una
identidad puede conservar privilegios efectivos mediante `PUBLIC` u otro rol
del que sea miembro; por eso la suite debe inspeccionar privilegios efectivos,
no solo grants directos.

La migración hacia delante no elimina políticas existentes silenciosamente.
La reaplicación se prueba reconstruyendo el entorno local o después de ejecutar
el rollback explícito; un nombre de política inesperadamente ocupado se trata
como drift y bloquea la migración.

No se propone `FORCE ROW LEVEL SECURITY`, `SECURITY DEFINER`, vista, función,
trigger, grant de tabla completo ni política para `anon`.

##### Diseño exacto de políticas RLS

| Política propuesta | Actor | Operación | `USING` | `WITH CHECK` | Resultado esperado |
| --- | --- | --- | --- | --- | --- |
| `users_select_own_minimal` | `authenticated` | `SELECT` | `id = auth.uid()` | No aplica | El owner puede obtener su fila; otros usuarios obtienen cero filas |
| `users_update_own_display_name` | `authenticated` | `UPDATE` | `id = auth.uid()` | `id = auth.uid()` | El owner puede actualizar una fila propia sin convertirla en fila ajena |

RLS limita filas, mientras los grants limitan columnas. Ninguna de estas capas
debe considerarse suficiente por separado.

##### Diseño exacto de grants por columna

Estado objetivo para roles cliente:

| Rol | Privilegio objetivo |
| --- | --- |
| `PUBLIC` | Ninguno sobre `public.users` |
| `anon` | Ninguno sobre `public.users` |
| `authenticated` | `SELECT(id, display_name)` y `UPDATE(display_name)` solamente |

Invariantes obligatorias:

- `authenticated` no tiene privilegios de tabla completos;
- `authenticated` no tiene `INSERT`, `DELETE`, `TRUNCATE`, `REFERENCES` ni
  `TRIGGER`;
- ninguna concesión incluye `role`, `avatar_url`, `created_at` o `updated_at`;
- una futura columna nueva no recibe permiso automáticamente;
- no se modifican permisos de roles privilegiados usados exclusivamente por
  backend/harness local.

##### Diseño exacto de tests pgTAP y SQL

La suite futura debe crear dos identidades ficticias A y B dentro de una
transacción que termine en rollback. Debe simular `anon` y `authenticated`,
establecer el claim local de `sub` para A o B y nunca usar `service_role` como
actor de prueba cliente.

Pruebas estructurales:

- RLS sigue habilitada y no forzada;
- existen exactamente las dos políticas 2B-II esperadas;
- sus operaciones, roles, `USING` y `WITH CHECK` coinciden con el diseño;
- `PUBLIC` y `anon` no tienen privilegios;
- `authenticated` tiene únicamente `SELECT(id, display_name)` y
  `UPDATE(display_name)`;
- `authenticated` no tiene privilegios sobre columnas bloqueadas ni permisos
  amplios de tabla;
- `authenticated` no obtiene privilegios efectivos inesperados mediante
  `PUBLIC` o membresías de rol;
- ninguna otra tabla o política cambia.

Pruebas `SELECT`:

- `anon` no puede leer;
- authenticated A no puede leer B;
- owner A puede leer únicamente `id` y `display_name` de A;
- owner no puede seleccionar `role`, `avatar_url`, `created_at` ni
  `updated_at`;
- owner no puede ejecutar `SELECT *`;
- una selección owner no filtra columnas bloqueadas ni datos de B.

Pruebas `UPDATE`:

- owner A puede actualizar `display_name` de A;
- owner no puede actualizar `role`, `avatar_url`, `created_at` ni
  `updated_at`;
- owner no puede cambiar `id` por falta de grant; adicionalmente, una prueba
  aislada dentro de una transacción puede conceder temporalmente
  `UPDATE(id)` a `authenticated` y debe demostrar que `WITH CHECK` rechaza
  cambiar la fila a un ID ajeno, revocando el grant antes del rollback;
- A no puede actualizar B;
- `anon` no puede actualizar;
- un payload mixto con `display_name` y una columna bloqueada falla completo y
  no aplica parcialmente el nombre.

Pruebas `INSERT` y `DELETE`:

- `anon`, authenticated y owner no pueden insertar;
- `anon`, authenticated y owner no pueden borrar;
- los fixtures permanecen intactos salvo el cambio de `display_name`
  explícitamente permitido.

Pruebas de rollback y reaplicación:

- rollback de 2B-II elimina solo sus dos políticas y revoca sus grants;
- RLS permanece habilitada;
- el estado resultante coincide con 2B-I: cero políticas y deny-all cliente;
- reaplicación restaura exactamente las dos políticas y grants mínimos;
- toda la suite vuelve a pasar después de reaplicar.

Las pruebas de falta de privilegios deben comprobar tanto catálogo
(`has_table_privilege`, `has_column_privilege`, `pg_policies`) como operaciones
reales. Comprobar solo el catálogo no demuestra comportamiento; comprobar solo
DML no demuestra ausencia de grants peligrosos.

##### Comportamiento esperado con Supabase/PostgREST

Los grants por columna son compatibles conceptualmente con PostgreSQL y
PostgREST, pero deben validarse contra el runtime local exacto antes de aprobar
cualquier conexión:

- una petición autenticada que seleccione explícitamente `id,display_name`
  debe devolver solo la fila owner;
- una petición que solicite `role`, `avatar_url`, `created_at` o `updated_at`
  debe fallar cerrada por privilegio insuficiente;
- `select=*` referencia también columnas bloqueadas y debe fallar completo, no
  devolver silenciosamente una proyección parcial;
- un `PATCH` que contenga solo `display_name` puede optar a modificar la fila
  owner;
- un `PATCH` que incluya cualquier columna bloqueada debe fallar completo;
- filtros o payloads dirigidos a otro ID no deben modificar filas;
- PostgREST puede representar un privilegio insuficiente como respuesta HTTP
  no exitosa asociada al SQLSTATE `42501`, habitualmente `403`, pero el status,
  código y cuerpo exactos deben capturarse en tests HTTP locales y no asumirse;
- la respuesta de error no debe filtrar valores de columnas ni existencia de
  perfiles ajenos.

La suite SQL/pgTAP no demuestra por sí sola este comportamiento HTTP. El plan
de implementación debe añadir pruebas locales contra PostgREST para:

1. selección owner permitida;
2. selección other vacía;
3. columnas bloqueadas y `select=*` denegados;
4. `PATCH display_name` owner permitido;
5. payload mixto y update other denegados.

Si PostgREST no ofrece un comportamiento estable y verificable con grants por
columna, 2B-II debe detenerse y volver a revisión. Una vista sanitizada
`security_invoker` podría reevaluarse, pero no se implementará automáticamente
porque también requiere permisos subyacentes y pruebas contra bypass de RLS.

##### Rollback exacto propuesto

El rollback futuro debe volver exactamente al estado seguro de 2B-I, no
deshabilitar RLS:

```sql
BEGIN;

DROP POLICY IF EXISTS users_select_own_minimal ON public.users;
DROP POLICY IF EXISTS users_update_own_display_name ON public.users;

REVOKE ALL PRIVILEGES ON TABLE public.users
  FROM PUBLIC, anon, authenticated;

ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;

COMMIT;
```

Después del rollback deben verificarse RLS habilitada, cero políticas, cero
privilegios cliente y denegación de `SELECT`, `UPDATE`, `INSERT` y `DELETE`
para owner, other y `anon`. Después se reaplicará la migración y se repetirán
todos los tests SQL y HTTP locales.

##### Riesgos y criterios para aprobar implementación SQL

Riesgos específicos:

- grants heredados, por tabla o mediante `PUBLIC` podrían ampliar el contrato;
- `SELECT *` y payloads mixtos pueden comportarse de forma distinta según
  PostgreSQL/PostgREST y deben fallar cerrados;
- la política `UPDATE` no limita columnas; esa protección depende de grants
  correctos;
- `WITH CHECK` protege ownership, pero no sustituye la ausencia de grant sobre
  `id`;
- errores de PostgREST podrían filtrar metadatos si no se inspeccionan;
- una migración de rollback demasiado amplia podría retirar permisos ajenos;
- `display_name` todavía carece de límites y normalización aprobados.

Criterios que autorizaron la implementación local y quedaron cumplidos:

1. aprobar nombres de migración y políticas;
2. aprobar que `display_name` se permita inicialmente sin añadir todavía
   constraint de formato, o definir ese constraint en un paquete separado;
3. aprobar el pseudocódigo de revokes, grants y rollback;
4. aprobar suite SQL/pgTAP y pruebas HTTP/PostgREST locales;
5. mantener remoto, backend real, Auth real, Flutter y datos reales bloqueados;
6. exigir evidencia local completa antes de cerrar 2B-II.

##### Resultado de implementación local de 2B-II

Fecha: 2026-06-13.

Implementado:

- migración `00003_public_users_owner_profile_minimal.sql`;
- precondición que falla ante políticas previas inesperadas;
- revocación de privilegios amplios de `PUBLIC`, `anon` y `authenticated`;
- política `users_select_own_minimal`;
- política `users_update_own_display_name` con `USING` y `WITH CHECK`;
- grants exclusivos `SELECT(id, display_name)` y `UPDATE(display_name)`;
- evolución del test 2B-I para conservar sus invariantes bajo 2B-II;
- suite 2B-II con 38 pruebas SQL/pgTAP;
- checklist PostgREST local ejecutado con dos usuarios ficticios.

Evidencia SQL verificada:

- reset local aplicó `00001`, `00002` y `00003`;
- test base 2B-I: 6 de 6 pruebas superadas;
- test 2B-II: 38 de 38 pruebas superadas;
- `public.users` mantiene RLS habilitada y no forzada;
- existen exactamente las dos políticas esperadas;
- grants cliente efectivos: `authenticated SELECT(id, display_name)` y
  `authenticated UPDATE(display_name)`;
- `anon` no tiene grants y ninguna otra tabla recibió RLS o políticas;
- una reaplicación directa de `00003` falla con
  `Unexpected policies exist on public.users before 2B-II`, demostrando el
  bloqueo ante drift.

Evidencia PostgREST local verificada:

- owner recibió solo su `id` y `display_name` con HTTP `200`;
- other filtrado explícitamente devolvió `[]`;
- `select=*`, `role`, `avatar_url`, `created_at` y `updated_at` devolvieron
  SQLSTATE `42501` con HTTP `403`;
- `anon` recibió `42501` con HTTP `401`;
- PATCH owner de `display_name` devolvió HTTP `204` y persistió;
- PATCH de `role` y payload mixto devolvieron `42501` y no modificaron
  parcialmente `display_name`;
- PATCH de B sobre A devolvió HTTP `204` con cero filas afectadas y no alteró
  el perfil de A.

Rollback y reaplicación verificados:

- rollback eliminó ambas políticas y todos los grants cliente;
- RLS permaneció habilitada, no forzada, con cero políticas;
- owner quedó nuevamente bajo deny-all con error de permisos;
- reset reaplicó `00003`;
- después de reaplicar, 6/6 y 38/38 tests volvieron a superar.

Limitaciones y riesgos residuales:

- `display_name` todavía no tiene validación de longitud o normalización;
- PostgREST responde `204` cuando RLS filtra un UPDATE de otra fila; el cliente
  no debe interpretar ese código por sí solo como confirmación de mutación;
- `role` sigue físicamente en el esquema, aunque permanece inaccesible;
- no existe creación/reparación automática de perfil;
- Supabase CLI local es `2.75.0`; no se actualizó;
- esta evidencia no autoriza remoto, backend real, Auth real ni datos reales.

##### Cierre formal de 2B-II

Fecha de cierre aprobada: 2026-06-13.

Queda aceptado que:

- `00003_public_users_owner_profile_minimal.sql` fue creada y `00001`/`00002`
  permanecen intactas;
- RLS solo se habilitó sobre `public.users`;
- owner puede leer únicamente `id` y `display_name`;
- owner puede actualizar únicamente `display_name`;
- `role`, `avatar_url`, `created_at`, `updated_at`, `SELECT *`, `INSERT`,
  `DELETE`, `anon` y other user permanecen bloqueados;
- rollback vuelve exactamente al deny-all de 2B-I y la reaplicación restaura
  2B-II;
- pgTAP y PostgREST fueron verificados en local;
- no se conectó Supabase remoto, no se usaron datos reales y no se activaron
  backend real, Auth real o Flutter.

2B-II queda cerrado como superficie SQL local mínima. Su cierre no autoriza
consumo desde Flutter, conexión remota, creación automática de perfil ni uso
con usuarios reales.

Referencias técnicas primarias usadas para validar el plan:

- PostgreSQL `REVOKE`: revocar privilegios de tabla revoca los privilegios de
  columna correspondientes, pero los privilegios efectivos pueden proceder de
  `PUBLIC` o membresías:
  <https://www.postgresql.org/docs/current/sql-revoke.html>;
- Supabase Column Level Security: RLS limita filas, los privilegios limitan
  columnas y los roles restringidos no pueden usar `select=*`:
  <https://supabase.com/docs/guides/database/postgres/column-level-security>;
- Supabase Database API `42501`: columnas restringidas y `select=*` fallan con
  privilegios insuficientes, normalmente representados como `401` o `403`:
  <https://supabase.com/docs/guides/troubleshooting/database-api-42501-errors>.

Paquetes posteriores separados:

- **2B-II:** cerrado formalmente; no ampliar sin nuevo gate;
- **2C-I:** contrato de perfil propio implementado, verificado y cerrado
  formalmente sin integración backend;
- **2C-II:** contrato de `chat_sessions` preparado documentalmente, pendiente
  de aprobación;
- **2C-III:** impedir `user_id` y roles arbitrarios desde Flutter al resolver
  el contrato futuro de mensajes;
- **2B-III:** diseñar e implementar catálogo sanitizado/RLS de especialistas;
- **2B-IV:** diseñar e implementar RLS de `chat_sessions`;
- **2B-V:** diseñar e implementar RLS de `messages` con pruebas de propiedad y
  falsificación de roles.

#### Tests positivos y negativos propuestos

Mínimos para 2B-I:

- migración aplica en base local vacía;
- RLS queda habilitada en `public.users`;
- harness/backend controlado puede preparar y limpiar fixtures;
- anon no puede seleccionar, insertar, actualizar ni borrar;
- usuario autenticado owner tampoco accede mientras no haya política;
- usuario A no puede acceder al registro de B;
- payload no puede cambiar `role`;
- rollback revierte el cambio en entorno local y una reaplicación funciona;
- ninguna credencial privilegiada aparece en Flutter, logs o fixtures
  versionados.

Obligatorios antes de cualquier política permisiva futura:

- owner realiza solo la acción y columnas aprobadas;
- other user falla en `SELECT/INSERT/UPDATE/DELETE`;
- usuario no cambia propietario mediante payload;
- usuario no falsifica roles de mensajes;
- usuario no accede a prompts, salud, permisos o IDs financieros;
- funciones auxiliares no recursan ni amplían privilegios;
- errores no filtran existencia o contenido de filas ajenas;
- consultas RLS usan índices adecuados;
- tests se ejecutan en CI contra entorno local o efímero.

### 2C — Contratos Flutter/backend

**Objetivo:** definir la frontera operativa sin conectar backend real.

Entregables:

- matriz de operaciones directas permitidas desde Flutter;
- matriz de operaciones obligatorias de función/backend;
- contratos de errores de autenticación, autorización y red;
- contratos de perfil, chat y catálogo sanitizado;
- reglas para sesiones, refresh, revocación y cierre de sesión;
- lista de flujos que permanecen demo.

Gate de salida:

- Flutter no decide autorización ni contiene secretos;
- ninguna operación sensible carece de frontera y owner.

#### 2C-I — Contrato Flutter/backend para perfil propio

**Objetivo:** definir cómo una futura implementación Flutter consumirá el
perfil owner mínimo demostrado por 2B-II, sin ampliar columnas, interpretar
éxitos ambiguos ni conectar todavía backend real.

Estado: contrato Flutter implementado, verificado y cerrado formalmente sin
conexión backend. No existe adaptador Supabase ejecutable, integración visual,
Auth real ni backend real autorizado para 2C-I.

2C-I permanece dentro de ADR-006 porque concreta la frontera de identidad,
autorización y RLS ya decidida. No requiere un ADR separado mientras no cambie
esas decisiones, introduzca una nueva frontera backend o amplíe datos y
permisos.

##### Principios obligatorios del contrato

- el modo demo no llama Supabase ni simula éxito backend;
- backend real permanece bloqueado hasta aprobación independiente;
- el repositorio solicita columnas explícitas; `select=*` está prohibido;
- el contrato de perfil contiene únicamente `id` y `displayName`;
- Flutter nunca envía ni modela como editables `id`, `role`, `avatar_url`,
  `created_at` o `updated_at`;
- una respuesta HTTP exitosa no demuestra por sí sola que se modificó una
  fila;
- errores de autenticación, autorización, red y contrato son visibles y
  diferenciables;
- ausencia de perfil no se convierte en perfil ficticio ni en éxito;
- ninguna clave, `service_role` o decisión administrativa llega a Flutter.

##### Contrato futuro de lectura de perfil propio

Operación conceptual:

```text
readOwnProfile() -> OwnProfileResult
```

Llamada PostgREST futura esperada:

```http
GET /rest/v1/users?select=id,display_name
Authorization: Bearer <sesión autenticada>
```

No se necesita enviar un ID propietario como fuente de autorización: RLS deriva
el owner de `auth.uid()`. Si se añade un filtro por ID por eficiencia, debe
proceder exclusivamente de la identidad central validada, nunca de entrada
arbitraria de UI.

Contrato de éxito:

- HTTP `200`;
- cuerpo JSON con exactamente una fila;
- la fila contiene únicamente `id` y `display_name`;
- `id` coincide con `CurrentIdentity.userId`;
- se mapea a un modelo de perfil sin roles, permisos o columnas internas.

Resultados no exitosos:

| Situación | Evidencia esperada | Resultado de dominio/UI |
| --- | --- | --- |
| Sin sesión | No se realiza llamada o respuesta `401` | `profileUnauthenticated`; solicitar autenticación futura, no mostrar perfil demo |
| Sesión inválida/expirada | `401` | `profileSessionInvalid`; limpiar/renovar sesión solo mediante flujo Auth aprobado |
| Permiso denegado o contrato inseguro | `403` / `42501` | `profilePermissionDenied`; visible y reportable |
| Perfil inexistente | HTTP `200` con `[]` | `profileMissing`; no crear automáticamente desde Flutter |
| Más de una fila | HTTP `200` con longitud mayor que uno | `profileContractViolation`; bloquear y registrar sin contenido sensible |
| ID distinto al identity central | Fila con ID inesperado | `profileContractViolation`; descartar respuesta |
| Backend bloqueado | Gate de entorno antes de red | `profileBackendBlocked`; ninguna llamada |
| Modo demo | Fuente demo explícita | Perfil demo marcado; ninguna llamada Supabase |
| Red/timeout | Fallo de transporte | `profileNetworkFailure`; permitir reintento consciente |
| Respuesta inválida | JSON/columnas/tipos inesperados | `profileUnexpectedFailure`; fallar cerrado |

El repositorio nunca debe traducir `[]`, `401`, `403`, error de red o respuesta
inválida a un perfil demo o a un perfil vacío aparentemente válido.

##### Contrato futuro de actualización de `display_name`

Operación conceptual:

```text
updateOwnDisplayName(displayName) -> UpdateOwnDisplayNameResult
```

Payload permitido:

```json
{"display_name": "<valor-validado>"}
```

Payloads prohibidos:

- cualquier payload con `id`, `role`, `avatar_url`, `created_at` o
  `updated_at`;
- mapas genéricos procedentes directamente de formularios;
- payload vacío o con columnas desconocidas;
- selección o actualización `*`.

La validación mínima de `display_name` debe aprobarse antes de implementar:

- normalización de espacios;
- política de vacío/nulo;
- longitud mínima y máxima;
- caracteres permitidos y Unicode;
- tratamiento de contenido ofensivo o suplantación, si Producto lo requiere.

Llamada PostgREST futura recomendada:

```http
PATCH /rest/v1/users?id=eq.<CurrentIdentity.userId>&select=id,display_name
Authorization: Bearer <sesión autenticada>
Prefer: return=representation
Content-Type: application/json

{"display_name":"<valor-validado>"}
```

El filtro por ID no concede autoridad; RLS continúa siendo el control
obligatorio. El ID procede únicamente de `CurrentIdentity`.

Contrato de éxito real:

- HTTP `200`;
- exactamente una fila devuelta;
- `id` coincide con `CurrentIdentity.userId`;
- `display_name` coincide con el valor normalizado solicitado;
- solo entonces el repositorio devuelve `profileUpdateConfirmed`.

Tratamiento obligatorio de `204`:

- `204` no se interpreta como éxito confirmado;
- se clasifica como `profileUpdateUnconfirmed`, porque puede representar cero
  filas modificadas;
- no se muestra confirmación de guardado;
- no se actualiza caché persistente como si el servidor hubiera aceptado;
- puede ofrecerse reintento consciente o lectura de verificación, sin bucle ni
  retry silencioso.

Otros resultados:

| Situación | Resultado |
| --- | --- |
| HTTP `200` con `[]` | `profileUpdateNoRows`; no éxito |
| HTTP `200` con más de una fila | `profileContractViolation` |
| Fila/ID/nombre inesperado | `profileContractViolation` |
| `401` | `profileUnauthenticated` o `profileSessionInvalid` según estado de sesión |
| `403` / `42501` | `profilePermissionDenied` o `profileColumnForbidden` cuando pueda clasificarse sin depender de texto frágil |
| Red/timeout | `profileNetworkFailure` |
| Backend bloqueado | `profileBackendBlocked`; ninguna llamada |
| Modo demo | actualización solo en repositorio demo explícito, nunca presentada como persistencia real |

La UI debe conservar el valor confirmado anterior. Puede editar en un estado
temporal, pero ante error, `204` no confirmado o cero filas debe restaurar o
mostrar claramente el valor previo y mantener disponible el texto intentado
para reintento manual. No debe mostrar “guardado” antes de recibir éxito real.

##### Errores y estados UI obligatorios

| Estado | Significado | Comportamiento UI mínimo |
| --- | --- | --- |
| `demo` | Perfil ficticio local explícito | Banner demo; no sugerir persistencia real |
| `backendBlocked` | Gate impide consumir backend | Explicar indisponibilidad; ninguna llamada |
| `unauthenticated` | No existe sesión | Mostrar estado de acceso requerido futuro |
| `sessionInvalid` | Sesión expirada/revocada/inválida | No reintentar mutación; iniciar flujo Auth aprobado |
| `profileMissing` | Sesión válida sin fila de perfil | Mostrar error recuperable; no crear desde Flutter |
| `permissionDenied` | RLS/grants deniegan operación | Mensaje visible; no degradar a demo |
| `columnForbidden` | Contrato intentó columna bloqueada | Tratar como defecto de implementación y registrar |
| `updateUnconfirmed` | HTTP `204` o resultado sin prueba de fila modificada | No confirmar guardado; ofrecer verificación/reintento |
| `networkFailure` | Sin respuesta válida por red/timeout | Mantener valor previo; reintento manual |
| `contractViolation` | Filas múltiples, ID distinto o forma inesperada | Fallar cerrado; no mostrar datos |
| `unexpectedFailure` | Error no clasificado | Mensaje visible y trazabilidad mínima sin secretos |
| `loading` / `updating` | Operación en curso | Evitar dobles envíos y conservar estado anterior |
| `ready` / `updateConfirmed` | Perfil o actualización verificados | Mostrar únicamente datos confirmados |

No se deben distinguir errores de autorización mediante parsing frágil del
texto humano. Deben priorizarse status HTTP, SQLSTATE/código estructurado y
estado de sesión.

##### Tests futuros obligatorios de 2C-I

Tests de arquitectura/contrato:

- el repositorio de perfil no contiene `select=*`;
- lectura solicita exactamente `id,display_name`;
- update construye únicamente `{"display_name": ...}`;
- el tipo de payload no permite columnas extra;
- modelos de perfil no contienen `role`, `avatarUrl`, timestamps ni permisos;
- el adaptador real no puede instanciarse cuando backend permanece bloqueado;
- modo demo selecciona repositorio demo y no invoca Supabase.

Tests de lectura:

- una fila owner válida se mapea correctamente;
- `[]` produce `profileMissing`;
- más de una fila o ID distinto producen `profileContractViolation`;
- `401` y `403` producen errores visibles distintos;
- columna no autorizada/`42501` no produce fallback demo;
- errores de red permanecen visibles.

Tests de actualización:

- solo se envía `display_name`;
- se solicita retorno explícito de `id,display_name`;
- HTTP `200` con exactamente una fila coincidente confirma éxito;
- HTTP `204` produce `profileUpdateUnconfirmed`, nunca éxito;
- HTTP `200` con `[]` produce `profileUpdateNoRows`;
- payloads con columnas extra no pueden construirse;
- `401`, `403`, `42501`, red y respuesta inválida no se convierten en éxito;
- UI no muestra guardado antes de confirmación y conserva/restaura el valor
  anterior ante fallo.

Gate de salida de 2C-I:

- contrato aprobado por Flutter, Backend, Seguridad, AppSec y QA;
- validación de `display_name` decidida;
- estados y errores aprobados;
- tests exactos acordados;
- backend real, Auth real y remoto continúan bloqueados;
- implementación requiere aprobación separada.

##### Resultado de implementación de 2C-I

Fecha: 2026-06-13.

Implementado dentro de `lib/features/profile/`:

- entidad mínima `OwnProfile` con `id`, `displayName` e indicador explícito
  `isDemo`;
- resultados sellados y diferenciados para lectura y actualización;
- contrato `OwnProfileRepository`;
- contrato tipado `OwnProfileRemoteDataSource`, sin implementación Supabase
  ejecutable;
- modelo estricto que acepta exactamente `id` y `display_name`;
- repositorio de contrato que valida status, número de filas, columnas, ID y
  valor confirmado;
- repositorio demo local y explícito;
- repositorio backend bloqueado;
- provider que selecciona demo en modo demo y bloqueo explícito en cualquier
  modo backend.

Validación implementada para `display_name`:

- trim inicial y final;
- no vacío;
- mínimo 2 y máximo 40 puntos de código visibles aproximados;
- rechazo de saltos de línea;
- rechazo de caracteres de control;
- permite letras, números, espacios normales, acentos, guion, guion bajo y
  punto;
- no añade una prohibición específica de emojis, conforme al alcance aprobado;
- no implementa unicidad, moderación, profanity filter ni normalización
  avanzada.

Semántica de contrato verificada:

- respuesta de lectura vacía produce `OwnProfileMissing`;
- múltiples filas, ID inesperado, tipos o columnas extra producen
  `OwnProfileContractViolation`;
- `401` produce resultado no autenticado;
- `403` o `42501` producen permiso denegado visible;
- error de red permanece visible;
- update inválido no llega al datasource;
- update `204` produce `UpdateOwnDisplayNameUnconfirmed`, nunca éxito;
- update `200` vacío produce perfil inexistente;
- éxito requiere exactamente una fila con ID y nombre confirmado coincidentes;
- demo nunca usa datasource remoto y queda marcado con `isDemo = true`;
- cualquier modo backend selecciona `BackendBlockedOwnProfileRepository`.

Evidencia:

- `dart run build_runner build --delete-conflicting-outputs`: completado, cero
  outputs nuevos;
- `flutter analyze --no-fatal-infos`: sin errores ni warnings bloqueantes; 48
  avisos informativos preexistentes y ninguno nuevo de perfil;
- tests específicos de perfil/arquitectura: 19 de 19 superados;
- suite completa Flutter: 34 de 34 tests superados;
- `git diff --check`: correcto.

Riesgos residuales de 2C-I:

- no existe adaptador real, UI de perfil ni persistencia backend;
- contar puntos de código es una aproximación y no equivale siempre a grafemas
  visuales Unicode;
- la política exacta de símbolos no alfanuméricos puede requerir refinamiento
  de Producto antes de datos reales;
- `UserProfile` antiguo de Auth continúa separado y no debe confundirse con
  `OwnProfile`;
- backend real, Auth real y remoto continúan bloqueados.

##### Cierre formal de 2C-I

Fecha de cierre aprobada: 2026-06-13.

Queda aceptado que:

- `OwnProfile` contiene únicamente `id`, `displayName` e `isDemo`;
- lectura y actualización tienen resultados diferenciados y fallan cerrado;
- HTTP `204` no se interpreta como actualización confirmada;
- `display_name` dispone de validación mínima;
- demo usa un repositorio local explícito;
- cualquier modo no demo devuelve backend bloqueado;
- no existe adaptador Supabase ejecutable;
- build runner finalizó correctamente, el análisis no añadió errores o warnings
  bloqueantes y la suite completa superó 34 de 34 tests;
- Supabase, CI, plataformas, UI, Auth real, chat, Storage y remoto no fueron
  modificados ni conectados.

2C-I queda cerrado como contrato Flutter preparado pero desconectado. Su cierre
no autoriza adaptador real, UI, Auth real, backend real o remoto.

#### 2C-II — Contrato Flutter/backend para `chat_sessions`

**Objetivo:** definir cómo listar, crear y archivar sesiones propias sin
permitir que Flutter asigne ownership, manipule campos server-managed o
habilite chat real antes de RLS y pruebas.

Estado: contrato documental aprobado el 2026-06-13, pero no implementado. No
existe SQL, RLS, función, adaptador Flutter o backend real autorizado para
2C-II. La creación real de sesiones permanece bloqueada hasta aprobar y
resolver el catálogo seguro mínimo de especialistas definido en 2C-II-A.

Nota normativa posterior: el plan exacto 2B-IV documentado en ADR-007 refina y
supera las partes de 2C-II que proponían exponer o enviar `specialist_id` /
`specialistId`. Para cualquier implementación futura rige exclusivamente
`selectableSpecialistId` como entrada pública; `user_id` y `specialist_id`
interno nunca son visibles, enviables ni escribibles por Flutter. El resto de
2C-II se conserva como antecedente documental no ejecutable.

2C-II permanece dentro de ADR-006 porque concreta propiedad, autorización y
frontera de ejecución de `chat_sessions`. Deberá proponerse un ADR separado si
la implementación futura introduce una API/RPC propia reutilizable, reglas de
idempotencia complejas, ciclo de vida de sesión adicional o decisiones que
excedan identidad y RLS.

##### Estado real y dependencias bloqueantes

La tabla actual contiene:

```text
id
user_id
specialist_id
started_at
last_message_at
status
message_count
```

Problemas verificados:

- `user_id` y `specialist_id` permiten `NULL`;
- Flutter actual envía `user_id` al crear una sesión;
- `specialists` continúa sin contrato seguro ni RLS aprobada;
- `messages` continúa sin RLS y fuera de 2C-II;
- el RPC `increment_message_count` invocado actualmente no existe;
- no se ha definido unicidad o idempotencia de sesión activa por especialista;
- no existe RLS en `chat_sessions`.

Por tanto, el contrato es diseño futuro. Chat real continúa bloqueado.

##### Contrato futuro de listado de sesiones propias

Operación conceptual:

```text
listOwnChatSessions(pageRequest) -> OwnChatSessionsResult
```

Proyección explícita permitida:

```text
id,specialist_id,started_at,last_message_at,status,message_count
```

`user_id` no se devuelve porque no aporta valor al owner y no debe convertirse
en parámetro de confianza. `select=*` queda prohibido.

Orden estable obligatorio:

```text
last_message_at DESC, id DESC
```

Paginación mínima propuesta:

- tamaño por defecto: 20;
- tamaño máximo: 50;
- cursor estable compuesto por `last_message_at` e `id`;
- sin carga ilimitada;
- offset solo podría aceptarse como solución provisional local si se documenta
  su inestabilidad ante nuevos mensajes.

Estados de sesión visibles permitidos:

```text
active
archived
```

Cualquier estado desconocido constituye violación de contrato. El filtro
opcional de estado solo acepta esos valores.

Contrato de éxito:

- sesión autenticada;
- HTTP `200`;
- cero o más filas, todas con exactamente las columnas aprobadas;
- todas las sesiones pertenecen implícitamente al owner por RLS;
- orden y límites respetados;
- cursor siguiente derivado únicamente de la última fila válida.

Resultados y errores:

| Situación | Resultado de contrato/UI |
| --- | --- |
| Cero sesiones | Lista vacía válida, no error |
| Sin sesión / `401` | `chatSessionsUnauthenticated` |
| Sesión inválida | `chatSessionsSessionInvalid` |
| `403` / `42501` | `chatSessionsPermissionDenied` |
| Columnas extra, estado desconocido o forma inválida | `chatSessionsContractViolation` |
| Backend bloqueado | `chatSessionsBackendBlocked`; ninguna llamada |
| Modo demo | Repositorio demo explícito; ninguna llamada Supabase |
| Red/timeout | `chatSessionsNetworkFailure` |
| Error inesperado | `chatSessionsUnexpectedFailure` |

La RLS futura deberá asegurar que usuario A nunca recibe sesiones de B. Flutter
no filtra ownership como control de seguridad.

##### Contrato futuro de creación de sesión propia

Operación conceptual:

```text
createOwnChatSession(specialistId) -> CreateOwnChatSessionResult
```

Payload permitido desde Flutter:

```json
{"specialist_id":"<id-validado>"}
```

Flutter nunca envía:

- `user_id`;
- `id`;
- `started_at`;
- `last_message_at`;
- `status`;
- `message_count`;
- campos de especialista, mensajes o roles.

La creación no debe exponerse inicialmente como `INSERT` genérico directo a
`chat_sessions`. Se recomienda una frontera backend/RPC futura y revisada que:

1. derive `user_id` exclusivamente de la sesión validada mediante
   `auth.uid()`;
2. valide que existe perfil owner autorizado;
3. valide que el especialista existe, está activo, no está bloqueado para el
   usuario y puede participar en ese contexto;
4. defina idempotencia: devolver sesión activa existente o crear una nueva
   según una decisión de producto todavía pendiente;
5. establezca server-side `id`, timestamps, `status = active` y
   `message_count = 0`;
6. devuelva exactamente una proyección segura y confirmada;
7. no cree mensajes ni invoque IA dentro de 2C-II;
8. registre errores sin filtrar prompts o configuración de especialistas.

Resultados obligatorios:

| Situación | Resultado |
| --- | --- |
| Creación confirmada con una fila | `chatSessionCreateConfirmed` |
| Especialista inexistente | `chatSessionSpecialistNotFound` sin filtrar datos internos |
| Especialista inactivo/bloqueado/no permitido | `chatSessionSpecialistUnavailable` |
| Sin sesión / sesión inválida | Resultado autenticación visible; ninguna creación |
| Perfil owner inexistente | `chatSessionOwnerProfileMissing`; no crear desde Flutter |
| HTTP `204`, cero filas o respuesta ambigua | `chatSessionCreateUnconfirmed`; nunca éxito |
| Más de una fila o columnas inesperadas | `chatSessionsContractViolation` |
| Backend bloqueado | `chatSessionsBackendBlocked`; ninguna llamada |
| Modo demo | Sesión demo explícita; ninguna llamada Supabase |

La decisión exacta entre RPC Supabase, Edge Function o API controlada debe
aprobarse antes de implementación. No se aprueba `SECURITY DEFINER` por
comodidad ni acceso cliente directo a `specialists`.

##### Contrato futuro de archivado de sesión propia

Operación conceptual:

```text
archiveOwnChatSession(sessionId) -> ArchiveOwnChatSessionResult
```

Reglas:

- solo owner puede archivar;
- Flutter envía únicamente `sessionId`;
- no existe `DELETE` físico desde Flutter;
- no se permite update genérico de `status`;
- la frontera controlada establece exclusivamente `status = archived`;
- no se permite reactivar mediante este contrato;
- `message_count`, ownership, especialista y timestamps no son editables por
  Flutter;
- archivar no borra ni modifica mensajes dentro de 2C-II.

Éxito confirmado:

- respuesta HTTP exitosa con exactamente una sesión;
- `id` coincide con `sessionId`;
- `status` es `archived`;
- respuesta contiene únicamente la proyección segura aprobada;
- solo entonces se devuelve `chatSessionArchiveConfirmed`.

HTTP `204`, cero filas afectadas o lista vacía significan
`chatSessionArchiveUnconfirmed`, nunca éxito. Esto cubre especialmente el caso
de intentar archivar una sesión ajena sin filtrar si existe.

Otros resultados:

- sesión inexistente o no visible: no confirmar éxito ni revelar ownership;
- `401`: no autenticado/sesión inválida;
- `403` / `42501`: permiso denegado visible;
- estado o fila inesperados: violación de contrato;
- backend bloqueado: ninguna llamada;
- demo: archivado solo en repositorio demo explícito.

##### Clasificación de columnas de `chat_sessions`

| Columna | Visible al cliente owner | Escribible por Flutter | Server-managed | Decisión |
| --- | --- | --- | --- | --- |
| `id` | Sí | Nunca | Sí | Identificador estable devuelto por frontera controlada |
| `user_id` | No | Nunca | Sí, derivado de `auth.uid()` | Debe pasar a `NOT NULL`; nunca confiar en payload |
| `specialist_id` | Sí | Solo como petición de creación tipada | Validado por backend | Dependencia bloqueada hasta catálogo seguro de especialistas |
| `started_at` | Sí | Nunca | Sí | Debe revisarse futuro `TIMESTAMPTZ NOT NULL` |
| `last_message_at` | Sí | Nunca | Sí | Solo cambia al persistir mensajes mediante frontera futura |
| `status` | Sí, solo `active`/`archived` | Nunca mediante update genérico | Sí; archivado por operación controlada | No permitir reactivación o estados arbitrarios |
| `message_count` | Sí como dato derivado provisional | Nunca | Sí | RPC actual inexistente; requiere fuente consistente/rediseño |

La visibilidad futura de timestamps y `message_count` no autoriza su escritura.
Si no pueden garantizarse consistencia y semántica, deberán retirarse de la
primera proyección antes de implementación.

##### Errores y estados UI de 2C-II

Flutter deberá distinguir como mínimo:

- `demo`;
- `backendBlocked`;
- `unauthenticated`;
- `sessionInvalid`;
- `loading`;
- `readyEmpty`;
- `readyWithSessions`;
- `specialistNotFound`;
- `specialistUnavailable`;
- `ownerProfileMissing`;
- `permissionDenied`;
- `createUnconfirmed`;
- `archiveUnconfirmed`;
- `contractViolation`;
- `networkFailure`;
- `unexpectedFailure`.

No se muestra una sesión nueva o archivada como confirmada hasta recibir
exactamente una fila coincidente. No se hace fallback silencioso a demo.

##### Tests futuros obligatorios de 2C-II

Tests de arquitectura/contrato:

- ningún datasource/repositorio usa `select=*`;
- listado solicita exactamente la proyección aprobada;
- payload de creación contiene solo `specialist_id`;
- payload de archivado contiene solo `sessionId` como argumento tipado;
- no existe `user_id` en payload cliente;
- no existe update cliente de `message_count`, `last_message_at`, `status` o
  timestamps;
- backend bloqueado no instancia ni llama adaptador Supabase;
- modo demo no llama Supabase.

Tests de listado:

- owner recibe únicamente sus sesiones;
- usuario A no recibe sesiones de B;
- orden `last_message_at DESC, id DESC`;
- límite y cursor respetados;
- lista vacía es éxito válido;
- columnas extra o estado desconocido producen violación de contrato;
- `401`, `403`, `42501`, red y respuesta inválida son visibles.

Tests de creación:

- Flutter no envía `user_id`;
- owner se deriva de sesión autenticada;
- especialista inexistente/bloqueado no crea sesión;
- sesión inexistente o backend bloqueado no llama/crea;
- campos server-managed no pueden enviarse;
- `204`, cero filas, múltiples filas o ID inesperado no confirman creación;
- creación confirmada devuelve exactamente una sesión owner segura;
- idempotencia se prueba después de decidir su regla.

Tests de archivado:

- owner puede archivar solo su sesión mediante operación controlada;
- usuario A no archiva sesión B;
- no existe delete físico;
- no se puede modificar `message_count`, `last_message_at` u ownership;
- HTTP `204` o cero filas no confirman éxito;
- respuesta confirmada exige una fila, mismo ID y `status = archived`;
- modo demo archiva localmente sin Supabase.

Tests SQL/RLS requeridos antes de chat real:

- anon denegado;
- A no ve, crea para, actualiza o elimina recursos de B;
- insert directo con `user_id` arbitrario denegado;
- update directo de campos server-managed denegado;
- delete cliente denegado;
- especialistas y mensajes permanecen bloqueados;
- rollback vuelve a deny-all seguro.

##### Riesgos y gates de 2C-II

Riesgos principales:

- falsificación de `user_id` y creación para terceros;
- acceso lateral a sesiones ajenas;
- manipulación de `message_count`, timestamps o estado;
- especialista inexistente, inactivo o bloqueado;
- tabla `specialists` todavía insegura y con prompts sensibles;
- `user_id`/`specialist_id` nullable;
- duplicación descontrolada de sesiones activas;
- derivación accidental hacia `messages` sin RLS;
- interpretar HTTP `204` como éxito;
- el contrato Flutter actual `getOrCreateSession(userId, specialistId)`
  contradice 2C-II y deberá sustituirse solo en una implementación aprobada.

Estado de gates antes de implementar 2C-II:

1. proyección explícita, paginación, creación confirmada y archivado lógico:
   aprobados documentalmente;
2. decidir idempotencia de creación;
3. decidir implementación de la frontera futura de creación/archivado;
4. implementar de forma separada 2C-II-A solo después de aprobar el plan
   exacto 2B-III y completar sus gates;
5. diseñar RLS de `chat_sessions` y rollback;
6. acordar tests Flutter, SQL y PostgREST;
7. mantener `messages`, IA, Auth real, backend real y remoto bloqueados.

##### Roadmap posterior mínimo

Después del cierre de 2C-I siguen pendientes:

1. revisar y aprobar o ajustar el plan exacto **2B-III-A**;
2. decidir después si autorizar por separado su implementación deny-all;
3. decidir posteriormente si avanzar a 2B-III-B/C/D y verificar 2C-II-A;
4. completar decisiones pendientes de creación y RLS de `chat_sessions` antes
   de implementar **2C-II**;
5. **2C-III:** contrato seguro de `messages`;
6. Auth real primero en entorno local/controlado;
7. integración de perfil real en Flutter;
8. vinculación remota controlada con gate y auditoría separados;
9. CI local/efímero para Supabase, migraciones y tests de seguridad;
10. especificación funcional visible del MVP;
11. Stasis, chat y especialistas;
12. Storage y avatar;
13. límites médicos, privacidad y seguridad de datos sensibles.

#### 2C-II-A — Catálogo seguro mínimo de especialistas seleccionables para chat

**Objetivo:** definir cómo Flutter podrá listar y seleccionar un subconjunto
MVP de especialistas sin acceder directamente a `public.specialists`, exponer
prompts o configuración interna, ni asumir autoridad sobre disponibilidad,
jerarquía o acceso premium.

Estado: diseño documental aprobado el 2026-06-13, pero no implementado. No
existe catálogo seguro implementado, vista, API, función, RLS, adaptador
Flutter, filas reales aprobadas ni integración con `chat_sessions`.

2C-II-A permanece dentro de ADR-006 porque resuelve una dependencia directa de
autorización y minimización de datos para crear sesiones propias. Deberá
proponerse un ADR independiente antes de implementar si el catálogo pasa a ser
un sistema de agentes versionado, administrable, reutilizable fuera del chat o
gobernado mediante PromptOps, publicación, rollout y permisos propios.

##### Problema verificado con `specialist_id`

`chat_sessions.specialist_id` referencia directamente
`public.specialists.id`, pero la tabla base mezcla:

- identidad visible del especialista;
- clasificación heredada del producto;
- prompt y parámetros internos de IA;
- flags operativos y comerciales;
- jerarquía interna sin claves foráneas;
- datos de presentación todavía no diseñados.

La tabla no tiene RLS ni contrato sanitizado aprobado. No debe exponerse
directamente al cliente. Tampoco se ha verificado que contenga filas reales,
completas o alineadas con el catálogo MVP.

Existen además contradicciones de modelo:

- `category` usa `fisico` y `mental`, mientras la definición vigente usa
  Entrenamiento y Wellness;
- `category` mezcla áreas seleccionables con roles internos como
  `branch_chief` y `subcategory_chief`;
- no existe un campo explícito `is_selectable`;
- no existe descripción corta segura;
- `branch_id` y `chief_id` no tienen claves foráneas;
- `is_premium` no demuestra entitlement del usuario;
- `is_active` expresa estado operativo interno, no un contrato UI.

Por tanto, ningún `specialist_id` de la tabla base se considera seleccionable
hasta que una frontera controlada lo incluya explícitamente en el catálogo
sanitizado aprobado.

##### Clasificación de columnas actuales de `specialists`

| Columna | Clasificación cliente | Catálogo MVP | Riesgo y decisión |
| --- | --- | --- | --- |
| `id` | Visible solo mediante catálogo sanitizado | Sí | Identificador opaco necesario para selección; no revela autoridad ni permite acceso directo a tabla |
| `name` | Visible tras validación editorial | Sí | Debe ser nombre público, estable y no contener instrucciones internas |
| `category` | Pendiente de rediseño/traducción | No como valor crudo | Enum heredado mezcla áreas y roles internos; devolver `area` pública normalizada |
| `subcategory` | Visible solo si existe taxonomía pública aprobada | Opcional, no inicial | Texto libre puede filtrar estructura interna o ser inconsistente |
| `prompt_template` | Backend only, muy sensible | Nunca | Contiene instrucciones y parámetros internos; exposición crítica |
| `is_premium` | Backend only como entrada comercial | Nunca como booleano crudo | No concede ni demuestra acceso; traducir a `accessState` derivado por usuario |
| `is_active` | Backend only como filtro operativo | Nunca | Un especialista no activo simplemente no aparece; no filtrar estado interno |
| `avatar_url` | Pendiente de rediseño | No inicial | Requiere contrato de Storage, origen permitido y fallback seguro |
| `branch_id` | Backend only | Nunca | Jerarquía interna ambigua, sin FK y no necesaria para seleccionar |
| `chief_id` | Backend only | Nunca | Jerarquía/autoridad interna, sin FK y no necesaria para seleccionar |
| `created_at` | Backend only | Nunca | Metadato interno sin valor para el usuario |

También quedan prohibidos permisos internos, prompts, parámetros LLM,
configuración, relaciones de jefatura, flags de rollout y cualquier otro campo
no incluido expresamente en la proyección aprobada.

##### Contrato futuro `listSelectableSpecialists()`

Operación conceptual:

```text
listSelectableSpecialists() -> SelectableSpecialistsResult
```

Proyección segura recomendada:

```text
id
displayName
area
shortDescription
accessState
isDemo
```

Semántica:

- `id`: identificador opaco aprobado para `createOwnChatSession`;
- `displayName`: nombre público validado, derivado de `name`;
- `area`: enum público `stasis`, `health`, `nutrition`, `training` o
  `wellness`; nunca devuelve categorías internas crudas;
- `shortDescription`: contenido editorial sanitizado que todavía no existe en
  el esquema actual;
- `accessState`: valor derivado `available`, `lockedPremium`, `unavailable` o
  `demoOnly`; no es permiso administrativo ni se calcula en Flutter;
- `isDemo`: indica inequívocamente que el elemento procede del catálogo demo.

`is_active` no se expone: la frontera controlada filtra filas inactivas.
`is_premium` tampoco se expone: una frontera autorizada combina catálogo,
entitlement verificado y política comercial para producir `accessState`.

Contrato de listado:

1. devuelve únicamente especialistas explícitamente seleccionables;
2. usa proyección explícita y forma estricta; `select=*` queda prohibido;
3. excluye especialistas internos, jefes, inactivos o no publicados;
4. no devuelve prompts, jerarquía, configuración o timestamps;
5. no permite que Flutter derive permisos desde campos crudos;
6. en demo usa un catálogo local explícito y no llama Supabase;
7. con backend bloqueado devuelve estado visible y no llama Supabase;
8. cualquier campo extra o enum desconocido produce violación de contrato.

No se decide todavía si la implementación futura será vista sanitizada,
función/RPC o API controlada. El acceso directo a `public.specialists`
permanece prohibido. Una vista solo sería aceptable si no filtra columnas
sensibles, aplica autorización correcta, no hereda privilegios peligrosos y
dispone de tests SQL/PostgREST negativos.

##### Subconjunto MVP conceptual seleccionable

Este catálogo es una propuesta de producto, no filas verificadas ni agentes
implementados. Los IDs, descripciones editoriales, disponibilidad y capacidad
real deberán aprobarse antes de implementación.

| Nombre visible propuesto | Área pública | Descripción corta propuesta | Demo | Requiere IA real | Requiere backend real | Puede aparecer en `chat_sessions` real | Riesgos principales |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Stasis | Stasis | Punto central para orientar y coordinar la experiencia | Sí | Sí para conversación real | Sí | Solo tras contratos aprobados | Puede prometer coordinación o memoria inexistentes |
| Salud general | Salud | Orientación general de bienestar y preparación de preguntas | Sí | Sí para conversación real | Sí | Solo tras contratos aprobados | No debe diagnosticar ni sustituir atención médica |
| Nutrición | Nutrición | Apoyo general para hábitos y planificación nutricional | Sí | Sí para conversación real | Sí | Solo tras contratos aprobados | Riesgo médico, alergias y recomendaciones personalizadas |
| Entrenamiento | Entrenamiento | Apoyo general para actividad y planificación física | Sí | Sí para conversación real | Sí | Solo tras contratos aprobados | Lesiones, contraindicaciones y categoría heredada `fisico` |
| Wellness | Wellness | Apoyo general para bienestar, hábitos y equilibrio | Sí | Sí para conversación real | Sí | Solo tras contratos aprobados | Concepto amplio y contradicción con categoría heredada `mental` |
| Sueño y estrés | Wellness | Orientación general sobre descanso y manejo cotidiano del estrés | Sí | Sí para conversación real | Sí | Solo tras contratos aprobados | Salud mental, crisis y límites clínicos |

Mientras chat real permanezca bloqueado, estos elementos solo pueden aparecer
como catálogo demo explícito sin presentar IA, memoria, investigación o
backend como capacidades reales.

##### Relación con `createOwnChatSession(specialistId)`

Antes de crear una sesión real, la frontera controlada deberá:

1. aceptar únicamente `specialistId`; Flutter nunca envía `user_id`,
   `is_premium`, `is_active`, área, rol o permisos;
2. resolver el ID contra el mismo catálogo sanitizado y publicado;
3. comprobar que existe y continúa seleccionable en el momento de creación;
4. rechazar especialistas inactivos, internos, jefes, no publicados o fuera
   del subconjunto permitido;
5. comprobar entitlement premium server-side cuando corresponda;
6. derivar owner desde sesión validada, nunca desde payload;
7. no devolver ni registrar prompts o configuración interna en errores;
8. devolver exactamente una sesión segura confirmada o un error tipado;
9. no crear mensajes ni invocar IA;
10. fallar cerrado si catálogo, entitlement o disponibilidad son ambiguos.

La presencia previa de un ID en Flutter no autoriza la creación. El backend
debe revalidar disponibilidad y acceso para evitar TOCTOU. Un especialista
premium bloqueado puede ser visible con `accessState = lockedPremium`, pero
`createOwnChatSession` debe denegarlo sin confiar en la UI.

##### Errores y estados UI de 2C-II-A

Flutter deberá distinguir como mínimo:

- `catalogDemo`;
- `catalogBackendBlocked`;
- `catalogLoading`;
- `catalogReady`;
- `catalogReadyEmpty`;
- `specialistNotFound`;
- `specialistUnavailable`;
- `specialistLockedPremium`;
- `specialistInternalNotSelectable`;
- `permissionDenied`;
- `networkFailure`;
- `contractViolation`;
- `unexpectedFailure`.

Reglas UI:

- demo debe mostrarse inequívocamente como demo;
- backend bloqueado no se transforma en catálogo demo silencioso;
- especialista no disponible se retira o muestra sin permitir creación según
  decisión de UX futura;
- premium bloqueado no se presenta como autorización concedida;
- no se muestran detalles que permitan inferir prompts, jerarquía o controles
  internos;
- errores de creación no confirman sesión ni revelan si existe un especialista
  interno concreto.

##### Tests futuros obligatorios de 2C-II-A

Tests de contrato y arquitectura:

- la respuesta contiene exactamente la proyección sanitizada aprobada;
- nunca devuelve `prompt_template`;
- nunca devuelve `branch_id`;
- nunca devuelve `chief_id`;
- nunca devuelve `created_at`;
- nunca devuelve `is_active` o `is_premium` crudos;
- no usa `select=*`;
- Flutter no accede directamente a `public.specialists`;
- demo no llama Supabase;
- backend bloqueado no llama Supabase.

Tests de catálogo:

- solo aparecen especialistas explícitamente seleccionables;
- especialista inactivo no aparece;
- jefe de rama, jefe de subcategoría y especialista interno no aparecen;
- categorías heredadas se traducen a áreas públicas aprobadas o se rechazan;
- forma, enums y campos extra inesperados producen violación de contrato;
- `accessState` premium se deriva en frontera controlada y no en Flutter.

Tests de creación de sesión:

- especialista no seleccionable no crea sesión;
- especialista inexistente o inactivo no crea sesión;
- especialista premium sin entitlement no crea sesión;
- especialista permitido puede continuar al contrato de creación, sin crear
  mensajes ni invocar IA;
- cambio de disponibilidad entre listado y creación se revalida y falla
  cerrado;
- payload de creación contiene únicamente `specialist_id`;
- payload nunca acepta `user_id`, prompts, flags o permisos.

Tests SQL/PostgREST futuros, si se aprueba una implementación:

- tabla base `specialists` permanece denegada al cliente;
- proyección sanitizada no filtra columnas prohibidas ni mediante
  `select=*`;
- anon y authenticated reciben solo el alcance expresamente aprobado;
- un ID interno no puede usarse para crear sesión;
- rollback vuelve a catálogo bloqueado/deny-all;
- reaplicación restaura únicamente la superficie sanitizada aprobada.

##### Riesgos y gates de 2C-II-A

Riesgos principales:

- filtración de prompts o parámetros LLM;
- usar `is_premium` como autorización o confiar en Flutter;
- exponer estructura interna y jefaturas;
- categorías heredadas incompatibles con el producto vigente;
- catálogo demo presentado como capacidad real;
- seleccionar especialista visible pero desactivado antes de crear sesión;
- ausencia de descripción pública y flag explícito de selección;
- vista o grants que permitan reconstruir columnas sensibles;
- ampliar prematuramente el catálogo a los 43 agentes documentales.

Estado de gates antes de implementar 2C-II-A:

1. proyección pública y enums `accessState`: aprobados documentalmente;
2. especialistas premium visibles como `lockedPremium`: aprobado
   documentalmente;
3. subconjunto MVP conceptual: aprobado documentalmente, sin implicar filas,
   prompts o agentes reales;
4. `is_selectable` o equivalente como decisión server-managed: aprobado
   documentalmente;
5. traducción pública `fisico -> Entrenamiento` y `mental -> Wellness`:
   aprobada documentalmente;
6. frontera sanitizada, modelo futuro, RLS/grants, rollback y pruebas:
   preparados en 2B-III, pendientes de aprobación;
7. tabla base, prompts, chat real, mensajes, IA, Auth real, remoto y datos
   reales permanecen bloqueados.

La creación real de `chat_sessions` no puede implementarse hasta completar
estos gates y revalidar el especialista server-side.

#### 2B-III — Diseño RLS/catálogo sanitizado de especialistas

**Objetivo:** definir la frontera futura que expondrá únicamente el catálogo
aprobado en 2C-II-A, sin conceder acceso cliente a `public.specialists`,
filtrar prompts o delegar autorización comercial a Flutter.

Estado: diseño documental aprobado el 2026-06-13. Plan exacto preparado,
pendiente de aprobación; no implementado. No existe migración, tabla de
catálogo, vista, RPC, API, Edge Function, política RLS, grant, dato real,
adaptador Flutter ni conexión remota autorizados.

2B-III se originó dentro de ADR-006 porque concreta RLS, autorización,
minimización y frontera backend. Su decisión especializada y evolución futura
se proponen en
`ADR-007-catalogo-sanitizado-especialistas-y-frontera-backend.md`.

ADR-007 está aceptado conceptualmente y pasa a ser la fuente especializada del
catálogo sanitizado. Su aprobación no autoriza 2B-III-A, que permanece
pendiente de aprobación de implementación.

##### Problema de `public.specialists`

`public.specialists` no es un catálogo público. Es una tabla interna
provisional que mezcla presentación, prompts, configuración, jerarquía,
disponibilidad y clasificación heredada. Dar `SELECT` cliente sobre ella,
incluso por columnas, acoplaría peligrosamente el contrato público al esquema
interno.

Decisiones obligatorias:

- la tabla base permanece deny-all para `anon` y `authenticated`;
- Flutter nunca consulta `public.specialists`;
- prompts, jerarquía, configuración, flags y timestamps nunca reciben grants
  cliente;
- `accessState` se calcula en frontera controlada, no desde `is_premium` en
  Flutter;
- demo permanece local y explícita;
- un especialista listado debe revalidarse al crear `chat_sessions`.

##### Alternativas técnicas evaluadas

| Alternativa | Ventajas | Riesgos y costes | Evaluación MVP |
| --- | --- | --- | --- |
| **A — Vista sanitizada `public.selectable_specialists`** | Proyección estática explícita, consulta sencilla por PostgREST y tests claros de columnas | Una vista normal puede eludir RLS; una `security_invoker` depende de permisos/RLS subyacentes; `accessState` dependiente del usuario complica el diseño; riesgo de ampliar columnas accidentalmente | No recomendada como frontera única; posible complemento interno futuro |
| **B — RPC `list_selectable_specialists()`** | Forma exacta, validación central y cálculo de `accessState`; integración directa con Supabase | Acopla contrato de producto a Postgres; paginación/errores requieren disciplina; riesgo elevado si se usa `SECURITY DEFINER`, privilegios amplios o `search_path` inseguro | Segunda opción si una función mínima y auditada satisface el contrato sin abrir tabla base |
| **C — Solo `public.specialists` interna y catálogo generado por backend** | No añade una segunda fuente y aísla acceso mediante backend | Mantiene presentación/publicación junto a prompts; obliga a traducir esquema heredado en cada petición; alto acoplamiento y riesgo de filtración o divergencia lógica | No recomendada para MVP |
| **D — Tabla sanitizada separada + API/capa backend controlada** | Separa datos editoriales de prompts, permite `accessState` por usuario, revalidación y evolución segura | Requiere sincronización explícita con especialista interno y dos superficies backend-only | **Recomendada para MVP seguro**, sin autorizar todavía implementación concreta |

##### Alternativa recomendada

Se recomienda **D — tabla sanitizada separada + API/capa backend controlada**.
No se recomienda una vista para el primer paquete ni acceso directo a ninguna
tabla desde Flutter.

Justificación:

1. `accessState` depende potencialmente de identidad, membresía,
   disponibilidad y modo;
2. la misma frontera puede revalidar `specialistId` al crear una sesión;
3. Flutter solo conoce el contrato público y nunca prompts, jerarquía o flags;
4. el catálogo puede evolucionar sin conceder grants sobre la tabla sensible;
5. permite errores tipados, observabilidad, límites y pruebas de contrato;
6. se alinea con la API/capa backend controlada aprobada para el MVP.

La recomendación no autoriza Edge Function, servicio independiente,
`service_role`, `SECURITY DEFINER` ni conexión real. La implementación exacta
requiere un plan separado. Cualquier acceso privilegiado permanecerá solo en
backend, usará proyección allowlist y nunca llegará a Flutter.

Rollback conceptual:

- retirar o deshabilitar la operación de catálogo;
- devolver `catalogBackendBlocked`;
- mantener `public.specialists` deny-all e intacta;
- retirar únicamente los artefactos sanitizados del paquete implementado;
- conservar catálogo demo local explícito;
- demostrar que la reaplicación solo restaura la superficie aprobada.

##### Contrato `listSelectableSpecialists()`

Operación:

```text
listSelectableSpecialists(pageRequest?, areaFilter?)
  -> SelectableSpecialistsResult
```

Respuesta permitida por elemento:

```text
id
displayName
area
shortDescription
accessState
isDemo
```

Enums:

```text
area: stasis | health | nutrition | training | wellness
accessState: available | lockedPremium | unavailable | demoOnly
```

Reglas:

- orden estable: área pública, orden editorial server-managed, nombre e ID;
- el orden editorial no se expone;
- `id` representa `specialist_catalog.id`, nunca `specialists.id`;
- filtro opcional únicamente por `area` pública;
- quedan prohibidos filtros por categoría interna, premium, activo, jerarquía
  o prompt;
- para el catálogo MVP se permite una sola página limitada a 20 elementos;
- si crece, deberá añadirse cursor opaco server-managed;
- catálogo vacío es éxito válido `catalogReadyEmpty`;
- backend bloqueado devuelve `catalogBackendBlocked` sin llamada Supabase
  desde Flutter;
- demo devuelve catálogo local con `isDemo = true` y
  `accessState = demoOnly`;
- columnas extra, enums desconocidos, IDs duplicados o forma inválida producen
  `catalogContractViolation`;
- `unavailable` y `lockedPremium` nunca permiten crear sesión;
- acceso y disponibilidad se revalidan al crear sesión;
- no existe fallback silencioso a demo.

Errores esperados:

- `catalogUnauthenticated`, si el contrato futuro exige identidad;
- `catalogPermissionDenied`;
- `catalogBackendBlocked`;
- `catalogNetworkFailure`;
- `catalogContractViolation`;
- `catalogUnexpectedFailure`.

##### Modelo de datos futuro

Se propone crear en un paquete futuro:

```text
public.specialist_catalog
```

La tabla será sanitizada respecto a prompts y jerarquía, pero seguirá siendo
**backend-only**. No será una API pública ni recibirá grants cliente. Su ID
será el identificador opaco devuelto en el contrato público.

El `id` público no será `public.specialists.id`. Esto evita que Flutter maneje
directamente la identidad interna usada por `chat_sessions`. La frontera
backend resolverá `specialist_catalog.id -> specialist_id`, revalidará la
entrada y solo entonces usará el identificador interno.

Columnas internas exactas propuestas:

| Columna | Tipo futuro | Visible al cliente | Editable backend/admin | Uso en contrato | Alcance y riesgo |
| --- | --- | --- | --- | --- | --- |
| `id` | `UUID PRIMARY KEY DEFAULT uuid_generate_v4()` | Sí, como `id` opaco | Solo creación backend/admin | `id` | MVP; nunca debe interpretarse como autoridad |
| `specialist_id` | `UUID NOT NULL UNIQUE REFERENCES public.specialists(id) ON DELETE RESTRICT` | Nunca | Solo backend/admin | Resolución interna | MVP; FK evita catálogo huérfano y `RESTRICT` evita borrado accidental |
| `display_name` | `TEXT NOT NULL` con longitud normalizada `1..80` | Sí | Backend/admin | `displayName` | MVP; requiere validación editorial |
| `product_area` | `TEXT NOT NULL CHECK (stasis/health/nutrition/training/wellness)` | Sí, traducida como `area` | Backend/admin | `area` | MVP; no acepta `fisico` o `mental` |
| `short_description` | `TEXT NOT NULL` con longitud máxima propuesta `240` | Sí | Backend/admin | `shortDescription` | MVP; contenido editorial, sin claims clínicos ni instrucciones internas |
| `is_published` | `BOOLEAN NOT NULL DEFAULT false` | Nunca | Backend/admin | Filtro interno | MVP; controla visibilidad, no acceso |
| `availability_status` | `TEXT NOT NULL DEFAULT 'unavailable' CHECK (available/unavailable)` | Nunca cruda | Backend/admin | Deriva `accessState` | MVP; razón interna nunca se expone |
| `access_tier` | `TEXT NOT NULL DEFAULT 'free' CHECK (free/premium)` | Nunca cruda | Backend/admin | Deriva `accessState` | MVP; no demuestra entitlement |
| `sort_order` | `INTEGER NOT NULL DEFAULT 0 CHECK (sort_order >= 0)` | Nunca | Backend/admin | Orden estable | MVP |
| `created_at` | `TIMESTAMPTZ NOT NULL DEFAULT now()` | Nunca | Server-managed | Ninguno | MVP técnico/auditoría; sin grant cliente |
| `updated_at` | `TIMESTAMPTZ NOT NULL DEFAULT now()` | Nunca | Server-managed mediante mecanismo futuro aprobado | Ninguno | MVP técnico; trigger todavía no autorizado |

Decisiones sobre columnas propuestas inicialmente:

- no persistir `default_access_state`: mezclaría disponibilidad y entitlement;
- no persistir `is_demo`: demo vive únicamente en repositorio local;
- no persistir `is_selectable`: se deriva de `is_published`,
  `availability_status`, `access_tier` y entitlement;
- `accessState` no se persiste como verdad global;
- no crear vista `public.selectable_specialists` en el primer paquete;
- `fisico` y `mental` pueden permanecer temporalmente solo en la tabla
  interna, nunca en `product_area` o contrato público.

Separar catálogo público e identidad interna evita añadir descripciones,
publicación y taxonomía de producto a una tabla que también almacena prompts.

##### Plan exacto de implementación futuro

El plan debe dividirse y aprobarse por separado:

**2B-III-A — Esquema local deny-all**

1. crear migración nueva para `public.specialist_catalog`;
2. no modificar la migración histórica;
3. crear constraints, FK, índice de orden y unicidad exactos;
4. habilitar RLS en `public.specialists` y `public.specialist_catalog`;
5. no crear políticas permisivas ni grants cliente;
6. no insertar todavía las seis filas conceptuales;
7. demostrar deny-all, rollback y reaplicación local.

**2B-III-B — Fuente editorial local controlada**

1. decidir mecanismo de alta/edición backend/admin;
2. crear exclusivamente las filas MVP aprobadas mediante fixtures locales
   revisables, nunca datos remotos;
3. comprobar traducción de áreas, publicación, orden y constraints;
4. demostrar que prompts y jerarquía no se copian al catálogo;
5. mantener toda lectura cliente bloqueada.

**2B-III-C — Frontera backend local/efímera**

1. aprobar una implementación concreta de API/capa backend;
2. validar JWT y derivar usuario de sesión, nunca de payload;
3. consultar solo allowlist de catálogo y mínimo entitlement;
4. derivar `accessState`;
5. devolver exactamente seis campos;
6. registrar auditoría mínima sin contenido sensible;
7. probar catálogo, errores, rollback y ausencia de secretos en Flutter.

Ningún subpaquete desbloquea remoto, producción, Flutter o `chat_sessions`.

##### RLS y grants futuros en lenguaje natural

**Tabla base `public.specialists`:**

- RLS habilitada y deny-all para `anon` y `authenticated`;
- ningún grant cliente de tabla o columna;
- ningún acceso directo mediante PostgREST;
- escritura solo por backend/admin futuro aprobado y auditable;
- prompts y jerarquía nunca salen de la frontera.

**Fuente sanitizada futura:**

- escritura, publicación, selección y orden: backend/admin only;
- lectura directa cliente: denegada inicialmente;
- la API/capa backend lee únicamente columnas allowlist;
- cualquier lectura directa posterior exige revisión RLS/grants separada.

**Actores y estados:**

- `anon`: denegado inicialmente;
- `authenticated`: obtiene catálogo únicamente mediante frontera controlada;
- backend controlado: lee los mínimos datos sanitizados y de entitlement;
- demo: repositorio local, sin Supabase, con `demoOnly`;
- backend bloqueado: ninguna llamada Supabase ni fallback demo;
- `lockedPremium` puede mostrarse, pero entitlement se verifica server-side;
- `unavailable` nunca concede creación.

Columnas sin grant cliente bajo cualquier alternativa:

```text
prompt_template
branch_id
chief_id
created_at
is_active
is_premium
configuración interna
permisos internos
jerarquía interna
```

Rollback esperado: volver a deny-all, retirar la operación sanitizada y
mantener demo local explícita. Nunca habilita acceso a la tabla base.

##### Frontera backend futura exacta

La primera implementación candidata será una **Edge Function o endpoint de API
propia ejecutado como backend controlado**, pero la tecnología concreta no
queda autorizada por este plan. No se recomienda RPC como frontera pública del
primer paquete.

Contrato de petición:

- método futuro recomendado: `GET`;
- bearer JWT obligatorio para catálogo real;
- filtros allowlist: `area` y cursor futuro;
- no acepta `user_id`, entitlement, premium, activo, rol o IDs internos.

Flujo interno:

1. validar firma, expiración y audiencia de la sesión;
2. derivar el usuario exclusivamente del JWT validado;
3. leer solo filas publicadas de `specialist_catalog`;
4. leer únicamente el entitlement mínimo necesario del usuario;
5. derivar por fila:
   - no publicada: no aparece;
   - publicada y `availability_status = unavailable`: `unavailable`;
   - publicada, disponible y `access_tier = free`: `available`;
   - publicada, disponible, premium y entitlement válido: `available`;
   - publicada, disponible, premium y sin entitlement: `lockedPremium`;
6. mapear únicamente los seis campos públicos;
7. validar forma, enums, duplicados, límite y orden antes de responder;
8. devolver error tipado y fallar cerrado ante cualquier ambigüedad.

Credenciales futuras:

- Flutter utiliza solo credencial pública/configuración aprobada y JWT de
  usuario; nunca contiene `service_role` ni secreto backend;
- la frontera usa preferentemente una identidad backend dedicada con mínimo
  privilegio sobre columnas allowlist;
- si Supabase obliga técnicamente a usar `service_role`, requerirá aprobación
  separada, aislamiento exclusivo en secretos del runtime, threat model,
  rotación y pruebas que demuestren que no llega a cliente o logs;
- ninguna credencial real se versiona.

Auditoría mínima futura:

- request/correlation ID;
- actor autenticado pseudonimizado o identificador interno protegido;
- operación y resultado agregado;
- cantidad de elementos devueltos;
- código de error tipado;
- latencia y versión del contrato;
- nunca prompts, descripciones completas, JWT, secretos, jerarquía,
  entitlement detallado o payloads sensibles.

Errores HTTP/contrato futuros:

- sesión ausente/inválida: `401` + `catalogUnauthenticated`;
- permiso denegado: `403` + `catalogPermissionDenied`;
- filtro inválido: `400` + `catalogContractViolation`;
- backend bloqueado: resultado local `catalogBackendBlocked`, sin llamada;
- dependencia no disponible: error controlado, sin fallback demo;
- error interno: identificador de correlación y mensaje genérico.

##### RLS, grants y rollback exactos futuros

**`public.specialists`:**

- habilitar RLS;
- revocar privilegios de `anon`, `authenticated` y `PUBLIC`;
- no crear políticas permisivas;
- verificar que ningún cliente puede leer ni mutar;
- backend futuro accede solo mediante identidad aprobada y mínimo privilegio.

**`public.specialist_catalog`:**

- habilitar RLS desde su creación;
- revocar privilegios de `anon`, `authenticated` y `PUBLIC`;
- no crear políticas permisivas en 2B-III-A;
- backend/admin futuro recibe únicamente privilegios aprobados;
- la frontera pública nunca reenvía filas crudas ni usa `select=*`.

Rollback de 2B-III-A:

1. retirar grants/backend roles creados por el paquete, si existen;
2. eliminar políticas creadas por el paquete, si existen;
3. eliminar índices y `public.specialist_catalog`;
4. mantener `public.specialists` en deny-all;
5. demostrar que anon/authenticated siguen bloqueados;
6. reaplicar y demostrar exclusivamente la superficie aprobada.

##### Tests futuros propuestos para 2B-III

Tests de esquema, RLS y grants:

- `public.specialists` tiene RLS y permanece deny-all;
- `anon` y `authenticated` no pueden usar `SELECT`, `SELECT *`, `INSERT`,
  `UPDATE` o `DELETE` sobre la tabla base;
- ninguna columna prohibida tiene grant cliente;
- rollback vuelve a deny-all y reaplicación restaura solo la frontera
  sanitizada.

Tests de contrato/backend:

- respuesta contiene exactamente los seis campos aprobados;
- nunca devuelve `prompt_template`, `branch_id`, `chief_id`, `created_at`,
  `is_active`, `is_premium`, configuración, permisos o jerarquía;
- especialistas internos, jefes e inactivos no aparecen;
- categorías antiguas se traducen o bloquean;
- premium se traduce a `lockedPremium`;
- `available`, `unavailable` y `demoOnly` respetan su semántica;
- duplicados, campos extra y enums desconocidos fallan cerrado;
- orden, filtro y límite respetan contrato;
- catálogo vacío es éxito válido.

Tests de aislamiento e integración futura:

- demo no llama Supabase;
- backend bloqueado no llama Supabase;
- ningún secreto o acceso privilegiado llega a Flutter;
- `createOwnChatSession` rechaza IDs internos, no seleccionables,
  desactivados, no publicados o premium sin entitlement;
- un cambio entre listado y creación se revalida;
- errores y logs no filtran prompts o configuración.

Tests específicos de la frontera:

- JWT ausente, inválido o expirado falla cerrado;
- `user_id`, premium, activo, rol y filtros internos son rechazados;
- la respuesta nunca contiene `specialists.id`;
- `id` público corresponde únicamente a `specialist_catalog.id`;
- `accessState` se deriva conforme a disponibilidad, tier y entitlement;
- una respuesta con más o menos de seis campos falla validación;
- logs no contienen JWT, secretos, prompts, jerarquía ni entitlement
  detallado;
- identidad backend y secretos no aparecen en Flutter.

##### Relación exacta con 2B-IV / `chat_sessions`

2B-III no desbloquea por sí solo `chat_sessions`. Solo establece la fuente
confiable necesaria para validar especialistas.

El contrato futuro debería evolucionar conceptualmente a:

```text
createOwnChatSession(selectableSpecialistId)
```

Aunque Flutter pueda conservar temporalmente el nombre `specialistId`, el
valor aceptado será exclusivamente `specialist_catalog.id`, nunca
`public.specialists.id`.

La frontera de creación deberá:

1. validar sesión y derivar owner; nunca aceptar `user_id`;
2. resolver la entrada por `specialist_catalog.id`;
3. exigir publicación, disponibilidad y acceso efectivo;
4. obtener `specialist_id` interno solo dentro del backend;
5. revalidar para evitar cambios entre listado y creación;
6. insertar el `specialist_id` interno en `chat_sessions` únicamente tras
   aprobar 2B-IV;
7. devolver una sesión confirmada sin prompts ni configuración;
8. rechazar IDs internos, desconocidos, no publicados, unavailable o premium
   sin entitlement.

Antes de implementar creación real siguen siendo obligatorios RLS/contrato de
`chat_sessions`, idempotencia, rollback y pruebas de aislamiento 2B-IV.

##### Riesgos y gates de 2B-III

Riesgos:

- frontera privilegiada demasiado amplia;
- divergencia entre catálogo y validación de creación;
- almacenar `accessState` como verdad global;
- filtrar prompts mediante errores, logs, vistas o respuestas;
- confundir catálogo conceptual con agentes reales;
- depender indefinidamente de categorías heredadas;
- introducir complejidad backend antes de definir modelo comercial mínimo.

Estado de gates antes de implementar 2B-III:

1. API/capa backend controlada y fuente sanitizada separada: aprobadas
   documentalmente;
2. proyección, estados, premium y `unavailable`: aprobados documentalmente;
3. estructura exacta, columnas, subpaquetes, RLS/grants, rollback y tests:
   aprobados documentalmente como plan, sin autorización de implementación;
4. falta decidir tecnología concreta de frontera y entitlement mínimo;
5. falta preparar threat model y plan de secretos de la frontera elegida;
6. ADR-007 aceptado conceptualmente; falta aprobar implementación 2B-III-A;
7. remoto, Flutter, chat real, mensajes, IA y datos reales permanecen
   bloqueados.

Por su alcance transversal entre esquema, catálogo de producto y frontera
backend, ADR-007 fue aceptado conceptualmente. Su aprobación no autoriza
2B-III-A ni ningún otro subpaquete.

### 2D — Tests de seguridad

**Objetivo:** aprobar la estrategia de evidencia antes de activar RLS.

Entregables:

- harness local o efímero para tests;
- tests de aislamiento entre usuarios;
- tests de acceso anónimo y denegado;
- tests de roles y permisos administrativos;
- tests de chats y perfiles;
- tests de membresías si entran en alcance;
- casos de revocación, expiración y rollback;
- requisitos CI y reporte de resultados.

Gate de salida:

- todos los casos críticos tienen prueba negativa;
- fallos de autorización bloquean el avance.

### 2E — Plan de implementación futura

**Objetivo:** convertir los diseños aprobados en un paquete ejecutable pequeño.

Orden propuesto:

1. Aprobar 2A y 2B.
2. Aprobar contratos 2C y pruebas 2D.
3. Definir migraciones exactas y rollback.
4. Implementar primero identidad/perfil mínimo en entorno local.
5. Implementar y probar RLS de una superficie mínima.
6. Integrar Flutter solo después de demostrar aislamiento.
7. Auditar y decidir si desbloquear backend real no productivo.

Archivos probables, pendientes de auditoría y aprobación:

- migraciones y tests locales de Supabase;
- configuración backend local/efímera;
- contratos y adaptadores Flutter de auth/perfil;
- rutas y providers de autenticación;
- CI de seguridad;
- documentación y ADRs.

Riesgos:

- escalado de privilegios;
- políticas RLS incompletas o recursivas;
- bloqueo accidental de usuarios legítimos;
- desincronización entre Auth y perfil;
- exposición de prompts o datos sensibles;
- confusión entre membresía y administración;
- migración irreversible o pérdida de acceso.

Rollback propuesto:

- migraciones reversibles probadas localmente;
- backend real permanece bloqueado durante implementación;
- no usar datos reales;
- mantener modo demo operativo;
- revertir políticas o contratos solo hacia denegación segura.

## Criterios para desbloquear backend real

Backend real solo podrá habilitarse en un entorno controlado no productivo si:

- ADR-006 y el alcance exacto de implementación están aprobados;
- 2A, 2B, 2C y 2D han superado sus gates;
- autenticación, sesión y revocación están verificadas;
- todas las tablas expuestas tienen RLS y políticas auditadas;
- operaciones sensibles pasan por backend controlado;
- aislamiento entre usuarios y denegaciones están probados;
- no existen secretos en Flutter;
- logging y auditoría mínima están definidos;
- existe rollback probado;
- Seguridad, Privacidad, AppSec, Backend/Supabase, QA y Arquitectura aprueban;
- el cliente autoriza explícitamente el desbloqueo.

Desbloquear backend real no desbloquea producción ni datos reales.

## Criterios para desbloquear datos reales

Además de los criterios de backend real:

- inventario y clasificación de datos aprobados;
- finalidad, consentimiento y minimización definidos;
- retención, borrado, exportación y respuesta a incidentes definidos;
- cifrado y gestión de claves aplicables verificados;
- observabilidad y auditoría operativas sin filtrar contenido sensible;
- entorno, backups y proveedores revisados;
- pruebas de seguridad y privacidad aprobadas;
- autorización explícita independiente del cliente.

Salud/wellness, memoria, investigaciones, pagos y archivos requieren gates
adicionales específicos. No se desbloquean por aprobar identidad básica.

## Fuera de alcance

- Implementar o restaurar autenticación.
- Activar Supabase o backend real.
- Crear o modificar migraciones, tablas, funciones o políticas RLS, salvo la
  migración 2B-I aprobada que habilita RLS sin políticas en `public.users`.
- Usar credenciales, usuarios o datos reales.
- Producción, stores o release.
- Memoria federada e investigaciones.
- Pagos, webhooks o membresías reales.
- Stasis Engine y MCP.
- Agentes reales, proveedores LLM o procesamiento de archivos.
- Migración Mental a Wellness.
- Diseñar cifrado de columnas o gestión de claves definitiva.
- Refactors o nuevas features.

## Criterios para aprobar implementación futura

- Alcance exacto limitado a uno o varios subpaquetes explícitos.
- Archivos permitidos y prohibidos declarados.
- Inventario del esquema revalidado.
- Threat model y revisión de privacidad completados.
- Políticas RLS exactas revisadas antes de ejecutarse.
- Matriz de pruebas positivas y negativas aprobada.
- Plan de migración y rollback probado localmente.
- Modo demo preservado y backend real bloqueado por defecto.
- Sin datos reales durante implementación y pruebas iniciales.
- Aprobación explícita del cliente.

## Agentes y comités revisores

Responsables principales:

- Arquitecto Principal.
- Arquitecto Backend.
- Especialista en Seguridad y Privacidad.
- Backend/Supabase Developer.
- Especialista AppSec / Ciberseguridad.
- QA Engineer.

Revisión obligatoria:

- Director de Proyecto.
- Product Owner.
- Revisor de Coherencia del Producto.
- Arquitecto Flutter.
- Especialista en Datos y Memoria.
- Especialista en Criptografía Aplicada y Gestión de Claves.
- DevOps / Infraestructura / Release Engineering.
- Comité de Arquitectura Técnica.
- Comité de Implementación.
- Comité de Dirección, Gobierno y Coherencia.

Revisión condicional:

- Especialista en Membresías y Pagos si membresías entran en implementación.
- Ética y Cumplimiento IA si agentes acceden a datos.
- Observabilidad si se implementa auditoría operativa.

## Decisiones que requieren aprobación

- Aceptar `auth.users` como fuente de verdad de identidad.
- Aceptar `public.users` como perfil 1:1 sin autoridad administrativa.
- Separar rol de producto, membresía y permisos administrativos.
- Prohibir `userMetadata` como fuente de autorización crítica.
- Adoptar denegación por defecto y estrategia RLS propuesta.
- Mantener todas las tablas actuales bloqueadas hasta diseño y pruebas.
- Aprobar la división 2A–2E y decidir qué subpaquete puede implementarse primero.

## Resultado de implementación del Paquete 2A

Fecha de implementación y verificación: 2026-06-11.
Fecha de aprobación de cierre: 2026-06-12.

### Implementado

- Se creó `CurrentIdentity` como contrato central mínimo con origen `demo` o
  `authenticated`, sin perfil, roles, permisos ni autoridad administrativa.
- Se centralizó la identidad demo y su identificador en un único contrato.
- Se creó `UserProfile` como contrato separado de identidad, sin autoridad.
- `UserEntity` representa únicamente una identidad autenticada futura.
- El mapeo desde Supabase ignora completamente `userMetadata` y cualquier rol.
- El registro dejó de enviar `role` y otros datos de perfil a Auth metadata.
- El campo visual de nombre permanece provisional en registro para evitar un
  cambio innecesario de UI, pero no se envía a Auth ni concede autoridad.
- Chat obtiene el identificador exclusivamente desde el provider central de
  identidad.
- El mensaje técnico de bloqueo de backend referencia el gate vigente ADR-006.

### Evidencia verificada

- `dart run build_runner build --delete-conflicting-outputs`: completado.
- `flutter analyze --no-fatal-infos`: completado sin errores ni warnings
  bloqueantes; quedan 48 avisos informativos totales.
- `flutter test`: 15 tests superados.
- `git diff --check`: completado sin errores.
- Tests concretos impiden reintroducir roles desde metadata o un identificador
  demo local dentro del provider de chat.

### Fuera de alcance confirmado

- No se modificaron `supabase/`, migraciones, tablas ni RLS.
- No se activaron backend real, producción ni autenticación real.
- No se conectaron servicios, usuarios, credenciales ni datos reales.
- No se implementaron permisos administrativos, membresías, pagos, memoria,
  investigaciones, Stasis Engine, MCP ni nuevas features.

### Riesgos residuales y siguiente gate

- `CurrentIdentity.authenticated` es únicamente un contrato futuro; no demuestra
  autenticación real.
- `UserProfile` no tiene todavía repositorio, persistencia ni flujo de
  sincronización.
- El campo de nombre del registro no se persiste hasta aprobar el flujo de
  perfil.
- La migración existente conserva `public.users.role`; continúa sin autoridad
  aprobada y no fue modificada.
- Backend real, datos reales, auth, esquema y RLS continúan bloqueados.
- El siguiente subpaquete solo puede prepararse o implementarse con aprobación
  explícita independiente.

## Resultado local del micro-paquete 2B-III-A

Fecha de implementación y verificación: 2026-06-13.

- La migración `00004_create_specialist_catalog_deny_all.sql` crea únicamente
  el esquema vacío aprobado para `public.specialist_catalog`.
- `public.specialists` y `public.specialist_catalog` quedan con RLS habilitada,
  sin FORCE RLS, sin policies y sin privilegios cliente.
- El catálogo no contiene datos, no expone `prompt_template` y no dispone de
  acceso directo desde Flutter/PostgREST.
- El harness 2B-III-A superó 56/56 pruebas; la suite SQL local acumulada superó
  100/100 pruebas.
- El rollback asimétrico elimina el catálogo y conserva el endurecimiento
  deny-all de `public.specialists`; la reaplicación fue verificada.
- No se conectó Supabase remoto ni se habilitaron backend real, auth real,
  datos reales, API, RPC, vista, función, Edge Function o nuevas features.
- 2B-III-A fue cerrado formalmente el 2026-06-14.
- Para 2B-III-B se recomienda únicamente fixtures locales transaccionales,
  porque un seed persistente requeriría inventar o aprobar primero filas
  internas de `public.specialists`.
- Cualquier 2B-III-B/C/D requiere aprobación explícita independiente.

## Resultado local del micro-paquete 2B-III-B

Fecha de implementación y verificación: 2026-06-14.

- Se creó únicamente un harness de fixtures locales transaccionales; no se
  creó seed persistente ni migración nueva.
- Se validaron seis especialistas ficticios `test_only` y seis entradas
  conceptuales, con separación entre ID público e ID interno.
- El harness superó 40/40 pruebas y la suite SQL acumulada 140/140.
- Tras rollback, reset y reaplicación se verificaron cero fixtures persistentes.
- `public.specialists` y `public.specialist_catalog` continúan deny-all para
  clientes, sin policies ni grants nuevos.
- No se utilizaron remoto, datos reales, credenciales reales, backend, API,
  Flutter, vistas, RPC, Edge Functions, chats ni mensajes.
- 2B-III-B fue cerrado formalmente el 2026-06-14.
- Para 2B-III-C se recomienda condicionalmente una Edge Function
  exclusivamente local como primera implementación de la API controlada.
- El diseño de 2B-III-C fue aprobado documentalmente el 2026-06-14, pero no
  autoriza crear ni ejecutar la Edge Function.
- 2B-III-C1 queda aprobado documentalmente: `service_role` puede usarse
  condicionalmente solo como identidad técnica efímera local, aislada y
  revocable dentro de una futura implementación aprobada.
- En el momento de cerrar 2B-III-B, la Edge Function aún no estaba
  implementada ni autorizada. Fue autorizada, implementada y cerrada después
  exclusivamente en local con JWT verificado contra Auth local, contrato
  exacto, consultas allowlist, logs seguros, anti-remoto y limpieza.
- Cualquier secreto persistente, ampliación de Edge Function, implementación
  2B-III-C2/D, acceso remoto o permanente requiere aprobación explícita
  independiente.

## Resultado local de 2B-III-C

Fecha de implementación y verificación: 2026-06-14.

- Se implementó exclusivamente una Edge Function local/efímera para listar el
  catálogo sanitizado.
- JWT se valida contra Auth local antes de usar la identidad técnica.
- `service_role` se limita al runtime local, no se versiona ni llega a
  Flutter, respuestas o logs.
- La función devuelve exactamente los seis campos públicos aprobados y
  rechaza identidad, roles, entitlement o `accessState` enviados por cliente.
- Consultas y logs usan allowlists; hosts no locales fallan cerrados.
- Tests Deno 11/11, harness HTTP local aprobado y suite SQL 140/140.
- Tras limpieza permanecen cero filas de catálogo y cero identidades Auth
  ficticias del harness.
- No se ejecutaron deploy, link, db push, remoto, migraciones nuevas, RPC,
  vistas, Flutter, sesiones o mensajes.
- 2B-III-C queda cerrado formalmente el 2026-06-14, aceptando como riesgo
  residual que la integración HTTP real validó catálogo vacío.
- 2B-III-C2 queda preparado documentalmente para validar una respuesta HTTP no
  vacía mediante fixtures locales efímeros confirmados y cleanup compensatorio
  obligatorio. No puede afirmarse una única transacción SQL porque la función
  consulta desde otra conexión.
- 2B-III-C2, 2B-III-D, 2B-IV, remoto, producción, datos reales y backend
  permanente continúan sin autorización.

## Resultado local de 2B-III-C2

Fecha de implementación y verificación: 2026-06-14.

- Se validó la ruta completa local con 21 fixtures efímeros confirmados,
  respuesta HTTP sanitizada no vacía y cleanup compensatorio obligatorio.
- La respuesta general devolvió 20 de 21 fixtures en orden estable; el filtro
  wellness y los cuatro estados canónicos fueron correctos.
- El contrato mantuvo exactamente seis campos sin información interna.
- Acceso directo cliente a `specialist_catalog` continuó denegado.
- Logs, JWT, identidad técnica y anti-remoto cumplieron los controles
  aprobados.
- Tras cleanup quedaron cero catálogo, cero especialistas C2, cero usuarios
  Auth C2 y cero policies nuevas.
- La Edge Function, migraciones, esquema, Flutter y CI no fueron modificados.
- Tests posteriores: Deno 11/11 y SQL 140/140.
- C2 queda cerrado formalmente el 2026-06-14. Su cierre no autoriza Flutter,
  catálogo visible, sesiones, mensajes, remoto ni producción.
- 2B-III-D queda preparado documentalmente como contrato Flutter desconectado:
  entidad mínima de seis campos, resultados tipados, repositorios demo y
  backend bloqueado, validación estricta y sin fallback silencioso.
- `EdgeFunctionSelectableSpecialistsRepository` permanece solo como contrato
  futuro sin implementación activa. 2B-III-D, 2B-IV, remoto y producción
  siguen sin autorización.

## Resultado desconectado de 2B-III-D

Fecha de implementación y verificación: 2026-06-14.

- Flutter dispone de entidad mínima, enums, resultados tipados, repositorio
  abstracto, catálogo demo local y repositorio backend bloqueado.
- El validador del contrato backend futuro acepta solo el envelope `items` y
  los seis campos públicos aprobados; cualquier ampliación falla cerrada.
- No existe adaptador ejecutable a Edge Function o Supabase y ningún provider
  puede seleccionar backend real o producción.
- No se crean sesiones, mensajes ni acciones IA.
- Verificación: `build_runner` sin salidas nuevas, suite Flutter 49/49,
  análisis sin errores ni warnings bloqueantes y `git diff --check` correcto.
- 2B-III-D queda cerrado formalmente; 2B-IV y cualquier conexión real requieren
  aprobación separada.

## Síntesis del plan exacto 2B-IV — `chat_sessions`

Fecha de preparación documental: 2026-06-14.

- El contrato anterior 2C-II queda refinado: Flutter nunca enviará ni recibirá
  `user_id` o `specialist_id`; la creación usa únicamente
  `selectableSpecialistId`.
- El backend derivará owner del JWT y resolverá internamente
  `specialist_catalog.id -> specialists.id`, revalidando publicación,
  disponibilidad y entitlement.
- Listado y archivado usarán proyecciones seguras, confirmación exacta,
  paginación estable y archivado lógico sin delete físico.
- Se recomienda para el primer MVP exclusivamente local una Edge Function
  separada y controlada, manteniendo `chat_sessions` deny-all sin grants
  cliente ni policies permisivas.
- `messages` queda fuera de 2B-IV y reservado para 2B-V.
- El diseño completo, riesgos, rollback, tests y gates se encuentran en
  ADR-007. No se autoriza todavía implementación SQL, Edge Function, Flutter,
  remoto, sesiones reales o datos reales.

## Síntesis del plan exacto 2B-IV-A

Fecha de preparación documental: 2026-06-14.

- 2B-IV queda aprobado únicamente como diseño y dividido en A-F; cada
  subpaquete requiere aprobación separada.
- 2B-IV-A endurecerá en una futura implementación local exclusivamente
  `public.chat_sessions`: RLS deny-all, cero policies/grants cliente,
  `NOT NULL`, checks mínimos e índice owner/orden estable.
- La migración futura deberá fallar cerrado si existen filas incompatibles; no
  podrá inventar backfills de owner, especialista, fechas, estado o contador.
- No se añaden estados, uniqueness de sesión activa, cambio de tipos timestamp
  o modificación de `ON DELETE` en A.
- Rollback y reaplicación conservarán deny-all y demostrarán que `messages`
  permanece intacta.
- El diseño completo de A está en ADR-007. En el momento de preparar el plan,
  A, B-F, 2B-V, SQL, Edge Functions, Flutter, sesiones, datos y remoto
  continuaban sin autorización. A fue autorizado e implementado después
  exclusivamente en local; B-F y 2B-V siguen bloqueados.

## Resultado local de 2B-IV-A

Fecha de implementación y verificación: 2026-06-14.

- `public.chat_sessions` quedó endurecida con preflight fail-closed,
  constraints mínimos, índice owner/orden estable y deny-all cliente.
- RLS está habilitada sin FORCE, con cero policies y cero grants para
  `PUBLIC`, `anon` y `authenticated`.
- `messages` no fue modificada.
- Rollback asimétrico, preflight incompatible y reaplicación fueron probados
  exclusivamente en local.
- Evidencia: harness 2B-IV-A 40/40 y suite SQL acumulada 180/180.
- No se usaron remoto, datos reales, seed, Edge Functions, Flutter, CI,
  create/list/archive o mensajes.
- 2B-IV-A queda cerrado formalmente. 2B-IV-B-F y 2B-V requieren aprobación
  separada.

## Síntesis del plan exacto 2B-IV-B

Fecha de preparación documental: 2026-06-14.

- B usará exclusivamente fixtures SQL/pgTAP transaccionales bajo
  `BEGIN/ROLLBACK`, porque no existe frontera cross-connection en este
  subpaquete.
- Seed persistente, migraciones con datos, setup confirmado y cleanup
  compensatorio quedan prohibidos en B.
- Se proponen dos usuarios/perfiles ficticios, un especialista interno, una
  entrada de catálogo y tres sesiones: activa propia, archivada propia y
  ajena.
- El orden de creación respeta FKs; todos los IDs/textos serán
  `test_only_2b_iv_b`.
- Éxito exige cero fixtures después de rollback y después de reset/reaplicación.
- Fixtures confirmados con cleanup solo podrán evaluarse en C/D/E si una
  conexión distinta necesita observarlos, bajo aprobación separada y sin
  convertirse nunca en seed.
- B no implementa create/list/archive, Edge Functions, Flutter o `messages`.
  El diseño completo está en ADR-007.

## Resultado local de 2B-IV-B

Fecha de implementación y verificación: 2026-06-14.

- Fixtures creados exclusivamente dentro de una transacción revertida:
  dos usuarios/perfiles, un especialista interno, una entrada de catálogo y
  tres sesiones propias/ajenas.
- Harness 2B-IV-B 31/31, postcondiciones 8/8 y suite SQL acumulada 219/219.
- Una comprobación externa posterior confirmó cero fixtures en todas las
  tablas afectadas y cero filas en `messages`.
- Ninguna migración fue modificada: los SHA-256 de `00001`-`00005`
  permanecieron idénticos antes y después.
- No se confirmó ningún dato y no se usaron seed persistente, cleanup
  compensatorio, remoto, credenciales reales ni datos reales.
- 2B-IV-B quedó cerrado formalmente el 2026-06-14; 2B-IV-C-F y 2B-V
  continúan bloqueados.

## Síntesis del cierre 2B-IV-B y plan exacto 2B-IV-C

Fecha: 2026-06-14.

- 2B-IV-B queda cerrado formalmente: harness 31/31, postcondiciones 8/8,
  suite 219/219, hashes de migraciones intactos y cero persistencia.
- 2B-IV-C propone una Edge Function nueva exclusivamente local que recibe solo
  `selectableSpecialistId`, valida JWT y deriva owner desde `sub`.
- La función resolverá internamente catálogo e ID de especialista, exigirá
  publicado/disponible/free y bloqueará premium sin entitlement.
- Flutter no podrá enviar ownership, IDs internos ni campos server-managed.
- Para MVP local, cada invocación válida y confirmada creará siempre una
  sesión nueva. No se reutilizará una sesión activa ni se añadirá unicidad por
  owner/especialista.
- La protección robusta ante reintentos mediante `Idempotency-Key` queda
  recomendada antes de remoto/producción y requiere diseño separado.
- Éxito exige exactamente una fila y una proyección pública segura; no se
  crean mensajes ni se invoca IA.
- 2B-IV-C fue implementado después exclusivamente en local/efímero y cerrado
  formalmente el 2026-06-14. D-F, 2B-V, Flutter, remoto y producción
  permanecen bloqueados.

## Resultado local de 2B-IV-C

Fecha de implementación y verificación: 2026-06-14.

- La Edge Function local recibe solo `selectableSpecialistId`, valida JWT,
  deriva owner y resuelve internamente el especialista.
- Dos llamadas válidas crearon dos sesiones activas distintas; no existe
  reutilización implícita de sesión activa.
- La respuesta pública no expone `user_id`, `specialist_id`, IDs internos,
  prompts ni configuración sensible.
- No se crearon mensajes y `messages` permaneció intacta.
- Harness HTTP PASS, Deno 17/17, SQL 219/219 y postcondiciones
  `0|0|0|0|0|0`.
- La implementación sigue siendo exclusivamente local/efímera. Su secuencia
  REST privilegiada no es atómica y deberá rediseñarse antes de remoto.
- 2B-IV-D/E/F, 2B-V, Flutter, remoto y producción continúan bloqueados.

## Síntesis del cierre 2B-IV-C y plan exacto 2B-IV-D

Fecha: 2026-06-14.

- 2B-IV-C queda cerrado formalmente con HTTP PASS, Deno 17/17, SQL 219/219,
  cleanup `0|0|0|0|0|0`, hashes intactos y anti-remoto verificado.
- 2B-IV-D propone una Edge Function local que lista exclusivamente sesiones
  del owner derivado del JWT, con `status=active` por defecto, límite 20/50 y
  cursor keyset opaco por `lastMessageAt + sessionId`.
- La respuesta usa únicamente la proyección pública aprobada y nunca expone
  `user_id`, `specialist_id`, IDs internos, prompts o configuración.
- Cada sesión debe resolver exactamente una entrada publicada de catálogo.
  Una sesión sin catálogo resoluble produce `contractViolation` y aborta toda
  la respuesta; no se omite ni se sustituye por placeholder.
- `backendMisconfigured` queda reservado a configuración/dependencia
  operativa inválida, no a incoherencias de datos.
- 2B-IV-D fue implementado después exclusivamente en local/efímero y cerrado
  formalmente el 2026-06-14. E/F, 2B-V, Flutter, remoto y producción
  continúan bloqueados.

## Resultado local de 2B-IV-D

Fecha de implementación y verificación: 2026-06-14.

- La Edge Function local valida JWT, deriva owner y lista solo sus sesiones.
- El cursor keyset dividió tres sesiones en páginas 2 + 1 sin duplicados,
  incluso con empate en `last_message_at`.
- Usuario A no recibió sesiones de B y viceversa.
- Una sesión sin catálogo publicado resoluble produjo
  `502 contractViolation` sin `items`, lista parcial o placeholder.
- Las respuestas exitosas no exponen `user_id`, `specialist_id`, IDs internos,
  prompts o configuración sensible.
- La función fue de solo lectura: sesiones, mensajes, catálogo y especialistas
  permanecieron intactos.
- Harness HTTP PASS, Deno 24/24, SQL 219/219 y cleanup
  `0|0|0|0|0|0`.
- La implementación sigue siendo exclusivamente local/efímera. E/F, 2B-V,
  Flutter, remoto y producción continúan bloqueados.

## Síntesis del cierre 2B-IV-D y plan exacto 2B-IV-E

Fecha: 2026-06-14.

- 2B-IV-D queda cerrado formalmente con HTTP PASS, Deno 24/24, SQL 219/219,
  cleanup `0|0|0|0|0|0`, hashes intactos y anti-remoto verificado.
- 2B-IV-E propone una Edge Function local que recibe solo `sessionId`, valida
  JWT, deriva owner y archiva exclusivamente una sesión propia `active`.
- La única mutación permitida es `status: active -> archived`.
- `last_message_at` se conserva exactamente porque archivar no representa
  actividad conversacional; también permanecen intactos timestamps iniciales,
  contador, owner, especialista e ID.
- La respuesta MVP será mínima y exacta:
  `{"session":{"sessionId":"...","status":"archived"}}`.
- Inexistente, ajena y ya archivada compartirán resultado opaco
  `sessionNotFound`; no se filtra existencia ni ownership.
- 2B-IV-E fue implementado después exclusivamente en local/efímero y cerrado
  formalmente el 2026-06-14. Esta síntesis histórica no autorizaba F, 2B-V,
  Flutter, remoto o producción.

## Resultado local de 2B-IV-E

Fecha de implementación y verificación: 2026-06-14.

- La Edge Function local valida JWT, deriva owner y ejecuta un único `PATCH`
  filtrado por sesión, owner y `status=active`.
- Solo cambió `status: active -> archived`; `last_message_at`, `started_at`,
  `message_count`, owner, especialista e ID permanecieron idénticos.
- Ajena, ya archivada, inexistente y segundo intento produjeron el mismo
  `404 sessionNotFound` opaco.
- La respuesta exitosa contiene exclusivamente `sessionId` y `status`.
- Otras sesiones, mensajes, catálogo y especialistas permanecieron intactos.
- Harness HTTP PASS, Deno 29/29, SQL 219/219 y cleanup
  `0|0|0|0|0|0`.
- La implementación sigue siendo exclusivamente local/efímera. F, 2B-V,
  Flutter, remoto y producción continúan bloqueados.

## Síntesis del cierre 2B-IV-E y plan exacto 2B-IV-F

Fecha: 2026-06-14.

- 2B-IV-E queda cerrado formalmente con HTTP PASS, Deno 29/29, SQL 219/219,
  cleanup `0|0|0|0|0|0`, mutación exclusiva de `status`, conservación exacta
  de `last_message_at` y respuesta mínima sin IDs internos.
- 2B-IV-F queda preparado únicamente como plan de contrato Flutter
  desconectado para crear, listar y archivar sesiones.
- El contrato futuro recibe solo `selectableSpecialistId`, filtros/cursor
  públicos o `sessionId`, según operación; nunca recibe owner, `userId`,
  `specialistId` interno ni campos gestionados por servidor.
- Los modelos públicos futuros prohíben `userId`, `user_id`, `specialistId`,
  `specialist_id`, `internalSpecialistId` y alias equivalentes.
- F permitirá solo repositorios demo explícito, backend bloqueado y validación
  contractual estricta. No permitirá datasource HTTP/Supabase, URLs, llamadas
  a Edge Functions ni provider remoto.
- El contexto `lib/features/chat/` heredado conserva IDs internos y acceso
  Supabase directo; F no lo reutiliza ni afirma corregirlo. Su sustitución
  requiere aprobación y paquete separados.
- Los tests futuros deberán demostrar ausencia de conexión, ausencia de IDs
  internos, fallback demo imposible en modos no demo, cursor opaco y rechazo
  de payloads extra o parciales.
- 2B-V/messages, Flutter-backend real, remoto, producción y datos reales
  continúan bloqueados.

## Resultado de implementación 2B-IV-F

Fecha: 2026-06-14.

- Se implementó un contexto Flutter nuevo en `lib/features/chat_sessions/`,
  separado del chat heredado que aún contiene contratos internos inseguros.
- El repositorio público acepta únicamente `selectableSpecialistId`,
  filtros/límite/cursor o `sessionId`, según operación.
- Ningún contrato público nuevo contiene owner, `userId`, `specialistId`
  interno, alias equivalentes o autoridad.
- Se implementaron repositorios demo explícito, backend bloqueado y validación
  contractual simulada, todos sin I/O.
- El contexto no importa Supabase, HTTP real ni runtime backend; tampoco
  invoca o conoce URLs ejecutables de Edge Functions.
- Los resultados tipados impiden convertir errores backend en éxito o demo.
- Tests unitarios y arquitectónicos demuestran modelos mínimos, validación
  estricta, cursor opaco, mutación demo mínima, bloqueo backend y ausencia de
  conexión o IDs internos.
- Flutter-backend, auth real, remoto, producción, mensajes y datos reales
  continúan bloqueados.

## Síntesis del cierre 2B-IV-F y plan exacto 2B-IV-G

Fecha: 2026-06-14.

- 2B-IV-F queda cerrado formalmente con tests específicos 14/14, suite
  completa 63/63, generación con 0 salidas, análisis sin avisos del nuevo
  paquete y diff check correcto.
- El contrato Flutter cerrado no importa Supabase/HTTP real, no ejecuta red,
  no llama Edge Functions y no expone owner, `userId`, `specialistId` interno
  o alias en contratos públicos.
- 2B-IV A-F quedan completados localmente: endurecimiento deny-all, fixtures
  transaccionales, Edge Functions locales create/list/archive y contrato
  Flutter desconectado.
- 2B-IV-G queda preparado solo documentalmente como datasource HTTP Flutter
  exclusivamente local, pendiente de aprobación separada.
- G deberá obtener JWT local mediante proveedor inyectado, sin hardcodear,
  versionar, persistir o loguear tokens y sin aceptar identidad manual.
- G fallará cerrado antes de I/O salvo que esquema, host, puerto y entorno
  pertenezcan a la composición local autorizada; remoto, project refs,
  redirecciones remotas y producción quedan bloqueados.
- Los requests futuros tendrán allowlists exactas: create solo
  `selectableSpecialistId`, list solo filtros/límite/cursor y archive solo
  `sessionId`.
- Se prohíbe usar Supabase client como atajo de transporte o sesión.
- `ValidatingOwnChatSessionsRepository` seguirá siendo la frontera estricta
  que rechaza campos internos, extra, parciales o sensibles.
- Ningún error podrá transformarse en demo o éxito silencioso.
- 2B-IV-G no implementa mensajes, auth real, remoto, producción, IA, Stasis
  Engine, datos reales ni sustitución del chat heredado.

## Resultado de implementación 2B-IV-G

Fecha: 2026-06-14.

- Se implementaron datasource HTTP local, proveedor abstracto de token,
  política local-only y transporte HTTP inyectable/testeable.
- La política local-only bloquea host remoto, HTTPS, dominio Supabase,
  composición deshabilitada, URI insegura y ausencia de puerto explícito antes
  de leer token o ejecutar transporte.
- JWT ausente o vacío produce resultado tipado sin ejecutar red; no existe
  token concreto, hardcodeado, persistido, versionado o logueado.
- Los requests respetan las allowlists aprobadas y nunca aceptan owner,
  `userId`, `specialistId` interno, campos server-managed, roles o permisos.
- El transporte Dio desactiva redirecciones y no usa Supabase client.
- Respuestas y errores siguen pasando por validación contractual estricta;
  fallos de transporte permanecen `networkError` y ningún error cae a demo.
- Tests específicos 32/32 y suite completa 81/81; generación con 0 salidas,
  análisis sin avisos del nuevo paquete y diff check correcto.
- G no fue conectado a providers/UI, no hizo HTTP real y no modificó Supabase,
  funciones, migraciones, CI, mensajes, remoto o producción.
- Proveedor concreto de JWT, integración HTTP real local y composición runtime
  requieren paquetes y aprobación separados.

## Síntesis del cierre 2B-IV-G y plan exacto 2B-IV-H

Fecha: 2026-06-15.

- 2B-IV-G queda cerrado formalmente con tests específicos 32/32, suite
  completa 81/81, generación con 0 salidas, análisis sin avisos de G y diff
  check correcto.
- Host remoto, HTTPS, Supabase remoto, producción y ausencia de puerto
  explícito fallan antes de leer token o ejecutar transporte.
- JWT ausente o vacío no ejecuta red; no existe token concreto hardcodeado,
  versionado, persistido o logueado.
- Ningún error real se convierte en demo o éxito.
- 2B-IV-H se preparó inicialmente como integración HTTP local controlada entre
  datasource Flutter, Edge Functions locales y Supabase local; el resultado
  verificado queda registrado en la sección posterior.
- H usa un proveedor JWT exclusivamente de test, obtiene JWT de Auth local y no
  versiona tokens reales.
- H usa fixtures efímeros marcados `test_only_2b_iv_h` para Auth local,
  `public.users`, especialista interno y `specialist_catalog`.
- Cleanup obligatorio deja cero fixtures en Auth, `public.users`,
  `specialists`, `specialist_catalog`, `chat_sessions` y `messages`; si falla,
  se ejecutará `supabase db reset --local --no-seed`.
- Anti-remoto: sin project ref, sin link, sin deploy, sin `db push`, sin tokens
  remotos y con funciones servidas localmente por CLI.
- 2B-IV-H no implementa messages, IA, Stasis Engine, UI, providers definitivos,
  remoto o producción.

## Resultado de implementación 2B-IV-H

Fecha: 2026-06-15.

2B-IV-H fue aprobado, implementado y verificado únicamente como harness local
controlado. Queda cerrado formalmente como integración local; no desbloquea
remoto, producción, providers reales, UI, mensajes, auth real ni Stasis Engine.

Se prepararon:

- test de integración Flutter local para el flujo create/list/archive/list;
- proveedor JWT local de test mediante `dart-define`, sin token versionado;
- harness shell local con comprobación anti-remoto antes de ejecutar;
- setup y cleanup SQL locales con fixtures `test_only_2b_iv_h`;
- cleanup con postcondición exacta esperada `0|0|0|0|0|0` para Auth,
  `public.users`, `specialists`, `specialist_catalog`, `chat_sessions` y
  `messages`;
- fallback de emergencia a `supabase db reset --local --no-seed` si el cleanup
  no deja cero fixtures;
- test de ausencia de JWT y host remoto bloqueado antes de transporte.

Evidencia obtenida:

- el archivo Dart de integración formatea correctamente;
- `flutter analyze --no-fatal-infos` sobre el test no reporta issues;
- `flutter test` sobre el test queda saltado intencionadamente si no existen
  los `dart-define` del harness local;
- `supabase start` arrancó el entorno local;
- `supabase db reset --local --no-seed` aplicó `00001` a `00005`;
- el harness `2b_iv_h_local_http_integration_test.sh` pasó completo;
- el flujo real local create/list/archive/list funcionó contra Edge Functions
  locales;
- el datasource Flutter usó JWT local efímero por `dart-define`;
- sin JWT y host remoto fallan antes de transporte;
- `messages` permaneció intacta;
- logs revisados sin token, owner id, especialista interno, `user_id`,
  `specialist_id`, `prompt_template` ni `service_role`;
- cleanup dejó la postcondición exacta `0|0|0|0|0|0`;
- no se versionó ningún token real, JWT, anon key remota ni service role remoto.

Incidencias detectadas y corregidas durante la integración:

- la Edge Function de creación devuelve `201 Created`; el validador Flutter
  aceptaba solo `200`, por lo que se amplió el contrato a `200`/`201` con test;
- PostgREST devuelve `TIMESTAMP` histórico sin zona (`2026-...T...`); Flutter
  normaliza esos valores locales a UTC y lo cubre con test específico. La deuda
  técnica futura es migrar/serializar timestamps como UTC explícito.

Comandos relevantes:

```bash
supabase start
supabase db reset --local --no-seed
bash supabase/tests/2b_iv_h_local_http_integration_test.sh
```

Resultado principal:

```text
2B-IV-H local HTTP integration harness: PASS
0|0|0|0|0|0
```

Decisión: 2B-IV-H queda cerrado formalmente como integración local controlada.
El siguiente paquete deberá planificar 2B-V `messages` o el wiring futuro de
providers/UI mediante aprobación separada.

## Síntesis del cierre 2B-IV-H y plan documental 2B-V messages

Fecha: 2026-06-15.

2B-IV-H queda cerrado formalmente. Se acepta como evidencia:

- flujo local real `create -> list -> archive -> list` validado;
- datasource Flutter integrado contra HTTP local;
- Edge Functions locales y Supabase local usados como backend efímero;
- JWT local, efímero y no versionado;
- ausencia de tokens reales versionados;
- remoto y producción no tocados;
- migraciones, Edge Functions y CI no modificados;
- providers reales y UI no conectados;
- `messages` no implementada y permaneció intacta;
- cleanup final exacto `0|0|0|0|0|0`;
- harness H `PASS`;
- `build_runner` con 0 outputs;
- `flutter test` con 83 passed y 1 skip intencional del harness sin env;
- `flutter analyze --no-fatal-infos` con 48 infos preexistentes;
- `git diff --check` correcto;
- Supabase local detenido al final.

Queda aprobado que 2B-IV A-H cierra localmente el bloque mínimo de sesiones.
No se autoriza wiring UI/providers todavía porque conectar sesiones sin
mensajes seguros produciría un chat incompleto y podría empujar decisiones
inseguras en la capa de presentación.

El siguiente paquete recomendado es 2B-V `messages`, solo como diseño
documental en esta fase. Sus reglas base son:

- Flutter no puede enviar `role`, `userId`, `specialistId`, `created_at`,
  `message_count` ni `last_message_at`;
- el backend decide el `role` y para MVP local solo crea mensajes `user`;
- `assistant`, `system` y `tool` quedan reservados para IA/Stasis Engine futuro;
- no se permite escribir mensajes en sesiones archivadas;
- `message_count` y `last_message_at` son server-managed y deben actualizarse
  de forma atómica con la inserción de mensaje antes de remoto o producción;
- mensajes, IA, Stasis Engine, streaming, UI, providers reales, remoto y datos
  reales siguen bloqueados.

## Resultado de implementación 2B-V-A — messages deny-all + constraints mínimos

Fecha: 2026-06-15.

2B-V-A fue aprobado, implementado y verificado exclusivamente en Supabase
local/efímero. No desbloquea backend real, remoto, producción, auth real,
Flutter, Edge Functions, UI, IA, Stasis Engine, streaming, adjuntos ni datos
reales.

Cambios formalizados:

- nueva migración local `00006_harden_messages_deny_all.sql`;
- RLS habilitada en `public.messages` sin `FORCE ROW LEVEL SECURITY`;
- cero policies en `public.messages`;
- cero privilegios cliente `anon`/`authenticated` sobre `public.messages`;
- `session_id` pasa a `NOT NULL`;
- `created_at` pasa a `NOT NULL DEFAULT now()`;
- `role` queda limitado a `user`, `assistant`, `system` y `tool`;
- `chief_intervention` queda eliminado del contrato nuevo y falla cerrado;
- `content` no puede ser vacío, whitespace-only ni superar 4000 caracteres;
- `attachments` queda obligado a `NULL` para el MVP local;
- se reemplaza el índice simple histórico por
  `idx_messages_session_created_id(session_id, created_at, id)`;
- rollback local conserva deny-all y vuelve al shape histórico mínimo solo para
  probar reversibilidad.

Evidencia local:

- `supabase db reset --local --no-seed` aplicó `00001` a `00006`;
- test específico 2B-V-A: 57/57;
- suite SQL acumulada: 276/276;
- preflight incompatible con fixture local abortó con
  `2B-V-A preflight rejected 1 incompatible messages rows`;
- el preflight demostró que no hubo transformación parcial;
- rollback local dejó `RLS=true`, `FORCE=false`, `policies=0`, `messages=0` y
  cero grants cliente;
- reaplicación posterior volvió a dejar la suite completa en verde;
- evidencia de catálogo: `public.messages` terminó con RLS habilitada, sin
  FORCE, cero policies, cero grants cliente, `session_id` NOT NULL y cero filas.

Decisiones de seguridad:

- ningún cliente puede leer, insertar, actualizar o borrar mensajes todavía;
- el cliente no puede falsificar `role`;
- escribir en sesiones archivadas sigue bloqueado por denegación total;
- `message_count` y `last_message_at` continúan server-managed y no son
  modificados por 2B-V-A;
- no se crean seeds persistentes ni datos reales.

Pendiente:

- 2B-V-B/C/D/E/F/G requieren aprobación separada.
- Antes de permitir escritura real de mensajes debe existir Edge Function/RPC
  controlada que derive owner del JWT, fuerce `role=user`, rechace sesiones
  archivadas y actualice `message_count`/`last_message_at` atómicamente.

## Cierre formal 2B-V-A y plan exacto 2B-V-B — fixtures locales de messages

Fecha: 2026-06-16.

2B-V-A queda cerrado formalmente. Se acepta como estado aprobado que
`public.messages` fue endurecida exclusivamente en Supabase local, con
`session_id NOT NULL`, `created_at NOT NULL DEFAULT now()`, contenido no vacío,
longitud máxima de 4000 caracteres, `attachments IS NULL`, `role` limitado a
`user`, `assistant`, `system` y `tool`, `chief_intervention` rechazado, RLS
habilitada sin FORCE, cero policies, cero grants cliente, preflight
fail-closed, rollback/reaplicación local y suite SQL 276/276.

### Objetivo de 2B-V-B

Diseñar fixtures locales de `messages` que permitan probar datos de mensajes
sin crear seed persistente, sin abrir grants cliente, sin implementar envío o
listado real, y sin confundir mensajes históricos con permisos futuros de
escritura.

2B-V-B es exclusivamente un paquete de fixtures y tests SQL locales. No
implementa `send-user-message`, `list-session-messages`, Edge Functions,
Flutter, UI, providers, IA, Stasis Engine, streaming, remoto ni producción.

### Decisión de fixtures

La estrategia aprobada para el plan es:

- usar exclusivamente fixtures transaccionales con `BEGIN` y `ROLLBACK`;
- no crear datos en migraciones;
- no usar seed persistente;
- no usar fixtures confirmados con cleanup compensatorio en 2B-V-B salvo
  aprobación separada;
- exigir cero persistencia después del rollback;
- usar marcadores `test_only_2b_v_b` en usuarios, perfiles, especialistas,
  catálogo, sesiones y mensajes para facilitar auditoría.

### Fixtures mínimos propuestos

Fixtures base:

- `owner_user`;
- `other_user`;
- `internal_specialist`;
- `specialist_catalog_entry`;
- `owner_active_session`;
- `owner_archived_session`;
- `other_user_session`;
- `owner_user_message_1`;
- `owner_user_message_2`;
- `other_user_message`;
- `archived_session_message_existing`.

La fila `archived_session_message_existing` representa un mensaje histórico
creado antes de archivar la sesión. No implica que sea válido crear nuevos
mensajes en sesiones archivadas. La escritura futura en sesiones archivadas
debe seguir bloqueada en 2B-V-C.

### Orden de creación

Orden propuesto:

1. `BEGIN`.
2. Insertar `auth.users` para owner y other.
3. Insertar `public.users`.
4. Insertar `public.specialists`.
5. Insertar `public.specialist_catalog`.
6. Insertar `public.chat_sessions`.
7. Insertar `public.messages`.
8. Ejecutar assertions.
9. `ROLLBACK`.
10. Verificar cero persistencia desde una transacción nueva o consulta externa.

### Escenarios de prueba

Mensajes de sesión propia activa:

- varios mensajes válidos;
- orden estable por `created_at ASC, id ASC`;
- roles internos válidos;
- `content` válido;
- `attachments NULL`.

Mensajes de sesión ajena:

- preparar aislamiento futuro;
- owner no deberá leerlos en endpoint futuro;
- owner no deberá insertar en esa sesión en endpoint futuro.

Mensajes en sesión archivada:

- permitir fixture histórico ya existente;
- no usarlo como permiso para escritura futura;
- servir como base para decidir lectura futura de sesiones archivadas.

Mensajes inválidos:

- `session_id NULL`;
- `session_id` inexistente;
- `content NULL`;
- `content` vacío;
- `content` whitespace-only;
- `content` mayor de 4000 caracteres;
- `role` inválido;
- `role = chief_intervention`;
- `attachments` no `NULL`;
- `created_at NULL`.

### Tests futuros propuestos

- cardinalidad exacta dentro de la transacción;
- FKs válidas;
- sesiones owner activas con mensajes múltiples;
- sesiones ajenas con mensajes;
- sesión archivada con mensaje histórico;
- roles válidos aceptados internamente;
- `chief_intervention` rechazado;
- contenido inválido rechazado;
- attachments no `NULL` rechazado;
- orden estable por `(created_at ASC, id ASC)`;
- RLS deny-all se mantiene;
- anon/authenticated sin CRUD;
- `chat_sessions` intacta;
- `message_count` y `last_message_at` no se modifican por los fixtures salvo
  que el propio test inserte directamente datos para preparar estado;
- `ROLLBACK` obligatorio;
- cero persistencia;
- anti-remoto.

### Relación con paquetes posteriores

- 2B-V-B = fixtures locales de `messages`.
- 2B-V-C = `send-user-message`.
- 2B-V-D = `list-session-messages`.

2B-V-B no autoriza envío ni listado real. Cualquier escritura real futura debe
validar owner, sesión activa, role forzado por backend y actualización atómica
de `chat_sessions`.

## Resultado de implementación 2B-V-B — fixtures locales transaccionales de messages

Fecha: 2026-06-16.

2B-V-B fue aprobado, implementado y verificado exclusivamente como tests SQL
locales con fixtures transaccionales. No crea migraciones, no modifica
migraciones existentes, no crea seed persistente, no confirma fixtures y no usa
cleanup compensatorio.

Archivos de test:

- `supabase/tests/2b_v_b_messages_fixtures_test.sql`;
- `supabase/tests/2b_v_b_messages_fixtures_zz_postconditions_test.sql`.

Resultado técnico:

- el test principal usa `BEGIN` y `ROLLBACK`;
- fixtures marcados `test_only_2b_v_b`;
- owner y other user separados;
- especialista interno y entrada de catálogo local;
- sesión propia activa, sesión propia archivada y sesión ajena;
- mensajes propios, mensaje ajeno y mensaje histórico en sesión archivada;
- roles `user`, `assistant`, `system` y `tool` aceptados internamente;
- `chief_intervention` y roles inválidos rechazados;
- contenido vacío, whitespace-only, `NULL` o mayor de 4000 caracteres
  rechazado;
- attachments no `NULL` rechazado;
- orden estable verificado por `created_at ASC, id ASC`;
- deny-all de `messages` preservado: RLS sin FORCE, cero policies y cero grants
  cliente;
- anon/authenticated sin CRUD;
- `message_count` y `last_message_at` no se actualizan automáticamente por
  fixtures directos;
- el mensaje histórico en sesión archivada queda documentado como estado
  pasado, no como permiso para escribir en sesiones archivadas.

Evidencia:

- `supabase db reset --local --no-seed` aplicó `00001` a `00006`;
- test específico B: 55/55;
- postcondiciones B: 7/7;
- suite SQL acumulada: 338/338;
- comprobación externa tras `ROLLBACK`: `0|0|0|0|0|0`;
- estado externo de `messages`: `RLS=true`, `FORCE=false`, `policies=0`,
  `client_grants=0`;
- ejecución exclusivamente local sobre `127.0.0.1`;
- sin `link`, `db push`, deploy, remoto, datos reales ni tokens reales
  versionados.

Pendiente:

- 2B-V-C/D/E/F/G siguen bloqueados.
- 2B-V-C deberá implementar envío controlado, si se aprueba, sin aceptar
  `role` desde cliente, rechazando sesiones archivadas y actualizando
  `message_count`/`last_message_at` atómicamente.

## Cierre formal 2B-V-B y plan exacto 2B-V-C — send-user-message

Fecha: 2026-06-16.

2B-V-B queda cerrado formalmente. Se acepta como evidencia: fixtures
transaccionales `BEGIN/ROLLBACK`, cero seed persistente, cero `COMMIT`, cero
cleanup compensatorio, migraciones intactas, `chief_intervention` rechazado,
mensaje histórico en sesión archivada documentado como estado pasado, deny-all
conservado, postcondición `0|0|0|0|0|0`, test específico 55/55,
postcondiciones 7/7 y suite SQL 338/338.

### Objetivo de 2B-V-C

Diseñar `send-user-message` como Edge Function local para enviar
exclusivamente mensajes de usuario a una sesión propia activa. No implementa
listado, Flutter, UI, providers, IA, Stasis Engine, streaming, remoto ni
producción.

### Contrato HTTP futuro

Endpoint:

```http
POST /functions/v1/send-user-message
Authorization: Bearer <JWT_LOCAL_VALIDADO>
Content-Type: application/json
Accept: application/json
```

Body permitido:

```json
{
  "sessionId": "...",
  "content": "..."
}
```

Campos prohibidos y motivo:

- `role`: el backend fuerza `user`;
- `userId`, `user_id`: owner deriva del JWT;
- `specialistId`, `specialist_id`, `internalSpecialistId`: la sesión ya
  encapsula especialista;
- `created_at`, `createdAt`: timestamp server-managed;
- `message_count`, `messageCount`, `last_message_at`, `lastMessageAt`: campos
  server-managed;
- `attachments`: Storage/archivos no diseñados;
- `assistant`, `system`, `tool`: roles internos no humanos;
- `metadata`: evitar superficie no gobernada.

El contrato debe rechazar cualquier campo adicional.

### Validación JWT

- exigir JWT;
- validar JWT contra Auth local;
- derivar owner desde `sub`;
- no aceptar owner desde body;
- rechazar JWT ausente o inválido;
- no loguear JWT completo;
- fallar cerrado ante sesión inválida o identidad no resoluble.

### Validación de content

- `content` requerido;
- `trim(content)` no vacío;
- máximo 4000 caracteres tras normalización;
- sin attachments;
- sin tratamiento especial de HTML/Markdown en este paquete;
- guardar `content` trimmeado.

Se recomienda guardar contenido trimmeado porque evita persistir espacios
accidentales, alinea la validación con el constraint `btrim(content) <> ''` y
reduce diferencias invisibles en tests y listados. Si en el futuro se necesita
preservación literal, deberá ser una decisión de producto y privacidad
separada.

### Reglas de sesión

Permitir solo si:

- la sesión existe;
- pertenece al usuario derivado del JWT;
- `status = active`.

Errores:

- sesión inexistente o ajena: `sessionNotFound` opaco;
- sesión propia archivada: `sessionArchived`.

Esta decisión favorece UX para el owner en sesiones archivadas sin revelar
existencia de sesiones ajenas.

### Inserción de mensaje

La operación futura inserta:

- `session_id = sessionId` validado;
- `role = user`;
- `content = content` validado y trimmeado;
- `attachments = NULL`;
- `created_at = server time`.

Flutter nunca envía `role`, `created_at`, `attachments`, `userId` ni
`specialistId`. Cliente no puede crear `assistant`, `system` o `tool`.

### Decisión de atomicidad

La decisión recomendada para MVP local es usar una RPC/transacción controlada
desde backend local para insertar mensaje y actualizar `chat_sessions` en la
misma unidad atómica.

Operación atómica obligatoria:

1. validar owner y sesión activa;
2. insertar `public.messages`;
3. actualizar `public.chat_sessions.message_count = message_count + 1`;
4. actualizar `public.chat_sessions.last_message_at` con el `created_at` real
   del mensaje;
5. devolver mensaje y resumen de sesión confirmados.

La alternativa de Edge Function con dos llamadas REST privilegiadas no es
atómica y no debe considerarse solución final. Solo podría documentarse como
transición local experimental con riesgo explícito de mensaje insertado sin
contador actualizado, y no desbloquearía remoto ni producción.

### Respuesta pública

Éxito:

```json
{
  "message": {
    "messageId": "...",
    "sessionId": "...",
    "role": "user",
    "content": "...",
    "createdAt": "..."
  },
  "session": {
    "sessionId": "...",
    "messageCount": 1,
    "lastMessageAt": "..."
  }
}
```

No devolver `user_id`, `specialist_id`, prompts, `service_role`, JWT completo,
attachments, metadata interna ni IDs internos innecesarios.

### Errores futuros

| Código | HTTP | Uso |
| --- | --- | --- |
| `unauthenticated` | 401 | JWT ausente o inválido |
| `invalidRequest` | 400 | JSON inválido, campos extra o tipos incorrectos |
| `contentInvalid` | 400 | Content ausente, vacío o whitespace |
| `contentTooLong` | 413 | Content mayor de 4000 |
| `sessionNotFound` | 404 | Sesión inexistente o ajena |
| `sessionArchived` | 409 | Sesión propia archivada |
| `permissionDenied` | 403 | Identidad válida sin permiso |
| `writeUnconfirmed` | 500 | No se confirma atomicidad de escritura |
| `contractViolation` | 502 | Respuesta interna no cumple contrato |
| `backendMisconfigured` | 500 | Configuración local/backend inválida |
| `unexpectedError` | 500 | Error no clasificado |

### Tests futuros propuestos

- rechaza sin JWT;
- rechaza JWT inválido;
- rechaza `role`, `userId`, `specialistId`, `created_at`, `message_count`,
  `last_message_at`, `attachments` y campos extra;
- content vacío, whitespace y >4000 falla;
- sesión inexistente falla;
- sesión ajena falla opaca;
- sesión propia archivada falla con `sessionArchived`;
- sesión propia activa acepta mensaje;
- mensaje creado tiene `role=user`;
- no crea `assistant`, `system` ni `tool`;
- `message_count` incrementa exactamente 1;
- `last_message_at` coincide con `created_at` confirmado;
- operación es atómica o falla sin persistir estado parcial;
- no modifica `specialist_catalog` ni `specialists`;
- no invoca IA ni streaming;
- respuesta no expone IDs internos;
- cleanup deja cero fixtures;
- anti-remoto.

### Seguridad y anti-remoto

- `service_role` solo local si se usa, nunca versionado;
- secretos fuera del repositorio;
- logs sin JWT completo ni service role;
- host allowlist local;
- no `link`, no `db push`, no deploy;
- fallo cerrado ante host no local o configuración remota.

### Relación con paquetes posteriores

- 2B-V-C = enviar mensaje de usuario;
- 2B-V-D = listar mensajes;
- 2B-V-E = contrato Flutter desconectado;
- 2B-V-F = datasource Flutter HTTP local;
- 2B-V-G = integración HTTP local messages.

C no implementa listado, Flutter, IA ni streaming.

## División 2B-V-C y plan exacto 2B-V-C1 — RPC send_user_message_core

Fecha: 2026-06-16.

El plan conceptual de 2B-V-C queda aprobado, pero la implementación completa no
se autoriza en un único paquete. Se divide en:

- **2B-V-C1:** RPC local transaccional `send_user_message_core`.
- **2B-V-C2:** Edge Function local `send-user-message` que valida JWT/body,
  llama a C1, mapea errores y construye respuesta HTTP.

La decisión de arquitectura es que dos escrituras REST privilegiadas
independientes no son aceptables como solución final. La operación de envío
debe ser atómica: validar sesión propia activa, insertar mensaje `role=user`,
incrementar `message_count`, actualizar `last_message_at` y devolver resultado
confirmado sin estado parcial.

### Objetivo de 2B-V-C1

Diseñar una función SQL/RPC local controlada que ejecute en una única
transacción:

1. validar que la sesión existe;
2. validar que pertenece al owner recibido desde backend controlado;
3. validar `status = active`;
4. validar `content`;
5. insertar mensaje `role = user`;
6. mantener `attachments = NULL`;
7. incrementar `chat_sessions.message_count`;
8. actualizar `chat_sessions.last_message_at`;
9. devolver datos públicos confirmados;
10. no invocar IA;
11. no crear `assistant`, `system` ni `tool`;
12. no permitir role spoofing.

### Firma RPC propuesta

Nombre propuesto:

```sql
send_user_message_core(
  p_session_id uuid,
  p_owner_user_id uuid,
  p_content text
)
```

`p_owner_user_id` lo aporta exclusivamente la Edge Function local tras validar
JWT. Flutter nunca llama esta RPC directamente y nunca envía owner. La RPC no
es frontera pública de producto; es núcleo transaccional interno para C2.

### Validación de sesión

La RPC debe fallar si:

- `p_session_id IS NULL`;
- `p_owner_user_id IS NULL`;
- sesión inexistente;
- sesión ajena;
- sesión `archived`;
- cualquier estado no `active`.

Errores internos recomendados:

- `invalid_session_id`;
- `invalid_owner`;
- `session_not_found`;
- `session_archived`;
- `session_not_active`;
- `content_invalid`;
- `content_too_long`;
- `write_unconfirmed`;
- `backend_misconfigured`.

C2 será responsable de mapearlos a errores HTTP públicos.

### Validación de content

Validar:

- `p_content IS NOT NULL`;
- `btrim(p_content) <> ''`;
- `char_length(btrim(p_content)) <= 4000`.

Decisión conceptual aprobada: guardar `btrim(p_content)`. Esto alinea backend
con `messages_content_not_blank`, evita diferencias invisibles y simplifica
listados/tests.

### Inserción de message

Insertar:

- `session_id = p_session_id`;
- `role = 'user'`;
- `content = btrim(p_content)`;
- `attachments = NULL`;
- `created_at = now()` o un timestamp capturado una vez dentro de la operación.

La RPC no acepta `role`, `created_at`, `attachments`, metadata ni roles no
humanos. No crea `assistant`, `system` o `tool`.

### Actualización atómica de chat_sessions

La RPC debe actualizar exactamente una fila:

```text
message_count = message_count + 1
last_message_at = created_at del mensaje insertado
```

Si la actualización no afecta exactamente una sesión, toda la operación debe
fallar y no debe quedar mensaje insertado. El retorno solo se considera válido
si mensaje y sesión están confirmados en la misma transacción.

### Retorno público

La RPC debe devolver únicamente campos necesarios para que C2 construya:

```json
{
  "message": {
    "messageId": "...",
    "sessionId": "...",
    "role": "user",
    "content": "...",
    "createdAt": "..."
  },
  "session": {
    "sessionId": "...",
    "messageCount": 1,
    "lastMessageAt": "..."
  }
}
```

No devolver `user_id`, `specialist_id`, prompts, `prompt_template`,
`service_role`, JWT, attachments ni metadata interna.

### Permisos, grants y SECURITY DEFINER

Regla base:

- no grants a `anon`;
- no grants a `authenticated`;
- no grants a Flutter ni al cliente;
- solo invocable por rol backend/local controlado usado por C2;
- no crear policies permisivas nuevas sobre `messages`;
- no crear policies permisivas nuevas sobre `chat_sessions`;
- comprobar explícitamente que `anon` y `authenticated` no pueden invocar la
  RPC.

Postura recomendada: evitar `SECURITY DEFINER` si C2 puede invocar la RPC con
un rol backend local controlado y grants mínimos. Si la implementación futura
necesita `SECURITY DEFINER`, deberá aprobarse explícitamente y cumplir:

- propietario de función no usado por clientes;
- `SET search_path = public, pg_temp` o equivalente seguro y auditado;
- referencias de esquema explícitas (`public.messages`, `public.chat_sessions`);
- `REVOKE ALL ON FUNCTION ... FROM PUBLIC, anon, authenticated`;
- `GRANT EXECUTE` solo al rol backend local controlado;
- no SQL dinámico;
- tests de invocación denegada para `anon` y `authenticated`;
- tests de que no se abre acceso directo a tablas base;
- rollback que elimina función y grants sin tocar datos.

### Tests futuros 2B-V-C1

- RPC no invocable por `anon`;
- RPC no invocable por `authenticated`;
- rol backend local controlado puede invocarla;
- sesión propia activa inserta mensaje;
- sesión ajena falla;
- sesión archivada falla;
- sesión inexistente falla;
- `session_id NULL` falla;
- owner `NULL` falla;
- content vacío falla;
- content whitespace falla;
- content >4000 falla;
- mensaje creado con `role=user`;
- attachments queda `NULL`;
- `created_at` server-managed;
- `message_count` incrementa exactamente 1;
- `last_message_at` coincide con `created_at` del mensaje;
- si falla validación no se inserta mensaje;
- si falla actualización no queda estado parcial;
- no crea `assistant`, `system` o `tool`;
- no modifica `specialist_catalog`;
- no modifica `specialists`;
- RLS deny-all cliente se mantiene;
- cleanup deja cero fixtures;
- anti-remoto.

### Rollback futuro

Rollback local de C1:

- eliminar RPC;
- revocar grants asociados;
- conservar deny-all en `messages`;
- conservar deny-all en `chat_sessions`;
- no abrir grants cliente;
- no modificar datos reales;
- permitir reaplicación limpia.

### Relación con 2B-V-C2

C1 no implementa HTTP. C2 será la Edge Function local que:

- valida JWT;
- valida body;
- deriva owner;
- llama a C1;
- mapea errores;
- construye respuesta HTTP;
- mantiene anti-remoto.

C1 no autoriza Flutter, UI/providers, listado, IA, streaming, remoto ni
producción.

## Resultado de implementación 2B-V-C1 — RPC send_user_message_core

Fecha: 2026-06-20.

2B-V-C1 quedó implementado exclusivamente en Supabase local/efímero como
núcleo SQL/RPC transaccional para un futuro `send-user-message`. No expone HTTP,
no conecta Flutter y no autoriza backend real, remoto, producción, datos reales,
IA, Stasis Engine, MCP ni UI/providers.

### Archivos creados o actualizados

- `supabase/migrations/00007_create_send_user_message_core_rpc.sql`;
- `supabase/tests/2b_v_c1_send_user_message_core_test.sql`;
- `supabase/tests/2b_v_c1_send_user_message_core_zz_postconditions_test.sql`;
- `supabase/tests/2b_v_c1_send_user_message_core_rollback.psql`;
- `supabase/tests/README.md`;
- este ADR y el `SESSION_TRACKER.md`.

### Decisiones implementadas

- RPC `public.send_user_message_core(uuid, uuid, text)`.
- Sin `SECURITY DEFINER`; la función conserva el comportamiento invoker por
  defecto.
- `REVOKE ALL` para `PUBLIC`, `anon` y `authenticated`.
- `GRANT EXECUTE` solo a `service_role` para uso backend/local controlado.
- Sin policies permisivas nuevas sobre `messages` ni `chat_sessions`.
- `anon` y `authenticated` no pueden invocar la RPC.
- La RPC valida `session_id`, owner y contenido.
- Solo escribe mensajes `role='user'`.
- `attachments` queda `NULL`.
- `message_count` y `last_message_at` se actualizan en la misma operación
  transaccional que inserta el mensaje.
- Sesiones ajenas, archivadas, inexistentes y contenido inválido fallan sin
  insertar mensajes ni cambiar contadores.

### Evidencia local

- `supabase db reset --local --no-seed` aplicó `00001`-`00007`.
- Test específico C1: 48/48.
- Postcondiciones C1: 8/8.
- Suite SQL acumulada: 394/394.
- Catálogo PostgreSQL: `security_definer=false`, `anon_execute=false`,
  `authenticated_execute=false`, `service_role_execute=true`.
- `messages` y `chat_sessions` conservaron cero policies y cero grants cliente
  relevantes.
- Postcondición externa de fixtures: `0|0|0|0|0|0`.
- Rollback eliminó la RPC y conservó cero policies.
- Reaplicación mediante reset volvió a crear la RPC y toda la suite pasó de
  nuevo.

### Límites que permanecen

C1 no implementa `send-user-message` HTTP, JWT, body parsing, mapeo de errores,
contrato público final, listado de mensajes, integración Flutter, remoto,
producción, IA, Stasis Engine ni datos reales. Todo eso requiere aprobación
separada, empezando por 2B-V-C2.

## Cierre formal 2B-V-C1 y plan exacto 2B-V-C2 — Edge Function send-user-message

Fecha: 2026-06-20.

2B-V-C1 queda cerrado formalmente. Se acepta como estado aprobado que la RPC
`public.send_user_message_core(p_session_id uuid, p_owner_user_id uuid,
p_content text)` existe, no usa `SECURITY DEFINER`, tiene `prosecdef=false`,
niega `EXECUTE` a `PUBLIC`, `anon` y `authenticated`, solo permite
`service_role` local/controlado, conserva cero policies permisivas en
`messages` y `chat_sessions`, inserta únicamente `role='user'`, mantiene
`attachments=NULL`, captura `created_at` en servidor y actualiza
`message_count + 1` y `last_message_at = created_at` de forma transaccional.
La evidencia local aceptada es: C1 48/48, postcondiciones 8/8, suite SQL
394/394, cleanup `0|0|0|0|0|0`, rollback y reaplicación correctos, sin remoto
ni producción.

### Riesgos residuales aceptados tras C1

- C1 no valida JWT.
- C1 no valida body HTTP.
- C1 no mapea errores HTTP.
- C1 no construye respuesta HTTP.
- `service_role` queda reservado exclusivamente para backend/local controlado.
- La RPC no debe exponerse al cliente.
- La frontera HTTP segura queda para 2B-V-C2.

### Objetivo de 2B-V-C2

Diseñar una Edge Function local `send-user-message` que reciba una petición HTTP
mínima, valide JWT contra Auth local, derive owner desde el JWT, rechace campos
prohibidos, valide contenido, llame exclusivamente a
`public.send_user_message_core`, mapee errores internos a errores HTTP tipados
y devuelva una respuesta pública sanitizada.

C2 no implementa IA, streaming, listado de mensajes, Flutter, UI/providers,
remoto, producción, Stasis Engine, MCP ni datos reales.

### Contrato HTTP futuro

Endpoint:

```http
POST /functions/v1/send-user-message
Authorization: Bearer <JWT_LOCAL_VALIDADO>
Content-Type: application/json
Accept: application/json
```

Body permitido exacto:

```json
{
  "sessionId": "...",
  "content": "..."
}
```

Campos prohibidos y causa de rechazo:

```text
role
userId
user_id
specialistId
specialist_id
internalSpecialistId
created_at
createdAt
message_count
messageCount
last_message_at
lastMessageAt
attachments
assistant
system
tool
metadata
```

La función debe rechazar cualquier campo adicional. No debe aceptar owner,
rol, especialista, timestamps, contador, adjuntos ni metadata desde cliente.

### Validación JWT

C2 debe:

- exigir cabecera `Authorization: Bearer ...`;
- validar el JWT contra Auth local, no limitarse a decodificarlo;
- derivar `owner` desde `sub`;
- rechazar JWT ausente;
- rechazar JWT inválido;
- fallar cerrado si la identidad local no es válida;
- no aceptar `owner`, `userId` ni `user_id` desde body;
- no registrar el JWT completo en logs;
- no registrar secretos ni `service_role`.

### Validación body/content

Validaciones obligatorias:

- body JSON obligatorio y objeto;
- `sessionId` obligatorio;
- `sessionId` UUID válido;
- `content` obligatorio;
- `content` debe ser string;
- `btrim(content)` no vacío;
- `char_length(btrim(content)) <= 4000`;
- campos extra o internos prohibidos provocan `invalidRequest`.

La Edge Function puede trimar antes de llamar a la RPC, pero la RPC permanece
como autoridad final y conserva sus validaciones.

### Llamada a RPC

C2 debe llamar exclusivamente a:

```text
public.send_user_message_core
```

Con parámetros:

```text
p_session_id = sessionId validado
p_owner_user_id = owner derivado del JWT
p_content = content validado
```

Reglas críticas:

- no insertar directamente en `public.messages`;
- no actualizar directamente `public.chat_sessions`;
- no hacer dos escrituras REST separadas;
- no consultar primero si una sesión ajena existe para construir un error más
  específico;
- no exponer la RPC al cliente;
- no conceder `EXECUTE` a `anon` ni `authenticated`;
- mantener la atomicidad en la RPC.

### Mapeo de errores

Mapa HTTP futuro:

| Error público | HTTP | Origen esperado |
| --- | --- | --- |
| `unauthenticated` | 401 | JWT ausente |
| `invalidSession` | 401 | JWT inválido o identidad local inválida |
| `invalidRequest` | 400 | body inválido, JSON inválido, campo extra, `sessionId` inválido |
| `contentInvalid` | 400 | content nulo, no string, vacío o whitespace |
| `contentTooLong` | 400 | content trimmeado superior a 4000 caracteres |
| `sessionNotFound` | 404 | sesión inexistente o ajena |
| `sessionArchived` | 409 | sesión propia archivada |
| `permissionDenied` | 403 | denegación inesperada de permisos |
| `writeUnconfirmed` | 409 | RPC no confirma insert/update atómico |
| `contractViolation` | 502 | respuesta RPC o esquema no cumple contrato |
| `backendMisconfigured` | 503 | RPC ausente, grants incorrectos, env local inválido |
| `unexpectedError` | 500 | excepción no clasificada |

Decisión de privacidad: sesión inexistente y sesión ajena deben mapearse al
mismo `sessionNotFound` opaco. La función no debe filtrar si una sesión existe
pero pertenece a otro usuario. Solo una sesión propia archivada puede devolver
`sessionArchived`.

### Respuesta pública

Respuesta de éxito:

```json
{
  "message": {
    "messageId": "...",
    "sessionId": "...",
    "role": "user",
    "content": "...",
    "createdAt": "..."
  },
  "session": {
    "sessionId": "...",
    "messageCount": 1,
    "lastMessageAt": "..."
  }
}
```

No devolver:

```text
user_id
specialist_id
prompt_template
service_role
JWT
attachments
metadata interna
roles internos no necesarios
```

### Seguridad y logs

Controles obligatorios:

- `service_role`, si se usa, solo local y no versionado;
- secretos fuera del repositorio;
- host allowlist local;
- no logs de JWT completo;
- no logs de `service_role`;
- no logs de `user_id` completo;
- no logs de `content` completo si se considera sensible;
- no logs de `prompt_template`;
- no logs de `specialist_id`.

Logs permitidos:

```text
operation
result
latency
request_id
contract_version
error_code
```

### Tests futuros propuestos

Request/JWT:

- rechaza sin JWT;
- rechaza JWT inválido;
- deriva owner desde JWT local validado;
- rechaza body vacío;
- rechaza campos extra;
- rechaza `role`, `userId`, `specialistId`, `created_at`,
  `message_count`, `last_message_at`, `attachments` y `metadata`.

Content:

- content válido acepta;
- content se guarda trimmeado;
- content `NULL`, vacío, whitespace y superior a 4000 falla.

Sesiones:

- sesión propia activa crea mensaje;
- sesión ajena falla como `sessionNotFound`;
- sesión inexistente falla como `sessionNotFound`;
- sesión propia archivada falla como `sessionArchived`;
- segundo mensaje incrementa contador correctamente.

RPC/atomicidad:

- Edge Function llama a RPC;
- no inserta directamente en `messages`;
- no actualiza directamente `chat_sessions`;
- no deja estado parcial;
- `message_count` incrementa exactamente 1;
- `last_message_at` coincide con `createdAt` del mensaje.

Respuesta pública:

- contiene `message` y `session`;
- no expone `user_id`, `specialist_id`, `prompt_template`, `service_role`,
  `attachments` ni metadata interna.

Integridad:

- no modifica `specialist_catalog`;
- no modifica `specialists`;
- no invoca IA;
- no streaming;
- no listado de mensajes;
- cleanup deja cero fixtures.

Anti-remoto:

- no `link`;
- no `db push`;
- no deploy;
- no project ref remoto;
- no tokens remotos;
- solo Docker/Supabase local.

### Fixtures futuras

Marcador: `test_only_2b_v_c2`.

Fixtures locales:

- owner user;
- other user;
- especialista;
- catálogo;
- sesión propia activa;
- sesión propia archivada;
- sesión ajena.

Postcondición esperada:

```text
0|0|0|0|0|0
```

Sobre:

```text
auth.users
public.users
public.specialists
public.specialist_catalog
public.chat_sessions
public.messages
```

### Relación con 2B-V-D/E/F/G

```text
2B-V-C2 = Edge Function send-user-message
2B-V-D = list-session-messages
2B-V-E = contrato Flutter desconectado messages
2B-V-F = datasource Flutter HTTP local messages
2B-V-G = integración HTTP local messages
```

C2 no implementa listado, Flutter, IA, streaming, UI/providers, remoto ni
producción.

### Criterios para aprobar implementación C2

- Aprobación explícita del cliente.
- Archivos permitidos definidos antes de implementar.
- No tocar SQL ni migraciones salvo aprobación separada.
- No modificar Flutter ni CI.
- Tests HTTP/Deno/locales con fixtures `test_only_2b_v_c2`.
- Evidencia de que la función llama a la RPC y no hace inserts/updates directos.
- Evidencia de que sesión ajena e inexistente no se distinguen públicamente.

## Resultado de implementación 2B-V-C2 — Edge Function send-user-message

Fecha: 2026-06-20.

2B-V-C2 quedó implementado exclusivamente como Edge Function local
`send-user-message`. No modifica SQL, migraciones, Flutter, CI, UI/providers,
remoto ni producción.

### Archivos creados o actualizados

- `supabase/functions/send-user-message/`;
- `supabase/tests/2b_v_c2_send_user_message_setup.psql`;
- `supabase/tests/2b_v_c2_send_user_message_cleanup.psql`;
- `supabase/tests/2b_v_c2_send_user_message_http_test.sh`;
- `supabase/tests/README.md`;
- este ADR, ADR-007 y `SESSION_TRACKER.md`.

### Decisiones implementadas

- Endpoint local `POST /functions/v1/send-user-message`.
- JWT obligatorio y validado contra Auth local.
- Owner derivado exclusivamente del JWT.
- Body exacto `{ "sessionId": "...", "content": "..." }`.
- Rechazo de campos internos o extra, incluidos `role`, `userId`,
  `specialistId`, timestamps, contadores, attachments y metadata.
- Contenido trimmeado, no vacío y máximo 4000 caracteres tras trim.
- Llamada exclusiva a `public.send_user_message_core`.
- Sin inserts directos en `public.messages`.
- Sin updates directos en `public.chat_sessions`.
- Sin dos escrituras REST separadas.
- Sesión inexistente y sesión ajena devuelven el mismo `sessionNotFound` 404
  opaco.
- Sesión propia archivada devuelve `sessionArchived` 409.
- Respuesta pública sanitizada con `message` y `session`.
- Logs sin JWT completo, `service_role`, owner completo, content completo,
  `specialist_id`, `prompt_template` ni metadata interna.

### Evidencia local

- `supabase start`.
- `supabase db reset --local --no-seed` aplicó `00001`-`00007`.
- `supabase test db --local`: 394/394.
- `deno fmt --check supabase/functions/send-user-message`: correcto.
- `deno check` de `index.ts` e `index_test.ts`: correcto.
- `deno test supabase/functions/send-user-message`: 7/7.
- Harness HTTP `2b_v_c2_send_user_message_http_test.sh`: PASS.
- Harness confirmó cleanup exacto `0|0|0|0|0|0`.
- El gate estático del harness confirmó que el runtime contiene
  `/rest/v1/rpc/send_user_message_core` y no contiene rutas directas
  `/rest/v1/messages` ni `/rest/v1/chat_sessions`.
- `git diff --check`: correcto.

### Alcance bloqueado

2B-V-C2 no habilita `list-session-messages`, Flutter, UI/providers, IA,
streaming, Stasis Engine, MCP, remoto, producción ni datos reales. 2B-V-D/E/F/G
requieren aprobación separada.

## Cierre formal 2B-V-C2 y plan exacto 2B-V-D — list-session-messages

Fecha: 2026-06-20.

2B-V-C2 queda cerrado formalmente. Se acepta como estado aprobado que
`send-user-message` valida JWT contra Auth local, deriva owner desde `sub`,
acepta únicamente `sessionId` y `content`, rechaza campos internos/extra, llama
exclusivamente a `public.send_user_message_core`, no inserta directamente en
`public.messages`, no actualiza directamente `public.chat_sessions`, no hace
dos escrituras REST separadas, no filtra sesiones ajenas, devuelve respuesta
pública sanitizada, mantiene logs seguros y dejó cleanup final
`0|0|0|0|0|0`. Evidencia aceptada: SQL 394/394, Deno C2 7/7, harness HTTP C2
PASS, `git diff --check` limpio, sin remoto ni producción.

2B-V-C queda cerrado localmente:

```text
2B-V-C1 — RPC transaccional send_user_message_core
2B-V-C2 — Edge Function local send-user-message
```

### Riesgos residuales aceptados tras C2

- C2 no lista mensajes.
- C2 no conecta Flutter.
- C2 no implementa streaming.
- C2 no invoca IA.
- `service_role` sigue limitado a runtime local/controlado.
- Remoto y producción siguen bloqueados.

### Objetivo de 2B-V-D

Diseñar una Edge Function local `list-session-messages` que permita listar
mensajes de una sesión propia activa o archivada, sin leer sesiones ajenas, sin
exponer datos internos y sin modificar ningún dato.

D no implementa Flutter, UI/providers, IA, Stasis Engine, streaming, remoto,
producción ni datos reales.

### Contrato HTTP futuro

```http
GET /functions/v1/list-session-messages
Authorization: Bearer <JWT_LOCAL_VALIDADO>
Accept: application/json
```

Query params permitidos: `sessionId`, `limit`, `cursor`.

Query params prohibidos: `userId`, `user_id`, `owner`, `ownerId`,
`specialistId`, `specialist_id`, `internalSpecialistId`, `role`, `roles`,
`created_at`, `message_count`, `last_message_at`, `prompt_template` y
`metadata`.

Cualquier parámetro desconocido debe rechazarse con `invalidRequest`.

### Validación JWT

- JWT obligatorio y validado contra Auth local.
- Owner derivado exclusivamente desde `sub`.
- No aceptar owner, `userId` ni `user_id` desde query.
- JWT ausente o inválido devuelve error 401.
- Identidad local inválida falla cerrado.
- No loguear JWT completo.

### Validación de query

- `sessionId` requerido y UUID válido.
- `limit` opcional, default `50`, mínimo `1`, máximo `100`.
- `cursor` opcional y opaco.
- Cursor inválido devuelve `invalidCursor`.
- Orden estable: `created_at ASC`, `id ASC`.
- Cursor conceptual basado en `createdAt` y `messageId`.

### Validación de sesión y ownership

La función solo puede listar mensajes si la sesión existe y
`session.user_id = owner` derivado del JWT.

Sesión inexistente y sesión ajena deben mapearse al mismo `sessionNotFound`
404 opaco. No se debe filtrar si una sesión existe pero pertenece a otra
persona.

Sesión archivada propia:

- debe permitir lectura de mensajes históricos;
- no permite escritura, ya cubierto por C2;
- archivar una sesión no borra mensajes;
- leer una sesión archivada no modifica la sesión.

### Lectura de mensajes

La función debe leer únicamente mensajes de la sesión validada.

No debe escribir nada ni modificar `messages`, `chat_sessions`,
`message_count`, `last_message_at`, `specialists` o `specialist_catalog`.

No debe invocar IA y no debe implementar streaming.

### Respuesta pública

```json
{
  "items": [
    {
      "messageId": "...",
      "sessionId": "...",
      "role": "user",
      "content": "...",
      "createdAt": "..."
    }
  ],
  "nextCursor": null
}
```

Roles visibles permitidos: `user`, `assistant`, `system`, `tool`.

No devolver `user_id`, `specialist_id`, `prompt_template`, `service_role`, JWT,
attachments ni metadata interna.

### Mapeo de errores

| Error público | HTTP |
| --- | --- |
| `unauthenticated` | 401 |
| `invalidSession` | 401 |
| `invalidRequest` | 400 |
| `invalidCursor` | 400 |
| `sessionNotFound` | 404 |
| `permissionDenied` | 403 |
| `contractViolation` | 502 |
| `backendMisconfigured` | 503 |
| `unexpectedError` | 500 |

### Seguridad y logs

Logs permitidos: `operation`, `result`, `latency`, `request_id`,
`contract_version`, `error_code` y `count`.

No loguear JWT completo, `service_role`, `user_id` completo, content completo,
`specialist_id`, `sessionId` completo, `prompt_template`, metadata interna,
filas completas ni secretos.

### Tests futuros propuestos

- Sin JWT e inválido.
- Owner derivado desde JWT local.
- Query vacío y campos prohibidos rechazados.
- Sesión propia activa lista mensajes.
- Sesión propia archivada lista mensajes históricos.
- Sesión ajena e inexistente devuelven el mismo `sessionNotFound`.
- Orden por `created_at ASC, id ASC`.
- Limit default, máximo e inválido.
- Cursor válido pagina; cursor inválido falla.
- Sin duplicados entre páginas.
- `nextCursor` solo si hay más resultados.
- Respuesta con `items` y `nextCursor`, sin campos internos.
- No modifica `messages`, `chat_sessions`, `message_count`,
  `last_message_at`, `specialist_catalog` ni `specialists`.
- No IA, no streaming.
- Cleanup deja `0|0|0|0|0|0`.
- Anti-remoto: sin `link`, `db push`, deploy, project ref remoto ni tokens
  remotos; Supabase local detenido al final.

### Fixtures futuras

Marcador: `test_only_2b_v_d`.

Fixtures locales: owner user, other user, especialista, catálogo, owner active
session, owner archived session, other user session, varios mensajes owner,
mensajes con roles internos válidos si procede, mensaje ajeno y mensaje
histórico en sesión archivada.

Postcondición esperada:

```text
0|0|0|0|0|0
```

Sobre `auth.users`, `public.users`, `public.specialists`,
`public.specialist_catalog`, `public.chat_sessions` y `public.messages`.

### Relación con 2B-V-E/F/G

```text
2B-V-D = list-session-messages
2B-V-E = contrato Flutter desconectado messages
2B-V-F = datasource Flutter HTTP local messages
2B-V-G = integración HTTP local messages
```

D no implementa Flutter, UI/providers, IA, streaming, remoto ni producción.

### Criterios para aprobar implementación D

- Aprobación explícita del cliente.
- No modificar SQL ni migraciones salvo fallo real aprobado.
- No modificar Flutter ni CI.
- Evidencia de lectura de sesión archivada propia.
- Evidencia de `sessionNotFound` opaco para ajena e inexistente.
- Evidencia de que `message_count` y `last_message_at` no cambian.
- Cleanup final `0|0|0|0|0|0`.

## Resultado de implementación 2B-V-D — Edge Function local list-session-messages

Fecha: 2026-06-21.

2B-V-D queda implementado y verificado exclusivamente en entorno local/efímero.
La función `list-session-messages` permite listar mensajes de una sesión propia
activa o archivada mediante JWT local validado, owner derivado del usuario
autenticado y query estricta. No conecta Flutter, no activa remoto, no invoca
IA, no implementa streaming y no habilita producción.

### Archivos creados

```text
supabase/functions/list-session-messages/
supabase/tests/2b_v_d_list_session_messages_setup.psql
supabase/tests/2b_v_d_list_session_messages_cleanup.psql
supabase/tests/2b_v_d_list_session_messages_http_test.sh
```

### Controles verificados

- JWT ausente o inválido devuelve 401 antes de consultar datos.
- Query vacía, límites inválidos y campos internos/prohibidos devuelven 400.
- Sesión propia activa lista mensajes.
- Sesión propia archivada lista mensajes históricos.
- Sesión ajena e inexistente devuelven el mismo `sessionNotFound` 404 opaco.
- Orden estable por `created_at ASC, id ASC`.
- Cursor opaco pagina sin duplicar mensajes.
- Respuesta pública contiene solo `items` y `nextCursor`.
- Cada item contiene solo `messageId`, `sessionId`, `role`, `content` y
  `createdAt`.
- No se exponen `user_id`, `specialist_id`, `prompt_template`, `service_role`,
  JWT, attachments ni metadata interna.
- La función no modifica `public.messages`, `public.chat_sessions`,
  `message_count`, `last_message_at`, `public.specialist_catalog` ni
  `public.specialists`.
- `message_count` y `last_message_at` permanecen idénticos en sesión activa y
  archivada antes/después de listar.
- Logs sanitizados sin JWT, `service_role`, owner completo, sesión completa,
  especialista interno ni contenido.
- Cleanup final deja `0|0|0|0|0|0`.

### Evidencia local

- `supabase start`: entorno local `127.0.0.1`.
- `supabase db reset --local --no-seed`: migraciones `00001`-`00007`
  aplicadas.
- `supabase test db --local`: 394/394 tests SQL superados.
- `deno fmt --check supabase/functions/list-session-messages`: correcto.
- `deno check supabase/functions/list-session-messages/index.ts
  supabase/functions/list-session-messages/index_test.ts`: correcto.
- `deno test supabase/functions/list-session-messages`: 6/6 tests superados.
- `supabase/tests/2b_v_d_list_session_messages_http_test.sh`: PASS.
- Postcondición externa: `0|0|0|0|0|0`.

### Fuera de alcance preservado

2B-V-D no implementa contrato Flutter, datasource Flutter, UI/providers, MCP,
Stasis Engine, IA, remoto, producción, datos reales, nuevas migraciones,
nuevas policies ni conexión a Supabase remoto.

### Siguiente paquete

2B-V-E queda como siguiente paso recomendado: contrato Flutter desconectado de
mensajes, sin red real y sin exponer `userId`, `specialistId` ni IDs internos.

## Cierre formal 2B-V-D y plan exacto 2B-V-E — contrato Flutter messages desconectado

Fecha: 2026-06-21.

2B-V-D queda cerrado formalmente. Se acepta como estado aprobado que
`list-session-messages` fue implementada localmente, valida JWT contra Auth
local, deriva owner desde el JWT, no acepta `userId` desde cliente, permite
leer sesiones propias activas y archivadas, devuelve sesión ajena e
inexistente como `sessionNotFound` 404 opaco, pagina por `created_at ASC,
id ASC`, devuelve una respuesta sanitizada, no modifica `messages`,
`chat_sessions`, `message_count`, `last_message_at`, catálogo ni especialistas
y dejó cleanup final `0|0|0|0|0|0`. Evidencia aceptada: SQL 394/394, Deno
6/6, harness HTTP PASS, `git diff --check` correcto, remoto y producción no
tocados.

2B-V queda cerrado localmente hasta D:

```text
2B-V-A — messages deny-all + constraints
2B-V-B — fixtures messages transaccionales
2B-V-C1 — RPC transaccional send_user_message_core
2B-V-C2 — Edge Function send-user-message
2B-V-D — Edge Function list-session-messages
```

### Riesgos residuales aceptados

- Flutter todavía no tiene contrato de mensajes.
- Flutter todavía no tiene datasource HTTP real.
- UI/providers siguen bloqueados.
- No hay streaming.
- No hay IA.
- No hay remoto ni producción.
- `service_role` sigue limitado a runtime local/controlado.

### Objetivo de 2B-V-E

Diseñar el contrato Flutter desconectado para mensajes, sin red real, sin UI,
sin providers y sin Supabase client. E solo prepara modelos, resultados,
contratos y validadores futuros para que el siguiente paquete pueda conectar
HTTP local de forma controlada.

2B-V-E no implementa datasource HTTP, no llama `send-user-message`, no llama
`list-session-messages`, no toca Supabase, no modifica Edge Functions y no
activa remoto.

### Modelos Flutter futuros

Modelos propuestos:

```text
OwnChatMessage
OwnChatMessagesPage
SentOwnChatMessage
```

`OwnChatMessage` solo puede contener:

```text
messageId
sessionId
role
content
createdAt
isDemo
```

Roles permitidos:

```text
user
assistant
system
tool
```

Campos prohibidos en modelos públicos:

```text
userId
user_id
specialistId
specialist_id
promptTemplate
prompt_template
attachments
metadata interna
serviceRole
service_role
JWT
```

### Contrato de repositorio futuro

Repositorio propuesto:

```text
OwnChatMessagesRepository
```

Operaciones:

```text
sendUserMessage(sessionId, content)
listSessionMessages(sessionId, limit, cursor)
```

Reglas obligatorias:

- Flutter envía solo `sessionId` y `content` para enviar.
- Flutter nunca envía `role`.
- Flutter nunca envía `userId`.
- Flutter nunca envía `specialistId`.
- Flutter nunca envía `createdAt`.
- Flutter nunca envía `messageCount`.
- Flutter nunca envía `lastMessageAt`.
- Flutter nunca decide ownership.
- Flutter nunca decide permisos.
- Flutter nunca decide si una sesión ajena existe.
- Flutter nunca actualiza contadores localmente como fuente de verdad.

### Resultados tipados futuros

Envío:

```text
success
demo
backendBlocked
unauthenticated
invalidSession
invalidRequest
contentInvalid
contentTooLong
sessionNotFound
sessionArchived
permissionDenied
writeUnconfirmed
contractViolation
networkError
unexpectedError
```

Listado:

```text
success
empty
demo
backendBlocked
unauthenticated
invalidSession
invalidRequest
invalidCursor
sessionNotFound
permissionDenied
contractViolation
networkError
unexpectedError
```

`sessionArchived` aplica al envío; leer una sesión archivada propia no debe
modelarse como error por defecto.

### Validación Flutter futura

Flutter puede validar:

```text
sessionId no vacío
content trim no vacío
content <= 4000
limit entre 1 y 100
cursor opaco no manipulado
```

La autoridad final sigue siendo backend. Flutter no valida ownership, premium,
roles internos ni existencia real como autoridad.

### Demo repository

El repositorio demo debe:

- crear mensajes `isDemo=true`;
- listar mensajes demo;
- no tocar red;
- no llamar Supabase;
- no simular permisos reales;
- no hacer fallback desde errores reales;
- separar claramente modo demo de backend real.

En demo puede existir respuesta local controlada, siempre marcada como demo.

### Backend blocked repository

El repositorio bloqueado debe:

- devolver `backendBlocked`;
- no tocar red;
- no llamar Supabase;
- no devolver demo;
- no hacer fallback silencioso;
- servir para entornos donde backend real sigue bloqueado.

### Validador de payload futuro

Para `sendUserMessage`, aceptar solo:

```text
message.messageId
message.sessionId
message.role
message.content
message.createdAt
session.sessionId
session.messageCount
session.lastMessageAt
```

Para `listSessionMessages`, aceptar solo:

```text
items[]
items[].messageId
items[].sessionId
items[].role
items[].content
items[].createdAt
nextCursor
```

Debe rechazar respuestas con:

```text
user_id
userId
specialist_id
specialistId
prompt_template
promptTemplate
service_role
JWT
attachments
metadata
campos extra
```

### Tests futuros propuestos

- Modelos con campos públicos exactos.
- Roles permitidos aceptados y roles inválidos rechazados.
- Ausencia de `userId`, `specialistId`, attachments, metadata y autoridad
  interna en contratos públicos.
- Demo send/list con `isDemo=true`, sin red, sin Supabase y sin fallback
  silencioso.
- Backend blocked send/list devuelve `backendBlocked`, sin red y sin demo.
- Payload correcto aceptado.
- Payload con `user_id`, `specialist_id`, attachments, metadata, role inválido,
  campos extra o respuesta parcial rechazado.
- Errores de envío y listado mapeados.
- `sessionArchived` solo para envío.
- Lectura de sesión archivada propia no modelada como error.
- Tests de arquitectura: sin imports Supabase, sin imports HTTP reales, sin
  URLs de Edge Functions hardcodeadas, sin providers reales, sin UI, sin IA y
  sin streaming.

### Relación con 2B-V-F/G

```text
2B-V-E = contrato Flutter desconectado messages
2B-V-F = datasource Flutter HTTP local messages
2B-V-G = integración HTTP local messages
```

E no implementa red. F conectará datasource HTTP local. G probará la
integración Flutter datasource con Edge Functions locales.

### Criterios para aprobar implementación E

- Aprobación explícita del cliente.
- No importar Supabase ni HTTP real.
- No crear datasource real.
- No conectar providers ni UI.
- No incluir `userId` ni `specialistId` en contratos públicos.
- No permitir que Flutter envíe `role`.
- No implementar fallback silencioso desde errores reales a demo.
- Añadir tests estáticos mantenibles que bloqueen Supabase/HTTP real y campos
  internos.

## Resultado de implementación 2B-V-E — contrato Flutter messages desconectado

Fecha: 2026-06-21.

2B-V-E queda implementado y verificado como contrato Flutter desconectado. Se
creó la feature `lib/features/chat_messages/`, separada del chat heredado,
UI/providers, Supabase, Edge Functions y datasources HTTP.

### Archivos creados

```text
lib/features/chat_messages/domain/entities/own_chat_message.dart
lib/features/chat_messages/domain/entities/own_chat_message_results.dart
lib/features/chat_messages/domain/repositories/own_chat_messages_repository.dart
lib/features/chat_messages/domain/validation/own_chat_message_input_validator.dart
lib/features/chat_messages/data/contracts/own_chat_messages_payload_validator.dart
lib/features/chat_messages/data/repositories/demo_own_chat_messages_repository.dart
lib/features/chat_messages/data/repositories/backend_blocked_own_chat_messages_repository.dart
test/features/chat_messages/
test/architecture/own_chat_messages_contract_test.dart
```

### Contrato implementado

- `OwnChatMessage`.
- `OwnChatMessagesPage`.
- `SentOwnChatMessage`.
- `OwnChatMessageRole` con valores `user`, `assistant`, `system`, `tool`.
- `OwnChatMessagesRepository`.
- `DemoOwnChatMessagesRepository`.
- `BackendBlockedOwnChatMessagesRepository`.
- `OwnChatMessagesPayloadValidator`.
- `OwnChatMessageInputValidator`.

### Reglas de frontera verificadas

- Flutter envía solo `sessionId` y `content` en `sendUserMessage`.
- Flutter nunca envía `role`.
- Flutter nunca envía `userId`.
- Flutter nunca envía `specialistId`.
- Flutter nunca envía `createdAt`, `messageCount` ni `lastMessageAt`.
- El contrato público no contiene `user_id`, `userId`, `specialist_id`,
  `specialistId`, `owner`, `attachments`, `metadata`, `serviceRole`, JWT ni
  tokens.
- No hay imports de Supabase.
- No hay imports HTTP/Dio.
- No hay URLs de Edge Functions hardcodeadas.
- No hay providers reales ni UI.
- No hay IA, Stasis Engine, MCP ni streaming.

### Validadores implementados

El validador de payload futuro acepta únicamente:

```text
send:
message.messageId
message.sessionId
message.role
message.content
message.createdAt
session.sessionId
session.messageCount
session.lastMessageAt

list:
items[]
items[].messageId
items[].sessionId
items[].role
items[].content
items[].createdAt
nextCursor
```

Rechaza campos internos o extra, incluidos `user_id`, `userId`,
`specialist_id`, `specialistId`, `attachments`, `metadata`, `prompt_template`,
`promptTemplate`, `service_role`, `serviceRole`, JWT y tokens.

### Evidencia

- Tests nuevos 2B-V-E: 18/18 superados.
- `dart run build_runner build --delete-conflicting-outputs`: escribió 0
  salidas.
- `flutter analyze --no-fatal-infos`: correcto; 48 infos preexistentes fuera
  de la nueva feature.
- `flutter test`: 101 tests superados, 1 skipped por harness local existente.
- Gates arquitectónicos confirman ausencia de Supabase/HTTP real y de campos
  internos en contratos públicos.

### Fuera de alcance preservado

2B-V-E no implementa datasource HTTP, integración local, providers, UI,
Supabase, Edge Functions, remoto, producción, IA, Stasis Engine, MCP,
streaming ni datos reales.

### Siguiente paquete

2B-V-F queda como siguiente paquete posible: datasource Flutter HTTP local de
mensajes, con aprobación explícita separada. Hasta entonces permanece
bloqueado.

## Cierre formal 2B-V-E y plan exacto 2B-V-F — datasource Flutter HTTP local messages

Fecha: 2026-06-21.

2B-V-E queda cerrado formalmente. Se acepta como estado aprobado que el
contrato Flutter desconectado de mensajes fue creado en `lib/features/chat_messages/`,
sin red real, sin Supabase imports, sin HTTP real, sin URLs hardcodeadas, sin
UI/providers, con demo repository separado, backend blocked repository separado,
validadores estrictos, tests nuevos 18/18, suite Flutter 101 passed y 1
skipped, y sin tocar Supabase, migraciones, Edge Functions, CI, remoto,
producción, IA, Stasis Engine, MCP ni streaming.

2B-V queda cerrado localmente hasta E:

```text
2B-V-A — messages deny-all + constraints
2B-V-B — fixtures messages transaccionales
2B-V-C1 — RPC transaccional send_user_message_core
2B-V-C2 — Edge Function send-user-message
2B-V-D — Edge Function list-session-messages
2B-V-E — contrato Flutter messages desconectado
```

### Riesgos residuales aceptados

- Todavía no hay datasource Flutter HTTP local de mensajes.
- Todavía no hay integración Flutter con Edge Functions locales.
- Todavía no hay providers/UI reales.
- Todavía no hay conexión remota.
- Todavía no hay producción.
- El chat heredado sigue sin sustituirse.
- IA, Stasis Engine, MCP y streaming siguen bloqueados.

### Objetivo de 2B-V-F

Diseñar el datasource Flutter HTTP local de mensajes, sin conectarlo todavía a
providers/UI. F conectará el contrato Flutter de 2B-V-E con las Edge Functions
locales `send-user-message` y `list-session-messages`, pero solo mediante un
datasource local inyectable y bloqueado contra remoto.

2B-V-F no implementa providers reales, UI, sustitución del chat heredado,
remoto, producción, Supabase client, datos reales, IA, Stasis Engine, MCP,
streaming, Edge Functions, migraciones ni CI.

### Datasource HTTP local futuro

Datasource propuesto:

```text
LocalHttpOwnChatMessagesDataSource
```

Operaciones:

```text
sendUserMessage(sessionId, content)
listSessionMessages(sessionId, limit, cursor)
```

Debe quedar claramente separado del repositorio abstracto y del transporte. Su
responsabilidad será componer validación local, host policy, token provider,
transporte inyectable, mapeo de errores y validación estricta de respuestas.

### Host policy local

Política estricta:

```text
solo http
solo localhost o 127.0.0.1
puerto explícito obligatorio
Supabase cloud bloqueado
https bloqueado
dominios remotos bloqueados
host vacío bloqueado
composition disabled -> backendBlocked
```

El bloqueo debe ocurrir antes de leer token y antes de ejecutar transporte.

### Token provider

Proveedor propuesto:

```text
LocalSessionTokenProvider
```

Reglas:

- no hardcodear JWT;
- no persistir JWT;
- no loguear JWT;
- si falta JWT, devolver `unauthenticated`;
- si el token está vacío, devolver `unauthenticated`;
- no ejecutar transporte si no hay token válido.

### Transporte HTTP inyectable

Transporte propuesto:

```text
OwnChatMessagesHttpTransport
```

Puede tener implementación futura con Dio, pero debe ser testeable mediante
transporte falso. Reglas:

- no Supabase client;
- no Edge Function URLs hardcodeadas;
- base URL inyectada;
- redirects deshabilitados;
- errores de transporte -> `networkError`;
- respuestas no 2xx mapeadas a resultados tipados;
- respuestas 2xx validadas como no confiables.

### Requests permitidos

Para `sendUserMessage`, enviar solo:

```json
{
  "sessionId": "...",
  "content": "..."
}
```

Nunca enviar:

```text
role
userId
specialistId
createdAt
messageCount
lastMessageAt
attachments
metadata
```

Para `listSessionMessages`, enviar solo query params:

```text
sessionId
limit
cursor
```

Nunca enviar:

```text
userId
specialistId
role
owner
prompt_template
metadata
attachments
```

### Validación de respuestas

Debe reutilizar `OwnChatMessagesPayloadValidator`.

Reglas:

- toda respuesta local se trata como no confiable;
- rechazar campos internos;
- rechazar campos extra;
- rechazar payload parcial;
- rechazar role inválido;
- rechazar fechas inválidas;
- rechazar cursor inválido;
- rechazar attachments, metadata, `user_id` y `specialist_id`;
- error de contrato -> `contractViolation`.

### Mapeo de errores HTTP

Envío:

```text
401 unauthenticated
400 invalidRequest/contentInvalid/contentTooLong
404 sessionNotFound
409 sessionArchived/writeUnconfirmed
403 permissionDenied
502 contractViolation
503 backendMisconfigured
500 unexpectedError
```

Listado:

```text
401 unauthenticated
400 invalidRequest/invalidCursor
404 sessionNotFound
403 permissionDenied
502 contractViolation
503 backendMisconfigured
500 unexpectedError
```

Errores de transporte:

```text
networkError
```

### Sin fallback demo

Regla crítica:

```text
error real HTTP/red/contrato nunca se convierte en demo
```

Demo repository y backend blocked repository siguen separados.

### Tests futuros propuestos

Host policy:

- bloquea remoto;
- bloquea Supabase cloud;
- bloquea https;
- bloquea host no local;
- bloquea puerto implícito;
- bloquea composition disabled;
- bloqueo ocurre antes de token y transporte.

Token:

- sin token -> `unauthenticated`;
- token vacío -> `unauthenticated`;
- no transporte sin token;
- token no aparece en logs.

Requests:

- send envía solo `sessionId` y `content`;
- send no envía `role`;
- send no envía `userId`/`specialistId`;
- list envía solo `sessionId`, `limit` y `cursor`;
- list no envía campos internos.

Response validation:

- send success válido aceptado;
- list success válido aceptado;
- payload con `user_id`, `specialist_id`, attachments, metadata, campos extra,
  payload parcial o role inválido rechazado.

Error mapping:

- errores de envío mapeados correctamente;
- errores de listado mapeados correctamente;
- `sessionArchived` solo aplica a envío;
- `invalidCursor` solo aplica a listado;
- transport error -> `networkError`;
- contract violation -> `contractViolation`.

No fallback:

- error HTTP no produce demo;
- error network no produce demo;
- contract violation no produce demo;
- backend blocked no produce demo.

Arquitectura:

- datasource no importa Supabase;
- datasource no importa UI;
- datasource no importa providers reales;
- datasource no importa IA, Stasis Engine o MCP;
- no streaming;
- URLs no hardcodeadas;
- Edge Function paths centralizados si se usan.

### Relación con 2B-V-G

```text
2B-V-F = datasource Flutter HTTP local messages
2B-V-G = integración HTTP local Flutter datasource ↔ Edge Functions locales
```

F no ejecuta integración real end-to-end contra Supabase local salvo tests
unitarios con transporte falso. G será la prueba real contra Edge Functions
locales.

### Criterios para aprobar implementación F

- Aprobación explícita del cliente.
- No conectar providers ni UI.
- No sustituir chat heredado.
- No usar Supabase client.
- No conectar remoto ni producción.
- Host policy debe bloquear antes de token/transporte.
- Token ausente no ejecuta transporte.
- Requests no envían `role`, `userId`, `specialistId`, attachments ni metadata.
- Errores reales no se convierten en demo.

## Resultado de implementación 2B-V-F — datasource Flutter HTTP local messages

Fecha: 2026-06-21.

2B-V-F fue implementado como datasource Flutter HTTP local de mensajes, sin
integración real end-to-end. El paquete conecta el contrato
`OwnChatMessagesRepository` con una frontera HTTP local inyectable y testeada
mediante transporte falso.

### Componentes implementados

- `LocalHttpOwnChatMessagesDataSource`, con operaciones `sendUserMessage` y
  `listSessionMessages`.
- `LocalOnlyHostPolicy`, que permite únicamente HTTP local con puerto explícito
  y bloquea composición deshabilitada, remoto, Supabase cloud, HTTPS, host
  vacío, puerto implícito, path inesperado, query, fragment y user info.
- `LocalSessionTokenProvider`, contrato inyectable para obtener token local sin
  hardcodear, persistir ni loguear JWT.
- `OwnChatMessagesHttpTransport`, transporte inyectable sin implementación real
  Dio/http en este paquete.
- Nuevos estados `backendMisconfigured` para fallos backend cerrados en envío y
  listado.

### Requests verificados

`sendUserMessage` compone únicamente:

```text
POST /functions/v1/send-user-message
body: sessionId, content
headers: Accept, Content-Type, Authorization: Bearer <token>
```

`listSessionMessages` compone únicamente:

```text
GET /functions/v1/list-session-messages
query: sessionId, limit, cursor opcional
headers: Accept, Authorization: Bearer <token>
```

No se envía `role`, `userId`, `specialistId`, `attachments`, `metadata`,
`messageCount`, `lastMessageAt` ni campos internos.

### Validación y errores verificados

- Toda respuesta 2xx se valida con `OwnChatMessagesPayloadValidator`.
- Payload parcial, campos internos, campos extra, role inválido, fecha inválida
  o cursor inválido producen `contractViolation`.
- Host bloqueado produce `backendBlocked` antes de leer token o transporte.
- Token ausente o vacío produce `unauthenticated` sin transporte.
- Redirects producen `backendBlocked`.
- Errores de transporte producen `networkError`.
- Errores HTTP se mapean a resultados tipados para envío y listado.
- Ningún error HTTP, red o contrato se convierte en demo.

### Verificación ejecutada

- `dart format lib/features/chat_messages test/features/chat_messages test/architecture`.
- `flutter test test/features/chat_messages test/architecture/own_chat_messages_contract_test.dart`: 34/34 tests passed.
- `dart run build_runner build --delete-conflicting-outputs`: 0 outputs written.
- `flutter analyze --no-fatal-infos`: passed con 48 infos preexistentes fuera de
  `chat_messages`.
- `flutter test`: 117 passed, 1 skipped.
- `git diff --check`: sin errores.

### Fuera de alcance preservado

2B-V-F no modificó Supabase, migraciones, Edge Functions, CI, providers, UI,
chat heredado, auth real, backend remoto, producción, datos reales, IA, Stasis
Engine, MCP ni streaming.

### Siguiente gate

2B-V-G queda como siguiente paquete posible: integración HTTP local real entre
el datasource Flutter de mensajes y las Edge Functions locales. Requiere
aprobación explícita separada.

## Cierre formal 2B-V-F y plan exacto 2B-V-G — integración HTTP local messages

Fecha: 2026-06-21.

2B-V-F queda cerrado formalmente. Se acepta como estado aprobado que existe
`LocalHttpOwnChatMessagesDataSource`, `LocalOnlyHostPolicy`,
`LocalSessionTokenProvider` y `OwnChatMessagesHttpTransport`; no se usó
Supabase client, Dio/http real directo, UI, providers reales, remoto,
Supabase, Edge Functions ni migraciones. Los requests quedaron limitados a
`sessionId` y `content` para envío, y `sessionId`, `limit` y `cursor` para
listado. No se envían `role`, `userId`, `specialistId`, timestamps,
contadores, attachments ni metadata. El bloqueo remoto ocurre antes de leer
token y transporte; token ausente o vacío devuelve `unauthenticated`; toda
respuesta 2xx se valida con `OwnChatMessagesPayloadValidator`; errores
HTTP/red/contrato no hacen fallback demo.

Estado local cerrado de 2B-V:

```text
2B-V-A — messages deny-all + constraints
2B-V-B — fixtures messages transaccionales
2B-V-C1 — RPC transaccional send_user_message_core
2B-V-C2 — Edge Function send-user-message
2B-V-D — Edge Function list-session-messages
2B-V-E — contrato Flutter messages desconectado
2B-V-F — datasource Flutter HTTP local messages
```

### Objetivo de 2B-V-G

Diseñar y, si se aprueba después, ejecutar una integración local real entre:

```text
LocalHttpOwnChatMessagesDataSource
send-user-message
list-session-messages
send_user_message_core
Supabase local
```

G no conectará providers reales ni UI, no sustituirá el chat heredado, no
activará remoto/producción y no usará datos reales.

### Harness de integración local futuro

El harness de G deberá:

1. arrancar Supabase local;
2. ejecutar `supabase db reset --local --no-seed`;
3. verificar que no existe project ref remoto vinculado;
4. crear fixtures locales marcados como `test_only_2b_v_g`;
5. crear usuarios Auth locales owner/other;
6. obtener JWT local efímero para owner y other, fuera del repositorio;
7. servir `send-user-message` y `list-session-messages` con env temporal no
   versionado;
8. ejecutar test Flutter de integración contra `http://localhost:<puerto>` o
   `http://127.0.0.1:<puerto>`;
9. limpiar fixtures y temporales;
10. verificar postcondición `0|0|0|0|0|0`;
11. detener Supabase local.

### Fixtures locales `test_only_2b_v_g`

Fixtures mínimos:

- owner user;
- other user;
- internal specialist;
- specialist catalog entry;
- owner active session;
- owner archived session;
- other user session;
- mensajes previos en owner active session para paginación;
- mensajes previos en owner archived session para lectura histórica.

Postcondición obligatoria tras cleanup:

```text
auth.users
public.users
public.specialists
public.specialist_catalog
public.chat_sessions
public.messages
= 0|0|0|0|0|0
```

Los fixtures deben ser efímeros, marcados con `test_only_2b_v_g`, limpiables por
script y no convertirse en seed persistente.

### Flujo E2E mínimo

El test Flutter de integración local deberá:

1. construir `LocalHttpOwnChatMessagesDataSource` con base URL local;
2. inyectar JWT local efímero;
3. llamar `sendUserMessage(ownerActiveSession, "mensaje de prueba")`;
4. verificar success;
5. verificar `role=user`;
6. verificar content trimmeado;
7. verificar `messageCount +1`;
8. verificar `lastMessageAt` actualizado;
9. llamar `listSessionMessages(ownerActiveSession)`;
10. verificar que el mensaje aparece;
11. verificar campos públicos;
12. verificar ausencia de `userId`, `specialistId`, attachments y metadata;
13. llamar `listSessionMessages(ownerArchivedSession)`;
14. verificar lectura histórica permitida;
15. intentar `sendUserMessage(ownerArchivedSession)`;
16. verificar `sessionArchived`;
17. intentar `listSessionMessages(otherUserSession)`;
18. verificar `sessionNotFound` opaco;
19. intentar `sendUserMessage(otherUserSession)`;
20. verificar `sessionNotFound` opaco.

### Paginación local

La prueba de paginación deberá:

- crear varios mensajes en sesión propia;
- listar con límite pequeño;
- verificar `nextCursor`;
- pedir página siguiente;
- verificar ausencia de duplicados;
- verificar orden estable `created_at ASC, id ASC`;
- verificar página final con `nextCursor = null`.

### Preflight anti-remoto

Antes de ejecutar integración, G deberá bloquear:

- base URL distinta de `http://localhost:<puerto>` o
  `http://127.0.0.1:<puerto>`;
- Supabase cloud;
- HTTPS;
- dominios remotos;
- puerto implícito;
- `supabase link`;
- `supabase db push`;
- deploy;
- project ref remoto;
- tokens remotos.

### Secretos y logs

Reglas futuras:

- JWT local efímero fuera del repo;
- `service_role` local solo en runtime Edge Functions;
- env file temporal fuera del repo;
- permisos restrictivos en temporales;
- cleanup de temporales;
- logs sin JWT;
- logs sin `service_role`;
- logs sin content completo;
- logs sin owner completo;
- logs sin IDs internos.

### Validaciones esperadas

G deberá demostrar que el datasource real integrado:

- no envía `role`;
- no envía `userId`;
- no envía `specialistId`;
- no envía metadata;
- no envía attachments;
- no hace fallback demo;
- mapea errores correctamente;
- valida respuestas con allowlist;
- rechaza respuestas con campos internos si se simulan o detectan.

### Comandos futuros esperados

```bash
supabase start
supabase db reset --local --no-seed
supabase test db --local
supabase functions serve send-user-message,list-session-messages --env-file <archivo-local-no-versionado>
flutter test <test de integración local 2B-V-G> --dart-define=...
flutter test
flutter analyze --no-fatal-infos
git diff --check
supabase stop
```

La implementación podrá ajustar la forma concreta de servir funciones si el
tooling local de Supabase lo requiere, pero sin remoto, link, push ni deploy.

### Tests futuros propuestos

Integración send:

- send en sesión propia activa;
- content trimmeado;
- `role=user`;
- `messageCount +1`;
- `lastMessageAt` actualizado;
- respuesta pública validada.

Integración list:

- listado de sesión propia activa;
- listado de sesión propia archivada;
- sesión ajena opaca;
- sesión inexistente opaca;
- paginación estable;
- sin duplicados.

Errores:

- JWT ausente;
- JWT inválido;
- content inválido;
- sesión archivada al enviar;
- sesión ajena;
- sesión inexistente;
- cursor inválido.

Seguridad:

- sin campos internos;
- sin logs sensibles;
- sin fallback demo;
- sin remoto;
- cleanup total.

### Relación con siguientes pasos

```text
2B-V-G = integración HTTP local messages
2B-V-H o siguiente = decisión sobre providers/UI o cierre del bloque messages
```

Tras G, se decidirá por separado si conectar providers, crear UI mínima de
mensajes, integrar con `chat_sessions` existente o cerrar 2B-V y pasar a otra
área. Nada de eso queda aprobado por este plan.

## Resultado de implementación 2B-V-G — integración HTTP local messages

Fecha: 2026-06-21.

2B-V-G fue implementado y verificado exclusivamente en entorno local/efímero.
El paquete valida el circuito real:

```text
LocalHttpOwnChatMessagesDataSource
send-user-message
list-session-messages
send_user_message_core
Supabase local
```

### Archivos creados o modificados

- `supabase/tests/2b_v_g_messages_http_integration_setup.psql`.
- `supabase/tests/2b_v_g_messages_http_integration_cleanup.psql`.
- `supabase/tests/2b_v_g_messages_http_integration_test.sh`.
- `test/integration/two_b_v_g_local_http_chat_messages_integration_test.dart`.
- `supabase/tests/README.md`.
- ADR-006, ADR-007 y `docs/SESSION_TRACKER.md`.

No se modificaron `lib/features/chat_messages/`, `supabase/functions/`,
`supabase/migrations/`, CI, providers, UI ni configuración remota.

### Harness local

El harness:

- verifica precondición `0|0|0|0|0|0`;
- bloquea configuración remota con `supabase.co`, project ref o token remoto;
- crea env file temporal fuera del repo con permisos `600`;
- crea usuarios Auth locales owner/other;
- obtiene JWT local efímero;
- sirve Edge Functions locales con `--no-verify-jwt`, manteniendo validación
  interna contra Auth local;
- ejecuta test Flutter de integración contra `http://127.0.0.1:54321`;
- verifica integridad en base de datos tras el test;
- comprueba logs sin secretos ni IDs internos completos;
- limpia fixtures y verifica postcondición final `0|0|0|0|0|0`;
- borra temporales;
- no ejecuta `supabase link`, `supabase db push` ni deploy.

### Fixtures locales

Fixtures marcados como `test_only_2b_v_g`:

- owner user;
- other user;
- internal specialist;
- specialist catalog entry;
- owner active session;
- owner archived session;
- other user session;
- mensajes previos de sesión propia activa;
- mensajes previos de sesión propia archivada;
- mensaje ajeno para comprobar opacidad.

El primer intento detectó un bug de fixture: timestamps estáticos futuros
violaban `chat_sessions_chronology_valid` cuando la RPC actualizaba
`last_message_at = now()`. Se corrigió el harness para usar timestamps
relativos a `now()`, sin tocar migraciones, RPC ni Edge Functions.

### Flujo validado

- `sendUserMessage(ownerActiveSession, "  mensaje de prueba  ")` devuelve
  success.
- `role=user`.
- Content trimmeado.
- `message_count` incrementa exactamente `+1`.
- `last_message_at` queda igual al último mensaje insertado.
- `listSessionMessages(ownerActiveSession)` devuelve el mensaje nuevo.
- Respuesta pública validada mediante `OwnChatMessagesPayloadValidator`.
- No hay `userId`, `specialistId`, attachments ni metadata en contrato público.
- `listSessionMessages(ownerArchivedSession)` permite lectura histórica.
- `sendUserMessage(ownerArchivedSession)` devuelve `sessionArchived`.
- Sesión ajena e inexistente devuelven `sessionNotFound` opaco.
- Cursor inválido devuelve `invalidCursor`.
- Paginación con límite pequeño no duplica mensajes y respeta orden
  `created_at ASC, id ASC`.

### Integridad y seguridad

- `list-session-messages` no modifica `messages`, `chat_sessions`,
  `message_count` ni `last_message_at`.
- `send-user-message` usa la RPC transaccional y no hace writes directos.
- `specialists` y `specialist_catalog` no cambian durante el flujo.
- El datasource no envía `role`, `userId`, `specialistId`, attachments ni
  metadata.
- Logs sin JWT completo, `service_role`, content completo, owner completo, IDs
  internos completos, `prompt_template` ni metadata interna.
- JWT local efímero y env temporal no se versionan.
- Cleanup final verificado: `0|0|0|0|0|0`.

### Verificación ejecutada

- `supabase start -x studio,realtime,storage-api,imgproxy,mailpit,postgres-meta,logflare,vector,supavisor`.
- `supabase db reset --local --no-seed`.
- `supabase test db --local`: 394/394.
- `supabase/tests/2b_v_g_messages_http_integration_test.sh`: PASS.
- Test Flutter de integración G dentro del harness: 3/3.
- `flutter test`: 117 passed, 2 skipped.
- `flutter analyze --no-fatal-infos`: PASS con 48 infos preexistentes.
- `git diff --check`: PASS.
- `supabase stop --no-backup`.

El arranque estándar de Supabase local chocó con el puerto auxiliar `54327`.
Para no modificar `supabase/config.toml`, se arrancó el entorno mínimo con
servicios auxiliares excluidos; DB, Auth, PostgREST/Kong y Edge Runtime quedaron
disponibles para la prueba.

### Fuera de alcance preservado

2B-V-G no conecta providers, no crea UI, no sustituye el chat heredado, no
habilita remoto, producción, Supabase real, datos reales, IA, Stasis Engine,
MCP ni streaming.

### Siguiente decisión

Decidir por separado si el siguiente paquete conecta providers, crea UI mínima,
integra mensajes con el flujo actual de `chat_sessions`, o cierra 2B-V y pasa a
otra área. Nada de eso queda aprobado por 2B-V-G.

## Cierre formal 2B-V-G y preparación 2B-V-H — cierre del bloque messages

Fecha: 2026-06-21.

2B-V-G queda cerrado formalmente. Se acepta que la integración local real
Flutter datasource ↔ Edge Functions ↔ RPC ↔ Supabase local fue validada con
JWT local efímero, `service_role` fuera del repositorio, anti-remoto, cleanup
final `0|0|0|0|0|0`, send/list verificados, sesión archivada legible, sesión
archivada no escribible, sesión ajena/inexistente opaca, paginación estable,
logs seguros, sin providers/UI y sin IA, Stasis Engine, MCP, streaming, remoto,
producción ni datos reales.

### Estado completo de 2B-V

| Subpaquete | Estado | Aporta |
| --- | --- | --- |
| 2B-V-A | Cerrado | `messages` deny-all, constraints mínimos y hardening base. |
| 2B-V-B | Cerrado | Fixtures transaccionales de mensajes sin seed persistente. |
| 2B-V-C1 | Cerrado | RPC transaccional `send_user_message_core`. |
| 2B-V-C2 | Cerrado | Edge Function local `send-user-message`. |
| 2B-V-D | Cerrado | Edge Function local `list-session-messages`. |
| 2B-V-E | Cerrado | Contrato Flutter desconectado de mensajes. |
| 2B-V-F | Cerrado | Datasource Flutter HTTP local de mensajes. |
| 2B-V-G | Cerrado | Integración local real end-to-end. |

### Capacidades locales disponibles

Localmente existe y ha sido verificado:

- tabla `messages` endurecida;
- fixtures de `messages`;
- RPC atómica de envío;
- Edge Function de envío;
- Edge Function de listado;
- contrato Flutter desconectado;
- datasource Flutter HTTP local;
- integración local real end-to-end.

### Bloqueos restantes

Siguen bloqueados:

- providers reales;
- UI real;
- chat heredado;
- conexión remota;
- producción;
- datos reales;
- IA;
- Stasis Engine;
- MCP;
- streaming;
- notificaciones;
- adjuntos/attachments;
- mensajes reales `assistant`, `system` o `tool`.

### Matriz de siguientes rutas

| Ruta | Ventajas | Riesgos | Observación |
| --- | --- | --- | --- |
| A — Providers/capa de aplicación sin UI | Acerca el datasource al flujo real; permite definir estado, lifecycle y errores antes de widgets. | Puede mezclar arquitectura si se acopla al chat heredado o a providers existentes sin diseño. | Recomendación preferida, con alcance desconectado y sin UI. |
| B — UI mínima | Permite validar experiencia y hacer visible send/list. | Sin capa de aplicación puede quedar artificial o contaminar widgets con decisiones temporales. | No recomendable antes de definir capa de aplicación. |
| C — Integración con chat heredado | Acerca funcionalidad a la app existente. | Mayor riesgo de acoplar código nuevo a deuda heredada y romper la separación limpia. | Debe esperar a un diseño de adaptación explícito. |
| D — Cerrar 2B-V y pasar a otro bloque | Deja messages como bloque técnico seguro y permite avanzar en otro frente pendiente. | Messages queda temporalmente invisible en producto. | Válida si se prioriza otra área antes de wiring. |

### Recomendación

Recomendación: preparar la Ruta A, pero todavía solo como planificación. El
siguiente paquete debería definir una capa de aplicación/providers de mensajes
sin UI, sin conectar el chat heredado, sin remoto y sin producción.

La razón es conservar la separación limpia ya construida: antes de widgets o
chat heredado conviene definir cómo se orquesta el repositorio, cómo se
representan estados de carga/error, qué lifecycle se acepta y cómo se evita que
la UI conozca detalles de Edge Functions, JWT o contratos internos.

### Siguiente paquete propuesto

```text
2B-V-I — capa de aplicación/providers messages sin UI
```

Estado: propuesto documentalmente, pendiente de aprobación. No autoriza
implementación.

## Cierre formal 2B-V-H y plan exacto 2B-V-I — capa de aplicación messages sin UI

Fecha: 2026-06-21.

2B-V-H queda cerrado formalmente. El bloque `messages` queda cerrado
localmente desde 2B-V-A hasta 2B-V-G, con capacidades técnicas verificadas y
con providers, UI, chat heredado, remoto, producción, datos reales, IA, Stasis
Engine, MCP y streaming todavía bloqueados.

### Estado actual del bloque messages

| Subpaquete | Estado | Resultado |
| --- | --- | --- |
| 2B-V-A | Cerrado | Tabla `messages` endurecida y deny-all. |
| 2B-V-B | Cerrado | Fixtures transaccionales de mensajes. |
| 2B-V-C1 | Cerrado | RPC transaccional `send_user_message_core`. |
| 2B-V-C2 | Cerrado | Edge Function local `send-user-message`. |
| 2B-V-D | Cerrado | Edge Function local `list-session-messages`. |
| 2B-V-E | Cerrado | Contrato Flutter desconectado. |
| 2B-V-F | Cerrado | Datasource Flutter HTTP local. |
| 2B-V-G | Cerrado | Integración HTTP local end-to-end. |
| 2B-V-H | Cerrado | Decisión documental de siguiente ruta. |

### Objetivo de 2B-V-I

Diseñar e implementar después, si se aprueba, una capa de aplicación para
mensajes que consuma `OwnChatMessagesRepository`, orqueste operaciones de
listado/envío/paginación y exponga estado usable por UI futura, sin conocer
HTTP, Edge Function paths, Supabase, JWT, ownership interno ni permisos.

2B-V-I no debe crear UI, no debe tocar widgets, no debe conectarse al chat
heredado y no debe activar remoto.

### Responsabilidades de la capa

La capa de aplicación deberá:

- cargar mensajes de una sesión;
- enviar mensajes de usuario;
- gestionar `loading`, `loaded`, `empty`, `sending`, `paginating` y errores;
- gestionar `nextCursor`;
- exponer errores tipados;
- mantener mensajes en memoria para una UI futura;
- evitar duplicados;
- preservar orden por `createdAt` y `messageId`;
- conservar listado existente ante errores de envío;
- no inventar `message_count` ni `last_message_at` como autoridad;
- no crear mensajes `assistant`, `system` o `tool`.

### Límites de la capa

La capa no debe:

- llamar Supabase directamente;
- hacer HTTP directamente;
- construir URLs de Edge Functions;
- leer `service_role`;
- leer JWT directamente si no pasa por contratos ya definidos;
- decidir si una sesión ajena existe;
- mandar `role`;
- mandar `userId`;
- mandar `specialistId`;
- mandar timestamps o contadores;
- crear UI;
- usar `BuildContext`;
- depender de widgets;
- mezclarse con el chat heredado;
- invocar IA;
- hacer streaming;
- importar Stasis Engine o MCP.

### Estado de aplicación futuro

Estados propuestos:

```text
initial
loading
loaded
sending
paginating
empty
error
backendBlocked
```

El estado deberá cubrir:

- `sessionId` seleccionado;
- lista de mensajes;
- `nextCursor`;
- envío en progreso;
- error de envío;
- error de listado;
- `sessionArchived`;
- `sessionNotFound`;
- `backendBlocked`;
- marca demo solo si se inyecta explícitamente un repositorio demo.

### Operaciones futuras

Operaciones propuestas:

```text
loadInitial(sessionId)
loadNextPage()
sendMessage(content)
refresh()
clear()
```

Reglas:

- `sendMessage` recibe solo `content`;
- `sessionId` viene del contexto de sesión seleccionado por `loadInitial`;
- no se acepta `role`;
- no se acepta `userId`;
- no se acepta `specialistId`;
- no se aceptan timestamps;
- no se aceptan contadores.

### Relación con `chat_sessions`

La capa de mensajes opera dentro de una sesión ya seleccionada:

- no crea sesiones;
- no archiva sesiones;
- no lista sesiones;
- no modifica `chat_sessions` directamente;
- tras enviar, puede consumir `messageCount` y `lastMessageAt` devueltos por
  backend;
- no debe inventar esos valores localmente como autoridad;
- cualquier sincronización futura con sesiones requerirá un paquete separado.

### Demo y backendBlocked

- Si se inyecta `DemoOwnChatMessagesRepository`, el estado puede marcar
  `isDemo`.
- Si se inyecta `BackendBlockedOwnChatMessagesRepository`, debe exponer
  `backendBlocked`.
- Un error real del datasource HTTP nunca cae a demo.
- Demo y backend real no deben mezclarse silenciosamente.

### Tests futuros propuestos

Estado:

- estado inicial;
- load success;
- load empty;
- load error;
- pagination success;
- pagination sin cursor;
- send success;
- send `sessionArchived`;
- send `sessionNotFound`;
- `backendBlocked`.

Operaciones:

- `loadInitial` llama repository list;
- `loadNextPage` usa cursor;
- `sendMessage` llama repository send con `sessionId` y `content`;
- `sendMessage` no envía `role`, `userId` ni `specialistId`;
- `refresh` recarga;
- `clear` limpia estado.

Orden y duplicados:

- mensajes ordenados;
- paginación sin duplicados;
- mensaje enviado aparece sin romper orden;
- respeta `createdAt`.

Errores:

- errores de envío no destruyen listado existente;
- errores de listado no inventan mensajes;
- `networkError` no produce demo;
- `contractViolation` no produce demo;
- `backendBlocked` no produce demo.

Arquitectura:

- sin Supabase imports;
- sin HTTP directo;
- sin UI widgets;
- sin `BuildContext`;
- sin providers reales en I1;
- sin chat heredado;
- sin IA;
- sin Stasis Engine;
- sin MCP;
- sin streaming.

### División recomendada I1/I2

Recomendación: dividir 2B-V-I antes de implementar.

```text
2B-V-I1 — application controller/state messages sin providers reales
2B-V-I2 — providers Riverpod messages sin UI
```

Motivo: la capa limpia puede contaminarse si se introduce Riverpod, lifecycle
de providers o dependencias del chat heredado demasiado pronto. I1 debe probar
el estado y las operaciones con repositorios falsos/in-memory. I2, solo después
de aprobar I1, conectará esa capa a providers reales sin UI.

### Relación con siguientes pasos

Posibles siguientes paquetes:

```text
2B-V-I1 — application controller/state messages sin providers reales
2B-V-I2 — providers Riverpod messages sin UI
2B-V-J — UI mínima messages
2B-V-K — integración controlada con chat actual
```

Ninguno queda aprobado por este plan.

## Resultado de implementación 2B-V-I1 — application controller/state messages sin providers reales

Fecha: 2026-06-21.

2B-V-I1 fue implementado como capa de aplicación pura para mensajes. No crea
providers reales, no usa Riverpod/Provider, no crea UI, no usa `BuildContext`,
no toca widgets, no se integra con el chat heredado, no hace HTTP directo, no
usa Supabase client, no modifica Supabase, Edge Functions, migraciones ni CI.

### Componentes implementados

- `OwnChatMessagesState`.
- `OwnChatMessagesController`.
- Tests unitarios con fake repository.
- Gate arquitectónico específico para mantener `application/` sin UI,
  providers, HTTP directo, Supabase, Edge Function paths, chat heredado, IA,
  Stasis Engine, MCP ni streaming.

### Estado de aplicación

El estado expone:

- `sessionId`;
- `messages`;
- `nextCursor`;
- `isInitialLoading`;
- `isPaginating`;
- `isSending`;
- `isDemo`;
- `isBackendBlocked`;
- `lastListError`;
- `lastSendError`;
- `confirmedMessageCount`;
- `confirmedLastMessageAt`.

`confirmedMessageCount` y `confirmedLastMessageAt` solo almacenan valores
confirmados devueltos por backend; no se inventan como autoridad local.

### Operaciones implementadas

- `loadInitial(sessionId)`: carga primera página, limpia estado de sesión previa,
  guarda mensajes/cursor o error tipado.
- `loadNextPage()`: usa `nextCursor`, añade página, evita duplicados y conserva
  listado ante error.
- `sendMessage(content)`: usa el `sessionId` actual, envía solo content al
  repositorio, añade mensaje confirmado si no existe y conserva listado ante
  error de envío.
- `refresh()`: recarga primera página de la sesión actual.
- `clear()`: limpia todo el estado.

### Reglas verificadas

- No se acepta `role`, `userId`, `specialistId`, timestamps ni contadores como
  input de `sendMessage`.
- Error de envío no destruye el listado existente.
- Error de listado/paginación no inventa mensajes.
- `networkError`, `contractViolation` y `backendBlocked` no producen demo.
- Demo solo aparece si el repositorio inyectado devuelve resultado demo.
- Orden estable por `createdAt ASC` y `messageId`.
- Dedupe por `messageId`.

### Verificación ejecutada

- `dart format lib/features/chat_messages test/features/chat_messages test/architecture`.
- `flutter test test/features/chat_messages test/architecture/own_chat_messages_contract_test.dart`: 51/51.
- `dart run build_runner build --delete-conflicting-outputs`: 0 outputs written.
- `flutter analyze --no-fatal-infos`: PASS con 48 infos preexistentes.
- `flutter test`: 134 passed, 2 skipped.
- `git diff --check`: PASS.

### Siguiente gate

2B-V-I2 queda bloqueado hasta aprobación explícita. I2 podrá diseñar providers
Riverpod/Provider sin UI, consumiendo la capa I1, sin chat heredado, remoto ni
producción.

## Cierre formal 2B-V-I1 y plan exacto 2B-V-I2 — providers messages sin UI

Fecha: 2026-06-21.

2B-V-I1 queda cerrado formalmente. Se acepta como estado aprobado que
`OwnChatMessagesController` y `OwnChatMessagesState` existen, son Dart puro,
no usan providers reales, Riverpod/Provider, UI, `BuildContext`, widgets, HTTP
directo, Supabase, Edge Function URLs, chat heredado, IA, Stasis Engine, MCP ni
streaming. Gestionan `loadInitial`, `loadNextPage`, `sendMessage`, `refresh` y
`clear`; separan errores de listado y envío; conservan listado ante error de
envío; deduplican por `messageId`; ordenan por `createdAt ASC` y `messageId`;
demo solo aparece si el repositorio devuelve demo; `backendBlocked` queda
explícito; no hay fallback demo desde errores reales.

### Estado actual de 2B-V

```text
2B-V-A — messages deny-all + constraints
2B-V-B — fixtures messages transaccionales
2B-V-C1 — RPC transaccional send_user_message_core
2B-V-C2 — Edge Function send-user-message
2B-V-D — Edge Function list-session-messages
2B-V-E — contrato Flutter messages desconectado
2B-V-F — datasource Flutter HTTP local messages
2B-V-G — integración HTTP local messages
2B-V-H — cierre del bloque messages y decisión
2B-V-I1 — application controller/state messages sin providers reales
```

### Evidencia de Riverpod en el proyecto

El proyecto sí usa Riverpod de forma real y verificable:

- `pubspec.yaml` declara `flutter_riverpod`, `riverpod_annotation` y
  `riverpod_generator`.
- `lib/main.dart` usa `ProviderScope`.
- Existen providers manuales en `core`, `profile` y `specialists`.
- Existen providers generados con `riverpod_annotation` en `auth`, `chat` y
  `orchestrator`.

Por tanto, para I2 se recomienda usar Riverpod real, pero con límites estrictos
y sin UI. No se recomienda un adapter neutro adicional en este momento porque
añadiría una abstracción que el proyecto no necesita todavía. Sí se recomienda
mantener I2 separado de I1 para que Riverpod no contamine la capa application
pura.

### Objetivo de 2B-V-I2

Diseñar providers Riverpod para `messages` que conecten de forma limpia:

```text
OwnChatMessagesRepository
OwnChatMessagesController
OwnChatMessagesState
```

Sin crear UI, sin widgets, sin `BuildContext`, sin chat heredado, sin remoto y
sin producción.

### Providers futuros propuestos

Nombres orientativos:

```text
ownChatMessagesRepositoryProvider
ownChatMessagesControllerProvider
ownChatMessagesStateProvider
```

La implementación podrá ajustar nombres para seguir el estilo local, pero debe
mantener separación entre repository, controller, state, configuración y token
/ base URL local futura si aplica.

### Alcance de providers

Los providers podrán:

- construir o recibir `OwnChatMessagesRepository`;
- construir `OwnChatMessagesController`;
- exponer `OwnChatMessagesState`;
- exponer operaciones del controller;
- permitir override en tests;
- permitir demo repository explícito;
- permitir backendBlocked repository explícito.

No podrán:

- crear UI;
- depender de widgets;
- usar `BuildContext`;
- llamar Supabase directamente;
- hacer HTTP directo fuera del datasource;
- construir URLs remotas hardcodeadas;
- leer `service_role`;
- decidir ownership;
- enviar `role`;
- enviar `userId`;
- enviar `specialistId`;
- tocar chat heredado.

### Lifecycle propuesto

- selección de `sessionId`;
- `loadInitial` al seleccionar sesión;
- `refresh`;
- `loadNextPage`;
- `sendMessage`;
- `clear` al salir de sesión;
- dispose si aplica.

Debe evitar mezclar mensajes entre sesiones, conservar cursor de sesión
anterior, enviar sin sesión actual, duplicar mensajes al paginar o perder
listado existente ante error de envío.

### Testing con overrides

Los tests de I2 deberán poder inyectar:

- fake success repository;
- fake demo repository;
- fake backendBlocked repository;
- fake error repository.

Sin red, Supabase, Edge Functions reales ni datasource HTTP real salvo un
provider explícito posterior aprobado.

### Errores visibles

Los providers deberán exponer, directa o indirectamente:

- `lastListError`;
- `lastSendError`;
- `isLoading`;
- `isSending`;
- `isPaginating`;
- `isBackendBlocked`;
- `isDemo`.

Errores reales no pueden convertirse en demo.

### Límites con UI futura

La UI futura solo podrá consumir estado y operaciones. I2 no crea:

- pages;
- widgets;
- screens;
- buttons;
- chat bubbles;
- text fields;
- navigation.

### Tests futuros propuestos

Providers:

- provider crea controller;
- provider expone estado inicial;
- provider permite override repository;
- provider demo explícito;
- provider backendBlocked explícito.

Operaciones:

- `loadInitial` vía provider;
- `sendMessage` vía provider;
- `loadNextPage` vía provider;
- `refresh` vía provider;
- `clear` vía provider.

Lifecycle:

- cambiar `sessionId` no mezcla mensajes;
- `clear` limpia estado;
- dispose no deja operaciones pendientes si aplica.

Errores:

- error de envío conserva listado;
- error de listado se expone;
- `backendBlocked` se expone;
- demo solo si repository demo inyectado.

Arquitectura:

- providers no importan Supabase, Dio/http, Firebase, UI widgets,
  `BuildContext`, chat heredado, IA, Stasis Engine, MCP ni streaming;
- Riverpod queda permitido solo en la capa de providers de I2.

### Riverpod real vs adapter neutro

Decisión recomendada para implementar I2: **Riverpod real sin UI**.

Justificación: Riverpod ya forma parte del proyecto y sus patrones existen en
`core`, `profile`, `specialists`, `auth`, `chat` y `orchestrator`. Aun así, I2
debe estar aislado del chat heredado, especialmente porque el chat legacy aún
contiene contratos inseguros como envío de `role`. I2 no debe reutilizar ese
controller ni sus providers.

### Relación con siguientes pasos

Tras I2, posibles paquetes:

```text
2B-V-J — UI mínima messages
2B-V-K — integración controlada con chat actual
2B-V-L — cierre de bloque messages y paso a otro módulo
```

No se decide ninguno todavía.

## Resultado de implementación 2B-V-I2 — providers Riverpod messages sin UI

Fecha: 2026-06-21.

2B-V-I2 queda implementado y verificado como capa Riverpod real para
`chat_messages`, sin UI, widgets, `BuildContext`, navegación, chat heredado,
Supabase directo, HTTP directo, Edge Function paths, remoto, producción, IA,
Stasis Engine, MCP ni streaming.

### Ruta elegida

Se eligió:

```text
lib/features/chat_messages/presentation/providers/
```

Motivo: es coherente con los providers existentes de `profile` y
`specialists`, y mantiene `application/` como Dart puro sin Riverpod.

### Providers creados

```text
ownChatMessagesRepositoryProvider
demoOwnChatMessagesRepositoryProvider
backendBlockedOwnChatMessagesRepositoryProvider
ownChatMessagesControllerProvider
ownChatMessagesStateProvider
```

### Composición

- `ownChatMessagesRepositoryProvider` selecciona demo solo en modo demo y
  backendBlocked para backend real/producción.
- `ownChatMessagesControllerProvider` usa `StateNotifierProvider` para exponer
  operaciones y estado observable, delegando en `OwnChatMessagesController`.
- `ownChatMessagesStateProvider` expone `OwnChatMessagesState` para futura UI.

### Operaciones expuestas

- `loadInitial(sessionId)`.
- `loadNextPage()`.
- `sendMessage(content)`.
- `refresh()`.
- `clear()`.

`sendMessage` sigue aceptando solo `content` desde el provider y usa la sesión
seleccionada por el controller. No acepta `role`, `userId`, `specialistId`,
timestamps, contadores ni permisos.

### Reglas verificadas

- Providers overrideables con `ProviderContainer`.
- Demo explícito solo mediante repositorio demo o modo demo.
- Backend real y producción siguen en backendBlocked.
- Error de envío conserva listado existente.
- Error de listado queda visible.
- Error real no produce demo.
- Cambio de sesión no mezcla mensajes ni cursor.
- Sin imports de UI/widgets/`BuildContext`.
- Sin Supabase, HTTP directo, Edge Function paths, chat heredado, IA, Stasis
  Engine, MCP ni streaming.

### Verificación ejecutada

- `dart format lib/features/chat_messages test/features/chat_messages test/architecture`.
- `flutter test test/features/chat_messages test/architecture/own_chat_messages_contract_test.dart`: 67/67.
- `dart run build_runner build --delete-conflicting-outputs`: 0 outputs written.
- `flutter analyze --no-fatal-infos`: PASS con 48 infos preexistentes.
- `flutter test`: 150 passed, 2 skipped.
- `git diff --check`: PASS.

### Siguiente gate

`2B-V-J — UI mínima messages` o cualquier integración con chat heredado queda
bloqueada hasta aprobación explícita. I2 no desbloquea remoto, producción,
datos reales, Supabase real ni IA.

## Cierre formal 2B-V-I2 y plan exacto 2B-V-J — UI mínima messages aislada

Fecha: 2026-06-21.

2B-V-I2 queda cerrado formalmente. Se acepta como estado aprobado que existen
providers Riverpod reales para `chat_messages`, son overrideables en tests,
mantienen demo/backendBlocked explícitos, no crean UI, no usan widgets,
`BuildContext`, Supabase directo, HTTP directo, Edge Functions, chat heredado,
remoto, producción, IA, Stasis Engine, MCP ni streaming.

### Estado actual del bloque messages

```text
2B-V-A — cerrado — messages deny-all + constraints
2B-V-B — cerrado — fixtures messages transaccionales
2B-V-C1 — cerrado — RPC transaccional send_user_message_core
2B-V-C2 — cerrado — Edge Function send-user-message
2B-V-D — cerrado — Edge Function list-session-messages
2B-V-E — cerrado — contrato Flutter messages desconectado
2B-V-F — cerrado — datasource Flutter HTTP local messages
2B-V-G — cerrado — integración HTTP local messages
2B-V-H — cerrado — cierre del bloque messages y decisión
2B-V-I1 — cerrado — application controller/state messages sin providers reales
2B-V-I2 — cerrado — providers Riverpod messages sin UI
```

### Decisión sobre siguiente ruta

Se recomienda preparar documentalmente:

```text
2B-V-J — UI mínima messages aislada
```

No se recomienda aún `2B-V-K — integración controlada con chat actual` porque
el chat heredado puede contaminar la arquitectura limpia. Primero debe
validarse una UI mínima aislada; después se decidirá si el chat actual se
integra, se reemplaza o se adapta.

### Objetivo de 2B-V-J

Diseñar una UI mínima y aislada que consuma:

```text
ownChatMessagesStateProvider
ownChatMessagesControllerProvider
```

o la estructura equivalente ya implementada. La UI no debe crear lógica de
negocio nueva, no debe llamar repositorios directamente y no debe tocar
navegación real ni chat heredado.

### Alcance de UI mínima

La UI mínima debe permitir:

- ver mensajes de una sesión ya seleccionada;
- ver loading inicial;
- ver estado empty;
- ver errores de listado;
- enviar mensaje de usuario;
- ver errores de envío sin borrar mensajes existentes;
- paginar manualmente;
- refrescar si se aprueba en el componente;
- mostrar backendBlocked;
- mostrar `sessionArchived` al intentar enviar.

Queda fuera: UX final, chat definitivo, navegación real, integración con chat
heredado, remoto, producción, IA, Stasis Engine, MCP, streaming, adjuntos y
mensajes reales `assistant`, `system` o `tool` generados por IA.

### Nombre propuesto

Nombre recomendado:

```text
OwnChatMessagesPanel
```

Motivo: comunica componente aislado y evita sugerir navegación real. Alternativa
aceptable futura: `OwnChatMessagesMinimalView`. No se recomienda todavía
`OwnChatMessagesMinimalPage` salvo que se apruebe una demo-route interna.

### Componentes mínimos

- `OwnChatMessagesPanel`.
- `MessagesList`.
- `MessageBubble` mínima.
- `MessageInput` mínima.
- `MessagesEmptyState`.
- `MessagesLoadingState`.
- `MessagesErrorState`.
- `MessagesPaginationLoader` o botón `Cargar más`.

El diseño visual debe ser deliberadamente simple y no representar UX final.

### Reglas de seguridad UI

La UI no debe:

- enviar `role`;
- enviar `userId`;
- enviar `specialistId`;
- enviar timestamps;
- enviar contadores;
- decidir ownership;
- decidir permisos;
- mostrar IDs internos;
- mostrar `service_role`;
- mostrar JWT;
- mostrar metadata interna;
- mostrar attachments;
- importar Supabase;
- importar Dio/http;
- importar paths de Edge Functions;
- importar chat heredado;
- importar IA, Stasis Engine, MCP o streaming.

El envío debe llamar únicamente:

```text
sendMessage(content)
```

### Estados visibles

La UI debe representar:

- `initial`: sin sesión o componente sin carga iniciada;
- `loading`: `isInitialLoading`;
- `loaded`: mensajes visibles;
- `empty`: sesión cargada sin mensajes;
- `paginating`: `isPaginating`, separado de loading inicial;
- `sending`: `isSending`, sin bloquear la lectura del listado;
- `backendBlocked`: estado explícito, sin fallback demo;
- `lastListError`: error de listado visible;
- `lastSendError`: error de envío visible;
- `sessionArchived`: error visible al enviar;
- `sessionNotFound`: error opaco visible sin filtrar existencia;
- `networkError`: error de red visible, nunca demo;
- `contractViolation`: error visible de contrato, nunca demo.

Errores de envío no deben borrar ni ocultar el listado existente.

### Sesión archivada

Reglas propuestas:

- lectura permitida si el backend/estado entrega mensajes;
- input deshabilitado solo si la UI recibe un contexto externo aprobado que
  indique sesión archivada;
- si no existe ese contexto, no inventar estado archivado;
- si `sendMessage` devuelve `sessionArchived`, mostrar mensaje claro y
  preservar el listado;
- no intentar escribir de nuevo automáticamente.

### Paginación

Recomendación: botón manual `Cargar más` para MVP local.

Reglas:

- usar `loadNextPage`;
- no implementar infinite scroll todavía;
- mostrar loading de paginación separado;
- no duplicar mensajes;
- ocultar o deshabilitar el botón si `nextCursor == null`;
- errores de paginación no borran listado existente.

### Demo y backendBlocked

- Si `isDemo == true`, mostrar etiqueta demo clara.
- Si `isBackendBlocked == true`, mostrar backend bloqueado.
- No cambiar a demo ante `networkError`, `contractViolation`,
  `backendMisconfigured` o cualquier error real.

### Tests futuros propuestos

Render:

- loading inicial;
- empty;
- listado con mensajes;
- bubble de mensaje `user`;
- bubble de mensaje `assistant`, `system` y `tool` si vienen del modelo;
- etiqueta demo;
- backendBlocked.

Operaciones:

- enviar llama al controller/provider solo con `content`;
- la UI no acepta `role`;
- la UI no acepta `userId`;
- la UI no acepta `specialistId`;
- botón `Cargar más` llama `loadNextPage`;
- refresh llama `refresh` si se incluye;
- `clear` no se expone salvo decisión separada.

Errores:

- error de listado visible;
- error de envío visible sin borrar mensajes;
- `sessionArchived` visible al enviar;
- `networkError` visible;
- `contractViolation` visible.

Arquitectura:

- UI no importa Supabase;
- UI no importa HTTP/Dio;
- UI no importa Edge Function paths;
- UI no importa chat heredado;
- UI no importa IA/Stasis Engine/MCP/streaming;
- UI no accede a `service_role` ni JWT;
- UI no construye repositorios directamente si debe usar providers;
- UI no conecta navegación real.

### Componente aislado vs demo-route

Opción A — componente/panel aislado sin ruta:

- menor riesgo;
- más testeable;
- no toca navegación;
- no toca chat heredado;
- recomendado para el primer J.

Opción B — página demo interna no conectada a navegación real:

- permite ver una pantalla completa;
- aumenta superficie y riesgo de parecer navegación real;
- debe esperar salvo aprobación explícita.

Recomendación: **Opción A — componente/panel aislado sin ruta real**.

### Relación con 2B-V-K

`2B-V-K` podrá proponerse después como integración controlada con el chat
actual/heredado. Sigue bloqueado hasta cerrar J y revisar si conviene integrar,
reemplazar o adaptar el chat existente.

## Resultado de implementación 2B-V-J — UI mínima messages aislada

Fecha: 2026-06-21.

2B-V-J queda implementado como UI mínima aislada para `chat_messages`.
El resultado aprobado es un componente reutilizable sin ruta real, sin
navegación, sin integración con chat heredado y sin conexión remota.

### Archivos creados o modificados

```text
lib/features/chat_messages/presentation/widgets/own_chat_messages_panel.dart
test/features/chat_messages/presentation/own_chat_messages_panel_test.dart
test/architecture/own_chat_messages_contract_test.dart
```

También se actualizan este ADR, ADR-007 y `docs/SESSION_TRACKER.md`.

### Componentes implementados

- `OwnChatMessagesPanel`.
- Lista de mensajes con orden recibido desde estado.
- Bubble mínima por mensaje.
- Input mínimo para contenido.
- Estado de loading inicial.
- Estado empty.
- Estado de error de listado.
- Estado de error de envío.
- Etiqueta demo.
- Aviso backendBlocked.
- Botón manual de paginación `Cargar más`.

### Consumo de providers

El panel consume únicamente:

```text
ownChatMessagesStateProvider
ownChatMessagesControllerProvider
```

La UI no construye repositorios, no llama datasources, no importa transporte
HTTP, no importa Supabase y no conoce rutas de Edge Functions.

### Regla de envío

El input solo llama:

```text
sendMessage(content)
```

No existe ningún input ni contrato UI para `role`, `userId`, `specialistId`,
timestamps, contadores, ownership, JWT, `service_role`, metadata ni
attachments.

### Estados verificados

Los tests cubren:

- sin sesión seleccionada;
- loading inicial;
- empty;
- listado de mensajes;
- roles visuales `user`, `assistant`, `system` y `tool` cuando ya vienen del
  modelo;
- demo visible;
- backendBlocked visible;
- error de listado visible;
- envío aceptado solo con contenido;
- error de envío preservando mensajes existentes;
- `sessionArchived`;
- `sessionNotFound`;
- `networkError`;
- `contractViolation`;
- paginación manual;
- estado `isPaginating`.

### Guardrails arquitectónicos añadidos

El test arquitectónico verifica que los widgets de `chat_messages` no importan
ni contienen:

- Supabase;
- HTTP/Dio;
- rutas de Edge Functions;
- chat heredado;
- IDs internos `userId`, `user_id`, `specialistId`, `specialist_id`;
- JWT, `service_role`, access/refresh tokens;
- attachments o metadata;
- IA, Stasis Engine, MCP o streaming.

### Evidencia de verificación

- `dart format lib/features/chat_messages test/features/chat_messages test/architecture`: PASS.
- `dart run build_runner build --delete-conflicting-outputs`: 0 outputs written.
- `flutter analyze --no-fatal-infos`: PASS con infos preexistentes no fatales.
- `flutter test test/features/chat_messages test/architecture/own_chat_messages_contract_test.dart`: 78/78.
- `flutter test`: 161 passed, 2 skipped.

### Fuera de alcance preservado

2B-V-J no implementa demo-route, navegación real, chat heredado, integración K,
Supabase remoto, producción, autenticación real, datos reales, IA, Stasis
Engine, MCP, streaming, attachments ni procesamiento de archivos.

### Siguiente gate

`2B-V-K — integración controlada con chat actual` o una demo-route aislada
requieren aprobación separada. La recomendación es revisar primero si conviene
integrar, adaptar o reemplazar el chat heredado sin contaminar la capa limpia.

## Cierre formal 2B-V-J y plan exacto 2B-V-J2 — host/demo aislado del panel messages

Fecha: 2026-06-21.

2B-V-J queda cerrado formalmente. Se acepta como estado aprobado que
`OwnChatMessagesPanel` existe como UI mínima aislada, sin ruta real, sin
navegación real, sin chat heredado, sin Supabase directo, sin HTTP/Dio directo,
sin Edge Function paths, sin construcción de repositorios/datasources y con
envío limitado a:

```text
sendMessage(content)
```

La UI no envía ni expone `role`, `userId`, `specialistId`, timestamps,
contadores, ownership, JWT, `service_role`, metadata ni attachments.

### Evidencia aceptada de 2B-V-J

- Tests específicos `chat_messages` + arquitectura: 78/78.
- Suite Flutter completa: 161 passed, 2 skipped.
- `flutter analyze --no-fatal-infos`: PASS con 48 infos preexistentes.
- `git diff --check`: PASS.
- `build_runner`: 0 outputs written.

### Decisión sobre siguiente paso

No se avanza todavía a:

```text
2B-V-K — integración controlada con chat actual
```

Motivo:

- el chat heredado puede contaminar la arquitectura nueva;
- el panel aún no se ha validado en un host visual controlado;
- conviene probar el componente en un entorno aislado antes de integrarlo,
  adaptarlo o sustituir nada.

### Objetivo de 2B-V-J2

Diseñar un host/demo aislado para visualizar `OwnChatMessagesPanel` dentro de
la app o de un entorno de desarrollo controlado, sin conectarlo a navegación
real, sin tocar chat heredado y sin usar remoto.

El host/demo debe permitir validar visualmente panel renderizado, estados,
input, envío, errores, demo/backendBlocked, paginación, lectura de mensajes y
sesión archivada.

### Opciones evaluadas

Opción A — Widget host de test/dev:

- Ventajas: no toca navegación, no contamina app real, es más seguro.
- Riesgos: prueba manual menos cómoda que una ruta visible.
- Recomendación: **opción preferente para MVP local**.

Opción B — Ruta demo interna no conectada a navegación principal:

- Ventajas: prueba manual más cómoda.
- Riesgos: puede tocar routing, colarse en producto o confundirse con
  navegación real.
- Recomendación: no implementar todavía; requerir aprobación separada si se
  elige más adelante.

### Alcance permitido propuesto para J2

El host/demo podrá montar `OwnChatMessagesPanel`, inyectar providers
fake/demo/backendBlocked, mostrar estados controlados, probar input, probar
paginación y probar errores.

No podrá conectar chat heredado, usar sesión real, usar usuario real, usar
remoto, usar Supabase directo, tocar navegación productiva, tocar rutas
públicas, activar IA, activar streaming ni activar adjuntos.

### Datos fake/demo propuestos

Todos los fixtures deberán ser locales y ficticios:

- mensajes `user`;
- mensajes `assistant`;
- mensajes `system`;
- mensajes `tool`;
- estado empty;
- estado loading;
- estado backendBlocked;
- estado demo;
- error list;
- error send;
- `sessionArchived`;
- `nextCursor` presente;
- `nextCursor` null.

### Tests futuros de J2

- host renderiza panel;
- host demo muestra mensajes;
- host backendBlocked muestra aviso;
- host error muestra error;
- host no usa navegación real;
- host no importa chat heredado;
- host no importa Supabase;
- host no importa HTTP/Dio;
- host no contiene Edge Function paths;
- host no expone JWT ni `service_role`;
- host no usa datos reales.

### Relación con 2B-V-K

2B-V-K sigue bloqueado hasta cerrar J2. Solo debería plantearse después de
decidir si se va a integrar el panel nuevo en chat actual, adaptar el chat
heredado, reemplazar el chat heredado o mantener ambos separados
temporalmente.

No se toma esa decisión en J2.

## Resultado de implementación 2B-V-J2 — host/demo aislado del panel messages

Fecha: 2026-06-21.

2B-V-J2 queda implementado como host dev/test aislado para visualizar
`OwnChatMessagesPanel`, sin ruta real, sin navegación real, sin chat heredado,
sin red, sin Supabase, sin Edge Functions, sin datos reales y sin producción.

### Archivos creados o modificados

```text
lib/features/chat_messages/presentation/dev/own_chat_messages_panel_dev_host.dart
test/features/chat_messages/presentation/own_chat_messages_panel_dev_host_test.dart
test/architecture/own_chat_messages_contract_test.dart
```

También se actualizan este ADR, ADR-007 y `docs/SESSION_TRACKER.md`.

### Host creado

`OwnChatMessagesPanelDevHost` monta `OwnChatMessagesPanel` dentro de un
`ProviderScope` local con `ownChatMessagesControllerProvider` overrideado. No
crea página, ruta, navegación ni dependencia con el chat heredado.

### Escenarios soportados

- mensajes fake con roles visuales `user`, `assistant`, `system` y `tool`;
- empty;
- loading;
- demo;
- backendBlocked;
- error de listado;
- error de envío;
- `sessionArchived`;
- `sessionNotFound`;
- `networkError`;
- `contractViolation`;
- paginación con cursor;
- sin paginación;
- sending;
- paginating.

### Interacciones simuladas

- escribir en input;
- enviar solo `content`;
- añadir mensaje fake tras envío aceptado;
- cargar siguiente página fake;
- mostrar errores controlados.

No existen parámetros UI para `role`, `userId`, `specialistId`, timestamps,
contadores, ownership, JWT, `service_role`, metadata ni attachments.

### Guardrails arquitectónicos

El gate de arquitectura cubre `presentation/dev` e impide:

- Supabase;
- HTTP/Dio;
- rutas de Edge Functions;
- chat heredado;
- routing productivo;
- tokens/JWT;
- IDs internos;
- metadata/attachments;
- IA, Stasis Engine, MCP o streaming;
- datos reales.

### Evidencia de verificación

- `dart format lib/features/chat_messages test/features/chat_messages test/architecture`: PASS.
- `dart run build_runner build --delete-conflicting-outputs`: 0 outputs written.
- `flutter analyze --no-fatal-infos`: PASS con 48 infos preexistentes.
- `flutter test test/features/chat_messages test/architecture/own_chat_messages_contract_test.dart`: 85/85.
- `flutter test`: 168 passed, 2 skipped.

### Fuera de alcance preservado

No se creó ruta real, navegación real, integración con chat heredado,
integración K, remoto, producción, Supabase real, Edge Functions, migraciones,
CI, IA, Stasis Engine, MCP, streaming, adjuntos ni datos reales.

### Siguiente gate

Tras cerrar J2, la siguiente decisión pendiente es elegir entre:

- diseñar `2B-V-K — integración controlada con chat actual`;
- adaptar el chat heredado;
- reemplazar el chat heredado;
- mantener ambos separados temporalmente;
- cerrar el bloque messages.

Nada de eso queda autorizado por J2.

## Cierre formal 2B-V-J2 y auditoría 2B-V-K0 — chat actual y plan de integración

Fecha: 2026-06-21.

2B-V-J2 queda cerrado formalmente. El host `OwnChatMessagesPanelDevHost` queda
aceptado como herramienta dev/test aislada: no crea ruta real, no toca
navegación, no toca routing productivo, no conecta chat heredado, no usa
Supabase, no usa HTTP/Dio, no usa backend real, no usa auth real, no usa remoto,
no usa producción y no usa datos reales.

K0 se prepara como auditoría documental del chat actual. No implementa
integración, no modifica Flutter y no autoriza `2B-V-K`.

### Evidencia de que el chat actual no fue modificado

Comprobación ejecutada:

```text
git diff --name-only -- lib/features/chat lib/core/config/routes.dart lib/app.dart lib/main.dart
```

Resultado: sin salida. Por tanto, en el diff actual no hay cambios en
`lib/features/chat/`, rutas principales ni arranque de app. Esta afirmación se
limita al estado del diff local; no implica que el chat heredado sea seguro ni
que esté alineado con la arquitectura nueva.

### Archivos inspeccionados para K0

Chat heredado:

```text
lib/features/chat/presentation/pages/chat_page.dart
lib/features/chat/presentation/pages/agent_chat_wrapper.dart
lib/features/chat/presentation/viewmodels/chat_providers.dart
lib/features/chat/presentation/viewmodels/chat_controller.dart
lib/features/chat/presentation/widgets/chat_input.dart
lib/features/chat/presentation/widgets/message_bubble.dart
lib/features/chat/data/datasources/chat_remote_datasource.dart
lib/features/chat/data/datasources/supabase_chat_datasource.dart
lib/features/chat/data/repositories/chat_repository_impl.dart
lib/features/chat/data/repositories/demo_chat_repository.dart
lib/features/chat/domain/entities/chat_session_entity.dart
lib/features/chat/domain/entities/message_entity.dart
lib/features/chat/domain/repositories/chat_repository.dart
lib/features/chat/domain/usecases/get_or_create_session_usecase.dart
lib/features/chat/domain/usecases/send_message_usecase.dart
lib/features/chat/domain/usecases/watch_messages_usecase.dart
```

Rutas y dependencias de navegación:

```text
lib/core/config/routes.dart
lib/app.dart
lib/features/orchestrator/presentation/pages/orchestrator_chat_page.dart
lib/features/orchestrator/presentation/pages/orchestrator_page.dart
```

Tests relacionados:

```text
test/features/chat/data/chat_repository_impl_test.dart
test/features/chat/data/demo_chat_repository_test.dart
test/architecture/own_chat_messages_contract_test.dart
test/features/chat_messages/
```

### Estructura actual verificada del chat heredado

- `ChatPage` es una pantalla `ConsumerStatefulWidget` que recibe `agentId`,
  `specialistName` y `specialty`; crea o recupera sesión mediante
  `activeChatSessionProvider(widget.agentId)` y renderiza `_ChatBody`.
- `_ChatBody` consume `chatMessagesStreamProvider(sessionId)` y
  `chatControllerProvider`; muestra `MessageBubble` y envía desde `ChatInput`.
- `AgentChatWrapper` resuelve el agente con `agentByIdProvider(agentId)` y
  construye `ChatPage`.
- `OrchestratorChatPage` usa `agentByIdProvider('stasis_core')` y construye
  `ChatPage`.
- `routes.dart` mantiene rutas reales `/chat/:id` y `/orchestrator/chat`.
- `chat_providers.dart` crea `SupabaseChatDataSource` con
  `Supabase.instance.client` cuando el entorno no es demo; en demo usa
  `DemoChatRepository`.
- `ActiveChatSession` deriva `userId` desde `currentIdentityProvider` y envía
  `specialistId` al caso de uso heredado.
- `ChatController.sendMessage` llama al caso de uso con `role: 'user'`.
- `SupabaseChatDataSource` hace writes directos a `chat_sessions` y `messages`,
  usa `select()`, `insert()`, `.stream()` y una RPC heredada
  `increment_message_count`.
- `MessageEntity` heredado expone `sessionId`, `role` y `attachments`.
- `ChatSessionEntity` heredado expone `userId` y `specialistId`.
- `ChatInput` conserva soporte visual de attachments mock (`analitica.pdf`).
- `MessageBubble` todavía conoce `chief_intervention`.

### Dependencias detectadas

- Supabase directo: `chat_providers.dart` importa `supabase_flutter` y crea
  `SupabaseChatDataSource(Supabase.instance.client)`.
- Supabase directo: `supabase_chat_datasource.dart` importa
  `supabase_flutter` y opera sobre tablas `chat_sessions` y `messages`.
- Auth/identidad: `ActiveChatSession` depende de `currentIdentityProvider`.
- Orchestrator: `AgentChatWrapper` y `OrchestratorChatPage` dependen de
  `agentByIdProvider`.
- Navegación real: `routes.dart` expone `/chat/:id` y `/orchestrator/chat`.
- Contratos internos heredados: `MessageEntity` y `ChatSessionEntity` exponen
  campos que la arquitectura nueva evita exponer en contratos públicos.
- Demo/backend real: la selección depende de `environment.isDemo`, pero el
  camino no-demo entra en Supabase client directo.

### Riesgos clasificados

| Riesgo | Severidad | Evidencia | Recomendación |
| --- | --- | --- | --- |
| Supabase directo en frontera heredada | Bloqueante | `chat_providers.dart`, `supabase_chat_datasource.dart` | No integrar panel nuevo sobre este provider sin capa adaptadora aprobada. |
| Writes directos desde Flutter a tablas | Bloqueante | `SupabaseChatDataSource.sendMessage` inserta en `messages` y llama RPC heredada | Sustituir por frontera backend controlada o mantener bloqueado. |
| Contratos heredados exponen IDs internos | Alto | `ChatSessionEntity.userId`, `specialistId`, `MessageEntity.sessionId` | No reutilizar entidades heredadas como contrato público nuevo. |
| UI puede enviar attachments mock | Alto | `ChatInput` devuelve `attachments` | Mantener fuera de K; adjuntos requieren diseño separado. |
| `role` viaja por contrato heredado | Alto | `ChatRepository.sendMessage(role)`, `ChatController(role: 'user')` | No permitir que UI/proveedor nuevo construya `role`; debe ser server-managed. |
| Rutas reales existentes | Alto | `/chat/:id`, `/orchestrator/chat` | No tocar navegación en K0; cualquier integración debe tener rollback claro. |
| Riesgo de duplicar flujos | Medio | `lib/features/chat/` y `lib/features/chat_messages/` coexisten | Elegir explícitamente integración, adaptación, reemplazo o separación temporal. |
| Estado mezclado UI/controlador | Medio | `ChatPage` usa stream, controller global y scroll listener | Integrar solo tras pruebas de widget/provider. |
| `chief_intervention` heredado | Medio | `MessageBubble`, `MessageEntity` | No arrastrarlo al contrato nuevo salvo ADR específico. |
| Tests heredados insuficientes para UI/rutas | Medio | Tests actuales cubren repositorios demo/error, no flujo UI completo | Añadir widget/provider/arquitectura antes de integración. |

### Matriz de opciones K0

| Opción | Ventajas | Riesgos | Cambios requeridos | Tests requeridos | Evaluación |
| --- | --- | --- | --- | --- | --- |
| A — Integrar `OwnChatMessagesPanel` dentro del chat actual | Reutiliza rutas existentes y reduce UI duplicada | Alto riesgo de contaminar el panel con providers heredados, IDs internos y Supabase directo | Tocar `ChatPage`, `AgentChatWrapper`, quizá rutas/providers | Widget, routing, provider overrides, arquitectura anti-Supabase | No recomendada como primer K. |
| B — Adaptar chat actual para consumir providers nuevos | Conserva pantalla/rutas y migra por dentro | Riesgo medio-alto; exige diseñar adapter entre `agentId` heredado, sesiones nuevas y mensajes nuevos | Adapter, provider bridge, tests de compatibilidad | Providers, widget, rutas, contrato anti-campos internos | Posible, pero requiere plan K1 detallado. |
| C — Reemplazo gradual del chat heredado | Permite apagar deuda con menos contaminación | Riesgo de ruptura visible si se cambia demasiado | Nueva página/adapter detrás de gate, rollback a ruta antigua | Widget, navegación controlada, regresión de rutas | Recomendable a medio plazo, no en K0. |
| D — Mantener ambos separados temporalmente | Riesgo bajo, preserva arquitectura limpia | Duplica experiencia y retrasa integración | Documentación y bloqueo explícito | Arquitectura y smoke tests | Recomendación inmediata tras K0 si no se aprueba K1. |
| E — Cerrar bloque messages sin integrar | Evita tocar zona riesgosa | No mejora UX del chat actual | Ninguno técnico | Ninguno adicional | Válido si se prioriza otra área. |

### Recomendación K0

Recomendación: no integrar todavía. Preparar un paquete documental siguiente:

```text
2B-V-K1 — plan exacto de adaptación segura del chat actual
```

K1 debería decidir si se implementa un adapter mínimo o si se mantiene la
separación. El alcance propuesto de K1 debe basarse en archivos reales, no en
suposiciones:

- `lib/features/chat/presentation/pages/chat_page.dart`;
- `lib/features/chat/presentation/pages/agent_chat_wrapper.dart`;
- `lib/features/chat/presentation/viewmodels/chat_providers.dart`;
- `lib/features/chat/presentation/viewmodels/chat_controller.dart`;
- `lib/features/chat/presentation/widgets/chat_input.dart`;
- `lib/features/chat/presentation/widgets/message_bubble.dart`;
- `lib/core/config/routes.dart`;
- `lib/features/orchestrator/presentation/pages/orchestrator_chat_page.dart`;
- `lib/features/chat_messages/presentation/widgets/own_chat_messages_panel.dart`;
- `lib/features/chat_messages/presentation/providers/own_chat_messages_providers.dart`.

K1 no debería modificar código todavía; debería definir un plan exacto con
rollback. Si se aprobara implementación posterior, el primer paquete debería
ser pequeño y reversible, preferiblemente un adapter/bridge de prueba que no
toque Supabase directo ni sustituya rutas productivas de golpe.

### Criterios mínimos antes de permitir integración real

- No Supabase directo desde UI.
- No HTTP directo desde UI.
- No `Supabase.instance` en providers de integración nueva.
- No `service_role`, JWT ni tokens en UI.
- No exponer `userId`, `specialistId`, `role`, `attachments` o metadata interna
  en contratos públicos nuevos.
- No mezclar demo/backend real de forma silenciosa.
- No convertir errores reales en demo.
- No romper `/chat/:id` ni `/orchestrator/chat` sin alternativa y rollback.
- No reutilizar `MessageEntity`/`ChatSessionEntity` heredados como contrato
  público del flujo nuevo sin sanitización.
- Añadir tests de widget, provider, rutas y arquitectura.
- Mantener rollback claro al chat heredado actual si una integración falla.

### Fuera de alcance de K0

No se modificó código de chat, navegación, rutas, providers productivos,
Supabase, Edge Functions, migraciones, CI, IA, Stasis Engine, MCP, streaming,
adjuntos ni datos reales.

## Cierre formal 2B-V-K0 y plan exacto 2B-V-K1 — adaptación segura del chat actual

Fecha: 2026-06-26.

2B-V-K0 queda cerrado formalmente. La auditoría se basó en archivos reales y no
modificó `lib/features/chat/`, rutas, navegación, providers productivos,
Supabase, Edge Functions, migraciones, CI, remoto, producción ni datos reales.

2B-V-K1 se prepara como plan exacto documental. No implementa código. La regla
principal de K1 es que ninguna estrategia aceptable puede conservar
`SupabaseChatDataSource` como camino futuro ni mantener el envío de `role` desde
Flutter. Ambos quedan clasificados como deuda heredada a bloquear y sustituir.

### Hallazgos heredados confirmados

```text
chat_providers.dart usa Supabase.instance.client.
supabase_chat_datasource.dart escribe directo en chat_sessions y messages.
ChatController envía role: 'user'.
Entidades heredadas exponen userId, specialistId, sessionId, role y attachments.
Rutas reales detectadas: /chat/:id y /orchestrator/chat.
```

### Mapa de arquitectura heredada

| Pieza | Responsabilidad actual | Dependencias peligrosas | Decisión futura | Riesgo |
| --- | --- | --- | --- | --- |
| `ChatPage` | Pantalla real de chat por agente; crea sesión y renderiza mensajes/input | Consume providers heredados y `sessionId` interno | Adaptar solo si se separa shell visual de lógica peligrosa | Alto |
| `AgentChatWrapper` | Resuelve agente por `agentId` y construye `ChatPage` | Depende de `agentByIdProvider` y pasa ID interno como entrada de chat | Adaptar con `LegacyChatRouteParamsAdapter` o dejar intacto | Medio |
| `chat_providers.dart` | Wiring Riverpod heredado de datasource/repos/usecases/sesión/stream | `Supabase.instance.client`, `SupabaseChatDataSource`, `userId`, `specialistId` | Bloquear para flujo nuevo; no conservar como camino futuro | Bloqueante |
| `chat_controller.dart` | Acción de envío heredada | Envía `role: 'user'` desde Flutter | Reemplazar; no usar en flujo nuevo | Bloqueante |
| `ChatInput` | Input visual con attachments mock | Emite attachments y no representa contrato seguro nuevo | Reutilizar solo si se adapta para emitir `content` únicamente | Alto |
| `MessageBubble` | Render de mensajes heredados | Conoce `chief_intervention` y entidad heredada | Reemplazar o adaptar a `OwnChatMessage` | Medio |
| `SupabaseChatDataSource` | Acceso directo a Supabase para sesiones/mensajes | Writes directos a tablas, stream directo, RPC heredada | Bloquear y retirar del flujo futuro | Bloqueante |
| `ChatRepositoryImpl` | Envuelve datasource heredado | Acepta `role` y entidades internas | Bloquear para flujo nuevo | Alto |
| `DemoChatRepository` | Demo heredado local | Sesiones por especialista, `role`, IDs internos demo | No usar para flujo nuevo; mantener solo legado hasta retirada | Medio |
| `/chat/:id` | Ruta real de chat por agente | Acopla navegación a wrapper heredado | Mantener intacta hasta K2 aprobado | Alto |
| `/orchestrator/chat` | Ruta real de Stasis | Construye `ChatPage` directamente | Mantener intacta hasta K2 aprobado | Alto |

### Código heredado bloqueado

K1 no debe proponer como solución futura:

- conservar `SupabaseChatDataSource` para el flujo nuevo;
- usar `Supabase.instance.client` en providers nuevos;
- hacer `insert`, `select`, `stream` o RPC directa desde Flutter contra
  `chat_sessions` o `messages`;
- conservar `ChatController.sendMessage(role: 'user')`;
- permitir que UI, controller o provider Flutter envíen `role`;
- exponer `userId`, `specialistId`, `sessionId`, `attachments` o metadata
  interna como contrato público nuevo.

### Estrategias comparadas

| Estrategia | Qué conserva | Qué bloquea/reemplaza | Riesgos | Tests necesarios | Evaluación |
| --- | --- | --- | --- | --- | --- |
| A — Adapter mínimo | Parte de `ChatPage`/wrapper y rutas existentes | Debe bloquear `chat_providers`, `ChatController`, `SupabaseChatDataSource`, `role` y entidades heredadas | Alto: es fácil arrastrar provider viejo | Provider overrides, widget, arquitectura anti-Supabase/anti-role, rutas | No recomendada si implica conservar datasource o controller heredado. |
| B — Panel nuevo dentro de shell heredado | Puede conservar una carcasa visual mínima y rutas intactas | Reemplaza lógica heredada por `OwnChatMessagesPanel` y providers nuevos | Medio: requiere aislar el shell para que no arrastre Supabase ni contratos viejos | Widget shell, input solo content, backendBlocked/demo explícitos, arquitectura | Recomendación preferida si el shell queda limpio. |
| C — Reemplazo gradual | Mantiene chat heredado separado hasta retirar; crea flujo nuevo controlado | Reemplaza progresivamente pantalla/providers antiguos | Medio: duplica temporalmente UI y rutas | Rutas bajo gate, smoke tests, rollback, arquitectura | Recomendación si B arrastra lógica insegura. |

### Recomendación

Recomendación principal: **Estrategia B — panel nuevo dentro de shell heredado
solo si el shell queda limpio**.

Condiciones estrictas:

- el shell no puede importar `SupabaseChatDataSource`;
- el shell no puede usar `chat_providers.dart` heredado;
- el shell no puede usar `ChatController`;
- el shell no puede enviar `role`;
- el shell no puede exponer `userId`, `specialistId`, `sessionId` interno,
  `attachments` ni metadata;
- la UI debe llamar solo operaciones ya saneadas, especialmente
  `sendMessage(content)`.

Si cualquiera de esas condiciones obliga a conservar datasource, controller o
contrato inseguro, la recomendación cambia automáticamente a:

```text
Estrategia C — reemplazo gradual
```

### Adapters necesarios

Propuestos solo para una implementación futura, no creados en K1:

- `LegacyChatRouteParamsAdapter`: convierte parámetros de ruta heredados en una
  entrada segura de selección sin exponer `userId` ni permitir `role`.
- `ChatSessionSelectionAdapter`: decide qué sesión segura debe abrirse usando
  contratos `chat_sessions` ya saneados, sin Supabase directo.
- `OwnMessagesPanelHostAdapter`: monta `OwnChatMessagesPanel` en un shell
  controlado y pasa solo estado/operaciones permitidas.

Reglas de adapters:

- no llaman Supabase;
- no escriben en base de datos;
- no envían `role`;
- no exponen `userId` ni `specialistId`;
- no conocen `service_role`, JWT ni tokens;
- no mezclan demo/backend real;
- no convierten errores reales en demo.

### Archivos candidatos para futura implementación

Permitidos con cambios mínimos futuros, si K2 lo aprueba:

```text
lib/features/chat/presentation/pages/chat_page.dart
lib/features/chat/presentation/pages/agent_chat_wrapper.dart
lib/features/chat/presentation/widgets/chat_input.dart
lib/features/chat/presentation/widgets/message_bubble.dart
lib/features/chat_messages/presentation/widgets/own_chat_messages_panel.dart
lib/features/chat_messages/presentation/providers/own_chat_messages_providers.dart
test/features/chat/
test/features/chat_messages/
test/architecture/own_chat_messages_contract_test.dart
```

Solo lectura / no tocar todavía:

```text
lib/core/config/routes.dart
lib/app.dart
lib/main.dart
lib/features/orchestrator/presentation/pages/orchestrator_chat_page.dart
lib/features/orchestrator/presentation/pages/orchestrator_page.dart
```

Prohibidos salvo aprobación explícita:

```text
lib/features/chat/data/datasources/supabase_chat_datasource.dart
lib/features/chat/presentation/viewmodels/chat_providers.dart
lib/features/chat/presentation/viewmodels/chat_controller.dart
lib/features/chat/data/repositories/chat_repository_impl.dart
lib/features/chat/data/repositories/demo_chat_repository.dart
supabase/
.github/
pubspec.yaml
analysis_options.yaml
android/
ios/
web/
```

La lista de prohibidos no significa que esos archivos sean correctos; significa
que K2 no debe tocarlos sin aprobación separada porque concentran riesgo.

### Rollback propuesto

Para una implementación futura K2:

- mantener rutas existentes intactas inicialmente;
- introducir un switch local o provider override para volver al flujo heredado;
- no borrar `lib/features/chat/` en la primera integración;
- limitar el diff a shell/adapters/tests aprobados;
- ejecutar tests antes/después;
- si falla widget, provider o arquitectura, revertir solo el paquete K2.

### Tests obligatorios futuros

Widget:

- chat actual renderiza sin romper;
- shell con panel nuevo renderiza si se elige Estrategia B;
- input solo envía `content`;
- errores visibles;
- backendBlocked visible;
- demo explícito visible.

Providers:

- se usan providers nuevos de `chat_messages`;
- no se usan providers heredados peligrosos;
- overrides funcionan;
- demo y backendBlocked son explícitos.

Arquitectura:

- no Supabase directo desde UI;
- no Supabase directo desde providers nuevos;
- no HTTP/Dio directo desde UI;
- no Edge Function paths en UI;
- no `role` enviado desde UI, controller o provider nuevo;
- no `userId` ni `specialistId` enviados desde UI;
- no `service_role` ni JWT en UI;
- no writes directos a `chat_sessions`/`messages`;
- no mezcla demo/backend real.

Rutas:

- `/chat/:id` no se rompe si se toca en una fase posterior;
- `/orchestrator/chat` no se rompe si se toca en una fase posterior;
- navegación productiva solo se toca con aprobación específica.

### Criterios de autorización para K2

K2 solo podrá implementarse cuando exista aprobación explícita de:

- estrategia elegida: B limpia o C gradual;
- archivos exactos autorizados;
- rollback documentado;
- tests definidos;
- riesgos aceptados;
- prohibición de `SupabaseChatDataSource` en el flujo nuevo;
- prohibición de writes directos desde Flutter;
- prohibición de `role`, `userId` y `specialistId` desde UI;
- decisión explícita sobre rutas reales.

### Fuera de alcance de K1

K1 no modifica código, chat heredado, rutas, navegación, providers productivos,
UI productiva, Supabase, Edge Functions, migraciones, CI, remoto, producción,
IA, Stasis Engine, MCP, streaming, adjuntos ni datos reales.

## Resultado de implementación 2B-V-K2 — integración controlada en shell seguro

Fecha: 2026-06-26.

2B-V-K2 queda implementado mediante Estrategia B limitada: panel nuevo dentro
de un shell seguro, sin reutilizar lógica peligrosa del chat heredado. No se
modifican rutas reales ni navegación productiva.

### Archivos creados o modificados

```text
lib/features/chat_messages/presentation/shell/own_chat_messages_safe_shell.dart
lib/features/chat_messages/presentation/shell/own_chat_messages_route_params_adapter.dart
test/features/chat_messages/presentation/own_chat_messages_safe_shell_test.dart
test/architecture/own_chat_messages_contract_test.dart
docs/stasisly_definition/adr/ADR-006-identidad-autorizacion-rls.md
docs/stasisly_definition/adr/ADR-007-catalogo-sanitizado-especialistas-y-frontera-backend.md
docs/SESSION_TRACKER.md
```

### Shell seguro creado

`OwnChatMessagesSafeShell` recibe un `sessionId` ya seguro como entrada,
normaliza espacios, valida vacío y monta `OwnChatMessagesPanel`. No hace
navegación, no decide ownership, no decide permisos, no construye repositorios,
no escribe en base de datos y no conoce usuarios, especialistas, tokens ni
roles.

### Adapter creado

`OwnChatMessagesRouteParamsAdapter` es un adapter puro para extraer únicamente
`sessionId` explícito de un mapa de parámetros. No acepta `id` heredado, no
interpreta `agentId`, no llama Supabase, no hace HTTP, no lee JWT y no expone
`userId` ni `specialistId`.

### Prohibiciones verificadas

El shell seguro y su adapter no usan:

- `SupabaseChatDataSource`;
- `Supabase.instance.client`;
- `supabase_flutter`;
- `ChatController` heredado;
- `chat_providers.dart` heredado;
- HTTP/Dio;
- Edge Function paths;
- `role`;
- `userId`;
- `specialistId`;
- JWT, `service_role` o tokens;
- writes directos a `chat_sessions` o `messages`;
- attachments;
- metadata;
- Stasis Engine, MCP o streaming.

### Rutas y chat heredado intactos

Comando ejecutado:

```text
git diff --name-only -- lib/features/chat lib/core/config/routes.dart lib/app.dart lib/main.dart
```

Resultado: sin salida. No se modificaron `lib/features/chat/`,
`lib/core/config/routes.dart`, `lib/app.dart` ni `lib/main.dart`.

### Verificación

- `dart format lib/features/chat_messages test/features/chat_messages test/architecture`: PASS.
- `dart run build_runner build --delete-conflicting-outputs`: 0 outputs written.
- `flutter analyze --no-fatal-infos`: PASS con 48 infos preexistentes.
- `flutter test test/features/chat_messages test/architecture/own_chat_messages_contract_test.dart`: 91/91.
- `flutter test`: 174 passed, 2 skipped.
- `git diff --check`: PASS.

### Rollback

Rollback simple: retirar los dos archivos de `presentation/shell/`, retirar el
test `own_chat_messages_safe_shell_test.dart`, revertir la ampliación del gate
arquitectónico y revertir estas entradas documentales. No hay migraciones,
rutas, providers productivos ni cambios en chat heredado que deshacer.

### Fuera de alcance preservado

K2 no integra rutas reales, no reemplaza navegación productiva, no conecta
remoto, no activa producción, no usa datos reales, no implementa IA, Stasis
Engine, MCP, streaming ni adjuntos. Tampoco modifica Supabase, Edge Functions,
migraciones o CI.

## Cierre formal 2B-V-K2 y plan exacto 2B-V-K3 — wiring controlado con rutas reales

Fecha: 2026-06-26.

2B-V-K2 queda cerrado formalmente. K3 se prepara como plan documental para
evaluar si el shell seguro puede conectarse a una ruta real o si debe
mantenerse aislado. No se modifica código, rutas, navegación ni chat heredado.

### Rutas inspeccionadas

```text
lib/core/config/routes.dart
lib/app.dart
lib/main.dart
lib/features/chat/presentation/pages/agent_chat_wrapper.dart
lib/features/chat/presentation/pages/chat_page.dart
lib/features/orchestrator/presentation/pages/orchestrator_chat_page.dart
lib/features/health/presentation/pages/health_page.dart
lib/features/nutrition/presentation/pages/nutrition_page.dart
lib/features/physical_training/presentation/pages/physical_training_page.dart
```

### Estado real de rutas

- `/chat/:id` está definido en `routes.dart`.
- El builder extrae `state.pathParameters['id']` y construye
  `AgentChatWrapper(agentId: id)`.
- `AgentChatWrapper` resuelve el agente mediante `agentByIdProvider(agentId)` y
  construye `ChatPage(agentId: agent.id, ...)`.
- `ChatPage` usa `activeChatSessionProvider(widget.agentId)`.
- `activeChatSessionProvider` crea/obtiene sesión usando `userId` de
  `currentIdentityProvider` y `specialistId: specialistId`.
- `chat_providers.dart` conserva `SupabaseChatDataSource(Supabase.instance.client)`
  en modo no demo.
- `ChatController` heredado conserva `role: 'user'`.
- `/orchestrator/chat` monta `OrchestratorChatPage`, que resuelve
  `agentByIdProvider('stasis_core')` y construye `ChatPage`.
- `health_page.dart`, `nutrition_page.dart` y `physical_training_page.dart`
  navegan a `/chat/${agent.id}`.

### Compatibilidad de sessionId

Conclusión: **`/chat/:id` no está demostrado como `sessionId` seguro**.

La evidencia real indica que `:id` es un `agentId`/ID de agente usado para
resolver especialista y crear/obtener sesión en el flujo heredado. Además, el
adapter seguro creado en K2 acepta exclusivamente `sessionId` como nombre de
parámetro y rechaza `id` heredado. Por tanto, conectar `/chat/:id` al shell
seguro implicaría tratar un ID ambiguo como sesión, lo cual queda bloqueado.

Regla K3:

```text
No tratar id heredado como sessionId seguro sin validación documental, técnica
y cambio de contrato de ruta aprobado.
```

### Opciones de wiring comparadas

| Opción | Ventajas | Riesgos | Archivos que tocaría | Rollback | Evaluación |
| --- | --- | --- | --- | --- | --- |
| A — Conectar `/chat/:id` | Reutiliza ruta existente | Bloqueante: `:id` es `agentId`, no `sessionId`; arrastra `AgentChatWrapper`, `ChatPage`, providers heredados, Supabase directo y `role` heredado | `routes.dart`, `AgentChatWrapper`, quizá `ChatPage` | Alto riesgo | No aprobar todavía. |
| B — Conectar `/orchestrator/chat` | Ruta de Stasis visible | Alto: depende de `OrchestratorChatPage`, `agentByIdProvider('stasis_core')` y `ChatPage`; puede confundirse con IA/Stasis Engine no implementados | `routes.dart`, `OrchestratorChatPage` | Medio-alto | No aprobar todavía. |
| C — Ruta interna dev-only | Permite validar shell sin contaminar producto | Riesgo de colarse en release si no se blinda bien | Nueva ruta interna y gating explícito | Bajo si es dev-only | Opción documental más segura si se necesita prueba manual. |
| D — Mantener shell aislado | Cero riesgo de routing | No acerca UX productiva | Ninguno | Trivial | Recomendación inmediata. |
| E — Reemplazo gradual posterior | Permite rediseñar contrato de ruta y sesión | Requiere fases y pruebas de navegación | Futuro plan K4/K5 | Controlable | Recomendable tras diseñar sesión/ruta segura. |

### Recomendación

No conectar `/chat/:id` en K4. El parámetro `:id` actual no es un `sessionId`
seguro; es un ID heredado de agente/especialista. Conectarlo ahora al shell
seguro rompería la separación construida y podría reactivar el flujo peligroso.

Recomendación inmediata:

```text
Mantener shell aislado o, si se necesita validación manual, diseñar una ruta
dev-only no productiva con parámetro explícito sessionId.
```

### Criterios mínimos para K4

Antes de cualquier implementación de routing real debe aprobarse:

- ruta exacta;
- contrato exacto de parámetros;
- si el parámetro es `sessionId`, debe llamarse `sessionId`, no `id`;
- archivos exactos;
- rollback;
- tests de rutas;
- prueba de que no se activa `AgentChatWrapper`, `ChatPage`, `ChatController`
  heredado, `chat_providers.dart` heredado ni `SupabaseChatDataSource`;
- prohibición de `role`, `userId` y `specialistId` desde UI;
- confirmación de que `/chat/:id` y `/orchestrator/chat` no se rompen o quedan
  sustituidas bajo decisión explícita.

### Tests futuros necesarios

Rutas:

- `/chat/:id` sigue resolviendo si se toca;
- `/orchestrator/chat` sigue resolviendo si se toca;
- ruta futura monta `OwnChatMessagesSafeShell`;
- ruta futura pasa `sessionId` explícito y válido;
- ruta futura rechaza `sessionId` vacío;
- ruta futura no interpreta `id` como sesión.

Arquitectura:

- rutas no importan Supabase;
- rutas no importan HTTP/Dio;
- rutas no importan `SupabaseChatDataSource`;
- rutas no importan `ChatController` heredado;
- rutas no activan `chat_providers.dart` peligroso;
- no `role`, `userId`, `specialistId`, JWT ni `service_role` desde UI.

Rollback:

- diff limitado;
- chat heredado no se borra en primera fase;
- rutas productivas pueden volver al estado anterior;
- shell seguro puede permanecer aislado.

### Fuera de alcance de K3

K3 no modifica código, rutas, navegación, chat heredado, providers productivos,
Supabase, Edge Functions, migraciones, CI, remoto, producción, IA, Stasis
Engine, MCP, streaming, adjuntos ni datos reales.

## Cierre formal 2B-V-K3 y plan exacto 2B-V-K4 — ruta dev-only segura con sessionId explícito

Fecha: 2026-06-26.

2B-V-K3 queda cerrado formalmente. El hallazgo bloqueante pasa a decisión
aprobada: `/chat/:id` no puede conectarse todavía a
`OwnChatMessagesSafeShell` porque `:id` está verificado como `agentId` heredado,
no como `sessionId` seguro.

Evidencia:

```text
/chat/:id monta AgentChatWrapper(agentId: id)
```

Por tanto:

- no tratar `id` heredado como `sessionId`;
- no conectar `/chat/:id` al shell seguro;
- no conectar `/orchestrator/chat` al shell seguro todavía;
- mantener el shell seguro aislado hasta aprobar un contrato de ruta explícito.

### Objetivo de K4

K4 prepara documentalmente una ruta o acceso dev-only para montar
`OwnChatMessagesSafeShell` con un parámetro explícito llamado `sessionId`.

No implementa código ni modifica rutas. Su objetivo es dejar listo un contrato
seguro para una futura K5, si se aprueba.

### Contrato propuesto

Ruta conceptual recomendada:

```text
/dev/chat-messages/session/:sessionId
```

Reglas:

- el parámetro debe llamarse `sessionId`;
- no puede llamarse `id`;
- no acepta `agentId`;
- no infiere sesión desde agente;
- no crea sesión;
- no lista sesiones;
- no toca chat heredado;
- no toca `/chat/:id`;
- no toca `/orchestrator/chat`;
- monta únicamente `OwnChatMessagesSafeShell(sessionId: sessionId)` o
  equivalente aprobado.

### Protección dev-only

Si K5 implementa una ruta, debe quedar blindada por una combinación explícita
de controles:

- guard `kDebugMode` o equivalente debug-only;
- feature flag local no remoto;
- exclusión o bloqueo verificable fuera de builds de desarrollo;
- guard visible de entorno en UI;
- tests que demuestren que producción no expone ni resuelve la ruta;
- ausencia de remoto, datos reales y backend real.

La ruta no puede depender de flags remotos, configuración de servidor ni datos
de usuario reales.

### Opciones comparadas

| Opción | Ventajas | Riesgos | Evaluación |
| --- | --- | --- | --- |
| A — Ruta dev-only en router existente | Permite prueba manual real con navegación. | Toca routing; riesgo de colarse en producción; exige gates y tests estrictos. | Aceptable solo con K5 explícito y blindaje dev-only. |
| B — Host en test/widget/dev harness sin router | No toca routing; menor riesgo; mantiene aislamiento. | Menos parecido al flujo real de navegación. | Recomendación inicial si el objetivo es validación visual segura. |
| C — Entrada temporal local con feature flag | Flexible para pruebas internas. | Riesgo de activación accidental si el flag no está completamente local. | Solo si el flag es local, debug-only y probado. |

### Recomendación K4

Recomendación inicial:

```text
Opción B si el objetivo es validación visual segura.
Opción A solo si queda blindada por dev-only y tests.
```

No se recomienda conectar `/chat/:id` ni `/orchestrator/chat` en K5.

### Criterios mínimos para K5

Antes de implementar cualquier ruta dev-only debe aprobarse:

- nombre exacto de ruta;
- archivo exacto de router a tocar;
- guard dev-only exacto;
- rollback;
- tests de ruta;
- prueba de que producción no expone la ruta;
- prueba de que `/chat/:id` queda intacta;
- prueba de que `/orchestrator/chat` queda intacta;
- prueba de que no se usa `agentId` como `sessionId`;
- prueba de que el parámetro se llama `sessionId`, nunca `id`;
- prueba de que no se importan Supabase, HTTP/Dio, `SupabaseChatDataSource`,
  `ChatController` heredado ni `chat_providers.dart` heredado;
- prueba de que UI no envía `role`, `userId`, `specialistId`, JWT ni
  `service_role`.

### Tests futuros necesarios

Ruta dev-only:

- monta `OwnChatMessagesSafeShell`;
- pasa `sessionId` explícito;
- rechaza `sessionId` vacío;
- no acepta `id`;
- no acepta `agentId`.

Producción:

- ruta no existe o queda bloqueada fuera de debug/dev;
- no se activa en producción;
- no usa remoto;
- no usa datos reales.

Rutas existentes:

- `/chat/:id` intacta;
- `/orchestrator/chat` intacta;
- handlers heredados sin cambios.

Arquitectura:

- ruta dev-only no importa Supabase;
- no importa HTTP/Dio;
- no importa `SupabaseChatDataSource`;
- no importa `ChatController` heredado;
- no importa `chat_providers.dart` heredado;
- no envía `role`, `userId` ni `specialistId`;
- no expone JWT ni `service_role`.

### Rollback

Rollback futuro de K5:

- quitar ruta dev-only;
- quitar tests asociados;
- mantener `OwnChatMessagesSafeShell`;
- mantener chat heredado intacto;
- mantener `/chat/:id` intacta;
- mantener `/orchestrator/chat` intacta;
- confirmar diff limitado y reversible.

### Relación con bloque messages

Después de revisar K4 se decidirá una de estas opciones:

- implementar K5 dev-only;
- cerrar bloque messages;
- volver a otra área.

K4 no decide todavía cuál camino tomar.

### Fuera de alcance de K4

K4 no implementa rutas, navegación, código Flutter, chat heredado, providers
productivos, Supabase, Edge Functions, migraciones, CI, remoto, producción,
auth real, datos reales, IA, Stasis Engine, MCP, streaming ni adjuntos.

## Cierre formal 2B-V-K4 y preparación 2B-V-L — bloque messages local-safe completo

Fecha: 2026-06-26.

2B-V-K4 queda cerrado formalmente. K4 fue exclusivamente documental: no
implementó ruta dev-only, no tocó navegación, no conectó nada al shell, no tocó
chat heredado, no modificó `lib/features/chat_messages/`, no tocó rutas,
tests, `pubspec.yaml`, Supabase, Edge Functions, migraciones ni CI.

Decisión firme:

```text
/chat/:id no puede conectarse a OwnChatMessagesSafeShell porque :id es
agentId heredado, no sessionId seguro.
```

Evidencia:

```text
/chat/:id monta AgentChatWrapper(agentId: id)
```

Por tanto, siguen bloqueados:

- `/chat/:id`;
- `/orchestrator/chat`;
- interpretación de `agentId` como `sessionId`;
- K5 ruta dev-only con `sessionId` explícito.

K5 no se autoriza todavía porque tocar routing añade riesgo, el host/dev
harness ya permite validación segura y no hay necesidad inmediata de ruta.

### Estado completo de 2B-V

Se documentan como cerrados o completados localmente:

- 2B-V-A — `messages` deny-all + constraints mínimos;
- 2B-V-B — fixtures transaccionales de `messages`;
- 2B-V-C1 — RPC transaccional `send_user_message_core`;
- 2B-V-C2 — Edge Function local `send-user-message`;
- 2B-V-D — Edge Function local `list-session-messages`;
- 2B-V-E — contrato Flutter messages desconectado;
- 2B-V-F — datasource Flutter HTTP local messages;
- 2B-V-G — integración HTTP local messages;
- 2B-V-H — cierre documental del bloque messages;
- 2B-V-I1 — application controller/state messages sin providers reales;
- 2B-V-I2 — providers Riverpod messages sin UI;
- 2B-V-J — UI mínima messages aislada;
- 2B-V-J2 — host/demo aislado messages;
- 2B-V-K0 — auditoría del chat actual;
- 2B-V-K1 — plan de adaptación segura del chat actual;
- 2B-V-K2 — shell seguro;
- 2B-V-K3 — plan de wiring con rutas reales;
- 2B-V-K4 — plan de ruta dev-only con `sessionId` explícito.

### Capacidades terminadas local-safe

Queda disponible de forma local, aislada o dev/test, no productiva:

- tabla `messages` endurecida;
- RPC transaccional de envío;
- Edge Functions locales `send` y `list`;
- contrato Flutter seguro;
- datasource HTTP local;
- integración local real;
- controller/state Dart puro;
- providers Riverpod sin UI peligrosa;
- UI mínima aislada;
- host/dev test;
- shell seguro;
- auditoría del chat heredado;
- decisión de no conectar `/chat/:id`.

### Bloqueos vigentes

Siguen bloqueados:

- rutas productivas;
- `/chat/:id`;
- `/orchestrator/chat`;
- chat heredado;
- `SupabaseChatDataSource`;
- `ChatController` heredado enviando `role`;
- `chat_providers.dart` heredado con `Supabase.instance.client`;
- backend remoto;
- producción;
- datos reales;
- IA;
- Stasis Engine;
- MCP;
- streaming;
- adjuntos;
- mensajes `assistant`, `system` o `tool` reales desde backend.

### Gates para futuro routing

Antes de tocar rutas reales deberá aprobarse y verificarse:

- `sessionId` explícito;
- nunca `agentId` como `sessionId`;
- ruta exacta aprobada;
- archivo exacto aprobado;
- rollback aprobado;
- tests de rutas;
- producción bloqueada si es dev-only;
- `/chat/:id` intacta;
- `/orchestrator/chat` intacta;
- no Supabase directo;
- no `ChatController` heredado;
- no `SupabaseChatDataSource`;
- no `role`, `userId` ni `specialistId` desde UI.

### Gates para backend real/remoto

Antes de backend real o remoto deberá aprobarse y verificarse:

- decisión explícita de entorno;
- secretos fuera del repo;
- token provider seguro;
- `baseUrl` no hardcodeada;
- anti-remoto revisado;
- tests locales pasando;
- no `service_role` en cliente;
- no writes directos desde Flutter a Supabase;
- no datos reales sin aprobación.

### Gates para IA, Stasis Engine, MCP y streaming

Permanecen fuera de alcance y requieren paquete separado:

- mensajes `assistant` reales;
- orquestación Stasis;
- Stasis Engine;
- MCP;
- streaming;
- tool calls;
- specialist routing;
- memoria;
- adjuntos.

### Recomendación de cierre

Cerrar temporalmente el bloque `messages` como local-safe completo y no tocar
routing hasta una decisión posterior.

Posibles siguientes rutas:

- volver a otro bloque técnico pendiente;
- preparar bloque de `chat_sessions` UI/routing seguro;
- preparar gates de auth/session selection;
- preparar futuro routing dev-only con `sessionId` explícito;
- pasar a otra área de Stasisly.

2B-V-L no implementa código ni desbloquea producción, remoto, rutas reales,
chat heredado, IA, Stasis Engine, MCP, streaming, adjuntos ni datos reales.

## Aprobación formal 2B-V-L — bloque messages local-safe completo

Fecha: 2026-06-26.

2B-V-L queda aprobado y cerrado formalmente. El bloque `messages` queda cerrado
temporalmente como:

```text
local-safe completo
dev/test-safe
no productivo
no remoto
sin datos reales
sin routing productivo
```

### Decisión crítica final

```text
/chat/:id es agentId heredado, no sessionId seguro.
```

Por tanto:

- no interpretar `agentId` como `sessionId`;
- no conectar `/chat/:id` a `OwnChatMessagesSafeShell`;
- no conectar `/orchestrator/chat` a `OwnChatMessagesSafeShell`;
- no avanzar a K5 sin aprobación futura explícita.

### Estado aprobado

Queda aprobado que 2B-V-A hasta 2B-V-K4 quedan documentados como
completados/cerrados según su alcance. También queda aprobado que el bloque
`messages` dispone de capacidades locales/dev-test suficientes para cerrarse
temporalmente: tabla endurecida, RPC transaccional local, Edge Functions
locales `send-user-message` y `list-session-messages`, contrato Flutter seguro,
datasource HTTP local, integración local real, controller/state Dart puro,
providers Riverpod sin UI peligrosa, UI mínima aislada, host/dev test, shell
seguro y auditoría del chat heredado.

### Bloqueos mantenidos

Permanecen bloqueados:

- `/chat/:id`;
- `/orchestrator/chat`;
- chat heredado;
- `SupabaseChatDataSource`;
- `ChatController` heredado enviando `role`;
- `chat_providers.dart` heredado con `Supabase.instance.client`;
- backend remoto;
- producción;
- datos reales;
- IA;
- Stasis Engine;
- MCP;
- streaming;
- adjuntos;
- mensajes `assistant`, `system` o `tool` reales desde backend.

### Siguiente paso recomendado

No continuar con K5. El siguiente paquete recomendado es:

```text
2B-W — chat_sessions UI/routing seguro
```

Motivo: `messages` exige `sessionId` explícito y seguro. Antes de tocar rutas
de mensajes hay que resolver cómo se selecciona una sesión, cómo se entra en
una sesión, cómo se evita confundir `agentId` con `sessionId`, cómo se evita
reactivar el chat heredado, cómo se evita Supabase directo desde Flutter y cómo
se conserva rollback.

Alternativas válidas:

- auth/session selection seguro;
- otro bloque técnico pendiente;
- otra área de Stasisly.

## Plan exacto 2B-W — chat_sessions UI/routing seguro

Fecha: 2026-06-26.

2B-W se inicia como análisis y planificación documental. No implementa código,
no modifica rutas, no toca navegación, no toca chat heredado, no modifica
Flutter app, Supabase, Edge Functions, migraciones ni CI.

### Estado heredado de messages

`messages` queda cerrado formalmente como local-safe completo:

- dev/test-safe;
- no productivo;
- no remoto;
- sin datos reales;
- sin routing productivo.

El bloque `messages` exige `sessionId` explícito y seguro. Por eso no puede
ser conectado a rutas reales hasta que `chat_sessions` resuelva de forma segura
selección, creación, listado, archivado y entrada a sesión.

### Decisiones firmes heredadas

```text
/chat/:id es agentId heredado, no sessionId seguro.
```

Por tanto:

- no conectar `/chat/:id` a `OwnChatMessagesSafeShell`;
- no conectar `/orchestrator/chat` a `OwnChatMessagesSafeShell`;
- no interpretar `agentId` como `sessionId`;
- K5 no está autorizado.

### Archivos inspeccionados

```text
lib/features/chat_sessions/
lib/features/chat_messages/
lib/features/chat/
lib/core/config/routes.dart
lib/app.dart
lib/main.dart
test/
pubspec.yaml
supabase/functions/
supabase/migrations/
```

La inspección fue de solo lectura.

### Estado actual de chat_sessions

Existente y verificado:

- dominio público en `OwnChatSession`, `OwnChatSessionsPage`,
  `ArchivedOwnChatSession`, `SelectableSpecialistSummary` y enums de estado;
- contrato `OwnChatSessionsRepository` con operaciones:
  `createOwnChatSession(selectableSpecialistId)`,
  `listOwnChatSessions(status, limit, cursor)` y
  `archiveOwnChatSession(sessionId)`;
- resultados tipados de create/list/archive con failures explícitos;
- datasource HTTP local `LocalHttpOwnChatSessionsDataSource`;
- host policy local, token provider local y transporte inyectable;
- repositorios demo, backendBlocked y validating;
- tests unitarios y de arquitectura para contrato local;
- integración local `two_b_iv_h_local_http_chat_sessions_integration_test.dart`;
- Edge Functions locales `create-own-chat-session`,
  `list-own-chat-sessions` y `archive-own-chat-session`;
- migración `00005_harden_chat_sessions_deny_all.sql`.

Pendiente o no existente:

- UI propia de `chat_sessions`;
- controller/state de aplicación para selección de sesión;
- providers Riverpod específicos de UI/routing de sesiones;
- routing seguro por `sessionId`;
- integración con `OwnChatMessagesSafeShell`;
- sustitución/adaptación de `/chat/:id`;
- decisión productiva de backend remoto.

### Capacidades ya cerradas de chat_sessions

Según documentación y archivos inspeccionados, quedan cerradas localmente:

- tabla `chat_sessions` endurecida/deny-all;
- fixtures locales transaccionales;
- Edge Function local `createOwnChatSession`;
- Edge Function local `listOwnChatSessions`;
- Edge Function local `archiveOwnChatSession`;
- contrato Flutter desconectado;
- datasource HTTP local;
- integración HTTP local.

Estas capacidades no desbloquean producción, remoto, datos reales ni routing
productivo.

### Brecha agentId vs sessionId

```text
agentId != sessionId
```

El flujo heredado `/chat/:id` usa `id` como `agentId` y monta
`AgentChatWrapper(agentId: id)`. El flujo seguro de mensajes necesita
`sessionId`. Por tanto, antes de entrar a mensajes debe existir un paso seguro
que produzca una sesión propia y explícita:

- desde un agente/especialista se puede crear o seleccionar una sesión;
- una vez creada o seleccionada, se entra a mensajes con `sessionId`;
- `messages` nunca recibe `agentId` como sesión;
- routing futuro debe separar rutas de agente y rutas de sesión.

### Opciones de flujo seguro

| Opción | Descripción | Ventajas | Riesgos | Tests necesarios |
| --- | --- | --- | --- | --- |
| A — Selector/listado de sesiones primero | El usuario ve sus sesiones y entra por `sessionId`. | Máxima claridad; no mezcla agente con sesión. | Requiere UI/listado y estado vacío. | listado, selección, cursor, sesión archivada, entrada por `sessionId`. |
| B — Desde agente se crea/recupera sesión segura | El usuario pulsa agente/especialista y se crea o selecciona sesión antes de mensajes. | UX más directa desde catálogo. | Riesgo de reintroducir `agentId` si no se separa bien. | create con `selectableSpecialistId`, respuesta con `sessionId`, navegación posterior por `sessionId`. |
| C — Ruta dev-only con `sessionId` explícito | Solo desarrollo, sin producto. | Valida shell y mensajes con sesión explícita. | No resuelve UX productiva. | debug-only, producción bloqueada, `sessionId` explícito. |
| D — Mantener messages aislado | No tocar routing aún. | Cero riesgo inmediato. | Bloquea validación de flujo real. | Ninguno nuevo; coste de oportunidad documentado. |

### Recomendación

Primero diseñar `chat_sessions` UI/routing seguro antes de tocar `/chat/:id`.

Preferencia inicial:

```text
Opción A o B, pero siempre con sessionId explícito antes de entrar en messages.
```

La opción A es más segura para evitar confusión conceptual. La opción B puede
ser mejor UX si se implementa con frontera estricta:
`selectableSpecialistId -> create/list session -> sessionId -> messages`.

### Gates para implementación futura

Antes de implementar cualquier UI/routing de `chat_sessions`:

- `sessionId` explícito;
- no `agentId` como `sessionId`;
- no Supabase directo desde UI;
- no writes directos desde Flutter;
- no `ChatController` heredado;
- no `SupabaseChatDataSource` heredado;
- no `role`, `userId` ni `specialistId` desde UI;
- rutas actuales intactas salvo aprobación explícita;
- rollback definido;
- tests de widget;
- tests de providers;
- tests arquitectónicos.

## Implementación 2B-W-B — controller/state chat_sessions UI-safe

### Estado

2B-W-A queda cerrado formalmente. 2B-W-B queda implementado y verificado como
controller/state puro para `chat_sessions`.

Esta implementación no autoriza providers, UI, navegación, routing productivo,
chat heredado, Supabase remoto, datos reales, IA, Stasis Engine, MCP,
streaming ni adjuntos.

### Decisión implementada

Se crea una capa de aplicación mínima y testeable que:

- carga sesiones propias mediante el contrato de repositorio existente;
- refresca el listado sin destruir datos confirmados ante errores;
- crea una sesión usando exclusivamente `selectableSpecialistId`;
- expone siempre el `sessionId` explícito devuelto por backend/demo como valor
  seleccionable para mensajes;
- archiva sesiones usando exclusivamente `sessionId`;
- permite seleccionar solo `sessionId` ya presentes en el estado;
- rechaza identificadores heredados o arbitrarios, incluido `agentId`;
- conserva separación estricta entre demo explícito, backend bloqueado y
  errores reales.

### Relación selectableSpecialistId / sessionId

Regla vigente:

```text
agentId != selectableSpecialistId != specialistId interno != sessionId
```

En 2B-W-B:

- `createSession` acepta solo `selectableSpecialistId`;
- el repositorio resuelve la creación mediante su contrato aprobado;
- la salida usable para `messages` es siempre `selectedSessionId`, basado en
  `OwnChatSession.sessionId`;
- `agentId` no forma parte de la API pública del controller/state;
- `specialistId` interno no aparece en el estado ni en las operaciones.

### Relación con messages

El controller/state no importa ni monta `messages`. Solo deja preparado el
valor seguro:

```text
OwnChatSessionsState.selectedSessionId -> sessionId explícito futuro para messages
```

`OwnChatMessagesSafeShell` y cualquier navegación futura siguen bloqueados
hasta que exista un paquete posterior aprobado.

### Bloqueos conservados

Siguen bloqueados:

- `/chat/:id`;
- `/orchestrator/chat`;
- `ChatController` heredado;
- `SupabaseChatDataSource`;
- providers productivos;
- UI mínima de sesiones;
- routing por `sessionId`;
- conexión remota;
- producción;
- datos reales.

### Evidencia

Se añadieron tests de estado, operaciones, errores, demo explícito,
backend bloqueado, orden sin duplicados, selección segura y frontera
`agentId/sessionId`.

Los tests arquitectónicos verifican que `lib/features/chat_sessions/application`
no usa Flutter widgets, `BuildContext`, Riverpod, Provider, Supabase, HTTP,
Edge Functions, chat heredado, `messages`, `userId`, `specialistId`, `agentId`,
`role`, permisos, Stasis Engine, MCP ni streaming.

### Siguiente paso recomendado

Preparar 2B-W-C como providers `chat_sessions` UI-safe, manteniéndolo
separado de UI y routing. Routing por `sessionId` debe continuar al final de la
cadena, después de controller/state, providers y UI/listado aislado.

## Implementación 2B-W-D — UI mínima aislada chat_sessions

### Estado

2B-W-C queda cerrado formalmente. 2B-W-D queda implementado y verificado como
UI mínima aislada para `chat_sessions`.

No autoriza rutas reales, navegación, `/chat/:id`, `/orchestrator/chat`,
chat heredado, `chat_messages`, `OwnChatMessagesSafeShell`,
`OwnChatMessagesPanel`, Supabase, HTTP directo desde UI, remoto, producción,
datos reales, IA, Stasis Engine, MCP, streaming ni adjuntos.

### Componentes creados

Se crea `OwnChatSessionsPanel` como componente aislado. Consume únicamente:

```text
ownChatSessionsStateProvider
ownChatSessionsControllerProvider
```

No llama repositorios, no construye datasources, no conoce URLs, no conoce Edge
Functions y no decide permisos u ownership.

### Capacidades UI

La UI representa:

- listado de sesiones;
- estado vacío;
- estado de carga;
- errores de listado, creación y archivado;
- backend bloqueado;
- demo explícito;
- creación por `selectableSpecialistId`;
- selección por `sessionId`;
- archivado por `sessionId`;
- `selectedSessionId` como valor seguro futuro para mensajes.

### Reglas de identificadores

Regla vigente:

```text
agentId != selectableSpecialistId != specialistId interno != sessionId
```

En W-D:

- el campo de creación se llama `selectableSpecialistId`;
- crear sesión llama `createSession(selectableSpecialistId)`;
- seleccionar llama `selectSession(sessionId)`;
- archivar llama `archiveSession(sessionId)`;
- la UI no envía `agentId`, `specialistId` interno, `userId` ni `role`;
- timestamps y contadores se muestran como información, no como autoridad.

### Relación con messages

W-D no integra `messages`. Solo muestra texto informativo:

```text
selectedSessionId disponible para futuro flujo de mensajes
```

No importa `chat_messages` ni monta componentes de mensajes.

### Evidencia

Se añadieron tests de widget con providers overrideados, sin red, sin Supabase,
sin Edge Functions reales y sin datos reales. Cubren render, estados, crear,
seleccionar, archivar, refresh, errores, demo/backendBlocked e identificadores
seguros.

Los tests arquitectónicos bloquean en widgets: Supabase, HTTP/Dio, Edge paths,
secretos/tokens, chat heredado, `chat_messages`, shells/panels de mensajes,
ids internos, roles/permisos, Stasis Engine, MCP y streaming.

### Siguiente paso recomendado

Preparar un paquete posterior de host/dev aislado o plan de routing seguro por
`sessionId` explícito. No conectar `/chat/:id` ni `/orchestrator/chat` sin una
aprobación separada.

## Implementación 2B-W-E — host/dev aislado chat_sessions

### Estado

2B-W-D queda cerrado formalmente. 2B-W-E queda implementado y verificado como
host/dev aislado para visualizar `OwnChatSessionsPanel` con escenarios
controlados.

No autoriza rutas reales, navegación, `/chat/:id`, `/orchestrator/chat`, chat
heredado, `chat_messages`, `OwnChatMessagesSafeShell`,
`OwnChatMessagesPanel`, Supabase, HTTP/Dio directo, Edge Function paths,
remoto, producción, datos reales, IA, Stasis Engine, MCP, streaming ni
adjuntos.

### Host/dev creado

Se crea `OwnChatSessionsPanelDevHost` dentro de
`lib/features/chat_sessions/presentation/dev/`. El host monta
`OwnChatSessionsPanel` con `ProviderScope` y overrides locales del controller.
No crea rutas, no invoca navegación y no se registra en `app.dart`, `main.dart`
ni configuración de routing.

### Datos fake/demo

El host usa sesiones ficticias con UUIDs de prueba y nombres explícitamente
ficticios. No usa usuarios reales, datos reales, secretos, tokens ni contenido
sensible.

### Estados representados

El host permite representar:

- listado con varias sesiones;
- sesión seleccionada;
- estado vacío;
- estado de carga;
- demo explícito;
- backend bloqueado;
- error de listado;
- error de creación;
- error de archivado;
- creación en curso;
- archivado en curso.

### Interacciones simuladas

Las interacciones mantienen la frontera aprobada:

```text
createSession(selectableSpecialistId)
selectSession(sessionId)
archiveSession(sessionId)
```

El host no acepta `agentId` como `sessionId`, no usa `specialistId` interno,
no envía `userId` y no envía `role`.

### Evidencia

Se añadieron tests de widget para el host/dev con providers overrideados, sin
red, sin Supabase, sin Edge Functions reales y sin datos reales. Cubren render,
escenarios controlados, errores, crear, seleccionar, archivar, refrescar,
demo/backendBlocked e identificadores seguros.

El test arquitectónico refuerza que `presentation/dev` no use Supabase,
HTTP/Dio, Edge paths, secretos/tokens, `go_router`, `Navigator`, chat heredado,
`chat_messages`, shells/panels de mensajes, ids internos, roles/permisos,
Stasis Engine, MCP ni streaming.

### Siguiente paso recomendado

Decidir si preparar un shell seguro de `chat_sessions`, un plan de routing por
`sessionId` explícito o un cierre temporal local-safe del bloque. No conectar
`/chat/:id` ni `/orchestrator/chat` sin aprobación separada.

## Implementación 2B-W-F — shell seguro chat_sessions

### Estado

2B-W-E queda cerrado formalmente. 2B-W-F queda implementado y verificado como
shell seguro de presentación para `chat_sessions`.

No autoriza rutas reales, navegación, `/chat/:id`, `/orchestrator/chat`, chat
heredado, `chat_messages`, `OwnChatMessagesSafeShell`,
`OwnChatMessagesPanel`, Supabase, HTTP/Dio directo, Edge Function paths,
remoto, producción, datos reales, IA, Stasis Engine, MCP, streaming ni
adjuntos.

### Shell seguro creado

Se crea `OwnChatSessionsSafeShell` dentro de
`lib/features/chat_sessions/presentation/shell/`. El shell monta
`OwnChatSessionsPanel` y puede mostrar contexto seguro de entrada, pero no
crea rutas, no navega, no registra path alguno y no modifica `routes.dart`,
`app.dart` ni `main.dart`.

### Adapter seguro creado

Se crea `OwnChatSessionsShellInputAdapter` como adapter allowlist-only. Solo
lee:

```text
sessionId
selectableSpecialistId
```

No lee ni transforma claves heredadas o ambiguas. Si la entrada no contiene
claves permitidas válidas, devuelve `null`.

### Reglas de entrada

La frontera se mantiene:

```text
selectableSpecialistId -> createSession -> sessionId
sessionId -> selectedSessionId seguro
```

El shell no crea sesiones por sí mismo, no selecciona sesiones por sí mismo y
no infiere sesión desde agentes. Las operaciones siguen perteneciendo al
controller/panel aprobado.

### Relación con messages

W-F no integra `messages`. No importa `chat_messages`, no monta
`OwnChatMessagesPanel` y no monta `OwnChatMessagesSafeShell`.

### Evidencia

Los tests de widget validan que el shell renderiza `OwnChatSessionsPanel`,
muestra estado inicial, puede reflejar backendBlocked mediante provider real
bloqueado, permite demo explícito con override y no rompe operaciones del
panel.

Los tests de adapter validan que se aceptan `sessionId` y
`selectableSpecialistId`, que entradas heredadas o ambiguas son rechazadas, que
vacío se rechaza y que no hay transformación de identificadores.

El test arquitectónico bloquea en `presentation/shell` Supabase, HTTP/Dio, Edge
paths, secretos/tokens, routing productivo, navegación, chat heredado,
`chat_messages`, shells/panels de mensajes, ids internos, roles/permisos,
Stasis Engine, MCP y streaming.

### Siguiente paso recomendado

Decidir si preparar un plan de routing por `sessionId` explícito o cerrar
temporalmente `chat_sessions` como bloque local-safe. No conectar `/chat/:id`
ni `/orchestrator/chat` sin aprobación separada.

## Implementación 2B-W-C — providers chat_sessions UI-safe

### Estado

2B-W-B queda cerrado formalmente. 2B-W-C queda implementado y verificado como
capa de providers Riverpod UI-safe para `chat_sessions`.

No autoriza UI, widgets, rutas, navegación, `/chat/:id`,
`/orchestrator/chat`, chat heredado, `chat_messages`, Supabase remoto, HTTP
directo desde providers, datos reales, IA, Stasis Engine, MCP, streaming ni
adjuntos.

### Providers creados

Se crean providers equivalentes a:

```text
ownChatSessionsRepositoryProvider
demoOwnChatSessionsRepositoryProvider
backendBlockedOwnChatSessionsRepositoryProvider
ownChatSessionsControllerProvider
ownChatSessionsStateProvider
```

El provider de repositorio:

- usa `DemoOwnChatSessionsRepository` solo en modo demo explícito;
- usa `BackendBlockedOwnChatSessionsRepository` para backend real y producción;
- permite override en tests;
- no construye Supabase client;
- no construye HTTP transport;
- no lee JWT, `service_role` ni secretos;
- no convierte errores reales en demo.

### Controller/state provider

`OwnChatSessionsControllerNotifier` envuelve el controller ya aprobado y expone:

```text
loadInitial()
refresh()
createSession(selectableSpecialistId)
archiveSession(sessionId)
selectSession(sessionId)
clearSelection()
clear()
```

El estado expuesto a UI futura sigue siendo `OwnChatSessionsState` y contiene
solo datos públicos de sesiones, `selectedSessionId`, flags y errores tipados.

### Relación selectableSpecialistId / sessionId

Regla vigente:

```text
agentId != selectableSpecialistId != specialistId interno != sessionId
```

En W-C:

- `createSession` recibe solo `selectableSpecialistId`;
- `selectedSessionId` sigue siendo el único valor preparado para messages;
- `archiveSession` y `selectSession` operan solo con `sessionId`;
- `agentId` heredado se rechaza antes de llegar al repositorio en selección y
  archivado UI-safe;
- `specialistId`, `userId` y `role` no aparecen en providers.

### Relación con messages

Los providers de `chat_sessions` no importan `chat_messages` ni montan
`OwnChatMessagesSafeShell` o `OwnChatMessagesPanel`.

La única relación futura permitida es conceptual:

```text
OwnChatSessionsState.selectedSessionId -> sessionId explícito para messages
```

### Evidencia

Se añadieron tests de providers con `ProviderContainer`, overrides de
repositorio, demo explícito, backend bloqueado, operaciones, lifecycle, errores
visibles y seguridad de identificadores.

Los tests arquitectónicos verifican que los providers no importan Flutter
widgets, `BuildContext`, Supabase, Dio, HTTP, Edge Function paths, chat
heredado, `chat_messages`, `OwnChatMessagesSafeShell`,
`OwnChatMessagesPanel`, `userId`, `specialistId`, `agentId`, `role`,
permisos, Stasis Engine, MCP ni streaming.

### Siguiente paso recomendado

Preparar 2B-W-D como UI mínima aislada de `chat_sessions`, sin routing y sin
conectar `/chat/:id` ni `/orchestrator/chat`.

### Paquetes futuros propuestos

- 2B-W-A — auditoría específica de `chat_sessions` UI/routing seguro;
- 2B-W-B — plan de selector/listado seguro de sesiones;
- 2B-W-C — controller/providers `chat_sessions` UI-safe;
- 2B-W-D — UI mínima aislada `chat_sessions`;
- 2B-W-E — routing seguro por `sessionId` explícito.

2B-W no implementa ninguno de estos paquetes; solo los propone para revisión.

## Auditoría específica 2B-W-A — chat_sessions UI/routing seguro

Fecha: 2026-06-26.

2B-W queda aprobado como plan inicial. 2B-W-A queda preparado como auditoría
documental específica para decidir cómo avanzar hacia UI/routing seguro de
`chat_sessions`.

No implementa código, UI, providers, controllers, rutas, navegación, chat
heredado, Flutter app, Supabase, Edge Functions, migraciones, CI, remoto,
producción, IA, Stasis Engine, MCP, streaming ni adjuntos.

### Estructura actual de chat_sessions

| Pieza | Archivo | Responsabilidad | Estado | Riesgo | Reutilización |
| --- | --- | --- | --- | --- | --- |
| Entidades públicas | `lib/features/chat_sessions/domain/entities/own_chat_session.dart` | `OwnChatSession`, `OwnChatSessionsPage`, `ArchivedOwnChatSession`, `SelectableSpecialistSummary` | Existente y verificado | Bajo | Reutilizable; no expone `userId` ni `specialistId`. |
| Resultados tipados | `own_chat_session_results.dart` | Success/demo/failure para create/list/archive | Existente y verificado | Bajo | Reutilizable; errores visibles. |
| Repository contract | `own_chat_sessions_repository.dart` | `createOwnChatSession`, `listOwnChatSessions`, `archiveOwnChatSession` | Existente y verificado | Medio | Reutilizable; UI futura debe controlar cuándo llama create/list/archive. |
| Contract source | `own_chat_sessions_contract_source.dart` | Fuente simulada/contrato público sin I/O directo | Existente y verificado | Bajo | Reutilizable. |
| Local HTTP datasource | `local_http_own_chat_sessions_datasource.dart` | Llama Edge Functions locales con host policy y token | Existente local | Medio | Reutilizable solo en local/dev; no remoto. |
| Host policy/token/transport | `data/local/` | Anti-remoto, token local, transporte inyectable | Existente local | Medio | Reutilizable con gates; no productivo. |
| Demo repository | `demo_own_chat_sessions_repository.dart` | Demo explícita con sesiones fake | Existente | Bajo | Reutilizable solo demo. |
| Backend blocked repository | `backend_blocked_own_chat_sessions_repository.dart` | Falla cerrado | Existente | Bajo | Reutilizable para producción bloqueada. |
| Validating repository | `validating_own_chat_sessions_repository.dart` | Valida payload público y rechaza contratos rotos | Existente y verificado | Bajo-medio | Reutilizable; base para UI-safe. |
| Controllers | No existen | Estado de pantalla/selección | Pendiente | Medio | Crear en paquete futuro. |
| Providers | No existen para UI/routing de sesiones | Inyección y overrides UI-safe | Pendiente | Medio | Crear después de controller/state. |
| UI | No existe | Listado/selector/acciones | Pendiente | Medio | Crear aislada antes de routing. |

### Backend local chat_sessions

Existente y verificado en solo lectura:

- `supabase/functions/create-own-chat-session`;
- `supabase/functions/list-own-chat-sessions`;
- `supabase/functions/archive-own-chat-session`;
- `supabase/migrations/00005_harden_chat_sessions_deny_all.sql`;
- tests Deno, SQL/locales e integración local.

`createOwnChatSession`:

- acepta exclusivamente body `{ selectableSpecialistId }`;
- `selectableSpecialistId` debe ser UUID;
- resuelve `specialist_catalog.id` como identificador público seleccionable;
- obtiene internamente `specialist_catalog.specialist_id`;
- valida catálogo publicado, disponible y `access_tier=free`;
- valida que existe el especialista interno;
- crea una fila en `chat_sessions` con `user_id` derivado del JWT local y
  `specialist_id` interno;
- no recibe `agentId`, `specialistId`, `userId`, `role`, timestamps ni contadores
  desde Flutter;
- sanitiza la respuesta pública como `{ session: { sessionId, selectableSpecialist,
  startedAt, lastMessageAt, status, messageCount } }`;
- no devuelve `user_id`, `specialist_id`, prompts ni campos internos.

Conclusión crítica: `createOwnChatSession` ya trabaja con identificador público
de catálogo (`selectableSpecialistId`) y devuelve `sessionId` explícito si el
contrato se cumple.

`listOwnChatSessions`:

- recibe solo `status`, `limit` y `cursor`;
- deriva owner desde JWT local;
- lista sesiones propias;
- une contra catálogo sanitizado para devolver `selectableSpecialist`;
- devuelve items con `sessionId` explícito y cursor opaco.

`archiveOwnChatSession`:

- recibe exclusivamente `{ sessionId }`;
- deriva owner desde JWT local;
- archiva solo sesión propia activa;
- devuelve respuesta mínima `{ session: { sessionId, status: archived } }`.

### Contrato Flutter auditado

Verificado:

- `createOwnChatSession(selectableSpecialistId)` envía solo
  `selectableSpecialistId`;
- `listOwnChatSessions(status, limit, cursor)` envía solo filtros públicos;
- `archiveOwnChatSession(sessionId)` envía solo `sessionId`;
- Flutter no envía `ownerUserId`, `userId`, `role`, `messageCount`,
  `lastMessageAt`, `createdAt`, `updatedAt`, `specialistId` ni campos internos;
- el contrato público expone `sessionId`, `selectableSpecialist`, `startedAt`,
  `lastMessageAt`, `status` y `messageCount`;
- no existe `title` ni `archivedAt` en el contrato actual.

### Relación agentId / specialistId / sessionId

- `agentId` heredado: ID usado por rutas/pantallas antiguas para resolver
  agente/especialista en `/chat/:id`; no es seguro como sesión.
- `selectableSpecialistId`: ID público de catálogo sanitizado que Flutter puede
  enviar para crear una sesión.
- `specialistId`/`specialist_id`: ID interno backend; no debe viajar como
  contrato público Flutter.
- `sessionId`: ID explícito de `chat_sessions.id`; único identificador válido
  para entrar a mensajes.

Regla firme:

```text
agentId nunca puede tratarse como sessionId.
```

### Relación con messages

Flujo seguro esperado:

```text
chat_sessions crea/lista/selecciona sessionId
messages recibe sessionId explícito
OwnChatMessagesSafeShell solo acepta sessionId
OwnChatMessagesRouteParamsAdapter rechaza id heredado
```

Puntos seguros existentes:

- `OwnChatMessagesSafeShell` recibe `sessionId`;
- `OwnChatMessagesRouteParamsAdapter` rechaza `id` heredado;
- contratos de `messages` envían solo `sessionId` y `content`.

Pendiente:

- selección UI-safe de sesión;
- estado/controlador de sesión seleccionada;
- providers UI-safe para sesiones;
- enlace explícito `OwnChatSession.sessionId -> OwnChatMessagesSafeShell`.

### Brechas UI-safe

| Pieza | Estado |
| --- | --- |
| controller/state `chat_sessions` UI-safe | Pendiente |
| providers Riverpod `chat_sessions` UI-safe | Pendiente |
| UI mínima aislada de sesiones | Pendiente |
| host/dev test de sesiones | Pendiente |
| shell seguro de sesiones | Pendiente |
| routing seguro por `sessionId` | Pendiente |
| selector/listado de sesiones | Pendiente |
| crear sesión desde especialista/agente | Pendiente de diseño UI-safe |
| archivar sesión desde UI | Pendiente |

### Riesgos clasificados

| Riesgo | Severidad | Estado |
| --- | --- | --- |
| Confundir `agentId` con `sessionId` | Bloqueante | Bloqueado documentalmente; requiere gates. |
| Supabase directo desde Flutter | Bloqueante | Prohibido; feature actual no lo usa. |
| Writes directos desde Flutter | Bloqueante | Prohibido; usar contrato/Edge local en fases futuras. |
| Rutas heredadas `/chat/:id` y `/orchestrator/chat` | Alto | No tocar sin aprobación. |
| Chat heredado | Alto | No reutilizar `ChatController`/`SupabaseChatDataSource`. |
| Exposición de IDs internos | Alto | Tests bloquean `userId`/`specialistId` en contrato público. |
| Token/JWT/service_role en cliente | Alto | Token local inyectado; `service_role` solo backend local. |
| Mezcla demo/backend real | Alto | Repos separados; no fallback silencioso. |
| Romper `messages` local-safe | Medio-alto | Entrar solo por `sessionId` explícito. |
| Romper `chat_sessions` local-safe | Medio | Requiere tests de contrato y arquitectura. |

### Recomendación

La auditoría confirma la recomendación inicial: primero implementar
controller/state y providers UI-safe de `chat_sessions`, después UI mínima o
selector/listado aislado, y routing al final.

Siguiente paquete recomendado:

```text
2B-W-B — controller/providers chat_sessions UI-safe
```

Alternativa si se quiere aún más separación:

```text
2B-W-B — controller/state chat_sessions UI-safe
2B-W-C — providers chat_sessions UI-safe
```

## Cierre 2B-W-G — chat_sessions local-safe completo

### Estado

2B-W-F queda cerrado formalmente. 2B-W-G registra el cierre temporal del bloque
`chat_sessions` como:

```text
local-safe completo
dev/test-safe
no productivo
no remoto
sin datos reales
sin routing productivo
```

Este cierre es documental. No implementa código, no modifica rutas, no conecta
navegación, no toca chat heredado, no integra `chat_messages`, no conecta
Supabase remoto y no desbloquea backend real ni producción.

### Estado completo de 2B-W

Quedan cerrados según su alcance:

- 2B-W — plan inicial de `chat_sessions` UI/routing seguro;
- 2B-W-A — auditoría específica de `chat_sessions`;
- 2B-W-B — controller/state Dart puro;
- 2B-W-C — providers Riverpod UI-safe;
- 2B-W-D — UI mínima aislada;
- 2B-W-E — host/dev aislado;
- 2B-W-F — shell seguro;
- 2B-W-G — cierre documental local-safe completo.

### Capacidades terminadas

El bloque `chat_sessions` dispone, en alcance local/dev-test:

- contrato Flutter seguro para sesiones propias;
- datasource HTTP local ya auditado en paquetes anteriores;
- integración local real ya auditada en paquetes anteriores;
- controller/state Dart puro sin providers, UI ni routing;
- providers Riverpod overrideables sin UI peligrosa;
- UI mínima aislada;
- host/dev aislado con fixtures fake;
- shell seguro de presentación;
- adapter allowlist-only;
- flujo seguro `selectableSpecialistId -> sessionId`;
- selección y archivado por `sessionId`.

### Decisiones firmes

Reglas permanentes hasta ADR o aprobación contraria:

```text
agentId != selectableSpecialistId
agentId != specialistId interno
agentId != sessionId
selectableSpecialistId != sessionId
```

`agentId` heredado nunca se interpreta como `sessionId`. Una clave heredada
`id` nunca se interpreta como `sessionId`. La única salida válida para un flujo
futuro de mensajes es un `sessionId` explícito producido o seleccionado por
`chat_sessions`.

`selectableSpecialistId` solo puede usarse para crear una sesión mediante el
contrato controlado de `chat_sessions`; no es una ruta de entrada a mensajes.

### Bloqueos vigentes

Permanecen bloqueados:

- routing por `sessionId`;
- `/chat/:id`;
- `/orchestrator/chat`;
- navegación real/productiva;
- conexión entre `chat_sessions` y `OwnChatMessagesSafeShell`;
- importación de `chat_messages` desde `chat_sessions`;
- chat heredado;
- `SupabaseChatDataSource` heredado;
- `ChatController` heredado enviando `role`;
- Supabase directo desde Flutter;
- HTTP/Dio directo desde UI/providers;
- remoto, producción y datos reales;
- IA, Stasis Engine, MCP, streaming y adjuntos.

### Gates para futuro routing

Antes de autorizar cualquier routing futuro debe existir paquete separado con:

- aprobación explícita del cliente;
- ruta exacta y nombre de parámetro `sessionId`, nunca `id`;
- prohibición de conectar `/chat/:id` si sigue representando `agentId`;
- prohibición de conectar `/orchestrator/chat` al shell seguro sin plan propio;
- prueba de que no se reactivan chat heredado, `SupabaseChatDataSource`,
  `ChatController` heredado ni providers inseguros;
- rollback concreto;
- tests de ruta/adapter, widget, arquitectura y contrato;
- evidencia de que UI no envía `role`, `userId`, `specialistId`, `agentId`,
  `attachments`, metadata interna ni tokens.

### Relación futura con messages

La relación futura permitida conceptualmente es:

```text
chat_sessions produce o selecciona sessionId explícito
messages consume sessionId explícito
```

2B-W-G no conecta ambos bloques. No monta `OwnChatMessagesSafeShell`, no monta
`OwnChatMessagesPanel`, no importa `chat_messages` y no crea navegación hacia
mensajes.

### Relación con remoto y producción

Cerrar `chat_sessions` como local-safe no autoriza:

- backend remoto;
- Supabase remoto;
- producción;
- usuarios reales;
- datos reales;
- auth real;
- publicación en stores;
- IA real o Stasis Engine.

### Recomendación

No continuar directamente con routing. Si se decide avanzar, preparar primero
un paquete documental específico para routing por `sessionId` explícito o para
selección/autorización de sesión. Ese paquete debe mantener separado el chat
heredado y no puede reutilizar `/chat/:id` mientras sea `agentId`.

## Cierre 2B-X — chat local-safe completo

### Estado

2B-W-G queda aprobado y cerrado formalmente. 2B-X prepara el cierre documental
global del frente chat local-safe, integrando:

- `messages`;
- `chat_sessions`.

El frente completo queda documentado como:

```text
local-safe completo
dev/test-safe
no productivo
no remoto
sin datos reales
sin routing productivo
```

2B-X no implementa código, no modifica rutas, no modifica navegación, no toca
chat heredado, no modifica `chat_messages`, no modifica `chat_sessions`, no
modifica Supabase, no modifica migraciones y no modifica tests.

### Estado global de messages

`messages` queda cerrado como local-safe completo, dev/test-safe, no productivo,
no remoto, sin datos reales y sin routing productivo.

Capacidades cerradas:

- tabla `messages` endurecida localmente;
- RPC transaccional local;
- Edge Functions locales `send-user-message` y `list-session-messages`;
- contrato Flutter seguro;
- datasource HTTP local;
- integración local;
- controller/state Dart puro;
- providers UI-safe;
- UI mínima aislada;
- host/dev;
- shell seguro.

`messages` no queda conectado a rutas productivas, chat heredado, remoto,
producción, datos reales, IA, Stasis Engine, MCP, streaming, adjuntos ni
mensajes assistant/system/tool reales desde backend productivo.

### Estado global de chat_sessions

`chat_sessions` queda cerrado como local-safe completo, dev/test-safe, no
productivo, no remoto, sin datos reales y sin routing productivo.

Capacidades cerradas:

- contrato seguro;
- datasource HTTP local auditado;
- integración local auditada;
- controller/state Dart puro;
- providers UI-safe;
- UI mínima aislada;
- host/dev;
- shell seguro;
- adapter allowlist-only;
- flujo `selectableSpecialistId -> sessionId`;
- selección y archivo por `sessionId`.

`chat_sessions` no queda conectado a `messages`, `chat_messages`, rutas reales,
navegación productiva, chat heredado, remoto, producción ni datos reales.

### Decisiones firmes globales

Quedan registradas como reglas globales:

```text
agentId != selectableSpecialistId != specialistId interno != sessionId
/chat/:id es agentId heredado, no sessionId
id heredado no puede tratarse como sessionId
sessionId es la única entrada válida futura para messages
selectableSpecialistId sirve para crear/seleccionar sesión, no para entrar directamente a messages
```

Ningún paquete posterior puede inferir `sessionId` desde `agentId`, desde un
`id` heredado, desde `selectableSpecialistId` o desde `specialist_id` interno.

### Bloqueos globales vigentes

Permanecen bloqueados:

- `/chat/:id`;
- `/orchestrator/chat`;
- routing real;
- navegación productiva;
- chat heredado;
- conexión `chat_sessions -> messages`;
- conexión `chat_sessions -> chat_messages`;
- `SupabaseChatDataSource` heredado;
- `ChatController` heredado;
- backend remoto;
- producción;
- datos reales;
- Supabase remoto;
- IA;
- Stasis Engine;
- MCP;
- streaming;
- adjuntos;
- mensajes assistant/system/tool reales.

### Gates antes de routing

Un paquete futuro de routing requiere, como mínimo:

- aprobación explícita;
- ruta exacta aprobada;
- archivo exacto aprobado;
- parámetro llamado `sessionId`;
- rechazo de `id`;
- rechazo de `agentId`;
- no tocar `/chat/:id` sin plan separado;
- no tocar `/orchestrator/chat` sin plan separado;
- no usar chat heredado;
- no usar `ChatController` heredado;
- no usar `SupabaseChatDataSource` heredado;
- no Supabase directo desde UI;
- no HTTP directo desde UI;
- no `userId` desde UI;
- no `specialistId` interno desde UI;
- no `role` desde UI;
- rollback definido;
- tests de routing;
- tests de navegación;
- tests de arquitectura;
- tests de producción bloqueada si la ruta es dev-only.

### Gates antes de remoto o producción

Remoto o producción requiere paquete separado y, como mínimo:

- decisión explícita de entorno;
- secrets fuera del repositorio;
- token provider real seguro;
- `baseUrl` no hardcodeada;
- anti-remote revisado;
- cero `service_role` en cliente;
- cero writes directos desde Flutter;
- cero datos reales hasta aprobación explícita;
- tests locales pasando;
- plan de rollback;
- auditoría de seguridad.

### Gates antes de IA, Stasis Engine, MCP o streaming

Siguen fuera de alcance y requieren paquetes separados:

- assistant real;
- mensajes system/tool reales;
- orquestación Stasis;
- Stasis Engine;
- MCP;
- streaming;
- tool calls;
- specialist routing;
- memoria;
- adjuntos.

### Recomendación final

Cerrar el frente chat local-safe completo antes de abrir routing. Después de
2B-X, las rutas válidas de trabajo son:

- plan de routing seguro por `sessionId` explícito;
- auth/session selection seguro;
- backend remoto seguro;
- otro bloque técnico;
- otra área de Stasisly.

Ninguna queda autorizada por este cierre.

## Plan 2B-Y — routing seguro por sessionId explícito

### Estado

2B-X queda aprobado y cerrado formalmente. 2B-Y prepara solo el plan exacto de
routing seguro por `sessionId` explícito.

2B-Y no implementa código, no modifica rutas, no modifica navegación, no toca
`lib/features/chat`, no modifica `chat_messages`, no modifica `chat_sessions`,
no modifica Supabase, no modifica migraciones, no modifica tests y no conecta
`chat_sessions` con `messages`.

### Rutas actuales inspeccionadas

Inspección en solo lectura:

- `lib/core/config/routes.dart`;
- `lib/app.dart`;
- `lib/main.dart`;
- `lib/features/chat/`;
- `lib/features/chat_messages/`;
- `lib/features/chat_sessions/`.

Rutas reales verificadas:

- `/onboarding`;
- `/login`;
- `/register`;
- `/health`;
- `/nutrition`;
- `/physical`;
- `/mental`;
- `/orchestrator`;
- `/orchestrator/chat`;
- `/chat/:id`.

`/chat/:id` monta `AgentChatWrapper(agentId: id)`. Ese `id` es `agentId`
heredado, no `sessionId`.

`/orchestrator/chat` monta `OrchestratorChatPage`, que carga `stasis_core` y
después monta `ChatPage(agentId: stasis.id, ...)`.

`AgentChatWrapper` resuelve `agentByIdProvider(agentId)` y monta `ChatPage`
con `agent.id`.

`ChatPage` usa `activeChatSessionProvider(widget.agentId)`, por lo que el valor
que entra desde la ruta heredada sigue el camino de `agentId`/especialista
heredado antes de producir una sesión interna.

`ChatController` heredado llama `sendMessage` con `role: 'user'`.

`chat_providers` heredado construye `SupabaseChatDataSource` con
`Supabase.instance.client` cuando no está en demo.

`SupabaseChatDataSource` heredado escribe directamente en `chat_sessions` y
`messages`, lee/escribe `user_id`, `specialist_id`, `role`, `session_id` y
usa RPC heredada `increment_message_count`.

### Riesgos actuales de routing

El riesgo principal es conectar una ruta nueva o existente al shell de
mensajes sin separar claramente:

```text
agentId != selectableSpecialistId != specialistId interno != sessionId
```

Riesgos concretos:

- `/chat/:id` parece genérica, pero hoy representa `agentId`;
- `/orchestrator/chat` entra por Stasis/agente, no por sesión segura;
- `AgentChatWrapper` y `OrchestratorChatPage` siguen montando `ChatPage`
  heredado;
- `ChatPage` consume providers heredados;
- `ChatController` heredado envía `role`;
- `SupabaseChatDataSource` heredado puede escribir directo desde Flutter si se
  activa backend;
- entidades heredadas exponen `userId`, `specialistId`, `role`, `attachments`
  y campos internos.

### Opciones de routing futuro

#### Opción A — Ruta nueva explícita por sessionId

Ruta conceptual:

```text
/chat/session/:sessionId
```

Ventajas:

- nombre explícito;
- no reutiliza `/chat/:id`;
- permite montar un shell seguro con entrada `sessionId`;
- reduce la ambigüedad entre agente, catálogo y sesión.

Riesgos:

- puede percibirse como ruta productiva si no se bloquea por entorno;
- requiere tests de navegación y producción bloqueada si no está lista para
  producto;
- podría conectar `messages` antes de cerrar selección/autorización de sesión.

Rollback:

- eliminar la ruta nueva y sus tests;
- conservar shells aislados sin navegación.

Tests mínimos:

- parámetro se llama `sessionId`;
- rechaza `id` y `agentId`;
- no toca `/chat/:id`;
- no toca `/orchestrator/chat`;
- monta solo shell seguro;
- producción/remoto bloqueados si corresponde.

#### Opción B — Ruta dev-only explícita por sessionId

Ruta conceptual:

```text
/dev/chat/session/:sessionId
```

Ventajas:

- reduce riesgo productivo;
- permite validar navegación local/dev sin tocar rutas reales;
- alinea mejor con estado local-safe actual.

Riesgos:

- no resuelve UX productiva;
- puede dejar deuda si se usa como ruta permanente;
- exige gate fuerte para bloquear producción.

Rollback:

- retirar la ruta dev-only y sus tests sin afectar producto.

Tests mínimos:

- ruta solo disponible en entorno dev/demo/local aprobado;
- producción bloqueada;
- parámetro `sessionId` obligatorio;
- no acepta `id` ni `agentId`;
- no conecta remoto.

#### Opción C — Mantener routing bloqueado y pasar a auth/session selection

Ventajas:

- evita conectar mensajes antes de resolver identidad/sesión;
- permite diseñar selección segura de sesión antes de navegación;
- reduce riesgo de mezclar demo/backend real.

Riesgos:

- retrasa validación visual de flujo completo;
- requiere otra fase documental/técnica.

#### Opción D — Refactor futuro de `/chat/:id`

No recomendada ahora.

Riesgos:

- `/chat/:id` está verificada como `agentId`;
- arrastra `AgentChatWrapper`, `ChatPage`, providers heredados,
  `ChatController` heredado y `SupabaseChatDataSource`;
- alto riesgo de reactivar writes directos y envío de `role`.

### Recomendación

No tocar `/chat/:id`.

No tocar `/orchestrator/chat`.

Si se abre routing, hacerlo en un paquete posterior separado con ruta nueva y
parámetro explícito `sessionId`. La opción más prudente para una primera
implementación futura es:

```text
2B-Y-A — implementación dev-only route por sessionId explícito
```

La opción productiva local-safe `/chat/session/:sessionId` debe esperar a que
se aprueben entorno, UX y tests de navegación.

### Gates obligatorios

Antes de implementar routing debe existir:

- aprobación explícita;
- ruta exacta aprobada;
- archivo exacto aprobado;
- parámetro llamado `sessionId`;
- rechazo de `id`;
- rechazo de `agentId`;
- no inferir sesión desde agente;
- no tocar `/chat/:id`;
- no tocar `/orchestrator/chat`;
- no usar `AgentChatWrapper`;
- no usar `ChatController` heredado;
- no usar `SupabaseChatDataSource` heredado;
- no Supabase directo desde UI;
- no HTTP directo desde UI;
- no `userId` desde UI;
- no `specialistId` interno desde UI;
- no `role` desde UI;
- rollback definido;
- tests de routing;
- tests de navegación;
- tests arquitectónicos;
- tests de producción bloqueada si la ruta es dev-only.

### Relación futura chat_sessions/messages

Flujo conceptual permitido:

```text
chat_sessions produce sessionId seguro
ruta futura recibe sessionId explícito
messages consume sessionId explícito
```

La ruta futura no crea sesiones, no resuelve agentes, no resuelve catálogo, no
consulta especialistas y no infiere sesión.

### Flujos prohibidos

```text
agentId -> messages
id heredado -> messages
selectableSpecialistId -> messages
/chat/:id -> OwnChatMessagesSafeShell
/orchestrator/chat -> OwnChatMessagesSafeShell
```

También queda prohibido usar `AgentChatWrapper`, `ChatPage`, `ChatController`
heredado o `SupabaseChatDataSource` heredado como puente hacia el shell seguro.

### Riesgos clasificados

| Riesgo | Severidad | Mitigación |
| --- | --- | --- |
| Confundir `agentId` con `sessionId` | Bloqueante | Ruta nueva con parámetro `sessionId`; rechazo de `id` y `agentId`. |
| Reactivar chat heredado | Bloqueante | Prohibir `AgentChatWrapper`, `ChatPage`, `ChatController` y `SupabaseChatDataSource`. |
| Usar Supabase directo desde UI | Bloqueante | Tests arquitectónicos y no usar providers heredados. |
| Abrir producción accidentalmente | Alto | Preferir ruta dev-only y test de producción bloqueada. |
| Romper rutas existentes | Alto | No tocar `/chat/:id` ni `/orchestrator/chat`. |
| Exponer IDs internos | Alto | No aceptar `userId`, `specialistId`, `role` ni metadata desde UI. |
| Mezclar demo/backend real | Alto | Mantener repos demo/backendBlocked y entorno explícito. |
| Conectar messages antes de session selection segura | Medio | Paquete separado y aprobación explícita. |

### Siguiente paquete propuesto

Recomendación:

```text
2B-Y-A — implementación dev-only route por sessionId explícito
```

Alternativas válidas:

- `2B-Y-B — implementación ruta nueva local-safe por sessionId explícito`;
- `2B-Z — auth/session selection seguro`;
- otro bloque técnico;
- otra área de Stasisly.

Ninguna implementación queda autorizada por 2B-Y.

## Implementación 2B-Y-A — dev-only route por sessionId explícito

### Estado

2B-Y queda aprobado y cerrado formalmente. 2B-Y-A queda implementado como ruta
dev-only/local por `sessionId` explícito.

Ruta creada:

```text
/dev/chat/session/:sessionId
```

La ruta no es productiva, no toca rutas heredadas y no conecta
`chat_sessions` con `messages`.

### Protección dev-only

La ruta se registra solo cuando:

```text
!kReleaseMode && environment.isDemo
```

En release o en cualquier modo no demo, la lista de rutas dev-only queda vacía.
No se modifican `app.dart` ni `main.dart`.

### Parámetro sessionId

La ruta usa exclusivamente un parámetro llamado `sessionId`. El valor se valida
mediante `OwnChatMessagesRouteParamsAdapter.sessionIdFrom(state.pathParameters)`.

El adapter solo lee `sessionId`, recorta espacios y rechaza valores vacíos o
con separadores de ruta.

### Rechazo de id y agentId

La ruta no declara parámetros `:id` ni `:agentId`, no lee `id`, no lee
`agentId` y no infiere sesión desde agente.

### Shell seguro montado

La ruta monta:

```text
Scaffold -> OwnChatMessagesSafeShell(sessionId)
```

El `Scaffold` pertenece a la capa de routing dev-only para dar contexto
Material al panel. No modifica el shell ni el feature `chat_messages`.

### Rutas heredadas intactas

Permanecen intactas:

- `/chat/:id`;
- `/orchestrator/chat`.

`/chat/:id` sigue montando `AgentChatWrapper(agentId: id)` y no se conecta al
shell seguro.

`/orchestrator/chat` sigue montando el flujo heredado y no se conecta al shell
seguro.

### Chat heredado intacto

No se modificó:

- `AgentChatWrapper`;
- `ChatPage`;
- `ChatController`;
- `chat_providers`;
- `SupabaseChatDataSource`;
- entidades o repositorios heredados de `features/chat`.

La ruta dev-only no importa ni invoca esas piezas.

### Relación con chat_sessions

2B-Y-A no conecta selector/listado de `chat_sessions`. No usa
`selectableSpecialistId`, no crea sesión, no lista sesiones y no archiva
sesiones.

### Relación con messages

La ruta recibe `sessionId` explícito y monta el shell seguro de mensajes. No
envía `role`, `userId`, `specialistId`, `agentId`, `ownerUserId`, metadata,
adjuntos, JWT, access token, refresh token ni `service_role`.

### Seguridad y tests

Tests añadidos:

- `test/core/config/dev_chat_messages_route_test.dart`;
- `test/architecture/dev_only_chat_route_contract_test.dart`.

Cobertura:

- la ruta demo/local monta el shell seguro con `sessionId`;
- la ruta está protegida por `kReleaseMode || !environment.isDemo`;
- no existen variantes `:id` o `:agentId`;
- el bloque dev-only no reutiliza `AgentChatWrapper`, `ChatPage`,
  `OrchestratorChatPage`, `ChatController`, `SupabaseChatDataSource`,
  Supabase directo, Edge paths, tokens, roles, IDs internos, Stasis Engine,
  MCP ni streaming.

### Rollback

Rollback simple:

- retirar la ruta `/dev/chat/session/:sessionId`;
- retirar los tests `dev_chat_messages_route_test.dart` y
  `dev_only_chat_route_contract_test.dart`;
- mantener 2B-X cerrado;
- mantener `/chat/:id` intacto;
- mantener `/orchestrator/chat` intacto;
- mantener chat heredado intacto.

### Riesgos residuales

La ruta es dev-only y no productiva. El riesgo residual principal es que un
paquete futuro intente convertirla en productiva sin gates de entorno,
autorización, UX y navegación. Debe requerir aprobación explícita separada.

### Gates para futura implementación

- `sessionId` explícito;
- no `agentId` como `sessionId`;
- no Supabase directo desde UI;
- no writes directos desde Flutter;
- no `ChatController` heredado;
- no `SupabaseChatDataSource` heredado;
- no `role`, `userId` ni `specialistId` desde UI;
- rutas productivas intactas;
- rollback definido;
- tests de widget;
- tests de providers;
- tests arquitectónicos.

## Cierre 2B-Y-B — routing dev-only cerrado

### Estado

2B-Y-A queda aprobado y cerrado formalmente. La ruta dev-only abierta por
2B-Y-A se clasifica como puerta de pruebas:

```text
/dev/chat/session/:sessionId
```

No es una puerta de producto, no habilita routing productivo y no desbloquea
navegación real de usuario.

### Protección vigente

La ruta solo puede existir bajo la doble condición:

```text
!kReleaseMode && environment.isDemo
```

En release, backend real, producción o cualquier entorno no demo, la ruta debe
quedar fuera de la tabla de rutas.

### Límites de la ruta

La ruta:

- exige `sessionId` explícito;
- no acepta `id`;
- no acepta `agentId`;
- no infiere sesiones;
- no crea, lista ni archiva `chat_sessions`;
- no conecta flujo completo `chat_sessions -> messages`;
- no activa remoto;
- no trata datos reales;
- solo monta `OwnChatMessagesSafeShell` con un `sessionId` ya conocido.

### Rutas heredadas intactas y bloqueadas

Permanecen intactas y no conectadas al shell seguro:

- `/chat/:id`;
- `/orchestrator/chat`.

Decisión firme:

```text
/chat/:id es agentId heredado, no sessionId seguro.
```

Por tanto, no debe interpretarse `agentId` como `sessionId` ni conectarse
`/chat/:id` o `/orchestrator/chat` a `OwnChatMessagesSafeShell` sin aprobación
futura explícita.

### Chat heredado intacto

Permanecen intactos y bloqueados para el frente local-safe:

- `AgentChatWrapper`;
- `ChatPage`;
- `ChatController`;
- `chat_providers`;
- `SupabaseChatDataSource`;
- cualquier envío heredado de `role`;
- cualquier uso heredado de `Supabase.instance.client`.

### Bloqueos vigentes

Siguen bloqueados:

- routing productivo;
- navegación real de usuario;
- integración completa `chat_sessions -> messages`;
- `/chat/:id` productivo;
- `/orchestrator/chat` productivo;
- auth/session selection real;
- backend remoto;
- Supabase remoto;
- producción;
- datos reales;
- IA;
- Stasis Engine;
- MCP;
- streaming;
- adjuntos.

### Recomendación

No avanzar directamente a routing productivo. El siguiente paso prudente es
preparar un plan separado para `auth/session selection seguro` o para una UX de
entrada segura `chat_sessions -> messages`, manteniendo la ruta dev-only como
herramienta local de prueba.

## Plan 2B-Z — auth/session selection seguro

### Estado

2B-Y-B queda aprobado y cerrado formalmente. 2B-Z prepara solo el plan exacto
para resolver la entrada segura del usuario al flujo de chat antes de abrir
routing real.

No implementa código, no modifica rutas, no modifica navegación, no conecta
`chat_sessions` con `messages`, no toca chat heredado, no toca Supabase, no
activa remoto, no usa producción y no trata datos reales.

### Estado actual auditado

Inspección en solo lectura:

- `lib/core/domain/entities/current_identity.dart`;
- `lib/core/providers/current_identity_provider.dart`;
- `lib/core/config/app_environment.dart`;
- `lib/main.dart`;
- `lib/features/auth/`;
- `lib/features/chat_sessions/`;
- `lib/features/chat_messages/`;
- `lib/features/chat/`.

Hallazgos verificados:

- existe `CurrentIdentity` como contrato central con `demo` y `authenticated`;
- `CurrentIdentity` no contiene perfil, roles, permisos ni autoridad
  administrativa;
- `currentIdentityProvider` devuelve identidad demo en modo demo y bloquea la
  identidad autenticada fuera de demo con `AppConfigurationException`;
- `UserEntity` extiende `CurrentIdentity` y no contiene rol ni permisos;
- `UserProfile` está separado y no concede autoridad;
- `main.dart` solo inicializa Supabase si `environment.usesBackend`;
- `AppEnvironment.validateForStartup` bloquea backend real si faltan variables
  o no existe aprobación explícita de activación;
- existe capa auth heredada con `SupabaseAuthDataSource`,
  `AuthRepositoryImpl` y `auth_providers`;
- `auth_providers` heredado expone `Supabase.instance.client`, por tanto no
  debe conectarse al flujo seguro sin paquete específico;
- `chat_sessions` y `chat_messages` tienen providers seguros que en demo usan
  repositorios demo y fuera de demo devuelven `backendBlocked`;
- existen `LocalSessionTokenProvider` locales para harness de validación, pero
  no son auth de producto ni deben versionar tokens reales;
- el chat heredado sigue existiendo y conserva piezas no aptas para el frente
  seguro: `ChatController`, `chat_providers` y `SupabaseChatDataSource`.

### Flujo seguro conceptual

Flujo permitido futuro:

```text
auth/session válida
-> identidad autenticada controlada
-> token provider seguro
-> chat_sessions lista/crea sesión propia
-> sessionId explícito
-> messages recibe sessionId explícito
```

La UI no decide ownership ni permisos. Flutter no envía `userId`, `role`,
`specialistId` interno ni tokens hardcodeados. El backend valida token,
ownership, permisos y estado de sesión.

### Flujos prohibidos

Quedan prohibidos:

```text
agentId -> messages
id heredado -> messages
selectableSpecialistId -> messages
/chat/:id -> messages
/orchestrator/chat -> messages
UI -> Supabase directo
UI -> writes directos
error real -> fallback demo
token hardcodeado -> backend
```

### Responsabilidades por capa

| Capa | Responsabilidad | No puede decidir |
| --- | --- | --- |
| Auth/session | Identidad autenticada, sesión vigente y token seguro. | Ownership de recursos sin backend. |
| chat_sessions | Crear, listar, seleccionar y archivar sesiones propias. | Mensajes ni permisos administrativos. |
| messages | Enviar/listar mensajes por `sessionId` explícito. | Crear sesión o inferir sesión desde agente. |
| routing | Transportar `sessionId` explícito tras selección segura. | Convertir `agentId`, `id` o catálogo en sesión. |
| UI | Mostrar estados, errores y acciones permitidas. | Ownership, permisos, roles o IDs internos. |
| backend | Validar token, ownership, permisos, RLS/RPC y contratos. | Confiar en autoridad enviada por Flutter. |

### Opciones de implementación futura

| Opción | Descripción | Ventaja | Riesgo | Recomendación |
| --- | --- | --- | --- | --- |
| A — Auth/session selection primero | Crear/validar capa segura de sesión de usuario antes de routing real. | Reduce riesgo de identidad ambigua. | No resuelve UX final todavía. | Recomendada. |
| B — Selector seguro `chat_sessions -> messages` | UX para seleccionar/crear sesión y entregar `sessionId`. | Acerca el flujo real. | Puede avanzar sin auth sólida. | Después de A. |
| C — Dev-only flow extendido | Mantener prueba solo local/demo con gates. | Bajo riesgo productivo. | No resuelve producto. | Válida para validar transiciones. |
| D — Routing productivo directo | Abrir ruta real hacia mensajes. | Más rápido visualmente. | Alto: puede mezclar IDs, auth y chat heredado. | No recomendada. |

### Recomendación

Orden recomendado:

```text
1. auth/session selection seguro
2. UX segura chat_sessions -> messages
3. routing productivo
```

### Gates antes de auth/session selection

- aprobación explícita;
- sin Supabase directo desde UI;
- sin `service_role` en cliente;
- sin tokens hardcodeados;
- sin datos reales;
- sin producción;
- token provider seguro;
- errores auth visibles;
- `backendBlocked` explícito;
- demo explícito;
- no fallback demo desde error real;
- tests de providers;
- tests arquitectónicos;
- rollback definido.

### Gates antes de UX chat_sessions -> messages

- `sessionId` explícito;
- `selectedSessionId` confirmado;
- no `agentId`;
- no `id` heredado;
- no `selectableSpecialistId` directo a `messages`;
- no chat heredado;
- no `ChatController` heredado;
- no `SupabaseChatDataSource` heredado;
- rollback definido;
- tests de widget;
- tests de navegación si aplica;
- tests arquitectónicos.

### Riesgos clasificados

| Riesgo | Severidad | Mitigación |
| --- | --- | --- |
| Mezclar auth demo con auth real | Bloqueante | Entorno explícito y contratos separados. |
| Usar token inseguro o hardcodeado | Bloqueante | Token provider seguro e inyectable. |
| Activar remoto accidentalmente | Bloqueante | `backendBlocked`, gates y tests anti-remoto. |
| Usar datos reales antes de RLS/auth aprobados | Bloqueante | Datos reales bloqueados. |
| Confundir `agentId` con `sessionId` | Bloqueante | Ruta/flujo con `sessionId` explícito. |
| Reactivar chat heredado | Alto | No usar `ChatController`, `chat_providers` ni datasource heredado. |
| Exponer `userId` o `specialistId` interno | Alto | Contratos públicos sanitizados. |
| Writes directos desde Flutter | Alto | Edge/RPC/backend controlado. |
| Productivizar ruta dev-only | Alto | `!kReleaseMode && environment.isDemo` y plan separado. |
| Ocultar errores auth como demo | Alto | No fallback demo desde error real. |

### Siguiente paquete propuesto

Propuesta de secuencia:

```text
2B-Z-A — auditoría auth/session actual
2B-Z-B — controller/providers auth/session safe
2B-Z-C — UX segura chat_sessions -> messages
2B-Z-D — plan routing productivo seguro
```

2B-Z-A debe seguir siendo de alcance pequeño y verificable, con inspección
focalizada de auth actual, proveedores, token/session contract y puntos que
deben quedar bloqueados antes de cualquier implementación.

## Auditoría 2B-Z-A — auth/session actual

### Estado

2B-Z queda aprobado y cerrado formalmente. 2B-Z-A audita el estado real de
auth/session antes de implementar cualquier controller, provider, ruta o
conexión real.

No implementa código, no modifica auth, no modifica providers, no modifica
rutas, no conecta `chat_sessions` con `messages`, no toca Supabase, no toca
migraciones, no ejecuta remoto, no usa producción y no trata datos reales.

### Archivos inspeccionados

Inspección en solo lectura:

- `lib/core/domain/entities/current_identity.dart`;
- `lib/core/providers/current_identity_provider.dart`;
- `lib/core/config/app_environment.dart`;
- `lib/core/config/env.dart`;
- `lib/main.dart`;
- `lib/features/auth/domain/entities/user_entity.dart`;
- `lib/features/auth/domain/entities/user_profile.dart`;
- `lib/features/auth/data/models/user_model.dart`;
- `lib/features/auth/domain/repositories/auth_repository.dart`;
- `lib/features/auth/data/datasources/supabase_auth_datasource.dart`;
- `lib/features/auth/data/repositories/auth_repository_impl.dart`;
- `lib/features/auth/presentation/viewmodels/auth_providers.dart`;
- `lib/features/chat_sessions/`;
- `lib/features/chat_messages/`;
- `lib/features/chat/`;
- `test/`;
- `supabase/functions/`;
- `supabase/migrations/`.

### CurrentIdentity

`CurrentIdentity` representa la identidad mínima que las features pueden
consumir directamente. Campos:

- `id`;
- `source`;
- `email`.

`source` solo puede ser `demo` o `authenticated`. No contiene perfil, rol,
permisos, membresía, flags administrativos ni autoridad de producto.

Estado: base segura parcial. Es correcta como contrato mínimo, pero la identidad
autenticada real sigue bloqueada hasta paquete aprobado.

Riesgos residuales:

- `demoId` es fijo y debe permanecer claramente acotado a demo;
- `email` no debe convertirse en clave de autorización;
- falta bridge aprobado entre auth real y `CurrentIdentity.authenticated`.

### UserEntity y UserProfile

`UserEntity` extiende `CurrentIdentity` con `id` y `email`; no añade rol,
perfil, permisos ni autoridad.

`UserProfile` contiene:

- `userId`;
- `displayName`;
- `avatarUrl`.

El perfil queda separado de identidad y explícitamente no concede roles,
permisos ni autoridad administrativa.

Estado: cerrado conceptualmente para separación identidad/perfil. Pendiente de
conexión segura con auth real, RLS y perfil propio.

### AppEnvironment

`AppEnvironment` define:

- `AppRuntimeMode.demo`;
- `AppRuntimeMode.backendReal`;
- `AppRuntimeMode.production`;
- `isDemo`;
- `usesBackend`;
- `validateForStartup`.

`main.dart` inicializa Supabase solo si `environment.usesBackend`.

`validateForStartup`:

- permite demo sin Supabase;
- bloquea backend real si faltan `SUPABASE_URL` o `SUPABASE_ANON_KEY`;
- bloquea backend real si no existe aprobación explícita
  `backendActivationApproved`.

Estado: base segura parcial. Evita remoto accidental por configuración normal.
Riesgo residual: cualquier paquete futuro que active backend debe pasar por
aprobación explícita y tests anti-remoto; no basta con variables presentes.

### Auth heredado

Piezas verificadas:

- `AuthRepository`;
- `SignInUseCase`;
- `SignUpUseCase`;
- `SignOutUseCase`;
- `SupabaseAuthDataSource`;
- `AuthRepositoryImpl`;
- `auth_providers`;
- `AuthController`.

El auth heredado usa Supabase directo:

- `auth_providers` expone `Supabase.instance.client`;
- `SupabaseAuthDataSource` llama a `supabase.auth.signInWithPassword`,
  `supabase.auth.signUp`, `supabase.auth.signOut`,
  `supabase.auth.currentUser` y `supabase.auth.onAuthStateChange`.

Estado: heredado y bloqueado para el flujo seguro nuevo. Puede aportar ideas de
contrato y casos de uso, pero no debe conectarse a `chat_sessions`, `messages`,
routing productivo ni `CurrentIdentity` sin paquete separado.

Qué podría reutilizarse tras revisión:

- interfaz conceptual `AuthRepository`;
- use cases de sign in/out/up;
- mapping `UserModel.fromSupabase` que ignora metadata de rol.

Qué debe bloquearse ahora:

- provider global de `Supabase.instance.client`;
- wiring directo datasource -> Supabase desde UI/providers;
- cualquier uso de `userMetadata` como autoridad;
- cualquier activación sin `backendBlocked` explícito y tests.

### Token providers

Existen interfaces locales:

- `lib/features/chat_sessions/data/local/local_session_token_provider.dart`;
- `lib/features/chat_messages/data/local/local_session_token_provider.dart`.

Ambas exponen:

```text
Future<String?> readLocalSessionToken()
```

Consumidores:

- `LocalHttpOwnChatSessionsDataSource`;
- `LocalHttpOwnChatMessagesDataSource`;
- harness/tests locales.

Estado: local/harness, no producto. No son auth real ni deben transportar
tokens reales versionados.

También existen tokens de prueba en tests, como `valid-local-jwt` o
`local-token`, usados como fixtures locales. No son credenciales reales.

Falta para token provider seguro real:

- contrato único de sesión/token;
- origen aprobado desde Supabase Auth o backend controlado;
- política de expiración/refresh;
- ausencia de `service_role` en cliente;
- errores visibles y sin fallback demo;
- tests anti-remoto y anti-token-hardcoded.

### Relación con chat_sessions

Contrato seguro actual:

```text
createOwnChatSession(selectableSpecialistId)
listOwnChatSessions(status, limit, cursor)
archiveOwnChatSession(sessionId)
```

`chat_sessions` no recibe `userId`, `ownerUserId`, `role` ni `specialistId`
interno desde UI. El datasource local usa token provider y host policy local.

En providers:

- modo demo usa `DemoOwnChatSessionsRepository`;
- modo no demo devuelve `BackendBlockedOwnChatSessionsRepository`;
- no hay conexión real productiva.

Estado: parcial/local-safe. Puede alimentar el flujo seguro cuando exista
auth/session selection aprobado. No debe conectarse a auth heredado directo.

### Relación con messages

Contrato seguro actual:

```text
sendUserMessage(sessionId, content)
listSessionMessages(sessionId, limit, cursor)
```

`messages` recibe `sessionId` explícito. No recibe `userId`, `role` ni
`specialistId` desde UI. El datasource local usa token provider, host policy,
validación de input y mapeo de errores.

En providers:

- modo demo usa `DemoOwnChatMessagesRepository`;
- modo no demo devuelve `BackendBlockedOwnChatMessagesRepository`;
- no hay conexión real productiva.

Estado: parcial/local-safe. Puede consumir `sessionId` cuando una capa segura
de selección lo entregue. No debe inferir sesión desde agente, catálogo ni ruta
heredada.

### Brechas auth/session

| Área | Estado | Evidencia / motivo |
| --- | --- | --- |
| Identidad central | Parcial | `CurrentIdentity` existe; auth real aún bloqueada. |
| Perfil separado | Cerrado conceptualmente | `UserProfile` separado y sin autoridad. |
| Auth real | Bloqueado | `currentIdentityProvider` lanza fuera de demo; backend real no aprobado. |
| Demo auth | Parcial | `CurrentIdentity.demo` centralizado; debe mantenerse explícito. |
| BackendBlocked auth | Parcial | Entorno bloquea backend; falta capa auth/session safe propia. |
| Token provider local | Parcial | Existe para harness local de sesiones/mensajes. |
| Token provider real | Pendiente | No existe contrato productivo aprobado. |
| Errores auth visibles | Parcial | Datasources locales devuelven `unauthenticated`; auth heredado lanza errores. |
| No fallback demo | Parcial | Repos backendBlocked separados; falta gate global para auth real. |
| Sesiones propias | Parcial | Edge/local valida ownership; UI no envía owner. |
| Entrada segura a chat_sessions | Parcial | Contrato seguro existe; falta auth/session selection. |
| Entrada segura a messages | Parcial | `sessionId` explícito existe; falta selección segura previa. |

### Riesgos clasificados

| Riesgo | Severidad | Estado / mitigación |
| --- | --- | --- |
| Mezclar demo auth con auth real | Bloqueante | Separar contratos y mantener modo explícito. |
| Activar Supabase real accidentalmente | Bloqueante | `validateForStartup` bloquea, pero futuros cambios requieren tests. |
| Tokens inseguros | Bloqueante | Token provider real pendiente. |
| Tokens hardcodeados | Bloqueante | Solo fixtures locales permitidas; prohibido producto. |
| `service_role` en cliente | Bloqueante | Prohibido; solo runtime backend/local controlado. |
| UI enviando `userId` | Bloqueante | Contratos actuales lo evitan; mantener tests. |
| UI decidiendo permisos | Bloqueante | Backend debe validar ownership/permisos. |
| Fallback demo desde error real | Alto | Mantener demo/backendBlocked separados. |
| Confundir `agentId` y `sessionId` | Bloqueante | Rutas heredadas siguen bloqueadas. |
| Reactivar auth heredado sin plan | Alto | `auth_providers` con Supabase directo queda bloqueado. |
| Reactivar chat heredado | Alto | `ChatController`/`SupabaseChatDataSource` bloqueados. |

### Recomendación

La base es suficiente para preparar el siguiente paquete, pero no para conectar
auth real. Recomendación:

```text
2B-Z-B — controller/providers auth/session safe
```

Condición: 2B-Z-B debe diseñarse o implementarse sin conectar todavía
`auth_providers` heredado a `chat_sessions`/`messages`. Si durante el plan se
detecta que el auth heredado arrastra Supabase directo inevitable, dividir antes
en:

```text
2B-Z-B1 — plan detallado token provider seguro
2B-Z-B2 — separar auth heredado de auth seguro
```

## Plan 2B-Z-B1 — token provider seguro

### Estado

2B-Z-A queda aprobado y cerrado formalmente. 2B-Z-B1 define el plan detallado
del token provider seguro que podrá alimentar en el futuro `chat_sessions`,
`messages` y auth/session safe.

No implementa código, no modifica auth, no modifica providers, no modifica
token providers, no modifica rutas, no conecta remoto, no usa producción y no
trata datos reales.

### Token providers actuales

Existen dos interfaces locales equivalentes:

- `lib/features/chat_sessions/data/local/local_session_token_provider.dart`;
- `lib/features/chat_messages/data/local/local_session_token_provider.dart`.

Interfaz actual:

```text
Future<String?> readLocalSessionToken()
```

Consumidores:

- `LocalHttpOwnChatSessionsDataSource`;
- `LocalHttpOwnChatMessagesDataSource`;
- harness/tests locales.

Comportamiento verificado:

- si `LocalOnlyHostPolicy` bloquea el host, el datasource devuelve
  `backendBlocked` antes de leer token o ejecutar transporte;
- si el token falta, devuelve `unauthenticated`;
- si en `chat_sessions` el token existe pero está vacío, devuelve
  `invalidSession`;
- si en `messages` el token falta o está vacío, devuelve `unauthenticated`;
- si pasa la validación local, el datasource añade `Authorization: Bearer ...`
  de forma controlada;
- no son producto, no son remoto, no son credenciales reales y no deben
  versionar tokens reales.

### Contrato conceptual futuro

Contrato conceptual, no implementado:

```text
currentAuthState()
getAccessToken()
refreshIfNeeded()
clearSession()
```

Responsabilidades:

- exponer estado de sesión sin conceder permisos;
- obtener token solo desde fuente aprobada;
- refrescar token de forma controlada;
- limpiar sesión de forma segura;
- devolver errores tipados sin fallback demo.

No responsabilidades:

- decidir ownership;
- decidir permisos administrativos;
- exponer `service_role`;
- enviar `userId` como autoridad;
- mezclar perfil o roles;
- abrir remoto por sí mismo.

### Estados auth/token

Estados mínimos propuestos:

| Estado | Significado | Resultado esperado |
| --- | --- | --- |
| `demo` | Modo demo explícito. | No produce token real. |
| `authenticated` | Sesión válida con token disponible. | Permite request controlada. |
| `unauthenticated` | No hay sesión de usuario. | Error visible; sin transporte si aplica. |
| `expired` | Token caducado o cercano a caducar. | Intentar refresh controlado. |
| `refreshFailed` | Refresh no recupera sesión válida. | Error visible y clear si procede. |
| `backendBlocked` | Entorno no autoriza backend. | Bloqueo antes de red/token real. |
| `misconfigured` | Configuración incompleta/incoherente. | Error visible; no demo fallback. |

### Reglas de seguridad

- no `service_role` en cliente;
- no tokens hardcodeados;
- no tokens versionados;
- no logs con tokens completos;
- no fallback demo desde error real;
- no Supabase directo desde UI;
- no Supabase directo desde widgets/providers de presentación;
- no remoto sin `AppEnvironment` aprobado;
- no producción sin aprobación explícita;
- errores visibles y tipados;
- refresh controlado, finito y observable;
- clear seguro;
- tests anti-remoto, anti-token-hardcoded y anti-log de secretos.

### Relación con AppEnvironment

Reglas:

- `environment.isDemo`: solo demo explícito; no token real;
- `environment.usesBackend`: no basta para activar backend si
  `validateForStartup` no lo aprueba;
- backend real: solo con entorno, auth/RLS y paquete aprobados;
- producción: paquete separado y aprobación explícita;
- `kReleaseMode`: no debe permitir rutas/dev flows ni tokens locales;
- errores de entorno producen `backendBlocked` o `misconfigured`, nunca demo.

### Relación con CurrentIdentity

El token provider puede alimentar un futuro estado de sesión, pero identidad no
concede permisos.

Relación conceptual:

```text
demo -> CurrentIdentity.demo
authenticated -> CurrentIdentity.authenticated
backendBlocked/misconfigured -> sin identidad autenticada usable
```

No se añade `CurrentIdentity.backendBlocked` todavía; si se necesita, debe
aprobarse en paquete separado como estado de sesión, no como identidad de
usuario.

Reglas:

- identidad no concede permisos;
- perfil sigue separado;
- roles/permisos quedan fuera del token provider;
- UI no usa `userId` como autoridad;
- backend valida ownership.

### Relación con chat_sessions y messages

Flujo futuro:

```text
chat_sessions datasource/repository -> token provider seguro -> Authorization
messages datasource/repository -> token provider seguro -> Authorization
```

Reglas:

- UI no pasa token;
- UI no pasa `userId`;
- UI no pasa `ownerUserId`;
- UI no decide permisos;
- datasource añade `Authorization` de forma controlada;
- backend valida ownership;
- errores auth son visibles;
- error real no se convierte en demo.

### Relación con auth heredado

Regla firme:

```text
auth heredado con Supabase directo no se conecta al flujo nuevo
```

`auth_providers` heredado expone `Supabase.instance.client`, por tanto no puede
ser usado por `chat_sessions`, `messages` o routing seguro sin frontera nueva.

### Opciones frente a auth heredado

| Opción | Descripción | Ventaja | Riesgo | Recomendación |
| --- | --- | --- | --- | --- |
| A — Auth/session safe paralelo | Nuevo flujo limpio sin tocar auth heredado. | Menor riesgo de contaminación. | Duplica temporalmente conceptos. | Recomendada. |
| B — Encapsular auth heredado | Reusar auth si queda detrás de frontera segura. | Menos duplicación. | Puede arrastrar Supabase directo. | Solo con pruebas estrictas. |
| C — Refactor auth heredado | Rehacer auth existente. | Limpieza futura. | Alto riesgo y mucha superficie. | No ahora. |

### Riesgos clasificados

| Riesgo | Severidad | Mitigación |
| --- | --- | --- |
| `service_role` en cliente | Bloqueante | Tests y prohibición explícita. |
| Token hardcodeado | Bloqueante | Fuentes inyectadas y secrets fuera del repo. |
| Token en logs | Bloqueante | Logs sanitizados. |
| Fallback demo desde error real | Bloqueante | Errores tipados; demo solo explícito. |
| Supabase real accidental | Bloqueante | `AppEnvironment` + host policy + tests. |
| Producción accidental | Bloqueante | Paquete separado y gates release. |
| Auth heredado acoplado | Alto | Flujo paralelo o frontera segura. |
| UI decide ownership | Alto | Backend valida ownership. |
| UI envía `userId` | Alto | Contratos públicos sin autoridad. |
| Token expirado tratado como éxito | Alto | Estado `expired` y refresh controlado. |
| Refresh infinito | Medio | Límite de reintentos y estado `refreshFailed`. |
| Errores auth ocultos | Alto | UI debe mostrar errores tipados. |

### Recomendación

Cerrar primero el contrato de token provider seguro:

```text
2B-Z-C1 — contrato token provider seguro
```

Después preparar:

```text
2B-Z-C2 — controller/providers auth/session safe
```

No conectar auth heredado todavía. Si se decide reutilizarlo, antes debe pasar
por una frontera segura que impida Supabase directo en UI/providers de
presentación y que preserve `backendBlocked`, errores visibles y no fallback
demo.

## Implementación 2B-Z-C1 — contrato token provider seguro

### Estado

2B-Z-B1 queda aprobado y cerrado formalmente. 2B-Z-C1 implementa el contrato
Dart puro del token provider seguro en `lib/core/auth/session/`.

No conecta auth real, no conecta auth heredado, no importa Supabase, no usa
HTTP/Dio, no ejecuta refresh real, no usa remoto, no usa producción y no trata
datos reales.

### Archivos creados

- `secure_session_auth_state.dart`;
- `secure_session_token_result.dart`;
- `secure_session_token_provider.dart`;
- `secure_session.dart`;
- tests unitarios de contrato e implementaciones seguras;
- test arquitectónico de aislamiento.

### Contrato creado

Interfaz implementada:

```text
currentAuthState()
getAccessToken()
refreshIfNeeded()
clearSession()
```

### Estados auth/token

Estados de auth:

```text
demo
authenticated
unauthenticated
expired
refreshFailed
backendBlocked
misconfigured
```

Estados de token:

```text
success
unauthenticated
expired
refreshFailed
backendBlocked
misconfigured
demo
```

`success` exige token no vacío. Los estados `demo`, `backendBlocked`,
`misconfigured`, `unauthenticated`, `expired` y `refreshFailed` no transportan
token.

### Errores tipados

Errores definidos:

```text
missingSession
expiredSession
refreshFailed
backendBlocked
misconfiguredEnvironment
demoModeNoRealToken
unexpected
```

### Implementaciones seguras

Implementaciones explícitas:

- `DemoSecureSessionTokenProvider`;
- `BackendBlockedSecureSessionTokenProvider`;
- `UnauthenticatedSecureSessionTokenProvider`.

Ninguna produce token real. `clearSession` no genera sesión ni token.

### Relación con CurrentIdentity

No se modificó `CurrentIdentity`. El contrato mantiene la relación conceptual:

```text
demo -> CurrentIdentity.demo
authenticated -> CurrentIdentity.authenticated futuro
backendBlocked/misconfigured -> sin identidad autenticada usable
```

`subjectId` en `SecureSessionAuthState.authenticated` no concede ownership ni
permisos; el backend sigue validando autorización.

### Relación con AppEnvironment

El contrato no activa backend. Permite que una implementación futura respete:

- demo sin token real;
- backend bloqueado fuera de entorno aprobado;
- producción como paquete separado;
- errores de entorno visibles y tipados.

### Relación futura con chat_sessions/messages

No se modificaron `chat_sessions` ni `messages`. La relación futura sigue
siendo:

```text
datasource/repository -> SecureSessionTokenProvider -> Authorization controlado
```

La UI no debe pasar token, `userId`, `ownerUserId` ni permisos.

### Reglas de seguridad verificadas

El test arquitectónico bloquea en `core/auth/session`:

- Supabase;
- `Supabase.instance`;
- Dio/HTTP;
- Edge Function paths;
- `service_role`;
- tokens hardcodeados;
- auth heredado;
- chat heredado;
- presentación de `chat_sessions`/`chat_messages`;
- Stasis Engine;
- MCP;
- streaming.

### Riesgos residuales

- No existe implementación real de token provider.
- No existe refresh real.
- No hay conexión con auth real.
- No hay wiring hacia `chat_sessions` o `messages`.
- Auth heredado sigue bloqueado por Supabase directo.

### Siguiente paso recomendado

Preparar `2B-Z-C2 — controller/providers auth/session safe`, o dividir antes
una frontera de auth heredado si se decide reutilizar algo de `features/auth`.

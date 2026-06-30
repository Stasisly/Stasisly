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
2B-Z-C2 controller/providers auth/session safe queda implementado y verificado
el 2026-06-28 como capa local-safe de estado, controller y providers
overrideables; no expone tokens en estado público, no importa auth heredado, no
usa Supabase/HTTP/Dio, no conecta remoto, producción, `chat_sessions` ni
`messages`, y conserva errores auth visibles sin fallback demo. 2B-Z-C2 queda
aprobado y cerrado formalmente el 2026-06-28. 2B-Z-D1 plan de frontera auth
real / auth heredado queda preparado documentalmente el 2026-06-28, sin
implementar código ni conectar auth real, auth heredado, Supabase, remoto,
producción, `chat_sessions` o `messages`.
2B-Z-D1 queda aprobado y cerrado formalmente el 2026-06-28. 2B-Z-D2 contrato
de implementación auth real segura queda implementado y verificado el
2026-06-28 como contrato/base local-safe, sin conectar Supabase real, auth
heredado, remoto, producción, datos reales, sesiones, mensajes ni rutas.
2B-Z-D2 queda aprobado y cerrado formalmente el 2026-06-28. 2B-Z-D3 separación
auth heredado / auth seguro queda preparada el 2026-06-28 como documentación y
tests arquitectónicos, sin modificar código de producción ni conectar auth real.
2B-Z-D3 queda aprobado y cerrado formalmente el 2026-06-28. 2B-Z-E token
provider real local-safe mockable queda preparado documentalmente el 2026-06-28,
sin implementar código, sin conectar Supabase real, auth heredado, remoto,
producción, datos reales, sesiones, mensajes ni routing. 2B-Z-E queda aprobado
y cerrado formalmente el 2026-06-28. 2B-Z-E1 token provider real local-safe
mockable queda implementado y verificado el 2026-06-28 con source fake
in-memory, provider mockable, fixtures fake y tests, sin conectar Supabase real,
auth heredado, remoto, producción, datos reales, sesiones, mensajes ni routing.
2B-Z-E1 queda aprobado y cerrado formalmente el 2026-06-28. 2B-Z-F cierre
auth/session local-safe completo queda preparado documentalmente el 2026-06-28,
sin implementar código, sin conectar auth real, Supabase real, auth heredado,
sesiones, mensajes, routing, remoto, producción ni datos reales.
2B-Z-F queda aprobado y cerrado formalmente el 2026-06-28. 2B-AA plan de
conexión controlada `chat_sessions/messages` con `SecureSession` queda
preparado documentalmente y aprobado el 2026-06-28. 2B-AA1 adapter
`SecureSession -> LocalSessionTokenProvider` queda implementado y verificado
el 2026-06-28 como adapter neutro en `core/auth/session`, sin conectar
features, datasources, providers, rutas, Supabase, auth heredado, remoto,
producción ni datos reales. 2B-AA2 conexión local-safe de `chat_sessions` al
adapter queda implementada y verificada el 2026-06-28 mediante wrapper de
feature y provider overrideable; no conecta `messages`, `chat_messages`,
routing, UI, repositorio real por defecto, Supabase, auth heredado, remoto,
producción ni datos reales. 2B-AA3 conexión local-safe de
`messages/chat_messages` al adapter queda implementada y verificada el
2026-06-28 mediante wrapper de feature y provider overrideable; no conecta
`chat_sessions -> messages`, routing, UI productiva, repositorio real por
defecto, Supabase, auth heredado, remoto, producción ni datos reales. 2B-AA4
cierre documental de conexión controlada local-safe completa queda preparado el
2026-06-28; cierra formalmente 2B-AA/AA1/AA2/AA3 como local-safe,
dev-test-safe y mockable, no productivo, no remoto, sin datos reales y sin
routing productivo.

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

## Implementación 2B-Z-C2 — controller/providers auth/session safe

### Estado

2B-Z-C1 queda aprobado y cerrado formalmente. 2B-Z-C2 implementa una capa
segura de estado, controller y providers Riverpod para auth/session sobre el
contrato `SecureSessionTokenProvider`.

La implementación sigue siendo local-safe/dev-test. No conecta auth real, no
conecta auth heredado, no importa `features/auth`, no usa Supabase, no usa
HTTP/Dio, no usa Edge Functions, no usa remoto, no usa producción y no trata
datos reales.

### Archivos creados

- `lib/core/auth/session/application/secure_session_state.dart`;
- `lib/core/auth/session/application/secure_session_controller.dart`;
- `lib/core/auth/session/providers/secure_session_providers.dart`;
- tests unitarios de state/controller/providers;
- refuerzo del test arquitectónico de `core/auth/session`.

### State público

`SecureSessionState` expone:

```text
authState
isChecking
isRefreshing
isClearing
lastError
flags derivados
```

El estado público no contiene `accessToken`, token, refresh token ni secreto. El
`subjectId` conceptual de `SecureSessionAuthState.authenticated` no concede
ownership ni permisos.

### Controller

`SecureSessionController` expone:

```text
checkCurrentSession()
refreshIfNeeded()
clearSession()
requireAuthenticated()
```

El controller usa únicamente `SecureSessionTokenProvider`. Los errores de
sesión se mantienen tipados y visibles; `backendBlocked`, `misconfigured`,
`expired` y `refreshFailed` no se convierten en demo.

### Providers

Providers creados:

```text
secureSessionTokenProvider
demoSecureSessionTokenProvider
backendBlockedSecureSessionTokenProvider
unauthenticatedSecureSessionTokenProvider
secureSessionControllerProvider
secureSessionStateProvider
```

Los providers son overrideables en tests. Demo se selecciona solo por entorno
demo explícito u override explícito. Backend real y producción continúan
devolviendo `BackendBlockedSecureSessionTokenProvider` hasta aprobación futura.

### Relación con AppEnvironment

`AppEnvironment.demo` produce provider demo explícito. `backendReal` y
`production` producen provider bloqueado. Un error de auth/session o de entorno
no produce fallback demo.

### Relación futura con chat_sessions/messages

No se modificaron `chat_sessions` ni `messages`. La relación futura permitida
queda limitada a:

```text
datasource/repository -> SecureSessionTokenProvider -> Authorization controlado
```

La UI no debe pasar token, `userId`, `ownerUserId`, `role`, permisos ni claims.

### Tests y gates

Los tests cubren:

- estado inicial seguro y flags derivados;
- demo, authenticated conceptual, unauthenticated, expired, refreshFailed,
  backendBlocked y misconfigured;
- `checkCurrentSession`, `refreshIfNeeded`, `clearSession` y
  `requireAuthenticated`;
- providers demo/backendBlocked/unauthenticated explícitos;
- override con `ProviderContainer`;
- errores visibles y ausencia de fallback demo;
- estado público sin token;
- bloqueo arquitectónico de Supabase, HTTP/Dio, Edge paths, `service_role`,
  tokens hardcodeados, auth heredado y chat heredado.

### Riesgos residuales

- No existe implementación real de token provider.
- No existe refresh real.
- No existe conexión revisada con auth heredado.
- No hay wiring hacia `chat_sessions` o `messages`.
- Routing productivo por `sessionId` sigue bloqueado.

### Siguiente paso recomendado

Preparar un paquete separado para decidir la frontera con auth heredado o el
adaptador auth real futuro, sin conectar todavía UI, `chat_sessions`,
`messages`, rutas productivas, remoto ni producción.

## Plan 2B-Z-D1 — frontera auth real / auth heredado

### Estado

2B-Z-C2 queda aprobado y cerrado formalmente. La capa auth/session safe existe,
pero sigue siendo local-safe/dev-test. Auth real, auth heredado, Supabase
remoto, datos reales, `chat_sessions`, `messages` y routing productivo siguen
bloqueados.

### Auth heredado inspeccionado

Archivos inspeccionados en solo lectura:

- `lib/features/auth/presentation/viewmodels/auth_providers.dart`;
- `lib/features/auth/data/datasources/supabase_auth_datasource.dart`;
- `lib/features/auth/data/repositories/auth_repository_impl.dart`;
- `lib/features/auth/domain/repositories/auth_repository.dart`;
- `lib/features/auth/domain/usecases/sign_in_usecase.dart`;
- `lib/features/auth/domain/usecases/sign_up_usecase.dart`;
- `lib/features/auth/domain/usecases/sign_out_usecase.dart`;
- `lib/features/auth/data/models/user_model.dart`;
- `lib/features/auth/domain/entities/user_entity.dart`;
- `lib/features/auth/domain/entities/user_profile.dart`;
- `lib/features/auth/presentation/pages/login_page.dart`;
- `lib/features/auth/presentation/pages/register_page.dart`;
- `lib/core/config/routes.dart`;
- `lib/main.dart`.

Hallazgos:

- `auth_providers.dart` importa `supabase_flutter` y expone
  `supabaseClientProvider` con `Supabase.instance.client`.
- `authDataSourceProvider` crea `SupabaseAuthDataSource` desde presentation.
- `AuthController` heredado vive en presentation y usa use cases heredados.
- `LoginPage` y `RegisterPage` llaman directamente
  `authControllerProvider.notifier`.
- `routes.dart` importa `auth_providers.dart` y observa `authControllerProvider`
  cuando `environment.usesBackend`.
- `main.dart` inicializa Supabase si `environment.usesBackend`.
- `SupabaseAuthDataSource` usa `_supabase.auth.onAuthStateChange`,
  `currentUser`, `signInWithPassword`, `signUp` y `signOut`.
- `UserModel.fromSupabase` ya no lee roles ni `userMetadata`; mapea solo `id` y
  `email`.
- `UserEntity` extiende `CurrentIdentity` sin perfil, rol ni permisos.
- `UserProfile` está separado y documenta que perfil no concede autoridad.

Piezas potencialmente reutilizables:

- `UserEntity` como identidad conceptual sin permisos.
- `UserProfile` como perfil no autoritativo.
- Use cases de sign in/sign up/sign out si se colocan detrás de una frontera
  segura sin Supabase directo en presentation.
- `AuthRepository` como contrato histórico de operaciones, solo si se adapta a
  errores tipados y no expone tokens ni autorización.

Piezas bloqueadas para el flujo nuevo:

- `supabaseClientProvider`;
- `authDataSourceProvider`;
- `authRepositoryProvider`;
- `authControllerProvider`;
- `SupabaseAuthDataSource` usado directamente por providers de presentation;
- `LoginPage`/`RegisterPage` conectados a `AuthController` heredado;
- redirect de `routes.dart` basado en `authControllerProvider` para el flujo
  nuevo.

### Flujo seguro nuevo inspeccionado

Archivos inspeccionados:

- `lib/core/auth/session/secure_session_token_provider.dart`;
- `lib/core/auth/session/secure_session_token_result.dart`;
- `lib/core/auth/session/secure_session_auth_state.dart`;
- `lib/core/auth/session/application/secure_session_state.dart`;
- `lib/core/auth/session/application/secure_session_controller.dart`;
- `lib/core/auth/session/providers/secure_session_providers.dart`;
- tests de `test/core/auth/session/`;
- `test/architecture/secure_session_contract_test.dart`.

Hallazgos:

- `SecureSessionState` no expone `accessToken`, refresh token ni secretos.
- `SecureSessionController` usa solo `SecureSessionTokenProvider`.
- `secureSessionTokenProvider` selecciona demo explícito en modo demo y
  `backendBlocked` en backend/producción.
- La capa nueva no importa `features/auth`, `features/chat`, Supabase,
  HTTP/Dio, Edge paths ni `service_role`.
- `demo`, `backendBlocked`, `unauthenticated`, `expired`, `refreshFailed` y
  `misconfigured` son visibles y no caen a demo silencioso.

Falta para auth real:

- implementación real revisada de `SecureSessionTokenProvider`;
- estrategia de refresh controlado;
- mapeo seguro a `CurrentIdentity` real;
- validación de entorno y bloqueo remoto/producción;
- tests anti-remoto y anti-token-log;
- rollback;
- decisión sobre reutilizar, encapsular o reemplazar auth heredado.

### Opciones de frontera

#### Opción A — Auth real seguro paralelo

Crear una implementación futura nueva de `SecureSessionTokenProvider` en
infraestructura controlada, sin consumir `auth_providers` heredado.

Ventajas:

- mantiene limpia la frontera nueva;
- evita arrastrar `Supabase.instance.client` desde presentation;
- permite errores tipados y refresh controlado desde el inicio;
- facilita tests anti-remoto, anti-token-log y override.

Riesgos:

- duplica temporalmente parte del auth;
- exige contrato preciso con Supabase/Auth antes de conectar backend real;
- requiere decidir dónde vive la infraestructura auth real.

Coste: medio.

Tests mínimos:

- provider real no se crea en demo;
- backend/producción bloqueados sin aprobación;
- token no aparece en estado público;
- errores de Supabase no producen demo;
- refresh fallido produce `refreshFailed`;
- `clearSession` no deja sesión usable;
- sin `service_role`, tokens hardcodeados ni logs de token.

#### Opción B — Encapsular auth heredado

Crear wrapper seguro alrededor de auth heredado, prohibiendo que el flujo nuevo
importe providers heredados.

Ventajas:

- reutiliza sign in/sign up/sign out existentes;
- reduce duplicación;
- podría acelerar auth real si el wrapper queda bien aislado.

Riesgos:

- alto riesgo de contaminar el flujo nuevo con `authControllerProvider`;
- `Supabase.instance.client` ya nace en presentation;
- errores actuales se transforman en excepciones genéricas;
- puede reactivar rutas/login/register heredados antes de tiempo.

Coste: medio-alto.

Tests mínimos:

- el wrapper no importa `auth_providers.dart`;
- `features/auth/presentation` no aparece en `core/auth/session`;
- no hay `Supabase.instance.client` fuera de infraestructura;
- errores heredados se traducen a `SecureSessionError`;
- no fallback demo.

#### Opción C — Refactor auth heredado primero

Reestructurar auth heredado antes de conectarlo al flujo seguro.

Ventajas:

- reduce deuda estructural;
- puede dejar una arquitectura auth única y más coherente;
- elimina Supabase directo en presentation.

Riesgos:

- mayor blast radius;
- toca rutas, login/register, providers y posiblemente generación;
- puede mezclar estabilización con UX/auth real antes de RLS completo.

Coste: alto.

Tests mínimos:

- regresión de login/register;
- gates de arquitectura por capas;
- rutas no conectan producto real sin aprobación;
- sin remoto/producción por accidente.

#### Opción D — Mantener auth real bloqueado

No avanzar auth real y trabajar otro bloque local-safe.

Ventajas:

- riesgo mínimo inmediato;
- preserva separación actual;
- permite madurar RLS/backend antes de usuario real.

Riesgos:

- retrasa entrada segura real al flujo;
- no desbloquea `chat_sessions -> messages` con auth real;
- puede acumular deuda de auth heredado.

Coste de oportunidad: medio.

### Recomendación

Recomendación principal: **Opción A**.

Crear una implementación auth real segura paralela o infraestructura nueva
controlada para `SecureSessionTokenProvider`, sin conectar
`auth_providers.dart` heredado al flujo nuevo.

No se recomienda conectar `AuthController` heredado, `auth_providers.dart` ni
`SupabaseAuthDataSource` al flujo nuevo sin un paquete separado de aislamiento
y pruebas estrictas. Tampoco se recomienda refactorizar todo auth heredado en el
mismo frente: el coste y el riesgo son demasiado altos para el estado actual.

### Gates antes de auth real

Antes de implementar auth real debe existir aprobación explícita de:

- paquete exacto;
- archivos exactos;
- entorno exacto;
- rollback;
- contrato de token provider real.

Gates técnicos mínimos:

- sin `service_role` en cliente;
- sin tokens hardcodeados;
- sin tokens en logs;
- sin `Supabase.instance.client` en UI/presentation;
- sin `auth_providers.dart` heredado en flujo nuevo;
- sin fallback demo desde error real;
- sin producción;
- sin datos reales;
- `AppEnvironment` validado;
- `validateForStartup` respetado;
- token provider real encapsulado;
- refresh controlado;
- clear seguro;
- errores visibles y tipados;
- tests unitarios;
- tests de providers;
- tests arquitectónicos;
- tests anti-remoto;
- tests anti-token-log.

### Gates antes de conectar chat_sessions/messages

Antes de conectar `chat_sessions` o `messages` a auth real:

- `SecureSessionTokenProvider` real aprobado;
- errores auth visibles;
- `backendBlocked` y `misconfigured` explícitos;
- UI no pasa token;
- UI no pasa `userId`;
- UI no decide ownership;
- datasource añade `Authorization`;
- backend valida ownership;
- sin writes directos desde Flutter;
- sin Supabase directo desde UI;
- tests de integración local;
- tests contract;
- rollback definido.

### Riesgos clasificados

| Riesgo | Severidad | Mitigación |
|---|---:|---|
| `Supabase.instance.client` entrando por providers heredados | Bloqueante | No importar `auth_providers.dart` en flujo nuevo; gate arquitectónico. |
| `service_role` en cliente | Bloqueante | Búsqueda estática y revisión AppSec. |
| Token hardcodeado/versionado | Bloqueante | Tests anti-token y revisión de secretos. |
| Token loggeado | Bloqueante | Safe logging y tests de ausencia de token. |
| Producción accidental | Bloqueante | `AppEnvironment`, `validateForStartup`, aprobación explícita. |
| Datos reales antes de aprobación | Bloqueante | Backend real y producción bloqueados. |
| Fallback demo desde error real | Alto | Errores tipados y tests de no fallback. |
| Auth heredado acoplado al flujo nuevo | Alto | Opción A y gate contra imports heredados. |
| UI enviando `userId` | Alto | Contratos públicos allowlist-only. |
| UI decidiendo ownership | Alto | Ownership solo backend/RLS/functions. |
| Refresh infinito | Medio | Límite de reintentos, estado `refreshFailed`. |
| Errores auth ocultos | Medio | Estado público con `lastError` tipado. |

### Siguiente paquete propuesto

Opción recomendada:

```text
2B-Z-D2 — contrato implementación auth real segura
```

Objetivo de D2: definir contrato exacto, ubicación, estados, errores,
dependencias permitidas, tests y rollback de una implementación real futura de
`SecureSessionTokenProvider`, sin implementarla todavía o con implementación
posterior separada.

Alternativas:

- `2B-Z-D3 — separación auth heredado/auth seguro`;
- `2B-Z-E — token provider real local-safe mockable`;
- conexión controlada `chat_sessions/messages` con SecureSession, solo en
  paquete futuro con nombre nuevo y aprobación explícita;
- otro bloque técnico;
- otra área de Stasisly.

## Implementación 2B-Z-D2 — contrato implementación auth real segura

### Estado

2B-Z-D1 queda aprobado y cerrado formalmente. 2B-Z-D2 crea la base contractual
para una implementación futura de auth real segura sin conectar ninguna fuente
real.

No conecta Supabase real, no usa `Supabase.instance.client`, no importa
`supabase_flutter`, no importa `features/auth`, no usa `auth_providers`, no usa
`AuthController`, no usa `SupabaseAuthDataSource`, no lee sesión real, no hace
login real, no hace refresh real, no emite tokens reales hardcodeados, no usa
`service_role`, no conecta remoto, no usa producción y no trata datos reales.

### Archivos creados

- `lib/core/auth/session/real/secure_real_session_source.dart`;
- `lib/core/auth/session/real/secure_real_session_snapshot.dart`;
- `lib/core/auth/session/real/secure_real_session_config.dart`;
- `lib/core/auth/session/real/secure_real_session_guard.dart`;
- `lib/core/auth/session/real/secure_real_session_error.dart`;
- `lib/core/auth/session/real/base_secure_real_session_token_provider.dart`;
- `lib/core/auth/session/real/secure_real_session.dart`;
- `test/core/auth/session/real/secure_real_session_contract_test.dart`;
- refuerzo de `test/architecture/secure_session_contract_test.dart`.

### Contrato de fuente real

`SecureRealSessionSource` define:

```text
readCurrentSession()
refreshSession()
clearSession()
```

Es una interfaz pura. No depende de Supabase, auth heredado, red, rutas ni
features.

### Snapshot de sesión real

`SecureRealSessionSnapshot` representa:

```text
authenticated
unauthenticated
expired
refreshFailed
misconfigured
backendBlocked
```

`authenticated` exige token no vacío y `subjectId` no vacío. Los estados no
exitosos no contienen token. El token, cuando exista en una implementación
futura, es interno/en memoria y nunca se copia al estado público
`SecureSessionState`.

### Configuración segura

`SecureRealSessionConfig` representa:

```text
runtime
backendActivationApproved
productionActivationApproved
hasRequiredBackendConfiguration
```

No contiene secretos, tokens, anon keys ni `service_role`.

### Guard anti-remoto / anti-producción

`SecureRealSessionGuard` devuelve:

```text
allowed
backendBlocked
productionBlocked
misconfigured
```

Reglas:

- demo bloquea como `backendBlocked`;
- backend real sin aprobación bloquea como `backendBlocked`;
- producción sin aprobación bloquea como `productionBlocked`;
- configuración incompleta bloquea como `misconfigured`;
- ningún bloqueo cae a demo.

### Adaptador futuro hacia SecureSessionTokenProvider

`BaseSecureRealSessionTokenProvider` implementa `SecureSessionTokenProvider`
usando únicamente:

```text
SecureRealSessionSource
SecureRealSessionGuard
SecureRealSessionConfig
```

El guard se evalúa antes de tocar la fuente. Si el guard bloquea, no se llama a
la fuente. Los snapshots se traducen a `SecureSessionAuthState` y
`SecureSessionTokenResult` sin fallback demo.

No existe implementación real tipo `SupabaseSecureSessionTokenProvider` ni
`AuthRepositorySecureSessionTokenProvider`.

### Relación con SecureSession

D2 solo se integra con:

- `SecureSessionTokenProvider`;
- `SecureSessionAuthState`;
- `SecureSessionTokenResult`;
- `SecureSessionError`.

No modifica el contrato público existente salvo exportar la nueva frontera
`real/`.

### Relación con auth heredado

La nueva capa no importa:

- `features/auth`;
- `auth_providers`;
- `AuthController`;
- `SupabaseAuthDataSource`;
- `AuthRepositoryImpl`;
- `Supabase.instance.client`.

### Tests y gates

Tests añadidos:

- snapshot autenticado exige token y subject no vacíos;
- snapshots no exitosos no contienen token;
- guard bloquea demo, backend no aprobado, producción no aprobada y
  configuración incompleta;
- guard permite backend solo con configuración y aprobación explícita;
- provider base bloquea antes de fuente real;
- provider base mapea estados autenticado/no autenticado/expirado/fallo de
  refresh/backendBlocked/misconfigured;
- errores reales no producen demo;
- `clearSession` delega solo cuando el guard permite;
- gate arquitectónico bloquea Supabase, HTTP/Dio, Edge paths, `service_role`,
  auth heredado, chat heredado, Stasis Engine, MCP y streaming.

### Riesgos residuales

- No existe implementación Supabase real.
- No existe refresh real.
- No existe login real.
- No existe integración con `CurrentIdentity` real.
- No hay conexión con `chat_sessions`, `messages` ni routing.
- Backend remoto y producción siguen bloqueados.

### Siguiente paso recomendado

Revisar y aprobar 2B-Z-D2. Después, elegir entre:

- `2B-Z-D3 — separación auth heredado/auth seguro`;
- `2B-Z-E — token provider real local-safe mockable`;
- otro bloque técnico;
- otra área de Stasisly.

## Preparación 2B-Z-D3 — separación auth heredado / auth seguro

### Estado

2B-Z-D2 queda aprobado y cerrado formalmente. 2B-Z-D3 refuerza la separación
entre:

```text
features/auth = flujo heredado actual
core/auth/session = frontera segura nueva
```

Este paquete no implementa auth real, no conecta Supabase real, no modifica
login/register, no modifica rutas, no conecta sesiones ni mensajes y no toca
código de producción.

### Separación de dominios

Reglas aprobadas:

- `core/auth/session` no debe importar `features/auth`.
- `core/auth/session` no debe importar `auth_providers.dart`.
- `core/auth/session` no debe depender de `AuthController`,
  `SupabaseAuthDataSource`, `AuthRepositoryImpl` ni `Supabase.instance.client`.
- `features/chat_sessions` no debe importar auth heredado.
- `features/chat_messages` no debe importar auth heredado.
- Auth heredado no se elimina en este paquete.
- Auth heredado queda bloqueado para el flujo seguro nuevo.
- Cualquier conexión futura requiere paquete separado y aprobación explícita.

### Auth heredado clasificado

Estado verificado:

- existente;
- parcialmente funcional/conectado a Supabase desde el flujo heredado;
- no aprobado para el flujo nuevo;
- pendiente de refactor, encapsulación o sustitución futura;
- no debe ser usado por `chat_sessions`, `messages` ni `core/auth/session`.

Piezas heredadas explícitamente bloqueadas para el flujo seguro:

- `auth_providers.dart`;
- `AuthController`;
- `SupabaseAuthDataSource`;
- `AuthRepositoryImpl`;
- `Supabase.instance.client`;
- `LoginPage`/`RegisterPage` como integración real;
- redirects heredados como fuente de auth/session segura.

### Auth seguro nuevo clasificado

Estado verificado:

- existente;
- local-safe/dev-test;
- sin implementación Supabase real;
- sin login real;
- sin refresh real;
- sin remoto;
- sin producción;
- sin datos reales;
- preparado para contrato/base futura mediante `SecureRealSessionSource`,
  `SecureRealSessionGuard` y `BaseSecureRealSessionTokenProvider`.

### Gates arquitectónicos reforzados

Se añade `test/architecture/auth_safe_boundary_contract_test.dart` para validar:

- `core/auth/session` no importa auth heredado;
- `chat_sessions` no importa auth heredado;
- `chat_messages` no importa auth heredado;
- la frontera segura no contiene `Supabase.instance`, `auth.signIn`,
  `auth.signUp`, `auth.signOut`, `auth.currentUser`,
  `auth.onAuthStateChange`, `service_role`, `access_token` ni
  `refresh_token`;
- auth heredado sigue identificado como existente, pero no aprobado para el
  flujo seguro.

### Estrategia futura

#### Opción A — Mantener auth heredado aislado y crear implementación segura nueva

Recomendada. Permite que `2B-Z-E` cree un token provider real local-safe
mockable sin contaminar la frontera con providers heredados.

#### Opción B — Encapsular auth heredado detrás de SecureRealSessionSource

Solo aceptable con paquete separado, gates estrictos y sin imports de
presentation heredada en `core/auth/session`.

#### Opción C — Refactor auth heredado antes de token provider real

Más costosa y no recomendada salvo necesidad explícita, porque toca login,
register, routes, providers y potencialmente generación.

### Siguiente paso recomendado

Si D3 se aprueba, preparar:

```text
2B-Z-E — token provider real local-safe mockable
```

E debe seguir sin remoto, sin producción, sin datos reales y sin conexión con
`chat_sessions`/`messages` hasta aprobación posterior.

## Plan 2B-Z-E — token provider real local-safe mockable

### Estado

2B-Z-D3 queda aprobado y cerrado formalmente. La separación entre auth heredado
y auth seguro queda blindada documental y arquitectónicamente:

```text
features/auth = auth heredado existente, no aprobado para flujo seguro
core/auth/session = frontera segura nueva, local-safe/dev-test
```

2B-Z-E no implementa código. Solo define cómo debería implementarse en un
paquete posterior un provider real local-safe y mockable para
`SecureSessionTokenProvider`.

### Definición

`token provider real local-safe mockable` significa:

- **real:** implementa el contrato real `SecureSessionTokenProvider` usando la
  base `BaseSecureRealSessionTokenProvider`, no un provider demo ni un stub de
  éxito.
- **local-safe:** opera solo con configuración local/dev controlada; no usa
  Supabase remoto, producción, datos reales ni credenciales reales.
- **mockable:** recibe una fuente `SecureRealSessionSource` fake o controlada,
  inyectable en tests, sin acoplarse a SDKs reales.
- **no productivo:** no desbloquea login real, refresh real, backend remoto,
  rutas productivas, `chat_sessions`, `messages` ni usuarios reales.

Este paquete futuro no autoriza:

- Supabase remoto;
- producción;
- datos reales;
- tokens reales versionados;
- `service_role` en cliente;
- auth heredado;
- login/register heredado;
- routing productivo.

### Arquitectura conceptual

Piezas existentes que debe reutilizar la implementación futura:

- `SecureRealSessionSource`;
- `SecureRealSessionSnapshot`;
- `SecureRealSessionConfig`;
- `SecureRealSessionGuard`;
- `BaseSecureRealSessionTokenProvider`;
- `SecureSessionTokenProvider`.

Nombre recomendado para el paquete de implementación futura:

```text
MockableSecureRealSessionTokenProvider
```

La composición conceptual será:

```text
SecureRealSessionConfig local-safe
        ↓
SecureRealSessionGuard
        ↓
SecureRealSessionSource fake/mockable
        ↓
BaseSecureRealSessionTokenProvider
        ↓
SecureSessionTokenProvider
```

Regla crítica: el guard debe evaluarse antes de llamar a la source. Si el guard
bloquea backend o producción, la source no debe ejecutarse.

### Fuentes permitidas y bloqueadas

| Fuente | Estado para E1 | Motivo |
| --- | --- | --- |
| Fake in-memory source | Recomendada | Permite tests deterministas sin red, secretos ni datos reales. |
| Local harness source | Permitida con cautela | Válida solo si no transporta secretos reales y queda aislada de remoto. |
| Supabase source real | Bloqueada | Requiere paquete separado, RLS revisada, configuración segura y aprobación. |
| Auth heredado wrapped | Bloqueada | Puede arrastrar `features/auth`, providers heredados y Supabase directo. |

### Estados y transiciones

El provider futuro debe mapear exactamente:

| Source snapshot | Resultado esperado |
| --- | --- |
| `authenticated` con token fake no real y subject válido | `success` / `authenticated` |
| `unauthenticated` | `unauthenticated` |
| `expired` | `expired` |
| `refreshFailed` | `refreshFailed` |
| `misconfigured` | `misconfigured` |
| `backendBlocked` | `backendBlocked` |
| guard `backendBlocked` | `backendBlocked`, sin llamar a source |
| guard `productionBlocked` | `misconfigured`, sin llamar a source |

Reglas negativas:

- demo no viene de error real;
- `backendBlocked` no se convierte en demo;
- `misconfigured` no se convierte en demo;
- `expired` no se trata como authenticated;
- `refreshFailed` no se trata como authenticated.

### Reglas de seguridad

Reglas obligatorias para E1:

- sin `service_role` cliente;
- sin tokens hardcodeados;
- sin tokens versionados;
- sin logs de token;
- sin `Supabase.instance.client`;
- sin `features/auth`;
- sin `auth_providers`;
- sin HTTP/Dio;
- sin Edge paths;
- sin fallback demo desde error real;
- sin producción;
- sin datos reales;
- guard antes que source;
- errores visibles;
- `clearSession` seguro;
- refresh controlado.

### Tests requeridos para futura implementación

Tests mínimos de E1:

- authenticated fake devuelve success con token fake no real;
- unauthenticated fake devuelve `unauthenticated`;
- expired fake devuelve `expired`;
- refreshFailed fake devuelve `refreshFailed`;
- misconfigured fake devuelve `misconfigured`;
- backendBlocked guard bloquea antes de source;
- productionBlocked guard bloquea antes de source;
- source no se llama si guard bloquea;
- `clearSession` delega y no filtra token;
- no fallback demo;
- no logs ni tokens hardcodeados;
- tests arquitectónicos sin Supabase, auth heredado, HTTP/Dio ni Edge paths.

### Relación futura con chat_sessions/messages

Incluso con un token provider mockable:

- no se conecta todavía `chat_sessions`;
- no se conecta todavía `messages`;
- no se conecta todavía `chat_messages`;
- no se conecta routing productivo.

El flujo futuro permitido en paquete posterior será:

```text
repository/datasource -> SecureSessionTokenProvider -> Authorization controlado
```

Nunca:

```text
UI -> token
UI -> userId
UI -> ownerUserId
UI -> permisos
```

### Riesgos clasificados

| Riesgo | Severidad | Control |
| --- | --- | --- |
| Mock con token parecido a real | Alto | Usar prefijo inequívoco de test y no versionar secretos. |
| Token fake en logs | Alto | Tests y revisión de logs; no imprimir token. |
| Source ejecutada pese a guard bloqueante | Bloqueante | Test de contador/spy que exige cero llamadas. |
| Fallback demo desde error real | Alto | Tests de errores visibles y estados tipados. |
| Auth heredado importado por accidente | Alto | Gate arquitectónico D3. |
| Supabase real accidental | Alto | Gate sin Supabase/HTTP y source fake inicial. |
| Producción accidental | Bloqueante | Guard `productionBlocked` antes de source. |
| UI accediendo a token | Alto | Token no entra en estado público; solo datasource autorizado lo solicitará. |
| `chat_sessions/messages` conectados demasiado pronto | Medio | Mantener conexión fuera de alcance hasta paquete posterior. |

### Siguiente paquete propuesto

Siguiente paquete recomendado:

```text
2B-Z-E1 — implementar token provider real local-safe mockable
```

Si antes de implementarlo se detecta que los guards actuales no cubren un caso
crítico, dividir en:

```text
2B-Z-E0 — reforzar guards/arquitectura antes de implementar
```

## Implementación 2B-Z-E1 — token provider real local-safe mockable

### Estado

2B-Z-E queda aprobado y cerrado formalmente. 2B-Z-E1 implementa una primera
versión local-safe y mockable del token provider real sobre la frontera segura
existente.

No conecta Supabase real, auth heredado, remoto, producción, datos reales,
`chat_sessions`, `messages`, `chat_messages` ni routing.

### Archivos implementados

- `lib/core/auth/session/real/secure_real_session_fixtures.dart`;
- `lib/core/auth/session/real/mockable_secure_real_session_source.dart`;
- `lib/core/auth/session/real/mockable_secure_real_session_token_provider.dart`;
- export en `lib/core/auth/session/real/secure_real_session.dart`;
- tests en `test/core/auth/session/real/mockable_secure_real_session_test.dart`;
- refuerzo en `test/architecture/secure_session_contract_test.dart`.

### Source fake/in-memory

`MockableSecureRealSessionSource` implementa `SecureRealSessionSource` y permite
simular:

- authenticated;
- unauthenticated;
- expired;
- refreshFailed;
- backendBlocked;
- misconfigured;
- refreshSession;
- clearSession.

La source mantiene contadores de llamadas para verificar que el guard bloquea
antes de tocarla. `clearSession` deja la sesión en `unauthenticated`.

### Provider mockable

`MockableSecureRealSessionTokenProvider` extiende
`BaseSecureRealSessionTokenProvider` y recibe:

- `SecureRealSessionSource`;
- `SecureRealSessionConfig`;
- `SecureRealSessionGuard`.

Por defecto usa `SecureRealSessionFixtures.localSafeConfig`, que solo permite
el flujo local-safe aprobado para tests/dev.

### Fixtures fake

`SecureRealSessionFixtures` define valores inequívocamente falsos:

```text
fake-local-subject
fake-user@local.test
fake-local-session-token
fake-local-refreshed-session-token
```

No se usan tokens reales, usuarios reales, datos reales, secretos reales ni
formato de credencial productiva.

### Guard antes que source

Los tests verifican que:

- backend no aprobado bloquea antes de source;
- producción no aprobada bloquea antes de source;
- configuración incompleta bloquea antes de source;
- si el guard bloquea, `readCurrentSession` y `refreshSession` no se ejecutan.

### Relación con SecureSession

El provider implementa `SecureSessionTokenProvider` a través de la base real.
Puede usarse como override de `secureSessionTokenProvider` en tests.

`SecureSessionState` no expone token. La UI no recibe token, `userId`,
`ownerUserId` ni permisos.

### Relación con chat_sessions/messages

No se conecta todavía:

- `chat_sessions`;
- `messages`;
- `chat_messages`;
- routing productivo;
- `/chat/:id`;
- `/orchestrator/chat`.

El flujo futuro permitido sigue siendo:

```text
repository/datasource -> SecureSessionTokenProvider -> Authorization controlado
```

Nunca:

```text
UI -> token
UI -> userId
UI -> ownerUserId
UI -> permisos
```

### Tests añadidos

Tests de source fake:

- authenticated devuelve snapshot autenticado con token fake;
- subjectId vacío se rechaza;
- estados no exitosos no contienen token;
- refresh cambia a token fake refrescado;
- clear limpia estado sin exponer token.

Tests de provider:

- authenticated produce `success`;
- token vacío no produce éxito;
- unauthenticated/expired/refreshFailed/backendBlocked/misconfigured se mapean
  sin fallback demo;
- refresh delega;
- clear delega;
- error real no produce demo.

Tests de integración con providers existentes:

- `secureSessionTokenProvider` puede overridearse con el provider mockable;
- `SecureSessionState` queda autenticado sin exponer token público.

Tests arquitectónicos:

- el provider mockable queda local-safe;
- no importa Supabase;
- no importa auth heredado;
- no usa HTTP/Dio;
- no usa Edge paths;
- no usa `service_role`;
- no conecta chat heredado, Stasis Engine, MCP ni streaming.

### Riesgos residuales

- No existe auth real productivo.
- No existe source Supabase real.
- No existe refresh real contra backend.
- No existe conexión con `chat_sessions/messages`.
- El token fake sirve solo para tests/dev; no debe cruzar a remoto.

### Siguiente paso recomendado

Revisar y aprobar 2B-Z-E1. Después, preparar un paquete separado para decidir
si procede:

- wiring local-safe del token provider hacia datasources locales ya existentes;
- o auditoría/refuerzo previo de boundaries;
- o continuar con otro frente técnico.

## Cierre 2B-Z-F — auth/session local-safe completo

### Estado

2B-Z-E1 queda aprobado y cerrado formalmente. El frente `auth/session` queda
cerrado documentalmente como local-safe, dev-test-safe, mockable, no productivo,
no remoto, sin datos reales, sin Supabase real, sin auth heredado y sin
conexión a sesiones/mensajes.

Este cierre no implementa código ni autoriza wiring.

### Paquetes cerrados

Quedan cerrados formalmente:

- `2B-Z — auth/session selection seguro`;
- `2B-Z-A — auditoría auth/session actual`;
- `2B-Z-B1 — plan token provider seguro`;
- `2B-Z-C1 — contrato token provider seguro`;
- `2B-Z-C2 — controller/providers auth/session safe`;
- `2B-Z-D1 — plan frontera auth real / auth heredado`;
- `2B-Z-D2 — contrato implementación auth real segura`;
- `2B-Z-D3 — separación auth heredado / auth seguro`;
- `2B-Z-E — plan token provider real local-safe mockable`;
- `2B-Z-E1 — token provider real local-safe mockable`.

### Capacidades terminadas local-safe

- `CurrentIdentity` auditado;
- `AppEnvironment` auditado;
- frontera auth heredado/auth seguro documentada;
- `SecureSessionTokenProvider`;
- `SecureSessionAuthState`;
- `SecureSessionTokenResult`;
- `SecureSessionError`;
- `SecureSessionState`;
- `SecureSessionController`;
- providers `secureSession` overrideables;
- `SecureRealSessionSource`;
- `SecureRealSessionSnapshot`;
- `SecureRealSessionConfig`;
- `SecureRealSessionGuard`;
- `BaseSecureRealSessionTokenProvider`;
- `MockableSecureRealSessionSource`;
- `MockableSecureRealSessionTokenProvider`;
- fixtures fake/local-safe;
- tests arquitectónicos de frontera.

### Decisiones firmes

- `features/auth` es auth heredado existente.
- `core/auth/session` es frontera segura nueva.
- Auth heredado no se conecta al flujo nuevo.
- `auth_providers` no se conecta al flujo nuevo.
- `AuthController` heredado no se conecta al flujo nuevo.
- `SupabaseAuthDataSource` heredado no se conecta al flujo nuevo.
- `Supabase.instance.client` no entra en `core/auth/session`.
- `SecureSessionState` no expone token.
- Errores reales no producen fallback demo.
- El guard se ejecuta antes que la source.

### Bloqueos vigentes

Sigue bloqueado:

- auth real productivo;
- Supabase real/remoto;
- datos reales;
- producción;
- login/register reales;
- refresh real contra backend;
- auth heredado conectado;
- `chat_sessions` conectado a `SecureSession`;
- `messages` conectado a `SecureSession`;
- routing productivo;
- `/chat/:id`;
- `/orchestrator/chat`;
- IA;
- Stasis Engine;
- MCP;
- streaming;
- adjuntos.

### Gates antes de conectar chat_sessions/messages

Antes de conectar `chat_sessions` o `messages` al token provider seguro se
exige:

- aprobación explícita;
- paquete separado;
- archivo exacto aprobado;
- rollback definido;
- `SecureSessionTokenProvider` aprobado;
- errores auth visibles;
- `backendBlocked` y `misconfigured` explícitos;
- UI no pasa token;
- UI no pasa `userId`;
- UI no pasa `ownerUserId`;
- UI no decide ownership;
- datasource añade `Authorization`;
- backend valida ownership;
- sin writes directos desde Flutter;
- sin Supabase directo desde UI;
- tests unitarios;
- tests de datasource/repository;
- tests arquitectónicos;
- tests anti-fallback demo.

### Gates antes de auth real/Supabase real

Antes de conectar auth real se exige:

- aprobación explícita;
- entorno exacto aprobado;
- sin `service_role` cliente;
- sin tokens hardcodeados;
- sin tokens en logs;
- sin `auth_providers` heredado;
- sin `AuthController` heredado;
- sin `SupabaseAuthDataSource` heredado;
- sin `Supabase.instance.client` en UI/presentation;
- `AppEnvironment` validado;
- `validateForStartup` respetado;
- refresh controlado;
- clear seguro;
- errores visibles;
- rollback definido;
- tests anti-remoto;
- tests producción bloqueada;
- auditoría de seguridad.

### Relación futura con chat_sessions/messages

Flujo futuro permitido, solo con paquete posterior:

```text
repository/datasource -> SecureSessionTokenProvider -> Authorization
backend valida ownership
```

Sigue prohibido:

```text
UI -> token
UI -> userId
UI -> ownerUserId
UI -> permisos
UI -> Supabase directo
error real -> demo
```

### Recomendación final

Cerrar `auth/session` como local-safe completo antes de conectar nada.

Después del cierre, posibles siguientes rutas:

- plan conexión controlada `chat_sessions/messages` con `SecureSession`;
- plan auth real/Supabase real seguro;
- UX segura `chat_sessions -> messages`;
- backend remoto seguro;
- otro bloque técnico;
- otra área de Stasisly.

Recomendación inicial: preparar un plan de conexión controlada
`chat_sessions/messages` con `SecureSession`, sin implementarlo todavía.

## Plan 2B-AA — conexión controlada chat_sessions/messages con SecureSession

### Estado

2B-Z-F queda aprobado y cerrado formalmente. `auth/session` queda local-safe
completo y la conexión con `chat_sessions/messages` sigue bloqueada hasta
paquete separado.

2B-AA solo diseña el wiring futuro. No implementa código, no modifica
datasources, repositories, providers, rutas, navegación, tests, Supabase,
migraciones ni CI.

### Auditoría de puntos actuales de token

#### chat_sessions

Estado verificado:

- `lib/features/chat_sessions/data/local/local_session_token_provider.dart`
  define `LocalSessionTokenProvider.readLocalSessionToken()`.
- `LocalHttpOwnChatSessionsDataSource` recibe `LocalSessionTokenProvider`.
- El datasource valida `LocalOnlyHostPolicy` antes de leer token.
- Si el host está bloqueado devuelve error `backendBlocked` y no lee token.
- Si el token es `null` devuelve `unauthenticated`.
- Si el token está vacío devuelve `invalidSession`.
- Si hay token, añade header `Authorization: Bearer <token>`.
- Las operaciones expuestas son `createOwnChatSession`,
  `listOwnChatSessions` y `archiveOwnChatSession`.
- Los inputs públicos son `selectableSpecialistId`, `status`, `limit`,
  `cursor` y `sessionId`.
- No se observa `userId`, `ownerUserId` ni ownership enviado desde UI.
- `ownChatSessionsRepositoryProvider` sigue usando demo en modo demo y
  `BackendBlockedOwnChatSessionsRepository` fuera de demo.

#### chat_messages/messages

Estado verificado:

- `lib/features/chat_messages/data/local/local_session_token_provider.dart`
  define `LocalSessionTokenProvider.readLocalSessionToken()`.
- `LocalHttpOwnChatMessagesDataSource` recibe `LocalSessionTokenProvider`.
- El datasource valida `LocalOnlyHostPolicy` antes de leer token.
- Si el host está bloqueado devuelve `backendBlocked` y no lee token.
- Si el token es `null` o vacío devuelve `unauthenticated`.
- Si hay token, añade header `Authorization: Bearer <token>`.
- Las operaciones expuestas son `sendUserMessage` y `listSessionMessages`.
- Los inputs públicos son `sessionId`, `content`, `limit` y `cursor`.
- No se observa `userId`, `ownerUserId` ni ownership enviado desde UI.
- `ownChatMessagesRepositoryProvider` sigue usando demo en modo demo y
  `BackendBlockedOwnChatMessagesRepository` fuera de demo.

### Frontera común propuesta

Crear en un paquete futuro un adapter común, por ejemplo:

```text
SecureSessionToLocalSessionTokenAdapter
```

Responsabilidad del adapter:

```text
SecureSessionTokenProvider -> LocalSessionTokenProvider.readLocalSessionToken()
```

Mapeo conceptual:

- `SecureSessionTokenResult.success(token)` -> devuelve token al datasource.
- `unauthenticated` -> `null`, para que el datasource devuelva
  `unauthenticated`.
- `expired` -> `null`, o error tipado equivalente en paquete futuro.
- `refreshFailed` -> `null`, manteniendo error visible.
- `backendBlocked` -> `null` o adapter failure explícito sin demo fallback.
- `misconfigured` -> `null` o adapter failure explícito sin demo fallback.
- `demo` -> `null`; demo no produce token real.

La UI no puede acceder al token. El token solo se entrega al datasource local
autorizado para construir `Authorization`.

### Opciones de conexión

| Opción | Descripción | Ventajas | Riesgos | Decisión |
| --- | --- | --- | --- | --- |
| A — Adapter común | Crear adapter compartido desde `SecureSessionTokenProvider` hacia los contratos `LocalSessionTokenProvider` actuales. | Menor cambio, reutiliza datasources locales y mantiene frontera. | Requiere mapear errores con cuidado. | Recomendada. |
| B — Datasources dependen de SecureSession | Migrar datasources a `SecureSessionTokenProvider` directamente. | Menos adapter. | Aumenta acoplamiento y toca dos datasources. | No ahora. |
| C — No conectar todavía | Mantener demo/backendBlocked. | Riesgo mínimo. | No valida flujo end-to-end. | Válida si se pospone wiring. |
| D — Conexión productiva/remota | Usar auth real/remoto. | Acerca a producción. | Rompe restricciones actuales. | Bloqueada. |

### Recomendación

Recomendada la Opción A: adapter común, local-safe, mockable, sin tocar auth
heredado, sin Supabase real y sin remoto.

No implementar todavía.

### Gates antes de implementación futura

Antes de implementar cualquier conexión se exige:

- aprobación explícita;
- archivo exacto aprobado;
- rollback definido;
- `SecureSessionTokenProvider` aprobado;
- adapter local-safe;
- sin Supabase real;
- sin auth heredado;
- sin tokens reales;
- sin datos reales;
- sin remoto;
- sin producción;
- UI no pasa token;
- UI no pasa `userId`;
- UI no pasa `ownerUserId`;
- UI no decide ownership;
- datasource añade `Authorization`;
- backend valida ownership;
- errores auth visibles;
- `backendBlocked` explícito;
- `misconfigured` explícito;
- no fallback demo desde error real;
- tests unitarios;
- tests de datasource;
- tests de providers;
- tests arquitectónicos.

### Riesgos clasificados

| Riesgo | Severidad | Mitigación |
| --- | --- | --- |
| Token expuesto a UI | Bloqueante | Adapter no sale de data layer; tests de estado público. |
| UI enviando `userId` | Bloqueante | Contratos públicos allowlist-only. |
| UI decidiendo ownership | Bloqueante | Ownership solo backend. |
| Fallback demo desde error real | Alto | Estados tipados y tests anti-fallback. |
| Auth heredado importado accidentalmente | Alto | Gates D3 y tests arquitectónicos. |
| Supabase real accidental | Alto | Host policy local y no tocar Supabase. |
| Token fake usado como real | Alto | Nombres fake inequívocos y no remoto. |
| Conectar messages antes de auth/session estable | Medio | Secuenciar AA1/AA2/AA3. |
| Romper local-safe | Alto | Diff prohibido y tests anti-remoto. |
| Romper dev-only route | Medio | No tocar rutas en AA. |

### Relación con routing

2B-AA no autoriza routing productivo.

La ruta dev-only existente sigue siendo solo prueba:

```text
/dev/chat/session/:sessionId
```

Siguen bloqueados:

- `/chat/:id`;
- `/orchestrator/chat`;
- routing productivo;
- navegación real.

### Siguiente paquete propuesto

Secuencia recomendada:

- `2B-AA1 — implementar adapter SecureSession -> LocalSessionTokenProvider`;
- `2B-AA2 — conectar chat_sessions datasource al adapter local-safe`;
- `2B-AA3 — conectar messages datasource al adapter local-safe`;
- `2B-AB — UX segura chat_sessions -> messages`.

AA1 debe ser el siguiente paso si se aprueba el plan. No debe conectar todavía
rutas productivas, remoto, producción ni datos reales.

## Implementación 2B-AA1 — adapter SecureSession -> LocalSessionTokenProvider

### Estado

2B-AA queda aprobado y cerrado formalmente como plan de conexión controlada.
2B-AA1 implementa solo el adapter neutro común entre el contrato seguro de
sesión y el contrato local esperado por los datasources futuros.

No conecta `chat_sessions`, `messages`, `chat_messages`, datasources,
repositories, providers, UI, rutas, navegación, Supabase, auth heredado,
remoto, producción ni datos reales.

### Adapter creado

Archivo:

```text
lib/core/auth/session/adapters/secure_session_to_local_session_token_adapter.dart
```

Responsabilidad única:

```text
SecureSessionTokenProvider.getAccessToken()
-> String? para consumidores locales autorizados
```

El adapter vive en `core/auth/session`, depende solo de
`SecureSessionTokenProvider` y no implementa todavía interfaces de feature.
Esto evita que `core` importe `chat_sessions` o `chat_messages`.

### Mapeo aprobado

| Resultado de `SecureSessionTokenProvider` | Salida del adapter |
| --- | --- |
| `success(token)` con token no vacío | token |
| `unauthenticated` | `null` |
| `expired` | `null` |
| `refreshFailed` | `null` |
| `backendBlocked` | `null` |
| `misconfigured` | `null` |
| `demo` | `null` |
| excepción inesperada del provider | `null` |

El adapter no transforma errores reales en demo, no fabrica tokens, no acepta
tokens vacíos y no expone token en estado público.

### Relación con LocalSessionTokenProvider existente

Existen contratos `LocalSessionTokenProvider` locales en:

```text
lib/features/chat_sessions/data/local/
lib/features/chat_messages/data/local/
```

2B-AA1 no importa esos contratos para mantener `core/auth/session` neutro y
sin dependencia hacia features. La adaptación concreta hacia cada datasource
queda para paquetes posteriores:

- `2B-AA2`: wrapper/conexión local-safe para `chat_sessions`;
- `2B-AA3`: wrapper/conexión local-safe para `messages/chat_messages`.

### Tests añadidos

Se añaden tests unitarios del adapter para verificar:

- token fake no vacío devuelto solo en `success`;
- token vacío rechazado por el contrato;
- estados no exitosos devuelven `null`;
- errores del provider devuelven `null` sin fallback demo;
- `toString` del adapter no expone token.

Se añade test arquitectónico para verificar que el adapter:

- no importa `features/auth`;
- no importa `features/chat`, `features/chat_sessions` ni
  `features/chat_messages`;
- no importa Supabase, HTTP/Dio, UI, rutas, MCP, Stasis Engine ni streaming;
- no contiene `service_role`;
- no contiene rutas de Edge Functions;
- no conecta datasources ni providers.

### Bloqueos vigentes

Siguen bloqueados:

- conexión real a `LocalHttpOwnChatSessionsDataSource`;
- conexión real a `LocalHttpOwnChatMessagesDataSource`;
- wrappers de feature;
- providers reales;
- UI/routing productivo;
- `/chat/:id`;
- `/orchestrator/chat`;
- Supabase real;
- auth heredado;
- remoto;
- producción;
- datos reales;
- IA, Stasis Engine, MCP, streaming y adjuntos.

### Siguiente paso recomendado

Revisar y aprobar 2B-AA1. Si se aprueba, el siguiente paso prudente es
preparar o implementar un paquete separado para `2B-AA2`, limitado a conectar
`chat_sessions` al adapter mediante una frontera local-safe y mockable, sin
routing productivo ni remoto.

## Implementación 2B-AA2 — chat_sessions conectado al adapter local-safe

### Estado

2B-AA1 queda aprobado y cerrado formalmente. 2B-AA2 conecta solo
`chat_sessions` al adapter seguro mediante una frontera local-safe de feature.

No conecta `messages`, `chat_messages`, UI, routing productivo, `/chat/:id`,
`/orchestrator/chat`, navegación real, chat heredado, Supabase real, remoto,
producción ni datos reales.

### Wrapper creado

Archivo:

```text
lib/features/chat_sessions/data/local/secure_session_chat_sessions_token_provider.dart
```

Responsabilidad:

```text
SecureSessionToLocalSessionTokenAdapter
-> LocalSessionTokenProvider.readLocalSessionToken()
```

Dirección permitida:

```text
features/chat_sessions -> core/auth/session
```

Dirección prohibida:

```text
core/auth/session -> features/chat_sessions
```

### Provider local-safe

Se añade un provider overrideable en `chat_sessions`:

```text
ownChatSessionsLocalSessionTokenProvider
```

Este provider compone:

```text
secureSessionTokenProvider
-> SecureSessionToLocalSessionTokenAdapter
-> SecureSessionChatSessionsTokenProvider
```

Importante: 2B-AA2 no cambia `ownChatSessionsRepositoryProvider`. En demo
sigue devolviendo `DemoOwnChatSessionsRepository`; en backend/producción sigue
devolviendo `BackendBlockedOwnChatSessionsRepository`. Por tanto, no activa
backend real ni datasource real por defecto.

### Mapeo preservado

Se preserva el comportamiento aprobado del datasource local:

- host no permitido -> `backendBlocked` antes de leer token;
- token `null` -> `unauthenticated`;
- token vacío -> `invalidSession`;
- token válido -> `Authorization: Bearer <token>`;
- errores del provider seguro -> `null` y luego `unauthenticated`;
- no hay fallback demo desde error real.

### Seguridad

El wrapper y su provider:

- no fabrican tokens;
- no devuelven string vacío;
- no exponen token a UI;
- no reciben `userId`;
- no reciben `ownerUserId`;
- no deciden ownership;
- no importan `features/auth`;
- no importan auth heredado;
- no importan Supabase;
- no usan HTTP/Dio nuevo;
- no contienen rutas Edge nuevas;
- no contienen `service_role`;
- no conectan `messages`.

### Tests añadidos o reforzados

Se añaden tests de wrapper para:

- token success fake;
- estados `unauthenticated`, `expired`, `refreshFailed`, `backendBlocked`,
  `misconfigured` y `demo`;
- excepción segura;
- token vacío rechazado por contrato;
- `toString` sin token.

Se refuerzan tests del datasource local para:

- token seguro válido añade `Authorization`;
- payload de create contiene solo `selectableSpecialistId`;
- no se envía `userId`, `ownerUserId` ni `specialistId`;
- token seguro `null` queda `unauthenticated`;
- error del provider no ejecuta transporte ni produce demo.

Se refuerzan tests de providers para:

- provider local de token usa `secureSessionTokenProvider` overrideado;
- `backendBlocked` y demo permanecen tokenless;
- error real no cae a demo ni activa repositorio real.

Se refuerzan tests arquitectónicos para:

- `chat_sessions` puede depender de `core/auth/session`;
- `core/auth/session` no importa `features/chat_sessions`;
- wrapper sin Supabase, auth heredado, HTTP/Dio, UI, rutas, IDs internos,
  `service_role`, MCP, Stasis Engine ni streaming.

### Bloqueos vigentes

Siguen bloqueados:

- conexión de `messages`;
- conexión de `chat_messages`;
- conexión `chat_sessions -> messages`;
- routing productivo;
- `/chat/:id`;
- `/orchestrator/chat`;
- navegación real;
- chat heredado;
- auth heredado;
- Supabase real;
- remoto;
- producción;
- datos reales;
- IA, Stasis Engine, MCP, streaming y adjuntos.

### Siguiente paso recomendado

Revisar y aprobar 2B-AA2. Después, el siguiente paso prudente es preparar
2B-AA3 para `messages/chat_messages` como paquete separado, sin routing
productivo ni conexión `chat_sessions -> messages`.

## Implementación 2B-AA3 — messages/chat_messages conectado al adapter local-safe

### Estado

2B-AA2 queda aprobado y cerrado formalmente. 2B-AA3 conecta solo
`messages/chat_messages` al adapter seguro mediante wrapper de feature y
provider overrideable. El cambio es local-safe y dev/test-safe: no activa
routing, no conecta producto, no conecta navegación real y no usa datos reales.

### Frontera creada

Archivo:

```text
lib/features/chat_messages/data/local/secure_session_chat_messages_token_provider.dart
```

Flujo local-safe:

```text
secureSessionTokenProvider
-> SecureSessionToLocalSessionTokenAdapter
-> SecureSessionChatMessagesTokenProvider
-> LocalSessionTokenProvider.readLocalSessionToken()
```

Esta conexión no crea sesiones, no interpreta `agentId` como `sessionId`, no
decide ownership, no pasa `userId`, no pasa `specialistId` y no concede acceso
a rutas productivas.

### Provider overrideable

Se añade:

```text
ownChatMessagesLocalSessionTokenProvider
```

El provider permite componer `chat_messages` con `SecureSession` en pruebas y
paquetes posteriores, pero 2B-AA3 no cambia
`ownChatMessagesRepositoryProvider`. En demo sigue devolviendo
`DemoOwnChatMessagesRepository`; en backend/producción sigue devolviendo
`BackendBlockedOwnChatMessagesRepository`.

### Contrato de seguridad

Se conserva:

- host remoto bloqueado antes de token/transporte;
- token `null` queda `unauthenticated`;
- token vacío directo queda `unauthenticated`;
- token válido añade `Authorization`;
- send envía solo `sessionId` y `content`;
- list envía solo `sessionId`, `limit` y `cursor`;
- UI no pasa token;
- UI no pasa `role`;
- UI no pasa `userId`;
- UI no pasa `specialistId`;
- errores reales no caen a demo.

### Tests y evidencia

AA3 añade/refuerza:

- tests del wrapper de `chat_messages`;
- tests del datasource local con fake transport usando el wrapper seguro;
- tests de provider overrideable;
- gates arquitectónicos contra auth heredado, Supabase, HTTP/Dio nuevo,
  rutas productivas, `/chat/:id`, `/orchestrator/chat`, `service_role`, tokens
  reales, IDs internos, MCP, Stasis Engine y streaming;
- gate de dirección: `core/auth/session` no importa `features/chat_messages`.

### Bloqueos vigentes

Siguen bloqueados:

- conexión `chat_sessions -> messages`;
- routing productivo;
- `/chat/:id`;
- `/orchestrator/chat`;
- navegación real;
- chat heredado;
- auth heredado;
- Supabase real;
- remoto;
- producción;
- datos reales;
- IA, Stasis Engine, MCP, streaming y adjuntos.

### Siguiente paso recomendado

Revisar y aprobar 2B-AA3. Después, el siguiente paso prudente es cerrar
formalmente el frente 2B-AA completo o preparar un plan separado de UX/routing
seguro, sin implementación todavía.

## Cierre 2B-AA4 — conexión controlada local-safe completa

### Estado

2B-AA3 queda aprobado y cerrado formalmente. 2B-AA4 cierra documentalmente
todo el frente 2B-AA como completo en modo:

- local-safe;
- dev-test-safe;
- mockable;
- no productivo;
- no remoto;
- sin datos reales;
- sin routing productivo;
- sin chat heredado.

### Paquetes cerrados

Quedan documentados como cerrados:

- `2B-AA` — plan conexión controlada `chat_sessions/messages` con
  `SecureSession`;
- `2B-AA1` — adapter `SecureSession -> LocalSessionTokenProvider`;
- `2B-AA2` — `chat_sessions` conectado al adapter local-safe;
- `2B-AA3` — `messages/chat_messages` conectado al adapter local-safe;
- `2B-AA4` — cierre conexión controlada local-safe completa.

### Capacidades terminadas

Queda disponible local-safe:

- `SecureSessionToLocalSessionTokenAdapter`;
- `SecureSessionChatSessionsTokenProvider`;
- `ownChatSessionsLocalSessionTokenProvider`;
- `SecureSessionChatMessagesTokenProvider`;
- `ownChatMessagesLocalSessionTokenProvider`;
- wrappers por feature;
- providers overrideables;
- datasources locales testeados con fake transport;
- `Authorization` añadido solo desde datasource;
- UI sin token;
- UI sin `userId`;
- UI sin `ownerUserId`;
- UI sin permisos;
- backend ownership sigue siendo autoridad.

### Decisiones firmes

- `core/auth/session` no depende de features.
- `features/chat_sessions` puede depender de `core/auth/session`.
- `features/chat_messages` puede depender de `core/auth/session`.
- El adapter neutro vive en core.
- Los wrappers concretos viven en cada feature.
- UI no recibe token.
- UI no envía `userId`.
- UI no decide ownership.
- El datasource añade `Authorization`.
- Backend valida ownership.
- Errores auth no caen a demo.

### Bloqueos vigentes

Siguen bloqueados:

- routing productivo;
- `/chat/:id`;
- `/orchestrator/chat`;
- navegación real;
- chat heredado;
- `AgentChatWrapper` heredado;
- `ChatPage` heredado;
- `ChatController` heredado;
- `chat_providers` heredado;
- `SupabaseChatDataSource` heredado;
- auth heredado;
- Supabase real;
- Supabase remoto;
- producción;
- datos reales;
- auth real productivo;
- login/register real;
- refresh real contra backend;
- IA;
- Stasis Engine;
- MCP;
- streaming;
- adjuntos.

### Gates antes de UX segura chat_sessions -> messages

Antes de unir UX de sesiones y mensajes se exige:

- aprobación explícita;
- paquete separado;
- sin routing productivo;
- sin `/chat/:id`;
- sin `/orchestrator/chat`;
- `sessionId` explícito obligatorio;
- `selectableSpecialistId` solo crea sesión;
- `sessionId` solo abre mensajes;
- no `agentId` como `sessionId`;
- no inherited `id` como `sessionId`;
- UI no pasa token;
- UI no pasa `userId`;
- UI no pasa `ownerUserId`;
- UI no decide ownership;
- providers overrideables;
- demo explícito separado;
- `backendBlocked` explícito;
- errores visibles;
- tests widget;
- tests providers;
- tests arquitectura;
- rollback definido.

### Gates antes de routing productivo

Antes de routing productivo se exige:

- plan separado;
- aprobación explícita;
- revisión de `/chat/:id`;
- revisión de `/orchestrator/chat`;
- eliminar o aislar chat heredado;
- `sessionId` explícito;
- no `agentId` heredado;
- no Supabase directo desde Flutter;
- no writes directos desde Flutter;
- auth/session aprobado;
- `chat_sessions` aprobado;
- `messages` aprobado;
- UX segura aprobada;
- tests anti-regresión;
- tests arquitectura;
- rollback definido.

### Relación futura permitida

El flujo futuro permitido será:

```text
chat_sessions selecciona/crea sessionId
sessionId explícito entra en messages
messages usa SecureSessionTokenProvider vía adapter
datasource añade Authorization
backend valida ownership
```

Sigue prohibido:

- `agentId -> messages`;
- `/chat/:id -> messages`;
- `/orchestrator/chat -> messages`;
- `UI -> token`;
- `UI -> userId`;
- `UI -> ownerUserId`;
- `UI -> permisos`;
- `UI -> Supabase directo`;
- `error real -> demo`.

### Recomendación final

Cerrar 2B-AA antes de UX/routing. Después del cierre, la ruta recomendada es:

```text
2B-AB — plan UX segura chat_sessions -> messages
```

sin implementación todavía.

## Plan 2B-AB — UX segura chat_sessions -> messages

### Estado

2B-AA4 queda aprobado y cerrado formalmente. 2B-AB prepara solo el plan de UX
segura para unir en el futuro:

```text
chat_sessions -> sessionId explícito -> messages
```

Este plan no implementa código, no modifica UI, no modifica providers, no
modifica controllers, no modifica rutas, no modifica navegación, no conecta
chat heredado, no conecta Supabase real/remoto, no usa producción y no usa
datos reales.

### Auditoría de piezas UX existentes

Piezas verificadas en solo lectura:

- `OwnChatSessionsPanel`: lista, crea, selecciona y archiva sesiones propias.
  Usa `selectableSpecialistId` solo para crear sesión y `sessionId` para
  seleccionar/archivar.
- `OwnChatSessionsSafeShell`: shell seguro de sesiones; muestra entradas
  seguras pero no conecta mensajes.
- `OwnChatSessionsPanelDevHost`: host dev con overrides; no usa repositorio
  real y no depende de routing.
- `OwnChatMessagesPanel`: recibe `sessionId` opcional; si existe y `autoLoad`
  está activo, carga mensajes para ese `sessionId`; el input envía solo
  contenido.
- `OwnChatMessagesSafeShell`: exige `sessionId` explícito y normalizado; si está
  vacío muestra sesión no válida.
- `OwnChatMessagesPanelDevHost`: host dev con overrides; no usa repositorio real
  y no depende de routing.
- Providers de `chat_sessions`: overrideables, con backend/producción
  bloqueados por defecto.
- Providers de `chat_messages`: overrideables, con backend/producción
  bloqueados por defecto.
- Controllers de `chat_sessions`: mantienen `selectedSessionId`, validan que la
  selección exista en la lista actual y limpian selección si desaparece.
- Controllers de `chat_messages`: cargan/listan/envían solo a partir de
  `sessionId`.

No se ha detectado en estas piezas seguras:

- dependencia directa de routing productivo;
- import de chat heredado;
- envío de token desde UI;
- envío de `userId` desde UI;
- envío de `ownerUserId` desde UI;
- uso de Supabase directo desde UI;
- conversión de `selectableSpecialistId` en `sessionId` dentro de mensajes.

Riesgo detectado: existe routing heredado `/chat/:id` con `agentId` y
`/orchestrator/chat` con chat heredado. También existe la puerta dev-only
`/dev/chat/session/:sessionId`, pero 2B-AB no la modifica ni la convierte en
producto.

### Flujo UX seguro propuesto

El flujo futuro permitido será:

1. Usuario ve sus sesiones propias.
2. Usuario crea sesión con `selectableSpecialistId` si procede.
3. Backend devuelve `sessionId`.
4. UI selecciona `sessionId` explícito.
5. `messages` recibe únicamente `sessionId`.
6. `messages` lista/envía usando `SecureSession` vía adapter.
7. Datasource añade `Authorization`.
8. Backend valida ownership.

Reglas obligatorias:

- `selectableSpecialistId` solo sirve para crear sesión.
- `sessionId` es el único identificador válido para abrir mensajes.
- `agentId` no sirve para abrir mensajes.
- inherited `id` no sirve para abrir mensajes.
- UI no pasa token.
- UI no pasa `userId`.
- UI no decide ownership.
- Backend valida ownership.

### Opciones UX

Opción A — shell seguro compuesto sin routing:

- crear en futuro un shell que componga `OwnChatSessionsPanel` y
  `OwnChatMessagesPanel`;
- pasar solo `selectedSessionId` desde estado de sesiones a mensajes;
- no tocar rutas productivas;
- recomendada si se quiere mantener el avance en una capa pura de UI local-safe.

Opción B — host/dev compuesto:

- crear primero un host/dev de prueba sin routing productivo;
- usar overrides de providers para simular sesiones y mensajes;
- recomendada si se quiere validar interacción visual antes de un shell real.

Opción C — route dev-only compuesta:

- usar una ruta dev-only explícita;
- nunca reutilizar `/chat/:id`;
- válida solo después de aprobar un paquete separado.

Opción D — routing productivo:

- bloqueada;
- no recomendada todavía.

### Recomendación

Recomendación inicial: Opción A o B, empezando por:

```text
2B-AB1 — shell UX compuesto local-safe sin routing
```

No debe implementar routing productivo, no debe tocar `/chat/:id`, no debe tocar
`/orchestrator/chat` y no debe conectar chat heredado.

### Gates antes de implementar UX

Antes de implementar UX se exige:

- aprobación explícita;
- paquete separado;
- sin routing productivo;
- sin `/chat/:id`;
- sin `/orchestrator/chat`;
- sin chat heredado;
- `sessionId` explícito obligatorio;
- no `agentId`;
- no inherited `id`;
- no `selectableSpecialistId` en messages;
- UI sin token;
- UI sin `userId`;
- UI sin `ownerUserId`;
- UI sin ownership;
- providers overrideables;
- demo explícito;
- `backendBlocked` explícito;
- errores visibles;
- tests widget;
- tests providers;
- tests arquitectura;
- rollback definido.

### Riesgos clasificados

Bloqueantes:

- `agentId` usado como `sessionId`;
- `/chat/:id` reutilizado por accidente;
- `/orchestrator/chat` conectado por accidente;
- UI pasando token;
- UI enviando `userId`;
- UI decidiendo ownership;
- Supabase directo reintroducido.

Altos:

- `selectableSpecialistId` enviado a `messages`;
- chat heredado reactivado;
- fallback demo desde error real;
- mensajes cargados sin `sessionId` explícito.

Medios:

- sesión archivada mal gestionada;
- errores de sesión/mensajes borrando estado útil;
- provider no overrideable que dificulte tests.

Bajos:

- estados visuales incompletos;
- copy de UI que confunda `selectableSpecialistId` y `sessionId`.

### Relación con routing

2B-AB no autoriza routing productivo. Siguen bloqueados:

- `/chat/:id`;
- `/orchestrator/chat`;
- `AgentChatWrapper` heredado;
- `ChatPage` heredado;
- `ChatController` heredado;
- `chat_providers` heredado;
- `SupabaseChatDataSource` heredado.

La única puerta de prueba existente sigue siendo dev-only:

```text
/dev/chat/session/:sessionId
```

2B-AB no la modifica.

### Siguiente paquete propuesto

Siguiente paquete recomendado:

```text
2B-AB1 — shell UX compuesto local-safe sin routing
```

Alternativa más prudente:

```text
2B-AB0 — auditoría UX/shell previa
```

si se decide revisar primero los contratos visuales y estados de error antes de
crear el shell compuesto.

## Implementación 2B-AB1 — shell UX compuesto local-safe sin routing

### Estado

2B-AB queda aprobado y cerrado formalmente. 2B-AB1 implementa únicamente un
shell UX compuesto local-safe, sin routing productivo, sin navegación real, sin
chat heredado, sin Supabase real/remoto, sin producción y sin datos reales.

### Ubicación

Se ubica en:

```text
lib/features/chat_messages/presentation/shell/own_chat_composed_safe_shell.dart
```

Justificación: el resultado final del flujo seguro es abrir mensajes con
`sessionId` explícito. El shell vive cerca de `chat_messages`, pero solo consume
estado seguro de `chat_sessions` para leer `selectedSessionId`.

### Flujo implementado

El shell compuesto:

- renderiza `OwnChatSessionsPanel`;
- observa `ownChatSessionsStateProvider.selectedSessionId`;
- si no hay `selectedSessionId`, muestra estado de selección pendiente;
- si hay `selectedSessionId`, monta `OwnChatMessagesSafeShell`;
- pasa solo `sessionId` a mensajes;
- desmonta mensajes cuando la selección se limpia;
- no transforma ids;
- no acepta `agentId`;
- no acepta `selectableSpecialistId` como `sessionId`;
- no persiste `sessionId` fuera del estado seguro existente.

### Providers usados

Usa únicamente providers seguros existentes:

- `ownChatSessionsStateProvider`;
- `ownChatSessionsControllerProvider` a través de `OwnChatSessionsPanel`;
- `ownChatMessagesControllerProvider` a través de `OwnChatMessagesSafeShell`;
- `ownChatMessagesStateProvider` a través de `OwnChatMessagesPanel`.

No construye repositorios, datasources ni transportes en UI.

### Seguridad

El shell:

- no recibe token;
- no pasa token;
- no pasa `userId`;
- no pasa `ownerUserId`;
- no pasa `role`;
- no pasa `specialistId`;
- no decide ownership;
- no importa Supabase;
- no importa auth heredado;
- no importa chat heredado;
- no importa routing.

### Tests y gates

AB1 añade/refuerza:

- tests widget/shell para render de sesiones;
- tests de selección `sessionId -> messages`;
- tests de desmontaje al limpiar selección;
- tests de desmontaje al archivar sesión seleccionada;
- tests de create con `selectableSpecialistId` sin pasarlo a messages;
- tests de estados demo/backendBlocked/error sin fallback indebido;
- gate arquitectónico del shell compuesto sin auth heredado, Supabase, chat
  heredado, rutas productivas, `service_role`, tokens reales, MCP, Stasis
  Engine ni streaming.

### Bloqueos vigentes

Siguen bloqueados:

- routing productivo;
- `/chat/:id`;
- `/orchestrator/chat`;
- navegación real;
- chat heredado;
- auth heredado;
- Supabase real/remoto;
- producción;
- datos reales;
- IA;
- Stasis Engine;
- MCP;
- streaming;
- adjuntos.

### Siguiente paso recomendado

Revisar y aprobar 2B-AB1. Después, el siguiente paso prudente es un cierre
documental de AB o un plan separado de integración dev-only/productiva segura,
sin implementación automática.

## Cierre 2B-AB2 — UX segura local-safe completa

### Estado

2B-AB1 queda aprobado y cerrado formalmente. 2B-AB2 cierra documentalmente el
frente 2B-AB como completo en modo local-safe, dev-test-safe, sin routing
productivo, sin chat heredado, sin Supabase real, sin remoto, sin producción y
sin datos reales.

### Paquetes cerrados

Quedan cerrados:

- `2B-AB — plan UX segura chat_sessions -> messages`;
- `2B-AB1 — shell UX compuesto local-safe sin routing`;
- `2B-AB2 — cierre UX segura local-safe completa`.

### Capacidades terminadas

Queda disponible local-safe:

- `OwnChatComposedSafeShell`;
- composición `OwnChatSessionsPanel + OwnChatMessagesSafeShell`;
- `sessionId` explícito como única entrada a messages;
- estado sin sesión seleccionada;
- estado con sesión seleccionada;
- desmontaje de messages al limpiar selección;
- desmontaje de messages al archivar sesión seleccionada;
- errores visibles;
- demo explícito;
- `backendBlocked` explícito;
- providers overrideables;
- tests widget;
- tests providers/overrides;
- tests arquitectura.

### Decisiones firmes

- `selectableSpecialistId` solo crea sesión.
- `sessionId` abre mensajes.
- `agentId` no abre mensajes.
- `id` heredado no abre mensajes.
- `/chat/:id` no abre mensajes.
- `/orchestrator/chat` no abre mensajes.
- UI no pasa token.
- UI no pasa `userId`.
- UI no pasa `ownerUserId`.
- UI no pasa `role`.
- UI no pasa `specialistId`.
- UI no decide ownership.
- Backend valida ownership.
- Chat heredado no se reutiliza.

### Bloqueos vigentes

Siguen bloqueados:

- routing productivo;
- routing dev-only compuesto;
- `/chat/:id`;
- `/orchestrator/chat`;
- navegación real;
- chat heredado;
- `AgentChatWrapper` heredado;
- `ChatPage` heredado;
- `ChatController` heredado;
- `chat_providers` heredado;
- `SupabaseChatDataSource` heredado;
- auth heredado;
- Supabase real;
- Supabase remoto;
- producción;
- datos reales;
- auth real productivo;
- login/register real;
- refresh real contra backend;
- IA;
- Stasis Engine;
- MCP;
- streaming;
- adjuntos.

### Gates antes de routing dev-only compuesto

Antes de crear una ruta dev-only compuesta se exige:

- aprobación explícita;
- paquete separado;
- ruta dev-only explícita;
- sin `/chat/:id`;
- sin `/orchestrator/chat`;
- sin chat heredado;
- `kReleaseMode` bloqueado;
- `environment.isDemo` obligatorio;
- `sessionId` explícito si aplica;
- sin `agentId`;
- sin inherited `id`;
- sin Supabase real;
- sin remoto;
- sin producción;
- tests de routing dev-only;
- tests arquitectura;
- rollback definido.

### Gates antes de routing productivo

Antes de routing productivo se exige:

- plan separado;
- aprobación explícita;
- auditoría de `/chat/:id`;
- auditoría de `/orchestrator/chat`;
- aislamiento o retirada del chat heredado;
- `sessionId` explícito obligatorio;
- no `agentId` heredado;
- no Supabase directo desde Flutter;
- no writes directos desde Flutter;
- auth/session aprobado;
- `chat_sessions` aprobado;
- messages aprobado;
- UX segura aprobada;
- tests anti-regresión;
- tests arquitectura;
- rollback definido.

### Relación futura permitida

El flujo futuro permitido será:

```text
chat_sessions crea/lista/selecciona sessionId
OwnChatComposedSafeShell pasa selectedSessionId explícito
OwnChatMessagesSafeShell recibe sessionId
messages usa SecureSessionTokenProvider vía adapter
datasource añade Authorization
backend valida ownership
```

Sigue prohibido:

- `agentId -> messages`;
- `selectableSpecialistId -> messages`;
- `/chat/:id -> messages`;
- `/orchestrator/chat -> messages`;
- `UI -> token`;
- `UI -> userId`;
- `UI -> ownerUserId`;
- `UI -> permisos`;
- `UI -> Supabase directo`;
- `error real -> demo`.

### Recomendación final

Cerrar 2B-AB antes de cualquier routing. Después del cierre, el siguiente paso
prudente es `2B-AC — plan ruta dev-only compuesta para UX segura`, sin
implementación todavía. Alternativas válidas: plan de routing productivo seguro,
plan auth real/Supabase real seguro, backend remoto seguro, otro bloque técnico
u otra área de Stasisly.

## Plan 2B-AC — ruta dev-only compuesta para UX segura

### Estado

2B-AB2 queda aprobado y cerrado formalmente. 2B-AC prepara solo el plan de una
ruta dev-only futura para probar `OwnChatComposedSafeShell`. No implementa
código, no modifica rutas, no modifica `go_router`, no modifica `app.dart`, no
modifica `main.dart`, no modifica widgets, no modifica providers, no modifica
controllers y no conecta Supabase real, remoto, producción ni datos reales.

### Routing actual inspeccionado

Archivos inspeccionados en solo lectura:

- `lib/core/config/routes.dart`;
- `lib/app.dart`;
- `lib/main.dart`.

Estado verificado:

- `routerProvider` vive en `lib/core/config/routes.dart`.
- `App` consume `routerProvider` y `appEnvironmentProvider` en `lib/app.dart`.
- `main.dart` inicializa Supabase solo cuando `environment.usesBackend` es true.
- `/orchestrator/chat` monta `OrchestratorChatPage` heredado.
- `/chat/:id` monta `AgentChatWrapper(agentId: id)` y por tanto `id` es
  `agentId` heredado, no `sessionId` seguro.
- Existe ruta dev-only `/dev/chat/session/:sessionId`.
- La ruta `/dev/chat/session/:sessionId` se registra solo si
  `!kReleaseMode && environment.isDemo`.
- La ruta dev-only existente monta `OwnChatMessagesSafeShell` con `sessionId`
  explícito, pero no compone selector de sesiones.

Rutas que no deben tocarse en 2B-AC:

- `/chat/:id`;
- `/orchestrator/chat`;
- `/dev/chat/session/:sessionId`;
- rutas principales del shell de producto.

### Ruta dev-only compuesta propuesta

Ruta futura recomendada:

```text
/dev/chat/composed
```

Componente futuro:

```text
OwnChatComposedSafeShell
```

Reglas:

- solo dev/demo;
- nunca release;
- nunca producción;
- sin remoto;
- sin datos reales;
- sin auth heredado;
- sin chat heredado;
- sin `/chat/:id`;
- sin `/orchestrator/chat`;
- sin `agentId`;
- sin inherited `id`;
- sin interpretar `selectableSpecialistId` como `sessionId`;
- sin token en UI;
- sin `userId`;
- sin ownership decidido por UI.

### Guards futuros mínimos

La ruta futura debe usar el patrón aprobado:

```text
!kReleaseMode && environment.isDemo
```

Además debe mantener:

- `environment.usesBackend == false` o bloqueo explícito equivalente;
- sin Supabase real;
- sin remoto;
- sin producción;
- sin datos reales;
- sin fallback de error real a demo.

Si el guard falla, la ruta no debe existir o debe quedar inaccesible de forma
explícita. No debe redirigir a chat heredado ni montar `AgentChatWrapper`.

### Opciones evaluadas

| Opción | Descripción | Ventajas | Riesgos | Decisión |
| --- | --- | --- | --- | --- |
| A | Ruta dev-only compuesta `/dev/chat/composed` | Prueba UX completa sin parámetros y sin tocar producto | Puede confundirse con ruta productiva si no se blinda | Recomendada para implementación futura |
| B | Reutilizar `/dev/chat/session/:sessionId` | Ya existe y está guardada | No prueba selector de sesiones ni composición completa | Mantener intacta |
| C | Host/dev sin router | Menor superficie de routing | Menos parecido al uso real de navegación | Alternativa si se quiere máxima prudencia |
| D | Routing productivo | Daría camino de producto | Bloqueante: aún no autorizado | Bloqueada |

### Tests requeridos para futura implementación

La implementación futura de 2B-AC1 debe demostrar:

- ruta existe solo en demo/dev;
- ruta no existe en release;
- ruta no existe si `environment.isDemo == false`;
- ruta monta `OwnChatComposedSafeShell`;
- ruta no monta chat heredado;
- `/chat/:id` no cambia;
- `/orchestrator/chat` no cambia;
- no `AgentChatWrapper`;
- no `ChatPage` heredado;
- no `ChatController` heredado;
- no `SupabaseChatDataSource`;
- no Supabase real;
- no `agentId` como `sessionId`;
- no inherited `id`;
- no `selectableSpecialistId` como `sessionId`;
- no token en UI;
- no `userId`;
- no ownership decidido por UI.

### Riesgos clasificados

Bloqueantes:

- exponer ruta dev-only en release;
- exponer ruta dev-only en producción;
- reutilizar `/chat/:id`;
- reutilizar `/orchestrator/chat`;
- montar chat heredado por accidente;
- interpretar `agentId` como `sessionId`;
- permitir Supabase real o datos reales.

Altos:

- confundir ruta dev con ruta productiva;
- aceptar inherited `id`;
- pasar `selectableSpecialistId` a messages;
- ocultar fallo de backend como demo;
- acoplar UI a auth heredado.

Medios:

- no cubrir estados de demo/backendBlocked/error;
- no probar que `/chat/:id` y `/orchestrator/chat` quedan intactas;
- no definir rollback de ruta.

Bajos:

- naming visual ambiguo;
- copy que no deje claro que es dev-only/local-safe.

### Relación con routing productivo

2B-AC no autoriza routing productivo. Siguen bloqueados:

- `/chat/:id`;
- `/orchestrator/chat`;
- `AgentChatWrapper` heredado;
- `ChatPage` heredado;
- `ChatController` heredado;
- `chat_providers` heredado;
- `SupabaseChatDataSource` heredado;
- navegación real de usuario;
- remoto;
- producción;
- datos reales.

### Siguiente paquete propuesto

Siguiente paquete recomendado:

```text
2B-AC1 — implementar ruta dev-only compuesta /dev/chat/composed
```

Solo debería aprobarse si se acepta que es una puerta de prueba, no una puerta
de producto. Si aparecen dudas sobre guards o acoplamientos, usar antes:

```text
2B-AC0 — reforzar arquitectura/routing antes de implementar
```

## Implementación 2B-AC1 — ruta dev-only compuesta /dev/chat/composed

### Estado

2B-AC queda aprobado y cerrado formalmente. 2B-AC1 implementa únicamente la
ruta dev-only compuesta `/dev/chat/composed` para montar
`OwnChatComposedSafeShell` en entorno demo/dev. No autoriza routing productivo,
no modifica `/chat/:id`, no modifica `/orchestrator/chat`, no conecta chat
heredado, no conecta Supabase real/remoto, no usa producción y no usa datos
reales.

### Ruta creada

Ruta:

```text
/dev/chat/composed
```

Guard:

```text
!kReleaseMode && environment.isDemo
```

Componente montado:

```text
Scaffold -> OwnChatComposedSafeShell
```

La ruta no acepta parámetros. Quedan prohibidas:

- `/dev/chat/composed/:id`;
- `/dev/chat/composed/:agentId`;
- `/dev/chat/composed/:sessionId`.

### Relación con rutas existentes

Se mantiene intacta la ruta dev-only existente:

```text
/dev/chat/session/:sessionId
```

Se mantienen intactas y bloqueadas para el flujo seguro nuevo:

- `/chat/:id`, que sigue siendo `agentId` heredado;
- `/orchestrator/chat`, que sigue siendo chat heredado.

### Seguridad

La ruta compuesta:

- no usa `AgentChatWrapper`;
- no usa `ChatPage` heredado;
- no usa `OrchestratorChatPage`;
- no usa `ChatController`;
- no usa `chat_providers` heredado;
- no usa `SupabaseChatDataSource`;
- no usa `Supabase.instance.client`;
- no usa `service_role`;
- no pasa token a UI;
- no pasa `userId`;
- no pasa `agentId`;
- no interpreta inherited `id` como `sessionId`;
- no interpreta `selectableSpecialistId` como `sessionId`.

### Tests y evidencia requerida

AC1 añade/refuerza tests para:

- existencia de `/dev/chat/composed` solo bajo el bloque dev-only;
- montaje de `OwnChatComposedSafeShell`;
- ausencia de parámetros en la ruta compuesta;
- conservación de `/dev/chat/session/:sessionId`;
- no modificación de `/chat/:id`;
- no modificación de `/orchestrator/chat`;
- ausencia de chat heredado, Supabase, tokens reales, `service_role`, IA,
  Stasis Engine, MCP y streaming en el bloque dev-only.

### Bloqueos vigentes

Siguen bloqueados:

- routing productivo;
- `/chat/:id` como entrada segura;
- `/orchestrator/chat` como entrada segura;
- navegación real de usuario;
- chat heredado;
- auth heredado;
- Supabase real;
- Supabase remoto;
- producción;
- datos reales;
- IA;
- Stasis Engine;
- MCP;
- streaming;
- adjuntos.

### Siguiente paso recomendado

Revisar y aprobar 2B-AC1. Después, preparar un cierre documental 2B-AC2 o un
plan separado de validación UX/dev-only antes de cualquier routing productivo.

## Cierre 2B-AC2 — ruta dev-only compuesta cerrada

### Estado

2B-AC1 queda aprobado y cerrado formalmente. 2B-AC2 cierra documentalmente el
frente 2B-AC como completo en modo dev-only, demo-only, local-safe, no
productivo, sin remoto, sin datos reales, sin chat heredado y sin Supabase real.

### Paquetes cerrados

Quedan cerrados:

- `2B-AC — plan ruta dev-only compuesta para UX segura`;
- `2B-AC1 — ruta dev-only compuesta /dev/chat/composed`;
- `2B-AC2 — cierre ruta dev-only compuesta`.

### Capacidades terminadas

Queda disponible:

- `/dev/chat/composed`;
- guard `!kReleaseMode && environment.isDemo`;
- montaje `Scaffold -> OwnChatComposedSafeShell`;
- ruta sin parámetros;
- ruta separada de `/chat/:id`;
- ruta separada de `/orchestrator/chat`;
- tests de routing dev-only;
- tests de no regresión de rutas existentes;
- tests arquitectónicos.

### Decisiones firmes

- `/dev/chat/composed` es puerta de prueba.
- `/dev/chat/composed` no es ruta productiva.
- `/dev/chat/composed` no acepta `agentId`.
- `/dev/chat/composed` no acepta `id` heredado.
- `/dev/chat/composed` no acepta `sessionId` por parámetro.
- `/chat/:id` sigue siendo heredada y bloqueada para el flujo seguro.
- `/orchestrator/chat` sigue heredada y bloqueada para el flujo seguro.
- Routing productivo sigue bloqueado.

### Bloqueos vigentes

Siguen bloqueados:

- routing productivo;
- `/chat/:id` como ruta segura;
- `/orchestrator/chat` como ruta segura;
- navegación real;
- chat heredado;
- `AgentChatWrapper` heredado;
- `ChatPage` heredado;
- `ChatController` heredado;
- `chat_providers` heredado;
- `SupabaseChatDataSource` heredado;
- auth heredado;
- Supabase real;
- Supabase remoto;
- producción;
- datos reales;
- auth real productivo;
- login/register real;
- refresh real contra backend;
- IA;
- Stasis Engine;
- MCP;
- streaming;
- adjuntos.

### Gates antes de routing productivo

Antes de cualquier routing productivo se exige:

- plan separado;
- aprobación explícita;
- auditoría completa de `/chat/:id`;
- auditoría completa de `/orchestrator/chat`;
- decisión sobre retirada o aislamiento del chat heredado;
- `sessionId` explícito obligatorio;
- no `agentId` heredado;
- no inherited `id`;
- no Supabase directo desde Flutter;
- no writes directos desde Flutter;
- auth/session aprobado;
- `chat_sessions` aprobado;
- messages aprobado;
- UX segura aprobada;
- ruta dev-only validada;
- tests anti-regresión;
- tests arquitectura;
- rollback definido.

### Relación futura permitida

El flujo dev-only permitido es:

```text
/dev/chat/composed
-> OwnChatComposedSafeShell
-> chat_sessions selecciona/crea sessionId
-> OwnChatMessagesSafeShell(sessionId)
-> messages usa SecureSessionTokenProvider vía adapter
-> datasource añade Authorization
-> backend valida ownership
```

Sigue prohibido:

- `agentId -> messages`;
- `selectableSpecialistId -> messages`;
- `/chat/:id -> messages`;
- `/orchestrator/chat -> messages`;
- `UI -> token`;
- `UI -> userId`;
- `UI -> ownerUserId`;
- `UI -> permisos`;
- `UI -> Supabase directo`;
- `error real -> demo`.

### Recomendación final

Cerrar 2B-AC antes de cualquier routing productivo. Después del cierre, la ruta
prudente recomendada es plan de validación UX dev-only antes de plantear routing
productivo. Alternativas válidas: `2B-AD — plan routing productivo seguro`,
plan auth real/Supabase real seguro, backend remoto seguro, otro bloque técnico
u otra área de Stasisly.

## Plan 2B-AD — validación UX dev-only

### Estado

2B-AC2 queda aprobado y cerrado formalmente. 2B-AD prepara únicamente el plan de
validación manual y técnica de la UX dev-only segura en `/dev/chat/composed`,
antes de plantear cualquier routing productivo. No implementa código, no
modifica rutas, no modifica widgets, no modifica providers, no modifica
controllers, no modifica datasources, no modifica Supabase, no modifica CI y no
conecta remoto, producción ni datos reales.

### Alcance de validación UX dev-only

La validación debe cubrir:

- render inicial;
- estado sin sesión seleccionada;
- lista de sesiones;
- creación de sesión si está disponible;
- selección de `sessionId` explícito;
- montaje de mensajes;
- envío de mensaje fake/local-safe si el entorno lo permite;
- listado de mensajes;
- archivado de sesión seleccionada;
- desmontaje de mensajes al limpiar selección;
- desmontaje de mensajes al archivar la sesión seleccionada;
- errores visibles;
- demo explícito;
- `backendBlocked` explícito.

### Checklist manual

Checklist manual para entorno demo/dev:

1. Abrir `/dev/chat/composed`.
2. Confirmar que no hay red remota.
3. Confirmar que no usa datos reales.
4. Confirmar que no aparece chat heredado.
5. Confirmar que no aparece `/chat/:id`.
6. Confirmar que no aparece `/orchestrator/chat`.
7. Confirmar que no hay tokens visibles.
8. Crear o seleccionar sesión.
9. Verificar que solo `sessionId` abre mensajes.
10. Enviar mensaje fake/local-safe si el entorno lo permite.
11. Archivar sesión y comprobar desmontaje de mensajes.
12. Comprobar errores demo/backendBlocked.

### Checklist técnico

Verificaciones técnicas mínimas:

- `flutter analyze --no-fatal-infos`;
- `flutter test`;
- tests focales de route/dev-only;
- tests widget de `OwnChatComposedSafeShell`;
- tests arquitectura;
- diff prohibido;
- búsqueda de Supabase/auth heredado/chat heredado;
- búsqueda de `/chat/:id` y `/orchestrator/chat` en nuevas piezas.

### Criterios de aceptación

La validación solo puede considerarse aprobada si:

- la ruta es solo dev/demo;
- no está disponible en release;
- no es productiva;
- no usa Supabase real;
- no usa chat heredado;
- no usa auth heredado;
- no usa datos reales;
- `sessionId` explícito es obligatorio;
- `selectableSpecialistId` no entra en messages;
- `agentId` no entra en messages;
- UI no muestra token;
- UI no pasa `userId`;
- UI no decide ownership;
- errores son visibles;
- ningún error real cae a demo;
- tests están en verde;
- rollback queda claro.

### Riesgos clasificados

Bloqueantes:

- ruta dev visible fuera de demo;
- uso accidental de datos reales;
- Supabase real inicializado;
- chat heredado renderizado;
- `agentId` usado como `sessionId`;
- token visible en UI.

Altos:

- `selectableSpecialistId` usado como `sessionId`;
- mensaje enviado sin `sessionId`;
- error real cae a demo;
- ownership decidido por UI.

Medios:

- archivado deja mensajes montados;
- estados demo/backendBlocked no son claros;
- checklist manual incompleto.

Bajos:

- copy dev-only ambiguo;
- falta de evidencia visual en la validación.

### Siguiente paquete propuesto

Siguiente recomendado:

```text
2B-AD1 — ejecutar/automatizar validación UX dev-only
```

Alternativas válidas:

- `2B-AE — plan routing productivo seguro`;
- `2B-AF — plan auth real/Supabase seguro`;
- `2B-AG — backend remoto seguro`.

## Ejecución 2B-AD1 — validación UX dev-only

### Estado

2B-AD queda aprobado y cerrado formalmente. 2B-AD1 ejecuta la validación
automatizada de la UX dev-only segura en `/dev/chat/composed` antes de cualquier
routing productivo. La validación confirma el flujo local-safe/dev-test:

```text
/dev/chat/composed
-> OwnChatComposedSafeShell
-> chat_sessions
-> selectedSessionId explícito
-> OwnChatMessagesSafeShell(sessionId)
```

No se autoriza routing productivo, no se conecta `/chat/:id`, no se conecta
`/orchestrator/chat`, no se conecta chat heredado y no se habilita Supabase
real/remoto.

### Evidencia automatizada

Validaciones ejecutadas:

- `dart format lib/core/config lib/features/chat_sessions lib/features/chat_messages test/core test/features/chat_sessions test/features/chat_messages test/architecture`;
- `dart run build_runner build --delete-conflicting-outputs`;
- `flutter analyze --no-fatal-infos`;
- `flutter test test/core/config test/features/chat_sessions test/features/chat_messages test/architecture`;
- `flutter test`;
- `git diff --check`;
- `git diff --name-only -- lib/features/auth lib/features/chat lib/app.dart lib/main.dart pubspec.yaml supabase`.

Resultados:

- `build_runner`: correcto, 0 outputs generados.
- `flutter analyze --no-fatal-infos`: correcto; quedan solo infos no fatales ya
  toleradas por la configuración actual.
- tests focales dev-only/sesiones/mensajes/arquitectura: 259 tests pasados.
- suite completa: 358 tests pasados, 2 tests saltados por harness local
  explícito.
- `git diff --check`: sin salida.
- diff prohibido sobre `features/auth`, `features/chat`, `app.dart`,
  `main.dart`, `pubspec.yaml` y `supabase`: sin salida.

### Criterios validados

2B-AD1 valida que:

- `/dev/chat/composed` es una ruta dev-only/demo-only, no productiva;
- la ruta no acepta `agentId`, inherited `id`, `userId`, `ownerUserId` ni token;
- `selectableSpecialistId` solo sirve para crear sesión y nunca entra en
  messages;
- messages recibe únicamente `sessionId` explícito;
- la selección y el archivado desmontan messages cuando corresponde;
- los errores permanecen visibles y no caen a demo;
- `backendBlocked` sigue siendo explícito;
- las piezas seguras no importan chat heredado, auth heredado ni Supabase real;
- la UI dev-only no decide ownership ni permisos.

### Validación manual

No se abrió una sesión interactiva de navegador ni dispositivo. La validación
manual queda sustituida en este paquete por pruebas widget, pruebas de ruta y
gates arquitectónicos ejecutables. La validación visual humana puede hacerse en
un paquete posterior si se desea, manteniendo la ruta en modo dev-only.

### Bloqueos vigentes

Siguen bloqueados:

- routing productivo;
- `/chat/:id` como ruta segura;
- `/orchestrator/chat` como ruta segura;
- chat heredado;
- auth heredado;
- Supabase real/remoto;
- producción;
- datos reales;
- IA;
- Stasis Engine;
- MCP;
- streaming;
- adjuntos.

### Decisión solicitada

Revisar y aprobar el cierre de 2B-AD1. Siguiente paso prudente recomendado:
`2B-AE — plan routing productivo seguro`, todavía sin implementación, o una
validación visual humana dev-only si se quiere evidencia UX adicional antes de
hablar de routing productivo.

## Plan 2B-AE — routing productivo seguro

### Estado

2B-AD1 queda aprobado y cerrado formalmente. La validación UX dev-only queda
ejecutada sobre `/dev/chat/composed` y routing productivo sigue bloqueado hasta
un paquete separado. 2B-AE prepara únicamente el plan documental para decidir
cómo abordar el routing productivo seguro del flujo de chat nuevo, sin
implementar código, sin modificar rutas, sin modificar widgets, sin conectar
chat heredado y sin conectar Supabase real/remoto.

### Auditoría de rutas productivas heredadas

Estado verificado en lectura:

- `lib/core/config/routes.dart` define `/chat/:id` y pasa `state.pathParameters['id']`
  a `AgentChatWrapper(agentId: id)`.
- `AgentChatWrapper` resuelve `agentByIdProvider(agentId)` y monta `ChatPage`
  con `agentId: agent.id`, `specialistName` y `specialty`.
- `ChatPage` usa `activeChatSessionProvider(widget.agentId)`; por tanto el
  parámetro de `/chat/:id` se interpreta como `agentId`/especialista heredado,
  no como `sessionId`.
- `ChatController.sendMessage` llama al use case heredado con `role: 'user'`
  desde Flutter.
- `chat_providers.dart` construye `SupabaseChatDataSource(Supabase.instance.client)`
  fuera de demo y usa `currentIdentityProvider` para obtener `userId`.
- `SupabaseChatDataSource` lee/escribe directamente en `chat_sessions` y
  `messages`, usa `specialist_id`, inserta `role`, hace `select()` y llama a la
  RPC heredada `increment_message_count`.
- `/orchestrator/chat` monta `OrchestratorChatPage`, que resuelve
  `agentByIdProvider('stasis_core')` y monta el mismo `ChatPage` heredado.

Piezas clasificadas como heredadas/bloqueadas para el flujo seguro:

- `/chat/:id`;
- `/orchestrator/chat`;
- `AgentChatWrapper`;
- `ChatPage`;
- `ChatController` heredado;
- `chat_providers` heredado;
- `ChatRepositoryImpl`;
- `SupabaseChatDataSource`;
- `ChatSessionEntity` heredado con `userId` y `specialistId` públicos;
- `MessageEntity` heredado con `role` y `attachments`;
- `DemoChatRepository` heredado, que reutiliza `demo_session_$specialistId`.

Estas piezas pueden auditarse, aislarse, deprecarse o migrarse en paquetes
posteriores, pero 2B-AE no autoriza su modificación.

### Problema central

`/chat/:id` no puede conectarse directamente al flujo seguro porque `:id` es
`agentId` heredado, no `sessionId` seguro.

`/orchestrator/chat` no puede conectarse directamente al flujo seguro porque
monta `OrchestratorChatPage -> ChatPage`, es decir, el flujo heredado.

Conectar cualquiera de esas rutas a `OwnChatMessagesSafeShell` sin rediseño
crearía una ambigüedad peligrosa:

```text
agentId / selectableSpecialistId / inherited id != sessionId
```

### Opciones de routing productivo

#### Opción A — Nueva ruta productiva segura separada

Crear en el futuro una ruta nueva, por ejemplo `/chat/sessions`, `/chat/new` o
`/chat/safe`, que monte el flujo seguro compuesto y no acepte `agentId` como
entrada de messages.

Ventajas:

- evita romper `/chat/:id` heredado de golpe;
- mantiene separación clara entre selección de sesión y lectura/escritura de
  mensajes;
- permite gates estrictos sobre auth/backend/RLS;
- reduce el riesgo de confundir `agentId` con `sessionId`.

Costes:

- requiere decisión de producto/UX sobre URL final;
- exige plan de migración o retirada del chat heredado;
- puede duplicar temporalmente rutas visibles si no se bloquea bien.

#### Opción B — Migrar `/chat/:id`

Convertir `/chat/:id` en ruta segura solo después de retirar, aislar o cambiar
formalmente el significado heredado de `:id`.

Ventajas:

- conserva una URL conocida;
- puede simplificar producto si se rediseña de forma completa.

Costes y riesgos:

- riesgo bloqueante de interpretar `agentId` como `sessionId`;
- requiere migración explícita de contratos, tests y navegación;
- requiere estrategia de compatibilidad o de ruptura controlada.

#### Opción C — Migrar `/orchestrator/chat`

Usar el flujo seguro para Stasis solo después de definir cómo Stasis crea,
selecciona o recupera un `sessionId` explícito.

Ventajas:

- acerca el flujo seguro al home/Stasis.

Costes y riesgos:

- hoy monta chat heredado;
- requiere decidir si Stasis usa sesión propia, sesión por rama o sesión por
  contexto;
- no debe crear mensajes ni sesiones opacas sin contrato de ownership.

#### Opción D — Mantener producto bloqueado y seguir en dev-only

Mantener `/dev/chat/composed` como única puerta validada mientras auth real,
backend real, RLS y ownership no estén aprobados fuera de local.

Ventajas:

- máxima seguridad;
- evita exposición accidental de datos reales;
- conserva rollback simple.

Costes:

- no desbloquea UX productiva.

### Recomendación

Recomendación de 2B-AE:

```text
No migrar /chat/:id todavía.
No migrar /orchestrator/chat todavía.
No conectar chat heredado al flujo seguro.
Preparar primero una nueva ruta productiva segura separada o mantener dev-only
hasta que auth/backend real estén aprobados.
```

La opción preferida para un siguiente diseño es Opción A, pero solo como plan
separado: `2B-AE1 — plan nueva ruta productiva segura separada`.

### Gates antes de cualquier implementación productiva

Antes de implementar cualquier ruta productiva segura deben cumplirse:

- aprobación explícita del paquete;
- paquete separado con rollback;
- decisión de URL productiva y alcance UX;
- auth real aprobada o `backendBlocked` productivo explícito;
- token provider real aprobado si aplica;
- backend/Supabase real aprobado si aplica;
- RLS/ownership verificados en entorno no local si hay datos reales;
- chat heredado no montado por la ruta segura;
- sin writes directos desde Flutter;
- sin Supabase directo desde UI;
- `sessionId` explícito obligatorio para messages;
- no `agentId` como `sessionId`;
- no inherited `id`;
- no `selectableSpecialistId` en messages;
- UI sin token;
- UI sin `userId`;
- UI sin `ownerUserId`;
- UI sin ownership ni permisos;
- backend valida ownership;
- errores visibles;
- ningún error real cae a demo;
- tests de routing;
- tests widget;
- tests providers;
- tests de integración local;
- tests de arquitectura;
- diff prohibido sobre chat heredado salvo aprobación explícita;
- rollback definido.

### Riesgos clasificados

Bloqueantes:

- usar `agentId` como `sessionId`;
- conectar `/chat/:id` directamente a messages;
- conectar `/orchestrator/chat` directamente al flujo seguro heredando
  `ChatPage`;
- reactivar `SupabaseChatDataSource` como camino productivo seguro;
- usar datos reales antes de auth/RLS/ownership aprobados.

Altos:

- romper `/chat/:id` existente sin migración;
- writes directos desde Flutter;
- Supabase real sin aprobación;
- UI enviando `userId`, token u ownership;
- fallback demo desde error real;
- confundir ruta dev con productiva.

Medios:

- duplicar rutas de chat sin señalización clara;
- mantener chat heredado visible junto a ruta segura;
- no definir política de redirección/deprecación.

Bajos:

- naming productivo ambiguo (`/chat/safe`, `/chat/new`, etc.);
- copy UX insuficiente sobre estado local-safe/productivo.

### Relación con auth real/backend remoto

Routing productivo seguro puede requerir antes:

- auth real segura;
- token provider real aprobado;
- backend remoto aprobado;
- Supabase real aprobado;
- RLS/ownership verificados fuera del entorno local.

2B-AE no autoriza ninguno de esos pasos. Solo documenta las dependencias y los
gates.

### Siguiente paquete propuesto

Siguiente recomendado:

```text
2B-AE1 — plan nueva ruta productiva segura separada
```

Alternativas válidas si se considera prematuro:

- `2B-AF — plan auth real/Supabase real seguro`;
- `2B-AG — backend remoto seguro`;
- validación visual humana dev-only adicional.

## Plan 2B-AE1 — nueva ruta productiva segura separada

### Estado

2B-AE queda aprobado y cerrado formalmente. Routing productivo sigue bloqueado.
2B-AE1 diseña únicamente una futura ruta productiva segura separada del chat
heredado, sin implementarla y sin modificar `go_router`, `routes.dart`,
`app.dart`, `main.dart`, widgets, providers, controllers, datasources,
Supabase, migraciones o CI.

### Nombres candidatos de ruta

| Ruta candidata | Claridad | Riesgo con `/chat/:id` | Compatibilidad con `sessionId` | Compatibilidad con Stasis | Evaluación |
| --- | --- | --- | --- | --- | --- |
| `/chat` | Alta para producto | Alto: convive cerca de `/chat/:id` y exige cuidado de orden/routing | Buena como shell sin parámetro | Media | No recomendada ahora por cercanía semántica con ruta heredada. |
| `/chat/sessions` | Media-alta | Medio: prefijo `/chat` sigue cerca del heredado | Buena | Media | Viable, pero aún puede confundirse con `/chat/:id`. |
| `/chat/safe` | Media | Medio | Buena | Baja-media | Útil internamente, poco natural para producto. |
| `/conversations` | Alta | Bajo: no colisiona con `/chat/:id` | Buena como shell sin parámetro | Alta | Recomendada como candidata principal. |
| `/conversations/:sessionId` | Alta para deep link | Bajo respecto a `/chat/:id` | Alta, pero exige validación fuerte | Alta | Futura fase, no primera puerta productiva. |
| `/stasis/chat` | Alta para Home/Stasis | Bajo respecto a `/chat/:id` | Media | Muy alta | Viable para Stasis, pero mezcla ruta general con caso Stasis. |
| `/stasis/sessions` | Media | Bajo | Buena | Alta | Viable si el producto decide que Stasis es la entrada única. |

La candidata preferida para el primer diseño productivo separado es
`/conversations`, porque evita el prefijo heredado `/chat/:id`, no introduce
parámetros ambiguos y puede montar un shell compuesto donde el `sessionId` se
obtiene internamente desde `chat_sessions`.

### Semántica correcta

Reglas obligatorias:

```text
selectableSpecialistId crea sesión
sessionId abre mensajes
agentId no abre mensajes
id heredado no abre mensajes
/chat/:id no se reutiliza
/orchestrator/chat no se reutiliza
```

La ruta productiva futura no debe aceptar `agentId`, inherited `id`,
`selectableSpecialistId`, `userId`, `ownerUserId`, token ni ownership como
entrada pública para messages.

### Opciones productivas

#### Opción A — Ruta productiva sin parámetro `/chat`

Monta un shell seguro compuesto y deja que el usuario seleccione o cree sesión.

Ventajas:

- evita `id` ambiguo;
- nombre familiar para producto.

Riesgos:

- colisión conceptual fuerte con `/chat/:id`;
- riesgo de que futuros cambios de orden en router confundan `/chat` y
  `/chat/:id`;
- exige tests muy explícitos para preservar el heredado bloqueado.

No recomendada como primera ruta segura.

#### Opción B — Ruta productiva nueva separada `/conversations`

Monta un shell seguro compuesto sin parámetro y sin reutilizar `/chat/:id`.

Ventajas:

- menor riesgo de colisión heredada;
- semántica clara: lista/selección/creación de conversaciones;
- conserva `sessionId` como estado interno seguro antes de messages;
- permite después añadir `/conversations/:sessionId` como deep link con
  ownership y 404 opaco.

Riesgos:

- requiere decisión de naming de producto;
- obliga a decidir cómo convive con navegación Home/Stasis.

Recomendada como candidata principal.

#### Opción C — Ruta por `sessionId` explícito `/conversations/:sessionId`

Solo viable cuando `:sessionId` esté validado como sesión segura y backend
devuelva 404 opaco para sesión ajena/inexistente.

Ventajas:

- deep link directo a conversación;
- semántica técnicamente precisa.

Riesgos:

- requiere auth real, ownership, backend, RLS y tests de no filtrado;
- no debe implementarse como primera puerta productiva.

#### Opción D — Mantener dev-only hasta auth/backend real

Mantener `/dev/chat/composed` como única ruta validada.

Ventajas:

- máxima seguridad;
- evita una puerta visual productiva prematura.

Riesgos:

- no permite validar navegación productiva con usuarios internos.

### Recomendación

Recomendación de 2B-AE1:

```text
No reutilizar /chat/:id.
No reutilizar /orchestrator/chat.
Preferir /conversations como futura ruta productiva segura separada sin parámetro.
No implementar /conversations/:sessionId todavía.
```

`/conversations` debería montar en el futuro `OwnChatComposedSafeShell` o un
shell productivo equivalente, pero solo tras un paquete de implementación
separado y aprobado.

### Requisitos antes de implementación futura

Antes de implementar la ruta futura:

- aprobación explícita;
- paquete separado;
- nombre de ruta aprobado;
- sin tocar `/chat/:id`;
- sin tocar `/orchestrator/chat`;
- sin chat heredado;
- `OwnChatComposedSafeShell` o shell productivo equivalente;
- `sessionId` explícito interno;
- UI sin token;
- UI sin `userId`;
- UI sin `ownerUserId`;
- UI sin ownership;
- backend valida ownership;
- sin Supabase directo desde UI;
- sin writes directos desde Flutter;
- auth/session aprobado;
- `chat_sessions` aprobado;
- `messages` aprobado;
- adapter aprobado;
- tests routing;
- tests widget;
- tests providers;
- tests arquitectura;
- rollback definido.

### Relación con auth real/backend remoto

Decisión importante:

```text
Una ruta productiva visual puede existir solo si sigue backendBlocked/demo
explícito, pero una ruta productiva real con datos reales requiere auth real,
backend real y RLS aprobados.
```

Variantes:

- Variante 1 — Ruta productiva bloqueada visualmente: existe en producto, pero
  muestra `backendBlocked` hasta que auth/backend real estén listos. Puede ser
  útil para navegación interna, pero exige copy claro.
- Variante 2 — Ruta productiva no registrada todavía: más segura hasta tener
  auth/backend real. Recomendable si no se necesita validación de navegación.
- Variante 3 — Ruta productiva con datos reales: bloqueada todavía; requiere
  auth real, backend real, RLS/ownership, auditoría y pruebas.

### Riesgos clasificados

Bloqueantes:

- colisión con `/chat/:id`;
- router resolviendo `/chat` antes/después de `/chat/:id` de forma ambigua;
- `agentId` tratado como `sessionId`;
- `sessionId` tratado como `agentId`;
- `/orchestrator/chat` reusado;
- chat heredado montado;
- datos reales sin auth/RLS.

Altos:

- `SupabaseChatDataSource` reactivado;
- writes directos desde Flutter;
- UI enviando `userId`;
- UI decidiendo ownership;
- fallback demo desde error real.

Medios:

- nombre de ruta confuso para producto;
- coexistencia temporal con chat heredado;
- navegación de Stasis no decidida.

Bajos:

- copy interno insuficiente;
- ausencia de validación visual humana previa.

### Plan de migración futura

Fases posibles:

1. Ruta productiva separada bloqueada/backendBlocked, por ejemplo
   `/conversations`, sin datos reales.
2. Auth/backend real aprobado.
3. Datos reales bajo RLS y ownership verificados.
4. Deprecación, aislamiento o retirada de `/chat/:id`.
5. Decisión específica sobre `/orchestrator/chat` y cómo Stasis obtiene o crea
   `sessionId`.

### Siguiente paquete propuesto

Siguiente recomendado:

```text
2B-AE2 — decidir nombre y semántica de ruta productiva segura
```

Alternativas válidas:

- `2B-AF — plan auth real/Supabase real seguro`;
- `2B-AG — backend remoto seguro`;
- mantener dev-only hasta que auth/backend real estén más maduros.

## Decisión 2B-AE2 — nombre y semántica de ruta productiva segura

### Estado

2B-AE1 queda aprobado y cerrado formalmente. La candidata principal para una
futura ruta productiva segura queda confirmada como `/conversations`. Routing
productivo sigue bloqueado y esta decisión no registra la ruta, no modifica
`go_router`, no modifica código y no conecta producto, remoto ni datos reales.

### Nombre de ruta decidido

Nombre aprobado para la futura ruta productiva segura:

```text
/conversations
```

Motivos:

- no colisiona semánticamente con `/chat/:id`;
- no usa `id` ambiguo;
- no sugiere `agentId`;
- expresa un flujo compuesto de sesiones/conversaciones y mensajes;
- puede convivir con chat heredado durante una transición controlada;
- deja abierta una futura fase `/conversations/:sessionId` si se aprueba más
  adelante;
- es más limpia para producto que `/chat/safe`.

Opciones descartadas para la primera ruta productiva segura:

- `/chat`: demasiado cercana a `/chat/:id`;
- `/chat/sessions`: mantiene prefijo heredado;
- `/chat/safe`: nombre interno, poco productivo;
- `/stasis/chat`: mezcla la ruta general de conversaciones con el caso Stasis;
- `/stasis/sessions`: viable solo si Stasis se decide como única entrada;
- `/conversations/:sessionId`: reservada para una fase futura con auth, backend,
  ownership, 404 opaco y RLS.

### Semántica decidida

Semántica formal:

```text
/conversations = puerta productiva segura futura para flujo compuesto de conversaciones
```

Cuando se implemente en un paquete futuro, deberá montar
`OwnChatComposedSafeShell` o un shell productivo equivalente, bajo estas reglas:

- `chat_sessions` crea, lista y selecciona `sessionId`;
- `messages` recibe solo `sessionId` explícito;
- UI no recibe token;
- UI no envía `userId`;
- UI no envía `ownerUserId`;
- UI no decide ownership;
- backend valida ownership;
- errores reales no caen a demo.

### Lo que no significa la ruta

`/conversations` no significa:

- `agentId`;
- `specialistId` interno;
- `selectableSpecialistId`;
- `/chat/:id`;
- `/orchestrator/chat`;
- chat heredado;
- `SupabaseChatDataSource`;
- writes directos desde Flutter;
- acceso directo a datos reales;
- `sessionId` por parámetro de ruta en esta fase.

### Relación con rutas heredadas

Decisión:

```text
/chat/:id permanece heredada hasta decisión futura.
/orchestrator/chat permanece heredada hasta decisión futura.
/conversations no reemplaza automáticamente a /chat/:id.
/conversations no reemplaza automáticamente a /orchestrator/chat.
```

Cualquier migración, retirada, redirección, deprecación o aislamiento de esas
rutas requiere paquete separado, aprobación explícita, tests y rollback.

### Variante inicial decidida

Se comparan tres variantes:

- Variante A — `/conversations` registrada pero `backendBlocked`/product-safe:
  útil para navegación visual, pero puede crear una puerta productiva prematura.
- Variante B — `/conversations` no registrada hasta auth/backend real o decisión
  de implementación separada: máxima seguridad y menor riesgo de confusión.
- Variante C — `/conversations` con datos reales: bloqueada.

Decisión de 2B-AE2:

```text
Elegir Variante B por ahora: decidir nombre y semántica, pero no registrar ruta productiva todavía.
```

Motivo: todavía no hay auth real, Supabase real, backend remoto ni RLS
productivo aprobados para datos reales.

### Requisitos antes de implementación futura

Antes de implementar `/conversations`:

- aprobación explícita;
- paquete separado;
- ruta `/conversations` aprobada;
- sin tocar `/chat/:id`;
- sin tocar `/orchestrator/chat`;
- sin chat heredado;
- sin `SupabaseChatDataSource`;
- sin writes directos desde Flutter;
- sin Supabase directo desde UI;
- `OwnChatComposedSafeShell` o shell productivo equivalente;
- `sessionId` explícito obligatorio;
- UI sin token;
- UI sin `userId`;
- UI sin `ownerUserId`;
- UI sin ownership;
- backend valida ownership;
- `backendBlocked`/demo explícitos si no hay backend real;
- sin fallback demo desde error real;
- tests routing;
- tests widget;
- tests providers;
- tests arquitectura;
- rollback definido.

### Riesgos clasificados

Bloqueantes:

- registrar `/conversations` demasiado pronto con datos reales;
- colisión con `/chat/:id`;
- `agentId` tratado como `sessionId`;
- `selectableSpecialistId` tratado como `sessionId`;
- chat heredado montado por accidente;
- datos reales sin auth/RLS.

Altos:

- router resolviendo rutas antiguas y nuevas de forma ambigua;
- `SupabaseChatDataSource` reactivado;
- writes directos desde Flutter;
- UI enviando `userId`;
- fallback demo desde error real.

Medios:

- confusión de producto entre chat heredado y conversaciones nuevas;
- falta de estrategia de deprecación de `/chat/:id`;
- navegación de Stasis no decidida.

Bajos:

- copy de ruta insuficiente;
- falta de validación visual previa a implementación.

### Siguiente paquete propuesto

Siguiente recomendado:

```text
2B-AE3 — cierre decisión routing productivo seguro
```

Alternativas válidas:

- `2B-AF — plan auth real/Supabase real seguro`;
- `2B-AG — backend remoto seguro`;
- `2B-AE3 — plan implementación futura /conversations backendBlocked`.

## Cierre 2B-AE3 — decisión routing productivo seguro

### Estado completo de 2B-AE

2B-AE2 queda aprobado y cerrado formalmente. El frente 2B-AE queda cerrado
documentalmente como decisión de routing productivo seguro, sin implementación
de código y sin registro de ruta productiva.

Quedan cerrados:

- `2B-AE — plan routing productivo seguro`;
- `2B-AE1 — plan nueva ruta productiva segura separada`;
- `2B-AE2 — decisión nombre y semántica de ruta productiva segura`;
- `2B-AE3 — cierre decisión routing productivo seguro`.

### Decisiones finales de routing

Decisiones firmes:

- `/conversations` será la futura ruta productiva segura candidata.
- `/conversations` no se registra hasta paquete separado.
- `/conversations` no acepta parámetros inicialmente.
- `/conversations/:sessionId` queda reservado para fase futura.
- `/chat/:id` no se reutiliza.
- `/orchestrator/chat` no se reutiliza.
- `/chat/:id` sigue siendo `agentId` heredado.
- `/orchestrator/chat` sigue siendo flujo heredado.
- chat heredado no se toca en este frente.

### Bloqueos vigentes

Siguen bloqueados:

- registro de `/conversations`;
- routing productivo;
- `/chat/:id` como ruta segura;
- `/orchestrator/chat` como ruta segura;
- navegación real;
- chat heredado;
- `AgentChatWrapper` heredado;
- `ChatPage` heredado;
- `ChatController` heredado;
- `chat_providers` heredado;
- `SupabaseChatDataSource` heredado;
- auth heredado;
- Supabase real;
- Supabase remoto;
- producción;
- datos reales;
- auth real productivo;
- login/register real;
- refresh real contra backend;
- IA;
- Stasis Engine;
- MCP;
- streaming;
- adjuntos.

### Requisitos antes de registrar /conversations

Antes de cualquier implementación futura de `/conversations`:

- aprobación explícita;
- paquete separado;
- decisión sobre `backendBlocked` visual o auth/backend real;
- sin tocar `/chat/:id`;
- sin tocar `/orchestrator/chat`;
- sin chat heredado;
- sin `SupabaseChatDataSource`;
- sin writes directos desde Flutter;
- sin Supabase directo desde UI;
- `OwnChatComposedSafeShell` o shell productivo equivalente;
- `sessionId` explícito obligatorio;
- UI sin token;
- UI sin `userId`;
- UI sin `ownerUserId`;
- UI sin ownership;
- backend valida ownership;
- `backendBlocked`/demo explícitos si no hay backend real;
- sin fallback demo desde error real;
- tests routing;
- tests widget;
- tests providers;
- tests arquitectura;
- rollback definido.

### Relación con auth real/backend remoto

2B-AE no autoriza:

- auth real;
- Supabase real;
- backend remoto;
- RLS productivo;
- datos reales.

Antes de una ruta productiva real con datos reales probablemente conviene
abordar:

- `2B-AF — plan auth real/Supabase real seguro`; o
- `2B-AG — backend remoto seguro`.

### Riesgos residuales

Riesgos que permanecen:

- confundir decisión de nombre con implementación;
- registrar `/conversations` demasiado pronto;
- reutilizar `/chat/:id` por comodidad;
- reutilizar `/orchestrator/chat` por comodidad;
- tratar `agentId` como `sessionId`;
- tratar `selectableSpecialistId` como `sessionId`;
- reactivar `SupabaseChatDataSource`;
- introducir writes directos desde Flutter;
- introducir datos reales sin auth/RLS;
- fallback demo desde error real.

### Recomendación final

Cerrar 2B-AE. No implementar `/conversations` todavía.

Siguiente bloque prudente:

```text
2B-AF — plan auth real/Supabase real seguro
```

Motivo: ya existe decisión de ruta, pero todavía faltan auth real, Supabase
real/backend remoto y RLS productivo antes de abrir una puerta productiva real.

### Siguiente paquete propuesto

Siguiente recomendado:

```text
2B-AF — plan auth real/Supabase real seguro
```

Alternativas válidas:

- `2B-AG — backend remoto seguro`;
- `2B-AE4 — plan implementación /conversations backendBlocked visual`;
- otro bloque técnico.

## Plan 2B-AF — auth real/Supabase real seguro

### Estado

2B-AE3 queda aprobado y cerrado formalmente. La ruta futura
`/conversations` queda decidida como puerta productiva segura candidata, pero
no se registra, no se implementa y no reemplaza a `/chat/:id` ni a
`/orchestrator/chat`.

2B-AF es un plan documental. No autoriza implementación de auth real,
Supabase real, backend remoto, rutas productivas, datos reales ni conexión con
chat heredado.

### Auditoría auth actual

Estado verificado:

- La capa nueva `lib/core/auth/session/` define `SecureSessionTokenProvider`,
  estados explícitos de sesión, resultados de token, controller, providers,
  guard de entorno y fuentes mockables.
- `SecureSessionState` no expone token al estado público.
- `SecureSessionTokenResult.success` exige token no vacío.
- Los estados `demo`, `unauthenticated`, `expired`, `refreshFailed`,
  `backendBlocked` y `misconfigured` son explícitos y no caen a demo.
- `SecureRealSessionGuard` bloquea backend real/producción si faltan aprobación
  o configuración.
- `secureSessionTokenProvider` mantiene non-demo como `backendBlocked` mientras
  no exista implementación real aprobada.
- Los adapters seguros de `chat_sessions` y `chat_messages` consumen token a
  través de `SecureSessionToLocalSessionTokenAdapter`, no desde UI.

Auth heredado verificado:

- `lib/features/auth/data/datasources/supabase_auth_datasource.dart` usa
  Supabase Auth directamente.
- `lib/features/auth/presentation/viewmodels/auth_providers.dart` expone
  `Supabase.instance.client`.
- `lib/main.dart` inicializa Supabase solo si `environment.usesBackend`, pero
  `AppEnvironment.validateForStartup` mantiene backend real bloqueado por
  defecto.
- `lib/core/config/routes.dart` consulta `authControllerProvider` heredado
  cuando `environment.usesBackend`.
- El auth heredado no debe conectarse al flujo seguro hasta que exista paquete
  separado de migración o reemplazo.

Piezas bloqueadas para el flujo nuevo:

- `SupabaseAuthDataSource`;
- `authControllerProvider` heredado como fuente de autorización;
- `supabaseClientProvider` heredado;
- rutas login/register reales como condición para `/conversations`;
- cualquier lectura de permisos o ownership desde Flutter.

Piezas adaptables solo con aprobación futura:

- `UserModel`/`UserEntity` como representación mínima sin roles;
- pantallas de login/register como UX futura, no como autoridad;
- `Supabase.instance.client.auth` únicamente detrás de
  `SecureRealSessionSource`, nunca desde UI ni repositorios de producto.

### Auditoría Supabase actual

Estado verificado:

- `00001_initial_schema.sql` crea el esquema base, incluyendo `users`,
  `specialists`, `chat_sessions`, `messages`, membresías y tablas sensibles.
- `00002_enable_rls_public_users_deny_all.sql` habilita RLS deny-all en
  `public.users`.
- `00003_public_users_owner_profile_minimal.sql` permite solo perfil propio
  mínimo: `SELECT(id, display_name)` y `UPDATE(display_name)`.
- `00004_create_specialist_catalog_deny_all.sql` crea catálogo sanitizado y
  bloquea tablas sensibles de especialistas.
- `00005_harden_chat_sessions_deny_all.sql` endurece `chat_sessions` con RLS,
  cero policies y cero grants cliente.
- `00006_harden_messages_deny_all.sql` endurece `messages` con RLS, cero
  policies, cero grants cliente y constraints mínimos.
- `00007_create_send_user_message_core_rpc.sql` crea
  `send_user_message_core`, transaccional, sin `SECURITY DEFINER`, sin grants
  para `anon`/`authenticated` y con ejecución local de backend.

Edge Functions locales verificadas:

- `list-selectable-specialists`;
- `create-own-chat-session`;
- `list-own-chat-sessions`;
- `archive-own-chat-session`;
- `send-user-message`;
- `list-session-messages`.

Estas funciones son local-safe/dev-test. Usan validación JWT local, entorno
local controlado y `SUPABASE_SERVICE_ROLE_KEY` solo en runtime local de función,
nunca en Flutter. No desbloquean remoto ni producción.

Datasource heredado bloqueado:

- `SupabaseChatDataSource` escribe directamente en `chat_sessions` y
  `messages` desde Flutter fuera de demo. No se puede reutilizar en el flujo
  seguro.

Datasource nuevo local-safe:

- `LocalHttpOwnChatSessionsDataSource` y
  `LocalHttpOwnChatMessagesDataSource` hablan con Edge Functions locales
  mediante transporte inyectable, host policy local y token provider inyectado.
  No son productivos ni remotos.

### Frontera auth real segura

La frontera futura aprobable debe ser:

```text
SecureSession
-> SecureRealSessionSource
-> implementación real aislada o mockable
-> SecureRealSessionTokenProvider
-> SecureSessionToLocalSessionTokenAdapter
-> feature token providers
-> datasources HTTP/Edge Functions
```

Reglas obligatorias:

- UI nunca recibe token.
- UI nunca refresca token.
- UI nunca pasa `userId`, `ownerUserId` ni ownership.
- UI nunca decide permisos administrativos.
- UI nunca lee `userMetadata` para autorización crítica.
- Token vacío equivale a sesión inválida.
- `expired` es estado explícito.
- `refreshFailed` es estado explícito.
- `backendBlocked` es estado explícito.
- `misconfigured` es estado explícito.
- Ningún error real puede convertirse en demo.
- La implementación real no puede importar chat heredado.
- La implementación real no puede exponer `Supabase.instance.client` a
  features.
- Cualquier bridge con Supabase Auth debe vivir detrás de
  `SecureRealSessionSource`.

### Frontera Supabase real segura

La frontera futura aprobable debe ser:

```text
Flutter -> Edge Functions -> RPC/RLS -> tables
```

Queda prohibido:

```text
Flutter -> Supabase tables direct writes
Flutter -> service_role
Flutter -> user_id enviado por UI
Flutter -> ownerUserId enviado por UI
Flutter -> specialist_id interno decidido por UI
Flutter -> role decidido por UI
Flutter -> SELECT/INSERT/UPDATE/DELETE directo sobre tablas sensibles
```

Permitido solo con aprobación futura:

- datasource añade `Authorization: Bearer <access_token>`;
- Edge Function valida JWT;
- backend obtiene usuario desde JWT validado;
- backend valida ownership sin confiar en UI;
- backend resuelve `selectableSpecialistId` contra catálogo sanitizado;
- RPC transaccional escribe datos cuando proceda;
- RLS protege tablas incluso si falla una capa superior;
- logs sin tokens, secretos, PII sensible ni contenido de salud real.

### Entornos

| Entorno | `usesBackend` | Supabase real | Auth real | Datos reales | Edge Functions remotas | `/conversations` | Misconfiguration |
| --- | --- | --- | --- | --- | --- | --- | --- |
| local | Opcional solo harness | Local/efímero | JWT local de test | No | No | Solo dev-route ya aprobada, no productiva | Fallar cerrado |
| demo | No | No | No | No | No | No registrada | Mostrar demo explícito |
| development | Sí, futuro | Solo proyecto no productivo aprobado | Futuro, detrás de `SecureRealSessionSource` | No | Futuro, con allowlist | Futuro, preferible `backendBlocked` primero | Fallar cerrado, nunca demo |
| staging | Sí, futuro | Proyecto staging aislado | Futuro | Solo sintéticos/pseudonimizados aprobados | Futuro | Futuro tras gates | Fallar cerrado |
| production | Sí, futuro | Sí, solo tras aprobación | Sí, solo tras aprobación | Sí, solo tras RLS/auditoría/tests | Sí, solo tras aprobación | Futuro tras gates | Bloquear arranque |

Reglas comunes:

- No versionar secretos.
- No loguear tokens.
- No loguear `Authorization`.
- No usar claves reales en tests.
- No permitir remoto desde host policy local.
- No degradar backend/prod a demo.

### Gates antes de auth real

Antes de implementar auth real se exige:

- aprobación explícita de paquete;
- decisión sobre reutilizar o reemplazar `features/auth`;
- implementación real detrás de `SecureRealSessionSource`;
- tests de `SecureRealSessionGuard`;
- tests de estados `authenticated`, `unauthenticated`, `expired`,
  `refreshFailed`, `backendBlocked` y `misconfigured`;
- tests que demuestren que el estado público no contiene token;
- tests que bloqueen imports de `features/auth` heredado en la frontera segura;
- tests que bloqueen `Supabase.instance.client` en providers/datasources
  seguros;
- no fallback demo desde error real;
- rollback a `backendBlocked`;
- documentación de entornos y secretos fuera del repo.

### Gates antes de Supabase real

Antes de permitir Supabase real se exige:

- proyecto remoto no productivo aprobado;
- separación local/development/staging/production;
- variables de entorno documentadas sin secretos versionados;
- Edge Functions remotas desplegadas y probadas en entorno no productivo;
- JWT validado por backend antes de ownership;
- RLS activa y tests negativos para tablas usadas;
- cero writes directos desde Flutter;
- cero `service_role` en Flutter;
- cero `userId`, `ownerUserId`, `specialist_id` interno o `role` enviados por UI;
- pruebas de host remoto permitido solo en entorno aprobado;
- pruebas de host remoto bloqueado en demo/local-safe;
- logs seguros;
- rollback a backendBlocked/demo explícito.

### Gates antes de datos reales

Antes de datos reales se exige:

- auth real aprobada y verificada;
- RLS completa para las tablas implicadas;
- pruebas de aislamiento entre usuarios;
- pruebas de no filtrado para recursos ajenos;
- auditoría de permisos administrativos;
- política de retención/borrado;
- clasificación de datos sensibles;
- prohibición de salud/wellness/chats reales sin autorización explícita;
- revisión AppSec/privacidad;
- plan de incidentes y rollback;
- ADR adicional si se abren datos de salud, memoria, investigaciones o pagos.

### Riesgos clasificados

Bloqueantes:

- conectar `SupabaseAuthDataSource` heredado al flujo seguro;
- exponer `Supabase.instance.client` a providers seguros;
- permitir `service_role` en Flutter;
- enviar `userId`, `ownerUserId`, `specialist_id` o `role` desde UI;
- convertir errores reales en demo;
- usar `/chat/:id` o `/orchestrator/chat` como entrada al flujo seguro.

Altos:

- inicializar Supabase real sin gates de entorno;
- registrar `/conversations` antes de auth/backend;
- confiar en `userMetadata`;
- habilitar remoto con tests solo locales;
- logs con tokens o datos sensibles.

Medios:

- duplicar auth segura y auth heredada sin plan de retirada;
- UX de login/register que parezca productiva sin backend aprobado;
- confusión entre token provider local-safe y token provider real.

Bajos:

- copy insuficiente para estados `backendBlocked`/`misconfigured`;
- documentación de entorno desactualizada.

### Recomendación

No implementar auth real ni Supabase real todavía.

Cerrar 2B-AF como plan de frontera y abrir un paquete más pequeño:

```text
2B-AF1 — plan entorno development/staging Supabase seguro
```

Ese paquete debería decidir primero proyecto/entorno, variables, secreto,
guardias de arranque, allowlist de hosts, estrategia de pruebas y rollback, sin
conectar aún UI ni rutas productivas.

### Fuera de alcance de 2B-AF

Queda fuera:

- código;
- auth real;
- Supabase real;
- remoto;
- producción;
- datos reales;
- migraciones;
- Edge Functions;
- CI;
- registro de `/conversations`;
- `/chat/:id`;
- `/orchestrator/chat`;
- chat heredado;
- Stasis Engine;
- MCP;
- IA;
- streaming;
- adjuntos.

## Plan 2B-AF1 — entorno development/staging Supabase seguro

### Estado

2B-AF queda aprobado y cerrado formalmente. Auth real y Supabase real quedan
planificados como frontera futura, pero no implementados. 2B-AF1 es un plan
documental para definir entornos `development` y `staging` antes de cualquier
conexión real.

2B-AF1 no autoriza código, configuración, proyectos Supabase, remoto, auth real,
Supabase real, datos reales, rutas productivas ni `/conversations`.

### Configuración actual auditada

Estado verificado:

- `AppRuntimeMode` existe con tres modos: `demo`, `backendReal` y
  `production`.
- No existen todavía modos técnicos separados llamados `development` o
  `staging`.
- `Env.appMode` lee `APP_MODE` por `--dart-define` y usa `demo` como valor
  seguro por defecto.
- `Env.supabaseUrl` lee `SUPABASE_URL`; por defecto es cadena vacía.
- `Env.supabaseAnonKey` lee `SUPABASE_ANON_KEY`; por defecto es cadena vacía.
- `AppEnvironment.isDemo` solo es verdadero en `demo`.
- `AppEnvironment.usesBackend` es `true` para todo lo que no sea demo.
- `validateForStartup` permite demo sin backend.
- `validateForStartup` bloquea backend real si faltan `SUPABASE_URL` o
  `SUPABASE_ANON_KEY`.
- `validateForStartup` bloquea backend real por defecto si no se pasa
  `backendActivationApproved`.
- `main.dart` solo inicializa Supabase cuando `environment.usesBackend`.
- `routes.dart` solo registra rutas dev-only si `!kReleaseMode` y
  `environment.isDemo`.
- `routes.dart` consulta auth heredado cuando `environment.usesBackend`; ese
  camino sigue bloqueado para el flujo seguro.

Brechas antes de development/staging seguro:

- falta decidir si `development`/`staging` serán nuevos `APP_MODE` o una capa
  adicional de entorno sobre `backendReal`;
- falta separar flags de activación de backend/auth/Supabase por entorno;
- falta allowlist explícita de hosts remotos por entorno;
- falta política de secretos por entorno;
- falta política de datos sintéticos/semillas por entorno;
- falta estrategia para no inicializar auth heredado al activar backend seguro;
- falta rollback documentado a `backendBlocked`.

### Entorno development definido

`development` será un entorno no productivo para validar integración remota
controlada sin datos reales.

Reglas:

- permite Supabase real: solo proyecto development aprobado en paquete futuro;
- permite auth real: solo tras aprobación futura y detrás de
  `SecureRealSessionSource`;
- permite datos reales: no;
- permite datos sintéticos: sí, marcados como no productivos;
- permite Edge Functions remotas: solo tras aprobación futura;
- permite logs técnicos: sí, sin tokens, `Authorization`, refresh tokens, PII
  sensible ni contenido de chats/salud reales;
- permite `/conversations`: no por ahora;
- permite `/dev/chat/composed`: solo si sigue protegido por demo/dev gates, no
  como ruta remota/productiva;
- permite `service_role` en Flutter: nunca;
- permite `SupabaseChatDataSource`: no.

Comportamiento ante errores:

- `SUPABASE_URL` ausente: fallar cerrado como misconfiguration/backendBlocked;
- `SUPABASE_ANON_KEY` ausente: fallar cerrado;
- entorno mal configurado: fallar cerrado;
- backend real solicitado sin aprobación: `backendBlocked`;
- token expirado: estado `expired`, sin fallback demo;
- refresh fallido: estado `refreshFailed`, sin fallback demo;
- error RLS: error visible/controlado, sin éxito mock;
- error Edge Function: error visible/controlado, sin local fallback silencioso.

### Entorno staging definido

`staging` será entorno preproductivo aislado, cercano a producción, pero sin
datos reales inicialmente.

Reglas:

- permite Supabase real: solo proyecto staging separado;
- permite auth real: solo tras aprobación futura;
- permite datos reales: no inicialmente;
- permite datos sintéticos/seed controlado: sí, con limpieza y marcadores
  explícitos;
- permite Edge Functions remotas: solo tras aprobación futura;
- permite logs técnicos: sí, minimizados;
- permite `/conversations`: no hasta paquete separado;
- permite `/dev/chat/composed`: no si staging no es demo/dev;
- permite `service_role` en Flutter: nunca;
- permite producción como fallback: nunca.

Comportamiento ante misconfiguration:

- fallar cerrado;
- mostrar `backendBlocked` o `misconfigured` explícito;
- no caer a demo;
- no usar local fallback silencioso;
- no usar production por defecto;
- no mezclar seeds sintéticos con datos reales.

### Production como referencia bloqueada

Production queda fuera de alcance de AF1. Reglas futuras mínimas:

- no datos reales sin RLS auditado;
- no auth real sin aprobación;
- no Supabase real sin staging validado;
- no `service_role` en cliente;
- no logs con tokens, refresh tokens ni `Authorization`;
- no fallback demo;
- no rutas `/dev`;
- no datos sintéticos mezclados con reales;
- no `/conversations` sin paquete específico;
- no chat heredado como backend productivo.

### Matriz de permisos por entorno

| Entorno | `usesBackend` | Supabase real | Auth real | Datos reales | Datos sintéticos | Edge Functions remotas | `/dev` routes | `/conversations` | Logs permitidos | Secretos permitidos | Error/misconfiguration |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| local | Opcional para harness | Solo local/efímero | JWT local de test | No | Sí, fixtures con cleanup | No | Sí, solo `!kReleaseMode && demo` | No | Técnicos sin tokens | Locales efímeros fuera del repo | Fallar cerrado |
| demo | No | No | No | No | Sí, demo explícito | No | Sí si no release | No | Técnicos mínimos | Ninguno real | Demo explícito |
| development | Futuro | Solo proyecto dev aprobado | Futuro | No | Sí | Futuro aprobado | No salvo demo/dev gate | No | Técnicos sin PII/tokens | Dev fuera del repo | `backendBlocked`/`misconfigured` |
| staging | Futuro | Solo proyecto staging | Futuro | No inicialmente | Sí, controlados | Futuro aprobado | No | No hasta paquete separado | Minimizados | Staging fuera del repo | Fallar cerrado |
| production | Futuro | Bloqueado hasta aprobación | Bloqueado hasta aprobación | Bloqueado hasta gates | No mezclados | Bloqueado hasta aprobación | No | Bloqueado | Minimizados/auditables | Production fuera del repo | Bloquear arranque |

### Secretos y configuración

Reglas:

- ningún secreto en repo;
- `service_role` nunca en Flutter;
- `SUPABASE_SERVICE_ROLE_KEY` solo en runtime backend/Edge Function controlado;
- anon key permitida solo como configuración pública controlada, no como
  permiso de datos;
- `SUPABASE_URL` separado por entorno;
- `SUPABASE_ANON_KEY` separado por entorno;
- variables separadas para development, staging y production;
- no usar claves production en development;
- no usar claves production en staging;
- no screenshots/logs con tokens;
- no imprimir `Authorization`;
- no imprimir refresh token;
- no guardar tokens en `SESSION_TRACKER`;
- no documentar valores reales, solo nombres de variables.

### Gates antes de conectar development

Antes de conectar development:

- aprobación explícita;
- paquete separado;
- proyecto Supabase development creado y aislado;
- secretos fuera del repo;
- decisión sobre `APP_MODE`/entorno técnico;
- `usesBackend` controlado;
- `SecureSession` sigue sin exponer token;
- no auth heredado como fuente de autoridad;
- no `SupabaseChatDataSource`;
- no writes directos desde Flutter;
- Edge Functions revisadas;
- RPC revisadas;
- RLS revisada;
- datos sintéticos solamente;
- tests de arquitectura;
- tests de no fallback demo;
- tests de host allowlist;
- rollback a `backendBlocked`;
- evidencia de no producción.

### Gates antes de conectar staging

Antes de conectar staging:

- development validado;
- aprobación explícita;
- paquete separado;
- proyecto Supabase staging separado;
- secretos staging fuera del repo;
- migraciones aplicadas de forma controlada;
- Edge Functions desplegadas en staging;
- RPC/RLS verificadas;
- datos sintéticos o seed controlado;
- sin datos reales inicialmente;
- logs minimizados;
- tests integración staging;
- tests de aislamiento entre usuarios;
- tests de no filtrado de recursos ajenos;
- rollback definido;
- evidencia de que no usa claves production.

### Riesgos clasificados

Bloqueantes:

- usar claves production en development;
- usar claves production en staging;
- `service_role` en cliente;
- datos reales en development;
- datos reales en staging sin aprobación;
- `misconfigured` tratado como demo;
- fallback demo desde error real;
- `SupabaseChatDataSource` reactivado.

Altos:

- writes directos desde Flutter;
- logs con token;
- RLS incompleta;
- Edge Function aceptando `userId` desde UI;
- remoto permitido sin allowlist;
- staging usando seeds persistentes no limpiables.

Medios:

- llamar `backendReal` tanto a development como a staging sin distinción;
- UI mostrando capacidad productiva cuando solo hay entorno técnico;
- tests locales asumidos como prueba de staging.

Bajos:

- copy insuficiente para `backendBlocked`/`misconfigured`;
- documentación de variables desactualizada.

### Recomendación

No conectar todavía development ni staging. Cerrar AF1 como plan de entornos y
abrir un paquete de decisión más pequeño:

```text
2B-AF2 — decisión matriz de entornos y configuración segura
```

Ese paquete debería decidir si se añaden nuevos modos técnicos, si se mantiene
`backendReal` con una variable adicional de entorno, cómo se nombran variables
por entorno y qué skeleton mínimo se permite sin conectar Supabase.

### Siguiente paquete propuesto

Siguiente recomendado:

```text
2B-AF2 — decisión matriz de entornos y configuración segura
```

Alternativas válidas:

- `2B-AF2 — implementación skeleton de environment development/staging sin conectar Supabase`;
- `2B-AG — backend remoto seguro`;
- `2B-AE4 — plan /conversations backendBlocked visual`;
- otro bloque técnico.

### Fuera de alcance de 2B-AF1

Queda fuera:

- código;
- auth real;
- Supabase real;
- proyectos Supabase;
- remoto;
- production;
- datos reales;
- migraciones;
- Edge Functions;
- CI;
- `go_router`;
- registro de `/conversations`;
- `/chat/:id`;
- `/orchestrator/chat`;
- chat heredado;
- IA;
- Stasis Engine;
- MCP;
- streaming;
- adjuntos.

## Decisión 2B-AF2 — matriz de entornos y configuración segura

### Estado

2B-AF1 queda aprobado y cerrado formalmente. Development y staging quedan
planificados como entornos futuros, no implementados. 2B-AF2 formaliza la
matriz oficial de entornos y configuración segura que deberá guiar paquetes
futuros.

2B-AF2 no modifica `APP_MODE`, `usesBackend`, `validateForStartup`,
`main.dart`, rutas, providers, datasources, Supabase, migraciones ni CI.

### Nombres oficiales de entornos

Se deciden como nombres oficiales:

```text
local
demo
development
staging
production
```

`backendReal` queda clasificado como modo histórico/transitorio del prototipo.
No es el nombre objetivo para entornos reales futuros.

Decisión pragmática:

```text
Mantener backendReal temporalmente hasta paquete de implementación separado,
pero orientar la arquitectura a development/staging/production.
```

No se implementa migración en este paquete.

### Semántica oficial por entorno

#### local

Entorno local de desarrollo y pruebas. No usa backend real por defecto, no usa
datos reales y no usa Supabase remoto. Puede usar Supabase local/efímero solo
en paquetes locales aprobados. Todo error debe fallar cerrado.

#### demo

Entorno de demostración explícita. No usa backend real, datos reales ni
Supabase remoto. Permite UX local-safe, mocks o fakes visibles. Las rutas `/dev`
solo pueden existir si `!kReleaseMode && environment.isDemo`.

#### development

Entorno técnico no productivo. Supabase real y auth real solo podrán activarse
tras aprobación futura. Datos reales prohibidos. Datos sintéticos permitidos.
Logs técnicos permitidos sin tokens ni PII sensible. Misconfiguration debe
producir `backendBlocked` o `misconfigured`, nunca demo.

#### staging

Entorno preproductivo aislado. Requiere Supabase staging separado. Auth real
solo tras aprobación futura. Datos reales prohibidos inicialmente. Seeds
sintéticos controlados permitidos. Logs minimizados. Misconfiguration falla
cerrado y no puede caer a demo, local ni production.

#### production

Entorno productivo real. Queda fuera de alcance. No puede usar datos reales
hasta tener auth, RLS, backend, auditoría y pruebas aprobadas. No permite rutas
`/dev`, fallback demo ni logs sensibles.

### Matriz de permisos decidida

| Entorno | Uso | `usesBackend` | Supabase real | Auth real | Datos reales | Datos sintéticos | Edge Functions remotas | `/dev` routes | `/conversations` | Logs | Secretos | Misconfiguration |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| local | Desarrollo local y harness | No por defecto | No remoto; local/efímero con paquete | No, salvo JWT local de test | No | Sí, con cleanup | No | Sí, solo no release/demo | No registrada | Técnicos sin tokens | Locales efímeros fuera del repo | Fallar cerrado |
| demo | Demo explícita | No | No | No | No | Sí, visibles como demo | No | Sí, solo `!kReleaseMode && isDemo` | No registrada | Mínimos | Ningún secreto real | Demo explícito, no backend |
| development | Integración no productiva futura | Futuro, aprobado | Futuro, proyecto dev separado | Futuro | No | Sí | Futuro, aprobado | No salvo gate demo/dev | No registrada | Técnicos sin tokens/PII | Dev fuera del repo | `backendBlocked`/`misconfigured` |
| staging | Preproducción aislada futura | Futuro, aprobado | Futuro, proyecto staging separado | Futuro | No inicialmente | Sí, controlados | Futuro, aprobado | No | No registrada | Minimizados | Staging fuera del repo | Fail closed |
| production | Producto real futuro | Futuro, aprobado | Futuro, tras gates | Futuro, tras gates | Futuro, tras gates | No mezclados | Futuro, tras gates | No | Futuro, paquete separado | Auditables sin sensibles | Production fuera del repo | Bloquear arranque |

Decisiones firmes:

- datos reales = no en local, demo, development y staging por ahora;
- production = bloqueado hasta gates futuros;
- `/conversations` = no registrada en todos los entornos por ahora;
- `/dev` routes = solo demo/dev local no release según gates existentes;
- staging no puede actuar como demo;
- development no puede usar claves production.

### Reglas de APP_MODE

Opciones evaluadas:

| Opción | Decisión |
| --- | --- |
| A — Mantener `backendReal` como modo genérico | Rechazada como arquitectura objetivo por ambigüedad. |
| B — Sustituir conceptualmente por `development` y `staging` | Aceptada como dirección objetivo. |
| C — Mantener `backendReal` temporalmente y planificar migración | Aceptada como decisión pragmática actual. |

Decisión:

```text
backendReal se mantiene temporalmente como modo histórico/transitorio.
La arquitectura objetivo usará development/staging/production.
```

Una implementación futura deberá decidir si:

- `APP_MODE` acepta directamente `development` y `staging`; o
- `APP_MODE=backendReal` se combina temporalmente con una variable explícita
  de entorno operativo, por ejemplo `APP_ENV=development|staging`.

Hasta esa implementación, no se cambia comportamiento real.

### Comportamiento ante misconfiguration

Decisión firme:

- misconfiguration nunca cae a demo;
- misconfiguration nunca cae a production;
- misconfiguration nunca usa fallback silencioso;
- misconfiguration muestra estado explícito;
- misconfiguration bloquea backend real;
- misconfiguration no intenta refresh real;
- misconfiguration no inicializa Supabase real;
- misconfiguration no registra rutas productivas;
- misconfiguration no convierte errores backend en éxito mock.

### Reglas de secretos

Decisión firme:

- ningún secreto en repo;
- `service_role` nunca en cliente;
- `SUPABASE_SERVICE_ROLE_KEY` nunca en Flutter;
- `SUPABASE_URL` separado por entorno;
- `SUPABASE_ANON_KEY` separado por entorno;
- anon key tratada como configuración pública controlada;
- no claves production en development;
- no claves production en staging;
- no tokens en logs;
- no `Authorization` en logs;
- no `refresh_token` en logs;
- no capturas con tokens;
- no registrar valores reales en documentación;
- secrets reales solo en gestor externo aprobado.

### Gates antes de implementar configuración

Antes de cualquier implementación futura:

- aprobación explícita;
- paquete separado;
- nombres oficiales aceptados;
- matriz aceptada;
- variables por entorno definidas;
- secrets fuera del repo;
- validación startup fail-closed;
- tests unitarios de configuración;
- tests de arquitectura;
- tests no secrets;
- tests de no fallback demo;
- tests de bloqueo `/dev` en release;
- tests de `/conversations` no registrada;
- rollback a demo/backendBlocked;
- evidencia de que no se usa production por defecto.

### Riesgos clasificados

Bloqueantes:

- `backendReal` ambiguo usado para entornos reales sin distinción;
- `APP_MODE` cayendo a demo en entornos reales;
- usar production keys en development/staging;
- misconfiguration con fallback silencioso;
- `service_role` en cliente;
- datos reales en staging prematuro.

Altos:

- `/conversations` registrada antes de auth/RLS;
- `/dev` routes visibles en release;
- logs con tokens;
- auth heredado reactivado como autoridad;
- `SupabaseChatDataSource` reactivado;
- Supabase remoto conectado sin allowlist.

Medios:

- variables de entorno con nombres ambiguos;
- staging con seeds persistentes;
- copiar configuración entre entornos manualmente.

Bajos:

- copy visual insuficiente para estados bloqueados;
- documentación de entorno duplicada.

### Siguiente paquete propuesto

Siguiente recomendado:

```text
2B-AF3 — cierre matriz de entornos y configuración segura
```

Motivo: conviene cerrar formalmente la decisión antes de cualquier skeleton o
cambio de configuración.

Alternativa válida si se decide avanzar:

```text
2B-AF3 — plan implementación skeleton de entornos sin conectar Supabase
```

### Fuera de alcance de 2B-AF2

Queda fuera:

- código;
- configuración real;
- cambios en `APP_MODE`;
- cambios en `usesBackend`;
- cambios en `validateForStartup`;
- auth real;
- Supabase real;
- development conectado;
- staging conectado;
- production;
- datos reales;
- rutas;
- `/conversations`;
- `/chat/:id`;
- `/orchestrator/chat`;
- chat heredado;
- migraciones;
- Edge Functions;
- CI;
- IA;
- Stasis Engine;
- MCP;
- streaming;
- adjuntos.

## Cierre 2B-AF3 — matriz de entornos y configuración segura

### Estado completo de AF

2B-AF2 queda aprobado y cerrado formalmente. La matriz de entornos queda
decidida y documentada. No se implementó configuración real.

Quedan cerrados:

- `2B-AF — plan auth real/Supabase real seguro`;
- `2B-AF1 — plan entorno development/staging Supabase seguro`;
- `2B-AF2 — decisión matriz de entornos y configuración segura`;
- `2B-AF3 — cierre matriz de entornos y configuración segura`.

Este cierre no autoriza código, configuración real, Supabase real, auth real,
remoto, production, datos reales ni rutas productivas.

### Decisiones finales de entornos

Decisiones firmes:

- `local` = desarrollo local/harness.
- `demo` = demostración explícita sin backend real/remoto.
- `development` = técnico no productivo.
- `staging` = preproductivo aislado.
- `production` = bloqueado hasta gates futuros.
- `backendReal` = histórico/transitorio.

Reglas firmes:

- datos reales = no en `local`, `demo`, `development` y `staging`;
- `/conversations` = no registrada en todos los entornos por ahora;
- rutas `/dev` solo según gates dev/demo y nunca en release;
- misconfiguration nunca cae a demo;
- misconfiguration nunca cae a production;
- misconfiguration nunca usa fallback silencioso;
- `backendReal` no es arquitectura objetivo.

### Bloqueos vigentes

Mantener bloqueado:

- implementación de development;
- implementación de staging;
- Supabase real;
- auth real;
- backend remoto;
- production;
- datos reales;
- `service_role` en cliente;
- production keys en development/staging;
- registro de `/conversations`;
- routing productivo;
- `/chat/:id` como ruta segura;
- `/orchestrator/chat` como ruta segura;
- chat heredado;
- `SupabaseChatDataSource`;
- writes directos desde Flutter;
- fallback demo desde error real;
- logs con tokens;
- logs con `Authorization`;
- logs con `refresh_token`.

### Requisitos antes de implementar configuración

Antes de cualquier implementación futura:

- aprobación explícita;
- paquete separado;
- matriz aceptada;
- variables por entorno definidas;
- secrets fuera del repo;
- tests unitarios de config;
- tests arquitectura;
- tests no secrets;
- startup fail-closed;
- rollback a demo/backendBlocked;
- no production keys en development/staging;
- no `service_role` en Flutter;
- no datos reales.

### Relación con auth real/Supabase real

Esta matriz no autoriza:

- auth real;
- Supabase real;
- backend remoto;
- Edge Functions remotas;
- RLS productivo;
- datos reales.

Antes de conectar Supabase real hará falta un paquete separado con aprobación,
gates de entorno, validación de secretos, tests de arquitectura, RLS/Edge/RPC
revisados y rollback.

### Riesgos residuales

Riesgos que permanecen:

- confundir matriz decidida con configuración implementada;
- mantener `backendReal` ambiguo demasiado tiempo;
- `APP_MODE` cayendo a demo en entorno real;
- usar claves production en development;
- usar claves production en staging;
- `service_role` en cliente;
- datos reales prematuros;
- `/conversations` registrada antes de auth/RLS;
- rutas `/dev` visibles en release;
- logs con tokens;
- fallback silencioso.

### Recomendación final

Cerrar 2B-AF3. El siguiente bloque prudente es:

```text
2B-AF4 — plan skeleton de entornos sin conectar Supabase
```

Motivo: ya se decidió la matriz; antes de conectar auth/Supabase real conviene
diseñar un skeleton de configuración fail-closed, reversible y testeable.

### Siguiente paquete propuesto

Siguiente recomendado:

```text
2B-AF4 — plan skeleton de entornos sin conectar Supabase
```

Alternativas válidas:

- `2B-AG — backend remoto seguro`;
- `2B-AF4 — implementación skeleton de entornos sin conectar Supabase`;
- `2B-AE4 — plan /conversations backendBlocked visual`.

### Fuera de alcance de 2B-AF3

Queda fuera:

- código;
- configuración real;
- cambios en `APP_MODE`;
- cambios en `usesBackend`;
- cambios en `validateForStartup`;
- `app.dart`;
- `main.dart`;
- rutas;
- providers;
- datasources;
- Supabase;
- migraciones;
- Edge Functions;
- CI;
- proyectos Supabase;
- remoto;
- production;
- datos reales;
- `service_role`;
- `/conversations`;
- `/chat/:id`;
- `/orchestrator/chat`;
- chat heredado;
- IA;
- Stasis Engine;
- MCP;
- streaming;
- adjuntos.

## Plan 2B-AF4 — skeleton de entornos sin conectar Supabase

### Estado

2B-AF3 queda aprobado y cerrado formalmente. La matriz de entornos queda
cerrada, pero la configuración real sigue sin implementarse. 2B-AF4 prepara un
plan para un skeleton futuro fail-closed, sin conectar Supabase real.

2B-AF4 es documental. No modifica `APP_MODE`, `usesBackend`,
`validateForStartup`, `main.dart`, rutas, providers, datasources, Supabase,
migraciones ni CI.

### Skeleton actual de configuración auditado

Estado verificado:

- `APP_MODE` se define en `lib/core/config/env.dart` mediante
  `String.fromEnvironment('APP_MODE', defaultValue: 'demo')`.
- `SUPABASE_URL` y `SUPABASE_ANON_KEY` se leen también en `Env`.
- `AppRuntimeMode` vive en `lib/core/config/app_environment.dart` y hoy solo
  incluye `demo`, `backendReal` y `production`.
- `AppEnvironment.fromEnvironment` construye configuración desde `Env`.
- `AppEnvironment.isDemo` depende de `mode == AppRuntimeMode.demo`.
- `AppEnvironment.usesBackend` es `true` para todo modo no-demo.
- `validateForStartup` vive en `AppEnvironment`; demo arranca, backend no-demo
  falla si faltan `SUPABASE_URL`/`SUPABASE_ANON_KEY` o si no hay
  `backendActivationApproved`.
- `main.dart` inicializa Supabase solo si `environment.usesBackend`.
- `routes.dart` registra rutas `/dev` solo cuando `!kReleaseMode` y
  `environment.isDemo`.
- `test/core/config/app_environment_test.dart` cubre demo por defecto,
  backendReal sin configuración y backendReal bloqueado aun con configuración.
- `test/core/config/dev_chat_messages_route_test.dart` cubre que rutas dev-only
  existen solo bajo gates y no importan chat heredado/Supabase.

Qué habría que ampliar en un futuro skeleton:

- enum o equivalente para `local`, `demo`, `development`, `staging`,
  `production` y legacy `backendReal`;
- parser explícito de `APP_MODE`;
- default seguro dependiente de contexto;
- flags derivados por entorno;
- validación fail-closed separada de conexión real;
- mensajes de error explícitos;
- tests unitarios y de arquitectura para no secrets/no fallback/no rutas
  productivas.

Qué no debe tocarse todavía:

- inicialización real de Supabase;
- rutas reales;
- auth heredado;
- datasources;
- providers de producto;
- migraciones;
- Edge Functions;
- CI.

### Futuro skeleton de entornos

El skeleton futuro debe soportar conceptualmente:

```text
local
demo
development
staging
production
backendReal legacy/transitional
```

Componentes propuestos:

- `AppRuntimeMode` o nuevo tipo equivalente con los nombres oficiales.
- Parser explícito de `APP_MODE`.
- Compatibilidad temporal con `backendReal`.
- Default seguro.
- Flags derivados.
- Validación fail-closed.
- Mensajes de error trazables.
- Tests unitarios de parsing/flags/validación.
- Tests de arquitectura contra secrets y conexiones accidentales.

El skeleton no debe:

- conectar Supabase;
- activar auth real;
- registrar `/conversations`;
- tocar `/chat/:id`;
- tocar `/orchestrator/chat`;
- habilitar datos reales;
- permitir `service_role` en Flutter.

### Default seguro recomendado

Opciones evaluadas:

| Opción | Evaluación |
| --- | --- |
| A — Default a demo | Compatible con el estado actual, pero riesgosa si un entorno real mal configurado cae a demo. |
| B — Default a local/demo solo en debug | Más segura, requiere distinguir contexto local/debug de entorno real. |
| C — Default a misconfigured si `APP_MODE` falta en entornos no locales | Recomendada como dirección futura. |

Recomendación:

```text
Mantener compatibilidad actual por ahora, pero diseñar futuro fail-closed:
APP_MODE ausente solo puede caer a demo/local en ejecución local explícita.
En entornos reales debe producir misconfigured/backendBlocked.
```

La implementación futura debe evitar que ausencia de `APP_MODE` en builds reales
se interprete como demo productivo.

### Flags derivados propuestos

Definir futuros flags derivados:

- `isLocal`;
- `isDemo`;
- `isDevelopment`;
- `isStaging`;
- `isProduction`;
- `usesBackend`;
- `allowsRemoteSupabase`;
- `allowsRealAuth`;
- `allowsRealData`;
- `allowsSyntheticData`;
- `allowsDevRoutes`;
- `allowsConversationsRoute`;
- `requiresSecrets`.

Reglas:

- `allowsRealData = false` salvo production futuro aprobado;
- `allowsConversationsRoute = false` por ahora;
- `allowsDevRoutes = true` solo demo/dev debug según gates;
- `allowsRemoteSupabase = false` hasta aprobación separada;
- `allowsRealAuth = false` hasta aprobación separada;
- `requiresSecrets = true` solo cuando se apruebe entorno remoto;
- `usesBackend` no basta para conectar Supabase.

### Validación fail-closed

Comportamiento futuro:

- `APP_MODE` desconocido = `misconfigured`;
- `APP_MODE` ausente en contexto real = `misconfigured`;
- development sin variables requeridas = `backendBlocked`/`misconfigured`;
- staging sin variables requeridas = `backendBlocked`/`misconfigured`;
- production sin gates = `backendBlocked`/`misconfigured`;
- Supabase solicitado sin aprobación = `backendBlocked`;
- auth real solicitado sin aprobación = `backendBlocked`;
- datos reales solicitados sin aprobación = `backendBlocked`;
- `/conversations` solicitada sin aprobación = bloqueada;
- rutas `/dev` en release = ausentes.

Prohibido:

- fallback silencioso a demo;
- fallback silencioso a production;
- fallback a claves production;
- fallback a Supabase local si el entorno era remoto;
- refresh real ante misconfiguration;
- inicializar Supabase por el mero hecho de parsear un entorno.

### Tests futuros

Tests mínimos:

- `APP_MODE=local` parsea local;
- `APP_MODE=demo` parsea demo;
- `APP_MODE=development` parsea development;
- `APP_MODE=staging` parsea staging;
- `APP_MODE=production` parsea production;
- `APP_MODE=backendReal` parsea legacy/transitional si se mantiene;
- `APP_MODE` desconocido falla cerrado;
- `APP_MODE` ausente en contexto real falla cerrado;
- development no permite datos reales;
- staging no permite datos reales inicialmente;
- production bloqueado sin gates;
- `/conversations` false en todos por ahora;
- `/dev` routes false en release;
- `service_role` no aparece en config Flutter;
- no secrets en repo;
- no `Authorization` en logs;
- `usesBackend` no inicializa Supabase sin aprobación;
- misconfiguration no llama refresh real.

### Rollback futuro

Rollback esperado:

- volver a demo/backendBlocked sin conectar Supabase;
- mantener rutas heredadas intactas;
- mantener `/dev/chat/composed` intacta;
- no borrar matriz documental;
- no tocar migraciones;
- no tocar Edge Functions;
- no cambiar datos;
- no eliminar tests de bloqueo.

### Riesgos clasificados

Bloqueantes:

- skeleton interpretado como conexión real;
- `APP_MODE` ausente cayendo a demo en entorno real;
- production desbloqueado por error;
- development usando claves production;
- staging usando claves production;
- `service_role` en cliente;
- datos reales habilitados por flag incorrecto.

Altos:

- `/conversations` registrada por accidente;
- rutas `/dev` visibles en release;
- fallback silencioso;
- Supabase inicializado por `usesBackend`;
- auth heredado usado como autoridad.

Medios:

- compatibilidad legacy `backendReal` mantenida demasiado tiempo;
- flags derivados con nombres ambiguos;
- tests de configuración incompletos.

Bajos:

- copy de errores poco claro;
- duplicación documental de matriz.

### Recomendación

Preparar AF4 como plan. Después ejecutar:

```text
2B-AF5 — implementar skeleton de entornos fail-closed sin conectar Supabase
```

La implementación futura debe ser pequeña, reversible, testeable y sin conexión
real.

### Siguiente paquete propuesto

Siguiente recomendado:

```text
2B-AF5 — implementar skeleton de entornos fail-closed sin conectar Supabase
```

Alternativa más prudente:

```text
2B-AF5 — cierre plan skeleton de entornos
```

### Fuera de alcance de 2B-AF4

Queda fuera:

- código;
- configuración real;
- cambios en `APP_MODE`;
- cambios en `usesBackend`;
- cambios en `validateForStartup`;
- `app.dart`;
- `main.dart`;
- rutas;
- providers;
- datasources;
- Supabase;
- migraciones;
- Edge Functions;
- CI;
- proyectos Supabase;
- remoto;
- production;
- datos reales;
- `service_role`;
- `/conversations`;
- `/chat/:id`;
- `/orchestrator/chat`;
- chat heredado;
- IA;
- Stasis Engine;
- MCP;
- streaming;
- adjuntos.

## Implementación 2B-AF5 — skeleton de entornos fail-closed sin conectar Supabase

### Estado

2B-AF4 queda aprobado y cerrado formalmente. Se implementa un skeleton mínimo
de entornos fail-closed, sin conectar Supabase real, auth real, remoto,
production ni datos reales.

### Cambios implementados

Se amplía `AppRuntimeMode` para soportar:

```text
local
demo
development
staging
backendReal
production
```

`backendReal` se conserva como legacy/transitional. No se elimina para no romper
compatibilidad, pero no queda como arquitectura objetivo.

Se añaden flags derivados:

- `isLocal`;
- `isDemo`;
- `isDevelopment`;
- `isStaging`;
- `isBackendRealLegacy`;
- `isProduction`;
- `usesBackend`;
- `allowsRemoteSupabase`;
- `allowsRealAuth`;
- `allowsRealData`;
- `allowsSyntheticData`;
- `allowsDevRoutes`;
- `allowsConversationsRoute`;
- `requiresSecrets`.

Decisiones de seguridad implementadas:

- `allowsRemoteSupabase = false`;
- `allowsRealAuth = false`;
- `allowsRealData = false`;
- `allowsConversationsRoute = false`;
- `usesBackend` no implica permiso para Supabase remoto;
- local/demo no usan backend;
- development/staging/backendReal/production siguen bloqueados por
  `validateForStartup` salvo aprobación futura.

### Parser APP_MODE

El parser reconoce:

- `local`;
- `demo`;
- `development`;
- `dev`;
- `staging`;
- `stage`;
- `backendReal`;
- `backend`;
- `backend_real`;
- `production`;
- `produccion`.

`APP_MODE` desconocido falla cerrado mediante `AppConfigurationException`.

El valor vacío conserva compatibilidad actual y parsea como `demo`. Esta
limitación queda documentada: una fase futura deberá diferenciar contexto local
de build real para evitar que ausencia de `APP_MODE` en entorno real caiga a
demo.

### Validación fail-closed

`validateForStartup` mantiene:

- local/demo arrancan sin backend;
- modos backend-like sin `SUPABASE_URL` o `SUPABASE_ANON_KEY` fallan;
- modos backend-like con variables pero sin aprobación fallan;
- production requiere gate adicional `productionActivationApproved`;
- no se inicializa Supabase por añadir modos nuevos;
- no hay fallback demo ante misconfiguration.

### Tests añadidos

Se añaden/refuerzan tests para:

- parsing de modos oficiales y legacy;
- `APP_MODE` desconocido fail-closed;
- default vacío documentado;
- flags derivados;
- `usesBackend` sin `allowsRemoteSupabase`;
- development/staging/backendReal/production bloqueados sin configuración;
- development/staging/backendReal/production bloqueados con configuración;
- production bloqueado sin gates;
- ausencia de `service_role`, `SUPABASE_SERVICE_ROLE_KEY`, `Authorization`,
  `refresh_token`, `SupabaseChatDataSource` y conexiones reales en skeleton de
  entorno;
- `/conversations` no registrada.

### Supabase initialization

No se modifica `main.dart`. La inicialización real de Supabase sigue bloqueada
porque `validateForStartup()` se ejecuta antes de `Supabase.initialize` y por
defecto no aprueba ningún modo backend-like.

### Fuera de alcance respetado

No se conecta:

- Supabase real;
- auth real;
- development real;
- staging real;
- remoto;
- production;
- datos reales;
- `/conversations`;
- `/chat/:id` seguro;
- `/orchestrator/chat` seguro;
- chat heredado.

No se modifican migraciones, Edge Functions, CI, Supabase ni features de auth o
chat.

### Riesgos residuales

Riesgos que permanecen:

- el valor vacío de `APP_MODE` conserva default demo por compatibilidad;
- `backendReal` sigue existiendo como legacy/transitional;
- `main.dart` sigue usando `usesBackend`, aunque `validateForStartup` bloquea
  antes de inicializar Supabase;
- una fase futura debe decidir contexto local/debug vs build real para default
  completamente fail-closed.

### Siguiente paso propuesto

Siguiente recomendado:

```text
2B-AF6 — cierre skeleton de entornos fail-closed
```

Alternativa válida:

```text
2B-AG — backend remoto seguro
```

## Cierre 2B-AF6 — skeleton de entornos fail-closed

### Estado

2B-AF5 queda aprobado y cerrado formalmente. El skeleton de entornos
fail-closed queda implementado como base de configuración segura, sin conexión
real de Supabase, auth real, remoto, production ni datos reales.

Con este cierre quedan documentados como cerrados dentro del frente AF:

- 2B-AF — plan auth real/Supabase real seguro;
- 2B-AF1 — plan entorno development/staging Supabase seguro;
- 2B-AF2 — decisión matriz de entornos y configuración segura;
- 2B-AF3 — cierre matriz de entornos y configuración segura;
- 2B-AF4 — plan skeleton de entornos sin conectar Supabase;
- 2B-AF5 — skeleton de entornos fail-closed sin conectar Supabase;
- 2B-AF6 — cierre skeleton de entornos fail-closed.

### Capacidades cerradas

Quedan cerradas como capacidades implementadas o documentadas según su alcance:

- modelo de entornos extendido;
- parser explícito de `APP_MODE`;
- alias controlados para modos oficiales y transicionales;
- `backendReal` mantenido solo como legacy/transitional;
- flags derivados de entorno;
- validación de startup fail-closed;
- tests de parsing;
- tests de flags;
- tests de startup validation;
- tests no-secrets y arquitectura;
- documentación ADR/tracker actualizada.

### Garantías fail-closed

Se mantienen las siguientes garantías:

- Supabase real no conectado;
- auth real no conectada;
- remoto no conectado;
- production no desbloqueado;
- datos reales no habilitados;
- `/conversations` no registrada;
- `/chat/:id` no tocado como ruta segura;
- `/orchestrator/chat` no tocado como ruta segura;
- chat heredado no conectado;
- `SupabaseChatDataSource` no reactivado;
- `service_role` no añadido al cliente;
- tokens no logueados;
- `Authorization` no logueado;
- `refresh_token` no logueado;
- `usesBackend` no basta para conectar Supabase;
- `validateForStartup` bloquea `development`, `staging`, `backendReal` y
  `production` sin configuración y aprobación explícita;
- `production` exige aprobación específica de producción.

### Bloqueos vigentes

Siguen bloqueados hasta paquete separado y aprobación explícita:

- conexión real development;
- conexión real staging;
- Supabase real;
- auth real;
- backend remoto;
- production;
- datos reales;
- `service_role` en cliente;
- claves de production en development/staging;
- registro de `/conversations`;
- routing productivo;
- `/chat/:id` como ruta segura;
- `/orchestrator/chat` como ruta segura;
- chat heredado;
- `SupabaseChatDataSource`;
- writes directos desde Flutter;
- fallback demo desde error real;
- logs con tokens;
- logs con `Authorization`;
- logs con `refresh_token`.

### Gates antes de conexión real

Antes de cualquier conexión real futura se exige como mínimo:

- aprobación explícita del cliente;
- paquete separado;
- proyecto Supabase development/staging separado;
- secretos fuera del repositorio;
- variables por entorno definidas;
- RLS revisada;
- RPC revisadas;
- Edge Functions revisadas;
- tests de integración local;
- tests de arquitectura;
- tests no-secrets;
- tests de aislamiento entre usuarios;
- datos sintéticos;
- startup fail-closed;
- rollback a `backendBlocked`;
- ausencia de production keys;
- ausencia de `service_role` en Flutter;
- ausencia de datos reales.

### Riesgos residuales

Riesgos que permanecen:

- confundir skeleton con conexión real;
- mantener `backendReal` legacy demasiado tiempo;
- `APP_MODE` vacío cayendo a `demo` fuera de contexto local;
- conectar development/staging sin paquete separado;
- desbloquear production por error;
- introducir `service_role` en cliente;
- usar datos reales prematuros;
- registrar `/conversations` antes de auth/RLS;
- mezclar cambios preexistentes de worktree con cierres futuros.

### Siguiente paso propuesto

Siguiente recomendado:

```text
2B-AG — plan backend remoto seguro
```

Alternativas válidas:

- plan de conexión controlada development/staging;
- UX segura `chat_sessions -> messages`;
- otro bloque técnico pendiente;
- otra área de Stasisly.

## Plan 2B-AG — backend remoto seguro

### Estado

2B-AF6 queda aprobado y cerrado formalmente. El frente AF completo queda
cerrado con skeleton de entornos fail-closed implementado y documentado.

2B-AG abre solo una fase de planificacion para backend remoto seguro. No
conecta Supabase real, auth real, development remoto, staging remoto,
production ni datos reales.

### Backend local actual auditado

Auditoria en solo lectura:

- `supabase/migrations/00001_initial_schema.sql`: esquema inicial con `users`,
  `memberships`, `user_memberships`, `specialists`, `branch_chiefs`,
  `subcategory_chiefs`, `chat_sessions`, `messages`, `user_health_data`,
  `calendar_events`, `reminders`, `orchestator_summaries`,
  `chief_write_permissions` y `specialist_temporary_disables`.
- `supabase/migrations/00002_enable_rls_public_users_deny_all.sql`: habilita
  RLS en `public.users` sin politicas permisivas.
- `supabase/migrations/00003_public_users_owner_profile_minimal.sql`: permite
  perfil propio minimo solo para `id` y `display_name`, con grants por columna.
- `supabase/migrations/00004_create_specialist_catalog_deny_all.sql`: crea
  `specialist_catalog`, endurece `specialists`, habilita RLS y revoca acceso
  cliente.
- `supabase/migrations/00005_harden_chat_sessions_deny_all.sql`: endurece
  `chat_sessions`, habilita RLS, deja cero politicas y cero privilegios
  cliente.
- `supabase/migrations/00006_harden_messages_deny_all.sql`: endurece
  `messages`, habilita RLS, deja cero politicas y cero privilegios cliente.
- `supabase/migrations/00007_create_send_user_message_core_rpc.sql`: crea
  `public.send_user_message_core` transaccional, sin `SECURITY DEFINER`, con
  `EXECUTE` revocado a `anon/authenticated` y concedido solo a `service_role`.
- Edge Functions locales existentes: `list-selectable-specialists`,
  `create-own-chat-session`, `list-own-chat-sessions`,
  `archive-own-chat-session`, `send-user-message` y
  `list-session-messages`.
- Tests locales existentes: pgTAP/SQL, shell HTTP local, cleanup con cero
  fixtures y tests Dart/arquitectura para contratos local-safe.

Piezas aptas como base conceptual para remoto:

- contratos estrictos de payload;
- derivacion de owner desde JWT;
- respuestas publicas sanitizadas;
- RLS y grants restrictivos;
- RPC transaccional para envio de mensaje;
- tests de aislamiento, logs y cleanup;
- frontera `SecureSessionTokenProvider -> datasource HTTP`.

Piezas que no deben desplegarse tal cual:

- scripts y README marcados como local/efimero;
- harness con `--no-verify-jwt`;
- fixtures `test_only`;
- uso de `service_role` dentro de funciones sin decision remota especifica;
- `supabase link`, `db push` o `functions deploy`;
- chat heredado y `SupabaseChatDataSource`;
- rutas productivas no aprobadas.

### Arquitectura backend remoto objetivo

Arquitectura objetivo futura:

```text
Flutter
-> SecureSessionTokenProvider
-> datasource HTTP
-> Edge Function remota
-> JWT validation
-> RPC transaccional
-> RLS
-> tablas
```

Reglas obligatorias:

- Flutter no escribe directo en tablas;
- Flutter no usa `service_role`;
- Flutter no envia `userId`;
- Flutter no envia `ownerUserId`;
- Flutter no decide ownership;
- Edge Function obtiene usuario desde JWT validado;
- backend valida ownership antes de operar;
- RPC escribe transaccionalmente cuando haya cambios compuestos;
- RLS protege lectura y escritura;
- logs no contienen tokens, `Authorization`, `refresh_token`, PII sensible,
  prompts internos ni IDs internos no aprobados;
- errores reales no caen a demo.

### Entornos remotos

Relación inicial:

- `development`: remoto futuro con datos sinteticos, nunca datos reales, y solo
  tras aprobacion explicita;
- `staging`: remoto futuro aislado con datos sinteticos o seed controlado, solo
  tras development validado;
- `production`: bloqueado;
- `backendReal`: legacy/transitional, no arquitectura objetivo.

### Supabase projects futuros

Se requieren proyectos separados:

- Supabase development;
- Supabase staging;
- Supabase production futuro.

Reglas:

- no mezclar claves entre entornos;
- no usar production keys en development/staging;
- no usar `service_role` en Flutter;
- secretos fuera del repo;
- anon key como configuracion publica controlada, no como secreto;
- secrets de Edge Functions gestionados fuera del repo;
- logs sin tokens;
- ningun dato real en development/staging.

### Estrategia de migraciones remotas

Estrategia futura:

1. mantener migraciones versionadas;
2. aplicar primero en development remoto;
3. validar con datos sinteticos;
4. verificar RLS, grants, RPC y ownership;
5. promover a staging solo tras aprobacion;
6. validar aislamiento usuario/usuario y logs;
7. mantener production bloqueado hasta gates;
8. documentar rollback antes de cada despliegue.

Prohibido en 2B-AG:

- `supabase link`;
- `supabase db push` remoto;
- `supabase functions deploy`;
- deploy a production;
- cambios de migraciones.

### Estrategia Edge Functions remotas

Funciones relevantes para revision futura:

- `create-own-chat-session`;
- `list-own-chat-sessions`;
- `archive-own-chat-session`;
- `send-user-message`;
- `list-session-messages`.

Estrategia:

- deployment primero en development;
- verificacion JWT real, sin `--no-verify-jwt` como contrato remoto;
- validacion estricta de payload;
- no aceptar `userId`, `ownerUserId`, `specialist_id`, `role`, `metadata` ni
  campos internos desde UI;
- owner derivado desde JWT;
- writes compuestos mediante RPC;
- errores explicitos y opacos ante recursos ajenos;
- sin fallback demo;
- logs minimizados;
- rollback por funcion documentado.

### Gates antes de development remoto

Gates obligatorios:

- aprobacion explicita;
- paquete separado;
- Supabase development creado;
- secrets fuera del repo;
- environment `development` configurado fail-closed;
- auth real o token strategy aprobada;
- migraciones revisadas;
- RLS revisada;
- RPC revisada;
- Edge Functions revisadas;
- datos sinteticos;
- tests de integracion local pasados;
- tests de arquitectura pasados;
- rollback definido.

### Gates antes de staging remoto

Gates obligatorios:

- development remoto validado;
- aprobacion explicita;
- paquete separado;
- Supabase staging separado;
- secrets staging fuera del repo;
- migraciones aplicadas controladamente;
- Edge Functions staging desplegadas;
- RLS/RPC verificadas;
- datos sinteticos o seed controlado;
- tests de aislamiento entre usuarios;
- logs minimizados;
- rollback definido.

### Gates antes de production

Production sigue bloqueado. Gates futuros minimos:

- staging validado;
- auditoria AppSec;
- RLS/ownership auditado;
- privacidad, retencion y borrado definidos;
- observabilidad segura;
- backups;
- rollback;
- datos reales autorizados;
- ADR especifico de datos sensibles, salud o memoria si aplica;
- aprobacion explicita.

### Riesgos clasificados

Bloqueantes:

- `supabase link` accidental contra remoto;
- `supabase db push` remoto accidental;
- `supabase functions deploy` accidental;
- production keys en development/staging;
- `service_role` en cliente;
- datos reales en development/staging;
- RLS incompleta sobre tablas sensibles;
- Edge Function aceptando `userId`/ownership desde UI.

Altos:

- ownership decidido por UI;
- logs con tokens o PII sensible;
- fallback demo desde error real;
- `SupabaseChatDataSource` reactivado;
- writes directos desde Flutter;
- RPC con grants cliente incorrectos;
- funciones remotas usando `--no-verify-jwt` como supuesto operativo.

Medios:

- `backendReal` legacy mantenido demasiado tiempo;
- seeds de staging persistentes sin cleanup;
- errores publicos filtrando existencia de recursos ajenos;
- cursor o paginacion duplicando/filtrando sesiones;
- contratos publicos exponiendo IDs internos.

Bajos:

- nombres de entorno ambiguos;
- documentacion duplicada;
- copy de errores poco claro.

### Recomendacion

No conectar backend remoto todavia. Cerrar AG como plan y preparar despues una
decision especifica de development/staging remoto con estrategia de despliegue,
secrets, rollback y pruebas.

### Siguiente paquete propuesto

Siguiente recomendado:

```text
2B-AG1 — decision backend remoto development/staging y estrategia de despliegue
```

Alternativas validas:

- `2B-AG1 — plan conexion development remoto con datos sinteticos`;
- `2B-AF7 — plan conexion development Supabase sintetica`;
- `2B-AE4 — plan /conversations backendBlocked visual`.

No implementar todavia.

## Resolución 2B-AG11 — evidencia externa DEV LINK sin secretos

### Estado

2B-AG10 queda aprobado y cerrado formalmente. AG11 revisa la evidencia externa
necesaria para DEV LINK sin ejecutar remoto, sin leer ni pegar secrets, sin
conectar Supabase real y sin modificar código, Supabase, migraciones, Edge
Functions, CI ni rutas.

Readiness final:

```text
READY WITH BLOCKERS
```

No se ha aportado evidencia externa suficiente para pasar a `READY FOR DEV
LINK`. El bloqueo sigue siendo externo/operativo.

### Proyecto development

| Elemento | Estado | Decisión |
| --- | --- | --- |
| Proyecto Supabase development existe | Pendiente | Bloqueante |
| Nombre indica claramente dev/development | Pendiente | Bloqueante |
| Organización/cuenta correcta | Pendiente | Bloqueante |
| Región documentada | Pendiente | Bloqueante |
| Owner/responsable identificado por rol | Pendiente | Bloqueante |
| Project ref development verificado fuera del repo | Pendiente | Bloqueante |
| Project ref development no pegado en docs | Verificado | Cumplido |
| Project ref development distinto de production | Pendiente | Bloqueante |
| Project ref development distinto de staging | Pendiente si staging existe | Condicional |

### Production

Clasificación:

```text
pendiente bloqueante
```

No se ha aportado evidencia externa de que production no exista/no se use o de
que production exista y sea claramente distinto de development.

### Staging

Clasificación:

```text
pendiente no bloqueante si no existe; pendiente bloqueante si existe y no se
verifica distinto
```

No se ha aportado evidencia externa de existencia o inexistencia de staging.

### Secrets development fuera del repo

| Elemento | Estado | Decisión |
| --- | --- | --- |
| `SUPABASE_URL` development | Pendiente fuera del repo | Bloqueante |
| `SUPABASE_ANON_KEY` development | Pendiente fuera del repo | Bloqueante |
| `PROJECT_REF` development | Pendiente fuera del repo | Bloqueante |
| Edge Function secrets development | Pendiente | No bloqueante para link si no se despliegan funciones |
| JWT config development | Pendiente | No bloqueante para link si no se prueba auth real |
| Rollback env vars | Pendiente | No bloqueante para link si no se ejecuta push/deploy |

Regla mantenida: no registrar valores reales en docs, prompts, tracker ni
capturas.

### Rollback remoto

Clasificación:

```text
completo como runbook documental; no probado contra remoto
```

Sigue cubriendo detección de link incorrecto, revisión futura de
`supabase/.temp/project-ref`, abortar antes de migraciones/functions, limpieza
local, reversión de variables, rotación de secrets si hubiera exposición,
vuelta a `backendBlocked`, confirmación local/demo, production intacto y
registro de incidente.

### Checks locales mínimos AG11

Resultados:

- `git status --short`: solo ADR-006, ADR-007 y tracker modificados;
- `git diff --check`: sin salida;
- diff crítico de código/Supabase/test/rutas: sin salida;
- `.env` existe localmente, está vacío, ignorado y no versionado;
- `supabase/.temp` contiene solo `cli-latest`;
- no existe `supabase/.temp/project-ref`;
- no existe `supabase/.temp/pooler-url`;
- no existe `supabase/.temp/access-token`.

### Checks no-secrets/no-remoto

Resultado AG11:

- no se detectan secrets reales versionados;
- los hits de `service_role`, `SUPABASE_SERVICE_ROLE_KEY`, `Authorization`,
  `/functions/v1/`, `access_token`, `refresh_token` y URLs de ejemplo se
  clasifican como falsos positivos esperados en tests, harness local, README,
  Edge Functions locales, contratos de bloqueo o ejemplos;
- `SupabaseChatDataSource` sigue existiendo únicamente en chat heredado
  bloqueado;
- no hay evidencia de link remoto en `supabase/.temp`.

### Riesgos clasificados

Bloqueantes:

- project ref development incorrecto o no verificado;
- production ref confundido con development;
- staging ref confundido con development si staging existe;
- secrets reales pegados en docs/prompts/screenshots;
- link ejecutado accidentalmente.

Altos:

- `service_role` en Flutter;
- production keys en development;
- `SupabaseChatDataSource` reactivado;
- writes directos desde Flutter;
- rollback remoto no probado.

Medios:

- `.env` local ignorado mal interpretado;
- falsos positivos de tests/harness confundidos con leaks reales;
- worktree documental acumulado.

Bajos:

- duplicidad documental;
- nombres largos de paquetes.

### Decisión AG11

AG11 no desbloquea DEV LINK real.

```text
READY WITH BLOCKERS
```

### Siguiente paquete propuesto

```text
2B-AG12 — resolver bloqueantes externos restantes DEV LINK
```

AG12 debe aportar evidencia externa real sin secretos. Si esa evidencia se
completa, podrá proponerse `READY FOR DEV LINK`; si no, debe mantenerse
`READY WITH BLOCKERS`.

## Resolución 2B-AG12 — evidencia externa real DEV LINK sin secretos

### Estado

2B-AG11 queda aprobado y cerrado formalmente. AG12 revisa si existe evidencia
externa real sin secretos suficiente para desbloquear DEV LINK, sin ejecutar
remoto, sin leer ni registrar secrets reales, sin conectar Supabase real y sin
modificar código, Supabase, migraciones, Edge Functions, CI ni rutas.

Readiness final:

```text
READY WITH BLOCKERS
```

No se ha aportado evidencia externa real suficiente para pasar a `READY FOR DEV
LINK`. No hay bloqueo local/técnico nuevo; el bloqueo sigue siendo
externo/operativo.

### Cierre formal de AG11

Queda registrado:

- 2B-AG11 cerrado formalmente;
- readiness previa `READY WITH BLOCKERS` confirmada;
- sin `supabase link`;
- sin `supabase db push`;
- sin `supabase migration up` remoto;
- sin `supabase functions deploy`;
- sin `supabase secrets set`;
- sin backend remoto, Supabase real, auth real, production ni datos reales;
- sin cambios de código, migraciones, Edge Functions, CI ni rutas;
- `/conversations`, `/chat/:id`, `/orchestrator/chat`, chat heredado y
  `SupabaseChatDataSource` siguen bloqueados.

### Proyecto development

| Elemento | Estado | Decisión |
| --- | --- | --- |
| Proyecto Supabase development existe | Pendiente | Bloqueante |
| Nombre indica claramente dev/development | Pendiente | Bloqueante |
| Organización/cuenta correcta | Pendiente | Bloqueante |
| Región documentada | Pendiente | Bloqueante |
| Owner/responsable identificado por rol | Pendiente | Bloqueante |
| Project ref development verificado fuera del repo | Pendiente | Bloqueante |
| Project ref development no pegado en docs | Verificado | Cumplido |
| Project ref development distinto de production | Pendiente | Bloqueante |
| Project ref development distinto de staging | Pendiente si staging existe | Condicional |

### Production

Clasificación:

```text
pendiente bloqueante
```

No se ha aportado evidencia externa real de que production no exista/no se use
o de que production exista y sea claramente distinto de development.

### Staging

Clasificación:

```text
pendiente no bloqueante si no existe; pendiente bloqueante si existe y no se
verifica distinto
```

No se ha aportado evidencia externa real de existencia o inexistencia de
staging.

### Secrets development fuera del repo

| Elemento | Estado | Decisión |
| --- | --- | --- |
| `SUPABASE_URL` development | Pendiente fuera del repo | Bloqueante |
| `SUPABASE_ANON_KEY` development | Pendiente fuera del repo | Bloqueante |
| `PROJECT_REF` development | Pendiente fuera del repo | Bloqueante |
| Edge Function secrets development | Pendiente | No bloqueante para link si no se despliegan funciones |
| JWT config development | Pendiente | No bloqueante para link si no se prueba auth real |
| Rollback env vars | Pendiente | No bloqueante para link si no se ejecuta push/deploy |

No se han registrado valores reales en documentación, prompts, tracker ni
capturas.

### Rollback remoto

Clasificación:

```text
completo como runbook documental; no probado contra remoto
```

Sigue cubriendo detección de link incorrecto, revisión futura de
`supabase/.temp/project-ref`, abortar antes de migraciones/functions, limpieza
local, reversión de variables, rotación de secrets si hubiera exposición,
vuelta a `backendBlocked`, confirmación local/demo, production intacto y
registro de incidente.

### Checks locales mínimos AG12

Resultados:

- `git status --short`: solo ADR-006, ADR-007 y tracker modificados;
- `git diff --check`: sin salida;
- diff crítico de código/Supabase/test/rutas: sin salida;
- `.env` existe localmente, está vacío, ignorado y no versionado;
- `supabase/.temp` contiene solo `cli-latest`;
- no existe `supabase/.temp/project-ref`;
- no existe `supabase/.temp/pooler-url`;
- no existe `supabase/.temp/access-token`.

### Checks no-secrets/no-remoto

Resultado AG12:

- no se detectan secrets reales versionados;
- los hits de `service_role`, `SUPABASE_SERVICE_ROLE_KEY`, `Authorization`,
  `/functions/v1/`, `access_token`, `refresh_token` y URLs de ejemplo se
  clasifican como falsos positivos esperados en tests, harness local, README,
  Edge Functions locales, contratos de bloqueo o ejemplos;
- `SupabaseChatDataSource` sigue existiendo únicamente en chat heredado
  bloqueado;
- no hay evidencia de link remoto en `supabase/.temp`.

### Riesgos clasificados

Bloqueantes:

- project ref development incorrecto o no verificado;
- production ref confundido con development;
- staging ref confundido con development si staging existe;
- secrets reales pegados en docs/prompts/screenshots;
- link ejecutado accidentalmente.

Altos:

- `service_role` en Flutter;
- production keys en development;
- `SupabaseChatDataSource` reactivado;
- writes directos desde Flutter;
- rollback remoto no probado.

Medios:

- `.env` local ignorado mal interpretado;
- falsos positivos de tests/harness confundidos con leaks reales;
- worktree documental acumulado.

Bajos:

- duplicidad documental;
- nombres largos de paquetes.

### Decisión AG12

AG12 no desbloquea DEV LINK real.

```text
READY WITH BLOCKERS
```

### Siguiente paquete propuesto

```text
2B-AG13 — resolver bloqueantes externos restantes DEV LINK
```

AG13 debe aportar evidencia externa real sin secretos. Si esa evidencia se
completa, podrá proponerse `READY FOR DEV LINK` y preparar un paquete posterior
para ejecutar `supabase link` controlado; si no, debe mantenerse `READY WITH
BLOCKERS`.

## Resolución 2B-AG10 — bloqueantes externos DEV LINK

### Estado

2B-AG9 queda aprobado y cerrado formalmente. AG10 revisa los bloqueantes
externos restantes para DEV LINK sin ejecutar remoto, sin leer secrets y sin
modificar código, Supabase, migraciones, Edge Functions, CI ni rutas.

Readiness final:

```text
READY WITH BLOCKERS
```

El bloqueo actual no es local/técnico: AG8 conserva el preflight local aprobado
y AG10 mantiene los checks locales mínimos limpios. El bloqueo sigue siendo
externo/operativo porque no se ha aportado evidencia verificable fuera del repo
de project refs, separación de entornos y secrets development.

### Cierre formal de AG9

Queda registrado:

- 2B-AG9 cerrado formalmente;
- readiness previa `READY WITH BLOCKERS` confirmada;
- sin `supabase link`;
- sin `supabase db push`;
- sin `supabase migration up` remoto;
- sin `supabase functions deploy`;
- sin `supabase secrets set`;
- sin backend remoto, Supabase real, auth real, production ni datos reales;
- sin cambios de código, migraciones, Edge Functions, CI ni rutas;
- `/conversations`, `/chat/:id`, `/orchestrator/chat`, chat heredado y
  `SupabaseChatDataSource` siguen bloqueados.

### Proyecto development

Estado AG10:

| Elemento | Estado | Decisión |
| --- | --- | --- |
| Proyecto Supabase development existe | Pendiente | Bloqueante |
| Nombre claro dev/development | Pendiente | Bloqueante |
| Organización/cuenta correcta | Pendiente | Bloqueante |
| Región documentada | Pendiente | Bloqueante |
| Owner/responsable identificado por rol | Pendiente | Bloqueante |
| Project ref development verificado fuera del repo | Pendiente | Bloqueante |
| Project ref development no pegado en docs | Verificado | Cumplido |
| Development distinto de production/staging | Pendiente | Bloqueante |

No se debe pegar el project ref real en documentación ni en tracker. Evidencia
aceptable futura: “verificado fuera del repo, no pegado”.

### Separación production

Estado AG10:

```text
pendiente bloqueante
```

Falta confirmar una de estas dos opciones:

- production no existe/no se usa todavía; o
- production existe, es distinto de development y no recibirá migraciones,
  funciones, datos ni keys de este flujo.

Hasta que esa separación quede verificada fuera del repo, DEV LINK no se
autoriza.

### Separación staging

Estado AG10:

```text
pendiente no bloqueante si staging no existe; bloqueante si existe y no se
verifica distinto
```

Si staging existe, debe quedar confirmado fuera del repo que su ref es distinto
de development y production, y que no se toca en DEV LINK. Si staging no existe,
no bloquea DEV LINK siempre que development quede separado de production.

### Secrets development fuera del repo

Estado AG10:

| Elemento | Estado | Decisión |
| --- | --- | --- |
| `SUPABASE_URL` development | Pendiente fuera del repo | Bloqueante |
| `SUPABASE_ANON_KEY` development | Pendiente fuera del repo | Bloqueante |
| `PROJECT_REF` development | Pendiente fuera del repo | Bloqueante |
| Edge Function secrets development | Pendiente | No bloqueante para link si no se despliegan funciones |
| JWT config development | Pendiente | No bloqueante para link si no se prueba auth real |
| Rollback env vars | Pendiente | No bloqueante para link si el link se aprueba sin push/deploy |

Reglas confirmadas:

- no secrets en docs;
- no secrets en tracker;
- no service role en Flutter;
- no production keys en development;
- no tokens en logs;
- no `Authorization` real en logs.

### Rollback remoto

Runbook documental clasificado como:

```text
completo como procedimiento; no probado contra remoto
```

Incluye detectar link incorrecto, revisar `supabase/.temp/project-ref` tras
link futuro, abortar antes de migraciones/functions, limpiar estado local,
revertir variables, rotar secrets si se exponen, volver a `backendBlocked`,
confirmar demo/local funcional, confirmar production intacto y registrar
incidente.

### Checks locales mínimos AG10

Resultados:

- `git status --short`: solo ADR-006, ADR-007 y tracker modificados;
- `git diff --check`: sin salida;
- diff crítico de código/Supabase/test/rutas: sin salida;
- `.env` existe localmente, está vacío, ignorado y no versionado;
- `supabase/.temp` contiene solo `cli-latest`;
- no existe `supabase/.temp/project-ref`;
- no existe `supabase/.temp/pooler-url`;
- no existe `supabase/.temp/access-token`.

### Checks no-secrets/no-remoto

Resultado AG10:

- no se detectan secrets reales versionados;
- los hits de `service_role`, `Authorization`, `/functions/v1/` y tokens son
  falsos positivos esperados en tests, harness local, README, Edge Functions
  locales y contratos de bloqueo;
- `SupabaseChatDataSource` sigue existiendo solo en chat heredado ya bloqueado;
- los datasources `chat_sessions` y `chat_messages` locales usan rutas
  `/functions/v1/` como harness local-safe, no como remoto productivo;
- `lib/core/config/env.dart` mantiene ejemplo documental de URL Supabase, no key
  real.

### Riesgos clasificados

Bloqueantes:

- project ref development incorrecto o no verificado;
- production ref confundido con development;
- staging ref confundido con development si staging existe;
- secrets reales pegados en docs/prompts/screenshots;
- link ejecutado accidentalmente.

Altos:

- `service_role` en Flutter;
- production keys en development;
- `SupabaseChatDataSource` reactivado;
- writes directos desde Flutter;
- rollback remoto no probado.

Medios:

- `.env` local ignorado mal interpretado;
- falsos positivos de tests/harness confundidos con leaks reales;
- worktree documental acumulado.

Bajos:

- duplicidad documental;
- nombres largos de paquetes;
- infos no fatales conocidas.

### Decisión AG10

AG10 no desbloquea DEV LINK real.

```text
READY WITH BLOCKERS
```

### Siguiente paquete propuesto

```text
2B-AG11 — resolver bloqueantes externos restantes DEV LINK
```

AG11 debe aportar evidencia externa sin secretos de project ref development,
separación production/staging y secrets development fuera del repo. Solo si esa
evidencia queda completa podrá proponerse `READY FOR DEV LINK` y preparar un
paquete posterior para ejecutar `supabase link` controlado.

## Evidence pack 2B-AG2 — backend remoto development

### Estado

2B-AG1 queda aprobado y cerrado formalmente. La estrategia futura decidida es:

```text
development remoto -> staging remoto -> production bloqueado
```

AG2 prepara evidencia local antes de cualquier conexion remota a Supabase
development. No se ejecuta `supabase link`, `supabase db push`,
`supabase migration up` remoto, `supabase functions deploy` ni
`supabase secrets set`.

### Estado Git/worktree

Evidencia local:

- `git status --short`: solo muestra cambios documentales en
  `docs/SESSION_TRACKER.md`, `ADR-006` y `ADR-007`.
- `git diff --check`: limpio.
- `git diff --name-only`: solo tres documentos.
- `git diff --name-only -- lib/core/config lib/core/auth/session
  lib/features/auth lib/features/chat lib/features/chat_sessions
  lib/features/chat_messages lib/app.dart lib/main.dart test pubspec.yaml
  supabase`: vacio.

Clasificacion:

- cambios del frente actual: ADR-006, ADR-007 y tracker;
- cambios preexistentes fuera del frente: ninguno detectado en esta revision;
- cambios prohibidos: ninguno detectado.

### Migraciones locales auditadas

Migraciones existentes:

- `00001_initial_schema.sql`: crea tablas base `users`, membresias,
  especialistas, jefaturas, `chat_sessions`, `messages`, datos de salud,
  calendario, recordatorios, summaries y permisos. Riesgo antes de remoto:
  contiene tablas sensibles que no forman parte del primer despliegue remoto y
  requieren RLS/gates especificos.
- `00002_enable_rls_public_users_deny_all.sql`: habilita RLS en `public.users`
  sin politicas; base deny-by-default.
- `00003_public_users_owner_profile_minimal.sql`: crea politicas owner
  minimas para `id` y `display_name`, con grants por columna. Riesgo:
  confirmar comportamiento PostgREST remoto antes de abrir development.
- `00004_create_specialist_catalog_deny_all.sql`: crea catalogo sanitizado y
  cierra `specialists`/`specialist_catalog` a cliente.
- `00005_harden_chat_sessions_deny_all.sql`: endurece `chat_sessions`, activa
  RLS, revoca privilegios cliente, añade constraints e indice owner listing.
- `00006_harden_messages_deny_all.sql`: endurece `messages`, activa RLS,
  revoca privilegios cliente, añade constraints e indice de lectura por sesion.
- `00007_create_send_user_message_core_rpc.sql`: crea RPC transaccional
  `send_user_message_core`, sin `SECURITY DEFINER`, con `EXECUTE` revocado a
  `anon/authenticated` y concedido solo a `service_role`.

Dependencias de orden:

- `00001` define tablas base.
- `00002`/`00003` dependen de `public.users`.
- `00004` depende de `public.specialists`.
- `00005` depende de `users` y `specialists`.
- `00006` depende de `chat_sessions`.
- `00007` depende de `messages` y `chat_sessions`.

### RLS/grants auditados

Evidencia documental/local:

- `users`: RLS activo; owner profile minimo; grants solo para
  `SELECT(id, display_name)` y `UPDATE(display_name)`.
- `specialists` y `specialist_catalog`: RLS activo, sin politicas permisivas y
  privilegios cliente revocados.
- `chat_sessions`: RLS activo, `NO FORCE ROW LEVEL SECURITY`, cero policies y
  cero privilegios cliente.
- `messages`: RLS activo, `NO FORCE ROW LEVEL SECURITY`, cero policies y cero
  privilegios cliente.
- RPC `send_user_message_core`: `anon/authenticated` no tienen `EXECUTE`;
  `service_role` solo para backend controlado.

Huecos antes de remoto:

- revalidar SQL/pgTAP en entorno local inmediatamente antes de link/deploy;
- decidir estrategia segura de `service_role` dentro de Edge Functions remotas;
- confirmar que tablas sensibles de `00001` no quedan accesibles por accidente.

### RPC auditada

RPC: `public.send_user_message_core(uuid, uuid, text)`.

Entrada:

- `p_session_id`;
- `p_owner_user_id`;
- `p_content`.

Validaciones:

- session id no nulo;
- owner user id no nulo;
- contenido no nulo, trim no vacio y maximo 4000 caracteres;
- sesion pertenece al owner;
- sesion existe;
- sesion no archivada;
- sesion esta activa.

Transaccionalidad:

- hace `SELECT ... FOR UPDATE`;
- inserta mensaje `role = user`;
- actualiza `message_count` y `last_message_at`;
- devuelve resultado confirmado;
- falla con `write_unconfirmed` si la actualizacion no queda confirmada.

Riesgos antes de remoto:

- usa `p_owner_user_id`; en remoto solo debe venir de Edge Function tras JWT,
  nunca desde UI;
- requiere que cliente no pueda invocarla directamente;
- exige tests de ownership y grants en development antes de staging.

### Edge Functions locales auditadas

Funciones revisadas en solo lectura:

- `create-own-chat-session`: payload permitido
  `{ selectableSpecialistId }`; rechaza campos internos; deriva owner desde JWT
  local; crea siempre sesion nueva; respuesta sin `user_id` ni `specialist_id`.
- `list-own-chat-sessions`: permite filtros publicos controlados; deriva owner
  desde JWT; respuesta sanitizada; catalogo roto falla cerrado.
- `archive-own-chat-session`: payload `{ sessionId }`; deriva owner desde JWT;
  actualiza solo `status`; error opaco para inexistente/ajena/archivada.
- `send-user-message`: payload `{ sessionId, content }`; deriva owner desde
  JWT; llama solo a RPC; no hace writes directos.
- `list-session-messages`: query `sessionId`; deriva owner desde JWT; solo
  lectura; permite sesion propia activa o archivada; no modifica counters.

Riesgos antes de deploy:

- hoy son funciones locales/efimeras;
- usan `--no-verify-jwt` en harness local, no valido como contrato remoto;
- usan `SUPABASE_SERVICE_ROLE_KEY` en runtime local; remoto exige decision y
  gestion de secrets separada;
- requieren auditoria AppSec antes de development remoto.

### Datasources Flutter seguros auditados

Piezas seguras auditadas:

- `lib/core/auth/session/`: contrato `SecureSessionTokenProvider` y providers
  overrideables; estados no exitosos no exponen token.
- `lib/features/chat_sessions/data/datasources/local_http_own_chat_sessions_datasource.dart`:
  HTTP local hacia Edge Functions; `Authorization` se construye en datasource;
  payloads usan `selectableSpecialistId` o `sessionId`, no `userId`.
- `lib/features/chat_messages/data/datasources/local_http_own_chat_messages_datasource.dart`:
  HTTP local hacia `send-user-message` y `list-session-messages`; UI envia
  `content` y `sessionId`, no ownership ni role.
- `LocalOnlyHostPolicy`: bloquea hosts remotos/HTTPS/missing port en modo
  local-safe.

Observaciones:

- UI no ve tokens directamente;
- providers son overrideables;
- errores no se convierten en demo;
- no dependen del chat heredado para el flujo local-safe.

### Piezas heredadas bloqueadas

Piezas heredadas detectadas y bloqueadas para flujo seguro:

- `lib/features/chat/data/datasources/supabase_chat_datasource.dart`;
- `lib/features/chat/presentation/viewmodels/chat_providers.dart`;
- `ChatController`;
- `ChatPage`;
- `AgentChatWrapper`;
- `lib/features/auth/presentation/viewmodels/auth_providers.dart`;
- `Supabase.instance.client` en auth/chat heredado.

Estas piezas no forman parte del flujo seguro remoto futuro hasta refactor o
retiro explicito.

### Tests locales ejecutados

Ejecutado:

- `flutter analyze --no-fatal-infos`: pasa con 43 infos no fatales conocidas.
- `flutter test test/core/config test/architecture`: pasa.
- `flutter test test/features/chat_sessions test/features/chat_messages`:
  pasa, 202 tests.
- `flutter test`: pasa, 367 tests y 2 skips esperados.

Skips esperados:

- `two_b_iv_h_local_http_chat_sessions_integration_test`;
- `two_b_v_g_local_http_chat_messages_integration_test`.

No ejecutado en AG2:

- harness SQL/pgTAP Supabase local;
- harness HTTP shell de Supabase local.

Motivo documental: AG2 no abre remoto ni despliegue; estos harness deben
revalidarse inmediatamente antes de cualquier link/deploy futuro.

### Checks no-secrets/no-remoto

Ejecutado:

- busqueda de `.env`, `.env.*`, `*secret*`, `*token*` hasta profundidad 3:
  sin resultados.
- busqueda de URLs Supabase reales, service role asignado, JWT-like,
  `sbp_`, `supabase link`, `supabase db push` y
  `supabase functions deploy`.

Resultados:

- no se detectan archivos `.env` versionados;
- no se detectan tokens reales ni project refs reales;
- coincidencias de `https://example.supabase.co` y
  `https://project.supabase.co` aparecen en tests/placeholders;
- `SUPABASE_SERVICE_ROLE_KEY=$SERVICE_ROLE_KEY` aparece solo en scripts locales
  de harness;
- `service_role` aparece en migraciones/tests/docs y funciones locales, no en
  Flutter como secreto;
- `SupabaseChatDataSource` sigue presente solo en chat heredado y tests/docs de
  bloqueo.

### Checklist variables/secrets futuro

Pendiente para paquete futuro:

- `SUPABASE_URL` development;
- `SUPABASE_ANON_KEY` development;
- Edge Function secrets development;
- JWT validation config;
- project ref development;
- rollback env vars.

Reglas:

- secrets fuera del repo;
- no `service_role` en Flutter;
- no production keys;
- no logs con tokens;
- anon key solo como configuracion publica controlada.

### Rollback checklist

Rollback futuro minimo:

- desvincular proyecto equivocado si aplica;
- revertir env vars;
- rollback de migraciones si procede;
- rollback de Edge Functions;
- volver a `backendBlocked`;
- mantener local/demo funcional;
- no tocar production;
- registrar evidencia antes/despues.

### Readiness development remoto

Clasificacion:

```text
READY WITH BLOCKERS
```

Motivo:

- Flutter analyze y tests locales Dart pasan;
- arquitectura local-safe esta protegida;
- no hay cambios de codigo/Supabase en AG2;
- no se detectan secrets reales versionados;
- quedan pendientes de revalidacion los harness SQL/pgTAP y HTTP locales de
  Supabase antes de cualquier link/deploy;
- hay piezas heredadas con Supabase directo que siguen bloqueadas y no deben
  mezclarse con remoto seguro.

### Riesgos clasificados

Bloqueantes:

- ejecutar `supabase link` contra proyecto equivocado;
- ejecutar `db push` contra production;
- secrets reales en repo;
- `service_role` en Flutter;
- datos reales en development/staging;
- reactivar `SupabaseChatDataSource`.

Altos:

- RLS incompleta en tablas sensibles de `00001`;
- RPC invocada directamente por cliente;
- Edge Function aceptando `userId` desde UI;
- logs con tokens;
- fallback demo desde error real;
- tests SQL/HTTP locales no reejecutados justo antes de remoto.

Medios:

- worktree documental mezclando AG, AG1 y AG2 si no se commitea agrupado;
- seeds sinteticos persistentes sin cleanup;
- production mencionada en docs/tests confundida con uso real;
- chat heredado visible en codigo confundido con flujo seguro.

Bajos:

- warnings informativos de analyzer;
- duplicidad documental;
- nombres legacy como `backendReal`.

### Recomendacion final

No conectar remoto todavia. Cerrar AG2 como evidence pack local y preparar
AG3 solo como plan de conexion development remoto con datos sinteticos.

### Siguiente paquete propuesto

Siguiente recomendado:

```text
2B-AG3 — plan conexion development remoto con datos sinteticos
```

Alternativa si se quiere cerrar los blockers antes:

```text
2B-AG3 — resolver bloqueantes evidence pack backend remoto development
```

No implementar remoto todavia.

## Plan 2B-AG3 — conexión development remoto con datos sintéticos

### Estado

2B-AG2 queda aprobado y cerrado formalmente. El evidence pack local queda
preparado con readiness:

```text
READY WITH BLOCKERS
```

Evidencia aprobada:

- `git status --short`: solo docs modificados;
- `git diff --check`: limpio;
- diff en codigo/Supabase/tests/rutas solicitadas: vacio;
- `flutter analyze --no-fatal-infos`: pasa con 43 infos no fatales;
- `flutter test test/core/config test/architecture`: pasa;
- `flutter test test/features/chat_sessions test/features/chat_messages`:
  pasa, 202 tests;
- `flutter test`: pasa, 367 tests y 2 skips esperados.

Bloqueos vigentes:

- revalidar SQL/pgTAP local antes de cualquier link/deploy;
- revalidar HTTP shell local antes de cualquier link/deploy;
- definir secrets remotos development;
- mantener chat heredado fuera del flujo remoto;
- mantener `SupabaseChatDataSource` bloqueado.

AG3 prepara solo el plan de conexion futura a Supabase development remoto con
datos sinteticos. No ejecuta conexion remota.

### Objetivo de development remoto

`development` remoto sera:

- entorno no productivo;
- proyecto Supabase separado;
- datos sinteticos unicamente;
- sin datos reales;
- sin production keys;
- sin `service_role` en Flutter;
- sin chat heredado;
- sin `SupabaseChatDataSource`;
- sin writes directos desde Flutter.

### Prerrequisitos antes de link

Antes de cualquier `supabase link` se exige:

- aprobacion explicita;
- paquete separado;
- proyecto Supabase development identificado;
- project ref verificado;
- cuenta/organizacion verificada;
- production project ref explicitamente distinto;
- `git status` revisado;
- evidence pack actualizado;
- secrets fuera del repo;
- rollback checklist aprobado.

`supabase link` sigue prohibido en AG3.

### Prerrequisitos antes de migraciones remotas

Antes de migraciones remotas se exige:

- migraciones auditadas;
- RLS auditada;
- grants auditados;
- RPC auditada;
- orden de migraciones verificado;
- base remota vacia o estado inicial conocido;
- no datos reales;
- backup/snapshot si procede;
- rollback documentado.

Comandos remotos siguen prohibidos en AG3.

### Prerrequisitos antes de Edge Functions remotas

Antes de deploy de funciones se exige:

- functions auditadas;
- JWT validation auditada;
- payload estricto auditado;
- rechazo de `userId`/`ownerUserId`/`role` desde UI;
- logs minimizados;
- errores explicitos;
- sin fallback demo;
- secrets function fuera del repo;
- rollback por funcion.

Funciones relevantes:

- `create-own-chat-session`;
- `list-own-chat-sessions`;
- `archive-own-chat-session`;
- `send-user-message`;
- `list-session-messages`.

### Datos sintéticos permitidos

Permitidos en development remoto futuro:

- usuarios sinteticos;
- perfiles sinteticos;
- especialistas de catalogo sinteticos/sanitizados;
- `chat_sessions` sinteticas;
- `messages` sinteticos;
- fixtures sin PII;
- seeds controlados.

Prohibido:

- datos reales;
- datos de salud reales;
- datos personales reales;
- tokens reales en fixtures;
- emails reales salvo dominios reservados tipo `example.com`;
- nombres reales identificables.

### Variables/secrets development

Checklist futuro:

- `SUPABASE_URL` development;
- `SUPABASE_ANON_KEY` development;
- `PROJECT_REF` development;
- Edge Function secrets development;
- JWT config development;
- rollback env vars.

Reglas:

- secrets fuera del repo;
- no `service_role` en Flutter;
- no production keys;
- no logs con tokens;
- no `Authorization` en logs;
- no `refresh_token` en logs.

### Comandos prohibidos y futuros comandos candidatos

En AG3 siguen prohibidos:

- `supabase link`;
- `supabase db push`;
- `supabase migration up` remoto;
- `supabase functions deploy`;
- `supabase secrets set` remoto;
- deploy staging;
- deploy production.

En un paquete futuro podrian proponerse, con aprobacion explicita:

- `supabase link --project-ref <development-ref>`;
- `supabase migration up` remoto contra development;
- `supabase functions deploy` contra development;
- `supabase secrets set` contra development.

No ejecutarlos en AG3.

### Estrategia de pruebas development remoto futura

Pruebas futuras:

- verificar migraciones aplicadas;
- verificar RLS activa;
- verificar grants minimos;
- verificar RPC;
- verificar Edge Functions;
- crear usuario sintetico;
- crear sesion sintetica;
- enviar mensaje sintetico;
- listar mensajes propios;
- verificar aislamiento entre usuarios sinteticos;
- verificar errores ownership;
- verificar logs sin tokens.

### Rollback remoto futuro

Rollback futuro:

- desvincular proyecto si es incorrecto;
- revertir env vars;
- deshabilitar Edge Functions si procede;
- rollback de migracion si procede;
- volver a `backendBlocked`;
- mantener local/demo funcional;
- documentar incidente;
- no tocar production.

### Readiness objetivo

El objetivo del siguiente paquete sera pasar desde:

```text
READY WITH BLOCKERS
```

a uno de:

- `READY FOR DEV LINK`;
- `READY WITH BLOCKERS`;
- `NOT READY`.

AG3 no ejecuta link.

### Riesgos clasificados

Bloqueantes:

- link al proyecto equivocado;
- production keys en development;
- `service_role` en cliente;
- datos reales en development;
- secrets en repo;
- `db push` remoto accidental;
- `functions deploy` accidental.

Altos:

- RLS incompleta;
- Edge Function acepta `userId` desde UI;
- logs con tokens;
- `SupabaseChatDataSource` reactivado;
- writes directos desde Flutter;
- fallback demo desde error real.

Medios:

- SQL/pgTAP local no revalidado;
- HTTP shell local no revalidado;
- project ref mal copiado;
- seed sintetico sin cleanup;
- `backendReal` legacy confundido con development.

Bajos:

- duplicidad documental;
- copy de errores ambiguo;
- warnings informativos no fatales.

### Recomendacion final

No conectar development remoto en AG3. Cerrar AG3 como plan. Despues preparar
AG4 para decidir si se alcanza `READY FOR DEV LINK` o si primero se resuelven
bloqueantes.

### Siguiente paquete propuesto

Siguiente recomendado:

```text
2B-AG4 — decisión READY FOR DEV LINK o resolver bloqueantes
```

Alternativas:

- `2B-AG4 — resolver bloqueantes SQL/pgTAP y HTTP shell local`;
- `2B-AG4 — plan supabase link development controlado`.

No ejecutar remoto todavia.

## Decisión 2B-AG4 — READY FOR DEV LINK o resolver bloqueantes

### Estado

2B-AG3 queda aprobado y cerrado formalmente. La conexión a `development`
remoto queda planificada con datos sintéticos, pero no ejecutada. No se ejecutó
`supabase link`, `supabase db push`, `supabase migration up` remoto,
`supabase functions deploy`, `supabase secrets set`, staging, production,
auth real, Supabase real ni datos reales.

AG4 decide readiness documental para un futuro paquete de `DEV LINK`. La
decisión final es:

```text
READY WITH BLOCKERS
```

No se autoriza todavía ningún comando remoto.

### Bloqueantes AG2/AG3 revalidados

| Bloqueante | Clasificación AG4 | Estado |
| --- | --- | --- |
| Revalidar SQL/pgTAP local antes de cualquier link/deploy | Requiere ejecución local; bloqueante para DEV LINK | Existen tests SQL y harnesses locales, pero no se han reejecutado en AG4. |
| Revalidar HTTP shell local antes de cualquier link/deploy | Requiere ejecución local; bloqueante para DEV LINK | Existen scripts `2b_iv_h` y `2b_v_g`; `flutter test` los mantiene como skips esperados. |
| Definir secrets remotos development | Requiere paquete separado; bloqueante para DEV LINK | La política existe, pero no hay checklist final de valores/ubicación/verificación remota. |
| Mantener chat heredado fuera | Resuelto documentalmente; no bloqueante para plan futuro | Tests de arquitectura siguen bloqueando rutas seguras contra chat heredado. |
| Mantener `SupabaseChatDataSource` bloqueado | Resuelto documentalmente; no bloqueante para plan futuro | Sigue existiendo en `lib/features/chat/` heredado, pero no está conectado al flujo seguro nuevo. |

### Criterios READY FOR DEV LINK

Solo se podrá clasificar como `READY FOR DEV LINK` cuando todo lo siguiente
esté demostrado en el mismo paquete o en evidence pack inmediatamente anterior:

- `git status` entendido, sin cambios prohibidos y con worktree apto para
  separar documentación de ejecución remota;
- migraciones auditadas;
- RLS y grants auditados;
- RPC auditada;
- Edge Functions auditadas;
- `flutter analyze --no-fatal-infos` pasado;
- tests de arquitectura pasados;
- tests Flutter completos pasados;
- checks no-secrets y no-remoto pasados;
- SQL/pgTAP local revalidado o justificación formal explícita aceptada;
- HTTP shell local revalidado o justificación formal explícita aceptada;
- project ref de development identificado, verificado y no usado todavía;
- production project ref explícitamente distinto;
- checklist de secrets development definido, sin valores en repo;
- rollback checklist operativo;
- datos reales prohibidos;
- staging y production bloqueados.

### Criterios READY WITH BLOCKERS

Se mantiene `READY WITH BLOCKERS` si:

- los tests Dart/Flutter y checks documentales pasan;
- no hay evidencia de secrets reales ni conexión remota;
- las piezas local-safe parecen coherentes;
- pero SQL/pgTAP local o HTTP shell local no han sido revalidados;
- el project ref development no está verificado;
- los secrets remotos development no están definidos;
- el rollback remoto todavía no es suficientemente operativo;
- existe worktree documental pendiente que conviene separar antes de ejecutar
  remoto.

Este es el estado de AG4.

### Criterios NOT READY

Debe clasificarse como `NOT READY` si aparece cualquiera de estos hechos:

- fallos de tests críticos;
- secrets reales o production keys detectadas;
- `service_role` en Flutter;
- datos reales en development;
- RLS incompleta bloqueante para tablas que se pretendan exponer;
- Edge Function aceptando `userId`, `ownerUserId` o `role` desde UI;
- `SupabaseChatDataSource` reactivado;
- writes directos desde Flutter;
- chat heredado conectado al flujo seguro;
- fallback demo desde error real;
- tokens en logs o repo.

### Verificaciones locales ejecutadas en AG4

Se ejecutaron verificaciones locales permitidas:

- `git status --short`: solo documentación modificada;
- `git diff --check`: sin salida;
- `git diff --name-only -- lib/core/config lib/core/auth/session lib/features/auth lib/features/chat lib/features/chat_sessions lib/features/chat_messages lib/app.dart lib/main.dart test pubspec.yaml supabase`: sin salida;
- `find . -name '.env*' -type f -not -path './.git/*' -print`: sin salida;
- `flutter analyze --no-fatal-infos`: pasa con 43 infos no fatales;
- `flutter test test/core/config test/architecture`: pasa;
- `flutter test test/features/chat_sessions test/features/chat_messages`: pasa con 202 tests;
- `flutter test`: pasa con 367 tests y 2 skips esperados de harness local HTTP;
- `find supabase/.temp -maxdepth 1 -type f -print`: solo
  `supabase/.temp/cli-latest`;
- comprobación explícita de `supabase/.temp/project-ref`,
  `supabase/.temp/pooler-url` y `supabase/.temp/access-token`: sin salida;
- listado de `supabase/tests/`: existen tests SQL/pgTAP, `.psql` y shell HTTP
  locales que deben revalidarse en paquete separado.

### Checks no-secrets/no-remoto

La búsqueda local de patrones sensibles detecta falsos positivos esperados en:

- tests de arquitectura que bloquean `service_role`, tokens, `/functions/v1/`
  y `SupabaseChatDataSource`;
- documentación y READMEs que describen prohibiciones o harness local;
- Edge Functions locales que leen `SUPABASE_SERVICE_ROLE_KEY` solo desde
  runtime local/efímero;
- scripts shell locales que obtienen tokens efímeros de usuarios de prueba;
- `supabase/config.toml` con `project_id = "Stasisly"` local, sin project ref
  remoto;
- chat heredado en `lib/features/chat/`, documentado como bloqueado para el
  flujo seguro.

No se detectaron `.env*`, project ref remoto, access token Supabase remoto ni
archivo de vínculo remoto en `supabase/.temp`.

### Readiness final

```text
READY WITH BLOCKERS
```

Justificación: la evidencia Dart/Flutter y anti-remoto actual pasa, no hay
cambios prohibidos ni secretos reales detectados, y las fronteras seguras
siguen bloqueando chat heredado y remoto. Pero no es correcto declarar
`READY FOR DEV LINK` porque SQL/pgTAP local, HTTP shell local, project ref
development, checklist de secrets y rollback remoto aún requieren paquete
separado y evidencia fresca.

### Riesgos clasificados

Bloqueantes:

- clasificar `READY FOR DEV LINK` sin SQL/pgTAP local revalidado;
- clasificar `READY FOR DEV LINK` sin HTTP shell local revalidado;
- link al proyecto equivocado;
- production keys en development;
- `service_role` en cliente;
- secrets en repo;
- datos reales en development;
- rollback remoto no operativo.

Altos:

- RLS incompleta en tablas que se pretendan exponer;
- Edge Function aceptando `userId` desde UI;
- logs con tokens;
- `SupabaseChatDataSource` reactivado;
- writes directos desde Flutter;
- fallback demo desde error real.

Medios:

- project ref development aún no verificado;
- secrets remotos development no definidos;
- SQL/pgTAP y HTTP shell existentes pero no reejecutados en AG4;
- worktree documental acumulado pendiente de commit;
- staging confundido con development.

Bajos:

- duplicidad documental entre ADR-006, ADR-007 y tracker;
- warnings informativos no fatales de `flutter analyze`;
- nombres heredados que siguen presentes solo en piezas bloqueadas.

### Recomendación final

No ejecutar `supabase link` todavía. Cerrar AG4 como decisión de readiness y
abrir un paquete separado para resolver bloqueantes antes de cualquier link,
push, deploy o secrets remotos.

### Siguiente paquete propuesto

Siguiente recomendado:

```text
2B-AG5 — resolver bloqueantes readiness development remoto
```

Alcance recomendado para AG5:

- reejecutar SQL/pgTAP local;
- reejecutar HTTP shell local para `chat_sessions` y `messages`;
- confirmar cleanup local;
- definir checklist de secrets development sin valores;
- definir project ref development como dato externo verificado, sin ejecutar
  `supabase link`;
- preparar rollback operativo.

No ejecutar remoto todavía.

## Revisión 2B-AG5 — resolver bloqueantes readiness development remoto

### Estado

2B-AG4 queda aprobado y cerrado formalmente con readiness:

```text
READY WITH BLOCKERS
```

AG5 revalida los bloqueantes locales permitidos sin ejecutar conexión remota.
No se ejecutó `supabase link`, `supabase db push`, `supabase migration up`
remoto, `supabase functions deploy`, `supabase secrets set`, staging,
production, auth real, Supabase real ni datos reales.

Readiness final tras AG5:

```text
READY WITH BLOCKERS
```

La diferencia frente a AG4 es que SQL/pgTAP local y HTTP shell local quedan
revalidados. Persisten como bloqueantes externos/documentales antes de cualquier
DEV LINK: project ref development real, separación explícita frente a production
ref, secrets checklist con ubicación real fuera del repo y rollback remoto
operativo aprobado.

### SQL/pgTAP local

Harness encontrado:

- `supabase/tests/*.sql`;
- `supabase/tests/README.md`;
- comando local `supabase test db --local`.

Ejecución AG5:

```text
supabase start -x studio,realtime,storage-api,imgproxy,mailpit,postgres-meta,logflare,vector,supavisor
supabase db reset --local --no-seed
supabase test db --local
```

Resultado:

```text
Files=12, Tests=394, Result: PASS
```

SQL/pgTAP local queda revalidado para:

- `public.users`;
- `specialist_catalog`;
- `chat_sessions`;
- `messages`;
- fixtures transaccionales/postcondiciones;
- RPC `send_user_message_core`;
- RLS/grants/zero policies esperadas.

### HTTP shell local

Harnesses encontrados:

- `supabase/tests/2b_iv_h_local_http_integration_test.sh`;
- `supabase/tests/2b_v_g_messages_http_integration_test.sh`;
- tests Dart integrados en `test/integration/`.

Ejecuciones AG5:

```text
bash supabase/tests/2b_iv_h_local_http_integration_test.sh
bash supabase/tests/2b_v_g_messages_http_integration_test.sh
```

Resultados:

```text
2B-IV-H local HTTP integration harness: PASS
2B-V-G messages local HTTP integration harness: PASS
```

Ambos harnesses ejecutaron preflight anti-remoto, sirvieron Edge Functions solo
localmente, ejecutaron integración Dart contra `127.0.0.1`, validaron logs
seguros y terminaron con:

```text
0|0|0|0|0|0
```

Además se verificó postcondición global contra la base local:

```text
0|0|0|0|0|0
```

### Checklist project ref development

Checklist documental requerido antes de cualquier paquete de DEV LINK:

- `project ref development` identificado como dato externo, no escrito en docs
  si se considera sensible: `<DEV_PROJECT_REF>`;
- `project ref production` explícitamente distinto:
  `<PRODUCTION_PROJECT_REF>`;
- organización/cuenta verificada;
- nombre de proyecto claramente development;
- región documentada si aplica;
- owner/admin verificado;
- riesgo de confusión con production mitigado;
- captura o evidencia humana guardada fuera del repo si incluye valores;
- `supabase/.temp/project-ref` inexistente antes de link;
- comando futuro escrito con placeholder, nunca ejecutado en AG5.

Estado AG5:

```text
Pendiente de verificación externa.
```

No se puede declarar resuelto hasta que el cliente confirme el proyecto
development real y su separación explícita frente a production.

### Checklist secrets development

Checklist documental requerido:

- `SUPABASE_URL` development;
- `SUPABASE_ANON_KEY` development;
- `PROJECT_REF` development;
- Edge Function secrets development;
- JWT validation config;
- rollback env vars;
- ubicación segura fuera del repo;
- responsable de rotación;
- confirmación de que no hay production keys;
- confirmación de que `service_role` nunca llega a Flutter;
- confirmación de que logs no incluyen `Authorization`, `refresh_token`,
  `access_token`, JWT completo ni secrets;
- confirmación de que no se pegan secrets en screenshots, tracker ni ADRs.

Estado AG5:

```text
Checklist definido, valores reales pendientes y fuera del repo.
```

La CLI local puede imprimir claves locales efímeras durante `supabase start` o
`supabase status`; no deben copiarse a documentación ni tracker.

### Rollback remoto operativo documental

Rollback requerido antes de cualquier DEV LINK:

1. confirmar entorno objetivo antes de link;
2. abortar si el project ref no coincide exactamente con `<DEV_PROJECT_REF>`;
3. si se enlaza proyecto equivocado, ejecutar desvinculación local y registrar
   incidente;
4. revertir variables de entorno locales;
5. volver a `backendBlocked` en configuración de app;
6. deshabilitar Edge Functions development si fueron desplegadas en paquete
   futuro;
7. aplicar rollback de migraciones development solo si existe plan aprobado y
   datos sintéticos;
8. conservar local/demo funcional;
9. no tocar staging;
10. no tocar production;
11. rotar cualquier secret expuesto accidentalmente;
12. registrar evidencia post-rollback.

Estado AG5:

```text
Rollback documental definido; ejecución remota pendiente de paquete futuro.
```

### Checks no-secrets/no-remoto

Verificaciones AG5:

- `find . -name '.env*' -type f -not -path './.git/*' -print`: sin salida;
- `supabase/.temp/project-ref`: inexistente;
- `supabase/.temp/pooler-url`: inexistente;
- `supabase/.temp/access-token`: inexistente;
- búsqueda de patrones remoto/secrets: falsos positivos en docs, tests,
  harness local y ejemplos bloqueados.

Falsos positivos esperados:

- tests que usan `project.supabase.co` para validar bloqueo de remoto;
- scripts shell con preflight anti-remoto;
- documentación que enumera comandos prohibidos;
- ejemplos de `SUPABASE_URL` en comentarios;
- Edge Functions locales que leen `SUPABASE_SERVICE_ROLE_KEY` desde runtime
  local/efímero, no desde Flutter ni repo;
- `SupabaseChatDataSource` heredado sigue presente como pieza bloqueada.

No se detectó vínculo remoto ni archivo `.env`.

### Verificaciones locales base

AG5 ejecutó:

- `git status --short`: solo documentación modificada;
- `git diff --check`: limpio;
- `flutter analyze --no-fatal-infos`: pasa con 43 infos no fatales;
- `flutter test test/core/config test/architecture`: pasa;
- `flutter test test/features/chat_sessions test/features/chat_messages`: pasa
  con 202 tests;
- `flutter test`: pasa con 367 tests y 2 skips esperados;
- `git diff --name-only -- lib/core/config lib/core/auth/session lib/features/auth lib/features/chat lib/features/chat_sessions lib/features/chat_messages lib/app.dart lib/main.dart test pubspec.yaml supabase`: sin salida.

Los 2 skips esperados de `flutter test` corresponden a harnesses locales HTTP
que AG5 ejecutó explícitamente por shell y ambos pasaron.

### Readiness final

```text
READY WITH BLOCKERS
```

Bloqueantes resueltos en AG5:

- SQL/pgTAP local revalidado;
- HTTP shell local `chat_sessions` revalidado;
- HTTP shell local `messages` revalidado;
- cleanup local confirmado en `0|0|0|0|0|0`;
- no-secrets/no-remoto local sin hallazgos reales;
- tests Flutter/arquitectura pasados.

Bloqueantes restantes:

- project ref development real no verificado;
- production ref distinto no verificado;
- secrets development no configurados ni validados fuera del repo;
- rollback remoto definido documentalmente pero no probado;
- worktree documental acumulado pendiente de commit.

### Riesgos clasificados

Bloqueantes:

- declarar `READY FOR DEV LINK` sin project ref development real verificado;
- confundir development con production;
- introducir secrets reales en docs o tracker;
- usar production keys en development;
- poner `service_role` en cliente;
- ejecutar `supabase link` sin paquete separado.

Altos:

- rollback remoto no probado;
- logs con tokens;
- `SupabaseChatDataSource` reactivado;
- writes directos desde Flutter;
- fallback demo desde error real.

Medios:

- worktree documental acumulado;
- CLI local imprime claves efímeras si no se redacta salida;
- nombres heredados aún presentes solo en módulos bloqueados.

Bajos:

- duplicidad documental;
- infos no fatales de análisis;
- dependencia de Docker/Supabase local para repetir evidence pack.

### Recomendación final

No ejecutar `supabase link` todavía. AG5 reduce los bloqueantes a elementos de
entorno remoto y gobierno de secrets. El siguiente paquete debe decidir y
validar datos externos de development sin ejecutar link.

### Siguiente paquete propuesto

Siguiente recomendado:

```text
2B-AG6 — preparar DEV LINK controlado sin ejecutarlo
```

Alcance recomendado:

- verificar cuenta/organización Supabase;
- registrar placeholders aprobados para `<DEV_PROJECT_REF>` y
  `<PRODUCTION_PROJECT_REF>` sin valores sensibles;
- preparar checklist de secrets fuera del repo;
- preparar comando candidato de link sin ejecutarlo;
- definir evidencia requerida para pasar a `READY FOR DEV LINK`.

## Runbook 2B-AG6 — DEV LINK controlado sin ejecución remota

### Estado

2B-AG5 queda aprobado y cerrado formalmente. Los bloqueantes locales quedaron
resueltos: SQL/pgTAP local, HTTP shell local, cleanup local, no-secrets local y
tests Flutter/arquitectura pasaron. La readiness sigue siendo:

```text
READY WITH BLOCKERS
```

AG6 prepara el runbook exacto para un futuro `supabase link` contra un proyecto
`development`, pero no ejecuta link ni ningún comando remoto.

### Checklist de identidad del proyecto development

Antes de autorizar cualquier paquete AG7 que ejecute `supabase link`, debe
existir evidencia externa, no secreta y revisada de:

| Campo | Placeholder permitido | Regla |
| --- | --- | --- |
| Project ref development | `<DEV_PROJECT_REF>` | Verificado visualmente en Supabase dashboard; no escribir valor real si se considera sensible. |
| Nombre development | `<DEV_PROJECT_NAME>` | Debe contener `development` o `dev` de forma inequívoca. |
| Organización/cuenta | `<DEV_ORG_NAME>` | Debe coincidir con la cuenta/organización aprobada para Stasisly. |
| Región | `<DEV_REGION>` | Documentar región si aplica; no debe confundirse con production. |
| Owner/admin | `<DEV_OWNER_EMAIL_OR_ROLE>` | Verificar rol/capacidad de administración sin publicar email sensible si no procede. |
| Project ref production | `<PRODUCTION_PROJECT_REF>` | Debe ser explícitamente distinto a `<DEV_PROJECT_REF>`. |
| Project ref staging | `<STAGING_PROJECT_REF>` | Si existe, debe ser explícitamente distinto a development y production. |

Reglas:

- las capturas de pantalla, si se usan como evidencia, deben ocultar secrets,
  keys, tokens, connection strings y datos personales;
- no copiar secrets al repo;
- no copiar valores reales al tracker si no son estrictamente necesarios;
- si el ref se documenta, debe revisarse que no sea production;
- cualquier duda sobre cuenta, org, región o nombre bloquea AG7.

### Checklist de secrets development

Antes de cualquier link o deploy remoto debe existir checklist externo, fuera
del repo, para:

- `SUPABASE_URL` development;
- `SUPABASE_ANON_KEY` development;
- `PROJECT_REF` development;
- JWT config development;
- Edge Function secrets development;
- variables de rollback.

Reglas:

- secrets fuera del repo;
- no secrets en docs;
- no secrets en `SESSION_TRACKER.md`;
- no secrets en prompts;
- no secrets en screenshots visibles;
- no `service_role` en Flutter;
- no production keys;
- no tokens en logs;
- no `Authorization` en logs;
- no `refresh_token` ni `access_token` en logs;
- no compartir salidas CLI que muestren claves sin redactarlas.

### Preflight obligatorio antes de link

El paquete que aspire a ejecutar link deberá repetir, justo antes del comando,
este preflight local:

```bash
git status --short
git diff --check
supabase db reset --local --no-seed
supabase test db --local
bash supabase/tests/2b_iv_h_local_http_integration_test.sh
bash supabase/tests/2b_v_g_messages_http_integration_test.sh
flutter analyze --no-fatal-infos
flutter test test/core/config test/architecture
flutter test test/features/chat_sessions test/features/chat_messages
flutter test
```

Checks no-secrets/no-remoto obligatorios:

- ausencia de `.env*` versionables;
- ausencia de `supabase/.temp/project-ref`;
- ausencia de `supabase/.temp/pooler-url`;
- ausencia de `supabase/.temp/access-token`;
- revisión de `service_role` y `SUPABASE_SERVICE_ROLE_KEY`;
- ausencia de `Authorization` hardcodeado;
- ausencia de `refresh_token` hardcodeado;
- ausencia de `access_token` hardcodeado;
- ausencia de production URL/key;
- `SupabaseChatDataSource` no reactivado;
- `/functions/v1/` solo en datasources/harness locales aprobados;
- diff de código, tests y Supabase entendido antes de remoto.

Falsos positivos esperados deben documentarse y ser explicables como tests,
docs, harness local o pieza heredada bloqueada.

### Comando candidato futuro

Comando candidato para un paquete futuro, no ejecutable en AG6:

```bash
supabase link --project-ref <DEV_PROJECT_REF>
```

Reglas:

- solo contra development;
- solo con aprobación explícita futura;
- solo tras project ref verificado;
- solo tras preflight limpio;
- solo tras rollback checklist aprobado;
- nunca contra production;
- abortar si el dashboard, CLI o `.temp/project-ref` no coinciden exactamente.

### Comandos prohibidos en AG6

AG6 prohíbe:

```bash
supabase link --project-ref <DEV_PROJECT_REF>
supabase db push
supabase migration up
supabase functions deploy
supabase secrets set
```

También quedan prohibidos:

- deploy staging;
- deploy production;
- datos reales;
- auth real;
- Supabase real conectado desde Flutter;
- registrar `/conversations`;
- tocar `/chat/:id`;
- tocar `/orchestrator/chat`;
- conectar chat heredado;
- reactivar `SupabaseChatDataSource`;
- writes directos desde Flutter.

### Rollback si link futuro es incorrecto

Runbook de rollback para un futuro paquete con link:

1. detener ejecución inmediatamente;
2. no ejecutar migraciones;
3. no desplegar funciones;
4. verificar `supabase/.temp/project-ref`;
5. si el ref no es `<DEV_PROJECT_REF>`, desvincular/eliminar referencia local
   siguiendo el procedimiento aprobado para la CLI vigente;
6. limpiar variables locales equivocadas;
7. rotar cualquier secret si se expuso;
8. volver a `backendBlocked`;
9. abrir incidente documental;
10. confirmar production intacto;
11. confirmar staging intacto;
12. registrar evidencia post-rollback.

Si hubo contacto con production, el estado pasa automáticamente a `NOT READY`
y se exige paquete de incidente antes de continuar.

### Evidence pack para AG7

AG7 solo podrá autorizarse si existe:

- project ref development verificado;
- production ref distinto;
- staging ref distinto si existe;
- secrets checklist completo fuera del repo;
- rollback checklist completo;
- preflight local fresco;
- worktree controlado;
- aprobación explícita;
- comando exacto preparado;
- no datos reales;
- no production;
- no secretos en docs, tracker, prompts ni screenshots visibles;
- decisión explícita de si AG7 ejecutará link o solo verificará valores.

### Readiness al cierre de AG6

AG6 mantiene:

```text
READY WITH BLOCKERS
```

No se pasa a `READY FOR DEV LINK` porque AG6 no verifica valores reales de
project refs ni secrets. Para pasar a `READY FOR DEV LINK` deberán quedar
verificados documentalmente, sin exponer valores sensibles:

- `<DEV_PROJECT_REF>`;
- `<PRODUCTION_PROJECT_REF>` distinto;
- secrets development fuera del repo;
- rollback remoto aprobado;
- preflight fresco.

### Riesgos clasificados

Bloqueantes:

- ejecutar link en AG6;
- usar project ref equivocado;
- usar production ref;
- copiar secrets en docs, tracker, prompts o screenshots;
- production keys en development;
- `service_role` en cliente.

Altos:

- preflight obsoleto;
- rollback remoto ambiguo;
- worktree mezclado;
- logs con tokens;
- fallback demo desde error real;
- `SupabaseChatDataSource` reactivado.

Medios:

- evidencia visual incompleta;
- nombre de proyecto ambiguo;
- región no documentada;
- duplicidad documental.

Bajos:

- warnings informativos de análisis;
- cambios de CLI Supabase que alteren comandos de unlink/rollback;
- necesidad de repetir harness local por tiempo de espera.

### Recomendación final

No ejecutar link en AG6. Cerrar AG6 como runbook/checklist de DEV LINK
controlado. Después decidir AG7 solo si se verifican project ref, secrets y
rollback fuera del repo.

### Siguiente paquete propuesto

Siguiente recomendado:

```text
2B-AG7 — verificar project ref/secrets/rollback para DEV LINK
```

AG7 deberá seguir sin ejecutar remoto salvo aprobación explícita distinta.

## Verificación 2B-AG7 — project ref/secrets/rollback para DEV LINK

### Estado

2B-AG6 queda aprobado y cerrado formalmente. AG7 verifica readiness para DEV
LINK sin ejecutar `supabase link`, `supabase db push`, `supabase migration up`
remoto, `supabase functions deploy` ni `supabase secrets set`.

Readiness final:

```text
READY WITH BLOCKERS
```

La base local queda revalidada, pero no se puede declarar `READY FOR DEV LINK`
porque la identidad real del proyecto Supabase development, la separación con
production/staging y el checklist de secrets reales siguen sin quedar
verificados fuera del repo.

### Identidad proyecto development

| Elemento | Estado | Evidencia / decisión |
|---|---|---|
| Proyecto Supabase development existe | Pendiente | No se aportó evidencia externa verificable en AG7. |
| Nombre claramente development/dev | Pendiente | Debe verificarse en dashboard/organización antes de link. |
| Organización/cuenta correcta | Pendiente | Debe verificarse fuera del repo. |
| Región documentada | Pendiente | No se registra valor real en docs. |
| Owner/responsable por rol | Pendiente | Debe registrarse como rol, no como secreto ni dato innecesario. |
| Project ref development | Pendiente | No se pega en repo; falta marcarlo como verificado externamente. |
| Distinto de production | Bloqueante | No se puede declarar listo sin comparar refs fuera del repo. |
| Distinto de staging | Pendiente / no aplica si staging no existe | Staging pendiente no bloquea si production queda separado. |

### Separación staging/production

Decisión vigente:

- production no se toca;
- production no se vincula;
- production no recibe migraciones;
- production no recibe Edge Functions;
- production no recibe datos reales;
- staging, si no existe, queda pendiente y no bloquea DEV LINK siempre que
  production quede explícitamente separado;
- no se deben usar production keys ni staging keys en development.

AG7 no verifica refs reales, por tanto la separación queda como bloqueante
documental pendiente.

### Checklist secrets development

| Elemento | Estado | Regla |
|---|---|---|
| `SUPABASE_URL` development | Pendiente | Verificar fuera del repo; no pegar valor real. |
| `SUPABASE_ANON_KEY` development | Pendiente | Verificar fuera del repo; no pegar valor real. |
| `PROJECT_REF` development | Pendiente | Verificar fuera del repo; no pegar valor real. |
| Edge Function secrets development | Pendiente | No usar `service_role` en Flutter; solo runtime backend. |
| JWT validation config | Pendiente | Debe validarse antes de remoto real. |
| Rollback env vars | Pendiente | Deben quedar definidas fuera del repo. |

Reglas reafirmadas:

- no secrets en repo;
- no secrets en docs;
- no secrets en `SESSION_TRACKER.md`;
- no secrets en prompts;
- no screenshots con secrets visibles;
- no `service_role` en Flutter;
- no production keys;
- no tokens en logs;
- no `Authorization` ni `refresh_token` en logs.

### Rollback remoto operativo

Rollback definido como runbook, pero no probado contra remoto:

1. detener ejecución si el ref no coincide;
2. no ejecutar migraciones;
3. no desplegar funciones;
4. comprobar `supabase/.temp/project-ref` solo cuando exista link futuro;
5. eliminar estado local equivocado si aplica;
6. revertir env vars equivocadas;
7. rotar secrets si se expusieron;
8. volver a `backendBlocked`;
9. mantener local/demo funcional;
10. confirmar production intacto;
11. registrar incidente.

Clasificación: parcial. Es suficiente como runbook previo, pero bloquea
`READY FOR DEV LINK` hasta verificar refs/secrets reales.

### Preflight fresco AG7

| Comando | Resultado |
|---|---|
| `git status --short` | Solo docs modificados: ADR-006, ADR-007 y tracker. |
| `git diff --check` | Sin salida. |
| `supabase start` | Primer intento falló por `logflare` unhealthy; arranque local recuperado con `supabase start -x logflare`. |
| `supabase db reset --local --no-seed` | PASS; migraciones 00001-00007 aplicadas localmente. |
| `supabase test db --local` | PASS; 12 files, 394 tests. |
| `bash supabase/tests/2b_iv_h_local_http_integration_test.sh` | PASS; cleanup `0|0|0|0|0|0`. |
| `bash supabase/tests/2b_v_g_messages_http_integration_test.sh` | PASS; cleanup `0|0|0|0|0|0`. |
| `flutter analyze --no-fatal-infos` | PASS con 43 infos preexistentes. |
| `flutter test test/core/config test/architecture` | PASS; 66 tests. |
| `flutter test test/features/chat_sessions test/features/chat_messages` | PASS; 202 tests. |
| `flutter test` | PASS; 367 tests y 2 skips esperados. |

Nota de seguridad: `supabase start` imprime claves locales efímeras propias de
la CLI. No se registran en este ADR, no se versionan y no autorizan remoto.

### Checks no-secrets/no-remoto

Resultado:

- no hay `.env*` en el workspace;
- `supabase/.temp` contiene solo `cli-latest`;
- no existen `supabase/.temp/project-ref`, `supabase/.temp/pooler-url` ni
  `supabase/.temp/access-token`;
- no hay cambios en `lib/`, `test/`, `pubspec.yaml` ni `supabase/` dentro del
  diff de AG7;
- los hits de `service_role`, `Authorization`, `access_token`,
  `refresh_token`, `/functions/v1/` y `SupabaseChatDataSource` corresponden a
  harness/tests locales, docs, Edge Functions locales o piezas heredadas
  auditadas y bloqueadas;
- los hits `supabase.co`/production corresponden a tests de bloqueo, ejemplos,
  fixtures no productivas o documentación.

### Riesgos clasificados

Bloqueantes:

- project ref development real no verificado;
- production ref no confirmado distinto;
- checklist de secrets reales pendiente fuera del repo;
- rollback remoto no probado contra proyecto real;
- `supabase start` requiere excluir `logflare` en este entorno local.

Altos:

- link accidental al proyecto equivocado;
- secrets reales pegados en docs/prompts/screenshots;
- production keys usadas en development;
- `service_role` en Flutter;
- `SupabaseChatDataSource` reactivado;
- writes directos desde Flutter.

Medios:

- worktree con cambios documentales acumulados;
- falsos positivos de secretos en tests/docs que requieren interpretación;
- preflight local dependiente del estado Docker/Supabase CLI.

Bajos:

- duplicidad documental entre ADR-006 y ADR-007;
- nombres de paquete largos;
- necesidad de recordar excluir `logflare` si vuelve a fallar analytics local.

### Decisión AG7

AG7 se cierra como verificación local fresca y preparación documental. No
desbloquea `supabase link`.

Decisión final:

```text
READY WITH BLOCKERS
```

### Siguiente paquete propuesto

```text
2B-AG8 — resolver bloqueantes finales DEV LINK
```

Objetivo: aportar evidencia externa sin secretos de project refs development /
production, clasificar secrets reales fuera del repo y confirmar rollback antes
de autorizar un paquete separado que ejecute `supabase link`.

## Resolución 2B-AG8 — bloqueantes finales DEV LINK

### Estado

2B-AG7 queda aprobado y cerrado formalmente. AG8 revisa los bloqueantes finales
de DEV LINK, repite preflight local y actualiza readiness sin ejecutar
`supabase link`, `supabase db push`, `supabase migration up` remoto,
`supabase functions deploy` ni `supabase secrets set`.

Readiness final:

```text
READY WITH BLOCKERS
```

Motivo: la evidencia local vuelve a pasar, pero no se aportó evidencia externa
sin secretos para project ref development, production ref distinto, staging si
aplica ni checklist real de secrets development.

### Project ref development

| Elemento | Estado AG8 | Observación |
|---|---|---|
| Proyecto Supabase development existe | Pendiente bloqueante | No se aportó evidencia externa verificable. |
| Nombre contiene dev/development | Pendiente bloqueante | Debe verificarse fuera del repo. |
| Organización/cuenta correcta | Pendiente bloqueante | Debe verificarse fuera del repo. |
| Región documentada | Pendiente | No se registra valor real en docs. |
| Owner/responsable por rol | Pendiente | Debe registrarse como rol, no como secreto. |
| Project ref development verificado | Pendiente bloqueante | No se escribe valor real en documentación. |
| Development no es production | Pendiente bloqueante | Requiere comparación externa de refs. |
| Development no es staging | Pendiente / no aplica | Depende de si staging existe. |

### Production ref distinto

Estado: pendiente bloqueante.

AG8 no recibió evidencia externa para declarar que production ref es distinto o
que production no existe/no se usa todavía de forma inequívoca. Production sigue
bloqueado: no link, no migraciones, no funciones, no datos reales y no keys.

### Staging ref si aplica

Estado: pendiente / no aplica hasta que se confirme externamente.

Si staging existe, debe verificarse distinto de development y production. Si no
existe, debe registrarse como pendiente/no creado y no bloqueante siempre que
production quede claramente separado.

### Secrets development fuera del repo

| Elemento | Estado AG8 | Bloqueo |
|---|---|---|
| `SUPABASE_URL` development | Pendiente | Bloqueante para link real. |
| `SUPABASE_ANON_KEY` development | Pendiente | Bloqueante para link real si el flujo la requiere. |
| `PROJECT_REF` development | Pendiente | Bloqueante. |
| Edge Function secrets development | Pendiente | Bloqueante antes de deploy, no antes de solo link si AG9 lo limita estrictamente. |
| JWT config development | Pendiente | Bloqueante antes de validar auth real/remoto. |
| Rollback env vars | Pendiente | Bloqueante antes de link real. |

Reglas reafirmadas:

- no secrets en repo;
- no secrets en docs;
- no secrets en `SESSION_TRACKER.md`;
- no secrets en prompts;
- no secrets en screenshots visibles;
- no tokens en logs;
- no `Authorization` ni `refresh_token` en logs;
- `service_role` nunca en Flutter;
- production keys nunca en development.

### Rollback remoto operativo

Clasificación AG8:

```text
completo como runbook documental; no probado contra remoto
```

AG8 deja definido cómo:

1. detectar link a proyecto incorrecto;
2. comprobar `supabase/.temp/project-ref` tras un link futuro;
3. abortar antes de migraciones/functions;
4. limpiar estado local equivocado;
5. revertir env vars;
6. decidir cuándo rotar secrets;
7. volver a `backendBlocked`;
8. confirmar local/demo funcional;
9. confirmar production intacto;
10. registrar incidente.

No se eleva a prueba remota porque AG8 no ejecuta link ni toca remoto.

### Preflight local fresco AG8

| Comando | Resultado |
|---|---|
| `git status --short` | Solo docs modificados: ADR-006, ADR-007 y tracker. |
| `git diff --check` | Sin salida. |
| `supabase start -x logflare` | PASS local; se excluye `logflare` por el fallo conocido de analytics local. |
| `supabase db reset --local --no-seed` | PASS; migraciones 00001-00007 aplicadas localmente. |
| `supabase test db --local` | PASS; 12 files, 394 tests. |
| `bash supabase/tests/2b_iv_h_local_http_integration_test.sh` | PASS; cleanup `0|0|0|0|0|0`. |
| `bash supabase/tests/2b_v_g_messages_http_integration_test.sh` | PASS; cleanup `0|0|0|0|0|0`. |
| `flutter analyze --no-fatal-infos` | PASS con 43 infos preexistentes. |
| `flutter test test/core/config test/architecture` | PASS; 66 tests. |
| `flutter test test/features/chat_sessions test/features/chat_messages` | PASS; 202 tests. |
| `flutter test` | PASS; 367 tests y 2 skips esperados. |
| `supabase stop` | PASS; entorno local detenido. |

Nota de seguridad: la CLI puede imprimir claves locales efímeras al arrancar
Supabase local. No se registran en ADRs ni tracker y no autorizan remoto.

### Checks no-secrets/no-remoto

Resultado AG8:

- `.env` existe, está vacío, no aparece en `git status` y está ignorado por
  `.gitignore`;
- `supabase/.temp` contiene solo `cli-latest`;
- no existen `supabase/.temp/project-ref`, `supabase/.temp/pooler-url` ni
  `supabase/.temp/access-token`;
- no hay cambios de AG8 en `lib/`, `test/`, `pubspec.yaml` ni `supabase/`;
- los hits de `service_role`, `SUPABASE_SERVICE_ROLE_KEY`, `Authorization`,
  `access_token`, `refresh_token`, `/functions/v1/`, `supabase.co` y
  `SupabaseChatDataSource` corresponden a tests, harness local, README local,
  funciones locales o piezas heredadas auditadas y bloqueadas.

### Riesgos clasificados

Bloqueantes:

- project ref development real no verificado;
- production ref no confirmado distinto o inexistente/no usado;
- secrets development reales no verificados fuera del repo;
- rollback no probado contra remoto real;
- ejecutar link accidental antes de aportar evidencia externa.

Altos:

- production keys confundidas con development;
- staging ref confundido con development;
- secrets reales pegados en docs/prompts/screenshots;
- `service_role` en Flutter;
- `SupabaseChatDataSource` reactivado;
- writes directos desde Flutter.

Medios:

- `.env` local vacío ignorado que debe permanecer no versionado;
- falsos positivos de patrones sensibles en tests/harness/docs;
- dependencia de `supabase start -x logflare` para el entorno local actual;
- worktree documental acumulado.

Bajos:

- duplicidad documental entre ADR-006 y ADR-007;
- nombres largos de paquetes;
- infos no fatales de Flutter analyze.

### Decisión AG8

AG8 no desbloquea DEV LINK real. La decisión final permanece:

```text
READY WITH BLOCKERS
```

### Siguiente paquete propuesto

```text
2B-AG9 — resolver bloqueantes restantes DEV LINK
```

AG9 debe aportar evidencia externa sin secretos de project refs y secrets antes
de plantear un paquete posterior que ejecute `supabase link`.

## Revisión 2B-AG9 — bloqueantes externos DEV LINK

### Estado

2B-AG8 queda aprobado y cerrado formalmente. AG9 revisa los bloqueantes
externos restantes para DEV LINK sin ejecutar `supabase link`, `supabase db
push`, `supabase migration up` remoto, `supabase functions deploy` ni
`supabase secrets set`.

Readiness final:

```text
READY WITH BLOCKERS
```

No se puede pasar a `READY FOR DEV LINK` porque AG9 no aporta evidencia externa
sin secretos que verifique el proyecto Supabase development, la separación con
production/staging ni la ubicación real de secrets development fuera del repo.

### Proyecto development verificado

| Elemento | Estado AG9 | Clasificación |
|---|---|---|
| Proyecto Supabase development existe | Pendiente | Bloqueante |
| Nombre indica dev/development | Pendiente | Bloqueante |
| Organización/cuenta correcta | Pendiente | Bloqueante |
| Región documentada | Pendiente | Pendiente |
| Owner/responsable por rol | Pendiente | Pendiente |
| Project ref development verificado fuera del repo | Pendiente | Bloqueante |
| Project ref development no pegado en docs | Cumplido | No bloqueante |

### Separación production

Estado AG9:

```text
pendiente bloqueante
```

No consta evidencia externa de que production no exista/no se use todavía, ni
de que production exista con ref distinto al development ref. Production sigue
bloqueado: no se toca, no recibe migraciones, no recibe funciones, no contiene
datos tocados por este flujo y no se usan production keys.

### Separación staging si aplica

Estado AG9:

```text
pendiente / no aplica hasta confirmación externa
```

Si staging existe, debe verificarse que su ref es distinto de development y
production. Si staging no existe, debe registrarse como pendiente/no creado y
no bloqueante siempre que development quede separado de production.

### Secrets development fuera del repo

| Elemento | Estado AG9 | Clasificación |
|---|---|---|
| `SUPABASE_URL` development | Pendiente | Pendiente bloqueante para conexión real |
| `SUPABASE_ANON_KEY` development | Pendiente | Pendiente bloqueante para conexión real |
| `PROJECT_REF` development | Pendiente | Pendiente bloqueante |
| Edge Function secrets development | Pendiente | Pendiente antes de deploy |
| JWT config development | Pendiente | Pendiente antes de auth real/remoto |
| Rollback env vars | Pendiente | Pendiente bloqueante antes de link real |

Reglas vigentes:

- no secrets en docs;
- no secrets en `SESSION_TRACKER.md`;
- no secrets en prompts;
- no secrets en screenshots visibles;
- no `service_role` en Flutter;
- no production keys en development;
- no tokens en logs;
- no `Authorization` ni `refresh_token` en logs.

### Rollback remoto operativo

Clasificación AG9:

```text
completo como runbook documental; no probado contra remoto
```

El runbook cubre:

- detección de link a proyecto incorrecto;
- comprobación futura de `supabase/.temp/project-ref`;
- aborto antes de migraciones/functions;
- limpieza de estado local equivocado;
- reversión de env vars;
- criterios de rotación de secrets si hubo exposición;
- vuelta a `backendBlocked`;
- confirmación de local/demo funcional;
- confirmación de production intacto;
- registro de incidente.

### Preflight local

AG9 no reejecuta el preflight pesado porque el objetivo del paquete es resolver
bloqueantes externos y AG8 dejó evidencia local fresca aprobada:

- `supabase start -x logflare`: PASS;
- `supabase db reset --local --no-seed`: PASS;
- `supabase test db --local`: PASS, 394 tests;
- harness 2B-IV-H: PASS, cleanup `0|0|0|0|0|0`;
- harness 2B-V-G: PASS, cleanup `0|0|0|0|0|0`;
- `flutter analyze --no-fatal-infos`: PASS con 43 infos;
- core/architecture: PASS, 66 tests;
- chat_sessions/chat_messages: PASS, 202 tests;
- `flutter test`: PASS, 367 tests y 2 skips esperados;
- `supabase stop`: PASS.

En AG9 se ejecutan checks finales de diff/no-remoto antes del cierre.

### Checks no-secrets/no-remoto

Resultado AG9:

- `git diff --check`: sin salida;
- diff de rutas críticas/código/Supabase/test: sin salida;
- cambios limitados a ADR-006, ADR-007 y tracker;
- `.env` local sigue tratado como archivo local ignorado/no versionado; no se
  debe leer ni registrar su contenido;
- `supabase/.temp/project-ref`, `pooler-url` y `access-token` no deben existir
  antes de un paquete de link.

### Riesgos clasificados

Bloqueantes:

- project ref development incorrecto o no verificado;
- production ref confundido con development;
- staging ref confundido con development;
- secrets reales pegados en docs/prompts/screenshots;
- rollback no probado contra remoto;
- link ejecutado accidentalmente.

Altos:

- `service_role` en Flutter;
- production keys en development;
- `SupabaseChatDataSource` reactivado;
- writes directos desde Flutter;
- tokens en logs.

Medios:

- `.env` local vacío/ignorado mal interpretado;
- dependencia local de `supabase start -x logflare`;
- worktree documental acumulado;
- preflight pesado no reejecutado en AG9.

Bajos:

- duplicidad documental;
- nombres largos de paquetes;
- infos no fatales de análisis ya conocidas.

### Decisión AG9

AG9 no desbloquea DEV LINK real.

```text
READY WITH BLOCKERS
```

### Siguiente paquete propuesto

```text
2B-AG10 — resolver bloqueantes externos DEV LINK
```

AG10 debe aportar evidencia externa sin secretos de project refs, separación de
entornos y secrets development. Si esa evidencia queda completa, podrá cerrar
como `READY FOR DEV LINK` y preparar un paquete posterior para ejecutar link
controlado.

## Decisión 2B-AG1 — backend remoto development/staging y estrategia de despliegue

### Estado

2B-AG queda aprobado y cerrado formalmente. Backend remoto seguro queda
planificado, no implementado. No se ha conectado Supabase real, auth real,
development remoto, staging remoto, production ni datos reales.

AG1 toma la decisión documental sobre secuencia de entornos remotos y estrategia
de despliegue futura. No ejecuta comandos remotos ni prepara credenciales.

### Secuencia de entornos remotos decidida

Se comparan tres opciones:

- Opcion A: development remoto primero con datos sinteticos; staging despues de
  development validado; production bloqueado.
- Opcion B: staging directamente.
- Opcion C: continuar solo local-safe y retrasar remoto.

Decision:

```text
Opcion A — development remoto primero.
```

Justificacion:

- reduce blast radius;
- permite validar migraciones, RLS, RPC, Edge Functions y logs con datos
  sinteticos;
- evita tratar staging como entorno experimental;
- mantiene production bloqueado;
- conserva rollback y evidence pack antes de promover.

Staging queda posterior a un evidence pack de development validado y aprobacion
explicita.

### Estrategia de Supabase projects

Decision objetivo:

- Supabase development separado;
- Supabase staging separado;
- Supabase production futuro separado.

Reglas:

- no mezclar claves;
- no usar production keys en development;
- no usar production keys en staging;
- secrets fuera del repo;
- anon key como configuracion publica controlada;
- `service_role` nunca en Flutter;
- Edge Function secrets fuera del repo;
- logs sin tokens.

### Estrategia de despliegue futura

Fases futuras decididas:

1. Fase 0: evidence pack local actual.
2. Fase 1: preparar proyecto development remoto.
3. Fase 2: aplicar migraciones en development remoto con aprobacion.
4. Fase 3: desplegar Edge Functions en development remoto con aprobacion.
5. Fase 4: pruebas sinteticas development.
6. Fase 5: promocion a staging con aprobacion.
7. Fase 6: production bloqueado.

No se ejecuta ninguna fase en AG1.

### Comandos permitidos y prohibidos

Prohibidos en AG1:

- `supabase link`;
- `supabase db push`;
- `supabase migration up` remoto;
- `supabase functions deploy`;
- `supabase secrets set` remoto;
- deploy staging;
- deploy production.

En paquetes futuros solo podran ejecutarse si existe:

- aprobacion explicita;
- entorno objetivo claro;
- proyecto Supabase no productivo;
- secrets fuera del repo;
- rollback definido;
- evidence pack previo.

### Evidence pack antes de remoto

Antes de tocar remoto debe existir como minimo:

- `git status` limpio o cambios identificados;
- migraciones auditadas;
- RLS auditada;
- RPC auditada;
- Edge Functions auditadas;
- tests SQL/local pasados;
- tests HTTP/local pasados;
- tests Flutter pasados;
- tests arquitectura pasados;
- tests no-secrets pasados;
- checklist de variables/secrets;
- checklist de rollback.

### Estrategia de migraciones development

Proceso futuro:

1. crear proyecto development;
2. vincular solo con aprobacion;
3. aplicar migraciones controladamente;
4. verificar tablas;
5. verificar grants;
6. verificar RLS;
7. verificar RPC;
8. cargar seed sintetico si se aprueba;
9. confirmar ausencia de datos reales;
10. documentar rollback.

No se ejecuta en AG1.

### Estrategia Edge Functions development

Proceso futuro:

- desplegar funciones solo en development;
- validar JWT real;
- validar payload;
- rechazar `userId`/`ownerUserId` desde UI;
- rechazar `role` desde UI;
- errores explicitos y opacos cuando corresponda;
- sin fallback demo;
- logs minimizados;
- rollback de funcion.

Funciones relevantes:

- `create-own-chat-session`;
- `list-own-chat-sessions`;
- `archive-own-chat-session`;
- `send-user-message`;
- `list-session-messages`.

### Criterios para pasar a staging

Staging solo podra abrirse si:

- development remoto esta validado;
- solo se usaron datos sinteticos;
- tests de integracion remota pasaron;
- RLS ownership fue validada;
- Edge Functions fueron validadas;
- logs fueron auditados;
- no hay leaks de tokens;
- rollback esta probado o documentado;
- existe aprobacion explicita.

### Production bloqueado

Decision firme:

- production no se toca;
- production no se vincula;
- production no recibe migraciones;
- production no recibe Edge Functions;
- production no recibe datos reales;
- production requiere ADR y gates separados.

### Riesgos clasificados

Bloqueantes:

- link al proyecto equivocado;
- `db push` contra production;
- `functions deploy` contra production;
- production keys en development;
- production keys en staging;
- `service_role` en cliente;
- secrets en repo;
- datos reales en development/staging.

Altos:

- RLS incompleta;
- Edge Function acepta `userId` desde UI;
- logs con tokens;
- fallback demo desde error real;
- `SupabaseChatDataSource` reactivado;
- writes directos desde Flutter;
- staging tratado como development experimental.

Medios:

- evidence pack incompleto;
- rollback no probado;
- seeds sinteticos persistentes sin cleanup;
- `backendReal` legacy confundido con modo objetivo;
- errores remotos filtrando existencia de recursos ajenos.

Bajos:

- nombres de entorno ambiguos;
- documentacion duplicada;
- copy de errores poco claro.

### Recomendacion final

Cerrar AG1 como decision. No conectar remoto todavia. Preparar primero un
evidence pack de backend remoto development antes de cualquier `link`, push o
deploy.

### Siguiente paquete propuesto

Siguiente recomendado:

```text
2B-AG2 — evidence pack backend remoto development
```

Alternativas:

- `2B-AG2 — plan conexion development remoto con datos sinteticos`;
- `2B-AF7 — plan conexion development Supabase sintetica`;
- `2B-AE4 — plan /conversations backendBlocked visual`.

No implementar todavia.

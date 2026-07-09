# ADR-008 — Ruta producto /conversations

## Estado

Aprobada conceptualmente / Pendiente de implementacion.

Esta ADR prepara la decision normativa para una futura ruta producto
`/conversations`. No autoriza implementacion inmediata, registro de ruta,
conexion de producto, uso de datos reales, staging, production, cleanup ni
cambios en Supabase.

## Contexto

La fase 2B dev-only ha dejado un frente tecnico validado para sesiones y
mensajes con estas propiedades:

- backend remoto development E2E completado con datos sinteticos;
- Flutter dev-only read/write completado;
- UX dev-only remota validada;
- hardening dev-only completado;
- baseline 2B publicado en Git;
- producto cerrado;
- `/conversations` no registrado;
- fixture sintetico development retenido;
- staging y production no autorizados;
- datos reales no usados.

La ruta producto `/conversations` seria la primera entrada de usuario final
para conversaciones propias. Por tanto, no puede tratarse como simple traslado
de la dev-shell existente. Debe existir una frontera normativa clara antes de
implementar routing, UI productiva, auth real, datos reales o promocion a
staging.

## Decision

La ruta `/conversations` podra abrirse solo como ruta producto futura,
separada de la dev-shell, despues de cumplir criterios de autenticacion de
producto, politica de datos reales, staging, rollback, observabilidad,
ownership backend/RLS y decision explicita sobre retention o cleanup del
fixture sintetico development.

Esta ADR no registra `/conversations`, no conecta producto y no habilita datos
reales. La implementacion debe aprobarse en un paquete posterior.

## Alcance autorizado

Queda autorizado exclusivamente:

- documentar el contrato normativo de `/conversations`;
- definir los criterios minimos previos a implementacion;
- definir no-alcances y bloqueos;
- decidir que la dev-shell no es producto;
- mantener el fixture sintetico retenido durante la ADR;
- diferir cleanup, staging y producto a decisiones posteriores.

## Alcance explicitamente no autorizado

Esta ADR no autoriza:

- registrar `/conversations`;
- modificar rutas Flutter;
- conectar UI productiva;
- usar `/chat/:id` como `sessionId`;
- usar `/orchestrator/chat`;
- reactivar el chat heredado como ruta de producto;
- usar `SupabaseChatDataSource` heredado;
- usar `service_role` en cliente;
- acceder a tablas directamente desde Flutter para operaciones sensibles;
- depender de `SYNTHETIC_ACCESS_TOKEN`;
- usar fixture development como dato de producto;
- hacer cleanup del fixture;
- activar staging o production;
- usar datos reales;
- ejecutar SQL, migraciones, deploys o `secrets set`.

## Diferencia dev-shell vs producto

La dev-shell existe para validar comportamiento tecnico de forma visible,
controlada y reversible. Sus rutas y hosts dev-only pueden usar datos
sinteticos retenidos y controles especiales de development.

`/conversations` debe ser producto. Por tanto:

- no debe depender de rutas `/dev/chat/composed` ni
  `/dev/chat/session/:sessionId`;
- no debe mostrarse como demo ni caer a demo ante errores reales;
- no debe leer tokens sinteticos de development;
- no debe exponer controles internos de testing;
- no debe asumir que un fixture es contenido real de usuario;
- no debe quedar disponible en release hasta completar gates de producto.

## Autenticacion y autorizacion producto

La ruta producto requiere una sesion autenticada real y segura. Antes de
implementarla debe existir decision aprobada sobre:

- fuente de verdad de identidad;
- provider real de sesion;
- refresh y expiracion de token;
- estado `unauthenticated`, `expired`, `backendBlocked` y `misconfigured`;
- tratamiento visible de errores de auth;
- ausencia de fallback demo ante error real;
- no uso de `userMetadata` como autoridad;
- no envio de `userId`, `ownerUserId`, `role` o permisos desde UI.

La autorizacion efectiva debe validarse en backend/RLS. Flutter no decide
ownership ni privilegios.

## Politica de datos reales

`/conversations` no puede usar datos reales hasta que exista una politica
explicita que cubra:

- finalidad del dato;
- minimizacion;
- consentimiento o base de uso;
- borrado y retencion;
- auditoria;
- logs seguros;
- separacion de datos sinteticos y reales;
- prohibicion de datos de salud/wellness reales sin autorizacion adicional;
- criterios de QA para evitar mezclar fixture, demo y producto.

## Staging antes de production

Staging debe definirse antes de production. No se puede saltar de development a
production.

Antes de activar `/conversations` fuera de development debe existir:

- entorno staging separado;
- secrets staging separados;
- auth staging separada;
- datos staging no reales o expresamente autorizados;
- plan de promocion;
- checklist de rollback;
- evidencia de que production permanece intacto.

## Fixture sintetico development

Decision de esta ADR: retener el fixture durante la preparacion de la ADR y
decidir cleanup/retention en un paquete posterior antes de activar producto
real.

El fixture:

- pertenece solo a development;
- no es producto;
- no debe aparecer como dato real;
- no debe usarse en staging;
- no debe usarse en production;
- debe quedar claramente etiquetado como sintetico;
- debe tener plan de cleanup con conteos previos/posteriores si se elimina.

## Contrato frontend/backend

Contrato producto minimo esperado para `/conversations`:

- listar conversaciones propias;
- abrir detalle de conversacion por `sessionId` propio;
- enviar mensaje mediante backend seguro;
- archivar o restaurar solo si se autoriza explicitamente;
- mostrar errores auth/backend visibles;
- no fallback demo;
- no exponer IDs internos;
- no enviar `userId`, `ownerUserId`, `specialistId` interno ni `role` desde UI;
- usar `selectableSpecialistId` como contrato publico cuando una operacion de
  producto requiera seleccionar especialista;
- validar ownership en backend;
- mapear errores sin filtrar existencia de sesiones ajenas;
- tratar contadores y timestamps server-managed como server-managed.

## Routing Flutter

La futura ruta producto debe definirse por separado. Reglas:

- `/conversations` no queda registrada por esta ADR;
- la implementacion requiere paquete posterior;
- no usar `/chat/:id` como `sessionId`, porque `:id` es `agentId` heredado;
- no conectar `/orchestrator/chat`;
- no reutilizar chat heredado para enviar `role` desde Flutter;
- no conectar `SupabaseChatDataSource`;
- no abrir ruta en release sin guards, tests y aprobacion.

## Rutas heredadas bloqueadas

Permanecen bloqueadas para el flujo seguro:

- `/chat/:id` como entrada a mensajes propios;
- `/orchestrator/chat`;
- rutas dev-only como producto;
- cualquier ruta que acepte `agentId` o `id` ambiguo como `sessionId`;
- cualquier ruta que use chat heredado para crear/enviar mensajes reales.

## Seguridad y RLS

Antes de implementar `/conversations` debe auditarse:

- RLS y ownership real de `public.users`, `chat_sessions` y `messages`;
- grants cliente;
- ausencia de policies permisivas no revisadas;
- Edge Functions como frontera operativa;
- RPCs autorizadas y grants de RPC;
- ausencia de `service_role` en Flutter;
- ausencia de writes directos desde Flutter a tablas sensibles;
- logs sin tokens, contenido sensible o IDs internos innecesarios;
- errores opacos para sesiones ajenas.

## Observabilidad minima

La ruta producto necesita observabilidad minima antes de salir de development:

- errores de auth;
- errores backend;
- latencia de llamadas;
- fallos de ownership;
- fallos de contrato;
- conteo de operaciones sensibles sin registrar contenido sensible;
- correlacion tecnica sin exponer tokens ni IDs internos al cliente.

## Rollback

Rollback minimo esperado para implementacion futura:

- feature flag o gate para desactivar `/conversations`;
- revert de ruta Flutter;
- mantener dev-shell separada;
- no tocar datos reales como rollback primario;
- si hubo cambios backend, rollback con migraciones o scripts aprobados;
- si hubo deploy de funciones, plan de redeploy anterior;
- documentar postcondiciones.

## Criterios minimos antes de implementacion

Antes de implementar `/conversations` debe cumplirse:

1. ADR-008 aprobada.
2. Auth producto definida.
3. Staging definido antes de production.
4. Politica de datos reales definida.
5. Fixture retention/cleanup decidido.
6. Rutas heredadas bloqueadas por tests.
7. Tests de route guards producto definidos.
8. Rollback definido.
9. Observabilidad minima definida.
10. RLS/backend ownership auditado.
11. Sin dependencia de dev-only flags.
12. Sin dependencia de token sintetico.
13. Sin fallback demo.
14. Sin `SupabaseChatDataSource` heredado.
15. Sin `/chat/:id` como `sessionId`.
16. Sin `/orchestrator/chat`.
17. Sin `service_role` cliente.
18. Sin Flutter directo a tablas sensibles.

## Politica fixture posterior a ADR

Decision recomendada tras publicar ADR-008: preparar un cleanup parcial
controlado de conversaciones sinteticas de development antes de implementar
`/conversations`.

La politica propuesta es:

- retener `public.users` sintetico;
- retener `public.specialists` sintetico si existe;
- retener `public.specialist_catalog` sintetico;
- eliminar solo `public.messages` sinteticos asociados a sesiones fixture;
- eliminar solo `public.chat_sessions` sinteticas fixture;
- no tocar `auth.users`;
- no tocar catalogo salvo decision posterior;
- no tocar datos reales;
- no ejecutar cleanup sin SQL exacto, conteos previos/posteriores y revision
  manual.

Razonamiento:

- las sesiones y mensajes sinteticos ya cumplieron su funcion E2E/UX;
- conservar conversaciones sinteticas aumenta el riesgo de confundirlas con
  conversaciones producto;
- el usuario y catalogo sintetico siguen siendo utiles para pruebas futuras
  development sin recrear todo el fixture.

Criterios para un paquete posterior de cleanup parcial:

1. preparar conteos read-only previos;
2. identificar sesiones sinteticas por owner sintetico y/o metadata segura;
3. identificar mensajes asociados exclusivamente a esas sesiones;
4. preparar SQL modificador en borrador, sin ejecutarlo hasta autorizacion
   separada;
5. definir conteos post-cleanup esperados;
6. bloquear cleanup si la identificacion no es segura;
7. no tocar `auth.users`, `public.users`, `public.specialists` ni
   `public.specialist_catalog`;
8. documentar rollback conceptual antes de borrar.

SQL conceptual: no se incluye SQL ejecutable en esta ADR. Cualquier SQL de
cleanup debe prepararse y aprobarse en un paquete separado, marcado
explicitamente como no ejecutable hasta autorizacion.

Rollback conceptual: una vez borradas sesiones/mensajes, el rollback ordinario
consiste en recrear fixture o restaurar backup. Por tanto, si hay duda sobre
identificacion, debe bloquearse el cleanup.

## Plan 2B-AG77 — cleanup parcial fixture sesiones/mensajes

Estado: `FIXTURE CLEANUP PLAN READY`, pendiente de autorizacion separada para
ejecutar cualquier SQL modificador.

AG77 no ejecuta cleanup, no borra datos, no toca remoto, no registra
`/conversations`, no modifica producto y no consulta ni modifica `auth.users`.
Solo deja preparado el plan de identificacion, conteos, borrador de cleanup y
rollback conceptual.

### Cierre AG76

AG76 queda cerrado como `FIXTURE CLEANUP DECISION READY`.

Decision vigente:

- limpiar de forma parcial solo conversaciones sinteticas de development;
- eliminar exclusivamente `public.messages` asociados a sesiones fixture;
- eliminar exclusivamente `public.chat_sessions` fixture;
- retener `public.users` sintetico;
- retener `public.specialists` sintetico si existe;
- retener `public.specialist_catalog` sintetico;
- no tocar `auth.users`;
- no ejecutar cleanup sin autorizacion posterior explicita.

### Identificacion segura del fixture

El esquema actual verificado por migraciones no contiene columnas `metadata` en
`public.chat_sessions` ni `public.messages`. Por tanto, AG77 no permite
identificar el fixture por metadata inexistente, fechas genericas, contenido
generico ni nombres ambiguos.

La identificacion segura debe seguir este orden:

1. Verificar que existe exactamente un `public.users` sintetico con
   `display_name = 'Synthetic Development User'`.
2. Verificar que existe exactamente un catalogo sintetico
   `public.specialist_catalog.display_name = 'Synthetic Development Specialist'`
   si se usa como corroboracion secundaria.
3. Seleccionar solo `public.chat_sessions` cuyo `user_id` coincide con el
   `public.users.id` sintetico verificado.
4. Seleccionar solo `public.messages` cuyo `session_id` pertenece a esas
   sesiones verificadas.
5. Bloquear si aparece mas de un usuario sintetico, cero usuarios sinteticos,
   sesiones sin owner inequivoco, mensajes fuera de las sesiones objetivo,
   conteos distintos no explicados o cualquier indicio de dato real.

No se debe consultar `auth.users` en este paquete. El email sintetico de Auth
es contexto historico, no criterio de borrado en AG77.

### SQL read-only — conteos previos

`READ-ONLY — SE PUEDE EJECUTAR EN AG77 SI NO EXPONE SECRETOS`.

Estas consultas no imprimen cuerpos de mensajes, tokens, emails reales,
connection strings ni secretos. Solo devuelven conteos.

```sql
-- READ-ONLY: conteos globales de tablas relevantes.
select 'public.users' as table_name, count(*)::bigint as row_count
from public.users
union all
select 'public.specialists', count(*)::bigint
from public.specialists
union all
select 'public.specialist_catalog', count(*)::bigint
from public.specialist_catalog
union all
select 'public.chat_sessions', count(*)::bigint
from public.chat_sessions
union all
select 'public.messages', count(*)::bigint
from public.messages;

-- READ-ONLY: conteo del usuario sintetico publico.
select count(*)::bigint as synthetic_public_users
from public.users
where display_name = 'Synthetic Development User';

-- READ-ONLY: conteo del catalogo sintetico.
select count(*)::bigint as synthetic_catalog_rows
from public.specialist_catalog
where display_name = 'Synthetic Development Specialist';

-- READ-ONLY: sesiones y mensajes asociados al usuario sintetico publico.
with synthetic_user as (
  select id
  from public.users
  where display_name = 'Synthetic Development User'
),
target_sessions as (
  select cs.id
  from public.chat_sessions cs
  join synthetic_user su on su.id = cs.user_id
)
select 'synthetic_chat_sessions' as metric, count(*)::bigint as value
from target_sessions
union all
select 'synthetic_messages', count(*)::bigint
from public.messages m
join target_sessions ts on ts.id = m.session_id;
```

### SQL read-only — seleccion previa

`READ-ONLY — SE PUEDE EJECUTAR EN AG77 SI NO EXPONE SECRETOS`.

La seleccion previa muestra identificadores truncados. No muestra contenido
completo de mensajes.

```sql
-- READ-ONLY: candidato de usuario sintetico publico.
select
  left(id::text, 8) || '...' as user_id_short,
  display_name,
  role,
  created_at,
  updated_at
from public.users
where display_name = 'Synthetic Development User'
order by created_at, id;

-- READ-ONLY: candidato de catalogo sintetico.
select
  left(id::text, 8) || '...' as catalog_id_short,
  left(specialist_id::text, 8) || '...' as specialist_id_short,
  display_name,
  product_area,
  availability_status,
  access_tier,
  is_published,
  created_at,
  updated_at
from public.specialist_catalog
where display_name = 'Synthetic Development Specialist'
order by created_at, id;

-- READ-ONLY: sesiones candidatas, sin exponer ids completos.
with synthetic_user as (
  select id
  from public.users
  where display_name = 'Synthetic Development User'
),
target_sessions as (
  select cs.*
  from public.chat_sessions cs
  join synthetic_user su on su.id = cs.user_id
)
select
  left(id::text, 8) || '...' as session_id_short,
  left(user_id::text, 8) || '...' as user_id_short,
  left(specialist_id::text, 8) || '...' as specialist_id_short,
  started_at,
  last_message_at,
  status,
  message_count
from target_sessions
order by started_at, id;

-- READ-ONLY: mensajes candidatos, sin content completo.
with synthetic_user as (
  select id
  from public.users
  where display_name = 'Synthetic Development User'
),
target_sessions as (
  select cs.id
  from public.chat_sessions cs
  join synthetic_user su on su.id = cs.user_id
)
select
  left(m.id::text, 8) || '...' as message_id_short,
  left(m.session_id::text, 8) || '...' as session_id_short,
  m.role,
  char_length(m.content) as content_length,
  m.created_at
from public.messages m
join target_sessions ts on ts.id = m.session_id
order by m.created_at, m.id;
```

### SQL cleanup borrador

`BORRADOR — NO EJECUTAR EN AG77`.

Este borrador requiere autorizacion posterior explicita y debe reemplazar
`<SYNTHETIC_PUBLIC_USER_ID_VERIFICADO>` por el UUID completo verificado por la
seleccion previa segura. No debe obtenerse desde `auth.users` en este paquete.

```sql
-- BORRADOR — NO EJECUTAR EN AG77.
-- Requiere autorizacion explicita posterior.
-- Precondiciones obligatorias:
-- 1. public.users sintetico verificado exactamente 1.
-- 2. target_sessions esperado: 2.
-- 3. target_messages esperado: 2.
-- 4. Sin indicios de datos reales.

begin;

with target_user as (
  select '<SYNTHETIC_PUBLIC_USER_ID_VERIFICADO>'::uuid as id
),
target_sessions as (
  select cs.id
  from public.chat_sessions cs
  join target_user tu on tu.id = cs.user_id
),
deleted_messages as (
  delete from public.messages m
  using target_sessions ts
  where m.session_id = ts.id
  returning m.id
),
deleted_sessions as (
  delete from public.chat_sessions cs
  using target_sessions ts
  where cs.id = ts.id
  returning cs.id
)
select
  (select count(*) from deleted_sessions) as deleted_chat_sessions,
  (select count(*) from deleted_messages) as deleted_messages;

-- Verificacion post-cleanup dentro de la misma transaccion.
with target_user as (
  select '<SYNTHETIC_PUBLIC_USER_ID_VERIFICADO>'::uuid as id
)
select
  (select count(*) from public.chat_sessions cs
   join target_user tu on tu.id = cs.user_id) as remaining_chat_sessions,
  (select count(*) from public.messages m
   join public.chat_sessions cs on cs.id = m.session_id
   join target_user tu on tu.id = cs.user_id) as remaining_messages,
  (select count(*) from public.users u
   join target_user tu on tu.id = u.id) as retained_public_users;

-- Sustituir por COMMIT solo en paquete posterior autorizado.
rollback;
```

El cleanup real debe borrar mensajes primero y sesiones despues. No debe
depender de cascadas como mecanismo principal, aunque las FK existan.

### Conteos esperados post-cleanup

Si el estado historico sigue igual, el resultado esperado del paquete posterior
autorizado es:

```text
chat_sessions sinteticas: 0
messages sinteticos asociados: 0
public.users sintetico: 1 retenido
public.specialists sintetico: 1 retenido si existe
public.specialist_catalog sintetico: 1 retenido
auth.users: no tocado
```

Si los conteos reales difieren, debe documentarse la diferencia y bloquear la
ejecucion hasta revision.

### Rollback conceptual

Antes del cleanup real debe capturarse seleccion exacta y conteos. Si se borran
sesiones/mensajes, el rollback ordinario requiere recrear fixture o restaurar
backup. No hay rollback automatico si no existe backup. No tocar `auth.users`
reduce el riesgo, pero no elimina la necesidad de revisar la seleccion previa.

Si la identificacion no es segura, el cleanup no debe ejecutarse.

### Criterios de stop

AG77 y cualquier paquete posterior deben detenerse si:

- se intenta ejecutar `DELETE`, `UPDATE` o `INSERT` sin autorizacion explicita;
- se intenta borrar datos fuera de `public.messages` y `public.chat_sessions`;
- se intenta tocar `auth.users`;
- se intenta tocar `public.users`, `public.specialists` o
  `public.specialist_catalog`;
- la identificacion del fixture no es inequivoca;
- los conteos no coinciden con lo esperado y no se explica;
- aparecen posibles datos reales;
- se intenta registrar `/conversations`;
- se intenta conectar producto;
- se toca staging o production;
- se imprime un secreto;
- se propone SQL destructivo sin seleccion previa segura.

## Verificacion 2B-AG78 — fixture read-only antes de cleanup

Estado: `FIXTURE CLEANUP READONLY VERIFIED`.

AG78 ejecuta solo lecturas `GET` contra `public.*`, equivalentes a SELECT via
PostgREST, con salida saneada. No ejecuta `DELETE`, `UPDATE`, `INSERT`,
`UPSERT`, `TRUNCATE`, `ALTER`, `DROP` ni `CREATE`. No consulta ni toca
`auth.users`. No registra `/conversations`, no conecta producto, no ejecuta
deploys, migraciones ni push.

Los headers locales necesarios para lectura remota no se imprimen ni se
registran. La verificacion no introduce `service_role` en Flutter ni en codigo
de cliente.

### Conteos read-only verificados

```text
public.users: 1
public.specialists: 1
public.specialist_catalog: 1
public.chat_sessions: 2
public.messages: 2
```

### Usuario sintetico publico

Resultado:

```text
synthetic_public_users_count: 1
user_id_short: 2e3838b4...
display_name: Synthetic Development User
role: user
created_at: 2026-07-04T18:01:38.97987
updated_at: 2026-07-04T18:01:38.97987
```

Dictamen: existe exactamente un usuario publico sintetico. No se consulto
`auth.users`.

### Especialista y catalogo retenidos

Resultado:

```text
synthetic_specialists_count: 1
specialist_id_short: 7336d3ba...
name: Synthetic Development Specialist
category: orquestador
created_at: 2026-07-03T21:11:14.571864

synthetic_catalog_count: 1
catalog_id_short: 05d30351...
specialist_id_short: 7336d3ba...
display_name: Synthetic Development Specialist
product_area: stasis
availability_status: available
access_tier: free
is_published: true
created_at: 2026-07-03T21:11:14.571864+00:00
updated_at: 2026-07-03T21:11:14.571864+00:00
```

Dictamen: especialista y catalogo sinteticos quedan retenidos. No son
candidatos a cleanup en AG79.

### Sesiones candidatas

Resultado:

```text
candidate_chat_sessions_count: 2

session 1:
  session_id_short: eed866d6...
  user_id_short: 2e3838b4...
  specialist_id_short: 7336d3ba...
  started_at: 2026-07-04T18:13:29.165959
  last_message_at: 2026-07-04T19:08:30.751849
  status: archived
  message_count: 1
  associated_messages_count: 1

session 2:
  session_id_short: ccd9ea79...
  user_id_short: 2e3838b4...
  specialist_id_short: 7336d3ba...
  started_at: 2026-07-05T09:49:04.266259
  last_message_at: 2026-07-05T09:49:04.596707
  status: archived
  message_count: 1
  associated_messages_count: 1
```

Todas las sesiones candidatas pertenecen al unico `public.users` sintetico
verificado.

### Mensajes candidatos

Resultado:

```text
candidate_messages_count: 2

message 1:
  message_id_short: 4f2059fc...
  session_id_short: eed866d6...
  role: user
  content_length: 34
  created_at: 2026-07-04T19:08:30.751849

message 2:
  message_id_short: db04c026...
  session_id_short: ccd9ea79...
  role: user
  content_length: 34
  created_at: 2026-07-05T09:49:04.596707
```

No se muestran cuerpos completos de mensajes. Todos los mensajes candidatos
pertenecen a las sesiones candidatas.

### Seleccion inequivoca

```text
Seleccion inequivoca: SI
Motivo: existe exactamente un public.users sintetico; las 2 sesiones pertenecen
al mismo user_id sintetico; los 2 mensajes pertenecen a esas sesiones; no se
identifican datos reales; no se consulto auth.users; no hay ambiguedad con
otros usuarios.
Riesgo: bajo-medio, limitado al uso de una seleccion por fixture sintetico
documentado; AG79 debe capturar conteos inmediatamente antes del cleanup real.
```

### SQL cleanup final para AG79

`BORRADOR — NO EJECUTAR EN AG78`.

`REQUIERE AUTORIZACION EXPLICITA EN AG79`.

El borrador evita documentar UUID completo y vuelve a validar que existe un
solo usuario sintetico antes de borrar. Si el conteo deja de ser exactamente
uno, no debe ejecutarse.

```sql
-- BORRADOR — NO EJECUTAR EN AG78.
-- REQUIERE AUTORIZACION EXPLICITA EN AG79.
-- Capturar conteos y seleccion inmediatamente antes de ejecutar.

begin;

with synthetic_user as (
  select id
  from public.users
  where display_name = 'Synthetic Development User'
),
guard as (
  select count(*)::int as synthetic_user_count
  from synthetic_user
),
target_sessions as (
  select cs.id
  from public.chat_sessions cs
  join synthetic_user su on su.id = cs.user_id
  where (select synthetic_user_count from guard) = 1
),
deleted_messages as (
  delete from public.messages m
  using target_sessions ts
  where m.session_id = ts.id
  returning m.id
),
deleted_sessions as (
  delete from public.chat_sessions cs
  using target_sessions ts
  where cs.id = ts.id
  returning cs.id
)
select
  (select synthetic_user_count from guard) as synthetic_user_count,
  (select count(*) from deleted_sessions) as deleted_chat_sessions,
  (select count(*) from deleted_messages) as deleted_messages;

-- Verificacion post-cleanup dentro de la misma transaccion.
with synthetic_user as (
  select id
  from public.users
  where display_name = 'Synthetic Development User'
),
target_sessions as (
  select cs.id
  from public.chat_sessions cs
  join synthetic_user su on su.id = cs.user_id
)
select
  (select count(*) from target_sessions) as remaining_chat_sessions,
  (select count(*) from public.messages m
   join target_sessions ts on ts.id = m.session_id) as remaining_messages,
  (select count(*) from synthetic_user) as retained_public_users;

-- Sustituir por COMMIT solo en AG79 si los conteos son los esperados.
rollback;
```

El cleanup real debe mantener el orden logico: borrar `public.messages`
asociados primero y despues `public.chat_sessions` candidatas. Debe retener
`auth.users`, `public.users`, `public.specialists` y
`public.specialist_catalog`.

### Conteos esperados post-cleanup AG79

```text
public.messages candidatos post-cleanup: 0
public.chat_sessions candidatas post-cleanup: 0
public.users sintetico: 1 retenido
public.specialists sintetico: 1 retenido
public.specialist_catalog sintetico: 1 retenido
auth.users: no tocado
```

### Rollback conceptual AG78

Antes de cleanup real en AG79 debe capturarse seleccion exacta y conteos. Si se
borra, rollback ordinario requiere recrear fixture o restaurar backup. No hay
rollback automatico garantizado sin backup. No tocar `auth.users` reduce
riesgo. Si la seleccion deja de ser inequivoca, no ejecutar cleanup.

## Cleanup 2B-AG79 — fixture sesiones/mensajes

Estado: `FIXTURE CLEANUP COMPLETED`.

AG79 ejecuta el cleanup parcial real autorizado exclusivamente sobre
`public.messages` y `public.chat_sessions` sinteticos. No modifica
`auth.users`, `public.users`, `public.specialists` ni
`public.specialist_catalog`. No registra `/conversations`, no conecta producto,
no ejecuta deploys, migraciones ni push.

### Recaptura read-only previa

La recaptura inmediata previa al cleanup confirma:

```text
synthetic_public_users_count: 1
synthetic_public_user_id_short: 2e3838b4...
display_name: Synthetic Development User
role: user

synthetic_specialists_count: 1
specialist_id_short: 7336d3ba...
name: Synthetic Development Specialist

synthetic_catalog_count: 1
catalog_id_short: 05d30351...
display_name: Synthetic Development Specialist

candidate_chat_sessions_count: 2
candidate_messages_count: 2
auth.users: no consultado
```

Seleccion previa:

```text
session 1:
  session_id_short: eed866d6...
  user_id_short: 2e3838b4...
  specialist_id_short: 7336d3ba...
  started_at: 2026-07-04T18:13:29.165959
  last_message_at: 2026-07-04T19:08:30.751849
  status: archived
  message_count: 1
  associated_messages_count: 1

session 2:
  session_id_short: ccd9ea79...
  user_id_short: 2e3838b4...
  specialist_id_short: 7336d3ba...
  started_at: 2026-07-05T09:49:04.266259
  last_message_at: 2026-07-05T09:49:04.596707
  status: archived
  message_count: 1
  associated_messages_count: 1

message 1:
  message_id_short: 4f2059fc...
  session_id_short: eed866d6...
  role: user
  content_length: 34
  created_at: 2026-07-04T19:08:30.751849

message 2:
  message_id_short: db04c026...
  session_id_short: ccd9ea79...
  role: user
  content_length: 34
  created_at: 2026-07-05T09:49:04.596707
```

No se imprimen cuerpos completos de mensajes ni secretos.

### Cleanup ejecutado

Orden ejecutado:

1. `DELETE` de `public.messages` asociados a las sesiones candidatas.
2. `DELETE` de `public.chat_sessions` candidatas.

Resultado:

```text
deleted_messages_count: 2
deleted_chat_sessions_count: 2
```

Se borraron:

```text
messages:
  4f2059fc... asociado a session eed866d6...
  db04c026... asociado a session ccd9ea79...

chat_sessions:
  eed866d6... owned por user 2e3838b4...
  ccd9ea79... owned por user 2e3838b4...
```

### Validacion post-cleanup

Resultado post-cleanup:

```text
candidate_chat_sessions_count: 0
candidate_messages_count: 0
synthetic_public_users_count: 1
synthetic_specialists_count: 1
synthetic_catalog_count: 1
auth.users: no consultado/no tocado
```

El fixture de usuario, especialista y catalogo queda retenido para futuros
paquetes si se decide recrear sesiones/mensajes sinteticos. Las conversaciones
sinteticas retenidas quedan eliminadas antes de cualquier implementacion
producto de `/conversations`.

### Rollback posterior al cleanup

No se ejecuta rollback. El rollback ordinario tras AG79 requiere recrear el
fixture de sesiones/mensajes o restaurar backup. No hay rollback automatico
garantizado sin backup. No tocar `auth.users` redujo el riesgo. Si se necesita
fixture de sesiones/mensajes de nuevo, debe recrearse explicitamente en un
paquete posterior.

## Decision 2B-AG82 — siguiente frontera tras cleanup fixture

Estado: `CONVERSATIONS IMPLEMENTATION PLAN DECISION READY`.

AG82 no implementa codigo, no registra `/conversations`, no toca Supabase, no
ejecuta SQL, no recrea fixture, no activa staging/production y no usa datos
reales. Su objetivo es decidir la siguiente frontera tras cerrar y publicar:

- baseline dev-only;
- ADR-008 `/conversations`;
- cleanup parcial de sesiones/mensajes sinteticos;
- documentacion del cleanup.

### Opciones evaluadas

#### Opcion A — preparar implementacion futura de `/conversations`

Recomendada como siguiente frontera, pero solo como plan tecnico. La razon es
que ADR-008 ya fija la frontera normativa, el fixture de conversaciones
sinteticas fue eliminado y el siguiente riesgo es abrir producto sin paquete de
implementacion descompuesto.

El siguiente paquete debe preparar alcance exacto, rutas, archivos, providers,
contratos backend, gates de entorno, pruebas, rollback y criterios de stop
antes de escribir codigo.

#### Opcion B — estrategia staging

Staging sigue no autorizado. Requiere secrets separados, auth separada,
politica de datos, plan de promocion, rollback y separacion de development.

Decision: diferir staging hasta que exista plan de implementacion producto o un
paquete especifico de staging. Staging sera obligatorio antes de production,
pero no bloquea preparar el plan tecnico de `/conversations`.

#### Opcion C — recrear fixture controlado

Recrear fixture puede ser util para pruebas dev-only futuras, pero ahora
reintroduciria conversaciones sinteticas justo despues de limpiarlas.

Decision: no recomendado ahora. Solo debe hacerse si una prueba concreta lo
exige y con paquete separado, datos claramente sinteticos y rollback definido.

#### Opcion D — hardening adicional

El hardening dev-only ya quedo cerrado. Si aparecen gaps, deben integrarse como
tests obligatorios del paquete `/conversations`.

Decision: no abrir como frente separado salvo hallazgo concreto.

#### Opcion E — otro frente tecnico

No se detecta una frontera mas prudente que preparar el plan de implementacion
de `/conversations`. Cualquier alternativa debe justificar por que reduce mas
riesgo que el plan producto.

### Recomendacion final

```text
Recomendacion: A — preparar implementacion futura de /conversations bajo ADR-008,
sin codigo todavia.
Motivo: baseline dev-only, ADR-008 y cleanup fixture ya estan cerrados; antes de
codigo hace falta un paquete tecnico exacto que evite mezclar dev-shell,
fixture, auth incompleta, rutas heredadas o datos reales.
Riesgo: abrir producto sin descomponer rutas, gates, auth, errores, rollback y
tests.
Siguiente paquete: 2B-AG83 — preparar plan de implementacion /conversations
producto.
```

### Criterios para 2B-AG83

AG83 debe ser plan tecnico, no implementacion. Debe definir como minimo:

- alcance exacto de `/conversations`;
- rutas permitidas y rutas bloqueadas;
- archivos Flutter permitidos y prohibidos;
- providers, controllers, repositories y datasources permitidos;
- contratos backend permitidos;
- estado de auth requerido;
- flags y gates de entorno;
- UI minima y estados de error;
- no fallback demo;
- no token sintetico;
- no fixture como producto;
- no `service_role` cliente;
- no Flutter directo a tablas;
- no `userId` ni `ownerUserId` desde UI;
- tests obligatorios de rutas, guards, arquitectura, errores y ausencia de
  rutas heredadas;
- rollback;
- criterios de stop;
- orden de implementacion;
- criterios de aprobacion para pasar a codigo.

### Rollback AG82

AG82 no tiene rollback tecnico si solo decide. Si se modifica documentacion,
rollback documental mediante revert aprobado. No tocar DB. Producto sigue
cerrado.

## Plan 2B-AG83 — implementacion futura de `/conversations` producto

Estado: `CONVERSATIONS IMPLEMENTATION PLAN READY`.

AG83 es un plan tecnico. No implementa codigo, no registra `/conversations`,
no modifica rutas Flutter, no toca Supabase, no ejecuta SQL, no crea datos, no
usa datos reales, no activa staging/production, no despliega, no ejecuta
migraciones y no hace push.

### Cierre AG82

AG82 queda aprobado y cerrado formalmente como
`CONVERSATIONS IMPLEMENTATION PLAN DECISION READY`. AG83 queda autorizado solo
para preparar el plan tecnico exacto de implementacion futura de
`/conversations` producto.

### Separacion agentes de desarrollo vs especialistas producto

#### Agentes internos de desarrollo

Los 43 agentes del equipo AAA de Stasisly son agentes internos de construccion,
auditoria, arquitectura, seguridad, QA, producto, documentacion, gobierno y
Customer Success. Viven en la documentacion del equipo, prompts internos,
comites, ADRs y flujo de trabajo de Codex/Antigravity.

No son especialistas producto.

No pueden:

- aparecer en la app como especialistas conversables;
- aparecer en `public.specialist_catalog` producto;
- ser seleccionables por usuarios finales;
- abrir conversaciones producto;
- formar parte del onboarding de usuario final;
- mostrarse como participantes de una investigacion de usuario final;
- filtrarse como prompts internos, nombres de archivos, roles de auditoria,
  roles Codex, comites tecnicos o identidades de arquitectura/seguridad/QA.

Ejemplos internos no producto:

- Director de Proyecto;
- Product Owner;
- Arquitecto Backend;
- Arquitecto Flutter;
- Experto Seguridad;
- Experto RLS;
- QA Lead;
- DevOps;
- Legal/Compliance;
- UX Research;
- comites tecnicos;
- Equipo AAA de desarrollo.

#### Especialistas producto

Los especialistas producto son agentes visibles o utilizables por el usuario
final dentro de Stasisly. Pueden pertenecer a areas como Stasis, Salud,
Nutricion, Entrenamiento y Wellness.

Solo pueden aparecer en catalogo producto si cumplen un contrato sanitizado y
si el backend los valida como publicados, accesibles por tier y seguros para
usuario final.

Pueden ser candidatos futuros:

- Stasis;
- Jefe de Salud;
- Jefe de Nutricion;
- Jefe de Entrenamiento;
- Jefe de Wellness;
- Especialista Sueno;
- Especialista Mindfulness;
- Especialista Fuerza;
- Especialista Habitos;
- Especialista Alimentacion.

AG83 no define el catalogo final completo. Solo fija la frontera y el criterio.

### Reglas de catalogo producto

`public.specialist_catalog` producto solo puede contener especialistas producto
sanitizados.

No puede contener:

- agentes del equipo de desarrollo;
- comites internos;
- roles de arquitectura;
- roles de seguridad;
- roles de QA;
- roles DevOps;
- roles legales internos;
- prompts internos;
- nombres de archivos internos;
- roles Codex;
- roles de auditoria documental;
- identificadores sensibles.

### Reglas de `/conversations`

`/conversations` producto solo puede abrir conversaciones con:

- sesiones propias del usuario autenticado;
- especialistas producto autorizados;
- especialistas publicados;
- especialistas sanitizados;
- especialistas accesibles por tier;
- especialistas validados por backend.

No puede abrir conversaciones con:

- agentes del equipo de desarrollo;
- especialistas no publicados;
- roles internos;
- fixtures sinteticos;
- datos development;
- usuarios de prueba;
- rutas heredadas;
- IDs internos enviados desde UI;
- `userId` u `ownerUserId` enviados desde UI.

### Plan de rutas

Rutas futuras propuestas:

- `/conversations`: lista producto de conversaciones propias;
- `/conversations/:sessionId`: detalle futuro por `sessionId` propio, solo si
  se autoriza expresamente en el paquete de implementacion.

Rutas dev-shell separadas:

- `/dev/chat/composed`;
- `/dev/chat/session/:sessionId`.

Rutas bloqueadas:

- `/chat/:id` como `sessionId`, porque `:id` es `agentId` heredado;
- `/orchestrator/chat`;
- cualquier ruta que use chat heredado;
- cualquier ruta que acepte `id` ambiguo, `agentId`, `userId` u `ownerUserId`
  como entrada producto.

AG83 no registra ninguna ruta. El registro real requiere paquete posterior.

### Archivos permitidos y prohibidos futuros

Archivos o zonas candidatas para una implementacion futura, a confirmar en el
paquete de codigo:

- routing producto;
- pantalla `Conversations`;
- pantalla `ConversationDetail`;
- providers producto de conversaciones;
- controllers o state producto;
- repositories/datasources producto que llamen solo a backend seguro;
- modelos sanitizados;
- tests de route guards;
- tests de auth gates;
- tests de arquitectura.

Archivos o zonas bloqueadas salvo autorizacion separada:

- dev-shell como producto;
- fixtures;
- cliente directo de Supabase desde Flutter;
- `SupabaseChatDataSource`;
- chat heredado;
- `service_role`;
- migraciones;
- Edge Functions;
- staging/production config;
- cualquier archivo de plataforma o CI si no esta justificado en el paquete.

### Contratos backend permitidos

`/conversations` producto solo puede consumir backend seguro existente o futuro:

- `list-own-chat-sessions`;
- `list-session-messages`;
- `send-user-message`, si se autoriza composer;
- `archive-own-chat-session`, solo si se autoriza archivar/restaurar;
- `list-selectable-specialists`, si se necesita crear una sesion;
- `create-own-chat-session`, solo si se autoriza crear sesiones producto.

Condiciones obligatorias:

- backend valida ownership;
- UI no envia `userId`;
- UI no envia `ownerUserId`;
- UI no decide roles ni permisos;
- UI no accede directo a tablas;
- sin `service_role` cliente;
- sin fallback demo ante error real;
- errores de sesion ajena son opacos;
- contadores y timestamps siguen siendo server-managed.

### Auth y gates de entorno

Gates minimos para implementacion futura:

- producto requiere auth real definida y aprobada;
- no `SYNTHETIC_ACCESS_TOKEN`;
- no fixture development;
- no fallback demo;
- `backendReal` sigue siendo legacy/transitional y no base de producto;
- `ENABLE_CONVERSATIONS_ROUTE` no basta por si solo: requiere auth, backend,
  tests, rollback y aprobacion;
- datos reales siguen bloqueados hasta politica separada;
- staging y production no quedan autorizados por AG83.

Estados que la UI debe tratar sin degradar a demo:

- unauthenticated;
- expired;
- backendBlocked;
- misconfigured;
- contractViolation;
- backendUnavailable;
- forbidden/notFound opaco.

### UI minima futura

La futura UI minima debe cubrir:

- lista de conversaciones propias;
- estado vacio si no hay sesiones;
- detalle por `sessionId` propio;
- composer solo si `send-user-message` queda autorizado;
- errores auth/backend visibles;
- no mostrar agentes de desarrollo;
- no mostrar IDs internos completos;
- no exponer permisos internos;
- no mostrar fixture como producto;
- no mezclar dev-shell con producto.

### Tests obligatorios futuros

Tests minimos para pasar a codigo:

- route guard de `/conversations`;
- producto no registra ni reutiliza dev-shell;
- dev-shell no contamina producto;
- agentes de desarrollo no aparecen en `specialist_catalog` producto;
- `/chat/:id` no se usa como `sessionId`;
- `/orchestrator/chat` no se conecta al flujo seguro;
- no `SupabaseChatDataSource`;
- no Flutter directo a tablas;
- no `service_role` cliente;
- no `userId` ni `ownerUserId` enviados desde UI;
- error auth no cae a demo;
- fixture no aparece en producto;
- ownership backend queda asumido por contrato y probado por respuestas
  controladas;
- staging/production no activan rutas incompletas;
- la ruta puede desactivarse por gate/kill-switch si aplica.

### Rollback futuro

Rollback de implementacion futura:

- desregistrar `/conversations`;
- mantener dev-shell intacto;
- no tocar datos como rollback primario;
- no tocar Supabase si el cambio fue solo Flutter;
- usar feature flag o kill-switch si aplica;
- revertir commit si falla;
- no usar force push sin autorizacion explicita.

### Orden de implementacion futuro

Orden recomendado:

1. Commit/push del plan AG83.
2. Paquete de skeleton route guards sin UI completa.
3. Paquete de UI lista read-only.
4. Paquete de detalle read-only.
5. Paquete de `send-user-message` si se autoriza composer.
6. Paquete de archive/restore si se autoriza.
7. Hardening/tests.
8. Estrategia staging antes de production.

### Criterios para pasar a codigo

No se puede pasar a implementacion hasta cumplir:

- AG83 aprobado;
- separacion agentes desarrollo/producto aprobada;
- archivos permitidos/prohibidos definidos;
- tests minimos definidos;
- rollback definido;
- criterios de stop definidos;
- producto sigue sin datos reales;
- staging/production siguen no autorizados;
- no hay decision pendiente sobre auth/gates que haga inseguro registrar ruta.

### Criterios de stop

Detener cualquier paquete que derive de AG83 si:

- se modifica codigo sin aprobacion;
- se modifica `test/` sin aprobacion;
- se modifica `supabase/` sin aprobacion;
- se registra `/conversations` antes del paquete autorizado;
- se toca producto real sin gates;
- se ejecuta SQL, deploy o migracion;
- se hace cleanup adicional;
- se usan datos reales;
- se toca staging/production;
- se imprime secreto;
- se mezclan agentes de desarrollo con especialistas producto;
- se autoriza catalogo producto sin frontera sanitizada.

## Decision 2B-AG89 — siguiente frontera tras superficies, conversations y wearables

Estado: `PRODUCT SPECIALISTS CATALOG DECISION READY`.

AG89 es una decision documental. No implementa codigo, no modifica tests, no
toca `supabase/`, no registra `/conversations`, no crea rutas, no crea datos,
no puebla `specialist_catalog`, no ejecuta SQL, no activa staging/production y
no hace push.

### Cierre AG88

AG88 queda aprobado y cerrado formalmente como
`SURFACES CONVERSATIONS WEARABLES PUSH COMPLETED`.

Quedan publicados:

- ADR-008 `/conversations`;
- ADR-009 superficies operativas Product/Wizard/Admin;
- extension futura wearables de Product Surface;
- cleanup parcial de sesiones/mensajes sinteticos;
- separacion de familias de agentes.

### Evaluacion de opciones

#### Opcion A — iniciar implementacion controlada de `/conversations`

ADR-008 y ADR-009 ya fijan la frontera normativa, y el fixture de
sesiones/mensajes sinteticos ya fue limpiado. Sin embargo, aun falta definir el
catalogo producto real de especialistas conversables: que especialistas pueden
aparecer, ser seleccionables, abrir sesiones, estar publicados, requerir tier y
ser validados por backend.

Decision: diferir implementacion de `/conversations` hasta definir catalogo
producto conversable o gates minimos equivalentes.

#### Opcion B — preparar estrategia staging

Staging sigue siendo obligatorio antes de production. Requiere secrets, auth,
politica de datos, rollback y separacion de entornos. Puede prepararse como
frente separado, pero no resuelve por si solo que especialistas producto son
conversables.

Decision: diferir staging hasta que el catalogo producto y `/conversations`
tengan un plan claro, salvo que se abra un paquete especifico de seguridad de
entorno.

#### Opcion C — preparar catalogo producto real de especialistas conversables

Esta opcion define la frontera exacta entre:

- especialistas producto;
- agentes internos de desarrollo;
- agentes Admin/Engine;
- fixtures development;
- catalogo sanitizado;
- conversaciones producto.

Debe decidir:

- que es un especialista producto;
- que especialistas iniciales son candidatos;
- que campos sanitizados puede tener `specialist_catalog`;
- que campos quedan prohibidos;
- que roles internos quedan prohibidos;
- que agentes Admin/Engine quedan prohibidos;
- que especialistas pueden abrir conversacion;
- que especialistas requieren tier;
- como se relacionan Stasis, Salud, Nutricion, Entrenamiento y Wellness;
- como se publica o despublica un especialista;
- como valida backend;
- como evitar contaminacion desde desarrollo/admin.

Decision: recomendada como siguiente frontera.

#### Opcion D — guards/tests adicionales

Guards y tests son necesarios, pero pueden integrarse en el paquete del catalogo
producto. No se recomienda abrirlos como frente separado salvo hallazgo urgente.

Decision: integrar en AG90 salvo gap critico.

#### Opcion E — otro frente tecnico

No se identifica otro frente mas prudente que catalogo producto conversable
antes de `/conversations`. Cualquier alternativa debe justificar por que reduce
mas riesgo que definir primero que especialistas pueden conversar.

### Recomendacion final

Recomendacion: C — preparar catalogo producto real de especialistas
conversables.

Motivo: ya se separaron agentes internos de desarrollo, agentes Admin/Engine y
especialistas producto. Antes de abrir `/conversations` hay que definir que
especialistas producto pueden aparecer, ser seleccionables y abrir sesiones.
Sin ese catalogo, `/conversations` podria implementarse sobre una frontera
incompleta.

Riesgo: medio-alto si se implementa `/conversations` antes de definir catalogo;
bajo si AG90 permanece documental y no puebla datos reales.

Siguiente paquete: `2B-AG90 — preparar ADR/plan catalogo producto especialistas
conversables`.

AG90 materializa esta decision en ADR-010:

```text
docs/stasisly_definition/adr/ADR-010-product-specialists-catalog.md
```

ADR-010 no implementa catalogo ni puebla datos. Define la frontera documental
de especialistas producto conversables antes de cualquier implementacion de
`/conversations`.

### Criterios para AG90

AG90 debe preparar una ADR o plan, sin implementar, que defina:

1. frontera de especialista producto;
2. especialistas iniciales candidatos;
3. campos permitidos en `specialist_catalog`;
4. campos prohibidos;
5. relacion con areas Stasis, Salud, Nutricion, Entrenamiento y Wellness;
6. relacion con `/conversations`;
7. relacion con tiers/suscripcion;
8. publicacion y despublicacion;
9. validacion backend;
10. tests obligatorios;
11. criterios de stop;
12. rollback;
13. prohibicion de poblar datos reales en esa fase.

### Rollback

AG89 no tiene rollback tecnico. Si se modifica documentacion, revertir
documentacion. No tocar DB. Producto sigue cerrado.

## Consecuencias

Consecuencias positivas:

- evita abrir producto con una ruta heredada o ambigua;
- protege la separacion entre dev-shell y producto;
- mantiene trazabilidad de decisiones antes de usar datos reales;
- reduce riesgo de mezclar fixture, demo, staging y production;
- preserva rollback.

Costes:

- retrasa la implementacion productiva de conversaciones;
- exige un paquete posterior de aprobacion e implementacion;
- obliga a decidir cleanup/retention y staging antes de producto real.

## Riesgos

Riesgos que esta ADR intenta bloquear:

- abrir `/conversations` sin auth producto;
- usar `SYNTHETIC_ACCESS_TOKEN` en producto;
- confundir fixture con dato real;
- usar `/chat/:id` como `sessionId`;
- reactivar `SupabaseChatDataSource`;
- exponer `service_role` o secretos en cliente;
- usar Flutter directo contra tablas sensibles;
- convertir errores reales en demo;
- abrir staging/production sin politica de datos;
- filtrar existencia de sesiones ajenas.

## Relacion con ADR anteriores

- ADR-005 mantiene estabilizacion, modo demo explicito y bloqueo de backend
  real/productivo hasta autorizacion posterior.
- ADR-006 define identidad, autorizacion, RLS, ownership, bloqueos de auth real
  y criterios previos para rutas de conversaciones.
- ADR-007 define catalogo sanitizado, frontera backend y prohibicion de exponer
  IDs internos, prompts o autoridad desde Flutter.

ADR-008 no sustituye ADR-006 ni ADR-007. Las especializa para la futura ruta
producto `/conversations`.

## Estado de implementacion

No implementado.

No existe autorizacion en esta ADR para registrar `/conversations`, modificar
rutas, conectar producto, limpiar fixture, tocar Supabase, usar datos reales,
activar staging, activar production ni desplegar cambios.

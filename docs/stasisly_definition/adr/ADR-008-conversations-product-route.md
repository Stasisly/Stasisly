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

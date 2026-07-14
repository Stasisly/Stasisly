# Tests locales de Supabase

## Micro-paquete 2B-I

Objetivo: verificar en una base local o efímera que únicamente
`public.users` tiene RLS habilitada y que, al no existir políticas, los roles
cliente quedan bajo denegación total.

Este harness no usa credenciales reales, no conecta un proyecto remoto y no
autoriza acceso a datos.

### Requisitos del checkout

- Docker compatible con Supabase CLI e iniciado.
- `supabase/config.toml` exclusivamente local.
- Base local efímera creada únicamente con datos ficticios.

### Ejecución local

Ejecutar únicamente contra el runtime local:

```bash
supabase start
supabase db reset --local
supabase test db supabase/tests/2b_i_public_users_rls_test.sql --local
```

El test pgTAP crea dos identidades ficticias dentro de una transacción y
comprueba:

1. RLS habilitada en `public.users`.
2. `FORCE ROW LEVEL SECURITY` deshabilitado.
3. Cero políticas sobre `public.users`.
4. Ninguna otra tabla de `public` modificada para habilitar RLS.
5. Los roles `anon` y `authenticated` existen y no pueden omitir RLS.
6. `anon` y `authenticated` no pueden seleccionar, insertar, actualizar ni
   borrar filas.
7. Owner no puede leer su perfil.
8. Usuario A no puede leer usuario B.
9. Ningún cliente puede modificar `role`.
10. Los intentos no crean políticas ni cambian otras tablas.

### Última ejecución verificada

Fecha: 2026-06-13.

- `supabase db reset --local --no-seed`: migraciones `00001` y `00002`
  aplicadas correctamente.
- `supabase test db supabase/tests/2b_i_public_users_rls_test.sql --local`:
  21 de 21 tests superados.
- Rollback local: `public.users.relrowsecurity = false`.
- Reaplicación mediante reset: `public.users.relrowsecurity = true`.
- Después de reaplicar: `FORCE RLS = false`, cero políticas y cero tablas
  adicionales con RLS.
- Ningún proyecto remoto fue vinculado o consultado.

El test `2b_i_public_users_rls_test.sql` evolucionó después de 2B-II: ahora
comprueba que la base de seguridad establecida por 2B-I continúa intacta
después de añadir las políticas mínimas de perfil.

### Rollback explícito de 2B-I

El rollback solo puede probarse en una base local o efímera descartable:

```sql
ALTER TABLE public.users DISABLE ROW LEVEL SECURITY;

select relrowsecurity
from pg_catalog.pg_class c
join pg_catalog.pg_namespace n on n.oid = c.relnamespace
where n.nspname = 'public' and c.relname = 'users';
```

Después del rollback se debe comprobar que `relrowsecurity` es `false`, volver
a aplicar la migración y repetir el test pgTAP. Nunca ejecutar este rollback
en remoto ni usarlo para desbloquear backend real.

## Micro-paquete 2B-II

Objetivo: demostrar localmente que un usuario autenticado puede leer únicamente
`id` y `display_name` de su fila y actualizar únicamente `display_name`.

Ejecución:

```bash
supabase db reset --local --no-seed
supabase test db supabase/tests/2b_i_public_users_rls_test.sql --local
supabase test db supabase/tests/2b_ii_public_users_profile_minimal_test.sql --local
```

El test `2b_ii_public_users_profile_minimal_test.sql` contiene 38 comprobaciones
de catálogo y operaciones reales sobre fixtures ficticios dentro de una
transacción revertida. Verifica:

- exactamente dos políticas owner en `public.users`;
- grants exclusivos `SELECT(id, display_name)` y `UPDATE(display_name)`;
- bloqueo de `role`, `avatar_url`, `created_at`, `updated_at`, `SELECT *`,
  `INSERT` y `DELETE`;
- aislamiento owner/other;
- protección de `id` mediante ausencia de grant y `WITH CHECK`;
- ninguna política o RLS añadida a otras tablas.

### Checklist PostgREST local verificado

Con Auth, PostgREST y Kong exclusivamente locales:

- `select=id,display_name` owner devuelve solo la fila owner;
- filtro explícito por otro usuario devuelve `[]`;
- `select=*` y columnas bloqueadas devuelven `42501`;
- PATCH owner solo de `display_name` devuelve éxito;
- PATCH de `role` y payload mixto devuelven `42501` y no aplican cambios
  parciales;
- PATCH de otro usuario devuelve éxito HTTP sin filas afectadas y no filtra
  existencia.

Los códigos exactos observados el 2026-06-13 fueron `401` para `anon` sin
privilegios, `403` para columnas bloqueadas, `200` para lecturas permitidas y
`204` para PATCH permitido o filtrado por RLS.

No guardar tokens o claves locales en archivos versionados. No usar estos
tests para conectar o validar Supabase remoto.

## Micro-paquete 2B-III-A

Objetivo: crear exclusivamente en local el esquema vacío
`public.specialist_catalog`, endurecer `public.specialists` y demostrar que
ambas tablas permanecen bajo denegación total para clientes.

Ejecución:

```bash
supabase db reset --local --no-seed
supabase test db supabase/tests/2b_iii_a_specialist_catalog_deny_all_test.sql --local
supabase test db --local
```

El harness 2B-III-A contiene 56 comprobaciones y verifica:

- esquema exacto, tipos, nullability, defaults, PK, FK, UNIQUE e índice parcial;
- constraints de categorías, estados, tier, textos y orden;
- catálogo vacío después de migración;
- `public.specialists` estructuralmente intacta y `prompt_template` interno;
- RLS habilitada sin FORCE y cero policies en ambas tablas;
- cero privilegios para `PUBLIC`, `anon` y `authenticated`;
- denegación de `SELECT`, `INSERT`, `UPDATE` y `DELETE` para clientes;
- integridad de FK, unicidad y `ON DELETE RESTRICT`.

### Última ejecución verificada

Fecha: 2026-06-13.

- `supabase db reset --local --no-seed`: migraciones `00001`–`00004`
  aplicadas correctamente.
- Harness 2B-III-A: 56/56 pruebas superadas.
- Suite SQL local completa: 100/100 pruebas superadas.
- Rollback local probado con `DROP TABLE public.specialist_catalog;`, sin
  `CASCADE`.
- Tras rollback, `public.specialists` conservó RLS habilitada, FORCE
  deshabilitado, cero policies y cero lectura cliente.
- Reaplicación mediante reset recreó el catálogo y volvió a superar las
  pruebas.
- No se vinculó ni consultó ningún proyecto remoto.

Este rollback es deliberadamente asimétrico: no deshabilita RLS ni restaura
grants inseguros sobre `public.specialists`.

## Micro-paquete 2B-III-B

Objetivo: validar exclusivamente mediante fixtures transaccionales que el
catálogo puede representar seis entradas conceptuales sin crear seed
persistente, datos reales ni exposición cliente.

Ejecución:

```bash
supabase db reset --local --no-seed
supabase test db supabase/tests/2b_iii_b_specialist_catalog_fixtures_test.sql --local
supabase test db --local
```

El harness 2B-III-B contiene 40 comprobaciones y crea dentro de una transacción
revertida:

- seis especialistas internos ficticios con placeholder `test_only`;
- seis entradas conceptuales: Stasis, Salud general, Nutrición,
  Entrenamiento, Wellness y Sueño y estrés;
- IDs públicos separados de IDs internos;
- todas las entradas no publicadas, indisponibles y con tier `free`.

También verifica FK, unicidad, `ON DELETE RESTRICT`, constraints, ausencia de
afirmaciones médicas, RLS deny-all, cero policies, cero privilegios cliente y
denegación de lectura/escritura para `anon` y `authenticated`.

### Última ejecución verificada

Fecha: 2026-06-14.

- Harness 2B-III-B: 40/40 pruebas superadas.
- Suite SQL local completa: 140/140 pruebas superadas.
- Después de cada test: cero filas en `specialist_catalog` y cero especialistas
  fixture.
- Después de reset y reaplicación: cero fixtures persistentes y ambas tablas
  mantienen RLS sin FORCE.
- No se creó seed, migración, dato editorial real ni conexión remota.

## Micro-paquete 2B-III-C

Objetivo: validar exclusivamente en local la Edge Function experimental
`list-selectable-specialists` y demostrar contrato, autenticación, fallo
cerrado y ausencia de remoto sin crear seed ni catálogo persistente.

Ejecución:

```bash
deno test --allow-env supabase/functions/list-selectable-specialists/index_test.ts
supabase functions serve list-selectable-specialists \
  --no-verify-jwt \
  --env-file /ruta/temporal/fuera-del-repo
bash supabase/tests/2b_iii_c_edge_function_local_test.sh
```

Los tests Deno validan:

- contrato exacto de seis campos;
- ausencia de columnas internas;
- reglas `available`, `lockedPro` y `unavailable`;
- fallo cerrado ante estados contradictorios, secreto ausente y host remoto;
- JWT obligatorio y validado antes de consultar catálogo;
- rechazo de autoridad enviada por cliente;
- orden, filtro, límite y logs por allowlist.

El harness HTTP crea únicamente una identidad Auth local ficticia que elimina
al finalizar. Comprueba JWT ausente/inválido, JWT válido emitido por Auth
local, catálogo vacío válido, área inválida y cero filas persistentes en
`specialist_catalog`.

Los fixtures de catálogo continúan exclusivamente en el harness transaccional
2B-III-B. Los tests de función usan fixtures en memoria y el catálogo real
local vacío; no crean seed ni datos persistentes.

## Micro-paquete 2B-III-C2

Objetivo: validar la ruta HTTP local completa con catálogo no vacío mediante 21
fixtures efímeros confirmados y cleanup compensatorio obligatorio.

Archivos:

```text
2b_iii_c2_non_empty_catalog_setup.psql
2b_iii_c2_non_empty_catalog_cleanup.psql
2b_iii_c2_non_empty_catalog_http_test.sh
```

El setup y cleanup no son migraciones ni seed. El orquestador instala un
`trap` antes del setup, crea 21 especialistas/catálogos `test_only_c2`, llama
la Edge Function real y elimina todos los fixtures y el usuario Auth local al
final.

Ejecución local, con la función servida y sus logs redirigidos a un archivo
temporal fuera del repositorio:

```bash
STASISLY_EDGE_LOG_FILE=/ruta/temporal/edge.log \
  bash supabase/tests/2b_iii_c2_non_empty_catalog_http_test.sh
```

Verifica:

- respuesta HTTP no vacía con contrato exacto;
- los cuatro estados canónicos;
- orden estable, límite 20 sobre 21 fixtures y filtro wellness;
- JWT obligatorio y catálogo deny-all para clientes directos;
- ausencia de columnas internas y valores prohibidos en logs;
- cero catálogo, especialistas C2 y usuarios Auth C2 tras cleanup.

Si el cleanup compensatorio falla, debe ejecutarse
`supabase db reset --local --no-seed` como recuperación secundaria. Nunca se
declara éxito sin postcondiciones limpias.

## Micro-paquete 2B-IV-A

Objetivo: endurecer `public.chat_sessions` exclusivamente en Supabase
local/efímero con constraints mínimos y acceso cliente deny-all.

Archivos:

```text
../migrations/00005_harden_chat_sessions_deny_all.sql
2b_iv_a_chat_sessions_deny_all_test.sql
2b_iv_a_chat_sessions_rollback.psql
```

Ejecución local esperada:

```bash
supabase start
supabase db reset --local --no-seed
supabase test db supabase/tests/2b_iv_a_chat_sessions_deny_all_test.sql --local
supabase test db --local
```

El harness pgTAP de 40 comprobaciones valida:

- columnas exactas, tipos históricos y defaults aprobados;
- todas las columnas `NOT NULL`, dos FKs aprobadas y tres checks mínimos;
- índice exacto de listado owner y ausencia del índice simple sustituido;
- RLS sin FORCE, cero policies y cero grants CRUD cliente;
- denegación CRUD real para `anon` y `authenticated`;
- fixture servidor válido y rechazo de nulos/valores inválidos;
- columnas, RLS y policies de `messages` intactas.

### Evidencia preflight fail-closed

La migración ejecuta un preflight transaccional antes del endurecimiento.
Aborta ante columnas/policies inesperadas, FKs distintas o cualquier fila con
ownership, especialista, timestamps, estado o contador nulos; estado inválido;
contador negativo; o cronología inválida. No contiene `UPDATE`, `DELETE`,
backfill ni transformación de datos.

Para demostrar el fallo en runtime debe usarse únicamente una base local
descartable detenida en `00004`: insertar mediante harness privilegiado una
fila ficticia incompatible y aplicar `00005`. La aplicación debe fallar y el
esquema debe permanecer intacto. Después se elimina la base mediante reset.
Nunca ejecutar este procedimiento en remoto.

### Rollback asimétrico y reaplicación

Solo en Supabase local descartable:

```bash
psql "$LOCAL_DB_URL" -f supabase/tests/2b_iv_a_chat_sessions_rollback.psql
supabase db reset --local --no-seed
supabase test db supabase/tests/2b_iv_a_chat_sessions_deny_all_test.sql --local
```

El rollback retira constraints/índice nuevos y restaura nullability/índice
históricos únicamente para probar reversibilidad. Conserva RLS, cero policies
y cero grants cliente, y no toca `messages`.

No ejecutar `link`, `deploy`, `db push`, usar tokens o apuntar a hosts no
locales.

### Última ejecución verificada

Fecha: 2026-06-14.

- Docker Desktop fue iniciado localmente y Supabase usó exclusivamente
  `127.0.0.1`.
- Reset local aplicó correctamente migraciones `00001`–`00005`.
- Harness 2B-IV-A: 40/40 pruebas superadas.
- Suite SQL local acumulada: 180/180 pruebas superadas.
- Rollback asimétrico verificado: RLS habilitada, FORCE deshabilitado, cero
  policies y seis columnas de `messages` intactas.
- Preflight fail-closed verificado con una fila ficticia incompatible: la
  aplicación terminó con error y dejó `user_id` nullable, RLS habilitada y la
  fila sin transformar; después se eliminó el fixture.
- Reset/reaplicación posterior volvió a superar 40/40 y 180/180.
- No se ejecutaron `link`, `deploy`, `db push`, remoto, seed o datos reales.

## Micro-paquete 2B-IV-B

Objetivo: validar sesiones propias/ajenas mediante fixtures exclusivamente
transaccionales, sin seed, migración de datos, fixtures confirmados o cleanup
compensatorio.

Archivos:

```text
2b_iv_b_chat_sessions_fixtures_test.sql
2b_iv_b_chat_sessions_fixtures_postconditions_test.sql
```

Ejecución local:

```bash
supabase start
supabase db reset --local --no-seed
supabase test db supabase/tests/2b_iv_b_chat_sessions_fixtures_test.sql --local
supabase test db supabase/tests/2b_iv_b_chat_sessions_fixtures_postconditions_test.sql --local
supabase test db --local
supabase stop
```

El harness principal crea dentro de `BEGIN/ROLLBACK` dos usuarios/perfiles
ficticios, un especialista interno, una entrada de catálogo y tres sesiones:
activa owner, archivada owner y ajena. Valida FKs, ID público/interno, owner,
estado, contador, cronología, orden, constraints, deny-all y `messages`
intacta.

El test de postcondiciones se ejecuta desde una transacción nueva después del
rollback y exige exactamente cero fixtures `test_only_2b_iv_b` en
`auth.users`, `public.users`, `public.specialists`,
`public.specialist_catalog` y `public.chat_sessions`. También exige cero
mensajes y deny-all intacto.

Este paquete no contiene `COMMIT`, setup confirmado, cleanup compensatorio,
seed o datos reales. Nunca declarar éxito si cualquiera de las cinco tablas
conserva un fixture.

### Resultado local verificado de 2B-IV-B

Fecha: 2026-06-14.

- Harness transaccional principal: 31/31 pruebas superadas.
- Postcondiciones ejecutadas desde una transacción nueva: 8/8 pruebas
  superadas.
- Suite SQL local acumulada: 219/219 pruebas superadas.
- Consulta externa posterior a la suite:
  `0|0|0|0|0|0` para fixtures en `auth.users`, `public.users`,
  `public.specialists`, `public.specialist_catalog`, `public.chat_sessions` y
  filas de `public.messages`.
- Los SHA-256 de las migraciones `00001`-`00005` son idénticos antes y
  después de implementar y ejecutar B; ninguna migración fue modificada.
- Los tests B no contienen `COMMIT`, seed, cleanup compensatorio, `DELETE` ni
  `TRUNCATE`. Todos los fixtures existen solo dentro de `BEGIN/ROLLBACK`.
- La ejecución usó exclusivamente Supabase local; no hubo link, push,
  despliegue, credenciales reales ni acceso remoto.

## Micro-paquete 2B-IV-C

Objetivo: validar localmente `createOwnChatSession` mediante una Edge Function
separada que acepta exclusivamente `selectableSpecialistId`, deriva owner del
JWT validado y crea siempre una sesión nueva.

Archivos principales:

```text
../functions/create-own-chat-session/
2b_iv_c_create_session_setup.psql
2b_iv_c_create_session_cleanup.psql
2b_iv_c_create_session_http_test.sh
```

El harness HTTP usa fixtures confirmados exclusivamente porque la Edge
Function opera desde otra conexión. El cleanup compensatorio es obligatorio y
las postcondiciones exigen cero usuarios, perfiles, especialistas, entradas de
catálogo y sesiones `test_only_2b_iv_c`.

Controles críticos:

- dos llamadas válidas crean dos `sessionId` distintos y dos filas activas;
- nunca se busca ni reutiliza una sesión activa;
- `messages` conserva exactamente su cardinalidad inicial y no recibe filas;
- la respuesta no contiene `user_id`, `specialist_id`, el ID interno del
  especialista, prompts ni configuración sensible;
- catálogo y especialista conservan exactamente su contenido;
- JWT se valida contra Auth local y el owner se deriva de esa identidad;
- host no local, campos adicionales y estados no permitidos fallan cerrado.

No ejecutar `link`, `deploy`, `db push`, remoto o datos reales.

## Micro-paquete 2B-V-D

Objetivo: validar localmente `list-session-messages` mediante una Edge Function
de solo lectura que lista mensajes de una sesión propia activa o archivada sin
exponer campos internos ni modificar estado.

Archivos principales:

```text
../functions/list-session-messages/
2b_v_d_list_session_messages_setup.psql
2b_v_d_list_session_messages_cleanup.psql
2b_v_d_list_session_messages_http_test.sh
```

Controles críticos:

- JWT local obligatorio; sin JWT o JWT inválido devuelve 401.
- Query allowlist: solo `sessionId`, `limit` y `cursor`.
- Sesión propia activa lista mensajes.
- Sesión propia archivada lista mensajes históricos.
- Sesión ajena e inexistente devuelven el mismo `sessionNotFound` 404 opaco.
- Paginación keyset estable por `created_at ASC, id ASC` sin duplicados.
- Respuesta pública sin `user_id`, `specialist_id`, `prompt_template`,
  `service_role`, JWT, attachments ni metadata interna.
- La función no modifica `messages`, `chat_sessions`, `message_count`,
  `last_message_at`, catálogo ni especialistas.
- Logs sanitizados sin secretos, IDs internos ni contenido de mensajes.
- Fixtures confirmados solo en local con cleanup compensatorio obligatorio.
- Postcondición final exacta: `0|0|0|0|0|0`.

Resultado local verificado el 2026-06-21:

- `supabase db reset --local --no-seed`: `00001`-`00007`;
- suite SQL acumulada: 394/394;
- `deno fmt --check supabase/functions/list-session-messages`: correcto;
- `deno check` de D: correcto;
- test Deno D: 6/6;
- harness HTTP D: PASS;
- cleanup final: `0|0|0|0|0|0`;
- ejecución solo local, sin `link`, `db push`, deploy, remoto, producción,
  datos reales ni tokens reales versionados.

No ejecutar todavía contrato Flutter, datasource Flutter, UI/providers, IA,
Stasis Engine, remoto o producción dentro de este paquete.

## Micro-paquete 2B-V-A

Objetivo: endurecer localmente `public.messages` con deny-all y constraints
mínimos antes de permitir cualquier escritura o lectura real de mensajes.

Archivos principales:

```text
../migrations/00006_harden_messages_deny_all.sql
2b_v_a_messages_deny_all_test.sql
2b_v_a_messages_preflight_test.sh
2b_v_a_messages_rollback.psql
```

Controles críticos:

- RLS habilitada en `messages` sin FORCE;
- cero policies en `messages`;
- cero grants cliente para `anon` y `authenticated`;
- `session_id` es `NOT NULL`;
- `created_at` es `NOT NULL DEFAULT now()`;
- `role` permite solo `user`, `assistant`, `system` y `tool`;
- `chief_intervention` y cualquier role no aprobado fallan cerrado;
- contenido vacío, whitespace-only o mayor de 4000 caracteres falla cerrado;
- `attachments` queda obligado a `NULL` para MVP local;
- índice estable por `(session_id, created_at, id)`;
- `message_count` y `last_message_at` de `chat_sessions` no se modifican;
- rollback conserva deny-all y cero grants cliente;
- el preflight aborta ante filas incompatibles y no transforma parcialmente.

Resultado local verificado:

- `supabase db reset --local --no-seed` aplicó `00001` a `00006`;
- test específico 2B-V-A: 57/57;
- suite SQL acumulada: 276/276;
- preflight incompatible abortó con
  `2B-V-A preflight rejected 1 incompatible messages rows`;
- rollback dejó `RLS=true`, `FORCE=false`, `policies=0`, `messages=0` y cero
  grants cliente;
- reaplicación posterior volvió a dejar la suite completa en verde;
- ejecución solo local, sin `link`, `db push`, deploy, remoto, producción,
  datos reales ni tokens reales versionados.

No ejecutar Flutter, Edge Functions de mensajes, UI/providers, IA, Stasis
Engine, remoto o datos reales dentro de este paquete.

## Micro-paquete 2B-V-B

Objetivo: validar fixtures locales transaccionales de `public.messages` sin
crear seed persistente, sin modificar migraciones y sin habilitar envío o
listado real de mensajes.

Archivos principales:

```text
2b_v_b_messages_fixtures_test.sql
2b_v_b_messages_fixtures_zz_postconditions_test.sql
```

Controles críticos:

- todos los fixtures usan marcador `test_only_2b_v_b`;
- el test principal usa `BEGIN` y `ROLLBACK`;
- no hay `COMMIT`, seed persistente ni cleanup compensatorio;
- se crean owner/other user, perfil público, especialista interno, catálogo,
  sesiones activa/archivada/ajena y mensajes solo dentro de la transacción;
- existe un mensaje histórico en sesión archivada, pero eso no autoriza crear
  mensajes nuevos en sesiones archivadas;
- `chief_intervention` y roles inválidos se rechazan;
- roles internos `user`, `assistant`, `system` y `tool` se aceptan solo como
  inserciones internas directas de test;
- contenido inválido y attachments no `NULL` se rechazan;
- orden estable por `created_at ASC, id ASC`;
- `messages` conserva RLS sin FORCE, cero policies y cero grants cliente;
- anon/authenticated no tienen CRUD;
- `message_count` y `last_message_at` no se actualizan automáticamente por
  fixtures directos;
- postcondición externa exacta esperada: `0|0|0|0|0|0`.

Resultado local verificado:

- test específico B: 55/55;
- postcondiciones B: 7/7;
- suite SQL acumulada: 338/338;
- consulta externa posterior: `0|0|0|0|0|0`;
- estado externo de `messages`: `RLS=true`, `FORCE=false`, `policies=0`,
  `client_grants=0`;
- ejecución solo local, sin `link`, `db push`, deploy, remoto, producción,
  datos reales ni tokens reales versionados.

No ejecutar `send-user-message`, `list-session-messages`, Flutter, UI,
providers, IA, Stasis Engine, remoto o producción dentro de este paquete.

## Micro-paquete 2B-V-C1

Objetivo: validar localmente la RPC transaccional interna
`send_user_message_core` como núcleo SQL para un futuro `send-user-message`,
sin exponer HTTP, Flutter, remoto ni datos reales.

Archivos principales:

```text
../migrations/00007_create_send_user_message_core_rpc.sql
2b_v_c1_send_user_message_core_test.sql
2b_v_c1_send_user_message_core_zz_postconditions_test.sql
2b_v_c1_send_user_message_core_rollback.psql
```

Controles críticos:

- RPC `public.send_user_message_core(uuid, uuid, text)` existente;
- no usa `SECURITY DEFINER`;
- `anon` y `authenticated` no tienen `EXECUTE`;
- `service_role` local/controlado sí tiene `EXECUTE`;
- `PUBLIC` no conserva grant de ejecución;
- no se crean policies permisivas en `messages` ni `chat_sessions`;
- cliente `anon`/`authenticated` sigue sin grants CRUD relevantes;
- sesión propia activa crea exactamente un mensaje `role=user`;
- sesión ajena, archivada, inexistente y contenido inválido fallan;
- `attachments` queda `NULL`;
- `created_at` lo gestiona servidor;
- `message_count` incrementa exactamente una vez;
- `last_message_at` coincide con `created_at` del mensaje insertado;
- no se crean mensajes `assistant`, `system` o `tool`;
- fallos de validación no dejan mensajes ni cambios parciales;
- catálogo y especialistas permanecen sin cambios fuera de fixtures
  transaccionales;
- rollback elimina la RPC sin abrir policies;
- reaplicación por reset vuelve a pasar la suite;
- postcondición externa exacta esperada: `0|0|0|0|0|0`.

Resultado local verificado:

- test específico C1: 48/48;
- postcondiciones C1: 8/8;
- suite SQL acumulada: 394/394;
- catálogo PostgreSQL:
  `security_definer=false`, `anon_execute=false`,
  `authenticated_execute=false`, `service_role_execute=true`;
- rollback eliminó la RPC y conservó cero policies;
- reaplicación local pasó la suite completa;
- ejecución solo local, sin `link`, `db push`, deploy, remoto, producción,
  datos reales ni tokens reales versionados.

No ejecutar todavía Edge Function `send-user-message`, `list-session-messages`,
Flutter, UI, providers, IA, Stasis Engine, remoto o producción dentro de este
paquete.

## Micro-paquete 2B-V-C2

Objetivo: validar localmente la Edge Function `send-user-message` como frontera
HTTP segura para enviar mensajes de usuario mediante la RPC
`public.send_user_message_core`.

Archivos principales:

```text
../functions/send-user-message/
2b_v_c2_send_user_message_setup.psql
2b_v_c2_send_user_message_cleanup.psql
2b_v_c2_send_user_message_http_test.sh
```

Controles críticos:

- JWT obligatorio y validado contra Auth local;
- owner derivado desde JWT, nunca desde body;
- body exacto con `sessionId` y `content`;
- rechazo de campos internos/extra como `role`, `userId`, `specialistId`,
  timestamps, contadores, attachments y metadata;
- content trimmeado, no vacío y máximo 4000 caracteres tras trim;
- llamada exclusiva a `/rest/v1/rpc/send_user_message_core`;
- sin rutas directas `/rest/v1/messages` ni `/rest/v1/chat_sessions` en el
  runtime;
- sin inserts directos en `messages`;
- sin updates directos en `chat_sessions`;
- sin dos escrituras REST separadas;
- sesión ajena e inexistente devuelven el mismo `sessionNotFound` 404;
- sesión propia archivada devuelve `sessionArchived` 409;
- segundo mensaje incrementa contador y mueve `last_message_at`;
- respuesta pública no expone `user_id`, `specialist_id`, `prompt_template`,
  `service_role`, JWT, attachments ni metadata interna;
- no se modifica `specialist_catalog` ni `specialists`;
- no IA, streaming, listado, Flutter, UI/providers, remoto ni producción;
- cleanup obligatorio y postcondición externa exacta `0|0|0|0|0|0`.

Resultado local verificado:

- `supabase db reset --local --no-seed`: `00001`-`00007`;
- suite SQL acumulada: 394/394;
- `deno fmt --check supabase/functions/send-user-message`: correcto;
- `deno check` de C2: correcto;
- test Deno C2: 7/7;
- harness HTTP C2: PASS;
- cleanup final: `0|0|0|0|0|0`;
- `git diff --check`: correcto;
- ejecución solo local, sin `link`, `db push`, deploy, remoto, producción,
  datos reales ni tokens reales versionados.

No ejecutar todavía `list-session-messages`, Flutter, UI, providers, IA,
Stasis Engine, remoto o producción dentro de este paquete.

## Micro-paquete 2B-V-G

Objetivo: validar localmente la integración real entre el datasource Flutter
HTTP local de mensajes, las Edge Functions `send-user-message` y
`list-session-messages`, la RPC `public.send_user_message_core` y Supabase
local.

Archivos principales:

```text
2b_v_g_messages_http_integration_setup.psql
2b_v_g_messages_http_integration_cleanup.psql
2b_v_g_messages_http_integration_test.sh
../../test/integration/two_b_v_g_local_http_chat_messages_integration_test.dart
```

Controles críticos:

- fixtures marcados como `test_only_2b_v_g`;
- JWT local efímero obtenido desde Auth local, pasado solo por `dart-define`;
- env file temporal fuera del repo, con permisos restrictivos y borrado al
  final;
- `service_role` local solo en runtime Edge Functions, nunca versionado;
- base URL local-only: `http://127.0.0.1:<puerto>` o
  `http://localhost:<puerto>`;
- preflight anti-remoto bloquea configuración con `supabase.co`, project ref o
  token remoto;
- `sendUserMessage` valida sesión propia activa, content trimmeado, `role=user`,
  `message_count +1` y `last_message_at` actualizado;
- `listSessionMessages` valida sesión propia activa, sesión propia archivada,
  paginación estable y cursor inválido;
- sesión ajena e inexistente devuelven `sessionNotFound` opaco;
- sesión archivada es legible, pero no escribible;
- el datasource no envía `role`, `userId`, `specialistId`, attachments ni
  metadata;
- respuestas públicas pasan por `OwnChatMessagesPayloadValidator`;
- `list-session-messages` no modifica `messages`, `chat_sessions`,
  `message_count` ni `last_message_at`;
- no se modifica `specialists` ni `specialist_catalog`;
- logs locales no contienen JWT completo, `service_role`, content completo,
  owner completo, IDs internos, `prompt_template` ni metadata interna;
- cleanup obligatorio y postcondición externa exacta `0|0|0|0|0|0`;
- sin providers, UI, chat heredado, remoto, producción, IA, Stasis Engine, MCP
  ni streaming.

Resultado local verificado:

- `supabase start` requirió excluir servicios auxiliares no necesarios por
  conflicto local de puerto `54327`;
- `supabase db reset --local --no-seed`: `00001`-`00007`;
- suite SQL acumulada: 394/394;
- harness HTTP G: PASS;
- test Flutter de integración G: 3/3;
- cleanup final: `0|0|0|0|0|0`;
- ejecución solo local, sin `link`, `db push`, deploy, remoto, producción,
  datos reales ni tokens reales versionados.

## Micro-paquete 2B-IV-E

Objetivo: validar localmente `archiveOwnChatSession` mediante una Edge Function
separada que archiva exclusivamente una sesión propia activa.

Archivos principales:

```text
../functions/archive-own-chat-session/
2b_iv_e_archive_session_setup.psql
2b_iv_e_archive_session_cleanup.psql
2b_iv_e_archive_session_http_test.sh
```

Controles críticos:

- un único `PATCH` filtra por `sessionId`, owner derivado y `status=active`;
- el body técnico actualiza exclusivamente `status=archived`;
- snapshot completo antes/después demuestra que `last_message_at`,
  `started_at`, `message_count`, owner, especialista e ID no cambian;
- sesión inexistente, ajena, ya archivada y segundo intento devuelven el mismo
  `sessionNotFound` opaco;
- respuesta de éxito contiene únicamente `sessionId` y `status`;
- no crea mensajes ni modifica otras sesiones, catálogo o especialistas;
- cleanup obligatorio y postcondiciones de cero fixtures.

No ejecutar `link`, `deploy`, `db push`, remoto o datos reales.

## Micro-paquete 2B-IV-D

Objetivo: validar localmente `listOwnChatSessions` mediante una Edge Function
separada que deriva owner del JWT y devuelve únicamente una proyección pública
sanitizada.

Archivos principales:

```text
../functions/list-own-chat-sessions/
2b_iv_d_list_sessions_setup.psql
2b_iv_d_list_sessions_cleanup.psql
2b_iv_d_list_sessions_http_test.sh
```

Controles críticos:

- usuario A nunca recibe sesiones de B y viceversa;
- `active` es el default; `archived` y `all` son explícitos;
- cursor keyset por `last_message_at DESC, id DESC` no duplica sesiones;
- si una sesión no resuelve catálogo publicado, toda la respuesta falla con
  `contractViolation`, sin `items`, lista parcial o placeholder;
- ninguna respuesta contiene `user_id`, `specialist_id` ni IDs internos;
- la función no modifica sesiones, catálogo, especialistas o mensajes;
- cleanup obligatorio y postcondiciones de cero fixtures.

No ejecutar `link`, `deploy`, `db push`, remoto o datos reales.

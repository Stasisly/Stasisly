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
2026-06-15. 2B-V `messages` queda preparado como plan exacto documental,
pendiente de aprobación de implementación. Toda conexión remota Flutter-backend
permanece sin autorizar.

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

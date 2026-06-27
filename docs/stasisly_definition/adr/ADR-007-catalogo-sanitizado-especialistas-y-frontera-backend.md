# ADR-007: Catálogo sanitizado de especialistas y frontera backend

## Estado

Aceptado conceptualmente. Micro-paquete 2B-III-A implementado, verificado
exclusivamente en entorno local/efímero y cerrado formalmente el 2026-06-14.
Micro-paquete 2B-III-B implementado, verificado exclusivamente mediante
fixtures locales transaccionales y cerrado formalmente el 2026-06-14. Plan
exacto 2B-III-C aprobado exclusivamente como diseño documental el 2026-06-14.
2B-III-C1 aprobado documentalmente el 2026-06-14: se permite
condicionalmente `service_role` exclusivamente local, efímero y aislado para
la validación experimental. 2B-III-C implementado, verificado exclusivamente
en local y cerrado formalmente el 2026-06-14. 2B-III-C2 implementado,
verificado exclusivamente en local y cerrado formalmente el 2026-06-14.
2B-III-D implementado, verificado como contrato Flutter exclusivamente
desconectado y cerrado formalmente el 2026-06-14. Diseño general 2B-IV de
`chat_sessions` aprobado documentalmente y dividido en subpaquetes; su
implementación completa no está autorizada. Plan exacto 2B-IV-A preparado
documentalmente y pendiente de aprobación. Secretos persistentes, catálogo
real, acceso Flutter-backend, API/capa backend permanente, remoto y datos
reales permanecen sin autorizar. 2B-IV-A fue implementado, verificado
exclusivamente en local y cerrado formalmente el 2026-06-14. Plan exacto
2B-IV-B implementado, verificado exclusivamente mediante fixtures locales
transaccionales y cerrado formalmente el 2026-06-14. 2B-IV-C implementado,
verificado exclusivamente en entorno local/efímero y cerrado formalmente el
2026-06-14. Plan exacto 2B-IV-D preparado documentalmente y pendiente de
aprobación. 2B-IV-D fue implementado después, verificado exclusivamente en
entorno local/efímero y cerrado formalmente el 2026-06-14. Plan exacto
2B-IV-E fue implementado, verificado exclusivamente en entorno local/efímero
y cerrado formalmente el 2026-06-14. 2B-IV-F fue implementado, verificado
como contrato Flutter exclusivamente desconectado y cerrado formalmente el
2026-06-14. 2B-IV-G fue implementado, verificado como datasource Flutter HTTP
exclusivamente local y cerrado formalmente el 2026-06-15. Plan exacto
2B-IV-H aprobado, implementado y verificado como integración HTTP local
controlada el 2026-06-15. 2B-V-A `messages` deny-all + constraints mínimos fue
aprobado, implementado y verificado exclusivamente en local/efímero el
2026-06-15. 2B-V-B fixtures locales transaccionales de `messages` fue
aprobado, implementado y verificado exclusivamente en local el 2026-06-16,
sin migraciones, seeds ni fixtures confirmados. No autoriza Supabase client,
remoto, producción, exposición de IDs internos, mensajes reales, IA ni
UI/providers.
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
el 2026-06-21 con host policy local, token provider inyectado, transporte falso
en tests unitarios y sin exponer `userId`, `specialistId`, `role` ni campos
internos en requests. 2B-V-G integración HTTP local permanece pendiente de
aprobación; su plan exacto queda preparado documentalmente. 2B-V-G fue
implementado y verificado exclusivamente en local el 2026-06-21, con cleanup
`0|0|0|0|0|0`, sin providers/UI, sin remoto y sin datos reales. 2B-V-H fue
cerrado documentalmente el 2026-06-21. 2B-V-I1 application controller/state
messages sin providers reales fue implementado, verificado y cerrado
formalmente el 2026-06-21. 2B-V-I2 providers Riverpod messages sin UI queda
implementado, verificado y cerrado formalmente el 2026-06-21. 2B-V-J UI mínima
messages aislada queda implementado, verificado y cerrado formalmente el
2026-06-21 como componente sin ruta real. 2B-V-J2 host/demo aislado queda
implementado, verificado y cerrado formalmente el 2026-06-21 como host
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

## Contexto

Stasisly necesita mostrar un catálogo mínimo de especialistas seleccionables
antes de permitir la creación real de sesiones de chat. El esquema actual no
dispone de un catálogo público seguro: `public.specialists` mezcla identidad
interna, configuración operativa, prompts, jerarquía, disponibilidad, flags
comerciales y categorías heredadas.

La tabla actual contiene, entre otros campos:

```text
id
name
category
subcategory
prompt_template
is_premium
is_active
avatar_url
branch_id
chief_id
created_at
```

Exponerla directa o parcialmente al cliente implicaría riesgos críticos:

- `prompt_template` contiene instrucciones y configuración interna;
- `branch_id` y `chief_id` exponen jerarquía interna;
- `is_active` e `is_premium` son flags internos y no prueban autorización;
- la tabla mezcla presentación pública y configuración operativa;
- las categorías `fisico` y `mental` contradicen los nombres vigentes de
  producto Entrenamiento y Wellness;
- no existe una decisión server-managed explícita de publicación/selección;
- no modela correctamente `accessState`, que puede depender del usuario;
- una ampliación accidental de columnas podría filtrar información sensible.

Este ADR especializa las decisiones de identidad, autorización y RLS de
ADR-006. Su aprobación conceptual no autoriza implementación y toda ejecución
continúa bloqueada hasta aprobar expresamente un subpaquete.

## Decisión principal aprobada conceptualmente

Se aprueba conceptualmente como dirección:

```text
public.specialists = tabla interna/backend-only
public.specialist_catalog = fuente sanitizada futura backend-only
API/capa backend controlada = frontera MVP recomendada
```

Consecuencias obligatorias:

- Flutter no accede directamente a ninguna de las dos tablas;
- `public.specialists` permanece deny-all para cliente;
- `public.specialist_catalog` nace deny-all para cliente;
- el catálogo real solo se obtiene mediante frontera backend controlada;
- demo utiliza un repositorio local explícito;
- prompts, configuración, jerarquía y flags internos nunca forman parte del
  contrato público;
- ningún subpaquete queda autorizado por la aprobación documental del ADR.

Se aprueba documentalmente que una Edge Function exclusivamente local/efímera
puede ser la primera implementación de la frontera para el MVP. Esto no
autoriza crearla ni usar identidad técnica, secretos o acceso privilegiado.
RPC no se recomienda como frontera pública inicial.

## Separación de identificadores

Se formaliza la separación conceptual:

```text
specialist_catalog.id = ID público seleccionable
specialists.id = ID interno de agente/configuración
```

Reglas:

1. Flutter solo recibe y utiliza `specialist_catalog.id`.
2. Flutter nunca recibe, persiste ni envía `specialists.id`.
3. El contrato futuro será:

   ```text
   createOwnChatSession(selectableSpecialistId)
   ```

4. La frontera backend resuelve internamente
   `specialist_catalog.id -> specialists.id`.
5. El backend revalida publicación, disponibilidad y entitlement antes de
   utilizar el ID interno.
6. Conocer o poseer un ID público no concede autorización.
7. IDs internos enviados por cliente se rechazan sin revelar si existen.
8. Logs y errores no incluyen IDs internos salvo auditoría backend protegida y
   justificada.

## Modelo futuro `public.specialist_catalog`

La tabla propuesta será una fuente sanitizada editorial y de publicación, pero
seguirá siendo backend-only. No se implementa mediante este ADR.

| Columna | Tipo conceptual | Propósito | Visible al cliente | Editable backend/admin | Contrato público | Sensibilidad / riesgo | Fase |
| --- | --- | --- | --- | --- | --- | --- | --- |
| `id` | UUID, PK, generado por servidor | Identificador público opaco | Sí, como `id` | Solo creación controlada | Sí | No concede autoridad | MVP |
| `specialist_id` | UUID, FK única a `specialists.id`, `ON DELETE RESTRICT` | Vincular catálogo con agente interno | Nunca | Backend/admin | No | Muy sensible; permite correlacionar identidad interna | MVP |
| `display_name` | Texto no vacío, máximo propuesto 80 | Nombre público editorial | Sí | Backend/admin | Sí, como `displayName` | Claims o instrucciones impropias | MVP |
| `product_area` | Enum/check `stasis`, `health`, `nutrition`, `training`, `wellness` | Área pública vigente | Sí | Backend/admin | Sí, como `area` | No aceptar categorías heredadas | MVP |
| `short_description` | Texto, máximo propuesto 240 | Descripción pública sanitizada | Sí | Backend/admin | Sí, como `shortDescription` | Claims clínicos o filtración interna | MVP |
| `is_published` | Boolean, default `false` | Controlar publicación | Nunca | Backend/admin | No | Publicar no concede acceso | MVP |
| `availability_status` | Enum/check `available`, `unavailable` | Disponibilidad operativa sanitizada | Nunca cruda | Backend/admin | Deriva `accessState` | La razón interna no se expone | MVP |
| `access_tier` | Enum/check `free`, `premium` | Clasificación comercial interna | Nunca cruda | Backend/admin | Deriva `accessState` | No demuestra entitlement | MVP |
| `sort_order` | Entero no negativo | Orden editorial estable | Nunca | Backend/admin | No | Colisiones requieren desempate estable | MVP |
| `created_at` | Timestamp con zona horaria, server-managed | Auditoría técnica | Nunca | Servidor | No | Sin grant cliente | MVP técnico |
| `updated_at` | Timestamp con zona horaria, server-managed | Auditoría técnica | Nunca | Servidor | No | Mecanismo de actualización requiere aprobación | MVP técnico |

Decisiones de modelo:

- no persistir `accessState`: depende del usuario y se recalcula;
- no persistir `isDemo`: demo solo existe en repositorio local;
- no persistir `is_selectable`: se deriva de publicación, disponibilidad,
  tier y entitlement;
- no copiar prompts, jerarquía, configuración o permisos;
- `specialist_id` es único para evitar múltiples identidades públicas
  ambiguas en el MVP;
- cualquier futura necesidad de variantes públicas exige revisión separada.

## Contrato público

Operación futura:

```text
listSelectableSpecialists(pageRequest?, areaFilter?)
  -> SelectableSpecialistsResult
```

Cada elemento contiene exactamente:

```text
id
displayName
area
shortDescription
accessState
isDemo
```

Reglas del contrato:

- no se permiten columnas extra;
- queda prohibido `select=*`;
- `id` siempre representa `specialist_catalog.id`;
- orden estable por área pública, orden editorial server-managed,
  `displayName` e `id`;
- el orden editorial no se expone;
- límite inicial máximo: 20 elementos;
- catálogo vacío es éxito válido;
- filtro opcional exclusivamente por área pública aprobada;
- filtros internos, premium, activo, jerarquía, prompt o IDs internos se
  rechazan;
- si el catálogo supera el límite, se diseñará cursor opaco server-managed;
- demo devuelve datos locales con `isDemo = true` y `accessState = demoOnly`;
- backend bloqueado no llama Supabase ni hace fallback silencioso a demo;
- campos extra, IDs duplicados, enums desconocidos o forma inválida provocan
  violación de contrato.

Errores tipados mínimos:

```text
catalogUnauthenticated
catalogPermissionDenied
catalogBackendBlocked
catalogNetworkFailure
catalogContractViolation
catalogUnexpectedFailure
```

## `accessState`

`accessState` se calcula en frontera backend para cada petición relevante. No
se persiste como verdad global ni lo decide Flutter.

| Estado | Significado | Visible en UI | Permite crear sesión | Quién calcula | Dependencia del usuario | No debe revelar |
| --- | --- | --- | --- | --- | --- | --- |
| `available` | Publicado, disponible y usuario autorizado | Sí | Sí, tras revalidación | Backend | Puede depender de entitlement | Flags internos o motivo de autorización |
| `lockedPremium` | Publicado y disponible, pero requiere entitlement ausente | Sí, si aporta valor UX | No | Backend | Sí | Plan interno, reglas comerciales o datos de membresía |
| `unavailable` | Publicado pero no disponible para iniciar sesión | Opcional, solo con razón genérica | No | Backend | Puede depender del contexto | Motivo operativo, incidentes o configuración |
| `demoOnly` | Elemento exclusivamente local de demostración | Sí, marcado como demo | Solo sesión demo local | Repositorio demo | No | Capacidad real inexistente |

Reglas:

- `is_premium` nunca se expone;
- `is_active` nunca se expone;
- entitlement nunca lo decide Flutter;
- la frontera recalcula `accessState` al listar y al crear sesión;
- `lockedPremium` y `unavailable` nunca permiten crear sesión;
- cualquier estado desconocido falla cerrado;
- una razón visible de indisponibilidad debe ser genérica y sanitizada.

## Categorías visibles

Áreas públicas permitidas:

```text
stasis
health
nutrition
training
wellness
```

Traducción obligatoria:

```text
fisico -> Entrenamiento / training
mental -> Wellness / wellness
```

Reglas:

- `fisico` y `mental` no aparecen como nombres visibles;
- `product_area` solo admite áreas vigentes;
- categorías internas antiguas se migran o traducen en frontera controlada;
- roles internos como `orquestador`, `branch_chief` o `subcategory_chief` no
  se transforman automáticamente en especialistas seleccionables;
- cualquier categoría no reconocida se bloquea.

## Frontera backend recomendada

### Alternativas

| Alternativa | Evaluación |
| --- | --- |
| Edge Function | Candidata para MVP Supabase; requiere contrato, secretos, observabilidad, tests y límites explícitos |
| API propia | Recomendada conceptualmente como frontera estable; puede estar implementada inicialmente sobre infraestructura Supabase |
| RPC | No recomendada como frontera pública inicial por acoplamiento a Postgres y riesgo de privilegios |
| Backend server | Válido en fases posteriores o si aparecen drivers operativos reales; mayor coste inicial |

Recomendación:

```text
API/capa backend controlada
```

La tecnología final permanece pendiente.

Requisitos obligatorios:

1. validar firma, expiración y audiencia del JWT;
2. derivar usuario exclusivamente de sesión validada;
3. no aceptar `user_id`, entitlement, premium, activo, rol o IDs internos;
4. no exponer ni enviar `service_role` a Flutter;
5. preferir identidad backend dedicada y mínimo privilegio;
6. calcular `accessState` con datos mínimos;
7. consultar únicamente columnas allowlist;
8. devolver exactamente el contrato público;
9. no registrar prompts, JWT, secretos, jerarquía ni datos sensibles;
10. usar errores genéricos con correlation ID;
11. registrar auditoría mínima: operación, resultado agregado, latencia,
    versión de contrato y cantidad devuelta;
12. fallar cerrado ante ambigüedad o dependencia no disponible.

Si una implementación futura necesitara `service_role`, exigirá aprobación
separada, aislamiento en secretos del runtime, rotación, threat model y pruebas
de no exposición.

## RLS, grants y rollback futuros

### `public.specialists`

- RLS habilitada;
- deny-all para `anon`, `authenticated` y `PUBLIC`;
- sin grants cliente de tabla o columnas;
- sin acceso directo PostgREST;
- mutación solo por backend/admin futuro aprobado y auditable.

### `public.specialist_catalog`

- RLS habilitada desde su creación;
- deny-all para `anon`, `authenticated` y `PUBLIC`;
- sin políticas permisivas en 2B-III-A;
- sin lectura directa cliente;
- escritura/publicación backend/admin only;
- la frontera backend nunca reenvía filas crudas.

Rollback de 2B-III-A:

1. retirar grants y políticas creados por el paquete, si existieran;
2. eliminar índices y `public.specialist_catalog`;
3. mantener `public.specialists` deny-all;
4. demostrar que anon/authenticated continúan bloqueados;
5. reaplicar y demostrar exclusivamente la superficie aprobada.

## Relación con `chat_sessions`

El contrato futuro será:

```text
createOwnChatSession(selectableSpecialistId)
```

Reglas:

- Flutter no envía `user_id`;
- Flutter no envía `specialists.id`;
- backend deriva owner desde sesión validada;
- backend resuelve `selectableSpecialistId` mediante catálogo;
- backend revalida publicación, disponibilidad y `accessState`;
- backend obtiene `specialists.id` solo internamente;
- backend crea únicamente una sesión propia confirmada;
- no seleccionable, `lockedPremium` o `unavailable` no crean sesión;
- errores no filtran prompts, IDs internos ni configuración;
- 2B-III no desbloquea sesiones reales sin aprobar 2B-IV.

## Subpaquetes futuros

Cada subpaquete requiere aprobación explícita e independiente:

### 2B-III-A — `specialist_catalog` esquema local deny-all

- cerrado formalmente el 2026-06-14;
- crear únicamente esquema, constraints, FK, índices y RLS deny-all;
- no crear políticas permisivas;
- no insertar catálogo;
- demostrar rollback y reaplicación local.

### 2B-III-B — Seed/editorial local controlado

- definir mecanismo controlado de edición;
- crear únicamente fixtures locales aprobados;
- verificar traducción, publicación, orden y ausencia de datos sensibles.

### 2B-III-C — Frontera backend local/efímera

- elegir tecnología;
- implementar contrato, JWT, entitlement, auditoría y errores;
- demostrar que secretos y tabla base no llegan a Flutter.

### 2B-III-D — Contrato Flutter catálogo sin backend real

- implementar modelos/resultados/validación y repositorio demo;
- mantener backend real bloqueado;
- no integrar Supabase ni secretos.

### 2B-IV — `chat_sessions`

- diseñar e implementar por separado RLS, creación, archivado, idempotencia,
  rollback y aislamiento.

### 2B-V — `messages`

- diseñar e implementar por separado propiedad, roles, escritura, adjuntos,
  rollback y aislamiento.

## Plan exacto 2B-III-A — `specialist_catalog` esquema local deny-all

### Estado real y objetivo

La migración futura propuesta se llamará:

```text
00004_create_specialist_catalog_deny_all.sql
```

No existe todavía y no queda autorizada por este plan.

Estado real relevante:

- `public.specialist_catalog` no existe;
- `public.specialists` existe, contiene campos sensibles y ninguna migración
  vigente le habilita RLS o revoca grants cliente;
- no existen políticas aprobadas para `public.specialists`;
- no existe seed ni catálogo real aprobado;
- las migraciones vigentes usan `uuid_generate_v4()`;
- los tests locales existentes usan pgTAP, catálogo PostgreSQL y roles
  `anon`/`authenticated`.

Objetivo futuro de 2B-III-A:

1. crear únicamente la estructura vacía de `public.specialist_catalog`;
2. endurecer `public.specialists` y `public.specialist_catalog` como deny-all;
3. no crear políticas permisivas;
4. no conceder grants cliente;
5. no insertar filas;
6. demostrar localmente esquema, constraints, denegación, rollback y
   reaplicación;
7. no desbloquear backend, Flutter, remoto o datos reales.

### Diseño conceptual de la migración futura

La migración deberá ejecutarse en una única transacción y seguir este orden:

1. iniciar transacción;
2. verificar que `public.specialist_catalog` no existe;
3. verificar y registrar como precondición que no existen políticas
   inesperadas sobre `public.specialists`;
4. crear `public.specialist_catalog` con las columnas y constraints aprobados;
5. crear los índices mínimos;
6. habilitar RLS en `public.specialists`;
7. habilitar RLS en `public.specialist_catalog`;
8. no habilitar `FORCE ROW LEVEL SECURITY`;
9. revocar todos los privilegios de tabla y columna de `PUBLIC`, `anon` y
   `authenticated` sobre ambas tablas;
10. no crear policies, funciones, triggers, vistas, RPC o grants permisivos;
11. comprobar como postcondición que ambas tablas tienen RLS, no tienen FORCE
    RLS, no tienen policies y no tienen grants cliente;
12. confirmar transacción.

Si aparece una policy inesperada, un objeto previo incompatible o un fallo de
postcondición, la migración debe abortar y revertirse completa.

### Columnas definitivas propuestas para 2B-III-A

| Columna | Tipo SQL recomendado | Nullable | Default | Constraints / índice | Visible en contrato | Editable backend/admin futuro | Riesgo y motivo |
| --- | --- | --- | --- | --- | --- | --- | --- |
| `id` | `UUID` | No | `uuid_generate_v4()` | PK | Sí, como ID público opaco | Solo creación controlada | No concede autorización; nunca sustituye revalidación |
| `specialist_id` | `UUID` | No | Ninguno | FK única a `public.specialists(id)` con `ON DELETE RESTRICT`; índice cubierto por UNIQUE | No | Sí, solo backend/admin | Correlaciona identidad interna; nunca sale al cliente |
| `display_name` | `TEXT` | No | Ninguno | `btrim(display_name) = display_name`; longitud `1..80` | Sí | Sí | Contenido editorial; debe evitar vacío, espacios y claims impropios |
| `product_area` | `TEXT` | No | Ninguno | CHECK allowlist pública | Sí, como `area` | Sí | No admite categorías heredadas o roles internos |
| `short_description` | `TEXT` | No | Ninguno | `btrim(short_description) = short_description`; longitud `1..240` | Sí | Sí | Puede contener claims o información interna |
| `is_published` | `BOOLEAN` | No | `false` | Ninguno adicional | No | Sí | Publicar no concede entitlement ni acceso |
| `availability_status` | `TEXT` | No | `'unavailable'` | CHECK allowlist | No cruda | Sí | La razón operativa no debe exponerse |
| `access_tier` | `TEXT` | No | `'free'` | CHECK allowlist | No cruda | Sí | No demuestra entitlement; solo entrada para cálculo |
| `sort_order` | `INTEGER` | No | `0` | CHECK `sort_order >= 0`; índice parcial de listado | No | Sí | Colisiones se resuelven con nombre e ID |
| `created_at` | `TIMESTAMPTZ` | No | `now()` | Server-managed | No | No directamente | Auditoría técnica; sin grant cliente |
| `updated_at` | `TIMESTAMPTZ` | No | `now()` | Server-managed; sin trigger en 2B-III-A | No | No directamente en 2B-III-A | No se prometerá actualización automática todavía |

Índices mínimos futuros:

- PK de `id`;
- UNIQUE de `specialist_id`;
- índice parcial de listado sobre
  `(product_area, sort_order, display_name, id)` cuando
  `is_published = true`.

No se propone índice para `access_tier` o `availability_status` hasta disponer
de consultas reales y evidencia de necesidad.

### Constraints definitivos propuestos

#### `product_area`

Valores almacenados:

```text
stasis
health
nutrition
training
wellness
```

Se eligen los enums públicos ingleses ya aprobados para el contrato. No se
almacenan `salud`, `nutricion`, `entrenamiento`, `fisico` o `mental` en esta
tabla. La traducción visible se resuelve en UI/i18n, no en autorización.

#### `availability_status`

Valores almacenados:

```text
available
unavailable
```

`demo_only` se rechaza porque demo vive exclusivamente en repositorio local y
no debe entrar en Supabase.

#### `access_tier`

Valores almacenados:

```text
free
premium
```

`internal` se rechaza en 2B-III-A porque un especialista interno no debe tener
entrada en el catálogo sanitizado. `access_tier` nunca se expone: la frontera
lo traduce a `accessState` tras validar entitlement.

#### Integridad adicional

- `specialist_id` único evita dos IDs públicos para el mismo agente en MVP;
- `ON DELETE RESTRICT` impide borrar accidentalmente un especialista interno
  todavía referenciado;
- nombres y descripciones deben estar recortados y dentro de longitud;
- no se permite `NULL` en ninguna columna del MVP;
- `sort_order` no puede ser negativo;
- `updated_at` no usa trigger todavía;
- no se añade constraint que intente calcular `accessState`.

### Seguridad inicial deny-all

Estado esperado después de aplicar 2B-III-A localmente:

- `public.specialists`: RLS habilitada, FORCE RLS deshabilitado, cero policies
  y cero privilegios cliente;
- `public.specialist_catalog`: RLS habilitada, FORCE RLS deshabilitado, cero
  policies, cero privilegios cliente y cero filas;
- `anon`: no puede `SELECT`, `INSERT`, `UPDATE` o `DELETE`;
- `authenticated`: no puede `SELECT`, `INSERT`, `UPDATE` o `DELETE`;
- no existe acceso directo mediante PostgREST;
- Flutter no cambia y no conoce la tabla;
- ningún rol o secreto nuevo llega al cliente;
- solo el harness local privilegiado puede preparar fixtures transaccionales
  para comprobar constraints y FK;
- el uso privilegiado del harness no prueba acceso cliente ni autoriza
  backend real.

2B-III-A debe endurecer también `public.specialists`, porque actualmente no
existe una migración que demuestre su bloqueo. No modifica sus columnas, datos
o relaciones.

### Tests implementados para 2B-III-A

El harness implementado es local/efímero y no utiliza remoto ni datos reales.
Demuestra como mínimo:

#### Esquema

- existe `public.specialist_catalog`;
- existen exactamente las once columnas aprobadas con tipos, nullability y
  defaults correctos;
- PK, FK, UNIQUE y `ON DELETE RESTRICT` son correctos;
- existe únicamente el índice parcial adicional aprobado;
- la tabla está vacía tras migración/reset sin seed;
- no existen vistas, funciones, RPC o triggers creados por 2B-III-A.

#### Constraints

- acepta cada `product_area` aprobado;
- rechaza `fisico`, `mental`, valores españoles, roles internos y valores
  desconocidos;
- acepta `available`/`unavailable` y rechaza `demo_only`;
- acepta `free`/`premium` y rechaza `internal`;
- rechaza nombre/descripción vacíos, con espacios exteriores o demasiado
  largos;
- rechaza `sort_order` negativo;
- rechaza `specialist_id` duplicado;
- rechaza FK inexistente;
- `ON DELETE RESTRICT` impide borrar el especialista referenciado.

#### RLS y grants

- ambas tablas tienen RLS habilitada;
- ambas tablas tienen FORCE RLS deshabilitado;
- ambas tablas tienen cero policies;
- `PUBLIC`, `anon` y `authenticated` no poseen privilegios amplios ni de
  columna;
- anon y authenticated no pueden leer, insertar, actualizar o borrar;
- `SELECT *` falla;
- ninguna otra tabla, policy o grant se modifica;
- `public.specialists` conserva columnas, constraints y filas intactas.

#### Operación y seguridad

- fixtures se crean únicamente con rol privilegiado local dentro de
  transacción revertida;
- ningún test usa `service_role` como actor cliente;
- rollback elimina `specialist_catalog` y preserva el bloqueo de
  `public.specialists`;
- reaplicación recrea exactamente la tabla deny-all;
- no existe project ref, token, credencial o conexión remota durante la
  ejecución.

### Rollback local verificado

El rollback autorizado y verificado para entorno local/efímero descartable es
deliberadamente seguro y asimétrico:

1. verificar que no existen filas reales ni dependencias externas;
2. verificar que `public.specialist_catalog` no tiene policies o grants
   inesperados;
3. eliminar el índice parcial y la tabla sin usar `CASCADE`;
4. comprobar que `public.specialist_catalog` ya no existe;
5. conservar RLS habilitada y grants cliente revocados en
   `public.specialists`;
6. comprobar que las columnas, constraints, relaciones y filas de
   `public.specialists` no cambiaron;
7. reaplicar la migración futura;
8. repetir todos los tests deny-all.

No se propone deshabilitar RLS ni restaurar grants cliente en
`public.specialists`, porque hacerlo reabriría una tabla sensible. Si se
exigiera volver exactamente al estado técnico inseguro anterior, requeriría
una decisión y aprobación separadas.

### Criterios para autorizar implementación de 2B-III-A

- aprobar nombre de migración y alcance transaccional;
- aprobar enums ingleses de `product_area`;
- aprobar exclusión de `demo_only` e `internal`;
- aprobar columnas, defaults, constraints e índices;
- aprobar endurecimiento deny-all de `public.specialists`;
- confirmar que “no modificar `public.specialists`” significa preservar sus
  columnas, datos y relaciones, permitiendo únicamente endurecer RLS/grants;
- aprobar rollback seguro asimétrico;
- aprobar matriz exacta de tests locales;
- confirmar que no habrá seed, backend, Flutter, remoto ni datos reales;
- autorizar explícitamente creación de SQL, migración y tests locales.

## Tests futuros mínimos

- `public.specialists` no expone ni permite mutar nada al cliente;
- `public.specialist_catalog` nace deny-all;
- no se devuelve `prompt_template`, `branch_id`, `chief_id`, `created_at`,
  `is_premium` o `is_active`;
- respuesta pública contiene exactamente seis campos;
- no se permite `select=*`;
- categorías antiguas se traducen o bloquean;
- especialistas internos, no publicados o indisponibles no se habilitan;
- `accessState` se deriva correctamente por usuario;
- `lockedPremium` y `unavailable` no permiten crear sesión;
- `createOwnChatSession` no acepta `user_id` ni IDs internos;
- demo no llama Supabase;
- backend bloqueado no llama Supabase;
- logs no contienen prompts, JWT, secretos o datos sensibles;
- rollback vuelve a bloqueo total.

## Riesgos y consecuencias

### Riesgos

- divergencia entre catálogo sanitizado y especialista interno;
- frontera backend excesivamente privilegiada;
- exposición por logs, errores o respuestas;
- entitlement incorrecto o desactualizado;
- confundir especialistas conceptuales con agentes reales;
- añadir complejidad antes de validar el modelo comercial.

### Consecuencias positivas

- minimiza exposición de prompts y jerarquía;
- desacopla contrato público y agente interno;
- centraliza autorización y `accessState`;
- prepara validación segura de sesiones;
- permite evolución editorial sin abrir configuración sensible.

### Costes

- añade una fuente de datos y sincronización explícita;
- exige frontera backend, pruebas y observabilidad;
- requiere gobierno editorial y comercial;
- cada subpaquete necesita revisión independiente.

## Fuera de alcance

- SQL, migraciones o tablas adicionales a la migración local 2B-III-A;
- vistas, RPC o Edge Functions;
- implementación de backend o Flutter;
- seeds o filas reales;
- conexión remota o credenciales;
- Auth real, producción o datos reales;
- `chat_sessions`, `messages`, agentes reales, prompts reales, IA o Stasis
  Engine.

## Condiciones vigentes tras la aprobación conceptual

- separación de IDs aprobada conceptualmente;
- `public.specialist_catalog` backend-only aprobado conceptualmente;
- API/capa backend controlada aprobada como dirección, sin tecnología final
  decidida;
- contrato público y estados aprobados conceptualmente;
- subpaquetes y gates separados aprobados conceptualmente;
- 2B-III-A está implementado, verificado y cerrado formalmente solo en local;
  no expone catálogo ni autoriza los siguientes subpaquetes.

## Resultado local del micro-paquete 2B-III-A

Fecha de implementación y verificación: 2026-06-13.

### Implementado

- Se creó la migración transaccional
  `00004_create_specialist_catalog_deny_all.sql`.
- Se creó `public.specialist_catalog` vacío con las once columnas, defaults,
  constraints, PK, FK `ON DELETE RESTRICT`, unicidad e índice parcial
  aprobados.
- Se habilitó RLS sin `FORCE ROW LEVEL SECURITY` en
  `public.specialists` y `public.specialist_catalog`.
- Se revocaron todos los privilegios de tabla de `PUBLIC`, `anon` y
  `authenticated` sobre ambas tablas.
- No se crearon policies permisivas, vistas, RPC, funciones, triggers, seeds
  ni filas de catálogo.
- `public.specialists` conserva sus columnas y contenido estructural interno,
  incluido `prompt_template`; solo se endurecieron RLS y grants.

### Evidencia verificada

- `supabase db reset --local --no-seed` aplicó `00001`–`00004`.
- El harness 2B-III-A superó 56/56 pruebas de esquema, seguridad e integridad.
- Los harnesses previos 2B-I y 2B-II continúan pasando.
- `supabase test db --local` superó 100/100 pruebas acumuladas.
- El rollback local eliminó `specialist_catalog` sin `CASCADE` y conservó
  `specialists` con RLS habilitada, FORCE deshabilitado, cero policies y cero
  lectura para `anon`/`authenticated`.
- La reaplicación mediante reset recreó el catálogo deny-all y volvió a superar
  las pruebas.
- La ejecución utilizó únicamente URLs `127.0.0.1`, contenedores Docker locales
  y credenciales efímeras generadas por Supabase CLI.

### Gates que permanecen cerrados

- No existe acceso cliente al catálogo ni a `specialists`.
- No existe API/capa backend, adapter Flutter, vista, RPC o Edge Function.
- No existe publicación, seed, catálogo real, entitlement, `accessState` ni
  creación de sesiones.
- Supabase remoto, backend real, autenticación real, producción y datos reales
  permanecen bloqueados.

### Cierre formal

2B-III-A queda cerrado formalmente el 2026-06-14 con la evidencia local
registrada. Este cierre acepta el esquema deny-all y su rollback, pero no
autoriza poblar tablas, exponer datos ni implementar otro subpaquete.

## Plan exacto 2B-III-B — Seed/editorial local controlado

### Objetivo y límite

2B-III-B debe validar localmente un catálogo editorial mínimo sin convertirlo
en catálogo real, sin exponerlo al cliente y sin inventar agentes productivos.
El paquete solo podrá poblar datos ficticios locales si existe una autorización
posterior explícita.

### Catálogo editorial mínimo conceptual

| Entrada conceptual | `display_name` | `product_area` | `short_description` provisional | `is_published` | `availability_status` | `access_tier` | `sort_order` | Dependencia interna |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Stasis | `Stasis` | `stasis` | Coordinación general y orientación transversal dentro de Stasisly. | `false` | `unavailable` | `free` | `10` | Requiere especialista interno futuro; no crearlo aún |
| Salud general | `Salud general` | `health` | Orientación general de bienestar y hábitos, sin diagnóstico médico. | `false` | `unavailable` | `free` | `20` | Requiere especialista interno futuro; no crearlo aún |
| Nutrición | `Nutrición` | `nutrition` | Orientación general sobre hábitos alimentarios, sin prescripción clínica. | `false` | `unavailable` | `free` | `30` | Requiere especialista interno futuro; no crearlo aún |
| Entrenamiento | `Entrenamiento` | `training` | Orientación general para planificación de actividad física segura. | `false` | `unavailable` | `free` | `40` | Requiere especialista interno futuro; no crearlo aún |
| Wellness | `Wellness` | `wellness` | Orientación general para equilibrio, autocuidado y bienestar cotidiano. | `false` | `unavailable` | `free` | `50` | Requiere especialista interno futuro; no crearlo aún |
| Sueño y estrés | `Sueño y estrés` | `wellness` | Orientación general sobre descanso y gestión cotidiana del estrés. | `false` | `unavailable` | `free` | `60` | Requiere especialista interno futuro; no crearlo aún |

Decisiones del plan:

- `Stasis` utiliza `product_area = stasis`.
- `Sueño y estrés` pertenece a `wellness`; no crea una rama principal nueva.
- Todas las entradas nacen `is_published = false` y
  `availability_status = unavailable`.
- Todas permanecen `free` solo como clasificación editorial provisional; esto
  no autoriza acceso ni define monetización.
- `specialist_id` nunca se inventa ni se expone. Debe referenciar una fila
  interna válida cuando esa dependencia sea aprobada.
- Los textos son provisionales, no médicos y no constituyen contenido
  editorial real.

### Dependencia con `public.specialists`

Opciones analizadas:

| Opción | Evaluación | Riesgo principal | Decisión |
| --- | --- | --- | --- |
| A. Insertar especialistas internos mínimos | Haría posible un seed persistente | Inventaría identidad, prompts y configuración interna no aprobados | No recomendada |
| B. Usar especialistas existentes | Correcta solo si existen filas coherentes y aprobadas | Acoplamiento a estado local no garantizado | Pendiente de auditoría futura |
| C. No insertar nada hasta rediseñar `specialists` | Máxima seguridad | No permite validar todavía el catálogo poblado | Alternativa válida |
| D. Fixtures locales solo para tests | Permite validar FK, orden y catálogo sin persistencia | Puede confundirse con seed si no se separa estrictamente | **Recomendada** |

Se recomienda la opción D. Una futura implementación mínima debe crear
especialistas internos y entradas de catálogo exclusivamente como fixtures
ficticios dentro de transacciones revertidas. No debe crear seed persistente.
El seed editorial queda bloqueado hasta aprobar el rediseño o contrato mínimo
de `public.specialists`.

### Seed, fixtures y datos reales

| Categoría | Definición | Estado en 2B-III-B |
| --- | --- | --- |
| Seed local | Datos persistentes recreados por reset local para uso manual o demo | Bloqueado hasta aprobación separada |
| Fixtures de test | Datos ficticios creados dentro de tests y revertidos al finalizar | Recomendado para futura implementación |
| Datos editoriales reales | Nombres, descripciones, disponibilidad y clasificación aprobados para producto | Prohibidos |
| Datos remotos | Cualquier dato insertado o migrado en Supabase remoto | Prohibidos |

Los fixtures no prueban que exista catálogo real, no autorizan demo visible y
no deben sobrevivir al test.

### Política de prompts

- 2B-III-B no crea prompts reales ni agentes reales.
- Si una futura prueba necesita satisfacer `specialists.prompt_template`, debe
  usar un placeholder JSON seguro, no médico, no definitivo y marcado como
  `test_only`/`non_production`.
- El placeholder solo puede existir localmente dentro de una transacción de
  test revertida.
- Ningún prompt, placeholder, `specialist_id`, jerarquía o configuración
  interna puede exponerse al cliente, logs públicos o respuestas futuras.

### Tests futuros propuestos

Una implementación futura de fixtures 2B-III-B debe demostrar:

- se crean exactamente las seis entradas conceptuales aprobadas;
- `Stasis` usa `stasis` y `Sueño y estrés` usa `wellness`;
- solo aparecen `product_area` permitidos;
- no existen `demo_only`, `internal`, datos médicos ni prompts reales;
- cada `specialist_id` referencia un fixture interno válido;
- los nombres, textos y orden son únicos y reproducibles;
- todas las entradas permanecen no publicadas e indisponibles;
- `specialist_id` y `prompt_template` no forman parte de ninguna proyección
  cliente;
- ambas tablas continúan deny-all para `anon` y `authenticated`;
- los fixtures se revierten y dejan el catálogo vacío;
- el rollback no debilita `public.specialists`;
- reaplicación de fixtures produce el mismo resultado;
- no existe vínculo, referencia, token o conexión a remoto.

### Gates antes de implementar 2B-III-B

Se requiere aprobación explícita de:

1. usar únicamente fixtures locales transaccionales o permitir seed local;
2. permitir fixtures internos ficticios en `public.specialists`;
3. permitir placeholders seguros `test_only` para satisfacer el esquema;
4. confirmar que el catálogo sigue siendo conceptual, no real ni demo visible;
5. confirmar `Sueño y estrés -> wellness`;
6. confirmar `Stasis -> stasis`;
7. aprobar exactamente las seis entradas, textos provisionales y orden;
8. aprobar archivos permitidos, rollback y matriz de tests.

Los gates para fixtures transaccionales fueron aprobados e implementados. El
seed persistente, datos editoriales reales, backend, acceso cliente y remoto
siguen sin autorizar.

## Resultado local del micro-paquete 2B-III-B

Fecha de implementación y verificación: 2026-06-14.

### Implementado

- Se creó únicamente el harness
  `2b_iii_b_specialist_catalog_fixtures_test.sql`.
- El harness crea seis especialistas internos ficticios y seis entradas
  conceptuales dentro de una transacción revertida.
- Todos los `prompt_template` fixture usan un placeholder `test_only`, no
  médico y no apto para producción.
- Las seis entradas permanecen no publicadas, indisponibles y con tier `free`.
- `Stasis` usa `stasis`; `Sueño y estrés` usa `wellness`.
- No se creó seed persistente, migración, tabla, policy, grant o dato real.

### Evidencia verificada

- El harness 2B-III-B superó 40/40 pruebas.
- La suite SQL local acumulada superó 140/140 pruebas.
- Tras cada rollback transaccional quedan cero filas de catálogo y cero
  especialistas fixture.
- Tras reset y reaplicación vuelven a quedar cero fixtures persistentes.
- `public.specialists` y `public.specialist_catalog` conservan RLS deny-all,
  cero policies y cero privilegios cliente.
- Solo se utilizaron Docker, Supabase CLI y PostgreSQL locales en
  `127.0.0.1`; no se vinculó ni consultó remoto.

### Riesgos residuales y gates cerrados

- Los fixtures no constituyen catálogo real, seed, demo visible ni contenido
  editorial aprobado.
- La tabla interna conserva categorías heredadas necesarias para satisfacer su
  constraint; esto no aprueba su modelo para producción.
- No existe frontera backend ni proyección pública que pueda demostrar
  sanitización de una respuesta real.
- En el momento de cerrar 2B-III-B, 2B-III-C/D, seed persistente,
  especialistas reales, prompts reales, acceso cliente, backend y remoto
  permanecían bloqueados. C fue autorizado, implementado y cerrado después;
  los demás elementos continúan bloqueados.

### Cierre formal de 2B-III-B

2B-III-B queda cerrado formalmente el 2026-06-14. El cierre acepta únicamente
la capacidad de validar fixtures locales transaccionales y la evidencia
140/140. No autoriza seed persistente, catálogo real, identidad técnica
privilegiada, frontera backend, acceso cliente ni remoto.

## Plan exacto 2B-III-C — Frontera backend local/efímera

### Objetivo

Diseñar una primera implementación local/efímera de la API controlada que
devuelva exclusivamente el contrato público sanitizado del catálogo. La
frontera debe validar identidad, derivar usuario y acceso server-side, impedir
consultas directas desde Flutter y fallar cerrada ante cualquier configuración
incompleta.

### Opciones evaluadas

| Opción | Ventajas | Riesgos y costes | Evaluación |
| --- | --- | --- | --- |
| A. Edge Function local | Encaja con Supabase local y ADR-001; permite JWT, contrato HTTP, secretos server-side, logs y tests de integración; puede evolucionar como implementación de la API propia | Para leer tablas deny-all necesita identidad técnica privilegiada local aprobada; riesgo de logs inseguros, configuración remota accidental y lógica dispersa | **Recomendada condicionalmente para el primer MVP local/efímero** |
| B. RPC local | Forma de salida estricta y proximidad a datos; fácil de probar con SQL | Riesgo alto de `SECURITY DEFINER`, grants y `search_path`; acoplamiento fuerte a Postgres; peor lugar para errores HTTP, auditoría y `accessState` dependiente de sesión/entitlement | No recomendada como frontera pública inicial |
| C. Backend/API propia local separada | Máxima separación, control de secretos, testabilidad y compatibilidad futura con Stasis Engine | Mayor coste operativo y de implementación antes de validar el contrato; requiere runtime, despliegue y gestión de secretos propios | Dirección futura válida; prematura para este micro-paquete |
| D. Aplazar frontera | Mantiene superficie mínima y evita identidad privilegiada prematura | No demuestra sanitización real, JWT, errores, logs ni derivación de acceso; 2B-III-D y 2B-IV seguirían sin una frontera validada | Alternativa segura si no se aprueba identidad técnica local |

### Opción recomendada

Se recomienda **Opción A: Edge Function exclusivamente local/efímera**, tratada
como primera implementación pequeña de la API propia/capa backend controlada,
no como acceso directo de Flutter a Supabase.

La recomendación está condicionada a un gate separado:

- autorizar explícitamente una identidad técnica privilegiada solo dentro del
  runtime local de la función;
- aislarla de Flutter, repositorio, logs y respuestas;
- demostrar que no existe project ref remoto ni destino configurable remoto;
- mantener la función deshabilitada o fallando cerrada cuando falte JWT,
  secreto local o configuración aprobada.

Sin aprobación de ese gate, debe aplicarse la opción D y no implementar
frontera todavía. No se recomienda intentar evitar el gate mediante RPC
`SECURITY DEFINER`, grants permisivos o acceso directo a tablas.

### Flujo futuro de confianza

1. El cliente envía un JWT local de usuario al endpoint local aprobado.
2. La frontera valida firma, expiración, audiencia y sujeto; nunca acepta un
   `user_id` proporcionado en query o body.
3. La frontera deriva el usuario exclusivamente desde el JWT validado.
4. Una identidad técnica local aislada consulta únicamente los campos internos
   mínimos necesarios de `specialist_catalog`; consulta entitlement solo cuando
   exista un modelo aprobado.
5. La frontera calcula `accessState`, elimina campos internos y valida el
   contrato de salida.
6. La respuesta contiene exactamente seis campos por elemento.
7. Errores de identidad, configuración, datos o contrato fallan cerrados y no
   filtran existencia, prompts, IDs internos o secretos.

### Contrato público exacto `listSelectableSpecialists()`

Cada elemento devolverá exactamente:

```text
id
displayName
area
shortDescription
accessState
isDemo
```

Reglas:

- `id`: exclusivamente `specialist_catalog.id`; nunca `specialists.id` ni
  `specialist_id`.
- `displayName`, `area` y `shortDescription`: campos sanitizados.
- `accessState`: derivado server-side, nunca persistido ni decidido en Flutter.
- `isDemo`: derivado por entorno/contrato; en frontera backend local real será
  `false`; los datos demo locales de Flutter usan `true` sin llamar backend.
- orden estable: `product_area`, `sort_order`, `display_name`, `id`;
- filtro opcional solo por `area` permitida;
- límite inicial máximo: 50 elementos; sin paginación implícita no documentada;
- catálogo vacío: éxito con lista vacía, no fallback demo silencioso;
- backend bloqueado o configuración incompleta: error cerrado explícito;
- JWT ausente/inválido: denegación genérica;
- cualquier columna extra o campo ausente invalida la respuesta;
- nunca se devuelve una fila cruda ni se admite `select=*`.

### Cálculo de `accessState`

Precedencia propuesta:

1. Si la petición usa exclusivamente repositorio demo local, no llama a la
   frontera y produce `demoOnly`.
2. Si `is_published = false` o `availability_status = unavailable`, produce
   `unavailable`.
3. Si `access_tier = premium` y no existe entitlement vigente verificado para
   el usuario derivado, produce `lockedPremium`.
4. Si está publicado, disponible y el tier/entitlement permite acceso, produce
   `available`.
5. Ante ausencia, conflicto o error en datos necesarios, produce error cerrado
   o `unavailable` según contrato aprobado; nunca asume acceso.

Reglas obligatorias:

- no persistir `accessState`;
- no devolver `access_tier`, `availability_status` ni entitlement;
- Flutter solo representa el estado recibido;
- la futura creación de sesión debe recalcular el mismo estado y no confiar en
  el estado mostrado anteriormente.

### Seguridad, secretos y auditoría

- ningún secreto, identidad técnica o `service_role` llega a Flutter;
- ningún token, clave o credencial se versiona;
- no se usa remoto ni configuración capaz de seleccionar remoto durante el
  micro-paquete local;
- `service_role` solo podrá usarse tras aprobación explícita, aislado en
  runtime local y nunca como actor cliente;
- logs permitidos: request ID, resultado genérico, latencia y código de error;
- logs prohibidos: JWT, secretos, prompts, IDs internos, payloads crudos,
  entitlement y datos sensibles;
- errores externos genéricos; detalle técnico solo en canal local controlado;
- auditoría futura mínima: request ID, sujeto derivado pseudonimizado, versión
  de contrato, decisión agregada y resultado, sin contenido sensible.

### Tests futuros propuestos

#### Contrato

- respuesta contiene exactamente seis campos;
- orden, filtro y límite son deterministas;
- catálogo vacío devuelve lista vacía;
- campos extra, ausentes o tipos inválidos fallan;
- no aparecen `specialist_id`, `specialists.id`, `prompt_template`,
  `branch_id`, `chief_id`, `is_premium`, `is_active`, `created_at`,
  `updated_at`, `access_tier` o `availability_status`.

#### Identidad y acceso

- sin JWT, JWT inválido, expirado o con audiencia incorrecta se deniega;
- el usuario se deriva del JWT y no de parámetros cliente;
- available, lockedPremium y unavailable se derivan conforme a precedencia;
- demoOnly solo procede del repositorio demo y no llama backend;
- backend/configuración bloqueada no consulta Supabase y falla cerrada;
- futura creación de sesión revalidará acceso de forma independiente.

#### Seguridad operativa

- secreto local nunca aparece en respuesta, Flutter, repo o logs;
- prompts, IDs internos y datos sensibles nunca aparecen en logs;
- la función solo usa URLs locales y no puede resolver remoto;
- errores no filtran existencia o estado interno;
- tablas permanecen deny-all para actores cliente;
- ausencia de identidad técnica local aprobada impide arrancar o consultar.

### Relación con 2B-III-D y 2B-IV

- 2B-III-C proporcionaría el contrato backend contra el que 2B-III-D podría
  validar modelos, parseo estricto y estados Flutter manteniendo backend real
  bloqueado por defecto.
- 2B-III-C demostraría la resolución segura
  `specialist_catalog.id -> specialists.id`, necesaria para diseñar 2B-IV.
- 2B-IV deberá revalidar identidad y `accessState` al crear sesión; no puede
  reutilizar ciegamente una decisión de listado.
- Ninguno de estos beneficios autoriza 2B-III-D ni 2B-IV. Ambos permanecen
  bloqueados hasta aprobación independiente.

### Gates antes de implementar 2B-III-C

1. aprobar Edge Function local como primera implementación de la API propia;
2. aprobar o rechazar identidad técnica privilegiada exclusivamente local;
3. definir cómo se impide cualquier destino remoto;
4. aprobar validación exacta de JWT local;
5. aprobar contrato, orden, filtro, límite y errores;
6. aprobar precedencia exacta de `accessState`;
7. aprobar política de logs y auditoría;
8. aprobar archivos permitidos, tests, rollback y limpieza;
9. confirmar que no habrá Flutter, seed, chats, mensajes ni datos reales.

Hasta resolver estos gates, 2B-III-C no autoriza Edge Function, secretos,
`service_role`, API, SQL, RPC, vistas, backend, tests de implementación ni
conexión alguna.

### Aprobación documental de 2B-III-C

El diseño exacto de 2B-III-C queda aprobado documentalmente el 2026-06-14:

- la frontera candidata para el MVP es una Edge Function exclusivamente
  local/efímera;
- Flutter no accede directamente a `public.specialists` ni a
  `public.specialist_catalog`;
- la respuesta futura contiene exactamente `id`, `displayName`, `area`,
  `shortDescription`, `accessState` e `isDemo`;
- `accessState` se calcula server-side y todo estado ambiguo falla cerrado;
- no existe fallback demo silencioso;
- prompts, IDs internos y configuración sensible no se exponen.

Esta aprobación no autoriza implementar la Edge Function. 2B-III-C1 y su
identidad técnica privilegiada exclusivamente local fueron aprobados
documentalmente después, bajo condiciones estrictas; la implementación de la
función todavía requiere autorización separada. 2B-III-D y 2B-IV continúan
bloqueados.

## Plan exacto 2B-III-C1 — Identidad técnica privilegiada local

### Problema a resolver

`public.specialists` y `public.specialist_catalog` permanecen deny-all para
actores cliente. La futura Edge Function necesita leer un conjunto interno
mínimo para construir la proyección sanitizada, pero no puede convertir esa
necesidad en acceso directo desde Flutter, una excepción RLS cliente o una
capacidad remota accidental.

2B-III-C1 define exclusivamente cómo aislar, auditar, probar y revocar una
identidad técnica privilegiada local. No crea identidad, secreto, función,
SQL, migración ni conexión.

### Opciones de identidad técnica evaluadas

| Opción | Ventajas | Riesgos y complejidad | Evaluación |
| --- | --- | --- | --- |
| A. `service_role` local | Compatible con Supabase local y Edge Functions; permite validar pronto contrato, JWT y sanitización sin abrir grants cliente | Omite RLS; una filtración concede privilegios amplios; exige aislamiento, anti-remoto, logs seguros y revocación | **Recomendada condicionalmente solo para el experimento local/efímero** |
| B. Rol PostgreSQL específico local | Mejor mínimo privilegio; grants exactos y revocación granular | Requiere SQL, migraciones, gestión de credenciales y compatibilidad operativa; mayor riesgo de drift antes de validar la frontera | Dirección futura preferible, pero prematura para C1 |
| C. RPC `SECURITY DEFINER` | Puede encapsular consulta y forma de salida cerca de los datos | Riesgo de escalada, `search_path`, ownership y privilegios excesivos; auditoría más difícil y fuerte acoplamiento a PostgreSQL | No recomendada |
| D. Aplazar frontera | No introduce secreto privilegiado ni nueva superficie | No valida todavía JWT, sanitización, contrato ni errores de frontera | Alternativa obligatoria si no se aprueba A |

### Opción recomendada y límites

Se recomienda aprobar posteriormente la opción A únicamente para una futura
Edge Function local/efímera y solo como capacidad de prueba revocable. Es
aceptable en local porque el entorno, URL, secreto y datos pueden ser
efímeros, no reales y destruidos tras el harness. No es aceptable para remoto
o producción porque `service_role` omite RLS y su compromiso tendría un radio
de impacto excesivo.

Condiciones obligatorias:

1. el secreto solo existe en el runtime local de la función;
2. ninguna ruta de configuración puede seleccionar Supabase remoto;
3. la función exige y valida JWT de usuario antes de consultar;
4. la identidad privilegiada solo consulta columnas internas allowlist;
5. la respuesta se valida contra el contrato exacto de seis campos;
6. ausencia de secreto, JWT o configuración aprobada falla cerrada;
7. logs, errores y respuestas nunca contienen secreto, JWT o filas crudas;
8. el secreto local puede revocarse destruyendo o reiniciando el entorno
   efímero;
9. la auditoría demuestra origen local, operación, resultado agregado y
   versión del contrato sin registrar contenido sensible;
10. si no puede demostrarse aislamiento anti-remoto, se aplica la opción D.

El uso futuro condicional de `service_role` exclusivamente local, efímero y
aislado queda aprobado documentalmente el 2026-06-14. Esta aprobación no
autoriza todavía crear o ejecutar la Edge Function, guardar secretos ni
conectar ningún entorno remoto.

### Reglas obligatorias de secretos

- Ningún secreto en Flutter, repositorio, documentación o tests versionados.
- Ningún secreto, JWT o credencial en logs, errores, snapshots o respuestas.
- `.env` real debe permanecer no versionado y no se modifica en C1.
- Un futuro `.env.example` solo podrá contener nombres y placeholders
  inequívocamente falsos; requiere aprobación previa.
- Uso exclusivamente local, efímero y explícito; remoto está prohibido.
- No copiar secretos a comandos, argumentos, capturas o informes persistentes.
- El runtime debe negarse a arrancar o consultar si falta el secreto local.
- La limpieza y revocación del entorno forman parte del rollback obligatorio.

### Validación JWT futura

La futura frontera deberá:

1. exigir cabecera de autorización;
2. rechazar JWT ausente, inválido, expirado o con audiencia/issuer no
   aprobados;
3. derivar el identificador del usuario exclusivamente del `sub` validado;
4. no aceptar `user_id` en query, body, headers auxiliares o metadatos;
5. no aceptar entitlement, rol, `accessState` ni autorización desde cliente;
6. validar identidad humana antes de usar la identidad técnica;
7. responder con errores genéricos y fallar cerrado si la validación no puede
   completarse.

La identidad técnica autoriza a la función a consultar datos internos; no
autoriza al usuario. La decisión de producto se calcula después de validar al
usuario y nunca se deriva de conocer un ID público.

### Threat model mínimo

| Amenaza | Impacto | Mitigación obligatoria |
| --- | --- | --- |
| Filtración de `service_role` | Bypass amplio de RLS | Runtime local aislado, secreto efímero, no versionado, revocación y pruebas de no exposición |
| Logs con secretos o JWT | Compromiso de identidad o infraestructura | Allowlist de logs, redacción, prohibición de payloads y pruebas sobre salida |
| Llamada remota accidental | Escritura/lectura fuera del entorno aprobado | URLs locales allowlist, ausencia de project ref remoto y test anti-remoto |
| Bypass de RLS sin controles de aplicación | Exposición interna masiva | Consulta allowlist mínima, JWT previo, sanitización estricta y fallo cerrado |
| Respuesta con columnas internas | Filtración de diseño o autorización | DTO de salida exacto, rechazo de campos extra y tests de contrato |
| Exposición de `prompt_template` | Filtración de configuración sensible | No seleccionarlo, no mapearlo, no loguearlo y test negativo explícito |
| Escalada de privilegios | Usuario controla actor, entitlement o decisión | Derivar usuario del JWT; ignorar `user_id`, rol, entitlement y estado cliente |
| Fallback demo silencioso | Datos ficticios presentados como reales | Error explícito; demo nunca llama la función |
| Usar ID público como autorización | Acceso indebido por enumeración | Revalidar identidad, publicación, disponibilidad y entitlement server-side |

### Tests futuros propuestos

Una implementación futura de C1/C deberá demostrar:

- no hay secretos versionados ni valores reales en `.env.example`;
- la función rechaza ausencia de JWT y JWT inválido;
- `user_id`, entitlement y `accessState` enviados por cliente se ignoran o
  rechazan;
- no devuelve `specialist_id`, `prompt_template` ni columnas internas;
- respuesta y logs no contienen secreto, JWT, prompts ni filas crudas;
- ninguna URL, project ref o conexión puede alcanzar remoto;
- falta de secreto local provoca fallo cerrado antes de consultar;
- demo no llama Edge Function;
- backend bloqueado no llama Edge Function;
- las tablas siguen deny-all para actores cliente;
- limpieza/rollback elimina el secreto y deja la frontera no operativa.

### Gates antes de implementar Edge Function

Se requiere aprobación explícita e independiente de:

1. opción de identidad técnica local;
2. ubicación y ciclo de vida del secreto local;
3. contenido permitido de un eventual `.env.example`;
4. política exacta de logs y redacción;
5. contrato de errores externos e internos;
6. harness exclusivamente local y efímero;
7. pruebas anti-remoto y evidencia esperada;
8. rollback, revocación y limpieza;
9. archivos permitidos y prohibidos para implementación;
10. confirmación de que 2B-III-D, 2B-IV, Flutter, remoto y datos reales siguen
    bloqueados.

Los gates de identidad técnica, aislamiento local, secreto no versionado,
anti-remoto, logs seguros, fallo cerrado y limpieza quedan aprobados
documentalmente. La futura implementación deberá respetarlos íntegramente.
Continúan sin autorizar Edge Function, secreto persistido, `.env` versionado,
rol PostgreSQL, RPC, SQL, backend permanente o conexión remota.

## Plan exacto final 2B-III-C — Edge Function local/efímera

### Objetivo y alcance autorizado para una futura implementación

La futura Edge Function validará experimentalmente una frontera backend local
que liste catálogo sanitizado mediante identidad humana validada y una
identidad técnica privilegiada local aislada. No desbloqueará Flutter, remoto,
producción, datos reales, sesiones, mensajes ni agentes reales.

Nombre y ruta propuestos:

```text
supabase/functions/list-selectable-specialists/
GET /functions/v1/list-selectable-specialists
```

### Estructura futura propuesta

Archivos previstos, sujetos a aprobación de implementación:

| Archivo futuro | Responsabilidad |
| --- | --- |
| `index.ts` | Entrada HTTP, validación de método/JWT/configuración y coordinación |
| `contract.ts` | DTO exacto de seis campos y validación estricta de salida |
| `access_state.ts` | Cálculo puro y cerrado de `accessState` |
| `errors.ts` | Errores internos tipados y traducción HTTP genérica |
| `safe_log.ts` | Allowlist de eventos y redacción defensiva |
| `index_test.ts` | Tests locales de contrato, identidad, seguridad y errores |
| `.env.example` | Solo si se aprueba separadamente; nombres y placeholders falsos |

Variables futuras mínimas:

```text
SUPABASE_URL=<LOCAL_ONLY_PLACEHOLDER>
SUPABASE_ANON_KEY=<LOCAL_EPHEMERAL_PLACEHOLDER>
SUPABASE_SERVICE_ROLE_KEY=<LOCAL_EPHEMERAL_PLACEHOLDER>
STASISLY_ALLOW_LOCAL_ONLY=true
```

Reglas:

- los valores reales/efímeros solo se inyectan al runtime local y no se
  versionan;
- `SUPABASE_URL` debe coincidir con una allowlist explícita del stack local,
  incluidos únicamente hosts internos locales necesarios por Docker;
- cualquier URL HTTPS, project ref remoto, host no aprobado o ausencia de
  `STASISLY_ALLOW_LOCAL_ONLY=true` bloquea el arranque antes de consultar;
- no se crea `.env` ni `.env.example` durante esta fase documental.

Flujo operativo futuro propuesto:

1. comprobar que Supabase CLI no está enlazado a remoto;
2. arrancar Docker y Supabase exclusivamente local;
3. inyectar secretos efímeros generados por el stack local;
4. servir la función solo mediante comando local, sin `deploy`;
5. ejecutar harness HTTP local y pruebas anti-remoto;
6. detener función y stack local;
7. eliminar variables, artefactos temporales y logs del experimento;
8. verificar que no quedan secretos o conexiones persistentes.

### Contrato HTTP exacto

Petición:

```http
GET /functions/v1/list-selectable-specialists
Authorization: Bearer <JWT_LOCAL_VALIDADO>
Accept: application/json
```

- no admite body;
- no admite `user_id`, roles, entitlement, `accessState` ni IDs internos;
- un filtro futuro por `area` queda fuera de la primera implementación;
- `OPTIONS` solo podrá responder para soporte local de CORS sin consultar
  datos ni revelar configuración.

Respuesta exitosa `200`:

```json
{
  "items": [
    {
      "id": "uuid-publico",
      "displayName": "Nombre sanitizado",
      "area": "wellness",
      "shortDescription": "Descripción sanitizada",
      "accessState": "available",
      "isDemo": false
    }
  ]
}
```

Cada elemento contiene exactamente los seis campos aprobados. La envolvente
solo contiene `items`. Catálogo vacío:

```json
{"items":[]}
```

Errores externos:

```json
{
  "error": {
    "code": "catalogUnauthenticated",
    "requestId": "identificador-opaco"
  }
}
```

| Caso | HTTP | Código externo | Regla |
| --- | --- | --- | --- |
| Método no permitido | `405` | `catalogMethodNotAllowed` | No consulta datos |
| JWT ausente o inválido | `401` | `catalogUnauthenticated` | No distingue causa |
| Identidad válida sin permiso futuro | `403` | `catalogPermissionDenied` | Sin revelar recurso |
| Configuración local ausente/bloqueada | `503` | `catalogBackendBlocked` | Falla antes de consultar |
| Catálogo vacío | `200` | Ninguno | Devuelve `items: []` |
| Datos contradictorios o contrato inválido | `500` | `catalogContractViolation` | No devuelve respuesta parcial |
| Error interno inesperado | `500` | `catalogUnexpectedFailure` | Sin detalle sensible |

### Validación JWT futura

La función deberá:

1. exigir exactamente un bearer token;
2. verificar firma, expiración, issuer/audiencia y sujeto mediante Auth local;
3. no considerar válido un JWT únicamente por haberlo decodificado;
4. derivar `userId` exclusivamente del `sub` verificado;
5. rechazar o ignorar cualquier identidad, rol, entitlement o `accessState`
   aportado por cliente;
6. completar la validación humana antes de crear el cliente privilegiado;
7. fallar cerrada si Auth local o la configuración de validación no están
   disponibles.

### Acceso interno a datos

La primera implementación futura consultará
`public.specialist_catalog` mediante columnas allowlist:

```text
id
display_name
product_area
short_description
is_published
availability_status
access_tier
sort_order
specialist_id
```

`specialist_id` solo podrá utilizarse internamente para comprobar que existe
la relación requerida. Si esa comprobación exige leer
`public.specialists`, se limitará a la existencia del ID y a la mínima
consistencia aprobada; nunca seleccionará `prompt_template`, jerarquía o filas
completas.

La función debe:

- usar consultas con columnas explícitas, nunca `select=*`;
- devolver únicamente la proyección pública;
- excluir filas no publicadas de la respuesta;
- ordenar establemente por `product_area`, `sort_order`, `display_name`, `id`;
- fallar cerrada ante tabla ausente, relación rota, duplicados, enums
  desconocidos, configuración ausente o errores de permisos;
- no convertir errores en catálogo demo ni en éxito vacío.

### Cálculo temporal de `accessState`

Reglas para la primera implementación local:

| Condición interna | Resultado público |
| --- | --- |
| `is_published = false` | No se devuelve |
| `availability_status = unavailable` | `unavailable` |
| `availability_status = available` y `access_tier = free` | `available` |
| `availability_status = available` y `access_tier = premium` | `lockedPremium` |
| Estado ausente, desconocido o contradictorio | Fallo cerrado |

Hasta que exista un sistema real y aprobado de membresías/entitlements,
`premium` siempre produce `lockedPremium`. `demoOnly` nunca procede de la
Edge Function: solo puede producirlo el repositorio demo local explícito.

### Logs seguros

Allowlist futura de logs:

```text
requestId
operation
resultado genérico
código de error
latencia
cantidad devuelta
versión de contrato
```

Queda prohibido registrar JWT, `service_role`, secretos, `prompt_template`,
filas completas, payloads, IDs internos, entitlements o datos sensibles. El
cliente recibe errores genéricos; el detalle local debe permanecer sanitizado.

### Tests futuros obligatorios

- rechaza petición sin JWT y con JWT inválido;
- deriva usuario del JWT y no acepta `user_id`, roles, entitlement o
  `accessState`;
- no devuelve `specialist_id`, `specialists.id`, `prompt_template` ni columnas
  internas;
- cada elemento contiene exactamente seis campos y la envolvente solo `items`;
- catálogo vacío devuelve `200` con lista vacía;
- `premium` produce `lockedPremium`;
- `unavailable` produce `unavailable`;
- `demoOnly` nunca procede de backend;
- datos contradictorios, relación rota y configuración ausente fallan
  cerrados;
- falta de secreto local bloquea antes de consultar;
- ningún secreto aparece versionado, en respuestas o logs;
- demo y backend bloqueado no llaman la función;
- no existe acceso directo cliente a las tablas;
- no se realiza ninguna conexión remota.

### Anti-remoto obligatorio

La implementación futura debe demostrar:

- ausencia de project ref remoto y estado no enlazado;
- ningún comando `link`, `deploy`, `db push` o equivalente;
- ausencia de access tokens y credenciales remotas;
- URLs restringidas a hosts del stack local explícitamente aprobados;
- Supabase CLI y Docker operan solo localmente;
- un host o URL no allowlisted provoca fallo antes de cualquier consulta;
- inspección de comandos, configuración y logs sin evidencia de remoto.

### Rollback y limpieza

El rollback futuro deberá:

1. detener el servidor local de funciones;
2. detener Supabase/Docker local cuando corresponda;
3. eliminar la función local creada si se revierte el paquete;
4. borrar variables y secretos efímeros del proceso/local runtime;
5. eliminar artefactos y logs temporales que pudieran contener contexto;
6. verificar que no existe secreto versionado ni persistido;
7. confirmar que las tablas mantienen deny-all para cliente;
8. confirmar que demo sigue operativa sin llamar backend;
9. dejar Edge Function, remoto, 2B-III-D y 2B-IV bloqueados.

### Gates antes de implementar el plan

Aunque C1 está aprobado documentalmente, implementar 2B-III-C requiere una
autorización explícita posterior que confirme:

1. archivos concretos permitidos;
2. comandos locales permitidos;
3. mecanismo exacto de inyección efímera;
4. allowlist exacta de URLs/hosts locales;
5. contrato HTTP y matriz de errores;
6. harness y evidencia anti-remoto;
7. rollback y limpieza;
8. prohibición mantenida de Flutter, remoto, datos reales, sesiones y
   mensajes.

## Resultado local de 2B-III-C — Edge Function experimental

Fecha de implementación y verificación local: 2026-06-14.

### Implementado

- Se creó exclusivamente
  `supabase/functions/list-selectable-specialists/`.
- La operación implementada es
  `GET /functions/v1/list-selectable-specialists`.
- La función exige bearer JWT y lo valida contra Auth local antes de consultar
  catálogo con la identidad técnica local.
- `service_role` procede únicamente del runtime Supabase local; no se
  versiona, documenta, registra ni devuelve.
- La función solo acepta hosts locales allowlist:
  `127.0.0.1:54321`, `localhost:54321`,
  `host.docker.internal:54321` y el gateway Docker local `kong:8000`.
- Cualquier host, protocolo o puerto no permitido falla cerrado.
- La consulta usa columnas internas explícitas y límite 20; nunca usa
  `select=*` ni selecciona `prompt_template` o jerarquías.
- La respuesta contiene una envolvente `items` y exactamente seis campos por
  elemento: `id`, `displayName`, `area`, `shortDescription`, `accessState` e
  `isDemo`.
- `premium` siempre produce `lockedPremium` mientras no exista entitlement
  real aprobado; `demoOnly` nunca procede de backend.
- El filtro opcional acepta únicamente áreas públicas. Áreas inválidas
  devuelven `400 catalogInvalidArea`; parámetros de autoridad o desconocidos
  devuelven `400 catalogInvalidRequest`.
- Los logs usan exclusivamente operación, resultado, latencia, cantidad,
  versión de contrato y request ID opaco.

### Evidencia verificada

- `deno fmt --check`: correcto.
- `deno check`: correcto.
- Tests Deno de contrato, seguridad, estados, URL local y logs: 11/11.
- `supabase db reset --local --no-seed`: migraciones `00001`–`00004`
  reaplicadas exclusivamente en local.
- `supabase test db --local`: suite SQL acumulada 140/140.
- Harness HTTP local 2B-III-C: aprobado.
- Sin JWT y JWT inválido: `401 catalogUnauthenticated`.
- JWT emitido y validado por Auth local: `200` con catálogo vacío válido.
- Área inválida: `400 catalogInvalidArea`.
- Autoridad enviada por cliente: `400 catalogInvalidRequest`.
- Catálogo y usuarios Auth ficticios del harness: cero filas tras limpieza.
- Logs observados sin JWT, secretos, prompts, filas o IDs internos.

### Evidencia anti-remoto

- No se ejecutaron `supabase link`, `supabase deploy`, `supabase db push` ni
  comandos equivalentes.
- La ejecución utilizó Supabase CLI, Docker, Auth, PostgREST y Edge Runtime
  locales.
- Las URLs externas comprobadas fueron únicamente `127.0.0.1:54321`.
- La función rechaza endpoints HTTPS y hosts no incluidos en la allowlist.
- El harness bloquea configuración con endpoint `supabase.co`, project ref o
  `SUPABASE_ACCESS_TOKEN`.
- No se usaron tokens, datos o credenciales remotas.

### Rollback y limpieza verificados

- El archivo temporal de entorno se creó fuera del repositorio y solo contenía
  `STASISLY_ALLOW_LOCAL_ONLY=true`.
- Respuestas temporales del harness fueron eliminadas.
- Las identidades Auth locales ficticias fueron eliminadas.
- `public.specialist_catalog` quedó con cero filas.
- Ningún seed, migración, policy, grant, RPC, vista o dato real fue creado.
- La función puede retirarse eliminando su carpeta; las tablas permanecen
  deny-all para clientes.

### Riesgos residuales y gates cerrados

- La respuesta HTTP integrada se validó con catálogo vacío para respetar la
  prohibición de fixtures persistentes. Respuestas no vacías, orden, límite y
  `accessState` se validaron mediante fixtures en memoria; las relaciones y
  fixtures SQL continúan verificadas transaccionalmente por 2B-III-B.
- `service_role` omite RLS y solo es aceptable dentro de este experimento
  local/efímero.
- La allowlist incluye `kong:8000` únicamente porque es el gateway interno
  verificado del stack Docker local; no es un host remoto permitido.
- No existe entitlement real, catálogo editorial real ni integración Flutter.
- 2B-III-C queda cerrado formalmente el 2026-06-14. El cierre acepta la
  implementación y evidencia exclusivamente locales, incluido el riesgo
  residual de que la integración HTTP real validó catálogo vacío.
- 2B-III-D, 2B-IV, remoto, producción, backend permanente, datos reales,
  sesiones y mensajes permanecen bloqueados.

## Plan exacto 2B-III-C2 — HTTP local con catálogo efímero no vacío

### Objetivo

C2 debe demostrar localmente la ruta completa:

```text
fixtures SQL efímeros confirmados
-> public.specialist_catalog
-> Edge Function local
-> respuesta HTTP sanitizada no vacía
-> limpieza obligatoria
```

No crea seed, migración, catálogo editorial real ni datos remotos. C2 es una
prueba adicional posterior al cierre de C; no reabre ni invalida su cierre.

### Decisión sobre transacciones y visibilidad HTTP

Una transacción SQL abierta no puede utilizarse como único contenedor de C2:
la Edge Function y PostgREST consultan mediante conexiones distintas y no ven
filas aún no confirmadas por otra conexión.

Por ello, la futura prueba debe usar un **harness efímero con compensación
garantizada**, no afirmar incorrectamente que toda la ruta ocurre dentro de una
única transacción:

1. preflight verifica entorno exclusivamente local y tablas vacías;
2. `setup` inserta y confirma fixtures identificables como `test_only_c2`;
3. se crea usuario Auth local y se obtiene JWT local;
4. se llama por HTTP a la Edge Function;
5. se validan respuesta, filtros, orden, límite, seguridad y logs;
6. un `trap` ejecuta `cleanup` ante éxito, error o interrupción;
7. postcondiciones demuestran cero fixtures y cero usuarios Auth de C2;
8. `supabase db reset --local --no-seed` queda como recuperación secundaria si
   la compensación no pudiera completarse.

La prueba solo podrá considerarse aprobada si la limpieza final queda
demostrada. Una interrupción sin limpieza convierte el resultado en fallo.

### Estructura futura propuesta

Archivos futuros, pendientes de aprobación de implementación:

```text
supabase/tests/2b_iii_c2_non_empty_catalog_setup.psql
supabase/tests/2b_iii_c2_non_empty_catalog_cleanup.psql
supabase/tests/2b_iii_c2_non_empty_catalog_http_test.sh
```

Reglas:

- `setup.sql` y `cleanup.sql` no son migraciones ni seed;
- solo el orquestador HTTP puede ejecutar el setup;
- el orquestador instala `trap cleanup EXIT INT TERM` antes del setup;
- todos los IDs, emails, nombres internos y prompts usan namespace
  inequívoco `test_only_c2`;
- cleanup elimina primero catálogo, después especialistas internos y usuario
  Auth local;
- no modificar Edge Function, esquema, policies, grants o migraciones.

### Catálogo efímero mínimo obligatorio

| Orden | Nombre público | Área | Tier interno | Disponibilidad | Resultado esperado |
| --- | --- | --- | --- | --- | --- |
| 10 | Stasis | `stasis` | `free` | `available` | `available` |
| 20 | Nutrición | `nutrition` | `free` | `available` | `available` |
| 30 | Wellness premium | `wellness` | `premium` | `available` | `lockedPremium` |
| 40 | Sueño y estrés | `wellness` | `free` | `unavailable` | `unavailable` |

Todas las filas:

- son ficticias y locales;
- usan `is_published = true` exclusivamente durante C2 para atravesar la ruta
  HTTP;
- referencian especialistas internos ficticios válidos;
- usan prompts placeholder `test_only_c2`, no reales y nunca expuestos;
- tienen IDs públicos distintos de IDs internos;
- se eliminan obligatoriamente al terminar.

Para probar el límite 20 de extremo a extremo, el setup debe crear además 17
filas auxiliares `test_only_c2` publicadas, dando un total de 21. La primera
llamada sin filtro debe devolver exactamente las primeras 20 según
`sort_order ASC, display_name ASC, id ASC`; la fila 21 no debe aparecer.
Las cuatro filas canónicas deben ocupar posiciones deterministas dentro de ese
orden. Las auxiliares no representan catálogo conceptual ni producto real.

### Flujo futuro de prueba

1. Confirmar que Supabase local está iniciado, no enlazado y sin tokens
   remotos.
2. Confirmar que `public.specialist_catalog` no contiene filas y no existen
   fixtures `test_only_c2`.
3. Preparar `trap` de limpieza antes de insertar.
4. Ejecutar setup local confirmado con 21 especialistas internos y 21 filas de
   catálogo efímeras.
5. Crear una identidad Auth local ficticia y obtener JWT local válido.
6. Servir la Edge Function exclusivamente local con secreto efímero.
7. Llamar sin filtro y comprobar HTTP `200`, 20 resultados y orden estable.
8. Llamar con `area=wellness` y comprobar exactamente las filas wellness
   canónicas en orden esperado.
9. Validar los cuatro `accessState` obligatorios.
10. Inspeccionar estructura de respuesta y ausencia de campos prohibidos.
11. Comprobar deny-all directo para `anon` y `authenticated`.
12. Capturar logs sanitizados y comprobar ausencia de secretos.
13. Ejecutar cleanup mediante `trap`.
14. Demostrar cero filas de catálogo, cero especialistas C2 y cero usuarios
    Auth C2.
15. Detener función y Supabase local; eliminar variables, respuestas y logs
    temporales.

### Verificaciones obligatorias

- HTTP `200` y lista no vacía;
- envolvente exacta `items`;
- exactamente seis campos por elemento;
- orden estable;
- límite 20 aplicado sobre 21 fixtures;
- filtro `area=wellness` funcional;
- Stasis y Nutrición como `available`;
- Wellness premium como `lockedPremium`;
- Sueño y estrés como `unavailable`;
- `isDemo = false` en toda respuesta backend;
- ausencia de `specialist_id`, `specialists.id`, `prompt_template`,
  `access_tier`, `availability_status`, jerarquía y columnas internas;
- ausencia de secretos, JWT y filas completas en logs;
- tablas mantienen RLS deny-all y cero acceso cliente directo;
- fixtures y usuario Auth eliminados incluso si falla una assertion;
- catálogo queda con cero filas;
- no existe conexión, token, project ref o comando remoto.

### Seguridad y anti-remoto

- JWT se emite y valida exclusivamente mediante Auth local.
- `service_role` permanece efímero dentro del runtime local.
- El setup usa conexión PostgreSQL local privilegiada solo para preparar
  fixtures; nunca representa acceso cliente.
- Los clientes `anon` y `authenticated` continúan deny-all sobre ambas tablas.
- La única lectura de catálogo permitida durante la prueba es mediante la Edge
  Function local.
- El harness debe rechazar hosts no allowlisted, endpoint `.supabase.co`,
  project ref, `SUPABASE_ACCESS_TOKEN` o estado enlazado.
- Quedan prohibidos `link`, `deploy`, `db push`, datos reales y secretos
  versionados.

### Rollback y limpieza

La limpieza primaria es compensatoria, idempotente y se ejecuta mediante
`trap`:

1. eliminar filas C2 de `specialist_catalog`;
2. eliminar especialistas internos C2;
3. eliminar identidad Auth local C2;
4. borrar JWT, respuestas, variables y logs temporales;
5. detener Edge Function y stack local;
6. verificar cero filas/fixtures/usuarios.

Si la limpieza primaria falla, el harness debe detenerse, informar el error y
usar `supabase db reset --local --no-seed` como recuperación secundaria. Nunca
debe declarar éxito sin postcondiciones limpias.

### Gates antes de implementar C2

Se requiere aprobación explícita de:

1. estrategia efímera confirmada más cleanup compensatorio, reconociendo que
   no es una única transacción visible por HTTP;
2. 21 fixtures totales para demostrar límite 20;
3. cuatro filas canónicas, estados y orden;
4. archivos exactos permitidos;
5. comandos locales, anti-remoto y captura segura de logs;
6. rollback, recuperación secundaria y postcondiciones;
7. confirmación de que Edge Function, Flutter, esquema, remoto, C/D y 2B-IV no
   se modifican.

C2 fue autorizado e implementado después exclusivamente en local. Su resultado
y evidencia se registran a continuación.

## Resultado local de 2B-III-C2 — HTTP con catálogo no vacío

Fecha de implementación y verificación local: 2026-06-14.

### Implementado

- Se crearon únicamente tres artefactos de harness en `supabase/tests/`:
  setup `.psql`, cleanup `.psql` y orquestador HTTP `.sh`.
- La extensión `.psql` evita que `supabase test db --local` interprete setup y
  cleanup como suites pgTAP.
- El setup confirma 21 especialistas y 21 entradas de catálogo ficticias,
  locales e inequívocamente marcadas `test_only_c2`.
- Cuatro filas canónicas validan Stasis, Nutrición, Wellness premium y Sueño y
  estrés; 17 auxiliares permiten demostrar el límite 20.
- El orquestador instala cleanup mediante `trap` antes del setup y verifica
  postcondiciones limpias antes de declarar éxito.
- Se creó y eliminó una identidad Auth local ficticia con JWT local.
- No fue necesario modificar la Edge Function: C2 no descubrió defectos en su
  implementación.

### Evidencia HTTP y de negocio

- Harness C2 no vacío: PASS.
- HTTP general: `200`, lista no vacía y exactamente 20 elementos sobre 21
  fixtures.
- Los primeros cuatro elementos respetaron orden estable:
  Stasis, Nutrición, Wellness premium y Sueño y estrés.
- Stasis y Nutrición devolvieron `available`.
- Wellness premium devolvió `lockedPremium`.
- Sueño y estrés devolvió `unavailable`.
- `area=wellness` devolvió exactamente Wellness premium y Sueño y estrés.
- Área inválida devolvió `catalogInvalidArea`.
- Parámetros de autoridad cliente devolvieron `catalogInvalidRequest`.
- Todos los elementos devolvieron exactamente seis campos e `isDemo = false`.
- No aparecieron columnas internas, prompts, secretos, JWT o filas completas.

### Evidencia de seguridad y anti-remoto

- Acceso directo a `specialist_catalog`: `anon=401` y
  `authenticated=403`; ambos denegados.
- JWT fue emitido y validado exclusivamente mediante Auth local.
- `service_role` permaneció dentro del runtime local.
- Logs inspeccionados sin JWT completo, `service_role`, `prompt_template`,
  `specialist_id`, `access_tier` ni `availability_status`.
- La Edge Function mantuvo allowlist local y fallo cerrado para hosts remotos.
- No se ejecutaron `link`, `deploy`, `db push` ni conexiones remotas.
- No se modificaron policies, grants, migraciones, función o esquema.

### Cleanup y postcondiciones verificadas

- Cleanup compensatorio mediante `trap`: aprobado.
- `public.specialist_catalog`: cero filas.
- Especialistas `test_only_c2`: cero filas.
- Usuarios Auth `test_only_c2`: cero filas.
- Policies nuevas sobre tablas de especialistas: cero.
- Archivos y respuestas temporales del harness eliminados.
- Suite SQL posterior al cleanup: 140/140.
- Tests Deno posteriores al cleanup: 11/11.

### Incidencias corregidas durante la validación

- La primera suite SQL detectó que archivos setup/cleanup con extensión `.sql`
  eran interpretados como tests pgTAP sin plan. Se corrigieron a `.psql`; no
  fue un fallo de esquema ni de la Edge Function.
- La denegación directa observada fue `401` para anon y `403` para
  authenticated. El harness acepta ambos códigos como denegación explícita y
  exige que ninguna lectura directa tenga éxito.

### Riesgos residuales y gates

- Los fixtures deben confirmarse temporalmente para ser visibles desde la
  conexión independiente de la Edge Function; el control depende de cleanup
  compensatorio y recuperación secundaria mediante reset local.
- `service_role` continúa limitado al experimento local y omite RLS.
- Antes de la decisión de cierre, C2 quedó implementado y verificado
  exclusivamente en local, pendiente de aprobación. Su cierre formal se
  registra a continuación.
- 2B-III-D, 2B-IV, Flutter, remoto, producción, catálogo real, sesiones,
  mensajes y datos reales permanecen bloqueados.

### Cierre formal de 2B-III-C2

2B-III-C2 queda cerrado formalmente el 2026-06-14. El cierre acepta la
evidencia HTTP no vacía, los 21 fixtures efímeros, el cleanup compensatorio y
las postcondiciones limpias. No autoriza catálogo real, Flutter, remoto,
sesiones, mensajes ni ampliaciones de backend.

## Plan exacto 2B-III-D — Contrato Flutter de catálogo sin backend real

### Objetivo y estado

2B-III-D debe preparar en Flutter un contrato estricto para representar,
validar y listar especialistas seleccionables sin activar todavía la Edge
Function, backend real, Supabase remoto ni creación de sesiones.

El paquete futuro deberá mantener:

- modo demo local explícito;
- cualquier modo backend no autorizado bloqueado antes de red;
- ningún fallback silencioso a demo;
- IDs públicos separados de IDs internos;
- catálogo separado de `chat_sessions`;
- selección visual sin crear sesión, mensaje o agente real.

Este plan es exclusivamente documental. No autoriza código Dart.

### Modelo futuro `SelectableSpecialist`

Entidad inmutable de dominio:

```text
SelectableSpecialist
  id: String
  displayName: String
  area: SelectableSpecialistArea
  shortDescription: String
  accessState: SelectableSpecialistAccessState
  isDemo: bool
```

Campos permitidos exactamente:

```text
id
displayName
area
shortDescription
accessState
isDemo
```

Campos prohibidos:

```text
specialistId
internalSpecialistId
promptTemplate
branchId
chiefId
accessTier
availabilityStatus
isPublished
createdAt
updatedAt
permissions
roles
```

Invariantes:

- `id`, `displayName` y `shortDescription` no están vacíos;
- `id` es el identificador público opaco, no prueba autorización;
- backend debe producir `isDemo = false`;
- demo local debe producir `isDemo = true` y `accessState = demoOnly`;
- el modelo no contiene métodos para crear sesiones, decidir entitlement o
  traducir IDs internos.

### Áreas y estados futuros

```text
SelectableSpecialistArea:
  stasis | health | nutrition | training | wellness

SelectableSpecialistAccessState:
  available | lockedPremium | unavailable | demoOnly
```

Reglas:

- cualquier valor desconocido produce `contractViolation`;
- `demoOnly` solo puede originarse en el repositorio demo local;
- una respuesta backend con `demoOnly` produce `contractViolation`;
- un elemento demo con `isDemo = false`, o no demo con `isDemo = true`,
  produce `contractViolation`;
- `lockedPremium` se representa bloqueado y Flutter no decide entitlement;
- `unavailable` se representa no iniciable;
- `available` solo habilita selección visual; no autoriza crear sesión.

### Resultado futuro `SelectableSpecialistsResult`

Estados mínimos y semántica:

| Resultado | Cuándo se usa | Contenido | Llamada backend |
| --- | --- | --- | --- |
| `success` | Respuesta autorizada válida con uno o más elementos | Lista backend sanitizada | Solo adaptador futuro autorizado |
| `empty` | Respuesta backend válida con lista vacía | Lista vacía | Solo adaptador futuro autorizado |
| `demo` | Modo demo explícito | Lista local, toda `isDemo=true`/`demoOnly` | Nunca |
| `backendBlocked` | Modo backend no autorizado o configuración bloqueada | Sin lista | Nunca |
| `unauthenticated` | HTTP 401 / sesión ausente para backend futuro | Sin lista | Futuro |
| `permissionDenied` | HTTP 403 | Sin lista | Futuro |
| `invalidSession` | Sesión local incoherente, expirada o no utilizable antes/durante llamada | Sin lista | Según punto de detección |
| `invalidArea` | Filtro local inválido o `400 catalogInvalidArea` | Sin lista | Nunca si se detecta localmente |
| `contractViolation` | Forma, campos, tipos, enums o semántica inválidos | Sin lista; fallar cerrado | Futuro |
| `networkError` | Error de transporte, timeout o servicio inaccesible | Sin lista | Futuro |
| `unexpectedError` | Fallo no clasificado | Sin lista | Según origen |

Reglas:

- `empty` nunca se convierte en `demo`;
- `backendBlocked` nunca se convierte en `demo`, `empty` o `success`;
- un resultado de error nunca transporta elementos parciales;
- `demo` no representa backend, autenticación ni capacidad real;
- los detalles técnicos no se muestran directamente al usuario.

### Repositorios futuros

Contrato de dominio:

```text
SelectableSpecialistsRepository
  listSelectableSpecialists(areaFilter?)
    -> SelectableSpecialistsResult
```

Implementaciones futuras aprobables por separado:

```text
DemoSelectableSpecialistsRepository
BackendBlockedSelectableSpecialistsRepository
EdgeFunctionSelectableSpecialistsRepository
```

#### `DemoSelectableSpecialistsRepository`

- contiene catálogo local ficticio y explícito;
- nunca llama red, Supabase o Edge Function;
- devuelve `demo`;
- todos los elementos usan `isDemo = true` y `accessState = demoOnly`;
- no promete IA, chat, memoria o capacidades reales.

#### `BackendBlockedSelectableSpecialistsRepository`

- nunca llama red, Supabase o Edge Function;
- devuelve siempre `backendBlocked`;
- se selecciona para cualquier modo backend no autorizado, configuración
  incompleta o entorno no permitido;
- no hace fallback a demo.

#### `EdgeFunctionSelectableSpecialistsRepository`

- se define solo como contrato futuro; no se implementa ni registra en D;
- solo podrá activarse mediante aprobación independiente;
- dependerá de un datasource HTTP tipado, sesión validada y configuración de
  entorno aprobada;
- no contendrá `service_role`, secretos ni acceso directo a tablas;
- traducirá únicamente respuestas sanitizadas y errores tipados.

### Validación futura del contrato HTTP

El adapter futuro deberá validar antes de construir entidades:

1. respuesta JSON con envolvente exacta `items`;
2. `items` es lista;
3. cada elemento es objeto con exactamente seis claves;
4. ninguna clave falta o sobra;
5. `id`, `displayName` y `shortDescription` son strings no vacíos;
6. `area` pertenece al enum permitido;
7. `accessState` pertenece al enum permitido;
8. `isDemo` es booleano;
9. backend devuelve `isDemo = false` y nunca `demoOnly`;
10. no existen IDs duplicados;
11. cualquier columna interna o campo desconocido produce
    `contractViolation`;
12. no se conserva ni registra payload crudo tras validarlo.

Campos que deben provocar `contractViolation`, aunque los seis campos válidos
también estén presentes:

```text
specialist_id
specialists.id
prompt_template
branch_id
chief_id
access_tier
availability_status
is_published
created_at
updated_at
permissions
roles
```

Mapeo futuro mínimo de errores:

| Backend/transporte | Resultado Flutter |
| --- | --- |
| HTTP 200 con lista válida no vacía | `success` |
| HTTP 200 con `items: []` | `empty` |
| HTTP 400 `catalogInvalidArea` | `invalidArea` |
| HTTP 401 `catalogUnauthenticated` | `unauthenticated` |
| HTTP 403 `catalogPermissionDenied` | `permissionDenied` |
| HTTP 503 `catalogBackendBlocked` | `backendBlocked` |
| Forma o código inesperado | `contractViolation` o `unexpectedError` según evidencia |
| Timeout/DNS/transporte | `networkError` |

### Comportamiento UI futuro

- **Loading:** indicador explícito, sin mostrar catálogo previo como resultado
  nuevo ni cambiar silenciosamente a demo.
- **Demo:** banner/etiqueta demo visible; selección solo navega a experiencia
  demo futura aprobada, nunca crea chat real.
- **Backend bloqueado:** estado visible que explica indisponibilidad; no llama
  backend y no muestra demo como sustituto.
- **Vacío:** estado vacío válido, diferenciado de error y bloqueo.
- **Sesión inválida/no autenticada:** solicitar restaurar sesión solo cuando
  auth real esté autorizada; no inventar usuario.
- **Permiso denegado:** mensaje genérico sin filtrar reglas internas.
- **Violación de contrato:** fallo cerrado y mensaje técnico seguro; no
  renderizar elementos parciales.
- **Premium bloqueado:** visible como bloqueado; no permite acción iniciable.
- **No disponible:** visible o retirado según decisión UX futura, pero nunca
  iniciable.
- **Disponible:** permite seleccionar visualmente el ID público; no crea
  sesión.

Seleccionar un especialista en D solo actualiza estado visual/local futuro. No
invoca `createOwnChatSession`, no escribe datos y no inicia IA.

### Tests futuros obligatorios de 2B-III-D

#### Modelo y arquitectura

- `SelectableSpecialist` contiene únicamente seis campos;
- no existen campos internos, permisos o roles;
- Flutter no importa SDK Supabase ni cliente de Edge Function desde dominio;
- `EdgeFunctionSelectableSpecialistsRepository` no tiene implementación
  activa ni provider registrado.

#### Demo y bloqueo

- demo devuelve catálogo local explícito;
- todos los elementos demo usan `isDemo = true` y `demoOnly`;
- demo nunca llama backend;
- backend bloqueado devuelve `backendBlocked` y nunca llama Edge Function;
- no existe fallback silencioso desde errores/bloqueo/vacío a demo.

#### Contrato y mapeo

- respuesta exacta de seis campos se acepta;
- campo extra o ausente produce `contractViolation`;
- `specialist_id` y `prompt_template` producen `contractViolation`;
- `accessState` o `area` inválidos producen `contractViolation`;
- backend con `demoOnly` o `isDemo = true` produce `contractViolation`;
- IDs duplicados producen `contractViolation`;
- HTTP 401 produce `unauthenticated`;
- HTTP 403 produce `permissionDenied`;
- `400 catalogInvalidArea` produce `invalidArea`;
- red/timeout produce `networkError`;
- lista vacía produce `empty`.

#### UI y sesiones

- loading, demo, bloqueo, vacío y errores son distinguibles;
- premium y unavailable no son iniciables;
- seleccionar un elemento no crea `chat_sessions`, mensajes ni llamadas IA;
- no se usa `specialists.id` para ninguna acción.

### Relación con `chat_sessions` y 2B-IV

2B-III-D no crea, lista, archiva ni modifica sesiones. Solo prepara catálogo,
selección visual y contrato de errores.

La futura operación:

```text
createOwnChatSession(selectableSpecialistId)
```

continúa bloqueada hasta 2B-IV. El backend deberá volver a validar identidad,
ID público, publicación, disponibilidad y entitlement; nunca confiará en
`accessState` previamente mostrado por Flutter.

### Gates antes de implementar 2B-III-D

Se requiere aprobación explícita de:

1. nombres exactos de entidad, enums, resultados y repositorios;
2. catálogo demo local y textos permitidos;
3. archivos Dart permitidos y prohibidos;
4. estrategia de providers que preserve backend bloqueado;
5. matriz de tests y criterios de aceptación;
6. confirmación de que no habrá datasource Edge Function ejecutable,
   Flutter-backend, sesiones, mensajes, remoto ni datos reales.

La implementación desconectada de 2B-III-D fue autorizada posteriormente y su
resultado se registra a continuación. Este plan no autoriza conexión backend.

## Resultado de implementación desconectada 2B-III-D

Fecha de implementación y verificación: 2026-06-14.

- Se creó `SelectableSpecialist` con exactamente `id`, `displayName`, `area`,
  `shortDescription`, `accessState` e `isDemo`.
- Se definieron enums cerrados para las cinco áreas aprobadas y los cuatro
  estados de acceso.
- Se añadieron resultados diferenciados para éxito, vacío, demo, backend
  bloqueado, autenticación, permisos, sesión/área inválidas, contrato, red y
  error inesperado.
- El repositorio demo usa seis entradas locales, ficticias y explícitamente
  `demoOnly`; no crea sesiones ni ejecuta acciones clínicas.
- Los modos backend real y producción seleccionan siempre un repositorio
  bloqueado.
- El contrato remoto futuro no tiene adaptador ejecutable y su validador
  rechaza campos extra, campos ausentes, enums desconocidos, IDs duplicados y
  datos demo atribuidos al backend.
- No se registró ni invocó Edge Function, Supabase, chat, sesiones, mensajes,
  remoto o datos reales.
- Las pruebas específicas del contrato superaron 15/15 y la suite Flutter
  completa superó 49/49.
- `build_runner` completó sin generar cambios; `flutter analyze
  --no-fatal-infos` terminó sin errores ni warnings bloqueantes y
  `git diff --check` fue correcto.
- 2B-III-D queda implementado, verificado y cerrado formalmente como contrato
  desconectado. No autoriza 2B-IV ni conexión Flutter-backend.

## Plan exacto 2B-IV — `chat_sessions` seguro

Estado: diseño documental preparado el 2026-06-14, pendiente de aprobación.
No autoriza SQL, migraciones, Edge Functions, Flutter, backend real, remoto,
sesiones, mensajes o datos reales.

### Objetivo y límites

2B-IV debe permitir en una futura implementación aprobada crear, listar y
archivar exclusivamente sesiones propias usando el ID público
`selectableSpecialistId`. Flutter nunca conocerá, enviará ni recibirá
`chat_sessions.user_id` o `chat_sessions.specialist_id`.

2B-IV no implementa mensajes, IA, agentes reales, Stasis Engine, remoto ni
producción. `messages` queda expresamente reservado para 2B-V.

### Estado verificado de `public.chat_sessions`

La migración histórica crea:

| Columna | Estado actual | Visible al cliente futuro | Escribible por cliente | Server-managed | Riesgo / decisión 2B-IV |
| --- | --- | --- | --- | --- | --- |
| `id` | UUID PK con default | Sí, como `sessionId` opaco | Nunca | Sí | Validar formato; no concede ownership |
| `user_id` | UUID FK nullable a `public.users` con cascade delete | Nunca | Nunca | Sí, derivado del JWT validado | Nullable y falsificable si se expone insert directo; debe endurecerse en un paquete aprobado |
| `specialist_id` | UUID FK nullable a `public.specialists` con cascade delete | Nunca | Nunca | Sí, resuelto desde catálogo | Expone identidad interna y el cascade puede borrar sesiones; requiere revisión |
| `started_at` | `TIMESTAMP DEFAULT now()` nullable | Sí, proyección segura | Nunca | Sí | Falta `NOT NULL` y zona horaria; pendiente de rediseño |
| `last_message_at` | `TIMESTAMP DEFAULT now()` nullable | Sí, proyección segura | Nunca | Sí | En 2B-IV permanece igual a creación; 2B-V definirá actualización por mensajes |
| `status` | `active`/`archived`, default `active`, nullable | Sí | Nunca de forma genérica | Sí | Solo archivado lógico controlado; sin reactivación |
| `message_count` | `INT DEFAULT 0`, nullable | Sí provisionalmente | Nunca | Sí | En 2B-IV debe permanecer `0`; fuente consistente se decide en 2B-V |

Existe únicamente `idx_chat_sessions_user(user_id)`. No existe índice para el
orden estable propuesto, RLS ni políticas aprobadas. La tabla actual no es apta
para acceso cliente.

`public.specialist_catalog.id` es el único ID seleccionable aceptable. La
frontera futura resolverá internamente:

```text
specialist_catalog.id -> specialist_catalog.specialist_id -> specialists.id
```

El `specialist_id` interno solo se persiste en `chat_sessions` después de
revalidar publicación, disponibilidad y entitlement.

### Contrato futuro `createOwnChatSession`

Operación conceptual:

```text
createOwnChatSession(selectableSpecialistId)
```

Entrada permitida:

```json
{"selectableSpecialistId":"<uuid-publico-catalogo>"}
```

No se aceptan campos adicionales. En particular, Flutter nunca envía
`user_id`, `specialist_id`, `status`, timestamps, `message_count`, roles,
entitlement o `accessState`.

Secuencia backend obligatoria:

1. validar JWT y derivar owner desde su `sub`;
2. rechazar sesión ausente, inválida o identidad sin perfil autorizado;
3. validar formato de `selectableSpecialistId`;
4. consultar catálogo por ID público sin aceptar IDs internos;
5. exigir catálogo publicado y especialista asociado existente/activo;
6. calcular disponibilidad y entitlement en backend; nunca confiar en
   `accessState` mostrado o enviado por Flutter;
7. rechazar `premium` sin entitlement y cualquier `unavailable`;
8. insertar exactamente una sesión con owner derivado, `specialist_id`
   interno resuelto, `status = active`, `message_count = 0` y timestamps
   server-managed;
9. devolver exactamente una proyección segura confirmada;
10. no crear mensajes ni invocar IA.

La primera validación local creará una sesión nueva por invocación confirmada.
No se promete semántica `get-or-create`. Antes de remoto debe aprobarse una
estrategia de idempotencia y rate limiting para evitar duplicados por reintento.

Éxito requiere HTTP `201` o `200` documentado y exactamente una sesión
coincidente. HTTP `204`, cero filas, múltiples filas, ID inesperado o forma
incompleta producen `createUnconfirmed` o `contractViolation`, nunca éxito.

Resultados mínimos: `createConfirmed`, `invalidSelectableSpecialist`,
`specialistNotFound`, `specialistUnavailable`, `premiumRequired`,
`ownerProfileMissing`, `unauthenticated`, `permissionDenied`,
`createUnconfirmed`, `contractViolation`, `backendBlocked`, `networkError` y
`unexpectedError`.

### Contrato futuro `listOwnChatSessions`

Operación conceptual:

```text
listOwnChatSessions(cursor?, limit?)
```

La frontera deriva owner del JWT y aplica siempre el filtro de propiedad.
Flutter no envía `user_id`. No se usa `SELECT *`.

Proyección segura propuesta:

```text
sessionId
selectableSpecialist: { id, displayName, area }
startedAt
lastMessageAt
status
messageCount
```

No se devuelve `user_id`, `specialist_id`, prompts, permisos, roles,
entitlement, configuración interna o campos editoriales no aprobados. La
información del especialista se obtiene del catálogo sanitizado, no de
`public.specialists` expuesto al cliente.

Orden estable obligatorio:

```text
last_message_at DESC NULLS LAST, id DESC
```

Paginación por cursor compuesto `lastMessageAt + sessionId`; límite por defecto
20 y máximo 50. Solo se admiten estados `active` y `archived`. Lista vacía es
éxito válido. Una columna extra, estado desconocido, orden inválido o catálogo
asociado no sanitizado produce `contractViolation`.

### Contrato futuro `archiveOwnChatSession`

Operación conceptual:

```text
archiveOwnChatSession(sessionId)
```

Flutter envía únicamente `sessionId`. La frontera deriva owner del JWT,
actualiza solo una sesión propia actualmente `active` y establece únicamente
`status = archived`.

No existe delete físico, update genérico de estado, cambio de ownership,
reactivación, modificación de especialista, timestamps o `message_count`.
Intentar archivar sesión inexistente, ajena o ya archivada no revela su
existencia y no confirma éxito.

Éxito requiere exactamente una fila segura con el mismo `sessionId` y
`status = archived`. HTTP `204`, cero filas, múltiples filas o respuesta
ambigua producen `archiveUnconfirmed`, nunca éxito.

### Frontera técnica evaluada

| Alternativa | Ventajas | Riesgos / límites | Decisión |
| --- | --- | --- | --- |
| RLS directa sobre `chat_sessions` | Menos componentes; lectura owner posible | No resuelve de forma segura catálogo interno, disponibilidad, premium ni creación controlada; obliga a grants cliente | No recomendada para creación/archivado inicial |
| RPC | Operación transaccional cercana a datos | Riesgo alto de `SECURITY DEFINER`, grants y superficie difícil de auditar; no aprobada por comodidad | No recomendada como primera frontera |
| Edge Function local | Reutiliza patrón C/C2, valida JWT, oculta IDs internos y permite contrato HTTP estricto | Identidad técnica privilegiada, logs, secretos efímeros y transacción requieren controles | **Recomendada para MVP exclusivamente local/efímero** |
| API propia permanente | Frontera objetivo más gobernable | Infraestructura, operación y costes fuera del alcance actual | Futuro, antes de producción |

La recomendación documental es una Edge Function nueva y separada,
exclusivamente local/efímera, con endpoints u operaciones allowlist para
crear, listar y archivar. No debe ampliarse silenciosamente la función de
catálogo. Su implementación requiere aprobación separada.

### RLS, grants y rollback futuros

Primera migración futura propuesta:

1. habilitar RLS en `public.chat_sessions` sin `FORCE RLS`;
2. revocar todos los privilegios sobre la tabla a `PUBLIC`, `anon` y
   `authenticated`;
3. no crear policies permisivas para cliente;
4. mantener acceso cliente directo deny-all;
5. prohibir `INSERT`, `UPDATE`, `DELETE` y `SELECT` directos;
6. no modificar `messages` ni otras tablas.

La Edge Function local usaría una identidad técnica efímera únicamente después
de validar JWT y aplicaría owner en cada consulta/escritura. No se usa
`service_role` como prueba de acceso cliente ni se entrega a Flutter.

Rollback de la primera migración debe eliminar únicamente los cambios nuevos y
volver al estado anterior documentado. Antes de implementar habrá que decidir
si el rollback conserva RLS deny-all como endurecimiento irreversible seguro,
igual que 2B-III-A, o vuelve exactamente al esquema histórico. La recomendación
es conservar deny-all y probar reaplicación.

### Tests futuros obligatorios

Arquitectura y contrato:

- Flutter nunca envía ni modela `user_id` o `specialists.id`;
- solo envía `selectableSpecialistId` para creación y `sessionId` para archivo;
- ningún contrato usa `SELECT *`;
- respuestas nunca exponen `user_id` o `specialist_id`;
- backend bloqueado y demo no llaman red;
- no se crean mensajes ni se invoca IA.

Creación:

- ID público inexistente, no publicado o especialista ausente falla cerrado;
- `premium` sin entitlement falla;
- `unavailable` falla;
- `available/free` crea exactamente una sesión con owner derivado;
- campos adicionales, `user_id`, ID interno o `accessState` enviados fallan;
- HTTP `204`, cero/múltiples filas o respuesta inesperada no confirman éxito.

Listado y aislamiento:

- usuario A nunca ve sesiones de B;
- proyección contiene solo campos seguros y catálogo sanitizado;
- lista vacía es éxito;
- cursor, límite, orden y estados se validan;
- columnas internas o estado desconocido producen violación de contrato.

Archivado y SQL:

- owner archiva exactamente una sesión activa propia;
- archivar sesión ajena/inexistente no confirma éxito ni filtra existencia;
- delete físico y reactivación están prohibidos;
- anon/authenticated no acceden directamente a la tabla;
- RLS queda habilitada, sin policies permisivas ni grants cliente;
- rollback y reaplicación preservan deny-all;
- harness anti-remoto demuestra ejecución solo local.

### Gates antes de implementar 2B-IV

1. aprobar explícitamente Edge Function local como primera frontera;
2. decidir nombres HTTP exactos, payloads y proyecciones;
3. aprobar migración deny-all de `chat_sessions` y rollback;
4. decidir endurecimiento de columnas nullable, timestamps y `ON DELETE`;
5. decidir idempotencia y rate limiting antes de cualquier conexión real;
6. aprobar fixtures locales, harness, identidad técnica efímera y cleanup;
7. mantener Flutter, remoto, producción y `messages` bloqueados.

## División aprobada de 2B-IV

Fecha de aprobación documental: 2026-06-14.

El diseño general 2B-IV queda aprobado, pero no puede implementarse como un
único paquete. Se divide obligatoriamente en:

```text
2B-IV-A — chat_sessions esquema local deny-all y constraints mínimos
2B-IV-B — fixtures locales de sesiones propias/ajenas
2B-IV-C — Edge Function local createOwnChatSession
2B-IV-D — Edge Function local listOwnChatSessions
2B-IV-E — Edge Function local archiveOwnChatSession
2B-IV-F — contrato Flutter desconectado para sesiones
2B-V — messages
```

Cada subpaquete requiere plan, aprobación, implementación, evidencia y cierre
independientes. La aprobación del diseño general no autoriza SQL, funciones,
Flutter, sesiones, mensajes, remoto o producción. El siguiente gate es
exclusivamente 2B-IV-A.

## Plan exacto 2B-IV-A — `chat_sessions` esquema local deny-all

Estado al preparar el plan: diseño documental pendiente de aprobación. La
implementación local fue autorizada y verificada posteriormente; su resultado
se registra al final de esta sección.

### Objetivo mínimo

Dejar `public.chat_sessions` preparada exclusivamente en local/efímero como
tabla backend-only endurecida:

- RLS habilitada sin FORCE RLS;
- cero policies y cero grants cliente;
- deny-all efectivo para `anon` y `authenticated`;
- integridad mínima de columnas existentes;
- un índice mínimo para listado owner estable;
- rollback local que no debilite deny-all;
- ninguna modificación de `messages`, Edge Functions, Flutter o remoto.

2B-IV-A no crea sesiones, fixtures, datos, operaciones create/list/archive,
funciones, RPC, vistas o contratos Flutter.

### Inventario y decisión por columna

| Columna | Tipo/default actual | Nullable actual | Riesgo actual | Decisión mínima futura | Índice | Visible futuro | Server-managed |
| --- | --- | --- | --- | --- | --- | --- | --- |
| `id` | `UUID`, PK, `uuid_generate_v4()` | No por PK | Ninguno crítico; ID no concede ownership | Conservar PK/default; no añadir constraint duplicado | Parte final del índice estable | Sí, como `sessionId` opaco | Sí |
| `user_id` | `UUID`, FK `users(id)`, `ON DELETE CASCADE`, sin default | Sí | Sesión huérfana lógica o ownership ausente; payload cliente falsificable si se expone | `NOT NULL`; conservar FK a `public.users(id)` en A; nunca backfill inventado ni escritura Flutter | Primera columna del índice estable | Nunca | Sí, futura frontera desde JWT |
| `specialist_id` | `UUID`, FK `specialists(id)`, `ON DELETE CASCADE`, sin default | Sí | Sesión sin especialista; ID interno sensible; cascade puede borrar historial | `NOT NULL`; conservar FK existente en A; cambio de `ON DELETE` requiere decisión separada | No añadir índice aún | Nunca | Sí, futura resolución desde catálogo |
| `started_at` | `TIMESTAMP`, default `now()` | Sí | Inicio ausente y semántica sin zona horaria | `NOT NULL`; conservar default; aplazar cambio a `TIMESTAMPTZ` | No | Sí | Sí |
| `last_message_at` | `TIMESTAMP`, default `now()` | Sí | Orden inestable si es null; posible fecha anterior al inicio | `NOT NULL`; conservar default; check `last_message_at >= started_at` | Orden descendente del índice estable | Sí | Sí |
| `status` | `TEXT`, default `active`, check `active/archived` | Sí | El check permite `NULL`; estados futuros inventados ampliarían superficie | `NOT NULL`; conservar default y solo `active`/`archived`; no añadir `deleted`, `closed` ni `draft` | No índice separado en A | Sí | Sí |
| `message_count` | `INT`, default `0` | Sí | Null o negativo; contador inconsistente | `NOT NULL`; conservar default `0`; check `message_count >= 0` | No | Sí provisionalmente | Sí |

`deleted`, `closed` y `draft` no se añaden porque no son necesarios para el
alcance aprobado. La eliminación lógica inicial es `archived`.

2B-IV-A no cambia tipos de timestamp, acciones `ON DELETE`, nombres públicos o
semántica de idempotencia. Esas decisiones tienen mayor impacto y requieren
gate independiente.

### Preflight obligatorio y estrategia de constraints

La migración futura debe comenzar con comprobaciones de catálogo y datos. Debe
fallar y hacer rollback completo si:

- falta la tabla o alguna columna esperada;
- existen policies o grants cliente inesperados;
- hay filas con `user_id`, `specialist_id`, `started_at`,
  `last_message_at`, `status` o `message_count` nulos;
- hay `status` fuera de `active`/`archived`;
- hay `message_count < 0`;
- hay `last_message_at < started_at`;
- las FKs existentes no apuntan a las tablas esperadas.

No se permite rellenar owners, especialistas, fechas, estados o contadores para
hacer pasar la migración. Si hay datos incompatibles, deben auditarse en un
paquete separado.

Orden conceptual futuro:

1. ejecutar preflight transaccional;
2. habilitar RLS y revocar grants cliente;
3. añadir checks nombrados de contador y coherencia temporal, preferiblemente
   `NOT VALID` y después `VALIDATE CONSTRAINT` para dejar evidencia explícita;
4. aplicar `NOT NULL` a las seis columnas endurecidas;
5. conservar defaults actuales aprobados;
6. conservar el check de estado limitado a `active`/`archived`;
7. crear el índice compuesto mínimo;
8. verificar postcondiciones y confirmar transacción.

### Índice mínimo propuesto

Sustituir el índice simple histórico `idx_chat_sessions_user` por un único
índice compuesto:

```text
(user_id, last_message_at DESC, id DESC)
```

Este índice cubre ownership, listado propio y orden estable sin añadir índices
de baja selectividad sobre `status`. El filtro opcional de estado se evaluará
dentro de las filas del owner. Solo se propondrá un índice adicional
`(user_id, status, last_message_at DESC, id DESC)` si fixtures y `EXPLAIN`
demuestran una necesidad real.

No se añade uniqueness en 2B-IV-A. Una restricción de sesión activa única
implicaría decidir idempotencia y comportamiento de producto, reservado para
2B-IV-C.

### Seguridad deny-all inicial

Estado objetivo futuro:

1. `ALTER TABLE public.chat_sessions ENABLE ROW LEVEL SECURITY`;
2. no usar `FORCE ROW LEVEL SECURITY`;
3. revocar todos los privilegios de tabla a `PUBLIC`, `anon` y
   `authenticated`;
4. comprobar cero policies en `public.chat_sessions`;
5. no crear policies permisivas;
6. denegar `SELECT`, `INSERT`, `UPDATE` y `DELETE` directos para cliente;
7. no exponer acceso PostgREST directo;
8. no modificar privilegios, RLS o estructura de `messages`.

El acceso privilegiado del harness local solo puede inspeccionar catálogo y
preparar pruebas. No cuenta como acceso cliente ni autoriza una frontera.

### Tests futuros obligatorios de 2B-IV-A

Esquema e integridad:

- tabla y siete columnas esperadas existen con tipos previstos;
- `id` conserva PK y default;
- `user_id`, `specialist_id`, `started_at`, `last_message_at`, `status` y
  `message_count` son `NOT NULL`;
- FKs siguen apuntando a `public.users(id)` y `public.specialists(id)`;
- solo `active` y `archived` son válidos;
- `message_count` acepta cero y rechaza negativos;
- `last_message_at = started_at` es válido y una fecha anterior se rechaza;
- defaults de estado, contador y timestamps producen valores aprobados;
- existe exactamente el índice compuesto mínimo esperado;
- no aparece uniqueness de sesión activa no aprobada.

Seguridad:

- RLS habilitada y FORCE RLS deshabilitado;
- cero policies;
- cero grants cliente efectivos;
- `anon` no puede leer, insertar, actualizar o borrar;
- `authenticated` no puede leer, insertar, actualizar o borrar;
- acceso directo PostgREST no confirma ninguna operación.

No regresión y entorno:

- estructura, RLS, policies y grants de `messages` quedan idénticos;
- no cambian Edge Functions, Flutter, catálogo ni otras tablas;
- preflight falla cerrado ante una fila incompatible;
- rollback y reaplicación se verifican localmente;
- anti-remoto demuestra ausencia de project link, deploy, db push y hosts no
  locales.

### Rollback local propuesto

El rollback es deliberadamente asimétrico:

- conserva RLS habilitada, sin FORCE RLS, cero policies y cero grants cliente;
- elimina únicamente los checks nuevos de contador/coherencia temporal;
- revierte `NOT NULL` solo si el rollback aprobado exige volver al esquema
  histórico y siempre dentro del entorno local;
- elimina el índice compuesto y recrea `idx_chat_sessions_user`;
- conserva FKs y defaults históricos;
- no toca `messages`.

Antes de retirar `NOT NULL`, el harness debe confirmar que no crea ni modifica
filas. No se borran ni transforman datos para ejecutar rollback. Tras rollback
se verifica deny-all; después se reaplica la migración y se repite toda la
suite.

La recomendación es que un rollback de emergencia de seguridad mantenga tanto
deny-all como los constraints ya validados. El rollback histórico completo se
usa solo para probar reversibilidad local, nunca para debilitar un entorno
activo.

### Relación con paquetes posteriores

- **2B-IV-B** podrá crear fixtures locales propios/ajenos únicamente cuando A
  demuestre integridad y deny-all; sigue bloqueado.
- **2B-IV-C** podrá diseñar/validar creación controlada y decidir idempotencia;
  sigue bloqueado.
- **2B-IV-D** podrá validar proyección, aislamiento, orden y cursor; sigue
  bloqueado.
- **2B-IV-E** podrá validar archivado lógico owner-only; sigue bloqueado.
- **2B-IV-F** podrá preparar Flutter desconectado después de contratos backend
  estables; sigue bloqueado.
- **2B-V** definirá `messages`, contador y actualización de
  `last_message_at`; sigue bloqueado.

Ningún paquete posterior queda autorizado por aprobar o implementar 2B-IV-A.

## Resultado local de 2B-IV-A

Fecha de implementación y verificación: 2026-06-14.

- Se creó `00005_harden_chat_sessions_deny_all.sql` sin modificar migraciones
  históricas.
- El preflight transaccional falla cerrado ante columnas/policies/FKs
  inesperadas o filas incompatibles, sin `UPDATE`, `DELETE`, backfill o
  transformación de datos.
- `user_id`, `specialist_id`, `started_at`, `last_message_at`, `status` y
  `message_count` quedaron `NOT NULL`.
- Se conservaron defaults aprobados y se añadieron checks para estado,
  contador no negativo y cronología.
- El índice histórico simple fue sustituido por
  `(user_id, last_message_at DESC, id DESC)`.
- `chat_sessions` quedó con RLS habilitada, sin FORCE, cero policies y cero
  grants cliente; CRUD directo de `anon` y `authenticated` fue denegado.
- `messages` mantuvo columnas, RLS y policies intactas.
- Harness específico 40/40 y suite SQL acumulada 180/180.
- El rollback asimétrico conservó deny-all y no tocó `messages`.
- El preflight fue demostrado con una fila ficticia incompatible: abortó sin
  endurecimiento parcial ni transformación; el fixture fue limpiado.
- Reset/reaplicación volvió a superar 40/40 y 180/180.
- Solo se usaron Docker y Supabase local en `127.0.0.1`; no se ejecutaron
  `link`, `deploy`, `db push`, remoto, seed o datos reales.
- 2B-IV-A queda implementado, verificado exclusivamente en local y cerrado
  formalmente. 2B-IV-B-F y 2B-V continúan bloqueados.

## Plan exacto 2B-IV-B — fixtures locales de `chat_sessions`

Estado: diseño documental preparado el 2026-06-14, pendiente de aprobación.
No autoriza crear fixtures, SQL nuevo, migraciones, seed, Edge Functions,
Flutter, operaciones de sesión, remoto o datos reales.

### Decisión obligatoria: fixtures transaccionales

2B-IV-B usará exclusivamente un harness SQL/pgTAP con:

```text
BEGIN
crear fixtures test_only
ejecutar assertions
ROLLBACK
verificar cero persistencia
```

Esta es la estrategia correcta porque todos los escenarios de B se validan
desde la misma conexión SQL. No existe Edge Function, HTTP ni segunda conexión
que necesite observar filas confirmadas.

En 2B-IV-B queda prohibido:

- crear o modificar `supabase/seed.sql`;
- añadir fixtures a una migración;
- crear scripts de setup que hagan `COMMIT`;
- dejar filas persistentes para reutilizarlas después;
- convertir identidades, especialistas, catálogo o sesiones ficticias en
  datos editoriales/reales;
- usar cleanup compensatorio como sustituto de `ROLLBACK`.

Los fixtures confirmados temporalmente con cleanup compensatorio **no se
autorizan en B**. Solo podrán proponerse en planes separados para C/D/E si una
Edge Function u otra frontera cross-connection necesita verlos. En ese caso
serán obligatorios `trap` instalado antes del setup, IDs allowlist, cleanup
idempotente, postcondiciones de cero filas y reset local como recuperación
secundaria. Esa posibilidad futura no autoriza seed persistente.

### Objetivo y fixtures propuestos

El harness futuro debe usar IDs UUID fijos, reservados y reconocibles, con
nombres/textos que incluyan `test_only_2b_iv_b`. Debe crear únicamente:

| Fixture conceptual | Tabla | Propósito | Persistencia |
| --- | --- | --- | --- |
| `owner_user` | `auth.users` + `public.users` | Propietario de dos sesiones | Transaccional |
| `other_user` | `auth.users` + `public.users` | Propietario de sesión ajena | Transaccional |
| `internal_specialist` | `public.specialists` | FK interna backend-only | Transaccional |
| `specialist_catalog_entry` | `public.specialist_catalog` | Relación pública `selectableSpecialistId -> specialist_id` | Transaccional |
| `owner_active_session` | `public.chat_sessions` | Sesión propia activa y más reciente | Transaccional |
| `owner_archived_session` | `public.chat_sessions` | Sesión propia archivada y más antigua | Transaccional |
| `other_user_session` | `public.chat_sessions` | Sesión ajena para aislamiento futuro | Transaccional |

Los fixtures no representan usuarios, agentes, especialistas o sesiones reales
de Stasisly. `prompt_template` interno debe usar únicamente un placeholder
`test_only`, nunca un prompt real.

### Dependencias y orden de creación

Orden obligatorio dentro de una única transacción:

1. crear `owner_user` y `other_user` ficticios en `auth.users`;
2. crear sus perfiles correspondientes en `public.users`;
3. crear un único `internal_specialist` ficticio en `public.specialists`;
4. crear una única entrada no real en `public.specialist_catalog` que apunte al
   especialista interno;
5. crear `owner_active_session`;
6. crear `owner_archived_session`;
7. crear `other_user_session`;
8. ejecutar assertions;
9. ejecutar `ROLLBACK`;
10. comprobar desde una nueva transacción que no persisten IDs
   `test_only_2b_iv_b`.

Las sesiones deben referenciar `public.users.id` y
`public.specialists.id`. La entrada de catálogo demuestra la separación entre
el futuro `selectableSpecialistId` público y `chat_sessions.specialist_id`
interno, pero B no ejecuta resolución backend ni operaciones create/list.

No se crean mensajes. No se necesita una fila en `messages` para que una
sesión sea válida en B.

### Escenarios futuros de prueba

#### Sesión propia activa

- owner igual a `owner_user`;
- `status = active`;
- `message_count = 0`;
- `last_message_at >= started_at`;
- timestamp más reciente que la sesión archivada;
- posición correcta al ordenar por
  `user_id, last_message_at DESC, id DESC`.

#### Sesión propia archivada

- owner igual a `owner_user`;
- `status = archived`;
- no se interpreta como activa;
- puede seleccionarse mediante filtro SQL privilegiado del harness;
- su visibilidad mediante API se decidirá y probará en D.

#### Sesión ajena

- owner igual a `other_user`;
- sirve como dato de referencia para aislamiento;
- acceso directo de `anon` y `authenticated` continúa denegado por A;
- B no afirma todavía aislamiento de una futura API, listado o archivado:
  esas garantías corresponden a D/E.

#### Filas inválidas

Mediante intentos revertidos dentro del harness:

- `user_id IS NULL` rechazado;
- `specialist_id IS NULL` rechazado;
- estado fuera de `active`/`archived` rechazado;
- `message_count < 0` rechazado;
- `last_message_at < started_at` rechazado.

Estas comprobaciones demuestran que A permanece vigente; no requieren insertar
filas inválidas persistentes.

### Seguridad y limpieza obligatorias

Durante y después del harness:

- `chat_sessions` conserva RLS habilitada, sin FORCE, cero policies y cero
  grants cliente;
- `anon` y `authenticated` continúan sin CRUD directo;
- `messages` conserva estructura, RLS, policies y cero filas fixture;
- no cambian Edge Functions, Flutter, migraciones ni catálogo persistente;
- antes del harness debe haber cero IDs `test_only_2b_iv_b`;
- después del `ROLLBACK` debe haber cero usuarios Auth/perfiles,
  especialistas, catálogo y sesiones `test_only_2b_iv_b`;
- la suite SQL acumulada debe pasar después del rollback;
- reset/reaplicación debe dejar igualmente cero fixtures.

Si el `ROLLBACK` o las postcondiciones fallan, B falla. El único mecanismo de
recuperación permitido es `supabase db reset --local --no-seed`; nunca se
declara éxito basándose solo en un cleanup parcial.

### Tests futuros obligatorios de 2B-IV-B

- crear exactamente dos usuarios/perfiles ficticios;
- crear exactamente un especialista interno y una entrada de catálogo;
- demostrar que ID público e interno son distintos;
- crear exactamente tres sesiones: activa propia, archivada propia y ajena;
- verificar owner, estados, contador, cronología y orden;
- verificar constraints inválidos sin persistencia;
- verificar índice owner/orden y deny-all de A;
- verificar CRUD directo denegado para `anon` y `authenticated`;
- verificar `messages` intacta y sin fixtures;
- verificar cero fixtures tras `ROLLBACK`;
- ejecutar suite SQL completa después del rollback;
- verificar cero fixtures después de reset/reaplicación;
- demostrar ausencia de seed, migración nueva, Edge Function, Flutter, tokens,
  project link y remoto.

### Relación con paquetes posteriores

2B-IV-B prepara únicamente datos y assertions locales transaccionales:

- no implementa `createOwnChatSession`; corresponde a C;
- no implementa `listOwnChatSessions`; corresponde a D;
- no implementa `archiveOwnChatSession`; corresponde a E;
- no implementa contrato Flutter; corresponde a F;
- no implementa `messages`; corresponde a 2B-V.

C/D/E podrán reutilizar los IDs y escenarios conceptuales, pero no podrán
depender de fixtures persistentes de B. Si requieren fixtures visibles desde
otra conexión, deberán crear y limpiar sus propios fixtures confirmados bajo
un plan y aprobación separados.

### Gates antes de implementar 2B-IV-B

1. aprobar fixtures exclusivamente transaccionales;
2. aprobar IDs/nombres `test_only_2b_iv_b` y cardinalidad exacta;
3. aprobar que catálogo/especialista son placeholders y no datos editoriales;
4. aprobar matriz de assertions y postcondiciones de cero persistencia;
5. confirmar que seed, setup confirmado y cleanup compensatorio están
   prohibidos en B;
6. mantener C-F, 2B-V, Edge Functions, Flutter y remoto bloqueados.

## Resultado local de 2B-IV-B

Fecha de implementación y verificación: 2026-06-14.

- El harness principal crea exactamente dos usuarios/perfiles, un especialista
  interno, una entrada de catálogo y tres sesiones solo dentro de
  `BEGIN/ROLLBACK`.
- Harness principal: 31/31 pruebas superadas.
- Postcondiciones desde una transacción nueva: 8/8 pruebas superadas.
- Suite SQL local acumulada: 219/219 pruebas superadas.
- Después del rollback, una consulta externa confirmó cero fixtures en
  `auth.users`, `public.users`, `public.specialists`,
  `public.specialist_catalog`, `public.chat_sessions` y cero filas en
  `public.messages`.
- No existe `COMMIT`, seed persistente, cleanup compensatorio, `DELETE` o
  `TRUNCATE` en los tests B. Ningún dato fixture fue confirmado.
- Los SHA-256 de todas las migraciones `00001`-`00005` permanecieron
  idénticos antes y después; ninguna migración fue modificada.
- Solo se usó Supabase local, sin link, push, despliegue, remoto, datos reales
  ni credenciales reales.
- B no autoriza operaciones de sesión. 2B-IV-C-F, 2B-V, Edge Functions,
  Flutter y remoto continúan bloqueados.

## Cierre formal de 2B-IV-B

Fecha de cierre: 2026-06-14.

2B-IV-B queda cerrado formalmente con harness 31/31, postcondiciones 8/8,
suite SQL acumulada 219/219, hashes de migraciones intactos y cero fixtures
persistidos tras `ROLLBACK`. No se usaron seed, fixtures confirmados, cleanup
compensatorio, remoto ni datos reales. Este cierre no autoriza 2B-IV-C-F,
2B-V, Edge Functions, Flutter, creación de sesiones ni conexión real.

## Plan exacto 2B-IV-C — Edge Function local `createOwnChatSession`

### Objetivo y frontera HTTP futura

2B-IV-C diseñará una Edge Function nueva, exclusivamente local/efímera:

```http
POST /functions/v1/create-own-chat-session
Authorization: Bearer <JWT_LOCAL_VALIDADO>
Content-Type: application/json
```

Único body permitido:

```json
{"selectableSpecialistId":"<specialist_catalog.id>"}
```

El parser debe exigir objeto JSON con exactamente esa clave y rechazar claves
adicionales, incluidas `user_id`, `userId`, `specialist_id`, `specialistId`,
`internalSpecialistId`, `status`, `message_count`, `started_at`,
`last_message_at`, `accessState`, `access_tier` y `availability_status`.

### Identidad, autorización y resolución

La función deberá:

1. exigir y validar JWT contra Auth local;
2. derivar owner exclusivamente de `sub`;
3. fallar cerrado ante JWT ausente, inválido o sesión no válida;
4. comprobar que el perfil owner existe sin crearlo ni repararlo;
5. resolver internamente
   `specialist_catalog.id -> specialist_catalog.specialist_id -> specialists.id`;
6. exigir entrada publicada, `availability_status = available`,
   `access_tier = free` y especialista interno existente;
7. bloquear `premium` hasta disponer de entitlement real;
8. no devolver ni registrar IDs internos, prompts o configuración sensible.

### Creación y confirmación

Cada invocación válida insertará exactamente una fila con owner derivado,
especialista interno resuelto, `status = active`, `message_count = 0` y
timestamps server-managed. No crea mensajes, no invoca IA y no llama Stasis
Engine. Solo existe éxito si la escritura y la proyección segura confirman
exactamente una fila; HTTP `204`, cero filas, múltiples filas o respuesta
ambigua fallan cerrado.

Respuesta pública de éxito propuesta:

```json
{
  "session": {
    "sessionId": "...",
    "selectableSpecialist": {"id": "...", "displayName": "...", "area": "..."},
    "startedAt": "...",
    "lastMessageAt": "...",
    "status": "active",
    "messageCount": 0
  }
}
```

No devuelve `user_id`, `specialist_id`, `specialists.id`, `prompt_template`,
`access_tier`, `availability_status`, roles o permisos.

### Decisión de idempotencia para MVP local

Se recomienda y aprueba como dirección documental para el MVP local:

**Opción A: cada invocación válida y confirmada crea siempre una sesión nueva.**

Razones:

- “crear sesión” conserva una semántica explícita y predecible;
- una sesión activa existente puede representar otra conversación;
- reutilizarla mezclaría contexto sin consentimiento y convertiría la
  operación en `get-or-create`;
- no existe una razón de producto, constraint de unicidad ni contrato de
  ciclo de vida que justifique reutilización automática;
- permite varias sesiones activas del mismo usuario con el mismo especialista.

Consecuencia aceptada: un reintento posterior a una respuesta perdida puede
crear un duplicado. Para el MVP local se mitiga con confirmación exacta,
cliente sin reintentos automáticos y rate limiting futuro. No se añade índice
único ni búsqueda de sesión activa.

**Opción B, reutilizar activa existente, queda rechazada para MVP.**

**Opción C, `Idempotency-Key`, queda recomendada antes de remoto/producción.**
Deberá diseñarse en paquete separado con clave opaca, scope por owner y
operación, hash del payload, ventana temporal, almacenamiento y respuesta
reproducible. No puede inferirse idempotencia a partir de
`owner + specialist`.

### Errores y HTTP recomendados

| Error | HTTP | Regla |
| --- | --- | --- |
| `unauthenticated` | 401 | JWT ausente |
| `invalidSession` | 401 | JWT inválido o sesión no válida |
| `invalidRequest` | 400 | JSON o campo requerido inválido |
| `contractViolation` | 400 | Campos adicionales/prohibidos |
| `invalidSelectableSpecialist` | 404 | ID público inexistente/no publicado sin filtrar detalles |
| `specialistUnavailable` | 409 | No disponible o interno no utilizable |
| `premiumLocked` | 403 | Premium sin entitlement |
| `permissionDenied` | 403 | Operación no autorizada |
| `backendMisconfigured` | 503 | Configuración local inválida; sin detalles sensibles |
| `networkError` | 503 | Dependencia local no disponible |
| `unexpectedError` | 500 | Fallo cerrado y log seguro |

### Tests futuros obligatorios

- rechazar JWT ausente/inválido y todos los campos prohibidos;
- rechazar especialista inexistente, no publicado, no disponible o premium;
- crear exactamente una sesión por cada invocación válida;
- dos invocaciones válidas crean dos sesiones distintas, incluso para el
  mismo owner y especialista;
- no buscar ni reutilizar una sesión activa existente;
- derivar owner del JWT y resolver el especialista interno correcto;
- devolver solo la proyección pública aprobada;
- no crear mensajes ni modificar catálogo/especialista;
- tratar respuesta ambigua como fallo;
- usar fixtures locales con cleanup obligatorio y postcondición cero;
- logs sin JWT, secretos, prompts ni IDs internos;
- demostrar host local y ausencia de link, deploy, `db push` o remoto.

### Seguridad, anti-remoto y paquetes posteriores

Si se autoriza implementación, `service_role` solo podrá existir en el proceso
local/efímero de la función, nunca en Flutter ni versionado. La función debe
fallar cerrado ante host no local. C crea; D lista; E archiva; F define
contrato Flutter; 2B-V implementará mensajes. C no implementa ninguno de esos
paquetes.

### Gates antes de implementar 2B-IV-C

1. aprobar explícitamente la Edge Function nueva exclusivamente local;
2. aprobar opción A de idempotencia y el riesgo controlado de duplicado por
   reintento;
3. aprobar contrato HTTP, errores y proyección pública;
4. aprobar identidad técnica local, fixtures confirmados temporales y cleanup;
5. mantener D-F, 2B-V, Flutter, remoto y producción bloqueados.

## Resultado local de 2B-IV-C — `createOwnChatSession`

Fecha de implementación y verificación: 2026-06-14.

- Se creó una Edge Function local separada que acepta exclusivamente
  `selectableSpecialistId`, valida el JWT contra Auth local y deriva owner de
  la identidad validada.
- Resuelve catálogo e ID interno mediante acceso técnico local/efímero,
  bloquea catálogo inexistente, no disponible o premium, y crea exactamente
  una sesión activa por invocación válida.
- Idempotencia MVP verificada: dos llamadas válidas con el mismo owner y
  especialista crearon dos `sessionId` distintos y dos filas activas
  distintas; no se buscó ni reutilizó una sesión previa.
- Las respuestas HTTP contienen únicamente la proyección pública aprobada.
  Los tests comprobaron ausencia de `user_id`, `specialist_id`, el valor del
  ID interno, prompts y configuración interna.
- `messages` conservó exactamente su cardinalidad inicial y no recibió filas.
  Catálogo y especialistas conservaron su contenido.
- Harness HTTP local: PASS. Tests Deno acumulados: 17/17. Suite SQL:
  219/219. Postcondición externa: `0|0|0|0|0|0`.
- Fixtures confirmados `test_only_2b_iv_c` se usaron solo porque la función
  opera desde otra conexión; cleanup compensatorio y postcondiciones cero
  fueron obligatorios.
- No se modificaron migraciones, Flutter, CI o `messages`; no hubo link,
  deploy, `db push`, remoto, datos reales, IA ni Stasis Engine.

### Riesgos residuales de 2B-IV-C

- La validación, resolución e inserción se realizan mediante varias llamadas
  REST privilegiadas y no forman una única transacción. Antes de remoto debe
  diseñarse atomicidad o una recuperación segura ante fallo posterior al
  insert.
- Un reintento tras perder la respuesta crea otra sesión por decisión MVP.
  `Idempotency-Key` y rate limiting siguen pendientes antes de remoto.
- `service_role` solo está aceptado para este experimento local/efímero; no
  constituye la frontera permanente de producción.
- 2B-IV-D/E/F y 2B-V continúan bloqueados.

## Cierre formal de 2B-IV-C

Fecha de cierre: 2026-06-14.

2B-IV-C queda cerrado formalmente con HTTP local PASS, Deno 17/17, SQL
219/219, cleanup `0|0|0|0|0|0`, migraciones intactas y anti-remoto
verificado. Se acepta exclusivamente como riesgo local que las llamadas REST
privilegiadas no son atómicas. Antes de remoto siguen siendo obligatorios el
diseño de atomicidad, `Idempotency-Key`, reintentos y control de duplicados.

## Plan exacto 2B-IV-D — Edge Function local `listOwnChatSessions`

### Objetivo y contrato HTTP futuro

2B-IV-D diseñará una Edge Function nueva, exclusivamente local/efímera:

```http
GET /functions/v1/list-own-chat-sessions
Authorization: Bearer <JWT_LOCAL_VALIDADO>
Accept: application/json
```

Parámetros permitidos, como máximo una vez cada uno:

```text
status=active|archived|all
limit=1..50
cursor=<cursor-opaco>
```

Defaults:

```text
status=active
limit=20
cursor ausente
```

Todo parámetro desconocido, repetido o de autoridad, incluidos `user_id`,
`userId`, `specialist_id`, `specialistId`, `internalSpecialistId`, roles,
permisos, `access_tier` o `availability_status`, produce `invalidRequest`.

### Identidad y ownership

La función deberá exigir y validar JWT contra Auth local, derivar owner
exclusivamente desde `sub` y consultar siempre:

```text
chat_sessions.user_id = owner derivado
```

Nunca acepta owner del cliente ni confía en filtrado Flutter. Usuario A no
puede observar, contar, inferir o paginar sesiones de B. JWT ausente o inválido
falla antes de consultar sesiones.

### Proyección pública

Respuesta futura:

```json
{
  "items": [
    {
      "sessionId": "...",
      "selectableSpecialist": {
        "id": "...",
        "displayName": "...",
        "area": "..."
      },
      "startedAt": "...",
      "lastMessageAt": "...",
      "status": "active",
      "messageCount": 0
    }
  ],
  "nextCursor": null
}
```

La función puede consultar internamente `user_id` y `specialist_id`, pero debe
eliminarlos antes de construir la respuesta. Nunca devuelve IDs internos,
prompts, publicación, disponibilidad, tier, roles, permisos, JWT o secretos.
No usa `SELECT *`.

### Filtros, orden y cursor

- `status=active` es el default MVP para reducir ruido y evitar mezclar
  conversaciones archivadas.
- `status=archived` lista solo archivadas.
- `status=all` lista ambos estados aprobados; cualquier otro estado falla.
- `limit` debe ser entero decimal canónico entre 1 y 50; default 20.
- Orden obligatorio:

```text
last_message_at DESC, id DESC
```

Cursor opaco propuesto: Base64URL sin padding de JSON UTF-8 con exactamente:

```json
{"v":1,"lastMessageAt":"<timestamp-devuelto>","sessionId":"<uuid>"}
```

El decoder debe limitar longitud, validar Base64URL, JSON, claves exactas,
versión, timestamp y UUID. Cursor inválido produce `invalidCursor`; nunca se
ignora ni se interpreta parcialmente. La consulta keyset futura aplica:

```text
last_message_at < cursor.lastMessageAt
OR (last_message_at = cursor.lastMessageAt AND id < cursor.sessionId)
```

Se solicitan `limit + 1` filas para decidir `nextCursor`, pero se devuelven
como máximo `limit`. Lista vacía es éxito válido con `nextCursor = null`.

### Decisión MVP: sesión sin catálogo público resoluble

Cada sesión devuelta debe resolver **exactamente una** entrada de
`specialist_catalog` publicada asociada a su `specialist_id` interno.

Si una sesión apunta a un especialista que ya no aparece en catálogo, cuya
entrada fue eliminada/no publicada, o no puede resolverse exactamente una
entrada pública:

- fallar cerrado con `contractViolation`;
- abortar la respuesta completa, sin devolver lista parcial;
- no omitir silenciosamente la sesión;
- no inventar nombre, área, ID público ni placeholder;
- no reutilizar datos internos de `public.specialists`;
- registrar solo un evento seguro sin IDs internos.

Justificación: la relación sesión-catálogo forma parte del contrato público.
Una ausencia indica incoherencia de datos o ciclo de vida no diseñado, no una
condición normal del usuario. Omitir ocultaría historial; un placeholder
presentaría información inventada; devolver datos internos rompería la
frontera.

Se reserva `backendMisconfigured` para imposibilidad operativa de ejecutar la
función: configuración local inválida, secreto técnico ausente, host no local
o dependencia backend no disponible. Una respuesta backend con forma
inesperada o una sesión no resoluble es `contractViolation`, no
`backendMisconfigured`.

Antes de producción deberá diseñarse el ciclo de vida editorial/histórico:
retención de una proyección inmutable, catálogo tombstone sanitizado o regla
equivalente. Ese diseño no forma parte de D.

### Errores y HTTP recomendados

| Error | HTTP | Regla |
| --- | --- | --- |
| `unauthenticated` | 401 | JWT ausente |
| `invalidSession` | 401 | JWT inválido o sesión no válida |
| `invalidRequest` | 400 | Parámetro desconocido, repetido o de autoridad |
| `invalidStatus` | 400 | Estado fuera de `active`, `archived`, `all` |
| `invalidCursor` | 400 | Cursor malformado, incompatible o no canónico |
| `permissionDenied` | 403 | Operación no autorizada |
| `contractViolation` | 502 | Datos/forma inesperados o sesión sin catálogo resoluble |
| `backendMisconfigured` | 503 | Configuración/dependencia local inválida |
| `unexpectedError` | 500 | Fallo cerrado no clasificado |

### Tests futuros obligatorios

- rechazar JWT ausente/inválido antes de consultar sesiones;
- rechazar parámetros desconocidos, repetidos, `user_id` y `specialist_id`;
- listar solo sesiones del owner derivado y nunca sesiones ajenas;
- verificar `active` por defecto, filtros `archived` y `all`;
- validar límites 1, 20, 50 y rechazar 0, 51, negativos/no enteros;
- validar orden estable y cursor entre páginas sin duplicados ni saltos;
- devolver lista vacía válida;
- resolver cada sesión a exactamente una entrada publicada de catálogo;
- provocar sesión con catálogo ausente/no publicado y exigir
  `contractViolation`, respuesta sin `items` y sin placeholder;
- comprobar que una sola sesión inconsistente aborta toda la página;
- comprobar respuesta sin `user_id`, `specialist_id`, IDs internos o prompts;
- no crear/modificar sesiones, mensajes, catálogo o especialistas;
- logs sin secretos ni IDs internos;
- fixtures locales con cleanup y postcondiciones cero;
- demostrar host local y ausencia de link, deploy, `db push` o remoto.

### Seguridad, anti-remoto y paquetes posteriores

Si se autoriza implementación, `service_role` solo podrá usarse dentro del
runtime local/efímero, nunca en Flutter ni versionado. El host debe pertenecer
a la allowlist local y fallar cerrado en otro caso. D solo lista: E archivará,
F definirá contrato Flutter y 2B-V implementará mensajes.

### Gates antes de implementar 2B-IV-D

1. aprobar Edge Function nueva exclusivamente local;
2. aprobar `active` por defecto, límites y cursor opaco exacto;
3. aprobar `contractViolation` y aborto completo ante catálogo inconsistente;
4. aprobar identidad técnica local, fixtures confirmados y cleanup;
5. mantener E/F, 2B-V, Flutter, remoto y producción bloqueados.

## Resultado local de 2B-IV-D — `listOwnChatSessions`

Fecha de implementación y verificación: 2026-06-14.

- Se creó una Edge Function local separada que valida JWT contra Auth local,
  deriva owner y lista exclusivamente sesiones de ese owner.
- `active` funciona como default; `archived` y `all` son filtros explícitos.
  Parámetros desconocidos, internos o de autoridad fallan cerrado.
- El cursor Base64URL estricto usa `lastMessageAt + sessionId` y orden keyset
  `last_message_at DESC, id DESC`.
- El harness dividió tres sesiones activas propias en páginas de dos y una,
  incluyendo empate de timestamp, y confirmó tres IDs únicos sin duplicados.
- Ownership verificado: usuario A no recibió sesiones de B y B solo recibió
  su propia sesión.
- Ante una sesión sin catálogo publicado resoluble, la función devolvió
  `502 contractViolation` sin clave `items`, sin lista parcial y sin
  placeholder.
- Todas las respuestas exitosas fueron escaneadas y no contienen `user_id`,
  `specialist_id`, IDs internos, prompts o configuración sensible.
- La función no creó, modificó ni archivó sesiones; `messages`, catálogo y
  especialistas permanecieron intactos.
- Harness HTTP local: PASS. Tests Deno acumulados: 24/24. Suite SQL:
  219/219. Cleanup externo: `0|0|0|0|0|0`.
- No se modificaron migraciones, Flutter, CI o `messages`; no hubo link,
  deploy, `db push`, remoto, datos reales, IA ni Stasis Engine.

### Riesgos residuales de 2B-IV-D

- El listado realiza consultas REST separadas para sesiones y catálogo; entre
  ambas puede existir una carrera que se tratará como `contractViolation`.
- Una sesión histórica cuyo catálogo deje de publicarse bloquea toda la
  página por decisión MVP. Antes de producción debe diseñarse retención
  histórica o tombstone sanitizado.
- `service_role` sigue limitado al experimento local/efímero.
- 2B-IV-E/F y 2B-V continúan bloqueados.

## Cierre formal de 2B-IV-D

Fecha de cierre: 2026-06-14.

2B-IV-D queda cerrado formalmente con HTTP local PASS, Deno 24/24, SQL
219/219, cleanup `0|0|0|0|0|0`, migraciones intactas y anti-remoto
verificado. Se acepta como riesgo local que las consultas de sesiones y
catálogo no son atómicas. Antes de producción sigue pendiente diseñar
retención histórica o tombstone sanitizado.

## Plan exacto 2B-IV-E — Edge Function local `archiveOwnChatSession`

### Objetivo y contrato HTTP futuro

2B-IV-E diseñará una Edge Function nueva, exclusivamente local/efímera:

```http
POST /functions/v1/archive-own-chat-session
Authorization: Bearer <JWT_LOCAL_VALIDADO>
Content-Type: application/json
Accept: application/json
```

Único body permitido:

```json
{"sessionId":"<chat_sessions.id>"}
```

El parser debe exigir objeto JSON con exactamente esa clave y UUID válido.
Rechaza cualquier campo adicional, especialmente `user_id`, `userId`,
`specialist_id`, `specialistId`, `internalSpecialistId`, `status`,
`newStatus`, `message_count`, `messageCount`, `started_at`,
`last_message_at`, roles o permisos.

### Identidad, ownership y transición

La función deberá validar JWT contra Auth local, derivar owner desde `sub` y
ejecutar una mutación restringida conceptualmente por:

```text
id = sessionId recibido
user_id = owner derivado
status = active
```

La única columna actualizada será:

```text
status = archived
```

No existe delete físico, reactivación, update genérico ni cambio de owner,
especialista, timestamps o contador.

### Decisión MVP: conservar `last_message_at`

Al archivar se conservará exactamente el valor previo de `last_message_at`.

Razones:

- archivar no crea un mensaje ni actividad conversacional;
- modificarlo falsearía el orden cronológico usado por D;
- 2B-V será el único paquete autorizado para actualizarlo al persistir
  mensajes;
- evita que una acción administrativa parezca una conversación reciente.

También deben conservarse exactamente `started_at`, `message_count`,
`user_id`, `specialist_id` e `id`. Los tests compararán la fila completa antes
y después y permitirán únicamente el cambio `active -> archived`.

### Confirmación exacta y no filtración

Éxito requiere HTTP `200`, exactamente una fila propia previamente `active`,
el mismo `sessionId` y `status = archived`. HTTP `204`, cero filas, múltiples
filas, ID inesperado o respuesta con columnas extra producen
`archiveUnconfirmed` o `contractViolation`, nunca éxito.

Sesión inexistente, ajena o ya archivada debe producir el mismo resultado
externo opaco `sessionNotFound` para no filtrar existencia ni ownership. La
función no realizará una consulta previa distinguible desde cliente.

### Decisión MVP: respuesta pública mínima

Respuesta aprobada para MVP local:

```json
{"session":{"sessionId":"...","status":"archived"}}
```

Se rechaza la proyección completa para E porque:

- el objetivo es confirmar una transición, no volver a listar;
- evita resolver catálogo y heredar sus riesgos de consistencia;
- reduce exposición de datos y acoplamiento con D;
- Flutter podrá refrescar o actualizar localmente el estado mediante su
  contrato futuro.

La respuesta debe contener exactamente `sessionId` y `status`. Nunca devuelve
`user_id`, `specialist_id`, timestamps, `message_count`, catálogo, prompts,
roles, permisos o secretos.

### Errores y HTTP recomendados

| Error | HTTP | Regla |
| --- | --- | --- |
| `unauthenticated` | 401 | JWT ausente |
| `invalidSession` | 401 | JWT inválido o sesión no válida |
| `invalidRequest` | 400 | Body inválido, extra o campo prohibido |
| `sessionNotFound` | 404 | Inexistente, ajena o ya archivada; mismo resultado opaco |
| `permissionDenied` | 403 | Frontera no autorizada sin filtrar recurso |
| `archiveUnconfirmed` | 502 | HTTP 204, cero/múltiples filas o confirmación ambigua |
| `contractViolation` | 502 | Respuesta/forma/estado inesperado |
| `backendMisconfigured` | 503 | Configuración/dependencia local inválida |
| `unexpectedError` | 500 | Fallo cerrado no clasificado |

### Tests futuros obligatorios

- rechazar JWT ausente/inválido y campos adicionales/prohibidos;
- owner A archiva exactamente una sesión activa propia;
- A no archiva sesión de B;
- inexistente, ajena y ya archivada devuelven el mismo `sessionNotFound`;
- solo cambia `status` de `active` a `archived`;
- conservar exactamente `last_message_at`, `started_at`, `message_count`,
  owner, especialista e ID;
- impedir reactivación, delete físico y estados arbitrarios;
- exigir exactamente una fila confirmada y rechazar 204/cero/múltiples;
- respuesta contiene exactamente `sessionId` y `status`;
- respuesta sin IDs internos, timestamps, contador, catálogo o prompts;
- no crear/modificar mensajes, catálogo o especialistas;
- logs sin secretos ni IDs internos;
- fixtures locales con cleanup y postcondiciones cero;
- demostrar host local y ausencia de link, deploy, `db push` o remoto.

### Seguridad, anti-remoto y paquetes posteriores

Si se autoriza implementación, `service_role` solo podrá usarse dentro del
runtime local/efímero, nunca en Flutter ni versionado. El host debe pertenecer
a la allowlist local y fallar cerrado en otro caso. E solo archiva: F definirá
contrato Flutter y 2B-V implementará mensajes.

### Gates antes de implementar 2B-IV-E

1. aprobar Edge Function nueva exclusivamente local;
2. aprobar conservación exacta de `last_message_at` y resto de campos;
3. aprobar respuesta mínima exacta `{sessionId,status}`;
4. aprobar resultado opaco común para inexistente/ajena/archivada;
5. aprobar identidad técnica local, fixtures confirmados y cleanup;
6. mantener F, 2B-V, Flutter, remoto y producción bloqueados.

## Resultado local de 2B-IV-E — `archiveOwnChatSession`

Fecha de implementación y verificación: 2026-06-14.

- Se creó una Edge Function local separada que valida JWT contra Auth local,
  deriva owner y realiza un único `PATCH` filtrado por `id + owner + active`.
- El body técnico actualiza exclusivamente `{"status":"archived"}` y la
  confirmación solicita únicamente `id,status`.
- Un snapshot completo antes/después demostró que solo cambió `status` de
  `active` a `archived`.
- `last_message_at` permaneció exactamente `2026-06-14T12:34:56`; también
  permanecieron idénticos `started_at`, `message_count`, `user_id`,
  `specialist_id` e `id`.
- Sesión ajena, ya archivada, inexistente y segundo intento devolvieron el
  mismo `404 sessionNotFound`, con la misma forma opaca y sin filtrar estado,
  existencia u ownership.
- La respuesta exitosa contiene exactamente
  `{"session":{"sessionId":"...","status":"archived"}}` y no expone IDs
  internos, timestamps, contador, catálogo o prompts.
- Otras sesiones, `messages`, catálogo y especialistas permanecieron intactos.
- Harness HTTP local: PASS. Tests Deno acumulados: 29/29. Suite SQL:
  219/219. Cleanup externo: `0|0|0|0|0|0`.
- No se modificaron migraciones, Flutter, CI o `messages`; no hubo link,
  deploy, `db push`, remoto, datos reales, IA ni Stasis Engine.

### Riesgos residuales de 2B-IV-E

- El uso de `service_role` sigue limitado al experimento local/efímero.
- El resultado opaco evita filtración, pero no distingue UX de “ya archivada”;
  esa elección deberá mantenerse o revisarse explícitamente antes de remoto.
- 2B-IV-F y 2B-V continúan bloqueados.

## Cierre formal de 2B-IV-E y plan exacto 2B-IV-F — contrato Flutter desconectado para sesiones

Fecha: 2026-06-14.

### Cierre formal de 2B-IV-E

2B-IV-E queda cerrado formalmente con evidencia local suficiente: HTTP PASS,
Deno 29/29, SQL 219/219, cleanup `0|0|0|0|0|0`, mutación exclusiva de
`status`, conservación exacta de `last_message_at` y respuesta pública mínima.
Este cierre no autoriza remoto, producción, Flutter-backend, mensajes ni uso
de datos reales.

### Objetivo y frontera de 2B-IV-F

2B-IV-F preparará en una implementación futura un contrato Flutter nuevo,
pequeño y completamente desconectado para crear, listar y archivar sesiones.
Su propósito es representar el contrato público ya validado sin ejecutar
ninguna llamada de red.

La auditoría puntual confirma que el contexto heredado `lib/features/chat/`
contiene `userId`, `specialistId` y un datasource Supabase directo. 2B-IV-F
no podrá reutilizar, ampliar, renombrar silenciosamente ni presentar ese
contrato como seguro. Su sustitución o migración requerirá un paquete separado.

Gate principal: durante 2B-IV-F Flutter no se conectará a las Edge Functions.
El nuevo contexto no contendrá datasource HTTP/Supabase ejecutable, URLs,
nombres invocables de funciones, cliente Supabase ni provider que seleccione
un repositorio remoto.

### Modelos públicos futuros

Modelo `OwnChatSession`:

- `sessionId`;
- `selectableSpecialist`, como resumen público sanitizado;
- `startedAt`;
- `lastMessageAt`;
- `status`;
- `messageCount`.

La condición demo se representa mediante resultados tipados demo, no mediante
un campo adicional del modelo público, para que la proyección permanezca
exactamente dentro del alcance aprobado.

Modelo `SelectableSpecialistSummary`:

- `id`, que representa exclusivamente el ID público del catálogo seleccionable;
- `displayName`;
- `area`.

Modelos auxiliares:

- `ChatSessionStatus`: `active`, `archived`;
- `ChatSessionStatusFilter`: `active`, `archived`, `all`;
- `OwnChatSessionsPage`: `items` y `nextCursor` opaco;
- `ArchivedOwnChatSession`: únicamente `sessionId` y `status=archived`.

Quedan prohibidos en todos los modelos, resultados y contratos públicos
nuevos: `userId`, `user_id`, `specialistId`, `specialist_id`,
`internalSpecialistId` y cualquier alias que oculte esos mismos conceptos.
También quedan fuera roles, permisos, prompts, configuración interna y
atributos no incluidos en la proyección pública aprobada.

### Resultados tipados futuros

Cada operación usará un resultado cerrado y exhaustivo; ninguna excepción
genérica podrá convertirse silenciosamente en demo o éxito.

- Crear: éxito con `OwnChatSession`; `unauthenticated`, `invalidSession`,
  `invalidRequest`, `invalidSelectableSpecialist`, `specialistUnavailable`,
  `premiumLocked`, `permissionDenied`, `contractViolation`,
  `backendBlocked`, `networkError` o `unexpectedError`.
- Listar: éxito con `OwnChatSessionsPage`; `unauthenticated`,
  `invalidSession`, `invalidRequest`, `invalidStatus`, `invalidCursor`,
  `permissionDenied`, `contractViolation`, `backendBlocked`, `networkError`
  o `unexpectedError`.
- Archivar: éxito con `ArchivedOwnChatSession`; `unauthenticated`,
  `invalidSession`, `invalidRequest`, `sessionNotFound`, `permissionDenied`,
  `archiveUnconfirmed`, `contractViolation`, `backendBlocked`,
  `networkError` o `unexpectedError`.

### Repositorio Flutter desconectado

Contrato futuro recomendado:

```dart
abstract interface class OwnChatSessionsRepository {
  Future<CreateOwnChatSessionResult> createOwnChatSession({
    required String selectableSpecialistId,
  });

  Future<ListOwnChatSessionsResult> listOwnChatSessions({
    ChatSessionStatusFilter status = ChatSessionStatusFilter.active,
    int limit = 20,
    String? cursor,
  });

  Future<ArchiveOwnChatSessionResult> archiveOwnChatSession({
    required String sessionId,
  });
}
```

El contrato no recibe owner, `userId`, ID interno de especialista ni campos
gestionados por servidor. Tampoco importa Supabase, HTTP o Edge Functions.

Implementaciones futuras permitidas dentro de F:

- `DemoOwnChatSessionsRepository`: memoria local determinista, datos
  explícitamente demo, cada creación genera una sesión distinta, listado y
  archivado solo locales;
- `BackendBlockedOwnChatSessionsRepository`: devuelve siempre
  `backendBlocked`, sin red y sin fallback demo;
- validador estricto de payload contractual inyectado: rechaza campos extra,
  IDs internos, formas parciales y estados desconocidos, sin llamar backend.

No se autoriza un repositorio remoto, datasource real ni provider que invoque
las Edge Functions. En cualquier modo no demo, el provider deberá seleccionar
`BackendBlockedOwnChatSessionsRepository`.

### Filtros, cursor y validación cliente mínima

- listado por defecto `active`, límite por defecto 20 y máximo 50;
- el cursor es opaco: Flutter solo lo conserva y reenvía en un paquete futuro;
  no lo decodifica, construye ni interpreta;
- Flutter puede validar presencia/formato básico de `selectableSpecialistId`,
  `sessionId`, límite y filtro;
- Flutter no decide ownership, autenticación, permisos, premium,
  disponibilidad, existencia interna del especialista o existencia de sesión.

### Tests futuros obligatorios de 2B-IV-F

- demo explícita, determinista y sin red;
- dos creaciones demo producen dos sesiones distintas y cero mensajes;
- backend bloqueado devuelve resultado tipado y nunca cae a demo;
- modelos y repositorio nuevos no contienen `userId`, `user_id`,
  `specialistId`, `specialist_id`, `internalSpecialistId` ni alias internos;
- el nuevo contexto no importa `supabase_flutter`, clientes HTTP ni el
  datasource Supabase heredado;
- el nuevo contexto no contiene llamadas, URLs o nombres invocables de
  `create-own-chat-session`, `list-own-chat-sessions` o
  `archive-own-chat-session`;
- validación estricta rechaza campos internos, extras, estados desconocidos y
  respuestas parciales;
- cursor tratado como opaco y sin duplicación en el repositorio demo;
- archivar cambia solo estado y conserva `lastMessageAt`;
- rutas existentes y modo demo siguen funcionando sin conectar backend.

Los tests arquitectónicos se limitarán al nuevo contexto para ser concretos y
mantenibles; no fingirán que el contrato heredado ya fue corregido.

### Relación con paquetes posteriores y gates

- 2B-IV-F no conecta Flutter con backend y no corrige todavía el chat heredado.
- Un paquete posterior separado deberá diseñar adaptadores HTTP reales,
  autenticación, mapeo de errores y sustitución controlada del legado.
- 2B-V/messages continúa bloqueado.
- Antes de implementar F deben aprobarse explícitamente el contexto nuevo, los
  modelos públicos sin IDs internos, repositorios demo/bloqueado y tests
  arquitectónicos anti-conexión.

## Resultado de implementación 2B-IV-F — contrato Flutter desconectado

Fecha: 2026-06-14.

- Se creó un contexto nuevo y autocontenido en `lib/features/chat_sessions/`;
  el contexto heredado `lib/features/chat/` permaneció intacto.
- Los modelos públicos implementados son `OwnChatSession`,
  `SelectableSpecialistSummary`, `OwnChatSessionsPage`,
  `ArchivedOwnChatSession`, `ChatSessionStatus` y
  `ChatSessionStatusFilter`.
- Los modelos, resultados, repositorio y fuente contractual pública no
  contienen `userId`, `user_id`, `specialistId`, `specialist_id`,
  `internalSpecialistId`, owner aliases, prompts, roles o permisos.
- `SelectableSpecialistSummary.id` representa exclusivamente el ID público del
  catálogo seleccionable.
- Se implementaron resultados sellados para crear, listar y archivar, con
  errores tipados visibles y sin fallback silencioso a demo.
- `DemoOwnChatSessionsRepository` opera solo en memoria, identifica el
  resultado como demo, crea una sesión distinta por llamada, genera cero
  mensajes, pagina mediante cursor opaco y archiva cambiando solo estado.
- `BackendBlockedOwnChatSessionsRepository` devuelve siempre
  `backendBlocked`, sin red ni fallback demo.
- `ValidatingOwnChatSessionsRepository` valida payloads simulados con forma
  exacta, rechaza campos internos, sensibles, extra, parciales o duplicados y
  no contiene adaptador de I/O.
- No existe datasource HTTP/Supabase ejecutable, provider remoto, URL,
  invocación de Edge Function ni import de backend real dentro del contexto.
- Los tests arquitectónicos inspeccionan el nuevo contexto completo para
  impedir imports Supabase/HTTP, llamadas de red, nombres invocables de Edge
  Functions e IDs internos en contratos públicos.
- Verificación específica inicial: 14/14 tests. La verificación completa queda
  registrada en el tracker.
- La conexión Flutter-backend, sustitución del chat heredado, UI, 2B-V,
  remoto, producción y datos reales continúan bloqueados.

## Cierre formal de 2B-IV-F y plan exacto 2B-IV-G — datasource Flutter HTTP local

Fecha: 2026-06-14.

### Cierre formal de 2B-IV-F

2B-IV-F queda cerrado formalmente. Se acepta como evidencia:

- contexto nuevo `lib/features/chat_sessions/` separado del chat heredado;
- contratos públicos sin owner, `userId`, `specialistId` interno ni alias;
- repositorios demo, backend bloqueado y validación contractual sin I/O;
- cero imports Supabase/HTTP real, llamadas de red o Edge Functions;
- tests específicos 14/14 y suite completa 63/63;
- `build_runner` con 0 salidas;
- análisis sin avisos del nuevo paquete y 48 infos preexistentes fuera de F;
- `git diff --check` correcto.

Este cierre no autoriza todavía implementar G ni conectar Flutter con backend.

### Estado global de 2B-IV A-F

Quedan completados y cerrados formalmente:

| Subpaquete | Estado cerrado | Frontera conservada |
| --- | --- | --- |
| 2B-IV-A | `chat_sessions` endurecida localmente con deny-all y constraints | Sin operaciones cliente |
| 2B-IV-B | Fixtures transaccionales locales | Sin seed ni datos persistentes |
| 2B-IV-C | Creación local mediante Edge Function | Sin Flutter, mensajes o remoto |
| 2B-IV-D | Listado local mediante Edge Function | Sin Flutter, mensajes o remoto |
| 2B-IV-E | Archivado local mediante Edge Function | Sin Flutter, mensajes o remoto |
| 2B-IV-F | Contrato Flutter desconectado | Sin HTTP, Supabase o Edge Functions |

### Objetivo limitado de 2B-IV-G

2B-IV-G podrá implementar, solo tras aprobación separada, un datasource HTTP
Flutter destinado exclusivamente a validar contra las tres Edge Functions
locales ya existentes:

- `POST /functions/v1/create-own-chat-session`;
- `GET /functions/v1/list-own-chat-sessions`;
- `POST /functions/v1/archive-own-chat-session`.

G no habilitará backend real remoto, producción, Supabase remoto, mensajes,
IA, Stasis Engine, datos reales ni sustitución completa del chat heredado.

### Frontera Flutter HTTP local futura

Nombre recomendado: `LocalHttpOwnChatSessionsDataSource`.

Responsabilidades exclusivas:

1. recibir un host local previamente validado;
2. obtener un JWT local mediante un proveedor de sesión inyectado;
3. construir únicamente los requests aprobados;
4. ejecutar mediante un transporte HTTP inyectado;
5. devolver una respuesta contractual cruda al validador existente;
6. fallar cerrado antes de cualquier I/O si entorno, host o sesión no cumplen.

Separaciones obligatorias:

- `LocalSessionTokenProvider`: entrega un token de sesión local en memoria;
- `LocalOnlyHostPolicy`: valida esquema, host, puerto y ausencia de project ref;
- `OwnChatSessionsHttpTransport`: abstracción mínima inyectable para tests;
- `LocalHttpOwnChatSessionsDataSource`: coordina request local, sin mapear a
  modelos de dominio;
- `ValidatingOwnChatSessionsRepository`: conserva la validación estricta y el
  mapeo a resultados Flutter.

No se usará el cliente Supabase como transporte ni proveedor implícito de
sesión. No habrá conexión directa desde entidades, repositorio de dominio o UI.

### Autorización y sesión local futura

- JWT local obtenido en runtime mediante `LocalSessionTokenProvider`;
- token nunca hardcodeado, versionado, logueado ni incluido en modelos;
- no se aceptan owner, `userId`, `user_id`, `specialistId` interno o alias;
- `Authorization: Bearer <token>` se añade solo después de validar host local;
- token ausente produce `unauthenticated` sin ejecutar red;
- token vacío, inválido o rechazado produce `invalidSession` o el error HTTP
  tipado correspondiente;
- G no restaura autenticación real ni define persistencia de tokens.

### Política local-only y anti-remoto

Antes de cualquier request deben cumplirse simultáneamente:

- composición explícita de validación local autorizada;
- entorno distinto de producción y de backend remoto;
- esquema `http`;
- hostname exactamente `localhost` o `127.0.0.1`;
- puerto local configurado explícitamente;
- URL sin credenciales embebidas;
- ausencia de dominio Supabase remoto, project ref o hostname alternativo.

Ante cualquier incumplimiento se devuelve `backendBlocked` antes del
transporte. Redirecciones quedan deshabilitadas o deben revalidarse contra la
misma política local-only. El datasource nunca debe seguir una redirección a
remoto.

### Mapeo exacto de requests

Crear:

```http
POST /functions/v1/create-own-chat-session
Content-Type: application/json
Authorization: Bearer <jwt-local>

{"selectableSpecialistId":"..."}
```

Listar:

```http
GET /functions/v1/list-own-chat-sessions?status=active&limit=20&cursor=<opaco>
Authorization: Bearer <jwt-local>
```

`cursor` se codifica como valor de query, pero nunca se decodifica, interpreta
o reconstruye semánticamente en Flutter. Se omite cuando es nulo.

Archivar:

```http
POST /functions/v1/archive-own-chat-session
Content-Type: application/json
Authorization: Bearer <jwt-local>

{"sessionId":"..."}
```

Los requests deben construirse desde allowlists exactas. Quedan prohibidos:
owner, `userId`, `user_id`, `specialistId`, `specialist_id`,
`internalSpecialistId`, `status`/`newStatus` en archive, `messageCount`,
timestamps, roles, permisos y cualquier campo adicional.

### Mapeo futuro de errores

| Condición | Resultado Flutter |
| --- | --- |
| Token local ausente | `unauthenticated` |
| JWT rechazado o sesión inválida | `invalidSession` |
| HTTP 400 / request inválido | `invalidRequest` o error específico permitido |
| Especialista seleccionable inválido | `invalidSelectableSpecialist` |
| Especialista no disponible | `specialistUnavailable` |
| Acceso premium bloqueado | `premiumLocked` |
| Sesión opacamente inexistente | `sessionNotFound` |
| HTTP 403 | `permissionDenied` |
| HTTP 502 contractual / forma inválida | `contractViolation` |
| Host/entorno bloqueado o dependencia local ausente | `backendBlocked` |
| Timeout, DNS o transporte local fallido | `networkError` |
| Error no clasificado | `unexpectedError` |

Ningún error, timeout, 4xx, 5xx o payload inválido podrá convertirse en demo o
éxito. Los cuerpos de error también se validarán mediante allowlist exacta.

### Validación contractual futura

El datasource no confiará en respuestas por ser locales. El validador deberá:

- aceptar únicamente envelopes y campos públicos exactos;
- rechazar respuestas parciales, campos extra y estados desconocidos;
- rechazar `user_id`, `userId`, `specialist_id`, `specialistId`,
  `internalSpecialistId`, prompts, `access_tier`, `availability_status`,
  roles, permisos, secretos y configuración;
- rechazar éxito HTTP con body vacío, ambiguo o no confirmado;
- mantener `nextCursor` opaco;
- no registrar JWT, bodies sensibles ni IDs internos.

### Tests futuros obligatorios de 2B-IV-G

- host `localhost` y `127.0.0.1` permitidos solo en composición local;
- HTTPS/remoto, dominio Supabase, project ref, producción y redirección remota
  fallan cerrado antes de ejecutar transporte;
- token ausente no ejecuta red y devuelve `unauthenticated`;
- JWT nunca aparece en logs, modelos o fixtures versionados;
- create envía exactamente `selectableSpecialistId`;
- list envía solo `status`, `limit` y cursor opaco cuando existe;
- archive envía exactamente `sessionId`, sin `status` ni `newStatus`;
- ningún request envía owner, IDs internos, timestamps, contador, roles o
  permisos;
- 400, 401, 403, 404, 502, timeout y fallo de transporte se mapean de forma
  tipada sin fallback demo;
- respuestas públicas válidas se transforman mediante el validador existente;
- campos internos, extra o respuestas parciales producen
  `contractViolation`;
- backend bloqueado y demo continúan sin ejecutar red;
- ninguna prueba o implementación toca `messages`, Supabase remoto, IA o
  Stasis Engine.

### Gates antes de implementar 2B-IV-G

1. aprobar explícitamente HTTP local desde Flutter;
2. aprobar la composición local-only y el proveedor de JWT local;
3. aprobar allowlist exacta de host/puerto y política de redirecciones;
4. aprobar transporte inyectable y prohibición de Supabase client;
5. aprobar requests, errores y validación estricta descritos;
6. mantener 2B-V, remoto, producción, IA y Stasis Engine bloqueados.

## Resultado de implementación 2B-IV-G — datasource Flutter HTTP local

Fecha: 2026-06-14.

- Se implementó `LocalHttpOwnChatSessionsDataSource` como fuente contractual
  HTTP exclusivamente local para create/list/archive.
- `LocalOnlyHostPolicy` exige composición local habilitada, esquema `http`,
  hostname exacto `localhost` o `127.0.0.1`, puerto escrito explícitamente y
  URI sin path base, credenciales, query o fragment.
- Un test detectó que `Uri.port` devuelve el puerto por defecto aunque no se
  escriba; la política se corrigió para exigir `hasPort`, cerrando esa brecha.
- Host remoto, HTTPS, dominio Supabase, producción/composición deshabilitada y
  URI insegura fallan antes de leer el token y antes de llamar al transporte.
- `LocalSessionTokenProvider` es inyectable y no contiene implementación,
  token hardcodeado, persistencia o logs.
- Token ausente devuelve `unauthenticated` sin transporte; token vacío devuelve
  `invalidSession` sin transporte.
- `OwnChatSessionsHttpTransport` es inyectable; su implementación Dio desactiva
  redirecciones y no usa Supabase client.
- Los requests usan allowlists exactas: create solo
  `selectableSpecialistId`, list solo `status`/`limit`/cursor opaco y archive
  solo `sessionId`.
- El datasource extrae códigos únicamente del envelope de error exacto y trata
  redirecciones como `backendBlocked`.
- `ValidatingOwnChatSessionsRepository` mantiene la validación de respuestas
  públicas y transforma transporte fallido en `networkError`, JSON/forma
  insegura en `contractViolation` y errores backend en resultados tipados.
- Ningún datasource o repositorio local referencia resultados demo; ningún
  error real se convierte en demo o éxito.
- Los tests específicos pasan 32/32 y la suite completa 81/81.
- `build_runner` escribió 0 salidas; análisis sin avisos de G y con 48 infos
  preexistentes fuera de G; `git diff --check` correcto.
- No se modificaron Supabase, Edge Functions, migraciones, CI, `messages`,
  remoto o producción. No hubo llamada HTTP real, deploy, `db push` o link.

### Riesgos residuales de 2B-IV-G

- El datasource no está conectado a providers, UI o composición runtime.
- No existe todavía proveedor concreto de JWT local; añadirlo requiere diseño
  y aprobación separados.
- Los tests usan transporte inyectado y no ejecutan integración HTTP real
  contra las Edge Functions locales.
- La sustitución del chat heredado, 2B-V/messages, remoto y producción
  continúan bloqueados.

## Cierre formal de 2B-IV-G y plan exacto 2B-IV-H — integración HTTP local sesiones

Fecha: 2026-06-15.

### Cierre formal de 2B-IV-G

2B-IV-G queda cerrado formalmente. Se acepta como evidencia:

- datasource HTTP local implementado sin wiring a providers o UI;
- host remoto bloqueado antes de leer token y antes de ejecutar transporte;
- JWT ausente o vacío sin red;
- redirecciones deshabilitadas;
- ausencia de Supabase client y `messages`;
- cero fallback demo ante errores reales;
- tests específicos 32/32 y suite completa 81/81;
- `build_runner` con 0 salidas;
- análisis sin avisos del nuevo paquete y 48 infos preexistentes fuera de G;
- `git diff --check` correcto;
- Supabase, Edge Functions, migraciones, CI, remoto y producción intactos.

Este cierre no autoriza todavía integración end-to-end, proveedores reales, UI,
mensajes, IA, Stasis Engine, remoto o producción.

### Estado global de 2B-IV A-G

Quedan completados y cerrados formalmente:

| Subpaquete | Estado cerrado | Límite conservado |
| --- | --- | --- |
| 2B-IV-A | `chat_sessions` deny-all + constraints | Sin operaciones cliente |
| 2B-IV-B | Fixtures transaccionales | Cleanup y cero seed persistente |
| 2B-IV-C | `createOwnChatSession` local | Sin Flutter, mensajes o remoto |
| 2B-IV-D | `listOwnChatSessions` local | Sin Flutter, mensajes o remoto |
| 2B-IV-E | `archiveOwnChatSession` local | Sin Flutter, mensajes o remoto |
| 2B-IV-F | Contrato Flutter desconectado | Sin HTTP real |
| 2B-IV-G | Datasource Flutter HTTP local | Sin integración real, providers o UI |

### Objetivo limitado de 2B-IV-H

2B-IV-H podrá validar, solo tras aprobación separada, un flujo de integración
local controlada:

```text
Flutter datasource -> HTTP local -> Edge Functions locales -> Supabase local
```

Operaciones mínimas:

1. crear una sesión con `selectableSpecialistId`;
2. listar sesiones activas y confirmar que aparece;
3. archivar la sesión;
4. listar activas y confirmar que ya no aparece;
5. listar archivadas o `all` y confirmar que aparece como archivada.

H sigue siendo local, efímero y de test; no habilita producción, remoto,
providers definitivos, UI, mensajes, IA o Stasis Engine.

### Proveedor JWT local de test

Nombre recomendado: `TestLocalSessionTokenProvider`.

Reglas obligatorias:

- solo existe en tests/integración local;
- no se exporta desde providers reales;
- no versiona tokens reales ni credenciales;
- no hardcodea JWT ni claves reales;
- obtiene un JWT desde Auth local mediante flujo controlado o fixture local
  autorizado;
- no acepta owner manual, `userId`, `specialistId` ni aliases;
- no loguea ni persiste el JWT;
- si no puede obtener token, falla cerrado y la prueba no ejecuta operaciones.

El token de integración debe ser efímero y derivado de Supabase local. Quedan
prohibidos tokens pegados en código, `.env`, fixtures versionados o logs.

### Fixtures locales de integración

Fixtures permitidos, todos marcados con `test_only_2b_iv_h`:

- usuario Auth local;
- perfil `public.users`;
- especialista interno;
- entrada `specialist_catalog`;
- catálogo `free`, `available` y publicado.

Reglas:

- nada de seed persistente;
- nada de datos reales;
- setup local confirmado solo para el harness;
- cleanup obligatorio en `finally`/trap;
- postcondición cero fixtures en Auth, `public.users`, `specialists`,
  `specialist_catalog`, `chat_sessions` y `messages`;
- si cleanup falla, ejecutar `supabase db reset --local --no-seed` y registrar
  el incidente;
- los fixtures no se reutilizan entre tests salvo que el harness demuestre
  aislamiento y limpieza.

### Anti-remoto obligatorio

Antes de cualquier integración se debe demostrar:

- Supabase CLI sin project ref remoto;
- ausencia de `SUPABASE_ACCESS_TOKEN` requerido para remoto;
- no ejecutar `supabase link`, `supabase functions deploy`, `supabase db push`
  ni comandos equivalentes;
- funciones servidas localmente por CLI;
- datasource apuntando solo a `http://localhost:<puerto>` o
  `http://127.0.0.1:<puerto>`;
- host remoto, HTTPS o project ref fallan cerrado antes de red;
- ningún token remoto, anon key remota o service role remoto queda versionado.

### Qué no se prueba en H

2B-IV-H no implementa ni valida:

- creación o envío de `messages`;
- respuesta de IA;
- Stasis Engine;
- UI;
- providers definitivos;
- autenticación real de app;
- producción;
- Supabase remoto;
- idempotencia final o atomicidad remota.

### Tests/harness obligatorios definidos para H

- obtiene JWT local de test sin token versionado;
- no ejecuta red si falta JWT;
- no ejecuta red si host no es local;
- create real local funciona con `selectableSpecialistId`;
- list real local devuelve la sesión creada sin `user_id` ni `specialist_id`;
- archive real local cambia la sesión a `archived`;
- flujo create-list-archive-list completo pasa;
- respuesta no expone prompts, configuración, IDs internos, roles o permisos;
- errores no se convierten en demo;
- `messages` permanece intacta;
- cleanup deja cero fixtures en todas las tablas afectadas;
- Supabase local se detiene o queda en estado limpio al final;
- remoto no fue tocado.

### Riesgos residuales de H

- integración local no equivale a producción;
- tokens locales de test no sustituyen auth real de la app;
- atomicidad REST privilegiada sigue pendiente;
- `Idempotency-Key` sigue pendiente;
- estrategia de catálogo histórico/tombstone sigue pendiente;
- providers/UI siguen sin conectarse.

### Relación con paquetes posteriores

- `2B-IV-H`: integración HTTP local controlada del bloque de sesiones; cerrado
  formalmente el 2026-06-15.
- `2B-V`: messages; sigue bloqueado hasta aprobación explícita separada.

Tras H, el bloque de sesiones queda probado localmente antes de diseñar o
implementar mensajes.

## Resultado 2B-IV-H — integración HTTP local sesiones

Fecha: 2026-06-15.

2B-IV-H fue aprobado, implementado y verificado como integración local
controlada entre datasource Flutter, Edge Functions locales y Supabase local.
Queda cerrado formalmente solo para entorno local/efímero.

### Archivos preparados

- `test/integration/two_b_iv_h_local_http_chat_sessions_integration_test.dart`;
- `supabase/tests/2b_iv_h_local_http_integration_setup.psql`;
- `supabase/tests/2b_iv_h_local_http_integration_cleanup.psql`;
- `supabase/tests/2b_iv_h_local_http_integration_test.sh`.

### Flujo diseñado

El harness ejecuta, solo contra local:

1. preflight anti-remoto;
2. lectura de variables locales desde `supabase status -o env`;
3. creación de usuario Auth local y perfil `public.users`;
4. inserción de especialista interno y entrada `specialist_catalog`
   `test_only_2b_iv_h`;
5. `supabase functions serve` con env temporal fuera del repositorio;
6. test Flutter real contra las Edge Functions locales;
7. verificación de que `messages` no cambia;
8. revisión de logs para evitar tokens, IDs internos y nombres de columnas
   sensibles;
9. cleanup obligatorio;
10. postcondición exacta `0|0|0|0|0|0` para Auth, `public.users`,
    `specialists`, `specialist_catalog`, `chat_sessions` y `messages`.

### Tokens y secretos

No se versionan tokens reales. El JWT de test solo se inyecta por
`dart-define` desde el harness local, y el env de Edge Functions se crea en un
directorio temporal fuera del repositorio con permisos restrictivos. El harness
rechaza configuraciones con señales de remoto antes del transporte.

### Evidencia obtenida

- El test de integración compila y se analiza sin issues.
- En ausencia del harness, el test queda saltado de forma explícita para no
  ejecutar red ni depender de tokens.
- `supabase start` arrancó el entorno local.
- `supabase db reset --local --no-seed` aplicó las migraciones `00001` a
  `00005`.
- El harness ejecutó el flujo real local create/list/archive/list contra Edge
  Functions locales.
- La protección sin JWT y host remoto se ejecutó y pasó antes del transporte.
- La sesión creada se listó como activa, se archivó y dejó de aparecer en
  activas.
- `messages` permaneció intacta.
- Los logs no contienen token, owner id, especialista interno, `user_id`,
  `specialist_id`, `prompt_template` ni `service_role`.
- El cleanup dejó exactamente `0|0|0|0|0|0`.

### Ajustes realizados durante H

- El validador Flutter aceptaba únicamente `200` como éxito; se corrigió para
  aceptar también `201 Created`, usado por `create-own-chat-session`.
- PostgREST devuelve `started_at` y `last_message_at` sin zona por el esquema
  histórico `TIMESTAMP`; Flutter los normaliza como UTC y se añadió test
  específico. La mejora futura recomendada es usar/emitir timestamps UTC
  explícitos desde backend.

### Resultado principal

```text
2B-IV-H local HTTP integration harness: PASS
0|0|0|0|0|0
```

2B-IV-H no habilita providers reales, UI, mensajes, remoto, producción, auth
real, Stasis Engine ni MCP. El siguiente paso recomendado es preparar 2B-V
`messages` o un plan separado de wiring UI/providers, siempre con aprobación
explícita.

## Plan exacto documental 2B-V — messages seguro

Fecha: 2026-06-15.

Estado: plan documental preparado, pendiente de aprobación. No implementa SQL,
migraciones, Edge Functions, Flutter, CI, remoto, IA, Stasis Engine, streaming,
UI, providers reales ni datos reales.

### Decisión sobre siguiente paquete

Se decide no avanzar todavía a wiring UI/providers. Aunque `chat_sessions` ya
funciona localmente de punta a punta, un chat conectado sin `messages` seguro
quedaría incompleto y podría forzar a la UI a inventar estado, exponer detalles
internos o normalizar decisiones inseguras.

El siguiente paquete debe ser 2B-V `messages`, primero como diseño exacto
documental.

### Estado actual verificado de `public.messages`

Fuente inspeccionada: `supabase/migrations/00001_initial_schema.sql`.

Tabla real:

```sql
CREATE TABLE public.messages (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  session_id UUID REFERENCES public.chat_sessions(id) ON DELETE CASCADE,
  role TEXT NOT NULL CHECK (role IN ('user', 'assistant', 'system', 'chief_intervention')),
  content TEXT NOT NULL,
  attachments JSONB,
  created_at TIMESTAMP DEFAULT now()
);
```

Índice real existente:

```sql
CREATE INDEX idx_messages_session ON public.messages(session_id);
```

Inventario por columna:

| Columna real | Tipo | Nullable actual | Default actual | Riesgo | Server-managed | Puede venir de cliente | Visible respuesta pública futura | Necesita constraint | Necesita índice |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `id` | `UUID` PK | No por PK | `uuid_generate_v4()` | Exponer ID interno puede acoplar UI; aceptable como `messageId` público si se decide | Sí | Nunca | Sí como `messageId`, no como campo interno | Ya tiene PK | PK existente |
| `session_id` | `UUID` FK -> `chat_sessions(id)` ON DELETE CASCADE | Sí actualmente | Ninguno | Mensajes huérfanos lógicos; inserción en sesión ajena; nombre real no es `chat_session_id` | Backend decide destino tras validar ownership | Cliente puede enviar `sessionId` público al endpoint, nunca escribir columna directa | No exponer como `session_id` | `NOT NULL` futuro | Índice compuesto futuro |
| `role` | `TEXT` | No | Ninguno | Spoofing de `assistant`, `system` o `chief_intervention`; enum histórico no coincide con modelo futuro | Sí | Nunca | Sí como `role` sanitizado | Reemplazar allowlist por `user/assistant/system/tool`; MVP local solo crea `user` | Opcional por filtros futuros |
| `content` | `TEXT` | No | Ninguno | Vacío, exceso de longitud, prompt injection, datos sensibles, contenido sin normalizar | No totalmente: cliente aporta texto, backend valida y persiste | Solo `content` del usuario vía Edge Function | Sí | trim no vacío, longitud máxima, posible normalización | No inicial |
| `attachments` | `JSONB` | Sí | Ninguno | Archivos/PDF/URLs temporales sin diseño Storage; riesgo alto de privacidad | Backend only futuro | No en 2B-V MVP | No en 2B-V MVP | Bloquear o exigir null en A/B/C iniciales | No inicial |
| `created_at` | `TIMESTAMP` | Sí actualmente | `now()` | Manipulación temporal y falta de zona explícita | Sí | Nunca | Sí como timestamp normalizado | `NOT NULL`; preferible `timestamptz` futuro o serialización UTC | Parte de índice de listado |

Problemas detectados:

- `session_id` es nullable; 2B-V-A debe proponer `NOT NULL` con preflight.
- `created_at` es nullable y `TIMESTAMP` sin zona; 2B-V-A debe endurecer
  `NOT NULL` y documentar deuda de UTC explícito.
- `role` permite `chief_intervention`, valor heredado no alineado con
  `user/assistant/system/tool`.
- No existe constraint de contenido no vacío ni límite de longitud.
- `attachments` existe sin diseño de Storage y debe quedar bloqueado.
- El índice `idx_messages_session` no garantiza orden estable; se recomienda
  `(session_id, created_at ASC, id ASC)`.
- No hay RLS/policies/grants endurecidos específicamente para mensajes en las
  migraciones actuales.

### Riesgos principales de messages

- Spoofing de `role` si Flutter o un cliente puede enviar `assistant`,
  `system`, `tool` o `chief_intervention`.
- Lectura de mensajes de sesiones ajenas.
- Inserción de mensajes en sesiones ajenas.
- Inserción de mensajes en sesiones archivadas.
- Mensajes vacíos, whitespace-only o excesivamente largos.
- Contenido sin validación mínima.
- Orden ambiguo si solo se usa `created_at` y hay empates.
- `created_at` manipulable si lo decide cliente.
- `message_count` inconsistente si se inserta mensaje sin actualizar sesión.
- `last_message_at` inconsistente si no se actualiza con la inserción.
- Exposición accidental de `user_id`, `specialist_id`, prompts o configuración
  interna al listar mensajes.
- Adjuntos sin política de Storage, caducidad, escaneo o privacidad.
- Escrituras parciales si mensaje y sesión se actualizan en pasos no atómicos.

### Roles permitidos

Modelo interno futuro recomendado:

```text
user
assistant
system
tool
```

Regla MVP local:

- el cliente no envía `role`;
- Flutter nunca modela `role` como entrada editable;
- `send-user-message` decide `role = user`;
- `assistant`, `system` y `tool` quedan reservados para IA/Stasis Engine futuro;
- `chief_intervention` debe considerarse heredado y no formar parte del contrato
  público nuevo;
- ningún endpoint cliente permite crear mensajes de asistente, sistema o tool.

### Estrategia por subpaquetes 2B-V

| Subpaquete | Objetivo | Implementa | No implementa |
| --- | --- | --- | --- |
| 2B-V-A | `messages` deny-all + constraints mínimos | RLS deny-all, cero grants/policies cliente, preflight, constraints e índice | Edge Functions, Flutter, datos reales |
| 2B-V-B | fixtures locales `messages` | Fixtures transaccionales o confirmados con cleanup según necesidad | Seed persistente |
| 2B-V-C | Edge Function local `send-user-message` | Inserción owner-only de mensaje `user`; no role client; no sesión archivada; update atómico de sesión | IA, assistant/system/tool |
| 2B-V-D | Edge Function local `list-session-messages` | Listado owner-only con cursor estable y contrato público mínimo | Streaming, adjuntos, prompts |
| 2B-V-E | contrato Flutter desconectado messages | Modelos/resultados seguros sin red | Providers/UI/backend real |
| 2B-V-F | datasource Flutter HTTP local messages | Transporte local-only e inyectable para send/list | Wiring UI/providers/remoto |
| 2B-V-G | integración HTTP local messages | Flujo local send/list con cleanup | Producción, remoto, IA |

No se recomienda saltar directamente a UI/providers.

### Diseño inicial 2B-V-A — messages deny-all + constraints mínimos

Objetivo: endurecer la tabla `public.messages` sin permitir todavía acceso
cliente.

Diseño de migración futura, no implementada:

- preflight fail-closed:
  - comprobar que existe `public.messages`;
  - comprobar columnas reales esperadas antes de transformar;
  - abortar si existen policies no esperadas;
  - abortar si hay filas incompatibles con constraints futuros;
  - abortar si hay `role` fuera de la allowlist aprobada;
  - abortar si hay `content` vacío tras trim;
  - abortar si hay mensajes con `session_id` null;
  - abortar si hay mensajes en sesión inexistente;
  - documentar cualquier dato existente como no apto para producción.
- habilitar RLS en `public.messages`;
- `NO FORCE ROW LEVEL SECURITY`;
- revocar grants cliente `anon` y `authenticated`;
- no crear policies permisivas;
- mantener backend/service role fuera de pruebas de acceso cliente;
- reforzar columnas:
  - `session_id NOT NULL`;
  - `content NOT NULL`;
  - `role NOT NULL`;
  - `created_at NOT NULL DEFAULT now()`;
  - `attachments` queda sin uso cliente y preferiblemente null en MVP;
- constraints candidatos:
  - `btrim(content) <> ''`;
  - `char_length(content) <= 4000` como límite inicial conservador;
  - `role IN ('user', 'assistant', 'system', 'tool')`, si preflight permite
    migrar desde `chief_intervention` sin datos o bloquea si existen datos;
- índice:
  - `messages_session_created_id_idx ON public.messages(session_id, created_at ASC, id ASC)`;
- rollback local:
  - retirar índice nuevo;
  - retirar constraints nuevos;
  - revocar grants añadidos si existieran;
  - volver a deny-all seguro, preferiblemente manteniendo RLS habilitada;
  - no reintroducir policies permisivas;
- anti-remoto:
  - solo Supabase local;
  - sin `link`, `db push`, deploy ni variables/tokens remotos.

### Constraints candidatos

| Constraint | Recomendación | Motivo |
| --- | --- | --- |
| `session_id NOT NULL` | Sí en 2B-V-A | Todo mensaje pertenece a una sesión |
| FK `session_id -> chat_sessions(id)` | Ya existe | Mantener; no cambiar sin aprobación |
| `content NOT NULL` | Ya existe | Mantener |
| `btrim(content) <> ''` | Sí | Evita mensajes vacíos/whitespace |
| Longitud máxima | Sí, proponer 4000 chars inicial | Evita abuso y costes futuros |
| `role NOT NULL` | Ya existe | Mantener |
| `role IN ('user','assistant','system','tool')` | Sí, con preflight | Elimina `chief_intervention` heredado del nuevo contrato |
| `created_at NOT NULL` | Sí | Orden y auditoría mínima |
| `created_at DEFAULT now()` | Ya existe, reforzar | Server-managed |
| Índice `(session_id, created_at ASC, id ASC)` | Sí | Listado estable por sesión |

Sobre `ON DELETE`:

- el esquema actual usa `ON DELETE CASCADE`;
- para 2B-V-A no se recomienda cambiarlo todavía, porque implicaría decisión de
  retención/auditoría más amplia;
- para producción conviene revisar si `RESTRICT`, soft-delete o retención
  auditada encaja mejor con privacidad, borrado de usuario y trazabilidad.

### Relación futura con `chat_sessions`

Reglas:

- solo se pueden enviar mensajes a sesiones propias;
- no se pueden enviar mensajes a sesiones archivadas;
- enviar mensaje de usuario debe actualizar `chat_sessions.message_count`;
- enviar mensaje de usuario debe actualizar `chat_sessions.last_message_at`;
- `message_count` y `last_message_at` son server-managed;
- Flutter nunca envía ni escribe esos campos;
- la inserción del mensaje y la actualización de sesión deben ser atómicas antes
  de remoto/producción;
- MVP local puede requerir Edge Function con operación controlada o RPC interna
  aprobada; no usar RPC inexistente ni fallback silencioso.

### Lectura futura de mensajes

Endpoint futuro propuesto:

```text
GET /functions/v1/list-session-messages
```

Parámetros:

```text
sessionId
limit
cursor
```

Reglas:

- owner se deriva del JWT;
- `sessionId` se valida como ID de sesión propia;
- sesión ajena, inexistente o no accesible debe responder de forma opaca cuando
  convenga, sin filtrar existencia;
- orden estable por `(created_at ASC, id ASC)`;
- cursor opaco;
- límite máximo conservador;
- respuesta pública no expone `session_id`, `user_id`, `specialist_id`,
  prompts, configuración interna ni columnas de Storage.

Respuesta conceptual mínima:

```json
{
  "items": [
    {
      "messageId": "...",
      "role": "user",
      "content": "...",
      "createdAt": "..."
    }
  ],
  "nextCursor": null
}
```

### Envío futuro de mensaje

Endpoint futuro propuesto:

```text
POST /functions/v1/send-user-message
```

Body permitido:

```json
{
  "sessionId": "...",
  "content": "..."
}
```

Prohibido en body:

```text
role
userId
specialistId
assistant content
system content
tool content
created_at
message_count
last_message_at
attachments
```

Reglas:

- owner se deriva del JWT;
- backend valida sesión propia y `status = active`;
- sesión archivada no admite nuevos mensajes;
- backend fuerza `role = user`;
- backend valida `content` trim no vacío y longitud máxima;
- backend inserta mensaje y actualiza `message_count`/`last_message_at` en la
  misma unidad atómica antes de remoto;
- no invoca IA;
- no crea respuesta assistant;
- no modifica prompts, catálogo, especialistas o Stasis Engine.

### Tests futuros propuestos

2B-V-A:

- RLS habilitada en `messages`;
- `NO FORCE RLS`;
- cero policies;
- cero grants cliente;
- anon/authenticated no pueden select/insert/update/delete;
- constraints de `session_id`, `content`, `role`, `created_at`;
- `chief_intervention` bloqueado por preflight o eliminado del contrato futuro;
- índice compuesto existe;
- rollback conserva deny-all seguro.

2B-V-B:

- fixtures transaccionales o confirmados con cleanup aprobado;
- cero seed persistente;
- cleanup deja cero fixtures en `messages` y tablas relacionadas.

2B-V-C:

- Flutter/backend request no acepta `role`;
- owner puede enviar mensaje `user` a sesión propia activa;
- usuario A no puede enviar a sesión de B;
- no se puede enviar a sesión archivada;
- no se aceptan mensajes vacíos o demasiado largos;
- no se puede enviar `created_at`, `message_count`, `last_message_at`,
  `userId` o `specialistId`;
- se actualizan `message_count` y `last_message_at` solo server-side;
- no se crea assistant/system/tool;
- no se invoca IA.

2B-V-D:

- owner lista mensajes de sesión propia;
- usuario A no lista mensajes de sesión de B;
- sesión inexistente/ajena no filtra información;
- orden estable sin duplicados;
- cursor no duplica ni salta mensajes;
- respuesta no expone IDs internos ni configuración.

2B-V-E/F/G:

- contratos Flutter sin `userId`, `specialistId`, `role` editable o campos
  server-managed;
- host remoto bloqueado antes de transporte;
- JWT ausente sin red;
- ningún error real se convierte en demo;
- integración local end-to-end send/list;
- cleanup final exacto.

### Decisión sobre UI/providers

UI/providers de sesiones esperan hasta tener `messages` mínimo seguro.

Motivo: conectar sesiones sin mensajes produciría un chat incompleto y podría
forzar decisiones inseguras de UI, como estados inventados, mensajes mock
presentados como reales o superficies que luego habría que romper.

### Criterios para aprobar implementación 2B-V-A

Antes de autorizar SQL real:

- confirmar que 2B-V-A tocará solo `supabase/migrations/`, `supabase/tests/`,
  ADR-006, ADR-007 y tracker;
- no tocar Edge Functions, Flutter, CI, remoto ni producción;
- aceptar la estrategia para `chief_intervention`;
- aceptar longitud máxima inicial de contenido;
- decidir si `attachments` debe quedar permitido como nullable histórico o
  forzado a null para MVP;
- confirmar rollback local y anti-remoto.

## Resultado de implementación 2B-V-A — messages deny-all + constraints mínimos

Fecha: 2026-06-15.

2B-V-A quedó implementado exclusivamente como endurecimiento local de
`public.messages`. No conecta Flutter, no crea Edge Functions de mensajes, no
lee ni escribe mensajes reales, no invoca IA y no desbloquea UI/providers.

Resultado técnico:

- migración nueva: `supabase/migrations/00006_harden_messages_deny_all.sql`;
- RLS habilitada en `messages` sin FORCE;
- cero policies;
- cero grants cliente para `anon` y `authenticated`;
- `session_id NOT NULL`;
- `created_at NOT NULL DEFAULT now()`;
- `role` limitado a `user`, `assistant`, `system`, `tool`;
- `chief_intervention` queda fuera del contrato y falla cerrado;
- contenido no vacío, no whitespace-only y máximo 4000 caracteres;
- `attachments` queda `NULL` obligatorio en MVP local;
- índice estable `idx_messages_session_created_id(session_id, created_at, id)`;
- rollback local idempotente conserva deny-all y cero grants.

Evidencia:

- `supabase db reset --local --no-seed` aplicó `00001` a `00006`;
- `supabase test db supabase/tests/2b_v_a_messages_deny_all_test.sql --local`:
  57/57;
- `supabase test db --local`: 276/276;
- preflight incompatible abortó antes de transformar schema;
- rollback local dejó `RLS=true`, `FORCE=false`, `policies=0`, `messages=0` y
  cero grants cliente;
- reaplicación posterior volvió a pasar la suite completa;
- ejecución local sobre `127.0.0.1`; sin `link`, `db push`, deploy, remoto,
  datos reales ni credenciales reales versionadas.

Decisiones conservadas:

- Flutter no puede enviar `role`;
- el cliente no puede falsificar mensajes `assistant`, `system` o `tool`;
- no se puede escribir en sesiones archivadas porque toda escritura cliente
  sigue denegada;
- `message_count` y `last_message_at` siguen server-managed y no cambian en
  2B-V-A.

Siguiente gate:

2B-V-B/C deben planificarse y aprobarse por separado. Cualquier escritura real
de mensajes debe pasar por backend controlado, derivar owner desde JWT, validar
sesión propia activa, forzar `role=user` y actualizar la sesión de forma
atómica.

## Cierre formal 2B-V-A y plan exacto 2B-V-B — fixtures locales de messages

Fecha: 2026-06-16.

2B-V-A queda cerrado formalmente. El estado seguro de `public.messages` se
acepta como base local: deny-all, cero policies, cero grants cliente,
constraints mínimos, `chief_intervention` rechazado, preflight fail-closed,
rollback/reaplicación y suite SQL acumulada 276/276.

2B-V-B se diseña como paquete de fixtures locales, no como funcionalidad de
mensajería. Su objetivo es preparar datos transaccionales para probar escenarios
de mensajes sin crear seeds persistentes ni abrir acceso cliente.

### Reglas de fixtures para 2B-V-B

- Usar `BEGIN` y `ROLLBACK`.
- Prohibir seed persistente.
- Prohibir datos en migraciones.
- Prohibir fixtures confirmados con cleanup compensatorio salvo aprobación
  separada.
- Exigir cero persistencia tras `ROLLBACK`.
- Marcar fixtures como `test_only_2b_v_b`.

### Fixtures propuestos

- owner y other en `auth.users`;
- perfiles en `public.users`;
- especialista interno;
- entrada sanitizada en `public.specialist_catalog`;
- sesión propia activa;
- sesión propia archivada;
- sesión de otro usuario;
- dos mensajes de la sesión propia activa;
- un mensaje de sesión ajena;
- un mensaje histórico en sesión archivada.

La existencia de un mensaje histórico en una sesión archivada solo representa
estado pasado. No autoriza crear mensajes nuevos en sesiones archivadas. El
endpoint futuro `send-user-message` deberá rechazar sesiones archivadas.

### Assertions diseñadas

- cardinalidad exacta dentro de la transacción;
- FKs de mensajes hacia sesiones existentes;
- orden estable por `created_at ASC, id ASC`;
- roles internos válidos aceptados;
- `chief_intervention` rechazado;
- `attachments` no `NULL` rechazado;
- contenido inválido rechazado;
- RLS deny-all y cero grants cliente conservados;
- anon/authenticated sin CRUD;
- `chat_sessions.message_count` y `chat_sessions.last_message_at` siguen
  server-managed y no se actualizan por endpoint porque B no implementa
  endpoints;
- cero persistencia tras rollback;
- ejecución exclusivamente local.

### Relación con C/D

- B prepara fixtures y pruebas SQL.
- C implementará, si se aprueba, envío controlado de mensaje `user`.
- D implementará, si se aprueba, listado controlado de mensajes.

B no crea `send-user-message`, `list-session-messages`, Flutter, UI, providers,
IA, streaming, Stasis Engine, remoto ni producción.

## Resultado de implementación 2B-V-B — fixtures locales transaccionales de messages

Fecha: 2026-06-16.

2B-V-B quedó implementado únicamente como tests SQL locales. No modifica
migraciones, Edge Functions, Flutter, UI, providers, CI, remoto ni producción.

Archivos:

- `supabase/tests/2b_v_b_messages_fixtures_test.sql`;
- `supabase/tests/2b_v_b_messages_fixtures_zz_postconditions_test.sql`.

Controles verificados:

- fixtures `test_only_2b_v_b` dentro de `BEGIN/ROLLBACK`;
- cero `COMMIT`, cero seed persistente y cero cleanup compensatorio;
- owner/other users, especialista, catálogo, sesiones y mensajes creados solo
  dentro de la transacción;
- mensaje histórico en sesión archivada permitido como dato pasado;
- escritura futura en sesiones archivadas sigue bloqueada y reservada para
  2B-V-C;
- `chief_intervention` sigue rechazado;
- role spoofing desde cliente bloqueado por deny-all;
- `messages` mantiene RLS sin FORCE, cero policies y cero grants cliente;
- anon/authenticated no pueden leer, insertar, actualizar ni borrar;
- `message_count` y `last_message_at` no se actualizan automáticamente por
  fixtures directos;
- postcondición externa exacta `0|0|0|0|0|0`.

Evidencia:

- test específico B: 55/55;
- postcondiciones B: 7/7;
- suite SQL acumulada: 338/338;
- estado externo de `messages`: `t|f|0|0`;
- ejecución local sobre `127.0.0.1`;
- sin remoto, `link`, `db push`, deploy, datos reales ni tokens reales
  versionados.

Siguiente gate:

2B-V-C/D deben planificarse y aprobarse por separado. Cualquier endpoint de
envío futuro deberá forzar `role=user` en backend, derivar owner desde JWT,
rechazar sesiones archivadas y actualizar sesión/mensaje de forma atómica.

## Cierre formal 2B-V-B y plan exacto 2B-V-C — send-user-message

Fecha: 2026-06-16.

2B-V-B queda cerrado formalmente: fixtures transaccionales de `messages`,
`BEGIN/ROLLBACK`, cero seed persistente, cero `COMMIT`, cero cleanup
compensatorio, migraciones intactas, postcondición `0|0|0|0|0|0`, suite SQL
338/338 y remoto no tocado.

2B-V-C se diseña como Edge Function local para enviar mensajes `user` a una
sesión propia activa, con owner derivado del JWT y sin aceptar campos de
autoridad desde cliente.

### Frontera HTTP

```http
POST /functions/v1/send-user-message
```

Body permitido:

```json
{
  "sessionId": "...",
  "content": "..."
}
```

Todo campo extra debe fallar cerrado. En particular quedan prohibidos `role`,
`userId`, `specialistId`, `created_at`, `message_count`, `last_message_at`,
`attachments`, roles internos y metadata.

### Validación

- JWT obligatorio y validado contra Auth local;
- owner derivado de `sub`;
- content requerido, trimmeado, no vacío y máximo 4000 caracteres;
- sesión debe existir, pertenecer al owner y estar `active`;
- inexistente/ajena devuelve `sessionNotFound`;
- propia archivada devuelve `sessionArchived`;
- no se loguea JWT completo.

### Atomicidad

Decisión recomendada: `send-user-message` debe terminar en RPC/transacción
controlada para MVP local. La transacción debe validar sesión activa, insertar
mensaje `role=user`, incrementar `message_count` y actualizar
`last_message_at` con el timestamp confirmado del mensaje.

Una Edge Function con dos escrituras REST privilegiadas no es atómica y no
puede desbloquear remoto/producción. Si se usa como transición local
experimental, deberá quedar marcada como riesgo residual y devolver
`writeUnconfirmed` si no puede confirmar la unidad completa.

### Respuesta pública

Devolver solo:

- `messageId`;
- `sessionId`;
- `role=user`;
- `content`;
- `createdAt`;
- `messageCount`;
- `lastMessageAt`.

No devolver `user_id`, `specialist_id`, prompts, service role, JWT, attachments
o metadata interna.

### Tests futuros

- sin JWT e inválido;
- body con campos prohibidos;
- content inválido;
- sesión inexistente, ajena y archivada;
- creación en sesión propia activa;
- `role=user` decidido por backend;
- no roles `assistant/system/tool`;
- incremento exacto de contador;
- `last_message_at` consistente;
- atomicidad sin estado parcial;
- no modificación de catálogo/especialistas;
- sin IA, streaming o listado;
- respuesta pública sanitizada;
- cleanup cero fixtures;
- anti-remoto.

### Relación con D/E/F/G

C solo envía mensajes de usuario. D listará mensajes si se aprueba. E/F/G
definirán contrato Flutter, datasource HTTP local e integración local. Nada de
esto habilita remoto, producción, UI/providers reales, IA o Stasis Engine.

## División 2B-V-C y plan exacto 2B-V-C1 — RPC send_user_message_core

Fecha: 2026-06-16.

2B-V-C queda conceptualmente aprobado, pero se divide para controlar riesgo:

- **2B-V-C1:** núcleo SQL/RPC local transaccional.
- **2B-V-C2:** Edge Function local `send-user-message`.

La operación no puede depender de dos escrituras REST privilegiadas
independientes. Debe validar sesión propia activa, insertar mensaje `user`,
incrementar contador y actualizar cronología en una sola transacción.

### RPC propuesta

Firma propuesta:

```sql
send_user_message_core(
  p_session_id uuid,
  p_owner_user_id uuid,
  p_content text
)
```

`p_owner_user_id` viene de C2 tras validar JWT; Flutter nunca llama la RPC
directamente y nunca aporta owner.

### Validaciones

- `p_session_id` y `p_owner_user_id` obligatorios;
- sesión existe;
- sesión pertenece a owner;
- sesión `status = active`;
- `btrim(p_content)` no vacío;
- `char_length(btrim(p_content)) <= 4000`;
- guardar contenido trimmeado.

### Escritura atómica

En una transacción:

1. insertar `public.messages` con `role='user'`, attachments `NULL` y timestamp
   server-managed;
2. actualizar exactamente una fila de `public.chat_sessions`;
3. `message_count = message_count + 1`;
4. `last_message_at = created_at` del mensaje;
5. devolver datos confirmados.

Si no se actualiza exactamente una sesión, la RPC falla y no deja mensaje
huérfano ni estado parcial.

### Grants y SECURITY DEFINER

Regla de seguridad:

- no `GRANT EXECUTE` a `anon`;
- no `GRANT EXECUTE` a `authenticated`;
- cliente/Flutter no puede invocar RPC;
- solo rol backend/local controlado de C2 puede invocarla;
- no crear policies permisivas sobre `messages` ni `chat_sessions`;
- RLS deny-all cliente debe permanecer.

Postura recomendada: evitar `SECURITY DEFINER` si es posible. Si se necesita,
requiere aprobación explícita y controles:

- propietario seguro;
- `search_path` fijado y seguro;
- referencias con esquema explícito;
- `REVOKE ALL FROM PUBLIC, anon, authenticated`;
- `GRANT EXECUTE` solo al rol backend local controlado;
- sin SQL dinámico;
- tests de denegación directa para `anon` y `authenticated`;
- rollback que elimina función y grants.

### Retorno

Devolver únicamente campos públicos: `messageId`, `sessionId`, `role=user`,
`content`, `createdAt`, `messageCount` y `lastMessageAt`.

No devolver owner, especialista interno, prompt, service role, JWT, attachments
ni metadata interna.

### Tests futuros C1

- RPC denegada para `anon`;
- RPC denegada para `authenticated`;
- invocación permitida solo por rol backend local controlado;
- sesión propia activa crea mensaje;
- sesión ajena, archivada o inexistente falla;
- content inválido falla;
- `role=user` forzado;
- `message_count` incrementa +1;
- `last_message_at` coincide con el mensaje;
- fallo sin estado parcial;
- no crea roles no humanos;
- no toca catálogo/especialistas;
- cleanup cero fixtures;
- anti-remoto.

### Rollback

Eliminar RPC y grants; conservar deny-all de `messages` y `chat_sessions`;
no abrir grants cliente; no tocar datos reales; permitir reaplicación limpia.

### Relación con C2

C1 no expone HTTP. C2 validará JWT/body, derivará owner, llamará C1, mapeará
errores y construirá respuesta HTTP. C1 no autoriza Flutter, listado, UI,
providers, IA, streaming, remoto ni producción.

## Resultado de implementación 2B-V-C1 — RPC send_user_message_core

Fecha: 2026-06-20.

2B-V-C1 quedó implementado exclusivamente en entorno Supabase local/efímero
como núcleo transaccional interno para el futuro endpoint `send-user-message`.
No modifica Edge Functions, Flutter, UI/providers, CI, remoto ni producción.

### Implementación

- Migración nueva: `supabase/migrations/00007_create_send_user_message_core_rpc.sql`.
- RPC: `public.send_user_message_core(p_session_id uuid, p_owner_user_id uuid, p_content text)`.
- No usa `SECURITY DEFINER`.
- Fija `search_path = public, pg_temp`.
- Revoca `EXECUTE` a `PUBLIC`, `anon` y `authenticated`.
- Concede `EXECUTE` solo a `service_role` para uso backend/local controlado.
- No crea policies permisivas sobre `messages` ni `chat_sessions`.
- Inserta únicamente `public.messages.role = 'user'`.
- Mantiene `attachments = NULL`.
- Actualiza `chat_sessions.message_count` y `chat_sessions.last_message_at` en
  la misma operación transaccional que el insert del mensaje.
- No devuelve `user_id`, `specialist_id`, prompts, JWT, service role,
  attachments ni metadata interna.

### Evidencia

- `supabase db reset --local --no-seed` aplicó `00001`-`00007`.
- `supabase test db supabase/tests/2b_v_c1_send_user_message_core_test.sql --local`: 48/48.
- `supabase test db supabase/tests/2b_v_c1_send_user_message_core_zz_postconditions_test.sql --local`: 8/8.
- `supabase test db --local`: 394/394.
- Catálogo PostgreSQL: `security_definer=false`, `anon_execute=false`,
  `authenticated_execute=false`, `service_role_execute=true`.
- Rollback local eliminó la RPC y mantuvo cero policies.
- Reaplicación local mediante reset volvió a pasar la suite completa.
- Postcondición externa: cero fixtures en Auth, perfiles, especialistas,
  catálogo, sesiones y mensajes.

### Alcance bloqueado

C1 no habilita HTTP, JWT, Edge Function `send-user-message`, listado,
integración Flutter, remoto, producción, IA, Stasis Engine, datos reales ni
uso directo por cliente. El siguiente paquete natural es 2B-V-C2, con revisión
explícita del mapeo HTTP y de que `anon`/`authenticated` sigan sin invocar la
RPC.

## Cierre formal 2B-V-C1 y plan exacto 2B-V-C2 — Edge Function send-user-message

Fecha: 2026-06-20.

2B-V-C1 queda cerrado formalmente con la RPC local transaccional
`public.send_user_message_core`. La función SQL no usa `SECURITY DEFINER`,
niega ejecución a `PUBLIC`, `anon` y `authenticated`, conserva cero policies en
`messages` y `chat_sessions`, inserta únicamente mensajes `user`, mantiene
`attachments=NULL` y actualiza `message_count` y `last_message_at` de forma
atómica. Evidencia aceptada: C1 48/48, postcondiciones 8/8, suite SQL 394/394,
cleanup `0|0|0|0|0|0`, rollback/reaplicación local correctos y remoto no
tocado.

### Objetivo C2

2B-V-C2 diseñará una Edge Function local `send-user-message` que actúe como
frontera HTTP segura. Su responsabilidad será validar JWT/body, derivar owner,
rechazar campos prohibidos, llamar a la RPC y construir una respuesta pública.

C2 no implementa listado, Flutter, UI/providers, IA, streaming, remoto,
producción ni datos reales.

### Contrato HTTP

Endpoint futuro:

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

Campos prohibidos: `role`, `userId`, `user_id`, `specialistId`,
`specialist_id`, `internalSpecialistId`, `created_at`, `createdAt`,
`message_count`, `messageCount`, `last_message_at`, `lastMessageAt`,
`attachments`, `assistant`, `system`, `tool` y `metadata`. Cualquier campo
extra debe rechazarse.

### JWT e identidad

La función debe validar el JWT contra Auth local, no solo decodificarlo. El
owner se deriva exclusivamente de `sub`. El cliente no puede enviar owner,
`userId` ni `user_id`. JWT ausente, inválido o identidad local inválida fallan
cerrado. No se loguea JWT completo.

### Body y contenido

Validaciones:

- `sessionId` requerido y UUID válido;
- `content` requerido y string;
- `btrim(content)` no vacío;
- longitud de `btrim(content)` menor o igual a 4000;
- rechazo de campos extra o internos.

La Edge Function puede trimar el contenido, pero la RPC sigue siendo la
autoridad final de validación.

### Llamada exclusiva a RPC

C2 debe llamar únicamente a:

```text
public.send_user_message_core
```

Con:

```text
p_session_id = sessionId validado
p_owner_user_id = owner derivado del JWT
p_content = content validado
```

La Edge Function no debe insertar directamente en `public.messages`, no debe
actualizar directamente `public.chat_sessions` y no debe hacer dos escrituras
REST separadas. Esto preserva la atomicidad conseguida en C1.

### No filtrado de sesiones ajenas

La función no debe consultar ni distinguir públicamente si una sesión existe
pero pertenece a otro usuario. Sesión inexistente y sesión ajena se responden
igual: `sessionNotFound` con HTTP 404. Solo una sesión propia archivada puede
mapearse a `sessionArchived` con HTTP 409.

### Mapeo de errores

| Error público | HTTP |
| --- | --- |
| `unauthenticated` | 401 |
| `invalidSession` | 401 |
| `invalidRequest` | 400 |
| `contentInvalid` | 400 |
| `contentTooLong` | 400 |
| `sessionNotFound` | 404 |
| `sessionArchived` | 409 |
| `permissionDenied` | 403 |
| `writeUnconfirmed` | 409 |
| `contractViolation` | 502 |
| `backendMisconfigured` | 503 |
| `unexpectedError` | 500 |

### Respuesta pública

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

No devolver `user_id`, `specialist_id`, `prompt_template`, `service_role`, JWT,
attachments, metadata interna ni roles internos innecesarios.

### Seguridad y logs

`service_role`, si se usa, será local, no versionado y no aparecerá en logs.
Los logs permitidos se limitan a `operation`, `result`, `latency`,
`request_id`, `contract_version` y `error_code`. No loguear JWT completo,
`service_role`, `user_id` completo, contenido completo sensible,
`prompt_template` ni `specialist_id`.

### Tests futuros C2

- JWT ausente e inválido;
- owner derivado desde JWT local;
- body vacío y campos extra rechazados;
- rechazo de `role`, `userId`, `specialistId`, `created_at`,
  `message_count`, `last_message_at`, `attachments` y `metadata`;
- content válido, trimmeado, nulo, vacío, whitespace y >4000;
- sesión propia activa crea mensaje;
- sesión ajena e inexistente devuelven el mismo `sessionNotFound`;
- sesión propia archivada devuelve `sessionArchived`;
- segundo mensaje incrementa contador correctamente;
- Edge Function llama a RPC y no hace inserts/updates directos;
- no hay estado parcial;
- respuesta no expone IDs internos ni metadata sensible;
- no modifica `specialist_catalog` ni `specialists`;
- no IA, no streaming, no listado;
- cleanup `0|0|0|0|0|0`;
- anti-remoto: sin `link`, `db push`, deploy, project ref remoto ni tokens
  remotos.

### Fixtures futuras

Marcador `test_only_2b_v_c2` con owner, other, especialista, catálogo, sesión
propia activa, sesión propia archivada y sesión ajena. Cleanup obligatorio
sobre `auth.users`, `public.users`, `public.specialists`,
`public.specialist_catalog`, `public.chat_sessions` y `public.messages`, con
postcondición `0|0|0|0|0|0`.

### Relación con siguientes paquetes

```text
2B-V-C2 = Edge Function send-user-message
2B-V-D = list-session-messages
2B-V-E = contrato Flutter desconectado messages
2B-V-F = datasource Flutter HTTP local messages
2B-V-G = integración HTTP local messages
```

C2 no autoriza D/E/F/G ni conexión real. Requiere aprobación explícita antes de
implementar.

## Resultado de implementación 2B-V-C2 — Edge Function send-user-message

Fecha: 2026-06-20.

2B-V-C2 quedó implementado exclusivamente como Edge Function local
`send-user-message`, sin modificar migraciones, Flutter, CI, UI/providers,
remoto ni producción.

### Implementación

- Función nueva: `supabase/functions/send-user-message/`.
- Harness local: `supabase/tests/2b_v_c2_send_user_message_http_test.sh`.
- Fixtures locales: `test_only_2b_v_c2`.
- Cleanup dedicado con postcondición `0|0|0|0|0|0`.
- JWT validado contra Auth local.
- Owner derivado desde JWT; no se acepta owner desde body.
- Body allowlist exacto: `sessionId` y `content`.
- Campos internos/extra rechazados.
- Content trimmeado y validado.
- Llamada exclusiva a `public.send_user_message_core`.
- No hay inserts directos en `public.messages`.
- No hay updates directos en `public.chat_sessions`.
- No se hacen dos escrituras REST separadas.
- Sesión ajena e inexistente se exponen igual: `sessionNotFound` 404.
- Sesión propia archivada: `sessionArchived` 409.
- Respuesta pública sin `user_id`, `specialist_id`, `prompt_template`,
  `service_role`, JWT, attachments ni metadata interna.

### Evidencia

- SQL local acumulado: 394/394.
- Deno unitario C2: 7/7.
- Harness HTTP C2: PASS.
- Cleanup final: `0|0|0|0|0|0`.
- Gate estático: runtime contiene `/rest/v1/rpc/send_user_message_core` y no
  contiene `/rest/v1/messages` ni `/rest/v1/chat_sessions`.
- Logs seguros: no se detectaron JWT, owner completo, `service_role`, content
  completo, `specialist_id`, `user_id` ni `prompt_template`.
- Anti-remoto: sin `link`, `db push`, deploy, project ref remoto ni tokens
  remotos versionados.

### Alcance bloqueado

C2 solo envía mensajes de usuario mediante RPC. No lista mensajes, no conecta
Flutter, no sustituye chat heredado, no invoca IA, no hace streaming, no activa
remoto, no habilita producción y no desbloquea datos reales.

## Cierre formal 2B-V-C2 y plan exacto 2B-V-D — list-session-messages

Fecha: 2026-06-20.

2B-V-C2 queda cerrado formalmente y 2B-V-C queda cerrado localmente con C1 RPC
transaccional y C2 Edge Function local. El siguiente paquete documental es
2B-V-D `list-session-messages`, que fue implementado y verificado localmente
después de este plan.

### Objetivo D

Crear, si se aprueba, una Edge Function local de solo lectura para listar
mensajes de una sesión propia activa o archivada. Debe preservar el patrón de
frontera backend: JWT validado contra Auth local, owner derivado desde `sub`,
query estricta, respuesta pública sanitizada, sin remoto y sin datos reales.

### Contrato futuro

```http
GET /functions/v1/list-session-messages
Authorization: Bearer <JWT_LOCAL_VALIDADO>
Accept: application/json
```

Query permitida: `sessionId`, `limit`, `cursor`.

Query prohibida: `userId`, `user_id`, `owner`, `ownerId`, `specialistId`,
`specialist_id`, `internalSpecialistId`, `role`, `roles`, `created_at`,
`message_count`, `last_message_at`, `prompt_template`, `metadata` y cualquier
parámetro desconocido.

### Ownership y sesiones archivadas

Regla de ownership:

```text
session.id = sessionId
session.user_id = owner derivado del JWT
```

Sesión ajena e inexistente deben devolver el mismo `sessionNotFound` 404 opaco.
La función no debe filtrar si una sesión existe pero pertenece a otro usuario.

Sesión archivada propia sí debe poder leerse. Archivar una sesión no borra sus
mensajes y no debe impedir consultar el historial. El bloqueo de escritura en
archivadas ya pertenece a `send-user-message`.

### Lectura y paginación

La lectura se limita a `public.messages` de la sesión validada. Orden estable:

```text
created_at ASC
id ASC
```

`limit` default `50`, mínimo `1`, máximo `100`. Cursor opaco basado
conceptualmente en `createdAt` y `messageId`; cursor inválido devuelve
`invalidCursor`.

### Mutaciones prohibidas

D no debe modificar:

```text
messages
chat_sessions
message_count
last_message_at
specialists
specialist_catalog
```

La implementación futura deberá demostrar que `message_count` y
`last_message_at` permanecen idénticos antes y después del listado.

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

Roles visibles: `user`, `assistant`, `system`, `tool`.

No devolver `user_id`, `specialist_id`, `prompt_template`, `service_role`, JWT,
attachments ni metadata interna.

### Errores

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

### Tests futuros obligatorios

- Sin JWT e inválido.
- Query vacío y campos internos rechazados.
- Sesión propia activa lista mensajes.
- Sesión propia archivada lista mensajes históricos.
- Sesión ajena e inexistente devuelven `sessionNotFound` indistinguible.
- Orden estable y paginación sin duplicados.
- `nextCursor` solo si hay más resultados.
- Respuesta sin IDs internos, prompts, attachments, JWT ni metadata.
- No modifica `messages`, `chat_sessions`, `message_count`,
  `last_message_at`, catálogo o especialistas.
- No IA, no streaming.
- Cleanup final `0|0|0|0|0|0`.
- Anti-remoto y Supabase local detenido al final.

### Fixtures futuras

Marcador `test_only_2b_v_d`. Deben cubrir owner/other, especialista, catálogo,
sesión propia activa, sesión propia archivada, sesión ajena, mensajes propios,
mensaje histórico archivado y mensaje ajeno. Cleanup sobre Auth, perfiles,
especialistas, catálogo, sesiones y mensajes con postcondición
`0|0|0|0|0|0`.

### Relación con siguientes paquetes

```text
2B-V-D = list-session-messages
2B-V-E = contrato Flutter desconectado messages
2B-V-F = datasource Flutter HTTP local messages
2B-V-G = integración HTTP local messages
```

D no implementa Flutter, UI/providers, IA, streaming, remoto ni producción.

## Resultado de implementación 2B-V-D — list-session-messages

Fecha: 2026-06-21.

2B-V-D queda implementado y verificado exclusivamente en entorno local/efímero.
La nueva Edge Function `list-session-messages` mantiene la frontera backend:
JWT local validado, owner derivado desde Auth local, query allowlist, lectura
solo de mensajes de sesión propia validada, respuesta pública sanitizada y
logs sin secretos ni IDs internos.

### Controles críticos cerrados

- Sesión propia activa lista mensajes.
- Sesión propia archivada lista mensajes históricos.
- Sesión ajena e inexistente devuelven el mismo `sessionNotFound` 404 opaco.
- La función no escribe en `public.messages`.
- La función no modifica `public.chat_sessions`.
- `message_count` y `last_message_at` permanecen idénticos antes/después.
- Catálogo y especialistas permanecen intactos.
- Paginación keyset por `created_at ASC, id ASC` sin duplicados.
- Respuesta sin `user_id`, `specialist_id`, `prompt_template`, `service_role`,
  JWT, attachments ni metadata interna.
- Cleanup final verificado: `0|0|0|0|0|0`.

### Evidencia local

- `supabase db reset --local --no-seed`: migraciones `00001`-`00007`.
- `supabase test db --local`: 394/394.
- `deno test supabase/functions/list-session-messages`: 6/6.
- Harness HTTP `2b_v_d_list_session_messages_http_test.sh`: PASS.
- Anti-remoto por preflight local; sin `link`, `db push`, deploy, remoto,
  producción, datos reales ni tokens reales versionados.

2B-V-D no implementa Flutter, UI/providers, IA, streaming, Stasis Engine, MCP,
remoto, producción ni datos reales. Los siguientes paquetes 2B-V-E/F/G
requieren aprobación explícita separada.

## Cierre formal 2B-V-D y plan exacto 2B-V-E — contrato Flutter messages desconectado

Fecha: 2026-06-21.

2B-V-D queda cerrado formalmente. Se acepta que `list-session-messages`
permite leer mensajes de sesión propia activa o archivada, devuelve sesión
ajena e inexistente como `sessionNotFound` opaco, pagina sin duplicados,
devuelve respuesta sanitizada, no modifica `messages`, `chat_sessions`,
`message_count`, `last_message_at`, catálogo ni especialistas y fue validada
localmente con SQL 394/394, Deno 6/6, harness HTTP PASS, cleanup
`0|0|0|0|0|0`, sin remoto ni producción.

2B-V-E será el contrato Flutter desconectado de mensajes. No implementa red,
datasource HTTP, providers, UI, Supabase client, llamadas reales a Edge
Functions, IA, streaming, remoto ni producción.

### Contratos públicos permitidos

Modelos futuros:

```text
OwnChatMessage
OwnChatMessagesPage
SentOwnChatMessage
OwnChatMessagesRepository
```

`OwnChatMessage` solo puede exponer `messageId`, `sessionId`, `role`,
`content`, `createdAt` e `isDemo`.

Roles visibles permitidos: `user`, `assistant`, `system`, `tool`.

### Campos y autoridad prohibidos en Flutter

El contrato Flutter no debe incluir ni enviar:

```text
userId
user_id
specialistId
specialist_id
promptTemplate
prompt_template
attachments
metadata
serviceRole
service_role
JWT
role enviado por Flutter
createdAt enviado por Flutter
messageCount enviado por Flutter
lastMessageAt enviado por Flutter
```

Flutter nunca decide ownership, permisos, existencia de sesión ajena ni
contadores como fuente de verdad.

### Operaciones futuras del repositorio

```text
sendUserMessage(sessionId, content)
listSessionMessages(sessionId, limit, cursor)
```

`sendUserMessage` enviará solo `sessionId` y `content` cuando F implemente el
datasource HTTP local. `listSessionMessages` enviará solo `sessionId`, `limit`
y `cursor`.

### Repositorios desconectados

- Demo repository: no toca red ni Supabase, devuelve datos locales marcados con
  `isDemo=true` y no hace fallback desde errores reales.
- Backend blocked repository: no toca red ni Supabase, devuelve
  `backendBlocked` y no sustituye errores por demo.

### Validación y tests futuros

E deberá diseñar tests de modelos, resultados, payload validator y
arquitectura:

- campos públicos exactos;
- roles inválidos rechazados;
- payload con `user_id`, `specialist_id`, attachments, metadata o campos extra
  rechazado;
- sin imports de Supabase;
- sin imports HTTP reales;
- sin URLs de Edge Functions hardcodeadas;
- sin providers reales;
- sin UI;
- sin IA;
- sin streaming.

### Relación con paquetes siguientes

```text
2B-V-E = contrato Flutter desconectado messages
2B-V-F = datasource Flutter HTTP local messages
2B-V-G = integración HTTP local messages
```

E no implementa red. F conectará el datasource local HTTP. G validará la
integración local de punta a punta.

## Resultado de implementación 2B-V-E — contrato Flutter messages desconectado

Fecha: 2026-06-21.

2B-V-E queda implementado como contrato Flutter desconectado para mensajes. La
feature nueva `chat_messages` no sustituye el chat heredado, no conecta
providers, no crea UI, no llama Edge Functions, no usa Supabase client y no
introduce transporte HTTP.

### Frontera pública creada

```text
OwnChatMessage
OwnChatMessagesPage
SentOwnChatMessage
OwnChatMessageRole
OwnChatMessagesRepository
DemoOwnChatMessagesRepository
BackendBlockedOwnChatMessagesRepository
OwnChatMessagesPayloadValidator
```

`OwnChatMessageRole` acepta solo:

```text
user
assistant
system
tool
```

`chief_intervention`, `admin`, `manager`, `specialist` y `moderator` quedan
rechazados.

### Garantías verificadas

- `sendUserMessage` recibe solo `sessionId` y `content`.
- Flutter no envía `role`.
- Flutter no envía `userId`.
- Flutter no envía `specialistId`.
- Flutter no envía timestamps ni contadores server-managed.
- Los modelos públicos no exponen campos internos.
- Los validadores rechazan `user_id`, `userId`, `specialist_id`,
  `specialistId`, `attachments`, `metadata`, tokens, service role y campos
  extra.
- Demo repository produce datos `isDemo=true`, sin red y sin fallback desde
  errores reales.
- Backend blocked repository devuelve `backendBlocked`, sin demo fallback.
- Tests arquitectónicos bloquean Supabase, HTTP real, URLs de Edge Functions,
  providers reales, UI, IA, Stasis Engine, MCP y streaming.

### Evidencia

- Tests nuevos 2B-V-E: 18/18.
- `dart run build_runner build --delete-conflicting-outputs`: 0 salidas.
- `flutter analyze --no-fatal-infos`: correcto; solo infos preexistentes.
- `flutter test`: 101 tests superados, 1 skipped del harness local existente.

### Paquetes siguientes

```text
2B-V-F = datasource Flutter HTTP local messages
2B-V-G = integración HTTP local messages
```

F y G siguen bloqueados hasta aprobación explícita. No se habilita remoto,
producción, datos reales, IA, Stasis Engine ni streaming.

## Cierre formal 2B-V-E y plan exacto 2B-V-F — datasource Flutter HTTP local messages

Fecha: 2026-06-21.

2B-V-E queda cerrado formalmente. El contrato Flutter desconectado de mensajes
existe, fue verificado con tests nuevos 18/18 y suite Flutter 101 passed, 1
skipped, y mantiene separación total de red real, Supabase, HTTP real, URLs
hardcodeadas, UI/providers, Edge Functions, remoto, producción, IA, Stasis
Engine, MCP y streaming.

### Estado actual de 2B-V

```text
2B-V-A — messages deny-all + constraints
2B-V-B — fixtures messages transaccionales
2B-V-C1 — RPC transaccional send_user_message_core
2B-V-C2 — Edge Function send-user-message
2B-V-D — Edge Function list-session-messages
2B-V-E — contrato Flutter messages desconectado
```

### Objetivo de 2B-V-F

2B-V-F deberá diseñar, si se aprueba su implementación, un datasource Flutter
HTTP local de mensajes que conecte el contrato `OwnChatMessagesRepository` con
las Edge Functions locales `send-user-message` y `list-session-messages`, sin
providers/UI y sin remoto.

Datasource propuesto:

```text
LocalHttpOwnChatMessagesDataSource
```

Componentes auxiliares propuestos:

```text
LocalSessionTokenProvider
OwnChatMessagesHttpTransport
LocalOnlyHostPolicy
```

### Host policy local

La composición debe aceptar únicamente `http://localhost:<puerto>` o
`http://127.0.0.1:<puerto>`. Debe bloquear Supabase cloud, HTTPS, dominios
remotos, host vacío, puerto implícito y composición deshabilitada. El bloqueo
debe ocurrir antes de leer token y antes de transporte.

### Token y transporte

- JWT inyectado, nunca hardcodeado.
- JWT no persistido ni logueado.
- Token ausente o vacío -> `unauthenticated`.
- Sin token no se ejecuta transporte.
- Transporte inyectable, testeable con fake.
- Sin Supabase client.
- Base URL inyectada.
- Redirects deshabilitados.
- Errores de transporte -> `networkError`.

### Requests permitidos

`sendUserMessage` envía solo:

```json
{
  "sessionId": "...",
  "content": "..."
}
```

`listSessionMessages` envía solo:

```text
sessionId
limit
cursor
```

Nunca se envía `role`, `userId`, `specialistId`, `createdAt`,
`messageCount`, `lastMessageAt`, attachments, metadata, owner ni campos
internos.

### Validación y errores

Toda respuesta se trata como no confiable y se valida con
`OwnChatMessagesPayloadValidator`. Campos internos, extra, payload parcial,
role inválido, fechas inválidas, cursor inválido, attachments, metadata,
`user_id` o `specialist_id` producen `contractViolation`.

Errores HTTP se mapearán a resultados tipados. `sessionArchived` solo aplica a
envío; `invalidCursor` solo aplica a listado; errores de transporte producen
`networkError`.

### Sin fallback demo

Un error HTTP, de red o de contrato nunca puede convertirse en demo. Demo
repository y backend blocked repository permanecen separados.

### Relación con 2B-V-G

```text
2B-V-F = datasource Flutter HTTP local messages
2B-V-G = integración HTTP local Flutter datasource ↔ Edge Functions locales
```

F usará tests unitarios con transporte falso. G será el paquete que ejecute la
integración real contra Edge Functions locales.

## Resultado de implementación 2B-V-F — datasource Flutter HTTP local messages

Fecha: 2026-06-21.

2B-V-F queda implementado y verificado como datasource Flutter HTTP local para
mensajes. No conecta Flutter todavía con Edge Functions reales ni modifica
providers/UI; solo crea una frontera de datos testeable con transporte
inyectable.

### Componentes implementados

- `LocalHttpOwnChatMessagesDataSource`.
- `LocalOnlyHostPolicy`.
- `LocalSessionTokenProvider`.
- `OwnChatMessagesHttpTransport` y tipos de request/response.
- Tests unitarios de host policy, token, requests, validación de respuestas,
  mapeo de errores y arquitectura.

### Frontera backend conservada

El datasource centraliza los paths locales:

```text
/functions/v1/send-user-message
/functions/v1/list-session-messages
```

No hardcodea dominio remoto, no usa Supabase client, no importa Dio/http real y
no permite Supabase cloud ni HTTPS en la composición local.

### Contrato público conservado

Los requests quedan limitados a:

```text
send: sessionId, content
list: sessionId, limit, cursor opcional
```

No se envían `role`, `userId`, `specialistId`, `attachments`, `metadata`,
`messageCount`, `lastMessageAt` ni campos internos. Las respuestas se validan
como no confiables con `OwnChatMessagesPayloadValidator`.

### Verificación ejecutada

- `flutter test test/features/chat_messages test/architecture/own_chat_messages_contract_test.dart`: 34/34 tests passed.
- `dart run build_runner build --delete-conflicting-outputs`: 0 outputs written.
- `flutter analyze --no-fatal-infos`: passed con 48 infos preexistentes fuera de
  `chat_messages`.
- `flutter test`: 117 passed, 1 skipped.
- `git diff --check`: sin errores.

### Fuera de alcance preservado

No se modificaron Supabase, migraciones, Edge Functions, CI, providers, UI,
chat heredado, auth real, backend remoto, producción, datos reales, IA, Stasis
Engine, MCP ni streaming.

### Siguiente gate

2B-V-G deberá aprobarse por separado para ejecutar integración HTTP local real
contra Edge Functions locales.

## Cierre formal 2B-V-F y plan exacto 2B-V-G — integración HTTP local messages

Fecha: 2026-06-21.

2B-V-F queda cerrado formalmente. El datasource Flutter HTTP local existe,
bloquea remoto antes de token/transporte, usa token provider inyectado,
transporte inyectable, requests mínimos, validación estricta de respuestas,
mapeo de errores tipado y cero fallback demo. No usa Supabase client, no usa
Dio/http real directo, no conecta UI/providers, no toca Supabase, Edge
Functions ni migraciones.

### Estado actual de 2B-V

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

2B-V-G deberá validar localmente el recorrido real:

```text
LocalHttpOwnChatMessagesDataSource
send-user-message
list-session-messages
send_user_message_core
Supabase local
```

Debe probar envío, listado, contador, `lastMessageAt`, paginación, errores
opacos, no exposición de campos internos y cleanup total, sin remoto ni UI.

### Harness local futuro

El harness deberá arrancar Supabase local, resetear con
`supabase db reset --local --no-seed`, crear fixtures `test_only_2b_v_g`,
crear usuarios Auth locales, obtener JWT local efímero, servir Edge Functions
locales con env temporal fuera del repo, ejecutar un test Flutter de
integración, limpiar fixtures, verificar `0|0|0|0|0|0` y detener Supabase
local.

### Fixtures locales

Fixtures permitidos:

- owner user;
- other user;
- internal specialist;
- specialist catalog entry;
- owner active session;
- owner archived session;
- other user session;
- mensajes previos owner active para paginación;
- mensajes previos owner archived para lectura histórica.

No deben convertirse en seed persistente. Deben quedar limpiados en:

```text
auth.users
public.users
public.specialists
public.specialist_catalog
public.chat_sessions
public.messages
= 0|0|0|0|0|0
```

### Flujo E2E mínimo

El test deberá construir el datasource con base URL local e inyectar JWT local
efímero. Deberá enviar un mensaje a sesión propia activa, verificar success,
`role=user`, content trimmeado, incremento de `messageCount` y actualización
de `lastMessageAt`. Después deberá listar la sesión propia activa, comprobar
que el mensaje aparece sin `userId`, `specialistId`, attachments ni metadata,
listar sesión propia archivada como lectura histórica permitida, rechazar envío
a archivada con `sessionArchived`, y devolver `sessionNotFound` opaco para
listar o enviar en sesión ajena.

### Paginación

La prueba deberá crear varios mensajes en sesión propia, listar con límite
pequeño, verificar `nextCursor`, solicitar la página siguiente, comprobar
ausencia de duplicados, orden `created_at ASC, id ASC` y página final con
`nextCursor = null`.

### Anti-remoto

Preflight obligatorio:

- base URL solo `http://localhost:<puerto>` o `http://127.0.0.1:<puerto>`;
- Supabase cloud bloqueado;
- HTTPS bloqueado;
- dominios remotos bloqueados;
- puerto implícito bloqueado;
- sin `supabase link`;
- sin `supabase db push`;
- sin deploy;
- sin project ref remoto;
- sin tokens remotos.

### Secretos y logs

JWT local efímero fuera del repo; `service_role` local solo en runtime Edge
Functions; env temporal no versionado; permisos restrictivos; cleanup de
temporales; logs sin JWT, `service_role`, content completo, owner completo ni
IDs internos.

### Tests futuros

- send en sesión propia activa;
- content trimmeado;
- `role=user`;
- `messageCount +1`;
- `lastMessageAt` actualizado;
- respuesta pública validada;
- listado de sesión propia activa;
- listado de sesión propia archivada;
- sesión ajena e inexistente opacas;
- paginación estable y sin duplicados;
- JWT ausente/inválido;
- content inválido;
- sesión archivada al enviar;
- cursor inválido;
- no campos internos;
- no logs sensibles;
- no fallback demo;
- no remoto;
- cleanup total.

### Siguiente decisión

Tras G, decidir por separado entre conectar providers, crear UI mínima,
integrar con `chat_sessions` existente o cerrar 2B-V. Este ADR no aprueba esas
acciones.

## Resultado de implementación 2B-V-G — integración HTTP local messages

Fecha: 2026-06-21.

2B-V-G queda implementado y verificado como integración HTTP local real entre
el datasource Flutter de mensajes, las Edge Functions locales
`send-user-message` y `list-session-messages`, la RPC
`send_user_message_core` y Supabase local.

### Archivos del paquete

```text
supabase/tests/2b_v_g_messages_http_integration_setup.psql
supabase/tests/2b_v_g_messages_http_integration_cleanup.psql
supabase/tests/2b_v_g_messages_http_integration_test.sh
test/integration/two_b_v_g_local_http_chat_messages_integration_test.dart
```

También se actualizó `supabase/tests/README.md` y la documentación normativa.

### Validaciones principales

- Fixtures `test_only_2b_v_g` efímeros.
- JWT local efímero fuera del repo.
- Env temporal fuera del repo y con permisos restrictivos.
- `service_role` solo en runtime local de Edge Functions.
- Base URL local-only.
- Preflight anti-remoto.
- `sendUserMessage` crea mensaje `role=user`, trimmea content, incrementa
  `message_count` y actualiza `last_message_at`.
- `listSessionMessages` lista sesión propia activa y archivada.
- Sesión ajena e inexistente responden `sessionNotFound` opaco.
- Sesión archivada es legible, pero no escribible.
- Paginación estable sin duplicados.
- Cursor inválido produce `invalidCursor`.
- Respuestas públicas sin `userId`, `specialistId`, attachments ni metadata.
- `list-session-messages` no modifica `messages`, `chat_sessions`,
  `message_count`, `last_message_at`, `specialists` ni
  `specialist_catalog`.
- Logs sin JWT completo, `service_role`, content completo, owner completo, IDs
  internos completos, `prompt_template` ni metadata interna.
- Cleanup final exacto `0|0|0|0|0|0`.

### Bug detectado y corregido

El primer intento del harness detectó timestamps de fixture en el futuro
respecto al reloj de PostgreSQL local. La RPC rechazó la actualización por la
constraint `chat_sessions_chronology_valid`. Se corrigió únicamente el harness
G para usar timestamps relativos a `now()`. No se modificaron migraciones, RPC,
Edge Functions ni código de aplicación.

### Verificación ejecutada

- Supabase local arrancado en modo mínimo, excluyendo servicios auxiliares por
  conflicto local de puerto `54327`.
- `supabase db reset --local --no-seed`.
- `supabase test db --local`: 394/394.
- Harness 2B-V-G: PASS.
- Test Flutter de integración G: 3/3.
- `flutter test`: 117 passed, 2 skipped.
- `flutter analyze --no-fatal-infos`: PASS con 48 infos preexistentes.
- `git diff --check`: PASS.
- `supabase stop --no-backup`.

### Frontera preservada

No se conectaron providers, UI, chat heredado, remoto, producción, Supabase
real, datos reales, IA, Stasis Engine, MCP ni streaming.

### Siguiente decisión

Decidir si el siguiente paquete será providers/UI, integración con el flujo
actual de chat, cierre de 2B-V o cambio de área. Requiere aprobación explícita.

## Cierre formal 2B-V-G y preparación 2B-V-H — cierre del bloque messages

Fecha: 2026-06-21.

2B-V-G queda cerrado formalmente. El bloque `messages` dispone ya de base SQL
endurecida, fixtures, RPC, Edge Functions locales, contrato Flutter,
datasource HTTP local e integración local end-to-end. Nada de esto desbloquea
providers, UI, chat heredado, remoto, producción, IA, Stasis Engine, MCP,
streaming ni datos reales.

### Estado completo de 2B-V

```text
2B-V-A — cerrado — messages deny-all + constraints
2B-V-B — cerrado — fixtures messages transaccionales
2B-V-C1 — cerrado — RPC transaccional send_user_message_core
2B-V-C2 — cerrado — Edge Function send-user-message
2B-V-D — cerrado — Edge Function list-session-messages
2B-V-E — cerrado — contrato Flutter messages desconectado
2B-V-F — cerrado — datasource Flutter HTTP local messages
2B-V-G — cerrado — integración HTTP local messages
```

### Bloqueos restantes

Permanecen bloqueados:

- providers reales;
- UI real;
- chat heredado;
- remoto;
- producción;
- datos reales;
- IA;
- Stasis Engine;
- MCP;
- streaming;
- notificaciones;
- adjuntos/attachments;
- mensajes reales `assistant`, `system` o `tool`.

### Matriz de rutas

| Ruta | Ventajas | Riesgos | Recomendación |
| --- | --- | --- | --- |
| A — Providers/capa de aplicación sin UI | Define estado y lifecycle antes de widgets. | Puede acoplarse mal si se mezcla con chat heredado. | Recomendada con alcance desconectado. |
| B — UI mínima | Hace visible el flujo. | Puede contaminar UI con lógica temporal si no hay capa previa. | Esperar. |
| C — Chat heredado | Acerca funcionalidad a la app actual. | Riesgo alto de romper la separación limpia. | No recomendar todavía. |
| D — Cerrar 2B-V y pasar a otro bloque | Mantiene el bloque técnico seguro. | Messages queda invisible temporalmente. | Alternativa válida si se prioriza otra área. |

### Recomendación

Preparar como siguiente paso:

```text
2B-V-I — capa de aplicación/providers messages sin UI
```

Debe ser primero documental o de alcance muy pequeño, sin UI, sin chat heredado,
sin remoto y sin producción. La capa deberá consumir repositorios públicos y no
filtrar JWT, Edge Functions, `userId`, `specialistId`, attachments, metadata ni
detalles internos hacia widgets.

## Cierre formal 2B-V-H y plan exacto 2B-V-I — capa de aplicación messages sin UI

Fecha: 2026-06-21.

2B-V-H queda cerrado formalmente. La siguiente dirección aprobada para
planificación es una capa de aplicación para `messages`, pero se recomienda
dividirla para evitar contaminar la frontera limpia con UI, providers reales o
chat heredado.

### Objetivo

La capa debe orquestar mensajes consumiendo `OwnChatMessagesRepository`, sin
conocer HTTP, Edge Functions, Supabase, JWT, ownership interno ni permisos. Debe
exponer estado para una UI futura, pero no crear UI.

### Responsabilidades

- Cargar mensajes de una sesión ya seleccionada.
- Enviar mensajes de usuario.
- Gestionar loading, loaded, empty, sending, paginating y error.
- Gestionar `nextCursor`.
- Evitar duplicados.
- Preservar orden.
- Mantener errores tipados.
- No inventar contadores ni timestamps como autoridad.
- No crear mensajes no humanos.

### Límites

- Sin Supabase directo.
- Sin HTTP directo.
- Sin URLs de Edge Functions.
- Sin `service_role`.
- Sin lectura directa de JWT.
- Sin `role`, `userId`, `specialistId`, timestamps o contadores como input.
- Sin widgets.
- Sin `BuildContext`.
- Sin chat heredado.
- Sin IA, Stasis Engine, MCP o streaming.

### División recomendada

```text
2B-V-I1 — application controller/state messages sin providers reales
2B-V-I2 — providers Riverpod messages sin UI
```

Se recomienda implementar primero I1 con tests de estado y repositorios falsos.
I2 deberá esperar a que I1 esté cerrado, para conectar Riverpod sin mezclar
decisiones de UI ni chat heredado.

### Siguientes paquetes posibles

```text
2B-V-I1 — application controller/state messages sin providers reales
2B-V-I2 — providers Riverpod messages sin UI
2B-V-J — UI mínima messages
2B-V-K — integración controlada con chat actual
```

Estado: todos pendientes de aprobación. Este ADR no autoriza implementación.

## Resultado de implementación 2B-V-I1 — application controller/state messages sin providers reales

Fecha: 2026-06-21.

2B-V-I1 queda implementado como capa de aplicación pura para `messages`. La
frontera limpia se mantiene: no Riverpod/Provider, no UI, no `BuildContext`, no
chat heredado, no Supabase, no HTTP directo, no Edge Function paths, no IA, no
Stasis Engine, no MCP y no streaming.

### Componentes

```text
lib/features/chat_messages/application/own_chat_messages_state.dart
lib/features/chat_messages/application/own_chat_messages_controller.dart
test/features/chat_messages/application/own_chat_messages_controller_test.dart
```

### Comportamiento

- `loadInitial` carga primera página y registra errores tipados.
- `loadNextPage` usa cursor, añade mensajes únicos y conserva listado ante
  error.
- `sendMessage` recibe solo content, usa sesión seleccionada y conserva listado
  ante error de envío.
- `refresh` recarga desde primera página.
- `clear` limpia estado completo.
- Demo y backendBlocked son estados explícitos según el repositorio inyectado.

### Gates arquitectónicos

El test arquitectónico impide que `application/` importe o contenga:

- Flutter UI o `BuildContext`;
- Riverpod/Provider/hooks;
- Dio/http directo;
- Supabase;
- paths de Edge Functions;
- chat heredado;
- IA, Stasis Engine, MCP o streaming.

### Verificación

- Tests específicos de `chat_messages` y arquitectura: 51/51.
- `build_runner`: 0 salidas.
- Analyze: PASS con 48 infos preexistentes.
- Suite Flutter: 134 passed, 2 skipped.
- `git diff --check`: PASS.

### Siguiente gate

`2B-V-I2 — providers Riverpod messages sin UI` permanece bloqueado hasta
aprobación explícita. I2 no debe crear UI ni integrar chat heredado.

## Cierre formal 2B-V-I1 y plan exacto 2B-V-I2 — providers messages sin UI

Fecha: 2026-06-21.

2B-V-I1 queda cerrado formalmente también desde la perspectiva de frontera
backend/catálogo/sesiones. La capa `application` de `messages` queda aceptada
como un límite limpio: no contiene Riverpod/Provider, UI, `BuildContext`, HTTP
directo, Supabase, Edge Function paths, chat heredado, IA, Stasis Engine, MCP
ni streaming. Sus operaciones (`loadInitial`, `loadNextPage`, `sendMessage`,
`refresh`, `clear`) consumen únicamente `OwnChatMessagesRepository` y estados
tipados.

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
2B-V-H — cerrado documentalmente — decisión de seguir con capa application/providers
2B-V-I1 — cerrado — application controller/state messages sin providers reales
2B-V-I2 — plan preparado — providers Riverpod messages sin UI
```

### Riverpod real vs adapter neutro

La inspección del proyecto confirma uso real de Riverpod:

- `pubspec.yaml` declara `flutter_riverpod`, `riverpod_annotation` y
  `riverpod_generator`.
- `lib/main.dart` envuelve la app con `ProviderScope`.
- Existen providers manuales en `core`, `profile` y `specialists`.
- Existen providers generados con `riverpod_annotation` en `auth`, `chat` y
  `orchestrator`.

Por tanto, para 2B-V-I2 se recomienda **Riverpod real sin UI**. No se
recomienda introducir un adapter neutro adicional salvo que aparezca una razón
técnica fuerte durante la implementación. La protección importante no es evitar
Riverpod, sino impedir que Riverpod contamine la capa `application` limpia o
reutilice el chat heredado inseguro.

### Objetivo de 2B-V-I2

Definir providers de `messages` que conecten:

```text
OwnChatMessagesRepository
OwnChatMessagesController
OwnChatMessagesState
```

sin crear widgets, navegación, pantallas, chat bubbles, integración con chat
heredado, red real, Supabase directo ni producción.

### Providers futuros

Nombres orientativos, ajustables al estilo local:

```text
ownChatMessagesRepositoryProvider
ownChatMessagesControllerProvider
ownChatMessagesStateProvider
```

Los providers deberán permitir overrides de repositorio para tests y deberán
seleccionar explícitamente demo o backendBlocked según configuración aprobada.
No pueden construir endpoints remotos, leer `service_role`, obtener JWT por su
cuenta ni decidir ownership.

### Lifecycle y errores visibles

El lifecycle mínimo de I2 será:

- seleccionar `sessionId`;
- cargar primera página con `loadInitial`;
- paginar con `loadNextPage`;
- enviar con `sendMessage`;
- refrescar con `refresh`;
- limpiar con `clear` o dispose si aplica.

El estado expuesto debe conservar:

- `isInitialLoading`;
- `isPaginating`;
- `isSending`;
- `lastListError`;
- `lastSendError`;
- `isDemo`;
- `isBackendBlocked`;
- `confirmedMessageCount`;
- `confirmedLastMessageAt`.

Ningún error real puede convertirse en demo. Un error de envío no debe destruir
el listado existente.

### Testing futuro con overrides

I2 deberá añadir tests de providers con `ProviderContainer` u opción equivalente
del patrón local:

- creación de controller y estado inicial;
- override con fake success repository;
- override con demo repository explícito;
- override con backendBlocked repository explícito;
- `loadInitial`, `loadNextPage`, `sendMessage`, `refresh` y `clear` desde el
  provider;
- cambio de sesión sin mezclar mensajes;
- error de envío conserva listado;
- error de listado queda visible;
- no hay imports de Supabase, HTTP directo, UI/widgets, `BuildContext`, chat
  heredado, IA, Stasis Engine, MCP ni streaming.

### Límites con UI futura

I2 no autoriza `2B-V-J` ni ninguna pantalla. La UI futura solo podrá consumir
estado y operaciones del provider. No podrá recibir `userId`, `specialistId`,
`role`, JWT, URLs de Edge Functions, metadata, attachments ni detalles internos
del backend.

### Relación con siguientes pasos

Después de I2 podrán proponerse paquetes separados:

```text
2B-V-J — UI mínima messages
2B-V-K — integración controlada con chat actual
2B-V-L — cierre de bloque messages y paso a otro módulo
```

Ninguno queda aprobado por este plan.

## Resultado de implementación 2B-V-I2 — providers Riverpod messages sin UI

Fecha: 2026-06-21.

2B-V-I2 queda implementado como wiring Riverpod real para mensajes, manteniendo
la frontera backend/catálogo/sesiones limpia. No conecta UI, chat heredado,
Supabase remoto, Supabase client, HTTP directo desde providers, Edge Function
paths, producción ni datos reales.

### Archivos principales

```text
lib/features/chat_messages/presentation/providers/own_chat_messages_providers.dart
test/features/chat_messages/presentation/own_chat_messages_providers_test.dart
test/architecture/own_chat_messages_contract_test.dart
```

### Decisión arquitectónica

Los providers viven en `presentation/providers/` porque el proyecto ya usa esa
convención en `profile` y `specialists`. La capa `application/` continúa
protegida contra Riverpod/Provider, UI, HTTP, Supabase y chat heredado.

### Frontera preservada

- Repository provider selecciona demo únicamente en modo demo.
- Backend real y producción siguen backendBlocked.
- Controller provider delega en `OwnChatMessagesController`.
- State provider expone `OwnChatMessagesState`.
- Tests usan overrides con repositorios fake, demo y backendBlocked.
- Providers no conocen JWT, owner, permisos, `service_role`, paths HTTP ni IDs
  internos.

### Verificación

- Tests específicos de `chat_messages` + arquitectura: 67/67.
- Build runner: 0 salidas.
- Analyze: PASS con 48 infos preexistentes.
- Suite Flutter: 150 passed, 2 skipped.
- Diff check: PASS.

### Siguiente decisión

Debe decidirse por separado si avanzar a:

```text
2B-V-J — UI mínima messages
2B-V-K — integración controlada con chat actual
2B-V-L — cierre de bloque messages y paso a otro módulo
```

Nada de esto queda autorizado por I2.

## Cierre formal 2B-V-I2 y plan exacto 2B-V-J — UI mínima messages aislada

Fecha: 2026-06-21.

2B-V-I2 queda cerrado formalmente. Desde la frontera backend/catálogo/sesiones,
los providers de `chat_messages` quedan aceptados como capa de wiring
Riverpod, sin UI, sin chat heredado, sin navegación, sin Supabase directo, sin
HTTP directo desde providers, sin rutas de Edge Functions, sin remoto y sin
datos reales.

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

### Siguiente ruta recomendada

Preparar:

```text
2B-V-J — UI mínima messages aislada
```

No se elige todavía `2B-V-K — integración controlada con chat actual`. Esa
integración seguirá bloqueada porque el chat heredado conserva riesgo de
contaminar contratos, navegación y responsabilidades de la capa nueva.

### Objetivo

Diseñar un componente/panel mínimo que consuma los providers existentes:

```text
ownChatMessagesStateProvider
ownChatMessagesControllerProvider
```

La UI no debe llamar repositorios directamente, no debe construir datasources,
no debe conocer Edge Function paths y no debe decidir permisos ni ownership.

### Componentes propuestos

Nombre recomendado:

```text
OwnChatMessagesPanel
```

Componentes internos mínimos:

- `MessagesList`.
- `MessageBubble` mínima.
- `MessageInput` mínima.
- `MessagesEmptyState`.
- `MessagesLoadingState`.
- `MessagesErrorState`.
- `MessagesPaginationLoader` o botón manual `Cargar más`.

No deben presentarse como UX final ni como chat definitivo.

### Reglas de seguridad UI

La UI solo puede enviar:

```text
content
```

mediante:

```text
sendMessage(content)
```

Queda prohibido enviar o exponer:

- `role`;
- `userId`;
- `specialistId`;
- timestamps;
- contadores;
- ownership;
- permisos;
- IDs internos;
- JWT;
- `service_role`;
- metadata interna;
- attachments;
- paths de Edge Functions.

### Estados visibles

El panel debe mostrar:

- `initial`;
- `loading`;
- `loaded`;
- `empty`;
- `paginating`;
- `sending`;
- `backendBlocked`;
- `lastListError`;
- `lastSendError`;
- `sessionArchived`;
- `sessionNotFound`;
- `networkError`;
- `contractViolation`.

El listado existente no se borra por errores de envío o paginación.

### Sesión archivada

- Leer mensajes históricos puede estar permitido.
- Escribir en sesión archivada no está permitido.
- La UI no inventa estado archivado si no lo recibe de contexto aprobado.
- Si `sendMessage` devuelve `sessionArchived`, muestra error claro y conserva
  mensajes.

### Paginación

Para MVP local se recomienda botón manual `Cargar más`:

- usa `loadNextPage`;
- loading de paginación separado;
- sin infinite scroll;
- sin duplicados;
- no borra listado ante error.

### Demo/backendBlocked

- `isDemo` muestra etiqueta demo visible.
- `isBackendBlocked` muestra backend bloqueado.
- `networkError`, `contractViolation` o errores reales nunca cambian a demo.

### Tests futuros

Widget/render:

- loading;
- empty;
- listado;
- bubble por roles existentes en modelo;
- demo label;
- backendBlocked.

Operaciones:

- send llama solo con `content`;
- no existe input para `role`, `userId` o `specialistId`;
- paginación manual llama `loadNextPage`;
- refresh llama `refresh` si se incluye.

Errores:

- listado visible;
- envío visible sin borrar mensajes;
- `sessionArchived`;
- `networkError`;
- `contractViolation`.

Arquitectura:

- sin imports de Supabase;
- sin HTTP/Dio;
- sin Edge Function paths;
- sin chat heredado;
- sin navegación real;
- sin IA, Stasis Engine, MCP o streaming;
- sin `service_role` ni JWT;
- sin construcción directa de repositorios.

### Componente aislado vs demo-route

Recomendación: **Opción A — componente/panel aislado sin ruta real**.

Una demo-route interna queda como opción posterior y requiere aprobación
explícita porque aumenta riesgo de navegación real accidental.

### Relación con 2B-V-K

`2B-V-K` solo podrá evaluarse tras cerrar J. Su objetivo sería integración
controlada con chat actual/heredado, pero todavía no está autorizado.

## Resultado de implementación 2B-V-J — UI mínima messages aislada

Fecha: 2026-06-21.

2B-V-J queda implementado como componente UI aislado para mensajes propios. La
frontera backend se mantiene intacta: la UI no conoce catálogo interno, no
conoce `specialist_id`, no decide ownership, no toca rutas reales y no se
conecta al chat heredado.

### Archivos relevantes

```text
lib/features/chat_messages/presentation/widgets/own_chat_messages_panel.dart
test/features/chat_messages/presentation/own_chat_messages_panel_test.dart
test/architecture/own_chat_messages_contract_test.dart
```

### Decisiones confirmadas

- El componente se llama `OwnChatMessagesPanel`.
- No se crea página ni ruta.
- No se integra navegación real.
- No se conecta con chat heredado.
- No se importan Supabase, HTTP/Dio ni Edge Function paths.
- La UI consume providers Riverpod ya aprobados.
- El envío pasa únicamente `content` mediante `sendMessage(content)`.
- La UI no envía ni expone `role`, `userId`, `specialistId`, timestamps,
  contadores, ownership, JWT, `service_role`, metadata ni attachments.

### Estados y comportamiento

- Loading inicial.
- Empty.
- Listado de mensajes.
- Bubble mínima por mensaje.
- Demo visible.
- Backend blocked visible.
- Errores de listado visibles.
- Errores de envío visibles sin borrar mensajes.
- `sessionArchived` visible al enviar.
- Paginación manual mediante `Cargar más`.

La lectura de mensajes históricos de una sesión archivada queda permitida si el
estado/backend ya entrega esos mensajes. La escritura en sesión archivada sigue
bloqueada por backend y se representa como error de envío.

### Evidencia

- Tests específicos de `chat_messages` y arquitectura: 78/78.
- Suite completa Flutter: 161 passed, 2 skipped.
- `build_runner`: 0 outputs written.
- `flutter analyze --no-fatal-infos`: sin errores; solo infos no fatales
  preexistentes.

### Fuera de alcance

No se implementa integración K, demo-route, navegación real, sustitución del
chat heredado, remoto, producción, Supabase real, auth real, datos reales, IA,
Stasis Engine, MCP, streaming, attachments ni procesamiento de archivos.

### Siguiente gate

Antes de conectar esta UI a cualquier flujo real debe aprobarse por separado
si el chat heredado se integra, se adapta o se reemplaza. La recomendación es
mantener la separación limpia y diseñar `2B-V-K` como integración controlada,
pequeña y reversible.

## Cierre formal 2B-V-J y plan exacto 2B-V-J2 — host/demo aislado del panel messages

Fecha: 2026-06-21.

2B-V-J queda cerrado formalmente. Desde la frontera backend/catálogo/sesiones,
se acepta que `OwnChatMessagesPanel` es un componente UI aislado que no conoce
catálogo interno, no conoce `specialist_id`, no decide ownership, no toca rutas
reales, no importa Supabase/HTTP/Dio y no se conecta al chat heredado.

### Evidencia aceptada

- Tests específicos `chat_messages` + arquitectura: 78/78.
- Suite Flutter completa: 161 passed, 2 skipped.
- `flutter analyze --no-fatal-infos`: PASS con 48 infos preexistentes.
- `git diff --check`: PASS.
- `build_runner`: 0 outputs written.

### Decisión

No avanzar todavía a `2B-V-K — integración controlada con chat actual`.
Primero se recomienda preparar y, si se aprueba, implementar:

```text
2B-V-J2 — host/demo aislado del panel messages
```

### Opciones de host/demo

Opción A — Widget host de test/dev:

- no toca navegación;
- no contamina app real;
- permite inyectar providers fake/demo/backendBlocked;
- es la opción recomendada.

Opción B — Ruta demo interna no conectada a navegación principal:

- facilita prueba manual;
- aumenta riesgo de tocar routing o aparecer en producto;
- queda descartada para el primer J2 salvo aprobación separada.

### Alcance de J2

El host/demo podrá montar `OwnChatMessagesPanel`, inyectar providers
fake/demo/backendBlocked, mostrar estados controlados, probar input, probar
paginación y probar errores.

No podrá conectar chat heredado, usar sesión real, usar usuario real, usar
remoto, usar Supabase directo, tocar navegación productiva, tocar rutas
públicas, activar IA, activar streaming ni activar adjuntos.

### Datos fake/demo

Todos los fixtures serán locales y ficticios:

- mensajes `user`, `assistant`, `system` y `tool`;
- empty;
- loading;
- backendBlocked;
- demo;
- error list;
- error send;
- `sessionArchived`;
- `nextCursor` presente;
- `nextCursor` null.

### Tests futuros

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

2B-V-K sigue bloqueado hasta cerrar J2. Después de J2 se decidirá si conviene
integrar el panel nuevo en chat actual, adaptar el chat heredado, reemplazar el
chat heredado o mantener ambos separados temporalmente.

## Resultado de implementación 2B-V-J2 — host/demo aislado del panel messages

Fecha: 2026-06-21.

2B-V-J2 queda implementado como host dev/test aislado. Desde la frontera
backend/catálogo/sesiones, el host mantiene la separación: no conoce catálogo
interno, no conoce `specialist_id`, no decide ownership, no toca rutas reales,
no importa Supabase/HTTP/Dio, no llama Edge Functions y no se conecta al chat
heredado.

### Archivos relevantes

```text
lib/features/chat_messages/presentation/dev/own_chat_messages_panel_dev_host.dart
test/features/chat_messages/presentation/own_chat_messages_panel_dev_host_test.dart
test/architecture/own_chat_messages_contract_test.dart
```

### Decisiones confirmadas

- El host se llama `OwnChatMessagesPanelDevHost`.
- Es dev/test, no pantalla productiva.
- No crea ruta real.
- No toca navegación real.
- No toca routing productivo.
- No conecta chat heredado.
- Usa providers overrideados.
- Usa datos fake locales.
- Simula envío solo con `content`.
- Simula paginación y errores controlados.

### Estados y fixtures

- mensajes fake `user`, `assistant`, `system` y `tool`;
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
- cursor presente;
- cursor null;
- sending;
- paginating.

### Evidencia

- Tests específicos `chat_messages` + arquitectura: 85/85.
- Suite completa Flutter: 168 passed, 2 skipped.
- `build_runner`: 0 outputs written.
- `flutter analyze --no-fatal-infos`: PASS con 48 infos preexistentes.

### Fuera de alcance

No se implementa integración K, ruta real, navegación real, sustitución del
chat heredado, remoto, producción, Supabase real, auth real, datos reales, IA,
Stasis Engine, MCP, streaming, attachments ni procesamiento de archivos.

### Siguiente gate

Tras J2 debe decidirse por separado si conviene integrar el panel nuevo en el
chat actual, adaptar el chat heredado, reemplazarlo, mantener ambos separados o
cerrar el bloque messages.

## Cierre formal 2B-V-J2 y auditoría 2B-V-K0 — frontera con chat actual

Fecha: 2026-06-21.

2B-V-J2 queda cerrado formalmente. `OwnChatMessagesPanelDevHost` se acepta como
host dev/test aislado: no tiene ruta real, no toca navegación real, no toca
routing productivo, no toca chat heredado, no usa Supabase, no usa HTTP/Dio, no
usa backend real, no usa auth real, no usa remoto, no usa producción y no usa
datos reales.

### Evidencia de no modificación del chat actual

Comprobación ejecutada:

```text
git diff --name-only -- lib/features/chat lib/core/config/routes.dart lib/app.dart lib/main.dart
```

Resultado: sin salida. No hay cambios en el diff actual sobre el chat heredado,
rutas principales ni arranque de app.

### Archivos reales inspeccionados

```text
lib/features/chat/presentation/pages/chat_page.dart
lib/features/chat/presentation/pages/agent_chat_wrapper.dart
lib/features/chat/presentation/viewmodels/chat_providers.dart
lib/features/chat/presentation/viewmodels/chat_controller.dart
lib/features/chat/presentation/widgets/chat_input.dart
lib/features/chat/presentation/widgets/message_bubble.dart
lib/features/chat/data/datasources/supabase_chat_datasource.dart
lib/features/chat/data/repositories/chat_repository_impl.dart
lib/features/chat/data/repositories/demo_chat_repository.dart
lib/features/chat/domain/entities/chat_session_entity.dart
lib/features/chat/domain/entities/message_entity.dart
lib/core/config/routes.dart
lib/features/orchestrator/presentation/pages/orchestrator_chat_page.dart
lib/features/orchestrator/presentation/pages/orchestrator_page.dart
```

### Hallazgos de frontera

- `routes.dart` expone rutas reales `/chat/:id` y `/orchestrator/chat`.
- `ChatPage` usa `activeChatSessionProvider(widget.agentId)` y
  `chatMessagesStreamProvider(sessionId)`.
- `AgentChatWrapper` y `OrchestratorChatPage` resuelven agentes mediante
  `agentByIdProvider`.
- `chat_providers.dart` crea `SupabaseChatDataSource` con
  `Supabase.instance.client` cuando el entorno no es demo.
- `supabase_chat_datasource.dart` hace `insert` directo en `chat_sessions` y
  `messages`, escucha `messages.stream()` y llama a RPC heredada
  `increment_message_count`.
- `ChatController` envía `role: 'user'` desde Flutter.
- `MessageEntity` heredado expone `sessionId`, `role` y `attachments`.
- `ChatSessionEntity` heredado expone `userId` y `specialistId`.
- `ChatInput` conserva attachments mock y `MessageBubble` conserva
  `chief_intervention`.

### Riesgo para catálogo y frontera backend

La integración directa del panel nuevo en el chat actual es bloqueante mientras
el chat heredado conserve Supabase directo, entidades con IDs internos, `role`
viajando por contrato Flutter y rutas reales sin adapter ni rollback. Cualquier
paso posterior debe impedir que el catálogo sanitizado y los contratos nuevos
se contaminen con `specialist_id`, `user_id`, prompts, metadatos internos,
attachments o permisos heredados.

### Recomendación

Preparar documentalmente:

```text
2B-V-K1 — plan exacto de adaptación segura del chat actual
```

K1 debe elegir con evidencia entre:

- integrar `OwnChatMessagesPanel` dentro del chat actual;
- adaptar el chat actual para consumir providers nuevos;
- reemplazar gradualmente el chat heredado;
- mantener ambos separados temporalmente;
- cerrar el bloque messages sin integrar.

No se recomienda implementar K directamente. La opción más prudente tras K0 es
mantener ambos flujos separados hasta que K1 defina adapter, tests y rollback.

### Criterios mínimos antes de integración real

- No Supabase directo desde UI.
- No HTTP directo desde UI.
- No IDs internos ni campos de autoridad en contratos públicos.
- No `service_role`, JWT ni tokens en UI.
- No mezcla silenciosa demo/backend real.
- No ruptura de rutas reales sin alternativa y rollback.
- Tests de widget, providers, rutas y arquitectura.

### Fuera de alcance

K0 no modifica chat heredado, navegación, rutas, providers productivos,
Supabase, Edge Functions, migraciones, CI, IA, Stasis Engine, MCP, streaming,
adjuntos ni datos reales.

## Cierre formal 2B-V-K0 y plan 2B-V-K1 — frontera segura con chat actual

Fecha: 2026-06-26.

2B-V-K0 queda cerrado formalmente. 2B-V-K1 queda preparado como plan exacto
documental, sin implementación. Desde la perspectiva de catálogo sanitizado y
frontera backend, K1 establece una regla de bloqueo: el flujo nuevo no puede
conservar `SupabaseChatDataSource` ni mantener `role` enviado desde Flutter.

### Hallazgos heredados confirmados

- `chat_providers.dart` crea `SupabaseChatDataSource` con
  `Supabase.instance.client`.
- `supabase_chat_datasource.dart` escribe directamente en `chat_sessions` y
  `messages`.
- `ChatController` envía `role: 'user'` desde Flutter.
- `MessageEntity` y `ChatSessionEntity` heredados exponen `sessionId`,
  `userId`, `specialistId`, `role` y `attachments`.
- Rutas reales existentes: `/chat/:id` y `/orchestrator/chat`.

### Decisión de frontera

K1 no recomienda adaptar el chat actual manteniendo datasource, controller o
contratos heredados peligrosos. Si una implementación futura necesita conservar
`SupabaseChatDataSource`, `ChatController.sendMessage(role: 'user')`,
`ChatRepository.sendMessage(role)` o entidades heredadas como contrato público,
esa implementación debe rechazarse o reconducirse a reemplazo gradual.

### Estrategia recomendada

Estrategia preferida: **panel nuevo dentro de shell heredado limpio**.

Condición: el shell solo puede conservar estructura visual o navegación
envolvente si no importa Supabase, no llama providers heredados peligrosos, no
envía `role`, no expone IDs internos y no toca rutas reales sin aprobación.

Si esa condición no se puede cumplir, la estrategia recomendada pasa a ser:

```text
reemplazo gradual del chat heredado
```

### Adapters permitidos conceptualmente

- `LegacyChatRouteParamsAdapter`;
- `ChatSessionSelectionAdapter`;
- `OwnMessagesPanelHostAdapter`.

Estos adapters no pueden llamar Supabase, escribir en base de datos, enviar
`role`, exponer `userId`/`specialistId`, conocer `service_role`/JWT ni mezclar
demo/backend real.

### Criterios para K2

Antes de implementar K2 debe aprobarse estrategia, archivos exactos, rollback,
tests y riesgos. K2 no puede autorizar Supabase directo, writes directos desde
Flutter, `role` desde UI, IDs internos públicos, metadata/attachments heredados
ni rutas modificadas sin aprobación explícita.

### Fuera de alcance

K1 no modifica código, chat heredado, rutas, navegación, providers productivos,
Supabase, Edge Functions, migraciones, CI, remoto, producción, IA, Stasis
Engine, MCP, streaming, adjuntos ni datos reales.

## Resultado de implementación 2B-V-K2 — shell seguro sin contaminación heredada

Fecha: 2026-06-26.

K2 queda implementado como shell seguro dentro de `chat_messages`. La
implementación confirma la frontera acordada: el flujo nuevo no conserva
`SupabaseChatDataSource`, no usa `ChatController` heredado, no importa
`chat_providers.dart`, no envía `role` desde Flutter y no expone `userId` ni
`specialistId`.

### Archivos relevantes

```text
lib/features/chat_messages/presentation/shell/own_chat_messages_safe_shell.dart
lib/features/chat_messages/presentation/shell/own_chat_messages_route_params_adapter.dart
test/features/chat_messages/presentation/own_chat_messages_safe_shell_test.dart
test/architecture/own_chat_messages_contract_test.dart
```

### Decisión de frontera

`OwnChatMessagesSafeShell` monta `OwnChatMessagesPanel` con un `sessionId` ya
seguro. `OwnChatMessagesRouteParamsAdapter` solo acepta un parámetro explícito
`sessionId`; no acepta `id` heredado de `/chat/:id`, no transforma agente en
sesión y no decide ownership.

### Evidencia de aislamiento

El gate arquitectónico de shell bloquea:

- `Supabase.instance.client`;
- `SupabaseChatDataSource`;
- `ChatController`;
- `chat_providers`;
- `supabase_flutter`;
- HTTP/Dio;
- Edge Function paths;
- `role: 'user'`;
- `userId` y `specialistId`;
- JWT, `service_role` y tokens;
- writes directos a `chat_sessions` o `messages`;
- attachments, metadata, Stasis Engine, MCP y streaming.

### Rutas intactas

Comando ejecutado:

```text
git diff --name-only -- lib/features/chat lib/core/config/routes.dart lib/app.dart lib/main.dart
```

Resultado: sin salida. No se modificó chat heredado, rutas, `app.dart` ni
`main.dart`.

### Verificación

- Tests específicos `chat_messages` + arquitectura: 91/91.
- Suite Flutter completa: 174 passed, 2 skipped.
- `build_runner`: 0 outputs written.
- `flutter analyze --no-fatal-infos`: PASS con 48 infos preexistentes.

### Fuera de alcance

K2 no activa rutas reales, navegación productiva, Supabase real, remoto,
producción, IA, Stasis Engine, MCP, streaming, adjuntos ni datos reales.

## Cierre formal 2B-V-K2 y plan exacto 2B-V-K3 — wiring controlado con rutas reales

Fecha: 2026-06-26.

2B-V-K2 queda cerrado formalmente. K3 se prepara como plan documental para
decidir si el shell seguro puede conectarse a rutas reales o si debe seguir
aislado. No modifica código, rutas, navegación ni chat heredado.

### Rutas y flujo heredado inspeccionados

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

Estado verificado:

- `/chat/:id` extrae `state.pathParameters['id']` y lo pasa a
  `AgentChatWrapper(agentId: id)`.
- `AgentChatWrapper` resuelve catálogo mediante `agentByIdProvider(agentId)` y
  construye `ChatPage(agentId: agent.id, ...)`.
- `ChatPage` usa `activeChatSessionProvider(widget.agentId)`.
- `activeChatSessionProvider` crea/obtiene sesión con `userId` y
  `specialistId`.
- `chat_providers.dart` conserva `SupabaseChatDataSource(Supabase.instance.client)`
  en modo no demo.
- `ChatController` heredado conserva envío de `role: 'user'`.
- `/orchestrator/chat` monta `OrchestratorChatPage`, que termina construyendo
  `ChatPage` para `stasis_core`.
- Páginas de Salud, Nutrición y Entrenamiento navegan a `/chat/${agent.id}`.

### Decisión sobre `:id`

`/chat/:id` no queda aprobado como punto de conexión para el shell seguro. La
evidencia indica que `:id` es un ID heredado de agente/especialista, no un
`sessionId` seguro. El adapter K2 acepta explícitamente `sessionId` y rechaza
`id`; por tanto, conectar `/chat/:id` ahora rompería la frontera limpia.

Regla K3:

```text
No tratar id heredado como sessionId seguro sin rediseño y aprobación expresa
del contrato de ruta.
```

### Opciones de wiring

| Opción | Evaluación | Decisión K3 |
| --- | --- | --- |
| Conectar `/chat/:id` | Bloqueante: `:id` es `agentId`, arrastra wrapper/chat/providers heredados y `role`. | No aprobar. |
| Conectar `/orchestrator/chat` | Riesgo alto: mezcla Stasis visible con chat heredado y posible expectativa de IA. | No aprobar. |
| Crear ruta dev-only con `sessionId` explícito | Opción segura para prueba manual si se blinda fuera de producto. | Posible K4, pendiente de aprobación. |
| Mantener shell aislado | Cero contaminación de rutas/producto. | Recomendación inmediata. |
| Reemplazo gradual posterior | Requiere contrato nuevo de sesión/ruta y pruebas de navegación. | Futuro. |

### Criterios mínimos para K4

Antes de implementar wiring debe aprobarse:

- ruta exacta;
- contrato de parámetros;
- uso de `sessionId` explícito si se conecta el shell seguro;
- archivos exactos;
- rollback;
- tests de rutas;
- prueba de que no se importa `SupabaseChatDataSource`, `ChatController`,
  `chat_providers.dart`, Supabase ni HTTP directo;
- prueba de que la UI no envía `role`, `userId` ni `specialistId`;
- decisión explícita sobre si `/chat/:id` queda intacta, reemplazada o
  deprecada.

### Fuera de alcance

K3 no implementa rutas, navegación, providers reales, conexión a Supabase,
remoto, producción, auth real, datos reales, IA, Stasis Engine, MCP, streaming
ni adjuntos.

## Cierre formal 2B-V-K3 y plan exacto 2B-V-K4 — ruta dev-only segura con sessionId explícito

Fecha: 2026-06-26.

2B-V-K3 queda cerrado formalmente. La decisión bloqueante para frontera
backend/catálogo es que `/chat/:id` no puede conectarse a
`OwnChatMessagesSafeShell`: el `:id` real está verificado como `agentId`
heredado, no como `sessionId` seguro.

Evidencia aprobada:

```text
/chat/:id monta AgentChatWrapper(agentId: id)
```

Reglas aprobadas:

- no tratar `id` heredado como `sessionId`;
- no conectar `/chat/:id` al shell seguro;
- no conectar `/orchestrator/chat` al shell seguro todavía;
- no inferir sesión desde agente;
- no crear sesión desde esta ruta;
- no listar sesiones desde esta ruta.

### Contrato dev-only propuesto

Ruta conceptual recomendada:

```text
/dev/chat-messages/session/:sessionId
```

La ruta futura, si se implementa en K5, solo puede montar:

```text
OwnChatMessagesSafeShell(sessionId: sessionId)
```

o equivalente aprobado. El parámetro debe llamarse exactamente `sessionId`.
Queda prohibido usar `id`, `agentId`, `specialistId`, `userId`, catálogo o
metadata como fuente de sesión.

### Protección dev-only

K5 deberá probar que la ruta dev-only queda fuera de producción mediante:

- `kDebugMode` o guard debug-only equivalente;
- feature flag local no remoto;
- bloqueo o exclusión verificable fuera de desarrollo;
- indicador visible de entorno;
- tests de producción/no-debug;
- cero remoto y cero datos reales.

### Opciones comparadas

| Opción | Ventajas | Riesgos | Recomendación |
| --- | --- | --- | --- |
| A — Ruta dev-only en router existente | Prueba manual real. | Toca routing; puede colarse en producción. | Solo con gates estrictos y tests. |
| B — Host en test/widget/dev harness sin router | No toca routing; menor riesgo. | Menos parecido al flujo real. | Recomendación inicial. |
| C — Entrada temporal local con feature flag | Flexible. | Activación accidental. | Solo con flag local y debug-only. |

### Criterios mínimos para K5

Antes de implementar:

- ruta exacta aprobada;
- archivo exacto aprobado;
- guard dev-only aprobado;
- rollback aprobado;
- tests de ruta aprobados;
- producción no expone la ruta;
- `/chat/:id` intacta;
- `/orchestrator/chat` intacta;
- `agentId` nunca se usa como `sessionId`;
- el parámetro es `sessionId`, nunca `id`;
- no hay imports de Supabase/HTTP/Dio;
- no hay imports de `SupabaseChatDataSource`, `ChatController` heredado ni
  `chat_providers.dart`;
- UI no envía `role`, `userId`, `specialistId`, JWT ni `service_role`.

### Rollback futuro

Si K5 falla, el rollback esperado es retirar la ruta dev-only y sus tests,
mantener el shell seguro, mantener chat heredado intacto y confirmar que
`/chat/:id` y `/orchestrator/chat` no cambiaron.

### Relación con messages

Tras K4 se decidirá si implementar K5 dev-only, cerrar el bloque messages o
volver a otra área. K4 no desbloquea navegación productiva ni backend real.

### Fuera de alcance

K4 no implementa rutas, navegación, chat heredado, providers productivos,
Supabase, Edge Functions, migraciones, CI, remoto, producción, auth real, datos
reales, IA, Stasis Engine, MCP, streaming ni adjuntos.

## Cierre formal 2B-V-K4 y preparación 2B-V-L — bloque messages local-safe completo

Fecha: 2026-06-26.

2B-V-K4 queda cerrado formalmente. No se implementó ruta dev-only, no se tocó
navegación, no se conectó nada al shell, no se modificó chat heredado, no se
tocaron rutas, tests, `pubspec.yaml`, Supabase, Edge Functions, migraciones ni
CI.

Decisión firme:

```text
/chat/:id no puede conectarse a OwnChatMessagesSafeShell porque :id es
agentId heredado, no sessionId seguro.
```

Evidencia:

```text
/chat/:id monta AgentChatWrapper(agentId: id)
```

Consecuencias:

- no conectar `/chat/:id`;
- no conectar `/orchestrator/chat`;
- no interpretar `agentId` como `sessionId`;
- no autorizar K5 todavía.

### Estado completo de 2B-V

Quedan cerrados o completados localmente:

- 2B-V-A — `messages` deny-all + constraints;
- 2B-V-B — fixtures transaccionales;
- 2B-V-C1 — RPC transaccional `send_user_message_core`;
- 2B-V-C2 — Edge Function local `send-user-message`;
- 2B-V-D — Edge Function local `list-session-messages`;
- 2B-V-E — contrato Flutter desconectado;
- 2B-V-F — datasource Flutter HTTP local;
- 2B-V-G — integración HTTP local;
- 2B-V-H — cierre documental del bloque;
- 2B-V-I1 — application controller/state sin providers reales;
- 2B-V-I2 — providers Riverpod sin UI;
- 2B-V-J — UI mínima aislada;
- 2B-V-J2 — host/demo aislado;
- 2B-V-K0 — auditoría del chat actual;
- 2B-V-K1 — plan de adaptación segura;
- 2B-V-K2 — shell seguro;
- 2B-V-K3 — plan wiring rutas reales;
- 2B-V-K4 — plan ruta dev-only con `sessionId` explícito.

### Capacidades local-safe disponibles

El bloque `messages` queda completo solo como local-safe/dev-test:

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
- auditoría de chat heredado;
- decisión firme de no conectar `/chat/:id`.

No queda habilitado producto real, remoto ni datos reales.

### Bloqueos vigentes

Permanecen bloqueados:

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

Antes de tocar rutas reales:

- `sessionId` explícito;
- no `agentId` como `sessionId`;
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

Antes de remoto o backend real:

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

Requieren paquete separado:

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

Cerrar temporalmente `messages` como bloque local-safe completo. No tocar
routing hasta una decisión posterior.

Posibles siguientes rutas:

- volver a otro bloque técnico pendiente;
- preparar bloque de `chat_sessions` UI/routing seguro;
- preparar gates de auth/session selection;
- preparar futuro routing dev-only con `sessionId` explícito;
- pasar a otra área de Stasisly.

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

2B-V-A hasta 2B-V-K4 quedan documentados como completados/cerrados según su
alcance. El bloque `messages` queda disponible solo local/dev-test con tabla
endurecida, RPC transaccional local, Edge Functions locales
`send-user-message` y `list-session-messages`, contrato Flutter seguro,
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

Motivo: antes de tocar rutas de mensajes hay que resolver selección de sesión,
entrada segura a sesión, separación entre `agentId` y `sessionId`, no reactivar
chat heredado, evitar Supabase directo desde Flutter y preservar rollback.

Alternativas válidas:

- auth/session selection seguro;
- otro bloque técnico pendiente;
- otra área de Stasisly.

## Plan exacto 2B-W — chat_sessions UI/routing seguro

Fecha: 2026-06-26.

2B-W se inicia como análisis y planificación documental. El objetivo es
resolver cómo se selecciona, muestra y entra en una `chat_session` sin
confundir `agentId` con `sessionId`.

No implementa código, rutas, navegación, chat heredado, Supabase, Edge
Functions, migraciones, CI, remoto, producción, IA, Stasis Engine, MCP,
streaming ni adjuntos.

### Estado heredado de messages

`messages` queda cerrado como local-safe completo, dev/test-safe, no
productivo, no remoto, sin datos reales y sin routing productivo. `messages`
requiere un `sessionId` explícito y seguro antes de cargar o enviar mensajes.

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

Inspección de solo lectura.

### Estado actual de chat_sessions

Existente y verificado:

- entidad pública `OwnChatSession` con `sessionId`;
- resumen público `SelectableSpecialistSummary` sin IDs internos;
- repositorio `OwnChatSessionsRepository`;
- operaciones create/list/archive;
- datasource HTTP local con host policy local, token provider y transporte
  inyectable;
- repositorios demo, backendBlocked y validating;
- tests unitarios, de arquitectura e integración local;
- Edge Functions locales `create-own-chat-session`,
  `list-own-chat-sessions` y `archive-own-chat-session`;
- migración `00005_harden_chat_sessions_deny_all.sql`.

Pendiente:

- UI propia de sesiones;
- controller/state UI-safe;
- providers de sesión orientados a pantalla/routing;
- routing seguro por `sessionId`;
- unión segura con `OwnChatMessagesSafeShell`;
- decisión productiva/remota.

### Capacidades ya cerradas de chat_sessions

Quedan documentadas como cerradas localmente:

- tabla `chat_sessions` endurecida/deny-all;
- fixtures locales transaccionales;
- Edge Function local `createOwnChatSession`;
- Edge Function local `listOwnChatSessions`;
- Edge Function local `archiveOwnChatSession`;
- contrato Flutter desconectado;
- datasource HTTP local;
- integración HTTP local.

No desbloquean producto real, remoto, datos reales ni routing productivo.

### Brecha agentId vs sessionId

```text
agentId != sessionId
```

El catálogo y las rutas heredadas trabajan con agente/especialista. Mensajes
trabaja con sesión. El flujo seguro debe ser:

```text
selectableSpecialistId -> crear/seleccionar chat_session -> sessionId -> messages
```

Nunca:

```text
agentId -> messages
```

### Opciones de flujo seguro

| Opción | Descripción | Ventajas | Riesgos | Tests necesarios |
| --- | --- | --- | --- | --- |
| A — Selector/listado de sesiones primero | Entrar desde lista de sesiones propias. | Evita confundir agente y sesión. | Requiere UI/listado. | listado, selección, cursor, estado vacío, sesión archivada. |
| B — Desde agente se crea/recupera sesión segura | El agente produce una sesión antes de mensajes. | Mejor UX desde catálogo. | Riesgo de filtrar `agentId` al flujo de mensajes. | create con `selectableSpecialistId`, entrada posterior por `sessionId`. |
| C — Ruta dev-only con `sessionId` explícito | Solo desarrollo. | Valida shell sin producto. | No resuelve UX productiva. | debug-only, producción bloqueada. |
| D — Mantener messages aislado | No tocar routing. | Riesgo cero inmediato. | No avanza integración. | Sin tests nuevos. |

### Recomendación

Primero diseñar `chat_sessions` UI/routing seguro antes de tocar `/chat/:id`.
La preferencia inicial es Opción A o B, siempre con `sessionId` explícito antes
de entrar en `messages`.

### Gates para implementación futura

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

### Paquetes futuros propuestos

- 2B-W-A — auditoría específica de `chat_sessions` UI/routing seguro;
- 2B-W-B — plan de selector/listado seguro de sesiones;
- 2B-W-C — controller/providers `chat_sessions` UI-safe;
- 2B-W-D — UI mínima aislada `chat_sessions`;
- 2B-W-E — routing seguro por `sessionId` explícito.

## Auditoría específica 2B-W-A — chat_sessions UI/routing seguro

Fecha: 2026-06-26.

2B-W queda aprobado como plan inicial. 2B-W-A audita específicamente la frontera
entre catálogo, sesiones y futura entrada a mensajes.

No implementa código, UI, providers, controllers, rutas, navegación, chat
heredado, Flutter app, Supabase, Edge Functions, migraciones, CI, remoto,
producción, IA, Stasis Engine, MCP, streaming ni adjuntos.

### Hallazgo principal

`createOwnChatSession` ya trabaja con un identificador público seguro de
catálogo:

```text
selectableSpecialistId -> specialist_catalog.id
```

No recibe `agentId`, no recibe `specialistId` interno, no recibe `userId`, no
recibe `role`, no recibe timestamps ni contadores desde Flutter.

La función resuelve internamente:

```text
specialist_catalog.id -> specialist_catalog.specialist_id -> specialists.id
```

y crea la sesión con `user_id` derivado del JWT local y `specialist_id` interno
solo en backend local/controlado.

Respuesta pública verificada:

```text
session.sessionId
session.selectableSpecialist.id
session.selectableSpecialist.displayName
session.selectableSpecialist.area
session.startedAt
session.lastMessageAt
session.status
session.messageCount
```

No devuelve `user_id`, `specialist_id`, prompts, permisos ni campos internos.

### Estructura auditada

| Pieza | Estado | Reutilización |
| --- | --- | --- |
| Entidades públicas de sesión | Existente y verificado | Reutilizable. |
| Repository contract | Existente y verificado | Reutilizable. |
| Datasource HTTP local | Existente local | Reutilizable solo local/dev. |
| Host policy/token/transport | Existente local | Reutilizable con gates. |
| Demo/backendBlocked/validating repos | Existente | Reutilizable según modo. |
| Controllers UI-safe | No existen | Paquete futuro. |
| Providers UI-safe | No existen | Paquete futuro. |
| UI/listado/selector | No existe | Paquete futuro. |
| Routing seguro por `sessionId` | No existe | Routing al final. |

### Backend local auditado

- `create-own-chat-session`: acepta solo `selectableSpecialistId`, devuelve
  `sessionId` explícito y crea dos sesiones distintas en dos llamadas válidas.
- `list-own-chat-sessions`: recibe `status`, `limit`, `cursor`; devuelve
  sesiones propias con `sessionId` y catálogo sanitizado.
- `archive-own-chat-session`: recibe solo `sessionId`, deriva owner y archiva
  sesión propia activa.
- `00005_harden_chat_sessions_deny_all.sql`: mantiene tabla bajo deny-all
  local previo a funciones controladas.

### Contrato Flutter auditado

Flutter seguro actual:

- create envía solo `selectableSpecialistId`;
- list envía solo filtros públicos;
- archive envía solo `sessionId`;
- contrato público no contiene `userId`, `specialistId`, `role`, owner,
  permisos ni campos internos;
- respuestas rotas pasan a `contractViolation`, no a demo.

### Relación agentId / specialistId / sessionId

```text
agentId != selectableSpecialistId != specialistId interno != sessionId
```

- `agentId`: heredado de rutas/pantallas antiguas; no sirve para mensajes.
- `selectableSpecialistId`: ID público de catálogo sanitizado; válido para
  pedir creación de sesión.
- `specialistId` interno: backend-only; no expuesto a Flutter.
- `sessionId`: ID seguro y explícito para entrar a mensajes.

Regla firme:

```text
agentId nunca puede tratarse como sessionId.
```

### Relación con messages

Flujo permitido:

```text
chat_sessions crea/lista/selecciona sessionId
messages recibe sessionId explícito
OwnChatMessagesSafeShell solo acepta sessionId
OwnChatMessagesRouteParamsAdapter rechaza id heredado
```

### Brechas UI-safe

Pendiente:

- controller/state `chat_sessions` UI-safe;
- providers Riverpod `chat_sessions` UI-safe;
- UI mínima aislada de sesiones;
- host/dev test de sesiones;
- shell seguro de sesiones;
- routing seguro por `sessionId`;
- selector/listado de sesiones;
- crear sesión desde especialista/agente sin filtrar `agentId`;
- archivar sesión desde UI.

### Riesgos

| Riesgo | Severidad | Mitigación |
| --- | --- | --- |
| Confundir `agentId` con `sessionId` | Bloqueante | Gates y tests antes de UI/routing. |
| Exponer `specialist_id` interno | Alto | Mantener `selectableSpecialistId` público. |
| Supabase directo desde Flutter | Bloqueante | Prohibido por arquitectura. |
| Reactivar chat heredado | Alto | No usar `ChatController` ni `SupabaseChatDataSource`. |
| Mezcla demo/backend real | Alto | Repos separados y errores visibles. |
| Romper `messages` local-safe | Medio-alto | Entrar solo por `sessionId`. |

### Recomendación

Siguiente paquete recomendado:

```text
2B-W-B — controller/providers chat_sessions UI-safe
```

Si se quiere granularidad máxima, dividirlo en:

```text
2B-W-B — controller/state chat_sessions UI-safe
2B-W-C — providers chat_sessions UI-safe
```

Routing por `sessionId` debe quedar para el final, después de controller,
providers y UI/listado aislado.

## Implementación 2B-W-B — controller/state chat_sessions UI-safe

### Estado

2B-W-A queda cerrado formalmente. 2B-W-B queda implementado y verificado como
controller/state puro para `chat_sessions`.

No autoriza providers, UI, navegación, routing productivo, chat heredado,
Supabase remoto, datos reales, IA, Stasis Engine, MCP, streaming ni adjuntos.

### Decisión implementada

La capa de aplicación creada mantiene intacta la frontera del catálogo
sanitizado:

- `createSession` usa exclusivamente `selectableSpecialistId`;
- no acepta `agentId`;
- no expone ni consume `specialistId` interno;
- conserva el `sessionId` explícito devuelto por la operación de creación;
- usa `selectedSessionId` como único valor preparado para entrar a mensajes;
- no importa `messages`, chat heredado, Supabase, HTTP, UI ni providers.

### Regla de identificadores

```text
agentId != selectableSpecialistId != specialistId interno != sessionId
```

El controller/state queda diseñado para que:

- `selectableSpecialistId` sea entrada pública de catálogo para crear sesión;
- `sessionId` sea salida explícita y seleccionable;
- `agentId` heredado no pueda transformarse en `sessionId`;
- `specialistId` interno siga siendo backend-only.

### Relación con la frontera backend

2B-W-B no cambia el contrato backend, no crea funciones, no conecta remoto y
no modifica Supabase. Solo consume el repositorio `chat_sessions` ya aprobado
por la frontera Flutter/backend local-safe.

Errores reales permanecen visibles:

- no se convierten en demo;
- `backendBlocked` queda explícito;
- una respuesta demo solo puede llegar desde repositorio demo explícito;
- errores de refresh preservan el listado confirmado existente.

### Evidencia

Los tests validan que dos conceptos no se mezclan:

- entrada de creación: `selectableSpecialistId`;
- salida usable para mensajes: `sessionId` explícito.

Los tests arquitectónicos bloquean Flutter widgets, `BuildContext`, Riverpod,
Provider, Supabase, HTTP, Edge Functions, chat heredado, `messages`, `userId`,
`specialistId`, `agentId`, `role`, permisos, Stasis Engine, MCP y streaming en
la capa `application`.

### Siguiente paso recomendado

Preparar 2B-W-C como providers `chat_sessions` UI-safe, sin UI ni routing. La
entrada real a mensajes debe seguir esperando una selección segura por
`sessionId` y no puede reutilizar `/chat/:id`.

## Implementación 2B-W-C — providers chat_sessions UI-safe

### Estado

2B-W-B queda cerrado formalmente. 2B-W-C queda implementado y verificado como
capa de providers Riverpod UI-safe para `chat_sessions`.

No autoriza UI, widgets, rutas, navegación, `/chat/:id`,
`/orchestrator/chat`, chat heredado, `chat_messages`, Supabase remoto, HTTP
directo desde providers, datos reales, IA, Stasis Engine, MCP, streaming ni
adjuntos.

### Frontera de catálogo preservada

La capa providers conserva la frontera del catálogo sanitizado:

- `createSession` expone solo `selectableSpecialistId`;
- ningún provider acepta `agentId`;
- ningún provider expone `specialistId` interno;
- ningún provider expone `userId`, `role`, permisos o autoridad;
- la salida segura para mensajes sigue siendo `selectedSessionId`, que deriva
  de `OwnChatSession.sessionId`.

### Wiring implementado

Se crean providers para:

- repositorio principal overrideable;
- repositorio demo explícito;
- repositorio backendBlocked explícito;
- controller/notifier;
- estado observable.

Backend real y producción permanecen bloqueados mediante
`BackendBlockedOwnChatSessionsRepository`. Demo solo se activa en modo demo
explícito o mediante override/test explícito.

### Relación con messages

Los providers de `chat_sessions` no importan `chat_messages`, no montan
`OwnChatMessagesSafeShell`, no montan `OwnChatMessagesPanel` y no conectan
routing.

El flujo futuro sigue siendo:

```text
selectableSpecialistId -> createSession -> sessionId explícito -> messages
```

### Evidencia

Los tests con `ProviderContainer` cubren override de repositorio, demo,
backendBlocked, `loadInitial`, `refresh`, `createSession`, `archiveSession`,
`selectSession`, `clearSelection`, `clear`, errores visibles, preservación de
listado y rechazo de `agentId` heredado en selección/archivado.

Los tests arquitectónicos bloquean Supabase, HTTP, Edge Function paths,
`chat_messages`, chat heredado, ids internos, roles/permisos, Stasis Engine,
MCP y streaming en providers.

### Siguiente paso recomendado

Preparar 2B-W-D como UI mínima aislada de `chat_sessions`, manteniendo routing
real y `/chat/:id` bloqueados hasta una aprobación posterior.

## Implementación 2B-W-D — UI mínima aislada chat_sessions

### Estado

2B-W-C queda cerrado formalmente. 2B-W-D queda implementado y verificado como
UI mínima aislada para `chat_sessions`.

No autoriza rutas reales, navegación, `/chat/:id`, `/orchestrator/chat`,
chat heredado, `chat_messages`, `OwnChatMessagesSafeShell`,
`OwnChatMessagesPanel`, Supabase, HTTP directo desde UI, remoto, producción,
datos reales, IA, Stasis Engine, MCP, streaming ni adjuntos.

### Frontera preservada

La UI consume únicamente providers de `chat_sessions`:

```text
ownChatSessionsStateProvider
ownChatSessionsControllerProvider
```

No llama repositorios ni datasources. No conoce URLs, Edge Functions, tokens,
Supabase client ni identidad técnica.

### Relación selectableSpecialistId / sessionId

El flujo UI mínimo queda así:

```text
selectableSpecialistId -> createSession -> sessionId explícito
sessionId -> selectSession/archiveSession
```

La UI no usa `agentId` como entrada, no usa `specialistId` interno, no envía
`userId` y no envía `role`.

### Relación con messages

W-D no integra `messages`. Solo muestra que `selectedSessionId` queda
disponible para un futuro flujo de mensajes. No importa `chat_messages`, no
monta `OwnChatMessagesSafeShell` y no monta `OwnChatMessagesPanel`.

### Evidencia

Los tests de widget cubren:

- loading;
- empty;
- listado;
- sesión seleccionada;
- demo;
- backendBlocked;
- error de listado;
- creación con `selectableSpecialistId`;
- selección con `sessionId`;
- archivado con `sessionId`;
- errores de creación/archivado sin borrar listado confirmado;
- texto informativo de relación futura con mensajes.

Los tests arquitectónicos bloquean en widgets Supabase, HTTP/Dio, Edge paths,
secretos/tokens, chat heredado, `chat_messages`, shells/panels de mensajes,
ids internos, roles/permisos, Stasis Engine, MCP y streaming.

### Siguiente paso recomendado

Preparar un paquete posterior de host/dev aislado o plan de routing seguro por
`sessionId` explícito. `/chat/:id` continúa bloqueada porque es `agentId`
heredado, no `sessionId`.

## Implementación 2B-W-E — host/dev aislado chat_sessions

### Estado

2B-W-D queda cerrado formalmente. 2B-W-E queda implementado y verificado como
host/dev aislado de `chat_sessions`.

No autoriza rutas reales, navegación, `/chat/:id`, `/orchestrator/chat`, chat
heredado, `chat_messages`, `OwnChatMessagesSafeShell`,
`OwnChatMessagesPanel`, Supabase, HTTP/Dio directo, Edge Function paths,
remoto, producción, datos reales, IA, Stasis Engine, MCP, streaming ni
adjuntos.

### Frontera preservada

El host monta `OwnChatSessionsPanel` mediante providers overrideados. No
construye repositorios reales, no construye datasources reales, no conoce URLs,
no invoca funciones backend y no interpreta IDs heredados.

La frontera sigue siendo:

```text
selectableSpecialistId -> createSession -> sessionId explícito
sessionId -> selectSession/archiveSession
```

`agentId` no se interpreta como `sessionId`.

### Datos fake/demo

Los escenarios usan sesiones ficticias, nombres ficticios y UUIDs de prueba.
No usan usuarios reales, especialistas internos reales, secretos, tokens ni
contenido sensible.

### Evidencia

Los tests del host/dev cubren:

- render de `OwnChatSessionsPanel`;
- sesiones fake;
- sesión seleccionada;
- empty;
- loading;
- demo;
- backendBlocked;
- errores de listado, creación y archivado;
- creación con `selectableSpecialistId`;
- selección y archivado con `sessionId`;
- refresh local fake.

El test arquitectónico bloquea en `presentation/dev` Supabase, HTTP/Dio, Edge
paths, secretos/tokens, routing productivo, navegación, chat heredado,
`chat_messages`, shells/panels de mensajes, ids internos, roles/permisos,
Stasis Engine, MCP y streaming.

### Siguiente paso recomendado

Decidir si preparar un shell seguro de `chat_sessions`, un plan de routing por
`sessionId` explícito o un cierre temporal local-safe del bloque. `/chat/:id`
sigue bloqueada porque es `agentId` heredado, no `sessionId`.

## Implementación 2B-W-F — shell seguro chat_sessions

### Estado

2B-W-E queda cerrado formalmente. 2B-W-F queda implementado y verificado como
shell seguro de presentación para `chat_sessions`.

No autoriza rutas reales, navegación, `/chat/:id`, `/orchestrator/chat`, chat
heredado, `chat_messages`, `OwnChatMessagesSafeShell`,
`OwnChatMessagesPanel`, Supabase, HTTP/Dio directo, Edge Function paths,
remoto, producción, datos reales, IA, Stasis Engine, MCP, streaming ni
adjuntos.

### Frontera preservada

El shell monta `OwnChatSessionsPanel` y acepta opcionalmente contexto seguro
validado, pero no crea rutas, no navega, no llama backend y no transforma IDs
heredados.

La frontera sigue siendo:

```text
selectableSpecialistId -> createSession -> sessionId
sessionId -> selectedSessionId seguro
```

### Adapter seguro

El adapter es allowlist-only y lee exclusivamente:

```text
sessionId
selectableSpecialistId
```

No acepta claves ambiguas ni heredadas como sustituto de sesión. Si no recibe
entrada segura válida, devuelve `null`.

### Relación con messages

W-F no integra `messages`. No importa `chat_messages`, no monta
`OwnChatMessagesSafeShell` y no monta `OwnChatMessagesPanel`.

### Evidencia

Los tests cubren:

- render de `OwnChatSessionsPanel` dentro del shell;
- estado inicial;
- backendBlocked desde provider real bloqueado;
- demo explícito mediante override;
- operaciones del panel sin romper la frontera;
- aceptación de `sessionId`;
- aceptación de `selectableSpecialistId`;
- rechazo de entradas vacías o no permitidas;
- ausencia de transformación de identificadores heredados.

El test arquitectónico bloquea en `presentation/shell` Supabase, HTTP/Dio, Edge
paths, secretos/tokens, routing productivo, navegación, chat heredado,
`chat_messages`, shells/panels de mensajes, ids internos, roles/permisos,
Stasis Engine, MCP y streaming.

### Siguiente paso recomendado

Decidir si preparar un plan de routing por `sessionId` explícito o cerrar
temporalmente `chat_sessions` como bloque local-safe. `/chat/:id` sigue
bloqueada porque es `agentId` heredado, no `sessionId`.

## Cierre 2B-W-G — chat_sessions local-safe completo

### Estado

2B-W-F queda cerrado formalmente. 2B-W-G registra el cierre temporal del bloque
`chat_sessions` como local-safe completo y dev/test-safe.

No queda productivo, no queda remoto, no usa datos reales y no autoriza routing
por `sessionId`. Este cierre es documental y no modifica código, rutas,
navegación, chat heredado, `chat_messages`, backend remoto ni producción.

### Frontera de catálogo preservada

La frontera aprobada sigue siendo:

```text
selectableSpecialistId -> createSession -> sessionId explícito
sessionId -> selectSession/archiveSession
```

`selectableSpecialistId` es un identificador público seleccionable del catálogo
sanitizado. No es `agentId`, no es `specialist_id` interno y no es `sessionId`.

`agentId` heredado nunca puede tratarse como `sessionId`. Una clave genérica
`id` nunca puede tratarse como `sessionId`.

### Capacidades terminadas

Quedan terminadas dentro de alcance local/dev-test:

- contrato seguro de `chat_sessions`;
- datasource HTTP local auditado;
- integración local auditada;
- controller/state Dart puro;
- providers Riverpod overrideables;
- UI mínima aislada;
- host/dev aislado;
- shell seguro;
- adapter allowlist-only;
- creación por `selectableSpecialistId`;
- selección y archivado por `sessionId`.

### Bloqueos vigentes

Permanecen bloqueados:

- routing por `sessionId`;
- `/chat/:id`;
- `/orchestrator/chat`;
- navegación real o productiva;
- conexión entre `chat_sessions` y `chat_messages`;
- `OwnChatMessagesSafeShell` montado desde `chat_sessions`;
- chat heredado;
- Supabase directo desde Flutter;
- HTTP/Dio directo desde UI/providers;
- remoto, producción y datos reales;
- IA, Stasis Engine, MCP, streaming y adjuntos.

### Gates para futuro routing

Un paquete futuro de routing deberá demostrar:

- aprobación explícita;
- parámetro llamado `sessionId`, nunca `id`;
- rechazo de `agentId` y de identificadores heredados;
- no tocar `/chat/:id` ni `/orchestrator/chat` sin plan propio;
- no importar `chat_messages` desde capas no autorizadas;
- no reactivar chat heredado ni `SupabaseChatDataSource`;
- no enviar `role`, `userId`, `specialistId`, `agentId`, `attachments`,
  metadata interna ni tokens desde UI;
- rollback y tests de arquitectura, widget, contrato y navegación.

### Relación futura con messages

El enlace futuro correcto será:

```text
chat_sessions entrega sessionId explícito
messages recibe sessionId explícito
```

2B-W-G no realiza ese enlace. Cualquier integración entre sesiones y mensajes
requiere paquete separado y aprobación explícita.

### Recomendación

Cerrar temporalmente `chat_sessions` como local-safe completo. El siguiente
trabajo debería ser un plan separado de routing por `sessionId` explícito,
auth/session selection seguro u otro bloque técnico, sin reutilizar
`/chat/:id` mientras represente `agentId`.

## Cierre 2B-X — chat local-safe completo

### Estado

2B-W-G queda aprobado y cerrado formalmente. 2B-X prepara el cierre documental
global del frente chat local-safe, integrando `messages` y `chat_sessions`.

El cierre global queda limitado a:

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

`messages` queda cerrado como local-safe completo. Capacidades cerradas:

- tabla `messages` endurecida;
- RPC transaccional;
- Edge Functions locales `send-user-message` y `list-session-messages`;
- contrato Flutter seguro;
- datasource HTTP local;
- integración local;
- controller/state puro;
- providers UI-safe;
- UI mínima aislada;
- host/dev;
- shell seguro.

No queda autorizado producto remoto, producción, datos reales, rutas
productivas, IA, Stasis Engine, MCP, streaming, adjuntos ni mensajes
assistant/system/tool reales.

### Estado global de chat_sessions

`chat_sessions` queda cerrado como local-safe completo. Capacidades cerradas:

- contrato seguro;
- datasource HTTP local auditado;
- integración local auditada;
- controller/state Dart puro;
- providers UI-safe;
- UI mínima aislada;
- host/dev;
- shell seguro;
- adapter allowlist-only;
- `selectableSpecialistId -> sessionId`;
- selección/archivo por `sessionId`.

No queda autorizado conectar `chat_sessions` con `messages`,
`chat_messages`, rutas reales, navegación productiva, chat heredado, remoto,
producción ni datos reales.

### Decisiones firmes globales

```text
agentId != selectableSpecialistId != specialistId interno != sessionId
/chat/:id es agentId heredado, no sessionId
id heredado no puede tratarse como sessionId
sessionId es la única entrada válida futura para messages
selectableSpecialistId sirve para crear/seleccionar sesión, no para entrar directamente a messages
```

El catálogo sanitizado solo puede entregar identificadores públicos
seleccionables. No autoriza acceso directo a mensajes ni sustituye la sesión.

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

Antes de routing debe existir paquete separado con:

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

Remoto o producción requiere paquete separado con:

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

Siguen fuera de alcance:

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
2B-X solo deberían considerarse, con paquete separado y aprobación explícita:
routing seguro por `sessionId`, auth/session selection seguro, backend remoto
seguro, otro bloque técnico u otra área de Stasisly.

## Plan 2B-Y — routing seguro por sessionId explícito

### Estado

2B-X queda aprobado y cerrado formalmente. 2B-Y prepara solo el plan exacto de
routing seguro por `sessionId` explícito.

No implementa rutas, navegación, conexión `chat_sessions -> messages`, remoto,
producción, IA, Stasis Engine, MCP ni streaming.

### Rutas actuales inspeccionadas

Inspección en solo lectura:

- `lib/core/config/routes.dart`;
- `lib/app.dart`;
- `lib/main.dart`;
- `lib/features/chat/`;
- `lib/features/chat_messages/`;
- `lib/features/chat_sessions/`.

Rutas verificadas:

- `/orchestrator/chat` monta `OrchestratorChatPage`, que carga `stasis_core` y
  monta `ChatPage(agentId: stasis.id, ...)`;
- `/chat/:id` monta `AgentChatWrapper(agentId: id)`;
- `AgentChatWrapper` resuelve `agentByIdProvider(agentId)` y monta `ChatPage`;
- `ChatPage` usa `activeChatSessionProvider(widget.agentId)`;
- `ChatController` heredado envía `role: 'user'`;
- `chat_providers` heredado construye `SupabaseChatDataSource` con
  `Supabase.instance.client` fuera de demo;
- `SupabaseChatDataSource` heredado escribe directamente en `chat_sessions` y
  `messages`.

Conclusión:

```text
/chat/:id = agentId heredado
messages necesita sessionId explícito
chat_sessions puede producir sessionId seguro
```

### Frontera de catálogo preservada

El catálogo sanitizado puede entregar `selectableSpecialistId` para crear una
sesión mediante `chat_sessions`, pero no puede ser entrada directa a
`messages`.

Regla:

```text
agentId != selectableSpecialistId != specialistId interno != sessionId
```

`selectableSpecialistId` no sustituye a `sessionId`. `agentId` heredado no
sustituye a `sessionId`. `specialist_id` interno no debe viajar por UI.

### Opciones de routing futuro

| Opción | Descripción | Ventaja | Riesgo | Recomendación |
| --- | --- | --- | --- | --- |
| A | Ruta nueva `/chat/session/:sessionId` | Clara y explícita | Puede parecer productiva antes de tiempo | Posible después de plan y tests. |
| B | Ruta dev-only `/dev/chat/session/:sessionId` | Menor riesgo productivo | No resuelve UX final | Recomendada como primera implementación futura. |
| C | Mantener routing bloqueado y pasar a auth/session selection | Reduce riesgo de sesión insegura | Retrasa navegación | Válida si se prioriza identidad/sesión. |
| D | Refactor de `/chat/:id` | Reutiliza ruta existente | Alto riesgo: `:id` es `agentId` y arrastra chat heredado | No recomendada. |

### Recomendación

No tocar `/chat/:id`.

No tocar `/orchestrator/chat`.

No usar `AgentChatWrapper`, `ChatPage`, `ChatController` heredado ni
`SupabaseChatDataSource` heredado.

Si se implementa routing después, empezar por un paquete dev-only con parámetro
explícito `sessionId` y producción bloqueada.

### Gates obligatorios

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
- tests de producción bloqueada si es dev-only.

### Relación futura chat_sessions/messages

Flujo permitido:

```text
chat_sessions produce sessionId seguro
ruta futura recibe sessionId explícito
messages consume sessionId explícito
```

Flujos prohibidos:

```text
agentId -> messages
id heredado -> messages
selectableSpecialistId -> messages
/chat/:id -> OwnChatMessagesSafeShell
/orchestrator/chat -> OwnChatMessagesSafeShell
```

### Riesgos clasificados

| Riesgo | Severidad | Mitigación |
| --- | --- | --- |
| Confundir `agentId` con `sessionId` | Bloqueante | Ruta nueva y parámetro `sessionId`. |
| Reactivar chat heredado | Bloqueante | No usar wrappers, controllers ni datasource heredados. |
| Usar Supabase directo desde UI | Bloqueante | Tests arquitectónicos y providers seguros. |
| Abrir producción accidentalmente | Alto | Ruta dev-only y test de bloqueo productivo. |
| Romper rutas existentes | Alto | No tocar rutas heredadas. |
| Exponer IDs internos | Alto | No aceptar `userId`, `specialistId` ni `role`. |
| Mezclar demo/backend real | Alto | Entorno explícito y sin fallback silencioso. |
| Conectar messages antes de selección segura | Medio | Paquetes separados. |

### Siguiente paquete propuesto

Recomendación:

```text
2B-Y-A — implementación dev-only route por sessionId explícito
```

Alternativas:

- `2B-Y-B — implementación ruta nueva local-safe por sessionId explícito`;
- `2B-Z — auth/session selection seguro`;
- otro bloque técnico;
- otra área de Stasisly.

Ninguna implementación queda autorizada por este plan.

## Implementación 2B-Y-A — dev-only route por sessionId explícito

### Estado

2B-Y queda aprobado y cerrado formalmente. 2B-Y-A queda implementado como ruta
dev-only/local por `sessionId` explícito:

```text
/dev/chat/session/:sessionId
```

No queda autorizada ruta productiva.

### Frontera de catálogo preservada

La ruta no usa `selectableSpecialistId`, no resuelve catálogo, no resuelve
agente, no usa `specialist_id` interno y no crea sesión. Recibe únicamente un
`sessionId` explícito ya existente.

Regla preservada:

```text
agentId != selectableSpecialistId != specialistId interno != sessionId
```

### Protección dev-only

La ruta solo se registra bajo:

```text
!kReleaseMode && environment.isDemo
```

En release, backend real o producción, no se añade a la tabla de rutas.

### Rechazos

La ruta no declara ni acepta:

- `id`;
- `agentId`;
- `selectableSpecialistId`;
- `specialistId`;
- `userId`;
- `role`;
- tokens;
- metadata;
- adjuntos.

### Shell seguro

La ruta monta `OwnChatMessagesSafeShell(sessionId)` dentro de un `Scaffold`
dev-only. No monta `ChatPage`, `AgentChatWrapper` ni `OrchestratorChatPage`.

### Rutas heredadas intactas

No se modifican:

- `/chat/:id`;
- `/orchestrator/chat`.

### Chat heredado intacto

No se modifican ni se usan:

- `AgentChatWrapper`;
- `ChatPage`;
- `ChatController`;
- `chat_providers`;
- `SupabaseChatDataSource`.

### Tests

Se añaden:

- test de routing dev-only;
- test arquitectónico de contrato dev-only.

Los tests verifican nombre de ruta, parámetro `sessionId`, guard dev-only,
ausencia de `:id`/`:agentId`, shell seguro y ausencia de chat heredado,
Supabase directo, Edge paths, tokens, roles, IDs internos, Stasis Engine, MCP y
streaming.

### Rollback

Rollback:

- retirar `/dev/chat/session/:sessionId`;
- retirar tests asociados;
- mantener `/chat/:id`;
- mantener `/orchestrator/chat`;
- mantener chat heredado intacto;
- mantener cierre 2B-X.

### Riesgo residual

La ruta sirve solo para validación local/dev. Cualquier evolución productiva
requiere paquete separado con entorno, autorización, navegación, UX, rollback y
tests propios.

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

### Frontera de identificadores

La ruta:

- exige `sessionId` explícito;
- no acepta `id`;
- no acepta `agentId`;
- no acepta `selectableSpecialistId`;
- no acepta `specialistId`;
- no infiere sesión desde catálogo;
- no crea, lista ni archiva `chat_sessions`;
- solo monta `OwnChatMessagesSafeShell` con un `sessionId` ya conocido.

Regla preservada:

```text
agentId != selectableSpecialistId != specialistId interno != sessionId
```

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

- `CurrentIdentity` centraliza identidad y no contiene perfil, rol ni permisos;
- `currentIdentityProvider` da identidad demo solo en modo demo y bloquea
  identidad autenticada fuera de demo;
- `UserEntity` y `UserProfile` mantienen separadas identidad y perfil;
- `main.dart` inicializa Supabase solo si el entorno usa backend;
- `AppEnvironment` bloquea backend real sin aprobación explícita;
- existe auth heredado con `SupabaseAuthDataSource`, `AuthRepositoryImpl` y
  `auth_providers`;
- `auth_providers` heredado expone `Supabase.instance.client`, por tanto no
  puede ser la frontera segura sin paquete específico;
- `chat_sessions` y `chat_messages` tienen providers demo/backendBlocked;
- existen token providers locales para harness de validación, no para producto;
- chat heredado conserva `ChatController`, `chat_providers` y
  `SupabaseChatDataSource`, y sigue bloqueado.

### Frontera de identificadores

Regla que 2B-Z preserva:

```text
agentId != selectableSpecialistId != specialistId interno != sessionId
```

El flujo seguro no puede entregar mensajes desde catálogo o agente. El catálogo
solo puede iniciar selección/creación de sesión mediante `selectableSpecialistId`.
El resultado utilizable por `messages` debe ser siempre `sessionId` explícito.

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

Flutter no envía `userId`, `role`, `specialistId` interno, `agentId` como
sesión ni tokens hardcodeados. El backend valida token, ownership, permisos y
estado de sesión.

### Flujos prohibidos

Quedan prohibidos:

```text
agentId -> messages
id heredado -> messages
selectableSpecialistId -> messages
specialistId interno -> messages
/chat/:id -> messages
/orchestrator/chat -> messages
UI -> Supabase directo
UI -> writes directos
error real -> fallback demo
```

### Responsabilidades por capa

| Capa | Responsabilidad | No puede decidir |
| --- | --- | --- |
| Auth/session | Identidad autenticada, sesión vigente y token seguro. | Ownership de recursos sin backend. |
| Catálogo | Exponer especialistas seleccionables sanitizados. | Sesión, ownership o mensajes. |
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
- no `specialistId` interno directo a `messages`;
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
| Usar `selectableSpecialistId` como sesión | Bloqueante | Crear sesión primero; entregar `sessionId`. |
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
focalizada de auth actual, proveedores, token/session contract, frontera de
catálogo e identificadores que deben quedar bloqueados antes de cualquier
implementación.

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
- `lib/features/auth/`;
- `lib/features/chat_sessions/`;
- `lib/features/chat_messages/`;
- `lib/features/chat/`;
- `test/`;
- `supabase/functions/`;
- `supabase/migrations/`.

### CurrentIdentity

`CurrentIdentity` centraliza identidad mínima con:

- `id`;
- `source`;
- `email`.

No contiene perfil, rol, permisos, catálogo, agente, especialista interno ni
autoridad administrativa. Es base segura parcial para auth/session, siempre que
la identidad autenticada se restaure en paquete aprobado.

### UserEntity y UserProfile

`UserEntity` representa identidad autenticada sin rol ni permisos.

`UserProfile` representa perfil de producto con `userId`, `displayName` y
`avatarUrl`. No concede autoridad.

Esta separación evita que el catálogo, la UI o el perfil puedan decidir
ownership o permisos.

### AppEnvironment

`AppEnvironment` distingue demo, backend real y producción. `main.dart` solo
inicializa Supabase si `environment.usesBackend`.

`validateForStartup` bloquea backend real sin variables válidas y sin
aprobación explícita. Esto reduce el riesgo de que el catálogo o chat activen
remoto accidentalmente.

### Auth heredado

Auth heredado verificado:

- `AuthRepository`;
- `SignInUseCase`, `SignUpUseCase`, `SignOutUseCase`;
- `SupabaseAuthDataSource`;
- `AuthRepositoryImpl`;
- `auth_providers`;
- `AuthController`.

Riesgo principal: `auth_providers` expone `Supabase.instance.client`, y
`SupabaseAuthDataSource` usa Supabase Auth directo. Por tanto, auth heredado no
debe conectarse al catálogo, `chat_sessions`, `messages` o routing seguro sin
paquete separado.

Piezas potencialmente reutilizables tras revisión:

- contratos de repositorio/use cases;
- mapping `UserModel.fromSupabase` que ignora metadata de rol.

Piezas bloqueadas:

- wiring directo de Supabase;
- provider global `Supabase.instance.client`;
- cualquier autoridad desde `userMetadata`;
- cualquier conexión sin `backendBlocked` explícito.

### Token providers

Existen interfaces locales duplicadas por frente:

- `chat_sessions/data/local/local_session_token_provider.dart`;
- `chat_messages/data/local/local_session_token_provider.dart`.

Consumidores:

- datasource HTTP local de `chat_sessions`;
- datasource HTTP local de `chat_messages`;
- harness/tests locales.

Estado: local/harness. No son token provider real de producto. No deben
contener tokens reales versionados ni alimentar remoto/producción.

Falta:

- token provider real unificado o contrato equivalente;
- origen de token aprobado;
- refresh/expiración;
- errores auth visibles;
- anti-remoto;
- cero `service_role` en cliente.

### Relación con chat_sessions

`chat_sessions` consume:

```text
selectableSpecialistId -> createOwnChatSession
sessionId -> archiveOwnChatSession
status/limit/cursor -> listOwnChatSessions
```

No recibe `userId`, `ownerUserId`, `role` ni `specialistId` interno desde UI.
El backend local valida ownership desde token.

En providers:

- demo usa `DemoOwnChatSessionsRepository`;
- no demo usa `BackendBlockedOwnChatSessionsRepository`;
- no hay conexión productiva.

Estado: parcial/local-safe. Puede participar en auth/session selection solo
después de token provider seguro.

### Relación con messages

`messages` consume:

```text
sessionId + content -> sendUserMessage
sessionId + limit/cursor -> listSessionMessages
```

No recibe `userId`, `role`, `agentId`, `selectableSpecialistId` ni
`specialistId` interno desde UI. El backend local valida ownership desde token.

En providers:

- demo usa `DemoOwnChatMessagesRepository`;
- no demo usa `BackendBlockedOwnChatMessagesRepository`;
- no hay conexión productiva.

Estado: parcial/local-safe. Debe recibir `sessionId` solo tras selección segura
de sesión propia.

### Brechas auth/session

| Área | Estado | Evidencia / motivo |
| --- | --- | --- |
| Identidad central | Parcial | Existe `CurrentIdentity`; falta auth real aprobada. |
| Perfil separado | Cerrado conceptualmente | `UserProfile` no concede autoridad. |
| Auth real | Bloqueado | Auth heredado usa Supabase directo y no está integrado al flujo seguro. |
| Demo auth | Parcial | Demo explícito, pero no sustituye auth real. |
| BackendBlocked auth | Parcial | Entorno y repos bloquean backend; falta capa auth/session safe. |
| Token provider local | Parcial | Existe para harness local. |
| Token provider real | Pendiente | No existe contrato productivo aprobado. |
| Errores auth visibles | Parcial | Datasources devuelven `unauthenticated`; falta capa común. |
| No fallback demo | Parcial | Repos separados; falta gate para auth real. |
| Sesiones propias | Parcial | Backend local valida ownership; falta auth productiva. |
| Entrada segura a chat_sessions | Parcial | Contrato existe; falta sesión/token real. |
| Entrada segura a messages | Parcial | `sessionId` explícito existe; falta selección segura previa. |

### Riesgos clasificados

| Riesgo | Severidad | Estado / mitigación |
| --- | --- | --- |
| Mezclar demo auth con auth real | Bloqueante | Separar contratos y mantener modo explícito. |
| Activar Supabase real accidentalmente | Bloqueante | `validateForStartup` bloquea, pero futuros cambios requieren tests. |
| Tokens inseguros o hardcodeados | Bloqueante | Token provider real pendiente. |
| `service_role` en cliente | Bloqueante | Prohibido; solo backend/local controlado. |
| UI enviando `userId` | Bloqueante | Contratos actuales lo evitan; mantener tests. |
| UI decidiendo permisos | Bloqueante | Backend valida ownership/permisos. |
| Confundir `agentId` y `sessionId` | Bloqueante | Rutas heredadas siguen bloqueadas. |
| Usar `selectableSpecialistId` como sesión | Bloqueante | Crear sesión primero; entregar `sessionId`. |
| Reactivar auth heredado sin plan | Alto | `auth_providers` con Supabase directo queda bloqueado. |
| Reactivar chat heredado | Alto | `ChatController`/`SupabaseChatDataSource` bloqueados. |
| Fallback demo desde error real | Alto | Mantener demo/backendBlocked separados. |

### Recomendación

La base es suficiente para preparar el siguiente paquete, pero no para conectar
auth real ni routing. Recomendación:

```text
2B-Z-B — controller/providers auth/session safe
```

Condición: no conectar `auth_providers` heredado directamente al flujo nuevo.
Si el plan muestra acoplamiento peligroso con Supabase directo, dividir antes:

```text
2B-Z-B1 — plan detallado token provider seguro
2B-Z-B2 — separar auth heredado de auth seguro
```

## Plan 2B-Z-B1 — token provider seguro

### Estado

2B-Z-A queda aprobado y cerrado formalmente. 2B-Z-B1 define el plan detallado
del token provider seguro que podrá alimentar en el futuro `chat_sessions`,
`messages` y auth/session safe sin contaminar la frontera de catálogo.

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

- host no local o composición local desactivada devuelve `backendBlocked` antes
  de leer token o ejecutar transporte;
- token ausente devuelve `unauthenticated`;
- token vacío se trata como sesión inválida/no autenticada según frente;
- request válido añade `Authorization: Bearer ...` dentro del datasource;
- los tokens de test son fixtures locales, no credenciales reales.

### Contrato conceptual futuro

Contrato conceptual, no implementado:

```text
currentAuthState()
getAccessToken()
refreshIfNeeded()
clearSession()
```

El contrato debe entregar token de acceso solo a datasources autorizados. No
debe entregar permisos, roles, `userId` como autoridad ni identificadores
internos de especialista.

### Estados auth/token

Estados mínimos propuestos:

| Estado | Significado | Resultado esperado |
| --- | --- | --- |
| `demo` | Modo demo explícito. | No produce token real. |
| `authenticated` | Sesión válida con token disponible. | Permite request controlada. |
| `unauthenticated` | No hay sesión de usuario. | Error visible. |
| `expired` | Token caducado o cercano a caducar. | Refresh controlado. |
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
- `environment.usesBackend`: no activa backend por sí solo;
- backend real: solo con entorno, auth/RLS y paquete aprobados;
- producción: paquete separado y aprobación explícita;
- `kReleaseMode`: no permite rutas/dev flows ni tokens locales;
- errores de entorno producen `backendBlocked` o `misconfigured`, nunca demo.

### Relación con CurrentIdentity

Relación conceptual:

```text
demo -> CurrentIdentity.demo
authenticated -> CurrentIdentity.authenticated
backendBlocked/misconfigured -> sin identidad autenticada usable
```

No se añade `CurrentIdentity.backendBlocked` todavía. Si se necesita, debe ser
estado de sesión, no identidad de usuario.

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
- UI no pasa `specialistId` interno;
- UI no decide permisos;
- datasource añade `Authorization` de forma controlada;
- backend valida ownership;
- errores auth son visibles;
- error real no se convierte en demo.

Frontera preservada:

```text
selectableSpecialistId -> create session -> sessionId
sessionId -> messages
```

El token provider no convierte `agentId`, `selectableSpecialistId` ni
`specialistId` interno en `sessionId`.

### Relación con auth heredado

Regla firme:

```text
auth heredado con Supabase directo no se conecta al flujo nuevo
```

`auth_providers` heredado expone `Supabase.instance.client`, por tanto no puede
ser usado por catálogo, `chat_sessions`, `messages` o routing seguro sin
frontera nueva.

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
| Token transforma catálogo en sesión | Bloqueante | Catálogo crea sesión; solo `sessionId` entra a messages. |

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
presentación y que preserve la frontera:

```text
agentId != selectableSpecialistId != specialistId interno != sessionId
```

## Implementación 2B-Z-C1 — contrato token provider seguro

### Estado

2B-Z-B1 queda aprobado y cerrado formalmente. 2B-Z-C1 implementa el contrato
Dart puro del token provider seguro en `lib/core/auth/session/`.

No conecta auth real, no conecta auth heredado, no importa Supabase, no usa
HTTP/Dio, no ejecuta refresh real, no usa remoto, no usa producción y no trata
datos reales.

### Frontera de catálogo preservada

El token provider no transforma catálogo o agente en sesión. La frontera sigue
siendo:

```text
agentId != selectableSpecialistId != specialistId interno != sessionId
selectableSpecialistId -> create session -> sessionId
sessionId -> messages
```

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

### Implementaciones seguras

Implementaciones explícitas:

- `DemoSecureSessionTokenProvider`;
- `BackendBlockedSecureSessionTokenProvider`;
- `UnauthenticatedSecureSessionTokenProvider`.

Ninguna produce token real. `clearSession` no genera sesión ni token.

### Relación futura con chat_sessions/messages

No se modificaron `chat_sessions` ni `messages`. La relación futura sigue
siendo:

```text
datasource/repository -> SecureSessionTokenProvider -> Authorization controlado
```

La UI no debe pasar token, `userId`, `ownerUserId`, `specialistId` interno,
`agentId` ni permisos.

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

Preparar `2B-Z-C2 — controller/providers auth/session safe`, manteniendo
bloqueada cualquier conversión de `agentId`, `selectableSpecialistId` o
`specialistId` interno en `sessionId`.

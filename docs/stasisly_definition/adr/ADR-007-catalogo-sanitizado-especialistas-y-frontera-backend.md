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
controlada el 2026-06-15. 2B-V `messages` queda preparado como plan exacto
documental, pendiente de aprobación de implementación. No autoriza Supabase
client, remoto, producción, exposición de IDs internos, mensajes reales, IA ni
UI/providers.

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

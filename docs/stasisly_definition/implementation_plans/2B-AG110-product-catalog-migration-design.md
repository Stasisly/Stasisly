# 2B-AG110 — Diseño de migración futura catálogo producto

## Estado

Diseño documental preparado.

Readiness esperado al cierre:

```text
PRODUCT CATALOG MIGRATION DESIGN COMPLETED_AND_PUSHED
```

## Contexto

AG109 cerró con la decisión:

```text
SCHEMA NEEDS FUTURE MIGRATION BEFORE SYNTHETIC CATALOG
```

La tabla local `public.specialist_catalog` ya existe como tabla cerrada
deny-all, pero no representa todavía todo lo requerido por ADR-010, ADR-011 y
ADR-012 para un catálogo producto seguro, jerárquico y compatible con
`/conversations`.

AG110 no crea migración, no toca `supabase/`, no ejecuta SQL, no puebla
`specialist_catalog`, no crea seeds y no registra `/conversations`.

## Decisión de diseño

La futura migración del catálogo producto debe evolucionar `specialist_catalog`
hacia una frontera backend-only con:

- campos públicos sanitizados suficientes para Product Surface;
- campos internos mínimos para validación backend;
- separación explícita de Product, Wizard/Development y Admin/Engine;
- representación inicial de jerarquía Product sin convertirla en lista plana;
- constraints estrictas;
- índices para listado producto estable;
- RLS/grants cerrados para clientes;
- compatibilidad con Edge Functions existentes;
- compatibilidad con contrato Flutter público de seis campos.

El contrato público Flutter no debe crecer automáticamente con el schema. El
backend puede tener más columnas, pero `list-selectable-specialists` debe seguir
devolviendo solo la allowlist pública aprobada para Product Surface.

## Tablas afectadas

### `public.specialists`

Estado futuro recomendado:

- tabla interna/backend-only;
- conserva la entidad especialista/origen técnico;
- no es tabla producto pública;
- puede contener campos sensibles o heredados solo si no se exponen;
- debe seguir cerrada a `anon` y `authenticated`;
- Product Surface nunca lee esta tabla directamente;
- Edge Functions la usan solo para validar existencia, integridad y relación.

No debe exponerse a Product:

- `prompt_template`;
- categorías heredadas no producto;
- jefes internos heredados;
- prompts;
- roles internos;
- IDs internos sensibles;
- operaciones Admin/Engine.

### `public.specialist_catalog`

Estado futuro recomendado:

- tabla producto sanitizada, pero backend-only;
- representa entidades seleccionables o visibles de Product Surface;
- referencia `public.specialists(id)` cuando necesite enlazar entidad técnica;
- contiene solo metadatos producto permitidos;
- no contiene prompts ni permisos;
- no concede autorización final al frontend;
- se lista exclusivamente mediante Edge Function.

## Campos propuestos para `specialist_catalog`

### Identidad y relación

- `id UUID PRIMARY KEY`
- `specialist_id UUID NOT NULL UNIQUE REFERENCES public.specialists(id)`
- `slug TEXT NOT NULL`
- `display_name TEXT NOT NULL`

Regla:

- `id` es el identificador público opaco que puede convertirse en
  `selectableSpecialistId`.
- `specialist_id` es interno y no debe salir al contrato Product.
- `slug` es público solo si no revela estructura interna ni nombres sensibles.

### Clasificación producto

- `product_area TEXT NOT NULL`
- `subcategory TEXT`
- `hierarchy_level TEXT NOT NULL`
- `parent_catalog_id UUID REFERENCES public.specialist_catalog(id)`
- `is_conversable BOOLEAN NOT NULL DEFAULT true`

Valores iniciales recomendados:

- `product_area`: `stasis`, `health`, `nutrition`, `training`, `wellness`
- `hierarchy_level`: `coordinator`, `branch_chief`, `subcategory_chief`,
  `specialist`

Reglas:

- Product Surface puede tener jerarquía, pero no una lista plana sin
  coordinación.
- Un jefe de rama puede existir como entidad producto sin ser necesariamente
  conversable.
- `parent_catalog_id` solo puede apuntar a otra entidad Product Surface.
- Ningún registro Admin/Engine o Wizard/Development puede entrar en esta tabla.

### Contenido público sanitizado

- `short_description TEXT NOT NULL`
- `capabilities JSONB NOT NULL DEFAULT '[]'`
- `safe_public_metadata JSONB NOT NULL DEFAULT '{}'`
- `locale TEXT NOT NULL DEFAULT 'es-ES'`

Reglas:

- `capabilities` debe ser una lista breve de strings sanitizados.
- `safe_public_metadata` solo puede contener claves aprobadas.
- No se permiten prompts, instrucciones internas, logs, tokens ni referencias
  de desarrollo.
- El contrato Product inicial puede mapear `short_description` a
  `shortDescription` y no exponer `capabilities` todavía.

### Publicación, disponibilidad y acceso

- `publication_status TEXT NOT NULL DEFAULT 'draft'`
- `is_published BOOLEAN NOT NULL DEFAULT false`
- `availability_status TEXT NOT NULL DEFAULT 'unavailable'`
- `access_tier TEXT NOT NULL DEFAULT 'free'`
- `supported_surfaces TEXT[] NOT NULL DEFAULT ARRAY['product']`
- `sort_order INTEGER NOT NULL DEFAULT 0`

Valores recomendados:

- `publication_status`: `draft`, `review`, `published`, `unpublished`,
  `disabled`, `maintenance`
- `availability_status`: `available`, `limited`, `unavailable`, `coming_soon`
- `access_tier`: `free`, `pro`, `vip`, `enterprise`
- `supported_surfaces`: debe incluir `product` para registros producto

Reglas:

- solo `publication_status = 'published'`;
- solo `is_published = true`;
- solo `availability_status IN ('available', 'limited')`;
- solo superficie `product`;
- tier validado por backend;
- `coming_soon` puede ser visible no conversable solo si un paquete futuro lo
  autoriza explícitamente.

### Auditoría mínima

- `created_at TIMESTAMPTZ NOT NULL DEFAULT now()`
- `updated_at TIMESTAMPTZ NOT NULL DEFAULT now()`
- `published_at TIMESTAMPTZ`
- `unpublished_at TIMESTAMPTZ`

Campos no recomendados todavía:

- `created_by`;
- `updated_by`;
- `published_by`.

Motivo: requieren modelo admin/autorización adicional y podrían mezclar
Admin/Engine antes de tiempo. Si se añaden, deben ser backend-only y nunca
salir por Product.

## Campos públicos e internos

### Públicos permitidos por Edge Function

La Edge Function puede construir el contrato público con:

- `id` como `selectableSpecialistId`/`id` público opaco;
- `display_name` como `displayName`;
- `product_area` como `area`;
- `short_description` como `shortDescription`;
- estado derivado seguro como `accessState`;
- `isDemo = false` en backend real.

Opcional futuro, con aprobación explícita:

- `slug`;
- `subcategory`;
- `capabilities` sanitizadas;
- `locale`;
- estado visible no conversable.

### Internos/backend-only

Deben permanecer internos:

- `specialist_id`;
- `parent_catalog_id`;
- `publication_status`;
- `is_published`;
- `availability_status`;
- `access_tier`;
- `supported_surfaces`;
- `sort_order`;
- `safe_public_metadata` hasta allowlist explícita;
- timestamps de auditoría si no son necesarios para UX;
- cualquier campo de autoría futura.

### Prohibidos

Nunca deben estar en contrato Product:

- prompts;
- system/developer/internal instructions;
- chain of thought;
- tokens;
- `service_role`;
- connection strings;
- `ownerUserId`;
- `userId`;
- roles internos;
- permisos internos;
- logs internos;
- raw errors;
- Admin/Engine fields;
- Wizard/Development fields;
- fixtures o synthetic identifiers en Product;
- datos reales no autorizados.

## Constraints futuras recomendadas

La migración futura debe definir constraints equivalentes a:

- `slug` no vacío, normalizado y único por superficie/área si aplica.
- `display_name` no vacío, trim exacto, longitud máxima conservadora.
- `short_description` no vacío, trim exacto, longitud máxima conservadora.
- `product_area` dentro de allowlist producto.
- `publication_status` dentro de allowlist.
- `availability_status` dentro de allowlist.
- `access_tier` dentro de allowlist producto.
- `supported_surfaces` no vacío e incluye `product`.
- `supported_surfaces` no contiene `admin`, `engine`, `wizard` ni
  `development` para registros producto.
- `hierarchy_level` dentro de allowlist.
- `parent_catalog_id` no apunta a sí mismo.
- `is_conversable = false` para coordinadores/jefes si el paquete futuro decide
  que no son conversables.
- `sort_order >= 0`.
- `locale` con formato allowlisted inicial, por ejemplo `es-ES`.
- `capabilities` debe ser array JSON, no objeto libre.
- `safe_public_metadata` debe ser objeto JSON y mantenerse vacío hasta
  allowlist explícita.
- `published_at` requerido cuando `publication_status = 'published'`, si se
  decide aplicarlo en la primera migración.

No se deben crear constraints que dependan de datos reales, pagos reales o
roles admin reales en este paquete futuro inicial.

## Índices futuros recomendados

Índices candidatos:

- índice único sobre `slug` con superficie/área si el slug se expone o se usa en
  Admin futuro;
- índice de listado producto sobre `product_area`, `sort_order`,
  `display_name`, `id` filtrado por publicado/disponible;
- índice sobre `specialist_id`;
- índice sobre `parent_catalog_id`;
- índice sobre `publication_status`, `availability_status`, `access_tier` si
  las Edge Functions filtran por esos campos;
- índice sobre `supported_surfaces` solo si se usa en filtros reales y no
  complica la primera migración.

El índice de listado debe favorecer orden estable y paginación futura sin
duplicados.

## RLS y grants esperados

La migración futura debe mantener el principio deny-by-default:

- `public.specialists`: RLS habilitada, cero policies cliente, cero grants
  cliente.
- `public.specialist_catalog`: RLS habilitada, cero policies cliente para
  `anon` y `authenticated`, cero grants cliente.
- Clientes Flutter no leen tablas directamente.
- Edge Functions acceden mediante backend autorizado.
- Product Surface recibe solo contrato público allowlisted.
- Admin/Engine no se mezcla con Product.
- Wizard/Development no se mezcla con Product.
- Datos reales siguen no autorizados.

No se debe añadir `SECURITY DEFINER`, policies permisivas ni grants cliente en
la primera migración de schema salvo aprobación posterior específica.

## Edge Functions afectadas

### `list-selectable-specialists`

Debe evolucionar para:

- leer allowlist explícita;
- filtrar `supported_surfaces` con `product`;
- filtrar `publication_status = 'published'`;
- filtrar `is_published = true`;
- filtrar `availability_status` permitido;
- filtrar o derivar `access_tier`;
- excluir registros no conversables si la UX solo muestra conversables;
- fallar cerrado ante catálogo roto;
- no devolver lista parcial insegura;
- mapear a contrato público de seis campos mientras no se apruebe ampliar el
  contrato Flutter.

### `create-own-chat-session`

Debe validar:

- `selectableSpecialistId` corresponde a `specialist_catalog.id`;
- pertenece a Product Surface;
- está publicado;
- está disponible;
- es conversable;
- el tier del usuario permite crear sesión;
- el `specialist_id` interno existe y es consistente;
- no es agente interno development;
- no es Admin/Engine.

El cliente no puede enviar `specialist_id`, `user_id`, permisos, roles ni
surface.

### `send-user-message`

Debe continuar usando `sessionId` explícito y validar indirectamente:

- sesión propia;
- sesión activa;
- sesión asociada a especialista producto válido;
- catálogo no roto;
- sesión no apunta a Admin/Engine ni Wizard/Development;
- `message_count` y `last_message_at` siguen server-managed.

## Seeds sintéticos futuros

Los seeds sintéticos deben venir después de la migración y de sus pruebas.

Reglas:

- solo `development`;
- sintéticos;
- sin datos reales;
- sin agentes internos development;
- sin agentes Admin/Engine;
- con jefes/especialistas producto solo si se aprueba;
- sin prompts internos;
- sin tokens;
- sin fixtures en Product real;
- reversibles;
- con cleanup verificable;
- sin persistir datos de prueba en staging/production;
- con conteos antes/después si se ejecutan contra development.

El primer seed futuro debería ser mínimo: un especialista producto sintético
publicado, disponible y free, con una relación interna consistente y sin
jerarquía compleja salvo que el paquete lo apruebe.

## Orden futuro de implementación

Orden recomendado:

1. `2B-AG111 — preparar migración local catálogo producto`.
2. Crear migración local nueva sin editar migraciones históricas.
3. Añadir tests SQL/locales para constraints, RLS/grants y rollback.
4. Validar local con Supabase efímero.
5. Revisar si las Edge Functions necesitan cambios de contrato.
6. Implementar cambios de Edge Functions solo si el schema local está validado.
7. Revalidar guards Flutter existentes.
8. Preparar seed sintético development en paquete separado.
9. Ejecutar seed sintético solo con aprobación explícita.
10. Recién después evaluar `/conversations` producto.

## Riesgos

Riesgos altos:

- poblar catálogo antes de migración;
- mezclar Product con Admin/Engine o Wizard/Development;
- exponer `specialist_id` o prompts;
- usar `SELECT *`;
- confiar en el frontend para autorización;
- crear seeds persistentes sin cleanup;
- abrir grants cliente por comodidad.

Riesgos medios:

- sobre-modelar jerarquía antes de validar UX;
- exponer `capabilities` o metadata sin allowlist;
- confundir `access_tier` visible con autorización final;
- permitir `coming_soon` como conversable sin decisión;
- usar slugs como identificadores de autoridad.

Riesgos bajos:

- retrasar catálogo sintético por diseñar schema;
- mantener contrato Flutter reducido mientras backend crece.

## Rollback esperado futuro

La migración futura debe ser reversible o acompañarse de rollback explícito:

- eliminar columnas nuevas si se añaden;
- eliminar constraints nuevas;
- eliminar índices nuevos;
- restaurar deny-all;
- conservar cero policies cliente;
- no dejar fixtures;
- no dejar grants cliente;
- no afectar `public.specialists` más allá de lo aprobado.

## Criterios de aceptación futuros

La implementación de migración solo podrá aprobarse si:

- no edita migraciones históricas;
- no usa datos reales;
- no puebla catálogo;
- no crea seeds;
- no registra `/conversations`;
- mantiene deny-by-default;
- tests SQL/locales prueban constraints y RLS/grants;
- rollback local está probado o documentado ejecutablemente;
- Edge Functions no exponen campos prohibidos;
- Flutter no recibe campos internos;
- `git diff --check` queda limpio.

## Fuera de alcance de AG110

AG110 no autoriza:

- tocar `supabase/`;
- crear migraciones;
- ejecutar SQL;
- crear seeds;
- poblar `specialist_catalog`;
- crear agentes reales;
- crear especialistas reales;
- registrar `/conversations`;
- modificar Flutter;
- modificar Edge Functions;
- usar datos reales;
- activar staging o production.

## Readiness

```text
PRODUCT CATALOG MIGRATION DESIGN COMPLETED_AND_PUSHED
```

## Implementacion local preparada en 2B-AG111

AG111 materializa este diseño como migracion local:

```text
supabase/migrations/00008_prepare_product_catalog_schema.sql
```

La migracion queda preparada para ejecucion y validacion local futura, pero AG111
no la aplica contra remoto, no ejecuta `db push`, no ejecuta
`migration up --linked`, no crea seeds, no puebla `specialist_catalog` y no
registra `/conversations`.

Decisiones concretas de AG111:

- mantiene `specialist_catalog` como tabla backend-only y deny-by-default;
- mantiene `public.specialists` y `public.specialist_catalog` con RLS activo;
- no crea policies permisivas para `anon` ni `authenticated`;
- revoca privilegios directos cliente sobre `specialist_catalog`;
- usa `display_name` existente como nombre publico de producto;
- introduce `slug`, `subcategory`, `public_capabilities`,
  `publication_status`, `supported_surfaces`, `locale`, `public_metadata`,
  `hierarchy_role`, `parent_catalog_id`, `is_conversable`, `published_at` y
  `unpublished_at`;
- conserva `specialist_id` como relacion interna backend-only;
- mantiene `short_description`, `product_area`, `availability_status`,
  `access_tier`, `sort_order`, `created_at` y `updated_at`;
- restringe `supported_surfaces` a `ARRAY['product']` para impedir mezcla con
  Admin/Engine o Wizard/Development en esta primera superficie;
- normaliza `access_tier = 'premium'` a `pro` para alinear el schema futuro;
- anade constraints e indices para listado backend futuro;
- anade trigger local para mantener `updated_at` sin `SECURITY DEFINER`.

Validacion pendiente para paquete futuro:

- aplicar la migracion en Supabase local;
- ejecutar pruebas SQL/pgTAP especificas de constraints, grants, policies, RLS,
  indices y trigger;
- probar rollback local/documentado;
- confirmar que no quedan policies cliente ni grants directos;
- confirmar que el contrato Flutter publico sigue limitado a la allowlist
  aprobada.

Readiness de AG111:

```text
PRODUCT CATALOG LOCAL MIGRATION PREPARED
```

## Validacion local completada en 2B-AG112

AG112 valida localmente la migracion AG111 con Supabase local:

```text
supabase db reset --local --no-seed
supabase test db supabase/tests/2b_ag112_product_catalog_migration_test.sql supabase/tests/2b_ag112_product_catalog_migration_zz_postconditions_test.sql --local
```

Resultado:

```text
67/67 PASS
PRODUCT CATALOG LOCAL MIGRATION VALIDATED_AND_PUSHED
```

La validacion confirma aplicacion local de `00008`, columnas, constraints,
indices, RLS, cero policies, cero grants cliente peligrosos, fixtures
transaccionales y limpieza final.

Pendiente antes de seeds sinteticos:

- decidir y alinear la frontera `access_tier`: la migracion usa `pro`, mientras
  algunos harness/Edge Functions historicos aun usan `premium`;
- no poblar `specialist_catalog` hasta resolver esa compatibilidad o aprobar
  explicitamente el mapeo `pro` -> estado visible de pago.

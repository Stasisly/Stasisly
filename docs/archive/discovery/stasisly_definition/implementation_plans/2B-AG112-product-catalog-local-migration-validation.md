# 2B-AG112 — Validacion local SQL migracion catalogo producto

## Estado

Validacion local completada.

Readiness esperado al cierre:

```text
PRODUCT CATALOG LOCAL MIGRATION VALIDATED_AND_PUSHED
```

## Contexto

AG111 preparo y publico la migracion local:

```text
supabase/migrations/00008_prepare_product_catalog_schema.sql
```

AG112 valida esa migracion solo contra Supabase local. No ejecuta remoto, no
usa datos reales, no crea seeds, no puebla `specialist_catalog` y no registra
`/conversations`.

## Entorno validado

- Rama: `main`.
- Commit inicial esperado: `6f2ab79 db: prepare product catalog schema migration`.
- Entorno usado: Supabase local.
- Reset ejecutado: `supabase db reset --local --no-seed`.
- Migraciones aplicadas localmente: `00001` a `00008`.
- Remoto: no usado.
- Staging/production: no usado.
- Datos reales: no usados.

La CLI de Supabase puede mostrar claves locales efimeras durante `supabase
start`; no se registran en esta documentacion ni deben copiarse a Git.

## Migracion validada

La migracion `00008_prepare_product_catalog_schema.sql` aplica sin errores en
local y deja `public.specialist_catalog` preparado para catalogo producto
backend-only.

La validacion confirma:

- columnas existentes conservadas;
- columnas nuevas disponibles;
- defaults nuevos presentes;
- constraints de seguridad y coherencia presentes;
- indices backend futuros presentes;
- RLS activo sin `FORCE ROW LEVEL SECURITY`;
- cero policies para `public.specialists` y `public.specialist_catalog`;
- cero grants cliente peligrosos sobre `public.specialist_catalog`;
- trigger `updated_at` existente sin ejecucion directa por roles cliente.

## Tests SQL creados

Se crearon dos harness pgTAP locales:

```text
supabase/tests/2b_ag112_product_catalog_migration_test.sql
supabase/tests/2b_ag112_product_catalog_migration_zz_postconditions_test.sql
```

El test principal cubre 59 comprobaciones:

- existencia y orden estable de columnas;
- tipos de columnas nuevas;
- defaults de `publication_status`, `supported_surfaces`, `locale`,
  `hierarchy_role`, `is_conversable` y `slug`;
- presencia de constraints AG111;
- RLS, policies y grants;
- indices `idx_specialist_catalog_product_slug_unique`,
  `idx_specialist_catalog_product_listing_v2`,
  `idx_specialist_catalog_product_access_v2` e
  `idx_specialist_catalog_supported_surfaces_gin`;
- funcion/trigger de `updated_at`;
- insercion de fila sintetica local valida;
- relacion basica `parent_catalog_id`;
- rechazo de slug invalido;
- rechazo de `publication_status` invalido;
- rechazo de `availability_status` invalido;
- rechazo de `access_tier` legacy `premium` e interno;
- rechazo de `supported_surfaces` sin Product o mezclando Product/Admin;
- rechazo de locale invalido;
- rechazo de `public_metadata` no objeto;
- rechazo de `public_capabilities` no array;
- rechazo de `hierarchy_role` invalido;
- rechazo de `parent_catalog_id` autociclico o inexistente;
- consistencia `is_published` / `publication_status`;
- unicidad de slug por `product_area`;
- denegacion de `SELECT`, `INSERT`, `UPDATE` y `DELETE` para `anon` y
  `authenticated`.

El test de postcondiciones cubre 8 comprobaciones:

- cero fixtures internos AG112 persistidos;
- cero fixtures de catalogo AG112 persistidos;
- RLS activo sin FORCE;
- cero policies;
- cero grants tabla cliente;
- cero grants columna cliente;
- cero filas legacy `premium`;
- `specialist_catalog` vacio tras la validacion.

## Comandos ejecutados

```bash
git status -sb
git log --oneline -5
git diff --check
find supabase/tests -maxdepth 2 -type f | sort
supabase start
supabase db reset --local --no-seed
supabase test db supabase/tests/2b_ag112_product_catalog_migration_test.sql --local
supabase test db supabase/tests/2b_ag112_product_catalog_migration_zz_postconditions_test.sql --local
supabase test db supabase/tests/2b_ag112_product_catalog_migration_test.sql supabase/tests/2b_ag112_product_catalog_migration_zz_postconditions_test.sql --local
```

Resultado:

```text
AG112 tests: 67/67 PASS
```

## Rollback y limpieza local

Los fixtures de AG112 se crean dentro de transacciones pgTAP y terminan en
`ROLLBACK`.

La limpieza local queda comprobada por el test de postcondiciones:

```text
AG112 internal specialist fixtures: 0
AG112 catalog fixtures: 0
specialist_catalog rows: 0
```

AG112 no prueba rollback estructural de la migracion `00008` porque el paquete
solo autoriza validacion local de aplicacion y tests. Un rollback estructural
requeriria un paquete explicito con base efimera o script reversible separado.

## Compatibilidad detectada y resuelta en AG113

La migracion AG111 normaliza `access_tier = 'premium'` a `pro` y despues rechaza
`premium` como valor nuevo.

Esto valido la decision de schema y dejo una compatibilidad pendiente que AG113
resuelve:

- Product usa definitivamente `free`, `pro` y `vip`;
- `premium` queda como legacy rechazado en contratos nuevos y normalizado solo en
  migracion historica controlada;
- `pro` y `vip` se derivan como `lockedPro` en respuestas publicas;
- los harness HTTP dejan de insertar `premium`;
- las Edge Functions dejan de tratar `premium` como contrato interno activo.

## Fuera de alcance respetado

AG112 no ejecuta:

- `supabase db push`;
- `supabase migration up --linked`;
- `supabase functions deploy`;
- `supabase secrets set`;
- `supabase db pull`;
- dump remoto;
- SQL contra remoto.

AG112 no toca:

- production;
- staging;
- datos reales;
- `auth.users` remoto;
- `specialist_catalog` remoto;
- Edge Functions;
- `/conversations`;
- `lib/`;
- Flutter UI.

AG112 no crea:

- seeds reales;
- agentes reales;
- especialistas reales;
- catalogo real.

## Readiness

```text
PRODUCT CATALOG LOCAL MIGRATION VALIDATED_AND_PUSHED
```

## Siguiente paso recomendado

No preparar seeds sinteticos todavia si se quiere conservar coherencia total de
contratos.

AG113 recomendado y ejecutado:

```text
2B-AG113 — canonicalizar access_tier antes de seeds sinteticos Product
```

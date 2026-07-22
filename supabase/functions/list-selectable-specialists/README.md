# `list-selectable-specialists` local

Edge Function experimental de 2B-III-C. Solo puede ejecutarse contra el stack
Supabase local y devuelve exclusivamente el contrato sanitizado del catálogo.

## Límites

- No desplegar, enlazar ni ejecutar contra remoto.
- No guardar claves, JWT o secretos en archivos versionados.
- `service_role` se usa únicamente dentro del runtime local.
- Flutter, sesiones, mensajes y datos reales permanecen fuera de alcance.
- El catálogo demo no llama esta función.

## Contrato

```http
GET /functions/v1/list-selectable-specialists
Authorization: Bearer <JWT_LOCAL_VALIDADO>
Accept: application/json
```

Filtro opcional:

```text
?area=stasis|health|nutrition|training|wellness
```

Un filtro inválido devuelve `400 catalogInvalidArea`. Cada elemento exitoso
contiene exactamente:

```text
selectableSpecialistId
displayName
publicArea
publicDescription
accessState
```

Cualquier parámetro distinto de `area`, incluido `user_id`, rol, entitlement o
`accessState`, devuelve `400 catalogInvalidRequest`.

## Ejecución local

Crear un archivo temporal fuera del repositorio que contenga únicamente:

```text
STASISLY_ALLOW_LOCAL_ONLY=true
```

Después:

```bash
supabase start
supabase db reset --local --no-seed
supabase test db --local
supabase functions serve list-selectable-specialists \
  --no-verify-jwt \
  --env-file /ruta/temporal/fuera-del-repo
deno test --allow-env supabase/functions/list-selectable-specialists/index_test.ts
bash supabase/tests/2b_iii_c_edge_function_local_test.sh
supabase stop
```

`--no-verify-jwt` desactiva únicamente la verificación automática del gateway
local para que la función demuestre su propia validación contra Auth local. No
permite omitir la validación dentro de la función.

El harness SQL 2B-III-B mantiene los fixtures de catálogo dentro de una
transacción revertida. Los tests de función usan datos en memoria para validar
contrato y `accessState`; el harness HTTP valida la frontera real con el
catálogo local vacío. Ninguno crea seed o filas de catálogo persistentes.

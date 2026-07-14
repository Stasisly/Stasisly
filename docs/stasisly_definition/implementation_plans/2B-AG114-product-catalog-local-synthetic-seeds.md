# 2B-AG114 — Seeds sintéticos locales del catálogo Product

## Estado

Completado y validado localmente. Pendiente únicamente de consolidación Git al
inicio de este documento; el resultado final del paquete debe registrarse tras
el commit y push.

## 1. Propósito

Crear un catálogo Product reducido, sintético y determinista que permita validar
schema, jerarquía, publicación, disponibilidad, conversabilidad, tiers y frontera
pública sin usuarios, datos reales, prompts reales, remoto ni rutas Product.

El dataset no constituye el roster editorial definitivo de 251 agentes. Es una
base local de desarrollo y pruebas.

## 2. Estrategia de seed

El seed versionado vive en `supabase/seed.sql`. La carga automática continúa
desactivada en `supabase/config.toml` para no alterar las precondiciones de las
suites históricas, que requieren tablas vacías y fixtures transaccionales.

Procedimiento local aprobado:

```bash
supabase db reset --local --no-seed
docker exec -i supabase_db_Stasisly \
  psql -U postgres -d postgres -v ON_ERROR_STOP=1 < supabase/seed.sql
docker exec -i supabase_db_Stasisly \
  psql -U postgres -d postgres -v ON_ERROR_STOP=1 \
  < supabase/tests/2b_ag114_product_catalog_seed_test.psql
```

El seed usa UUID fijos, timestamps fijos y `ON CONFLICT (id) DO NOTHING`. Una
segunda aplicación no inserta filas, no crea duplicados y conserva el mismo
fingerprint. Para eliminarlo se ejecuta `supabase db reset --local --no-seed`.

## 3. Dataset y distribución

Se crean 19 identidades backend mínimas en `specialists` y 19 representaciones
públicas controladas en `specialist_catalog`:

| Área | Entradas | Nombres sintéticos |
|---|---:|---|
| Stasis | 1 | Stasis |
| Salud | 4 | Salus, Sintoma, Cardia, Motus |
| Nutrición | 4 | Nutria, Fuel, Menu, Emocion |
| Entrenamiento | 6 | Atlas, Kitesurf, CrossFit, HYROX, Yoga, Pilates |
| Wellness | 4 | Sofia, Somno, Loto, Calma |
| **Total** | **19** | Dataset reducido Product |

No se incluyen Nexus, Rector, Gerendi, agentes AAA, Wizard, Admin/Engine ni
agentes internos de Development.

## 4. Jerarquía

```text
Stasis (coordinator)
├── Salus (branch_chief)
│   ├── Sintoma
│   ├── Cardia
│   └── Motus
├── Nutria (branch_chief)
│   ├── Fuel
│   ├── Menu
│   └── Emocion
├── Atlas (branch_chief)
│   ├── Kitesurf
│   ├── CrossFit
│   ├── HYROX
│   ├── Yoga
│   └── Pilates
└── Sofia (branch_chief)
    ├── Somno
    ├── Loto
    └── Calma
```

Stasis es la única raíz Product. Los cuatro jefes dependen de Stasis y cada
especialista depende de su jefe de área. Los tests rechazan autoparents y padres
huérfanos; no se amplía el schema para ciclos indirectos.

## 5. Tiers y estados

Distribución canónica:

- `free`: 12 entradas.
- `pro`: 4 entradas.
- `vip`: 3 entradas.
- `premium`, `enterprise` u otros: 0 entradas.

Estados representados:

- publicados: 16;
- draft: 2;
- unpublished: 1;
- disponibles: 17;
- no disponibles: 2;
- conversables: 14;
- no conversables: 5;
- seleccionables por el predicado público completo: 9.

No se implementan entitlements comerciales. `pro` y `vip` conservan el estado
público bloqueado ya aprobado hasta que exista autorización real.

## 6. Identidad interna y contrato público

`specialists` contiene solo identidad backend sintética mínima. Sus UUID están
en el rango `11000000-...`, `prompt_template` es `{}`, no hay usuarios, auth,
sesiones, mensajes, secretos ni prompts funcionales.

`specialist_catalog` usa UUID distintos en el rango `21000000-...` y contiene
la representación Product sanitizada: slug, nombre, descripción, área,
subcategoría, capacidades públicas, publicación, disponibilidad, tier,
surface, locale, metadata pública, jerarquía, conversabilidad y orden.

Todos los `supported_surfaces` son exactamente `['product']`. `public_metadata`
solo usa claves públicas como `iconKey`, `searchAliases` y `experienceLevel`.
Los tests bloquean claves de prompts, razonamiento, permisos, ownership, tokens,
credenciales, secretos y datos Admin/Development.

## 7. Frontera backend

`list-selectable-specialists` conserva su DTO público de seis campos y sigue sin
usar `SELECT *`. La consulta local añade filtros explícitos para:

- `is_published = true`;
- `publication_status = published`;
- `availability_status = available`;
- `supported_surfaces = {product}`;
- `is_conversable = true`;
- área opcional válida;
- orden estable y límite 20.

No se exponen `specialist_id`, `parent_catalog_id`, metadata, prompts, permisos,
ownership ni timestamps internos. No hay fallback demo ni despliegue remoto.

## 8. Tests y evidencia

El pgTAP dedicado ejecuta 45 checks sobre el seed aplicado: recuentos, slugs,
FK, superficies, jerarquía, estados, tiers, metadata, campos públicos, RLS,
policies, grants y denegación directa para `anon`/`authenticated`.

Resultados:

- primer reset local y aplicación: 19 especialistas y 19 filas de catálogo;
- pgTAP AG114: 45/45;
- segunda aplicación: 0 inserts y fingerprint sin cambios;
- segundo reset y aplicación: mismo recuento y mismo fingerprint;
- Deno `list-selectable-specialists`: 11/11;
- suite SQL completa después de cleanup: 479/479;
- cleanup final AG114: `0|0`.

## 9. Seguridad

RLS permanece activo y sin `FORCE RLS` en `specialists` y
`specialist_catalog`. Ambas tablas conservan cero policies y cero grants de
cliente peligrosos. `anon` y `authenticated` no pueden leer el catálogo de
forma directa.

La carga se ejecutó exclusivamente contra `127.0.0.1` y el contenedor local
`supabase_db_Stasisly`. No se usaron comandos linked, remoto, deploy, secrets,
auth users, datos reales ni credenciales reales.

## 10. Límites

No se crea catálogo real, roster completo, regionalización, pricing, entitlement,
usuarios, auth, sesiones, mensajes, UI Product, `/conversations`, `/chat/:id`,
Stasis Engine, MCP ni prompts de agentes. Tampoco se modifica la migración
`00008` ni se activa el seed automático.

## 11. Readiness

```text
PRODUCT CATALOG LOCAL SYNTHETIC SEEDS VALIDATED_AND_PUSHED
```

Siguiente paquete recomendado:

```text
2B-AG115 — validar creación local de sesión mediante selectableSpecialistId
```

La adaptación mínima de `list-selectable-specialists` ya queda cubierta y
probada en AG114, por lo que AG115 puede concentrarse en el siguiente contrato
local sin registrar rutas Product ni conectar remoto.

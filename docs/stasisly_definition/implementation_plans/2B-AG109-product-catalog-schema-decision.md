# 2B-AG109 — Decisión schema futuro catálogo producto

## Estado

Preparado dentro de `2B-AG109 route/fail-closed guards y decisión schema catálogo producto`.

## Decisión

```text
SCHEMA NEEDS FUTURE MIGRATION BEFORE SYNTHETIC CATALOG
```

## Base revisada

La decisión se basa solo en documentación y archivos locales visibles:

- `docs/stasisly_definition/adr/ADR-010-product-specialists-catalog.md`
- `docs/stasisly_definition/adr/ADR-011-product-specialists-catalog-guards-contracts.md`
- `docs/stasisly_definition/adr/ADR-012-agent-hierarchy-product-admin-engine.md`
- `docs/stasisly_definition/implementation_plans/2B-AG104-product-catalog-tests-guards-plan.md`
- `supabase/migrations/00004_create_specialist_catalog_deny_all.sql`
- contratos Flutter locales en `lib/features/specialists/`

No se ha consultado remoto, no se ha ejecutado SQL, no se ha hecho `db pull`, no se ha creado migración y no se ha poblado `specialist_catalog`.

## Motivo

El schema local existente de `public.specialist_catalog` es útil como tabla cerrada y deny-all, pero no cubre todavía todo lo que ADR-010, ADR-011 y ADR-012 exigen antes de poblar un catálogo producto, aunque sea sintético.

Diferencias relevantes:

- ADR-010/011 mencionan `slug`, `subcategory`, capacidades resumidas, `locale` y `supported_surfaces`; la tabla local no los tiene.
- ADR-010/011 separan publicación, disponibilidad, tier y superficie Product; la tabla local no expresa superficie de forma explícita.
- ADR-012 introduce jerarquía Product/Admin-Engine; la tabla local no representa nivel jerárquico, coordinador, jefe de rama/subcategoría ni relación jerárquica producto.
- El contrato Flutter público ya está reducido a seis campos sanitizados (`id`, `displayName`, `area`, `shortDescription`, `accessState`, `isDemo`), por lo que el schema backend puede evolucionar sin exponer campos internos al producto.
- `public.specialists` sigue siendo una tabla heredada con prompts y categorías antiguas; cualquier relación con `specialist_catalog` debe mantenerse backend-only y no contaminar Product Surface.

## Implicación

Antes de preparar catálogo sintético development debe existir un paquete específico para diseñar la migración futura del catálogo producto.

Ese paquete debe decidir, como mínimo:

- campos definitivos de `specialist_catalog`;
- si `supported_surfaces` vive como columna, tabla relacional o validación backend;
- cómo representar jerarquía producto sin mezclar agentes internos ni Admin/Engine;
- valores permitidos de `availability_status` y `access_tier`;
- compatibilidad entre schema backend y contrato público Flutter de seis campos;
- política de RLS/grants y acceso backend-only;
- estrategia de migración local/remota segura;
- rollback;
- tests SQL/locales y guards Flutter asociados.

## Fuera de alcance

AG109 no autoriza:

- modificar `supabase/`;
- crear migraciones;
- ejecutar SQL;
- poblar `specialist_catalog`;
- crear agentes reales;
- crear especialistas reales;
- crear fixtures persistentes;
- registrar `/conversations`;
- conectar Product Surface a backend real;
- usar datos reales;
- tocar staging o production.

## Siguiente paquete recomendado

```text
2B-AG110 — preparar diseño de migración catálogo producto
```

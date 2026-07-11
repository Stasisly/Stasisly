# ADR-011 — Guards y contratos del catálogo producto de especialistas

## Estado

Aprobada conceptualmente / Pendiente de implementación.

## Contexto

ADR-008 define la futura ruta producto `/conversations`, pero no la implementa.
ADR-009 separa Product Surface, Wizard/Development Surface y Admin/Engine
Surface. ADR-010 aprueba conceptualmente el catálogo producto de especialistas
conversables y deja su implementación pendiente.

Antes de crear schema, migraciones, seeds, especialistas reales o integración
producto, Stasisly necesita guards y contratos normativos que impidan contaminar
`specialist_catalog` producto con agentes internos, agentes Admin/Engine,
prompts internos, fixtures, datos reales no autorizados o campos sensibles.

AG95 es documental. No implementa código, no crea tests, no toca Supabase, no
ejecuta SQL, no crea migraciones, no crea seeds, no puebla
`specialist_catalog`, no registra `/conversations`, no usa datos reales y no
activa staging ni production.

## Decisión

Antes de implementar schema, seeds, catálogo real o `/conversations` producto,
Stasisly debe definir y aplicar guards/contracts que protejan
`specialist_catalog` producto frente a contaminación de superficies, campos
prohibidos, prompts internos, datos inseguros y entidades no producto.

El siguiente frente recomendado es preparar y aprobar estos contratos antes de
cualquier implementación de catálogo.

## Contrato público permitido

El contrato público del catálogo producto solo puede exponer datos sanitizados,
deliberadamente permitidos y necesarios para la experiencia de usuario.

Campos conceptualmente permitidos:

- `display_name`;
- `slug`;
- `product_area`;
- `subcategory`;
- descripción corta sanitizada;
- capacidades resumidas;
- `availability_status`;
- `access_tier`;
- `is_published`;
- `sort_order`;
- `locale`;
- `supported_surfaces`;
- metadata pública segura si existe;
- `created_at` y `updated_at` solo si no exponen información sensible.

Regla: todo campo expuesto a Product Surface debe ser deliberadamente
permitido, sanitizado y necesario para la experiencia de usuario.

## Contrato interno prohibido

Nunca deben exponerse en contratos producto:

- system prompts;
- developer prompts;
- internal prompts;
- chain of thought;
- instrucciones internas;
- políticas internas completas;
- IDs sensibles de agentes internos;
- nombres de comités técnicos internos;
- roles admin;
- roles development;
- `service_role`;
- tokens;
- connection strings;
- model routing interno sensible;
- cost controls internos;
- debug flags;
- feature flags internos;
- fixtures;
- synthetic user identifiers;
- tokens sintéticos;
- referencias internas development;
- permisos internos;
- ownership;
- detalles RLS explotables;
- métricas internas;
- datos de otros usuarios;
- health data no autorizado;
- logs internos;
- errores técnicos crudos.

## Campos permitidos

Los campos permitidos deben cumplir simultáneamente:

- pertenecer al contrato público aprobado;
- tener finalidad clara de producto;
- estar sanitizados;
- no conceder autoridad;
- no revelar infraestructura, prompts, costes, permisos ni ownership;
- no depender de datos reales no autorizados;
- poder validarse por backend con allowlist explícita.

## Campos prohibidos

Un campo queda prohibido si cumple cualquiera de estas condiciones:

- contiene secretos, credenciales, tokens o rutas internas;
- permite inferir prompts, políticas internas o razonamiento interno;
- representa autoridad, permiso, ownership o rol interno;
- identifica agentes internos de desarrollo o Admin/Engine;
- proviene de fixtures o usuarios sintéticos;
- revela datos de otros usuarios o health data no autorizado;
- expone errores técnicos crudos, logs, métricas internas o detalles RLS
  explotables.

## Regla anti SELECT *

Ninguna función backend, repositorio, RPC, query o contrato producto debe usar
`SELECT *` para devolver especialistas producto.

Debe existir una allowlist explícita de campos públicos. Si un campo nuevo se
añade al schema, no debe aparecer automáticamente en Product Surface. Debe
requerir revisión y autorización explícita.

## Guard anti agentes internos de desarrollo

Deben existir guards contra:

- agentes AAA internos;
- comités técnicos;
- roles de arquitectura;
- roles de seguridad;
- roles QA;
- roles Product Owner internos;
- orquestadores técnicos internos;
- prompts de desarrollo;
- cualquier entidad Wizard/Development Surface.

Regla: ninguna entidad Wizard/Development Surface puede aparecer en
`specialist_catalog` producto ni ser conversable por usuario final.

## Guard anti agentes Admin/Engine

Deben existir guards contra:

- agentes Admin/Engine;
- Data Analyst Agent;
- Retention Analyst Agent;
- Support Intelligence Agent;
- Risk & Abuse Detection Agent;
- Admin Decision Assistant;
- herramientas admin;
- roles admin;
- métricas internas;
- operaciones del Stasis Engine.

Regla: ninguna entidad Admin/Engine Surface puede aparecer en
`specialist_catalog` producto ni ser conversable por usuario final.

## Guard anti prompts internos

El catálogo producto nunca puede exponer prompts internos, system prompts,
developer prompts, instrucciones completas de agente, políticas internas
completas, chain of thought ni detalles de razonamiento interno.

La transparencia producto debe explicar capacidades, límites, origen de una
decisión y participantes autorizados sin revelar instrucciones internas,
secretos ni razonamiento sensible.

## Guard anti fixtures y usuarios sintéticos

Fixtures, usuarios sintéticos, catálogos development, IDs sintéticos y datos de
prueba, tokens sintéticos y referencias internas development no pueden aparecer
en Product Surface.

Los fixtures pueden existir en Wizard/Development Surface bajo control, pero no
pueden contaminar Product Surface ni convertirse en catálogo producto real por
accidente.

## Guard anti datos reales no autorizados

El catálogo producto no puede usar datos reales, health data, conversaciones,
perfiles de usuarios, métricas internas o datos comerciales reales hasta que
exista autorización explícita, RLS suficiente, auditoría, minimización y paquete
aprobado.

Product Surface debe degradar de forma segura si falta autorización para datos
reales. No puede caer a demo silencioso ante errores reales.

## Guard anti catálogo roto parcial

Debe bloquearse o degradarse de forma segura si:

- falta `specialist`;
- falta `specialist_catalog`;
- un especialista publicado apunta a entidad inexistente;
- el tier es inválido;
- la disponibilidad es inválida;
- la superficie es inválida;
- faltan campos obligatorios;
- el contrato público no se puede construir completo;
- backend detecta mezcla de superficies.

Regla: ante catálogo roto, el sistema debe fallar cerrado o devolver estado
seguro; nunca devolver lista parcial insegura, fallback demo ni errores técnicos
crudos.

## Guard de superficie Product

Toda lectura producto del catálogo debe validar `surface = Product`.

Product Surface no puede leer ni mostrar registros Wizard/Development ni
Admin/Engine. La separación de superficies no depende del frontend: backend
debe aplicar la frontera antes de responder.

## Guard de publicación y disponibilidad

Solo especialistas `published` con disponibilidad `available` o `limited`
pueden aparecer como seleccionables.

No deben ser seleccionables:

- `draft`;
- `review`;
- `unpublished`;
- `disabled`;
- `maintenance`;
- `unavailable`.

`coming_soon` puede mostrarse solo si se autoriza explícitamente como estado no
conversable.

## Guard de tiers y suscripción

Backend debe validar el tier final.

El frontend puede mostrar información de acceso, pero no decide autorización
final. Un especialista solo puede aparecer como seleccionable si el usuario
tiene acceso al `access_tier` requerido o si backend lo marca explícitamente
como visible pero bloqueado de forma segura.

## Validación backend esperada

Backend debe:

- usar allowlist explícita de campos;
- validar `surface = Product`;
- filtrar `published`;
- filtrar disponibilidad;
- filtrar `access_tier`;
- validar suscripción o tier del usuario;
- rechazar internal/dev/admin agents;
- rechazar prompts y campos prohibidos;
- rechazar catálogo roto;
- no usar `SELECT *`;
- no devolver errores técnicos crudos;
- no hacer fallback demo;
- no depender de decisiones de autorización del frontend;
- registrar errores de forma segura y sin secretos.

## Validación frontend esperada

Frontend Product debe:

- consumir solo contrato backend;
- no construir especialistas desde datos internos;
- no pasar `userId`, `ownerUserId`, `role` ni permisos;
- no decidir autorización final;
- no usar Supabase directo;
- no usar `service_role`;
- no usar fixtures;
- no usar fallback demo ante errores reales;
- mostrar error o empty state seguro si backend falla;
- no interpretar campos ausentes como permiso implícito.

## Relación con list-selectable-specialists

`list-selectable-specialists` debe devolver solo especialistas producto
permitidos por contrato público, superficie Product, publicación,
disponibilidad y tier.

Debe fallar cerrado o devolver estado seguro ante catálogo roto. No debe
devolver agentes internos, agentes Admin/Engine, prompts, fixtures, datos
reales no autorizados ni campos fuera de allowlist.

## Relación con create-own-chat-session

`create-own-chat-session` debe aceptar `selectableSpecialistId` solo si backend
valida que pertenece a Product Surface, está publicado, está disponible y está
autorizado por tier para el usuario.

El cliente no puede enviar `specialist_id`, `user_id`, ownership, permisos,
roles ni campos de autoridad.

## Relación con /conversations

Product `/conversations` depende de catálogo producto seguro. No debe
implementarse `/conversations` hasta que guards/contracts estén aprobados y
exista paquete específico de implementación.

`/conversations` no puede reutilizar dev-shell, fixtures, `/chat/:id` heredado,
`/orchestrator/chat`, agentes internos ni agentes Admin/Engine.

## Relación con wearables futuros

Wearables futuros heredarán el contrato público de Product Surface.

No pueden abrir catálogo propio, exponer campos prohibidos, exponer agentes
internos ni exponer agentes Admin/Engine. Cualquier interacción conversacional
desde Apple Watch, Wear OS o Garmin requiere ADR o paquete específico posterior.

## Tests futuros obligatorios

Tests futuros mínimos:

- backend allowlist no contiene campos prohibidos;
- backend no usa `SELECT *`;
- `list-selectable-specialists` no devuelve agentes internos;
- `list-selectable-specialists` no devuelve Admin/Engine agents;
- `list-selectable-specialists` no devuelve prompts internos;
- `list-selectable-specialists` filtra `unpublished`, `disabled`,
  `maintenance` y `unavailable`;
- `list-selectable-specialists` filtra `access_tier`;
- `list-selectable-specialists` falla cerrado ante catálogo roto;
- `create-own-chat-session` rechaza especialista no publicado;
- `create-own-chat-session` rechaza especialista no autorizado por tier;
- `create-own-chat-session` rechaza internal/dev/admin agents;
- Product UI no pasa `userId`, `ownerUserId`, `role` ni permisos;
- Product UI no usa Supabase directo;
- Product UI no usa `service_role`;
- Product UI no usa fixtures;
- Product UI no usa fallback demo ante errores reales.

AG95 no crea tests.

## Orden recomendado de implementación

Orden recomendado:

1. Aprobar ADR-011 guards/contracts.
2. Baseline/commit/push ADR-011.
3. Preparar implementación de tests/guards.
4. Implementar tests/guards sin poblar datos reales.
5. Preparar schema/migración si falta.
6. Preparar seeds sintéticos controlados development.
7. Validar catálogo sintético.
8. Preparar integración `/conversations` producto.
9. Preparar staging strategy.
10. Solo después, considerar datos/producto real.

## Alcance autorizado

AG95 autoriza solo documentación:

- crear esta ADR;
- añadir referencias breves en ADR-008, ADR-009, ADR-010, arquitectura,
  definición de proyecto y tracker si procede;
- registrar la decisión en `SESSION_TRACKER.md`.

## Alcance no autorizado

AG95 no autoriza:

- código;
- tests;
- cambios en `supabase/`;
- SQL;
- migraciones;
- seeds;
- poblar `specialist_catalog`;
- crear especialistas reales;
- crear fixtures;
- crear sesiones;
- enviar mensajes;
- registrar `/conversations`;
- conectar producto;
- usar datos reales;
- staging;
- production;
- deploy;
- push.

## Riesgos

Riesgos altos:

- implementar catálogo antes de guards/contracts;
- exponer agentes internos como producto;
- exponer agentes Admin/Engine como producto;
- devolver campos prohibidos por usar `SELECT *`;
- devolver lista parcial insegura ante catálogo roto.

Riesgos medios:

- mezclar disponibilidad con autorización;
- permitir tiers solo en frontend;
- usar fixtures development como catálogo producto;
- diseñar schema antes de cerrar contrato público.

Riesgos bajos:

- retrasar schema/seeds por exceso de prudencia;
- requerir ajustes de nombres antes de implementación.

## Relación con ADR-008

ADR-008 define `/conversations` producto y la deja pendiente de implementación.
ADR-011 exige que `/conversations` no avance hasta que el catálogo producto
tenga guards y contratos aprobados.

## Relación con ADR-009

ADR-009 separa Product Surface, Wizard/Development Surface y Admin/Engine
Surface. ADR-011 convierte esa separación en reglas de contrato y guards para
`specialist_catalog` producto.

## Relación con ADR-010

ADR-010 define qué es el catálogo producto de especialistas conversables.
ADR-011 define cómo protegerlo antes de schema, seeds, datos reales o rutas
producto.

## Relación con ADR-012

ADR-012 propone la jerarquía conceptual de agentes Product y Admin/Engine. Para
ADR-011, los guards y contratos futuros deben proteger tambien esa jerarquía:
coordinadores, jefes de departamento y especialistas no pueden saltarse
allowlists, permisos, superficies, fallo cerrado ni contratos públicos.

## Estado de implementación

No implementado.

No existe autorización en esta ADR para modificar código, crear tests, tocar
Supabase, ejecutar SQL, crear migraciones, crear seeds, poblar
`specialist_catalog`, crear especialistas reales, registrar `/conversations`,
usar datos reales, activar staging, activar production, desplegar cambios ni
hacer push.

## Revisión 2B-AG96

AG96 revisa y aprueba conceptualmente esta ADR con ajustes menores
documentales. La decisión central no cambia: antes de implementar schema,
seeds, catálogo real o `/conversations`, Stasisly debe cerrar guards y contratos
que protejan `specialist_catalog` producto.

Resultado de revisión:

- decisión: ADR-011 aprobada con ajustes menores;
- readiness: `PRODUCT CATALOG GUARDS ADR APPROVED WITH MINOR CHANGES`;
- estado actualizado a `Aprobada conceptualmente / Pendiente de implementación`;
- se refuerza la prohibición de tokens sintéticos y referencias internas
  development en Product Surface;
- se aclara que catálogo roto tampoco puede exponer errores técnicos crudos;
- no se implementa código;
- no se crean tests;
- no se ejecuta SQL;
- no se crean migraciones;
- no se crean seeds;
- no se puebla `specialist_catalog`;
- no se crean especialistas reales;
- no se registra `/conversations`;
- no se toca Supabase;
- no se usan datos reales, staging ni production.

## Decisión 2B-AG103 — siguiente frontera tras jerarquía Product/Admin-Engine

AG103 se ejecuta después de publicar ADR-012. La decisión es no implementar
tests/guards directamente todavía.

Opciones evaluadas:

1. Implementar tests/guards directamente: no recomendado todavía. ADR-010,
   ADR-011 y ADR-012 ya fijan la dirección, pero aún falta un plan técnico que
   separe capas, archivos, assertions, comandos, stops y rollback.
2. Preparar plan técnico detallado de tests/guards: recomendado. Es la frontera
   más segura antes de tocar `test/`, `lib/`, `supabase/`, schema, seeds,
   catálogo real o `/conversations`.
3. Preparar schema/migración: necesario más adelante si el esquema actual no
   cubre el contrato, pero debe venir después del plan de tests/guards.
4. Preparar seeds sintéticos: útil para development, pero debe venir después de
   cerrar tests/guards y contrato técnico.
5. Avanzar a `/conversations`: diferido. Depende de catálogo seguro, guards
   implementados, validación backend y especialistas sintéticos/controlados.

Recomendación:

```text
2B-AG104 — preparar plan técnico implementación tests/guards catálogo producto
```

AG104 debe definir, sin implementar todavía:

- capas de guards;
- tests de arquitectura;
- tests de contrato backend;
- tests de frontera frontend/Product;
- tests de route guards;
- tests de ausencia de Supabase directo;
- tests de ausencia de `service_role` en cliente;
- tests anti `SELECT *`;
- tests anti agentes internos de desarrollo;
- tests anti agentes Admin/Engine;
- tests anti prompts y campos prohibidos;
- tests de catálogo roto y fallo cerrado;
- tests de compatibilidad con jerarquía Product/Admin de ADR-012;
- archivos permitidos;
- comandos permitidos;
- stops;
- rollback;
- prohibición de poblar `specialist_catalog`;
- prohibición de Supabase remoto y datos reales.

AG103 no implementa código, no crea tests, no toca Supabase, no ejecuta SQL, no
puebla `specialist_catalog`, no crea agentes reales ni especialistas reales, no
registra `/conversations`, no usa datos reales, no toca staging/production y no
hace push.

## Plan 2B-AG104 — implementación futura de tests/guards

El plan técnico documental de implementación futura queda definido en:

```text
docs/stasisly_definition/implementation_plans/2B-AG104-product-catalog-tests-guards-plan.md
```

AG104 no implementa tests ni código. Su función es separar capas, assertions,
archivos permitidos, comandos permitidos, criterios de stop y rollback antes de
autorizar cualquier cambio en `test/`, `lib/`, `supabase/`, schema, seeds,
catálogo real o `/conversations`.

Readiness documental:

```text
PRODUCT CATALOG TESTS GUARDS TECHNICAL PLAN READY
```

## Decisión 2B-AG109 — route/fail-closed guards y schema futuro

AG109 ejecuta el siguiente bloque local-safe de guards del catálogo producto:

- route guards: `/conversations` y variantes siguen sin registrarse;
- fail-closed guards: payloads inseguros, superficies inválidas, campos
  prohibidos y errores backend reales no producen fallback demo;
- decisión schema: el schema local actual no debe usarse todavía para poblar
  catálogo sintético development.

Decisión de schema:

```text
SCHEMA NEEDS FUTURE MIGRATION BEFORE SYNTHETIC CATALOG
```

La decisión se documenta en:

```text
docs/stasisly_definition/implementation_plans/2B-AG109-product-catalog-schema-decision.md
```

Consecuencia: el siguiente paquete prudente es diseñar la migración futura del
catálogo producto antes de preparar catálogo sintético, seeds, fixtures,
especialistas reales o `/conversations`.

AG109 no toca Supabase, no ejecuta SQL, no crea migraciones, no puebla
`specialist_catalog`, no registra `/conversations`, no usa datos reales y no
toca staging/production.

# ADR-010 — Catálogo producto de especialistas conversables

## Estado

Aprobada conceptualmente / Pendiente de implementación.

## Contexto

ADR-008 define la futura ruta producto `/conversations`, pero no la implementa.
ADR-009 separa Product Surface, Wizard/Development Surface y Admin/Engine
Surface, y distingue tres familias de agentes: agentes internos de desarrollo,
especialistas producto y agentes Admin/Engine.

Antes de implementar `/conversations`, Stasisly debe definir y proteger el
catálogo producto de especialistas conversables. Sin esta frontera, la ruta
producto podría acabar exponiendo agentes internos, agentes Admin/Engine,
fixtures, prompts internos, roles técnicos o datos no sanitizados.

AG90 es documental. No crea especialistas reales, no puebla
`specialist_catalog`, no ejecuta SQL, no registra `/conversations`, no toca
Supabase, no usa datos reales y no activa staging/production.

## Decisión

Antes de implementar `/conversations` producto, Stasisly debe definir y proteger
el catálogo producto de especialistas conversables.

`specialist_catalog` producto solo puede contener especialistas producto
sanitizados, publicados, autorizados por tier y validados por backend.

No puede contener agentes internos de desarrollo, agentes Admin/Engine, comités
técnicos, prompts internos, fixtures, usuarios sintéticos ni roles admin.

## Qué es un especialista producto

Un especialista producto es una entidad conversable, visible o seleccionable por
el usuario final dentro de Product Surface, diseñada para ayudar en una rama
funcional de Stasisly bajo reglas de producto, permisos, tier, publicación y
validación backend.

Debe cumplir:

- estar sanitizado;
- estar publicado;
- tener área producto asignada;
- tener estado de disponibilidad;
- tener tier o acceso definido;
- no exponer prompts internos;
- no exponer arquitectura interna;
- no exponer rol de desarrollo;
- no exponer rol Admin/Engine;
- estar validado por backend antes de crear sesión o conversación.

## Qué no es un especialista producto

No son especialistas producto:

- agentes internos de desarrollo;
- comités técnicos;
- agentes AAA de arquitectura, auditoría, seguridad, QA o producto interno;
- agentes Admin/Engine;
- herramientas de métricas;
- herramientas de soporte interno;
- roles admin;
- fixtures;
- usuarios sintéticos;
- prompts internos;
- orquestadores técnicos no expuestos;
- Stasis Engine interno.

## Familias prohibidas en specialist_catalog producto

`specialist_catalog` producto no debe contener:

- agentes del equipo AAA de desarrollo;
- agentes Admin/Engine;
- roles admin;
- roles development;
- comités internos;
- prompts internos;
- fixtures development;
- identidades sintéticas;
- herramientas internas;
- operadores técnicos;
- nombres de archivos internos;
- identificadores sensibles.

## Áreas producto iniciales

Áreas producto candidatas:

- Stasis;
- Salud;
- Nutrición;
- Entrenamiento;
- Wellness.

Subáreas futuras de Wellness:

- Descanso/Sueño;
- Mindfulness;
- hábitos;
- estrés;
- recuperación;
- bienestar diario.

Estas áreas son conceptuales. AG90 no cierra todo el equipo final ni crea una
plantilla masiva de especialistas.

## Especialistas iniciales candidatos

Candidatos conceptuales de alto nivel:

- Stasis — Coordinador producto principal;
- Salud — Orientador salud general;
- Nutrición — Orientador nutricional;
- Entrenamiento — Orientador entrenamiento;
- Wellness — Orientador wellness;
- Descanso/Sueño — Orientador descanso;
- Mindfulness — Guía mindfulness.

Estos candidatos no son registros reales, no son nombres definitivos y no deben
insertarse en `specialist_catalog` sin aprobación posterior.

## Campos permitidos en specialist_catalog producto

Campos permitidos conceptualmente, sujetos a diseño final de esquema:

- id público o identificador interno no sensible;
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
- `created_at`;
- `updated_at`.

El frontend no debe interpretar campos de catálogo como autorización final. La
autorización real pertenece al backend.

## Campos prohibidos en specialist_catalog producto

`specialist_catalog` producto no debe exponer:

- system prompts;
- developer prompts;
- internal prompts;
- chain of thought;
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
- fixtures;
- synthetic user identifiers;
- permisos internos;
- ownership;
- detalles RLS explotables;
- métricas internas;
- datos de otros usuarios.

## Publicación, despublicación y disponibilidad

Estados conceptuales de publicación:

- `draft`;
- `review`;
- `published`;
- `unpublished`;
- `disabled`;
- `maintenance`.

Estados conceptuales de disponibilidad:

- `available`;
- `limited`;
- `unavailable`;
- `coming_soon`.

Regla: solo especialistas `published` y `available` o `limited`, con tier
autorizado, pueden aparecer como seleccionables en Product Surface.

## Tiers, suscripción y acceso

Tiers conceptuales:

- `free`;
- `pro`;
- `vip`;
- `enterprise`;
- futuro interno no producto, solo si se aprueba posteriormente y sin aparecer
  como tier seleccionable por usuario final.

El frontend no decide autorización final. El backend debe validar
`access_tier`, suscripción, usuario, superficie y permisos antes de permitir
crear sesión o enviar mensaje.

AG90 no implementa suscripción, pagos ni membresías.

## Relación con /conversations

`/conversations` producto solo puede abrir conversaciones con especialistas
producto autorizados por backend.

Reglas:

- `create-own-chat-session` solo puede aceptar o seleccionar especialistas
  producto autorizados por backend;
- `selectableSpecialistId` debe referir a un especialista producto publicado,
  sanitizado y permitido;
- `list-selectable-specialists` solo debe devolver catálogo producto permitido
  para ese usuario, superficie y tier;
- ningún agente interno de desarrollo puede ser conversable en Product
  `/conversations`;
- ningún agente Admin/Engine puede ser conversable en Product
  `/conversations`;
- ningún fixture o usuario sintético puede aparecer como conversación producto.

## Relación con Product Surface

El catálogo producto pertenece a Product Surface.

Solo puede alimentar interfaces de usuario final si el backend ya filtró por
publicación, disponibilidad, tier, superficie y permisos. Product Surface no
debe exponer información interna del especialista, prompts, roles técnicos ni
identificadores sensibles.

## Relación con Wizard/Development Surface

Wizard/Development Surface puede tener documentación, prompts y herramientas
internas para construir y auditar especialistas, pero no puede contaminar
`specialist_catalog` producto.

Los agentes internos de desarrollo viven en Wizard/Development Surface y no son
especialistas producto.

## Relación con Admin/Engine Surface

Admin/Engine Surface puede gestionar, auditar o analizar especialistas si se
aprueba una herramienta admin futura. Esa gestión no convierte agentes
Admin/Engine en especialistas producto.

Los agentes Admin/Engine no aparecen en `specialist_catalog` producto y no
conversan con usuarios finales desde Product Surface.

## Relación con wearables futuros

Wearables futuros no abren catálogo propio en esta fase.

Cualquier interacción con especialistas desde Apple Watch, Wear OS o Garmin
requerirá ADR o paquete específico posterior. Las extensiones wearable deben
heredar reglas de Product Surface y no pueden exponer agentes internos de
desarrollo ni agentes Admin/Engine.

## Validación backend obligatoria

Antes de listar, crear sesión o enviar mensaje, backend debe validar:

- usuario autenticado;
- ownership;
- `surface = Product`;
- especialista existe;
- especialista está publicado;
- disponibilidad del especialista;
- `access_tier` del especialista;
- suscripción o tier del usuario;
- especialista no es interno development;
- especialista no es Admin/Engine;
- especialista está permitido para `/conversations`;
- sesión pertenece al usuario;
- mensajes pertenecen a la sesión;
- catálogo íntegro, consistente y no roto.

## Guards/tests futuros obligatorios

Tests y guards futuros:

- no agentes internos en Product Surface;
- no agentes Admin/Engine en Product Surface;
- no agentes internos en `specialist_catalog` producto;
- no agentes Admin/Engine en `specialist_catalog` producto;
- `list-selectable-specialists` filtra por `published`;
- `list-selectable-specialists` filtra por `access_tier`;
- `list-selectable-specialists` no devuelve listas parciales si el catálogo está
  roto;
- `create-own-chat-session` rechaza especialista no publicado;
- `create-own-chat-session` rechaza especialista no autorizado por tier;
- `create-own-chat-session` rechaza internal/dev/admin agents;
- `send-user-message` valida ownership y sesión;
- ningún contrato producto usa `SELECT *`;
- ningún contrato producto expone campos prohibidos;
- ningún contrato mezcla Product Surface, Wizard/Development Surface y
  Admin/Engine Surface;
- Product UI no pasa `userId`, `ownerUserId`, `role` ni permisos;
- Product UI no usa Supabase directo;
- Product UI no usa `service_role`;
- Product UI no usa fixtures;
- Product UI no usa fallback demo ante errores reales.

AG90 no implementa tests.

## Seguridad y privacidad

El catálogo producto debe aplicar:

- minimización de datos;
- nombres y descripciones sanitizadas;
- ausencia de prompts internos;
- ausencia de permisos internos;
- ausencia de datos de otros usuarios;
- validación backend obligatoria;
- separación clara entre Product, Wizard/Development y Admin/Engine;
- trazabilidad de publicación y despublicación;
- revisión de seguridad antes de usar datos reales.

## Alcance autorizado

AG90 autoriza solo documentación:

- crear esta ADR;
- actualizar referencias breves en ADR-008, ADR-009 y documentos maestros si
  procede;
- registrar AG90 en `SESSION_TRACKER.md`.

## Alcance no autorizado

AG90 no autoriza:

- código;
- tests;
- cambios en `supabase/`;
- SQL;
- poblar `specialist_catalog`;
- crear especialistas reales;
- crear fixtures;
- rutas;
- registro de `/conversations`;
- conexión de producto;
- datos reales;
- staging;
- production;
- deploy;
- migraciones;
- push.

## Consecuencias

Consecuencias positivas:

- evita implementar `/conversations` sobre una frontera incompleta;
- protege Product Surface;
- protege `specialist_catalog` producto;
- separa especialistas producto de desarrollo y Admin/Engine;
- prepara criterios para backend, tiers, publicación y tests.

Costes:

- retrasa implementación directa de `/conversations`;
- exige revisión de catálogo antes de poblar datos;
- requiere una fase posterior de aprobación e implementación.

## Riesgos

Riesgos altos:

- exponer agentes internos como especialistas producto;
- exponer agentes Admin/Engine como especialistas producto;
- poblar catálogo sin validación backend;
- permitir conversaciones con entidades no publicadas o no autorizadas.

Riesgos medios:

- definir demasiados especialistas iniciales antes de validar producto;
- mezclar disponibilidad con autorización;
- usar tiers solo en frontend;
- contaminar Product Surface con fixtures.

Riesgos bajos:

- sobre-documentar antes de implementar;
- requerir ajustes de nombres antes del primer catálogo real.

## Relación con ADR-008

ADR-008 define `/conversations` producto y la deja pendiente de implementación.
ADR-010 establece que antes de implementar `/conversations` debe definirse el
catálogo producto de especialistas conversables.

## Relación con ADR-009

ADR-009 separa Product Surface, Wizard/Development Surface y Admin/Engine
Surface. ADR-010 aplica esa separación al catálogo producto y evita mezclar las
tres familias de agentes.

## Relación con ADR-012

ADR-012 propone que Product Surface y Admin/Engine Surface usen jerarquías de
agentes, no listas planas. Para ADR-010, esto significa que
`specialist_catalog` producto podrá representar una jerarquía producto solo si
un paquete posterior lo aprueba, y nunca podrá mezclar agentes internos de
desarrollo ni agentes Admin/Engine.

## Estado de implementación

No implementado.

No existe autorización en esta ADR para poblar `specialist_catalog`, ejecutar
SQL, crear especialistas reales, registrar `/conversations`, tocar Supabase,
usar datos reales, activar staging, activar production, desplegar cambios ni
hacer push.

## Revisión 2B-AG91

AG91 revisa y aprueba conceptualmente esta ADR con ajustes menores
documentales. La decisión central no cambia: antes de implementar
`/conversations`, Stasisly debe proteger `specialist_catalog` producto con una
frontera explícita entre especialistas producto, agentes internos de desarrollo
y agentes Admin/Engine.

Resultado de revisión:

- decisión: ADR-010 aprobada con ajustes menores;
- readiness: `PRODUCT SPECIALISTS CATALOG ADR APPROVED WITH MINOR CHANGES`;
- estado actualizado a `Aprobada conceptualmente / Pendiente de implementación`;
- se aclara que el tier interno futuro no es producto;
- se refuerza la obligación de catálogo íntegro y no roto;
- se refuerzan guards futuros contra `SELECT *`, campos prohibidos y mezcla de
  superficies;
- no se implementa código;
- no se ejecuta SQL;
- no se puebla `specialist_catalog`;
- no se crean especialistas reales;
- no se registra `/conversations`;
- no se toca Supabase;
- no se usan datos reales, staging ni production.

## Decisión 2B-AG94 — siguiente frontera

AG94 decide la siguiente frontera tras publicar ADR-010 en Git. La decisión es
no implementar catálogo producto directamente todavía.

Opciones evaluadas:

1. Implementar catálogo producto directamente: no recomendado todavía, porque
   faltan guards, contratos y tests que impidan contaminar Product Surface.
2. Preparar guards/tests/contracts previos: recomendado como siguiente
   frontera.
3. Preparar schema/migración: necesario más adelante, pero debe venir después
   de contratos y guards.
4. Preparar seeds sintéticos: útil para development, pero debe venir después de
   contratos y guards.
5. Implementar `/conversations`: sigue diferido hasta que exista catálogo
   producto seguro y validación backend suficiente.

Recomendación:

`2B-AG95 — preparar plan guards/contracts catálogo producto especialistas`.

AG95 materializa esta recomendación en:

```text
docs/stasisly_definition/adr/ADR-011-product-specialists-catalog-guards-contracts.md
```

ADR-011 no implementa guards ni tests. Define el contrato público permitido, el
contrato interno prohibido, los guards mínimos y el orden recomendado antes de
schema, seeds, catálogo real o `/conversations`.

AG95 debe definir, sin implementar todavía:

- contrato público permitido para especialistas producto;
- campos permitidos y campos prohibidos;
- reglas anti `SELECT *`;
- reglas anti agentes internos de desarrollo;
- reglas anti agentes Admin/Engine;
- reglas anti prompts internos;
- reglas anti fixtures;
- reglas anti datos reales;
- validación backend esperada;
- validación frontend esperada;
- tests futuros obligatorios;
- stops y rollback.

AG94 no autoriza código, tests, SQL, migraciones, seeds, especialistas reales,
poblado de `specialist_catalog`, registro de `/conversations`, conexión de
producto, datos reales, staging ni production.

## Decisión 2B-AG109 — schema futuro antes de catálogo sintético

AG109 implementa guards locales adicionales de rutas/fail-closed y revisa el
schema local visible frente a ADR-010, ADR-011 y ADR-012.

Decisión:

```text
SCHEMA NEEDS FUTURE MIGRATION BEFORE SYNTHETIC CATALOG
```

Motivo resumido: `public.specialist_catalog` existe como tabla cerrada y
deny-all, pero todavía no representa todo el contrato conceptual de catálogo
producto: superficie Product explícita, jerarquía producto, `supported_surfaces`,
campos sanitizados auxiliares y compatibilidad completa con tiers/publicación.

La decisión completa queda registrada en:

```text
docs/stasisly_definition/implementation_plans/2B-AG109-product-catalog-schema-decision.md
```

AG109 no autoriza poblar `specialist_catalog`, crear especialistas reales,
crear fixtures persistentes, registrar `/conversations`, ejecutar SQL ni crear
migraciones.

## Diseño 2B-AG110 — migración futura del catálogo producto

AG110 prepara el diseño documental de la futura migración del catálogo producto:

```text
docs/stasisly_definition/implementation_plans/2B-AG110-product-catalog-migration-design.md
```

La decisión principal es mantener `specialist_catalog` como frontera
backend-only, ampliar su schema futuro con campos producto sanitizados,
superficie Product explícita, jerarquía compatible con ADR-012, constraints,
índices y RLS/grants cerrados para cliente.

AG110 no crea migración, no toca Supabase, no ejecuta SQL, no puebla
`specialist_catalog`, no crea seeds, no registra `/conversations`, no conecta
producto y no usa datos reales.

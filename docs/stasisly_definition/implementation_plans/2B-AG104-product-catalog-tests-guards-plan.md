# 2B-AG104 — Plan técnico tests/guards catálogo producto

## Estado

Plan técnico aprobado conceptualmente / Pendiente de implementación.

No implementado. Aprobado en revisión documental AG105 antes de tocar código,
tests, Supabase, rutas, schema, seeds, catálogo real o `/conversations`.

Readiness objetivo de este documento:

```text
PRODUCT CATALOG TESTS GUARDS TECHNICAL PLAN READY
```

## Contexto

ADR-008 define la futura ruta producto `/conversations`, pero no la implementa.
ADR-009 separa Product Surface, Wizard/Development Surface y Admin/Engine
Surface. ADR-010 define el catálogo producto de especialistas conversables.
ADR-011 define guards y contratos para proteger ese catálogo. ADR-012 añade la
jerarquía conceptual Product/Admin-Engine.

AG104 prepara el plan técnico para una futura implementación de tests/guards.
No implementa ningún test ni cambia comportamiento de la app.

## Objetivo

Definir el paquete técnico mínimo futuro para probar que el catálogo producto de
especialistas conversables:

- solo expone contrato público autorizado;
- no mezcla agentes internos, Wizard/Development ni Admin/Engine;
- no usa Supabase directo desde Product Surface;
- no expone `service_role`, tokens, prompts, ownership ni permisos internos;
- no usa `SELECT *` para construir respuestas producto;
- falla cerrado ante catálogo roto;
- respeta publicación, disponibilidad, tiers y jerarquía ADR-012;
- mantiene `/conversations` bloqueado hasta aprobación específica.

## Principios de implementación futura

- Implementar primero guards automatizados, no catálogo real.
- Mantener Product Surface separada de Wizard/Development y Admin/Engine.
- Probar allowlists explícitas, no ausencia accidental de campos.
- Tratar todo dato de catálogo como no confiable hasta validación backend.
- Fallar cerrado ante contradicción, dato incompleto o superficie mezclada.
- No transformar errores reales en fallback demo.
- No poblar `specialist_catalog` en este paquete.
- No introducir especialistas reales, agentes reales, seeds ni fixtures
  persistentes.
- No registrar rutas producto ni dev routes nuevas salvo aprobación posterior.
- No conectar remoto, staging, production, datos reales ni auth real.

## Capas de protección

La futura implementación debe separar seis capas:

1. Architecture guards.
2. Backend contract guards.
3. Frontend/Product boundary guards.
4. Route guards.
5. Data/catalog integrity guards.
6. Agent hierarchy/surface guards.

Cada capa debe poder fallar de forma independiente y explicar qué frontera se ha
roto.

## Tests architecture guards

Los tests de arquitectura futuros deben verificar que Product Surface:

- no importa Supabase directo;
- no usa `Supabase.instance.client`;
- no usa `service_role`;
- no accede a tablas directamente;
- no embebe SQL;
- no usa tokens sintéticos;
- no lee fixtures productivos;
- no depende de `.env` real ni secretos;
- no convierte errores backend en demo silencioso;
- no usa datasources legacy inseguros;
- no reactiva rutas legacy inseguras;
- no interpreta `/chat/:id` como `sessionId`;
- no conecta `/orchestrator/chat`;
- no mezcla Wizard/Development con Product;
- no mezcla Admin/Engine con Product.

La implementación futura debe limitar estos tests a rutas y patrones concretos
para evitar falsos positivos por documentación, comentarios o ejemplos
históricos.

## Tests backend contract guards

Los tests de contrato backend futuros deben cubrir como mínimo:

- `list-selectable-specialists` devuelve solo contrato público permitido;
- `create-own-chat-session` valida `selectableSpecialistId` en backend;
- `send-user-message` no depende de catálogo no validado;
- ninguna respuesta pública expone `userId`, `ownerUserId`,
  `specialistId` interno, roles internos, permisos internos, prompts,
  Admin/Engine, Wizard/Development, logs ni detalles RLS explotables;
- los errores son seguros y no filtran existencia interna;
- no hay fallback demo ante error real;
- no se usa `SELECT *` para especialistas producto;
- las respuestas se construyen con allowlist explícita.

Si todavía no existe backend real para algún contrato, la futura implementación
debe usar tests contractuales simulados o fixtures transaccionales locales
controlados, nunca seeds persistentes.

## Tests frontend Product boundary

Los tests de frontera frontend/Product futuros deben demostrar que el frontend:

- consume solo contrato backend sanitizado;
- no decide autorización final;
- no construye especialistas a partir de datos internos;
- no pasa `userId`, `ownerUserId`, `role`, permisos, `service_role`,
  `specialistId` interno, prompts ni metadata sensible;
- maneja estado vacío o error de forma segura;
- no cae a demo silencioso ante error real;
- no muestra IDs sensibles, prompts o errores técnicos crudos;
- no mezcla superficies Product/Wizard/Admin.

## Tests route guards

Los route guards futuros deben confirmar que:

- `/conversations` sigue sin registrarse hasta aprobación explícita;
- si se aprueba en el futuro, pertenece solo a Product Surface;
- `/chat/:id` no se usa como ruta de sesión;
- `/chat/:id` conserva semántica heredada de `agentId` hasta retirada o
  migración aprobada;
- `/orchestrator/chat` no se conecta al flujo producto;
- dev routes siguen dev-only;
- dev routes no están disponibles en staging ni production;
- Product routes no usan synthetic tokens, fixtures ni datos locales de prueba.

## Tests no Supabase directo

Los guards futuros deben buscar en archivos producto autorizados:

- `Supabase.instance.client`;
- imports directos de paquetes Supabase en Product Surface;
- acceso directo a tablas;
- SQL embebido;
- llamadas directas a RPC desde UI;
- construcción manual de headers de autorización con tokens reales.

Un hallazgo en Product Surface debe bloquear la implementación salvo que el
paquete futuro autorice explícitamente una frontera backend segura.

## Tests no service_role

Los tests futuros deben asegurar que:

- `service_role` no aparece en Flutter ni Product Surface;
- no existe `SUPABASE_SERVICE_ROLE_KEY` en código cliente;
- no se versionan tokens ni secretos;
- no se exponen bearer tokens en contratos públicos;
- ningún modelo público contiene autoridad administrativa.

El uso de service role solo puede existir en backend controlado y nunca en
Flutter, contratos públicos ni tests productivos que simulen cliente.

## Tests no SELECT *

Los tests futuros deben fallar si el catálogo producto usa `SELECT *` o
equivalentes que autoexpongan columnas.

Reglas:

- toda query producto debe usar columnas explícitas;
- todo DTO público debe tener allowlist declarada;
- un campo nuevo de schema no aparece automáticamente en Product Surface;
- cada campo expuesto necesita autorización documental;
- `select=*` no debe ser aceptable para especialistas producto.

Si PostgREST o un cliente genera `select=*`, el test debe detectar el contrato
como no apto para Product Surface.

## Tests anti agentes internos

Los guards futuros deben bloquear:

- agentes AAA internos;
- comités técnicos;
- Director de Proyecto, Product Owner interno y Revisor de Coherencia;
- roles de arquitectura, seguridad, privacidad, QA, DevOps, AppSec y costes;
- orquestadores técnicos internos;
- prompts de desarrollo;
- entidades Wizard/Development Surface.

Ninguna entidad interna del equipo de construcción puede convertirse en
especialista producto conversable.

## Tests anti Admin/Engine

Los guards futuros deben bloquear:

- Admin/Engine coordinator;
- Data & Analytics;
- Usuarios & Soporte;
- Suscripciones & Negocio;
- Riesgo, Calidad y Compliance;
- Operaciones Stasis Engine;
- métricas internas;
- herramientas admin;
- operaciones internas de motor;
- datos operativos no producto.

Admin/Engine puede existir como superficie interna futura, pero no dentro de
`specialist_catalog` producto.

## Tests anti prompts/campos prohibidos

Los tests futuros deben detectar y bloquear:

- system prompts;
- developer prompts;
- internal prompts;
- chain of thought;
- instrucciones internas completas;
- políticas internas completas;
- tokens;
- `service_role`;
- connection strings;
- detalles RLS explotables;
- IDs internos sensibles;
- ownership;
- permisos;
- roles admin/dev;
- logs internos;
- errores técnicos crudos;
- metadata no sanitizada;
- datos de usuarios;
- health data no autorizado.

La respuesta pública debe explicar capacidades y límites sin revelar
instrucciones internas ni secretos.

## Tests catálogo roto/fail closed

Los tests futuros deben cubrir estos casos:

- catálogo apunta a especialista inexistente;
- especialista existe pero falta entrada de catálogo;
- `surface` inválida;
- Product/Admin/Wizard mezclados;
- `tier` inválido;
- `availability_status` inválido;
- falta un campo público obligatorio;
- aparece un campo prohibido;
- la allowlist pública no puede construirse;
- el backend devuelve error técnico bruto;
- hay lista parcial con registros válidos e inválidos.

Resultado esperado:

- fail closed;
- estado vacío o error seguro;
- sin lista parcial insegura;
- sin fallback demo;
- sin exposición de errores internos.

## Tests publicación/disponibilidad/tier

La futura implementación debe validar:

- `published + available + tier autorizado` es seleccionable;
- `published + limited + tier autorizado` puede ser seleccionable si la regla
  `limited` lo permite;
- `draft`, `review`, `unpublished`, `disabled`, `maintenance` y `unavailable`
  no son seleccionables;
- `coming_soon` no es conversable salvo decisión futura específica;
- tier superior al usuario no es seleccionable;
- tier inválido falla cerrado;
- el frontend no decide autorización final de tier.

## Tests jerarquía ADR-012

Los tests futuros deben comprobar que:

- Product Surface puede tener coordinador, jefes y especialistas conceptuales;
- esa jerarquía no implica permisos totales;
- coordinador Product no equivale a `service_role`;
- jefes Product no saltan allowlists;
- especialistas no cruzan superficies;
- Admin/Engine no aparece en Product Surface;
- Wizard/Development no aparece en Product Surface;
- un jefe o coordinador conversable requiere decisión futura específica;
- la jerarquía no sustituye validación backend.

## Archivos permitidos para implementación futura

La implementación futura, si se aprueba por paquete separado, debería limitarse
inicialmente a:

- `test/architecture/**`;
- `test/features/**`;
- `test/core/**`;
- `lib/features/conversations/**` solo si un paquete futuro lo autoriza;
- `lib/features/product_specialists/**` solo si un paquete futuro lo autoriza;
- `lib/core/contracts/**` si existe o se crea en un paquete futuro;
- `lib/core/routing/**` solo para guards, no para registrar ruta producto sin
  aprobación;
- `docs/SESSION_TRACKER.md`.

## Archivos prohibidos para implementación futura

El primer paquete futuro de tests/guards no debe tocar:

- `supabase/migrations/**`;
- `supabase/functions/**`;
- configuración staging/production;
- `.env`;
- `.env.example` salvo aprobación explícita;
- datos de `specialist_catalog`;
- seeds reales;
- fixtures persistentes;
- `auth.users`;
- plataformas `android/`, `ios/`, `web/`, `macos/`, `windows/`, `linux/`;
- CI/CD;
- stores reales;
- pagos;
- wearables;
- Panel Admin/Engine productivo.

## Comandos permitidos para implementación futura

Comandos seguros esperados:

```bash
flutter analyze --no-fatal-infos
flutter test
git diff --check
git status --short
git status -sb
```

## Comandos prohibidos

Sin aprobación específica, no ejecutar:

```bash
supabase link
supabase db push
supabase migration up
supabase migration up --linked
supabase db reset
supabase functions deploy
supabase secrets set
supabase db pull
git push
git rebase
git reset --hard
git clean
```

## Orden técnico recomendado

1. Aprobar AG104.
2. Commit/push documental del plan, si el usuario lo solicita.
3. Implementar architecture guards.
4. Implementar frontend Product boundary guards.
5. Implementar backend contract guards simulados o mockeados si no hay Supabase
   autorizado.
6. Implementar route guards.
7. Implementar tests fail-closed con fixtures locales transaccionales
   controlados.
8. Ejecutar analyzer/tests.
9. Diseñar schema/migración en paquete posterior, si procede.
10. Diseñar seeds development en paquete posterior, si procede.
11. Validar catálogo sintético en development, si procede.
12. Planificar `/conversations` solo después de guards verdes.

## Readiness futuro esperado

La implementación futura solo podrá declararse:

```text
PRODUCT CATALOG TESTS GUARDS IMPLEMENTED
```

si:

- los tests/guards existen;
- `flutter analyze --no-fatal-infos` pasa o deja infos justificadas;
- `flutter test` pasa;
- no se usó Supabase remoto;
- no se creó SQL, migración, seed ni datos reales;
- no se pobló `specialist_catalog`;
- no se crearon agentes reales ni especialistas reales;
- no se registró `/conversations`;
- los guards cubren ADR-010, ADR-011 y ADR-012.

## Criterios de stop

Detener la implementación futura si aparece cualquiera de estos casos:

- necesidad de tocar Supabase remoto;
- necesidad de crear migraciones;
- necesidad de poblar `specialist_catalog`;
- necesidad de registrar `/conversations`;
- necesidad de conectar auth real;
- necesidad de usar datos reales;
- aparición de secreto, token o `service_role` en cliente;
- duda sobre si un agente pertenece a Product, Wizard o Admin/Engine;
- test que requiere fixture persistente;
- intento de convertir error real en demo.

## Rollback

El rollback futuro debe ser simple:

- revertir únicamente archivos de tests/guards y documentación del paquete;
- no revertir cambios ajenos;
- no tocar `.env`;
- no tocar Supabase remoto;
- no borrar migraciones;
- no limpiar datos reales porque no deben existir en este paquete.

Si se crean fixtures locales en un paquete posterior, deben ser
transaccionales o tener cleanup verificable a cero.

## Fuera de alcance

AG104 no autoriza:

- código;
- tests;
- Supabase;
- SQL;
- migraciones;
- seeds;
- fixtures persistentes;
- poblar `specialist_catalog`;
- crear especialistas reales;
- crear agentes reales;
- registrar `/conversations`;
- conectar producto;
- auth real;
- staging;
- production;
- datos reales;
- deploy;
- push.

## Relación con ADR-008

ADR-008 mantiene `/conversations` como ruta producto futura. AG104 no la
registra ni la desbloquea; solo define guards previos para evitar que esa ruta
nazca conectada a catálogo inseguro.

## Relación con ADR-009

ADR-009 separa Product Surface, Wizard/Development Surface y Admin/Engine
Surface. AG104 convierte esa separación en tests/guards futuros verificables.

## Relación con ADR-010

ADR-010 define qué puede ser especialista producto conversable. AG104 define
cómo probar en el futuro que solo ese contrato entra en Product Surface.

## Relación con ADR-011

ADR-011 define los guards y contratos normativos. AG104 los traduce a un plan
técnico de pruebas por capas.

## Relación con ADR-012

ADR-012 define jerarquía Product/Admin-Engine. AG104 añade guards futuros para
que la jerarquía no mezcle superficies ni conceda autoridad implícita.

## Revisión 2B-AG105

AG105 revisa y aprueba formalmente este plan técnico con ajustes menores
documentales.

Decisión:

```text
PLAN TÉCNICO APROBADO CON AJUSTES MENORES
```

Readiness:

```text
PRODUCT CATALOG TESTS GUARDS TECHNICAL PLAN APPROVED WITH MINOR CHANGES
```

Ajustes realizados:

- estado actualizado a aprobado conceptualmente / pendiente de implementación;
- cierre formal de AG104 registrado;
- se confirma que no se implementan tests todavía;
- se confirma que `/conversations` sigue bloqueado;
- se confirma que no se toca Supabase, SQL, schema, seeds ni datos reales;
- se confirma que `specialist_catalog` no se puebla;
- se confirma que no se crean agentes reales ni especialistas reales;
- se confirma que Product, Wizard/Development y Admin/Engine siguen separados.

AG105 no implementa código, no crea tests, no toca `lib/`, no toca `test/`, no
toca Supabase, no ejecuta SQL, no crea migraciones, no crea seeds, no registra
`/conversations`, no usa datos reales, no toca staging/production y no hace
push.

## Estado de implementación

No implementado.

AG104/AG105 son solo documentación, planificación técnica y aprobación
documental. El siguiente paso recomendado es baseline/commit documental antes
de implementar tests/guards.

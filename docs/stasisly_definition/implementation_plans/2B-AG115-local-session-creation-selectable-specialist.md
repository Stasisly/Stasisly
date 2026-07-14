# 2B-AG115 — Creación local de sesión mediante selectableSpecialistId

## Estado

Completado y validado localmente. El cierre Git queda confirmado por el commit
y push registrados al final del paquete.

## 1. Objetivo y baseline

Validar que `create-own-chat-session` solo cree sesiones locales a partir de un
identificador público seleccionable, derive ownership de Auth y no exponga ni
acepte autoridad interna.

Baseline inicial limpio:

```text
4a1153f test: add local synthetic product catalog seeds
main sincronizada con origin/main
Supabase local disponible en 127.0.0.1
```

## 2. Contrato de entrada

La única forma admitida es:

```json
{"selectableSpecialistId":"<specialist_catalog.id>"}
```

El parser exige objeto JSON, una única clave, string UUID válido y ningún campo
adicional. Se rechazan IDs vacíos o malformados, tipos incorrectos y campos como
`specialistId`, `internalSpecialistId`, `catalogId`, `agentId`, `userId`,
`ownerUserId`, `sessionId`, `role`, `permissions`, surface, estado, tier o
prompts.

## 3. Significado y resolución del identificador

`selectableSpecialistId` representa exclusivamente `specialist_catalog.id`, la
identidad pública estable del catálogo. El cliente no conoce ni envía
`specialists.id` ni `specialist_catalog.specialist_id`.

El backend consulta el catálogo por el ID público, valida la fila exacta,
resuelve `specialist_id`, comprueba que la identidad interna existe y almacena
esa identidad interna en `chat_sessions.specialist_id`.

## 4. Predicado seleccionable final

La consulta exige simultáneamente:

```text
id = selectableSpecialistId
is_published = true
publication_status = published
availability_status = available
supported_surfaces = {product}
is_conversable = true
product_area ∈ stasis|health|nutrition|training|wellness
access_tier ∈ free|pro|vip
specialist_id UUID válido y existente
```

No se usa la categoría legacy de `specialists` como autoridad Product. Draft,
unpublished, unavailable, no conversable, surface no Product o ID inexistente
producen `invalidSelectableSpecialist` opaco. Contratos internos corruptos
fallan como `contractViolation` o `backendMisconfigured`.

## 5. Ownership

La función valida el JWT contra Auth local y obtiene el owner de la respuesta
validada. Después exige que exista el perfil `public.users` y usa ese UUID para
el insert. El payload nunca participa en ownership.

El harness utilizó dos usuarios sintéticos temporales:

- usuario A creó sesiones Stasis y Kitesurf con owner A;
- usuario B creó Kitesurf con owner B;
- usuario B no pudo enviar `ownerUserId` ni asignarse owner A;
- `userId`, roles y permisos se rechazaron con HTTP 400.

## 6. Tiers

- `free`: permite creación si se cumple todo el predicado.
- `pro`: devuelve `proLocked` (HTTP 403).
- `vip`: devuelve `proLocked` (HTTP 403).
- tier desconocido: falla cerrado como violación de contrato.

No se crean suscripciones ni entitlements sintéticos. `pro` y `vip` están
catalogados y visibles contractualmente, pero la creación permanece bloqueada
hasta implementar autorización comercial aprobada.

## 7. Casos positivos

El flujo HTTP local validó:

- Stasis: dos llamadas crean dos `sessionId` distintos;
- Kitesurf: sesión válida para usuario A;
- Kitesurf: sesión independiente para usuario B;
- cada sesión queda `active`, con `message_count = 0`;
- owner e identidad interna coinciden con la resolución backend;
- no se crea ningún mensaje.

La creación conserva la decisión MVP de crear siempre una sesión nueva. No se
añaden idempotency keys ni reutilización de sesiones.

## 8. Casos negativos

Se probaron sin sesiones persistentes: sin Authorization, token inválido, body
no JSON, objeto vacío, body de tipo incorrecto, ID vacío, ID con tipo incorrecto,
UUID malformado, ID interno usado como público, ID inexistente, draft, no
disponible, no conversable, surface Admin/Development simulada, área no Product,
tier desconocido, especialista interno inexistente y payloads con campos de
autoridad prohibidos.

Los casos no seleccionables HTTP comparten `invalidSelectableSpecialist` y no
revelan la causa interna. `pro/vip` conservan el error comercial estable ya
aprobado.

## 9. Respuesta pública

La respuesta exitosa contiene únicamente:

```text
sessionId
selectableSpecialist { id, displayName, area }
startedAt
lastMessageAt
status
messageCount
```

No expone owner, `specialist_id`, `parent_catalog_id`, prompts, metadata interna,
roles, permisos, claims, tokens, SQL, stack traces ni errores crudos. Las
consultas usan allowlists explícitas y nunca `SELECT *`.

## 10. Atomicidad

La única escritura es un `INSERT` de una fila completa en `chat_sessions`, con
FKs y columnas NOT NULL. Si falla parsing, auth, perfil, resolución o identidad
interna, el insert no se ejecuta. No hay mensajes ni otras escrituras parciales.

La resolución de catálogo y el insert son llamadas separadas. Esto deja una
ventana TOCTOU teórica si el catálogo cambia concurrentemente; no afecta la
validación local estática, pero requiere una operación transaccional backend
antes de uso productivo.

## 11. Categorías legacy y prompt_template

Las categorías internas `fisico` y `mental` no se usan para autorización ni
pertenencia Product. Son deuda legacy no bloqueante.

El placeholder sintético `prompt_template = {}` solo satisface el schema. La
creación no lo consulta, interpreta, ejecuta ni expone. No se genera respuesta
automática y no se afirma que exista un agente IA operativo.

## 12. Tests y repetibilidad

- catálogo aplicado: `19 specialists | 19 catalog | 9 seleccionables`;
- pgTAP focal AG115: 23/23;
- harness HTTP AG115: tres ejecuciones completas PASS tras corregir únicamente
  el preflight de compatibilidad CLI;
- cleanup de cada harness: `0|0|0|0|0|0` fixtures temporales;
- suite SQL acumulada AG112–AG114: 479/479;
- Deno `create-own-chat-session`: 8/8;
- Flutter focal: 46/46;
- estado final tras reset sin seed: `0|0|0|0|0|0`.

Los dos ciclos focales consecutivos recrearon usuarios, generaron sesiones
distintas, limpiaron todos los temporales y conservaron intacto el fingerprint
del catálogo AG114. No quedó proceso `functions serve` huérfano.

## 13. Seguridad

RLS permanece activo sin FORCE RLS. `specialists`, `specialist_catalog` y
`chat_sessions` conservan cero policies y los roles cliente conservan cero
grants CRUD. `service_role` existe solo en el entorno temporal local con permiso
0600, se elimina con el harness y no aparece en respuestas, logs o Git.

No se utilizó Supabase remoto, linked migration, deploy, secrets, datos reales
ni credenciales reales.

## 14. Límites

No se modificaron migraciones, schema, Flutter, rutas, UI Product, mensajes,
prompts, entitlements, `/conversations`, `/chat/:id`, `/orchestrator/chat`,
Stasis Engine, MCP, Foundation, Nexus, Rector o Gerendi.

## 15. Deuda residual

1. Resolver la ventana TOCTOU con una operación backend transaccional antes de
   producción.
2. Diseñar autorización comercial real para `pro/vip`.
3. Retirar categorías y `prompt_template` legacy mediante una decisión futura
   separada.
4. El flujo continúa local/dev-only y no está autorizado para remoto o producto.

## 16. Readiness

```text
LOCAL SESSION CREATION BY SELECTABLE SPECIALIST VALIDATED_AND_PUSHED
```

Recomendación aprobada para el cierre:

```text
Cerrar formalmente AG115 y congelar la línea 2B.
Siguiente iniciativa: FOUNDATION-001 — congelación, baseline,
inventario y transición formal de Descubrimiento a Stasisly Foundation.
```

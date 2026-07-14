# 2B-AG113 — Canonicalizacion de access_tier Product

## Estado

Completado y publicado.

Readiness final:

```text
PRODUCT CATALOG ACCESS TIER CANONICALIZED_AND_PUSHED
```

## Motivo

AG112 valido que la migracion `00008` usa `pro` y rechaza `premium`, pero
detectó que algunas Edge Functions, harness HTTP, contratos Flutter y
documentos vigentes todavia usaban `premium` como valor activo.

Antes de preparar seeds sinteticos Product debe existir un unico vocabulario
tecnico para `specialist_catalog.access_tier`.

## Decision canonica

Valores tecnicos activos:

```text
free
pro
vip
```

Reglas:

- `pro` es el tier intermedio canonico.
- `vip` es el tier superior canonico.
- `premium` queda prohibido en contratos nuevos, DTO, respuestas publicas,
  fixtures activos, seeds futuros, Edge Functions y repositorios Flutter.
- `premium` solo puede aparecer como valor legacy en normalizacion historica de
  migracion o como prueba negativa que demuestre rechazo.
- No existe compatibilidad bidireccional.
- No se convierte `pro` de nuevo en `premium`.
- Valores desconocidos fallan cerrado.

## Tier tecnico frente a nombre comercial

`access_tier` es un enum tecnico de backend/catalogo.

La palabra `Premium` puede aparecer en textos comerciales, diseno visual o
documentos historicos sin representar `specialist_catalog.access_tier`. Esos
casos no se sustituyen automaticamente para evitar cambiar posicionamiento de
producto fuera del alcance de AG113.

## Inventario semantico

| Contexto | Clasificacion | Accion | Justificacion |
|---|---|---|---|
| `supabase/migrations/00008_prepare_product_catalog_schema.sql` permitia `enterprise` | Contrato schema activo | Cambiado a `free/pro/vip` | Decision vinculante AG113 no incluye `enterprise`. |
| `supabase/migrations/00008_prepare_product_catalog_schema.sql` normaliza `premium -> pro` | Legacy migration normalization | Conservado | Unica normalizacion legacy controlada. |
| `supabase/migrations/00004_create_specialist_catalog_deny_all.sql` contiene `free/premium` | Documentacion historica de migracion previa | Conservado | Migracion historica anterior a AG111; `00008` normaliza y reemplaza constraint. |
| `list-selectable-specialists/access_state.ts` aceptaba `premium` y devolvia `lockedPremium` | Backend contract/public response | Cambiado a `pro/vip -> lockedPro`; `premium` rechazado | El estado publico no debe contener `premium`. |
| `create-own-chat-session/contract.ts` trataba `premium` como bloqueo | Backend contract/public error | Cambiado a `pro/vip -> proLocked`; `premium` es contract violation | El error publico no debe contener `premium`. |
| `SelectableSpecialistAccessState.lockedPremium` | Flutter/domain DTO | Cambiado a `lockedPro` | Flutter no debe aceptar respuesta publica con `premium`. |
| Parser Flutter de `accessState` | Flutter/domain contract | Cambiado a aceptar `lockedPro` y rechazar `lockedPremium` | Sin fallback silencioso ni compatibilidad bidireccional. |
| Harness SQL/HTTP con `access_tier='premium'` | Test/fixture activo | Cambiado a `pro` cuando representaba tier activo | Seeds y fixtures activos deben usar vocabulario canonico. |
| Tests AG112/AG113 que usan `premium` | Test negativo legacy | Conservado | Demuestran rechazo de `premium`. |
| `is_premium` en tabla `specialists` | Columna interna legacy distinta | Conservado | No es `specialist_catalog.access_tier`; queda fuera del contrato publico. |
| `lib/core/theme/* premium aesthetics/palette` | Texto comercial/visual no relacionado | Conservado | No representa enum tecnico. |
| ADR/tracker historicos con `premium` | Documentacion historica | Conservado salvo referencias vigentes AG110/AG112 | No se reescribe historia; AG113 documenta la decision nueva. |

## Cambios realizados

Backend local:

- `list-selectable-specialists` usa `lockedPro`.
- `create-own-chat-session` usa `proLocked`.
- `pro` y `vip` bloquean creacion hasta que exista entitlement real.
- `premium` falla como `contractViolation`.

Flutter/contratos:

- `SelectableSpecialistAccessState.lockedPro` reemplaza
  `lockedPremium`.
- Parser backend acepta `lockedPro`.
- Parser backend rechaza `lockedPremium`.

SQL/tests:

- `00008` restringe `access_tier` a `free`, `pro`, `vip`.
- Harness activos usan `pro` en lugar de `premium`.
- Se anaden tests AG113 de allowlist canonica y postcondiciones.

Documentacion:

- AG110 queda actualizado con `free/pro/vip`.
- AG112 queda actualizado indicando que la deuda `pro/premium` se resuelve en
  AG113.
- SESSION_TRACKER registra el cierre AG113.

## Validacion ejecutada

SQL local:

- `supabase db reset --local --no-seed`
- AG112 principal + postconditions junto con AG113 principal + postconditions:
  PASS 85/85.
- `supabase test db --local`: PASS 479/479.

Edge Functions:

- `deno fmt` sobre archivos tocados: PASS.
- `deno test supabase/functions/list-selectable-specialists supabase/functions/create-own-chat-session`:
  PASS 18/18.

Flutter:

- `dart format --set-exit-if-changed` sobre archivos Dart tocados: PASS.
- tests focales de specialists/chat_sessions/architecture: PASS.
- `flutter analyze --no-fatal-infos`: PASS con 52 infos preexistentes.
- `flutter test`: PASS 406/406 con 5 skips esperados por entorno remoto.

Git:

- `git diff --check`: PASS.
- Inventario semantico posterior confirma que `premium` queda solo como
  normalizacion legacy, prueba negativa, texto historico o texto comercial no
  relacionado con `specialist_catalog.access_tier`.

## Limites

AG113 no autoriza:

- seeds sinteticos Product;
- datos reales;
- remoto;
- deploy;
- `/conversations`;
- UI Product nueva;
- cambios de pricing comercial;
- reescritura de documentacion historica.

## Readiness para seeds

Los seeds sinteticos Product solo podran usar:

```text
free
pro
vip
```

No podran usar:

```text
premium
enterprise
internal
```

Readiness:

```text
PRODUCT CATALOG ACCESS TIER CANONICALIZED_AND_PUSHED
```

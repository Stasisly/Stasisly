# FOUNDATION-005-R1 — Legacy Public Tables Deny-All

Status: **ACTIVE evidence — CLOSED_LOCALLY**

## 1. P0 original

FOUNDATION-005 detectó diez tablas legacy en `public` con RLS desactivado y
grants CRUD amplios para `anon` y `authenticated`. El riesgo era crítico si ese
estado definido por el repositorio llegaba a desplegarse.

## 2. Alcance exacto

La remediación cubre exclusivamente:

```text
memberships
user_memberships
branch_chiefs
subcategory_chiefs
user_health_data
calendar_events
reminders
orchestator_summaries
chief_write_permissions
specialist_temporary_disables
```

## 3. Evidencia previa

Antes de la migración, las diez tablas existían, tenían RLS desactivado, cero
policies y privilegios de tabla amplios para ambos roles cliente. Esta evidencia
procede de una base Supabase local reconstruida desde las migraciones.

## 4. Consumidores

La inspección de `lib/`, `supabase/functions/`, `supabase/tests/` y `test/` no
encontró consumidores ejecutables de estas tablas. No se encontró contrato de
acceso cliente aprobado.

## 5. Migración

`supabase/migrations/00009_harden_legacy_public_tables_deny_all.sql` aplica una
transacción con preflight y postflight. Verifica el conjunto exacto de tablas,
habilita RLS y revoca privilegios de tabla a `PUBLIC`, `anon` y
`authenticated`.

## 6. RLS

Las diez tablas terminan con RLS activo. La migración no habilita `FORCE ROW
LEVEL SECURITY`, porque no altera el modelo de acceso backend/propietario.

## 7. Grants cliente

El postflight y pgTAP prueban cero privilegios equivalentes de tabla o columna
para `anon` y `authenticated`, incluidos `SELECT`, `INSERT`, `UPDATE` y
`DELETE`.

## 8. Secuencias

No existen secuencias públicas asociadas a estas tablas ni secuencias públicas
en el estado local inspeccionado. La migración no modifica secuencias.

## 9. Policies

No se crean policies. Cada tabla conserva exactamente cero policies, por lo que
RLS opera como deny-all para roles sin bypass.

## 10. Vistas, funciones y bypass

No se encontraron vistas, vistas materializadas ni funciones dependientes de
las diez tablas. Las únicas funciones públicas inspeccionadas son ajenas a este
alcance y no usan `SECURITY DEFINER`. No se añadió ninguna vía de bypass.

## 11. Acceso backend

`service_role` conserva CRUD en las diez tablas. R1 no autoriza su uso desde
clientes ni crea un nuevo backend consumidor.

## 12. Preservación de esquema y datos

No se renombran tablas o columnas, no se altera semántica de datos, no se crean
seeds y no se modifica `orchestator_summaries`. La remediación solo endurece el
control de acceso.

## 13. Tests focales

- Suite principal R1: 120/120 assertions pgTAP.
- Postcondiciones R1: 50/50 assertions pgTAP.
- Tres tests históricos ajustados bajo ampliación explícita de alcance: 100/100.

Los tres ajustes históricos solo amplían las listas exactas de tablas con RLS;
no relajan assertions ni cambian planes.

## 14. Regresión completa

- SQL: 18 archivos, 649 tests, todos superados.
- Deno: 52 tests superados; formato correcto en 41 archivos.
- Flutter: 406 tests superados y 5 omitidos.

## 15. Repetibilidad y limpieza

Se ejecutaron dos `supabase db reset --local --no-seed` desde cero. En ambos
casos las migraciones `00001` a `00009` aplicaron correctamente y la suite SQL
completa quedó verde. No se usaron fixtures persistentes ni datos reales.

## 16. Bloqueo temporal y autorización ampliada

La primera suite completa detectó tres expectativas históricas que enumeraban
el conjunto anterior de tablas con RLS. El trabajo se detuvo sin ampliar alcance
por iniciativa propia. Tras autorización explícita, se modificaron únicamente
los tres archivos de test indicados y se repitieron todas las validaciones.

## 17. Límites, deuda residual y readiness

Este cierre es local y del P0 concreto. No demuestra el estado remoto, no
implementa RBAC/ABAC/JIT, no resuelve superficies, identidad, privacidad, CI ni
deuda P1-P4. No se ejecutó `db push`, migración linked, deploy ni acceso remoto.

Readiness:

```text
LEGACY PUBLIC TABLES DENY_ALL HARDENED_LOCAL
```

El P0 queda `CLOSED_LOCALLY`. FOUNDATION-006 puede proponerse como siguiente
paquete; cualquier despliegue remoto requiere autorización y evidencia propias.

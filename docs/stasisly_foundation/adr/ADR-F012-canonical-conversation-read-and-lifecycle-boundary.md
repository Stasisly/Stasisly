# ADR-F012 — Canonical Conversation read and lifecycle boundary

```text
Decision: APPROVED
Implementation: IMPLEMENTED_LOCALLY
Scope: Product Conversation backend boundary
Remote: NOT AUTHORIZED
```

## Context

Create/send son transaccionales, pero list/read/archive seguían repartiendo
ownership, catálogo y lifecycle entre consultas transitorias, y restore no
existía. Archive replay devolvía 404.

## Decision

1. Conversation es el agregado Product y `chat_sessions` el nombre físico
   transitorio.
2. List/read son owner-scoped, sanitizados y con paginación estable acotada.
3. Active significa `archived_at IS NULL`; archived significa timestamp no
   nulo, con constraint coherente. Unknown deniega y pendingDeletion se difiere.
4. Archive no es delete, conserva ID e historia y es idempotente por estado.
5. Restore es explícito, atómico, conserva historia e idempotente por estado.
6. Historia archivada sigue legible solo por owner; send archivado se deniega.
7. RPCs son invoker-security, service-role-only y tablas siguen deny-all.
8. Endpoints y schema transitorios se mantienen por compatibilidad.
9. Solo local/development están permitidos. Remoto no está autorizado.

## Consequences

El backend concentra lifecycle y ownership, elimina el PATCH directo de
archive y permite read/restore canónicos. El orden cursor no es snapshot ante
cambios concurrentes. Rutas Product, UI, delete, sharing y provenance siguen
fuera de alcance.

## Evidence

Migration 00011, dos suites pgTAP 713/713, Deno 85/85, HTTP local real con
siete ceros, Flutter 517/5 skips, contratos/adapters y evidencia FOUNDATION-013C.

## Rollback

Revert del commit y `supabase db reset --local --no-seed`; no existe estado
remoto que revertir.

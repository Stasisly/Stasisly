# FOUNDATION-013C — Canonical Conversation read/list/archive/restore

```text
Status: IMPLEMENTED_LOCALLY
Owner: Backend + Product Architecture + Security + QA
Remote: NOT AUTHORIZED
```

## 1. Auditoría list

El endpoint transitorio autenticaba por JWT, derivaba propietario en backend,
filtraba `active|archived|all`, ordenaba por `(last_message_at,id)` descendente
y usaba cursor v1 opaco y límite 1–50. Consultaba tabla y catálogo por separado.
El orden era determinista, pero no una instantánea ante mutaciones concurrentes.

## 2. Auditoría archive

`archive-own-chat-session` aceptaba POST `{sessionId}`, hacía PATCH directo solo
sobre estado activo y devolvía DTO mínimo. El replay producía 404 y la carrera
dependía de dos pasos; no era naturalmente idempotente.

## 3. Auditoría message read

`list-session-messages` valida JWT y ownership, admite sesión propia activa o
archivada, ordena `(created_at,id)` ascendente, limita 1–100, pagina con cursor
opaco y sanitiza roles demostrados. Vacío es 200 y ajeno/inexistente es 404.

## 4. Contrato backend canónico

`PublicConversation` permite `conversationId`, `status`, `createdAt`,
`updatedAt`, `archivedAt` opcional y referencia pública seleccionada opcional.
No expone owner, IDs internos, runtime, prompts, policy ni base de datos.

## 5. Lifecycle mapping

`status=active + archived_at IS NULL` mapea a active; `status=archived +
archived_at IS NOT NULL` mapea a archived. La constraint impide estados
contradictorios. `pendingDeletion` no se implementa y unknown deniega.

## 6. Operation registry

Se registran `conversation.listOwn`, `conversation.readOwn`,
`conversation.archiveOwn`, `conversation.restoreOwn` y
`conversation.message.listOwn`, Product local/development con PDP/PEP común.

## 7. List

`list_own_conversations_core` deriva alcance mediante owner recibido solo desde
la Edge autorizada, admite filtros acotados y falla cerrado si falta catálogo
público. El endpoint transitorio conserva su DTO y nombre.

## 8. Cursor

El cursor codifica versión, `updatedAt` físico transitorio y Conversation ID;
se valida canónicamente. La comparación de tupla evita duplicados con datos
estables, sin prometer snapshot isolation durante escrituras concurrentes.

## 9. Read one

`read-own-conversation` autentica, autoriza, invoca RPC owner-scoped y devuelve
solo el DTO canónico. No incluye mensajes, memoria, research ni trace.

## 10. Archive

La RPC bloquea la fila `FOR UPDATE`; active pasa a archived y un replay archived
devuelve el mismo resultado lógico 200. Ajeno e inexistente comparten 404 opaco.

## 11. Restore

La RPC bloquea la misma fila; archived pasa a active y un replay active devuelve
el mismo resultado lógico 200. No crea otra Conversation ni reconstruye datos.

## 12. Concurrencia

Los locks serializan transiciones sobre una Conversation. Archive/archive y
restore/restore son replays seguros; operaciones opuestas dejan un único estado
válido determinado por el orden efectivo de adquisición, sin orden global.

## 13. Archived message history

Archive conserva ID, Messages, `message_count` y `last_message_at`. El owner
puede leer historia archivada, pero `send_user_message_core` sigue denegando.

## 14. Message pagination

Se conserva el cursor acotado `(created_at,messageId)`, orden ascendente y
aislamiento por Conversation/owner. No se añaden attachments ni provenance.

## 15. DTOs

Conversation usa allowlist canónica; endpoints transitorios list/archive y
Message conservan sus shapes públicos. Ningún DTO incluye `user_id` o
`specialist_id` interno.

## 16. Endpoints transitorios

`list-own-chat-sessions`, `archive-own-chat-session` y
`list-session-messages` son `TRANSITIONAL_BACKEND_ENDPOINT` y no vocabulario
Product canónico.

## 17. Nuevos endpoints

Solo se crean `read-own-conversation` y `restore-own-conversation`. No se crea
delete, share, participants, memory, research ni ruta `/conversations`.

## 18. Authorization

Todas las operaciones usan `BackendRequestContext`, registro central, Product
backend-owned, entorno local/development, JWT verificado, PDP, PEP, ownership y
correlation ID seguro.

## 19. Errors

Input inválido es 400, auth 401, recurso ajeno/inexistente 404 opaco, lifecycle
inválido 409, contrato 502 y backend mal configurado 503. Detalles SQL no salen.

## 20. HTTP

List/read/archive/restore válidos responden 200. Archive/restore replay también
200. No se usa 201 para lifecycle.

## 21. Migration

`00011_add_canonical_conversation_read_and_lifecycle.sql` añade solo
`archived_at`, constraint, índice y cuatro RPCs. No altera migraciones previas,
renombra tablas ni habilita remoto.

## 22. Indexes

`idx_chat_sessions_owner_status_listing` soporta owner, status y paginación
estable. `idx_messages_session_created_id` ya cubría historia de Message.

## 23. Privileges

Las cuatro RPCs son invoker-security, fijan `search_path`, deniegan EXECUTE a
PUBLIC/anon/authenticated y conceden solo a service_role. Tablas mantienen RLS
deny-all, cero policies y cero CRUD cliente.

## 24. SQL tests

pgTAP cubre filtros, cursor, read, opacidad, archive/restore/replays, historia,
send archivado/restaurado, grants, invoker security y rollback a siete ceros.
Dos resets sin seed y dos suites completas pasan 713/713 en 22 archivos cada
una.

## 25. Deno tests

Se cubren DTO allowlist, authority-bearing inputs, JWT, PDP/PEP, RPC estrecha,
404 opaco, lifecycle, replay, errores sanitizados y runtime fail-closed. La
suite completa pasa 85/85 y `deno fmt --check` valida 62 archivos.

## 26. HTTP integration

El harness local usa dos identidades sintéticas, recorre list/read/archive/
history/send-denied/restore/send y termina `0|0|0|0|0|0|0`.

## 27. Flutter contracts

`ConversationRepository` añade read y restore; los filtros active/archived ya
eran canónicos. La regresión completa pasa 517 tests con 5 skips aprobados; el
análisis tiene 0 errores y 51 infos heredadas. No hay provider Product, UI ni
ruta nueva.

## 28. Adapters

El adapter transitorio transforma snapshots sanitizados a Conversation con
owner obtenido de identidad confiable. El transporte conserva nombres físicos
solo en el límite compatible.

## 29. Idempotency decision

Create/send mantienen key-based idempotency. Archive/restore usan idempotencia
natural basada en estado y lock; no contaminan `conversation_idempotency`.

## 30. Security

Owner siempre se deriva del JWT; recursos ajenos son opacos; unknown deniega;
no hay RPC/tabla cliente, fallback legacy, secreto, remoto ni producción.

## 31. Rollback

Revertir el commit y resetear Supabase local elimina 00011 y los endpoints. No
se borra historia ni se requiere rollback remoto porque no hubo despliegue.

## 32. Residual debt

Persisten nombres físicos transitorios, no hay snapshot pagination, Product
API completa/rutas/UI, delete, pendingDeletion, sharing, provenance 013D,
retención idempotency, rate limits, remoto ni producción.

## 33. Readiness

List/read/archive/restore/history quedan `FOUNDATION_ADOPTED_LOCALLY`; API
canónica backend permanece `PARTIALLY_IMPLEMENTED`; G8–G10 no autorizados.

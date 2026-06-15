# `archive-own-chat-session` local

Edge Function experimental de 2B-IV-E. Archiva exclusivamente una sesión propia
activa mediante un único `PATCH` filtrado por sesión, owner y estado.

```http
POST /functions/v1/archive-own-chat-session
Authorization: Bearer <JWT_LOCAL_VALIDADO>
Content-Type: application/json

{"sessionId":"<chat_sessions.id>"}
```

Solo actualiza `status` a `archived`. Conserva exactamente `last_message_at`,
`started_at`, `message_count`, owner, especialista e ID.

La respuesta contiene únicamente `sessionId` y `status`. Sesión inexistente,
ajena o ya archivada producen el mismo `sessionNotFound`.

No desplegar ni ejecutar contra remoto. No crea mensajes ni modifica catálogo o
especialistas.

# `list-own-chat-sessions` local

Edge Function experimental de 2B-IV-D. Solo lista sesiones del owner derivado
del JWT validado contra Auth local.

```http
GET /functions/v1/list-own-chat-sessions?status=active&limit=20&cursor=...
Authorization: Bearer <JWT_LOCAL_VALIDADO>
```

La respuesta nunca contiene `user_id`, `specialist_id`, IDs internos, prompts o
configuración sensible. Si una sesión no resuelve exactamente una entrada
publicada de catálogo, falla toda la respuesta con `contractViolation`; nunca
devuelve lista parcial ni placeholder.

El cursor es Base64URL estricto sobre `lastMessageAt + sessionId`, con orden
`last_message_at DESC, id DESC`.

No desplegar ni ejecutar contra remoto. No modifica sesiones, catálogo,
especialistas o mensajes.

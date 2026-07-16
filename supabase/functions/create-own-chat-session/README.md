# `create-own-chat-session` local

Edge Function local transitoria para creación canónica de Conversation. Solo
puede ejecutarse contra Supabase local y delega elegibilidad, idempotencia e
inserción a una única RPC transaccional.

## Contrato

```http
POST /functions/v1/create-own-chat-session
Authorization: Bearer <JWT_LOCAL_VALIDADO>
Content-Type: application/json
Idempotency-Key: <opaque-operation-attempt-id>

{"selectableSpecialistId":"<specialist_catalog.id>"}
```

No acepta campos adicionales. La respuesta pública nunca contiene `user_id`,
`specialist_id`, prompts o configuración interna. No crea mensajes.

`selectableSpecialistId` representa exclusivamente `specialist_catalog.id`. La
RPC bloquea la fila del catálogo y valida publicación, disponibilidad,
conversabilidad, superficie Product, área y tier dentro de la misma transacción
que crea la sesión. Los tiers `pro`/`vip` permanecen bloqueados.

Una primera ejecución devuelve `201`; un replay idéntico devuelve `200` con el
mismo DTO. Reutilizar la key con otro payload devuelve conflicto. La key no es
identidad ni autorización y debe tener 16-128 caracteres seguros.

## Límites

- No desplegar, enlazar ni ejecutar contra remoto.
- No guardar claves, JWT o secretos en archivos versionados.
- `service_role` se usa únicamente dentro del runtime local/efímero.
- Cada key nueva crea una sesión nueva; no reutiliza sesiones activas.
- Listado, archivado, IA y Stasis Engine quedan fuera.

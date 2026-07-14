# `create-own-chat-session` local

Edge Function experimental de 2B-IV-C. Solo puede ejecutarse contra Supabase
local y crea siempre una sesión nueva por cada invocación válida.

## Contrato

```http
POST /functions/v1/create-own-chat-session
Authorization: Bearer <JWT_LOCAL_VALIDADO>
Content-Type: application/json

{"selectableSpecialistId":"<specialist_catalog.id>"}
```

No acepta campos adicionales. La respuesta pública nunca contiene `user_id`,
`specialist_id`, prompts o configuración interna. No crea mensajes.

`selectableSpecialistId` representa exclusivamente `specialist_catalog.id`. El
backend resuelve `specialist_id` y exige que la entrada esté publicada,
disponible, sea conversable y pertenezca únicamente a Product. Los tiers
`pro`/`vip` permanecen bloqueados hasta que exista entitlement aprobado.

## Límites

- No desplegar, enlazar ni ejecutar contra remoto.
- No guardar claves, JWT o secretos en archivos versionados.
- `service_role` se usa únicamente dentro del runtime local/efímero.
- No reutiliza sesiones activas ni implementa `Idempotency-Key`.
- Listado, archivado, Flutter, mensajes, IA y Stasis Engine quedan fuera.

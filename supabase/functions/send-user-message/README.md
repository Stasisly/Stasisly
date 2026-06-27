# send-user-message

Edge Function local para 2B-V-C2. Valida JWT contra Auth local, valida un body
estricto `{ "sessionId": "...", "content": "..." }`, deriva owner desde el JWT y
llama exclusivamente a `public.send_user_message_core`.

No inserta directamente en `public.messages`, no actualiza directamente
`public.chat_sessions`, no lista mensajes, no invoca IA y no habilita remoto.

Uso local:

```bash
supabase functions serve send-user-message --no-verify-jwt --env-file <archivo-local-no-versionado>
```

El archivo de entorno local debe contener `SUPABASE_URL`, `SUPABASE_ANON_KEY`,
`SUPABASE_SERVICE_ROLE_KEY` y `STASISLY_ALLOW_LOCAL_ONLY=true`. No versionar
secretos ni tokens.

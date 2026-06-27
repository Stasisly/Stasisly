# list-session-messages

Edge Function local para 2B-V-D. Valida JWT contra Auth local, deriva owner
desde el JWT y lista mensajes de una sesion propia activa o archivada.

La funcion es de solo lectura: no modifica `messages`, `chat_sessions`,
`message_count`, `last_message_at`, catalogo, especialistas, Flutter ni UI.

Uso local:

```bash
supabase functions serve list-session-messages --no-verify-jwt --env-file <archivo-local-no-versionado>
```

No versionar secretos, tokens ni archivos de entorno locales.

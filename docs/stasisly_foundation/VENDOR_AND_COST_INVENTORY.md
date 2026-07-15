# Inventario inicial de proveedores y costes

## Alcance

Inventario basado únicamente en código, lockfile y documentación segura. No se
consultaron dashboards, contratos, facturación, secretos ni entornos remotos.
Por ello, los costes monetarios reales se clasifican como desconocidos.

## Política arquitectónica FOUNDATION-004

- PostgreSQL es la plataforma relacional canónica donde corresponda.
- Supabase es un proveedor managed inicial, no la identidad del backend.
- Auth, Storage, Edge Functions, Realtime y gestión Supabase se evalúan y pueden
  sustituirse por separado.
- Los clientes nuevos prefieren contratos propiedad de Stasisly.
- Model Gateway y Cost Controller son componentes conceptuales obligatorios
  antes de escalar uso de IA; no se ha elegido proveedor ni modelo.
- Managed services están permitidos con portabilidad; self-hosting es capacidad
  futura y cualquier comparación usa coste total de propiedad.

## Proveedores y dependencias

| Capacidad | Proveedor / tecnología | Datos | Uso observado | Coste | Portabilidad | Alternativa / salida preliminar | Riesgo |
|---|---|---|---|---|---|---|---|
| Base de datos | PostgreSQL vía Supabase | Usuarios, catálogo, sesiones, mensajes | Schema y tests activos | UNKNOWN / USAGE_BASED | PORTABLE_WITH_ADAPTATION | PostgreSQL gestionado propio/otro proveedor; SQL versionado | Medio |
| Auth | Supabase Auth | Identidad y tokens | Local/dev y Flutter legacy | UNKNOWN / USAGE_BASED | VENDOR_COUPLED | Puerto de identidad + proveedor intercambiable | Alto |
| API REST | PostgREST/Supabase | Datos de aplicación | Edge Functions y harnesses | UNKNOWN / USAGE_BASED | PORTABLE_WITH_ADAPTATION | API propia sobre contratos de dominio | Medio |
| Serverless | Supabase Edge Functions/Deno | Payloads de catálogo/chat | Seis funciones local-safe | UNKNOWN / USAGE_BASED | PORTABLE_WITH_ADAPTATION | Runtime Deno/Node/container | Medio |
| Realtime | Supabase Realtime | Eventos futuros | Dependencia declarada, uso no verificado | UNKNOWN | VENDOR_COUPLED | WebSocket/event bus propio | Medio |
| Storage | Supabase Storage | Archivos futuros | No implementado | UNKNOWN / USAGE_BASED | PORTABLE_WITH_ADAPTATION | S3 compatible | Medio |
| Firebase Core/Auth | Google Firebase | Identidad/config potencial | Dependencias declaradas; uso funcional no verificado | UNKNOWN | VENDOR_COUPLED | Retirar o encapsular | Alto por duplicidad |
| Push | Firebase Cloud Messaging | Tokens y notificaciones | Dependencia declarada; no auditada | UNKNOWN / USAGE_BASED | VENDOR_COUPLED | APNs/Web Push/otro broker | Medio |
| Google Sign-In | Google | Identidad OAuth | Dependencia declarada; no auditada | UNKNOWN | VENDOR_COUPLED | OIDC mediante puerto | Medio |
| Error tracking | Sentry | Errores y contexto técnico | Dependencia/config declarada | UNKNOWN / USAGE_BASED | PORTABLE_WITH_ADAPTATION | OpenTelemetry + backend alternativo | Privacidad/logs |
| HTTP cliente | Dio | Payloads API | Integraciones locales Flutter | Sin coste directo | PORTABLE | `http` u otro adapter | Bajo |
| Secure storage | Plataforma vía plugin Flutter | Tokens locales futuros | Dependencia declarada | Sin coste directo | PORTABLE_WITH_ADAPTATION | Keystore/Keychain adapters | Alto de seguridad |
| Fuentes | Google Fonts | Tipografías/posible red | Dependencia declarada | UNKNOWN | PORTABLE | Bundling local | Privacidad/disponibilidad |
| Repositorio/CI | GitHub + Actions | Código, artefactos, logs | Activo | UNKNOWN / USAGE_BASED | PORTABLE_WITH_ADAPTATION | Otro Git/CI; export Git completo | Supply chain |
| Apple | App Store/APNs/Sign in futuro | Distribución/identidad/notificaciones | Skeleton iOS | UNKNOWN / FIXED+USAGE | VENDOR_COUPLED | No sustituible para iOS | Alto externo |
| Google | Play Store/Android services | Distribución y servicios | Skeleton Android | UNKNOWN / FIXED+USAGE | VENDOR_COUPLED | Distribución alternativa limitada | Alto externo |
| Pagos | No seleccionado | Datos comerciales futuros | No implementado | UNKNOWN / USAGE_BASED | UNKNOWN | ADR y abstracción de billing | FOUNDATION_BLOCKER |
| Email | No seleccionado | Email/transaccional futuro | No implementado | UNKNOWN / USAGE_BASED | UNKNOWN | Proveedor intercambiable | Medio |
| Analytics | No seleccionado | Eventos de producto futuros | No implementado | UNKNOWN / USAGE_BASED | UNKNOWN | Esquema propio + adapter | Privacidad |
| Proveedores IA | No seleccionados | Prompts, contexto y resultados futuros | No implementados | UNBOUNDED_RISK | UNKNOWN | Model Gateway multi-provider/modelos propios | Crítico |
| MCP | No seleccionado | Tools/contexto futuro | Conceptual | UNKNOWN / USAGE_BASED | UNKNOWN | APIs internas tipadas | Superficie de ataque |

Los valores de proveedor y coste de esta tabla son evidencia, no selección
arquitectónica nueva. `UNKNOWN` permanece hasta obtener evidencia autorizada.

## Soberanía y plan de salida

1. Mantener contratos de dominio independientes del SDK de proveedor.
2. Encapsular Supabase, Firebase, Sentry y proveedores IA detrás de puertos.
3. Versionar schema, migraciones, eventos y formatos de exportación.
4. Definir exportación periódica, restauración y prueba de salida.
5. Evitar datos o permisos críticos en metadata controlable por cliente.
6. No desplegar Model Gateway sin routing, presupuesto y telemetría por uso.
7. Mantener contrato propio, export path, migration strategy, cost observability
   y exit trigger para cada dependencia crítica.
8. Atribuir uso y presupuesto por surface, plan, entorno y región cuando
   corresponda.

## Inventario de costes técnicos

| Fuente de coste | Tipo | Control actual observado | Riesgo | Control Foundation requerido |
|---|---|---|---|---|
| Tokens de IA | UNBOUNDED_RISK | No implementado | Crítico | Presupuesto por usuario/tarea/modelo |
| Tool calls/agentes | UNBOUNDED_RISK | No implementado | Crítico | Límite de fan-out, timeout y circuit breaker |
| Model routing | UNKNOWN | No existe gateway | Alto | Política coste/calidad/latencia |
| Edge Functions | USAGE_BASED | Harnesses locales | Medio | Métricas por función y cuota |
| Base de datos | USAGE_BASED | Schema local | Medio | Índices, límites, retención y capacity plan |
| Storage | USAGE_BASED | No implementado | Alto | Cuotas, lifecycle y deduplicación |
| Egress | UNBOUNDED_RISK | No medido | Alto | Presupuesto y caché |
| Realtime | USAGE_BASED | No verificado | Medio | Límites de canales/eventos |
| Auth/MAU | USAGE_BASED | Local/dev | Medio | Forecast de MAU y abuso |
| Emails | USAGE_BASED | No implementado | Medio | Cuotas y proveedor fallback |
| Notificaciones | USAGE_BASED | Dependencia declarada | Medio | Rate limits y preferencias |
| Logs/Sentry | UNBOUNDED_RISK | Config parcial | Alto | Sampling, redacción y retención |
| Observabilidad | USAGE_BASED | No consolidada | Medio | Telemetría por surface/servicio |
| Wearables/sync | UNBOUNDED_RISK | No implementado | Alto | Frecuencia, batching y consentimiento |
| Backups | USAGE_BASED | No auditado | Alto | RPO/RTO y política de retención |
| Regiones | FIXED + USAGE_BASED | Una topología no confirmada | Medio | Estrategia de residencia/latencia |
| CI/builds | USAGE_BASED | GitHub Actions Flutter | Bajo/medio | Caché y límites de concurrencia |
| Stores | FIXED + USAGE_BASED | No productivo | Medio | Presupuesto y calendario release |

## Incógnitas bloqueantes

- Tarifas, cuotas y límites contractuales reales.
- Residencia de datos y regiones futuras.
- Volumen esperado de usuarios, mensajes, memoria y archivos.
- Modelos IA, precio por token y política de fallback.
- Retención, backup, egress y observabilidad.
- Proveedor de pagos, email y analytics.

No debe aprobarse hiperescala operativa hasta convertir estas incógnitas en
presupuestos, SLO, límites y propietarios.

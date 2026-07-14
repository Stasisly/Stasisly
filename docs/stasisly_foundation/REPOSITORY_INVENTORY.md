# Inventario del repositorio

## Estado y método

Inventario estático de `FOUNDATION-001`, realizado sobre archivos del
repositorio en el commit base `7f747e0`. No se inspeccionaron secretos, `.env`,
dashboards, facturación ni datos remotos. Los conteos excluyen `.git`, build,
`.dart_tool` y estado temporal de Supabase.

## Resumen cuantitativo

| Grupo | Conteo verificado | Observaciones |
|---|---:|---|
| Archivos inventariados | 452 | Incluye archivos ocultos seguros y plataformas |
| Documentos en `docs/` | 77 | Definición, tracker, ADR, agentes y planes |
| Agentes AAA | 43 | Prompts internos de Development |
| Comités | 6 | Gobierno transversal |
| ADR | 12 | Varios requieren consolidación Foundation |
| Planes de implementación | 7 | Principalmente cierre de línea 2B |
| Archivos Dart en `lib/` | 135 | Core y 11 features |
| Tests Dart | 64 | Arquitectura, unidad, widgets e integración |
| Migraciones SQL | 8 | `00001` a `00008` |
| Archivos de tests Supabase | 50 | SQL, psql y harness shell |
| Edge Functions funcionales | 6 | Más módulo compartido `_shared` |

## Árbol resumido

```text
.
├── .github/workflows/       CI y builds manuales
├── android/                 plataforma Flutter Android
├── docs/                    definición y evidencia de Descubrimiento
├── ios/                     plataforma Flutter iOS
├── lib/                     aplicación Flutter
├── supabase/                schema, seed, Edge Functions y tests
├── test/                    tests Dart/Flutter
├── web/                     plataforma Flutter Web
├── .env.example             plantilla segura
├── analysis_options.yaml
├── pubspec.yaml
└── pubspec.lock
```

No se encontraron directorios versionados para macOS, Windows o Linux. No hay
implementación wearable específica.

## Documentación

### Fuente existente

- `docs/PROJECT_DEFINITION.md`: visión y producto de Descubrimiento.
- `docs/ARCHITECTURE.md`: arquitectura conceptual y gates acumulados.
- `docs/SESSION_TRACKER.md`: histórico operativo, no evidencia técnica por sí
  solo.
- `docs/stasisly_definition/`: equipo, ADR, orquestador y planes 2B.
- `docs/archive/`: material histórico ya identificado.

### Riesgos documentales

- `ADR-006` supera 27.000 líneas y `ADR-007` supera 21.000; mezclan decisión,
  ejecución, evidencia y tracker.
- Persisten nombres `Wizard/Development` y `Admin/Engine` incompatibles con el
  vocabulario Foundation aprobado.
- Existe solapamiento entre ADR, planes, arquitectura y tracker.
- Estado conceptual e implementación real requieren separación más estricta.

## Flutter

### Core

Incluye configuración de entornos, routing, identidad central, sesión segura,
errores, tema y shell. Riverpod y GoRouter son dependencias activas.

### Features detectadas

```text
auth
chat
chat_messages
chat_sessions
health
mental_training
nutrition
orchestrator
physical_training
profile
specialists
```

### Estado observado

- Arquitectura por capas presente de forma desigual.
- Modo demo/local y fronteras fail-closed tienen pruebas específicas.
- `main.dart` todavía importa e inicializa Supabase en modos backend.
- Auth y chat legacy contienen imports directos de Supabase.
- Las rutas `/chat/:id` y `/orchestrator/chat` siguen siendo legacy; las rutas
  seguras compuestas son dev-only.
- Persisten `mental_training`, `physical_training` y categorías `fisico/mental`.
- No existe implementación real de Nexus, Rector, Gerendi o Stasis Engine.
- Los `.g.dart` se generan con `build_runner` y están ignorados por Git.

## Supabase

### Schema y migraciones

Ocho migraciones definen usuarios, catálogo de especialistas, sesiones,
mensajes, RLS deny-all, perfil mínimo y RPC de mensajes. Hay seed sintético local
de catálogo Product.

### Edge Functions

```text
archive-own-chat-session
create-own-chat-session
list-own-chat-sessions
list-selectable-specialists
list-session-messages
send-user-message
```

Todas pertenecen al frente local/dev-safe de Descubrimiento. Su existencia no
demuestra readiness productiva.

### Seguridad observable

- RLS y grants se validan mediante tests locales.
- Existen harnesses anti-remoto y cleanup de fixtures.
- Supabase continúa siendo una dependencia importante en Flutter y backend.
- La portabilidad de Auth, Edge Functions y APIs REST requiere diseño.

## Tests y automatización

- 64 archivos Dart cubren contratos arquitectónicos, repositorios, providers,
  widgets e integración local.
- 50 archivos Supabase cubren pgTAP, fixtures, HTTP local y cleanup.
- Tests Deno viven junto a cada Edge Function.
- CI de pull request ejecuta generación, análisis y tests Flutter.
- Build Android/Web es manual.
- CI no ejecuta actualmente Supabase local, pgTAP ni Deno.

## Configuración y entornos

- Modos: `local`, `demo`, `development`, `staging`, `backendReal`, `production`.
- `backendReal` es legacy/transitorio.
- `.env.example` contiene defaults seguros; `.env*` está ignorado salvo la
  plantilla.
- Hay gates para remoto, auth real, datos reales, rutas dev y conversaciones.
- `allowsRealData` permanece cerrado en código.
- Estado local de Supabase está ignorado.

## Integraciones y dependencias detectadas

Declaradas: Supabase, Firebase, Google Sign-In, Sentry, Dio, almacenamiento
seguro, selectores de archivos/imágenes, Google Fonts, Lottie y utilidades
Flutter. GitHub Actions está configurado. Pagos, email productivo, analytics,
Model Gateway, MCP y proveedores LLM no tienen integración productiva
verificada.

## MCP, Stasis Engine y wearables

- MCP: definido conceptualmente; no hay servidor MCP de producto en el repo.
- Stasis Engine: definido conceptualmente; no hay subsistema implementado.
- Wearables: intención futura; no hay targets, adaptadores ni contratos de
  dispositivos.

## Release, privacidad y seguridad

- Android, iOS y Web tienen skeleton de plataforma.
- No se verificó metadata de stores ni pipeline de publicación productivo.
- La documentación contempla privacidad y cifrado, pero memoria federada,
  investigaciones, datos de salud reales y pagos permanecen no implementados.
- Sentry está declarado, pero su operación y política de redacción no están
  auditadas en este paquete.

## Áreas desconocidas

- Coste real, límites y configuración de proveedores remotos.
- Estado operativo de Firebase, Sentry, Google y Supabase fuera del repo.
- Requisitos regulatorios por mercado y datos tratados.
- Estrategia definitiva de observabilidad, backup y disaster recovery.
- Arquitectura final del Model Gateway y Stasis Engine.
- Roster definitivo y permisos de agentes Product/Development/Administration.

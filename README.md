# Stasisly

Stasisly es una plataforma de bienestar con arquitectura Flutter/Supabase y una
definición documental centrada en Stasis como sistema nervioso central.

## Estado actual

El proyecto está en fase de estabilización local y modo demo explícito. Backend
real, producción, datos reales, IA, Stasis Engine, pagos y wiring UI/providers
requieren aprobación documental y técnica antes de activarse.

## Requisitos

- Flutter SDK compatible con el proyecto.
- Dart SDK compatible con el proyecto.
- Docker Desktop para pruebas Supabase locales.
- Supabase CLI para migraciones y harnesses locales.

## Comandos útiles

```bash
dart run build_runner build --delete-conflicting-outputs
flutter analyze --no-fatal-infos
flutter test
```

Para pruebas Supabase locales, usar únicamente entorno local/efímero y seguir
los harnesses documentados en `supabase/tests/`.

## Documentación principal

- `docs/PROJECT_DEFINITION.md`
- `docs/ARCHITECTURE.md`
- `docs/SESSION_TRACKER.md`
- `docs/stasisly_definition/`
- `docs/stasisly_definition/adr/`

## Reglas de seguridad

- No versionar secretos, tokens ni archivos `.env`.
- No ejecutar migraciones contra remoto sin aprobación explícita.
- No conectar datos reales sin RLS, autorización, auditoría y tests.
- No presentar modo demo, mocks o fixtures como producto real.

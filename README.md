# Stasisly

Stasisly es una plataforma de bienestar con arquitectura Flutter/Supabase y una
definición documental centrada en Stasis como sistema nervioso central.

## Estado actual

El proyecto está en fase de Re-foundation documental. La arquitectura futura
está aprobada como diseño, pero no debe confundirse con implementación ni
operación. Backend remoto, producción, datos reales, IA, Stasis Engine, pagos y
nuevas surfaces requieren paquetes y aprobaciones posteriores.

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

- `docs/stasisly_refoundation/00_MASTER_REFOUNDATION.md` — fuente normativa
  maestra vigente.
- `docs/stasisly_refoundation/decisions/` — ADR Re-foundation aprobados.
- `docs/stasisly_refoundation/10_IMPLEMENTATION_STATUS.md` — separación entre
  diseño, implementación y operación.
- `docs/stasisly_foundation/` — evidencia Foundation preservada y no normativa.
- `docs/archive/discovery/` — evidencia Discovery preservada y no normativa.

La documentación demuestra decisiones. El código y las pruebas demuestran
implementación. Los prompts y planes bajo el archivo de Descubrimiento no deben
ejecutarse.

## Reglas de seguridad

- No versionar secretos, tokens ni archivos `.env`.
- No ejecutar migraciones contra remoto sin aprobación explícita.
- No conectar datos reales sin RLS, autorización, auditoría y tests.
- No presentar modo demo, mocks o fixtures como producto real.

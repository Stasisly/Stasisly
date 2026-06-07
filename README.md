# Stasisly

Plataforma integral de bienestar físico y mental con agentes de inteligencia artificial especializados.

## Requisitos Previos

- Flutter SDK `^3.10.0`
- Dart SDK `^3.10.0`
- Configuración de variables de entorno (Supabase, Firebase, Sentry)

## Configuración de Entorno

Crea un archivo de configuración para tus variables de entorno si lo deseas, o inyéctalas directamente en el comando de compilación:

```bash
flutter run --dart-define=SUPABASE_URL="https://tu-proyecto.supabase.co" \
            --dart-define=SUPABASE_ANON_KEY="tu-anon-key"
```

## Arquitectura

El proyecto sigue **Clean Architecture** combinada con **Arquitectura Hexagonal** y el patrón **MVVM** en la capa de presentación. 
El manejo de dependencias y estado se realiza mediante **Riverpod**.

Para más detalles, consulta `docs/ARCHITECTURE.md`.

## Documentación

La definición completa del proyecto y requisitos se encuentra en `docs/PROJECT_DEFINITION_FINAL.md`.
El seguimiento de cambios se documenta en `docs/SESSION_TRACKER.md`.

## Testing

```bash
flutter test
```

Para correr el linter con reglas estrictas:

```bash
flutter analyze
```

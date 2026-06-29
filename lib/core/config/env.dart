/// Environment configuration for Stasisly.
///
/// Values are injected at build time via `--dart-define`.
/// Example:
/// ```bash
/// flutter run --dart-define=SUPABASE_URL=https://xxx.supabase.co
/// ```
abstract final class Env {
  /// Runtime mode: local, demo, development, staging, backendReal or production.
  /// Demo is the current compatibility default and remains local-only.
  static const String appMode = String.fromEnvironment(
    'APP_MODE',
    defaultValue: 'demo',
  );

  /// Supabase project URL.
  static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL');

  /// Supabase anonymous key (public).
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
  );

  /// Sentry DSN for error tracking.
  static const String sentryDsn = String.fromEnvironment('SENTRY_DSN');

  /// Backend URL for file processing (Docker/K8s).
  static const String processingBackendUrl = String.fromEnvironment(
    'PROCESSING_BACKEND_URL',
    defaultValue: 'http://localhost:8000',
  );

  /// Whether the app is running in production.
  static const bool isProduction = bool.fromEnvironment('PRODUCTION');

  /// Whether Sentry is enabled.
  static bool get isSentryEnabled => sentryDsn.isNotEmpty;
}

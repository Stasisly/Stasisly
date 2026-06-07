/// Environment configuration for Stasisly.
///
/// Values are injected at build time via `--dart-define`.
/// Example:
/// ```
/// flutter run --dart-define=SUPABASE_URL=https://xxx.supabase.co
/// ```
abstract final class Env {
  /// Supabase project URL.
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://your-project.supabase.co',
  );

  /// Supabase anonymous key (public).
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'your-anon-key',
  );

  /// Sentry DSN for error tracking.
  static const String sentryDsn = String.fromEnvironment(
    'SENTRY_DSN',
    defaultValue: '',
  );

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

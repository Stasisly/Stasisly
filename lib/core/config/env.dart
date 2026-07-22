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

  /// Explicit backend target classification; never inferred from the URL.
  static const String backendTargetEnvironment = String.fromEnvironment(
    'BACKEND_TARGET_ENVIRONMENT',
    defaultValue: 'unassigned',
  );

  /// Explicit gate for remote backend usage in development.
  static const bool enableRemoteBackend = bool.fromEnvironment(
    'ENABLE_REMOTE_BACKEND',
  );

  /// Explicit gate for real/synthetic auth token usage in development.
  static const bool enableRealAuth = bool.fromEnvironment('ENABLE_REAL_AUTH');

  /// Real user data stays disabled until a separate package approves it.
  static const bool enableRealData = bool.fromEnvironment('ENABLE_REAL_DATA');

  /// Development-only diagnostic routes are enabled by default outside release.
  static const bool allowDevRoutes = bool.fromEnvironment(
    'ALLOW_DEV_ROUTES',
    defaultValue: true,
  );

  /// Product conversations route remains disabled until explicitly approved.
  static const bool enableConversationsRoute = bool.fromEnvironment(
    'ENABLE_CONVERSATIONS_ROUTE',
  );

  /// Temporary development-only synthetic JWT. Never commit real values.
  static const String syntheticAccessToken = String.fromEnvironment(
    'SYNTHETIC_ACCESS_TOKEN',
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

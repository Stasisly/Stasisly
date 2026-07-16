import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:stasisly/core/config/env.dart';

/// Runtime modes supported by the stabilized prototype.
enum AppRuntimeMode {
  local,
  demo,
  development,
  staging,
  backendReal,
  production,
}

/// Raised when a runtime mode cannot start safely.
class AppConfigurationException implements Exception {
  const AppConfigurationException(this.message);

  final String message;

  @override
  String toString() => 'AppConfigurationException: $message';
}

/// Centralized, testable runtime configuration.
class AppEnvironment {
  const AppEnvironment({
    required this.mode,
    this.supabaseUrl = '',
    this.supabaseAnonKey = '',
    this.remoteBackendEnabled = false,
    this.realAuthEnabled = false,
    this.realDataEnabled = false,
    this.devRoutesEnabled = true,
    this.conversationsRouteEnabled = false,
  });

  factory AppEnvironment.fromEnvironment() {
    return AppEnvironment(
      mode: parseMode(Env.appMode),
      supabaseUrl: Env.supabaseUrl,
      supabaseAnonKey: Env.supabaseAnonKey,
      remoteBackendEnabled: Env.enableRemoteBackend,
      realAuthEnabled: Env.enableRealAuth,
      realDataEnabled: Env.enableRealData,
      devRoutesEnabled: Env.allowDevRoutes,
      conversationsRouteEnabled: Env.enableConversationsRoute,
    );
  }

  final AppRuntimeMode mode;
  final String supabaseUrl;
  final String supabaseAnonKey;
  final bool remoteBackendEnabled;
  final bool realAuthEnabled;
  final bool realDataEnabled;
  final bool devRoutesEnabled;
  final bool conversationsRouteEnabled;

  bool get isLocal => mode == AppRuntimeMode.local;
  bool get isDemo => mode == AppRuntimeMode.demo;
  bool get isDevelopment => mode == AppRuntimeMode.development;
  bool get isStaging => mode == AppRuntimeMode.staging;
  bool get isBackendRealLegacy => mode == AppRuntimeMode.backendReal;
  bool get isProduction => mode == AppRuntimeMode.production;
  bool get usesBackend => !(isLocal || isDemo);
  bool get allowsRemoteSupabase =>
      isDevelopment && remoteBackendEnabled && !realDataEnabled;
  bool get allowsRealAuth => allowsRemoteSupabase && realAuthEnabled;
  bool get allowsRealData => false;
  bool get allowsSyntheticData => !isProduction;
  bool get allowsDevRoutes => devRoutesEnabled && (isLocal || isDevelopment);
  bool get allowsConversationsRoute => false;
  bool get requiresSecrets => usesBackend;

  String get visibleLabel => switch (mode) {
    AppRuntimeMode.local => 'LOCAL · SIN BACKEND REAL',
    AppRuntimeMode.demo => 'MODO DEMO · DATOS FICTICIOS',
    AppRuntimeMode.development => 'DEVELOPMENT · BLOQUEADO',
    AppRuntimeMode.staging => 'STAGING · BLOQUEADO',
    AppRuntimeMode.backendReal => 'BACKEND REAL · NO PRODUCCIÓN',
    AppRuntimeMode.production => 'PRODUCCIÓN',
  };

  /// Validates configuration without activating a real backend.
  void validateForStartup({
    bool backendActivationApproved = false,
    bool productionActivationApproved = false,
  }) {
    if (isLocal || isDemo) return;

    if (supabaseUrl.isEmpty || supabaseAnonKey.isEmpty) {
      throw AppConfigurationException(
        '${_modeLabel()} bloqueado: faltan SUPABASE_URL o SUPABASE_ANON_KEY.',
      );
    }

    if (!backendActivationApproved && !allowsRemoteSupabase) {
      throw AppConfigurationException(
        '${_modeLabel()} bloqueado por ADR-006 hasta aprobar auth, RLS y pruebas.',
      );
    }

    if (isProduction && !productionActivationApproved) {
      throw const AppConfigurationException(
        'Production bloqueado por ADR-006 hasta aprobar gates de producción.',
      );
    }
  }

  static AppRuntimeMode parseMode(String value) {
    return switch (value.trim().toLowerCase()) {
      '' || 'demo' => AppRuntimeMode.demo,
      'local' => AppRuntimeMode.local,
      'development' || 'dev' => AppRuntimeMode.development,
      'staging' || 'stage' => AppRuntimeMode.staging,
      'backend' ||
      'backendreal' ||
      'backend_real' => AppRuntimeMode.backendReal,
      'production' || 'produccion' => AppRuntimeMode.production,
      _ => throw AppConfigurationException(
        'APP_MODE no válido: "$value". Usa local, demo, development, staging, backendReal o production.',
      ),
    };
  }

  String _modeLabel() => switch (mode) {
    AppRuntimeMode.local => 'Local',
    AppRuntimeMode.demo => 'Demo',
    AppRuntimeMode.development => 'Development',
    AppRuntimeMode.staging => 'Staging',
    AppRuntimeMode.backendReal => 'Backend real legacy',
    AppRuntimeMode.production => 'Production',
  };
}

/// Overridden at application startup and in tests.
final appEnvironmentProvider = Provider<AppEnvironment>(
  (ref) => AppEnvironment.fromEnvironment(),
);

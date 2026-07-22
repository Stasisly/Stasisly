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

/// Explicit classification of the configured backend target.
enum BackendTargetEnvironment { unassigned, development, staging, production }

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
    this.backendTargetEnvironment = BackendTargetEnvironment.unassigned,
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
      backendTargetEnvironment: parseBackendTargetEnvironment(
        Env.backendTargetEnvironment,
      ),
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
  final BackendTargetEnvironment backendTargetEnvironment;
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
      isDevelopment &&
      backendTargetEnvironment == BackendTargetEnvironment.development &&
      remoteBackendEnabled &&
      !realDataEnabled &&
      _hasCompleteRemoteConfiguration;
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
    if (isLocal || isDemo) {
      if (remoteBackendEnabled ||
          backendTargetEnvironment != BackendTargetEnvironment.unassigned) {
        throw const AppConfigurationException(
          'Configuración bloqueada: el modo local/demo no puede seleccionar un backend remoto.',
        );
      }
      return;
    }

    if (supabaseUrl.isEmpty || supabaseAnonKey.isEmpty) {
      throw AppConfigurationException(
        '${_modeLabel()} bloqueado: faltan SUPABASE_URL o SUPABASE_ANON_KEY.',
      );
    }

    if (!_hasCompleteRemoteConfiguration) {
      throw AppConfigurationException(
        '${_modeLabel()} bloqueado: configuración remota inválida o placeholder.',
      );
    }

    if (isProduction) {
      if (!productionActivationApproved) {
        throw const AppConfigurationException('Production bloqueado.');
      }
      throw const AppConfigurationException(
        'Production bloqueado: este paquete no autoriza activación.',
      );
    }

    if (!isDevelopment ||
        backendTargetEnvironment != BackendTargetEnvironment.development) {
      throw AppConfigurationException(
        '${_modeLabel()} bloqueado: el entorno de aplicación y el destino backend no coinciden.',
      );
    }

    if (!allowsRemoteSupabase) {
      throw const AppConfigurationException(
        'Development bloqueado: configuración incompleta o capacidades no autorizadas.',
      );
    }

    if (!backendActivationApproved) {
      throw const AppConfigurationException(
        'Development bloqueado: requiere autorización remota explícita.',
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
      _ => throw const AppConfigurationException(
        'APP_MODE no válido. Usa local, demo, development, staging, backendReal o production.',
      ),
    };
  }

  static BackendTargetEnvironment parseBackendTargetEnvironment(String value) {
    return switch (value.trim().toLowerCase()) {
      '' || 'unassigned' => BackendTargetEnvironment.unassigned,
      'development' => BackendTargetEnvironment.development,
      'staging' => BackendTargetEnvironment.staging,
      'production' => BackendTargetEnvironment.production,
      _ => throw const AppConfigurationException(
        'BACKEND_TARGET_ENVIRONMENT no válido.',
      ),
    };
  }

  bool get _hasCompleteRemoteConfiguration {
    if (_isPlaceholder(supabaseUrl) || _isPlaceholder(supabaseAnonKey)) {
      return false;
    }
    final uri = Uri.tryParse(supabaseUrl);
    return uri != null &&
        uri.scheme == 'https' &&
        uri.host.isNotEmpty &&
        uri.userInfo.isEmpty &&
        supabaseAnonKey.trim().isNotEmpty;
  }

  static bool _isPlaceholder(String value) {
    final normalized = value.trim().toLowerCase();
    return normalized.isEmpty ||
        normalized.contains('placeholder') ||
        normalized.contains('example') ||
        normalized.contains('<') ||
        normalized.contains('your_');
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

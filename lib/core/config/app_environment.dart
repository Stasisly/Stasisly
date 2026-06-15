import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:stasisly/core/config/env.dart';

/// Runtime modes supported by the stabilized prototype.
enum AppRuntimeMode { demo, backendReal, production }

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
  });

  factory AppEnvironment.fromEnvironment() {
    return AppEnvironment(
      mode: parseMode(Env.appMode),
      supabaseUrl: Env.supabaseUrl,
      supabaseAnonKey: Env.supabaseAnonKey,
    );
  }

  final AppRuntimeMode mode;
  final String supabaseUrl;
  final String supabaseAnonKey;

  bool get isDemo => mode == AppRuntimeMode.demo;
  bool get usesBackend => !isDemo;

  String get visibleLabel => switch (mode) {
    AppRuntimeMode.demo => 'MODO DEMO · DATOS FICTICIOS',
    AppRuntimeMode.backendReal => 'BACKEND REAL · NO PRODUCCIÓN',
    AppRuntimeMode.production => 'PRODUCCIÓN',
  };

  /// Validates configuration without activating a real backend.
  void validateForStartup({bool backendActivationApproved = false}) {
    if (isDemo) return;

    if (supabaseUrl.isEmpty || supabaseAnonKey.isEmpty) {
      throw const AppConfigurationException(
        'Backend real bloqueado: faltan SUPABASE_URL o SUPABASE_ANON_KEY.',
      );
    }

    if (!backendActivationApproved) {
      throw const AppConfigurationException(
        'Backend real bloqueado por ADR-006 hasta aprobar auth, RLS y pruebas.',
      );
    }
  }

  static AppRuntimeMode parseMode(String value) {
    return switch (value.trim().toLowerCase()) {
      '' || 'demo' => AppRuntimeMode.demo,
      'backend' ||
      'backendreal' ||
      'backend_real' => AppRuntimeMode.backendReal,
      'production' || 'produccion' => AppRuntimeMode.production,
      _ => throw AppConfigurationException(
        'APP_MODE no válido: "$value". Usa demo, backendReal o production.',
      ),
    };
  }
}

/// Overridden at application startup and in tests.
final appEnvironmentProvider = Provider<AppEnvironment>(
  (ref) => AppEnvironment.fromEnvironment(),
);

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  final sessionFiles = Directory('lib/core/auth/session')
      .listSync(recursive: true)
      .whereType<File>()
      .where((file) => file.path.endsWith('.dart'))
      .toList(growable: false);

  test('secure session contract exists in core', () {
    expect(sessionFiles, isNotEmpty);

    final provider = File(
      'lib/core/auth/session/secure_session_token_provider.dart',
    ).readAsStringSync();

    expect(provider, contains('abstract interface class'));
    expect(provider, contains('currentAuthState'));
    expect(provider, contains('getAccessToken'));
    expect(provider, contains('refreshIfNeeded'));
    expect(provider, contains('clearSession'));
  });

  test('secure session controller and providers exist', () {
    final state = File(
      'lib/core/auth/session/application/secure_session_state.dart',
    ).readAsStringSync();
    final controller = File(
      'lib/core/auth/session/application/secure_session_controller.dart',
    ).readAsStringSync();
    final providers = File(
      'lib/core/auth/session/providers/secure_session_providers.dart',
    ).readAsStringSync();

    expect(state, contains('class SecureSessionState'));
    expect(state, contains('lastError'));
    expect(state, isNot(contains('accessToken')));
    expect(state, isNot(contains('token;')));
    expect(controller, contains('class SecureSessionController'));
    expect(controller, contains('checkCurrentSession'));
    expect(controller, contains('refreshIfNeeded'));
    expect(controller, contains('clearSession'));
    expect(providers, contains('secureSessionTokenProvider'));
    expect(providers, contains('secureSessionControllerProvider'));
    expect(providers, contains('secureSessionStateProvider'));
    expect(providers, contains('StateNotifierProvider'));
  });

  test('secure real session contract exists without real backend adapter', () {
    final source = File(
      'lib/core/auth/session/real/secure_real_session_source.dart',
    ).readAsStringSync();
    final snapshot = File(
      'lib/core/auth/session/real/secure_real_session_snapshot.dart',
    ).readAsStringSync();
    final guard = File(
      'lib/core/auth/session/real/secure_real_session_guard.dart',
    ).readAsStringSync();
    final provider = File(
      'lib/core/auth/session/real/base_secure_real_session_token_provider.dart',
    ).readAsStringSync();

    expect(
      source,
      contains('abstract interface class SecureRealSessionSource'),
    );
    expect(source, contains('readCurrentSession'));
    expect(source, contains('refreshSession'));
    expect(source, contains('clearSession'));
    expect(snapshot, contains('class SecureRealSessionSnapshot'));
    expect(snapshot, contains('authenticated'));
    expect(guard, contains('class SecureRealSessionGuard'));
    expect(guard, contains('productionBlocked'));
    expect(provider, contains('class BaseSecureRealSessionTokenProvider'));

    for (final forbidden in [
      'SupabaseSecureSessionTokenProvider',
      'AuthRepositorySecureSessionTokenProvider',
      'Supabase.instance.client',
      'SupabaseAuthDataSource',
      'authControllerProvider',
    ]) {
      expect(provider, isNot(contains(forbidden)));
    }
  });

  test('mockable real session provider stays local safe', () {
    final source = File(
      'lib/core/auth/session/real/mockable_secure_real_session_source.dart',
    ).readAsStringSync();
    final provider = File(
      'lib/core/auth/session/real/mockable_secure_real_session_token_provider.dart',
    ).readAsStringSync();
    final fixtures = File(
      'lib/core/auth/session/real/secure_real_session_fixtures.dart',
    ).readAsStringSync();

    expect(source, contains('class MockableSecureRealSessionSource'));
    expect(source, contains('readCurrentSession'));
    expect(source, contains('refreshSession'));
    expect(source, contains('clearSession'));
    expect(provider, contains('class MockableSecureRealSessionTokenProvider'));
    expect(provider, contains('BaseSecureRealSessionTokenProvider'));
    expect(fixtures, contains('fake-local-session-token'));
    expect(fixtures, contains('fake-local-refreshed-session-token'));

    for (final fileSource in [source, provider, fixtures]) {
      for (final forbidden in [
        'supabase_flutter',
        'Supabase.instance',
        'features/auth',
        'auth_providers',
        'AuthController',
        'SupabaseAuthDataSource',
        'AuthRepositoryImpl',
        'package:dio/',
        'package:http/',
        '/functions/v1/',
        'service_role',
        'serviceRole',
        'Bearer ',
      ]) {
        expect(fileSource, isNot(contains(forbidden)));
      }
    }
  });

  test('secure session token adapter stays neutral and feature free', () {
    final adapter = File(
      'lib/core/auth/session/adapters/secure_session_to_local_session_token_adapter.dart',
    ).readAsStringSync();

    expect(adapter, contains('class SecureSessionToLocalSessionTokenAdapter'));
    expect(adapter, contains('readLocalSessionToken'));
    expect(adapter, contains('SecureSessionTokenProvider'));
    expect(adapter, isNot(contains('LocalHttpOwnChatSessionsDataSource')));
    expect(adapter, isNot(contains('LocalHttpOwnChatMessagesDataSource')));

    for (final forbidden in [
      'features/auth',
      'features/chat',
      'features/chat_sessions',
      'features/chat_messages',
      'supabase_flutter',
      'supabase',
      'Supabase.instance',
      'auth_providers',
      'AuthController',
      'SupabaseAuthDataSource',
      'package:dio/',
      'package:http/',
      '/functions/v1/',
      'service_role',
      'serviceRole',
      'BuildContext',
      'Widget',
      'StasisEngine',
      'MCP',
      'streaming',
      'Bearer ',
    ]) {
      expect(adapter, isNot(contains(forbidden)));
    }
  });

  test('secure session core has no network, backend or legacy imports', () {
    for (final file in sessionFiles) {
      final source = file.readAsStringSync();
      for (final forbidden in [
        'supabase_flutter',
        'supabase',
        'Supabase.instance',
        'package:dio/',
        'package:http/',
        'dart:io',
        'dart:html',
        'firebase',
        '/functions/v1/',
        'service_role',
        'serviceRole',
        'access_token',
        'refresh_token',
        'features/auth/',
        'features/chat/',
        'features/chat_messages/presentation',
        'features/chat_sessions/presentation',
        'StasisEngine',
        'MCP',
        'streaming',
      ]) {
        expect(source, isNot(contains(forbidden)), reason: file.path);
      }
    }
  });

  test('safe providers do not embed token literals', () {
    final source = File(
      'lib/core/auth/session/secure_session_token_provider.dart',
    ).readAsStringSync();

    for (final forbidden in [
      'Bearer ',
      'jwt',
      'JWT',
      'local-token',
      'valid-local-jwt',
      'anonKey',
      'SUPABASE',
    ]) {
      expect(source, isNot(contains(forbidden)));
    }
  });

  test('Riverpod is isolated to secure session providers only', () {
    for (final file in sessionFiles) {
      final source = file.readAsStringSync();
      final isProviderFile = file.path.endsWith(
        'providers/secure_session_providers.dart',
      );

      if (isProviderFile) {
        expect(
          source,
          contains('package:flutter_riverpod/flutter_riverpod.dart'),
        );
      } else {
        expect(
          source,
          isNot(contains('package:flutter_riverpod/flutter_riverpod.dart')),
          reason: file.path,
        );
        expect(source, isNot(contains('StateNotifier')), reason: file.path);
        expect(source, isNot(contains('Provider<')), reason: file.path);
      }
    }
  });

  test(
    'secure session providers do not import legacy auth or chat features',
    () {
      final source = File(
        'lib/core/auth/session/providers/secure_session_providers.dart',
      ).readAsStringSync();

      for (final forbidden in [
        'features/auth/',
        'features/chat/',
        'features/chat_messages/',
        'features/chat_sessions/',
        'AuthController',
        'authControllerProvider',
        'auth_providers',
        'SupabaseAuthDataSource',
        'Supabase.instance',
        'getAccessToken()',
        'Bearer ',
      ]) {
        expect(source, isNot(contains(forbidden)));
      }
    },
  );

  test('secure real session layer has no backend SDK or legacy imports', () {
    final realFiles = Directory('lib/core/auth/session/real')
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'))
        .toList(growable: false);

    expect(realFiles, isNotEmpty);

    for (final file in realFiles) {
      final source = file.readAsStringSync();
      for (final forbidden in [
        'supabase_flutter',
        'supabase',
        'Supabase.instance',
        'features/auth',
        'auth_providers',
        'AuthController',
        'SupabaseAuthDataSource',
        'AuthRepositoryImpl',
        'package:dio/',
        'package:http/',
        'dart:io',
        'dart:html',
        'firebase',
        '/functions/v1/',
        'service_role',
        'serviceRole',
        'access_token',
        'refresh_token',
        'features/chat/',
        'features/chat_sessions/presentation',
        'features/chat_messages/presentation',
        'StasisEngine',
        'MCP',
        'streaming',
      ]) {
        expect(source, isNot(contains(forbidden)), reason: file.path);
      }
    }
  });

  test('demo and backendBlocked are explicit non-success token results', () {
    final resultSource = File(
      'lib/core/auth/session/secure_session_token_result.dart',
    ).readAsStringSync();

    expect(resultSource, contains('SecureSessionTokenStatus.demo'));
    expect(resultSource, contains('SecureSessionTokenStatus.backendBlocked'));
    expect(resultSource, contains('demoModeNoRealToken'));
    expect(
      resultSource,
      contains('status == SecureSessionTokenStatus.success'),
    );
  });
}

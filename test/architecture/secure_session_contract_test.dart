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

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  final environmentFiles = [
    File('lib/core/config/app_environment.dart'),
    File('lib/core/config/env.dart'),
  ];

  test('core config exposes environment skeleton without real connections', () {
    final source = File(
      'lib/core/config/app_environment.dart',
    ).readAsStringSync();

    expect(source, contains('AppRuntimeMode'));
    expect(source, contains('local'));
    expect(source, contains('development'));
    expect(source, contains('staging'));
    expect(source, contains('backendReal'));
    expect(source, contains('isDevelopment && remoteBackendEnabled'));
    expect(source, contains('allowsRemoteSupabase && realAuthEnabled'));
    expect(source, contains('allowsRealData => false'));
    expect(source, contains('allowsConversationsRoute => false'));
    expect(source, contains('validateForStartup'));
  });

  test(
    'core config does not contain client secrets or legacy feature imports',
    () {
      expect(environmentFiles, isNotEmpty);

      for (final file in environmentFiles) {
        final source = file.readAsStringSync();

        for (final forbidden in [
          'SUPABASE_SERVICE_ROLE_KEY',
          'service_role',
          'serviceRole',
          'Authorization:',
          'Bearer ',
          'refresh_token',
          'production-secret',
          'features/auth',
          'features/chat',
          'SupabaseChatDataSource',
          'Supabase.instance.client',
          '/functions/v1/',
        ]) {
          expect(source, isNot(contains(forbidden)), reason: file.path);
        }
      }
    },
  );

  test('product conversations route uses canonical explicit parameter', () {
    final routesSource = File('lib/core/config/routes.dart').readAsStringSync();
    final registrySource = File(
      'lib/core/routing/infrastructure/entry_point_registry.dart',
    ).readAsStringSync();

    expect(registrySource, contains("pathPattern: '/conversations'"));
    expect(
      registrySource,
      contains("pathPattern: '/conversations/:conversationId'"),
    );
    expect(routesSource, isNot(contains("path: '/conversations/:sessionId'")));
    expect(routesSource, isNot(contains("path: '/conversations/:id'")));
    expect(routesSource, isNot(contains("path: '/conversations/:agentId'")));
    expect(routesSource, isNot(contains("path: '/conversation'")));
    expect(routesSource, isNot(contains("path: '/conversation/:sessionId'")));
  });
}

import 'package:flutter_test/flutter_test.dart';

import 'package:stasisly/core/config/app_environment.dart';

void main() {
  group('AppEnvironment', () {
    test('demo is the safe empty/default mode', () {
      expect(AppEnvironment.parseMode(''), AppRuntimeMode.demo);
      expect(AppEnvironment.parseMode('demo'), AppRuntimeMode.demo);

      const environment = AppEnvironment(mode: AppRuntimeMode.demo);
      expect(environment.isDemo, isTrue);
      expect(environment.validateForStartup, returnsNormally);
    });

    test('backend real without configuration is blocked explicitly', () {
      const environment = AppEnvironment(mode: AppRuntimeMode.backendReal);

      expect(
        environment.validateForStartup,
        throwsA(
          isA<AppConfigurationException>().having(
            (error) => error.message,
            'message',
            contains('faltan SUPABASE_URL'),
          ),
        ),
      );
    });

    test('backend real remains blocked even with configuration', () {
      const environment = AppEnvironment(
        mode: AppRuntimeMode.backendReal,
        supabaseUrl: 'https://example.invalid',
        supabaseAnonKey: 'public-test-key',
      );

      expect(
        environment.validateForStartup,
        throwsA(
          isA<AppConfigurationException>().having(
            (error) => error.message,
            'message',
            contains('bloqueado por ADR-006'),
          ),
        ),
      );
    });
  });
}

import 'package:flutter_test/flutter_test.dart';

import 'package:stasisly/core/config/app_environment.dart';

void main() {
  group('AppEnvironment', () {
    test('parses official modes and transitional backendReal', () {
      expect(AppEnvironment.parseMode('local'), AppRuntimeMode.local);
      expect(AppEnvironment.parseMode(''), AppRuntimeMode.demo);
      expect(AppEnvironment.parseMode('demo'), AppRuntimeMode.demo);
      expect(
        AppEnvironment.parseMode('development'),
        AppRuntimeMode.development,
      );
      expect(AppEnvironment.parseMode('dev'), AppRuntimeMode.development);
      expect(AppEnvironment.parseMode('staging'), AppRuntimeMode.staging);
      expect(AppEnvironment.parseMode('stage'), AppRuntimeMode.staging);
      expect(
        AppEnvironment.parseMode('backendReal'),
        AppRuntimeMode.backendReal,
      );
      expect(
        AppEnvironment.parseMode('backend_real'),
        AppRuntimeMode.backendReal,
      );
      expect(AppEnvironment.parseMode('production'), AppRuntimeMode.production);
    });

    test('unknown APP_MODE fails closed', () {
      expect(
        () => AppEnvironment.parseMode('prod-real'),
        throwsA(
          isA<AppConfigurationException>().having(
            (error) => error.message,
            'message',
            contains('APP_MODE no válido'),
          ),
        ),
      );
    });

    test('empty APP_MODE keeps documented compatibility default', () {
      expect(AppEnvironment.parseMode(''), AppRuntimeMode.demo);
    });

    test('local and demo do not use backend', () {
      const local = AppEnvironment(mode: AppRuntimeMode.local);
      const demo = AppEnvironment(mode: AppRuntimeMode.demo);

      expect(local.isLocal, isTrue);
      expect(local.isDemo, isFalse);
      expect(local.usesBackend, isFalse);
      expect(local.validateForStartup, returnsNormally);

      expect(demo.isDemo, isTrue);
      expect(demo.usesBackend, isFalse);
      expect(demo.validateForStartup, returnsNormally);
    });

    test('derived flags keep real capabilities blocked by default', () {
      const environments = [
        AppEnvironment(mode: AppRuntimeMode.local),
        AppEnvironment(mode: AppRuntimeMode.demo),
        AppEnvironment(mode: AppRuntimeMode.development),
        AppEnvironment(mode: AppRuntimeMode.staging),
        AppEnvironment(mode: AppRuntimeMode.backendReal),
        AppEnvironment(mode: AppRuntimeMode.production),
      ];

      for (final environment in environments) {
        expect(environment.allowsRemoteSupabase, isFalse);
        expect(environment.allowsRealAuth, isFalse);
        expect(environment.allowsRealData, isFalse);
        expect(environment.allowsConversationsRoute, isFalse);
      }

      expect(
        const AppEnvironment(mode: AppRuntimeMode.local).allowsSyntheticData,
        isTrue,
      );
      expect(
        const AppEnvironment(mode: AppRuntimeMode.demo).allowsSyntheticData,
        isTrue,
      );
      expect(
        const AppEnvironment(
          mode: AppRuntimeMode.development,
        ).allowsSyntheticData,
        isTrue,
      );
      expect(
        const AppEnvironment(mode: AppRuntimeMode.staging).allowsSyntheticData,
        isTrue,
      );
      expect(
        const AppEnvironment(
          mode: AppRuntimeMode.production,
        ).allowsSyntheticData,
        isFalse,
      );
      expect(
        const AppEnvironment(mode: AppRuntimeMode.production).allowsDevRoutes,
        isFalse,
      );
    });

    test('usesBackend does not imply remote Supabase is allowed', () {
      const environment = AppEnvironment(mode: AppRuntimeMode.development);

      expect(environment.usesBackend, isTrue);
      expect(environment.allowsRemoteSupabase, isFalse);
    });

    test(
      'development remote backend requires explicit gate and real data off',
      () {
        const blockedWithoutGate = AppEnvironment(
          mode: AppRuntimeMode.development,
          supabaseUrl: 'https://project.supabase.co',
          supabaseAnonKey: 'public-test-key',
        );
        const allowed = AppEnvironment(
          mode: AppRuntimeMode.development,
          supabaseUrl: 'https://project.supabase.co',
          supabaseAnonKey: 'public-test-key',
          remoteBackendEnabled: true,
          realAuthEnabled: true,
        );
        const blockedWithRealData = AppEnvironment(
          mode: AppRuntimeMode.development,
          supabaseUrl: 'https://project.supabase.co',
          supabaseAnonKey: 'public-test-key',
          remoteBackendEnabled: true,
          realAuthEnabled: true,
          realDataEnabled: true,
        );

        expect(blockedWithoutGate.allowsRemoteSupabase, isFalse);
        expect(allowed.allowsRemoteSupabase, isTrue);
        expect(allowed.allowsRealAuth, isTrue);
        expect(allowed.allowsRealData, isFalse);
        expect(blockedWithRealData.allowsRemoteSupabase, isFalse);
        expect(blockedWithRealData.allowsRealAuth, isFalse);
      },
    );

    test(
      'remote backend gate does not open staging, backendReal or production',
      () {
        for (final mode in [
          AppRuntimeMode.staging,
          AppRuntimeMode.backendReal,
          AppRuntimeMode.production,
        ]) {
          final environment = AppEnvironment(
            mode: mode,
            supabaseUrl: 'https://project.supabase.co',
            supabaseAnonKey: 'public-test-key',
            remoteBackendEnabled: true,
            realAuthEnabled: true,
          );

          expect(environment.allowsRemoteSupabase, isFalse);
          expect(environment.allowsRealAuth, isFalse);
        }
      },
    );

    test(
      'incomplete development backend gates fail closed without demo fallback',
      () {
        const cases = [
          AppEnvironment(
            mode: AppRuntimeMode.development,
            supabaseUrl: 'https://project.supabase.co',
            supabaseAnonKey: 'public-test-key',
            remoteBackendEnabled: false,
            realAuthEnabled: true,
          ),
          AppEnvironment(
            mode: AppRuntimeMode.development,
            supabaseUrl: 'https://project.supabase.co',
            supabaseAnonKey: 'public-test-key',
            remoteBackendEnabled: true,
            realAuthEnabled: true,
            realDataEnabled: true,
          ),
        ];

        for (final environment in cases) {
          expect(environment.isDemo, isFalse);
          expect(environment.allowsRemoteSupabase, isFalse);
          expect(environment.allowsRealAuth, isFalse);
        }
      },
    );

    test('missing real auth gate blocks auth without falling back to demo', () {
      const environment = AppEnvironment(
        mode: AppRuntimeMode.development,
        supabaseUrl: 'https://project.supabase.co',
        supabaseAnonKey: 'public-test-key',
        remoteBackendEnabled: true,
        realAuthEnabled: false,
      );

      expect(environment.isDemo, isFalse);
      expect(environment.allowsRemoteSupabase, isTrue);
      expect(environment.allowsRealAuth, isFalse);
    });

    test('development can disable dev routes without falling back to demo', () {
      const environment = AppEnvironment(
        mode: AppRuntimeMode.development,
        supabaseUrl: 'https://project.supabase.co',
        supabaseAnonKey: 'public-test-key',
        remoteBackendEnabled: true,
        realAuthEnabled: true,
        devRoutesEnabled: false,
      );

      expect(environment.isDemo, isFalse);
      expect(environment.allowsRemoteSupabase, isTrue);
      expect(environment.allowsRealAuth, isTrue);
      expect(environment.allowsDevRoutes, isFalse);
    });

    test('conversations route flag is ignored until a future package', () {
      const environments = [
        AppEnvironment(
          mode: AppRuntimeMode.local,
          conversationsRouteEnabled: true,
        ),
        AppEnvironment(
          mode: AppRuntimeMode.demo,
          conversationsRouteEnabled: true,
        ),
        AppEnvironment(
          mode: AppRuntimeMode.development,
          conversationsRouteEnabled: true,
        ),
        AppEnvironment(
          mode: AppRuntimeMode.staging,
          conversationsRouteEnabled: true,
        ),
        AppEnvironment(
          mode: AppRuntimeMode.production,
          conversationsRouteEnabled: true,
        ),
      ];

      for (final environment in environments) {
        expect(environment.allowsConversationsRoute, isFalse);
      }
    });

    test('staging and production never expose dev routes', () {
      const environments = [
        AppEnvironment(mode: AppRuntimeMode.staging, devRoutesEnabled: true),
        AppEnvironment(mode: AppRuntimeMode.production, devRoutesEnabled: true),
      ];

      for (final environment in environments) {
        expect(environment.allowsDevRoutes, isFalse);
      }
    });

    test('development remote gate can pass startup validation', () {
      const environment = AppEnvironment(
        mode: AppRuntimeMode.development,
        supabaseUrl: 'https://project.supabase.co',
        supabaseAnonKey: 'public-test-key',
        remoteBackendEnabled: true,
      );

      expect(environment.validateForStartup, returnsNormally);
    });

    test('backend-like modes without configuration are blocked explicitly', () {
      const environments = [
        AppEnvironment(mode: AppRuntimeMode.development),
        AppEnvironment(mode: AppRuntimeMode.staging),
        AppEnvironment(mode: AppRuntimeMode.backendReal),
        AppEnvironment(mode: AppRuntimeMode.production),
      ];

      for (final environment in environments) {
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
      }
    });

    test('backend-like modes remain blocked even with configuration', () {
      const environments = [
        AppEnvironment(
          mode: AppRuntimeMode.development,
          supabaseUrl: 'https://example.invalid',
          supabaseAnonKey: 'public-test-key',
        ),
        AppEnvironment(
          mode: AppRuntimeMode.staging,
          supabaseUrl: 'https://example.invalid',
          supabaseAnonKey: 'public-test-key',
        ),
        AppEnvironment(
          mode: AppRuntimeMode.backendReal,
          supabaseUrl: 'https://example.invalid',
          supabaseAnonKey: 'public-test-key',
        ),
        AppEnvironment(
          mode: AppRuntimeMode.production,
          supabaseUrl: 'https://example.invalid',
          supabaseAnonKey: 'public-test-key',
        ),
      ];

      for (final environment in environments) {
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
      }
    });

    test('production remains blocked without production gates', () {
      const environment = AppEnvironment(
        mode: AppRuntimeMode.production,
        supabaseUrl: 'https://example.invalid',
        supabaseAnonKey: 'public-test-key',
      );

      expect(
        () => environment.validateForStartup(backendActivationApproved: true),
        throwsA(
          isA<AppConfigurationException>().having(
            (error) => error.message,
            'message',
            contains('Production bloqueado'),
          ),
        ),
      );
    });

    test('dev routes can be disabled explicitly', () {
      const environment = AppEnvironment(
        mode: AppRuntimeMode.development,
        devRoutesEnabled: false,
      );

      expect(environment.allowsDevRoutes, isFalse);
      expect(
        const AppEnvironment(mode: AppRuntimeMode.development).allowsDevRoutes,
        isTrue,
      );
    });
  });
}

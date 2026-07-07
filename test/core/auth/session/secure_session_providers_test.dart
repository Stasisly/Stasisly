import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:stasisly/core/auth/session/application/secure_session_state.dart';
import 'package:stasisly/core/auth/session/providers/secure_session_providers.dart';
import 'package:stasisly/core/auth/session/secure_session_auth_state.dart';
import 'package:stasisly/core/auth/session/secure_session_token_provider.dart';
import 'package:stasisly/core/auth/session/secure_session_token_result.dart';
import 'package:stasisly/core/config/app_environment.dart';

const _syntheticJwtLikeToken = 'header.payload.signature';

void main() {
  test(
    'secureSessionTokenProvider selects explicit demo in demo mode',
    () async {
      final container = ProviderContainer(
        overrides: [
          appEnvironmentProvider.overrideWithValue(
            const AppEnvironment(mode: AppRuntimeMode.demo),
          ),
        ],
      );
      addTearDown(container.dispose);

      final provider = container.read(secureSessionTokenProvider);

      expect(provider, isA<DemoSecureSessionTokenProvider>());
      expect(
        await provider.getAccessToken(),
        const SecureSessionTokenResult.demo(),
      );
    },
  );

  test('backend and production modes stay backendBlocked', () async {
    for (final mode in [
      AppRuntimeMode.backendReal,
      AppRuntimeMode.production,
    ]) {
      final container = ProviderContainer(
        overrides: [
          appEnvironmentProvider.overrideWithValue(AppEnvironment(mode: mode)),
        ],
      );
      addTearDown(container.dispose);

      final provider = container.read(secureSessionTokenProvider);

      expect(provider, isA<BackendBlockedSecureSessionTokenProvider>());
      expect(
        await provider.getAccessToken(),
        const SecureSessionTokenResult.backendBlocked(),
      );
    }
  });

  test('development real auth gate selects synthetic token provider', () async {
    final container = ProviderContainer(
      overrides: [
        appEnvironmentProvider.overrideWithValue(
          const AppEnvironment(
            mode: AppRuntimeMode.development,
            supabaseUrl: 'https://project.supabase.co',
            supabaseAnonKey: 'public-test-key',
            remoteBackendEnabled: true,
            realAuthEnabled: true,
          ),
        ),
        developmentSyntheticAccessTokenProvider.overrideWithValue(
          _syntheticJwtLikeToken,
        ),
      ],
    );
    addTearDown(container.dispose);

    final provider = container.read(secureSessionTokenProvider);

    expect(provider, isA<DevelopmentSyntheticSecureSessionTokenProvider>());
    expect(
      await provider.getAccessToken(),
      SecureSessionTokenResult.success(_syntheticJwtLikeToken),
    );
  });

  test(
    'development synthetic token provider fails closed without usable token',
    () async {
      for (final token in ['', '   ', 'not-a-jwt', 'a.b', 'a.b.', 'a b.c.d']) {
        final provider = DevelopmentSyntheticSecureSessionTokenProvider(
          accessToken: token,
        );

        expect(
          await provider.getAccessToken(),
          const SecureSessionTokenResult.misconfigured(),
          reason: token,
        );
        expect(
          (await provider.currentAuthState()).status,
          SecureSessionAuthStatus.misconfigured,
          reason: token,
        );
      }
    },
  );

  test(
    'synthetic token provider trims but never exposes malformed tokens',
    () async {
      const provider = DevelopmentSyntheticSecureSessionTokenProvider(
        accessToken: '  header.payload.signature  ',
      );

      expect(
        await provider.getAccessToken(),
        SecureSessionTokenResult.success(_syntheticJwtLikeToken),
      );
      expect(
        (await provider.currentAuthState()).status,
        SecureSessionAuthStatus.authenticated,
      );
    },
  );

  test(
    'staging and production never select synthetic token provider',
    () async {
      for (final mode in [AppRuntimeMode.staging, AppRuntimeMode.production]) {
        final container = ProviderContainer(
          overrides: [
            appEnvironmentProvider.overrideWithValue(
              AppEnvironment(
                mode: mode,
                supabaseUrl: 'https://project.supabase.co',
                supabaseAnonKey: 'public-test-key',
                remoteBackendEnabled: true,
                realAuthEnabled: true,
              ),
            ),
            developmentSyntheticAccessTokenProvider.overrideWithValue(
              _syntheticJwtLikeToken,
            ),
          ],
        );
        addTearDown(container.dispose);

        final provider = container.read(secureSessionTokenProvider);

        expect(provider, isA<BackendBlockedSecureSessionTokenProvider>());
        expect(
          await provider.getAccessToken(),
          const SecureSessionTokenResult.backendBlocked(),
        );
      }
    },
  );

  test('explicit safe providers are available', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(
      container.read(demoSecureSessionTokenProvider),
      isA<DemoSecureSessionTokenProvider>(),
    );
    expect(
      container.read(backendBlockedSecureSessionTokenProvider),
      isA<BackendBlockedSecureSessionTokenProvider>(),
    );
    expect(
      container.read(unauthenticatedSecureSessionTokenProvider),
      isA<UnauthenticatedSecureSessionTokenProvider>(),
    );
  });

  test('controller provider exposes initial public state', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(
      container.read(secureSessionControllerProvider.notifier),
      isA<SecureSessionControllerNotifier>(),
    );
    expect(
      container.read(secureSessionStateProvider),
      const SecureSessionState(),
    );
  });

  test(
    'providers are overrideable and checkCurrentSession uses override',
    () async {
      final provider = _FakeTokenProvider(
        authState: const SecureSessionAuthState.authenticated(
          subjectId: 'subject-1',
        ),
      );
      final container = ProviderContainer(
        overrides: [secureSessionTokenProvider.overrideWithValue(provider)],
      );
      addTearDown(container.dispose);

      await container
          .read(secureSessionControllerProvider.notifier)
          .checkCurrentSession();

      expect(provider.currentAuthStateCalls, 1);
      expect(
        container.read(secureSessionStateProvider).isAuthenticated,
        isTrue,
      );
      expect(container.read(secureSessionStateProvider).lastError, isNull);
    },
  );

  test('error provider does not produce demo fallback', () async {
    final container = ProviderContainer(
      overrides: [
        secureSessionTokenProvider.overrideWithValue(_ThrowingTokenProvider()),
      ],
    );
    addTearDown(container.dispose);

    await container
        .read(secureSessionControllerProvider.notifier)
        .checkCurrentSession();

    final state = container.read(secureSessionStateProvider);
    expect(state.isMisconfigured, isTrue);
    expect(state.isDemo, isFalse);
    expect(state.lastError, SecureSessionError.unexpected);
  });

  test('refresh failure remains visible and not authenticated', () async {
    final container = ProviderContainer(
      overrides: [
        secureSessionTokenProvider.overrideWithValue(
          _FakeTokenProvider(
            refreshResult: const SecureSessionTokenResult.expired(),
          ),
        ),
      ],
    );
    addTearDown(container.dispose);

    await container
        .read(secureSessionControllerProvider.notifier)
        .refreshIfNeeded();

    final state = container.read(secureSessionStateProvider);
    expect(state.isExpired, isTrue);
    expect(state.isAuthenticated, isFalse);
    expect(state.lastError, SecureSessionError.expiredSession);
  });

  test('requireAuthenticated never treats demo as authenticated', () async {
    final container = ProviderContainer(
      overrides: [
        appEnvironmentProvider.overrideWithValue(
          const AppEnvironment(mode: AppRuntimeMode.demo),
        ),
      ],
    );
    addTearDown(container.dispose);

    await container
        .read(secureSessionControllerProvider.notifier)
        .checkCurrentSession();

    final result = container
        .read(secureSessionControllerProvider.notifier)
        .requireAuthenticated();

    expect(result, isFalse);
    expect(container.read(secureSessionStateProvider).isDemo, isTrue);
    expect(
      container.read(secureSessionStateProvider).lastError,
      SecureSessionError.demoModeNoRealToken,
    );
  });
}

class _FakeTokenProvider implements SecureSessionTokenProvider {
  _FakeTokenProvider({
    this.authState = const SecureSessionAuthState.unauthenticated(),
    this.refreshResult = const SecureSessionTokenResult.unauthenticated(),
  });

  final SecureSessionAuthState authState;
  final SecureSessionTokenResult refreshResult;

  int currentAuthStateCalls = 0;

  @override
  Future<SecureSessionAuthState> currentAuthState() async {
    currentAuthStateCalls += 1;
    return authState;
  }

  @override
  Future<SecureSessionTokenResult> getAccessToken() async {
    return const SecureSessionTokenResult.unauthenticated();
  }

  @override
  Future<SecureSessionTokenResult> refreshIfNeeded() async {
    return refreshResult;
  }

  @override
  Future<void> clearSession() async {}
}

class _ThrowingTokenProvider implements SecureSessionTokenProvider {
  @override
  Future<SecureSessionAuthState> currentAuthState() async {
    throw StateError('broken session');
  }

  @override
  Future<SecureSessionTokenResult> getAccessToken() async {
    throw StateError('broken session');
  }

  @override
  Future<SecureSessionTokenResult> refreshIfNeeded() async {
    throw StateError('broken session');
  }

  @override
  Future<void> clearSession() async {
    throw StateError('broken session');
  }
}

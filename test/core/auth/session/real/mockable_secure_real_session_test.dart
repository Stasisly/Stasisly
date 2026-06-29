import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:stasisly/core/auth/session/providers/secure_session_providers.dart';
import 'package:stasisly/core/auth/session/real/secure_real_session.dart';
import 'package:stasisly/core/auth/session/secure_session_auth_state.dart';
import 'package:stasisly/core/auth/session/secure_session_token_result.dart';

void main() {
  group('MockableSecureRealSessionSource', () {
    test('authenticated returns a fake authenticated snapshot', () async {
      final source = MockableSecureRealSessionSource.authenticated();

      final snapshot = await source.readCurrentSession();

      expect(snapshot.status, SecureRealSessionSnapshotStatus.authenticated);
      expect(snapshot.token, SecureRealSessionFixtures.fakeToken);
      expect(snapshot.subjectId, SecureRealSessionFixtures.fakeSubjectId);
      expect(snapshot.email, SecureRealSessionFixtures.fakeEmail);
      expect(source.readCalls, 1);
    });

    test('authenticated requires non-empty fake subjectId', () {
      expect(
        () => SecureRealSessionSnapshot.authenticated(
          token: SecureRealSessionFixtures.fakeToken,
          subjectId: '',
        ),
        throwsArgumentError,
      );
    });

    test(
      'non-authenticated factories return explicit non-success states',
      () async {
        final cases = [
          (
            MockableSecureRealSessionSource.unauthenticated(),
            SecureRealSessionSnapshotStatus.unauthenticated,
          ),
          (
            MockableSecureRealSessionSource.expired(),
            SecureRealSessionSnapshotStatus.expired,
          ),
          (
            MockableSecureRealSessionSource.refreshFailed(),
            SecureRealSessionSnapshotStatus.refreshFailed,
          ),
          (
            MockableSecureRealSessionSource.backendBlocked(),
            SecureRealSessionSnapshotStatus.backendBlocked,
          ),
          (
            MockableSecureRealSessionSource.misconfigured(),
            SecureRealSessionSnapshotStatus.misconfigured,
          ),
        ];

        for (final entry in cases) {
          final snapshot = await entry.$1.readCurrentSession();

          expect(snapshot.status, entry.$2);
          expect(snapshot.hasToken, isFalse);
        }
      },
    );

    test('refreshSession can move to refreshed fake snapshot', () async {
      final source = MockableSecureRealSessionSource.authenticated();

      final refreshed = await source.refreshSession();

      expect(refreshed.token, SecureRealSessionFixtures.fakeRefreshedToken);
      expect(source.refreshCalls, 1);
      expect(
        (await source.readCurrentSession()).token,
        SecureRealSessionFixtures.fakeRefreshedToken,
      );
    });

    test('clearSession clears state without exposing token', () async {
      final source = MockableSecureRealSessionSource.authenticated();

      await source.clearSession();
      final snapshot = await source.readCurrentSession();

      expect(source.clearCalls, 1);
      expect(snapshot.status, SecureRealSessionSnapshotStatus.unauthenticated);
      expect(snapshot.token, isNull);
    });
  });

  group('MockableSecureRealSessionTokenProvider', () {
    test('authenticated fake produces success with fake token', () async {
      final provider = MockableSecureRealSessionTokenProvider(
        source: MockableSecureRealSessionSource.authenticated(),
      );

      final authState = await provider.currentAuthState();
      final token = await provider.getAccessToken();

      expect(authState.status, SecureSessionAuthStatus.authenticated);
      expect(authState.subjectId, SecureRealSessionFixtures.fakeSubjectId);
      expect(authState.email, SecureRealSessionFixtures.fakeEmail);
      expect(token.status, SecureSessionTokenStatus.success);
      expect(token.token, SecureRealSessionFixtures.fakeToken);
    });

    test('empty token cannot produce success', () {
      expect(
        () => SecureRealSessionSnapshot.authenticated(
          token: '',
          subjectId: SecureRealSessionFixtures.fakeSubjectId,
        ),
        throwsArgumentError,
      );
    });

    test('non-success states map without demo fallback', () async {
      final cases = [
        (
          MockableSecureRealSessionSource.unauthenticated(),
          SecureSessionTokenStatus.unauthenticated,
        ),
        (
          MockableSecureRealSessionSource.expired(),
          SecureSessionTokenStatus.expired,
        ),
        (
          MockableSecureRealSessionSource.refreshFailed(),
          SecureSessionTokenStatus.refreshFailed,
        ),
        (
          MockableSecureRealSessionSource.backendBlocked(),
          SecureSessionTokenStatus.backendBlocked,
        ),
        (
          MockableSecureRealSessionSource.misconfigured(),
          SecureSessionTokenStatus.misconfigured,
        ),
      ];

      for (final entry in cases) {
        final provider = MockableSecureRealSessionTokenProvider(
          source: entry.$1,
        );

        final result = await provider.getAccessToken();

        expect(result.status, entry.$2);
        expect(result.status, isNot(SecureSessionTokenStatus.demo));
        expect(result.token, isNull);
      }
    });

    test('refreshIfNeeded delegates to source refresh', () async {
      final source = MockableSecureRealSessionSource.authenticated();
      final provider = MockableSecureRealSessionTokenProvider(source: source);

      final result = await provider.refreshIfNeeded();

      expect(result.status, SecureSessionTokenStatus.success);
      expect(result.token, SecureRealSessionFixtures.fakeRefreshedToken);
      expect(source.refreshCalls, 1);
    });

    test('clearSession delegates safely', () async {
      final source = MockableSecureRealSessionSource.authenticated();
      final provider = MockableSecureRealSessionTokenProvider(source: source);

      await provider.clearSession();

      expect(source.clearCalls, 1);
      expect(
        (await provider.currentAuthState()).status,
        SecureSessionAuthStatus.unauthenticated,
      );
    });

    test('source errors do not become demo', () async {
      final provider = MockableSecureRealSessionTokenProvider(
        source: _ThrowingSource(),
      );

      expect(
        await provider.currentAuthState(),
        const SecureSessionAuthState.misconfigured(),
      );
      expect(
        await provider.getAccessToken(),
        const SecureSessionTokenResult.unexpected(),
      );
      expect(
        await provider.refreshIfNeeded(),
        const SecureSessionTokenResult.refreshFailed(),
      );
    });
  });

  group('guard before source', () {
    test('backendBlocked blocks before source', () async {
      final source = MockableSecureRealSessionSource.authenticated();
      final provider = MockableSecureRealSessionTokenProvider(
        config: const SecureRealSessionConfig(
          runtime: SecureRealSessionRuntime.backendReal,
          hasRequiredBackendConfiguration: true,
        ),
        source: source,
      );

      expect(
        await provider.getAccessToken(),
        const SecureSessionTokenResult.backendBlocked(),
      );
      expect(source.readCalls, 0);
      expect(source.refreshCalls, 0);
    });

    test('productionBlocked blocks before source', () async {
      final source = MockableSecureRealSessionSource.authenticated();
      final provider = MockableSecureRealSessionTokenProvider(
        config: const SecureRealSessionConfig(
          runtime: SecureRealSessionRuntime.production,
          hasRequiredBackendConfiguration: true,
          backendActivationApproved: true,
        ),
        source: source,
      );

      expect(
        await provider.getAccessToken(),
        const SecureSessionTokenResult.misconfigured(),
      );
      expect(source.readCalls, 0);
      expect(source.refreshCalls, 0);
    });

    test('misconfigured blocks before source', () async {
      final source = MockableSecureRealSessionSource.authenticated();
      final provider = MockableSecureRealSessionTokenProvider(
        config: const SecureRealSessionConfig(
          runtime: SecureRealSessionRuntime.backendReal,
          backendActivationApproved: true,
        ),
        source: source,
      );

      expect(
        await provider.getAccessToken(),
        const SecureSessionTokenResult.misconfigured(),
      );
      expect(source.readCalls, 0);
      expect(source.refreshCalls, 0);
    });
  });

  group('SecureSession providers integration', () {
    test(
      'provider override can use mockable provider without public token',
      () async {
        final container = ProviderContainer(
          overrides: [
            secureSessionTokenProvider.overrideWithValue(
              MockableSecureRealSessionTokenProvider(
                source: MockableSecureRealSessionSource.authenticated(),
              ),
            ),
          ],
        );
        addTearDown(container.dispose);

        await container
            .read(secureSessionControllerProvider.notifier)
            .checkCurrentSession();

        final state = container.read(secureSessionStateProvider);
        expect(state.isAuthenticated, isTrue);
        expect(
          state.authState.subjectId,
          SecureRealSessionFixtures.fakeSubjectId,
        );
        expect(
          state.toString(),
          isNot(contains(SecureRealSessionFixtures.fakeToken)),
        );
      },
    );
  });
}

class _ThrowingSource implements SecureRealSessionSource {
  @override
  Future<SecureRealSessionSnapshot> readCurrentSession() async {
    throw StateError('fake local source unavailable');
  }

  @override
  Future<SecureRealSessionSnapshot> refreshSession() async {
    throw StateError('fake local source unavailable');
  }

  @override
  Future<void> clearSession() async {
    throw StateError('fake local source unavailable');
  }
}

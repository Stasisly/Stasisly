import 'package:flutter_test/flutter_test.dart';
import 'package:stasisly/core/auth/session/secure_session.dart';

void main() {
  group('secure session auth states', () {
    test('all required auth statuses are represented', () {
      expect(SecureSessionAuthStatus.values, {
        SecureSessionAuthStatus.demo,
        SecureSessionAuthStatus.authenticated,
        SecureSessionAuthStatus.unauthenticated,
        SecureSessionAuthStatus.expired,
        SecureSessionAuthStatus.refreshFailed,
        SecureSessionAuthStatus.backendBlocked,
        SecureSessionAuthStatus.misconfigured,
      });
    });

    test('authenticated state is identity only and grants no token', () {
      const state = SecureSessionAuthState.authenticated(
        subjectId: 'subject-1',
        email: 'user@example.test',
      );

      expect(state.status, SecureSessionAuthStatus.authenticated);
      expect(state.isAuthenticated, isTrue);
      expect(state.canRequestBackendToken, isTrue);
      expect(state.subjectId, 'subject-1');
      expect(state.email, 'user@example.test');
    });

    test('non-authenticated states cannot request backend token', () {
      const states = [
        SecureSessionAuthState.demo(),
        SecureSessionAuthState.unauthenticated(),
        SecureSessionAuthState.expired(),
        SecureSessionAuthState.refreshFailed(),
        SecureSessionAuthState.backendBlocked(),
        SecureSessionAuthState.misconfigured(),
      ];

      for (final state in states) {
        expect(state.canRequestBackendToken, isFalse, reason: '$state');
      }
    });
  });

  group('secure session token results', () {
    test('all required token statuses are represented', () {
      expect(SecureSessionTokenStatus.values, {
        SecureSessionTokenStatus.success,
        SecureSessionTokenStatus.unauthenticated,
        SecureSessionTokenStatus.expired,
        SecureSessionTokenStatus.refreshFailed,
        SecureSessionTokenStatus.backendBlocked,
        SecureSessionTokenStatus.misconfigured,
        SecureSessionTokenStatus.demo,
      });
    });

    test('success requires a non-empty token', () {
      final result = SecureSessionTokenResult.success('future-session-token');

      expect(result.status, SecureSessionTokenStatus.success);
      expect(result.isSuccess, isTrue);
      expect(result.hasToken, isTrue);
      expect(result.token, 'future-session-token');

      expect(
        () => SecureSessionTokenResult.success(''),
        throwsA(isA<ArgumentError>()),
      );
      expect(
        () => SecureSessionTokenResult.success('   '),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('error and non-real states do not carry tokens', () {
      const results = [
        SecureSessionTokenResult.unauthenticated(),
        SecureSessionTokenResult.expired(),
        SecureSessionTokenResult.refreshFailed(),
        SecureSessionTokenResult.backendBlocked(),
        SecureSessionTokenResult.misconfigured(),
        SecureSessionTokenResult.demo(),
        SecureSessionTokenResult.unexpected(),
      ];

      for (final result in results) {
        expect(result.isSuccess, isFalse, reason: '$result');
        expect(result.hasToken, isFalse, reason: '$result');
        expect(result.token, isNull, reason: '$result');
      }
    });

    test('errors are visible and typed', () {
      expect(
        const SecureSessionTokenResult.unauthenticated().error,
        SecureSessionError.missingSession,
      );
      expect(
        const SecureSessionTokenResult.expired().error,
        SecureSessionError.expiredSession,
      );
      expect(
        const SecureSessionTokenResult.refreshFailed().error,
        SecureSessionError.refreshFailed,
      );
      expect(
        const SecureSessionTokenResult.backendBlocked().error,
        SecureSessionError.backendBlocked,
      );
      expect(
        const SecureSessionTokenResult.misconfigured().error,
        SecureSessionError.misconfiguredEnvironment,
      );
      expect(
        const SecureSessionTokenResult.demo().error,
        SecureSessionError.demoModeNoRealToken,
      );
    });
  });

  group('safe providers', () {
    test('demo provider returns demo state and no real token', () async {
      const provider = DemoSecureSessionTokenProvider();

      expect(
        await provider.currentAuthState(),
        const SecureSessionAuthState.demo(),
      );
      expect(
        await provider.getAccessToken(),
        const SecureSessionTokenResult.demo(),
      );
      expect(
        await provider.refreshIfNeeded(),
        const SecureSessionTokenResult.demo(),
      );

      await provider.clearSession();
      expect(
        await provider.getAccessToken(),
        const SecureSessionTokenResult.demo(),
      );
    });

    test(
      'backendBlocked provider returns backendBlocked and no token',
      () async {
        const provider = BackendBlockedSecureSessionTokenProvider();

        expect(
          await provider.currentAuthState(),
          const SecureSessionAuthState.backendBlocked(),
        );
        expect(
          await provider.getAccessToken(),
          const SecureSessionTokenResult.backendBlocked(),
        );
        expect(
          await provider.refreshIfNeeded(),
          const SecureSessionTokenResult.backendBlocked(),
        );

        await provider.clearSession();
        expect(
          await provider.getAccessToken(),
          const SecureSessionTokenResult.backendBlocked(),
        );
      },
    );

    test('unauthenticated provider returns unauthenticated state', () async {
      const provider = UnauthenticatedSecureSessionTokenProvider();

      expect(
        await provider.currentAuthState(),
        const SecureSessionAuthState.unauthenticated(),
      );
      expect(
        await provider.getAccessToken(),
        const SecureSessionTokenResult.unauthenticated(),
      );
      expect(
        await provider.refreshIfNeeded(),
        const SecureSessionTokenResult.unauthenticated(),
      );
    });
  });
}

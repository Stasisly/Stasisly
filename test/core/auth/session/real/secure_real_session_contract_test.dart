import 'package:flutter_test/flutter_test.dart';

import 'package:stasisly/core/auth/session/real/secure_real_session.dart';
import 'package:stasisly/core/auth/session/secure_session_auth_state.dart';
import 'package:stasisly/core/auth/session/secure_session_token_result.dart';

void main() {
  group('SecureRealSessionSnapshot', () {
    test('authenticated requires non-empty token and subjectId', () {
      final snapshot = SecureRealSessionSnapshot.authenticated(
        token: 'runtime-session-token',
        subjectId: 'subject-1',
        email: 'user@example.com',
      );

      expect(snapshot.isAuthenticated, isTrue);
      expect(snapshot.hasToken, isTrue);
      expect(snapshot.subjectId, 'subject-1');
      expect(snapshot.email, 'user@example.com');
      expect(
        () => SecureRealSessionSnapshot.authenticated(
          token: '',
          subjectId: 'subject-1',
        ),
        throwsArgumentError,
      );
      expect(
        () => SecureRealSessionSnapshot.authenticated(
          token: 'runtime-session-token',
          subjectId: ' ',
        ),
        throwsArgumentError,
      );
    });

    test('non-success snapshots carry no token', () {
      const snapshots = [
        SecureRealSessionSnapshot.unauthenticated(),
        SecureRealSessionSnapshot.expired(),
        SecureRealSessionSnapshot.refreshFailed(),
        SecureRealSessionSnapshot.misconfigured(),
        SecureRealSessionSnapshot.backendBlocked(),
      ];

      for (final snapshot in snapshots) {
        expect(snapshot.isAuthenticated, isFalse, reason: '$snapshot');
        expect(snapshot.hasToken, isFalse, reason: '$snapshot');
        expect(snapshot.token, isNull, reason: '$snapshot');
      }
    });
  });

  group('SecureRealSessionGuard', () {
    const guard = SecureRealSessionGuard();

    test('demo runtime is backendBlocked and never demo', () {
      final decision = guard.evaluate(
        const SecureRealSessionConfig(runtime: SecureRealSessionRuntime.demo),
      );

      expect(decision.status, SecureRealSessionGuardStatus.backendBlocked);
      expect(decision.error, SecureRealSessionError.backendBlocked);
    });

    test('backend real without approval is backendBlocked', () {
      final decision = guard.evaluate(
        const SecureRealSessionConfig(
          runtime: SecureRealSessionRuntime.backendReal,
          hasRequiredBackendConfiguration: true,
        ),
      );

      expect(decision.status, SecureRealSessionGuardStatus.backendBlocked);
      expect(decision.error, SecureRealSessionError.backendBlocked);
    });

    test('production without approval is productionBlocked', () {
      final decision = guard.evaluate(
        const SecureRealSessionConfig(
          runtime: SecureRealSessionRuntime.production,
          hasRequiredBackendConfiguration: true,
          backendActivationApproved: true,
        ),
      );

      expect(decision.status, SecureRealSessionGuardStatus.productionBlocked);
      expect(decision.error, SecureRealSessionError.productionBlocked);
    });

    test('missing backend configuration is misconfigured', () {
      final decision = guard.evaluate(
        const SecureRealSessionConfig(
          runtime: SecureRealSessionRuntime.backendReal,
          backendActivationApproved: true,
        ),
      );

      expect(decision.status, SecureRealSessionGuardStatus.misconfigured);
      expect(decision.error, SecureRealSessionError.misconfiguredEnvironment);
    });

    test('approved backend is allowed', () {
      final decision = guard.evaluate(
        const SecureRealSessionConfig(
          runtime: SecureRealSessionRuntime.backendReal,
          hasRequiredBackendConfiguration: true,
          backendActivationApproved: true,
        ),
      );

      expect(decision, const SecureRealSessionGuardDecision.allowed());
    });
  });

  group('BaseSecureRealSessionTokenProvider', () {
    test('guard backendBlocked blocks before source access', () async {
      final source = _FakeSource(
        current: SecureRealSessionSnapshot.authenticated(
          token: 'runtime-session-token',
          subjectId: 'subject-1',
        ),
      );
      final provider = BaseSecureRealSessionTokenProvider(
        config: const SecureRealSessionConfig(
          runtime: SecureRealSessionRuntime.backendReal,
          hasRequiredBackendConfiguration: true,
        ),
        source: source,
      );

      expect(
        await provider.currentAuthState(),
        const SecureSessionAuthState.backendBlocked(),
      );
      expect(
        await provider.getAccessToken(),
        const SecureSessionTokenResult.backendBlocked(),
      );
      expect(source.readCalls, 0);
      expect(source.refreshCalls, 0);
      expect(source.clearCalls, 0);
    });

    test('guard misconfigured blocks before source access', () async {
      final source = _FakeSource(
        current: SecureRealSessionSnapshot.authenticated(
          token: 'runtime-session-token',
          subjectId: 'subject-1',
        ),
      );
      final provider = BaseSecureRealSessionTokenProvider(
        config: const SecureRealSessionConfig(
          runtime: SecureRealSessionRuntime.backendReal,
          backendActivationApproved: true,
        ),
        source: source,
      );

      expect(
        await provider.currentAuthState(),
        const SecureSessionAuthState.misconfigured(),
      );
      expect(
        await provider.getAccessToken(),
        const SecureSessionTokenResult.misconfigured(),
      );
      expect(source.readCalls, 0);
    });

    test('authenticated source maps to auth state and token result', () async {
      final provider = BaseSecureRealSessionTokenProvider(
        config: _allowedBackendConfig,
        source: _FakeSource(
          current: SecureRealSessionSnapshot.authenticated(
            token: 'runtime-session-token',
            subjectId: 'subject-1',
            email: 'user@example.com',
          ),
        ),
      );

      final authState = await provider.currentAuthState();
      final token = await provider.getAccessToken();

      expect(authState.status, SecureSessionAuthStatus.authenticated);
      expect(authState.subjectId, 'subject-1');
      expect(authState.email, 'user@example.com');
      expect(token.status, SecureSessionTokenStatus.success);
      expect(token.token, 'runtime-session-token');
    });

    test('source non-success states map without demo fallback', () async {
      for (final entry in [
        (
          const SecureRealSessionSnapshot.unauthenticated(),
          SecureSessionAuthStatus.unauthenticated,
          SecureSessionTokenStatus.unauthenticated,
        ),
        (
          const SecureRealSessionSnapshot.expired(),
          SecureSessionAuthStatus.expired,
          SecureSessionTokenStatus.expired,
        ),
        (
          const SecureRealSessionSnapshot.refreshFailed(),
          SecureSessionAuthStatus.refreshFailed,
          SecureSessionTokenStatus.refreshFailed,
        ),
        (
          const SecureRealSessionSnapshot.backendBlocked(),
          SecureSessionAuthStatus.backendBlocked,
          SecureSessionTokenStatus.backendBlocked,
        ),
        (
          const SecureRealSessionSnapshot.misconfigured(),
          SecureSessionAuthStatus.misconfigured,
          SecureSessionTokenStatus.misconfigured,
        ),
      ]) {
        final provider = BaseSecureRealSessionTokenProvider(
          config: _allowedBackendConfig,
          source: _FakeSource(current: entry.$1, refreshed: entry.$1),
        );

        expect((await provider.currentAuthState()).status, entry.$2);
        expect((await provider.getAccessToken()).status, entry.$3);
        expect((await provider.refreshIfNeeded()).status, entry.$3);
      }
    });

    test(
      'refresh uses refreshSession and clear delegates when allowed',
      () async {
        final source = _FakeSource(
          current: const SecureRealSessionSnapshot.unauthenticated(),
          refreshed: SecureRealSessionSnapshot.authenticated(
            token: 'runtime-session-token',
            subjectId: 'subject-1',
          ),
        );
        final provider = BaseSecureRealSessionTokenProvider(
          config: _allowedBackendConfig,
          source: source,
        );

        expect(
          await provider.refreshIfNeeded(),
          SecureSessionTokenResult.success('runtime-session-token'),
        );
        await provider.clearSession();

        expect(source.readCalls, 0);
        expect(source.refreshCalls, 1);
        expect(source.clearCalls, 1);
      },
    );

    test('source errors do not produce demo', () async {
      final provider = BaseSecureRealSessionTokenProvider(
        config: _allowedBackendConfig,
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
}

const _allowedBackendConfig = SecureRealSessionConfig(
  runtime: SecureRealSessionRuntime.backendReal,
  hasRequiredBackendConfiguration: true,
  backendActivationApproved: true,
);

class _FakeSource implements SecureRealSessionSource {
  _FakeSource({required this.current, SecureRealSessionSnapshot? refreshed})
    : refreshed = refreshed ?? current;

  final SecureRealSessionSnapshot current;
  final SecureRealSessionSnapshot refreshed;

  int readCalls = 0;
  int refreshCalls = 0;
  int clearCalls = 0;

  @override
  Future<SecureRealSessionSnapshot> readCurrentSession() async {
    readCalls += 1;
    return current;
  }

  @override
  Future<SecureRealSessionSnapshot> refreshSession() async {
    refreshCalls += 1;
    return refreshed;
  }

  @override
  Future<void> clearSession() async {
    clearCalls += 1;
  }
}

class _ThrowingSource implements SecureRealSessionSource {
  @override
  Future<SecureRealSessionSnapshot> readCurrentSession() async {
    throw StateError('real session unavailable');
  }

  @override
  Future<SecureRealSessionSnapshot> refreshSession() async {
    throw StateError('real session unavailable');
  }

  @override
  Future<void> clearSession() async {
    throw StateError('real session unavailable');
  }
}

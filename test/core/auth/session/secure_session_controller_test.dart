import 'package:flutter_test/flutter_test.dart';

import 'package:stasisly/core/auth/session/application/secure_session_controller.dart';
import 'package:stasisly/core/auth/session/application/secure_session_state.dart';
import 'package:stasisly/core/auth/session/secure_session_auth_state.dart';
import 'package:stasisly/core/auth/session/secure_session_token_provider.dart';
import 'package:stasisly/core/auth/session/secure_session_token_result.dart';

void main() {
  group('SecureSessionState', () {
    test('initial state is safe and exposes no token field', () {
      const state = SecureSessionState();

      expect(state.isUnauthenticated, isTrue);
      expect(state.isAuthenticated, isFalse);
      expect(state.hasActiveWork, isFalse);
      expect(state.lastError, isNull);
      expect(state.toString(), isNot(contains('token')));
    });

    test('derived flags represent all auth states', () {
      expect(
        const SecureSessionState(
          authState: SecureSessionAuthState.demo(),
        ).isDemo,
        isTrue,
      );
      expect(
        const SecureSessionState(
          authState: SecureSessionAuthState.authenticated(subjectId: 'sub-1'),
        ).isAuthenticated,
        isTrue,
      );
      expect(
        const SecureSessionState(
          authState: SecureSessionAuthState.backendBlocked(),
        ).isBackendBlocked,
        isTrue,
      );
      expect(
        const SecureSessionState(
          authState: SecureSessionAuthState.misconfigured(),
        ).isMisconfigured,
        isTrue,
      );
      expect(
        const SecureSessionState(
          authState: SecureSessionAuthState.expired(),
        ).isExpired,
        isTrue,
      );
      expect(
        const SecureSessionState(
          authState: SecureSessionAuthState.refreshFailed(),
        ).isRefreshFailed,
        isTrue,
      );
    });
  });

  group('SecureSessionController', () {
    test(
      'checkCurrentSession calls provider and exposes explicit demo',
      () async {
        final provider = _FakeTokenProvider(
          authStates: [const SecureSessionAuthState.demo()],
        );
        final controller = SecureSessionController(tokenProvider: provider);

        await controller.checkCurrentSession();

        expect(provider.currentAuthStateCalls, 1);
        expect(controller.state.isDemo, isTrue);
        expect(
          controller.state.lastError,
          SecureSessionError.demoModeNoRealToken,
        );
        expect(controller.state.isChecking, isFalse);
      },
    );

    test(
      'checkCurrentSession preserves backendBlocked as backendBlocked',
      () async {
        final controller = SecureSessionController(
          tokenProvider: _FakeTokenProvider(
            authStates: [const SecureSessionAuthState.backendBlocked()],
          ),
        );

        await controller.checkCurrentSession();

        expect(controller.state.isBackendBlocked, isTrue);
        expect(controller.state.isDemo, isFalse);
        expect(controller.state.lastError, SecureSessionError.backendBlocked);
      },
    );

    test(
      'refreshIfNeeded calls provider and never turns failure into demo',
      () async {
        final provider = _FakeTokenProvider(
          refreshResults: [const SecureSessionTokenResult.refreshFailed()],
        );
        final controller = SecureSessionController(tokenProvider: provider);

        await controller.refreshIfNeeded();

        expect(provider.refreshCalls, 1);
        expect(controller.state.isRefreshFailed, isTrue);
        expect(controller.state.isDemo, isFalse);
        expect(controller.state.lastError, SecureSessionError.refreshFailed);
      },
    );

    test(
      'refreshIfNeeded success stores auth state without exposing token',
      () async {
        final provider = _FakeTokenProvider(
          authStates: [
            const SecureSessionAuthState.authenticated(subjectId: 'subject-1'),
          ],
          refreshResults: [SecureSessionTokenResult.success('runtime-token')],
        );
        final controller = SecureSessionController(tokenProvider: provider);

        await controller.refreshIfNeeded();

        expect(provider.refreshCalls, 1);
        expect(provider.currentAuthStateCalls, 1);
        expect(controller.state.isAuthenticated, isTrue);
        expect(controller.state.authState.subjectId, 'subject-1');
        expect(
          controller.state.props.join('|'),
          isNot(contains('runtime-token')),
        );
      },
    );

    test('clearSession calls provider and resets to unauthenticated', () async {
      final provider = _FakeTokenProvider();
      final controller = SecureSessionController(tokenProvider: provider);

      await controller.clearSession();

      expect(provider.clearCalls, 1);
      expect(controller.state.isUnauthenticated, isTrue);
      expect(controller.state.lastError, isNull);
    });

    test('requireAuthenticated records typed error for non-auth states', () {
      final controller = SecureSessionController(
        tokenProvider: _FakeTokenProvider(),
      );

      final result = controller.requireAuthenticated();

      expect(result, isFalse);
      expect(controller.state.lastError, SecureSessionError.missingSession);
    });

    test('provider exceptions are visible and not converted to demo', () async {
      final controller = SecureSessionController(
        tokenProvider: _ThrowingTokenProvider(),
      );

      await controller.checkCurrentSession();

      expect(controller.state.isMisconfigured, isTrue);
      expect(controller.state.isDemo, isFalse);
      expect(controller.state.lastError, SecureSessionError.unexpected);
    });
  });
}

class _FakeTokenProvider implements SecureSessionTokenProvider {
  _FakeTokenProvider({
    List<SecureSessionAuthState>? authStates,
    List<SecureSessionTokenResult>? accessResults,
    List<SecureSessionTokenResult>? refreshResults,
  }) : _authStates = List.of(
         authStates ?? [const SecureSessionAuthState.unauthenticated()],
       ),
       _accessResults = List.of(
         accessResults ?? [const SecureSessionTokenResult.unauthenticated()],
       ),
       _refreshResults = List.of(
         refreshResults ?? [const SecureSessionTokenResult.unauthenticated()],
       );

  final List<SecureSessionAuthState> _authStates;
  final List<SecureSessionTokenResult> _accessResults;
  final List<SecureSessionTokenResult> _refreshResults;

  int currentAuthStateCalls = 0;
  int accessCalls = 0;
  int refreshCalls = 0;
  int clearCalls = 0;

  @override
  Future<SecureSessionAuthState> currentAuthState() async {
    currentAuthStateCalls += 1;
    return _authStates.removeAt(0);
  }

  @override
  Future<SecureSessionTokenResult> getAccessToken() async {
    accessCalls += 1;
    return _accessResults.removeAt(0);
  }

  @override
  Future<SecureSessionTokenResult> refreshIfNeeded() async {
    refreshCalls += 1;
    return _refreshResults.removeAt(0);
  }

  @override
  Future<void> clearSession() async {
    clearCalls += 1;
  }
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

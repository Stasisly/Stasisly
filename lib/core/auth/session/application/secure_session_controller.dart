import 'package:stasisly/core/auth/session/application/secure_session_state.dart';
import 'package:stasisly/core/auth/session/secure_session_auth_state.dart';
import 'package:stasisly/core/auth/session/secure_session_token_provider.dart';
import 'package:stasisly/core/auth/session/secure_session_token_result.dart';

class SecureSessionController {
  SecureSessionController({required SecureSessionTokenProvider tokenProvider})
    : _tokenProvider = tokenProvider;

  final SecureSessionTokenProvider _tokenProvider;

  SecureSessionState state = const SecureSessionState();

  Future<void> checkCurrentSession() async {
    state = state.copyWith(isChecking: true, lastError: null);
    try {
      final authState = await _tokenProvider.currentAuthState();
      state = state.copyWith(
        authState: authState,
        isChecking: false,
        lastError: _errorFromAuthState(authState),
      );
    } on Object {
      state = state.copyWith(
        authState: const SecureSessionAuthState.misconfigured(),
        isChecking: false,
        lastError: SecureSessionError.unexpected,
      );
    }
  }

  Future<void> refreshIfNeeded() async {
    state = state.copyWith(isRefreshing: true, lastError: null);
    try {
      final result = await _tokenProvider.refreshIfNeeded();
      final authState = result.isSuccess
          ? await _tokenProvider.currentAuthState()
          : _authStateFromTokenResult(result);
      state = state.copyWith(
        authState: authState,
        isRefreshing: false,
        lastError: result.error ?? _errorFromAuthState(authState),
      );
    } on Object {
      state = state.copyWith(
        authState: const SecureSessionAuthState.refreshFailed(),
        isRefreshing: false,
        lastError: SecureSessionError.unexpected,
      );
    }
  }

  Future<void> clearSession() async {
    state = state.copyWith(isClearing: true, lastError: null);
    try {
      await _tokenProvider.clearSession();
      state = state.copyWith(
        authState: const SecureSessionAuthState.unauthenticated(),
        isClearing: false,
        lastError: null,
      );
    } on Object {
      state = state.copyWith(
        isClearing: false,
        lastError: SecureSessionError.unexpected,
      );
    }
  }

  bool requireAuthenticated() {
    if (state.isAuthenticated) return true;

    final error = switch (state.authState.status) {
      SecureSessionAuthStatus.demo => SecureSessionError.demoModeNoRealToken,
      SecureSessionAuthStatus.unauthenticated =>
        SecureSessionError.missingSession,
      SecureSessionAuthStatus.expired => SecureSessionError.expiredSession,
      SecureSessionAuthStatus.refreshFailed => SecureSessionError.refreshFailed,
      SecureSessionAuthStatus.backendBlocked =>
        SecureSessionError.backendBlocked,
      SecureSessionAuthStatus.misconfigured =>
        SecureSessionError.misconfiguredEnvironment,
      SecureSessionAuthStatus.authenticated => null,
    };
    state = state.copyWith(lastError: error);
    return false;
  }

  SecureSessionAuthState _authStateFromTokenResult(
    SecureSessionTokenResult result,
  ) {
    return switch (result.status) {
      SecureSessionTokenStatus.success => state.authState,
      SecureSessionTokenStatus.demo => const SecureSessionAuthState.demo(),
      SecureSessionTokenStatus.unauthenticated =>
        const SecureSessionAuthState.unauthenticated(),
      SecureSessionTokenStatus.expired =>
        const SecureSessionAuthState.expired(),
      SecureSessionTokenStatus.refreshFailed =>
        const SecureSessionAuthState.refreshFailed(),
      SecureSessionTokenStatus.backendBlocked =>
        const SecureSessionAuthState.backendBlocked(),
      SecureSessionTokenStatus.misconfigured =>
        const SecureSessionAuthState.misconfigured(),
    };
  }

  SecureSessionError? _errorFromAuthState(SecureSessionAuthState authState) {
    return switch (authState.status) {
      SecureSessionAuthStatus.demo => SecureSessionError.demoModeNoRealToken,
      SecureSessionAuthStatus.authenticated => null,
      SecureSessionAuthStatus.unauthenticated =>
        SecureSessionError.missingSession,
      SecureSessionAuthStatus.expired => SecureSessionError.expiredSession,
      SecureSessionAuthStatus.refreshFailed => SecureSessionError.refreshFailed,
      SecureSessionAuthStatus.backendBlocked =>
        SecureSessionError.backendBlocked,
      SecureSessionAuthStatus.misconfigured =>
        SecureSessionError.misconfiguredEnvironment,
    };
  }
}

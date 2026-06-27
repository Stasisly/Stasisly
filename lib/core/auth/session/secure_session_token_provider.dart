import 'package:stasisly/core/auth/session/secure_session_auth_state.dart';
import 'package:stasisly/core/auth/session/secure_session_token_result.dart';

abstract interface class SecureSessionTokenProvider {
  Future<SecureSessionAuthState> currentAuthState();

  Future<SecureSessionTokenResult> getAccessToken();

  Future<SecureSessionTokenResult> refreshIfNeeded();

  Future<void> clearSession();
}

class DemoSecureSessionTokenProvider implements SecureSessionTokenProvider {
  const DemoSecureSessionTokenProvider();

  @override
  Future<SecureSessionAuthState> currentAuthState() async {
    return const SecureSessionAuthState.demo();
  }

  @override
  Future<SecureSessionTokenResult> getAccessToken() async {
    return const SecureSessionTokenResult.demo();
  }

  @override
  Future<SecureSessionTokenResult> refreshIfNeeded() async {
    return const SecureSessionTokenResult.demo();
  }

  @override
  Future<void> clearSession() async {}
}

class BackendBlockedSecureSessionTokenProvider
    implements SecureSessionTokenProvider {
  const BackendBlockedSecureSessionTokenProvider();

  @override
  Future<SecureSessionAuthState> currentAuthState() async {
    return const SecureSessionAuthState.backendBlocked();
  }

  @override
  Future<SecureSessionTokenResult> getAccessToken() async {
    return const SecureSessionTokenResult.backendBlocked();
  }

  @override
  Future<SecureSessionTokenResult> refreshIfNeeded() async {
    return const SecureSessionTokenResult.backendBlocked();
  }

  @override
  Future<void> clearSession() async {}
}

class UnauthenticatedSecureSessionTokenProvider
    implements SecureSessionTokenProvider {
  const UnauthenticatedSecureSessionTokenProvider();

  @override
  Future<SecureSessionAuthState> currentAuthState() async {
    return const SecureSessionAuthState.unauthenticated();
  }

  @override
  Future<SecureSessionTokenResult> getAccessToken() async {
    return const SecureSessionTokenResult.unauthenticated();
  }

  @override
  Future<SecureSessionTokenResult> refreshIfNeeded() async {
    return const SecureSessionTokenResult.unauthenticated();
  }

  @override
  Future<void> clearSession() async {}
}

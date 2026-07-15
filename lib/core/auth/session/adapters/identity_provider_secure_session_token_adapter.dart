import 'package:stasisly/core/auth/session/secure_session_auth_state.dart';
import 'package:stasisly/core/auth/session/secure_session_token_provider.dart';
import 'package:stasisly/core/auth/session/secure_session_token_result.dart';
import 'package:stasisly/core/identity/domain/authentication_state.dart';
import 'package:stasisly/core/identity/domain/authentication_token_result.dart';
import 'package:stasisly/core/identity/ports/identity_provider.dart';

class IdentityProviderSecureSessionTokenAdapter
    implements SecureSessionTokenProvider {
  const IdentityProviderSecureSessionTokenAdapter(this._identityProvider);

  final IdentityProvider _identityProvider;

  @override
  Future<SecureSessionAuthState> currentAuthState() async {
    final session = await _identityProvider.readCurrentSession();
    return switch (session.state) {
      AuthenticationState.authenticated => SecureSessionAuthState.authenticated(
        subjectId: session.identity!.subjectId,
        email: session.identity!.email,
      ),
      AuthenticationState.unauthenticated =>
        const SecureSessionAuthState.unauthenticated(),
      AuthenticationState.expired => const SecureSessionAuthState.expired(),
      AuthenticationState.unknown ||
      AuthenticationState.invalid ||
      AuthenticationState.revoked ||
      AuthenticationState.unavailable =>
        const SecureSessionAuthState.misconfigured(),
    };
  }

  @override
  Future<SecureSessionTokenResult> getAccessToken() async {
    return _mapToken(await _identityProvider.acquireAccessToken());
  }

  @override
  Future<SecureSessionTokenResult> refreshIfNeeded() async {
    final refresh = await _identityProvider.refreshSession();
    if (!refresh.isSuccess) {
      return const SecureSessionTokenResult.refreshFailed();
    }
    return getAccessToken();
  }

  @override
  Future<void> clearSession() async {
    await _identityProvider.signOut();
  }

  SecureSessionTokenResult _mapToken(AuthenticationTokenResult result) {
    return switch (result.status) {
      AuthenticationTokenStatus.available => SecureSessionTokenResult.success(
        result.token!,
      ),
      AuthenticationTokenStatus.unavailable =>
        const SecureSessionTokenResult.unauthenticated(),
      AuthenticationTokenStatus.expired =>
        const SecureSessionTokenResult.expired(),
      AuthenticationTokenStatus.invalid ||
      AuthenticationTokenStatus.providerFailure =>
        const SecureSessionTokenResult.refreshFailed(),
      AuthenticationTokenStatus.environmentBlocked =>
        const SecureSessionTokenResult.backendBlocked(),
    };
  }
}

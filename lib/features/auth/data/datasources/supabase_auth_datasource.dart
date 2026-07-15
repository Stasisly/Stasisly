import 'package:stasisly/core/identity/domain/authentication_result.dart';
import 'package:stasisly/core/identity/domain/authentication_token_result.dart';
import 'package:stasisly/core/identity/domain/stasisly_session.dart';
import 'package:stasisly/core/identity/ports/identity_provider.dart';

/// Compatibility wrapper. Provider SDK access lives in the core adapter.
@Deprecated('Inject IdentityProvider directly in new code.')
class SupabaseAuthDataSource {
  const SupabaseAuthDataSource(this._identityProvider);

  final IdentityProvider _identityProvider;

  Stream<StasislySession> get authStateChanges =>
      _identityProvider.observeAuthentication();

  Future<StasislySession> readCurrentSession() =>
      _identityProvider.readCurrentSession();

  /// Signs in a user with email and password.
  Future<AuthenticationResult> signInWithEmail({
    required String email,
    required String password,
  }) {
    return _identityProvider.signIn(email: email, password: password);
  }

  /// Registers a new user.
  Future<AuthenticationResult> signUpWithEmail({
    required String email,
    required String password,
  }) {
    return _identityProvider.signUp(email: email, password: password);
  }

  /// Signs out the current user.
  Future<AuthenticationResult> signOut() => _identityProvider.signOut();

  Future<AuthenticationResult> refreshSession() =>
      _identityProvider.refreshSession();

  Future<AuthenticationTokenResult> acquireAccessToken() =>
      _identityProvider.acquireAccessToken();
}

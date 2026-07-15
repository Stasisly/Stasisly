import 'package:stasisly/core/identity/domain/authentication_result.dart';
import 'package:stasisly/core/identity/domain/authentication_token_result.dart';
import 'package:stasisly/core/identity/domain/stasisly_session.dart';
import 'package:stasisly/core/identity/ports/identity_provider.dart';
import 'package:stasisly/features/auth/domain/repositories/auth_repository.dart';

/// Provider-neutral compatibility repository for the existing auth feature.
class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._identityProvider);

  final IdentityProvider _identityProvider;

  @override
  Future<AuthenticationTokenResult> acquireAccessToken() {
    return _identityProvider.acquireAccessToken();
  }

  @override
  Stream<StasislySession> observeAuthentication() {
    return _identityProvider.observeAuthentication();
  }

  @override
  Future<StasislySession> readCurrentSession() {
    return _identityProvider.readCurrentSession();
  }

  @override
  Future<AuthenticationResult> refreshSession() {
    return _identityProvider.refreshSession();
  }

  @override
  Future<AuthenticationResult> signIn({
    required String email,
    required String password,
  }) {
    return _identityProvider.signIn(email: email, password: password);
  }

  @override
  Future<AuthenticationResult> signOut() {
    return _identityProvider.signOut();
  }

  @override
  Future<AuthenticationResult> signUp({
    required String email,
    required String password,
  }) {
    return _identityProvider.signUp(email: email, password: password);
  }
}

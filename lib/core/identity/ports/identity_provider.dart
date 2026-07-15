import 'package:stasisly/core/identity/domain/authentication_result.dart';
import 'package:stasisly/core/identity/domain/authentication_token_result.dart';
import 'package:stasisly/core/identity/domain/stasisly_session.dart';

abstract interface class IdentityProvider {
  Future<StasislySession> readCurrentSession();

  Stream<StasislySession> observeAuthentication();

  Future<AuthenticationResult> signIn({
    required String email,
    required String password,
  });

  Future<AuthenticationResult> signUp({
    required String email,
    required String password,
  });

  Future<AuthenticationResult> signOut();

  Future<AuthenticationResult> refreshSession();

  Future<AuthenticationTokenResult> acquireAccessToken();
}

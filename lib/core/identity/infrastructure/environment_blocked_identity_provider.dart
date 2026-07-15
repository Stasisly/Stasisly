import 'package:stasisly/core/identity/domain/authentication_error.dart';
import 'package:stasisly/core/identity/domain/authentication_result.dart';
import 'package:stasisly/core/identity/domain/authentication_token_result.dart';
import 'package:stasisly/core/identity/domain/stasisly_session.dart';
import 'package:stasisly/core/identity/ports/identity_provider.dart';

class EnvironmentBlockedIdentityProvider implements IdentityProvider {
  const EnvironmentBlockedIdentityProvider();

  static const _error = AuthenticationError(
    AuthenticationErrorCode.environmentBlocked,
  );

  @override
  Future<StasislySession> readCurrentSession() async {
    return const StasislySession.unavailable();
  }

  @override
  Stream<StasislySession> observeAuthentication() {
    return Stream.value(const StasislySession.unavailable());
  }

  @override
  Future<AuthenticationTokenResult> acquireAccessToken() async {
    return const AuthenticationTokenResult.environmentBlocked();
  }

  @override
  Future<AuthenticationResult> refreshSession() async {
    return const AuthenticationResult.failure(_error);
  }

  @override
  Future<AuthenticationResult> signIn({
    required String email,
    required String password,
  }) async {
    return const AuthenticationResult.failure(_error);
  }

  @override
  Future<AuthenticationResult> signOut() async {
    return const AuthenticationResult.failure(_error);
  }

  @override
  Future<AuthenticationResult> signUp({
    required String email,
    required String password,
  }) async {
    return const AuthenticationResult.failure(_error);
  }
}

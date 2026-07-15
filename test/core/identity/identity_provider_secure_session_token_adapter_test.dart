import 'package:flutter_test/flutter_test.dart';

import 'package:stasisly/core/auth/session/secure_session.dart';
import 'package:stasisly/core/identity/identity.dart';

void main() {
  test('owned provider session maps to legacy secure session state', () async {
    final adapter = IdentityProviderSecureSessionTokenAdapter(
      _FakeIdentityProvider.authenticated(),
    );

    final authState = await adapter.currentAuthState();
    final token = await adapter.getAccessToken();

    expect(authState.status, SecureSessionAuthStatus.authenticated);
    expect(authState.subjectId, 'subject-1');
    expect(token.status, SecureSessionTokenStatus.success);
    expect(token.token, 'synthetic-runtime-credential');
    expect(token.toString(), isNot(contains('synthetic-runtime-credential')));
  });

  test('environment blocked never reaches a credential', () async {
    final adapter = IdentityProviderSecureSessionTokenAdapter(
      _FakeIdentityProvider.blocked(),
    );

    expect(
      await adapter.currentAuthState(),
      const SecureSessionAuthState.misconfigured(),
    );
    expect(
      await adapter.getAccessToken(),
      const SecureSessionTokenResult.backendBlocked(),
    );
  });
}

class _FakeIdentityProvider implements IdentityProvider {
  _FakeIdentityProvider.authenticated()
    : session = StasislySession.authenticated(
        identity: const StasislyIdentity(
          subjectId: 'subject-1',
          identityType: IdentityType.humanUser,
          authenticationState: AuthenticationState.authenticated,
        ),
      ),
      token = AuthenticationTokenResult.available(
        'synthetic-runtime-credential',
      );

  _FakeIdentityProvider.blocked()
    : session = const StasislySession.unavailable(),
      token = const AuthenticationTokenResult.environmentBlocked();

  final StasislySession session;
  final AuthenticationTokenResult token;

  @override
  Future<AuthenticationTokenResult> acquireAccessToken() async => token;

  @override
  Stream<StasislySession> observeAuthentication() => Stream.value(session);

  @override
  Future<StasislySession> readCurrentSession() async => session;

  @override
  Future<AuthenticationResult> refreshSession() async {
    return AuthenticationResult.success(session);
  }

  @override
  Future<AuthenticationResult> signIn({
    required String email,
    required String password,
  }) async => AuthenticationResult.success(session);

  @override
  Future<AuthenticationResult> signOut() async {
    return const AuthenticationResult.success(
      StasislySession.unauthenticated(),
    );
  }

  @override
  Future<AuthenticationResult> signUp({
    required String email,
    required String password,
  }) async => AuthenticationResult.success(session);
}

import 'package:flutter_test/flutter_test.dart';

import 'package:stasisly/core/identity/identity.dart';

void main() {
  test('canonical identity carries identity, not authorization', () {
    const identity = StasislyIdentity(
      subjectId: 'subject-1',
      identityType: IdentityType.humanUser,
      authenticationState: AuthenticationState.authenticated,
      email: 'user@example.test',
    );

    expect(identity.subjectId, 'subject-1');
    expect(identity.identityType, IdentityType.humanUser);
    expect(identity.isAuthenticated, isTrue);
  });

  test('identity type vocabulary is closed and extensible', () {
    expect(IdentityType.values, {
      IdentityType.humanUser,
      IdentityType.service,
      IdentityType.agent,
      IdentityType.unknown,
    });
  });

  test('authentication state does not collapse safe failures into null', () {
    expect(AuthenticationState.values, {
      AuthenticationState.unknown,
      AuthenticationState.unauthenticated,
      AuthenticationState.authenticated,
      AuthenticationState.expired,
      AuthenticationState.invalid,
      AuthenticationState.revoked,
      AuthenticationState.unavailable,
    });
  });

  test('authenticated session requires authenticated identity', () {
    expect(
      () => StasislySession.authenticated(
        identity: const StasislyIdentity(
          subjectId: 'subject-1',
          identityType: IdentityType.humanUser,
          authenticationState: AuthenticationState.unauthenticated,
        ),
      ),
      throwsArgumentError,
    );
  });

  test('API context fails closed without authenticated session', () {
    expect(
      () => ApiIdentityContext.fromSession(
        session: const StasislySession.unauthenticated(),
        environment: ApiEnvironmentContext.development,
        correlationReference: 'correlation-1',
      ),
      throwsA(isA<StasislyApiIdentityContextException>()),
    );
  });

  test('API context contains no token or authorization decision', () {
    final session = StasislySession.authenticated(
      identity: const StasislyIdentity(
        subjectId: 'subject-1',
        identityType: IdentityType.humanUser,
        authenticationState: AuthenticationState.authenticated,
      ),
      sessionReference: 'opaque-session-ref',
    );

    final context = ApiIdentityContext.fromSession(
      session: session,
      environment: ApiEnvironmentContext.development,
      correlationReference: 'correlation-1',
    );

    expect(context.subjectId, 'subject-1');
    expect(context.sessionReference, 'opaque-session-ref');
    expect(context.toString(), isNot(contains('token')));
  });

  test('token result never renders the credential', () {
    final result = AuthenticationTokenResult.available(
      'synthetic-runtime-credential',
    );

    expect(result.isAvailable, isTrue);
    expect(result.token, 'synthetic-runtime-credential');
    expect(result.toString(), isNot(contains('synthetic-runtime-credential')));
  });
}

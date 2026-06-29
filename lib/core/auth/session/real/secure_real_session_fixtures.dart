import 'package:stasisly/core/auth/session/real/secure_real_session_config.dart';
import 'package:stasisly/core/auth/session/real/secure_real_session_snapshot.dart';

class SecureRealSessionFixtures {
  const SecureRealSessionFixtures._();

  static const fakeSubjectId = 'fake-local-subject';
  static const fakeEmail = 'fake-user@local.test';
  static const fakeToken = 'fake-local-session-token';
  static const fakeRefreshedToken = 'fake-local-refreshed-session-token';

  static const localSafeConfig = SecureRealSessionConfig(
    runtime: SecureRealSessionRuntime.backendReal,
    hasRequiredBackendConfiguration: true,
    backendActivationApproved: true,
  );

  static SecureRealSessionSnapshot authenticated() {
    return SecureRealSessionSnapshot.authenticated(
      token: fakeToken,
      subjectId: fakeSubjectId,
      email: fakeEmail,
    );
  }

  static SecureRealSessionSnapshot refreshed() {
    return SecureRealSessionSnapshot.authenticated(
      token: fakeRefreshedToken,
      subjectId: fakeSubjectId,
      email: fakeEmail,
    );
  }

  static const unauthenticated = SecureRealSessionSnapshot.unauthenticated();
  static const expired = SecureRealSessionSnapshot.expired();
  static const refreshFailed = SecureRealSessionSnapshot.refreshFailed();
  static const backendBlocked = SecureRealSessionSnapshot.backendBlocked();
  static const misconfigured = SecureRealSessionSnapshot.misconfigured();
}

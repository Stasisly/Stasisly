import 'package:stasisly/core/auth/session/real/secure_real_session_fixtures.dart';
import 'package:stasisly/core/auth/session/real/secure_real_session_snapshot.dart';
import 'package:stasisly/core/auth/session/real/secure_real_session_source.dart';

class MockableSecureRealSessionSource implements SecureRealSessionSource {
  MockableSecureRealSessionSource({
    required SecureRealSessionSnapshot currentSnapshot,
    SecureRealSessionSnapshot? refreshedSnapshot,
  }) : _currentSnapshot = currentSnapshot,
       _refreshedSnapshot = refreshedSnapshot ?? currentSnapshot;

  factory MockableSecureRealSessionSource.authenticated() {
    return MockableSecureRealSessionSource(
      currentSnapshot: SecureRealSessionFixtures.authenticated(),
      refreshedSnapshot: SecureRealSessionFixtures.refreshed(),
    );
  }

  factory MockableSecureRealSessionSource.unauthenticated() {
    return MockableSecureRealSessionSource(
      currentSnapshot: SecureRealSessionFixtures.unauthenticated,
    );
  }

  factory MockableSecureRealSessionSource.expired() {
    return MockableSecureRealSessionSource(
      currentSnapshot: SecureRealSessionFixtures.expired,
    );
  }

  factory MockableSecureRealSessionSource.refreshFailed() {
    return MockableSecureRealSessionSource(
      currentSnapshot: SecureRealSessionFixtures.refreshFailed,
      refreshedSnapshot: SecureRealSessionFixtures.refreshFailed,
    );
  }

  factory MockableSecureRealSessionSource.backendBlocked() {
    return MockableSecureRealSessionSource(
      currentSnapshot: SecureRealSessionFixtures.backendBlocked,
    );
  }

  factory MockableSecureRealSessionSource.misconfigured() {
    return MockableSecureRealSessionSource(
      currentSnapshot: SecureRealSessionFixtures.misconfigured,
    );
  }

  SecureRealSessionSnapshot _currentSnapshot;
  final SecureRealSessionSnapshot _refreshedSnapshot;

  int readCalls = 0;
  int refreshCalls = 0;
  int clearCalls = 0;

  @override
  Future<SecureRealSessionSnapshot> readCurrentSession() async {
    readCalls += 1;
    return _currentSnapshot;
  }

  @override
  Future<SecureRealSessionSnapshot> refreshSession() async {
    refreshCalls += 1;
    _currentSnapshot = _refreshedSnapshot;
    return _refreshedSnapshot;
  }

  @override
  Future<void> clearSession() async {
    clearCalls += 1;
    _currentSnapshot = SecureRealSessionFixtures.unauthenticated;
  }
}

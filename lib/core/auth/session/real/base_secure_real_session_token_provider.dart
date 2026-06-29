import 'package:stasisly/core/auth/session/real/secure_real_session_config.dart';
import 'package:stasisly/core/auth/session/real/secure_real_session_guard.dart';
import 'package:stasisly/core/auth/session/real/secure_real_session_snapshot.dart';
import 'package:stasisly/core/auth/session/real/secure_real_session_source.dart';
import 'package:stasisly/core/auth/session/secure_session_auth_state.dart';
import 'package:stasisly/core/auth/session/secure_session_token_provider.dart';
import 'package:stasisly/core/auth/session/secure_session_token_result.dart';

class BaseSecureRealSessionTokenProvider implements SecureSessionTokenProvider {
  const BaseSecureRealSessionTokenProvider({
    required SecureRealSessionConfig config,
    required SecureRealSessionSource source,
    SecureRealSessionGuard guard = const SecureRealSessionGuard(),
  }) : _config = config,
       _source = source,
       _guard = guard;

  final SecureRealSessionConfig _config;
  final SecureRealSessionSource _source;
  final SecureRealSessionGuard _guard;

  @override
  Future<SecureSessionAuthState> currentAuthState() async {
    final guardDecision = _guard.evaluate(_config);
    if (!guardDecision.isAllowed) {
      return _authStateFromGuardDecision(guardDecision);
    }

    try {
      final snapshot = await _source.readCurrentSession();
      return _authStateFromSnapshot(snapshot);
    } on Object {
      return const SecureSessionAuthState.misconfigured();
    }
  }

  @override
  Future<SecureSessionTokenResult> getAccessToken() async {
    final guardDecision = _guard.evaluate(_config);
    if (!guardDecision.isAllowed) {
      return _tokenResultFromGuardDecision(guardDecision);
    }

    try {
      final snapshot = await _source.readCurrentSession();
      return _tokenResultFromSnapshot(snapshot);
    } on Object {
      return const SecureSessionTokenResult.unexpected();
    }
  }

  @override
  Future<SecureSessionTokenResult> refreshIfNeeded() async {
    final guardDecision = _guard.evaluate(_config);
    if (!guardDecision.isAllowed) {
      return _tokenResultFromGuardDecision(guardDecision);
    }

    try {
      final snapshot = await _source.refreshSession();
      return _tokenResultFromSnapshot(snapshot);
    } on Object {
      return const SecureSessionTokenResult.refreshFailed();
    }
  }

  @override
  Future<void> clearSession() async {
    final guardDecision = _guard.evaluate(_config);
    if (!guardDecision.isAllowed) return;

    await _source.clearSession();
  }

  SecureSessionAuthState _authStateFromGuardDecision(
    SecureRealSessionGuardDecision decision,
  ) {
    return switch (decision.status) {
      SecureRealSessionGuardStatus.allowed =>
        const SecureSessionAuthState.misconfigured(),
      SecureRealSessionGuardStatus.backendBlocked =>
        const SecureSessionAuthState.backendBlocked(),
      SecureRealSessionGuardStatus.productionBlocked ||
      SecureRealSessionGuardStatus.misconfigured =>
        const SecureSessionAuthState.misconfigured(),
    };
  }

  SecureSessionTokenResult _tokenResultFromGuardDecision(
    SecureRealSessionGuardDecision decision,
  ) {
    return switch (decision.status) {
      SecureRealSessionGuardStatus.allowed =>
        const SecureSessionTokenResult.misconfigured(),
      SecureRealSessionGuardStatus.backendBlocked =>
        const SecureSessionTokenResult.backendBlocked(),
      SecureRealSessionGuardStatus.productionBlocked ||
      SecureRealSessionGuardStatus.misconfigured =>
        const SecureSessionTokenResult.misconfigured(),
    };
  }

  SecureSessionAuthState _authStateFromSnapshot(
    SecureRealSessionSnapshot snapshot,
  ) {
    return switch (snapshot.status) {
      SecureRealSessionSnapshotStatus.authenticated =>
        SecureSessionAuthState.authenticated(
          subjectId: snapshot.subjectId!,
          email: snapshot.email,
        ),
      SecureRealSessionSnapshotStatus.unauthenticated =>
        const SecureSessionAuthState.unauthenticated(),
      SecureRealSessionSnapshotStatus.expired =>
        const SecureSessionAuthState.expired(),
      SecureRealSessionSnapshotStatus.refreshFailed =>
        const SecureSessionAuthState.refreshFailed(),
      SecureRealSessionSnapshotStatus.backendBlocked =>
        const SecureSessionAuthState.backendBlocked(),
      SecureRealSessionSnapshotStatus.misconfigured =>
        const SecureSessionAuthState.misconfigured(),
    };
  }

  SecureSessionTokenResult _tokenResultFromSnapshot(
    SecureRealSessionSnapshot snapshot,
  ) {
    return switch (snapshot.status) {
      SecureRealSessionSnapshotStatus.authenticated =>
        SecureSessionTokenResult.success(snapshot.token!),
      SecureRealSessionSnapshotStatus.unauthenticated =>
        const SecureSessionTokenResult.unauthenticated(),
      SecureRealSessionSnapshotStatus.expired =>
        const SecureSessionTokenResult.expired(),
      SecureRealSessionSnapshotStatus.refreshFailed =>
        const SecureSessionTokenResult.refreshFailed(),
      SecureRealSessionSnapshotStatus.backendBlocked =>
        const SecureSessionTokenResult.backendBlocked(),
      SecureRealSessionSnapshotStatus.misconfigured =>
        const SecureSessionTokenResult.misconfigured(),
    };
  }
}

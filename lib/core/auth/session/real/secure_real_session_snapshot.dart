import 'package:equatable/equatable.dart';

enum SecureRealSessionSnapshotStatus {
  authenticated,
  unauthenticated,
  expired,
  refreshFailed,
  misconfigured,
  backendBlocked,
}

class SecureRealSessionSnapshot extends Equatable {
  const SecureRealSessionSnapshot._({
    required this.status,
    this.token,
    this.subjectId,
    this.email,
  });

  factory SecureRealSessionSnapshot.authenticated({
    required String token,
    required String subjectId,
    String? email,
  }) {
    if (token.trim().isEmpty) {
      throw ArgumentError.value(
        token,
        'token',
        'Authenticated real session snapshots require a non-empty token.',
      );
    }
    if (subjectId.trim().isEmpty) {
      throw ArgumentError.value(
        subjectId,
        'subjectId',
        'Authenticated real session snapshots require a non-empty subjectId.',
      );
    }
    return SecureRealSessionSnapshot._(
      status: SecureRealSessionSnapshotStatus.authenticated,
      token: token,
      subjectId: subjectId,
      email: email,
    );
  }

  const SecureRealSessionSnapshot.unauthenticated()
    : this._(status: SecureRealSessionSnapshotStatus.unauthenticated);

  const SecureRealSessionSnapshot.expired()
    : this._(status: SecureRealSessionSnapshotStatus.expired);

  const SecureRealSessionSnapshot.refreshFailed()
    : this._(status: SecureRealSessionSnapshotStatus.refreshFailed);

  const SecureRealSessionSnapshot.misconfigured()
    : this._(status: SecureRealSessionSnapshotStatus.misconfigured);

  const SecureRealSessionSnapshot.backendBlocked()
    : this._(status: SecureRealSessionSnapshotStatus.backendBlocked);

  final SecureRealSessionSnapshotStatus status;

  /// Internal in-memory token for future infrastructure adapters.
  ///
  /// This value must never be copied into public UI state.
  final String? token;
  final String? subjectId;
  final String? email;

  bool get isAuthenticated {
    return status == SecureRealSessionSnapshotStatus.authenticated;
  }

  bool get hasToken => token != null && token!.trim().isNotEmpty;

  @override
  List<Object?> get props => [status, subjectId, email, hasToken];
}

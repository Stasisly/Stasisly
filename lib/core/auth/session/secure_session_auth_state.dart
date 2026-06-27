import 'package:equatable/equatable.dart';

/// High-level auth/session state exposed to application layers.
///
/// This state never grants product permissions. Ownership and authorization
/// remain backend responsibilities.
enum SecureSessionAuthStatus {
  demo,
  authenticated,
  unauthenticated,
  expired,
  refreshFailed,
  backendBlocked,
  misconfigured,
}

class SecureSessionAuthState extends Equatable {
  const SecureSessionAuthState._({
    required this.status,
    this.subjectId,
    this.email,
  });

  const SecureSessionAuthState.demo()
    : this._(status: SecureSessionAuthStatus.demo);

  const SecureSessionAuthState.authenticated({
    required String subjectId,
    String? email,
  }) : this._(
         status: SecureSessionAuthStatus.authenticated,
         subjectId: subjectId,
         email: email,
       );

  const SecureSessionAuthState.unauthenticated()
    : this._(status: SecureSessionAuthStatus.unauthenticated);

  const SecureSessionAuthState.expired()
    : this._(status: SecureSessionAuthStatus.expired);

  const SecureSessionAuthState.refreshFailed()
    : this._(status: SecureSessionAuthStatus.refreshFailed);

  const SecureSessionAuthState.backendBlocked()
    : this._(status: SecureSessionAuthStatus.backendBlocked);

  const SecureSessionAuthState.misconfigured()
    : this._(status: SecureSessionAuthStatus.misconfigured);

  final SecureSessionAuthStatus status;

  /// Stable subject identifier for future authenticated sessions.
  ///
  /// UI must not treat this value as proof of ownership or authorization.
  final String? subjectId;

  final String? email;

  bool get isAuthenticated => status == SecureSessionAuthStatus.authenticated;

  bool get isDemo => status == SecureSessionAuthStatus.demo;

  bool get canRequestBackendToken => isAuthenticated;

  @override
  List<Object?> get props => [status, subjectId, email];
}

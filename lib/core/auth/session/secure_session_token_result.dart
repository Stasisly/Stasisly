import 'package:equatable/equatable.dart';

enum SecureSessionTokenStatus {
  success,
  unauthenticated,
  expired,
  refreshFailed,
  backendBlocked,
  misconfigured,
  demo,
}

enum SecureSessionError {
  missingSession,
  expiredSession,
  refreshFailed,
  backendBlocked,
  misconfiguredEnvironment,
  demoModeNoRealToken,
  unexpected,
}

class SecureSessionTokenResult extends Equatable {
  const SecureSessionTokenResult._success(this.token)
    : status = SecureSessionTokenStatus.success,
      error = null;

  const SecureSessionTokenResult._failure(this.status, this.error)
    : token = null;

  factory SecureSessionTokenResult.success(String token) {
    if (token.trim().isEmpty) {
      throw ArgumentError.value(
        token,
        'token',
        'A successful secure session token result requires a non-empty token.',
      );
    }
    return SecureSessionTokenResult._success(token);
  }

  const SecureSessionTokenResult.unauthenticated()
    : this._failure(
        SecureSessionTokenStatus.unauthenticated,
        SecureSessionError.missingSession,
      );

  const SecureSessionTokenResult.expired()
    : this._failure(
        SecureSessionTokenStatus.expired,
        SecureSessionError.expiredSession,
      );

  const SecureSessionTokenResult.refreshFailed()
    : this._failure(
        SecureSessionTokenStatus.refreshFailed,
        SecureSessionError.refreshFailed,
      );

  const SecureSessionTokenResult.backendBlocked()
    : this._failure(
        SecureSessionTokenStatus.backendBlocked,
        SecureSessionError.backendBlocked,
      );

  const SecureSessionTokenResult.misconfigured()
    : this._failure(
        SecureSessionTokenStatus.misconfigured,
        SecureSessionError.misconfiguredEnvironment,
      );

  const SecureSessionTokenResult.demo()
    : this._failure(
        SecureSessionTokenStatus.demo,
        SecureSessionError.demoModeNoRealToken,
      );

  const SecureSessionTokenResult.unexpected()
    : this._failure(
        SecureSessionTokenStatus.misconfigured,
        SecureSessionError.unexpected,
      );

  final SecureSessionTokenStatus status;
  final String? token;
  final SecureSessionError? error;

  bool get isSuccess => status == SecureSessionTokenStatus.success;

  bool get hasToken => token != null && token!.trim().isNotEmpty;

  @override
  List<Object?> get props => [status, error];
}

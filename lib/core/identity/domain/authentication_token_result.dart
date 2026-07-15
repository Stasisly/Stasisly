import 'package:equatable/equatable.dart';

enum AuthenticationTokenStatus {
  available,
  unavailable,
  expired,
  invalid,
  providerFailure,
  environmentBlocked,
}

class AuthenticationTokenResult extends Equatable {
  const AuthenticationTokenResult._({
    required this.status,
    this.token,
    this.expiresAt,
  });

  factory AuthenticationTokenResult.available(
    String token, {
    DateTime? expiresAt,
  }) {
    final normalized = token.trim();
    if (normalized.isEmpty) {
      throw ArgumentError.value(token, 'token', 'Token must not be empty.');
    }
    return AuthenticationTokenResult._(
      status: AuthenticationTokenStatus.available,
      token: normalized,
      expiresAt: expiresAt,
    );
  }

  const AuthenticationTokenResult.unavailable()
    : this._(status: AuthenticationTokenStatus.unavailable);

  const AuthenticationTokenResult.expired()
    : this._(status: AuthenticationTokenStatus.expired);

  const AuthenticationTokenResult.invalid()
    : this._(status: AuthenticationTokenStatus.invalid);

  const AuthenticationTokenResult.providerFailure()
    : this._(status: AuthenticationTokenStatus.providerFailure);

  const AuthenticationTokenResult.environmentBlocked()
    : this._(status: AuthenticationTokenStatus.environmentBlocked);

  final AuthenticationTokenStatus status;

  /// Infrastructure-only credential. Never copy it into public state or logs.
  final String? token;
  final DateTime? expiresAt;

  bool get isAvailable => status == AuthenticationTokenStatus.available;

  // Deliberately excludes the credential from equality and string rendering.
  @override
  List<Object?> get props => [status, expiresAt];
}

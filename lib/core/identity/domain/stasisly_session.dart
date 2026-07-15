import 'package:equatable/equatable.dart';

import 'package:stasisly/core/identity/domain/authentication_state.dart';
import 'package:stasisly/core/identity/domain/stasisly_identity.dart';

class StasislySession extends Equatable {
  const StasislySession._({
    required this.state,
    this.identity,
    this.sessionReference,
    this.issuedAt,
    this.expiresAt,
  });

  factory StasislySession.authenticated({
    required StasislyIdentity identity,
    String? sessionReference,
    DateTime? issuedAt,
    DateTime? expiresAt,
  }) {
    if (!identity.isAuthenticated) {
      throw ArgumentError.value(
        identity.authenticationState,
        'identity',
        'An authenticated session requires an authenticated identity.',
      );
    }
    return StasislySession._(
      state: AuthenticationState.authenticated,
      identity: identity,
      sessionReference: _normalizeOptional(sessionReference),
      issuedAt: issuedAt,
      expiresAt: expiresAt,
    );
  }

  const StasislySession.unknown() : this._(state: AuthenticationState.unknown);

  const StasislySession.unauthenticated()
    : this._(state: AuthenticationState.unauthenticated);

  const StasislySession.expired({StasislyIdentity? identity})
    : this._(state: AuthenticationState.expired, identity: identity);

  const StasislySession.invalid() : this._(state: AuthenticationState.invalid);

  const StasislySession.revoked() : this._(state: AuthenticationState.revoked);

  const StasislySession.unavailable()
    : this._(state: AuthenticationState.unavailable);

  final AuthenticationState state;
  final StasislyIdentity? identity;
  final String? sessionReference;
  final DateTime? issuedAt;
  final DateTime? expiresAt;

  bool get isAuthenticated {
    return state == AuthenticationState.authenticated && identity != null;
  }

  @override
  List<Object?> get props => [
    state,
    identity,
    sessionReference,
    issuedAt,
    expiresAt,
  ];
}

String? _normalizeOptional(String? value) {
  final normalized = value?.trim();
  return normalized == null || normalized.isEmpty ? null : normalized;
}

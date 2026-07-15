import 'package:equatable/equatable.dart';

import 'package:stasisly/core/identity/domain/authentication_state.dart';
import 'package:stasisly/core/identity/domain/identity_type.dart';

class StasislyIdentity extends Equatable {
  const StasislyIdentity({
    required this.subjectId,
    required this.identityType,
    required this.authenticationState,
    this.email,
  }) : assert(subjectId != '', 'subjectId must not be empty.');

  final String subjectId;
  final IdentityType identityType;
  final AuthenticationState authenticationState;
  final String? email;

  bool get isAuthenticated {
    return authenticationState == AuthenticationState.authenticated;
  }

  @override
  List<Object?> get props => [
    subjectId,
    identityType,
    authenticationState,
    email,
  ];
}

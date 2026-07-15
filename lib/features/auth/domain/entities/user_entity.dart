import 'package:stasisly/core/identity/domain/authentication_state.dart';
import 'package:stasisly/core/identity/domain/identity_type.dart';
import 'package:stasisly/core/identity/domain/stasisly_identity.dart';

/// Authenticated identity returned by an auth provider.
///
/// It contains no profile, role, permission, or administrative authority.
@Deprecated('Use StasislyIdentity from the owned identity boundary.')
class UserEntity extends StasislyIdentity {
  const UserEntity({required String id, required String email})
    : super(
        subjectId: id,
        identityType: IdentityType.humanUser,
        authenticationState: AuthenticationState.authenticated,
        email: email,
      );

  String get id => subjectId;
}

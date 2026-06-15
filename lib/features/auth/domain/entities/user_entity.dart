import 'package:stasisly/core/domain/entities/current_identity.dart';

/// Authenticated identity returned by an auth provider.
///
/// It contains no profile, role, permission, or administrative authority.
class UserEntity extends CurrentIdentity {
  const UserEntity({required String id, required String email})
    : super(id: id, source: IdentitySource.authenticated, email: email);
}

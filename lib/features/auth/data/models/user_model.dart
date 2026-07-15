import 'package:stasisly/core/identity/domain/stasisly_identity.dart';
import 'package:stasisly/features/auth/domain/entities/user_entity.dart';

/// Compatibility model for legacy auth consumers.
class UserModel extends UserEntity {
  const UserModel({required super.id, required super.email});

  factory UserModel.fromIdentity(StasislyIdentity identity) {
    return UserModel(id: identity.subjectId, email: identity.email ?? '');
  }
}

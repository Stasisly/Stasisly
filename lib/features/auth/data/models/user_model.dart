import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import 'package:stasisly/features/auth/domain/entities/user_entity.dart';

/// Data model representing the user, mapping Supabase User to UserEntity.
class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    super.displayName,
    super.avatarUrl,
    super.role,
  });

  /// Creates a [UserModel] from a Supabase [User].
  factory UserModel.fromSupabase(supabase.User user) {
    final metadata = user.userMetadata ?? {};
    
    return UserModel(
      id: user.id,
      email: user.email ?? '',
      displayName: metadata['display_name'] as String?,
      avatarUrl: metadata['avatar_url'] as String?,
      role: (metadata['role'] as String?) ?? 'user',
    );
  }
}

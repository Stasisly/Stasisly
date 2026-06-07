import 'package:equatable/equatable.dart';

/// Represents an authenticated user in the domain layer.
class UserEntity extends Equatable {
  const UserEntity({
    required this.id,
    required this.email,
    this.displayName,
    this.avatarUrl,
    this.role = 'user',
  });

  /// The unique identifier of the user (UUID from Supabase Auth).
  final String id;

  /// The user's email address.
  final String email;

  /// The user's chosen display name.
  final String? displayName;

  /// URL to the user's avatar image.
  final String? avatarUrl;

  /// The user's role ('user' or 'admin'). Defaults to 'user'.
  final String role;

  @override
  List<Object?> get props => [id, email, displayName, avatarUrl, role];
}

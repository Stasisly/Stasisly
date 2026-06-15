import 'package:equatable/equatable.dart';

/// Product profile associated 1:1 with an identity.
///
/// Profile fields never grant roles, permissions, or administrative authority.
class UserProfile extends Equatable {
  const UserProfile({required this.userId, this.displayName, this.avatarUrl});

  final String userId;
  final String? displayName;
  final String? avatarUrl;

  @override
  List<Object?> get props => [userId, displayName, avatarUrl];
}

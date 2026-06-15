import 'package:equatable/equatable.dart';

/// Minimal owner-only profile contract approved by ADR-006.
class OwnProfile extends Equatable {
  const OwnProfile({
    required this.id,
    required this.displayName,
    required this.isDemo,
  });

  final String id;
  final String displayName;
  final bool isDemo;

  @override
  List<Object?> get props => [id, displayName, isDemo];
}

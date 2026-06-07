import 'package:equatable/equatable.dart';

/// Represents the role of an agent in the hierarchy.
enum AgentRole {
  orchestrator,
  branchChief,
  subChief,
  specialist,
}

/// Represents the branch an agent belongs to.
enum AgentBranch {
  orchestrator, // Stasis itself
  health,
  nutrition,
  physical,
  mental,
}

/// Domain entity representing an AI Agent.
class AgentEntity extends Equatable {
  const AgentEntity({
    required this.id,
    required this.name,
    required this.role,
    required this.branch,
    required this.specialty,
    required this.description,
    this.avatarUrl,
  });

  final String id;
  final String name;
  final AgentRole role;
  final AgentBranch branch;
  
  /// Specific specialty (e.g., 'Cardiología', 'Fuerza', 'Descanso')
  final String specialty;
  
  /// Short description to show in the catalog
  final String description;
  
  final String? avatarUrl;

  @override
  List<Object?> get props => [
        id,
        name,
        role,
        branch,
        specialty,
        description,
        avatarUrl,
      ];
}

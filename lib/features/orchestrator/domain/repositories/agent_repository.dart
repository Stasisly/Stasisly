import 'package:dartz/dartz.dart';

import 'package:stasisly/core/error/failures.dart';
import 'package:stasisly/features/orchestrator/domain/entities/agent_entity.dart';

/// Interface for agent data operations.
abstract class AgentRepository {
  /// Retrieves all available agents.
  Future<Either<Failure, List<AgentEntity>>> getAgents();

  /// Retrieves agents belonging to a specific branch.
  Future<Either<Failure, List<AgentEntity>>> getAgentsByBranch(AgentBranch branch);

  /// Retrieves a specific agent by ID.
  Future<Either<Failure, AgentEntity>> getAgentById(String id);
}

import 'package:dartz/dartz.dart';

import 'package:stasisly/core/error/failures.dart';
import 'package:stasisly/features/orchestrator/domain/entities/agent_entity.dart';
import 'package:stasisly/features/orchestrator/domain/repositories/agent_repository.dart';

/// Use case to retrieve agents, optionally filtered by branch.
class GetAgentsUseCase {
  const GetAgentsUseCase(this._repository);

  final AgentRepository _repository;

  Future<Either<Failure, List<AgentEntity>>> call({AgentBranch? branch}) {
    if (branch != null) {
      return _repository.getAgentsByBranch(branch);
    }
    return _repository.getAgents();
  }
}

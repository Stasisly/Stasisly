import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:stasisly/features/orchestrator/data/repositories/agent_repository_impl.dart';
import 'package:stasisly/features/orchestrator/domain/entities/agent_entity.dart';
import 'package:stasisly/features/orchestrator/domain/repositories/agent_repository.dart';
import 'package:stasisly/features/orchestrator/domain/usecases/get_agents_usecase.dart';

part 'agent_providers.g.dart';

@Riverpod(keepAlive: true)
AgentRepository agentRepository(AgentRepositoryRef ref) {
  return AgentRepositoryImpl(); // Initial mock implementation
}

@Riverpod(keepAlive: true)
GetAgentsUseCase getAgentsUseCase(GetAgentsUseCaseRef ref) {
  final repo = ref.watch(agentRepositoryProvider);
  return GetAgentsUseCase(repo);
}

@riverpod
Future<List<AgentEntity>> agentsByBranch(AgentsByBranchRef ref, AgentBranch branch) async {
  final useCase = ref.watch(getAgentsUseCaseProvider);
  final result = await useCase(branch: branch);
  
  return result.fold(
    (failure) => throw Exception(failure.message),
    (agents) => agents,
  );
}

@riverpod
Future<AgentEntity> agentById(AgentByIdRef ref, String id) async {
  final repo = ref.watch(agentRepositoryProvider);
  final result = await repo.getAgentById(id);
  
  return result.fold(
    (failure) => throw Exception(failure.message),
    (agent) => agent,
  );
}

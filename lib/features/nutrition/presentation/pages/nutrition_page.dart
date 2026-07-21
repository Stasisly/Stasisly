import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:stasisly/core/theme/app_colors.dart';
import 'package:stasisly/core/theme/app_spacing.dart';
import 'package:stasisly/core/theme/app_typography.dart';
import 'package:stasisly/features/orchestrator/domain/entities/agent_entity.dart';
import 'package:stasisly/features/orchestrator/presentation/viewmodels/agent_providers.dart';
import 'package:stasisly/features/specialists/presentation/widgets/unavailable_specialist_card.dart';

class NutritionPage extends ConsumerWidget {
  const NutritionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final agentsAsync = ref.watch(
      agentsByBranchProvider(AgentBranch.nutrition),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Nutrición',
          style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.nutritionAccent.withValues(alpha: 0.1),
      ),
      body: agentsAsync.when(
        data: (agents) {
          if (agents.isEmpty) {
            return const Center(child: Text('No hay agentes disponibles'));
          }
          return ListView.separated(
            padding: AppSpacing.pagePadding,
            itemCount: agents.length,
            separatorBuilder: (context, index) =>
                const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, index) {
              final agent = agents[index];
              return UnavailableSpecialistCard(
                name: agent.name,
                specialty: agent.specialty,
                description: agent.description,
                color: AppColors.nutritionAccent,
                isHighlighted:
                    agent.role == AgentRole.branchChief ||
                    agent.role == AgentRole.subChief,
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }
}

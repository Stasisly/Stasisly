import 'package:flutter/material.dart';
import 'package:stasisly/core/theme/app_spacing.dart';
import 'package:stasisly/core/theme/app_typography.dart';
import 'package:stasisly/features/orchestrator/domain/entities/agent_entity.dart';

class AgentCard extends StatelessWidget {
  const AgentCard({
    required this.agent,
    required this.color,
    required this.onTap,
    super.key,
  });

  final AgentEntity agent;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isChief = agent.role == AgentRole.branchChief || agent.role == AgentRole.subChief;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar placeholder
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isChief ? color : color.withValues(alpha: 0.3),
                    width: isChief ? 2 : 1,
                  ),
                ),
                child: Icon(
                  Icons.person_rounded,
                  color: color,
                  size: 32,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            agent.name,
                            style: AppTypography.titleMedium.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (isChief)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: color.withValues(alpha: 0.5)),
                            ),
                            child: Text(
                              'Chief',
                              style: AppTypography.labelSmall.copyWith(
                                color: color,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      agent.specialty,
                      style: AppTypography.labelMedium.copyWith(
                        color: color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      agent.description,
                      style: AppTypography.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Icon(
                Icons.chat_bubble_outline_rounded,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

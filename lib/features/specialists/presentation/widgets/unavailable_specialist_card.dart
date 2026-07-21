import 'package:flutter/material.dart';

import 'package:stasisly/core/theme/app_spacing.dart';
import 'package:stasisly/core/theme/app_typography.dart';

/// Displays legacy catalog information without exposing a conversation action.
class UnavailableSpecialistCard extends StatelessWidget {
  const UnavailableSpecialistCard({
    required this.name,
    required this.specialty,
    required this.description,
    required this.color,
    required this.isHighlighted,
    super.key,
  });

  final String name;
  final String specialty;
  final String description;
  final Color color;
  final bool isHighlighted;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: '$name. $specialty. Conversaciones no disponibles todavía.',
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isHighlighted ? color : color.withValues(alpha: 0.3),
                    width: isHighlighted ? 2 : 1,
                  ),
                ),
                child: Icon(Icons.person_rounded, color: color, size: 32),
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
                            name,
                            style: AppTypography.titleMedium.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (isHighlighted)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: color.withValues(alpha: 0.5),
                              ),
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
                      specialty,
                      style: AppTypography.labelMedium.copyWith(
                        color: color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      description,
                      style: AppTypography.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Conversaciones no disponibles todavía',
                      style: AppTypography.labelSmall.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Icon(
                Icons.lock_outline_rounded,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                semanticLabel: 'No disponible',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

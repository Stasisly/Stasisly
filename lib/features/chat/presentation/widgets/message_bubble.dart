import 'package:flutter/material.dart';

import 'package:stasisly/core/theme/app_colors.dart';
import 'package:stasisly/core/theme/app_spacing.dart';
import 'package:stasisly/core/theme/app_typography.dart';
import 'package:stasisly/features/chat/domain/entities/message_entity.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    required this.message,
    super.key,
  });

  final MessageEntity message;

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == 'user';
    final isChiefIntervention = message.role == 'chief_intervention';

    // Theme adaptations
    final Color bubbleColor;
    final Color textColor;
    
    if (isUser) {
      bubbleColor = AppColors.primary;
      textColor = Colors.white;
    } else if (isChiefIntervention) {
      bubbleColor = AppColors.warning.withValues(alpha: 0.15);
      textColor = AppColors.textPrimaryDark;
    } else {
      bubbleColor = AppColors.surfaceVariantDark;
      textColor = AppColors.textPrimaryDark;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xs,
      ),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            const CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primaryLight,
              child: Icon(Icons.psychology, size: 16, color: Colors.white),
            ),
            const SizedBox(width: AppSpacing.sm),
          ],
          Flexible(
            child: Container(
              padding: AppSpacing.messagePadding,
              decoration: BoxDecoration(
                color: bubbleColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(AppSpacing.radiusXl),
                  topRight: const Radius.circular(AppSpacing.radiusXl),
                  bottomLeft: Radius.circular(
                    isUser ? AppSpacing.radiusXl : AppSpacing.radiusSm,
                  ),
                  bottomRight: Radius.circular(
                    isUser ? AppSpacing.radiusSm : AppSpacing.radiusXl,
                  ),
                ),
                border: isChiefIntervention
                    ? Border.all(color: AppColors.warning, width: 0.5)
                    : null,
              ),
              child: Column(
                crossAxisAlignment:
                    isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  if (isChiefIntervention)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                      child: Text(
                        'Intervención del Consultor Senior',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.warning,
                        ),
                      ),
                    ),
                  Text(
                    message.content,
                    style: AppTypography.bodyLarge.copyWith(color: textColor),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

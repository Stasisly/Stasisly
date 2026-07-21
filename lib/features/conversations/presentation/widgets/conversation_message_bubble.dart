import 'package:flutter/material.dart';

import 'package:stasisly/core/theme/app_spacing.dart';
import 'package:stasisly/features/conversations/presentation/models/conversation_message_view_model.dart';
import 'package:stasisly/features/conversations/presentation/widgets/conversation_redacted_message.dart';
import 'package:stasisly/features/conversations/presentation/widgets/conversation_system_notice.dart';

class ConversationMessageBubble extends StatelessWidget {
  const ConversationMessageBubble({required this.message, super.key});

  final ConversationMessageViewModel message;

  @override
  Widget build(BuildContext context) {
    if (message.isRedacted) {
      return ConversationRedactedMessage(message: message);
    }
    if (message.visualKind == ConversationMessageVisualKind.systemNotice) {
      return ConversationSystemNotice(message: message);
    }

    final theme = Theme.of(context);
    final isUser = message.visualKind == ConversationMessageVisualKind.user;
    final colorScheme = theme.colorScheme;
    final bubbleColor = isUser
        ? colorScheme.primary
        : colorScheme.surfaceContainerHighest;
    final foreground = isUser
        ? colorScheme.onPrimary
        : colorScheme.onSurfaceVariant;
    final viewportWidth = MediaQuery.sizeOf(context).width;
    final maxWidth = viewportWidth <= 0
        ? 240.0
        : (viewportWidth * 0.78).clamp(0.0, AppSpacing.maxContentWidth);

    return Semantics(
      container: true,
      label: message.accessibilityLabel,
      child: ExcludeSemantics(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.xs,
          ),
          child: Align(
            alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: DecoratedBox(
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
                ),
                child: Padding(
                  padding: AppSpacing.messagePadding,
                  child: Column(
                    crossAxisAlignment: isUser
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Text(
                        message.displayAuthor,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: foreground,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        message.content,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: foreground,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        message.displayTimestamp,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: foreground.withValues(alpha: 0.78),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

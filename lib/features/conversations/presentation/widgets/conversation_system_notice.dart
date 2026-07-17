import 'package:flutter/material.dart';

import 'package:stasisly/core/theme/app_spacing.dart';
import 'package:stasisly/features/conversations/presentation/models/conversation_message_view_model.dart';

class ConversationSystemNotice extends StatelessWidget {
  const ConversationSystemNotice({required this.message, super.key});

  final ConversationMessageViewModel message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      container: true,
      label: message.accessibilityLabel,
      child: ExcludeSemantics(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppSpacing.maxContentWidth,
              ),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondaryContainer,
                  borderRadius: AppSpacing.borderRadiusLg,
                ),
                child: Padding(
                  padding: AppSpacing.cardPaddingCompact,
                  child: Text(
                    message.content,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSecondaryContainer,
                    ),
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

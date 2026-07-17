import 'package:flutter/material.dart';

import 'package:stasisly/core/theme/app_spacing.dart';
import 'package:stasisly/features/conversations/presentation/models/conversation_message_view_model.dart';

class ConversationRedactedMessage extends StatelessWidget {
  const ConversationRedactedMessage({required this.message, super.key});

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
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: theme.colorScheme.outline),
                borderRadius: AppSpacing.borderRadiusLg,
              ),
              child: Padding(
                padding: AppSpacing.cardPaddingCompact,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.visibility_off_outlined, size: 20),
                    const SizedBox(width: AppSpacing.sm),
                    Flexible(child: Text(message.content)),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      message.displayTimestamp,
                      style: theme.textTheme.labelSmall,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

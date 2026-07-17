import 'package:flutter/material.dart';

import 'package:stasisly/core/theme/app_spacing.dart';

class ConversationEmptyState extends StatelessWidget {
  const ConversationEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: 'Conversación vacía',
      child: const ExcludeSemantics(
        child: Center(
          child: Padding(
            padding: AppSpacing.pagePadding,
            child: Text(
              'Todavía no hay mensajes.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

class ConversationLoadingState extends StatelessWidget {
  const ConversationLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      liveRegion: true,
      label: 'Cargando conversación',
      child: const ExcludeSemantics(
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class ConversationErrorState extends StatelessWidget {
  const ConversationErrorState({
    this.message = 'No se pudo cargar la conversación.',
    this.onRetry,
    super.key,
  });

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      liveRegion: true,
      label: message,
      child: ExcludeSemantics(
        child: Center(
          child: Padding(
            padding: AppSpacing.pagePadding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline),
                const SizedBox(height: AppSpacing.sm),
                Text(message, textAlign: TextAlign.center),
                if (onRetry != null) ...[
                  const SizedBox(height: AppSpacing.lg),
                  FilledButton.tonal(
                    onPressed: onRetry,
                    child: const Text('Reintentar'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

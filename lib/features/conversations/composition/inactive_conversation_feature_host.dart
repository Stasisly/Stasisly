import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:stasisly/core/theme/app_spacing.dart';
import 'package:stasisly/features/conversations/application/state/conversation_application_states.dart';
import 'package:stasisly/features/conversations/composition/conversation_providers.dart';
import 'package:stasisly/features/conversations/domain/entities/conversation.dart';
import 'package:stasisly/features/conversations/domain/value_objects/conversation_id.dart';
import 'package:stasisly/features/conversations/presentation/models/conversation_list_item_view_model.dart';
import 'package:stasisly/features/conversations/presentation/models/conversation_message_view_model.dart';
import 'package:stasisly/features/conversations/presentation/widgets/conversation_composer_shell.dart';
import 'package:stasisly/features/conversations/presentation/widgets/conversation_message_bubble.dart';
import 'package:stasisly/features/conversations/presentation/widgets/conversation_states.dart';

/// Local validation host. It is intentionally absent from application routing.
class InactiveConversationFeatureHost extends ConsumerStatefulWidget {
  const InactiveConversationFeatureHost({
    this.conversationId,
    this.onConversationSelected,
    super.key,
  });

  final ConversationId? conversationId;
  final ValueChanged<ConversationId>? onConversationSelected;

  @override
  ConsumerState<InactiveConversationFeatureHost> createState() =>
      _InactiveConversationFeatureHostState();
}

class _InactiveConversationFeatureHostState
    extends ConsumerState<InactiveConversationFeatureHost> {
  final TextEditingController _composer = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  @override
  void didUpdateWidget(InactiveConversationFeatureHost oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.conversationId != widget.conversationId) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _load());
    }
  }

  void _load() {
    if (!mounted) return;
    final id = widget.conversationId;
    if (id == null) {
      ref.read(conversationListControllerProvider.notifier).loadInitial();
    } else {
      ref.read(conversationDetailControllerProvider(id).notifier).load();
    }
  }

  @override
  void dispose() {
    _composer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final id = widget.conversationId;
    if (id == null) return _buildList();
    ref.listen<ConversationDetailState>(
      conversationDetailControllerProvider(id),
      (_, next) {
        if (_composer.text != next.composer.draft) {
          _composer.value = TextEditingValue(
            text: next.composer.draft,
            selection: TextSelection.collapsed(
              offset: next.composer.draft.length,
            ),
          );
        }
      },
    );
    return _buildDetail(id);
  }

  Widget _buildList() {
    final state = ref.watch(conversationListControllerProvider);
    final notifier = ref.read(conversationListControllerProvider.notifier);
    return Column(
      children: [
        Padding(
          padding: AppSpacing.pagePadding,
          child: SegmentedButton<ConversationListFilter>(
            segments: const [
              ButtonSegment(
                value: ConversationListFilter.active,
                label: Text('Activas'),
              ),
              ButtonSegment(
                value: ConversationListFilter.archived,
                label: Text('Archivadas'),
              ),
            ],
            selected: {state.filter},
            onSelectionChanged: (selection) =>
                notifier.changeFilter(selection.single),
          ),
        ),
        Expanded(child: _listBody(state, notifier)),
      ],
    );
  }

  Widget _listBody(
    ConversationListState state,
    ConversationListControllerNotifier notifier,
  ) {
    if (state.phase == ConversationListPhase.loading ||
        state.phase == ConversationListPhase.initial) {
      return const ConversationLoadingState();
    }
    if (state.phase == ConversationListPhase.empty) {
      return const Center(child: Text('No hay conversaciones.'));
    }
    if (state.phase == ConversationListPhase.error ||
        state.phase == ConversationListPhase.environmentBlocked ||
        state.phase == ConversationListPhase.unauthenticated) {
      return ConversationErrorState(
        message: _safeError(state.error),
        onRetry: notifier.refresh,
      );
    }
    return RefreshIndicator(
      onRefresh: notifier.refresh,
      child: ListView.builder(
        itemCount: state.conversations.length + (state.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == state.conversations.length) {
            return Padding(
              padding: AppSpacing.pagePadding,
              child: OutlinedButton(
                onPressed: state.phase == ConversationListPhase.loadingMore
                    ? null
                    : notifier.loadMore,
                child: const Text('Cargar más'),
              ),
            );
          }
          final item = ConversationListItemViewModel.fromConversation(
            state.conversations[index],
          );
          return ListTile(
            title: Text(item.title),
            subtitle: item.specialistSummary == null
                ? null
                : Text(item.specialistSummary!),
            trailing: Text(
              item.status == ConversationStatus.archived
                  ? 'Archivada'
                  : 'Activa',
            ),
            onTap: widget.onConversationSelected == null
                ? null
                : () => widget.onConversationSelected!(item.conversationId),
          );
        },
      ),
    );
  }

  Widget _buildDetail(ConversationId id) {
    final state = ref.watch(conversationDetailControllerProvider(id));
    final notifier = ref.read(
      conversationDetailControllerProvider(id).notifier,
    );
    if (state.phase == ConversationDetailPhase.initial ||
        state.phase == ConversationDetailPhase.loading) {
      return const ConversationLoadingState();
    }
    if (state.conversation == null) {
      return ConversationErrorState(
        message: _safeError(state.error),
        onRetry: notifier.refresh,
      );
    }
    final conversation = ConversationListItemViewModel.fromConversation(
      state.conversation!,
    );
    final mapper = ref.watch(conversationMessageViewMapperProvider);
    final visibleMessages = state.messages.messages
        .map(mapper)
        .whereType<ConversationMessageViewModel>()
        .toList(growable: false);
    return Column(
      children: [
        ListTile(
          title: Text(conversation.title),
          subtitle: Text(state.isArchived ? 'Archivada' : 'Activa'),
          trailing:
              state.lifecycle.status == ConversationLifecycleStatus.changing
              ? const CircularProgressIndicator()
              : TextButton(
                  onPressed: state.isArchived
                      ? notifier.restore
                      : notifier.archive,
                  child: Text(state.isArchived ? 'Restaurar' : 'Archivar'),
                ),
        ),
        Expanded(
          child: switch (state.messages.phase) {
            ConversationMessagesPhase.initial ||
            ConversationMessagesPhase.loading =>
              const ConversationLoadingState(),
            ConversationMessagesPhase.empty => const ConversationEmptyState(),
            ConversationMessagesPhase.error => ConversationErrorState(
              message: _safeError(state.messages.error),
              onRetry: notifier.refresh,
            ),
            _ => ListView.builder(
              itemCount:
                  visibleMessages.length + (state.messages.hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == visibleMessages.length) {
                  return TextButton(
                    onPressed:
                        state.messages.phase ==
                            ConversationMessagesPhase.loadingMore
                        ? null
                        : notifier.loadMoreMessages,
                    child: const Text('Cargar mensajes anteriores'),
                  );
                }
                return ConversationMessageBubble(
                  message: visibleMessages[index],
                );
              },
            ),
          },
        ),
        if (state.composer.sendStatus == ConversationSendStatus.failed)
          Padding(
            padding: AppSpacing.pageHorizontal,
            child: Row(
              children: [
                Expanded(child: Text(_safeError(state.composer.error))),
                if (state.composer.canRetry)
                  TextButton(
                    onPressed: notifier.retrySend,
                    child: const Text('Reintentar envío'),
                  ),
              ],
            ),
          ),
        ConversationComposerShell(
          controller: _composer,
          enabled: !state.isArchived,
          submitting:
              state.composer.sendStatus == ConversationSendStatus.sending,
          onSendIntent: (content) {
            notifier
              ..updateDraft(content)
              ..send();
          },
        ),
      ],
    );
  }
}

String _safeError(ConversationApplicationErrorCode? error) => switch (error) {
  ConversationApplicationErrorCode.unauthenticated =>
    'Necesitas una sesión válida.',
  ConversationApplicationErrorCode.unauthorized ||
  ConversationApplicationErrorCode.notFound =>
    'La conversación no está disponible.',
  ConversationApplicationErrorCode.environmentBlocked =>
    'Esta composición está bloqueada en el entorno actual.',
  ConversationApplicationErrorCode.invalidInput => 'Revisa los datos enviados.',
  ConversationApplicationErrorCode.archived =>
    'No se puede enviar a una conversación archivada.',
  ConversationApplicationErrorCode.idempotencyConflict =>
    'El intento entra en conflicto. Modifica la intención antes de continuar.',
  ConversationApplicationErrorCode.backendUnavailable =>
    'El servicio no está disponible. Puedes reintentar.',
  ConversationApplicationErrorCode.contractViolation ||
  ConversationApplicationErrorCode.unknownFailure ||
  null => 'No se pudo completar la operación.',
};

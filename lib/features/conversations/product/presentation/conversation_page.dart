import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:stasisly/core/theme/app_spacing.dart';
import 'package:stasisly/features/conversations/application/state/conversation_application_states.dart';
import 'package:stasisly/features/conversations/composition/conversation_providers.dart';
import 'package:stasisly/features/conversations/domain/value_objects/conversation_id.dart';
import 'package:stasisly/features/conversations/presentation/models/conversation_list_item_view_model.dart';
import 'package:stasisly/features/conversations/presentation/models/conversation_message_view_model.dart';
import 'package:stasisly/features/conversations/presentation/widgets/conversation_composer_shell.dart';
import 'package:stasisly/features/conversations/presentation/widgets/conversation_message_bubble.dart';
import 'package:stasisly/features/conversations/presentation/widgets/conversation_states.dart';
import 'package:stasisly/features/conversations/product/presentation/conversation_safe_copy.dart';

class ConversationPage extends ConsumerStatefulWidget {
  const ConversationPage({required this.conversationId, super.key});

  final ConversationId? conversationId;

  @override
  ConsumerState<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends ConsumerState<ConversationPage> {
  final TextEditingController _composer = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  @override
  void didUpdateWidget(ConversationPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.conversationId != widget.conversationId) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _load());
    }
  }

  void _load() {
    final id = widget.conversationId;
    if (mounted && id != null) {
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
    if (id == null) return _opaqueNotFound();
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
    final state = ref.watch(conversationDetailControllerProvider(id));
    final notifier = ref.read(
      conversationDetailControllerProvider(id).notifier,
    );
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => _goBack(context)),
        title: const Text('Conversación'),
        actions: [
          if (state.conversation != null) ...[
            if (state.lifecycle.status == ConversationLifecycleStatus.changing)
              const Padding(
                padding: EdgeInsets.all(AppSpacing.md),
                child: SizedBox.square(
                  dimension: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            else
              TextButton(
                key: Key(state.isArchived ? 'restore' : 'archive'),
                onPressed: state.isArchived
                    ? notifier.restore
                    : notifier.archive,
                child: Text(state.isArchived ? 'Restaurar' : 'Archivar'),
              ),
          ],
        ],
      ),
      body: _body(state, notifier),
    );
  }

  Widget _body(
    ConversationDetailState state,
    ConversationDetailControllerNotifier notifier,
  ) {
    if (state.phase == ConversationDetailPhase.initial ||
        state.phase == ConversationDetailPhase.loading) {
      return const ConversationLoadingState();
    }
    if (state.conversation == null) {
      return ConversationErrorState(
        message: conversationSafeError(state.error),
        onRetry: state.phase == ConversationDetailPhase.notFound
            ? null
            : notifier.refresh,
      );
    }
    final summary = ConversationListItemViewModel.fromConversation(
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
          title: Text(summary.title),
          subtitle: Text(
            [
              if (state.isArchived) 'Archivada' else 'Activa',
              if (summary.specialistSummary != null) summary.specialistSummary!,
            ].join(' · '),
          ),
        ),
        if (state.lifecycle.status == ConversationLifecycleStatus.failed)
          Semantics(
            liveRegion: true,
            child: Padding(
              padding: AppSpacing.pageHorizontal,
              child: Text(conversationSafeError(state.lifecycle.error)),
            ),
          ),
        Expanded(child: _messages(state, notifier, visibleMessages)),
        if (state.composer.sendStatus == ConversationSendStatus.failed)
          Semantics(
            liveRegion: true,
            child: Padding(
              padding: AppSpacing.pageHorizontal,
              child: Row(
                children: [
                  Expanded(
                    child: Text(conversationSafeError(state.composer.error)),
                  ),
                  if (state.composer.canRetry)
                    TextButton(
                      onPressed: notifier.retrySend,
                      child: const Text('Reintentar envío'),
                    ),
                ],
              ),
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

  Widget _messages(
    ConversationDetailState state,
    ConversationDetailControllerNotifier notifier,
    List<ConversationMessageViewModel> visibleMessages,
  ) {
    if (state.messages.phase == ConversationMessagesPhase.initial ||
        state.messages.phase == ConversationMessagesPhase.loading) {
      return const ConversationLoadingState();
    }
    if (state.messages.phase == ConversationMessagesPhase.error) {
      return ConversationErrorState(
        message: conversationSafeError(state.messages.error),
        onRetry: notifier.refresh,
      );
    }
    if (visibleMessages.isEmpty) {
      return const Center(
        child: Padding(
          padding: AppSpacing.pagePadding,
          child: Text(
            'Conversación creada. Puedes escribir y revisar tus mensajes. Las respuestas automáticas de Stasis y especialistas no están activas.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    return ListView.builder(
      key: const Key('conversation-message-list'),
      itemCount:
          visibleMessages.length +
          (state.messages.error == null ? 0 : 1) +
          (state.messages.hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (state.messages.error != null && index == 0) {
          return Semantics(
            liveRegion: true,
            child: ListTile(
              title: Text(conversationSafeError(state.messages.error)),
              trailing: TextButton(
                onPressed: notifier.refresh,
                child: const Text('Reintentar'),
              ),
            ),
          );
        }
        final messageIndex = index - (state.messages.error == null ? 0 : 1);
        if (messageIndex == visibleMessages.length) {
          return TextButton(
            key: const Key('load-more-messages'),
            onPressed:
                state.messages.phase == ConversationMessagesPhase.loadingMore
                ? null
                : notifier.loadMoreMessages,
            child: const Text('Cargar mensajes anteriores'),
          );
        }
        return ConversationMessageBubble(
          message: visibleMessages[messageIndex],
        );
      },
    );
  }

  Widget _opaqueNotFound() => Scaffold(
    appBar: AppBar(
      leading: BackButton(onPressed: () => _goBack(context)),
      title: const Text('Conversación'),
    ),
    body: const ConversationErrorState(
      message: 'La conversación no está disponible.',
    ),
  );

  void _goBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/conversations');
    }
  }
}

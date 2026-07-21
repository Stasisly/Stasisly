import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:stasisly/core/theme/app_spacing.dart';
import 'package:stasisly/features/conversations/application/state/conversation_application_states.dart';
import 'package:stasisly/features/conversations/composition/conversation_providers.dart';
import 'package:stasisly/features/conversations/domain/entities/conversation.dart';
import 'package:stasisly/features/conversations/presentation/models/conversation_list_item_view_model.dart';
import 'package:stasisly/features/conversations/presentation/widgets/conversation_states.dart';
import 'package:stasisly/features/conversations/product/presentation/conversation_safe_copy.dart';

class ConversationsPage extends ConsumerStatefulWidget {
  const ConversationsPage({super.key});

  @override
  ConsumerState<ConversationsPage> createState() => _ConversationsPageState();
}

class _ConversationsPageState extends ConsumerState<ConversationsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(conversationListControllerProvider.notifier).loadInitial();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(conversationListControllerProvider);
    final notifier = ref.read(conversationListControllerProvider.notifier);
    return Scaffold(
      appBar: AppBar(title: const Text('Conversaciones')),
      body: Column(
        children: [
          Padding(
            padding: AppSpacing.pagePadding,
            child: Semantics(
              label: 'Filtro de conversaciones',
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
          ),
          Expanded(child: _body(context, state, notifier)),
        ],
      ),
    );
  }

  Widget _body(
    BuildContext context,
    ConversationListState state,
    ConversationListControllerNotifier notifier,
  ) {
    if (state.phase == ConversationListPhase.initial ||
        state.phase == ConversationListPhase.loading) {
      return const ConversationLoadingState();
    }
    if (state.phase == ConversationListPhase.empty) {
      return Center(
        child: Padding(
          padding: AppSpacing.pagePadding,
          child: Text(
            state.filter == ConversationListFilter.active
                ? 'No tienes conversaciones activas.'
                : 'No tienes conversaciones archivadas.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    if (state.phase == ConversationListPhase.error ||
        state.phase == ConversationListPhase.environmentBlocked ||
        state.phase == ConversationListPhase.unauthenticated) {
      return ConversationErrorState(
        message: conversationSafeError(state.error),
        onRetry: notifier.refresh,
      );
    }
    return RefreshIndicator(
      onRefresh: notifier.refresh,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: state.conversations.length + (state.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == state.conversations.length) {
            return Padding(
              padding: AppSpacing.pagePadding,
              child: OutlinedButton(
                key: const Key('load-more-conversations'),
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
          return Semantics(
            button: true,
            label:
                '${item.title}, ${item.status == ConversationStatus.archived ? 'archivada' : 'activa'}',
            child: ListTile(
              key: ValueKey('conversation-${item.conversationId.value}'),
              title: Text(item.title),
              subtitle: Text(
                [
                  if (item.specialistSummary != null) item.specialistSummary!,
                  _date(item.updatedAt),
                ].join(' · '),
              ),
              trailing: Text(
                item.status == ConversationStatus.archived
                    ? 'Archivada'
                    : 'Activa',
              ),
              onTap: () => context.push(
                '/conversations/${Uri.encodeComponent(item.conversationId.value)}',
              ),
            ),
          );
        },
      ),
    );
  }

  String _date(DateTime value) {
    final local = value.toLocal();
    return '${local.day.toString().padLeft(2, '0')}/'
        '${local.month.toString().padLeft(2, '0')}/${local.year}';
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:stasisly/core/auth/session/providers/secure_session_providers.dart';
import 'package:stasisly/core/config/app_environment.dart';
import 'package:stasisly/core/idempotency/operation_attempt_id.dart';
import 'package:stasisly/core/identity/domain/authentication_state.dart';
import 'package:stasisly/core/identity/domain/identity_type.dart';
import 'package:stasisly/core/identity/domain/stasisly_identity.dart';
import 'package:stasisly/core/observability/conversation_observability.dart';
import 'package:stasisly/features/chat_messages/presentation/providers/own_chat_messages_providers.dart';
import 'package:stasisly/features/chat_sessions/domain/repositories/own_chat_sessions_repository.dart';
import 'package:stasisly/features/chat_sessions/presentation/providers/own_chat_sessions_providers.dart';
import 'package:stasisly/features/conversations/application/controllers/conversation_create_controller.dart';
import 'package:stasisly/features/conversations/application/controllers/conversation_detail_controller.dart';
import 'package:stasisly/features/conversations/application/controllers/conversation_list_controller.dart';
import 'package:stasisly/features/conversations/application/state/conversation_application_states.dart';
import 'package:stasisly/features/conversations/application/use_cases/conversation_use_cases.dart';
import 'package:stasisly/features/conversations/data/adapters/transitional_conversation_repository_adapter.dart';
import 'package:stasisly/features/conversations/data/repositories/fail_closed_conversation_repository.dart';
import 'package:stasisly/features/conversations/domain/entities/conversation_message.dart';
import 'package:stasisly/features/conversations/domain/repositories/conversation_repository.dart';
import 'package:stasisly/features/conversations/domain/results/conversation_results.dart';
import 'package:stasisly/features/conversations/domain/value_objects/conversation_id.dart';
import 'package:stasisly/features/conversations/presentation/mappers/conversation_message_view_mapper.dart';
import 'package:stasisly/features/conversations/presentation/models/conversation_message_view_model.dart';

/// Availability of the explicit, inactive Conversation composition.
enum ConversationCompositionAvailability { available, environmentBlocked }

final conversationObservabilitySinkProvider =
    Provider<ConversationObservabilitySink>(
      (ref) => const NoOpConversationObservabilitySink(),
    );

final conversationObservedEnvironmentProvider =
    Provider<ConversationObservedEnvironment>((ref) {
      return ConversationObservedEnvironment.values.byName(
        ref.watch(appEnvironmentProvider).mode.name,
      );
    });

final conversationCompositionAvailabilityProvider =
    Provider<ConversationCompositionAvailability>((ref) {
      final mode = ref.watch(appEnvironmentProvider).mode;
      return mode == AppRuntimeMode.local || mode == AppRuntimeMode.development
          ? ConversationCompositionAvailability.available
          : ConversationCompositionAvailability.environmentBlocked;
    });

final conversationTrustedIdentityProvider = Provider<StasislyIdentity?>((ref) {
  final session = ref.watch(secureSessionStateProvider).authState;
  final subjectId = session.subjectId?.trim();
  if (!session.isAuthenticated || subjectId == null || subjectId.isEmpty) {
    return null;
  }
  return StasislyIdentity(
    subjectId: subjectId,
    identityType: IdentityType.humanUser,
    authenticationState: AuthenticationState.authenticated,
    email: session.email,
  );
});

final conversationRepositoryProvider = Provider<ConversationRepository>((ref) {
  if (ref.watch(conversationCompositionAvailabilityProvider) ==
      ConversationCompositionAvailability.environmentBlocked) {
    return const FailClosedConversationRepository(
      ConversationResultStatus.environmentBlocked,
    );
  }
  final identity = ref.watch(conversationTrustedIdentityProvider);
  if (identity == null) {
    return const FailClosedConversationRepository(
      ConversationResultStatus.unauthenticated,
    );
  }
  final sessions = ref.watch(ownChatSessionsRepositoryProvider);
  return TransitionalConversationRepositoryAdapter(
    chatSessions: sessions,
    chatMessages: ref.watch(ownChatMessagesRepositoryProvider),
    lifecycle: sessions is OwnChatSessionLifecycleRepository
        ? sessions as OwnChatSessionLifecycleRepository
        : null,
    trustedOwner: identity,
  );
});

final conversationOperationAttemptIdFactoryProvider =
    Provider<OperationAttemptIdFactory>(
      (ref) => const SecureOperationAttemptIdFactory(),
    );

final listOwnConversationsProvider = Provider<ListOwnConversations>(
  (ref) => ListOwnConversations(ref.watch(conversationRepositoryProvider)),
);
final readOwnConversationProvider = Provider<ReadOwnConversation>(
  (ref) => ReadOwnConversation(ref.watch(conversationRepositoryProvider)),
);
final createOwnConversationProvider = Provider<CreateOwnConversation>(
  (ref) => CreateOwnConversation(ref.watch(conversationRepositoryProvider)),
);
final archiveOwnConversationProvider = Provider<ArchiveOwnConversation>(
  (ref) => ArchiveOwnConversation(ref.watch(conversationRepositoryProvider)),
);
final restoreOwnConversationProvider = Provider<RestoreOwnConversation>(
  (ref) => RestoreOwnConversation(ref.watch(conversationRepositoryProvider)),
);
final listOwnConversationMessagesProvider =
    Provider<ListOwnConversationMessages>(
      (ref) => ListOwnConversationMessages(
        ref.watch(conversationRepositoryProvider),
      ),
    );
final sendOwnConversationMessageProvider = Provider<SendOwnConversationMessage>(
  (ref) =>
      SendOwnConversationMessage(ref.watch(conversationRepositoryProvider)),
);

typedef CanonicalConversationMessageMapper =
    ConversationMessageViewModel? Function(ConversationMessage message);

final conversationMessageViewMapperProvider =
    Provider<CanonicalConversationMessageMapper>(
      (ref) => ConversationMessageViewMapper.tryMap,
    );

final inactiveConversationHostCompositionProvider = Provider<bool>((ref) {
  return ref.watch(conversationCompositionAvailabilityProvider) ==
      ConversationCompositionAvailability.available;
});

final conversationListControllerProvider =
    StateNotifierProvider.autoDispose<
      ConversationListControllerNotifier,
      ConversationListState
    >((ref) {
      return ConversationListControllerNotifier(
        listOwnConversations: ref.watch(listOwnConversationsProvider),
        observability: ref.watch(conversationObservabilitySinkProvider),
        observedEnvironment: ref.watch(conversationObservedEnvironmentProvider),
      );
    });

final conversationCreateControllerProvider =
    StateNotifierProvider.autoDispose<
      ConversationCreateControllerNotifier,
      ConversationCreateState
    >((ref) {
      return ConversationCreateControllerNotifier(
        createOwnConversation: ref.watch(createOwnConversationProvider),
        operationAttemptIds: ref.watch(
          conversationOperationAttemptIdFactoryProvider,
        ),
      );
    });

final conversationDetailControllerProvider = StateNotifierProvider.autoDispose
    .family<
      ConversationDetailControllerNotifier,
      ConversationDetailState,
      ConversationId
    >((ref, conversationId) {
      return ConversationDetailControllerNotifier(
        conversationId: conversationId,
        readOwnConversation: ref.watch(readOwnConversationProvider),
        listOwnConversationMessages: ref.watch(
          listOwnConversationMessagesProvider,
        ),
        sendOwnConversationMessage: ref.watch(
          sendOwnConversationMessageProvider,
        ),
        archiveOwnConversation: ref.watch(archiveOwnConversationProvider),
        restoreOwnConversation: ref.watch(restoreOwnConversationProvider),
        operationAttemptIds: ref.watch(
          conversationOperationAttemptIdFactoryProvider,
        ),
        observability: ref.watch(conversationObservabilitySinkProvider),
        observedEnvironment: ref.watch(conversationObservedEnvironmentProvider),
        onListsInvalidated: () =>
            ref.invalidate(conversationListControllerProvider),
      );
    });

class ConversationListControllerNotifier
    extends StateNotifier<ConversationListState> {
  ConversationListControllerNotifier({
    required ListOwnConversations listOwnConversations,
    required ConversationObservabilitySink observability,
    required ConversationObservedEnvironment observedEnvironment,
  }) : super(const ConversationListState()) {
    _controller = ConversationListController(
      listOwnConversations: listOwnConversations,
      observability: observability,
      observedEnvironment: observedEnvironment,
      onStateChanged: (next) => state = next,
    );
  }

  late final ConversationListController _controller;

  Future<void> loadInitial() => _controller.loadInitial();
  Future<void> refresh() => _controller.refresh();
  Future<void> changeFilter(ConversationListFilter filter) =>
      _controller.changeFilter(filter);
  Future<void> loadMore() => _controller.loadMore();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class ConversationCreateControllerNotifier
    extends StateNotifier<ConversationCreateState> {
  ConversationCreateControllerNotifier({
    required CreateOwnConversation createOwnConversation,
    required OperationAttemptIdFactory operationAttemptIds,
  }) : super(const ConversationCreateState()) {
    _controller = ConversationCreateController(
      createOwnConversation: createOwnConversation,
      operationAttemptIds: operationAttemptIds,
      onStateChanged: (next) => state = next,
    );
  }

  late final ConversationCreateController _controller;

  Future<void> create(String selectableSpecialistId) =>
      _controller.create(selectableSpecialistId);
  Future<void> retry() => _controller.retry();
  void startNewIntent() => _controller.startNewIntent();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class ConversationDetailControllerNotifier
    extends StateNotifier<ConversationDetailState> {
  ConversationDetailControllerNotifier({
    required ConversationId conversationId,
    required ReadOwnConversation readOwnConversation,
    required ListOwnConversationMessages listOwnConversationMessages,
    required SendOwnConversationMessage sendOwnConversationMessage,
    required ArchiveOwnConversation archiveOwnConversation,
    required RestoreOwnConversation restoreOwnConversation,
    required OperationAttemptIdFactory operationAttemptIds,
    required void Function() onListsInvalidated,
    required ConversationObservabilitySink observability,
    required ConversationObservedEnvironment observedEnvironment,
  }) : super(const ConversationDetailState()) {
    _controller = ConversationDetailController(
      conversationId: conversationId,
      readOwnConversation: readOwnConversation,
      listOwnConversationMessages: listOwnConversationMessages,
      sendOwnConversationMessage: sendOwnConversationMessage,
      archiveOwnConversation: archiveOwnConversation,
      restoreOwnConversation: restoreOwnConversation,
      operationAttemptIds: operationAttemptIds,
      observability: observability,
      observedEnvironment: observedEnvironment,
      onStateChanged: (next) => state = next,
      onListsInvalidated: onListsInvalidated,
    );
  }

  late final ConversationDetailController _controller;

  Future<void> load() => _controller.load();
  Future<void> refresh() => _controller.refresh();
  Future<void> loadMoreMessages() => _controller.loadMoreMessages();
  void updateDraft(String value) => _controller.updateDraft(value);
  Future<void> send() => _controller.send();
  Future<void> retrySend() => _controller.retrySend();
  Future<void> archive() => _controller.archive();
  Future<void> restore() => _controller.restore();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

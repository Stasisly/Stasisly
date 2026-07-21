import 'package:stasisly/core/idempotency/operation_attempt_id.dart';
import 'package:stasisly/core/identity/domain/authentication_state.dart';
import 'package:stasisly/core/identity/domain/identity_type.dart';
import 'package:stasisly/core/identity/domain/stasisly_identity.dart';
import 'package:stasisly/core/observability/conversation_observability.dart';
import 'package:stasisly/features/conversations/application/inputs/conversation_inputs.dart';
import 'package:stasisly/features/conversations/domain/entities/conversation.dart';
import 'package:stasisly/features/conversations/domain/entities/conversation_message.dart';
import 'package:stasisly/features/conversations/domain/repositories/conversation_repository.dart';
import 'package:stasisly/features/conversations/domain/results/conversation_results.dart';
import 'package:stasisly/features/conversations/domain/value_objects/conversation_id.dart';

const testIdentity = StasislyIdentity(
  subjectId: 'synthetic-subject',
  identityType: IdentityType.humanUser,
  authenticationState: AuthenticationState.authenticated,
);

class InMemoryConversationObservabilitySink
    implements ConversationObservabilitySink {
  final List<ConversationObservation> observations = [];

  @override
  void record(ConversationObservation observation) {
    observations.add(observation);
  }

  void clear() => observations.clear();
}

Conversation conversation({
  String id = 'conversation-1',
  ConversationStatus status = ConversationStatus.active,
  String? title = 'Conversación sintética',
}) => Conversation.fromTrustedIdentity(
  conversationId: ConversationId(id),
  ownerIdentity: testIdentity,
  status: status,
  createdAt: DateTime.utc(2026),
  updatedAt: DateTime.utc(2026, 1, 2),
  archivedAt: status == ConversationStatus.archived
      ? DateTime.utc(2026, 1, 2)
      : null,
  title: title,
  selectedSpecialistReference: ConversationSpecialistSelection(
    selectableSpecialistId: 'specialist-public-1',
    displayName: 'Especialista sintético',
    area: 'Salud',
    state: ConversationSpecialistSelectionState.selected,
  ),
);

ConversationMessage message({
  String id = 'message-1',
  String conversationId = 'conversation-1',
  String content = 'Mensaje sintético',
}) => ConversationMessage(
  messageId: id,
  conversationId: ConversationId(conversationId),
  author: const UserAuthor(),
  content: content,
  createdAt: DateTime.utc(2026, 1, 2),
  status: ConversationMessageStatus.accepted,
  provenance: ConversationMessageProvenance.userProvided,
  visibility: ConversationMessageVisibility.ownerOnly,
);

class SequenceOperationAttemptIdFactory implements OperationAttemptIdFactory {
  int count = 0;

  @override
  OperationAttemptId create() {
    count += 1;
    return OperationAttemptId(
      'test_attempt_${count.toString().padLeft(8, '0')}',
    );
  }
}

class FakeConversationRepository implements ConversationRepository {
  ConversationListResult listResult = const ConversationListSuccess(
    ConversationPage(items: [], nextCursor: null),
  );
  ConversationReadResult readResult = ConversationReadSuccess(conversation());
  ConversationMutationResult createResult = ConversationMutationSuccess(
    conversation: conversation(),
  );
  ConversationMutationResult archiveResult = ConversationMutationSuccess(
    receipt: ConversationMutationReceipt(
      conversationId: ConversationId('conversation-1'),
      status: ConversationStatus.archived,
    ),
  );
  ConversationMutationResult restoreResult = ConversationMutationSuccess(
    receipt: ConversationMutationReceipt(
      conversationId: ConversationId('conversation-1'),
      status: ConversationStatus.active,
    ),
  );
  ConversationMessageListResult messagesResult = ConversationMessageListSuccess(
    ConversationMessagePage(items: [message()], nextCursor: null),
  );
  ConversationMessageSendResult sendResult = ConversationMessageSendSuccess(
    ConversationMessageSendReceipt(
      message: message(id: 'sent-message'),
      messageCount: 2,
      lastMessageAt: DateTime.utc(2026, 1, 2),
    ),
  );

  Future<ConversationListResult> Function(
    ConversationStatusFilter status,
    int limit,
    String? cursor,
  )?
  onList;
  Future<ConversationReadResult> Function(ConversationId id)? onRead;
  Future<ConversationMutationResult> Function(CreateConversationInput input)?
  onCreate;
  Future<ConversationMutationResult> Function(ArchiveConversationInput input)?
  onArchive;
  Future<ConversationMutationResult> Function(RestoreConversationInput input)?
  onRestore;
  Future<ConversationMessageListResult> Function(
    ListConversationMessagesInput input,
  )?
  onMessages;
  Future<ConversationMessageSendResult> Function(
    SendConversationMessageInput input,
  )?
  onSend;

  final List<ConversationStatusFilter> listStatuses = [];
  final List<String?> listCursors = [];
  final List<CreateConversationInput> createInputs = [];
  final List<SendConversationMessageInput> sendInputs = [];
  int archiveCalls = 0;
  int restoreCalls = 0;
  int messageCalls = 0;

  @override
  Future<ConversationListResult> listOwnConversations({
    ConversationStatusFilter status = ConversationStatusFilter.active,
    int limit = 20,
    String? cursor,
  }) async {
    listStatuses.add(status);
    listCursors.add(cursor);
    return onList?.call(status, limit, cursor) ?? listResult;
  }

  @override
  Future<ConversationReadResult> readOwnConversation(
    ConversationId conversationId,
  ) async => onRead?.call(conversationId) ?? readResult;

  @override
  Future<ConversationMutationResult> createOwnConversation(
    CreateConversationInput input,
  ) async {
    createInputs.add(input);
    return onCreate?.call(input) ?? createResult;
  }

  @override
  Future<ConversationMutationResult> archiveOwnConversation(
    ArchiveConversationInput input,
  ) async {
    archiveCalls += 1;
    return onArchive?.call(input) ?? archiveResult;
  }

  @override
  Future<ConversationMutationResult> restoreOwnConversation(
    RestoreConversationInput input,
  ) async {
    restoreCalls += 1;
    return onRestore?.call(input) ?? restoreResult;
  }

  @override
  Future<ConversationMessageListResult> listOwnConversationMessages(
    ListConversationMessagesInput input,
  ) async {
    messageCalls += 1;
    return onMessages?.call(input) ?? messagesResult;
  }

  @override
  Future<ConversationMessageSendResult> sendOwnConversationMessage(
    SendConversationMessageInput input,
  ) async {
    sendInputs.add(input);
    return onSend?.call(input) ?? sendResult;
  }
}

import 'package:stasisly/features/conversations/application/inputs/conversation_inputs.dart';
import 'package:stasisly/features/conversations/domain/entities/conversation.dart';
import 'package:stasisly/features/conversations/domain/repositories/conversation_repository.dart';
import 'package:stasisly/features/conversations/domain/results/conversation_results.dart';
import 'package:stasisly/features/conversations/domain/value_objects/conversation_id.dart';

class FailClosedConversationRepository implements ConversationRepository {
  const FailClosedConversationRepository(this.status)
    : assert(
        status != ConversationResultStatus.success,
        'A fail-closed repository cannot return success.',
      );

  final ConversationResultStatus status;

  @override
  Future<ConversationMutationResult> archiveOwnConversation(
    ArchiveConversationInput input,
  ) async => ConversationMutationFailure(status);

  @override
  Future<ConversationMutationResult> createOwnConversation(
    CreateConversationInput input,
  ) async => ConversationMutationFailure(status);

  @override
  Future<ConversationListResult> listOwnConversations({
    ConversationStatusFilter status = ConversationStatusFilter.active,
    int limit = 20,
    String? cursor,
  }) async => ConversationListFailure(this.status);

  @override
  Future<ConversationMessageListResult> listOwnConversationMessages(
    ListConversationMessagesInput input,
  ) async => ConversationMessageListFailure(status);

  @override
  Future<ConversationReadResult> readOwnConversation(
    ConversationId conversationId,
  ) async => ConversationReadFailure(status);

  @override
  Future<ConversationMutationResult> restoreOwnConversation(
    RestoreConversationInput input,
  ) async => ConversationMutationFailure(status);

  @override
  Future<ConversationMessageSendResult> sendOwnConversationMessage(
    SendConversationMessageInput input,
  ) async => ConversationMessageSendFailure(status);
}

import 'package:stasisly/features/conversations/application/inputs/conversation_inputs.dart';
import 'package:stasisly/features/conversations/domain/entities/conversation.dart';
import 'package:stasisly/features/conversations/domain/results/conversation_results.dart';
import 'package:stasisly/features/conversations/domain/value_objects/conversation_id.dart';

abstract interface class ConversationRepository {
  Future<ConversationListResult> listOwnConversations({
    ConversationStatusFilter status = ConversationStatusFilter.active,
    int limit = 20,
    String? cursor,
  });

  Future<ConversationMutationResult> createOwnConversation(
    CreateConversationInput input,
  );

  Future<ConversationReadResult> readOwnConversation(
    ConversationId conversationId,
  );

  Future<ConversationMutationResult> archiveOwnConversation(
    ArchiveConversationInput input,
  );

  Future<ConversationMutationResult> restoreOwnConversation(
    RestoreConversationInput input,
  );

  Future<ConversationMessageListResult> listOwnConversationMessages(
    ListConversationMessagesInput input,
  );

  Future<ConversationMessageSendResult> sendOwnConversationMessage(
    SendConversationMessageInput input,
  );
}

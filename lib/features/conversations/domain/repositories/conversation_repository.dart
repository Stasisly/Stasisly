import 'package:stasisly/features/conversations/application/inputs/conversation_inputs.dart';
import 'package:stasisly/features/conversations/domain/entities/conversation.dart';
import 'package:stasisly/features/conversations/domain/results/conversation_results.dart';

abstract interface class ConversationRepository {
  Future<ConversationListResult> listOwnConversations({
    ConversationStatusFilter status = ConversationStatusFilter.active,
    int limit = 20,
    String? cursor,
  });

  Future<ConversationMutationResult> createOwnConversation(
    CreateConversationInput input,
  );

  Future<ConversationMutationResult> archiveOwnConversation(
    ArchiveConversationInput input,
  );

  Future<ConversationMessageListResult> listOwnConversationMessages(
    ListConversationMessagesInput input,
  );

  Future<ConversationMessageSendResult> sendOwnConversationMessage(
    SendConversationMessageInput input,
  );
}

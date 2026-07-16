import 'package:stasisly/features/chat_messages/domain/entities/own_chat_message.dart';
import 'package:stasisly/features/conversations/domain/entities/conversation.dart';
import 'package:stasisly/features/conversations/domain/entities/conversation_message.dart';
import 'package:stasisly/features/conversations/domain/value_objects/conversation_id.dart';

class OwnChatMessageConversationAdapter {
  const OwnChatMessageConversationAdapter();

  ConversationMessage map(OwnChatMessage source) {
    final (author, provenance) = switch (source.role) {
      OwnChatMessageRole.user => (
        ConversationMessageAuthor.user,
        ConversationMessageProvenance.userProvided,
      ),
      OwnChatMessageRole.system => (
        ConversationMessageAuthor.systemNotice,
        ConversationMessageProvenance.systemGenerated,
      ),
      OwnChatMessageRole.assistant || OwnChatMessageRole.tool => (
        ConversationMessageAuthor.unknown,
        ConversationMessageProvenance.unknown,
      ),
    };
    final conversationId = ConversationId.tryParse(source.sessionId);
    final content = source.content.trim();
    if (conversationId == null ||
        source.messageId.trim().isEmpty ||
        content.isEmpty ||
        content.length > ConversationMessage.maxContentLength) {
      throw const ConversationContractException(
        'Invalid transitional message contract.',
      );
    }
    return ConversationMessage(
      messageId: source.messageId.trim(),
      conversationId: conversationId,
      author: author,
      content: source.content,
      createdAt: source.createdAt.toUtc(),
      status: ConversationMessageStatus.accepted,
      provenanceSummary: provenance,
    );
  }
}

import 'package:stasisly/features/chat_messages/domain/entities/own_chat_message.dart';
import 'package:stasisly/features/conversations/domain/entities/conversation.dart';
import 'package:stasisly/features/conversations/domain/entities/conversation_message.dart';
import 'package:stasisly/features/conversations/domain/value_objects/conversation_id.dart';

class OwnChatMessageConversationAdapter {
  const OwnChatMessageConversationAdapter();

  ConversationMessage map(OwnChatMessage source) {
    final author = switch (source.authorType) {
      OwnChatMessageAuthorType.user => const UserAuthor(),
      OwnChatMessageAuthorType.systemNotice => const SystemNoticeAuthor(),
      OwnChatMessageAuthorType.stasis ||
      OwnChatMessageAuthorType.specialist ||
      OwnChatMessageAuthorType.unknown => const UnknownAuthor(),
    };
    final provenance = ConversationMessageProvenance.values.firstWhere(
      (value) => value.name == source.provenance.name,
    );
    final visibility = ConversationMessageVisibility.values.firstWhere(
      (value) => value.name == source.visibility.name,
    );
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
    if (author is UnknownAuthor || !visibility.isProductReadable) {
      throw const ConversationContractException(
        'Message is not safely attributable and Product-visible.',
      );
    }
    return ConversationMessage(
      messageId: source.messageId.trim(),
      conversationId: conversationId,
      author: author,
      content: source.content,
      createdAt: source.createdAt.toUtc(),
      status: source.status == OwnChatMessageStatus.redacted
          ? ConversationMessageStatus.redacted
          : ConversationMessageStatus.accepted,
      provenance: provenance,
      visibility: visibility,
    );
  }
}

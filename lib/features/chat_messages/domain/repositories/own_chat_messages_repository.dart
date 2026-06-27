import 'package:stasisly/features/chat_messages/domain/entities/own_chat_message_results.dart';

abstract interface class OwnChatMessagesRepository {
  Future<SendUserMessageResult> sendUserMessage({
    required String sessionId,
    required String content,
  });

  Future<ListSessionMessagesResult> listSessionMessages({
    required String sessionId,
    int limit = 50,
    String? cursor,
  });
}

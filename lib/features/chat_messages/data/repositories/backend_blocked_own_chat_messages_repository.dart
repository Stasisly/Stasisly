import 'package:stasisly/features/chat_messages/domain/entities/own_chat_message_results.dart';
import 'package:stasisly/features/chat_messages/domain/repositories/own_chat_messages_repository.dart';

class BackendBlockedOwnChatMessagesRepository
    implements OwnChatMessagesRepository {
  const BackendBlockedOwnChatMessagesRepository();

  @override
  Future<SendUserMessageResult> sendUserMessage({
    required String sessionId,
    required String content,
  }) async {
    return const SendUserMessageFailure(
      SendOwnChatMessageFailureType.backendBlocked,
    );
  }

  @override
  Future<ListSessionMessagesResult> listSessionMessages({
    required String sessionId,
    int limit = 50,
    String? cursor,
  }) async {
    return const ListSessionMessagesFailure(
      ListOwnChatMessagesFailureType.backendBlocked,
    );
  }
}

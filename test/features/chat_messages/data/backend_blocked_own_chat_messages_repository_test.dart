import 'package:flutter_test/flutter_test.dart';
import 'package:stasisly/features/chat_messages/data/repositories/backend_blocked_own_chat_messages_repository.dart';
import 'package:stasisly/features/chat_messages/domain/entities/own_chat_message_results.dart';

void main() {
  test('send returns backendBlocked without demo fallback', () async {
    const repository = BackendBlockedOwnChatMessagesRepository();

    final result = await repository.sendUserMessage(
      sessionId: 'session-1',
      content: 'hola',
    );

    expect(
      result,
      const SendUserMessageFailure(
        SendOwnChatMessageFailureType.backendBlocked,
      ),
    );
    expect(result, isNot(isA<SendUserMessageDemo>()));
  });

  test('list returns backendBlocked without demo fallback', () async {
    const repository = BackendBlockedOwnChatMessagesRepository();

    final result = await repository.listSessionMessages(sessionId: 'session-1');

    expect(
      result,
      const ListSessionMessagesFailure(
        ListOwnChatMessagesFailureType.backendBlocked,
      ),
    );
    expect(result, isNot(isA<ListSessionMessagesDemo>()));
  });
}

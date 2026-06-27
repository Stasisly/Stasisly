import 'package:flutter_test/flutter_test.dart';
import 'package:stasisly/features/chat_messages/data/repositories/demo_own_chat_messages_repository.dart';
import 'package:stasisly/features/chat_messages/domain/entities/own_chat_message.dart';
import 'package:stasisly/features/chat_messages/domain/entities/own_chat_message_results.dart';

void main() {
  test('send demo creates user message marked as demo', () async {
    final repository = DemoOwnChatMessagesRepository();

    final result = await repository.sendUserMessage(
      sessionId: 'session-1',
      content: '  hola demo  ',
    );

    expect(result, isA<SendUserMessageDemo>());
    final sent = (result as SendUserMessageDemo).sent;
    expect(sent.isDemo, true);
    expect(sent.message.isDemo, true);
    expect(sent.message.role, OwnChatMessageRole.user);
    expect(sent.message.content, 'hola demo');
    expect(sent.messageCount, 1);
  });

  test(
    'list demo returns demo messages with stable cursor pagination',
    () async {
      final repository = DemoOwnChatMessagesRepository();
      await repository.sendUserMessage(sessionId: 'session-1', content: 'uno');
      await repository.sendUserMessage(sessionId: 'session-1', content: 'dos');

      final first = await repository.listSessionMessages(
        sessionId: 'session-1',
        limit: 1,
      );
      expect(first, isA<ListSessionMessagesDemo>());
      final firstPage = (first as ListSessionMessagesDemo).page;
      expect(firstPage.items.single.content, 'uno');
      expect(firstPage.items.single.isDemo, true);
      expect(firstPage.nextCursor, isNotNull);

      final second = await repository.listSessionMessages(
        sessionId: 'session-1',
        limit: 1,
        cursor: firstPage.nextCursor,
      );
      final secondPage = (second as ListSessionMessagesDemo).page;
      expect(secondPage.items.single.content, 'dos');
      expect(secondPage.nextCursor, isNull);
    },
  );

  test(
    'demo repository validates inputs without pretending authority',
    () async {
      final repository = DemoOwnChatMessagesRepository();

      expect(
        await repository.sendUserMessage(sessionId: '', content: 'hola'),
        const SendUserMessageFailure(
          SendOwnChatMessageFailureType.invalidSession,
        ),
      );
      expect(
        await repository.sendUserMessage(
          sessionId: 'session-1',
          content: '   ',
        ),
        const SendUserMessageFailure(
          SendOwnChatMessageFailureType.contentInvalid,
        ),
      );
      expect(
        await repository.listSessionMessages(
          sessionId: 'session-1',
          limit: 101,
        ),
        const ListSessionMessagesFailure(
          ListOwnChatMessagesFailureType.invalidRequest,
        ),
      );
    },
  );

  test(
    'demo repository never turns invalid cursor into fallback data',
    () async {
      final repository = DemoOwnChatMessagesRepository();
      await repository.sendUserMessage(sessionId: 'session-1', content: 'uno');

      final result = await repository.listSessionMessages(
        sessionId: 'session-1',
        cursor: 'unknown-cursor',
      );

      expect(
        result,
        const ListSessionMessagesFailure(
          ListOwnChatMessagesFailureType.invalidCursor,
        ),
      );
    },
  );
}

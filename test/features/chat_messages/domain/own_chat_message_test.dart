import 'package:flutter_test/flutter_test.dart';
import 'package:stasisly/features/chat_messages/domain/entities/own_chat_message.dart';
import 'package:stasisly/features/chat_messages/domain/entities/own_chat_message_results.dart';

void main() {
  test('message model exposes only public fields and demo marker', () {
    final message = OwnChatMessage(
      messageId: 'message-1',
      sessionId: 'session-1',
      role: OwnChatMessageRole.user,
      content: 'Hola',
      createdAt: DateTime.utc(2026),
      isDemo: true,
    );

    expect(message.messageId, 'message-1');
    expect(message.sessionId, 'session-1');
    expect(message.role, OwnChatMessageRole.user);
    expect(message.content, 'Hola');
    expect(message.createdAt, DateTime.utc(2026));
    expect(message.isDemo, true);
  });

  test('only approved roles are parsed', () {
    expect(OwnChatMessageRole.tryParse('user'), OwnChatMessageRole.user);
    expect(
      OwnChatMessageRole.tryParse('assistant'),
      OwnChatMessageRole.assistant,
    );
    expect(OwnChatMessageRole.tryParse('system'), OwnChatMessageRole.system);
    expect(OwnChatMessageRole.tryParse('tool'), OwnChatMessageRole.tool);

    for (final forbidden in [
      'chief_intervention',
      'admin',
      'manager',
      'specialist',
      'moderator',
      'owner',
    ]) {
      expect(OwnChatMessageRole.tryParse(forbidden), isNull);
    }
  });

  test('send and list failures keep separate typed domains', () {
    expect(
      SendOwnChatMessageFailureType.values,
      contains(SendOwnChatMessageFailureType.sessionArchived),
    );
    expect(
      ListOwnChatMessagesFailureType.values,
      isNot(contains(SendOwnChatMessageFailureType.sessionArchived)),
    );
    expect(
      ListOwnChatMessagesFailureType.values,
      contains(ListOwnChatMessagesFailureType.invalidCursor),
    );
  });

  test('sent message keeps server-managed counters as response only', () {
    final message = OwnChatMessage(
      messageId: 'message-1',
      sessionId: 'session-1',
      role: OwnChatMessageRole.user,
      content: 'Hola',
      createdAt: DateTime.utc(2026),
      isDemo: false,
    );
    final sent = SentOwnChatMessage(
      message: message,
      sessionId: 'session-1',
      messageCount: 1,
      lastMessageAt: message.createdAt,
      isDemo: false,
    );

    expect(sent.message, message);
    expect(sent.messageCount, 1);
    expect(sent.lastMessageAt, message.createdAt);
    expect(sent.isDemo, false);
  });
}

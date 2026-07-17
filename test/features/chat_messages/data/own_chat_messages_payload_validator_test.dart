import 'package:flutter_test/flutter_test.dart';
import 'package:stasisly/features/chat_messages/data/contracts/own_chat_messages_payload_validator.dart';
import 'package:stasisly/features/chat_messages/domain/entities/own_chat_message.dart';

void main() {
  const validator = OwnChatMessagesPayloadValidator();

  Map<String, Object?> messagePayload({String role = 'user'}) => {
    'author': {'type': 'user'},
    'messageId': 'message-1',
    'sessionId': 'session-1',
    'role': role,
    'content': 'hola',
    'createdAt': '2026-06-21T10:00:00Z',
    'status': 'accepted',
    'provenance': 'userProvided',
    'visibility': 'productVisible',
  };

  Map<String, Object?> sentPayload() => {
    'message': messagePayload(),
    'session': {
      'sessionId': 'session-1',
      'messageCount': 1,
      'lastMessageAt': '2026-06-21T10:00:00Z',
    },
  };

  Map<String, Object?> pagePayload() => {
    'items': [messagePayload()],
    'nextCursor': null,
  };

  test('valid send payload is accepted', () {
    final sent = validator.parseSentMessage(sentPayload());

    expect(sent.message.role, OwnChatMessageRole.user);
    expect(sent.sessionId, 'session-1');
    expect(sent.messageCount, 1);
    expect(sent.isDemo, false);
  });

  test('valid list payload accepts items and cursor shapes', () {
    final empty = validator.parseMessagesPage({
      'items': <Object?>[],
      'nextCursor': null,
    });
    final page = validator.parseMessagesPage({
      'items': [messagePayload()],
      'nextCursor': 'opaque-cursor',
    });

    expect(empty.items, isEmpty);
    expect(page.items.single.role, OwnChatMessageRole.user);
    expect(page.items.single.authorType, OwnChatMessageAuthorType.user);
    expect(page.nextCursor, 'opaque-cursor');
  });

  test('send payload rejects internal and forbidden keys', () {
    for (final forbidden in [
      'user_id',
      'userId',
      'ownerUserId',
      'owner',
      'ownerId',
      'specialist_id',
      'specialistId',
      'agentId',
      'internalSpecialistId',
      'prompt_template',
      'promptTemplate',
      'systemPrompt',
      'developerPrompt',
      'service_role',
      'serviceRole',
      'JWT',
      'accessToken',
      'refreshToken',
      'attachments',
      'metadata',
      'permissions',
      'rawError',
      'extra',
    ]) {
      final payload = sentPayload();
      if (forbidden == 'extra') {
        payload[forbidden] = true;
      } else {
        (payload['message']! as Map<String, Object?>)[forbidden] = 'blocked';
      }
      expect(
        () => validator.parseSentMessage(payload),
        throwsA(isA<OwnChatMessagesContractException>()),
        reason: forbidden,
      );
    }
  });

  test('list payload rejects internal item keys and extra top-level keys', () {
    for (final forbidden in [
      'user_id',
      'userId',
      'ownerUserId',
      'specialist_id',
      'specialistId',
      'attachments',
      'metadata',
      'prompt',
      'permissions',
      'service_role',
      'rawError',
    ]) {
      final payload = pagePayload();
      ((payload['items']! as List<Object?>).single!
              as Map<String, Object?>)[forbidden] =
          'blocked';
      expect(
        () => validator.parseMessagesPage(payload),
        throwsA(isA<OwnChatMessagesContractException>()),
        reason: forbidden,
      );
    }

    final extra = pagePayload()..['extra'] = true;
    expect(
      () => validator.parseMessagesPage(extra),
      throwsA(isA<OwnChatMessagesContractException>()),
    );
  });

  test('invalid roles, partial payloads and invalid types are rejected', () {
    for (final role in ['chief_intervention', 'admin', 'manager']) {
      expect(
        () => validator.parseMessagesPage({
          'items': [messagePayload(role: role)],
          'nextCursor': null,
        }),
        throwsA(isA<OwnChatMessagesContractException>()),
      );
    }

    final partial = sentPayload();
    (partial['message']! as Map<String, Object?>).remove('content');
    expect(
      () => validator.parseSentMessage(partial),
      throwsA(isA<OwnChatMessagesContractException>()),
    );

    final invalidCount = sentPayload();
    (invalidCount['session']! as Map<String, Object?>)['messageCount'] = -1;
    expect(
      () => validator.parseSentMessage(invalidCount),
      throwsA(isA<OwnChatMessagesContractException>()),
    );

    final invalidCursor = pagePayload()..['nextCursor'] = 7;
    expect(
      () => validator.parseMessagesPage(invalidCursor),
      throwsA(isA<OwnChatMessagesContractException>()),
    );
  });

  test(
    'internal and unknown visibility fail closed; redaction hides content',
    () {
      for (final visibility in ['internal', 'unknown']) {
        final message = messagePayload()..['visibility'] = visibility;
        expect(
          () => validator.parseMessagesPage({
            'items': [message],
            'nextCursor': null,
          }),
          throwsA(isA<OwnChatMessagesContractException>()),
        );
      }
      final redacted = messagePayload()
        ..remove('content')
        ..['status'] = 'redacted'
        ..['visibility'] = 'redacted';
      final page = validator.parseMessagesPage({
        'items': [redacted],
        'nextCursor': null,
      });
      expect(page.items.single.content, OwnChatMessageRedaction.placeholder);
    },
  );
}

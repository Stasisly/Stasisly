import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  final canonicalMessage = File(
    'lib/features/conversations/domain/entities/conversation_message.dart',
  );
  final sendInput = File(
    'lib/features/conversations/application/inputs/conversation_inputs.dart',
  );
  final adapter = File(
    'lib/features/conversations/data/adapters/'
    'own_chat_message_conversation_adapter.dart',
  );

  test(
    'Product message contract excludes runtime and private trace fields',
    () {
      final source = canonicalMessage.readAsStringSync();
      for (final forbidden in [
        'agentId',
        'modelId',
        'modelProvider',
        'promptId',
        'promptVersion',
        'toolInput',
        'toolOutput',
        'chainOfThought',
        'internalAnalysis',
        'ownerSubjectId',
        'specialists.id',
      ]) {
        expect(source, isNot(contains(forbidden)), reason: forbidden);
      }
      expect(source, contains('selectableSpecialistId'));
      expect(source, contains("publicReference = 'stasis'"));
    },
  );

  test('send input remains content-only authority neutral', () {
    final source = sendInput.readAsStringSync();
    final sendClass = source.substring(
      source.indexOf('class SendConversationMessageInput'),
      source.indexOf('String? _optionalRequired'),
    );
    for (final forbidden in [
      'author',
      'provenance',
      'visibility',
      'specialistId',
      'selectableSpecialistId',
      'agentId',
      'model',
      'tool',
      'owner',
      'role',
      'surface',
      'environment',
    ]) {
      expect(sendClass, isNot(contains(forbidden)), reason: forbidden);
    }
    expect(sendClass, contains('ConversationId conversationId'));
    expect(sendClass, contains('String content'));
  });

  test(
    'transitional mapping uses metadata rather than assistant or tool role',
    () {
      final source = adapter.readAsStringSync();
      expect(source, contains('source.authorType'));
      expect(source, contains('source.visibility'));
      expect(source, isNot(contains('OwnChatMessageRole.assistant')));
      expect(source, isNot(contains('OwnChatMessageRole.tool')));
      expect(source, isNot(contains('StasisAuthor()')));
      expect(source, isNot(contains('SpecialistAuthor(')));
    },
  );

  test(
    'Edge read filters in SQL RPC and Flutter rejects hidden visibility',
    () {
      final edge = File(
        'supabase/functions/list-session-messages/index.ts',
      ).readAsStringSync();
      final validator = File(
        'lib/features/chat_messages/data/contracts/'
        'own_chat_messages_payload_validator.dart',
      ).readAsStringSync();
      expect(edge, contains('list_own_conversation_messages_core'));
      expect(edge, isNot(contains('/rest/v1/messages')));
      expect(validator, contains('OwnChatMessageVisibility.internal'));
      expect(validator, contains('OwnChatMessageVisibility.unknown'));
    },
  );
}

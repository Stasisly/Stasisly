import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  final feature = Directory('lib/features/conversations');
  final domain = Directory('lib/features/conversations/domain');

  Iterable<File> dartFiles(Directory directory) {
    return directory
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'));
  }

  test('canonical domain has no provider or legacy chat coupling', () {
    for (final file in dartFiles(domain)) {
      final source = file.readAsStringSync();
      for (final forbidden in [
        'supabase',
        'Supabase',
        'package:dio/',
        'package:http/',
        'features/chat/',
        'provider thread',
        'runtimeSessionId',
        'agentId',
        'ownerUserId',
        'specialists.id',
        'promptId',
        'modelId',
        'toolPermissions',
        'accessToken',
      ]) {
        expect(source, isNot(contains(forbidden)), reason: file.path);
      }
    }
  });

  test('Product inputs cannot accept client authority fields', () {
    final source = File(
      'lib/features/conversations/application/inputs/conversation_inputs.dart',
    ).readAsStringSync();

    for (final forbidden in [
      'ownerUserId',
      'authorId',
      'agentId',
      'specialistId',
      'surface',
      'environment',
      'role',
      'entitlement',
    ]) {
      expect(source, isNot(contains(forbidden)));
    }
    expect(source, contains('selectableSpecialistId'));
    expect(source, contains('conversationId'));
    expect(source, contains('content'));
  });

  test(
    'canonical feature has no presentation, routes or remote datasource',
    () {
      expect(
        Directory('lib/features/conversations/presentation').existsSync(),
        isFalse,
      );
      expect(
        Directory('lib/features/conversations/routes').existsSync(),
        isFalse,
      );
      expect(
        Directory('lib/features/conversations/data/datasources').existsSync(),
        isFalse,
      );

      for (final file in dartFiles(feature)) {
        final source = file.readAsStringSync();
        expect(source, isNot(contains("'/conversations")), reason: file.path);
        expect(source, isNot(contains('"/conversations')), reason: file.path);
        expect(source, isNot(contains('features/chat/')), reason: file.path);
        expect(
          source,
          isNot(contains('typedef Conversation')),
          reason: file.path,
        );
        expect(
          source,
          isNot(contains('DemoChatRepository')),
          reason: file.path,
        );
      }
    },
  );

  test('Product routes remain unregistered', () {
    final routes = File('lib/core/config/routes.dart').readAsStringSync();
    final registry = File(
      'lib/core/routing/infrastructure/entry_point_registry.dart',
    ).readAsStringSync();

    for (final source in [routes, registry]) {
      expect(source, isNot(contains("path: '/conversations'")));
      expect(source, isNot(contains("path: '/conversations/:conversationId'")));
      expect(source, isNot(contains("pathPattern: '/conversations'")));
      expect(
        source,
        isNot(contains("pathPattern: '/conversations/:conversationId'")),
      );
    }
  });

  test('transitional contracts remain unchanged in public shape', () {
    final session = File(
      'lib/features/chat_sessions/domain/entities/own_chat_session.dart',
    ).readAsStringSync();
    final message = File(
      'lib/features/chat_messages/domain/entities/own_chat_message.dart',
    ).readAsStringSync();
    final repository = File(
      'lib/features/chat_messages/domain/repositories/'
      'own_chat_messages_repository.dart',
    ).readAsStringSync();

    expect(session, contains('final String sessionId;'));
    expect(session, contains('SelectableSpecialistSummary'));
    expect(message, contains('final String sessionId;'));
    expect(message, contains('OwnChatMessageRole'));
    expect(repository, contains('required String sessionId'));
    expect(repository, contains('required String content'));
    expect(repository, isNot(contains('role')));
  });
}

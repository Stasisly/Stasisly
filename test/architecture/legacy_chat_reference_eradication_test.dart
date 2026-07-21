import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:stasisly/core/routing/infrastructure/entry_point_registry.dart';

void main() {
  Iterable<File> dartFiles(String root) {
    final directory = Directory(root);
    if (!directory.existsSync()) return const [];
    return directory
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'));
  }

  test('LEGACY_CHAT_REFERENCE_ERADICATION has no legacy runtime source', () {
    expect(Directory('lib/features/chat').existsSync(), isFalse);
    expect(
      File(
        'lib/features/orchestrator/presentation/pages/'
        'orchestrator_chat_page.dart',
      ).existsSync(),
      isFalse,
    );

    for (final file in dartFiles('lib')) {
      final source = file.readAsStringSync();
      expect(source, isNot(contains('features/chat/')), reason: file.path);
      for (final symbol in [
        'ChatPage',
        'ChatController',
        'ChatRepository',
        'ChatState',
        'ChatSessionEntity',
        'MessageEntity',
        'SupabaseChatDataSource',
        'DemoChatRepository',
      ]) {
        expect(
          RegExp('\\b$symbol\\b').hasMatch(source),
          isFalse,
          reason: '${file.path}: $symbol',
        );
      }
    }
  });

  test('legacy chat route is absent without canonical redirect', () {
    final registry = File(
      'lib/core/routing/infrastructure/entry_point_registry.dart',
    ).readAsStringSync();
    final routes = File('lib/core/config/routes.dart').readAsStringSync();

    expect(EntryPointRegistry.resolvePath('/chat/legacy-id'), isNull);
    expect(registry, isNot(contains("pathPattern: '/chat/:id'")));
    expect(registry, isNot(contains('legacyAgentChat')));
    expect(routes, isNot(contains('legacyAgentChat')));
    expect(routes, isNot(contains("redirect: '/conversations'")));
    expect(routes, isNot(contains("redirect: '/stasis'")));
  });

  test('canonical Product graph has no Orchestrator edge', () {
    for (final root in [
      'lib/features/conversations',
      'lib/features/conversations/product',
    ]) {
      for (final file in dartFiles(root)) {
        final source = file.readAsStringSync();
        expect(
          source,
          isNot(contains('features/orchestrator/')),
          reason: file.path,
        );
        expect(source, isNot(contains('features/chat/')), reason: file.path);
      }
    }

    for (final file in dartFiles('lib/features/orchestrator')) {
      final source = file.readAsStringSync();
      expect(source, isNot(contains('features/chat/')), reason: file.path);
      expect(
        source,
        isNot(contains('features/conversations/')),
        reason: file.path,
      );
    }
  });

  test('transitional repositories remain present and encapsulated', () {
    expect(Directory('lib/features/chat_sessions').existsSync(), isTrue);
    expect(Directory('lib/features/chat_messages').existsSync(), isTrue);

    final adapter = File(
      'lib/features/conversations/data/adapters/'
      'transitional_conversation_repository_adapter.dart',
    ).readAsStringSync();
    expect(adapter, contains('OwnChatSessionsRepository'));
    expect(adapter, contains('OwnChatMessagesRepository'));

    for (final file in dartFiles('lib/features/conversations/product')) {
      final source = file.readAsStringSync();
      expect(
        source,
        isNot(contains('OwnChatSessionsRepository')),
        reason: file.path,
      );
      expect(
        source,
        isNot(contains('OwnChatMessagesRepository')),
        reason: file.path,
      );
      expect(
        source,
        isNot(contains('TransitionalConversationRepositoryAdapter')),
        reason: file.path,
      );
    }
  });
}

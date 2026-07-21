import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  final canonicalPresentation = Directory(
    'lib/features/conversations/presentation',
  );
  final legacyChat = Directory('lib/features/chat');

  Iterable<File> dartFiles(Directory directory) {
    return directory
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'));
  }

  test('canonical presentation is provider neutral and legacy free', () {
    for (final file in dartFiles(canonicalPresentation)) {
      final source = file.readAsStringSync();
      for (final forbidden in [
        'features/chat/',
        'features/chat_messages/',
        'features/chat_sessions/',
        'features/orchestrator/',
        'supabase',
        'Supabase',
        'package:dio/',
        'package:http/',
        'flutter_riverpod',
        'ChatRepository',
        'OwnChatMessage',
        'MessageEntity',
        'agentId',
        'ownerSubjectId',
        'specialists.id',
        'accessToken',
        'refreshToken',
        'authorizationContext',
        'toolInput',
        'toolOutput',
      ]) {
        expect(source, isNot(contains(forbidden)), reason: file.path);
      }
    }
  });

  test(
    'canonical presentation contains no screen provider route or wiring',
    () {
      final paths = dartFiles(
        canonicalPresentation,
      ).map((file) => file.path).toList();
      for (final forbidden in [
        'page.dart',
        'screen.dart',
        'provider.dart',
        'controller.dart',
        'repository.dart',
        'datasource.dart',
        'router.dart',
        'route.dart',
      ]) {
        expect(paths.where((path) => path.endsWith(forbidden)), isEmpty);
      }

      final composer = File(
        'lib/features/conversations/presentation/widgets/'
        'conversation_composer_shell.dart',
      ).readAsStringSync();
      for (final forbidden in [
        'repository',
        'token',
        'session',
        'idempotency',
        'author',
        'provenance',
        'visibility',
        'attachment',
        'retry',
      ]) {
        expect(composer.toLowerCase(), isNot(contains(forbidden)));
      }
    },
  );

  test('message mapper fails closed and never brands unknown as Stasis', () {
    final mapper = File(
      'lib/features/conversations/presentation/mappers/'
      'conversation_message_view_mapper.dart',
    ).readAsStringSync();

    expect(mapper, contains('ConversationMessageVisibility.internal'));
    expect(mapper, contains('ConversationMessageVisibility.unknown'));
    expect(mapper, contains('message.author is UnknownAuthor'));
    expect(mapper, contains('return null'));
    expect(mapper, isNot(contains('UnknownAuthor() =>')));
    expect(mapper, isNot(contains("UnknownAuthor(), 'Stasis'")));
  });

  test('legacy freeze README is explicit and canonical barrel is safe', () {
    final readme = File('lib/features/chat/README.md').readAsStringSync();
    final barrel = File(
      'lib/features/conversations/conversations.dart',
    ).readAsStringSync();

    for (final required in [
      'DEPRECATED_AND_BLOCKED',
      'lib/features/conversations/',
      'new routes or features',
      'new repository or provider consumers',
      'must never be used as fallback',
    ]) {
      expect(readme, contains(required));
    }
    expect(barrel, isNot(contains('features/chat/')));
    expect(barrel, isNot(contains('repository')));
    expect(barrel, isNot(contains('datasource')));
  });

  test(
    'legacy imports outside feature remain frozen to known blocked consumer',
    () {
      final consumers = Directory('lib')
          .listSync(recursive: true)
          .whereType<File>()
          .where((file) => file.path.endsWith('.dart'))
          .where((file) => !file.path.startsWith('lib/features/chat/'))
          .where((file) => file.readAsStringSync().contains('features/chat/'))
          .map((file) => file.path)
          .toSet();

      expect(consumers, {
        'lib/features/orchestrator/presentation/pages/orchestrator_chat_page.dart',
      });
    },
  );

  test('direct Supabase legacy coupling cannot spread beyond frozen files', () {
    final coupled = dartFiles(legacyChat)
        .where((file) => file.readAsStringSync().contains('supabase_flutter'))
        .map((file) => file.path)
        .toSet();

    expect(coupled, {
      'lib/features/chat/data/datasources/supabase_chat_datasource.dart',
      'lib/features/chat/presentation/viewmodels/chat_providers.dart',
    });
  });

  test('legacy routes remain blocked beside canonical Product routes', () {
    final registry = File(
      'lib/core/routing/infrastructure/entry_point_registry.dart',
    ).readAsStringSync();

    expect(registry, contains("pathPattern: '/chat/:id'"));
    expect(registry, contains('EntryPointLegacyState.legacyBlocked'));
    expect(registry, contains("pathPattern: '/conversations'"));
    expect(registry, contains("pathPattern: '/stasis'"));
    expect(registry, contains("pathPattern: '/conversations/:conversationId'"));
  });
}

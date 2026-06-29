import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  final featureFiles = Directory('lib/features/chat_messages')
      .listSync(recursive: true)
      .whereType<File>()
      .where((file) => file.path.endsWith('.dart'))
      .toList(growable: false);

  test('messages feature has no Supabase, HTTP or runtime coupling', () {
    for (final file in featureFiles) {
      final source = file.readAsStringSync();
      for (final forbidden in [
        'supabase_flutter',
        'Supabase.instance',
        'functions.invoke',
        'package:http/',
        'package:dio/',
        'dart:io',
        'dart:html',
        'firebase',
        'StasisEngine',
        'MCP',
        'stream',
      ]) {
        expect(source, isNot(contains(forbidden)), reason: file.path);
      }
    }
  });

  test('Edge Function paths are centralized only in local datasource', () {
    for (final file in featureFiles) {
      final source = file.readAsStringSync();
      if (source.contains('/functions/v1/') ||
          source.contains('send-user-message') ||
          source.contains('list-session-messages')) {
        expect(
          file.path,
          endsWith(
            'data/datasources/local_http_own_chat_messages_datasource.dart',
          ),
        );
        expect(source, isNot(contains('supabase.co')));
        expect(source, isNot(contains('https://')));
      }
    }
  });

  test('public contracts contain no owner or specialist authority', () {
    final publicFiles = [
      File('lib/features/chat_messages/domain/entities/own_chat_message.dart'),
      File(
        'lib/features/chat_messages/domain/entities/'
        'own_chat_message_results.dart',
      ),
      File(
        'lib/features/chat_messages/domain/repositories/'
        'own_chat_messages_repository.dart',
      ),
    ];

    for (final file in publicFiles) {
      final source = file.readAsStringSync();
      for (final forbidden in [
        'userId',
        'user_id',
        'ownerId',
        'owner',
        'specialistId',
        'specialist_id',
        'internalSpecialistId',
        'promptTemplate',
        'prompt_template',
        'attachments',
        'metadata',
        'serviceRole',
        'service_role',
        'JWT',
        'accessToken',
        'refreshToken',
      ]) {
        expect(source, isNot(contains(forbidden)), reason: file.path);
      }
    }
  });

  test('repository sends only sessionId and content', () {
    final source = File(
      'lib/features/chat_messages/domain/repositories/'
      'own_chat_messages_repository.dart',
    ).readAsStringSync();

    expect(source, contains('required String sessionId'));
    expect(source, contains('required String content'));
    expect(source, contains('int limit = 50'));
    expect(source, contains('String? cursor'));
    for (final forbidden in [
      'required OwnChatMessageRole role',
      'required String role',
      'required DateTime createdAt',
      'required int messageCount',
      'required DateTime lastMessageAt',
    ]) {
      expect(source, isNot(contains(forbidden)));
    }
  });

  test('application layer stays pure and disconnected from UI/providers', () {
    final applicationFiles = Directory('lib/features/chat_messages/application')
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'))
        .toList(growable: false);

    expect(applicationFiles, isNotEmpty);
    for (final file in applicationFiles) {
      final source = file.readAsStringSync();
      for (final forbidden in [
        'package:flutter/',
        'BuildContext',
        'riverpod',
        'provider',
        'hooks',
        'package:dio/',
        'package:http/',
        'supabase',
        'Supabase',
        '/functions/v1/',
        'send-user-message',
        'list-session-messages',
        'features/chat/',
        'StasisEngine',
        'MCP',
        'stream',
      ]) {
        expect(source, isNot(contains(forbidden)), reason: file.path);
      }
    }
  });

  test(
    'messages providers stay overrideable and disconnected from UI/runtime',
    () {
      final providerFiles =
          Directory('lib/features/chat_messages/presentation/providers')
              .listSync(recursive: true)
              .whereType<File>()
              .where((file) {
                return file.path.endsWith('.dart');
              })
              .toList(growable: false);

      expect(providerFiles, isNotEmpty);
      for (final file in providerFiles) {
        final source = file.readAsStringSync();
        expect(source, contains('Provider<'), reason: file.path);
        for (final forbidden in [
          'package:flutter/material.dart',
          'package:flutter/widgets.dart',
          'BuildContext',
          'supabase_flutter',
          'Supabase',
          'package:dio/',
          'package:http/',
          'dart:io',
          'dart:html',
          'firebase',
          '/functions/v1/',
          'send-user-message',
          'list-session-messages',
          'features/chat/',
          'service_role',
          'serviceRole',
          'userId',
          'user_id',
          'specialistId',
          'specialist_id',
          'StasisEngine',
          'MCP',
          'streaming',
        ]) {
          expect(source, isNot(contains(forbidden)), reason: file.path);
        }
      }
    },
  );

  test(
    'secure session messages wrapper stays local-safe and feature-scoped',
    () {
      final file = File(
        'lib/features/chat_messages/data/local/'
        'secure_session_chat_messages_token_provider.dart',
      );
      final source = file.readAsStringSync();

      expect(source, contains('SecureSessionToLocalSessionTokenAdapter'));
      expect(source, contains('LocalSessionTokenProvider'));
      for (final forbidden in [
        'features/auth/',
        'auth_providers',
        'AuthController',
        'SupabaseAuthDataSource',
        'Supabase.instance.client',
        'supabase_flutter',
        'package:dio/',
        'package:http/',
        'dart:io',
        'dart:html',
        '/functions/v1/',
        'send-user-message',
        'list-session-messages',
        'service_role',
        'serviceRole',
        'Bearer ',
        'BuildContext',
        'Widget',
        'userId',
        'user_id',
        'specialistId',
        'specialist_id',
        'role',
        'attachments',
        'metadata',
        'StasisEngine',
        'MCP',
        'streaming',
      ]) {
        expect(source, isNot(contains(forbidden)), reason: file.path);
      }
    },
  );

  test('core auth session does not depend on chat messages feature', () {
    final coreFiles = Directory('lib/core/auth/session')
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'))
        .toList(growable: false);

    expect(coreFiles, isNotEmpty);
    for (final file in coreFiles) {
      final source = file.readAsStringSync();
      for (final forbidden in [
        'features/chat_messages/',
        'OwnChatMessages',
        'LocalSessionTokenProvider',
        'send-user-message',
        'list-session-messages',
      ]) {
        expect(source, isNot(contains(forbidden)), reason: file.path);
      }
    }
  });

  test('messages widgets stay isolated from transport and internal ids', () {
    final widgetFiles =
        Directory('lib/features/chat_messages/presentation/widgets')
            .listSync(recursive: true)
            .whereType<File>()
            .where((file) => file.path.endsWith('.dart'))
            .toList(growable: false);

    expect(widgetFiles, isNotEmpty);
    for (final file in widgetFiles) {
      final source = file.readAsStringSync();
      for (final forbidden in [
        'supabase_flutter',
        'Supabase',
        'package:dio/',
        'package:http/',
        'dart:io',
        'dart:html',
        'firebase',
        '/functions/v1/',
        'send-user-message',
        'list-session-messages',
        'features/chat/',
        'service_role',
        'serviceRole',
        'JWT',
        'accessToken',
        'refreshToken',
        'userId',
        'user_id',
        'specialistId',
        'specialist_id',
        'attachments',
        'metadata',
        'StasisEngine',
        'MCP',
        'streaming',
      ]) {
        expect(source, isNot(contains(forbidden)), reason: file.path);
      }
    }
  });

  test(
    'messages dev host stays isolated from routing and runtime services',
    () {
      final devFiles = Directory('lib/features/chat_messages/presentation/dev')
          .listSync(recursive: true)
          .whereType<File>()
          .where((file) => file.path.endsWith('.dart'))
          .toList(growable: false);

      expect(devFiles, isNotEmpty);
      for (final file in devFiles) {
        final source = file.readAsStringSync();
        for (final forbidden in [
          'supabase_flutter',
          'supabase',
          'Supabase',
          'package:dio/',
          'package:http/',
          'dart:io',
          'dart:html',
          'firebase',
          '/functions/v1/',
          'send-user-message',
          'list-session-messages',
          'features/chat/',
          'go_router',
          'GoRouter',
          'router',
          'service_role',
          'serviceRole',
          'jwt',
          'JWT',
          'access_token',
          'accessToken',
          'refresh_token',
          'refreshToken',
          'userId',
          'user_id',
          'specialistId',
          'specialist_id',
          'attachments',
          'metadata',
          'StasisEngine',
          'MCP',
          'streaming',
          'real user',
          'real data',
        ]) {
          expect(source, isNot(contains(forbidden)), reason: file.path);
        }
      }
    },
  );

  test('messages shells stay isolated from legacy chat runtime', () {
    final shellFiles =
        Directory('lib/features/chat_messages/presentation/shell')
            .listSync(recursive: true)
            .whereType<File>()
            .where((file) => file.path.endsWith('.dart'))
            .toList(growable: false);

    expect(shellFiles, isNotEmpty);
    for (final file in shellFiles) {
      final source = file.readAsStringSync();
      final isComposedShell = file.path.endsWith(
        'own_chat_composed_safe_shell.dart',
      );
      if (isComposedShell) {
        expect(
          source,
          contains('features/chat_sessions/presentation/'),
          reason: file.path,
        );
        expect(source, contains('selectedSessionId'), reason: file.path);
        expect(source, contains('OwnChatMessagesSafeShell'), reason: file.path);
      } else {
        expect(
          source,
          isNot(contains('features/chat_sessions/')),
          reason: file.path,
        );
      }
      for (final forbidden in [
        'Supabase.instance.client',
        'SupabaseChatDataSource',
        'ChatController',
        'chat_providers',
        'supabase_flutter',
        'supabase',
        'Supabase',
        'package:dio/',
        'package:http/',
        '/functions/v1/',
        "role: 'user'",
        'role =',
        'userId',
        'user_id',
        'specialistId',
        'specialist_id',
        'service_role',
        'serviceRole',
        'JWT',
        'access_token',
        'accessToken',
        'refresh_token',
        'refreshToken',
        'messages.insert',
        "from('messages')",
        'from("messages")',
        'attachments',
        'metadata',
        'features/chat/',
        'go_router',
        'GoRouter',
        'StasisEngine',
        'MCP',
        'streaming',
      ]) {
        expect(source, isNot(contains(forbidden)), reason: file.path);
      }
    }
  });

  test('composed messages shell is local-safe and route-free', () {
    final source = File(
      'lib/features/chat_messages/presentation/shell/'
      'own_chat_composed_safe_shell.dart',
    ).readAsStringSync();

    expect(source, contains('ownChatSessionsStateProvider'));
    expect(source, contains('selectedSessionId'));
    expect(source, contains('OwnChatMessagesSafeShell'));
    expect(source, contains('OwnChatSessionsPanel'));
    for (final forbidden in [
      'features/auth/',
      'auth_providers',
      'AuthController',
      'SupabaseAuthDataSource',
      'Supabase.instance.client',
      'features/chat/',
      'AgentChatWrapper',
      'ChatPage',
      'ChatController',
      'chat_providers',
      'SupabaseChatDataSource',
      '/chat/:id',
      '/orchestrator/chat',
      'GoRouter',
      'AppRouter',
      'service_role',
      'serviceRole',
      'accessToken',
      'refreshToken',
      'Bearer ',
      'package:dio/',
      'package:http/',
      'supabase',
      'Supabase',
      'userId',
      'user_id',
      'ownerUserId',
      'owner_user_id',
      'specialistId',
      'specialist_id',
      'agentId',
      'attachments',
      'metadata',
      'MCP',
      'StasisEngine',
      'streaming',
    ]) {
      expect(source, isNot(contains(forbidden)), reason: forbidden);
    }
  });
}

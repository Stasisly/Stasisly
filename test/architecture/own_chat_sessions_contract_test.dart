import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  final featureFiles = Directory('lib/features/chat_sessions')
      .listSync(recursive: true)
      .whereType<File>()
      .where((file) => file.path.endsWith('.dart'))
      .toList(growable: false);

  test(
    'sessions feature never uses Supabase or forbidden runtime coupling',
    () {
      for (final file in featureFiles) {
        final source = file.readAsStringSync();
        for (final forbidden in [
          'supabase_flutter',
          'Supabase.instance',
          'functions.invoke',
          'package:http/',
          'dart:io',
          'dart:html',
          'service_role',
          'messages',
        ]) {
          expect(source, isNot(contains(forbidden)), reason: file.path);
        }
      }
    },
  );

  test(
    'real HTTP dependency and function paths stay inside local data layer',
    () {
      for (final file in featureFiles) {
        final source = file.readAsStringSync();
        if (source.contains('package:dio/')) {
          expect(
            file.path,
            endsWith('data/local/own_chat_sessions_http_transport.dart'),
          );
        }
        if (source.contains('/functions/v1/')) {
          expect(
            file.path,
            endsWith(
              'data/datasources/local_http_own_chat_sessions_datasource.dart',
            ),
          );
        }
      }
    },
  );

  test('local datasource cannot reference demo fallback', () {
    final source = File(
      'lib/features/chat_sessions/data/datasources/'
      'local_http_own_chat_sessions_datasource.dart',
    ).readAsStringSync();

    expect(source, isNot(contains('DemoOwnChatSessionsRepository')));
    expect(source, isNot(contains('CreateOwnChatSessionDemo')));
    expect(source, isNot(contains('ListOwnChatSessionsDemo')));
    expect(source, isNot(contains('ArchiveOwnChatSessionDemo')));
  });

  test('local HTTP layer disables redirects and contains no token logging', () {
    final localFiles = Directory('lib/features/chat_sessions/data/local')
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'))
        .toList(growable: false);
    final transport = File(
      'lib/features/chat_sessions/data/local/'
      'own_chat_sessions_http_transport.dart',
    ).readAsStringSync();

    expect(transport, contains('followRedirects: false'));
    expect(transport, contains('maxRedirects: 0'));
    for (final file in localFiles) {
      final source = file.readAsStringSync();
      for (final forbidden in ['print(', 'debugPrint(', 'log(', 'developer.']) {
        expect(source, isNot(contains(forbidden)), reason: file.path);
      }
    }
  });

  test('public domain and repository contracts contain no internal ids', () {
    final publicFiles = [
      File('lib/features/chat_sessions/domain/entities/own_chat_session.dart'),
      File(
        'lib/features/chat_sessions/domain/entities/'
        'own_chat_session_results.dart',
      ),
      File(
        'lib/features/chat_sessions/domain/repositories/'
        'own_chat_sessions_repository.dart',
      ),
      File(
        'lib/features/chat_sessions/data/contracts/'
        'own_chat_sessions_contract_source.dart',
      ),
    ];

    for (final file in publicFiles) {
      final source = file.readAsStringSync();
      for (final forbidden in [
        'userId',
        'user_id',
        'specialistId',
        'specialist_id',
        'internalSpecialistId',
        'ownerId',
        'authUserId',
        'backendUserId',
        'prompt_template',
        'access_tier',
        'availability_status',
        'roles',
        'permissions',
      ]) {
        expect(source, isNot(contains(forbidden)), reason: file.path);
      }
    }
  });

  test('repository contract accepts only approved operation inputs', () {
    final source = File(
      'lib/features/chat_sessions/domain/repositories/'
      'own_chat_sessions_repository.dart',
    ).readAsStringSync();

    expect(source, contains('required String selectableSpecialistId'));
    expect(source, contains('required String sessionId'));
    expect(source, contains('ChatSessionStatusFilter status'));
    expect(source, contains('int limit = 20'));
    expect(source, contains('String? cursor'));
  });

  test('application controller stays pure and UI-safe', () {
    final applicationFiles = Directory('lib/features/chat_sessions/application')
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
        'Widget',
        'package:flutter_riverpod/',
        'package:hooks_riverpod/',
        'package:provider/',
        'ProviderScope',
        'ConsumerWidget',
        'StateNotifier',
        'Notifier',
        'supabase_flutter',
        'Supabase.instance',
        'package:dio/',
        'package:http/',
        '/functions/v1/',
        'create-own-chat-session',
        'list-own-chat-sessions',
        'archive-own-chat-session',
        'features/chat/',
        'features/chat_messages/',
        'OwnChatMessagesSafeShell',
        'SupabaseChatDataSource',
        'ChatController',
        'userId',
        'user_id',
        'specialistId',
        'specialist_id',
        'agentId',
        'agent_id',
        'role',
        'roles',
        'permissions',
        'StasisEngine',
        'MCP',
        'streaming',
      ]) {
        expect(source, isNot(contains(forbidden)), reason: file.path);
      }
    }
  });

  test('application exposes sessionId but never treats agentId as input', () {
    final controller = File(
      'lib/features/chat_sessions/application/'
      'own_chat_sessions_controller.dart',
    ).readAsStringSync();
    final state = File(
      'lib/features/chat_sessions/application/own_chat_sessions_state.dart',
    ).readAsStringSync();

    expect(
      controller,
      contains('createSession(String selectableSpecialistId)'),
    );
    expect(controller, contains('selectedSessionId: session.sessionId'));
    expect(controller, contains('archiveSession(String sessionId)'));
    expect(controller, contains('selectSession(String sessionId)'));
    expect(state, contains('String? selectedSessionId'));
    expect(controller, isNot(contains('agentId')));
    expect(state, isNot(contains('agentId')));
  });

  test(
    'presentation providers stay overrideable and disconnected from runtime',
    () {
      final providerFiles =
          Directory('lib/features/chat_sessions/presentation/providers')
              .listSync(recursive: true)
              .whereType<File>()
              .where((file) => file.path.endsWith('.dart'))
              .toList(growable: false);

      expect(providerFiles, isNotEmpty);

      for (final file in providerFiles) {
        final source = file.readAsStringSync();
        expect(source, contains('Provider<OwnChatSessionsRepository>'));
        expect(source, contains('StateNotifierProvider'));
        for (final forbidden in [
          'package:flutter/material.dart',
          'package:flutter/widgets.dart',
          'BuildContext',
          'supabase_flutter',
          'Supabase.instance',
          'package:dio/',
          'package:http/',
          '/functions/v1/',
          'create-own-chat-session',
          'list-own-chat-sessions',
          'archive-own-chat-session',
          'features/chat/',
          'features/chat_messages/',
          'OwnChatMessagesSafeShell',
          'OwnChatMessagesPanel',
          'SupabaseChatDataSource',
          'ChatController',
          'userId',
          'user_id',
          'specialistId',
          'specialist_id',
          'agentId',
          'agent_id',
          'role',
          'roles',
          'permissions',
          'StasisEngine',
          'MCP',
          'streaming',
        ]) {
          expect(source, isNot(contains(forbidden)), reason: file.path);
        }
      }
    },
  );

  test('presentation widgets stay isolated from transport and messages UI', () {
    final widgetFiles =
        Directory('lib/features/chat_sessions/presentation/widgets')
            .listSync(recursive: true)
            .whereType<File>()
            .where((file) => file.path.endsWith('.dart'))
            .toList(growable: false);

    expect(widgetFiles, isNotEmpty);

    for (final file in widgetFiles) {
      final source = file.readAsStringSync();
      expect(source, contains('ownChatSessionsStateProvider'));
      expect(source, contains('ownChatSessionsControllerProvider'));
      for (final forbidden in [
        'supabase_flutter',
        'Supabase.instance',
        'package:dio/',
        'package:http/',
        '/functions/v1/',
        'create-own-chat-session',
        'list-own-chat-sessions',
        'archive-own-chat-session',
        'service_role',
        'access_token',
        'refresh_token',
        'jwt',
        'JWT',
        'features/chat/',
        'features/chat_messages/',
        'OwnChatMessagesSafeShell',
        'OwnChatMessagesPanel',
        'SupabaseChatDataSource',
        'ChatController',
        'userId',
        'user_id',
        'specialist_id',
        'internalSpecialistId',
        'ownerUserId',
        'agentId',
        'agent_id',
        'role',
        'roles',
        'permissions',
        'StasisEngine',
        'MCP',
        'streaming',
      ]) {
        expect(source, isNot(contains(forbidden)), reason: file.path);
      }
    }
  });

  test('presentation dev host stays isolated and override-driven', () {
    final devFiles = Directory('lib/features/chat_sessions/presentation/dev')
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'))
        .toList(growable: false);

    expect(devFiles, isNotEmpty);

    for (final file in devFiles) {
      final source = file.readAsStringSync();
      expect(source, contains('OwnChatSessionsPanel'));
      expect(source, contains('ProviderScope'));
      expect(source, contains('overrideWith'));
      expect(source, contains('selectableSpecialistId'));
      expect(source, contains('sessionId'));
      for (final forbidden in [
        'supabase_flutter',
        'supabase',
        'Supabase.instance',
        'package:dio/',
        'package:http/',
        'dart:io',
        'dart:html',
        'firebase',
        '/functions/v1/',
        'create-own-chat-session',
        'list-own-chat-sessions',
        'archive-own-chat-session',
        'service_role',
        'access_token',
        'refresh_token',
        'jwt',
        'JWT',
        'go_router',
        'GoRouter',
        'context.go',
        'context.push',
        'Navigator.',
        'features/chat/',
        'features/chat_messages/',
        'OwnChatMessagesSafeShell',
        'OwnChatMessagesPanel',
        'SupabaseChatDataSource',
        'ChatController',
        'userId',
        'user_id',
        'specialistId',
        'specialist_id',
        'internalSpecialistId',
        'ownerUserId',
        'agentId',
        'agent_id',
        'role',
        'roles',
        'permissions',
        'StasisEngine',
        'MCP',
        'streaming',
      ]) {
        expect(source, isNot(contains(forbidden)), reason: file.path);
      }
    }
  });

  test('presentation safe shell stays route-free and messages-free', () {
    final shellFiles =
        Directory('lib/features/chat_sessions/presentation/shell')
            .listSync(recursive: true)
            .whereType<File>()
            .where((file) => file.path.endsWith('.dart'))
            .toList(growable: false);

    expect(shellFiles, isNotEmpty);

    for (final file in shellFiles) {
      final source = file.readAsStringSync();
      if (file.path.endsWith('own_chat_sessions_safe_shell.dart')) {
        expect(source, contains('OwnChatSessionsPanel'));
      }
      for (final forbidden in [
        'supabase_flutter',
        'supabase',
        'Supabase.instance',
        'package:dio/',
        'package:http/',
        'dart:io',
        'dart:html',
        'firebase',
        '/functions/v1/',
        'create-own-chat-session',
        'list-own-chat-sessions',
        'archive-own-chat-session',
        'service_role',
        'access_token',
        'refresh_token',
        'jwt',
        'JWT',
        'go_router',
        'GoRouter',
        'context.go',
        'context.push',
        'Navigator.',
        'features/chat/',
        'features/chat_messages/',
        'OwnChatMessagesSafeShell',
        'OwnChatMessagesPanel',
        'SupabaseChatDataSource',
        'ChatController',
        'userId',
        'user_id',
        'specialistId',
        'specialist_id',
        'internalSpecialistId',
        'ownerUserId',
        'agentId',
        'agent_id',
        'role',
        'roles',
        'permissions',
        'StasisEngine',
        'MCP',
        'streaming',
      ]) {
        expect(source, isNot(contains(forbidden)), reason: file.path);
      }
    }
  });
}

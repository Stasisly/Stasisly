import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:stasisly/features/chat_messages/data/datasources/local_http_own_chat_messages_datasource.dart';
import 'package:stasisly/features/chat_messages/data/local/local_only_host_policy.dart'
    as messages_policy;
import 'package:stasisly/features/chat_messages/data/local/local_session_token_provider.dart'
    as messages_token;
import 'package:stasisly/features/chat_messages/data/local/own_chat_messages_http_transport.dart';
import 'package:stasisly/features/chat_messages/domain/entities/own_chat_message_results.dart';
import 'package:stasisly/features/chat_sessions/data/datasources/local_http_own_chat_sessions_datasource.dart';
import 'package:stasisly/features/chat_sessions/data/local/local_only_host_policy.dart'
    as sessions_policy;
import 'package:stasisly/features/chat_sessions/data/local/local_session_token_provider.dart'
    as sessions_token;
import 'package:stasisly/features/chat_sessions/data/local/own_chat_sessions_http_transport.dart';
import 'package:stasisly/features/chat_sessions/data/repositories/validating_own_chat_sessions_repository.dart';
import 'package:stasisly/features/chat_sessions/domain/entities/own_chat_session.dart';
import 'package:stasisly/features/chat_sessions/domain/entities/own_chat_session_results.dart';

import '../../../../tool/development_remote_execution_contracts.dart';

void main() {
  test(
    'development remote UX source is compatible with retained fixture without writes',
    () async {
      final env = _DevelopmentRemoteEnv.fromProcess();
      final gate = DevelopmentRemoteGateInput.fromEnvironment(
        Platform.environment,
      );
      if (!env.isComplete || !gate.isReady) {
        markTestSkipped(
          'Requires complete development remote read environment.',
        );
        return;
      }

      final fixture = await _loadRemoteReadFixture(env);
      expect(fixture.activeSessions, isEmpty);
      expect(fixture.allSessions, hasLength(1));
      expect(
        fixture.allSessions.where(
          (session) => session.status == ChatSessionStatus.archived,
        ),
        hasLength(1),
      );
      expect(
        fixture.messagesBySession.values.fold<int>(
          0,
          (count, messages) => count + messages.length,
        ),
        1,
      );
      for (final messages in fixture.messagesBySession.values) {
        expect(messages, isNotEmpty);
      }

      final composedSource = File(
        'lib/features/chat_messages/presentation/shell/'
        'own_chat_composed_safe_shell.dart',
      ).readAsStringSync();
      final detailSource = File(
        'lib/features/chat_messages/presentation/shell/'
        'own_chat_messages_safe_shell.dart',
      ).readAsStringSync();
      final routesSource = File(
        'lib/core/config/routes.dart',
      ).readAsStringSync();
      final registrySource = File(
        'lib/core/routing/infrastructure/entry_point_registry.dart',
      ).readAsStringSync();
      final sessionsPanelSource = File(
        'lib/features/chat_sessions/presentation/widgets/'
        'own_chat_sessions_panel.dart',
      ).readAsStringSync();

      expect(composedSource, contains('DEV ONLY'));
      expect(composedSource, contains('REMOTE DEVELOPMENT'));
      expect(composedSource, contains('SYNTHETIC DATA'));
      expect(composedSource, contains('NOT PRODUCT'));
      expect(composedSource, contains('ChatSessionStatusFilter.all'));
      expect(
        composedSource,
        contains('Shell dev-only con sessionId explícito.'),
      );
      expect(
        detailSource,
        contains('Detalle dev-only por sessionId explícito.'),
      );
      expect(registrySource, contains("pathPattern: '/dev/chat/composed'"));
      expect(
        registrySource,
        contains("pathPattern: '/dev/chat/session/:sessionId'"),
      );
      expect(routesSource, contains("context.go('/dev/chat/session/"));
      expect(routesSource, isNot(contains("path: '/conversations'")));
      expect(
        routesSource,
        isNot(contains("path: '/conversations/:sessionId'")),
      );
      expect(
        registrySource,
        isNot(contains("pathPattern: '/dev/chat/session/:id'")),
      );
      expect(
        registrySource,
        isNot(contains("pathPattern: '/dev/chat/session/:agentId'")),
      );
      expect(sessionsPanelSource, contains('active sessions count:'));
      expect(sessionsPanelSource, contains('all sessions count:'));
      expect(sessionsPanelSource, contains('archived sessions count:'));
      expect(sessionsPanelSource, contains('Abrir mensajes dev-only'));
      expect(sessionsPanelSource, contains('session.sessionId'));
      expect(sessionsPanelSource, isNot(contains('agentId')));
    },
  );
}

Future<_RemoteReadFixture> _loadRemoteReadFixture(
  _DevelopmentRemoteEnv env,
) async {
  final baseUri = Uri.parse(env.supabaseUrl);
  final sessionsRepository = ValidatingOwnChatSessionsRepository(
    source: LocalHttpOwnChatSessionsDataSource(
      baseUri: baseUri,
      hostPolicy: sessions_policy.DevelopmentRemoteHostPolicy(
        enabled: true,
        approvedHost: baseUri.host,
      ),
      tokenProvider: _SessionsEnvTokenProvider(env.syntheticAccessToken),
      transport: createDioOwnChatSessionsHttpTransport(),
    ),
  );

  final activeResult = await sessionsRepository.listOwnChatSessions();
  expect(activeResult, isA<ListOwnChatSessionsSuccess>());
  final activeSessions =
      (activeResult as ListOwnChatSessionsSuccess).page.items;

  final allResult = await sessionsRepository.listOwnChatSessions(
    status: ChatSessionStatusFilter.all,
  );
  expect(allResult, isA<ListOwnChatSessionsSuccess>());
  final allSessions = (allResult as ListOwnChatSessionsSuccess).page.items;

  final messagesRepository = LocalHttpOwnChatMessagesDataSource(
    baseUri: baseUri,
    hostPolicy: messages_policy.DevelopmentRemoteHostPolicy(
      enabled: true,
      approvedHost: baseUri.host,
    ),
    tokenProvider: _MessagesEnvTokenProvider(env.syntheticAccessToken),
    transport: createDioOwnChatMessagesHttpTransport(),
  );

  final messagesBySession = <String, List<Object>>{};
  for (final session in allSessions) {
    final messagesResult = await messagesRepository.listSessionMessages(
      sessionId: session.sessionId,
      limit: 20,
    );
    expect(messagesResult, isA<ListSessionMessagesSuccess>());
    final page = (messagesResult as ListSessionMessagesSuccess).page;
    for (final message in page.items) {
      expect(message.isDemo, isFalse);
    }
    messagesBySession[session.sessionId] = List.unmodifiable(page.items);
  }

  return _RemoteReadFixture(
    activeSessions: List.unmodifiable(activeSessions),
    allSessions: List.unmodifiable(allSessions),
    messagesBySession: Map.unmodifiable(messagesBySession),
  );
}

final class _RemoteReadFixture {
  const _RemoteReadFixture({
    required this.activeSessions,
    required this.allSessions,
    required this.messagesBySession,
  });

  final List<OwnChatSession> activeSessions;
  final List<OwnChatSession> allSessions;
  final Map<String, List<Object>> messagesBySession;
}

final class _DevelopmentRemoteEnv {
  const _DevelopmentRemoteEnv({
    required this.appMode,
    required this.enableRemoteBackend,
    required this.enableRealAuth,
    required this.enableRealData,
    required this.allowDevRoutes,
    required this.enableConversationsRoute,
    required this.supabaseUrl,
    required this.syntheticAccessToken,
  });

  factory _DevelopmentRemoteEnv.fromProcess() {
    final env = Platform.environment;
    return _DevelopmentRemoteEnv(
      appMode: env['APP_MODE'] ?? '',
      enableRemoteBackend: env['ENABLE_REMOTE_BACKEND'] ?? '',
      enableRealAuth: env['ENABLE_REAL_AUTH'] ?? '',
      enableRealData: env['ENABLE_REAL_DATA'] ?? '',
      allowDevRoutes: env['ALLOW_DEV_ROUTES'] ?? '',
      enableConversationsRoute: env['ENABLE_CONVERSATIONS_ROUTE'] ?? '',
      supabaseUrl: env['SUPABASE_URL'] ?? '',
      syntheticAccessToken: env['SYNTHETIC_ACCESS_TOKEN'] ?? '',
    );
  }

  final String appMode;
  final String enableRemoteBackend;
  final String enableRealAuth;
  final String enableRealData;
  final String allowDevRoutes;
  final String enableConversationsRoute;
  final String supabaseUrl;
  final String syntheticAccessToken;

  bool get isComplete {
    return appMode == 'development' &&
        enableRemoteBackend == 'true' &&
        enableRealAuth == 'true' &&
        enableRealData == 'false' &&
        allowDevRoutes == 'true' &&
        enableConversationsRoute == 'false' &&
        supabaseUrl.trim().isNotEmpty &&
        syntheticAccessToken.trim().isNotEmpty;
  }
}

final class _SessionsEnvTokenProvider
    implements sessions_token.LocalSessionTokenProvider {
  const _SessionsEnvTokenProvider(this.token);

  final String token;

  @override
  Future<String?> readLocalSessionToken() async => token;
}

final class _MessagesEnvTokenProvider
    implements messages_token.LocalSessionTokenProvider {
  const _MessagesEnvTokenProvider(this.token);

  final String token;

  @override
  Future<String?> readLocalSessionToken() async => token;
}

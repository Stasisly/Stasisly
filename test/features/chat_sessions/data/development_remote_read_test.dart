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
    'development remote read lists own sessions and messages without writes',
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
      final activePage = (activeResult as ListOwnChatSessionsSuccess).page;
      expect(activePage.items, isEmpty);

      final allResult = await sessionsRepository.listOwnChatSessions(
        status: ChatSessionStatusFilter.all,
      );
      expect(allResult, isA<ListOwnChatSessionsSuccess>());
      final allPage = (allResult as ListOwnChatSessionsSuccess).page;
      expect(allPage.items, hasLength(1));
      expect(
        allPage.items.where(
          (session) => session.status == ChatSessionStatus.archived,
        ),
        hasLength(1),
      );

      final messagesRepository = LocalHttpOwnChatMessagesDataSource(
        baseUri: baseUri,
        hostPolicy: messages_policy.DevelopmentRemoteHostPolicy(
          enabled: true,
          approvedHost: baseUri.host,
        ),
        tokenProvider: _MessagesEnvTokenProvider(env.syntheticAccessToken),
        transport: createDioOwnChatMessagesHttpTransport(),
      );

      var totalMessages = 0;
      for (final session in allPage.items) {
        final messagesResult = await messagesRepository.listSessionMessages(
          sessionId: session.sessionId,
          limit: 20,
        );
        expect(messagesResult, isA<ListSessionMessagesSuccess>());
        final messagesPage =
            (messagesResult as ListSessionMessagesSuccess).page;
        for (final message in messagesPage.items) {
          expect(message.isDemo, isFalse);
        }
        totalMessages += messagesPage.items.length;
      }
      expect(totalMessages, 1);
    },
  );
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

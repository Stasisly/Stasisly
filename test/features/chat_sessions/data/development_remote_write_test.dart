import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:stasisly/core/idempotency/operation_attempt_id.dart';
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
import 'package:stasisly/features/specialists/data/datasources/selectable_specialists_remote_datasource.dart';
import 'package:stasisly/features/specialists/data/repositories/selectable_specialists_repository_impl.dart';
import 'package:stasisly/features/specialists/domain/entities/selectable_specialist.dart';
import 'package:stasisly/features/specialists/domain/entities/selectable_specialists_result.dart';

void main() {
  test(
    'development remote write creates sends lists and archives synthetic session',
    () async {
      final env = _DevelopmentRemoteEnv.fromProcess();
      if (!env.isComplete) {
        markTestSkipped(
          'Requires complete development remote write environment.',
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
      final messagesRepository = LocalHttpOwnChatMessagesDataSource(
        baseUri: baseUri,
        hostPolicy: messages_policy.DevelopmentRemoteHostPolicy(
          enabled: true,
          approvedHost: baseUri.host,
        ),
        tokenProvider: _MessagesEnvTokenProvider(env.syntheticAccessToken),
        transport: createDioOwnChatMessagesHttpTransport(),
      );
      final specialistsRepository = SelectableSpecialistsRepositoryImpl(
        dataSource: _DevelopmentSelectableSpecialistsDataSource(
          baseUri: baseUri,
          token: env.syntheticAccessToken,
        ),
      );

      final specialistsResult = await specialistsRepository
          .listSelectableSpecialists(
            areaFilter: SelectableSpecialistArea.stasis,
          );
      expect(specialistsResult, isA<SelectableSpecialistsSuccess>());
      final specialists =
          (specialistsResult as SelectableSpecialistsSuccess).specialists;
      expect(specialists, isNotEmpty);
      final syntheticSpecialist = specialists.firstWhere(
        (specialist) =>
            specialist.displayName == 'Synthetic Development Specialist',
      );
      expect(syntheticSpecialist.isDemo, isFalse);
      expect(
        syntheticSpecialist.accessState,
        SelectableSpecialistAccessState.available,
      );

      final initialActive = await sessionsRepository.listOwnChatSessions();
      expect(initialActive, isA<ListOwnChatSessionsSuccess>());
      expect((initialActive as ListOwnChatSessionsSuccess).page.items, isEmpty);

      final initialAll = await sessionsRepository.listOwnChatSessions(
        status: ChatSessionStatusFilter.all,
      );
      expect(initialAll, isA<ListOwnChatSessionsSuccess>());
      expect(
        (initialAll as ListOwnChatSessionsSuccess).page.items,
        hasLength(1),
      );

      final createResult = await sessionsRepository.createOwnChatSession(
        selectableSpecialistId: syntheticSpecialist.id,
        operationAttemptId: OperationAttemptId('development_create_0001'),
      );
      expect(createResult, isA<CreateOwnChatSessionSuccess>());
      final createdSession =
          (createResult as CreateOwnChatSessionSuccess).session;
      expect(createdSession.status, ChatSessionStatus.active);
      expect(createdSession.messageCount, 0);

      final sendResult = await messagesRepository.sendUserMessage(
        sessionId: createdSession.sessionId,
        content: 'synthetic-development-message-ag57',
        operationAttemptId: OperationAttemptId('development_send_000001'),
      );
      expect(sendResult, isA<SendUserMessageSuccess>());
      final sent = (sendResult as SendUserMessageSuccess).sent;
      expect(sent.isDemo, isFalse);
      expect(sent.sessionId, createdSession.sessionId);
      expect(sent.message.content, 'synthetic-development-message-ag57');

      final messagesResult = await messagesRepository.listSessionMessages(
        sessionId: createdSession.sessionId,
      );
      expect(messagesResult, isA<ListSessionMessagesSuccess>());
      final messagesPage = (messagesResult as ListSessionMessagesSuccess).page;
      expect(messagesPage.items, hasLength(1));
      expect(
        messagesPage.items.single.content,
        'synthetic-development-message-ag57',
      );
      expect(messagesPage.items.single.isDemo, isFalse);

      final archiveResult = await sessionsRepository.archiveOwnChatSession(
        sessionId: createdSession.sessionId,
      );
      expect(archiveResult, isA<ArchiveOwnChatSessionSuccess>());
      expect(
        (archiveResult as ArchiveOwnChatSessionSuccess).session.status,
        ChatSessionStatus.archived,
      );

      final finalActive = await sessionsRepository.listOwnChatSessions();
      expect(finalActive, isA<ListOwnChatSessionsSuccess>());
      expect((finalActive as ListOwnChatSessionsSuccess).page.items, isEmpty);

      final finalAll = await sessionsRepository.listOwnChatSessions(
        status: ChatSessionStatusFilter.all,
      );
      expect(finalAll, isA<ListOwnChatSessionsSuccess>());
      final finalAllItems = (finalAll as ListOwnChatSessionsSuccess).page.items;
      expect(finalAllItems, hasLength(2));
      expect(
        finalAllItems.where(
          (session) => session.status == ChatSessionStatus.archived,
        ),
        hasLength(2),
      );
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

final class _DevelopmentSelectableSpecialistsDataSource
    implements SelectableSpecialistsRemoteDataSource {
  const _DevelopmentSelectableSpecialistsDataSource({
    required this.baseUri,
    required this.token,
  });

  final Uri baseUri;
  final String token;

  @override
  Future<SelectableSpecialistsRemoteResponse> listSelectableSpecialists({
    SelectableSpecialistArea? areaFilter,
  }) async {
    final client = HttpClient()
      ..connectionTimeout = const Duration(seconds: 10);
    try {
      final uri = baseUri
          .resolve('/functions/v1/list-selectable-specialists')
          .replace(
            queryParameters: {if (areaFilter != null) 'area': areaFilter.name},
          );
      final request = await client.getUrl(uri);
      request.headers
        ..set(HttpHeaders.acceptHeader, 'application/json')
        ..set(HttpHeaders.authorizationHeader, 'Bearer $token');
      final response = await request.close();
      final raw = await response.transform(utf8.decoder).join();
      final decoded = raw.trim().isEmpty ? null : jsonDecode(raw);
      return SelectableSpecialistsRemoteResponse(
        statusCode: response.statusCode,
        body: _stringKeyedMap(decoded),
        errorCode: _errorCode(decoded),
      );
    } finally {
      client.close(force: true);
    }
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

Map<String, dynamic>? _stringKeyedMap(Object? value) {
  if (value is! Map) return null;
  if (value.keys.any((key) => key is! String)) return null;
  return Map<String, dynamic>.from(value);
}

String? _errorCode(Object? value) {
  final body = _stringKeyedMap(value);
  if (body == null || body.keys.length != 1 || body['error'] is! Map) {
    return null;
  }
  final error = _stringKeyedMap(body['error']);
  if (error == null ||
      error.keys.length != 2 ||
      error['code'] is! String ||
      error['requestId'] is! String) {
    return null;
  }
  return error['code'] as String;
}

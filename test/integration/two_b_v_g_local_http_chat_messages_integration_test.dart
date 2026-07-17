import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:stasisly/features/chat_messages/data/datasources/local_http_own_chat_messages_datasource.dart';
import 'package:stasisly/features/chat_messages/data/local/local_only_host_policy.dart';
import 'package:stasisly/features/chat_messages/data/local/local_session_token_provider.dart';
import 'package:stasisly/features/chat_messages/data/local/own_chat_messages_http_transport.dart';
import 'package:stasisly/features/chat_messages/domain/entities/own_chat_message.dart';
import 'package:stasisly/features/chat_messages/domain/entities/own_chat_message_results.dart';

void main() {
  const hasIntegrationEnvironment =
      bool.hasEnvironment('STASISLY_2B_V_G_API_URL') &&
      bool.hasEnvironment('STASISLY_2B_V_G_ACCESS_TOKEN') &&
      bool.hasEnvironment('STASISLY_2B_V_G_OWNER_ACTIVE_SESSION_ID') &&
      bool.hasEnvironment('STASISLY_2B_V_G_OWNER_ARCHIVED_SESSION_ID') &&
      bool.hasEnvironment('STASISLY_2B_V_G_OTHER_SESSION_ID') &&
      bool.hasEnvironment('STASISLY_2B_V_G_MISSING_SESSION_ID') &&
      bool.hasEnvironment('STASISLY_2B_V_G_INITIAL_MESSAGE_COUNT') &&
      bool.hasEnvironment('STASISLY_2B_V_G_INITIAL_LAST_MESSAGE_AT');

  if (!hasIntegrationEnvironment) {
    test(
      '2B-V-G local integration requires the approved local harness',
      () {},
      skip: 'Run supabase/tests/2b_v_g_messages_http_integration_test.sh',
    );
    return;
  }

  late LocalHttpOwnChatMessagesDataSource datasource;

  setUpAll(() {
    datasource = LocalHttpOwnChatMessagesDataSource(
      baseUri: Uri.parse(_requiredEnv('STASISLY_2B_V_G_API_URL')),
      hostPolicy: const LocalOnlyHostPolicy(localValidationEnabled: true),
      tokenProvider: const _TestLocalSessionTokenProvider(),
      transport: _DioOwnChatMessagesHttpTransport(dio: Dio()),
    );
  });

  test('send and list messages against local Edge Functions', () async {
    final ownerActiveSessionId = _requiredEnv(
      'STASISLY_2B_V_G_OWNER_ACTIVE_SESSION_ID',
    );
    final ownerArchivedSessionId = _requiredEnv(
      'STASISLY_2B_V_G_OWNER_ARCHIVED_SESSION_ID',
    );
    final otherSessionId = _requiredEnv('STASISLY_2B_V_G_OTHER_SESSION_ID');
    final missingSessionId = _requiredEnv('STASISLY_2B_V_G_MISSING_SESSION_ID');
    final initialMessageCount = int.parse(
      _requiredEnv('STASISLY_2B_V_G_INITIAL_MESSAGE_COUNT'),
    );
    final initialLastMessageAt = DateTime.parse(
      _requiredEnv('STASISLY_2B_V_G_INITIAL_LAST_MESSAGE_AT'),
    );

    final sent = await datasource.sendUserMessage(
      sessionId: ownerActiveSessionId,
      content: '  mensaje de prueba  ',
    );
    expect(sent, isA<SendUserMessageSuccess>());
    final sentMessage = (sent as SendUserMessageSuccess).sent;
    expect(sentMessage.sessionId, ownerActiveSessionId);
    expect(sentMessage.message.sessionId, ownerActiveSessionId);
    expect(sentMessage.message.role, OwnChatMessageRole.user);
    expect(sentMessage.message.content, 'mensaje de prueba');
    expect(sentMessage.message.authorType, OwnChatMessageAuthorType.user);
    expect(
      sentMessage.message.provenance,
      OwnChatMessageProvenance.userProvided,
    );
    expect(
      sentMessage.message.visibility,
      OwnChatMessageVisibility.productVisible,
    );
    expect(sentMessage.message.status, OwnChatMessageStatus.accepted);
    expect(sentMessage.message.isDemo, isFalse);
    expect(sentMessage.isDemo, isFalse);
    expect(sentMessage.messageCount, initialMessageCount + 1);
    expect(sentMessage.lastMessageAt.isAfter(initialLastMessageAt), isTrue);

    final listed = await datasource.listSessionMessages(
      sessionId: ownerActiveSessionId,
      limit: 20,
    );
    expect(listed, isA<ListSessionMessagesSuccess>());
    final page = (listed as ListSessionMessagesSuccess).page;
    expect(page.nextCursor, isNull);
    final listedSentMessage = page.items.singleWhere(
      (message) => message.messageId == sentMessage.message.messageId,
    );
    expect(listedSentMessage.role, OwnChatMessageRole.user);
    expect(listedSentMessage.content, 'mensaje de prueba');
    expect(listedSentMessage.authorType, OwnChatMessageAuthorType.user);
    expect(
      page.items.any((message) => message.content == 'active assistant'),
      isFalse,
    );
    expect(
      page.items.any((message) => message.content == 'active tool'),
      isFalse,
    );
    expect(listedSentMessage.isDemo, isFalse);

    final archived = await datasource.listSessionMessages(
      sessionId: ownerArchivedSessionId,
      limit: 20,
    );
    expect(archived, isA<ListSessionMessagesSuccess>());
    expect((archived as ListSessionMessagesSuccess).page.items, isNotEmpty);

    final archivedSend = await datasource.sendUserMessage(
      sessionId: ownerArchivedSessionId,
      content: 'no debe escribirse',
    );
    expect(
      archivedSend,
      const SendUserMessageFailure(
        SendOwnChatMessageFailureType.sessionArchived,
      ),
    );

    final otherList = await datasource.listSessionMessages(
      sessionId: otherSessionId,
      limit: 20,
    );
    expect(
      otherList,
      const ListSessionMessagesFailure(
        ListOwnChatMessagesFailureType.sessionNotFound,
      ),
    );

    final otherSend = await datasource.sendUserMessage(
      sessionId: otherSessionId,
      content: 'opaco',
    );
    expect(
      otherSend,
      const SendUserMessageFailure(
        SendOwnChatMessageFailureType.sessionNotFound,
      ),
    );

    final missingList = await datasource.listSessionMessages(
      sessionId: missingSessionId,
      limit: 20,
    );
    expect(
      missingList,
      const ListSessionMessagesFailure(
        ListOwnChatMessagesFailureType.sessionNotFound,
      ),
    );
  });

  test('pagination is stable and rejects invalid cursor', () async {
    final ownerActiveSessionId = _requiredEnv(
      'STASISLY_2B_V_G_OWNER_ACTIVE_SESSION_ID',
    );

    final firstPage = await datasource.listSessionMessages(
      sessionId: ownerActiveSessionId,
      limit: 2,
    );
    expect(firstPage, isA<ListSessionMessagesSuccess>());
    final first = (firstPage as ListSessionMessagesSuccess).page;
    expect(first.items, hasLength(2));
    expect(first.nextCursor, isNotNull);

    final secondPage = await datasource.listSessionMessages(
      sessionId: ownerActiveSessionId,
      limit: 2,
      cursor: first.nextCursor,
    );
    expect(secondPage, isA<ListSessionMessagesSuccess>());
    final second = (secondPage as ListSessionMessagesSuccess).page;

    final ids = [
      ...first.items,
      ...second.items,
    ].map((message) => message.messageId).toList();
    expect(ids.toSet(), hasLength(ids.length));
    expect(_isChronologicallySorted([...first.items, ...second.items]), isTrue);

    var cursor = second.nextCursor;
    final allIds = ids.toSet();
    while (cursor != null) {
      final pageResult = await datasource.listSessionMessages(
        sessionId: ownerActiveSessionId,
        limit: 2,
        cursor: cursor,
      );
      expect(pageResult, isA<ListSessionMessagesSuccess>());
      final page = (pageResult as ListSessionMessagesSuccess).page;
      for (final message in page.items) {
        expect(allIds.add(message.messageId), isTrue);
      }
      cursor = page.nextCursor;
    }
    expect(cursor, isNull);

    final invalidCursor = await datasource.listSessionMessages(
      sessionId: ownerActiveSessionId,
      cursor: 'not-a-valid-cursor',
    );
    expect(
      invalidCursor,
      const ListSessionMessagesFailure(
        ListOwnChatMessagesFailureType.invalidCursor,
      ),
    );
  });

  test('missing token and remote host fail before HTTP transport', () async {
    final ownerActiveSessionId = _requiredEnv(
      'STASISLY_2B_V_G_OWNER_ACTIVE_SESSION_ID',
    );

    final missingToken = LocalHttpOwnChatMessagesDataSource(
      baseUri: Uri.parse(_requiredEnv('STASISLY_2B_V_G_API_URL')),
      hostPolicy: const LocalOnlyHostPolicy(localValidationEnabled: true),
      tokenProvider: const _StaticTokenProvider(null),
      transport: _FailingTransport(),
    );
    expect(
      await missingToken.listSessionMessages(sessionId: ownerActiveSessionId),
      const ListSessionMessagesFailure(
        ListOwnChatMessagesFailureType.unauthenticated,
      ),
    );

    final remote = LocalHttpOwnChatMessagesDataSource(
      baseUri: Uri.parse('https://project.supabase.co'),
      hostPolicy: const LocalOnlyHostPolicy(localValidationEnabled: true),
      tokenProvider: const _TestLocalSessionTokenProvider(),
      transport: _FailingTransport(),
    );
    expect(
      await remote.sendUserMessage(
        sessionId: ownerActiveSessionId,
        content: 'blocked',
      ),
      const SendUserMessageFailure(
        SendOwnChatMessageFailureType.backendBlocked,
      ),
    );
  });
}

bool _isChronologicallySorted(List<OwnChatMessage> messages) {
  for (var i = 1; i < messages.length; i += 1) {
    final previous = messages[i - 1];
    final current = messages[i];
    final byCreatedAt = previous.createdAt.compareTo(current.createdAt);
    if (byCreatedAt > 0) return false;
    if (byCreatedAt == 0 &&
        previous.messageId.compareTo(current.messageId) > 0) {
      return false;
    }
  }
  return true;
}

String _requiredEnv(String key) {
  final value = switch (key) {
    'STASISLY_2B_V_G_API_URL' => const String.fromEnvironment(
      'STASISLY_2B_V_G_API_URL',
    ),
    'STASISLY_2B_V_G_ACCESS_TOKEN' => const String.fromEnvironment(
      'STASISLY_2B_V_G_ACCESS_TOKEN',
    ),
    'STASISLY_2B_V_G_OWNER_ACTIVE_SESSION_ID' => const String.fromEnvironment(
      'STASISLY_2B_V_G_OWNER_ACTIVE_SESSION_ID',
    ),
    'STASISLY_2B_V_G_OWNER_ARCHIVED_SESSION_ID' => const String.fromEnvironment(
      'STASISLY_2B_V_G_OWNER_ARCHIVED_SESSION_ID',
    ),
    'STASISLY_2B_V_G_OTHER_SESSION_ID' => const String.fromEnvironment(
      'STASISLY_2B_V_G_OTHER_SESSION_ID',
    ),
    'STASISLY_2B_V_G_MISSING_SESSION_ID' => const String.fromEnvironment(
      'STASISLY_2B_V_G_MISSING_SESSION_ID',
    ),
    'STASISLY_2B_V_G_INITIAL_MESSAGE_COUNT' => const String.fromEnvironment(
      'STASISLY_2B_V_G_INITIAL_MESSAGE_COUNT',
    ),
    'STASISLY_2B_V_G_INITIAL_LAST_MESSAGE_AT' => const String.fromEnvironment(
      'STASISLY_2B_V_G_INITIAL_LAST_MESSAGE_AT',
    ),
    _ => '',
  };
  if (value.isEmpty) {
    throw StateError('$key is required for 2B-V-G local integration.');
  }
  return value;
}

class _TestLocalSessionTokenProvider implements LocalSessionTokenProvider {
  const _TestLocalSessionTokenProvider();

  @override
  Future<String?> readLocalSessionToken() async {
    return _requiredEnv('STASISLY_2B_V_G_ACCESS_TOKEN');
  }
}

class _StaticTokenProvider implements LocalSessionTokenProvider {
  const _StaticTokenProvider(this.token);

  final String? token;

  @override
  Future<String?> readLocalSessionToken() async => token;
}

class _DioOwnChatMessagesHttpTransport implements OwnChatMessagesHttpTransport {
  _DioOwnChatMessagesHttpTransport({required Dio dio}) : _dio = dio {
    _dio.options.followRedirects = false;
    _dio.options.validateStatus = (_) => true;
  }

  final Dio _dio;

  @override
  Future<OwnChatMessagesHttpResponse> send(
    OwnChatMessagesHttpRequest request,
  ) async {
    try {
      final response = await _dio.request<Object?>(
        request.uri.toString(),
        data: request.body,
        options: Options(
          method: switch (request.method) {
            OwnChatMessagesHttpMethod.get => 'GET',
            OwnChatMessagesHttpMethod.post => 'POST',
          },
          headers: request.headers,
          followRedirects: false,
          validateStatus: (_) => true,
        ),
      );
      return OwnChatMessagesHttpResponse(
        statusCode: response.statusCode ?? 0,
        body: response.data,
      );
    } on DioException {
      throw const OwnChatMessagesTransportException();
    }
  }
}

class _FailingTransport implements OwnChatMessagesHttpTransport {
  @override
  Future<OwnChatMessagesHttpResponse> send(OwnChatMessagesHttpRequest request) {
    throw StateError('Transport must not be called.');
  }
}

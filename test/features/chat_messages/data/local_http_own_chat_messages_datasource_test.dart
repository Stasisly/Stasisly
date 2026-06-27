import 'package:flutter_test/flutter_test.dart';
import 'package:stasisly/features/chat_messages/data/datasources/local_http_own_chat_messages_datasource.dart';
import 'package:stasisly/features/chat_messages/data/local/local_only_host_policy.dart';
import 'package:stasisly/features/chat_messages/data/local/local_session_token_provider.dart';
import 'package:stasisly/features/chat_messages/data/local/own_chat_messages_http_transport.dart';
import 'package:stasisly/features/chat_messages/domain/entities/own_chat_message_results.dart';

void main() {
  group('fail closed before token or transport', () {
    test('blocked host never reads token or executes transport', () async {
      final tokenProvider = _FakeTokenProvider('local-token');
      final transport = _FakeTransport();
      final source = _source(
        baseUri: Uri.parse('https://project.supabase.co'),
        tokenProvider: tokenProvider,
        transport: transport,
      );

      final result = await source.sendUserMessage(
        sessionId: 'session-1',
        content: 'hola',
      );

      expect(
        result,
        const SendUserMessageFailure(
          SendOwnChatMessageFailureType.backendBlocked,
        ),
      );
      expect(tokenProvider.calls, 0);
      expect(transport.requests, isEmpty);
    });

    test('disabled local composition never reads token or transport', () async {
      final tokenProvider = _FakeTokenProvider('local-token');
      final transport = _FakeTransport();

      final result = await _source(
        policy: const LocalOnlyHostPolicy(localValidationEnabled: false),
        tokenProvider: tokenProvider,
        transport: transport,
      ).listSessionMessages(sessionId: 'session-1');

      expect(
        result,
        const ListSessionMessagesFailure(
          ListOwnChatMessagesFailureType.backendBlocked,
        ),
      );
      expect(tokenProvider.calls, 0);
      expect(transport.requests, isEmpty);
    });

    test('missing or empty token never executes transport', () async {
      for (final token in <String?>[null, '']) {
        final transport = _FakeTransport();
        final result = await _source(
          tokenProvider: _FakeTokenProvider(token),
          transport: transport,
        ).sendUserMessage(sessionId: 'session-1', content: 'hola');

        expect(
          result,
          const SendUserMessageFailure(
            SendOwnChatMessageFailureType.unauthenticated,
          ),
        );
        expect(transport.requests, isEmpty);
      }
    });
  });

  group('exact local requests', () {
    test('send posts only sessionId and content', () async {
      final transport = _FakeTransport(response: _sendSuccess());

      await _source(
        transport: transport,
      ).sendUserMessage(sessionId: 'session-1', content: '  hola  ');

      final request = transport.requests.single;
      expect(request.method, OwnChatMessagesHttpMethod.post);
      expect(request.uri.path, '/functions/v1/send-user-message');
      expect(request.body, {'sessionId': 'session-1', 'content': 'hola'});
      expect(request.headers.keys, {'Accept', 'Authorization', 'Content-Type'});
      expect(request.headers['Authorization'], 'Bearer local-token');
      for (final forbidden in [
        'role',
        'userId',
        'specialistId',
        'createdAt',
        'messageCount',
        'lastMessageAt',
        'attachments',
        'metadata',
      ]) {
        expect(request.body, isNot(containsPair(forbidden, anything)));
      }
    });

    test('list gets only sessionId, limit and cursor', () async {
      final transport = _FakeTransport(response: _listSuccess());

      await _source(transport: transport).listSessionMessages(
        sessionId: 'session-1',
        limit: 7,
        cursor: 'opaque-cursor',
      );

      final request = transport.requests.single;
      expect(request.method, OwnChatMessagesHttpMethod.get);
      expect(request.uri.path, '/functions/v1/list-session-messages');
      expect(request.uri.queryParameters, {
        'sessionId': 'session-1',
        'limit': '7',
        'cursor': 'opaque-cursor',
      });
      expect(request.body, isNull);
      for (final forbidden in ['userId', 'specialistId', 'role', 'owner']) {
        expect(request.uri.queryParameters, isNot(contains(forbidden)));
      }
    });
  });

  group('untrusted responses', () {
    test('valid send and list success payloads are accepted', () async {
      final send = await _source(
        transport: _FakeTransport(response: _sendSuccess()),
      ).sendUserMessage(sessionId: 'session-1', content: 'hola');
      final list = await _source(
        transport: _FakeTransport(response: _listSuccess()),
      ).listSessionMessages(sessionId: 'session-1');

      expect(send, isA<SendUserMessageSuccess>());
      expect(list, isA<ListSessionMessagesSuccess>());
    });

    test('empty list payload maps to empty result', () async {
      final result = await _source(
        transport: _FakeTransport(
          response: const OwnChatMessagesHttpResponse(
            statusCode: 200,
            body: {'items': <Object?>[], 'nextCursor': null},
          ),
        ),
      ).listSessionMessages(sessionId: 'session-1');

      expect(result, const ListSessionMessagesEmpty());
    });

    test(
      'internal, partial, invalid role and invalid cursor are rejected',
      () async {
        for (final body in [
          _listBodyWithItem({'user_id': 'blocked'}),
          _listBodyWithItem({'specialist_id': 'blocked'}),
          _listBodyWithItem({'attachments': <Object?>[]}),
          _listBodyWithItem({'metadata': <String, Object?>{}}),
          _listBodyWithItem({'extra': true}),
          _listBodyWithItem({'role': 'chief_intervention'}),
          _listBodyWithItem({'createdAt': 'bad-date'}),
          {
            'items': [_message()..remove('content')],
            'nextCursor': null,
          },
          {
            'items': [_message()],
            'nextCursor': 7,
          },
        ]) {
          final result = await _source(
            transport: _FakeTransport(
              response: OwnChatMessagesHttpResponse(
                statusCode: 200,
                body: body,
              ),
            ),
          ).listSessionMessages(sessionId: 'session-1');

          expect(
            result,
            const ListSessionMessagesFailure(
              ListOwnChatMessagesFailureType.contractViolation,
            ),
            reason: '$body',
          );
        }
      },
    );
  });

  group('error mapping and no demo fallback', () {
    test('send errors are mapped without demo fallback', () async {
      final cases = {
        'contentInvalid': SendOwnChatMessageFailureType.contentInvalid,
        'contentTooLong': SendOwnChatMessageFailureType.contentTooLong,
        'sessionNotFound': SendOwnChatMessageFailureType.sessionNotFound,
        'sessionArchived': SendOwnChatMessageFailureType.sessionArchived,
        'writeUnconfirmed': SendOwnChatMessageFailureType.writeUnconfirmed,
        'permissionDenied': SendOwnChatMessageFailureType.permissionDenied,
        'contractViolation': SendOwnChatMessageFailureType.contractViolation,
        'backendMisconfigured':
            SendOwnChatMessageFailureType.backendMisconfigured,
      };
      for (final entry in cases.entries) {
        final result = await _source(
          transport: _FakeTransport(
            response: OwnChatMessagesHttpResponse(
              statusCode: _statusFor(entry.key),
              body: _error(entry.key),
            ),
          ),
        ).sendUserMessage(sessionId: 'session-1', content: 'hola');

        expect(result, SendUserMessageFailure(entry.value));
        expect(result, isNot(isA<SendUserMessageDemo>()));
      }
    });

    test('list errors are mapped without demo fallback', () async {
      final cases = {
        'invalidCursor': ListOwnChatMessagesFailureType.invalidCursor,
        'sessionNotFound': ListOwnChatMessagesFailureType.sessionNotFound,
        'permissionDenied': ListOwnChatMessagesFailureType.permissionDenied,
        'contractViolation': ListOwnChatMessagesFailureType.contractViolation,
        'backendMisconfigured':
            ListOwnChatMessagesFailureType.backendMisconfigured,
      };
      for (final entry in cases.entries) {
        final result = await _source(
          transport: _FakeTransport(
            response: OwnChatMessagesHttpResponse(
              statusCode: _statusFor(entry.key),
              body: _error(entry.key),
            ),
          ),
        ).listSessionMessages(sessionId: 'session-1');

        expect(result, ListSessionMessagesFailure(entry.value));
        expect(result, isNot(isA<ListSessionMessagesDemo>()));
      }
    });

    test('transport exception maps to networkError without demo', () async {
      final result = await _source(
        transport: _FakeTransport(throwsTransport: true),
      ).sendUserMessage(sessionId: 'session-1', content: 'hola');

      expect(
        result,
        const SendUserMessageFailure(
          SendOwnChatMessageFailureType.networkError,
        ),
      );
      expect(result, isNot(isA<SendUserMessageDemo>()));
    });

    test('redirect response is blocked', () async {
      final result = await _source(
        transport: _FakeTransport(
          response: const OwnChatMessagesHttpResponse(
            statusCode: 302,
            body: null,
          ),
        ),
      ).listSessionMessages(sessionId: 'session-1');

      expect(
        result,
        const ListSessionMessagesFailure(
          ListOwnChatMessagesFailureType.backendBlocked,
        ),
      );
    });
  });
}

LocalHttpOwnChatMessagesDataSource _source({
  Uri? baseUri,
  LocalOnlyHostPolicy policy = const LocalOnlyHostPolicy(
    localValidationEnabled: true,
  ),
  _FakeTokenProvider? tokenProvider,
  _FakeTransport? transport,
}) {
  return LocalHttpOwnChatMessagesDataSource(
    baseUri: baseUri ?? Uri.parse('http://127.0.0.1:54321'),
    hostPolicy: policy,
    tokenProvider: tokenProvider ?? _FakeTokenProvider('local-token'),
    transport: transport ?? _FakeTransport(response: _listSuccess()),
  );
}

class _FakeTokenProvider implements LocalSessionTokenProvider {
  _FakeTokenProvider(this.token);

  final String? token;
  int calls = 0;

  @override
  Future<String?> readLocalSessionToken() async {
    calls++;
    return token;
  }
}

class _FakeTransport implements OwnChatMessagesHttpTransport {
  _FakeTransport({
    this.response = const OwnChatMessagesHttpResponse(
      statusCode: 200,
      body: <String, Object?>{'items': <Object?>[], 'nextCursor': null},
    ),
    this.throwsTransport = false,
  });

  final OwnChatMessagesHttpResponse response;
  final bool throwsTransport;
  final List<OwnChatMessagesHttpRequest> requests = [];

  @override
  Future<OwnChatMessagesHttpResponse> send(
    OwnChatMessagesHttpRequest request,
  ) async {
    requests.add(request);
    if (throwsTransport) throw const OwnChatMessagesTransportException();
    return response;
  }
}

OwnChatMessagesHttpResponse _sendSuccess() {
  return OwnChatMessagesHttpResponse(
    statusCode: 200,
    body: {
      'message': _message(),
      'session': {
        'sessionId': 'session-1',
        'messageCount': 1,
        'lastMessageAt': '2026-06-21T10:00:00Z',
      },
    },
  );
}

OwnChatMessagesHttpResponse _listSuccess() {
  return OwnChatMessagesHttpResponse(
    statusCode: 200,
    body: {
      'items': [_message()],
      'nextCursor': 'next',
    },
  );
}

Map<String, Object?> _message() {
  return {
    'messageId': 'message-1',
    'sessionId': 'session-1',
    'role': 'user',
    'content': 'hola',
    'createdAt': '2026-06-21T10:00:00Z',
  };
}

Map<String, Object?> _listBodyWithItem(Map<String, Object?> override) {
  return {
    'items': [_message()..addAll(override)],
    'nextCursor': null,
  };
}

Map<String, Object?> _error(String code) {
  return {
    'error': {'code': code, 'requestId': 'request-1'},
  };
}

int _statusFor(String code) {
  return switch (code) {
    'contentInvalid' || 'contentTooLong' || 'invalidCursor' => 400,
    'permissionDenied' => 403,
    'sessionNotFound' => 404,
    'sessionArchived' || 'writeUnconfirmed' => 409,
    'contractViolation' => 502,
    'backendMisconfigured' => 503,
    _ => 500,
  };
}

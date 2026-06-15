import 'package:flutter_test/flutter_test.dart';

import 'package:stasisly/features/chat_sessions/data/datasources/local_http_own_chat_sessions_datasource.dart';
import 'package:stasisly/features/chat_sessions/data/local/local_only_host_policy.dart';
import 'package:stasisly/features/chat_sessions/data/local/local_session_token_provider.dart';
import 'package:stasisly/features/chat_sessions/data/local/own_chat_sessions_http_transport.dart';
import 'package:stasisly/features/chat_sessions/domain/entities/own_chat_session.dart';

void main() {
  group('fail closed before transport', () {
    test(
      'blocked remote host never reads token or executes transport',
      () async {
        final tokenProvider = _FakeTokenProvider('local-jwt');
        final transport = _FakeTransport();
        final source = _source(
          baseUri: Uri.parse('https://project.supabase.co'),
          tokenProvider: tokenProvider,
          transport: transport,
        );

        final response = await source.createOwnChatSession(
          selectableSpecialistId: 'catalog-public',
        );

        expect(response.errorCode, 'backendBlocked');
        expect(tokenProvider.calls, 0);
        expect(transport.requests, isEmpty);
      },
    );

    test('disabled local composition never executes transport', () async {
      final transport = _FakeTransport();
      final source = _source(
        policy: const LocalOnlyHostPolicy(localValidationEnabled: false),
        transport: transport,
      );

      final response = await source.listOwnChatSessions(
        status: ChatSessionStatusFilter.active,
        limit: 20,
      );

      expect(response.errorCode, 'backendBlocked');
      expect(transport.requests, isEmpty);
    });

    test('missing or empty token never executes transport', () async {
      for (final token in <String?>[null, '']) {
        final transport = _FakeTransport();
        final response = await _source(
          tokenProvider: _FakeTokenProvider(token),
          transport: transport,
        ).archiveOwnChatSession(sessionId: 'session-public');

        expect(
          response.errorCode,
          token == null ? 'unauthenticated' : 'invalidSession',
        );
        expect(transport.requests, isEmpty);
      }
    });
  });

  group('exact local requests', () {
    test(
      'create sends only selectable catalog id and approved headers',
      () async {
        final transport = _FakeTransport();

        await _source(
          transport: transport,
        ).createOwnChatSession(selectableSpecialistId: 'catalog-public');

        final request = transport.requests.single;
        expect(request.method, OwnChatSessionsHttpMethod.post);
        expect(request.uri.path, '/functions/v1/create-own-chat-session');
        expect(request.body, {'selectableSpecialistId': 'catalog-public'});
        expect(request.headers.keys, {
          'Accept',
          'Authorization',
          'Content-Type',
        });
        expect(request.headers['Authorization'], 'Bearer local-jwt');
      },
    );

    test('list sends only status, limit and opaque cursor', () async {
      final transport = _FakeTransport();

      await _source(transport: transport).listOwnChatSessions(
        status: ChatSessionStatusFilter.archived,
        limit: 7,
        cursor: 'opaque+/= value',
      );

      final request = transport.requests.single;
      expect(request.method, OwnChatSessionsHttpMethod.get);
      expect(request.uri.path, '/functions/v1/list-own-chat-sessions');
      expect(request.uri.queryParameters, {
        'status': 'archived',
        'limit': '7',
        'cursor': 'opaque+/= value',
      });
      expect(request.body, isNull);
    });

    test('archive sends only session id', () async {
      final transport = _FakeTransport();

      await _source(
        transport: transport,
      ).archiveOwnChatSession(sessionId: 'session-public');

      final request = transport.requests.single;
      expect(request.method, OwnChatSessionsHttpMethod.post);
      expect(request.uri.path, '/functions/v1/archive-own-chat-session');
      expect(request.body, {'sessionId': 'session-public'});
    });
  });

  group('untrusted responses', () {
    test('extracts only the exact backend error envelope', () async {
      final response = await _source(
        transport: _FakeTransport(
          response: const OwnChatSessionsHttpResponse(
            statusCode: 404,
            body: {
              'error': {
                'code': 'sessionNotFound',
                'requestId': 'local-request',
              },
            },
          ),
        ),
      ).archiveOwnChatSession(sessionId: 'session-public');

      expect(response.statusCode, 404);
      expect(response.errorCode, 'sessionNotFound');
    });

    test('invalid error shape cannot become a typed backend claim', () async {
      final response = await _source(
        transport: _FakeTransport(
          response: const OwnChatSessionsHttpResponse(
            statusCode: 502,
            body: {
              'error': {'code': 'contractViolation', 'extra': true},
            },
          ),
        ),
      ).listOwnChatSessions(status: ChatSessionStatusFilter.active, limit: 20);

      expect(response.errorCode, isNull);
    });

    test(
      'redirect response fails closed and is never returned as success',
      () async {
        final response = await _source(
          transport: _FakeTransport(
            response: const OwnChatSessionsHttpResponse(
              statusCode: 302,
              body: null,
            ),
          ),
        ).createOwnChatSession(selectableSpecialistId: 'catalog-public');

        expect(response.statusCode, 503);
        expect(response.errorCode, 'backendBlocked');
      },
    );
  });
}

LocalHttpOwnChatSessionsDataSource _source({
  Uri? baseUri,
  LocalOnlyHostPolicy policy = const LocalOnlyHostPolicy(
    localValidationEnabled: true,
  ),
  _FakeTokenProvider? tokenProvider,
  _FakeTransport? transport,
}) {
  return LocalHttpOwnChatSessionsDataSource(
    baseUri: baseUri ?? Uri.parse('http://127.0.0.1:54321'),
    hostPolicy: policy,
    tokenProvider: tokenProvider ?? _FakeTokenProvider('local-jwt'),
    transport: transport ?? _FakeTransport(),
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

class _FakeTransport implements OwnChatSessionsHttpTransport {
  _FakeTransport({
    this.response = const OwnChatSessionsHttpResponse(
      statusCode: 200,
      body: <String, dynamic>{},
    ),
  });

  final OwnChatSessionsHttpResponse response;
  final List<OwnChatSessionsHttpRequest> requests = [];

  @override
  Future<OwnChatSessionsHttpResponse> send(
    OwnChatSessionsHttpRequest request,
  ) async {
    requests.add(request);
    return response;
  }
}

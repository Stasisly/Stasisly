import 'package:flutter_test/flutter_test.dart';

import 'package:stasisly/core/auth/session/secure_session.dart';
import 'package:stasisly/features/chat_sessions/data/datasources/local_http_own_chat_sessions_datasource.dart';
import 'package:stasisly/features/chat_sessions/data/local/local_only_host_policy.dart';
import 'package:stasisly/features/chat_sessions/data/local/local_session_token_provider.dart';
import 'package:stasisly/features/chat_sessions/data/local/own_chat_sessions_http_transport.dart';
import 'package:stasisly/features/chat_sessions/data/local/secure_session_chat_sessions_token_provider.dart';
import 'package:stasisly/features/chat_sessions/domain/entities/own_chat_session.dart';
import 'package:stasisly/features/conversations/application/idempotency/operation_attempt_id_factory.dart';

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
      'secure session wrapper token adds approved Authorization header',
      () async {
        final transport = _FakeTransport();

        await _source(
          tokenProvider: _secureSessionTokenProvider(
            SecureSessionTokenResult.success('fake-secure-session-token'),
          ),
          transport: transport,
        ).createOwnChatSession(selectableSpecialistId: 'catalog-public');

        final request = transport.requests.single;
        expect(
          request.headers['Authorization'],
          'Bearer fake-secure-session-token',
        );
        expect(request.body, {'selectableSpecialistId': 'catalog-public'});
        expect(request.body, isNot(containsPair('userId', anything)));
        expect(request.body, isNot(containsPair('ownerUserId', anything)));
        expect(request.body, isNot(containsPair('specialistId', anything)));
        expect(request.body, isNot(containsPair('role', anything)));
        expect(request.body, isNot(containsPair('permissions', anything)));
      },
    );

    test('secure session wrapper null token remains unauthenticated', () async {
      final transport = _FakeTransport();

      final response = await _source(
        tokenProvider: _secureSessionTokenProvider(
          const SecureSessionTokenResult.expired(),
        ),
        transport: transport,
      ).listOwnChatSessions(status: ChatSessionStatusFilter.active, limit: 20);

      expect(response.errorCode, 'unauthenticated');
      expect(transport.requests, isEmpty);
    });

    test(
      'secure session wrapper errors never become demo or transport calls',
      () async {
        final transport = _FakeTransport();

        final response = await _source(
          tokenProvider: SecureSessionChatSessionsTokenProvider(
            adapter: SecureSessionToLocalSessionTokenAdapter(
              tokenProvider: _ThrowingSecureSessionTokenProvider(),
            ),
          ),
          transport: transport,
        ).archiveOwnChatSession(sessionId: 'session-public');

        expect(response.errorCode, 'unauthenticated');
        expect(transport.requests, isEmpty);
      },
    );

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
          'Idempotency-Key',
        });
        expect(request.headers['Authorization'], 'Bearer local-jwt');
        expect(request.headers['Idempotency-Key'], 'test_attempt_00000001');
        for (final forbidden in [
          'userId',
          'ownerUserId',
          'role',
          'permissions',
          'specialistId',
          'agentId',
          'service_role',
        ]) {
          expect(request.body, isNot(containsPair(forbidden, anything)));
        }
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

    test('remote invalid or expired token remains unauthenticated', () async {
      final response = await _source(
        transport: _FakeTransport(
          response: const OwnChatSessionsHttpResponse(
            statusCode: 401,
            body: {
              'error': {
                'code': 'unauthenticated',
                'requestId': 'local-request',
              },
            },
          ),
        ),
      ).listOwnChatSessions(status: ChatSessionStatusFilter.active, limit: 20);

      expect(response.statusCode, 401);
      expect(response.errorCode, 'unauthenticated');
    });
  });
}

LocalHttpOwnChatSessionsDataSource _source({
  Uri? baseUri,
  LocalOnlyHostPolicy policy = const LocalOnlyHostPolicy(
    localValidationEnabled: true,
  ),
  LocalSessionTokenProvider? tokenProvider,
  _FakeTransport? transport,
  OperationAttemptIdFactory? operationAttemptIds,
}) {
  return LocalHttpOwnChatSessionsDataSource(
    baseUri: baseUri ?? Uri.parse('http://127.0.0.1:54321'),
    hostPolicy: policy,
    tokenProvider: tokenProvider ?? _FakeTokenProvider('local-jwt'),
    transport: transport ?? _FakeTransport(),
    operationAttemptIds:
        operationAttemptIds ?? _FakeOperationAttemptIdFactory(),
  );
}

class _FakeOperationAttemptIdFactory implements OperationAttemptIdFactory {
  int _next = 1;

  @override
  String create() => 'test_attempt_${(_next++).toString().padLeft(8, '0')}';
}

SecureSessionChatSessionsTokenProvider _secureSessionTokenProvider(
  SecureSessionTokenResult result,
) {
  return SecureSessionChatSessionsTokenProvider(
    adapter: SecureSessionToLocalSessionTokenAdapter(
      tokenProvider: _FakeSecureSessionTokenProvider(result),
    ),
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

class _FakeSecureSessionTokenProvider implements SecureSessionTokenProvider {
  const _FakeSecureSessionTokenProvider(this.result);

  final SecureSessionTokenResult result;

  @override
  Future<SecureSessionAuthState> currentAuthState() async {
    return const SecureSessionAuthState.unauthenticated();
  }

  @override
  Future<SecureSessionTokenResult> getAccessToken() async {
    return result;
  }

  @override
  Future<SecureSessionTokenResult> refreshIfNeeded() async {
    return result;
  }

  @override
  Future<void> clearSession() async {}
}

class _ThrowingSecureSessionTokenProvider
    implements SecureSessionTokenProvider {
  @override
  Future<SecureSessionAuthState> currentAuthState() async {
    return const SecureSessionAuthState.unauthenticated();
  }

  @override
  Future<SecureSessionTokenResult> getAccessToken() {
    throw StateError('fake secure session failure');
  }

  @override
  Future<SecureSessionTokenResult> refreshIfNeeded() {
    throw StateError('fake secure session failure');
  }

  @override
  Future<void> clearSession() async {}
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

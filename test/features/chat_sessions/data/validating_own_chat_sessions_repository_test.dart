import 'package:flutter_test/flutter_test.dart';

import 'package:stasisly/core/error/exceptions.dart';
import 'package:stasisly/features/chat_sessions/data/contracts/own_chat_sessions_contract_source.dart';
import 'package:stasisly/features/chat_sessions/data/repositories/validating_own_chat_sessions_repository.dart';
import 'package:stasisly/features/chat_sessions/domain/entities/own_chat_session.dart';
import 'package:stasisly/features/chat_sessions/domain/entities/own_chat_session_results.dart';

void main() {
  group('strict public payload validation', () {
    test('accepts exact create, list and archive payloads', () async {
      final source = _FakeSource(
        createResponse: _response({'session': _session()}),
        listResponse: _response({
          'items': [_session()],
          'nextCursor': 'opaque-value',
        }),
        archiveResponse: _response({
          'session': {'sessionId': 'session-public', 'status': 'archived'},
        }),
      );
      final repository = ValidatingOwnChatSessionsRepository(source: source);

      expect(
        await repository.createOwnChatSession(
          selectableSpecialistId: 'catalog-public',
        ),
        isA<CreateOwnChatSessionSuccess>(),
      );
      final listed = await repository.listOwnChatSessions(
        cursor: 'opaque-input',
      );
      expect(listed, isA<ListOwnChatSessionsSuccess>());
      expect(
        (listed as ListOwnChatSessionsSuccess).page.nextCursor,
        'opaque-value',
      );
      expect(source.receivedCursor, 'opaque-input');
      expect(
        await repository.archiveOwnChatSession(sessionId: 'session-public'),
        isA<ArchiveOwnChatSessionSuccess>(),
      );
    });

    test('rejects every internal, sensitive or extra field', () async {
      for (final field in [
        'user_id',
        'userId',
        'specialist_id',
        'specialistId',
        'internalSpecialistId',
        'prompt_template',
        'access_tier',
        'availability_status',
        'roles',
        'permissions',
        'ownerId',
        'authUserId',
        'backendUserId',
        'unexpected',
      ]) {
        final payload = _session()..[field] = 'forbidden';
        final result = await _createFrom(payload);
        expect(
          result,
          const CreateOwnChatSessionFailure(
            OwnChatSessionsFailureType.contractViolation,
          ),
          reason: field,
        );
      }
    });

    test('rejects partial, duplicate and malformed responses', () async {
      final partial = _session()..remove('lastMessageAt');
      expect(
        await _createFrom(partial),
        const CreateOwnChatSessionFailure(
          OwnChatSessionsFailureType.contractViolation,
        ),
      );

      final source = _FakeSource(
        listResponse: _response({
          'items': [_session(), _session()],
          'nextCursor': null,
        }),
      );
      expect(
        await ValidatingOwnChatSessionsRepository(
          source: source,
        ).listOwnChatSessions(),
        const ListOwnChatSessionsFailure(
          OwnChatSessionsFailureType.contractViolation,
        ),
      );
    });

    test('maps errors visibly and never falls back to demo', () async {
      final source = _FakeSource(
        createResponse: const OwnChatSessionsContractResponse(
          statusCode: 503,
          errorCode: 'backendBlocked',
        ),
        listResponse: const OwnChatSessionsContractResponse(
          statusCode: 403,
          errorCode: 'permissionDenied',
        ),
        archiveResponse: const OwnChatSessionsContractResponse(
          statusCode: 404,
          errorCode: 'sessionNotFound',
        ),
      );
      final repository = ValidatingOwnChatSessionsRepository(source: source);

      expect(
        await repository.createOwnChatSession(
          selectableSpecialistId: 'catalog-public',
        ),
        const CreateOwnChatSessionFailure(
          OwnChatSessionsFailureType.backendBlocked,
        ),
      );
      expect(
        await repository.listOwnChatSessions(),
        const ListOwnChatSessionsFailure(
          OwnChatSessionsFailureType.permissionDenied,
        ),
      );
      expect(
        await repository.archiveOwnChatSession(sessionId: 'session-public'),
        const ArchiveOwnChatSessionFailure(
          OwnChatSessionsFailureType.sessionNotFound,
        ),
      );
    });

    test(
      'real transport failures remain failures and never become demo',
      () async {
        final result = await ValidatingOwnChatSessionsRepository(
          source: _FakeSource(error: const NetworkException()),
        ).listOwnChatSessions();

        expect(
          result,
          const ListOwnChatSessionsFailure(
            OwnChatSessionsFailureType.networkError,
          ),
        );
        expect(result, isNot(isA<ListOwnChatSessionsDemo>()));
      },
    );

    test('invalid successful JSON shape becomes contract violation', () async {
      final result = await ValidatingOwnChatSessionsRepository(
        source: _FakeSource(
          createResponse: const OwnChatSessionsContractResponse(
            statusCode: 200,
          ),
        ),
      ).createOwnChatSession(selectableSpecialistId: 'catalog-public');

      expect(
        result,
        const CreateOwnChatSessionFailure(
          OwnChatSessionsFailureType.contractViolation,
        ),
      );
    });

    test('accepts create response with HTTP 201 Created', () async {
      final result = await ValidatingOwnChatSessionsRepository(
        source: _FakeSource(
          createResponse: OwnChatSessionsContractResponse(
            statusCode: 201,
            body: {'session': _session()},
          ),
        ),
      ).createOwnChatSession(selectableSpecialistId: 'catalog-public');

      expect(result, isA<CreateOwnChatSessionSuccess>());
    });

    test(
      'normalizes local PostgREST timestamps without timezone as UTC',
      () async {
        final session = _session()
          ..['startedAt'] = '2026-06-15T21:39:48.919204'
          ..['lastMessageAt'] = '2026-06-15T21:39:48.919204';

        final result = await ValidatingOwnChatSessionsRepository(
          source: _FakeSource(
            createResponse: OwnChatSessionsContractResponse(
              statusCode: 201,
              body: {'session': session},
            ),
          ),
        ).createOwnChatSession(selectableSpecialistId: 'catalog-public');

        expect(result, isA<CreateOwnChatSessionSuccess>());
        final created = result as CreateOwnChatSessionSuccess;
        expect(created.session.startedAt.isUtc, isTrue);
        expect(created.session.lastMessageAt.isUtc, isTrue);
      },
    );

    test(
      'maps approved HTTP error codes without success or demo fallback',
      () async {
        final cases = <(int, String?, OwnChatSessionsFailureType)>[
          (401, null, OwnChatSessionsFailureType.unauthenticated),
          (401, 'invalidSession', OwnChatSessionsFailureType.invalidSession),
          (400, 'invalidRequest', OwnChatSessionsFailureType.invalidRequest),
          (400, 'invalidStatus', OwnChatSessionsFailureType.invalidRequest),
          (400, 'invalidCursor', OwnChatSessionsFailureType.invalidRequest),
          (
            404,
            'invalidSelectableSpecialist',
            OwnChatSessionsFailureType.invalidSelectableSpecialist,
          ),
          (
            409,
            'specialistUnavailable',
            OwnChatSessionsFailureType.specialistUnavailable,
          ),
          (402, 'premiumLocked', OwnChatSessionsFailureType.premiumLocked),
          (404, 'sessionNotFound', OwnChatSessionsFailureType.sessionNotFound),
          (
            403,
            'permissionDenied',
            OwnChatSessionsFailureType.permissionDenied,
          ),
          (
            502,
            'contractViolation',
            OwnChatSessionsFailureType.contractViolation,
          ),
          (
            409,
            'archiveUnconfirmed',
            OwnChatSessionsFailureType.contractViolation,
          ),
          (
            503,
            'backendMisconfigured',
            OwnChatSessionsFailureType.backendBlocked,
          ),
          (500, 'unexpectedError', OwnChatSessionsFailureType.unexpectedError),
        ];

        for (final (statusCode, errorCode, expected) in cases) {
          final result = await ValidatingOwnChatSessionsRepository(
            source: _FakeSource(
              createResponse: OwnChatSessionsContractResponse(
                statusCode: statusCode,
                errorCode: errorCode,
              ),
            ),
          ).createOwnChatSession(selectableSpecialistId: 'catalog-public');

          expect(
            result,
            CreateOwnChatSessionFailure(expected),
            reason: errorCode,
          );
          expect(result, isNot(isA<CreateOwnChatSessionSuccess>()));
          expect(result, isNot(isA<CreateOwnChatSessionDemo>()));
        }
      },
    );
  });
}

Future<CreateOwnChatSessionResult> _createFrom(Map<String, dynamic> session) {
  return ValidatingOwnChatSessionsRepository(
    source: _FakeSource(createResponse: _response({'session': session})),
  ).createOwnChatSession(selectableSpecialistId: 'catalog-public');
}

OwnChatSessionsContractResponse _response(Map<String, dynamic> body) {
  return OwnChatSessionsContractResponse(statusCode: 200, body: body);
}

Map<String, dynamic> _session() {
  return {
    'sessionId': 'session-public',
    'selectableSpecialist': {
      'id': 'catalog-public',
      'displayName': 'Wellness',
      'area': 'wellness',
    },
    'startedAt': '2026-06-14T10:00:00.000Z',
    'lastMessageAt': '2026-06-14T10:00:00.000Z',
    'status': 'active',
    'messageCount': 0,
  };
}

class _FakeSource implements OwnChatSessionsContractSource {
  _FakeSource({
    this.createResponse = const OwnChatSessionsContractResponse(
      statusCode: 500,
    ),
    this.listResponse = const OwnChatSessionsContractResponse(statusCode: 500),
    this.archiveResponse = const OwnChatSessionsContractResponse(
      statusCode: 500,
    ),
    this.error,
  });

  final OwnChatSessionsContractResponse createResponse;
  final OwnChatSessionsContractResponse listResponse;
  final OwnChatSessionsContractResponse archiveResponse;
  final Exception? error;
  String? receivedCursor;

  @override
  Future<OwnChatSessionsContractResponse> archiveOwnChatSession({
    required String sessionId,
  }) async {
    if (error case final error?) throw error;
    return archiveResponse;
  }

  @override
  Future<OwnChatSessionsContractResponse> createOwnChatSession({
    required String selectableSpecialistId,
  }) async {
    if (error case final error?) throw error;
    return createResponse;
  }

  @override
  Future<OwnChatSessionsContractResponse> listOwnChatSessions({
    required ChatSessionStatusFilter status,
    required int limit,
    String? cursor,
  }) async {
    if (error case final error?) throw error;
    receivedCursor = cursor;
    return listResponse;
  }
}

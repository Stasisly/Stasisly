import 'package:flutter_test/flutter_test.dart';

import 'package:stasisly/core/authorization/authorization.dart';
import 'package:stasisly/core/error/exceptions.dart';
import 'package:stasisly/core/identity/domain/authentication_state.dart';
import 'package:stasisly/core/identity/domain/identity_type.dart';
import 'package:stasisly/core/identity/domain/stasisly_identity.dart';
import 'package:stasisly/features/profile/application/own_profile_read_authorization_gate.dart';
import 'package:stasisly/features/profile/data/datasources/own_profile_remote_datasource.dart';
import 'package:stasisly/features/profile/data/repositories/own_profile_repository_impl.dart';
import 'package:stasisly/features/profile/domain/entities/own_profile_results.dart';

void main() {
  const identityId = 'owner-id';
  const identity = StasislyIdentity(
    subjectId: identityId,
    identityType: IdentityType.humanUser,
    authenticationState: AuthenticationState.authenticated,
  );

  group('OwnProfileRepositoryImpl read', () {
    test('accepts exactly one owner row with approved columns', () async {
      final repository = OwnProfileRepositoryImpl(
        dataSource: _FakeDataSource(
          readResponse: const OwnProfileRemoteResponse(
            statusCode: 200,
            rows: [
              {'id': identityId, 'display_name': 'Raúl'},
            ],
          ),
        ),
        currentIdentity: identity,
        authorizationEnvironment: AuthorizationEnvironment.local,
        readAuthorizationGate: _readAuthorizationGate(),
      );

      final result = await repository.readOwnProfile();

      expect(result, isA<OwnProfileSuccess>());
      expect((result as OwnProfileSuccess).profile.displayName, 'Raúl');
      expect(result.profile.isDemo, isFalse);
    });

    test('maps empty and multiple rows to contract states', () async {
      final missing = OwnProfileRepositoryImpl(
        dataSource: _FakeDataSource(
          readResponse: const OwnProfileRemoteResponse(statusCode: 200),
        ),
        currentIdentity: identity,
        authorizationEnvironment: AuthorizationEnvironment.local,
        readAuthorizationGate: _readAuthorizationGate(),
      );
      final multiple = OwnProfileRepositoryImpl(
        dataSource: _FakeDataSource(
          readResponse: const OwnProfileRemoteResponse(
            statusCode: 200,
            rows: [
              {'id': identityId, 'display_name': 'Owner'},
              {'id': 'other', 'display_name': 'Other'},
            ],
          ),
        ),
        currentIdentity: identity,
        authorizationEnvironment: AuthorizationEnvironment.local,
        readAuthorizationGate: _readAuthorizationGate(),
      );

      expect(await missing.readOwnProfile(), isA<OwnProfileMissing>());
      expect(
        await multiple.readOwnProfile(),
        isA<OwnProfileContractViolation>(),
      );
    });

    test('rejects extra columns and an unexpected identity', () async {
      final extraColumn = OwnProfileRepositoryImpl(
        dataSource: _FakeDataSource(
          readResponse: const OwnProfileRemoteResponse(
            statusCode: 200,
            rows: [
              {'id': identityId, 'display_name': 'Owner', 'role': 'admin'},
            ],
          ),
        ),
        currentIdentity: identity,
        authorizationEnvironment: AuthorizationEnvironment.local,
        readAuthorizationGate: _readAuthorizationGate(),
      );
      final otherIdentity = OwnProfileRepositoryImpl(
        dataSource: _FakeDataSource(
          readResponse: const OwnProfileRemoteResponse(
            statusCode: 200,
            rows: [
              {'id': 'other', 'display_name': 'Other'},
            ],
          ),
        ),
        currentIdentity: identity,
        authorizationEnvironment: AuthorizationEnvironment.local,
        readAuthorizationGate: _readAuthorizationGate(),
      );

      expect(
        await extraColumn.readOwnProfile(),
        isA<OwnProfileContractViolation>(),
      );
      expect(
        await otherIdentity.readOwnProfile(),
        isA<OwnProfileContractViolation>(),
      );
    });

    test('maps 401, 403, 42501 and network errors visibly', () async {
      Future<OwnProfileResult> read(OwnProfileRemoteDataSource source) {
        return OwnProfileRepositoryImpl(
          dataSource: source,
          currentIdentity: identity,
          authorizationEnvironment: AuthorizationEnvironment.local,
          readAuthorizationGate: _readAuthorizationGate(),
        ).readOwnProfile();
      }

      expect(
        await read(
          _FakeDataSource(
            readResponse: const OwnProfileRemoteResponse(statusCode: 401),
          ),
        ),
        isA<OwnProfileUnauthenticated>(),
      );
      expect(
        await read(
          _FakeDataSource(
            readResponse: const OwnProfileRemoteResponse(statusCode: 403),
          ),
        ),
        isA<OwnProfilePermissionDenied>(),
      );
      expect(
        await read(
          _FakeDataSource(
            readResponse: const OwnProfileRemoteResponse(
              statusCode: 500,
              errorCode: '42501',
            ),
          ),
        ),
        isA<OwnProfilePermissionDenied>(),
      );
      expect(
        await read(_FakeDataSource(readError: const NetworkException())),
        isA<OwnProfileNetworkError>(),
      );
    });

    test('fails closed when the local policy receives production', () async {
      final repository = OwnProfileRepositoryImpl(
        dataSource: _FakeDataSource(
          readResponse: const OwnProfileRemoteResponse(
            statusCode: 200,
            rows: [
              {'id': identityId, 'display_name': 'Owner'},
            ],
          ),
        ),
        currentIdentity: identity,
        authorizationEnvironment: AuthorizationEnvironment.production,
        readAuthorizationGate: _readAuthorizationGate(),
      );

      expect(
        await repository.readOwnProfile(),
        isA<OwnProfilePermissionDenied>(),
      );
    });
  });

  group('OwnProfileRepositoryImpl update', () {
    test(
      'sends only normalized displayName through the typed contract',
      () async {
        final dataSource = _FakeDataSource(
          updateResponse: const OwnProfileRemoteResponse(
            statusCode: 200,
            rows: [
              {'id': identityId, 'display_name': 'Raúl'},
            ],
          ),
        );
        final repository = OwnProfileRepositoryImpl(
          dataSource: dataSource,
          currentIdentity: identity,
          authorizationEnvironment: AuthorizationEnvironment.local,
          readAuthorizationGate: _readAuthorizationGate(),
        );

        final result = await repository.updateOwnDisplayName('  Raúl  ');

        expect(result, isA<UpdateOwnDisplayNameSuccess>());
        expect(dataSource.lastDisplayName, 'Raúl');
      },
    );

    test('invalid name stops before datasource execution', () async {
      final dataSource = _FakeDataSource();
      final repository = OwnProfileRepositoryImpl(
        dataSource: dataSource,
        currentIdentity: identity,
        authorizationEnvironment: AuthorizationEnvironment.local,
        readAuthorizationGate: _readAuthorizationGate(),
      );

      final result = await repository.updateOwnDisplayName('A');

      expect(result, isA<UpdateOwnDisplayNameInvalid>());
      expect(dataSource.updateCalls, 0);
    });

    test('204 and empty 200 never become silent success', () async {
      final unconfirmed = OwnProfileRepositoryImpl(
        dataSource: _FakeDataSource(
          updateResponse: const OwnProfileRemoteResponse(statusCode: 204),
        ),
        currentIdentity: identity,
        authorizationEnvironment: AuthorizationEnvironment.local,
        readAuthorizationGate: _readAuthorizationGate(),
      );
      final missing = OwnProfileRepositoryImpl(
        dataSource: _FakeDataSource(
          updateResponse: const OwnProfileRemoteResponse(statusCode: 200),
        ),
        currentIdentity: identity,
        authorizationEnvironment: AuthorizationEnvironment.local,
        readAuthorizationGate: _readAuthorizationGate(),
      );

      expect(
        await unconfirmed.updateOwnDisplayName('Owner'),
        isA<UpdateOwnDisplayNameUnconfirmed>(),
      );
      expect(
        await missing.updateOwnDisplayName('Owner'),
        isA<UpdateOwnDisplayNameProfileMissing>(),
      );
    });

    test('rejects extra columns and mismatched confirmed values', () async {
      final extra = OwnProfileRepositoryImpl(
        dataSource: _FakeDataSource(
          updateResponse: const OwnProfileRemoteResponse(
            statusCode: 200,
            rows: [
              {'id': identityId, 'display_name': 'Owner', 'role': 'user'},
            ],
          ),
        ),
        currentIdentity: identity,
        authorizationEnvironment: AuthorizationEnvironment.local,
        readAuthorizationGate: _readAuthorizationGate(),
      );
      final mismatch = OwnProfileRepositoryImpl(
        dataSource: _FakeDataSource(
          updateResponse: const OwnProfileRemoteResponse(
            statusCode: 200,
            rows: [
              {'id': identityId, 'display_name': 'Different'},
            ],
          ),
        ),
        currentIdentity: identity,
        authorizationEnvironment: AuthorizationEnvironment.local,
        readAuthorizationGate: _readAuthorizationGate(),
      );

      expect(
        await extra.updateOwnDisplayName('Owner'),
        isA<UpdateOwnDisplayNameContractViolation>(),
      );
      expect(
        await mismatch.updateOwnDisplayName('Owner'),
        isA<UpdateOwnDisplayNameContractViolation>(),
      );
    });

    test(
      'maps authentication, permission and network failures visibly',
      () async {
        final unauthenticated = OwnProfileRepositoryImpl(
          dataSource: _FakeDataSource(
            updateResponse: const OwnProfileRemoteResponse(statusCode: 401),
          ),
          currentIdentity: identity,
          authorizationEnvironment: AuthorizationEnvironment.local,
          readAuthorizationGate: _readAuthorizationGate(),
        );
        final denied = OwnProfileRepositoryImpl(
          dataSource: _FakeDataSource(
            updateResponse: const OwnProfileRemoteResponse(
              statusCode: 403,
              errorCode: '42501',
            ),
          ),
          currentIdentity: identity,
          authorizationEnvironment: AuthorizationEnvironment.local,
          readAuthorizationGate: _readAuthorizationGate(),
        );
        final network = OwnProfileRepositoryImpl(
          dataSource: _FakeDataSource(updateError: const NetworkException()),
          currentIdentity: identity,
          authorizationEnvironment: AuthorizationEnvironment.local,
          readAuthorizationGate: _readAuthorizationGate(),
        );

        expect(
          await unauthenticated.updateOwnDisplayName('Owner'),
          isA<UpdateOwnDisplayNameUnauthenticated>(),
        );
        expect(
          await denied.updateOwnDisplayName('Owner'),
          isA<UpdateOwnDisplayNamePermissionDenied>(),
        );
        expect(
          await network.updateOwnDisplayName('Owner'),
          isA<UpdateOwnDisplayNameNetworkError>(),
        );
      },
    );
  });
}

OwnProfileReadAuthorizationGate _readAuthorizationGate() {
  return OwnProfileReadAuthorizationGate(
    DefaultAuthorizationEnforcer(
      decisionPoint: LocalFoundationPolicyDecisionPoint(),
      auditSink: const LocalNoOpAuthorizationAuditSink(),
    ),
  );
}

class _FakeDataSource implements OwnProfileRemoteDataSource {
  _FakeDataSource({
    this.readResponse = const OwnProfileRemoteResponse(statusCode: 500),
    this.updateResponse = const OwnProfileRemoteResponse(statusCode: 500),
    this.readError,
    this.updateError,
  });

  final OwnProfileRemoteResponse readResponse;
  final OwnProfileRemoteResponse updateResponse;
  final Exception? readError;
  final Exception? updateError;
  int readCalls = 0;
  int updateCalls = 0;
  String? lastDisplayName;

  @override
  Future<OwnProfileRemoteResponse> readOwnProfile() async {
    readCalls += 1;
    if (readError case final error?) throw error;
    return readResponse;
  }

  @override
  Future<OwnProfileRemoteResponse> updateOwnDisplayName(
    String displayName,
  ) async {
    updateCalls += 1;
    lastDisplayName = displayName;
    if (updateError case final error?) throw error;
    return updateResponse;
  }
}

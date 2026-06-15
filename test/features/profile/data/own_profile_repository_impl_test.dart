import 'package:flutter_test/flutter_test.dart';

import 'package:stasisly/core/error/exceptions.dart';
import 'package:stasisly/features/profile/data/datasources/own_profile_remote_datasource.dart';
import 'package:stasisly/features/profile/data/repositories/own_profile_repository_impl.dart';
import 'package:stasisly/features/profile/domain/entities/own_profile_results.dart';

void main() {
  const identityId = 'owner-id';

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
        currentIdentityId: identityId,
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
        currentIdentityId: identityId,
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
        currentIdentityId: identityId,
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
        currentIdentityId: identityId,
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
        currentIdentityId: identityId,
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
          currentIdentityId: identityId,
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
          currentIdentityId: identityId,
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
        currentIdentityId: identityId,
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
        currentIdentityId: identityId,
      );
      final missing = OwnProfileRepositoryImpl(
        dataSource: _FakeDataSource(
          updateResponse: const OwnProfileRemoteResponse(statusCode: 200),
        ),
        currentIdentityId: identityId,
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
        currentIdentityId: identityId,
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
        currentIdentityId: identityId,
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
          currentIdentityId: identityId,
        );
        final denied = OwnProfileRepositoryImpl(
          dataSource: _FakeDataSource(
            updateResponse: const OwnProfileRemoteResponse(
              statusCode: 403,
              errorCode: '42501',
            ),
          ),
          currentIdentityId: identityId,
        );
        final network = OwnProfileRepositoryImpl(
          dataSource: _FakeDataSource(updateError: const NetworkException()),
          currentIdentityId: identityId,
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

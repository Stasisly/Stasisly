import 'package:flutter_test/flutter_test.dart';

import 'package:stasisly/core/error/exceptions.dart';
import 'package:stasisly/features/specialists/data/datasources/selectable_specialists_remote_datasource.dart';
import 'package:stasisly/features/specialists/data/repositories/selectable_specialists_repository_impl.dart';
import 'package:stasisly/features/specialists/domain/entities/selectable_specialist.dart';
import 'package:stasisly/features/specialists/domain/entities/selectable_specialists_result.dart';

void main() {
  group('strict backend contract', () {
    test('accepts only the exact approved envelope and fields', () async {
      final result = await _read(_response(items: [_validItem()]));

      expect(result, isA<SelectableSpecialistsSuccess>());
      final item = (result as SelectableSpecialistsSuccess).specialists.single;
      expect(item.isDemo, isFalse);
      expect(item.area, SelectableSpecialistArea.health);
    });

    test('maps an approved empty catalog explicitly', () async {
      expect(
        await _read(_response(items: const [])),
        isA<SelectableSpecialistsEmpty>(),
      );
    });

    test('rejects extra or missing fields and extra envelope keys', () async {
      final missing = _validItem()..remove('shortDescription');

      for (final forbidden in [
        'specialist_id',
        'specialistId',
        'internalSpecialistId',
        'prompt_template',
        'promptTemplate',
        'branch_id',
        'chief_id',
        'access_tier',
        'availability_status',
        'is_published',
        'created_at',
        'updated_at',
        'roles',
        'permissions',
      ]) {
        final extra = _validItem()..[forbidden] = 'forbidden';
        expect(
          await _read(_response(items: [extra])),
          isA<SelectableSpecialistsContractViolation>(),
          reason: forbidden,
        );
      }
      expect(
        await _read(_response(items: [missing])),
        isA<SelectableSpecialistsContractViolation>(),
      );
      expect(
        await _read(
          SelectableSpecialistsRemoteResponse(
            statusCode: 200,
            body: {
              'items': [_validItem()],
              'metadata': true,
            },
          ),
        ),
        isA<SelectableSpecialistsContractViolation>(),
      );
    });

    test(
      'rejects invalid enums, backend demo claims and duplicate ids',
      () async {
        final invalidArea = _validItem()..['area'] = 'mental';
        final invalidState = _validItem()..['accessState'] = 'adminOnly';
        final demo = _validItem()
          ..['isDemo'] = true
          ..['accessState'] = 'demoOnly';

        for (final item in [invalidArea, invalidState, demo]) {
          expect(
            await _read(_response(items: [item])),
            isA<SelectableSpecialistsContractViolation>(),
          );
        }
        expect(
          await _read(_response(items: [_validItem(), _validItem()])),
          isA<SelectableSpecialistsContractViolation>(),
        );
      },
    );
  });

  group('visible error mapping', () {
    test('maps auth, permission and catalog errors', () async {
      expect(
        await _read(const SelectableSpecialistsRemoteResponse(statusCode: 401)),
        isA<SelectableSpecialistsUnauthenticated>(),
      );
      expect(
        await _read(const SelectableSpecialistsRemoteResponse(statusCode: 403)),
        isA<SelectableSpecialistsPermissionDenied>(),
      );
      expect(
        await _read(
          const SelectableSpecialistsRemoteResponse(
            statusCode: 400,
            errorCode: 'catalogInvalidSession',
          ),
        ),
        isA<SelectableSpecialistsInvalidSession>(),
      );
      expect(
        await _read(
          const SelectableSpecialistsRemoteResponse(
            statusCode: 400,
            errorCode: 'catalogInvalidArea',
          ),
        ),
        isA<SelectableSpecialistsInvalidArea>(),
      );
      expect(
        await _read(
          const SelectableSpecialistsRemoteResponse(
            statusCode: 503,
            errorCode: 'catalogBackendBlocked',
          ),
        ),
        isA<SelectableSpecialistsBackendBlocked>(),
      );
    });

    test(
      'maps network and unexpected failures without mock fallback',
      () async {
        expect(
          await const SelectableSpecialistsRepositoryImpl(
            dataSource: _FakeDataSource(error: NetworkException()),
          ).listSelectableSpecialists(),
          isA<SelectableSpecialistsNetworkError>(),
        );
        expect(
          await SelectableSpecialistsRepositoryImpl(
            dataSource: _FakeDataSource(error: Exception('unexpected')),
          ).listSelectableSpecialists(),
          isA<SelectableSpecialistsUnexpectedError>(),
        );
      },
    );
  });
}

Future<SelectableSpecialistsResult> _read(
  SelectableSpecialistsRemoteResponse response,
) {
  return SelectableSpecialistsRepositoryImpl(
    dataSource: _FakeDataSource(response: response),
  ).listSelectableSpecialists();
}

SelectableSpecialistsRemoteResponse _response({
  required List<Map<String, dynamic>> items,
}) {
  return SelectableSpecialistsRemoteResponse(
    statusCode: 200,
    body: {'items': items},
  );
}

Map<String, dynamic> _validItem() {
  return {
    'id': 'health-general',
    'displayName': 'Salud general',
    'area': 'health',
    'shortDescription': 'Orientación general.',
    'accessState': 'available',
    'isDemo': false,
  };
}

class _FakeDataSource implements SelectableSpecialistsRemoteDataSource {
  const _FakeDataSource({
    this.response = const SelectableSpecialistsRemoteResponse(statusCode: 500),
    this.error,
  });

  final SelectableSpecialistsRemoteResponse response;
  final Exception? error;

  @override
  Future<SelectableSpecialistsRemoteResponse> listSelectableSpecialists({
    SelectableSpecialistArea? areaFilter,
  }) async {
    if (error case final error?) throw error;
    return response;
  }
}

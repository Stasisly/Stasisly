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
        'userId',
        'ownerUserId',
        'owner',
        'prompt_template',
        'promptTemplate',
        'prompt',
        'systemPrompt',
        'developerPrompt',
        'branch_id',
        'chief_id',
        'access_tier',
        'accessTier',
        'availability_status',
        'availability',
        'supportedSurfaces',
        'is_published',
        'isPublished',
        'created_at',
        'updated_at',
        'slug',
        'product_area',
        'subcategory',
        'capabilities',
        'sort_order',
        'locale',
        'supported_surfaces',
        'metadata',
        'roles',
        'role',
        'permissions',
        'service_role',
        'token',
        'accessToken',
        'refreshToken',
        'logs',
        'rawError',
        'adminSurface',
        'wizardSurface',
        'developmentSurface',
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
      for (final requiredField in [
        'id',
        'displayName',
        'area',
        'shortDescription',
        'accessState',
        'isDemo',
      ]) {
        final item = _validItem()..remove(requiredField);
        expect(
          await _read(_response(items: [item])),
          isA<SelectableSpecialistsContractViolation>(),
          reason: requiredField,
        );
      }
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
        final legacyPremiumState = _validItem()
          ..['accessState'] = 'lockedPremium';
        final demo = _validItem()
          ..['isDemo'] = true
          ..['accessState'] = 'demoOnly';

        for (final item in [
          invalidArea,
          invalidState,
          legacyPremiumState,
          demo,
        ]) {
          expect(
            await _read(_response(items: [item])),
            isA<SelectableSpecialistsContractViolation>(),
          );
        }
        for (final invalidCatalogState in [
          _validItem()..['availability_status'] = 'available',
          _validItem()..['availability'] = 'available',
          _validItem()..['access_tier'] = 'free',
          _validItem()..['accessTier'] = 'free',
          _validItem()..['supported_surfaces'] = ['product'],
          _validItem()..['supportedSurfaces'] = ['product'],
        ]) {
          expect(
            await _read(_response(items: [invalidCatalogState])),
            isA<SelectableSpecialistsContractViolation>(),
          );
        }
        for (final invalidProductSurfaceValue in [
          _validItem()..['area'] = 'admin',
          _validItem()..['area'] = 'wizard',
          _validItem()..['area'] = 'development',
          _validItem()..['area'] = 'engine',
          _validItem()..['accessState'] = 'published',
          _validItem()..['accessState'] = 'maintenance',
          _validItem()..['accessState'] = 'coming_soon',
          _validItem()..['accessState'] = 'internalOnly',
        ]) {
          expect(
            await _read(_response(items: [invalidProductSurfaceValue])),
            isA<SelectableSpecialistsContractViolation>(),
          );
        }
        expect(
          await _read(_response(items: [_validItem(), _validItem()])),
          isA<SelectableSpecialistsContractViolation>(),
        );
      },
    );

    test('accepts lockedPro as the canonical paid access state', () async {
      final result = await _read(
        _response(items: [_validItem()..['accessState'] = 'lockedPro']),
      );

      expect(result, isA<SelectableSpecialistsSuccess>());
      final item = (result as SelectableSpecialistsSuccess).specialists.single;
      expect(item.accessState, SelectableSpecialistAccessState.lockedPro);
    });
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
      expect(
        await _read(
          const SelectableSpecialistsRemoteResponse(
            statusCode: 502,
            errorCode: 'contractViolation',
          ),
        ),
        isA<SelectableSpecialistsUnexpectedError>(),
      );
      expect(
        await _read(
          const SelectableSpecialistsRemoteResponse(
            statusCode: 503,
            body: {
              'items': <Map<String, dynamic>>[],
              'error': 'database stack trace',
            },
          ),
        ),
        isA<SelectableSpecialistsUnexpectedError>(),
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

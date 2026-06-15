import 'package:stasisly/core/error/exceptions.dart';
import 'package:stasisly/features/specialists/data/datasources/selectable_specialists_remote_datasource.dart';
import 'package:stasisly/features/specialists/data/models/selectable_specialist_model.dart';
import 'package:stasisly/features/specialists/domain/entities/selectable_specialist.dart';
import 'package:stasisly/features/specialists/domain/entities/selectable_specialists_result.dart';
import 'package:stasisly/features/specialists/domain/repositories/selectable_specialists_repository.dart';

/// Validates and maps a future backend response. It performs no I/O itself.
class SelectableSpecialistsRepositoryImpl
    implements SelectableSpecialistsRepository {
  const SelectableSpecialistsRepositoryImpl({required this.dataSource});

  final SelectableSpecialistsRemoteDataSource dataSource;

  @override
  Future<SelectableSpecialistsResult> listSelectableSpecialists({
    SelectableSpecialistArea? areaFilter,
  }) async {
    try {
      final response = await dataSource.listSelectableSpecialists(
        areaFilter: areaFilter,
      );
      final error = _mapError(response);
      if (error != null) return error;

      final body = response.body;
      if (body == null ||
          body.keys.length != 1 ||
          !body.containsKey('items') ||
          body['items'] is! List) {
        return const SelectableSpecialistsContractViolation();
      }

      final rawItems = body['items'] as List<dynamic>;
      final specialists = rawItems
          .map((raw) {
            if (raw is! Map<String, dynamic>) {
              throw const FormatException('Invalid specialist catalog item.');
            }
            return SelectableSpecialistModel.fromBackendJson(raw).toEntity();
          })
          .toList(growable: false);

      if (specialists.map((item) => item.id).toSet().length !=
          specialists.length) {
        return const SelectableSpecialistsContractViolation();
      }
      if (specialists.isEmpty) return const SelectableSpecialistsEmpty();
      return SelectableSpecialistsSuccess(specialists);
    } on NetworkException {
      return const SelectableSpecialistsNetworkError();
    } on FormatException {
      return const SelectableSpecialistsContractViolation();
    } on Exception {
      return const SelectableSpecialistsUnexpectedError();
    }
  }

  SelectableSpecialistsResult? _mapError(
    SelectableSpecialistsRemoteResponse response,
  ) {
    if (response.statusCode == 401) {
      return const SelectableSpecialistsUnauthenticated();
    }
    if (response.statusCode == 403 || response.errorCode == '42501') {
      return const SelectableSpecialistsPermissionDenied();
    }
    if (response.errorCode == 'catalogInvalidSession') {
      return const SelectableSpecialistsInvalidSession();
    }
    if (response.errorCode == 'catalogInvalidArea') {
      return const SelectableSpecialistsInvalidArea();
    }
    if (response.errorCode == 'catalogBackendBlocked') {
      return const SelectableSpecialistsBackendBlocked();
    }
    if (response.statusCode != 200) {
      return const SelectableSpecialistsUnexpectedError();
    }
    return null;
  }
}

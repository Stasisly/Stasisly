import 'package:stasisly/features/specialists/domain/entities/selectable_specialist.dart';
import 'package:stasisly/features/specialists/domain/entities/selectable_specialists_result.dart';
import 'package:stasisly/features/specialists/domain/repositories/selectable_specialists_repository.dart';

class BackendBlockedSelectableSpecialistsRepository
    implements SelectableSpecialistsRepository {
  const BackendBlockedSelectableSpecialistsRepository();

  @override
  Future<SelectableSpecialistsResult> listSelectableSpecialists({
    SelectableSpecialistArea? areaFilter,
  }) async {
    return const SelectableSpecialistsBackendBlocked();
  }
}

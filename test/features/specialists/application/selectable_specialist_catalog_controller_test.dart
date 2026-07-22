import 'package:flutter_test/flutter_test.dart';

import 'package:stasisly/features/specialists/application/selectable_specialist_catalog_controller.dart';
import 'package:stasisly/features/specialists/application/selectable_specialist_catalog_state.dart';
import 'package:stasisly/features/specialists/domain/entities/selectable_specialist.dart';
import 'package:stasisly/features/specialists/domain/entities/selectable_specialists_result.dart';
import 'package:stasisly/features/specialists/domain/repositories/selectable_specialists_repository.dart';

void main() {
  for (final entry
      in <SelectableSpecialistsResult, SelectableSpecialistCatalogPhase>{
        const SelectableSpecialistsSuccess([_specialist]):
            SelectableSpecialistCatalogPhase.data,
        const SelectableSpecialistsEmpty():
            SelectableSpecialistCatalogPhase.empty,
        const SelectableSpecialistsUnauthenticated():
            SelectableSpecialistCatalogPhase.unauthenticated,
        const SelectableSpecialistsBackendBlocked():
            SelectableSpecialistCatalogPhase.environmentBlocked,
        const SelectableSpecialistsPermissionDenied():
            SelectableSpecialistCatalogPhase.error,
      }.entries) {
    test('maps ${entry.key.runtimeType} to ${entry.value.name}', () async {
      final states = <SelectableSpecialistCatalogState>[];
      final controller = SelectableSpecialistCatalogController(
        catalog: _Catalog(entry.key),
        onStateChanged: states.add,
      );
      addTearDown(controller.dispose);

      await controller.load();

      expect(states.first.phase, SelectableSpecialistCatalogPhase.loading);
      expect(controller.state.phase, entry.value);
    });
  }
}

const _specialist = SelectableSpecialist(
  selectableSpecialistId: 'stable-catalog-reference',
  displayName: 'Synthetic specialist',
  publicArea: SelectableSpecialistArea.stasis,
  publicDescription: 'Safe public description.',
  accessState: SelectableSpecialistAccessState.available,
);

class _Catalog implements SelectableSpecialistCatalog {
  const _Catalog(this.result);
  final SelectableSpecialistsResult result;

  @override
  Future<SelectableSpecialistsResult> listSelectableSpecialists({
    SelectableSpecialistArea? areaFilter,
  }) async => result;
}

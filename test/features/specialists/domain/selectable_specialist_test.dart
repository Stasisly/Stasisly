import 'package:flutter_test/flutter_test.dart';

import 'package:stasisly/features/specialists/domain/entities/selectable_specialist.dart';

void main() {
  test('selectable specialist exposes only catalog-safe semantics', () {
    const specialist = SelectableSpecialist(
      selectableSpecialistId: 'nutrition-1',
      displayName: 'Nutrición',
      publicArea: SelectableSpecialistArea.nutrition,
      publicDescription: 'Descripción segura.',
      accessState: SelectableSpecialistAccessState.available,
    );

    expect(specialist.props, hasLength(5));
    expect(specialist.publicArea, SelectableSpecialistArea.nutrition);
    expect(specialist.accessState, SelectableSpecialistAccessState.available);
  });
}

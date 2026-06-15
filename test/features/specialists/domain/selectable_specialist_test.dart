import 'package:flutter_test/flutter_test.dart';

import 'package:stasisly/features/specialists/domain/entities/selectable_specialist.dart';

void main() {
  test('selectable specialist exposes only catalog-safe semantics', () {
    const specialist = SelectableSpecialist(
      id: 'nutrition-1',
      displayName: 'Nutrición',
      area: SelectableSpecialistArea.nutrition,
      shortDescription: 'Descripción segura.',
      accessState: SelectableSpecialistAccessState.available,
      isDemo: false,
    );

    expect(specialist.props, hasLength(6));
    expect(specialist.area, SelectableSpecialistArea.nutrition);
    expect(specialist.accessState, SelectableSpecialistAccessState.available);
  });
}

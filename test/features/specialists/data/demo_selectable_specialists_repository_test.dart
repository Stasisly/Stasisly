import 'package:flutter_test/flutter_test.dart';

import 'package:stasisly/features/specialists/data/repositories/demo_selectable_specialists_repository.dart';
import 'package:stasisly/features/specialists/domain/entities/selectable_specialist.dart';
import 'package:stasisly/features/specialists/domain/entities/selectable_specialists_result.dart';

void main() {
  const repository = DemoSelectableSpecialistsRepository();

  test('returns an explicit, local and safe demo catalog', () async {
    final result = await repository.listSelectableSpecialists();

    expect(result, isA<SelectableSpecialistsDemo>());
    final items = (result as SelectableSpecialistsDemo).specialists;
    expect(items, hasLength(6));
    expect(items.every((item) => item.isDemo), isTrue);
    expect(
      items.every(
        (item) => item.accessState == SelectableSpecialistAccessState.demoOnly,
      ),
      isTrue,
    );
    expect(items.map((item) => item.id).toSet(), hasLength(items.length));
    final descriptions = items
        .map((item) => item.shortDescription.toLowerCase())
        .join(' ');
    expect(descriptions, isNot(contains('diagnóstico')));
    expect(descriptions, isNot(contains('tratamiento')));
    expect(descriptions, isNot(contains('terapia')));
  });

  test('filters locally by approved area enum', () async {
    final result = await repository.listSelectableSpecialists(
      areaFilter: SelectableSpecialistArea.wellness,
    );

    final items = (result as SelectableSpecialistsDemo).specialists;
    expect(items, hasLength(2));
    expect(
      items.every((item) => item.area == SelectableSpecialistArea.wellness),
      isTrue,
    );
  });
}

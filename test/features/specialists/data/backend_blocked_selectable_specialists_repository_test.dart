import 'package:flutter_test/flutter_test.dart';

import 'package:stasisly/features/specialists/data/repositories/backend_blocked_selectable_specialists_repository.dart';
import 'package:stasisly/features/specialists/domain/entities/selectable_specialists_result.dart';

void main() {
  test('always reports backend blocked', () async {
    const repository = BackendBlockedSelectableSpecialistsRepository();

    expect(
      await repository.listSelectableSpecialists(),
      isA<SelectableSpecialistsBackendBlocked>(),
    );
  });
}

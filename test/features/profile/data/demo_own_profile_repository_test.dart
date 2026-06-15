import 'package:flutter_test/flutter_test.dart';

import 'package:stasisly/features/profile/data/repositories/demo_own_profile_repository.dart';
import 'package:stasisly/features/profile/domain/entities/own_profile_results.dart';

void main() {
  test('demo profile is explicit and updates only local demo state', () async {
    final repository = DemoOwnProfileRepository();

    final initial = await repository.readOwnProfile();
    final updated = await repository.updateOwnDisplayName('  Demo Nuevo  ');

    expect(initial, isA<OwnProfileSuccess>());
    expect((initial as OwnProfileSuccess).profile.isDemo, isTrue);
    expect(updated, isA<UpdateOwnDisplayNameSuccess>());
    expect(
      (updated as UpdateOwnDisplayNameSuccess).profile.displayName,
      'Demo Nuevo',
    );
    expect(updated.profile.isDemo, isTrue);
  });
}

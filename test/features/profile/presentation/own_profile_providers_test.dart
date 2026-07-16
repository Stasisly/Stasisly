import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:stasisly/core/config/app_environment.dart';
import 'package:stasisly/features/profile/data/repositories/backend_blocked_own_profile_repository.dart';
import 'package:stasisly/features/profile/data/repositories/demo_own_profile_repository.dart';
import 'package:stasisly/features/profile/domain/entities/own_profile_results.dart';
import 'package:stasisly/features/profile/presentation/providers/own_profile_providers.dart';

void main() {
  test('demo mode cannot implicitly select a Product repository', () {
    final container = ProviderContainer(
      overrides: [
        appEnvironmentProvider.overrideWithValue(
          const AppEnvironment(mode: AppRuntimeMode.demo),
        ),
      ],
    );
    addTearDown(container.dispose);

    expect(
      container.read(ownProfileRepositoryProvider),
      isA<BackendBlockedOwnProfileRepository>(),
    );
  });

  test('explicit demo repository remains test-only and overrideable', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(
      container.read(demoOwnProfileRepositoryProvider),
      isA<DemoOwnProfileRepository>(),
    );
  });

  test('backend modes remain explicitly blocked', () async {
    final container = ProviderContainer(
      overrides: [
        appEnvironmentProvider.overrideWithValue(
          const AppEnvironment(mode: AppRuntimeMode.backendReal),
        ),
      ],
    );
    addTearDown(container.dispose);

    final repository = container.read(ownProfileRepositoryProvider);

    expect(repository, isA<BackendBlockedOwnProfileRepository>());
    expect(await repository.readOwnProfile(), isA<OwnProfileBackendBlocked>());
    expect(
      await repository.updateOwnDisplayName('Owner'),
      isA<UpdateOwnDisplayNameBackendBlocked>(),
    );
  });
}

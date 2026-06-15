import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:stasisly/core/config/app_environment.dart';
import 'package:stasisly/features/specialists/data/repositories/backend_blocked_selectable_specialists_repository.dart';
import 'package:stasisly/features/specialists/data/repositories/demo_selectable_specialists_repository.dart';
import 'package:stasisly/features/specialists/domain/entities/selectable_specialists_result.dart';
import 'package:stasisly/features/specialists/presentation/providers/selectable_specialists_providers.dart';

void main() {
  test('demo mode selects only the local demo catalog', () {
    final container = ProviderContainer(
      overrides: [
        appEnvironmentProvider.overrideWithValue(
          const AppEnvironment(mode: AppRuntimeMode.demo),
        ),
      ],
    );
    addTearDown(container.dispose);

    expect(
      container.read(selectableSpecialistsRepositoryProvider),
      isA<DemoSelectableSpecialistsRepository>(),
    );
  });

  test('backend real and production remain explicitly blocked', () async {
    for (final mode in [
      AppRuntimeMode.backendReal,
      AppRuntimeMode.production,
    ]) {
      final container = ProviderContainer(
        overrides: [
          appEnvironmentProvider.overrideWithValue(AppEnvironment(mode: mode)),
        ],
      );
      addTearDown(container.dispose);

      final repository = container.read(
        selectableSpecialistsRepositoryProvider,
      );
      expect(repository, isA<BackendBlockedSelectableSpecialistsRepository>());
      expect(
        await repository.listSelectableSpecialists(),
        isA<SelectableSpecialistsBackendBlocked>(),
      );
    }
  });
}

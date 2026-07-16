import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:stasisly/core/config/app_environment.dart';
import 'package:stasisly/features/specialists/data/repositories/backend_blocked_selectable_specialists_repository.dart';
import 'package:stasisly/features/specialists/data/repositories/demo_selectable_specialists_repository.dart';
import 'package:stasisly/features/specialists/domain/entities/selectable_specialists_result.dart';
import 'package:stasisly/features/specialists/presentation/providers/selectable_specialists_providers.dart';

void main() {
  test('demo mode cannot implicitly select a Product catalog', () {
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
      isA<BackendBlockedSelectableSpecialistsRepository>(),
    );
  });

  test('every non-demo runtime remains explicitly backend blocked', () async {
    for (final mode in [
      AppRuntimeMode.local,
      AppRuntimeMode.development,
      AppRuntimeMode.staging,
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

  test('provider boundary exposes no final authorization decision', () {
    final container = ProviderContainer(
      overrides: [
        appEnvironmentProvider.overrideWithValue(
          const AppEnvironment(mode: AppRuntimeMode.production),
        ),
      ],
    );
    addTearDown(container.dispose);

    final repository = container.read(selectableSpecialistsRepositoryProvider);

    expect(repository, isA<BackendBlockedSelectableSpecialistsRepository>());
    expect(repository, isNot(isA<DemoSelectableSpecialistsRepository>()));
  });
}

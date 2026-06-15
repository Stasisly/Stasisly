import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:stasisly/core/config/app_environment.dart';
import 'package:stasisly/features/specialists/data/repositories/backend_blocked_selectable_specialists_repository.dart';
import 'package:stasisly/features/specialists/data/repositories/demo_selectable_specialists_repository.dart';
import 'package:stasisly/features/specialists/domain/repositories/selectable_specialists_repository.dart';

final selectableSpecialistsRepositoryProvider =
    Provider<SelectableSpecialistsRepository>((ref) {
      final environment = ref.watch(appEnvironmentProvider);
      if (environment.isDemo) {
        return const DemoSelectableSpecialistsRepository();
      }

      // ADR-007: the future backend catalog remains disconnected.
      return const BackendBlockedSelectableSpecialistsRepository();
    });

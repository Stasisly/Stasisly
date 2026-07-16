import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:stasisly/core/auth/session/providers/secure_session_providers.dart';
import 'package:stasisly/core/authorization/domain/authorization_surface.dart';
import 'package:stasisly/core/authorization/infrastructure/app_environment_authorization_mapper.dart';
import 'package:stasisly/core/config/app_environment.dart';
import 'package:stasisly/core/routing/application/entry_point_boundary_enforcer.dart';
import 'package:stasisly/core/routing/infrastructure/entry_point_registry.dart';
import 'package:stasisly/features/specialists/data/repositories/backend_blocked_selectable_specialists_repository.dart';
import 'package:stasisly/features/specialists/domain/repositories/selectable_specialists_repository.dart';

final selectableSpecialistsRepositoryProvider =
    Provider<SelectableSpecialistsRepository>((ref) {
      final environment = ref.watch(appEnvironmentProvider);
      final session = ref.watch(secureSessionStateProvider);
      final decision = const EntryPointBoundaryEnforcer().evaluate(
        definition: EntryPointRegistry.specialistsCatalog,
        actualSurface: AuthorizationSurface.product,
        actualEnvironment: AppEnvironmentAuthorizationMapper.fromRuntimeMode(
          environment.mode,
        ),
        isAuthenticated: session.isAuthenticated,
        remotePermissionGranted: environment.allowsRemoteSupabase,
      );
      if (!decision.isAllowed) {
        return const BackendBlockedSelectableSpecialistsRepository();
      }

      // ADR-007: the future backend catalog remains disconnected.
      return const BackendBlockedSelectableSpecialistsRepository();
    });

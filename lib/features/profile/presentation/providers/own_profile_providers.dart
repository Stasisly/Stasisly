import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:stasisly/core/auth/session/providers/secure_session_providers.dart';
import 'package:stasisly/core/authorization/domain/authorization_surface.dart';
import 'package:stasisly/core/authorization/infrastructure/app_environment_authorization_mapper.dart';
import 'package:stasisly/core/config/app_environment.dart';
import 'package:stasisly/core/routing/application/entry_point_boundary_enforcer.dart';
import 'package:stasisly/core/routing/infrastructure/entry_point_registry.dart';
import 'package:stasisly/features/profile/data/repositories/backend_blocked_own_profile_repository.dart';
import 'package:stasisly/features/profile/data/repositories/demo_own_profile_repository.dart';
import 'package:stasisly/features/profile/domain/repositories/own_profile_repository.dart';

final ownProfileRepositoryProvider = Provider<OwnProfileRepository>((ref) {
  final environment = ref.watch(appEnvironmentProvider);
  final session = ref.watch(secureSessionStateProvider);
  final decision = const EntryPointBoundaryEnforcer().evaluate(
    definition: EntryPointRegistry.profileRead,
    actualSurface: AuthorizationSurface.product,
    actualEnvironment: AppEnvironmentAuthorizationMapper.fromRuntimeMode(
      environment.mode,
    ),
    isAuthenticated: session.isAuthenticated,
    remotePermissionGranted: environment.allowsRemoteSupabase,
    // The repository's OwnProfileReadAuthorizationGate remains authoritative.
    foundationPolicyAllowed: true,
  );
  if (!decision.isAllowed) return const BackendBlockedOwnProfileRepository();

  // ADR-006: no real adapter may be selected until backend activation is
  // approved independently.
  return const BackendBlockedOwnProfileRepository();
});

final demoOwnProfileRepositoryProvider = Provider<OwnProfileRepository>((ref) {
  return DemoOwnProfileRepository();
});

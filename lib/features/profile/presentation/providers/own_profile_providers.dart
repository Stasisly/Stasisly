import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:stasisly/core/config/app_environment.dart';
import 'package:stasisly/core/providers/current_identity_provider.dart';
import 'package:stasisly/features/profile/data/repositories/backend_blocked_own_profile_repository.dart';
import 'package:stasisly/features/profile/data/repositories/demo_own_profile_repository.dart';
import 'package:stasisly/features/profile/domain/repositories/own_profile_repository.dart';

final ownProfileRepositoryProvider = Provider<OwnProfileRepository>((ref) {
  final environment = ref.watch(appEnvironmentProvider);
  if (environment.isDemo) {
    final identity = ref.watch(currentIdentityProvider);
    return DemoOwnProfileRepository(demoId: identity.subjectId);
  }

  // ADR-006: no real adapter may be selected until backend activation is
  // approved independently.
  return const BackendBlockedOwnProfileRepository();
});

final demoOwnProfileRepositoryProvider = Provider<OwnProfileRepository>((ref) {
  return DemoOwnProfileRepository();
});

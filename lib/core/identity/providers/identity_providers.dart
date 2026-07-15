import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:stasisly/core/config/app_environment.dart';
import 'package:stasisly/core/identity/infrastructure/environment_blocked_identity_provider.dart';
import 'package:stasisly/core/identity/infrastructure/supabase_identity_provider.dart';
import 'package:stasisly/core/identity/ports/identity_provider.dart';

final identityProviderProvider = Provider<IdentityProvider>((ref) {
  final environment = ref.watch(appEnvironmentProvider);
  if (!environment.allowsRealAuth) {
    return const EnvironmentBlockedIdentityProvider();
  }
  return ref.watch(supabaseIdentityProviderAdapterProvider);
});

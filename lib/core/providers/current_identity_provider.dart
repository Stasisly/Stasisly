import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:stasisly/core/config/app_environment.dart';
import 'package:stasisly/core/domain/entities/current_identity.dart';

/// Provides the only identity that application features may consume directly.
///
/// Authenticated identity remains blocked until a later approved package.
final currentIdentityProvider = Provider<CurrentIdentity>((ref) {
  final environment = ref.watch(appEnvironmentProvider);
  if (environment.isDemo) return const CurrentIdentity.demo();

  throw const AppConfigurationException(
    'Identidad autenticada bloqueada hasta restaurar auth de forma aprobada.',
  );
});

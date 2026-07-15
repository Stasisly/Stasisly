import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:stasisly/core/auth/session/providers/secure_session_providers.dart';
import 'package:stasisly/core/config/app_environment.dart';
import 'package:stasisly/core/domain/entities/current_identity.dart';
import 'package:stasisly/core/identity/domain/authentication_state.dart';
import 'package:stasisly/core/identity/domain/identity_type.dart';
import 'package:stasisly/core/identity/domain/stasisly_identity.dart';

/// Provides the only identity that application features may consume directly.
///
/// Authenticated identity remains blocked until a later approved package.
final currentIdentityProvider = Provider<StasislyIdentity>((ref) {
  final environment = ref.watch(appEnvironmentProvider);
  if (environment.isDemo) return const CurrentIdentity.demo();

  final session = ref.watch(secureSessionStateProvider).authState;
  if (session.isAuthenticated && session.subjectId != null) {
    return StasislyIdentity(
      subjectId: session.subjectId!,
      identityType: IdentityType.humanUser,
      authenticationState: AuthenticationState.authenticated,
      email: session.email,
    );
  }

  throw const AppConfigurationException(
    'Identidad autenticada no disponible en el estado de sesión actual.',
  );
});

import 'package:equatable/equatable.dart';

import 'package:stasisly/core/identity/domain/authentication_state.dart';
import 'package:stasisly/core/identity/domain/identity_type.dart';
import 'package:stasisly/core/identity/domain/stasisly_session.dart';

enum ApiEnvironmentContext { local, demo, development, staging, production }

class ApiIdentityContext extends Equatable {
  ApiIdentityContext({
    required String subjectId,
    required this.identityType,
    required this.authenticationState,
    required this.environment,
    required String correlationReference,
    String? sessionReference,
  }) : subjectId = _required(subjectId, 'subjectId'),
       correlationReference = _required(
         correlationReference,
         'correlationReference',
       ),
       sessionReference = _optional(sessionReference) {
    if (authenticationState != AuthenticationState.authenticated) {
      throw ArgumentError.value(
        authenticationState,
        'authenticationState',
        'API identity context requires an authenticated state.',
      );
    }
  }

  factory ApiIdentityContext.fromSession({
    required StasislySession session,
    required ApiEnvironmentContext environment,
    required String correlationReference,
  }) {
    final identity = session.identity;
    if (!session.isAuthenticated || identity == null) {
      throw const StasislyApiIdentityContextException();
    }
    return ApiIdentityContext(
      subjectId: identity.subjectId,
      identityType: identity.identityType,
      authenticationState: session.state,
      sessionReference: session.sessionReference,
      environment: environment,
      correlationReference: correlationReference,
    );
  }

  final String subjectId;
  final IdentityType identityType;
  final AuthenticationState authenticationState;
  final String? sessionReference;
  final ApiEnvironmentContext environment;
  final String correlationReference;

  @override
  List<Object?> get props => [
    subjectId,
    identityType,
    authenticationState,
    sessionReference,
    environment,
    correlationReference,
  ];
}

class StasislyApiIdentityContextException implements Exception {
  const StasislyApiIdentityContextException();

  @override
  String toString() => 'Authenticated request context is unavailable.';
}

String _required(String value, String name) {
  final normalized = value.trim();
  if (normalized.isEmpty) {
    throw ArgumentError.value(value, name, '$name must not be empty.');
  }
  return normalized;
}

String? _optional(String? value) {
  final normalized = value?.trim();
  return normalized == null || normalized.isEmpty ? null : normalized;
}

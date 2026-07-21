import 'package:equatable/equatable.dart';

import 'package:stasisly/core/authorization/domain/authorization_environment.dart';
import 'package:stasisly/core/authorization/domain/authorization_surface.dart';
import 'package:stasisly/core/routing/domain/entry_point_context.dart';

class EntryPointDefinition extends Equatable {
  const EntryPointDefinition({
    required this.id,
    required this.pathPattern,
    required this.surface,
    required this.allowedEnvironments,
    required this.authenticationRequirement,
    required this.authorizationRequirement,
    required this.legacyState,
    this.resourceType = EntryPointResourceType.unspecified,
    this.entryPointClassification = EntryPointClassification.unspecified,
    this.backendAuthorityRequired = false,
    this.requiresRuntimeEnablement = false,
  });

  final EntryPointId id;
  final String pathPattern;
  final AuthorizationSurface surface;
  final Set<AuthorizationEnvironment> allowedEnvironments;
  final EntryPointAuthenticationRequirement authenticationRequirement;
  final EntryPointAuthorizationRequirement authorizationRequirement;
  final EntryPointLegacyState legacyState;
  final EntryPointResourceType resourceType;
  final EntryPointClassification entryPointClassification;
  final bool backendAuthorityRequired;
  final bool requiresRuntimeEnablement;

  @override
  List<Object?> get props => [
    id,
    pathPattern,
    surface,
    allowedEnvironments,
    authenticationRequirement,
    authorizationRequirement,
    legacyState,
    resourceType,
    entryPointClassification,
    backendAuthorityRequired,
    requiresRuntimeEnablement,
  ];
}

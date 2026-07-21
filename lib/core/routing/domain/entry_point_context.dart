import 'package:equatable/equatable.dart';

import 'package:stasisly/core/authorization/domain/authorization_environment.dart';
import 'package:stasisly/core/authorization/domain/authorization_surface.dart';

enum EntryPointId {
  onboarding,
  login,
  register,
  stasis,
  conversations,
  conversationDetail,
  health,
  nutrition,
  physicalTraining,
  mentalTraining,
  profileRead,
  specialistsCatalog,
  legacyOrchestrator,
  legacyOrchestratorChat,
  developmentChatComposed,
  developmentChatSession,
  administration,
  platformInternal,
  sharedInfrastructure,
  unknown,
}

enum EntryPointResourceType {
  unspecified,
  productEntry,
  conversationCollection,
  conversation,
}

enum EntryPointClassification { unspecified, canonicalProduct }

enum EntryPointAuthenticationRequirement { public, authenticated }

enum EntryPointAuthorizationRequirement { none, foundationPolicy }

enum EntryPointLegacyState {
  current,
  developmentOnly,
  legacyBlocked,
  notAvailable,
  unknown,
}

class EntryPointContext extends Equatable {
  const EntryPointContext({
    required this.surface,
    required this.environment,
    required this.entryPointId,
    required this.authenticationRequirement,
    required this.authorizationRequirement,
    required this.legacyState,
    required this.correlationId,
  });

  final AuthorizationSurface surface;
  final AuthorizationEnvironment environment;
  final EntryPointId entryPointId;
  final EntryPointAuthenticationRequirement authenticationRequirement;
  final EntryPointAuthorizationRequirement authorizationRequirement;
  final EntryPointLegacyState legacyState;
  final String correlationId;

  @override
  List<Object?> get props => [
    surface,
    environment,
    entryPointId,
    authenticationRequirement,
    authorizationRequirement,
    legacyState,
    correlationId,
  ];
}

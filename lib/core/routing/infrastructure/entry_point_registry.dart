import 'package:stasisly/core/authorization/domain/authorization_environment.dart';
import 'package:stasisly/core/authorization/domain/authorization_surface.dart';
import 'package:stasisly/core/routing/domain/entry_point_context.dart';
import 'package:stasisly/core/routing/domain/entry_point_definition.dart';

abstract final class EntryPointRegistry {
  static const _productEnvironments = {
    AuthorizationEnvironment.local,
    AuthorizationEnvironment.development,
  };
  static const _authenticationEnvironments = {
    AuthorizationEnvironment.local,
    AuthorizationEnvironment.demo,
    AuthorizationEnvironment.development,
    AuthorizationEnvironment.staging,
    AuthorizationEnvironment.production,
  };
  static const _developmentEnvironments = {
    AuthorizationEnvironment.local,
    AuthorizationEnvironment.development,
  };

  static const onboarding = EntryPointDefinition(
    id: EntryPointId.onboarding,
    pathPattern: '/onboarding',
    surface: AuthorizationSurface.product,
    allowedEnvironments: _authenticationEnvironments,
    authenticationRequirement: EntryPointAuthenticationRequirement.public,
    authorizationRequirement: EntryPointAuthorizationRequirement.none,
    legacyState: EntryPointLegacyState.current,
  );
  static const login = EntryPointDefinition(
    id: EntryPointId.login,
    pathPattern: '/login',
    surface: AuthorizationSurface.product,
    allowedEnvironments: _authenticationEnvironments,
    authenticationRequirement: EntryPointAuthenticationRequirement.public,
    authorizationRequirement: EntryPointAuthorizationRequirement.none,
    legacyState: EntryPointLegacyState.current,
  );
  static const register = EntryPointDefinition(
    id: EntryPointId.register,
    pathPattern: '/register',
    surface: AuthorizationSurface.product,
    allowedEnvironments: _authenticationEnvironments,
    authenticationRequirement: EntryPointAuthenticationRequirement.public,
    authorizationRequirement: EntryPointAuthorizationRequirement.none,
    legacyState: EntryPointLegacyState.current,
  );
  static const health = EntryPointDefinition(
    id: EntryPointId.health,
    pathPattern: '/health',
    surface: AuthorizationSurface.product,
    allowedEnvironments: _productEnvironments,
    authenticationRequirement:
        EntryPointAuthenticationRequirement.authenticated,
    authorizationRequirement: EntryPointAuthorizationRequirement.none,
    legacyState: EntryPointLegacyState.current,
  );
  static const nutrition = EntryPointDefinition(
    id: EntryPointId.nutrition,
    pathPattern: '/nutrition',
    surface: AuthorizationSurface.product,
    allowedEnvironments: _productEnvironments,
    authenticationRequirement:
        EntryPointAuthenticationRequirement.authenticated,
    authorizationRequirement: EntryPointAuthorizationRequirement.none,
    legacyState: EntryPointLegacyState.current,
  );
  static const physicalTraining = EntryPointDefinition(
    id: EntryPointId.physicalTraining,
    pathPattern: '/physical',
    surface: AuthorizationSurface.product,
    allowedEnvironments: _productEnvironments,
    authenticationRequirement:
        EntryPointAuthenticationRequirement.authenticated,
    authorizationRequirement: EntryPointAuthorizationRequirement.none,
    legacyState: EntryPointLegacyState.current,
  );
  static const mentalTraining = EntryPointDefinition(
    id: EntryPointId.mentalTraining,
    pathPattern: '/mental',
    surface: AuthorizationSurface.product,
    allowedEnvironments: _productEnvironments,
    authenticationRequirement:
        EntryPointAuthenticationRequirement.authenticated,
    authorizationRequirement: EntryPointAuthorizationRequirement.none,
    legacyState: EntryPointLegacyState.current,
  );
  static const profileRead = EntryPointDefinition(
    id: EntryPointId.profileRead,
    pathPattern: 'repository:own-profile-read',
    surface: AuthorizationSurface.product,
    allowedEnvironments: _productEnvironments,
    authenticationRequirement:
        EntryPointAuthenticationRequirement.authenticated,
    authorizationRequirement:
        EntryPointAuthorizationRequirement.foundationPolicy,
    legacyState: EntryPointLegacyState.current,
    backendAuthorityRequired: true,
  );
  static const specialistsCatalog = EntryPointDefinition(
    id: EntryPointId.specialistsCatalog,
    pathPattern: 'repository:selectable-specialists',
    surface: AuthorizationSurface.product,
    allowedEnvironments: _productEnvironments,
    authenticationRequirement:
        EntryPointAuthenticationRequirement.authenticated,
    authorizationRequirement: EntryPointAuthorizationRequirement.none,
    legacyState: EntryPointLegacyState.current,
    backendAuthorityRequired: true,
  );
  static const legacyAgentChat = EntryPointDefinition(
    id: EntryPointId.legacyAgentChat,
    pathPattern: '/chat/:id',
    surface: AuthorizationSurface.unknown,
    allowedEnvironments: <AuthorizationEnvironment>{},
    authenticationRequirement:
        EntryPointAuthenticationRequirement.authenticated,
    authorizationRequirement: EntryPointAuthorizationRequirement.none,
    legacyState: EntryPointLegacyState.legacyBlocked,
  );
  static const legacyOrchestrator = EntryPointDefinition(
    id: EntryPointId.legacyOrchestrator,
    pathPattern: '/orchestrator',
    surface: AuthorizationSurface.development,
    allowedEnvironments: _developmentEnvironments,
    authenticationRequirement:
        EntryPointAuthenticationRequirement.authenticated,
    authorizationRequirement: EntryPointAuthorizationRequirement.none,
    legacyState: EntryPointLegacyState.legacyBlocked,
  );
  static const legacyOrchestratorChat = EntryPointDefinition(
    id: EntryPointId.legacyOrchestratorChat,
    pathPattern: '/orchestrator/chat',
    surface: AuthorizationSurface.development,
    allowedEnvironments: _developmentEnvironments,
    authenticationRequirement:
        EntryPointAuthenticationRequirement.authenticated,
    authorizationRequirement: EntryPointAuthorizationRequirement.none,
    legacyState: EntryPointLegacyState.legacyBlocked,
  );
  static const developmentChatComposed = EntryPointDefinition(
    id: EntryPointId.developmentChatComposed,
    pathPattern: '/dev/chat/composed',
    surface: AuthorizationSurface.development,
    allowedEnvironments: _developmentEnvironments,
    authenticationRequirement: EntryPointAuthenticationRequirement.public,
    authorizationRequirement: EntryPointAuthorizationRequirement.none,
    legacyState: EntryPointLegacyState.developmentOnly,
    backendAuthorityRequired: true,
    requiresRuntimeEnablement: true,
  );
  static const developmentChatSession = EntryPointDefinition(
    id: EntryPointId.developmentChatSession,
    pathPattern: '/dev/chat/session/:sessionId',
    surface: AuthorizationSurface.development,
    allowedEnvironments: _developmentEnvironments,
    authenticationRequirement: EntryPointAuthenticationRequirement.public,
    authorizationRequirement: EntryPointAuthorizationRequirement.none,
    legacyState: EntryPointLegacyState.developmentOnly,
    backendAuthorityRequired: true,
    requiresRuntimeEnablement: true,
  );

  static const registeredRoutes = [
    onboarding,
    login,
    register,
    health,
    nutrition,
    physicalTraining,
    mentalTraining,
    legacyOrchestrator,
    legacyOrchestratorChat,
    legacyAgentChat,
    developmentChatComposed,
    developmentChatSession,
  ];

  static EntryPointDefinition? resolvePath(String path) {
    for (final definition in registeredRoutes) {
      if (_matches(definition.pathPattern, path)) return definition;
    }
    return null;
  }

  static bool _matches(String pattern, String path) {
    final expected = pattern.split('/');
    final actual = path.split('/');
    if (expected.length != actual.length) return false;
    for (var index = 0; index < expected.length; index++) {
      if (expected[index].startsWith(':')) {
        if (actual[index].isEmpty) return false;
      } else if (expected[index] != actual[index]) {
        return false;
      }
    }
    return true;
  }
}

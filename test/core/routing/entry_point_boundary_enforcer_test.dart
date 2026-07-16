import 'package:flutter_test/flutter_test.dart';

import 'package:stasisly/core/authorization/domain/authorization_environment.dart';
import 'package:stasisly/core/authorization/domain/authorization_surface.dart';
import 'package:stasisly/core/authorization/infrastructure/app_environment_authorization_mapper.dart';
import 'package:stasisly/core/config/app_environment.dart';
import 'package:stasisly/core/routing/application/entry_point_boundary_enforcer.dart';
import 'package:stasisly/core/routing/domain/boundary_decision.dart';
import 'package:stasisly/core/routing/domain/entry_point_context.dart';
import 'package:stasisly/core/routing/domain/entry_point_definition.dart';
import 'package:stasisly/core/routing/infrastructure/entry_point_registry.dart';

void main() {
  const enforcer = EntryPointBoundaryEnforcer();

  BoundaryDecision evaluate(
    EntryPointDefinition? definition, {
    AuthorizationSurface? actualSurface,
    AuthorizationEnvironment environment = AuthorizationEnvironment.local,
    bool authenticated = true,
    bool runtimeEnabled = true,
    bool? policyAllowed,
  }) {
    return enforcer.evaluate(
      definition: definition,
      actualSurface:
          actualSurface ?? definition?.surface ?? AuthorizationSurface.unknown,
      actualEnvironment: environment,
      isAuthenticated: authenticated,
      remotePermissionGranted: runtimeEnabled,
      foundationPolicyAllowed: policyAllowed,
    );
  }

  group('approved boundaries', () {
    test('Product routes allow local and development when authenticated', () {
      for (final environment in [
        AuthorizationEnvironment.local,
        AuthorizationEnvironment.development,
      ]) {
        expect(
          evaluate(EntryPointRegistry.health, environment: environment).type,
          BoundaryDecisionType.allow,
        );
      }
    });

    test('Development routes allow only local and development', () {
      for (final environment in [
        AuthorizationEnvironment.local,
        AuthorizationEnvironment.development,
      ]) {
        expect(
          evaluate(
            EntryPointRegistry.developmentChatSession,
            environment: environment,
          ).type,
          BoundaryDecisionType.allow,
        );
      }
      for (final environment in [
        AuthorizationEnvironment.staging,
        AuthorizationEnvironment.production,
      ]) {
        expect(
          evaluate(
            EntryPointRegistry.developmentChatSession,
            environment: environment,
          ).type,
          BoundaryDecisionType.blockedByEnvironment,
        );
      }
    });

    test('public authentication entry is allowed without a session', () {
      expect(
        evaluate(EntryPointRegistry.login, authenticated: false).type,
        BoundaryDecisionType.allow,
      );
    });

    test('protected Product entry redirects without a session', () {
      expect(
        evaluate(EntryPointRegistry.health, authenticated: false).type,
        BoundaryDecisionType.redirectToAuthentication,
      );
    });
  });

  group('fail-closed boundaries', () {
    test('surface mismatch is denied in both directions', () {
      expect(
        evaluate(
          EntryPointRegistry.health,
          actualSurface: AuthorizationSurface.development,
        ).type,
        BoundaryDecisionType.blockedBySurface,
      );
      expect(
        evaluate(
          EntryPointRegistry.developmentChatComposed,
          actualSurface: AuthorizationSurface.product,
        ).type,
        BoundaryDecisionType.blockedBySurface,
      );
    });

    test('unknown surface, environment and missing metadata deny', () {
      expect(
        evaluate(
          EntryPointRegistry.health,
          actualSurface: AuthorizationSurface.unknown,
        ).reasonCode,
        BoundaryReasonCode.unknownSurface,
      );
      expect(
        evaluate(
          EntryPointRegistry.health,
          environment: AuthorizationEnvironment.unknown,
        ).reasonCode,
        BoundaryReasonCode.unknownEnvironment,
      );
      expect(evaluate(null).type, BoundaryDecisionType.deny);
    });

    test('backendReal maps to unknown and cannot authorize', () {
      final environment = AppEnvironmentAuthorizationMapper.fromRuntimeMode(
        AppRuntimeMode.backendReal,
      );
      expect(environment, AuthorizationEnvironment.unknown);
      expect(
        evaluate(EntryPointRegistry.health, environment: environment).isAllowed,
        isFalse,
      );
    });

    test('runtime-disabled Development capability remains blocked', () {
      expect(
        evaluate(
          EntryPointRegistry.developmentChatComposed,
          runtimeEnabled: false,
        ).type,
        BoundaryDecisionType.blockedByEnvironment,
      );
    });

    test('legacy chat and orchestrator remain blocked', () {
      expect(
        evaluate(EntryPointRegistry.legacyAgentChat).type,
        BoundaryDecisionType.legacyBlocked,
      );
      expect(
        evaluate(
          EntryPointRegistry.legacyOrchestrator,
          actualSurface: AuthorizationSurface.product,
        ).type,
        BoundaryDecisionType.legacyBlocked,
      );
    });

    test(
      'Administration, Platform and Shared Infrastructure are unavailable',
      () {
        for (final surface in [
          AuthorizationSurface.administration,
          AuthorizationSurface.platform,
          AuthorizationSurface.sharedInfrastructure,
        ]) {
          final definition = EntryPointDefinition(
            id: switch (surface) {
              AuthorizationSurface.administration =>
                EntryPointId.administration,
              AuthorizationSurface.platform => EntryPointId.platformInternal,
              _ => EntryPointId.sharedInfrastructure,
            },
            pathPattern: 'internal:${surface.name}',
            surface: surface,
            allowedEnvironments: const {AuthorizationEnvironment.local},
            authenticationRequirement:
                EntryPointAuthenticationRequirement.authenticated,
            authorizationRequirement: EntryPointAuthorizationRequirement.none,
            legacyState: EntryPointLegacyState.notAvailable,
          );
          expect(evaluate(definition).type, BoundaryDecisionType.notAvailable);
        }
      },
    );

    test('a required Foundation policy must explicitly allow', () {
      expect(
        evaluate(EntryPointRegistry.profileRead).reasonCode,
        BoundaryReasonCode.policyDenied,
      );
      expect(
        evaluate(EntryPointRegistry.profileRead, policyAllowed: true).type,
        BoundaryDecisionType.allow,
      );
    });
  });
}

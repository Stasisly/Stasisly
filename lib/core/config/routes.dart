import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:stasisly/core/auth/session/providers/secure_session_providers.dart';
import 'package:stasisly/core/authorization/domain/authorization_surface.dart';
import 'package:stasisly/core/authorization/infrastructure/app_environment_authorization_mapper.dart';
import 'package:stasisly/core/authorization/infrastructure/no_op_authorization_audit_sink.dart';
import 'package:stasisly/core/config/app_environment.dart';
import 'package:stasisly/core/routing/application/boundary_audit_recorder.dart';
import 'package:stasisly/core/routing/application/entry_point_boundary_enforcer.dart';
import 'package:stasisly/core/routing/domain/boundary_decision.dart';
import 'package:stasisly/core/routing/domain/entry_point_context.dart';
import 'package:stasisly/core/routing/domain/entry_point_definition.dart';
import 'package:stasisly/core/routing/infrastructure/entry_point_registry.dart';
import 'package:stasisly/core/routing/presentation/entry_point_boundary_gate.dart';
import 'package:stasisly/core/widgets/app_shell.dart';
import 'package:stasisly/features/auth/presentation/pages/login_page.dart';
import 'package:stasisly/features/auth/presentation/pages/onboarding_page.dart';
import 'package:stasisly/features/auth/presentation/pages/register_page.dart';
import 'package:stasisly/features/chat_messages/presentation/shell/own_chat_composed_safe_shell.dart';
import 'package:stasisly/features/chat_messages/presentation/shell/own_chat_messages_route_params_adapter.dart';
import 'package:stasisly/features/chat_messages/presentation/shell/own_chat_messages_safe_shell.dart';
import 'package:stasisly/features/conversations/product/presentation/conversation_page.dart';
import 'package:stasisly/features/conversations/product/presentation/conversations_page.dart';
import 'package:stasisly/features/conversations/product/presentation/stasis_page.dart';
import 'package:stasisly/features/conversations/product/routing/conversation_route_params_adapter.dart';
import 'package:stasisly/features/health/presentation/pages/health_page.dart';
import 'package:stasisly/features/mental_training/presentation/pages/mental_training_page.dart';
import 'package:stasisly/features/nutrition/presentation/pages/nutrition_page.dart';
import 'package:stasisly/features/physical_training/presentation/pages/physical_training_page.dart';

const _boundaryEnforcer = EntryPointBoundaryEnforcer();
const _boundaryAuditRecorder = BoundaryAuditRecorder(
  LocalNoOpAuthorizationAuditSink(),
);

/// Provides the router with explicit Foundation metadata for every entry point.
final routerProvider = Provider<GoRouter>((ref) {
  final environment = ref.watch(appEnvironmentProvider);
  final isAuthenticated = ref.watch(secureSessionStateProvider).isAuthenticated;

  return GoRouter(
    initialLocation: '/stasis',
    redirect: (context, state) {
      final definition = EntryPointRegistry.resolvePath(state.uri.path);
      final decision = _evaluateBoundary(
        definition: definition,
        environment: environment,
        isAuthenticated: isAuthenticated,
      );
      _recordBoundary(definition, environment, decision);

      if (decision.type == BoundaryDecisionType.redirectToAuthentication &&
          state.uri.path != EntryPointRegistry.onboarding.pathPattern) {
        return EntryPointRegistry.onboarding.pathPattern;
      }
      if (isAuthenticated &&
          definition?.surface == AuthorizationSurface.product &&
          definition?.authenticationRequirement ==
              EntryPointAuthenticationRequirement.public) {
        return EntryPointRegistry.stasis.pathPattern;
      }
      return null;
    },
    errorBuilder: (context, state) => const EntryPointBoundaryGate(
      decision: BoundaryDecision(
        type: BoundaryDecisionType.notAvailable,
        reasonCode: BoundaryReasonCode.unknownEntryPoint,
        auditRequired: true,
        safeUserMessageKey: BoundarySafeUserMessageKey.notAvailable,
      ),
      childBuilder: _emptyBoundaryChild,
    ),
    routes: [
      _route(
        definition: EntryPointRegistry.onboarding,
        environment: environment,
        isAuthenticated: isAuthenticated,
        childBuilder: (context, state) => const OnboardingPage(),
      ),
      _route(
        definition: EntryPointRegistry.login,
        environment: environment,
        isAuthenticated: isAuthenticated,
        childBuilder: (context, state) => const LoginPage(),
      ),
      _route(
        definition: EntryPointRegistry.register,
        environment: environment,
        isAuthenticated: isAuthenticated,
        childBuilder: (context, state) => const RegisterPage(),
      ),
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          _route(
            definition: EntryPointRegistry.stasis,
            environment: environment,
            isAuthenticated: isAuthenticated,
            childBuilder: (context, state) => const StasisPage(),
          ),
          _route(
            definition: EntryPointRegistry.conversations,
            environment: environment,
            isAuthenticated: isAuthenticated,
            childBuilder: (context, state) => const ConversationsPage(),
          ),
          _route(
            definition: EntryPointRegistry.conversationDetail,
            environment: environment,
            isAuthenticated: isAuthenticated,
            childBuilder: (context, state) => ConversationPage(
              conversationId: const ConversationRouteParamsAdapter()
                  .conversationIdFrom(state.pathParameters),
            ),
          ),
          _route(
            definition: EntryPointRegistry.health,
            environment: environment,
            isAuthenticated: isAuthenticated,
            childBuilder: (context, state) => const HealthPage(),
          ),
          _route(
            definition: EntryPointRegistry.nutrition,
            environment: environment,
            isAuthenticated: isAuthenticated,
            childBuilder: (context, state) => const NutritionPage(),
          ),
          _route(
            definition: EntryPointRegistry.physicalTraining,
            environment: environment,
            isAuthenticated: isAuthenticated,
            childBuilder: (context, state) => const PhysicalTrainingPage(),
          ),
          _route(
            definition: EntryPointRegistry.mentalTraining,
            environment: environment,
            isAuthenticated: isAuthenticated,
            childBuilder: (context, state) => const MentalTrainingPage(),
          ),
        ],
      ),
      _blockedLegacyRoute(
        definition: EntryPointRegistry.legacyOrchestrator,
        environment: environment,
        isAuthenticated: isAuthenticated,
      ),
      _blockedLegacyRoute(
        definition: EntryPointRegistry.legacyOrchestratorChat,
        environment: environment,
        isAuthenticated: isAuthenticated,
      ),
      _blockedLegacyRoute(
        definition: EntryPointRegistry.legacyAgentChat,
        environment: environment,
        isAuthenticated: isAuthenticated,
      ),
      ..._developmentChatMessageRoutes(
        environment,
        isAuthenticated: isAuthenticated,
      ),
    ],
  );
});

GoRoute _route({
  required EntryPointDefinition definition,
  required AppEnvironment environment,
  required bool isAuthenticated,
  required Widget Function(BuildContext, GoRouterState) childBuilder,
}) {
  return GoRoute(
    path: definition.pathPattern,
    builder: (context, state) {
      final decision = _evaluateBoundary(
        definition: definition,
        environment: environment,
        isAuthenticated: isAuthenticated,
      );
      _recordBoundary(definition, environment, decision);
      return EntryPointBoundaryGate(
        decision: decision,
        childBuilder: (context) => childBuilder(context, state),
      );
    },
  );
}

GoRoute _blockedLegacyRoute({
  required EntryPointDefinition definition,
  required AppEnvironment environment,
  required bool isAuthenticated,
}) {
  return _route(
    definition: definition,
    environment: environment,
    isAuthenticated: isAuthenticated,
    childBuilder: _emptyRouteChild,
  );
}

List<RouteBase> _developmentChatMessageRoutes(
  AppEnvironment environment, {
  required bool isAuthenticated,
}) {
  if (kReleaseMode) return const [];

  return [
    _route(
      definition: EntryPointRegistry.developmentChatComposed,
      environment: environment,
      isAuthenticated: isAuthenticated,
      childBuilder: (context, state) => Scaffold(
        body: OwnChatComposedSafeShell(
          onOpenSession: (sessionId) =>
              context.go('/dev/chat/session/$sessionId'),
        ),
      ),
    ),
    _route(
      definition: EntryPointRegistry.developmentChatSession,
      environment: environment,
      isAuthenticated: isAuthenticated,
      childBuilder: (context, state) {
        final sessionId = const OwnChatMessagesRouteParamsAdapter()
            .sessionIdFrom(state.pathParameters);
        return Scaffold(
          body: OwnChatMessagesSafeShell(sessionId: sessionId ?? ''),
        );
      },
    ),
  ];
}

BoundaryDecision _evaluateBoundary({
  required EntryPointDefinition? definition,
  required AppEnvironment environment,
  required bool isAuthenticated,
}) {
  return _boundaryEnforcer.evaluate(
    definition: definition,
    actualSurface: definition?.surface ?? AuthorizationSurface.unknown,
    actualEnvironment: AppEnvironmentAuthorizationMapper.fromRuntimeMode(
      environment.mode,
    ),
    isAuthenticated: isAuthenticated,
    remotePermissionGranted: environment.allowsDevRoutes,
  );
}

void _recordBoundary(
  EntryPointDefinition? definition,
  AppEnvironment environment,
  BoundaryDecision decision,
) {
  if (definition == null || !decision.auditRequired) return;
  final authorizationEnvironment =
      AppEnvironmentAuthorizationMapper.fromRuntimeMode(environment.mode);
  unawaited(
    _boundaryAuditRecorder.recordIfRequired(
      EntryPointContext(
        surface: definition.surface,
        environment: authorizationEnvironment,
        entryPointId: definition.id,
        authenticationRequirement: definition.authenticationRequirement,
        authorizationRequirement: definition.authorizationRequirement,
        legacyState: definition.legacyState,
        correlationId:
            'route-${definition.id.name}-${DateTime.now().microsecondsSinceEpoch}',
      ),
      decision,
    ),
  );
}

Widget _emptyRouteChild(BuildContext context, GoRouterState state) {
  return const SizedBox.shrink();
}

Widget _emptyBoundaryChild(BuildContext context) {
  return const SizedBox.shrink();
}

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:stasisly/core/authorization/domain/authorization_environment.dart';
import 'package:stasisly/core/authorization/domain/authorization_surface.dart';
import 'package:stasisly/core/routing/application/entry_point_boundary_enforcer.dart';
import 'package:stasisly/core/routing/domain/boundary_decision.dart';
import 'package:stasisly/core/routing/domain/entry_point_context.dart';
import 'package:stasisly/core/routing/infrastructure/entry_point_registry.dart';
import 'package:stasisly/features/conversations/product/routing/conversation_route_params_adapter.dart';

void main() {
  const enforcer = EntryPointBoundaryEnforcer();
  final canonical = [
    EntryPointRegistry.stasis,
    EntryPointRegistry.conversations,
    EntryPointRegistry.conversationDetail,
  ];

  test('canonical routes have explicit Product metadata', () {
    expect(canonical.map((entry) => entry.pathPattern), [
      '/stasis',
      '/conversations',
      '/conversations/:conversationId',
    ]);
    for (final entry in canonical) {
      expect(entry.surface, AuthorizationSurface.product);
      expect(
        entry.authenticationRequirement,
        EntryPointAuthenticationRequirement.authenticated,
      );
      expect(
        entry.entryPointClassification,
        EntryPointClassification.canonicalProduct,
      );
      expect(entry.legacyState, EntryPointLegacyState.current);
      expect(entry.allowedEnvironments, {
        AuthorizationEnvironment.local,
        AuthorizationEnvironment.development,
      });
      expect(entry.resourceType, isNot(EntryPointResourceType.unspecified));
    }
  });

  test('canonical routes allow only local and development', () {
    for (final definition in canonical) {
      for (final environment in [
        AuthorizationEnvironment.local,
        AuthorizationEnvironment.development,
      ]) {
        expect(
          enforcer
              .evaluate(
                definition: definition,
                actualSurface: AuthorizationSurface.product,
                actualEnvironment: environment,
                isAuthenticated: true,
                remotePermissionGranted: true,
              )
              .isAllowed,
          isTrue,
        );
      }
      for (final environment in [
        AuthorizationEnvironment.staging,
        AuthorizationEnvironment.production,
        AuthorizationEnvironment.unknown,
      ]) {
        expect(
          enforcer
              .evaluate(
                definition: definition,
                actualSurface: AuthorizationSurface.product,
                actualEnvironment: environment,
                isAuthenticated: true,
                remotePermissionGranted: false,
              )
              .type,
          isNot(BoundaryDecisionType.allow),
        );
      }
    }
  });

  test('conversation route adapter accepts conversationId only', () {
    const adapter = ConversationRouteParamsAdapter();
    expect(
      adapter.conversationIdFrom({'conversationId': 'conversation-safe'}),
      isNotNull,
    );
    expect(adapter.conversationIdFrom({'id': 'legacy'}), isNull);
    expect(adapter.conversationIdFrom({'agentId': 'legacy'}), isNull);
    expect(adapter.conversationIdFrom({'sessionId': 'legacy'}), isNull);
    expect(
      adapter.conversationIdFrom({
        'conversationId': 'conversation-safe',
        'ownerSubjectId': 'forbidden',
      }),
      isNull,
    );
  });

  test('active router contains no authority extras or legacy fallback', () {
    final source = File('lib/core/config/routes.dart').readAsStringSync();
    final productSources = Directory('lib/features/conversations/product')
        .listSync(recursive: true)
        .whereType<File>()
        .map((file) => file.readAsStringSync());

    expect(source, contains("initialLocation: '/stasis'"));
    expect(source, isNot(contains('InactiveConversationFeatureHost')));
    expect(source, isNot(contains('OrchestratorChatPage')));
    for (final productSource in productSources) {
      for (final forbidden in [
        'features/chat/',
        'package:dio/',
        'package:http/',
        'supabase_flutter',
        'ownerSubjectId',
        'agentId',
        'sessionId',
        'role:',
        'StasisEngine',
      ]) {
        expect(productSource, isNot(contains(forbidden)), reason: forbidden);
      }
    }
  });
}

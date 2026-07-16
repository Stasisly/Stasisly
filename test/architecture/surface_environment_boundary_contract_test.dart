import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:stasisly/core/authorization/domain/authorization_environment.dart';
import 'package:stasisly/core/authorization/domain/authorization_surface.dart';
import 'package:stasisly/core/routing/domain/entry_point_context.dart';
import 'package:stasisly/core/routing/infrastructure/entry_point_registry.dart';

void main() {
  test('every registered route has explicit non-empty metadata', () {
    for (final route in EntryPointRegistry.registeredRoutes) {
      expect(route.id, isNot(EntryPointId.unknown));
      expect(route.pathPattern, isNotEmpty);
      if (route.legacyState != EntryPointLegacyState.legacyBlocked) {
        expect(route.allowedEnvironments, isNotEmpty, reason: route.id.name);
        expect(route.surface, isNot(AuthorizationSurface.unknown));
        expect(
          route.allowedEnvironments,
          isNot(contains(AuthorizationEnvironment.unknown)),
        );
      }
    }
  });

  test('no Administration, Platform or Shared Infrastructure UI is active', () {
    final surfaces = EntryPointRegistry.registeredRoutes
        .map((route) => route.surface)
        .toSet();
    expect(surfaces, isNot(contains(AuthorizationSurface.administration)));
    expect(surfaces, isNot(contains(AuthorizationSurface.platform)));
    expect(
      surfaces,
      isNot(contains(AuthorizationSurface.sharedInfrastructure)),
    );
  });

  test('legacy chat and orchestrator cannot construct legacy capability', () {
    final routes = File('lib/core/config/routes.dart').readAsStringSync();
    expect(routes, isNot(contains('AgentChatWrapper')));
    expect(routes, isNot(contains('OrchestratorPage')));
    expect(routes, isNot(contains('OrchestratorChatPage')));
    expect(routes, isNot(contains('SupabaseChatDataSource')));
    expect(routes, isNot(contains("path: '/conversations'")));
  });

  test('Product pages do not import Development hosts', () {
    for (final path in [
      'lib/features/health/presentation/pages/health_page.dart',
      'lib/features/nutrition/presentation/pages/nutrition_page.dart',
      'lib/features/mental_training/presentation/pages/mental_training_page.dart',
      'lib/features/physical_training/presentation/pages/physical_training_page.dart',
    ]) {
      final source = File(path).readAsStringSync();
      expect(source, isNot(contains('features/chat_messages')));
      expect(source, isNot(contains('features/chat_sessions')));
      expect(source, isNot(contains('AuthorizationSurface.')));
    }
  });

  test('backendReal and demo never enable Development routes', () {
    final environmentSource = File(
      'lib/core/config/app_environment.dart',
    ).readAsStringSync();
    expect(
      environmentSource,
      contains('devRoutesEnabled && (isLocal || isDevelopment)'),
    );
    expect(
      environmentSource,
      isNot(contains('isLocal || isDemo || isDevelopment')),
    );
  });
}

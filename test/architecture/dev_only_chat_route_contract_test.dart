import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Development chat routes are explicit and strongly guarded', () {
    final routesSource = File('lib/core/config/routes.dart').readAsStringSync();
    final registrySource = File(
      'lib/core/routing/infrastructure/entry_point_registry.dart',
    ).readAsStringSync();

    expect(
      registrySource,
      contains("pathPattern: '/dev/chat/session/:sessionId'"),
    );
    expect(registrySource, contains("pathPattern: '/dev/chat/composed'"));
    expect(registrySource, contains('AuthorizationSurface.development'));
    expect(registrySource, contains('requiresRuntimeEnablement: true'));
    expect(routesSource, contains('if (kReleaseMode) return const []'));
    expect(routesSource, contains('OwnChatMessagesRouteParamsAdapter'));
    expect(routesSource, contains('sessionIdFrom(state.pathParameters)'));
    expect(registrySource, isNot(contains("pathPattern: '/chat/:sessionId'")));
    expect(registrySource, isNot(contains(':agentId')));
  });

  test('legacy chat is absent while orchestrator routes remain blocked', () {
    final routesSource = File('lib/core/config/routes.dart').readAsStringSync();
    final registrySource = File(
      'lib/core/routing/infrastructure/entry_point_registry.dart',
    ).readAsStringSync();

    expect(registrySource, isNot(contains("pathPattern: '/chat/:id'")));
    expect(registrySource, contains("pathPattern: '/orchestrator/chat'"));
    expect(registrySource, contains('EntryPointLegacyState.legacyBlocked'));
    expect(routesSource, isNot(contains('AgentChatWrapper')));
    expect(routesSource, isNot(contains('OrchestratorChatPage')));
    expect(routesSource, isNot(contains('SupabaseChatDataSource')));
    expect(routesSource, isNot(contains('legacyAgentChat')));
  });

  test('Development route does not reuse inherited chat runtime', () {
    final routesSource = File('lib/core/config/routes.dart').readAsStringSync();
    final devRouteSource = routesSource.substring(
      routesSource.indexOf('List<RouteBase> _developmentChatMessageRoutes'),
    );

    for (final forbidden in [
      'AgentChatWrapper(',
      'ChatPage(',
      'OrchestratorChatPage',
      'ChatController',
      'SupabaseChatDataSource',
      'Supabase.instance.client',
      'supabase_flutter',
      '/functions/v1/',
      'service_role',
      'access_token',
      'refresh_token',
      "role: 'user'",
      'userId',
      'specialistId',
      'agentId',
      "['id']",
      'StasisEngine',
      'MCP',
      'streaming',
    ]) {
      expect(devRouteSource, isNot(contains(forbidden)), reason: forbidden);
    }
  });
}

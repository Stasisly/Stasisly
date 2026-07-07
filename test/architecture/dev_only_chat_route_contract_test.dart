import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('dev-only chat messages route is explicit and strongly guarded', () {
    final routesSource = File('lib/core/config/routes.dart').readAsStringSync();

    expect(routesSource, contains("path: '/dev/chat/session/:sessionId'"));
    expect(routesSource, contains("path: '/dev/chat/composed'"));
    expect(
      routesSource,
      contains('kReleaseMode || !environment.allowsDevRoutes'),
    );
    expect(routesSource, contains("state.uri.path.startsWith('/dev/')"));
    expect(routesSource, contains('OwnChatMessagesRouteParamsAdapter'));
    expect(routesSource, contains('OwnChatMessagesSafeShell'));
    expect(routesSource, contains('OwnChatComposedSafeShell'));
    expect(routesSource, contains('sessionIdFrom(state.pathParameters)'));
    expect(routesSource, isNot(contains("path: '/dev/chat/session/:id'")));
    expect(routesSource, isNot(contains("path: '/dev/chat/session/:agentId'")));
    expect(routesSource, isNot(contains("path: '/dev/chat/composed/:id'")));
    expect(
      routesSource,
      isNot(contains("path: '/dev/chat/composed/:agentId'")),
    );
    expect(
      routesSource,
      isNot(contains("path: '/dev/chat/composed/:sessionId'")),
    );
    expect(routesSource, isNot(contains("path: '/chat/:sessionId'")));
  });

  test('inherited routes are not wired to safe session messages', () {
    final routesSource = File('lib/core/config/routes.dart').readAsStringSync();

    expect(routesSource, contains("path: '/chat/:id'"));
    expect(routesSource, contains("final id = state.pathParameters['id']"));
    expect(routesSource, contains('AgentChatWrapper(agentId: id)'));
    expect(routesSource, contains("path: '/orchestrator/chat'"));

    final inheritedChatSource = routesSource.substring(
      routesSource.indexOf("path: '/chat/:id'"),
      routesSource.indexOf('..._devOnlyChatMessageRoutes'),
    );

    for (final forbidden in [
      'OwnChatMessagesSafeShell',
      'OwnChatComposedSafeShell',
      'sessionId',
      'selectableSpecialistId',
      '/functions/v1/',
      'SupabaseChatDataSource',
    ]) {
      expect(
        inheritedChatSource,
        isNot(contains(forbidden)),
        reason: forbidden,
      );
    }
  });

  test(
    'dev-only chat messages route does not reuse inherited chat runtime',
    () {
      final routesSource = File(
        'lib/core/config/routes.dart',
      ).readAsStringSync();
      final devRouteSource = routesSource.substring(
        routesSource.indexOf('List<RouteBase> _devOnlyChatMessageRoutes'),
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
    },
  );
}

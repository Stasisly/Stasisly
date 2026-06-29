import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:stasisly/app.dart';
import 'package:stasisly/core/config/app_environment.dart';
import 'package:stasisly/core/config/routes.dart';
import 'package:stasisly/features/chat_messages/presentation/shell/own_chat_composed_safe_shell.dart';

void main() {
  const sessionId = '00000000-0000-4000-8000-0000000000aa';

  testWidgets('dev-only route mounts safe messages shell with sessionId', (
    tester,
  ) async {
    final container = ProviderContainer(
      overrides: [
        appEnvironmentProvider.overrideWithValue(
          const AppEnvironment(mode: AppRuntimeMode.demo),
        ),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(container: container, child: const App()),
    );
    await tester.pump();

    container.read(routerProvider).go('/dev/chat/session/$sessionId');
    await tester.pumpAndSettle();

    expect(find.text('MODO DEMO MENSAJES'), findsOneWidget);
    expect(find.text('Mensaje'), findsOneWidget);
    expect(find.text('Sesión no válida'), findsNothing);
    expect(find.byType(Scaffold), findsOneWidget);
  });

  testWidgets('dev-only composed route mounts composed safe shell', (
    tester,
  ) async {
    final container = ProviderContainer(
      overrides: [
        appEnvironmentProvider.overrideWithValue(
          const AppEnvironment(mode: AppRuntimeMode.demo),
        ),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(container: container, child: const App()),
    );
    await tester.pump();

    container.read(routerProvider).go('/dev/chat/composed');
    await tester.pumpAndSettle();

    expect(find.byType(OwnChatComposedSafeShell), findsOneWidget);
    expect(find.textContaining('Shell local-safe'), findsOneWidget);
    expect(
      find.text('Selecciona una sesión para abrir mensajes'),
      findsOneWidget,
    );
    expect(find.byType(Scaffold), findsOneWidget);
  });

  test('dev-only route is guarded out of non-demo runtime modes', () {
    final routesSource = File('lib/core/config/routes.dart').readAsStringSync();

    expect(routesSource, contains("path: '/dev/chat/session/:sessionId'"));
    expect(routesSource, contains("path: '/dev/chat/composed'"));
    expect(routesSource, contains('kReleaseMode || !environment.isDemo'));
    expect(routesSource, contains('OwnChatMessagesRouteParamsAdapter'));
    expect(routesSource, contains('OwnChatMessagesSafeShell'));
    expect(routesSource, contains('OwnChatComposedSafeShell'));
    expect(routesSource, contains('state.pathParameters'));
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
  });

  test('dev-only route keeps inherited chat and runtime services out', () {
    final routesSource = File('lib/core/config/routes.dart').readAsStringSync();
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
  });
}

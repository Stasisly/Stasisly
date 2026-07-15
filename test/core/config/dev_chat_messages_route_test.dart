import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:stasisly/app.dart';
import 'package:stasisly/core/config/app_environment.dart';
import 'package:stasisly/core/config/routes.dart';
import 'package:stasisly/core/identity/infrastructure/environment_blocked_identity_provider.dart';
import 'package:stasisly/core/identity/providers/identity_providers.dart';
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
    expect(find.text('DEV ONLY'), findsOneWidget);
    expect(find.text('REMOTE DEVELOPMENT'), findsOneWidget);
    expect(find.text('SYNTHETIC DATA'), findsOneWidget);
    expect(find.text('NOT PRODUCT'), findsOneWidget);
    expect(
      find.text('Selecciona una sesión para abrir mensajes'),
      findsOneWidget,
    );
    expect(find.byType(Scaffold), findsOneWidget);
  });

  testWidgets('development dev-only composed route is available behind gate', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final container = ProviderContainer(
      overrides: [
        appEnvironmentProvider.overrideWithValue(
          const AppEnvironment(
            mode: AppRuntimeMode.development,
            supabaseUrl: 'https://project.supabase.co',
            supabaseAnonKey: 'public-test-key',
            remoteBackendEnabled: true,
            realAuthEnabled: true,
          ),
        ),
        identityProviderProvider.overrideWithValue(
          const EnvironmentBlockedIdentityProvider(),
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
  });

  test('dev-only route is guarded by allowsDevRoutes and release mode', () {
    final routesSource = File('lib/core/config/routes.dart').readAsStringSync();

    expect(routesSource, contains("path: '/dev/chat/session/:sessionId'"));
    expect(routesSource, contains("path: '/dev/chat/composed'"));
    expect(
      routesSource,
      contains('kReleaseMode || !environment.allowsDevRoutes'),
    );
    expect(routesSource, contains('OwnChatMessagesRouteParamsAdapter'));
    expect(routesSource, contains('OwnChatMessagesSafeShell'));
    expect(routesSource, contains('OwnChatComposedSafeShell'));
    expect(routesSource, contains('state.pathParameters'));
    expect(routesSource, contains('sessionIdFrom(state.pathParameters)'));
    expect(routesSource, contains("context.go('/dev/chat/session/"));
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

  test('product conversations route remains unregistered', () {
    final routesSource = File('lib/core/config/routes.dart').readAsStringSync();

    expect(routesSource, isNot(contains("path: '/conversations'")));
    expect(routesSource, isNot(contains("path: '/conversations/:sessionId'")));
    expect(routesSource, isNot(contains("path: '/conversations/:id'")));
    expect(routesSource, isNot(contains("path: '/conversations/:agentId'")));
    expect(routesSource, isNot(contains("path: '/conversation'")));
    expect(routesSource, isNot(contains("path: '/conversation/:sessionId'")));
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

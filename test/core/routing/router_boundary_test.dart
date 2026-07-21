import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:stasisly/app.dart';
import 'package:stasisly/core/auth/session/application/secure_session_state.dart';
import 'package:stasisly/core/auth/session/providers/secure_session_providers.dart';
import 'package:stasisly/core/auth/session/secure_session_auth_state.dart';
import 'package:stasisly/core/config/app_environment.dart';
import 'package:stasisly/core/config/routes.dart';
import 'package:stasisly/features/chat_messages/presentation/shell/own_chat_composed_safe_shell.dart';
import 'package:stasisly/features/conversations/product/presentation/stasis_page.dart';

void main() {
  const authenticatedSession = SecureSessionState(
    authState: SecureSessionAuthState.authenticated(
      subjectId: '00000000-0000-4000-8000-0000000000f1',
    ),
  );

  Future<ProviderContainer> pumpApp(
    WidgetTester tester,
    AppEnvironment environment, {
    SecureSessionState session = authenticatedSession,
  }) async {
    tester.view.physicalSize = const Size(1200, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final container = ProviderContainer(
      overrides: [
        appEnvironmentProvider.overrideWithValue(environment),
        secureSessionStateProvider.overrideWithValue(session),
      ],
    );
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(container: container, child: const App()),
    );
    await tester.pumpAndSettle();
    return container;
  }

  testWidgets('approved Product route builds in local when authenticated', (
    tester,
  ) async {
    await pumpApp(tester, const AppEnvironment(mode: AppRuntimeMode.local));
    expect(find.byType(StasisPage), findsOneWidget);
  });

  testWidgets('approved Development route builds in local', (tester) async {
    final container = await pumpApp(
      tester,
      const AppEnvironment(mode: AppRuntimeMode.local),
    );
    container.read(routerProvider).go('/dev/chat/composed');
    await tester.pumpAndSettle();
    expect(find.byType(OwnChatComposedSafeShell), findsOneWidget);
  });

  testWidgets('Development route is blocked in production', (tester) async {
    final container = await pumpApp(
      tester,
      const AppEnvironment(mode: AppRuntimeMode.production),
    );
    container.read(routerProvider).go('/dev/chat/composed');
    await tester.pumpAndSettle();
    expect(
      find.text('Esta capacidad no está disponible en este entorno.'),
      findsOneWidget,
    );
    expect(find.byType(OwnChatComposedSafeShell), findsNothing);
  });

  testWidgets('legacy chat is unknown and orchestrator remains blocked', (
    tester,
  ) async {
    final container = await pumpApp(
      tester,
      const AppEnvironment(mode: AppRuntimeMode.local),
    );
    container.read(routerProvider).go('/chat/legacy-agent');
    await tester.pumpAndSettle();
    expect(find.text('Esta página no está disponible.'), findsOneWidget);

    container.read(routerProvider).go('/orchestrator');
    await tester.pumpAndSettle();
    expect(
      find.text('Esta capacidad heredada no está disponible.'),
      findsOneWidget,
    );
  });

  testWidgets('unknown route renders safe not-available state', (tester) async {
    final container = await pumpApp(
      tester,
      const AppEnvironment(mode: AppRuntimeMode.local),
    );
    container.read(routerProvider).go('/unknown-foundation-route');
    await tester.pumpAndSettle();
    expect(find.text('Esta página no está disponible.'), findsOneWidget);
  });

  testWidgets('unauthenticated Product route redirects to public auth entry', (
    tester,
  ) async {
    await pumpApp(
      tester,
      const AppEnvironment(mode: AppRuntimeMode.local),
      session: const SecureSessionState(),
    );
    expect(find.text('Comenzar'), findsOneWidget);
    expect(find.byType(StasisPage), findsNothing);
  });

  testWidgets('public login route remains available unauthenticated', (
    tester,
  ) async {
    final container = await pumpApp(
      tester,
      const AppEnvironment(mode: AppRuntimeMode.local),
      session: const SecureSessionState(),
    );
    container.read(routerProvider).go('/login');
    await tester.pumpAndSettle();
    expect(find.text('Iniciar sesión'), findsWidgets);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:stasisly/app.dart';
import 'package:stasisly/core/auth/session/application/secure_session_state.dart';
import 'package:stasisly/core/auth/session/providers/secure_session_providers.dart';
import 'package:stasisly/core/auth/session/secure_session_auth_state.dart';
import 'package:stasisly/core/config/app_environment.dart';
import 'package:stasisly/core/config/routes.dart';
import 'package:stasisly/core/observability/conversation_observability.dart';
import 'package:stasisly/features/conversations/composition/conversation_providers.dart';
import 'package:stasisly/features/conversations/domain/entities/conversation.dart';
import 'package:stasisly/features/conversations/domain/entities/conversation_message.dart';
import 'package:stasisly/features/conversations/domain/results/conversation_results.dart';
import 'package:stasisly/features/conversations/domain/value_objects/conversation_id.dart';
import 'package:stasisly/features/conversations/presentation/widgets/conversation_message_bubble.dart';
import 'package:stasisly/features/conversations/product/presentation/conversation_page.dart'
    as product;
import 'package:stasisly/features/conversations/product/presentation/conversations_page.dart';
import 'package:stasisly/features/conversations/product/presentation/stasis_page.dart';

import '../support/conversation_test_support.dart';

void main() {
  testWidgets('Stasis is honest and opens canonical conversations', (
    tester,
  ) async {
    final router = GoRouter(
      initialLocation: '/stasis',
      routes: [
        GoRoute(path: '/stasis', builder: (_, _) => const StasisPage()),
        GoRoute(
          path: '/conversations',
          builder: (_, _) => const Scaffold(body: Text('Lista canónica')),
        ),
      ],
    );
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));

    expect(find.text('Tu espacio central'), findsOneWidget);
    expect(find.textContaining('no están activas'), findsOneWidget);
    expect(find.textContaining('motor'), findsNothing);
    await tester.tap(find.byKey(const Key('open-conversations')));
    await tester.pumpAndSettle();
    expect(find.text('Lista canónica'), findsOneWidget);
  });

  testWidgets('list defaults active, filters archived and opens detail', (
    tester,
  ) async {
    final repository = FakeConversationRepository()
      ..onList = (status, _, _) async => ConversationListSuccess(
        ConversationPage(
          items: [
            conversation(
              status: status == ConversationStatusFilter.archived
                  ? ConversationStatus.archived
                  : ConversationStatus.active,
            ),
          ],
          nextCursor: null,
        ),
      );
    final router = GoRouter(
      initialLocation: '/conversations',
      routes: [
        GoRoute(
          path: '/conversations',
          builder: (_, _) => const ConversationsPage(),
        ),
        GoRoute(
          path: '/conversations/:conversationId',
          builder: (_, state) => Scaffold(
            body: Text('Detalle ${state.pathParameters['conversationId']}'),
          ),
        ),
      ],
    );
    await tester.pumpWidget(
      _app(repository, MaterialApp.router(routerConfig: router)),
    );
    await tester.pumpAndSettle();

    expect(repository.listStatuses, [ConversationStatusFilter.active]);
    expect(find.text('Conversación sintética'), findsOneWidget);
    expect(
      find.text('Especialista sintético · Salud · 02/01/2026'),
      findsOneWidget,
    );
    expect(find.text('synthetic-subject'), findsNothing);
    await tester.tap(find.text('Archivadas'));
    await tester.pumpAndSettle();
    expect(repository.listStatuses.last, ConversationStatusFilter.archived);
    await tester.tap(find.text('Conversación sintética'));
    await tester.pumpAndSettle();
    expect(find.text('Detalle conversation-1'), findsOneWidget);
  });

  testWidgets('detail sends only user message, archives and restores', (
    tester,
  ) async {
    final repository = FakeConversationRepository();
    await tester.pumpWidget(
      _app(
        repository,
        MaterialApp(
          home: product.ConversationPage(
            conversationId: ConversationId('conversation-1'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Mensaje sintético'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'mensaje Product');
    await tester.pump();
    await tester.tap(find.byIcon(Icons.send_outlined));
    await tester.pumpAndSettle();
    expect(repository.sendInputs.single.content, 'mensaje Product');
    expect(
      repository.sendInputs.single.operationAttemptId.value,
      'test_attempt_00000001',
    );
    expect(find.text('Stasis'), findsNothing);

    await tester.tap(find.text('Archivar'));
    await tester.pumpAndSettle();
    expect(repository.archiveCalls, 1);
    expect(tester.widget<TextField>(find.byType(TextField)).enabled, isFalse);
    expect(find.text('Mensaje sintético'), findsWidgets);
    await tester.tap(find.text('Restaurar'));
    await tester.pumpAndSettle();
    expect(repository.restoreCalls, 1);
    expect(tester.widget<TextField>(find.byType(TextField)).enabled, isTrue);
  });

  testWidgets('detail maps redaction and opaque missing state safely', (
    tester,
  ) async {
    final repository = FakeConversationRepository()
      ..messagesResult = ConversationMessageListSuccess(
        ConversationMessagePage(
          items: [
            ConversationMessage(
              messageId: 'redacted-message',
              conversationId: ConversationId('conversation-1'),
              author: const UserAuthor(),
              content: ConversationMessage.redactedPlaceholder,
              createdAt: DateTime.utc(2026),
              status: ConversationMessageStatus.redacted,
              provenance: ConversationMessageProvenance.userProvided,
              visibility: ConversationMessageVisibility.redacted,
            ),
          ],
          nextCursor: null,
        ),
      );
    await tester.pumpWidget(
      _app(
        repository,
        MaterialApp(
          home: product.ConversationPage(
            conversationId: ConversationId('conversation-1'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Contenido no disponible'), findsOneWidget);

    await tester.pumpWidget(
      _app(
        repository,
        const MaterialApp(home: product.ConversationPage(conversationId: null)),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('La conversación no está disponible.'), findsOneWidget);
  });

  testWidgets(
    'canonical Product route flow stays local and user-message only',
    (tester) async {
      var status = ConversationStatus.active;
      final repository = FakeConversationRepository()
        ..onList = (filter, _, _) async {
          final expected = filter == ConversationStatusFilter.active
              ? ConversationStatus.active
              : ConversationStatus.archived;
          return ConversationListSuccess(
            ConversationPage(
              items: status == expected
                  ? [conversation(status: status)]
                  : const [],
              nextCursor: null,
            ),
          );
        }
        ..onRead = (_) async {
          return ConversationReadSuccess(conversation(status: status));
        }
        ..onArchive = (input) async {
          status = ConversationStatus.archived;
          return ConversationMutationSuccess(
            receipt: ConversationMutationReceipt(
              conversationId: input.conversationId,
              status: status,
            ),
          );
        }
        ..onRestore = (input) async {
          status = ConversationStatus.active;
          return ConversationMutationSuccess(
            receipt: ConversationMutationReceipt(
              conversationId: input.conversationId,
              status: status,
            ),
          );
        };
      final observability = InMemoryConversationObservabilitySink();
      final container = ProviderContainer(
        overrides: [
          appEnvironmentProvider.overrideWithValue(
            const AppEnvironment(mode: AppRuntimeMode.local),
          ),
          secureSessionStateProvider.overrideWithValue(
            const SecureSessionState(
              authState: SecureSessionAuthState.authenticated(
                subjectId: 'synthetic-product-subject',
              ),
            ),
          ),
          conversationRepositoryProvider.overrideWithValue(repository),
          conversationObservabilitySinkProvider.overrideWithValue(
            observability,
          ),
          conversationOperationAttemptIdFactoryProvider.overrideWithValue(
            SequenceOperationAttemptIdFactory(),
          ),
        ],
      );
      addTearDown(container.dispose);
      await tester.pumpWidget(
        UncontrolledProviderScope(container: container, child: const App()),
      );
      await tester.pumpAndSettle();

      expect(find.byType(StasisPage), findsOneWidget);
      await tester.tap(find.byKey(const Key('open-conversations')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Conversación sintética'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'mensaje integral');
      await tester.pump();
      await tester.tap(find.byIcon(Icons.send_outlined));
      await tester.pumpAndSettle();
      expect(repository.sendInputs.single.content, 'mensaje integral');
      expect(repository.sendInputs, hasLength(1));

      await tester.tap(find.text('Archivar'));
      await tester.pumpAndSettle();
      expect(status, ConversationStatus.archived);
      expect(tester.widget<TextField>(find.byType(TextField)).enabled, isFalse);
      await tester.tap(find.text('Restaurar'));
      await tester.pumpAndSettle();
      expect(status, ConversationStatus.active);
      expect(tester.widget<TextField>(find.byType(TextField)).enabled, isTrue);
      await tester.tap(find.byType(BackButton));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byType(ConversationsPage), findsOneWidget);
      expect(find.text('Conversación sintética'), findsOneWidget);
      expect(
        observability.observations.any(
          (event) =>
              event.event == ConversationObservabilityEventName.routeEntered &&
              event.route == ConversationObservedRoute.conversationDetail,
        ),
        isTrue,
      );
    },
  );

  testWidgets('blocked environment never loads canonical repository', (
    tester,
  ) async {
    final repository = FakeConversationRepository();
    final observability = InMemoryConversationObservabilitySink();
    final container = ProviderContainer(
      overrides: [
        appEnvironmentProvider.overrideWithValue(
          const AppEnvironment(mode: AppRuntimeMode.production),
        ),
        secureSessionStateProvider.overrideWithValue(
          const SecureSessionState(
            authState: SecureSessionAuthState.authenticated(
              subjectId: 'synthetic-product-subject',
            ),
          ),
        ),
        conversationRepositoryProvider.overrideWithValue(repository),
        conversationObservabilitySinkProvider.overrideWithValue(observability),
      ],
    );
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(container: container, child: const App()),
    );
    container.read(routerProvider).go('/conversations');
    await tester.pumpAndSettle();

    expect(
      find.text('Esta capacidad no está disponible en este entorno.'),
      findsOneWidget,
    );
    expect(repository.listStatuses, isEmpty);
    expect(
      observability.observations.any(
        (event) =>
            event.event ==
                ConversationObservabilityEventName.environmentBlocked &&
            event.route == ConversationObservedRoute.conversations,
      ),
      isTrue,
    );
  });

  testWidgets('100 conversations and 200 messages stay lazy and responsive', (
    tester,
  ) async {
    final repository = FakeConversationRepository()
      ..listResult = ConversationListSuccess(
        ConversationPage(
          items: List.generate(
            100,
            (index) => conversation(id: 'conversation-$index'),
          ),
          nextCursor: null,
        ),
      )
      ..messagesResult = ConversationMessageListSuccess(
        ConversationMessagePage(
          items: List.generate(200, (index) => message(id: 'message-$index')),
          nextCursor: null,
        ),
      );
    await tester.binding.setSurfaceSize(const Size(320, 700));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _app(repository, const MaterialApp(home: ConversationsPage())),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.byType(ListTile).evaluate().length, lessThan(100));

    await tester.pumpWidget(
      _app(
        repository,
        MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(2)),
          child: MaterialApp(
            home: product.ConversationPage(
              conversationId: ConversationId('conversation-1'),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(
      find.byType(ConversationMessageBubble).evaluate().length,
      lessThan(200),
    );
  });

  testWidgets('unknown legacy chat path emits only a safe blocked event', (
    tester,
  ) async {
    final observability = InMemoryConversationObservabilitySink();
    final container = ProviderContainer(
      overrides: [
        appEnvironmentProvider.overrideWithValue(
          const AppEnvironment(mode: AppRuntimeMode.local),
        ),
        secureSessionStateProvider.overrideWithValue(
          const SecureSessionState(
            authState: SecureSessionAuthState.authenticated(
              subjectId: 'synthetic-product-subject',
            ),
          ),
        ),
        conversationObservabilitySinkProvider.overrideWithValue(observability),
      ],
    );
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(container: container, child: const App()),
    );

    container.read(routerProvider).go('/chat/legacy-value');
    await tester.pumpAndSettle();

    expect(
      observability.observations.any(
        (event) =>
            event.event == ConversationObservabilityEventName.routeBlocked &&
            event.route == null,
      ),
      isTrue,
    );
  });

  testWidgets('unauthenticated canonical route emits safe auth requirement', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1200, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final observability = InMemoryConversationObservabilitySink();
    final container = ProviderContainer(
      overrides: [
        appEnvironmentProvider.overrideWithValue(
          const AppEnvironment(mode: AppRuntimeMode.local),
        ),
        secureSessionStateProvider.overrideWithValue(
          const SecureSessionState(),
        ),
        conversationObservabilitySinkProvider.overrideWithValue(observability),
      ],
    );
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(container: container, child: const App()),
    );

    container.read(routerProvider).go('/conversations');
    await tester.pumpAndSettle();

    expect(
      observability.observations.any(
        (event) =>
            event.event ==
                ConversationObservabilityEventName.authenticationRequired &&
            event.route == ConversationObservedRoute.conversations &&
            event.result == ConversationObservationResult.unauthenticated,
      ),
      isTrue,
    );
  });
}

Widget _app(FakeConversationRepository repository, Widget child) {
  return ProviderScope(
    overrides: [
      conversationRepositoryProvider.overrideWithValue(repository),
      conversationOperationAttemptIdFactoryProvider.overrideWithValue(
        SequenceOperationAttemptIdFactory(),
      ),
    ],
    child: child,
  );
}

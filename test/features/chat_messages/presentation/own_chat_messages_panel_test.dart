import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:stasisly/features/chat_messages/application/own_chat_messages_controller.dart';
import 'package:stasisly/features/chat_messages/application/own_chat_messages_state.dart';
import 'package:stasisly/features/chat_messages/domain/entities/own_chat_message.dart';
import 'package:stasisly/features/chat_messages/domain/entities/own_chat_message_results.dart';
import 'package:stasisly/features/chat_messages/domain/repositories/own_chat_messages_repository.dart';
import 'package:stasisly/features/chat_messages/presentation/providers/own_chat_messages_providers.dart';
import 'package:stasisly/features/chat_messages/presentation/widgets/own_chat_messages_panel.dart';

const _testSessionId = '00000000-0000-4000-8000-000000000301';

void main() {
  const sessionId = _testSessionId;

  testWidgets('renders initial and loading states', (tester) async {
    await _pumpPanel(tester, _FakeNotifier(const OwnChatMessagesState()));

    expect(
      find.text('Selecciona una sesión para ver mensajes'),
      findsOneWidget,
    );

    await _pumpPanel(
      tester,
      _FakeNotifier(
        const OwnChatMessagesState(
          sessionId: sessionId,
          isInitialLoading: true,
        ),
      ),
    );

    expect(find.text('Cargando mensajes...'), findsOneWidget);
  });

  testWidgets('renders empty state', (tester) async {
    await _pumpPanel(
      tester,
      _FakeNotifier(const OwnChatMessagesState(sessionId: sessionId)),
    );

    expect(find.text('No hay mensajes todavía'), findsOneWidget);
  });

  testWidgets('renders user, assistant, system and tool messages', (
    tester,
  ) async {
    await _pumpPanel(
      tester,
      _FakeNotifier(
        OwnChatMessagesState(
          sessionId: sessionId,
          messages: [
            _message('m1', OwnChatMessageRole.user, 'hola'),
            _message('m2', OwnChatMessageRole.assistant, 'respuesta'),
            _message('m3', OwnChatMessageRole.system, 'sistema'),
            _message('m4', OwnChatMessageRole.tool, 'herramienta'),
          ],
        ),
      ),
    );

    expect(find.text('Usuario'), findsOneWidget);
    expect(find.text('Asistente'), findsOneWidget);
    expect(find.text('Sistema'), findsOneWidget);
    expect(find.text('Herramienta'), findsOneWidget);
    expect(find.text('hola'), findsOneWidget);
    expect(find.text('respuesta'), findsOneWidget);
  });

  testWidgets('renders demo label and backend blocked state', (tester) async {
    await _pumpPanel(
      tester,
      _FakeNotifier(
        const OwnChatMessagesState(
          sessionId: sessionId,
          isDemo: true,
          isBackendBlocked: true,
        ),
      ),
    );

    expect(find.text('MODO DEMO MENSAJES'), findsOneWidget);
    expect(find.text('Backend bloqueado para mensajes'), findsOneWidget);
  });

  testWidgets('renders list error', (tester) async {
    await _pumpPanel(
      tester,
      _FakeNotifier(
        const OwnChatMessagesState(
          sessionId: sessionId,
          lastListError: ListOwnChatMessagesFailureType.networkError,
        ),
      ),
    );

    expect(
      find.text(
        'Error al cargar mensajes: No se pudo contactar con el backend.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('input sends only content and clears on accepted send', (
    tester,
  ) async {
    final notifier = _FakeNotifier(
      const OwnChatMessagesState(sessionId: sessionId),
    );
    await _pumpPanel(tester, notifier);

    await tester.enterText(find.byType(TextField), '  hola stasis  ');
    await tester.tap(find.text('Enviar'));
    await tester.pump();

    expect(notifier.sentContents, ['hola stasis']);
    expect(find.text('hola stasis'), findsNothing);
  });

  testWidgets('send error is visible and keeps existing messages', (
    tester,
  ) async {
    final notifier = _FakeNotifier(
      OwnChatMessagesState(
        sessionId: sessionId,
        messages: [_message('m1', OwnChatMessageRole.user, 'mensaje previo')],
      ),
      sendFailure: SendOwnChatMessageFailureType.sessionArchived,
    );
    await _pumpPanel(tester, notifier);

    await tester.enterText(find.byType(TextField), 'nuevo');
    await tester.tap(find.text('Enviar'));
    await tester.pump();

    expect(find.text('mensaje previo'), findsOneWidget);
    expect(
      find.text(
        'Error al enviar mensaje: La sesión está archivada y no admite nuevos mensajes.',
      ),
      findsOneWidget,
    );
  });

  testWidgets(
    'sessionNotFound, networkError and contractViolation are visible',
    (tester) async {
      for (final failure in [
        SendOwnChatMessageFailureType.sessionNotFound,
        SendOwnChatMessageFailureType.networkError,
        SendOwnChatMessageFailureType.contractViolation,
      ]) {
        final notifier = _FakeNotifier(
          OwnChatMessagesState(sessionId: sessionId, lastSendError: failure),
        );
        await _pumpPanel(tester, notifier);

        expect(find.textContaining('Error al enviar mensaje:'), findsOneWidget);
      }
    },
  );

  testWidgets('pagination button calls loadNextPage when cursor exists', (
    tester,
  ) async {
    final notifier = _FakeNotifier(
      OwnChatMessagesState(
        sessionId: sessionId,
        messages: [_message('m1', OwnChatMessageRole.user, 'uno')],
        nextCursor: 'cursor-1',
      ),
    );
    await _pumpPanel(tester, notifier);

    expect(find.text('Cargar más'), findsOneWidget);
    await tester.tap(find.text('Cargar más'));
    await tester.pump();

    expect(notifier.nextPageCalls, 1);
  });

  testWidgets('pagination button is hidden without cursor and shows progress', (
    tester,
  ) async {
    await _pumpPanel(
      tester,
      _FakeNotifier(
        OwnChatMessagesState(
          sessionId: sessionId,
          messages: [_message('m1', OwnChatMessageRole.user, 'uno')],
        ),
      ),
    );

    expect(find.text('Cargar más'), findsNothing);

    await _pumpPanel(
      tester,
      _FakeNotifier(
        OwnChatMessagesState(
          sessionId: sessionId,
          messages: [_message('m1', OwnChatMessageRole.user, 'uno')],
          nextCursor: 'cursor-1',
          isPaginating: true,
        ),
      ),
    );

    expect(find.text('Cargando más...'), findsOneWidget);
  });
}

Future<void> _pumpPanel(WidgetTester tester, _FakeNotifier notifier) async {
  await tester.pumpWidget(
    ProviderScope(
      key: UniqueKey(),
      overrides: [
        ownChatMessagesControllerProvider.overrideWith((ref) => notifier),
      ],
      child: const MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 500,
            width: 400,
            child: OwnChatMessagesPanel(autoLoad: false),
          ),
        ),
      ),
    ),
  );
}

OwnChatMessage _message(
  String id,
  OwnChatMessageRole messageRole,
  String content,
) {
  return OwnChatMessage(
    messageId: id,
    sessionId: _testSessionId,
    role: messageRole,
    content: content,
    createdAt: DateTime.utc(2026, 6, 21, 14),
    isDemo: false,
  );
}

class _FakeNotifier extends OwnChatMessagesControllerNotifier {
  _FakeNotifier(OwnChatMessagesState initialState, {this.sendFailure})
    : super(OwnChatMessagesController(repository: _NeverRepository())) {
    state = initialState;
  }

  final SendOwnChatMessageFailureType? sendFailure;
  final List<String> sentContents = [];
  int nextPageCalls = 0;

  @override
  Future<void> sendMessage(String content) async {
    sentContents.add(content);
    if (sendFailure == null) {
      state = state.copyWith(lastSendError: null, isSending: false);
      return;
    }
    state = state.copyWith(lastSendError: sendFailure, isSending: false);
  }

  @override
  Future<void> loadNextPage() async {
    nextPageCalls += 1;
    state = state.copyWith(isPaginating: false);
  }
}

class _NeverRepository implements OwnChatMessagesRepository {
  @override
  Future<ListSessionMessagesResult> listSessionMessages({
    required String sessionId,
    int limit = 50,
    String? cursor,
  }) {
    throw StateError('Unexpected list call from widget test.');
  }

  @override
  Future<SendUserMessageResult> sendUserMessage({
    required String sessionId,
    required String content,
  }) {
    throw StateError('Unexpected send call from widget test.');
  }
}

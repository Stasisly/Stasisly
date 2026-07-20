import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stasisly/core/idempotency/operation_attempt_id.dart';

import 'package:stasisly/features/chat_messages/application/own_chat_messages_controller.dart';
import 'package:stasisly/features/chat_messages/application/own_chat_messages_state.dart';
import 'package:stasisly/features/chat_messages/domain/entities/own_chat_message_results.dart';
import 'package:stasisly/features/chat_messages/domain/repositories/own_chat_messages_repository.dart';
import 'package:stasisly/features/chat_messages/presentation/providers/own_chat_messages_providers.dart';
import 'package:stasisly/features/chat_messages/presentation/shell/own_chat_messages_route_params_adapter.dart';
import 'package:stasisly/features/chat_messages/presentation/shell/own_chat_messages_safe_shell.dart';

const _session = '00000000-0000-4000-8000-000000000401';

void main() {
  test('route params adapter accepts only explicit session input', () {
    const adapter = OwnChatMessagesRouteParamsAdapter();

    expect(adapter.sessionIdFrom({'sessionId': '  $_session  '}), _session);
    expect(adapter.sessionIdFrom({'id': _session}), isNull);
    expect(adapter.sessionIdFrom({'sessionId': ''}), isNull);
    expect(adapter.sessionIdFrom({'sessionId': '../$_session'}), isNull);
  });

  testWidgets('safe shell renders the approved panel', (tester) async {
    await _pumpShell(
      tester,
      notifier: _FakeNotifier(const OwnChatMessagesState(sessionId: _session)),
    );

    expect(find.byType(OwnChatMessagesSafeShell), findsOneWidget);
    expect(find.text('DEV ONLY'), findsOneWidget);
    expect(find.text('REMOTE DEVELOPMENT'), findsOneWidget);
    expect(find.text('SYNTHETIC DATA'), findsOneWidget);
    expect(find.text('NOT PRODUCT'), findsOneWidget);
    expect(
      find.text('Detalle dev-only por sessionId explícito.'),
      findsOneWidget,
    );
    expect(find.text('No hay mensajes todavía'), findsOneWidget);
  });

  testWidgets('safe shell passes normalized session input to panel', (
    tester,
  ) async {
    final notifier = _FakeNotifier(const OwnChatMessagesState());

    await _pumpShell(
      tester,
      notifier: notifier,
      sessionId: '  $_session  ',
      autoLoad: true,
    );
    await tester.pump();

    expect(notifier.loadedSessions, [_session]);
  });

  testWidgets('safe shell exposes invalid session state without loading', (
    tester,
  ) async {
    final notifier = _FakeNotifier(const OwnChatMessagesState());

    await _pumpShell(tester, notifier: notifier, sessionId: ' ');

    expect(find.text('Sesión no válida'), findsOneWidget);
    expect(notifier.loadedSessions, isEmpty);
  });

  testWidgets('safe shell can show backend blocked through approved provider', (
    tester,
  ) async {
    await _pumpShell(
      tester,
      notifier: _FakeNotifier(
        const OwnChatMessagesState(
          sessionId: _session,
          isBackendBlocked: true,
          lastListError: ListOwnChatMessagesFailureType.backendBlocked,
        ),
      ),
    );

    expect(find.text('Backend bloqueado para mensajes'), findsOneWidget);
    expect(
      find.text('Error al cargar mensajes: Backend bloqueado.'),
      findsOneWidget,
    );
  });
}

Future<void> _pumpShell(
  WidgetTester tester, {
  required _FakeNotifier notifier,
  String sessionId = _session,
  bool autoLoad = false,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        ownChatMessagesControllerProvider.overrideWith((ref) => notifier),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 500,
            width: 400,
            child: OwnChatMessagesSafeShell(
              sessionId: sessionId,
              autoLoad: autoLoad,
            ),
          ),
        ),
      ),
    ),
  );
}

class _FakeNotifier extends OwnChatMessagesControllerNotifier {
  _FakeNotifier(OwnChatMessagesState initialState)
    : super(OwnChatMessagesController(repository: _NeverRepository())) {
    state = initialState;
  }

  final List<String> loadedSessions = [];

  @override
  Future<void> loadInitial(String sessionId) async {
    loadedSessions.add(sessionId);
    state = OwnChatMessagesState(sessionId: sessionId);
  }
}

class _NeverRepository implements OwnChatMessagesRepository {
  @override
  Future<ListSessionMessagesResult> listSessionMessages({
    required String sessionId,
    int limit = 50,
    String? cursor,
  }) {
    throw StateError('Repository must not be called by shell tests.');
  }

  @override
  Future<SendUserMessageResult> sendUserMessage({
    required String sessionId,
    required String content,
    required OperationAttemptId operationAttemptId,
  }) {
    throw StateError('Repository must not be called by shell tests.');
  }
}

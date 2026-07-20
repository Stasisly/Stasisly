import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stasisly/core/idempotency/operation_attempt_id.dart';

import 'package:stasisly/features/chat_messages/application/own_chat_messages_controller.dart';
import 'package:stasisly/features/chat_messages/application/own_chat_messages_state.dart';
import 'package:stasisly/features/chat_messages/domain/entities/own_chat_message_results.dart';
import 'package:stasisly/features/chat_messages/domain/repositories/own_chat_messages_repository.dart';
import 'package:stasisly/features/chat_messages/presentation/providers/own_chat_messages_providers.dart';
import 'package:stasisly/features/chat_messages/presentation/shell/own_chat_composed_safe_shell.dart';
import 'package:stasisly/features/chat_messages/presentation/shell/own_chat_messages_safe_shell.dart';
import 'package:stasisly/features/chat_sessions/application/own_chat_sessions_controller.dart';
import 'package:stasisly/features/chat_sessions/application/own_chat_sessions_state.dart';
import 'package:stasisly/features/chat_sessions/domain/entities/own_chat_session.dart';
import 'package:stasisly/features/chat_sessions/domain/entities/own_chat_session_results.dart';
import 'package:stasisly/features/chat_sessions/domain/repositories/own_chat_sessions_repository.dart';
import 'package:stasisly/features/chat_sessions/presentation/providers/own_chat_sessions_providers.dart';
import 'package:stasisly/features/chat_sessions/presentation/widgets/own_chat_sessions_panel.dart';

const _sessionA = '00000000-0000-4000-8000-000000000a01';
const _sessionB = '00000000-0000-4000-8000-000000000b02';
const _selectableA = '10000000-0000-4000-8000-000000000a01';
const _selectableB = '10000000-0000-4000-8000-000000000b02';

void main() {
  testWidgets('renders sessions panel without mounting messages initially', (
    tester,
  ) async {
    await _pumpShell(
      tester,
      sessions: _FakeSessionsNotifier(
        OwnChatSessionsState(sessions: [_session(_sessionA)]),
      ),
      messages: _FakeMessagesNotifier(const OwnChatMessagesState()),
    );

    expect(find.byType(OwnChatComposedSafeShell), findsOneWidget);
    expect(find.byType(OwnChatSessionsPanel), findsOneWidget);
    expect(find.byType(OwnChatMessagesSafeShell), findsNothing);
    expect(find.text('DEV ONLY'), findsOneWidget);
    expect(find.text('REMOTE DEVELOPMENT'), findsOneWidget);
    expect(find.text('SYNTHETIC DATA'), findsOneWidget);
    expect(find.text('NOT PRODUCT'), findsOneWidget);
    expect(
      find.text('Selecciona una sesión para abrir mensajes'),
      findsOneWidget,
    );
  });

  testWidgets('selecting explicit sessionId mounts messages with sessionId', (
    tester,
  ) async {
    final sessions = _FakeSessionsNotifier(
      OwnChatSessionsState(
        sessions: [_session(_sessionA), _session(_sessionB, minute: 2)],
      ),
    );
    final messages = _FakeMessagesNotifier(const OwnChatMessagesState());
    await _pumpShell(tester, sessions: sessions, messages: messages);

    await tester.tap(find.text('Seleccionar sessionId').first);
    await tester.pump();

    expect(sessions.selectedSessionIds, [_sessionA]);
    expect(find.byType(OwnChatMessagesSafeShell), findsOneWidget);
    expect(
      find.text('Selecciona una sesión para ver mensajes'),
      findsOneWidget,
    );
    expect(find.text('selectedSessionId: $_sessionA'), findsOneWidget);
    expect(find.text('Abrir mensajes dev-only'), findsNWidgets(2));
    expect(messages.loadedSessionIds, isEmpty);
  });

  testWidgets('autoLoad passes selected sessionId to messages only', (
    tester,
  ) async {
    final messages = _FakeMessagesNotifier(const OwnChatMessagesState());
    await _pumpShell(
      tester,
      sessions: _FakeSessionsNotifier(
        OwnChatSessionsState(
          sessions: [_session(_sessionA)],
          selectedSessionId: _sessionA,
        ),
      ),
      messages: messages,
      messagesAutoLoad: true,
    );
    await tester.pump();

    expect(messages.loadedSessionIds, [_sessionA]);
    expect(messages.loadedSessionIds, isNot(contains(_selectableA)));
    expect(messages.loadedSessionIds, isNot(contains('agent-stasis-core')));
  });

  testWidgets('clearing selection unmounts messages', (tester) async {
    final sessions = _FakeSessionsNotifier(
      OwnChatSessionsState(
        sessions: [_session(_sessionA)],
        selectedSessionId: _sessionA,
      ),
    );
    await _pumpShell(
      tester,
      sessions: sessions,
      messages: _FakeMessagesNotifier(
        const OwnChatMessagesState(sessionId: _sessionA),
      ),
    );

    expect(find.byType(OwnChatMessagesSafeShell), findsOneWidget);

    sessions.clearSelection();
    await tester.pump();

    expect(find.byType(OwnChatMessagesSafeShell), findsNothing);
    expect(
      find.text('Selecciona una sesión para abrir mensajes'),
      findsOneWidget,
    );
  });

  testWidgets('archiving selected session unmounts messages', (tester) async {
    final sessions = _FakeSessionsNotifier(
      OwnChatSessionsState(
        sessions: [_session(_sessionA)],
        selectedSessionId: _sessionA,
      ),
    );
    await _pumpShell(
      tester,
      sessions: sessions,
      messages: _FakeMessagesNotifier(
        const OwnChatMessagesState(sessionId: _sessionA),
      ),
    );

    await tester.tap(find.text('Archivar sessionId'));
    await tester.pump();

    expect(sessions.archivedSessionIds, [_sessionA]);
    expect(find.byType(OwnChatMessagesSafeShell), findsNothing);
    expect(find.text('sessionId: $_sessionA'), findsNothing);
  });

  testWidgets('create uses selectableSpecialistId but messages receive none', (
    tester,
  ) async {
    final sessions = _FakeSessionsNotifier(const OwnChatSessionsState());
    final messages = _FakeMessagesNotifier(const OwnChatMessagesState());
    await _pumpShell(tester, sessions: sessions, messages: messages);

    await tester.enterText(find.byType(TextField), '  $_selectableB  ');
    await tester.tap(find.text('Crear sesión'));
    await tester.pump();

    expect(sessions.createdSelectableIds, [_selectableB]);
    expect(find.byType(OwnChatMessagesSafeShell), findsOneWidget);
    expect(messages.loadedSessionIds, isEmpty);
    expect(find.text('sessionId: $_sessionB'), findsOneWidget);
  });

  testWidgets('demo, backendBlocked and errors remain explicit', (
    tester,
  ) async {
    await _pumpShell(
      tester,
      sessions: _FakeSessionsNotifier(
        const OwnChatSessionsState(
          selectedSessionId: _sessionA,
          isDemo: true,
          isBackendBlocked: true,
          lastListError: OwnChatSessionsFailureType.networkError,
        ),
      ),
      messages: _FakeMessagesNotifier(
        const OwnChatMessagesState(
          sessionId: _sessionA,
          isDemo: true,
          isBackendBlocked: true,
          lastListError: ListOwnChatMessagesFailureType.backendBlocked,
        ),
      ),
    );

    expect(find.text('MODO DEMO SESIONES'), findsOneWidget);
    expect(find.text('Backend bloqueado para sesiones'), findsOneWidget);
    expect(find.text('MODO DEMO MENSAJES'), findsOneWidget);
    expect(find.text('Backend bloqueado para mensajes'), findsOneWidget);
    expect(find.textContaining('Error al cargar sesiones:'), findsOneWidget);
    expect(find.textContaining('Error al cargar mensajes:'), findsOneWidget);
  });

  testWidgets('safe shell text exposes no internal authority fields', (
    tester,
  ) async {
    await _pumpShell(
      tester,
      sessions: _FakeSessionsNotifier(
        OwnChatSessionsState(
          sessions: [_session(_sessionA)],
          selectedSessionId: _sessionA,
        ),
      ),
      messages: _FakeMessagesNotifier(
        const OwnChatMessagesState(sessionId: _sessionA),
      ),
    );

    for (final forbidden in [
      'userId',
      'ownerUserId',
      'specialistId',
      'agentId',
      'role',
      'token',
      'Authorization',
      'Supabase',
    ]) {
      expect(find.textContaining(forbidden), findsNothing);
    }
  });
}

Future<void> _pumpShell(
  WidgetTester tester, {
  required _FakeSessionsNotifier sessions,
  required _FakeMessagesNotifier messages,
  bool messagesAutoLoad = false,
}) async {
  tester.view.physicalSize = const Size(1200, 1200);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    ProviderScope(
      key: UniqueKey(),
      overrides: [
        ownChatSessionsControllerProvider.overrideWith((ref) => sessions),
        ownChatMessagesControllerProvider.overrideWith((ref) => messages),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 1100,
            width: 900,
            child: OwnChatComposedSafeShell(
              sessionsAutoLoad: false,
              messagesAutoLoad: messagesAutoLoad,
              onOpenSession: (_) {},
            ),
          ),
        ),
      ),
    ),
  );
}

OwnChatSession _session(String sessionId, {int minute = 1}) {
  final timestamp = DateTime.utc(2026, 6, 28, 10, minute);
  final selectableId = sessionId == _sessionB ? _selectableB : _selectableA;
  return OwnChatSession(
    sessionId: sessionId,
    selectableSpecialist: SelectableSpecialistSummary(
      id: selectableId,
      displayName: 'Especialista seguro $minute',
      area: SelectableSpecialistSummaryArea.wellness,
    ),
    startedAt: timestamp,
    lastMessageAt: timestamp,
    status: ChatSessionStatus.active,
    messageCount: 0,
  );
}

class _FakeSessionsNotifier extends OwnChatSessionsControllerNotifier {
  _FakeSessionsNotifier(OwnChatSessionsState initialState)
    : super(OwnChatSessionsController(repository: _NeverSessionsRepository())) {
    state = initialState;
  }

  final List<String> createdSelectableIds = [];
  final List<String> selectedSessionIds = [];
  final List<String> archivedSessionIds = [];

  @override
  Future<void> createSession(String selectableSpecialistId) async {
    final normalized = selectableSpecialistId.trim();
    createdSelectableIds.add(normalized);
    final created = _session(_sessionB, minute: 2);
    state = state.copyWith(
      sessions: [created, ...state.sessions],
      selectedSessionId: created.sessionId,
      lastCreatedSession: created,
      lastCreateError: null,
    );
  }

  @override
  void selectSession(String sessionId) {
    selectedSessionIds.add(sessionId);
    state = state.copyWith(selectedSessionId: sessionId, lastListError: null);
  }

  @override
  Future<void> archiveSession(String sessionId) async {
    archivedSessionIds.add(sessionId);
    state = state.copyWith(
      sessions: state.sessions
          .where((session) => session.sessionId != sessionId)
          .toList(growable: false),
      selectedSessionId: state.selectedSessionId == sessionId
          ? null
          : state.selectedSessionId,
      lastArchivedSessionId: sessionId,
      lastArchiveError: null,
    );
  }
}

class _FakeMessagesNotifier extends OwnChatMessagesControllerNotifier {
  _FakeMessagesNotifier(OwnChatMessagesState initialState)
    : super(OwnChatMessagesController(repository: _NeverMessagesRepository())) {
    state = initialState;
  }

  final List<String> loadedSessionIds = [];

  @override
  Future<void> loadInitial(String sessionId) async {
    loadedSessionIds.add(sessionId);
    state = OwnChatMessagesState(sessionId: sessionId);
  }
}

class _NeverSessionsRepository implements OwnChatSessionsRepository {
  @override
  Future<CreateOwnChatSessionResult> createOwnChatSession({
    required String selectableSpecialistId,
    required OperationAttemptId operationAttemptId,
  }) {
    throw StateError('Repository must not be called by composed shell tests.');
  }

  @override
  Future<ListOwnChatSessionsResult> listOwnChatSessions({
    ChatSessionStatusFilter status = ChatSessionStatusFilter.active,
    int limit = 20,
    String? cursor,
  }) {
    throw StateError('Repository must not be called by composed shell tests.');
  }

  @override
  Future<ArchiveOwnChatSessionResult> archiveOwnChatSession({
    required String sessionId,
  }) {
    throw StateError('Repository must not be called by composed shell tests.');
  }
}

class _NeverMessagesRepository implements OwnChatMessagesRepository {
  @override
  Future<ListSessionMessagesResult> listSessionMessages({
    required String sessionId,
    int limit = 50,
    String? cursor,
  }) {
    throw StateError('Repository must not be called by composed shell tests.');
  }

  @override
  Future<SendUserMessageResult> sendUserMessage({
    required String sessionId,
    required String content,
    required OperationAttemptId operationAttemptId,
  }) {
    throw StateError('Repository must not be called by composed shell tests.');
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:stasisly/core/config/app_environment.dart';
import 'package:stasisly/features/chat_sessions/application/own_chat_sessions_controller.dart';
import 'package:stasisly/features/chat_sessions/application/own_chat_sessions_state.dart';
import 'package:stasisly/features/chat_sessions/domain/entities/own_chat_session.dart';
import 'package:stasisly/features/chat_sessions/domain/entities/own_chat_session_results.dart';
import 'package:stasisly/features/chat_sessions/domain/repositories/own_chat_sessions_repository.dart';
import 'package:stasisly/features/chat_sessions/presentation/providers/own_chat_sessions_providers.dart';
import 'package:stasisly/features/chat_sessions/presentation/shell/own_chat_sessions_safe_shell.dart';
import 'package:stasisly/features/chat_sessions/presentation/shell/own_chat_sessions_shell_input_adapter.dart';
import 'package:stasisly/features/chat_sessions/presentation/widgets/own_chat_sessions_panel.dart';

const _session = '20000000-0000-4000-8000-0000000000f1';
const _selectable = '10000000-0000-4000-8000-0000000000f2';

void main() {
  test('shell input adapter accepts only approved keys', () {
    const adapter = OwnChatSessionsShellInputAdapter();

    expect(adapter.sessionIdFrom({'sessionId': '  $_session  '}), _session);
    expect(
      adapter.selectableSpecialistIdFrom({
        'selectableSpecialistId': '  $_selectable  ',
      }),
      _selectable,
    );

    expect(adapter.sessionIdFrom({'id': _session}), isNull);
    expect(adapter.sessionIdFrom({'agentId': _session}), isNull);
    expect(adapter.sessionIdFrom({'sessionId': ''}), isNull);
    expect(adapter.sessionIdFrom({'sessionId': '../$_session'}), isNull);
  });

  test('shell input adapter keeps approved values separate', () {
    const adapter = OwnChatSessionsShellInputAdapter();

    final input = adapter.from({
      'sessionId': _session,
      'selectableSpecialistId': _selectable,
    });

    expect(input?.sessionId, _session);
    expect(input?.selectableSpecialistId, _selectable);
    expect(adapter.from({'id': _session, 'agentId': _session}), isNull);
  });

  testWidgets('safe shell renders the approved sessions panel', (tester) async {
    await _pumpShell(
      tester,
      notifier: _FakeNotifier(const OwnChatSessionsState()),
    );

    expect(find.byType(OwnChatSessionsSafeShell), findsOneWidget);
    expect(find.byType(OwnChatSessionsPanel), findsOneWidget);
    expect(
      find.text('Shell seguro chat_sessions sin entrada inicial'),
      findsOneWidget,
    );
    expect(find.text('No hay sesiones todavía'), findsOneWidget);
  });

  testWidgets('safe shell displays only explicit safe input context', (
    tester,
  ) async {
    await _pumpShell(
      tester,
      input: const OwnChatSessionsShellInput(
        sessionId: _session,
        selectableSpecialistId: _selectable,
      ),
      notifier: _FakeNotifier(const OwnChatSessionsState()),
    );

    expect(find.text('Shell seguro chat_sessions'), findsOneWidget);
    expect(find.text('Entrada segura sessionId: $_session'), findsOneWidget);
    expect(
      find.text('Entrada segura selectableSpecialistId: $_selectable'),
      findsOneWidget,
    );
    expect(find.textContaining('agentId'), findsNothing);
    expect(find.textContaining('userId'), findsNothing);
    expect(find.textContaining('role'), findsNothing);
  });

  testWidgets('safe shell can show backendBlocked through real provider', (
    tester,
  ) async {
    await _pumpShellWithBackendBlockedProvider(tester);
    await tester.pump();

    expect(find.text('Backend bloqueado para sesiones'), findsOneWidget);
    expect(
      find.text(
        'Error al cargar sesiones: El backend real continúa bloqueado.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('safe shell allows explicit demo through provider override', (
    tester,
  ) async {
    await _pumpShell(
      tester,
      notifier: _FakeNotifier(
        OwnChatSessionsState(sessions: [_sessionItem()], isDemo: true),
      ),
    );

    expect(find.text('MODO DEMO SESIONES'), findsOneWidget);
    expect(find.text('Especialista ficticio shell'), findsOneWidget);
  });

  testWidgets('safe shell does not break panel operations', (tester) async {
    final notifier = _FakeNotifier(
      OwnChatSessionsState(sessions: [_sessionItem()]),
    );
    await _pumpShell(tester, notifier: notifier);

    await tester.enterText(find.byType(TextField), _selectable);
    await tester.tap(find.text('Crear sesión'));
    await tester.pump();

    await tester.ensureVisible(find.text('Seleccionar sessionId').first);
    await tester.tap(find.text('Seleccionar sessionId').first);
    await tester.pump();

    await tester.ensureVisible(find.text('Archivar sessionId').first);
    await tester.tap(find.text('Archivar sessionId').first);
    await tester.pump();

    expect(notifier.createdSelectableIds, [_selectable]);
    expect(notifier.selectedSessionIds, [_session]);
    expect(notifier.archivedSessionIds, [_session]);
  });
}

Future<void> _pumpShell(
  WidgetTester tester, {
  required _FakeNotifier notifier,
  OwnChatSessionsShellInput input = const OwnChatSessionsShellInput(),
}) async {
  tester.view.physicalSize = const Size(900, 1100);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    ProviderScope(
      key: UniqueKey(),
      overrides: [
        ownChatSessionsControllerProvider.overrideWith((ref) => notifier),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 650,
            width: 500,
            child: OwnChatSessionsSafeShell(input: input, autoLoad: false),
          ),
        ),
      ),
    ),
  );
}

Future<void> _pumpShellWithBackendBlockedProvider(WidgetTester tester) async {
  await tester.pumpWidget(
    ProviderScope(
      key: UniqueKey(),
      overrides: [
        appEnvironmentProvider.overrideWithValue(
          const AppEnvironment(mode: AppRuntimeMode.backendReal),
        ),
      ],
      child: const MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 650,
            width: 500,
            child: OwnChatSessionsSafeShell(),
          ),
        ),
      ),
    ),
  );
}

OwnChatSession _sessionItem() {
  final timestamp = DateTime.utc(2026, 6, 27, 12);
  return OwnChatSession(
    sessionId: _session,
    selectableSpecialist: const SelectableSpecialistSummary(
      id: _selectable,
      displayName: 'Especialista ficticio shell',
      area: SelectableSpecialistSummaryArea.wellness,
    ),
    startedAt: timestamp,
    lastMessageAt: timestamp,
    status: ChatSessionStatus.active,
    messageCount: 0,
  );
}

class _FakeNotifier extends OwnChatSessionsControllerNotifier {
  _FakeNotifier(OwnChatSessionsState initialState)
    : super(OwnChatSessionsController(repository: _NeverRepository())) {
    state = initialState;
  }

  final List<String> createdSelectableIds = [];
  final List<String> selectedSessionIds = [];
  final List<String> archivedSessionIds = [];

  @override
  Future<void> createSession(String selectableSpecialistId) async {
    createdSelectableIds.add(selectableSpecialistId);
    state = state.copyWith(
      sessions: [_sessionItem(), ...state.sessions],
      selectedSessionId: _session,
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
      lastArchiveError: null,
    );
  }
}

class _NeverRepository implements OwnChatSessionsRepository {
  @override
  Future<CreateOwnChatSessionResult> createOwnChatSession({
    required String selectableSpecialistId,
  }) {
    throw StateError('Repository must not be called by shell tests.');
  }

  @override
  Future<ListOwnChatSessionsResult> listOwnChatSessions({
    ChatSessionStatusFilter status = ChatSessionStatusFilter.active,
    int limit = 20,
    String? cursor,
  }) {
    throw StateError('Repository must not be called by shell tests.');
  }

  @override
  Future<ArchiveOwnChatSessionResult> archiveOwnChatSession({
    required String sessionId,
  }) {
    throw StateError('Repository must not be called by shell tests.');
  }
}

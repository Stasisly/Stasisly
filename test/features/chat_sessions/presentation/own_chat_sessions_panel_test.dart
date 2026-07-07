import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:stasisly/features/chat_sessions/application/own_chat_sessions_controller.dart';
import 'package:stasisly/features/chat_sessions/application/own_chat_sessions_state.dart';
import 'package:stasisly/features/chat_sessions/domain/entities/own_chat_session.dart';
import 'package:stasisly/features/chat_sessions/domain/entities/own_chat_session_results.dart';
import 'package:stasisly/features/chat_sessions/domain/repositories/own_chat_sessions_repository.dart';
import 'package:stasisly/features/chat_sessions/presentation/providers/own_chat_sessions_providers.dart';
import 'package:stasisly/features/chat_sessions/presentation/widgets/own_chat_sessions_panel.dart';

const _sessionA = '00000000-0000-4000-8000-0000000000a1';
const _sessionB = '00000000-0000-4000-8000-0000000000b2';
const _selectableA = '10000000-0000-4000-8000-0000000000a1';

void main() {
  testWidgets('renders loading and empty states', (tester) async {
    await _pumpPanel(
      tester,
      _FakeNotifier(const OwnChatSessionsState(isInitialLoading: true)),
    );

    expect(find.text('Cargando sesiones...'), findsOneWidget);

    await _pumpPanel(tester, _FakeNotifier(const OwnChatSessionsState()));

    expect(find.text('No hay sesiones todavía'), findsOneWidget);
    expect(find.text('selectedSessionId: sin selección'), findsOneWidget);
  });

  testWidgets('renders session list and selected session', (tester) async {
    await _pumpPanel(
      tester,
      _FakeNotifier(
        OwnChatSessionsState(
          sessions: [
            _session(_sessionA),
            _session(_sessionB, minute: 2, status: ChatSessionStatus.archived),
          ],
          selectedSessionId: _sessionB,
        ),
      ),
    );

    expect(find.text('Especialista seguro'), findsNWidgets(2));
    expect(find.text('sessionId: $_sessionA'), findsOneWidget);
    expect(find.text('sessionId: $_sessionB'), findsOneWidget);
    expect(find.text('selectedSessionId: $_sessionB'), findsOneWidget);
    expect(find.text('active sessions count: 1'), findsOneWidget);
    expect(find.text('all sessions count: 2'), findsOneWidget);
    expect(find.text('archived sessions count: 1'), findsOneWidget);
    expect(
      find.text('Fixture sintético retenido: development remoto'),
      findsOneWidget,
    );
    expect(
      find.text('Acciones de escritura dev-only: no automáticas'),
      findsOneWidget,
    );
    expect(find.text('Sesión seleccionada'), findsOneWidget);
  });

  testWidgets('renders demo label, backendBlocked and list error', (
    tester,
  ) async {
    await _pumpPanel(
      tester,
      _FakeNotifier(
        const OwnChatSessionsState(
          isDemo: true,
          isBackendBlocked: true,
          lastListError: OwnChatSessionsFailureType.networkError,
        ),
      ),
    );

    expect(find.text('MODO DEMO SESIONES'), findsOneWidget);
    expect(find.text('Backend bloqueado para sesiones'), findsOneWidget);
    expect(
      find.text(
        'Error al cargar sesiones: No se pudo contactar con el backend.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('create session sends only selectableSpecialistId', (
    tester,
  ) async {
    final notifier = _FakeNotifier(const OwnChatSessionsState());
    await _pumpPanel(tester, notifier);

    await tester.enterText(find.byType(TextField), '  $_selectableA  ');
    await tester.tap(find.text('Crear sesión'));
    await tester.pump();

    expect(notifier.createdSelectableIds, [_selectableA]);
    expect(notifier.createdSelectableIds, isNot(contains('agent-stasis-core')));
    expect(notifier.createdSelectableIds, isNot(contains(_sessionA)));
    expect(find.text('selectedSessionId: $_sessionA'), findsOneWidget);
    expect(find.text(_selectableA), findsNothing);
  });

  testWidgets('select session calls selectSession with sessionId', (
    tester,
  ) async {
    final notifier = _FakeNotifier(
      OwnChatSessionsState(sessions: [_session(_sessionA)]),
    );
    await _pumpPanel(tester, notifier);

    await tester.tap(find.text('Seleccionar sessionId'));
    await tester.pump();

    expect(notifier.selectedSessionIds, [_sessionA]);
    expect(notifier.selectedSessionIds, isNot(contains('agent-stasis-core')));
    expect(find.text('selectedSessionId: $_sessionA'), findsOneWidget);
  });

  testWidgets('archive session calls archiveSession with sessionId', (
    tester,
  ) async {
    final notifier = _FakeNotifier(
      OwnChatSessionsState(
        sessions: [_session(_sessionA), _session(_sessionB, minute: 2)],
        selectedSessionId: _sessionA,
      ),
    );
    await _pumpPanel(tester, notifier);

    await tester.tap(find.text('Archivar sessionId').first);
    await tester.pump();

    expect(notifier.archivedSessionIds, [_sessionA]);
    expect(notifier.archivedSessionIds, isNot(contains('agent-stasis-core')));
    expect(find.text('sessionId: $_sessionA'), findsNothing);
    expect(find.text('selectedSessionId: sin selección'), findsOneWidget);
  });

  testWidgets('refresh button calls refresh', (tester) async {
    final notifier = _FakeNotifier(const OwnChatSessionsState());
    await _pumpPanel(tester, notifier);

    await tester.tap(find.text('Refrescar'));
    await tester.pump();

    expect(notifier.refreshCalls, 1);
  });

  testWidgets('create error is visible without clearing sessions', (
    tester,
  ) async {
    final notifier = _FakeNotifier(
      OwnChatSessionsState(sessions: [_session(_sessionA)]),
      createFailure: OwnChatSessionsFailureType.invalidSelectableSpecialist,
    );
    await _pumpPanel(tester, notifier);

    await tester.enterText(find.byType(TextField), _selectableA);
    await tester.tap(find.text('Crear sesión'));
    await tester.pump();

    expect(find.text('sessionId: $_sessionA'), findsOneWidget);
    expect(
      find.text(
        'Error al crear sesión: El especialista seleccionable no es válido.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('archive error is visible without clearing sessions', (
    tester,
  ) async {
    final notifier = _FakeNotifier(
      OwnChatSessionsState(sessions: [_session(_sessionA)]),
      archiveFailure: OwnChatSessionsFailureType.sessionNotFound,
    );
    await _pumpPanel(tester, notifier);

    await tester.tap(find.text('Archivar sessionId'));
    await tester.pump();

    expect(find.text('sessionId: $_sessionA'), findsOneWidget);
    expect(
      find.text(
        'Error al archivar sesión: La sesión no existe o no está disponible.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('informational relation with messages is text only', (
    tester,
  ) async {
    await _pumpPanel(
      tester,
      _FakeNotifier(
        OwnChatSessionsState(
          sessions: [_session(_sessionA)],
          selectedSessionId: _sessionA,
        ),
      ),
    );

    expect(
      find.text('selectedSessionId disponible para futuro flujo de mensajes'),
      findsOneWidget,
    );
    expect(find.textContaining('userId'), findsNothing);
    expect(find.textContaining('agentId'), findsNothing);
    expect(find.textContaining('role'), findsNothing);
  });
}

Future<void> _pumpPanel(WidgetTester tester, _FakeNotifier notifier) async {
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
      child: const MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 900,
            width: 500,
            child: OwnChatSessionsPanel(autoLoad: false),
          ),
        ),
      ),
    ),
  );
}

OwnChatSession _session(
  String sessionId, {
  int minute = 1,
  ChatSessionStatus status = ChatSessionStatus.active,
}) {
  final timestamp = DateTime.utc(2026, 6, 26, 10, minute);
  return OwnChatSession(
    sessionId: sessionId,
    selectableSpecialist: const SelectableSpecialistSummary(
      id: _selectableA,
      displayName: 'Especialista seguro',
      area: SelectableSpecialistSummaryArea.wellness,
    ),
    startedAt: timestamp,
    lastMessageAt: timestamp,
    status: status,
    messageCount: 0,
  );
}

class _FakeNotifier extends OwnChatSessionsControllerNotifier {
  _FakeNotifier(
    OwnChatSessionsState initialState, {
    this.createFailure,
    this.archiveFailure,
  }) : super(OwnChatSessionsController(repository: _NeverRepository())) {
    state = initialState;
  }

  final OwnChatSessionsFailureType? createFailure;
  final OwnChatSessionsFailureType? archiveFailure;
  final List<String> createdSelectableIds = [];
  final List<String> selectedSessionIds = [];
  final List<String> archivedSessionIds = [];
  int refreshCalls = 0;

  @override
  Future<void> createSession(String selectableSpecialistId) async {
    createdSelectableIds.add(selectableSpecialistId);
    if (createFailure != null) {
      state = state.copyWith(lastCreateError: createFailure);
      return;
    }

    final session = _session(_sessionA);
    state = state.copyWith(
      sessions: [session, ...state.sessions],
      selectedSessionId: session.sessionId,
      lastCreateError: null,
      lastCreatedSession: session,
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
    if (archiveFailure != null) {
      state = state.copyWith(lastArchiveError: archiveFailure);
      return;
    }

    state = state.copyWith(
      sessions: state.sessions
          .where((session) => session.sessionId != sessionId)
          .toList(growable: false),
      selectedSessionId: state.selectedSessionId == sessionId
          ? null
          : state.selectedSessionId,
      lastArchiveError: null,
      lastArchivedSessionId: sessionId,
    );
  }

  @override
  Future<void> refresh({
    ChatSessionStatusFilter status = ChatSessionStatusFilter.active,
  }) async {
    refreshCalls++;
  }
}

class _NeverRepository implements OwnChatSessionsRepository {
  @override
  Future<CreateOwnChatSessionResult> createOwnChatSession({
    required String selectableSpecialistId,
  }) {
    throw UnimplementedError('Repository is not used by widget tests');
  }

  @override
  Future<ListOwnChatSessionsResult> listOwnChatSessions({
    ChatSessionStatusFilter status = ChatSessionStatusFilter.active,
    int limit = 20,
    String? cursor,
  }) {
    throw UnimplementedError('Repository is not used by widget tests');
  }

  @override
  Future<ArchiveOwnChatSessionResult> archiveOwnChatSession({
    required String sessionId,
  }) {
    throw UnimplementedError('Repository is not used by widget tests');
  }
}

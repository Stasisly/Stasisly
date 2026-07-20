import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stasisly/core/idempotency/operation_attempt_id.dart';
import 'package:stasisly/features/chat_sessions/application/own_chat_sessions_controller.dart';
import 'package:stasisly/features/chat_sessions/application/own_chat_sessions_state.dart';
import 'package:stasisly/features/chat_sessions/domain/entities/own_chat_session.dart';
import 'package:stasisly/features/chat_sessions/domain/entities/own_chat_session_results.dart';
import 'package:stasisly/features/chat_sessions/domain/repositories/own_chat_sessions_repository.dart';
import 'package:stasisly/features/chat_sessions/presentation/providers/own_chat_sessions_providers.dart';
import 'package:stasisly/features/chat_sessions/presentation/widgets/own_chat_sessions_panel.dart';

enum OwnChatSessionsPanelDevScenario {
  sessions,
  selected,
  empty,
  loading,
  demo,
  backendBlocked,
  listError,
  createError,
  archiveError,
  creating,
  archiving,
}

class OwnChatSessionsPanelDevHost extends StatelessWidget {
  const OwnChatSessionsPanelDevHost({
    super.key,
    this.scenario = OwnChatSessionsPanelDevScenario.sessions,
  });

  final OwnChatSessionsPanelDevScenario scenario;

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        ownChatSessionsControllerProvider.overrideWith(
          (ref) => _DevOwnChatSessionsNotifier.forScenario(scenario),
        ),
      ],
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: const Text('chat_sessions dev host')),
          body: const Padding(
            padding: EdgeInsets.all(16),
            child: OwnChatSessionsPanel(autoLoad: false),
          ),
        ),
      ),
    );
  }
}

class _DevOwnChatSessionsNotifier extends OwnChatSessionsControllerNotifier {
  _DevOwnChatSessionsNotifier(
    OwnChatSessionsState initialState, {
    this.createFailure,
    this.archiveFailure,
  }) : super(OwnChatSessionsController(repository: _NeverDevRepository())) {
    state = initialState;
  }

  factory _DevOwnChatSessionsNotifier.forScenario(
    OwnChatSessionsPanelDevScenario scenario,
  ) {
    return switch (scenario) {
      OwnChatSessionsPanelDevScenario.sessions => _DevOwnChatSessionsNotifier(
        OwnChatSessionsState(sessions: _fakeSessions),
      ),
      OwnChatSessionsPanelDevScenario.selected => _DevOwnChatSessionsNotifier(
        OwnChatSessionsState(
          sessions: _fakeSessions,
          selectedSessionId: _fakeSelectedSessionId,
        ),
      ),
      OwnChatSessionsPanelDevScenario.empty => _DevOwnChatSessionsNotifier(
        const OwnChatSessionsState(),
      ),
      OwnChatSessionsPanelDevScenario.loading => _DevOwnChatSessionsNotifier(
        const OwnChatSessionsState(isInitialLoading: true),
      ),
      OwnChatSessionsPanelDevScenario.demo => _DevOwnChatSessionsNotifier(
        OwnChatSessionsState(sessions: _fakeSessions, isDemo: true),
      ),
      OwnChatSessionsPanelDevScenario.backendBlocked =>
        _DevOwnChatSessionsNotifier(
          const OwnChatSessionsState(isBackendBlocked: true),
        ),
      OwnChatSessionsPanelDevScenario.listError => _DevOwnChatSessionsNotifier(
        const OwnChatSessionsState(
          lastListError: OwnChatSessionsFailureType.networkError,
        ),
      ),
      OwnChatSessionsPanelDevScenario.createError =>
        _DevOwnChatSessionsNotifier(
          OwnChatSessionsState(sessions: _fakeSessions),
          createFailure: OwnChatSessionsFailureType.invalidSelectableSpecialist,
        ),
      OwnChatSessionsPanelDevScenario.archiveError =>
        _DevOwnChatSessionsNotifier(
          OwnChatSessionsState(sessions: _fakeSessions),
          archiveFailure: OwnChatSessionsFailureType.sessionNotFound,
        ),
      OwnChatSessionsPanelDevScenario.creating => _DevOwnChatSessionsNotifier(
        OwnChatSessionsState(sessions: _fakeSessions, isCreating: true),
      ),
      OwnChatSessionsPanelDevScenario.archiving => _DevOwnChatSessionsNotifier(
        OwnChatSessionsState(sessions: _fakeSessions, isArchiving: true),
      ),
    };
  }

  final OwnChatSessionsFailureType? createFailure;
  final OwnChatSessionsFailureType? archiveFailure;

  @override
  Future<void> createSession(String selectableSpecialistId) async {
    final normalized = selectableSpecialistId.trim();
    if (createFailure != null) {
      state = state.copyWith(isCreating: false, lastCreateError: createFailure);
      return;
    }

    final created = _fakeSession(
      sessionId: _fakeCreatedSessionId,
      selectableSpecialistId: normalized,
      displayName: 'Especialista ficticio creado',
      minute: 12,
    );
    state = state.copyWith(
      sessions: [created, ...state.sessions],
      selectedSessionId: created.sessionId,
      isCreating: false,
      isDemo: true,
      lastCreateError: null,
      lastCreatedSession: created,
    );
  }

  @override
  void selectSession(String sessionId) {
    state = state.copyWith(selectedSessionId: sessionId, lastListError: null);
  }

  @override
  Future<void> archiveSession(String sessionId) async {
    if (archiveFailure != null) {
      state = state.copyWith(
        isArchiving: false,
        lastArchiveError: archiveFailure,
      );
      return;
    }

    final remaining = state.sessions
        .where((session) => session.sessionId != sessionId)
        .toList(growable: false);
    state = state.copyWith(
      sessions: remaining,
      selectedSessionId: state.selectedSessionId == sessionId
          ? null
          : state.selectedSessionId,
      isArchiving: false,
      lastArchiveError: null,
      lastArchivedSessionId: sessionId,
    );
  }

  @override
  Future<void> refresh({
    ChatSessionStatusFilter status = ChatSessionStatusFilter.active,
  }) async {
    state = state.copyWith(
      sessions: _fakeSessions,
      selectedSessionId: null,
      isRefreshing: false,
      lastListError: null,
    );
  }
}

class _NeverDevRepository implements OwnChatSessionsRepository {
  @override
  Future<CreateOwnChatSessionResult> createOwnChatSession({
    required String selectableSpecialistId,
    required OperationAttemptId operationAttemptId,
  }) {
    throw UnimplementedError('The dev host uses provider overrides only');
  }

  @override
  Future<ListOwnChatSessionsResult> listOwnChatSessions({
    ChatSessionStatusFilter status = ChatSessionStatusFilter.active,
    int limit = 20,
    String? cursor,
  }) {
    throw UnimplementedError('The dev host uses provider overrides only');
  }

  @override
  Future<ArchiveOwnChatSessionResult> archiveOwnChatSession({
    required String sessionId,
  }) {
    throw UnimplementedError('The dev host uses provider overrides only');
  }
}

const _fakeSelectedSessionId = '20000000-0000-4000-8000-0000000000a1';
const _fakeCreatedSessionId = '20000000-0000-4000-8000-0000000000c3';
const _fakeSelectableIdA = '10000000-0000-4000-8000-0000000000a1';
const _fakeSelectableIdB = '10000000-0000-4000-8000-0000000000b2';

final _fakeSessions = <OwnChatSession>[
  _fakeSession(
    sessionId: _fakeSelectedSessionId,
    selectableSpecialistId: _fakeSelectableIdA,
    displayName: 'Especialista ficticio Wellness',
    minute: 1,
  ),
  _fakeSession(
    sessionId: '20000000-0000-4000-8000-0000000000b2',
    selectableSpecialistId: _fakeSelectableIdB,
    displayName: 'Especialista ficticio Salud',
    area: SelectableSpecialistSummaryArea.health,
    minute: 2,
    count: 3,
  ),
];

OwnChatSession _fakeSession({
  required String sessionId,
  required String selectableSpecialistId,
  required String displayName,
  required int minute,
  SelectableSpecialistSummaryArea area =
      SelectableSpecialistSummaryArea.wellness,
  int count = 0,
}) {
  final timestamp = DateTime.utc(2026, 6, 27, 10, minute);
  return OwnChatSession(
    sessionId: sessionId,
    selectableSpecialist: SelectableSpecialistSummary(
      id: selectableSpecialistId,
      displayName: displayName,
      area: area,
    ),
    startedAt: timestamp,
    lastMessageAt: timestamp,
    status: ChatSessionStatus.active,
    messageCount: count,
  );
}

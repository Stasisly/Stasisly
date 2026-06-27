import 'package:flutter_test/flutter_test.dart';

import 'package:stasisly/features/chat_sessions/application/own_chat_sessions_controller.dart';
import 'package:stasisly/features/chat_sessions/application/own_chat_sessions_state.dart';
import 'package:stasisly/features/chat_sessions/domain/entities/own_chat_session.dart';
import 'package:stasisly/features/chat_sessions/domain/entities/own_chat_session_results.dart';
import 'package:stasisly/features/chat_sessions/domain/repositories/own_chat_sessions_repository.dart';

void main() {
  const sessionA = '00000000-0000-4000-8000-0000000000a1';
  const sessionB = '00000000-0000-4000-8000-0000000000b2';
  const selectableA = '10000000-0000-4000-8000-0000000000a1';

  test('initial state has no sessions, selection, loading or errors', () {
    const state = OwnChatSessionsState();

    expect(state.sessions, isEmpty);
    expect(state.selectedSessionId, isNull);
    expect(state.selectedSession, isNull);
    expect(state.isInitialLoading, isFalse);
    expect(state.isRefreshing, isFalse);
    expect(state.isCreating, isFalse);
    expect(state.isArchiving, isFalse);
    expect(state.isDemo, isFalse);
    expect(state.isBackendBlocked, isFalse);
    expect(state.lastListError, isNull);
    expect(state.lastCreateError, isNull);
    expect(state.lastArchiveError, isNull);
  });

  test('loadInitial stores own sessions and next cursor', () async {
    final repository = _FakeOwnChatSessionsRepository(
      listResults: [
        ListOwnChatSessionsSuccess(
          OwnChatSessionsPage(
            items: [_session(sessionA), _session(sessionB, minute: 2)],
            nextCursor: 'cursor-1',
          ),
        ),
      ],
    );
    final controller = OwnChatSessionsController(repository: repository);

    await controller.loadInitial();

    expect(repository.listCalls.single.limit, 20);
    expect(repository.listCalls.single.status, ChatSessionStatusFilter.active);
    expect(controller.state.sessions.map((session) => session.sessionId), [
      sessionA,
      sessionB,
    ]);
    expect(controller.state.nextCursor, 'cursor-1');
    expect(controller.state.lastListError, isNull);
  });

  test('loadInitial empty does not invent sessions', () async {
    final controller = OwnChatSessionsController(
      repository: _FakeOwnChatSessionsRepository(
        listResults: const [
          ListOwnChatSessionsSuccess(
            OwnChatSessionsPage(items: [], nextCursor: null),
          ),
        ],
      ),
    );

    await controller.loadInitial();

    expect(controller.state.sessions, isEmpty);
    expect(controller.state.isEmpty, isTrue);
    expect(controller.state.selectedSessionId, isNull);
  });

  test('loadInitial maps errors without demo fallback', () async {
    final controller = OwnChatSessionsController(
      repository: _FakeOwnChatSessionsRepository(
        listResults: const [
          ListOwnChatSessionsFailure(OwnChatSessionsFailureType.networkError),
        ],
      ),
    );

    await controller.loadInitial();

    expect(
      controller.state.lastListError,
      OwnChatSessionsFailureType.networkError,
    );
    expect(controller.state.sessions, isEmpty);
    expect(controller.state.isDemo, isFalse);
    expect(controller.state.isBackendBlocked, isFalse);
  });

  test(
    'backendBlocked list result stays explicit and never becomes demo',
    () async {
      final controller = OwnChatSessionsController(
        repository: _FakeOwnChatSessionsRepository(
          listResults: const [
            ListOwnChatSessionsFailure(
              OwnChatSessionsFailureType.backendBlocked,
            ),
          ],
        ),
      );

      await controller.loadInitial();

      expect(controller.state.isBackendBlocked, isTrue);
      expect(controller.state.isDemo, isFalse);
    },
  );

  test(
    'demo repository result is demo only when explicitly injected',
    () async {
      final controller = OwnChatSessionsController(
        repository: _FakeOwnChatSessionsRepository(
          listResults: [
            ListOwnChatSessionsDemo(
              OwnChatSessionsPage(
                items: [_session(sessionA)],
                nextCursor: null,
              ),
            ),
          ],
        ),
      );

      await controller.loadInitial();

      expect(controller.state.isDemo, isTrue);
      expect(controller.state.isBackendBlocked, isFalse);
      expect(controller.state.sessions.single.sessionId, sessionA);
    },
  );

  test(
    'refresh replaces confirmed list and preserves existing selection',
    () async {
      final repository = _FakeOwnChatSessionsRepository(
        listResults: [
          ListOwnChatSessionsSuccess(
            OwnChatSessionsPage(
              items: [_session(sessionA), _session(sessionB)],
              nextCursor: null,
            ),
          ),
          ListOwnChatSessionsSuccess(
            OwnChatSessionsPage(
              items: [_session(sessionB, minute: 4)],
              nextCursor: null,
            ),
          ),
        ],
      );
      final controller = OwnChatSessionsController(repository: repository);

      await controller.loadInitial();
      controller.selectSession(sessionB);
      await controller.refresh();

      expect(controller.state.sessions.map((session) => session.sessionId), [
        sessionB,
      ]);
      expect(controller.state.selectedSessionId, sessionB);
      expect(controller.state.lastListError, isNull);
    },
  );

  test('refresh clears selection when selected session disappears', () async {
    final repository = _FakeOwnChatSessionsRepository(
      listResults: [
        ListOwnChatSessionsSuccess(
          OwnChatSessionsPage(items: [_session(sessionA)], nextCursor: null),
        ),
        const ListOwnChatSessionsSuccess(
          OwnChatSessionsPage(items: [], nextCursor: null),
        ),
      ],
    );
    final controller = OwnChatSessionsController(repository: repository);

    await controller.loadInitial();
    controller.selectSession(sessionA);
    await controller.refresh();

    expect(controller.state.selectedSessionId, isNull);
    expect(controller.state.sessions, isEmpty);
  });

  test('refresh error preserves existing sessions', () async {
    final repository = _FakeOwnChatSessionsRepository(
      listResults: [
        ListOwnChatSessionsSuccess(
          OwnChatSessionsPage(items: [_session(sessionA)], nextCursor: null),
        ),
        const ListOwnChatSessionsFailure(
          OwnChatSessionsFailureType.contractViolation,
        ),
      ],
    );
    final controller = OwnChatSessionsController(repository: repository);

    await controller.loadInitial();
    await controller.refresh();

    expect(controller.state.sessions.single.sessionId, sessionA);
    expect(
      controller.state.lastListError,
      OwnChatSessionsFailureType.contractViolation,
    );
    expect(controller.state.isDemo, isFalse);
  });

  test(
    'createSession sends only selectableSpecialistId and exposes sessionId',
    () async {
      final repository = _FakeOwnChatSessionsRepository(
        createResults: [
          CreateOwnChatSessionSuccess(
            _session(sessionA, selectableId: selectableA),
          ),
        ],
      );
      final controller = OwnChatSessionsController(repository: repository);

      await controller.createSession(selectableA);

      expect(repository.createCalls.single.selectableSpecialistId, selectableA);
      expect(controller.state.sessions.single.sessionId, sessionA);
      expect(controller.state.selectedSessionId, sessionA);
      expect(controller.state.lastCreatedSession?.sessionId, sessionA);
      expect(controller.state.lastCreateError, isNull);
    },
  );

  test('createSession does not duplicate an existing session', () async {
    final repository = _FakeOwnChatSessionsRepository(
      listResults: [
        ListOwnChatSessionsSuccess(
          OwnChatSessionsPage(items: [_session(sessionA)], nextCursor: null),
        ),
      ],
      createResults: [
        CreateOwnChatSessionSuccess(_session(sessionA, minute: 5)),
      ],
    );
    final controller = OwnChatSessionsController(repository: repository);

    await controller.loadInitial();
    await controller.createSession(selectableA);

    expect(controller.state.sessions, hasLength(1));
    expect(controller.state.sessions.single.sessionId, sessionA);
    expect(controller.state.selectedSessionId, sessionA);
  });

  test(
    'create error preserves current list and never falls back to demo',
    () async {
      final repository = _FakeOwnChatSessionsRepository(
        listResults: [
          ListOwnChatSessionsSuccess(
            OwnChatSessionsPage(items: [_session(sessionA)], nextCursor: null),
          ),
        ],
        createResults: const [
          CreateOwnChatSessionFailure(
            OwnChatSessionsFailureType.backendBlocked,
          ),
        ],
      );
      final controller = OwnChatSessionsController(repository: repository);

      await controller.loadInitial();
      await controller.createSession(selectableA);

      expect(controller.state.sessions.single.sessionId, sessionA);
      expect(
        controller.state.lastCreateError,
        OwnChatSessionsFailureType.backendBlocked,
      );
      expect(controller.state.isBackendBlocked, isTrue);
      expect(controller.state.isDemo, isFalse);
    },
  );

  test(
    'archiveSession sends only sessionId and clears selected archived session',
    () async {
      final repository = _FakeOwnChatSessionsRepository(
        listResults: [
          ListOwnChatSessionsSuccess(
            OwnChatSessionsPage(
              items: [_session(sessionA), _session(sessionB)],
              nextCursor: null,
            ),
          ),
        ],
        archiveResults: const [
          ArchiveOwnChatSessionSuccess(
            ArchivedOwnChatSession(sessionId: sessionA),
          ),
        ],
      );
      final controller = OwnChatSessionsController(repository: repository);

      await controller.loadInitial();
      controller.selectSession(sessionA);
      await controller.archiveSession(sessionA);

      expect(repository.archiveCalls.single.sessionId, sessionA);
      expect(controller.state.sessions.map((session) => session.sessionId), [
        sessionB,
      ]);
      expect(controller.state.selectedSessionId, isNull);
      expect(controller.state.lastArchivedSessionId, sessionA);
    },
  );

  test('archive error preserves existing list and selection', () async {
    final repository = _FakeOwnChatSessionsRepository(
      listResults: [
        ListOwnChatSessionsSuccess(
          OwnChatSessionsPage(items: [_session(sessionA)], nextCursor: null),
        ),
      ],
      archiveResults: const [
        ArchiveOwnChatSessionFailure(
          OwnChatSessionsFailureType.sessionNotFound,
        ),
      ],
    );
    final controller = OwnChatSessionsController(repository: repository);

    await controller.loadInitial();
    controller.selectSession(sessionA);
    await controller.archiveSession(sessionA);

    expect(controller.state.sessions.single.sessionId, sessionA);
    expect(controller.state.selectedSessionId, sessionA);
    expect(
      controller.state.lastArchiveError,
      OwnChatSessionsFailureType.sessionNotFound,
    );
  });

  test('archiveSession rejects inherited ids before repository call', () async {
    final repository = _FakeOwnChatSessionsRepository(
      listResults: [
        ListOwnChatSessionsSuccess(
          OwnChatSessionsPage(items: [_session(sessionA)], nextCursor: null),
        ),
      ],
    );
    final controller = OwnChatSessionsController(repository: repository);

    await controller.loadInitial();
    await controller.archiveSession('agent-stasis-core');

    expect(repository.archiveCalls, isEmpty);
    expect(controller.state.sessions.single.sessionId, sessionA);
    expect(
      controller.state.lastArchiveError,
      OwnChatSessionsFailureType.invalidRequest,
    );
  });

  test(
    'selectSession selects only an existing sessionId and rejects inherited ids',
    () async {
      final controller = OwnChatSessionsController(
        repository: _FakeOwnChatSessionsRepository(
          listResults: [
            ListOwnChatSessionsSuccess(
              OwnChatSessionsPage(
                items: [_session(sessionA)],
                nextCursor: null,
              ),
            ),
          ],
        ),
      );

      await controller.loadInitial();
      controller.selectSession(sessionA);
      expect(controller.state.selectedSessionId, sessionA);

      controller.selectSession('agent-stasis-core');
      expect(controller.state.selectedSessionId, isNull);
      expect(
        controller.state.lastListError,
        OwnChatSessionsFailureType.invalidRequest,
      );
    },
  );

  test('clearSelection and clear reset safe state', () async {
    final controller = OwnChatSessionsController(
      repository: _FakeOwnChatSessionsRepository(
        listResults: [
          ListOwnChatSessionsSuccess(
            OwnChatSessionsPage(items: [_session(sessionA)], nextCursor: null),
          ),
        ],
      ),
    );

    await controller.loadInitial();
    controller
      ..selectSession(sessionA)
      ..clearSelection();
    expect(controller.state.selectedSessionId, isNull);

    controller.clear();
    expect(controller.state, const OwnChatSessionsState());
  });

  test('selectedSessionId is the only value intended for messages', () async {
    final controller = OwnChatSessionsController(
      repository: _FakeOwnChatSessionsRepository(
        listResults: [
          ListOwnChatSessionsSuccess(
            OwnChatSessionsPage(items: [_session(sessionA)], nextCursor: null),
          ),
        ],
      ),
    );

    await controller.loadInitial();
    controller.selectSession(sessionA);

    expect(controller.state.selectedSessionId, sessionA);
    expect(controller.state.selectedSession?.sessionId, sessionA);
  });
}

OwnChatSession _session(
  String sessionId, {
  String selectableId = '10000000-0000-4000-8000-000000000001',
  int minute = 1,
}) {
  final timestamp = DateTime.utc(2026, 6, 26, 10, minute);
  return OwnChatSession(
    sessionId: sessionId,
    selectableSpecialist: SelectableSpecialistSummary(
      id: selectableId,
      displayName: 'Especialista seguro',
      area: SelectableSpecialistSummaryArea.wellness,
    ),
    startedAt: timestamp,
    lastMessageAt: timestamp,
    status: ChatSessionStatus.active,
    messageCount: 0,
  );
}

class _FakeOwnChatSessionsRepository implements OwnChatSessionsRepository {
  _FakeOwnChatSessionsRepository({
    List<ListOwnChatSessionsResult>? listResults,
    List<CreateOwnChatSessionResult>? createResults,
    List<ArchiveOwnChatSessionResult>? archiveResults,
  }) : _listResults = List.of(listResults ?? const []),
       _createResults = List.of(createResults ?? const []),
       _archiveResults = List.of(archiveResults ?? const []);

  final List<ListOwnChatSessionsResult> _listResults;
  final List<CreateOwnChatSessionResult> _createResults;
  final List<ArchiveOwnChatSessionResult> _archiveResults;

  final List<_ListCall> listCalls = [];
  final List<_CreateCall> createCalls = [];
  final List<_ArchiveCall> archiveCalls = [];

  @override
  Future<CreateOwnChatSessionResult> createOwnChatSession({
    required String selectableSpecialistId,
  }) async {
    createCalls.add(_CreateCall(selectableSpecialistId));
    return _createResults.isEmpty
        ? const CreateOwnChatSessionFailure(
            OwnChatSessionsFailureType.unexpectedError,
          )
        : _createResults.removeAt(0);
  }

  @override
  Future<ListOwnChatSessionsResult> listOwnChatSessions({
    ChatSessionStatusFilter status = ChatSessionStatusFilter.active,
    int limit = 20,
    String? cursor,
  }) async {
    listCalls.add(_ListCall(status, limit, cursor));
    return _listResults.isEmpty
        ? const ListOwnChatSessionsFailure(
            OwnChatSessionsFailureType.unexpectedError,
          )
        : _listResults.removeAt(0);
  }

  @override
  Future<ArchiveOwnChatSessionResult> archiveOwnChatSession({
    required String sessionId,
  }) async {
    archiveCalls.add(_ArchiveCall(sessionId));
    return _archiveResults.isEmpty
        ? const ArchiveOwnChatSessionFailure(
            OwnChatSessionsFailureType.unexpectedError,
          )
        : _archiveResults.removeAt(0);
  }
}

class _ListCall {
  const _ListCall(this.status, this.limit, this.cursor);

  final ChatSessionStatusFilter status;
  final int limit;
  final String? cursor;
}

class _CreateCall {
  const _CreateCall(this.selectableSpecialistId);

  final String selectableSpecialistId;
}

class _ArchiveCall {
  const _ArchiveCall(this.sessionId);

  final String sessionId;
}

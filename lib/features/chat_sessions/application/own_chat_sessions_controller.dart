import 'package:stasisly/features/chat_sessions/application/own_chat_sessions_state.dart';
import 'package:stasisly/features/chat_sessions/domain/entities/own_chat_session.dart';
import 'package:stasisly/features/chat_sessions/domain/entities/own_chat_session_results.dart';
import 'package:stasisly/features/chat_sessions/domain/repositories/own_chat_sessions_repository.dart';

class OwnChatSessionsController {
  OwnChatSessionsController({
    required OwnChatSessionsRepository repository,
    this.pageSize = 20,
  }) : _repository = repository;

  final OwnChatSessionsRepository _repository;
  final int pageSize;

  OwnChatSessionsState state = const OwnChatSessionsState();

  Future<void> loadInitial({
    ChatSessionStatusFilter status = ChatSessionStatusFilter.active,
  }) async {
    state = state.copyWith(
      isInitialLoading: true,
      lastListError: null,
      isBackendBlocked: false,
    );
    final result = await _repository.listOwnChatSessions(
      status: status,
      limit: pageSize,
    );
    state = _stateFromListResult(
      previous: state,
      result: result,
      loadingFlag: _ListLoadingFlag.initial,
    );
  }

  Future<void> refresh({
    ChatSessionStatusFilter status = ChatSessionStatusFilter.active,
  }) async {
    state = state.copyWith(
      isRefreshing: true,
      lastListError: null,
      isBackendBlocked: false,
    );
    final result = await _repository.listOwnChatSessions(
      status: status,
      limit: pageSize,
    );
    state = _stateFromListResult(
      previous: state,
      result: result,
      loadingFlag: _ListLoadingFlag.refresh,
    );
  }

  Future<void> createSession(String selectableSpecialistId) async {
    state = state.copyWith(
      isCreating: true,
      lastCreateError: null,
      isBackendBlocked: false,
      lastCreatedSession: null,
    );
    final result = await _repository.createOwnChatSession(
      selectableSpecialistId: selectableSpecialistId,
    );
    state = _stateFromCreateResult(state, result);
  }

  Future<void> archiveSession(String sessionId) async {
    if (sessionId.trim().isEmpty ||
        !_containsSession(state.sessions, sessionId)) {
      state = state.copyWith(
        lastArchiveError: OwnChatSessionsFailureType.invalidRequest,
      );
      return;
    }
    state = state.copyWith(
      isArchiving: true,
      lastArchiveError: null,
      isBackendBlocked: false,
      lastArchivedSessionId: null,
    );
    final result = await _repository.archiveOwnChatSession(
      sessionId: sessionId,
    );
    state = _stateFromArchiveResult(state, result);
  }

  void selectSession(String sessionId) {
    if (sessionId.trim().isEmpty ||
        !_containsSession(state.sessions, sessionId)) {
      state = state.copyWith(
        selectedSessionId: null,
        lastListError: OwnChatSessionsFailureType.invalidRequest,
      );
      return;
    }
    state = state.copyWith(selectedSessionId: sessionId, lastListError: null);
  }

  void clearSelection() {
    state = state.copyWith(selectedSessionId: null);
  }

  void clear() {
    state = const OwnChatSessionsState();
  }

  OwnChatSessionsState _stateFromListResult({
    required OwnChatSessionsState previous,
    required ListOwnChatSessionsResult result,
    required _ListLoadingFlag loadingFlag,
  }) {
    final clearedLoading = _clearListLoading(previous, loadingFlag);
    return switch (result) {
      ListOwnChatSessionsSuccess(:final page) => _replaceSessions(
        clearedLoading,
        page.items,
        page.nextCursor,
        isDemo: false,
      ),
      ListOwnChatSessionsDemo(:final page) => _replaceSessions(
        clearedLoading,
        page.items,
        page.nextCursor,
        isDemo: true,
      ),
      ListOwnChatSessionsFailure(:final type) => clearedLoading.copyWith(
        lastListError: type,
        isBackendBlocked: type == OwnChatSessionsFailureType.backendBlocked,
      ),
    };
  }

  OwnChatSessionsState _stateFromCreateResult(
    OwnChatSessionsState previous,
    CreateOwnChatSessionResult result,
  ) {
    return switch (result) {
      CreateOwnChatSessionSuccess(:final session) => _storeCreatedSession(
        previous,
        session,
        isDemo: false,
      ),
      CreateOwnChatSessionDemo(:final session) => _storeCreatedSession(
        previous,
        session,
        isDemo: true,
      ),
      CreateOwnChatSessionFailure(:final type) => previous.copyWith(
        isCreating: false,
        lastCreateError: type,
        isBackendBlocked: type == OwnChatSessionsFailureType.backendBlocked,
      ),
    };
  }

  OwnChatSessionsState _stateFromArchiveResult(
    OwnChatSessionsState previous,
    ArchiveOwnChatSessionResult result,
  ) {
    return switch (result) {
      ArchiveOwnChatSessionSuccess(:final session) => _storeArchivedSession(
        previous,
        session.sessionId,
        isDemo: false,
      ),
      ArchiveOwnChatSessionDemo(:final session) => _storeArchivedSession(
        previous,
        session.sessionId,
        isDemo: true,
      ),
      ArchiveOwnChatSessionFailure(:final type) => previous.copyWith(
        isArchiving: false,
        lastArchiveError: type,
        isBackendBlocked: type == OwnChatSessionsFailureType.backendBlocked,
      ),
    };
  }

  OwnChatSessionsState _replaceSessions(
    OwnChatSessionsState previous,
    List<OwnChatSession> sessions,
    String? nextCursor, {
    required bool isDemo,
  }) {
    final unique = _uniqueBySessionId(sessions);
    final selected = previous.selectedSessionId;
    final keepSelection =
        selected != null && _containsSession(unique, selected);
    return previous.copyWith(
      sessions: unique,
      selectedSessionId: keepSelection ? selected : null,
      nextCursor: nextCursor,
      isDemo: isDemo,
      isBackendBlocked: false,
      lastListError: null,
      lastCreateError: null,
      lastArchiveError: null,
    );
  }

  OwnChatSessionsState _storeCreatedSession(
    OwnChatSessionsState previous,
    OwnChatSession session, {
    required bool isDemo,
  }) {
    final sessions = _upsertFirst(previous.sessions, session);
    return previous.copyWith(
      sessions: sessions,
      selectedSessionId: session.sessionId,
      isCreating: false,
      isDemo: isDemo,
      isBackendBlocked: false,
      lastCreateError: null,
      lastCreatedSession: session,
    );
  }

  OwnChatSessionsState _storeArchivedSession(
    OwnChatSessionsState previous,
    String sessionId, {
    required bool isDemo,
  }) {
    final sessions = previous.sessions
        .where((session) => session.sessionId != sessionId)
        .toList(growable: false);
    final selected = previous.selectedSessionId == sessionId
        ? null
        : previous.selectedSessionId;
    return previous.copyWith(
      sessions: List.unmodifiable(sessions),
      selectedSessionId: selected,
      isArchiving: false,
      isDemo: isDemo,
      isBackendBlocked: false,
      lastArchiveError: null,
      lastArchivedSessionId: sessionId,
    );
  }

  OwnChatSessionsState _clearListLoading(
    OwnChatSessionsState state,
    _ListLoadingFlag flag,
  ) {
    return switch (flag) {
      _ListLoadingFlag.initial => state.copyWith(isInitialLoading: false),
      _ListLoadingFlag.refresh => state.copyWith(isRefreshing: false),
    };
  }

  List<OwnChatSession> _upsertFirst(
    List<OwnChatSession> sessions,
    OwnChatSession session,
  ) {
    final withoutSession = sessions
        .where((item) => item.sessionId != session.sessionId)
        .toList(growable: false);
    return List.unmodifiable([session, ...withoutSession]);
  }

  List<OwnChatSession> _uniqueBySessionId(List<OwnChatSession> sessions) {
    final seen = <String>{};
    final result = <OwnChatSession>[];
    for (final session in sessions) {
      if (seen.add(session.sessionId)) result.add(session);
    }
    return List.unmodifiable(result);
  }

  bool _containsSession(List<OwnChatSession> sessions, String sessionId) {
    return sessions.any((session) => session.sessionId == sessionId);
  }
}

enum _ListLoadingFlag { initial, refresh }

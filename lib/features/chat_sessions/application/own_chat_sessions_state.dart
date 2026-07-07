import 'package:equatable/equatable.dart';

import 'package:stasisly/features/chat_sessions/domain/entities/own_chat_session.dart';
import 'package:stasisly/features/chat_sessions/domain/entities/own_chat_session_results.dart';

class OwnChatSessionsState extends Equatable {
  const OwnChatSessionsState({
    this.sessions = const [],
    this.selectedSessionId,
    this.nextCursor,
    this.isInitialLoading = false,
    this.isRefreshing = false,
    this.isCreating = false,
    this.isArchiving = false,
    this.isDemo = false,
    this.isBackendBlocked = false,
    this.lastListError,
    this.lastCreateError,
    this.lastArchiveError,
    this.lastCreatedSession,
    this.lastArchivedSessionId,
  });

  final List<OwnChatSession> sessions;
  final String? selectedSessionId;
  final String? nextCursor;
  final bool isInitialLoading;
  final bool isRefreshing;
  final bool isCreating;
  final bool isArchiving;
  final bool isDemo;
  final bool isBackendBlocked;
  final OwnChatSessionsFailureType? lastListError;
  final OwnChatSessionsFailureType? lastCreateError;
  final OwnChatSessionsFailureType? lastArchiveError;
  final OwnChatSession? lastCreatedSession;
  final String? lastArchivedSessionId;

  OwnChatSession? get selectedSession {
    final id = selectedSessionId;
    if (id == null) return null;
    for (final session in sessions) {
      if (session.sessionId == id) return session;
    }
    return null;
  }

  bool get hasSessions => sessions.isNotEmpty;

  int get activeCount {
    return sessions
        .where((session) => session.status == ChatSessionStatus.active)
        .length;
  }

  int get archivedCount {
    return sessions
        .where((session) => session.status == ChatSessionStatus.archived)
        .length;
  }

  bool get isEmpty => sessions.isEmpty && !hasActiveWork;

  bool get hasActiveWork {
    return isInitialLoading || isRefreshing || isCreating || isArchiving;
  }

  OwnChatSessionsState copyWith({
    List<OwnChatSession>? sessions,
    Object? selectedSessionId = _sentinel,
    Object? nextCursor = _sentinel,
    bool? isInitialLoading,
    bool? isRefreshing,
    bool? isCreating,
    bool? isArchiving,
    bool? isDemo,
    bool? isBackendBlocked,
    Object? lastListError = _sentinel,
    Object? lastCreateError = _sentinel,
    Object? lastArchiveError = _sentinel,
    Object? lastCreatedSession = _sentinel,
    Object? lastArchivedSessionId = _sentinel,
  }) {
    return OwnChatSessionsState(
      sessions: sessions ?? this.sessions,
      selectedSessionId: identical(selectedSessionId, _sentinel)
          ? this.selectedSessionId
          : selectedSessionId as String?,
      nextCursor: identical(nextCursor, _sentinel)
          ? this.nextCursor
          : nextCursor as String?,
      isInitialLoading: isInitialLoading ?? this.isInitialLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isCreating: isCreating ?? this.isCreating,
      isArchiving: isArchiving ?? this.isArchiving,
      isDemo: isDemo ?? this.isDemo,
      isBackendBlocked: isBackendBlocked ?? this.isBackendBlocked,
      lastListError: identical(lastListError, _sentinel)
          ? this.lastListError
          : lastListError as OwnChatSessionsFailureType?,
      lastCreateError: identical(lastCreateError, _sentinel)
          ? this.lastCreateError
          : lastCreateError as OwnChatSessionsFailureType?,
      lastArchiveError: identical(lastArchiveError, _sentinel)
          ? this.lastArchiveError
          : lastArchiveError as OwnChatSessionsFailureType?,
      lastCreatedSession: identical(lastCreatedSession, _sentinel)
          ? this.lastCreatedSession
          : lastCreatedSession as OwnChatSession?,
      lastArchivedSessionId: identical(lastArchivedSessionId, _sentinel)
          ? this.lastArchivedSessionId
          : lastArchivedSessionId as String?,
    );
  }

  @override
  List<Object?> get props => [
    sessions,
    selectedSessionId,
    nextCursor,
    isInitialLoading,
    isRefreshing,
    isCreating,
    isArchiving,
    isDemo,
    isBackendBlocked,
    lastListError,
    lastCreateError,
    lastArchiveError,
    lastCreatedSession,
    lastArchivedSessionId,
  ];
}

const Object _sentinel = Object();

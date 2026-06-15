import 'package:stasisly/features/chat_sessions/domain/entities/own_chat_session.dart';
import 'package:stasisly/features/chat_sessions/domain/entities/own_chat_session_results.dart';
import 'package:stasisly/features/chat_sessions/domain/repositories/own_chat_sessions_repository.dart';

class DemoOwnChatSessionsRepository implements OwnChatSessionsRepository {
  DemoOwnChatSessionsRepository();

  final List<OwnChatSession> _sessions = [];
  final Map<String, int> _cursorOffsets = {};
  int _nextSession = 1;
  int _nextCursor = 1;

  @override
  Future<CreateOwnChatSessionResult> createOwnChatSession({
    required String selectableSpecialistId,
  }) async {
    if (selectableSpecialistId.trim().isEmpty) {
      return const CreateOwnChatSessionFailure(
        OwnChatSessionsFailureType.invalidSelectableSpecialist,
      );
    }

    final sequence = _nextSession++;
    final timestamp = DateTime.utc(2026).add(Duration(minutes: sequence));
    final session = OwnChatSession(
      sessionId: 'demo-session-$sequence',
      selectableSpecialist: SelectableSpecialistSummary(
        id: selectableSpecialistId,
        displayName: 'Especialista demo',
        area: SelectableSpecialistSummaryArea.wellness,
      ),
      startedAt: timestamp,
      lastMessageAt: timestamp,
      status: ChatSessionStatus.active,
      messageCount: 0,
    );
    _sessions.add(session);
    return CreateOwnChatSessionDemo(session);
  }

  @override
  Future<ListOwnChatSessionsResult> listOwnChatSessions({
    ChatSessionStatusFilter status = ChatSessionStatusFilter.active,
    int limit = 20,
    String? cursor,
  }) async {
    if (limit < 1 || limit > 50) {
      return const ListOwnChatSessionsFailure(
        OwnChatSessionsFailureType.invalidRequest,
      );
    }
    final offset = cursor == null ? 0 : _cursorOffsets[cursor];
    if (offset == null) {
      return const ListOwnChatSessionsFailure(
        OwnChatSessionsFailureType.invalidRequest,
      );
    }

    final filtered = _sessions
        .where((session) {
          return switch (status) {
            ChatSessionStatusFilter.active =>
              session.status == ChatSessionStatus.active,
            ChatSessionStatusFilter.archived =>
              session.status == ChatSessionStatus.archived,
            ChatSessionStatusFilter.all => true,
          };
        })
        .toList(growable: false);
    final end = (offset + limit).clamp(0, filtered.length);
    final items = List<OwnChatSession>.unmodifiable(
      filtered.sublist(offset, end),
    );
    String? nextCursor;
    if (end < filtered.length) {
      nextCursor = 'demo-cursor-${_nextCursor++}';
      _cursorOffsets[nextCursor] = end;
    }
    return ListOwnChatSessionsDemo(
      OwnChatSessionsPage(items: items, nextCursor: nextCursor),
    );
  }

  @override
  Future<ArchiveOwnChatSessionResult> archiveOwnChatSession({
    required String sessionId,
  }) async {
    if (sessionId.trim().isEmpty) {
      return const ArchiveOwnChatSessionFailure(
        OwnChatSessionsFailureType.invalidRequest,
      );
    }
    final index = _sessions.indexWhere(
      (session) =>
          session.sessionId == sessionId &&
          session.status == ChatSessionStatus.active,
    );
    if (index < 0) {
      return const ArchiveOwnChatSessionFailure(
        OwnChatSessionsFailureType.sessionNotFound,
      );
    }
    final current = _sessions[index];
    _sessions[index] = current.copyWith(status: ChatSessionStatus.archived);
    return ArchiveOwnChatSessionDemo(
      ArchivedOwnChatSession(sessionId: sessionId),
    );
  }
}

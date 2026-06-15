import 'package:equatable/equatable.dart';

enum ChatSessionStatus { active, archived }

enum ChatSessionStatusFilter { active, archived, all }

enum SelectableSpecialistSummaryArea {
  stasis,
  health,
  nutrition,
  training,
  wellness,
}

/// Public catalog reference. Its id never identifies an internal specialist.
class SelectableSpecialistSummary extends Equatable {
  const SelectableSpecialistSummary({
    required this.id,
    required this.displayName,
    required this.area,
  });

  final String id;
  final String displayName;
  final SelectableSpecialistSummaryArea area;

  @override
  List<Object?> get props => [id, displayName, area];
}

class OwnChatSession extends Equatable {
  const OwnChatSession({
    required this.sessionId,
    required this.selectableSpecialist,
    required this.startedAt,
    required this.lastMessageAt,
    required this.status,
    required this.messageCount,
  });

  final String sessionId;
  final SelectableSpecialistSummary selectableSpecialist;
  final DateTime startedAt;
  final DateTime lastMessageAt;
  final ChatSessionStatus status;
  final int messageCount;

  OwnChatSession copyWith({ChatSessionStatus? status}) {
    return OwnChatSession(
      sessionId: sessionId,
      selectableSpecialist: selectableSpecialist,
      startedAt: startedAt,
      lastMessageAt: lastMessageAt,
      status: status ?? this.status,
      messageCount: messageCount,
    );
  }

  @override
  List<Object?> get props => [
    sessionId,
    selectableSpecialist,
    startedAt,
    lastMessageAt,
    status,
    messageCount,
  ];
}

class OwnChatSessionsPage extends Equatable {
  const OwnChatSessionsPage({required this.items, required this.nextCursor});

  final List<OwnChatSession> items;
  final String? nextCursor;

  @override
  List<Object?> get props => [items, nextCursor];
}

class ArchivedOwnChatSession extends Equatable {
  const ArchivedOwnChatSession({required this.sessionId});

  final String sessionId;
  ChatSessionStatus get status => ChatSessionStatus.archived;

  @override
  List<Object?> get props => [sessionId, status];
}

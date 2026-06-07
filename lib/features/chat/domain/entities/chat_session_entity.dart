import 'package:equatable/equatable.dart';

/// Represents a chat session between a user and a specialist.
class ChatSessionEntity extends Equatable {
  const ChatSessionEntity({
    required this.id,
    required this.userId,
    required this.specialistId,
    required this.startedAt,
    required this.lastMessageAt,
    required this.status,
    required this.messageCount,
  });

  final String id;
  final String userId;
  final String specialistId;
  final DateTime startedAt;
  final DateTime lastMessageAt;
  
  /// 'active' or 'archived'
  final String status;
  final int messageCount;

  @override
  List<Object?> get props => [
        id,
        userId,
        specialistId,
        startedAt,
        lastMessageAt,
        status,
        messageCount,
      ];
}

import 'package:equatable/equatable.dart';

/// Represents a single message in a chat session.
class MessageEntity extends Equatable {
  const MessageEntity({
    required this.id,
    required this.sessionId,
    required this.role,
    required this.content,
    required this.createdAt,
    this.attachments,
  });

  final String id;
  final String sessionId;
  
  /// 'user', 'assistant', 'system', 'chief_intervention'
  final String role;
  
  final String content;
  final DateTime createdAt;
  
  /// List of attachment metadata (e.g. { 'type': 'pdf', 'url': '...' })
  final List<Map<String, dynamic>>? attachments;

  @override
  List<Object?> get props => [
        id,
        sessionId,
        role,
        content,
        createdAt,
        attachments,
      ];
}

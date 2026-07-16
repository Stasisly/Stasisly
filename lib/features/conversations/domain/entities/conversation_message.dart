import 'package:equatable/equatable.dart';

import 'package:stasisly/features/conversations/domain/value_objects/conversation_id.dart';

enum ConversationMessageAuthor {
  user,
  stasis,
  specialist,
  systemNotice,
  unknown;

  bool get isDisplaySafe => this != ConversationMessageAuthor.unknown;
}

enum ConversationMessageStatus { accepted, pending, failed, hidden, unknown }

enum ConversationMessageProvenance {
  userProvided,
  stasisGenerated,
  specialistGenerated,
  systemGenerated,
  unknown,
}

class ConversationMessage extends Equatable {
  ConversationMessage({
    required this.messageId,
    required this.conversationId,
    required this.author,
    required String content,
    required this.createdAt,
    required this.status,
    required this.provenanceSummary,
  }) : content = _validateContent(content) {
    if (messageId.trim().isEmpty) {
      throw ArgumentError.value(messageId, 'messageId', 'Must not be empty.');
    }
  }

  static const int maxContentLength = 4000;

  final String messageId;
  final ConversationId conversationId;
  final ConversationMessageAuthor author;
  final String content;
  final DateTime createdAt;
  final ConversationMessageStatus status;
  final ConversationMessageProvenance provenanceSummary;

  bool get isDisplaySafe {
    return author.isDisplaySafe && status != ConversationMessageStatus.unknown;
  }

  static String _validateContent(String value) {
    final normalized = value.trim();
    if (normalized.isEmpty || normalized.length > maxContentLength) {
      throw ArgumentError.value(value, 'content', 'Invalid message content.');
    }
    return normalized;
  }

  @override
  List<Object?> get props => [
    messageId,
    conversationId,
    author,
    content,
    createdAt,
    status,
    provenanceSummary,
  ];
}

import 'package:equatable/equatable.dart';

import 'package:stasisly/features/conversations/domain/value_objects/conversation_id.dart';

class CreateConversationInput extends Equatable {
  CreateConversationInput({String? selectableSpecialistId})
    : selectableSpecialistId = _optionalRequired(selectableSpecialistId);

  final String? selectableSpecialistId;

  @override
  List<Object?> get props => [selectableSpecialistId];
}

class ArchiveConversationInput extends Equatable {
  const ArchiveConversationInput({required this.conversationId});
  final ConversationId conversationId;
  @override
  List<Object?> get props => [conversationId];
}

class ListConversationMessagesInput extends Equatable {
  ListConversationMessagesInput({
    required this.conversationId,
    this.limit = 50,
    String? cursor,
  }) : cursor = _optionalCursor(cursor) {
    if (limit < 1 || limit > 100) {
      throw ArgumentError.value(limit, 'limit', 'Must be between 1 and 100.');
    }
  }

  final ConversationId conversationId;
  final int limit;
  final String? cursor;

  @override
  List<Object?> get props => [conversationId, limit, cursor];
}

class SendConversationMessageInput extends Equatable {
  SendConversationMessageInput({
    required this.conversationId,
    required String content,
  }) : content = _content(content);

  static const int maxContentLength = 4000;

  final ConversationId conversationId;
  final String content;

  @override
  List<Object?> get props => [conversationId, content];
}

String? _optionalRequired(String? value) {
  if (value == null) return null;
  final normalized = value.trim();
  if (normalized.isEmpty) {
    throw ArgumentError.value(
      value,
      'selectableSpecialistId',
      'Must not be empty.',
    );
  }
  return normalized;
}

String? _optionalCursor(String? value) {
  if (value == null) return null;
  final normalized = value.trim();
  if (normalized.isEmpty) {
    throw ArgumentError.value(value, 'cursor', 'Must not be empty.');
  }
  return normalized;
}

String _content(String value) {
  final normalized = value.trim();
  if (normalized.isEmpty ||
      normalized.length > SendConversationMessageInput.maxContentLength) {
    throw ArgumentError.value(value, 'content', 'Invalid message content.');
  }
  return normalized;
}

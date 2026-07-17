import 'package:equatable/equatable.dart';

import 'package:stasisly/features/conversations/domain/value_objects/conversation_id.dart';

sealed class MessageAuthor extends Equatable {
  const MessageAuthor();

  bool get isDisplaySafe => this is! UnknownAuthor;
}

final class UserAuthor extends MessageAuthor {
  const UserAuthor();

  @override
  List<Object?> get props => const ['user'];
}

final class StasisAuthor extends MessageAuthor {
  const StasisAuthor();

  static const publicReference = 'stasis';

  @override
  List<Object?> get props => const [publicReference];
}

final class SpecialistAuthor extends MessageAuthor {
  const SpecialistAuthor({
    required this.selectableSpecialistId,
    required this.displayName,
    required this.publicArea,
  });

  final String selectableSpecialistId;
  final String displayName;
  final String publicArea;

  @override
  List<Object?> get props => [selectableSpecialistId, displayName, publicArea];
}

final class SystemNoticeAuthor extends MessageAuthor {
  const SystemNoticeAuthor();

  @override
  List<Object?> get props => const ['systemNotice'];
}

final class UnknownAuthor extends MessageAuthor {
  const UnknownAuthor();

  @override
  List<Object?> get props => const ['unknown'];
}

enum ConversationMessageStatus { accepted, redacted, failed, unknown }

enum ConversationMessageProvenance {
  userProvided,
  stasisConsolidated,
  specialistProvided,
  systemGenerated,
  imported,
  unknown,
}

enum ConversationMessageVisibility {
  productVisible,
  ownerOnly,
  systemVisible,
  internal,
  redacted,
  unknown;

  bool get isProductReadable => switch (this) {
    productVisible || ownerOnly || systemVisible || redacted => true,
    internal || unknown => false,
  };
}

class ConversationMessage extends Equatable {
  ConversationMessage({
    required this.messageId,
    required this.conversationId,
    required this.author,
    required String content,
    required this.createdAt,
    required this.status,
    required this.provenance,
    required this.visibility,
  }) : content = _validateContent(content) {
    if (messageId.trim().isEmpty) {
      throw ArgumentError.value(messageId, 'messageId', 'Must not be empty.');
    }
    if (!visibility.isProductReadable || author is UnknownAuthor) {
      throw ArgumentError('ConversationMessage must be Product-readable.');
    }
    if (visibility == ConversationMessageVisibility.redacted &&
        (status != ConversationMessageStatus.redacted ||
            content != redactedPlaceholder)) {
      throw ArgumentError('Redacted messages cannot contain original content.');
    }
  }

  static const int maxContentLength = 4000;
  static const String redactedPlaceholder = '[redacted]';

  final String messageId;
  final ConversationId conversationId;
  final MessageAuthor author;
  final String content;
  final DateTime createdAt;
  final ConversationMessageStatus status;
  final ConversationMessageProvenance provenance;
  final ConversationMessageVisibility visibility;

  bool get isDisplaySafe {
    return author.isDisplaySafe &&
        visibility.isProductReadable &&
        status != ConversationMessageStatus.unknown;
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
    provenance,
    visibility,
  ];
}

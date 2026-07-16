import 'package:equatable/equatable.dart';

import 'package:stasisly/features/conversations/domain/entities/conversation.dart';
import 'package:stasisly/features/conversations/domain/entities/conversation_message.dart';
import 'package:stasisly/features/conversations/domain/value_objects/conversation_id.dart';

enum ConversationResultStatus {
  success,
  unauthenticated,
  unauthorized,
  notFound,
  invalidInput,
  archived,
  idempotencyConflict,
  operationInProgress,
  transactionFailed,
  environmentBlocked,
  backendUnavailable,
  contractViolation,
  unknownFailure,
}

class ConversationPage extends Equatable {
  const ConversationPage({required this.items, required this.nextCursor});

  final List<Conversation> items;
  final String? nextCursor;

  @override
  List<Object?> get props => [items, nextCursor];
}

class ConversationMessagePage extends Equatable {
  const ConversationMessagePage({
    required this.items,
    required this.nextCursor,
  });

  final List<ConversationMessage> items;
  final String? nextCursor;

  @override
  List<Object?> get props => [items, nextCursor];
}

class ConversationMutationReceipt extends Equatable {
  const ConversationMutationReceipt({
    required this.conversationId,
    required this.status,
  });

  final ConversationId conversationId;
  final ConversationStatus status;

  @override
  List<Object?> get props => [conversationId, status];
}

class ConversationMessageSendReceipt extends Equatable {
  const ConversationMessageSendReceipt({
    required this.message,
    required this.messageCount,
    required this.lastMessageAt,
  });

  final ConversationMessage message;
  final int messageCount;
  final DateTime lastMessageAt;

  @override
  List<Object?> get props => [message, messageCount, lastMessageAt];
}

sealed class ConversationListResult extends Equatable {
  const ConversationListResult();
}

final class ConversationListSuccess extends ConversationListResult {
  const ConversationListSuccess(this.page);
  final ConversationPage page;
  @override
  List<Object?> get props => [page];
}

final class ConversationListFailure extends ConversationListResult {
  const ConversationListFailure(this.status)
    : assert(
        status != ConversationResultStatus.success,
        'A failure cannot use the success status.',
      );
  final ConversationResultStatus status;
  @override
  List<Object?> get props => [status];
}

sealed class ConversationReadResult extends Equatable {
  const ConversationReadResult();
}

final class ConversationReadSuccess extends ConversationReadResult {
  const ConversationReadSuccess(this.conversation);
  final Conversation conversation;
  @override
  List<Object?> get props => [conversation];
}

final class ConversationReadFailure extends ConversationReadResult {
  const ConversationReadFailure(this.status)
    : assert(
        status != ConversationResultStatus.success,
        'A failure cannot use the success status.',
      );
  final ConversationResultStatus status;
  @override
  List<Object?> get props => [status];
}

sealed class ConversationMutationResult extends Equatable {
  const ConversationMutationResult();
}

final class ConversationMutationSuccess extends ConversationMutationResult {
  const ConversationMutationSuccess({this.conversation, this.receipt})
    : assert(
        (conversation == null) != (receipt == null),
        'A mutation success requires exactly one payload.',
      );
  final Conversation? conversation;
  final ConversationMutationReceipt? receipt;
  @override
  List<Object?> get props => [conversation, receipt];
}

final class ConversationMutationFailure extends ConversationMutationResult {
  const ConversationMutationFailure(this.status)
    : assert(
        status != ConversationResultStatus.success,
        'A failure cannot use the success status.',
      );
  final ConversationResultStatus status;
  @override
  List<Object?> get props => [status];
}

sealed class ConversationMessageListResult extends Equatable {
  const ConversationMessageListResult();
}

final class ConversationMessageListSuccess
    extends ConversationMessageListResult {
  const ConversationMessageListSuccess(this.page);
  final ConversationMessagePage page;
  @override
  List<Object?> get props => [page];
}

final class ConversationMessageListFailure
    extends ConversationMessageListResult {
  const ConversationMessageListFailure(this.status)
    : assert(
        status != ConversationResultStatus.success,
        'A failure cannot use the success status.',
      );
  final ConversationResultStatus status;
  @override
  List<Object?> get props => [status];
}

sealed class ConversationMessageSendResult extends Equatable {
  const ConversationMessageSendResult();
}

final class ConversationMessageSendSuccess
    extends ConversationMessageSendResult {
  const ConversationMessageSendSuccess(this.receipt);
  final ConversationMessageSendReceipt receipt;
  @override
  List<Object?> get props => [receipt];
}

final class ConversationMessageSendFailure
    extends ConversationMessageSendResult {
  const ConversationMessageSendFailure(this.status)
    : assert(
        status != ConversationResultStatus.success,
        'A failure cannot use the success status.',
      );
  final ConversationResultStatus status;
  @override
  List<Object?> get props => [status];
}

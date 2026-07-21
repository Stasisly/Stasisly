import 'package:stasisly/features/conversations/application/state/conversation_application_states.dart';
import 'package:stasisly/features/conversations/domain/results/conversation_results.dart';

ConversationApplicationErrorCode mapConversationError(
  ConversationResultStatus status,
) => switch (status) {
  ConversationResultStatus.unauthenticated =>
    ConversationApplicationErrorCode.unauthenticated,
  ConversationResultStatus.unauthorized =>
    ConversationApplicationErrorCode.unauthorized,
  ConversationResultStatus.notFound =>
    ConversationApplicationErrorCode.notFound,
  ConversationResultStatus.environmentBlocked =>
    ConversationApplicationErrorCode.environmentBlocked,
  ConversationResultStatus.invalidInput =>
    ConversationApplicationErrorCode.invalidInput,
  ConversationResultStatus.archived =>
    ConversationApplicationErrorCode.archived,
  ConversationResultStatus.idempotencyConflict =>
    ConversationApplicationErrorCode.idempotencyConflict,
  ConversationResultStatus.operationInProgress ||
  ConversationResultStatus.transactionFailed ||
  ConversationResultStatus.backendUnavailable =>
    ConversationApplicationErrorCode.backendUnavailable,
  ConversationResultStatus.contractViolation =>
    ConversationApplicationErrorCode.contractViolation,
  ConversationResultStatus.unknownFailure || ConversationResultStatus.success =>
    ConversationApplicationErrorCode.unknownFailure,
};

bool isRetryableConversationFailure(ConversationResultStatus status) =>
    switch (status) {
      ConversationResultStatus.operationInProgress ||
      ConversationResultStatus.transactionFailed ||
      ConversationResultStatus.backendUnavailable ||
      ConversationResultStatus.unknownFailure => true,
      _ => false,
    };

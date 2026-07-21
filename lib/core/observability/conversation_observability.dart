enum ConversationObservabilityEventName {
  routeEntered,
  routeBlocked,
  authenticationRequired,
  conversationListRequested,
  conversationListSucceeded,
  conversationListFailed,
  conversationReadRequested,
  conversationReadSucceeded,
  conversationReadFailed,
  messageSendRequested,
  messageSendSucceeded,
  messageSendReplayed,
  messageSendFailed,
  conversationArchived,
  conversationRestored,
  paginationRequested,
  paginationCompleted,
  contractViolationDetected,
  environmentBlocked,
}

enum ConversationObservedRoute { stasis, conversations, conversationDetail }

enum ConversationObservationCategory {
  routing,
  authentication,
  list,
  read,
  messages,
  send,
  lifecycle,
  contract,
  environment,
}

enum ConversationObservationResult {
  requested,
  success,
  empty,
  replay,
  unauthenticated,
  environmentBlocked,
  notFoundOpaque,
  invalidInput,
  archived,
  idempotencyConflict,
  backendUnavailable,
  contractViolation,
  unknownFailure,
}

enum ConversationObservedEnvironment {
  local,
  demo,
  development,
  staging,
  production,
  backendReal,
  unknown,
}

enum ConversationObservedSurface { product }

enum ConversationDurationBucket {
  under100Milliseconds,
  under500Milliseconds,
  under2Seconds,
  twoSecondsOrMore,
}

enum ConversationItemCountBucket {
  zero,
  oneToTwenty,
  twentyOneToOneHundred,
  overOneHundred,
}

enum ConversationRetryClass { none, automaticReplay, userInitiated }

enum ConversationSafeErrorCode {
  unauthenticated,
  unauthorized,
  notFound,
  environmentBlocked,
  invalidInput,
  archived,
  idempotencyConflict,
  backendUnavailable,
  contractViolation,
  unknownFailure,
}

/// A deliberately closed, provider-neutral event with no free-form payload.
///
/// Conversation identifiers, content, drafts, tokens, attempts, owners and
/// provider errors cannot be represented by this contract.
class ConversationObservation {
  const ConversationObservation({
    required this.event,
    required this.category,
    required this.result,
    this.route,
    this.environment = ConversationObservedEnvironment.unknown,
    this.surface = ConversationObservedSurface.product,
    this.duration,
    this.itemCount,
    this.retry = ConversationRetryClass.none,
    this.error,
  });

  final ConversationObservabilityEventName event;
  final ConversationObservationCategory category;
  final ConversationObservationResult result;
  final ConversationObservedRoute? route;
  final ConversationObservedEnvironment environment;
  final ConversationObservedSurface surface;
  final ConversationDurationBucket? duration;
  final ConversationItemCountBucket? itemCount;
  final ConversationRetryClass retry;
  final ConversationSafeErrorCode? error;
}

// The single operation keeps the provider-neutral sink intentionally minimal.
// ignore: one_member_abstracts
abstract interface class ConversationObservabilitySink {
  void record(ConversationObservation observation);
}

class NoOpConversationObservabilitySink
    implements ConversationObservabilitySink {
  const NoOpConversationObservabilitySink();

  @override
  void record(ConversationObservation observation) {}
}

ConversationDurationBucket conversationDurationBucket(Duration duration) {
  if (duration < const Duration(milliseconds: 100)) {
    return ConversationDurationBucket.under100Milliseconds;
  }
  if (duration < const Duration(milliseconds: 500)) {
    return ConversationDurationBucket.under500Milliseconds;
  }
  if (duration < const Duration(seconds: 2)) {
    return ConversationDurationBucket.under2Seconds;
  }
  return ConversationDurationBucket.twoSecondsOrMore;
}

ConversationItemCountBucket conversationItemCountBucket(int count) {
  if (count <= 0) return ConversationItemCountBucket.zero;
  if (count <= 20) return ConversationItemCountBucket.oneToTwenty;
  if (count <= 100) return ConversationItemCountBucket.twentyOneToOneHundred;
  return ConversationItemCountBucket.overOneHundred;
}

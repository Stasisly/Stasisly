import 'package:equatable/equatable.dart';

import 'package:stasisly/features/conversations/domain/entities/conversation.dart';
import 'package:stasisly/features/conversations/domain/entities/conversation_message.dart';

enum ConversationApplicationErrorCode {
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

enum ConversationListFilter { active, archived }

enum ConversationListPhase {
  initial,
  loading,
  data,
  empty,
  refreshing,
  loadingMore,
  unauthenticated,
  environmentBlocked,
  error,
}

class ConversationListState extends Equatable {
  const ConversationListState({
    this.phase = ConversationListPhase.initial,
    this.filter = ConversationListFilter.active,
    this.conversations = const [],
    this.nextCursor,
    this.error,
  });

  final ConversationListPhase phase;
  final ConversationListFilter filter;
  final List<Conversation> conversations;
  final String? nextCursor;
  final ConversationApplicationErrorCode? error;

  bool get hasMore => nextCursor != null;

  ConversationListState copyWith({
    ConversationListPhase? phase,
    ConversationListFilter? filter,
    List<Conversation>? conversations,
    Object? nextCursor = _unset,
    Object? error = _unset,
  }) => ConversationListState(
    phase: phase ?? this.phase,
    filter: filter ?? this.filter,
    conversations: List.unmodifiable(conversations ?? this.conversations),
    nextCursor: identical(nextCursor, _unset)
        ? this.nextCursor
        : nextCursor as String?,
    error: identical(error, _unset)
        ? this.error
        : error as ConversationApplicationErrorCode?,
  );

  @override
  List<Object?> get props => [phase, filter, conversations, nextCursor, error];
}

enum ConversationDetailPhase {
  initial,
  loading,
  active,
  archived,
  notFound,
  unauthenticated,
  environmentBlocked,
  error,
}

enum ConversationMessagesPhase {
  initial,
  loading,
  data,
  empty,
  loadingMore,
  error,
}

enum ConversationSendStatus { idle, sending, failed }

enum ConversationLifecycleStatus { idle, changing, failed }

enum ConversationCreateStatus { idle, creating, success, failed }

class ConversationMessagesState extends Equatable {
  const ConversationMessagesState({
    this.phase = ConversationMessagesPhase.initial,
    this.messages = const [],
    this.nextCursor,
    this.error,
  });

  final ConversationMessagesPhase phase;
  final List<ConversationMessage> messages;
  final String? nextCursor;
  final ConversationApplicationErrorCode? error;

  bool get hasMore => nextCursor != null;

  ConversationMessagesState copyWith({
    ConversationMessagesPhase? phase,
    List<ConversationMessage>? messages,
    Object? nextCursor = _unset,
    Object? error = _unset,
  }) => ConversationMessagesState(
    phase: phase ?? this.phase,
    messages: List.unmodifiable(messages ?? this.messages),
    nextCursor: identical(nextCursor, _unset)
        ? this.nextCursor
        : nextCursor as String?,
    error: identical(error, _unset)
        ? this.error
        : error as ConversationApplicationErrorCode?,
  );

  @override
  List<Object?> get props => [phase, messages, nextCursor, error];
}

class ConversationComposerState extends Equatable {
  const ConversationComposerState({
    this.draft = '',
    this.sendStatus = ConversationSendStatus.idle,
    this.canRetry = false,
    this.error,
  });

  final String draft;
  final ConversationSendStatus sendStatus;
  final bool canRetry;
  final ConversationApplicationErrorCode? error;

  bool get isValid => draft.trim().isNotEmpty && draft.trim().length <= 4000;

  ConversationComposerState copyWith({
    String? draft,
    ConversationSendStatus? sendStatus,
    bool? canRetry,
    Object? error = _unset,
  }) => ConversationComposerState(
    draft: draft ?? this.draft,
    sendStatus: sendStatus ?? this.sendStatus,
    canRetry: canRetry ?? this.canRetry,
    error: identical(error, _unset)
        ? this.error
        : error as ConversationApplicationErrorCode?,
  );

  @override
  List<Object?> get props => [draft, sendStatus, canRetry, error];

  @override
  String toString() =>
      'ConversationComposerState(isValid: $isValid, sendStatus: $sendStatus, canRetry: $canRetry, error: $error)';
}

class ConversationLifecycleState extends Equatable {
  const ConversationLifecycleState({
    this.status = ConversationLifecycleStatus.idle,
    this.error,
  });

  final ConversationLifecycleStatus status;
  final ConversationApplicationErrorCode? error;

  @override
  List<Object?> get props => [status, error];
}

class ConversationDetailState extends Equatable {
  const ConversationDetailState({
    this.phase = ConversationDetailPhase.initial,
    this.conversation,
    this.messages = const ConversationMessagesState(),
    this.composer = const ConversationComposerState(),
    this.lifecycle = const ConversationLifecycleState(),
    this.error,
  });

  final ConversationDetailPhase phase;
  final Conversation? conversation;
  final ConversationMessagesState messages;
  final ConversationComposerState composer;
  final ConversationLifecycleState lifecycle;
  final ConversationApplicationErrorCode? error;

  bool get isArchived => phase == ConversationDetailPhase.archived;

  ConversationDetailState copyWith({
    ConversationDetailPhase? phase,
    Object? conversation = _unset,
    ConversationMessagesState? messages,
    ConversationComposerState? composer,
    ConversationLifecycleState? lifecycle,
    Object? error = _unset,
  }) => ConversationDetailState(
    phase: phase ?? this.phase,
    conversation: identical(conversation, _unset)
        ? this.conversation
        : conversation as Conversation?,
    messages: messages ?? this.messages,
    composer: composer ?? this.composer,
    lifecycle: lifecycle ?? this.lifecycle,
    error: identical(error, _unset)
        ? this.error
        : error as ConversationApplicationErrorCode?,
  );

  @override
  List<Object?> get props => [
    phase,
    conversation,
    messages,
    composer,
    lifecycle,
    error,
  ];
}

class ConversationCreateState extends Equatable {
  const ConversationCreateState({
    this.status = ConversationCreateStatus.idle,
    this.conversation,
    this.error,
  });

  final ConversationCreateStatus status;
  final Conversation? conversation;
  final ConversationApplicationErrorCode? error;

  @override
  List<Object?> get props => [status, conversation, error];
}

const Object _unset = Object();

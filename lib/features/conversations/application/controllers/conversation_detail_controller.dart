import 'package:stasisly/core/idempotency/operation_attempt_id.dart';
import 'package:stasisly/core/observability/conversation_observability.dart';
import 'package:stasisly/features/conversations/application/inputs/conversation_inputs.dart';
import 'package:stasisly/features/conversations/application/state/conversation_application_states.dart';
import 'package:stasisly/features/conversations/application/state/conversation_result_mapping.dart';
import 'package:stasisly/features/conversations/application/use_cases/conversation_use_cases.dart';
import 'package:stasisly/features/conversations/domain/entities/conversation.dart';
import 'package:stasisly/features/conversations/domain/entities/conversation_message.dart';
import 'package:stasisly/features/conversations/domain/results/conversation_results.dart';
import 'package:stasisly/features/conversations/domain/value_objects/conversation_id.dart';

class ConversationDetailController {
  ConversationDetailController({
    required ConversationId conversationId,
    required ReadOwnConversation readOwnConversation,
    required ListOwnConversationMessages listOwnConversationMessages,
    required SendOwnConversationMessage sendOwnConversationMessage,
    required ArchiveOwnConversation archiveOwnConversation,
    required RestoreOwnConversation restoreOwnConversation,
    required OperationAttemptIdFactory operationAttemptIds,
    this.pageSize = 50,
    this.observability = const NoOpConversationObservabilitySink(),
    this.observedEnvironment = ConversationObservedEnvironment.unknown,
    void Function(ConversationDetailState)? onStateChanged,
    void Function()? onListsInvalidated,
  }) : _conversationId = conversationId,
       _readOwnConversation = readOwnConversation,
       _listOwnConversationMessages = listOwnConversationMessages,
       _sendOwnConversationMessage = sendOwnConversationMessage,
       _archiveOwnConversation = archiveOwnConversation,
       _restoreOwnConversation = restoreOwnConversation,
       _operationAttemptIds = operationAttemptIds,
       _onStateChanged = onStateChanged,
       _onListsInvalidated = onListsInvalidated;

  ConversationId _conversationId;
  final ReadOwnConversation _readOwnConversation;
  final ListOwnConversationMessages _listOwnConversationMessages;
  final SendOwnConversationMessage _sendOwnConversationMessage;
  final ArchiveOwnConversation _archiveOwnConversation;
  final RestoreOwnConversation _restoreOwnConversation;
  final OperationAttemptIdFactory _operationAttemptIds;
  final int pageSize;
  final ConversationObservabilitySink observability;
  final ConversationObservedEnvironment observedEnvironment;
  final void Function(ConversationDetailState)? _onStateChanged;
  final void Function()? _onListsInvalidated;

  ConversationDetailState state = const ConversationDetailState();
  int _generation = 0;
  bool _loadingMore = false;
  bool _sendInFlight = false;
  bool _lifecycleInFlight = false;
  bool _disposed = false;
  _SendIntent? _pendingSend;

  ConversationId get conversationId => _conversationId;

  Future<void> openConversation(ConversationId conversationId) async {
    if (_disposed) return;
    _conversationId = conversationId;
    _pendingSend = null;
    _generation += 1;
    _emit(const ConversationDetailState());
    await load();
  }

  Future<void> load() async {
    if (_disposed) return;
    final generation = ++_generation;
    final id = _conversationId;
    final stopwatch = Stopwatch()..start();
    _record(
      ConversationObservabilityEventName.conversationReadRequested,
      ConversationObservationCategory.read,
      ConversationObservationResult.requested,
    );
    _emit(
      const ConversationDetailState(phase: ConversationDetailPhase.loading),
    );
    final result = await _readOwnConversation(id);
    if (!_isCurrent(generation, id)) {
      return;
    }
    switch (result) {
      case ConversationReadSuccess(:final conversation):
        if (conversation.conversationId != id ||
            !{
              ConversationStatus.active,
              ConversationStatus.archived,
            }.contains(conversation.status)) {
          _emitDetailFailure(
            ConversationApplicationErrorCode.contractViolation,
          );
          _recordFailure(
            stopwatch,
            ConversationObservabilityEventName.contractViolationDetected,
            ConversationObservationCategory.contract,
            ConversationApplicationErrorCode.contractViolation,
          );
          return;
        }
        _recordSuccess(
          stopwatch,
          ConversationObservabilityEventName.conversationReadSucceeded,
          ConversationObservationCategory.read,
        );
        _emit(
          ConversationDetailState(
            phase: conversation.status == ConversationStatus.archived
                ? ConversationDetailPhase.archived
                : ConversationDetailPhase.active,
            conversation: conversation,
            messages: const ConversationMessagesState(
              phase: ConversationMessagesPhase.loading,
            ),
          ),
        );
        await _loadFirstMessages(generation, id);
      case ConversationReadFailure(:final status):
        final error = mapConversationError(status);
        _recordFailure(
          stopwatch,
          ConversationObservabilityEventName.conversationReadFailed,
          ConversationObservationCategory.read,
          error,
        );
        _emitDetailFailure(error);
    }
  }

  Future<void> refresh() => load();

  Future<void> _loadFirstMessages(int generation, ConversationId id) async {
    final stopwatch = Stopwatch()..start();
    _record(
      ConversationObservabilityEventName.paginationRequested,
      ConversationObservationCategory.messages,
      ConversationObservationResult.requested,
    );
    final result = await _listOwnConversationMessages(
      ListConversationMessagesInput(conversationId: id, limit: pageSize),
    );
    if (!_isCurrent(generation, id)) {
      return;
    }
    _recordMessageResult(stopwatch, result);
    _applyMessagePage(result, append: false);
  }

  Future<void> loadMoreMessages() async {
    if (_disposed || _loadingMore || !state.messages.hasMore) return;
    _loadingMore = true;
    final generation = _generation;
    final id = _conversationId;
    final stopwatch = Stopwatch()..start();
    _record(
      ConversationObservabilityEventName.paginationRequested,
      ConversationObservationCategory.messages,
      ConversationObservationResult.requested,
    );
    _emit(
      state.copyWith(
        messages: state.messages.copyWith(
          phase: ConversationMessagesPhase.loadingMore,
          error: null,
        ),
      ),
    );
    final result = await _listOwnConversationMessages(
      ListConversationMessagesInput(
        conversationId: id,
        limit: pageSize,
        cursor: state.messages.nextCursor,
      ),
    );
    _loadingMore = false;
    if (!_isCurrent(generation, id)) {
      return;
    }
    _recordMessageResult(stopwatch, result);
    _applyMessagePage(result, append: true);
  }

  void updateDraft(String value) {
    if (_disposed) return;
    final normalized = value.trim();
    if (!_sendInFlight &&
        _pendingSend != null &&
        _pendingSend!.content != normalized) {
      _pendingSend = null;
    }
    _emit(
      state.copyWith(
        composer: state.composer.copyWith(
          draft: value,
          sendStatus: ConversationSendStatus.idle,
          canRetry: false,
          error: null,
        ),
      ),
    );
  }

  Future<void> send() async {
    if (_disposed || _sendInFlight || _lifecycleInFlight) return;
    if (state.isArchived) {
      _emitComposerFailure(ConversationApplicationErrorCode.archived);
      _recordRejectedSend(ConversationApplicationErrorCode.archived);
      return;
    }
    final content = state.composer.draft.trim();
    if (content.isEmpty ||
        content.length > SendConversationMessageInput.maxContentLength) {
      _emitComposerFailure(ConversationApplicationErrorCode.invalidInput);
      _recordRejectedSend(ConversationApplicationErrorCode.invalidInput);
      return;
    }
    if (_pendingSend == null || _pendingSend!.content != content) {
      _pendingSend = _SendIntent(content, _operationAttemptIds.create());
    }
    await _submitPendingSend(retry: false);
  }

  Future<void> retrySend() async {
    if (_disposed ||
        _sendInFlight ||
        _lifecycleInFlight ||
        _pendingSend == null ||
        state.isArchived) {
      return;
    }
    await _submitPendingSend(retry: true);
  }

  Future<void> _submitPendingSend({required bool retry}) async {
    final intent = _pendingSend!;
    final stopwatch = Stopwatch()..start();
    _record(
      retry
          ? ConversationObservabilityEventName.messageSendReplayed
          : ConversationObservabilityEventName.messageSendRequested,
      ConversationObservationCategory.send,
      retry
          ? ConversationObservationResult.replay
          : ConversationObservationResult.requested,
      retry: retry
          ? ConversationRetryClass.userInitiated
          : ConversationRetryClass.none,
    );
    _sendInFlight = true;
    _emit(
      state.copyWith(
        composer: state.composer.copyWith(
          sendStatus: ConversationSendStatus.sending,
          canRetry: false,
          error: null,
        ),
      ),
    );
    final result = await _sendOwnConversationMessage(
      SendConversationMessageInput(
        conversationId: _conversationId,
        operationAttemptId: intent.operationAttemptId,
        content: intent.content,
      ),
    );
    _sendInFlight = false;
    if (_disposed || !identical(intent, _pendingSend)) {
      return;
    }
    switch (result) {
      case ConversationMessageSendSuccess(:final receipt):
        if (receipt.message.conversationId != _conversationId) {
          _pendingSend = null;
          _emitComposerFailure(
            ConversationApplicationErrorCode.contractViolation,
          );
          _recordFailure(
            stopwatch,
            ConversationObservabilityEventName.contractViolationDetected,
            ConversationObservationCategory.contract,
            ConversationApplicationErrorCode.contractViolation,
            retry: retry
                ? ConversationRetryClass.userInitiated
                : ConversationRetryClass.none,
          );
          return;
        }
        final messages = _deduplicateMessages([
          ...state.messages.messages,
          receipt.message,
        ]);
        final draftStillMatches = state.composer.draft.trim() == intent.content;
        _pendingSend = null;
        _emit(
          state.copyWith(
            messages: state.messages.copyWith(
              phase: ConversationMessagesPhase.data,
              messages: messages,
              error: null,
            ),
            composer: ConversationComposerState(
              draft: draftStillMatches ? '' : state.composer.draft,
            ),
          ),
        );
        _recordSuccess(
          stopwatch,
          ConversationObservabilityEventName.messageSendSucceeded,
          ConversationObservationCategory.send,
          retry: retry
              ? ConversationRetryClass.userInitiated
              : ConversationRetryClass.none,
        );
      case ConversationMessageSendFailure(:final status):
        final submittedContentStillCurrent =
            state.composer.draft.trim() == intent.content;
        final retainsIntent =
            submittedContentStillCurrent &&
            (isRetryableConversationFailure(status) ||
                status == ConversationResultStatus.idempotencyConflict);
        if (!retainsIntent) {
          _pendingSend = null;
        }
        _emitComposerFailure(
          mapConversationError(status),
          canRetry: retainsIntent,
        );
        _recordFailure(
          stopwatch,
          ConversationObservabilityEventName.messageSendFailed,
          ConversationObservationCategory.send,
          mapConversationError(status),
          retry: retry
              ? ConversationRetryClass.userInitiated
              : ConversationRetryClass.none,
        );
    }
  }

  Future<void> archive() async {
    if (_disposed || _lifecycleInFlight || _sendInFlight || state.isArchived) {
      if (_sendInFlight) {
        _emitLifecycleFailure(
          ConversationApplicationErrorCode.backendUnavailable,
        );
      }
      return;
    }
    await _changeLifecycle(archive: true);
  }

  Future<void> restore() async {
    if (_disposed || _lifecycleInFlight || _sendInFlight || !state.isArchived) {
      return;
    }
    await _changeLifecycle(archive: false);
  }

  Future<void> _changeLifecycle({required bool archive}) async {
    final stopwatch = Stopwatch()..start();
    const category = ConversationObservationCategory.lifecycle;
    _lifecycleInFlight = true;
    _emit(
      state.copyWith(
        lifecycle: const ConversationLifecycleState(
          status: ConversationLifecycleStatus.changing,
        ),
      ),
    );
    final result = archive
        ? await _archiveOwnConversation(
            ArchiveConversationInput(conversationId: _conversationId),
          )
        : await _restoreOwnConversation(
            RestoreConversationInput(conversationId: _conversationId),
          );
    _lifecycleInFlight = false;
    if (_disposed) return;
    switch (result) {
      case ConversationMutationSuccess(:final receipt, :final conversation):
        final status = receipt?.status ?? conversation?.status;
        final resultId =
            receipt?.conversationId ?? conversation?.conversationId;
        final expected = archive
            ? ConversationStatus.archived
            : ConversationStatus.active;
        if (resultId != _conversationId || status != expected) {
          _emitLifecycleFailure(
            ConversationApplicationErrorCode.contractViolation,
          );
          _recordFailure(
            stopwatch,
            ConversationObservabilityEventName.contractViolationDetected,
            ConversationObservationCategory.contract,
            ConversationApplicationErrorCode.contractViolation,
          );
          return;
        }
        _pendingSend = null;
        _emit(
          state.copyWith(
            phase: archive
                ? ConversationDetailPhase.archived
                : ConversationDetailPhase.active,
            conversation: conversation ?? state.conversation,
            composer: archive
                ? state.composer.copyWith(
                    sendStatus: ConversationSendStatus.idle,
                    error: null,
                  )
                : state.composer,
            lifecycle: const ConversationLifecycleState(),
            error: null,
          ),
        );
        _onListsInvalidated?.call();
        _recordSuccess(
          stopwatch,
          archive
              ? ConversationObservabilityEventName.conversationArchived
              : ConversationObservabilityEventName.conversationRestored,
          category,
        );
      case ConversationMutationFailure(:final status):
        final error = mapConversationError(status);
        _emitLifecycleFailure(error);
        _recordFailure(
          stopwatch,
          archive
              ? ConversationObservabilityEventName.conversationArchived
              : ConversationObservabilityEventName.conversationRestored,
          category,
          error,
        );
    }
  }

  void _applyMessagePage(
    ConversationMessageListResult result, {
    required bool append,
  }) {
    switch (result) {
      case ConversationMessageListSuccess(:final page):
        if (page.nextCursor != null && page.nextCursor!.trim().isEmpty ||
            page.items.any((item) => item.conversationId != _conversationId)) {
          _emit(
            state.copyWith(
              messages: state.messages.copyWith(
                phase: ConversationMessagesPhase.error,
                error: ConversationApplicationErrorCode.contractViolation,
                nextCursor: null,
              ),
            ),
          );
          return;
        }
        final items = _deduplicateMessages([
          if (append) ...state.messages.messages,
          ...page.items,
        ]);
        _emit(
          state.copyWith(
            messages: state.messages.copyWith(
              phase: items.isEmpty
                  ? ConversationMessagesPhase.empty
                  : ConversationMessagesPhase.data,
              messages: items,
              nextCursor: page.nextCursor?.trim(),
              error: null,
            ),
          ),
        );
      case ConversationMessageListFailure(:final status):
        _emit(
          state.copyWith(
            messages: state.messages.copyWith(
              phase: state.messages.messages.isEmpty
                  ? ConversationMessagesPhase.error
                  : ConversationMessagesPhase.data,
              error: mapConversationError(status),
            ),
          ),
        );
    }
  }

  List<ConversationMessage> _deduplicateMessages(
    List<ConversationMessage> source,
  ) {
    final result = <ConversationMessage>[];
    final seen = <String>{};
    for (final message in source) {
      if (seen.add(message.messageId)) result.add(message);
    }
    return result;
  }

  void _emitDetailFailure(ConversationApplicationErrorCode error) {
    final phase = switch (error) {
      ConversationApplicationErrorCode.notFound =>
        ConversationDetailPhase.notFound,
      ConversationApplicationErrorCode.unauthenticated =>
        ConversationDetailPhase.unauthenticated,
      ConversationApplicationErrorCode.environmentBlocked =>
        ConversationDetailPhase.environmentBlocked,
      _ => ConversationDetailPhase.error,
    };
    _emit(ConversationDetailState(phase: phase, error: error));
  }

  void _emitComposerFailure(
    ConversationApplicationErrorCode error, {
    bool canRetry = false,
  }) {
    _emit(
      state.copyWith(
        composer: state.composer.copyWith(
          sendStatus: ConversationSendStatus.failed,
          canRetry: canRetry,
          error: error,
        ),
      ),
    );
  }

  void _emitLifecycleFailure(ConversationApplicationErrorCode error) {
    _emit(
      state.copyWith(
        lifecycle: ConversationLifecycleState(
          status: ConversationLifecycleStatus.failed,
          error: error,
        ),
      ),
    );
  }

  void _recordMessageResult(
    Stopwatch stopwatch,
    ConversationMessageListResult result,
  ) {
    switch (result) {
      case ConversationMessageListSuccess(:final page):
        final invalid =
            page.nextCursor != null && page.nextCursor!.trim().isEmpty ||
            page.items.any((item) => item.conversationId != _conversationId);
        if (invalid) {
          _recordFailure(
            stopwatch,
            ConversationObservabilityEventName.contractViolationDetected,
            ConversationObservationCategory.contract,
            ConversationApplicationErrorCode.contractViolation,
          );
        } else {
          _recordSuccess(
            stopwatch,
            ConversationObservabilityEventName.paginationCompleted,
            ConversationObservationCategory.messages,
            itemCount: page.items.length,
          );
        }
      case ConversationMessageListFailure(:final status):
        _recordFailure(
          stopwatch,
          ConversationObservabilityEventName.paginationCompleted,
          ConversationObservationCategory.messages,
          mapConversationError(status),
        );
    }
  }

  void _recordRejectedSend(ConversationApplicationErrorCode error) {
    _record(
      ConversationObservabilityEventName.messageSendFailed,
      ConversationObservationCategory.send,
      _safeObservationResult(error),
      error: ConversationSafeErrorCode.values.byName(error.name),
    );
  }

  void _record(
    ConversationObservabilityEventName event,
    ConversationObservationCategory category,
    ConversationObservationResult result, {
    ConversationDurationBucket? duration,
    ConversationItemCountBucket? itemCount,
    ConversationRetryClass retry = ConversationRetryClass.none,
    ConversationSafeErrorCode? error,
  }) {
    try {
      observability.record(
        ConversationObservation(
          event: event,
          category: category,
          result: result,
          environment: observedEnvironment,
          duration: duration,
          itemCount: itemCount,
          retry: retry,
          error: error,
        ),
      );
    } on Object {
      // Observability is diagnostic and must never alter Product behavior.
    }
  }

  void _recordSuccess(
    Stopwatch stopwatch,
    ConversationObservabilityEventName event,
    ConversationObservationCategory category, {
    int? itemCount,
    ConversationRetryClass retry = ConversationRetryClass.none,
  }) {
    stopwatch.stop();
    _record(
      event,
      category,
      itemCount == 0
          ? ConversationObservationResult.empty
          : ConversationObservationResult.success,
      duration: conversationDurationBucket(stopwatch.elapsed),
      itemCount: itemCount == null
          ? null
          : conversationItemCountBucket(itemCount),
      retry: retry,
    );
  }

  void _recordFailure(
    Stopwatch stopwatch,
    ConversationObservabilityEventName event,
    ConversationObservationCategory category,
    ConversationApplicationErrorCode error, {
    ConversationRetryClass retry = ConversationRetryClass.none,
  }) {
    stopwatch.stop();
    _record(
      error == ConversationApplicationErrorCode.environmentBlocked
          ? ConversationObservabilityEventName.environmentBlocked
          : event,
      error == ConversationApplicationErrorCode.environmentBlocked
          ? ConversationObservationCategory.environment
          : category,
      _safeObservationResult(error),
      duration: conversationDurationBucket(stopwatch.elapsed),
      retry: retry,
      error: ConversationSafeErrorCode.values.byName(error.name),
    );
  }

  bool _isCurrent(int generation, ConversationId id) =>
      !_disposed && generation == _generation && id == _conversationId;

  void _emit(ConversationDetailState next) {
    if (_disposed) return;
    state = next;
    _onStateChanged?.call(next);
  }

  void dispose() {
    _disposed = true;
    _generation += 1;
    _pendingSend = null;
  }
}

ConversationObservationResult _safeObservationResult(
  ConversationApplicationErrorCode error,
) => ConversationObservationResult.values.byName(switch (error) {
  ConversationApplicationErrorCode.notFound => 'notFoundOpaque',
  ConversationApplicationErrorCode.unauthorized => 'unknownFailure',
  _ => error.name,
});

class _SendIntent {
  const _SendIntent(this.content, this.operationAttemptId);

  final String content;
  final OperationAttemptId operationAttemptId;
}

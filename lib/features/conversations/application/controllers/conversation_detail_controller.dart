import 'package:stasisly/core/idempotency/operation_attempt_id.dart';
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
    _emit(
      const ConversationDetailState(phase: ConversationDetailPhase.loading),
    );
    final result = await _readOwnConversation(id);
    if (!_isCurrent(generation, id)) return;
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
          return;
        }
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
        _emitDetailFailure(mapConversationError(status));
    }
  }

  Future<void> refresh() => load();

  Future<void> _loadFirstMessages(int generation, ConversationId id) async {
    final result = await _listOwnConversationMessages(
      ListConversationMessagesInput(conversationId: id, limit: pageSize),
    );
    if (!_isCurrent(generation, id)) return;
    _applyMessagePage(result, append: false);
  }

  Future<void> loadMoreMessages() async {
    if (_disposed || _loadingMore || !state.messages.hasMore) return;
    _loadingMore = true;
    final generation = _generation;
    final id = _conversationId;
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
    if (!_isCurrent(generation, id)) return;
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
      return;
    }
    final content = state.composer.draft.trim();
    if (content.isEmpty ||
        content.length > SendConversationMessageInput.maxContentLength) {
      _emitComposerFailure(ConversationApplicationErrorCode.invalidInput);
      return;
    }
    if (_pendingSend == null || _pendingSend!.content != content) {
      _pendingSend = _SendIntent(content, _operationAttemptIds.create());
    }
    await _submitPendingSend();
  }

  Future<void> retrySend() async {
    if (_disposed ||
        _sendInFlight ||
        _lifecycleInFlight ||
        _pendingSend == null ||
        state.isArchived) {
      return;
    }
    await _submitPendingSend();
  }

  Future<void> _submitPendingSend() async {
    final intent = _pendingSend!;
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
    if (_disposed || !identical(intent, _pendingSend)) return;
    switch (result) {
      case ConversationMessageSendSuccess(:final receipt):
        if (receipt.message.conversationId != _conversationId) {
          _pendingSend = null;
          _emitComposerFailure(
            ConversationApplicationErrorCode.contractViolation,
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
      case ConversationMutationFailure(:final status):
        _emitLifecycleFailure(mapConversationError(status));
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
              phase: ConversationMessagesPhase.error,
              error: mapConversationError(status),
              nextCursor: null,
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

class _SendIntent {
  const _SendIntent(this.content, this.operationAttemptId);

  final String content;
  final OperationAttemptId operationAttemptId;
}

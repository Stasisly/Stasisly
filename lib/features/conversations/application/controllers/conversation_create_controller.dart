import 'package:stasisly/core/idempotency/operation_attempt_id.dart';
import 'package:stasisly/features/conversations/application/inputs/conversation_inputs.dart';
import 'package:stasisly/features/conversations/application/state/conversation_application_states.dart';
import 'package:stasisly/features/conversations/application/state/conversation_result_mapping.dart';
import 'package:stasisly/features/conversations/application/use_cases/conversation_use_cases.dart';
import 'package:stasisly/features/conversations/domain/results/conversation_results.dart';

class ConversationCreateController {
  ConversationCreateController({
    required CreateOwnConversation createOwnConversation,
    required OperationAttemptIdFactory operationAttemptIds,
    void Function(ConversationCreateState)? onStateChanged,
  }) : _createOwnConversation = createOwnConversation,
       _operationAttemptIds = operationAttemptIds,
       _onStateChanged = onStateChanged;

  final CreateOwnConversation _createOwnConversation;
  final OperationAttemptIdFactory _operationAttemptIds;
  final void Function(ConversationCreateState)? _onStateChanged;

  ConversationCreateState state = const ConversationCreateState();
  _CreateIntent? _pending;
  bool _disposed = false;

  Future<void> create(String selectableSpecialistId) async {
    if (_disposed || state.status == ConversationCreateStatus.creating) return;
    final specialistId = selectableSpecialistId.trim();
    if (specialistId.isEmpty) {
      _emit(
        const ConversationCreateState(
          status: ConversationCreateStatus.failed,
          error: ConversationApplicationErrorCode.invalidInput,
        ),
      );
      return;
    }
    if (_pending == null || _pending!.selectableSpecialistId != specialistId) {
      _pending = _CreateIntent(specialistId, _operationAttemptIds.create());
    }
    await _submitPending();
  }

  Future<void> retry() async {
    if (_disposed ||
        state.status == ConversationCreateStatus.creating ||
        _pending == null) {
      return;
    }
    await _submitPending();
  }

  void startNewIntent() {
    if (state.status == ConversationCreateStatus.creating) return;
    _pending = null;
    _emit(const ConversationCreateState());
  }

  Future<void> _submitPending() async {
    final intent = _pending!;
    _emit(
      const ConversationCreateState(status: ConversationCreateStatus.creating),
    );
    final result = await _createOwnConversation(
      CreateConversationInput(
        operationAttemptId: intent.operationAttemptId,
        selectableSpecialistId: intent.selectableSpecialistId,
      ),
    );
    if (_disposed || !identical(intent, _pending)) return;
    switch (result) {
      case ConversationMutationSuccess(:final conversation):
        if (conversation == null) {
          _pending = null;
          _emit(
            const ConversationCreateState(
              status: ConversationCreateStatus.failed,
              error: ConversationApplicationErrorCode.contractViolation,
            ),
          );
          return;
        }
        _pending = null;
        _emit(
          ConversationCreateState(
            status: ConversationCreateStatus.success,
            conversation: conversation,
          ),
        );
      case ConversationMutationFailure(:final status):
        if (!isRetryableConversationFailure(status) &&
            status != ConversationResultStatus.idempotencyConflict) {
          _pending = null;
        }
        _emit(
          ConversationCreateState(
            status: ConversationCreateStatus.failed,
            error: mapConversationError(status),
          ),
        );
    }
  }

  void _emit(ConversationCreateState next) {
    if (_disposed) return;
    state = next;
    _onStateChanged?.call(next);
  }

  void dispose() {
    _disposed = true;
    _pending = null;
  }
}

class _CreateIntent {
  const _CreateIntent(this.selectableSpecialistId, this.operationAttemptId);

  final String selectableSpecialistId;
  final OperationAttemptId operationAttemptId;
}

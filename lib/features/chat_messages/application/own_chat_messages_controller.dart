import 'package:stasisly/features/chat_messages/application/own_chat_messages_state.dart';
import 'package:stasisly/features/chat_messages/domain/entities/own_chat_message.dart';
import 'package:stasisly/features/chat_messages/domain/entities/own_chat_message_results.dart';
import 'package:stasisly/features/chat_messages/domain/repositories/own_chat_messages_repository.dart';

class OwnChatMessagesController {
  OwnChatMessagesController({
    required OwnChatMessagesRepository repository,
    this.pageSize = 50,
  }) : _repository = repository;

  final OwnChatMessagesRepository _repository;
  final int pageSize;

  OwnChatMessagesState state = const OwnChatMessagesState();

  Future<void> loadInitial(String sessionId) async {
    state = OwnChatMessagesState(sessionId: sessionId, isInitialLoading: true);
    final result = await _repository.listSessionMessages(
      sessionId: sessionId,
      limit: pageSize,
    );
    state = _stateFromInitialResult(sessionId, result);
  }

  Future<void> loadNextPage() async {
    final sessionId = state.sessionId;
    final cursor = state.nextCursor;
    if (sessionId == null || cursor == null || state.isPaginating) return;
    final previous = state;
    state = state.copyWith(isPaginating: true, lastListError: null);
    final result = await _repository.listSessionMessages(
      sessionId: sessionId,
      limit: pageSize,
      cursor: cursor,
    );
    state = _stateFromNextPageResult(previous, result);
  }

  Future<void> sendMessage(String content) async {
    final sessionId = state.sessionId;
    if (sessionId == null) {
      state = state.copyWith(
        lastSendError: SendOwnChatMessageFailureType.invalidSession,
      );
      return;
    }
    final previous = state;
    state = state.copyWith(isSending: true, lastSendError: null);
    final result = await _repository.sendUserMessage(
      sessionId: sessionId,
      content: content,
    );
    state = _stateFromSendResult(previous, result);
  }

  Future<void> refresh() async {
    final sessionId = state.sessionId;
    if (sessionId == null) return;
    await loadInitial(sessionId);
  }

  void clear() {
    state = const OwnChatMessagesState();
  }

  OwnChatMessagesState _stateFromInitialResult(
    String sessionId,
    ListSessionMessagesResult result,
  ) {
    return switch (result) {
      ListSessionMessagesSuccess(:final page) => OwnChatMessagesState(
        sessionId: sessionId,
        messages: _orderedUnique(page.items),
        nextCursor: page.nextCursor,
      ),
      ListSessionMessagesDemo(:final page) => OwnChatMessagesState(
        sessionId: sessionId,
        messages: _orderedUnique(page.items),
        nextCursor: page.nextCursor,
        isDemo: true,
      ),
      ListSessionMessagesEmpty() => OwnChatMessagesState(sessionId: sessionId),
      ListSessionMessagesFailure(:final type) => OwnChatMessagesState(
        sessionId: sessionId,
        lastListError: type,
        isBackendBlocked: type == ListOwnChatMessagesFailureType.backendBlocked,
      ),
    };
  }

  OwnChatMessagesState _stateFromNextPageResult(
    OwnChatMessagesState previous,
    ListSessionMessagesResult result,
  ) {
    return switch (result) {
      ListSessionMessagesSuccess(:final page) => previous.copyWith(
        messages: _orderedUnique([...previous.messages, ...page.items]),
        nextCursor: page.nextCursor,
        isPaginating: false,
        isDemo: false,
        isBackendBlocked: false,
        lastListError: null,
      ),
      ListSessionMessagesDemo(:final page) => previous.copyWith(
        messages: _orderedUnique([...previous.messages, ...page.items]),
        nextCursor: page.nextCursor,
        isPaginating: false,
        isDemo: true,
        isBackendBlocked: false,
        lastListError: null,
      ),
      ListSessionMessagesEmpty() => previous.copyWith(
        nextCursor: null,
        isPaginating: false,
        lastListError: null,
      ),
      ListSessionMessagesFailure(:final type) => previous.copyWith(
        isPaginating: false,
        lastListError: type,
        isBackendBlocked: type == ListOwnChatMessagesFailureType.backendBlocked,
      ),
    };
  }

  OwnChatMessagesState _stateFromSendResult(
    OwnChatMessagesState previous,
    SendUserMessageResult result,
  ) {
    return switch (result) {
      SendUserMessageSuccess(:final sent) => previous.copyWith(
        messages: _orderedUnique([...previous.messages, sent.message]),
        isSending: false,
        isDemo: false,
        isBackendBlocked: false,
        lastSendError: null,
        confirmedMessageCount: sent.messageCount,
        confirmedLastMessageAt: sent.lastMessageAt,
      ),
      SendUserMessageDemo(:final sent) => previous.copyWith(
        messages: _orderedUnique([...previous.messages, sent.message]),
        isSending: false,
        isDemo: true,
        isBackendBlocked: false,
        lastSendError: null,
        confirmedMessageCount: sent.messageCount,
        confirmedLastMessageAt: sent.lastMessageAt,
      ),
      SendUserMessageFailure(:final type) => previous.copyWith(
        isSending: false,
        lastSendError: type,
        isBackendBlocked: type == SendOwnChatMessageFailureType.backendBlocked,
      ),
    };
  }

  List<OwnChatMessage> _orderedUnique(List<OwnChatMessage> messages) {
    final byId = <String, OwnChatMessage>{};
    for (final message in messages) {
      byId[message.messageId] = message;
    }
    final ordered = byId.values.toList()
      ..sort((left, right) {
        final byCreatedAt = left.createdAt.compareTo(right.createdAt);
        if (byCreatedAt != 0) return byCreatedAt;
        return left.messageId.compareTo(right.messageId);
      });
    return List.unmodifiable(ordered);
  }
}

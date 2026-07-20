import 'package:stasisly/core/idempotency/operation_attempt_id.dart';
import 'package:stasisly/features/chat_messages/domain/entities/own_chat_message.dart';
import 'package:stasisly/features/chat_messages/domain/entities/own_chat_message_results.dart';
import 'package:stasisly/features/chat_messages/domain/repositories/own_chat_messages_repository.dart';
import 'package:stasisly/features/chat_messages/domain/validation/own_chat_message_input_validator.dart';

class DemoOwnChatMessagesRepository implements OwnChatMessagesRepository {
  DemoOwnChatMessagesRepository();

  final OwnChatMessageInputValidator _validator =
      const OwnChatMessageInputValidator();
  final Map<String, List<OwnChatMessage>> _messagesBySession = {};
  final Map<String, _CursorPosition> _cursorPositions = {};
  int _nextMessage = 1;
  int _nextCursor = 1;

  @override
  Future<SendUserMessageResult> sendUserMessage({
    required String sessionId,
    required String content,
    required OperationAttemptId operationAttemptId,
  }) async {
    final error = _validator.validateSend(
      sessionId: sessionId,
      content: content,
    );
    if (error != null) return SendUserMessageFailure(_sendFailure(error));

    final messages = _messagesBySession.putIfAbsent(sessionId, () => []);
    final sequence = _nextMessage++;
    final createdAt = DateTime.utc(2026).add(Duration(minutes: sequence));
    final message = OwnChatMessage(
      messageId: 'demo-message-$sequence',
      sessionId: sessionId,
      role: OwnChatMessageRole.user,
      content: content.trim(),
      createdAt: createdAt,
      isDemo: true,
      authorType: OwnChatMessageAuthorType.user,
      provenance: OwnChatMessageProvenance.userProvided,
      visibility: OwnChatMessageVisibility.productVisible,
      status: OwnChatMessageStatus.accepted,
    );
    messages.add(message);
    return SendUserMessageDemo(
      SentOwnChatMessage(
        message: message,
        sessionId: sessionId,
        messageCount: messages.length,
        lastMessageAt: createdAt,
        isDemo: true,
      ),
    );
  }

  @override
  Future<ListSessionMessagesResult> listSessionMessages({
    required String sessionId,
    int limit = 50,
    String? cursor,
  }) async {
    final error = _validator.validateList(
      sessionId: sessionId,
      limit: limit,
      cursor: cursor,
    );
    if (error != null) return ListSessionMessagesFailure(_listFailure(error));

    final offset = cursor == null ? 0 : _cursorPositions[cursor]?.offset;
    if (offset == null) {
      return const ListSessionMessagesFailure(
        ListOwnChatMessagesFailureType.invalidCursor,
      );
    }
    if (cursor != null && _cursorPositions[cursor]?.sessionId != sessionId) {
      return const ListSessionMessagesFailure(
        ListOwnChatMessagesFailureType.invalidCursor,
      );
    }

    final messages = List<OwnChatMessage>.unmodifiable(
      _messagesBySession[sessionId] ?? const [],
    );
    final end = (offset + limit).clamp(0, messages.length);
    final items = List<OwnChatMessage>.unmodifiable(
      messages.sublist(offset, end),
    );
    String? nextCursor;
    if (end < messages.length) {
      nextCursor = 'demo-message-cursor-${_nextCursor++}';
      _cursorPositions[nextCursor] = _CursorPosition(
        sessionId: sessionId,
        offset: end,
      );
    }
    return ListSessionMessagesDemo(
      OwnChatMessagesPage(items: items, nextCursor: nextCursor),
    );
  }

  SendOwnChatMessageFailureType _sendFailure(OwnChatMessageInputError error) {
    return switch (error) {
      OwnChatMessageInputError.invalidSession =>
        SendOwnChatMessageFailureType.invalidSession,
      OwnChatMessageInputError.contentInvalid =>
        SendOwnChatMessageFailureType.contentInvalid,
      OwnChatMessageInputError.contentTooLong =>
        SendOwnChatMessageFailureType.contentTooLong,
      OwnChatMessageInputError.invalidRequest =>
        SendOwnChatMessageFailureType.invalidRequest,
    };
  }

  ListOwnChatMessagesFailureType _listFailure(OwnChatMessageInputError error) {
    return switch (error) {
      OwnChatMessageInputError.invalidSession =>
        ListOwnChatMessagesFailureType.invalidSession,
      OwnChatMessageInputError.contentInvalid ||
      OwnChatMessageInputError.contentTooLong ||
      OwnChatMessageInputError.invalidRequest =>
        ListOwnChatMessagesFailureType.invalidRequest,
    };
  }
}

class _CursorPosition {
  const _CursorPosition({required this.sessionId, required this.offset});

  final String sessionId;
  final int offset;
}

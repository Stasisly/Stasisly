import 'package:flutter_test/flutter_test.dart';
import 'package:stasisly/core/idempotency/operation_attempt_id.dart';

import 'package:stasisly/features/chat_messages/application/own_chat_messages_controller.dart';
import 'package:stasisly/features/chat_messages/application/own_chat_messages_state.dart';
import 'package:stasisly/features/chat_messages/domain/entities/own_chat_message.dart';
import 'package:stasisly/features/chat_messages/domain/entities/own_chat_message_results.dart';
import 'package:stasisly/features/chat_messages/domain/repositories/own_chat_messages_repository.dart';

void main() {
  const sessionId = '00000000-0000-4000-8000-000000000001';

  test('initial state has no session, messages, cursor or errors', () {
    const state = OwnChatMessagesState();

    expect(state.sessionId, isNull);
    expect(state.messages, isEmpty);
    expect(state.nextCursor, isNull);
    expect(state.isInitialLoading, isFalse);
    expect(state.isPaginating, isFalse);
    expect(state.isSending, isFalse);
    expect(state.lastListError, isNull);
    expect(state.lastSendError, isNull);
  });

  test('loadInitial stores messages and next cursor', () async {
    final repository = _FakeOwnChatMessagesRepository(
      listResults: [
        ListSessionMessagesSuccess(
          OwnChatMessagesPage(
            items: [_message('m2', minute: 2), _message('m1')],
            nextCursor: 'cursor-1',
          ),
        ),
      ],
    );
    final controller = OwnChatMessagesController(repository: repository);

    await controller.loadInitial(sessionId);

    expect(repository.listCalls.single.sessionId, sessionId);
    expect(repository.listCalls.single.limit, 50);
    expect(repository.listCalls.single.cursor, isNull);
    expect(controller.state.messages.map((message) => message.messageId), [
      'm1',
      'm2',
    ]);
    expect(controller.state.nextCursor, 'cursor-1');
    expect(controller.state.lastListError, isNull);
  });

  test(
    'loadInitial empty keeps selected session without inventing messages',
    () async {
      final controller = OwnChatMessagesController(
        repository: _FakeOwnChatMessagesRepository(
          listResults: const [ListSessionMessagesEmpty()],
        ),
      );

      await controller.loadInitial(sessionId);

      expect(controller.state.sessionId, sessionId);
      expect(controller.state.messages, isEmpty);
      expect(controller.state.nextCursor, isNull);
      expect(controller.state.isEmpty, isTrue);
    },
  );

  test('loadInitial maps list failures without demo fallback', () async {
    final controller = OwnChatMessagesController(
      repository: _FakeOwnChatMessagesRepository(
        listResults: const [
          ListSessionMessagesFailure(
            ListOwnChatMessagesFailureType.networkError,
          ),
        ],
      ),
    );

    await controller.loadInitial(sessionId);

    expect(
      controller.state.lastListError,
      ListOwnChatMessagesFailureType.networkError,
    );
    expect(controller.state.messages, isEmpty);
    expect(controller.state.isDemo, isFalse);
  });

  test(
    'backendBlocked list result marks backend blocked without demo',
    () async {
      final controller = OwnChatMessagesController(
        repository: _FakeOwnChatMessagesRepository(
          listResults: const [
            ListSessionMessagesFailure(
              ListOwnChatMessagesFailureType.backendBlocked,
            ),
          ],
        ),
      );

      await controller.loadInitial(sessionId);

      expect(controller.state.isBackendBlocked, isTrue);
      expect(controller.state.isDemo, isFalse);
    },
  );

  test('loadNextPage appends unique messages and preserves order', () async {
    final repository = _FakeOwnChatMessagesRepository(
      listResults: [
        ListSessionMessagesSuccess(
          OwnChatMessagesPage(items: [_message('m1')], nextCursor: 'cursor-1'),
        ),
        ListSessionMessagesSuccess(
          OwnChatMessagesPage(
            items: [_message('m1'), _message('m3', minute: 3)],
            nextCursor: null,
          ),
        ),
      ],
    );
    final controller = OwnChatMessagesController(repository: repository);

    await controller.loadInitial(sessionId);
    await controller.loadNextPage();

    expect(repository.listCalls.last.cursor, 'cursor-1');
    expect(controller.state.messages.map((message) => message.messageId), [
      'm1',
      'm3',
    ]);
    expect(controller.state.nextCursor, isNull);
  });

  test('loadNextPage does nothing without cursor', () async {
    final repository = _FakeOwnChatMessagesRepository(
      listResults: [
        ListSessionMessagesSuccess(
          OwnChatMessagesPage(items: [_message('m1')], nextCursor: null),
        ),
      ],
    );
    final controller = OwnChatMessagesController(repository: repository);

    await controller.loadInitial(sessionId);
    await controller.loadNextPage();

    expect(repository.listCalls, hasLength(1));
  });

  test('pagination error preserves existing messages', () async {
    final repository = _FakeOwnChatMessagesRepository(
      listResults: [
        ListSessionMessagesSuccess(
          OwnChatMessagesPage(items: [_message('m1')], nextCursor: 'cursor-1'),
        ),
        const ListSessionMessagesFailure(
          ListOwnChatMessagesFailureType.contractViolation,
        ),
      ],
    );
    final controller = OwnChatMessagesController(repository: repository);

    await controller.loadInitial(sessionId);
    await controller.loadNextPage();

    expect(controller.state.messages.map((message) => message.messageId), [
      'm1',
    ]);
    expect(
      controller.state.lastListError,
      ListOwnChatMessagesFailureType.contractViolation,
    );
    expect(controller.state.isDemo, isFalse);
  });

  test('sendMessage calls repository with session and content only', () async {
    final repository = _FakeOwnChatMessagesRepository(
      listResults: [ListSessionMessagesSuccess(_page())],
      sendResults: [_sendSuccess(_message('m2', minute: 2))],
    );
    final controller = OwnChatMessagesController(repository: repository);

    await controller.loadInitial(sessionId);
    await controller.sendMessage('hello');

    expect(repository.sendCalls.single.sessionId, sessionId);
    expect(repository.sendCalls.single.content, 'hello');
    expect(controller.state.messages.map((message) => message.messageId), [
      'm1',
      'm2',
    ]);
    expect(controller.state.confirmedMessageCount, 2);
  });

  test('sendMessage does not duplicate existing sent message', () async {
    final repository = _FakeOwnChatMessagesRepository(
      listResults: [ListSessionMessagesSuccess(_page())],
      sendResults: [_sendSuccess(_message('m1'))],
    );
    final controller = OwnChatMessagesController(repository: repository);

    await controller.loadInitial(sessionId);
    await controller.sendMessage('hello again');

    expect(controller.state.messages, hasLength(1));
    expect(controller.state.messages.single.messageId, 'm1');
  });

  test('send errors preserve existing list', () async {
    final repository = _FakeOwnChatMessagesRepository(
      listResults: [ListSessionMessagesSuccess(_page())],
      sendResults: const [
        SendUserMessageFailure(SendOwnChatMessageFailureType.sessionArchived),
      ],
    );
    final controller = OwnChatMessagesController(repository: repository);

    await controller.loadInitial(sessionId);
    await controller.sendMessage('archived');

    expect(controller.state.messages.map((message) => message.messageId), [
      'm1',
    ]);
    expect(
      controller.state.lastSendError,
      SendOwnChatMessageFailureType.sessionArchived,
    );
    expect(controller.state.isDemo, isFalse);
  });

  test(
    'sendMessage without selected session fails without repository call',
    () async {
      final repository = _FakeOwnChatMessagesRepository();
      final controller = OwnChatMessagesController(repository: repository);

      await controller.sendMessage('hello');

      expect(repository.sendCalls, isEmpty);
      expect(
        controller.state.lastSendError,
        SendOwnChatMessageFailureType.invalidSession,
      );
    },
  );

  test('refresh reloads first page and replaces confirmed messages', () async {
    final repository = _FakeOwnChatMessagesRepository(
      listResults: [
        ListSessionMessagesSuccess(_page()),
        ListSessionMessagesSuccess(
          OwnChatMessagesPage(
            items: [_message('fresh', minute: 5)],
            nextCursor: null,
          ),
        ),
      ],
    );
    final controller = OwnChatMessagesController(repository: repository);

    await controller.loadInitial(sessionId);
    await controller.refresh();

    expect(controller.state.sessionId, sessionId);
    expect(controller.state.messages.map((message) => message.messageId), [
      'fresh',
    ]);
    expect(repository.listCalls.last.cursor, isNull);
  });

  test('clear resets complete state', () async {
    final controller = OwnChatMessagesController(
      repository: _FakeOwnChatMessagesRepository(
        listResults: [ListSessionMessagesSuccess(_page(nextCursor: 'next'))],
      ),
    );

    await controller.loadInitial(sessionId);
    controller.clear();

    expect(controller.state, const OwnChatMessagesState());
  });

  test('demo repository result marks demo explicitly', () async {
    final controller = OwnChatMessagesController(
      repository: _FakeOwnChatMessagesRepository(
        listResults: [
          ListSessionMessagesDemo(
            OwnChatMessagesPage(
              items: [_message('demo', isDemo: true)],
              nextCursor: null,
            ),
          ),
        ],
      ),
    );

    await controller.loadInitial(sessionId);

    expect(controller.state.isDemo, isTrue);
    expect(controller.state.messages.single.isDemo, isTrue);
  });

  test(
    'backendBlocked send result marks backend blocked without demo',
    () async {
      final repository = _FakeOwnChatMessagesRepository(
        listResults: [ListSessionMessagesSuccess(_page())],
        sendResults: const [
          SendUserMessageFailure(SendOwnChatMessageFailureType.backendBlocked),
        ],
      );
      final controller = OwnChatMessagesController(repository: repository);

      await controller.loadInitial(sessionId);
      await controller.sendMessage('blocked');

      expect(controller.state.isBackendBlocked, isTrue);
      expect(controller.state.isDemo, isFalse);
      expect(controller.state.messages, hasLength(1));
    },
  );
}

OwnChatMessagesPage _page({String? nextCursor}) {
  return OwnChatMessagesPage(items: [_message('m1')], nextCursor: nextCursor);
}

OwnChatMessage _message(String id, {int minute = 1, bool isDemo = false}) {
  return OwnChatMessage(
    messageId: id,
    sessionId: '00000000-0000-4000-8000-000000000001',
    role: OwnChatMessageRole.user,
    content: 'content $id',
    createdAt: DateTime.utc(2026, 6, 21, 10, minute),
    isDemo: isDemo,
  );
}

SendUserMessageSuccess _sendSuccess(OwnChatMessage message) {
  return SendUserMessageSuccess(
    SentOwnChatMessage(
      message: message,
      sessionId: message.sessionId,
      messageCount: 2,
      lastMessageAt: message.createdAt,
      isDemo: message.isDemo,
    ),
  );
}

class _FakeOwnChatMessagesRepository implements OwnChatMessagesRepository {
  _FakeOwnChatMessagesRepository({
    List<ListSessionMessagesResult>? listResults,
    List<SendUserMessageResult>? sendResults,
  }) : _listResults = [...?listResults],
       _sendResults = [...?sendResults];

  final List<ListSessionMessagesResult> _listResults;
  final List<SendUserMessageResult> _sendResults;
  final List<_ListCall> listCalls = [];
  final List<_SendCall> sendCalls = [];

  @override
  Future<ListSessionMessagesResult> listSessionMessages({
    required String sessionId,
    int limit = 50,
    String? cursor,
  }) async {
    listCalls.add(_ListCall(sessionId, limit, cursor));
    return _listResults.removeAt(0);
  }

  @override
  Future<SendUserMessageResult> sendUserMessage({
    required String sessionId,
    required String content,
    required OperationAttemptId operationAttemptId,
  }) async {
    sendCalls.add(_SendCall(sessionId, content));
    return _sendResults.removeAt(0);
  }
}

class _ListCall {
  const _ListCall(this.sessionId, this.limit, this.cursor);

  final String sessionId;
  final int limit;
  final String? cursor;
}

class _SendCall {
  const _SendCall(this.sessionId, this.content);

  final String sessionId;
  final String content;
}

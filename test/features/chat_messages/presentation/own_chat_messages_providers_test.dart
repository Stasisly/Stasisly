import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:stasisly/core/auth/session/secure_session.dart';
import 'package:stasisly/core/config/app_environment.dart';
import 'package:stasisly/features/chat_messages/application/own_chat_messages_state.dart';
import 'package:stasisly/features/chat_messages/data/datasources/local_http_own_chat_messages_datasource.dart';
import 'package:stasisly/features/chat_messages/data/repositories/backend_blocked_own_chat_messages_repository.dart';
import 'package:stasisly/features/chat_messages/data/repositories/demo_own_chat_messages_repository.dart';
import 'package:stasisly/features/chat_messages/domain/entities/own_chat_message.dart';
import 'package:stasisly/features/chat_messages/domain/entities/own_chat_message_results.dart';
import 'package:stasisly/features/chat_messages/domain/repositories/own_chat_messages_repository.dart';
import 'package:stasisly/features/chat_messages/presentation/providers/own_chat_messages_providers.dart';

void main() {
  const sessionA = '00000000-0000-4000-8000-000000000101';
  const sessionB = '00000000-0000-4000-8000-000000000202';

  test('repository provider selects explicit demo repository in demo mode', () {
    final container = ProviderContainer(
      overrides: [
        appEnvironmentProvider.overrideWithValue(
          const AppEnvironment(mode: AppRuntimeMode.demo),
        ),
      ],
    );
    addTearDown(container.dispose);

    expect(
      container.read(ownChatMessagesRepositoryProvider),
      isA<DemoOwnChatMessagesRepository>(),
    );
  });

  test('repository provider keeps backend modes explicitly blocked', () async {
    for (final mode in [
      AppRuntimeMode.backendReal,
      AppRuntimeMode.production,
    ]) {
      final container = ProviderContainer(
        overrides: [
          appEnvironmentProvider.overrideWithValue(AppEnvironment(mode: mode)),
        ],
      );
      addTearDown(container.dispose);

      final repository = container.read(ownChatMessagesRepositoryProvider);

      expect(repository, isA<BackendBlockedOwnChatMessagesRepository>());
      expect(
        await repository.listSessionMessages(sessionId: sessionA),
        isA<ListSessionMessagesFailure>(),
      );
    }
  });

  test(
    'repository provider selects remote HTTP repository only in gated development',
    () {
      final container = ProviderContainer(
        overrides: [
          appEnvironmentProvider.overrideWithValue(
            const AppEnvironment(
              mode: AppRuntimeMode.development,
              supabaseUrl: 'https://project.supabase.co',
              supabaseAnonKey: 'public-test-key',
              remoteBackendEnabled: true,
              realAuthEnabled: true,
            ),
          ),
          secureSessionTokenProvider.overrideWithValue(
            _FakeSecureSessionTokenProvider(
              SecureSessionTokenResult.success('fake-development-token'),
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      expect(
        container.read(ownChatMessagesRepositoryProvider),
        isA<LocalHttpOwnChatMessagesDataSource>(),
      );
    },
  );

  test('development without auth gate remains backendBlocked', () {
    final container = ProviderContainer(
      overrides: [
        appEnvironmentProvider.overrideWithValue(
          const AppEnvironment(
            mode: AppRuntimeMode.development,
            supabaseUrl: 'https://project.supabase.co',
            supabaseAnonKey: 'public-test-key',
            remoteBackendEnabled: true,
          ),
        ),
      ],
    );
    addTearDown(container.dispose);

    expect(
      container.read(ownChatMessagesRepositoryProvider),
      isA<BackendBlockedOwnChatMessagesRepository>(),
    );
  });

  test('local session token provider maps secure success token', () async {
    final container = ProviderContainer(
      overrides: [
        secureSessionTokenProvider.overrideWithValue(
          _FakeSecureSessionTokenProvider(
            SecureSessionTokenResult.success('fake-messages-token'),
          ),
        ),
      ],
    );
    addTearDown(container.dispose);

    final tokenProvider = container.read(
      ownChatMessagesLocalSessionTokenProvider,
    );

    expect(await tokenProvider.readLocalSessionToken(), 'fake-messages-token');
  });

  test(
    'local session token provider maps demo and backendBlocked to null',
    () async {
      for (final result in [
        const SecureSessionTokenResult.demo(),
        const SecureSessionTokenResult.backendBlocked(),
      ]) {
        final container = ProviderContainer(
          overrides: [
            secureSessionTokenProvider.overrideWithValue(
              _FakeSecureSessionTokenProvider(result),
            ),
          ],
        );
        addTearDown(container.dispose);

        final tokenProvider = container.read(
          ownChatMessagesLocalSessionTokenProvider,
        );

        expect(await tokenProvider.readLocalSessionToken(), isNull);
      }
    },
  );

  test(
    'throwing secure session provider returns null without activating backend',
    () async {
      final container = ProviderContainer(
        overrides: [
          appEnvironmentProvider.overrideWithValue(
            const AppEnvironment(mode: AppRuntimeMode.backendReal),
          ),
          secureSessionTokenProvider.overrideWithValue(
            _ThrowingSecureSessionTokenProvider(),
          ),
        ],
      );
      addTearDown(container.dispose);

      final tokenProvider = container.read(
        ownChatMessagesLocalSessionTokenProvider,
      );
      final repository = container.read(ownChatMessagesRepositoryProvider);

      expect(await tokenProvider.readLocalSessionToken(), isNull);
      expect(repository, isA<BackendBlockedOwnChatMessagesRepository>());
    },
  );

  test('controller provider exposes initial state', () {
    final container = _containerWithRepository(
      _FakeOwnChatMessagesRepository(),
    );
    addTearDown(container.dispose);

    expect(
      container.read(ownChatMessagesControllerProvider.notifier),
      isA<OwnChatMessagesControllerNotifier>(),
    );
    expect(
      container.read(ownChatMessagesStateProvider),
      const OwnChatMessagesState(),
    );
  });

  test('providers allow repository override and loadInitial', () async {
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
    final container = _containerWithRepository(repository);
    addTearDown(container.dispose);

    await container
        .read(ownChatMessagesControllerProvider.notifier)
        .loadInitial(sessionA);

    expect(repository.listCalls.single.sessionId, sessionA);
    expect(repository.listCalls.single.limit, 50);
    expect(repository.listCalls.single.cursor, isNull);
    expect(
      container
          .read(ownChatMessagesStateProvider)
          .messages
          .map((message) => message.messageId),
      ['m1', 'm2'],
    );
    expect(container.read(ownChatMessagesStateProvider).nextCursor, 'cursor-1');
  });

  test(
    'loadInitial exposes loading state before repository completes',
    () async {
      final repository = _PendingOwnChatMessagesRepository();
      final container = _containerWithRepository(repository);
      addTearDown(container.dispose);

      final future = container
          .read(ownChatMessagesControllerProvider.notifier)
          .loadInitial(sessionA);

      expect(container.read(ownChatMessagesStateProvider).sessionId, sessionA);
      expect(
        container.read(ownChatMessagesStateProvider).isInitialLoading,
        isTrue,
      );

      repository.completeList(ListSessionMessagesSuccess(_page()));
      await future;

      expect(
        container.read(ownChatMessagesStateProvider).isInitialLoading,
        isFalse,
      );
    },
  );

  test('loadNextPage through provider appends without duplicates', () async {
    final repository = _FakeOwnChatMessagesRepository(
      listResults: [
        ListSessionMessagesSuccess(
          OwnChatMessagesPage(items: [_message('m1')], nextCursor: 'cursor-1'),
        ),
        ListSessionMessagesSuccess(
          OwnChatMessagesPage(
            items: [_message('m1'), _message('m2', minute: 2)],
            nextCursor: null,
          ),
        ),
      ],
    );
    final container = _containerWithRepository(repository);
    addTearDown(container.dispose);

    final notifier = container.read(ownChatMessagesControllerProvider.notifier);
    await notifier.loadInitial(sessionA);
    await notifier.loadNextPage();

    expect(repository.listCalls.last.sessionId, sessionA);
    expect(repository.listCalls.last.limit, 50);
    expect(repository.listCalls.last.cursor, 'cursor-1');
    expect(
      container
          .read(ownChatMessagesStateProvider)
          .messages
          .map((message) => message.messageId),
      ['m1', 'm2'],
    );
    expect(container.read(ownChatMessagesStateProvider).nextCursor, isNull);
  });

  test('sendMessage through provider accepts only content', () async {
    final repository = _FakeOwnChatMessagesRepository(
      listResults: [ListSessionMessagesSuccess(_page())],
      sendResults: [_sendSuccess(_message('m2', minute: 2))],
    );
    final container = _containerWithRepository(repository);
    addTearDown(container.dispose);

    final notifier = container.read(ownChatMessagesControllerProvider.notifier);
    await notifier.loadInitial(sessionA);
    await notifier.sendMessage('hello');

    expect(repository.sendCalls.single.sessionId, sessionA);
    expect(repository.sendCalls.single.content, 'hello');
    expect(
      container.read(ownChatMessagesStateProvider).confirmedMessageCount,
      2,
    );
    expect(
      container
          .read(ownChatMessagesStateProvider)
          .messages
          .map((message) => message.messageId),
      ['m1', 'm2'],
    );
  });

  test(
    'sendMessage exposes sending state before repository completes',
    () async {
      final repository = _PendingOwnChatMessagesRepository();
      final container = _containerWithRepository(repository);
      addTearDown(container.dispose);

      final notifier = container.read(
        ownChatMessagesControllerProvider.notifier,
      );
      final loadFuture = notifier.loadInitial(sessionA);
      repository.completeList(ListSessionMessagesSuccess(_page()));
      await loadFuture;

      final sendFuture = notifier.sendMessage('hello');

      expect(container.read(ownChatMessagesStateProvider).isSending, isTrue);

      repository.completeSend(_sendSuccess(_message('m2', minute: 2)));
      await sendFuture;

      expect(container.read(ownChatMessagesStateProvider).isSending, isFalse);
      expect(
        container.read(ownChatMessagesStateProvider).messages,
        hasLength(2),
      );
    },
  );

  test('refresh reloads selected session from first page', () async {
    final repository = _FakeOwnChatMessagesRepository(
      listResults: [
        ListSessionMessagesSuccess(_page(nextCursor: 'cursor-1')),
        ListSessionMessagesSuccess(
          OwnChatMessagesPage(
            items: [_message('fresh', minute: 5)],
            nextCursor: null,
          ),
        ),
      ],
    );
    final container = _containerWithRepository(repository);
    addTearDown(container.dispose);

    final notifier = container.read(ownChatMessagesControllerProvider.notifier);
    await notifier.loadInitial(sessionA);
    await notifier.refresh();

    expect(repository.listCalls.last.sessionId, sessionA);
    expect(repository.listCalls.last.limit, 50);
    expect(repository.listCalls.last.cursor, isNull);
    expect(
      container
          .read(ownChatMessagesStateProvider)
          .messages
          .map((message) => message.messageId),
      ['fresh'],
    );
  });

  test('clear resets provider state', () async {
    final container = _containerWithRepository(
      _FakeOwnChatMessagesRepository(
        listResults: [ListSessionMessagesSuccess(_page())],
      ),
    );
    addTearDown(container.dispose);

    final notifier = container.read(ownChatMessagesControllerProvider.notifier);
    await notifier.loadInitial(sessionA);
    notifier.clear();

    expect(
      container.read(ownChatMessagesStateProvider),
      const OwnChatMessagesState(),
    );
  });

  test('changing session does not mix messages or cursor', () async {
    final repository = _FakeOwnChatMessagesRepository(
      listResults: [
        ListSessionMessagesSuccess(_page(nextCursor: 'cursor-a')),
        ListSessionMessagesSuccess(
          OwnChatMessagesPage(
            items: [_message('b1', sessionId: sessionB)],
            nextCursor: null,
          ),
        ),
      ],
    );
    final container = _containerWithRepository(repository);
    addTearDown(container.dispose);

    final notifier = container.read(ownChatMessagesControllerProvider.notifier);
    await notifier.loadInitial(sessionA);
    await notifier.loadInitial(sessionB);

    final state = container.read(ownChatMessagesStateProvider);
    expect(state.sessionId, sessionB);
    expect(state.nextCursor, isNull);
    expect(state.messages.map((message) => message.sessionId).toSet(), {
      sessionB,
    });
    expect(state.messages.map((message) => message.messageId), ['b1']);
  });

  test('send error remains visible and preserves existing messages', () async {
    final repository = _FakeOwnChatMessagesRepository(
      listResults: [ListSessionMessagesSuccess(_page())],
      sendResults: const [
        SendUserMessageFailure(SendOwnChatMessageFailureType.networkError),
      ],
    );
    final container = _containerWithRepository(repository);
    addTearDown(container.dispose);

    final notifier = container.read(ownChatMessagesControllerProvider.notifier);
    await notifier.loadInitial(sessionA);
    await notifier.sendMessage('hello');

    final state = container.read(ownChatMessagesStateProvider);
    expect(state.messages.map((message) => message.messageId), ['m1']);
    expect(state.lastSendError, SendOwnChatMessageFailureType.networkError);
    expect(state.isDemo, isFalse);
  });

  test('list error remains visible without demo fallback', () async {
    final container = _containerWithRepository(
      _FakeOwnChatMessagesRepository(
        listResults: const [
          ListSessionMessagesFailure(
            ListOwnChatMessagesFailureType.contractViolation,
          ),
        ],
      ),
    );
    addTearDown(container.dispose);

    await container
        .read(ownChatMessagesControllerProvider.notifier)
        .loadInitial(sessionA);

    final state = container.read(ownChatMessagesStateProvider);
    expect(
      state.lastListError,
      ListOwnChatMessagesFailureType.contractViolation,
    );
    expect(state.isDemo, isFalse);
  });

  test('backendBlocked is explicit and not demo', () async {
    final container = _containerWithRepository(
      const BackendBlockedOwnChatMessagesRepository(),
    );
    addTearDown(container.dispose);

    await container
        .read(ownChatMessagesControllerProvider.notifier)
        .loadInitial(sessionA);

    final state = container.read(ownChatMessagesStateProvider);
    expect(state.isBackendBlocked, isTrue);
    expect(state.isDemo, isFalse);
  });

  test('demo only appears when demo repository is injected', () async {
    final container = _containerWithRepository(DemoOwnChatMessagesRepository());
    addTearDown(container.dispose);

    final notifier = container.read(ownChatMessagesControllerProvider.notifier);
    await notifier.loadInitial(sessionA);
    await notifier.sendMessage('demo message');

    final state = container.read(ownChatMessagesStateProvider);
    expect(state.isDemo, isTrue);
    expect(state.messages.single.isDemo, isTrue);
  });
}

ProviderContainer _containerWithRepository(
  OwnChatMessagesRepository repository,
) {
  return ProviderContainer(
    overrides: [
      ownChatMessagesRepositoryProvider.overrideWithValue(repository),
    ],
  );
}

OwnChatMessagesPage _page({String? nextCursor}) {
  return OwnChatMessagesPage(items: [_message('m1')], nextCursor: nextCursor);
}

OwnChatMessage _message(
  String id, {
  String sessionId = '00000000-0000-4000-8000-000000000101',
  int minute = 1,
  bool isDemo = false,
}) {
  return OwnChatMessage(
    messageId: id,
    sessionId: sessionId,
    role: OwnChatMessageRole.user,
    content: 'content $id',
    createdAt: DateTime.utc(2026, 6, 21, 12, minute),
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
  }) async {
    sendCalls.add(_SendCall(sessionId, content));
    return _sendResults.removeAt(0);
  }
}

class _PendingOwnChatMessagesRepository implements OwnChatMessagesRepository {
  late Completer<ListSessionMessagesResult> _listCompleter;
  late Completer<SendUserMessageResult> _sendCompleter;

  @override
  Future<ListSessionMessagesResult> listSessionMessages({
    required String sessionId,
    int limit = 50,
    String? cursor,
  }) {
    _listCompleter = Completer<ListSessionMessagesResult>();
    return _listCompleter.future;
  }

  @override
  Future<SendUserMessageResult> sendUserMessage({
    required String sessionId,
    required String content,
  }) {
    _sendCompleter = Completer<SendUserMessageResult>();
    return _sendCompleter.future;
  }

  void completeList(ListSessionMessagesResult result) {
    _listCompleter.complete(result);
  }

  void completeSend(SendUserMessageResult result) {
    _sendCompleter.complete(result);
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

class _FakeSecureSessionTokenProvider implements SecureSessionTokenProvider {
  const _FakeSecureSessionTokenProvider(this.result);

  final SecureSessionTokenResult result;

  @override
  Future<SecureSessionAuthState> currentAuthState() async {
    return const SecureSessionAuthState.unauthenticated();
  }

  @override
  Future<SecureSessionTokenResult> getAccessToken() async {
    return result;
  }

  @override
  Future<SecureSessionTokenResult> refreshIfNeeded() async {
    return result;
  }

  @override
  Future<void> clearSession() async {}
}

class _ThrowingSecureSessionTokenProvider
    implements SecureSessionTokenProvider {
  @override
  Future<SecureSessionAuthState> currentAuthState() async {
    return const SecureSessionAuthState.unauthenticated();
  }

  @override
  Future<SecureSessionTokenResult> getAccessToken() {
    throw StateError('fake secure session failure');
  }

  @override
  Future<SecureSessionTokenResult> refreshIfNeeded() {
    throw StateError('fake secure session failure');
  }

  @override
  Future<void> clearSession() async {}
}

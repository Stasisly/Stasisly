import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:stasisly/core/auth/session/secure_session.dart';
import 'package:stasisly/core/config/app_environment.dart';
import 'package:stasisly/features/chat_sessions/application/own_chat_sessions_state.dart';
import 'package:stasisly/features/chat_sessions/data/repositories/backend_blocked_own_chat_sessions_repository.dart';
import 'package:stasisly/features/chat_sessions/data/repositories/demo_own_chat_sessions_repository.dart';
import 'package:stasisly/features/chat_sessions/data/repositories/validating_own_chat_sessions_repository.dart';
import 'package:stasisly/features/chat_sessions/domain/entities/own_chat_session.dart';
import 'package:stasisly/features/chat_sessions/domain/entities/own_chat_session_results.dart';
import 'package:stasisly/features/chat_sessions/domain/repositories/own_chat_sessions_repository.dart';
import 'package:stasisly/features/chat_sessions/presentation/providers/own_chat_sessions_providers.dart';

void main() {
  const sessionA = '00000000-0000-4000-8000-0000000000a1';
  const sessionB = '00000000-0000-4000-8000-0000000000b2';
  const selectableA = '10000000-0000-4000-8000-0000000000a1';

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
      container.read(ownChatSessionsRepositoryProvider),
      isA<DemoOwnChatSessionsRepository>(),
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

      final repository = container.read(ownChatSessionsRepositoryProvider);

      expect(repository, isA<BackendBlockedOwnChatSessionsRepository>());
      expect(
        await repository.listOwnChatSessions(),
        isA<ListOwnChatSessionsFailure>(),
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
        container.read(ownChatSessionsRepositoryProvider),
        isA<ValidatingOwnChatSessionsRepository>(),
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
      container.read(ownChatSessionsRepositoryProvider),
      isA<BackendBlockedOwnChatSessionsRepository>(),
    );
  });

  test('explicit demo and backendBlocked providers are available', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(
      container.read(demoOwnChatSessionsRepositoryProvider),
      isA<DemoOwnChatSessionsRepository>(),
    );
    expect(
      container.read(backendBlockedOwnChatSessionsRepositoryProvider),
      isA<BackendBlockedOwnChatSessionsRepository>(),
    );
  });

  test(
    'local token provider adapts overrideable secure session token provider',
    () async {
      final container = ProviderContainer(
        overrides: [
          secureSessionTokenProvider.overrideWithValue(
            _FakeSecureSessionTokenProvider(
              SecureSessionTokenResult.success(
                'fake-chat-sessions-provider-token',
              ),
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      final tokenProvider = container.read(
        ownChatSessionsLocalSessionTokenProvider,
      );

      expect(
        await tokenProvider.readLocalSessionToken(),
        'fake-chat-sessions-provider-token',
      );
    },
  );

  test(
    'local token provider preserves backendBlocked as no local token',
    () async {
      final container = ProviderContainer(
        overrides: [
          secureSessionTokenProvider.overrideWithValue(
            const BackendBlockedSecureSessionTokenProvider(),
          ),
        ],
      );
      addTearDown(container.dispose);

      final tokenProvider = container.read(
        ownChatSessionsLocalSessionTokenProvider,
      );

      expect(await tokenProvider.readLocalSessionToken(), isNull);
    },
  );

  test('local token provider keeps demo explicit and tokenless', () async {
    final container = ProviderContainer(
      overrides: [
        secureSessionTokenProvider.overrideWithValue(
          const DemoSecureSessionTokenProvider(),
        ),
      ],
    );
    addTearDown(container.dispose);

    final tokenProvider = container.read(
      ownChatSessionsLocalSessionTokenProvider,
    );

    expect(await tokenProvider.readLocalSessionToken(), isNull);
  });

  test('local token provider errors do not become demo', () async {
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
      ownChatSessionsLocalSessionTokenProvider,
    );

    expect(await tokenProvider.readLocalSessionToken(), isNull);
    expect(
      container.read(ownChatSessionsRepositoryProvider),
      isA<BackendBlockedOwnChatSessionsRepository>(),
    );
  });

  test('controller provider exposes initial state', () {
    final container = _containerWithRepository(
      _FakeOwnChatSessionsRepository(),
    );
    addTearDown(container.dispose);

    expect(
      container.read(ownChatSessionsControllerProvider.notifier),
      isA<OwnChatSessionsControllerNotifier>(),
    );
    expect(
      container.read(ownChatSessionsStateProvider),
      const OwnChatSessionsState(),
    );
  });

  test('providers allow repository override and loadInitial', () async {
    final repository = _FakeOwnChatSessionsRepository(
      listResults: [
        ListOwnChatSessionsSuccess(
          OwnChatSessionsPage(
            items: [_session(sessionA), _session(sessionB, minute: 2)],
            nextCursor: 'cursor-1',
          ),
        ),
      ],
    );
    final container = _containerWithRepository(repository);
    addTearDown(container.dispose);

    await container
        .read(ownChatSessionsControllerProvider.notifier)
        .loadInitial();

    expect(repository.listCalls.single.limit, 20);
    expect(repository.listCalls.single.status, ChatSessionStatusFilter.active);
    expect(repository.listCalls.single.cursor, isNull);
    expect(
      container
          .read(ownChatSessionsStateProvider)
          .sessions
          .map((session) => session.sessionId),
      [sessionA, sessionB],
    );
    expect(container.read(ownChatSessionsStateProvider).nextCursor, 'cursor-1');
  });

  test(
    'loadInitial exposes loading state before repository completes',
    () async {
      final repository = _PendingOwnChatSessionsRepository();
      final container = _containerWithRepository(repository);
      addTearDown(container.dispose);

      final future = container
          .read(ownChatSessionsControllerProvider.notifier)
          .loadInitial();

      expect(
        container.read(ownChatSessionsStateProvider).isInitialLoading,
        isTrue,
      );

      repository.completeList(ListOwnChatSessionsSuccess(_page(sessionA)));
      await future;

      expect(
        container.read(ownChatSessionsStateProvider).isInitialLoading,
        isFalse,
      );
    },
  );

  test('refresh replaces list and preserves valid selection', () async {
    final repository = _FakeOwnChatSessionsRepository(
      listResults: [
        ListOwnChatSessionsSuccess(
          OwnChatSessionsPage(
            items: [_session(sessionA), _session(sessionB)],
            nextCursor: null,
          ),
        ),
        ListOwnChatSessionsSuccess(_page(sessionB)),
      ],
    );
    final container = _containerWithRepository(repository);
    addTearDown(container.dispose);

    final notifier = container.read(ownChatSessionsControllerProvider.notifier);
    await notifier.loadInitial();
    notifier.selectSession(sessionB);
    await notifier.refresh();

    expect(
      container.read(ownChatSessionsStateProvider).selectedSessionId,
      sessionB,
    );
    expect(
      container
          .read(ownChatSessionsStateProvider)
          .sessions
          .map((session) => session.sessionId),
      [sessionB],
    );
  });

  test(
    'createSession sends only selectableSpecialistId and exposes sessionId',
    () async {
      final repository = _FakeOwnChatSessionsRepository(
        createResults: [
          CreateOwnChatSessionSuccess(
            _session(sessionA, selectableId: selectableA),
          ),
        ],
      );
      final container = _containerWithRepository(repository);
      addTearDown(container.dispose);

      await container
          .read(ownChatSessionsControllerProvider.notifier)
          .createSession(selectableA);

      expect(repository.createCalls.single.selectableSpecialistId, selectableA);
      expect(
        container.read(ownChatSessionsStateProvider).selectedSessionId,
        sessionA,
      );
      expect(
        container
            .read(ownChatSessionsStateProvider)
            .lastCreatedSession
            ?.sessionId,
        sessionA,
      );
    },
  );

  test(
    'createSession exposes creating state before repository completes',
    () async {
      final repository = _PendingOwnChatSessionsRepository();
      final container = _containerWithRepository(repository);
      addTearDown(container.dispose);

      final future = container
          .read(ownChatSessionsControllerProvider.notifier)
          .createSession(selectableA);

      expect(container.read(ownChatSessionsStateProvider).isCreating, isTrue);

      repository.completeCreate(
        CreateOwnChatSessionSuccess(_session(sessionA)),
      );
      await future;

      expect(container.read(ownChatSessionsStateProvider).isCreating, isFalse);
      expect(
        container.read(ownChatSessionsStateProvider).selectedSessionId,
        sessionA,
      );
    },
  );

  test(
    'archiveSession sends only existing sessionId and clears selection',
    () async {
      final repository = _FakeOwnChatSessionsRepository(
        listResults: [
          ListOwnChatSessionsSuccess(
            OwnChatSessionsPage(
              items: [_session(sessionA), _session(sessionB)],
              nextCursor: null,
            ),
          ),
        ],
        archiveResults: const [
          ArchiveOwnChatSessionSuccess(
            ArchivedOwnChatSession(sessionId: sessionA),
          ),
        ],
      );
      final container = _containerWithRepository(repository);
      addTearDown(container.dispose);

      final notifier = container.read(
        ownChatSessionsControllerProvider.notifier,
      );
      await notifier.loadInitial();
      notifier.selectSession(sessionA);
      await notifier.archiveSession(sessionA);

      expect(repository.archiveCalls.single.sessionId, sessionA);
      expect(
        container.read(ownChatSessionsStateProvider).selectedSessionId,
        isNull,
      );
      expect(
        container.read(ownChatSessionsStateProvider).lastArchivedSessionId,
        sessionA,
      );
    },
  );

  test(
    'selectSession accepts only known sessionId and rejects agentId',
    () async {
      final container = _containerWithRepository(
        _FakeOwnChatSessionsRepository(
          listResults: [ListOwnChatSessionsSuccess(_page(sessionA))],
        ),
      );
      addTearDown(container.dispose);

      final notifier = container.read(
        ownChatSessionsControllerProvider.notifier,
      );
      await notifier.loadInitial();
      notifier.selectSession(sessionA);
      expect(
        container.read(ownChatSessionsStateProvider).selectedSessionId,
        sessionA,
      );

      notifier.selectSession('agent-stasis-core');

      expect(
        container.read(ownChatSessionsStateProvider).selectedSessionId,
        isNull,
      );
      expect(
        container.read(ownChatSessionsStateProvider).lastListError,
        OwnChatSessionsFailureType.invalidRequest,
      );
    },
  );

  test('archiveSession rejects agentId before repository call', () async {
    final repository = _FakeOwnChatSessionsRepository(
      listResults: [ListOwnChatSessionsSuccess(_page(sessionA))],
    );
    final container = _containerWithRepository(repository);
    addTearDown(container.dispose);

    final notifier = container.read(ownChatSessionsControllerProvider.notifier);
    await notifier.loadInitial();
    await notifier.archiveSession('agent-stasis-core');

    expect(repository.archiveCalls, isEmpty);
    expect(
      container.read(ownChatSessionsStateProvider).lastArchiveError,
      OwnChatSessionsFailureType.invalidRequest,
    );
  });

  test('clearSelection and clear reset provider state', () async {
    final container = _containerWithRepository(
      _FakeOwnChatSessionsRepository(
        listResults: [ListOwnChatSessionsSuccess(_page(sessionA))],
      ),
    );
    addTearDown(container.dispose);

    final notifier = container.read(ownChatSessionsControllerProvider.notifier);
    await notifier.loadInitial();
    notifier
      ..selectSession(sessionA)
      ..clearSelection();
    expect(
      container.read(ownChatSessionsStateProvider).selectedSessionId,
      isNull,
    );

    notifier.clear();
    expect(
      container.read(ownChatSessionsStateProvider),
      const OwnChatSessionsState(),
    );
  });

  test('create error preserves current list and never becomes demo', () async {
    final repository = _FakeOwnChatSessionsRepository(
      listResults: [ListOwnChatSessionsSuccess(_page(sessionA))],
      createResults: const [
        CreateOwnChatSessionFailure(OwnChatSessionsFailureType.networkError),
      ],
    );
    final container = _containerWithRepository(repository);
    addTearDown(container.dispose);

    final notifier = container.read(ownChatSessionsControllerProvider.notifier);
    await notifier.loadInitial();
    await notifier.createSession(selectableA);

    final state = container.read(ownChatSessionsStateProvider);
    expect(state.sessions.single.sessionId, sessionA);
    expect(state.lastCreateError, OwnChatSessionsFailureType.networkError);
    expect(state.isDemo, isFalse);
  });

  test('archive error preserves current list and selection', () async {
    final repository = _FakeOwnChatSessionsRepository(
      listResults: [ListOwnChatSessionsSuccess(_page(sessionA))],
      archiveResults: const [
        ArchiveOwnChatSessionFailure(
          OwnChatSessionsFailureType.sessionNotFound,
        ),
      ],
    );
    final container = _containerWithRepository(repository);
    addTearDown(container.dispose);

    final notifier = container.read(ownChatSessionsControllerProvider.notifier);
    await notifier.loadInitial();
    notifier.selectSession(sessionA);
    await notifier.archiveSession(sessionA);

    final state = container.read(ownChatSessionsStateProvider);
    expect(state.sessions.single.sessionId, sessionA);
    expect(state.selectedSessionId, sessionA);
    expect(state.lastArchiveError, OwnChatSessionsFailureType.sessionNotFound);
  });

  test('list error remains visible without demo fallback', () async {
    final container = _containerWithRepository(
      _FakeOwnChatSessionsRepository(
        listResults: const [
          ListOwnChatSessionsFailure(
            OwnChatSessionsFailureType.contractViolation,
          ),
        ],
      ),
    );
    addTearDown(container.dispose);

    await container
        .read(ownChatSessionsControllerProvider.notifier)
        .loadInitial();

    final state = container.read(ownChatSessionsStateProvider);
    expect(state.lastListError, OwnChatSessionsFailureType.contractViolation);
    expect(state.isDemo, isFalse);
  });

  test('backendBlocked is explicit and not demo', () async {
    final container = _containerWithRepository(
      const BackendBlockedOwnChatSessionsRepository(),
    );
    addTearDown(container.dispose);

    await container
        .read(ownChatSessionsControllerProvider.notifier)
        .loadInitial();

    final state = container.read(ownChatSessionsStateProvider);
    expect(state.isBackendBlocked, isTrue);
    expect(state.isDemo, isFalse);
  });

  test('demo only appears when demo repository is injected', () async {
    final container = _containerWithRepository(DemoOwnChatSessionsRepository());
    addTearDown(container.dispose);

    final notifier = container.read(ownChatSessionsControllerProvider.notifier);
    await notifier.createSession(selectableA);
    await notifier.loadInitial();

    final state = container.read(ownChatSessionsStateProvider);
    expect(state.isDemo, isTrue);
    expect(state.sessions.single.selectableSpecialist.id, selectableA);
  });
}

ProviderContainer _containerWithRepository(
  OwnChatSessionsRepository repository,
) {
  return ProviderContainer(
    overrides: [
      ownChatSessionsRepositoryProvider.overrideWithValue(repository),
    ],
  );
}

OwnChatSessionsPage _page(String sessionId, {String? nextCursor}) {
  return OwnChatSessionsPage(
    items: [_session(sessionId)],
    nextCursor: nextCursor,
  );
}

OwnChatSession _session(
  String sessionId, {
  String selectableId = '10000000-0000-4000-8000-000000000001',
  int minute = 1,
}) {
  final timestamp = DateTime.utc(2026, 6, 26, 10, minute);
  return OwnChatSession(
    sessionId: sessionId,
    selectableSpecialist: SelectableSpecialistSummary(
      id: selectableId,
      displayName: 'Especialista seguro',
      area: SelectableSpecialistSummaryArea.wellness,
    ),
    startedAt: timestamp,
    lastMessageAt: timestamp,
    status: ChatSessionStatus.active,
    messageCount: 0,
  );
}

class _FakeOwnChatSessionsRepository implements OwnChatSessionsRepository {
  _FakeOwnChatSessionsRepository({
    List<ListOwnChatSessionsResult>? listResults,
    List<CreateOwnChatSessionResult>? createResults,
    List<ArchiveOwnChatSessionResult>? archiveResults,
  }) : _listResults = [...?listResults],
       _createResults = [...?createResults],
       _archiveResults = [...?archiveResults];

  final List<ListOwnChatSessionsResult> _listResults;
  final List<CreateOwnChatSessionResult> _createResults;
  final List<ArchiveOwnChatSessionResult> _archiveResults;
  final List<_ListCall> listCalls = [];
  final List<_CreateCall> createCalls = [];
  final List<_ArchiveCall> archiveCalls = [];

  @override
  Future<CreateOwnChatSessionResult> createOwnChatSession({
    required String selectableSpecialistId,
  }) async {
    createCalls.add(_CreateCall(selectableSpecialistId));
    return _createResults.removeAt(0);
  }

  @override
  Future<ListOwnChatSessionsResult> listOwnChatSessions({
    ChatSessionStatusFilter status = ChatSessionStatusFilter.active,
    int limit = 20,
    String? cursor,
  }) async {
    listCalls.add(_ListCall(status, limit, cursor));
    return _listResults.removeAt(0);
  }

  @override
  Future<ArchiveOwnChatSessionResult> archiveOwnChatSession({
    required String sessionId,
  }) async {
    archiveCalls.add(_ArchiveCall(sessionId));
    return _archiveResults.removeAt(0);
  }
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

class _PendingOwnChatSessionsRepository implements OwnChatSessionsRepository {
  late Completer<ListOwnChatSessionsResult> _listCompleter;
  late Completer<CreateOwnChatSessionResult> _createCompleter;

  @override
  Future<CreateOwnChatSessionResult> createOwnChatSession({
    required String selectableSpecialistId,
  }) {
    _createCompleter = Completer<CreateOwnChatSessionResult>();
    return _createCompleter.future;
  }

  @override
  Future<ListOwnChatSessionsResult> listOwnChatSessions({
    ChatSessionStatusFilter status = ChatSessionStatusFilter.active,
    int limit = 20,
    String? cursor,
  }) {
    _listCompleter = Completer<ListOwnChatSessionsResult>();
    return _listCompleter.future;
  }

  @override
  Future<ArchiveOwnChatSessionResult> archiveOwnChatSession({
    required String sessionId,
  }) {
    throw UnimplementedError('archive is not used by this pending fake');
  }

  void completeList(ListOwnChatSessionsResult result) {
    _listCompleter.complete(result);
  }

  void completeCreate(CreateOwnChatSessionResult result) {
    _createCompleter.complete(result);
  }
}

class _ListCall {
  const _ListCall(this.status, this.limit, this.cursor);

  final ChatSessionStatusFilter status;
  final int limit;
  final String? cursor;
}

class _CreateCall {
  const _CreateCall(this.selectableSpecialistId);

  final String selectableSpecialistId;
}

class _ArchiveCall {
  const _ArchiveCall(this.sessionId);

  final String sessionId;
}

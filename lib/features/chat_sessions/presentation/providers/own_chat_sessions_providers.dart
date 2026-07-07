import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:stasisly/core/auth/session/secure_session.dart';
import 'package:stasisly/core/config/app_environment.dart';
import 'package:stasisly/features/chat_sessions/application/own_chat_sessions_controller.dart';
import 'package:stasisly/features/chat_sessions/application/own_chat_sessions_state.dart';
import 'package:stasisly/features/chat_sessions/data/datasources/local_http_own_chat_sessions_datasource.dart';
import 'package:stasisly/features/chat_sessions/data/local/local_only_host_policy.dart';
import 'package:stasisly/features/chat_sessions/data/local/local_session_token_provider.dart';
import 'package:stasisly/features/chat_sessions/data/local/own_chat_sessions_http_transport.dart';
import 'package:stasisly/features/chat_sessions/data/local/secure_session_chat_sessions_token_provider.dart';
import 'package:stasisly/features/chat_sessions/data/repositories/backend_blocked_own_chat_sessions_repository.dart';
import 'package:stasisly/features/chat_sessions/data/repositories/demo_own_chat_sessions_repository.dart';
import 'package:stasisly/features/chat_sessions/data/repositories/validating_own_chat_sessions_repository.dart';
import 'package:stasisly/features/chat_sessions/domain/entities/own_chat_session.dart';
import 'package:stasisly/features/chat_sessions/domain/repositories/own_chat_sessions_repository.dart';

final ownChatSessionsLocalSessionTokenProvider =
    Provider<LocalSessionTokenProvider>((ref) {
      final tokenProvider = ref.watch(secureSessionTokenProvider);
      return _chatSessionsTokenProviderFor(tokenProvider);
    });

LocalSessionTokenProvider _chatSessionsTokenProviderFor(
  SecureSessionTokenProvider tokenProvider,
) {
  return SecureSessionChatSessionsTokenProvider(
    adapter: SecureSessionToLocalSessionTokenAdapter(
      tokenProvider: tokenProvider,
    ),
  );
}

final ownChatSessionsRepositoryProvider = Provider<OwnChatSessionsRepository>((
  ref,
) {
  final environment = ref.watch(appEnvironmentProvider);
  if (environment.isDemo) {
    return DemoOwnChatSessionsRepository();
  }

  if (environment.allowsRealAuth) {
    return ref.watch(remoteOwnChatSessionsRepositoryProvider);
  }

  // ADR-006/ADR-007: backend wiring for chat_sessions remains blocked until a
  // separate package approves provider-to-datasource activation.
  return const BackendBlockedOwnChatSessionsRepository();
});

final remoteOwnChatSessionsRepositoryProvider =
    Provider<OwnChatSessionsRepository>((ref) {
      final environment = ref.watch(appEnvironmentProvider);
      final baseUri = Uri.parse(environment.supabaseUrl);
      return ValidatingOwnChatSessionsRepository(
        source: LocalHttpOwnChatSessionsDataSource(
          baseUri: baseUri,
          hostPolicy: DevelopmentRemoteHostPolicy(
            enabled: environment.allowsRealAuth,
            approvedHost: baseUri.host,
          ),
          tokenProvider: ref.watch(ownChatSessionsLocalSessionTokenProvider),
          transport: createDioOwnChatSessionsHttpTransport(),
        ),
      );
    });

final demoOwnChatSessionsRepositoryProvider =
    Provider<OwnChatSessionsRepository>((ref) {
      return DemoOwnChatSessionsRepository();
    });

final backendBlockedOwnChatSessionsRepositoryProvider =
    Provider<OwnChatSessionsRepository>((ref) {
      return const BackendBlockedOwnChatSessionsRepository();
    });

final ownChatSessionsControllerProvider =
    StateNotifierProvider<
      OwnChatSessionsControllerNotifier,
      OwnChatSessionsState
    >((ref) {
      final repository = ref.watch(ownChatSessionsRepositoryProvider);
      return OwnChatSessionsControllerNotifier(
        OwnChatSessionsController(repository: repository),
      );
    });

final ownChatSessionsStateProvider = Provider<OwnChatSessionsState>((ref) {
  return ref.watch(ownChatSessionsControllerProvider);
});

class OwnChatSessionsControllerNotifier
    extends StateNotifier<OwnChatSessionsState> {
  OwnChatSessionsControllerNotifier(this._controller)
    : super(_controller.state);

  final OwnChatSessionsController _controller;

  Future<void> loadInitial({
    ChatSessionStatusFilter status = ChatSessionStatusFilter.active,
  }) async {
    state = state.copyWith(isInitialLoading: true, lastListError: null);
    await _controller.loadInitial(status: status);
    _syncState();
  }

  Future<void> refresh({
    ChatSessionStatusFilter status = ChatSessionStatusFilter.active,
  }) async {
    state = state.copyWith(isRefreshing: true, lastListError: null);
    await _controller.refresh(status: status);
    _syncState();
  }

  Future<void> createSession(String selectableSpecialistId) async {
    state = state.copyWith(isCreating: true, lastCreateError: null);
    await _controller.createSession(selectableSpecialistId);
    _syncState();
  }

  Future<void> archiveSession(String sessionId) async {
    state = state.copyWith(isArchiving: true, lastArchiveError: null);
    await _controller.archiveSession(sessionId);
    _syncState();
  }

  void selectSession(String sessionId) {
    _controller.selectSession(sessionId);
    _syncState();
  }

  void clearSelection() {
    _controller.clearSelection();
    _syncState();
  }

  void clear() {
    _controller.clear();
    _syncState();
  }

  void _syncState() {
    state = _controller.state;
  }
}

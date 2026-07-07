import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:stasisly/core/auth/session/secure_session.dart';
import 'package:stasisly/core/config/app_environment.dart';
import 'package:stasisly/features/chat_messages/application/own_chat_messages_controller.dart';
import 'package:stasisly/features/chat_messages/application/own_chat_messages_state.dart';
import 'package:stasisly/features/chat_messages/data/datasources/local_http_own_chat_messages_datasource.dart';
import 'package:stasisly/features/chat_messages/data/local/local_only_host_policy.dart';
import 'package:stasisly/features/chat_messages/data/local/local_session_token_provider.dart';
import 'package:stasisly/features/chat_messages/data/local/own_chat_messages_http_transport.dart';
import 'package:stasisly/features/chat_messages/data/local/secure_session_chat_messages_token_provider.dart';
import 'package:stasisly/features/chat_messages/data/repositories/backend_blocked_own_chat_messages_repository.dart';
import 'package:stasisly/features/chat_messages/data/repositories/demo_own_chat_messages_repository.dart';
import 'package:stasisly/features/chat_messages/domain/repositories/own_chat_messages_repository.dart';

final ownChatMessagesLocalSessionTokenProvider =
    Provider<LocalSessionTokenProvider>((ref) {
      final tokenProvider = ref.watch(secureSessionTokenProvider);
      return SecureSessionChatMessagesTokenProvider(
        adapter: SecureSessionToLocalSessionTokenAdapter(
          tokenProvider: tokenProvider,
        ),
      );
    });

final ownChatMessagesRepositoryProvider = Provider<OwnChatMessagesRepository>((
  ref,
) {
  final environment = ref.watch(appEnvironmentProvider);
  if (environment.isDemo) {
    return DemoOwnChatMessagesRepository();
  }

  if (environment.allowsRealAuth) {
    return ref.watch(remoteOwnChatMessagesRepositoryProvider);
  }

  // ADR-006/ADR-007: backend wiring for messages remains blocked until a
  // separate package approves provider-to-datasource activation.
  return const BackendBlockedOwnChatMessagesRepository();
});

final remoteOwnChatMessagesRepositoryProvider =
    Provider<OwnChatMessagesRepository>((ref) {
      final environment = ref.watch(appEnvironmentProvider);
      final baseUri = Uri.parse(environment.supabaseUrl);
      return LocalHttpOwnChatMessagesDataSource(
        baseUri: baseUri,
        hostPolicy: DevelopmentRemoteHostPolicy(
          enabled: environment.allowsRealAuth,
          approvedHost: baseUri.host,
        ),
        tokenProvider: ref.watch(ownChatMessagesLocalSessionTokenProvider),
        transport: createDioOwnChatMessagesHttpTransport(),
      );
    });

final demoOwnChatMessagesRepositoryProvider =
    Provider<OwnChatMessagesRepository>((ref) {
      return DemoOwnChatMessagesRepository();
    });

final backendBlockedOwnChatMessagesRepositoryProvider =
    Provider<OwnChatMessagesRepository>((ref) {
      return const BackendBlockedOwnChatMessagesRepository();
    });

final ownChatMessagesControllerProvider =
    StateNotifierProvider<
      OwnChatMessagesControllerNotifier,
      OwnChatMessagesState
    >((ref) {
      final repository = ref.watch(ownChatMessagesRepositoryProvider);
      return OwnChatMessagesControllerNotifier(
        OwnChatMessagesController(repository: repository),
      );
    });

final ownChatMessagesStateProvider = Provider<OwnChatMessagesState>((ref) {
  return ref.watch(ownChatMessagesControllerProvider);
});

class OwnChatMessagesControllerNotifier
    extends StateNotifier<OwnChatMessagesState> {
  OwnChatMessagesControllerNotifier(this._controller)
    : super(_controller.state);

  final OwnChatMessagesController _controller;

  Future<void> loadInitial(String sessionId) async {
    state = OwnChatMessagesState(sessionId: sessionId, isInitialLoading: true);
    await _controller.loadInitial(sessionId);
    _syncState();
  }

  Future<void> loadNextPage() async {
    if (state.sessionId != null &&
        state.nextCursor != null &&
        !state.isPaginating) {
      state = state.copyWith(isPaginating: true, lastListError: null);
    }
    await _controller.loadNextPage();
    _syncState();
  }

  Future<void> sendMessage(String content) async {
    if (state.sessionId != null) {
      state = state.copyWith(isSending: true, lastSendError: null);
    }
    await _controller.sendMessage(content);
    _syncState();
  }

  Future<void> refresh() async {
    await _controller.refresh();
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stasisly/core/idempotency/operation_attempt_id.dart';
import 'package:stasisly/features/chat_messages/application/own_chat_messages_controller.dart';
import 'package:stasisly/features/chat_messages/application/own_chat_messages_state.dart';
import 'package:stasisly/features/chat_messages/domain/entities/own_chat_message.dart';
import 'package:stasisly/features/chat_messages/domain/entities/own_chat_message_results.dart';
import 'package:stasisly/features/chat_messages/domain/repositories/own_chat_messages_repository.dart';
import 'package:stasisly/features/chat_messages/presentation/providers/own_chat_messages_providers.dart';
import 'package:stasisly/features/chat_messages/presentation/widgets/own_chat_messages_panel.dart';

enum OwnChatMessagesPanelDevScenario {
  messages,
  empty,
  loading,
  demo,
  backendBlocked,
  listError,
  sendError,
  sessionArchived,
  sessionNotFound,
  networkError,
  contractViolation,
  pagination,
  noPagination,
  sending,
  paginating,
}

class OwnChatMessagesPanelDevHost extends StatelessWidget {
  const OwnChatMessagesPanelDevHost({
    super.key,
    this.scenario = OwnChatMessagesPanelDevScenario.messages,
  });

  final OwnChatMessagesPanelDevScenario scenario;

  @override
  Widget build(BuildContext context) {
    final config = _DevHostConfig.forScenario(scenario);
    return ProviderScope(
      overrides: [
        ownChatMessagesControllerProvider.overrideWith((ref) {
          return _DevHostNotifier(config);
        }),
      ],
      child: const SizedBox(
        width: 420,
        height: 560,
        child: OwnChatMessagesPanel(autoLoad: false),
      ),
    );
  }
}

class _DevHostConfig {
  const _DevHostConfig({required this.state, this.sendFailure});

  factory _DevHostConfig.forScenario(OwnChatMessagesPanelDevScenario scenario) {
    return switch (scenario) {
      OwnChatMessagesPanelDevScenario.messages => _DevHostConfig(
        state: OwnChatMessagesState(
          sessionId: _sessionId,
          messages: _messages(),
        ),
      ),
      OwnChatMessagesPanelDevScenario.empty => const _DevHostConfig(
        state: OwnChatMessagesState(sessionId: _sessionId),
      ),
      OwnChatMessagesPanelDevScenario.loading => const _DevHostConfig(
        state: OwnChatMessagesState(
          sessionId: _sessionId,
          isInitialLoading: true,
        ),
      ),
      OwnChatMessagesPanelDevScenario.demo => _DevHostConfig(
        state: OwnChatMessagesState(
          sessionId: _sessionId,
          messages: _messages(isDemo: true),
          isDemo: true,
        ),
      ),
      OwnChatMessagesPanelDevScenario.backendBlocked => const _DevHostConfig(
        state: OwnChatMessagesState(
          sessionId: _sessionId,
          isBackendBlocked: true,
          lastListError: ListOwnChatMessagesFailureType.backendBlocked,
        ),
      ),
      OwnChatMessagesPanelDevScenario.listError => const _DevHostConfig(
        state: OwnChatMessagesState(
          sessionId: _sessionId,
          lastListError: ListOwnChatMessagesFailureType.contractViolation,
        ),
      ),
      OwnChatMessagesPanelDevScenario.sendError => _DevHostConfig(
        state: OwnChatMessagesState(
          sessionId: _sessionId,
          messages: _messages(),
          lastSendError: SendOwnChatMessageFailureType.networkError,
        ),
      ),
      OwnChatMessagesPanelDevScenario.sessionArchived => _DevHostConfig(
        state: OwnChatMessagesState(
          sessionId: _sessionId,
          messages: _messages(),
        ),
        sendFailure: SendOwnChatMessageFailureType.sessionArchived,
      ),
      OwnChatMessagesPanelDevScenario.sessionNotFound => _DevHostConfig(
        state: OwnChatMessagesState(
          sessionId: _sessionId,
          messages: _messages(),
        ),
        sendFailure: SendOwnChatMessageFailureType.sessionNotFound,
      ),
      OwnChatMessagesPanelDevScenario.networkError => _DevHostConfig(
        state: OwnChatMessagesState(
          sessionId: _sessionId,
          messages: _messages(),
        ),
        sendFailure: SendOwnChatMessageFailureType.networkError,
      ),
      OwnChatMessagesPanelDevScenario.contractViolation => _DevHostConfig(
        state: OwnChatMessagesState(
          sessionId: _sessionId,
          messages: _messages(),
        ),
        sendFailure: SendOwnChatMessageFailureType.contractViolation,
      ),
      OwnChatMessagesPanelDevScenario.pagination => _DevHostConfig(
        state: OwnChatMessagesState(
          sessionId: _sessionId,
          messages: _messages(),
          nextCursor: 'fake-next-page',
        ),
      ),
      OwnChatMessagesPanelDevScenario.noPagination => _DevHostConfig(
        state: OwnChatMessagesState(
          sessionId: _sessionId,
          messages: _messages(),
        ),
      ),
      OwnChatMessagesPanelDevScenario.sending => _DevHostConfig(
        state: OwnChatMessagesState(
          sessionId: _sessionId,
          messages: _messages(),
          isSending: true,
        ),
      ),
      OwnChatMessagesPanelDevScenario.paginating => _DevHostConfig(
        state: OwnChatMessagesState(
          sessionId: _sessionId,
          messages: _messages(),
          nextCursor: 'fake-next-page',
          isPaginating: true,
        ),
      ),
    };
  }

  final OwnChatMessagesState state;
  final SendOwnChatMessageFailureType? sendFailure;
}

class _DevHostNotifier extends OwnChatMessagesControllerNotifier {
  _DevHostNotifier(this.config)
    : super(OwnChatMessagesController(repository: _NeverRepository())) {
    state = config.state;
  }

  final _DevHostConfig config;

  @override
  Future<void> sendMessage(String content) async {
    final failure = config.sendFailure;
    if (failure != null) {
      state = state.copyWith(lastSendError: failure, isSending: false);
      return;
    }
    final message = _message(
      id: 'fake-sent-user-message',
      role: OwnChatMessageRole.user,
      content: content.trim(),
      minute: 5,
    );
    state = state.copyWith(
      messages: [...state.messages, message],
      lastSendError: null,
      isSending: false,
    );
  }

  @override
  Future<void> loadNextPage() async {
    state = state.copyWith(
      messages: [
        ...state.messages,
        _message(
          id: 'fake-next-page-message',
          role: OwnChatMessageRole.assistant,
          content: 'Respuesta ficticia de pagina siguiente.',
          minute: 6,
        ),
      ],
      nextCursor: null,
      isPaginating: false,
    );
  }
}

class _NeverRepository implements OwnChatMessagesRepository {
  @override
  Future<ListSessionMessagesResult> listSessionMessages({
    required String sessionId,
    int limit = 50,
    String? cursor,
  }) {
    throw StateError('Unexpected dev host list call.');
  }

  @override
  Future<SendUserMessageResult> sendUserMessage({
    required String sessionId,
    required String content,
    required OperationAttemptId operationAttemptId,
  }) {
    throw StateError('Unexpected dev host send call.');
  }
}

List<OwnChatMessage> _messages({bool isDemo = false}) {
  return [
    _message(
      id: 'fake-user-message',
      role: OwnChatMessageRole.user,
      content: 'Mensaje ficticio de usuario.',
      minute: 1,
      isDemo: isDemo,
    ),
    _message(
      id: 'fake-assistant-message',
      role: OwnChatMessageRole.assistant,
      content: 'Respuesta ficticia de asistente.',
      minute: 2,
      isDemo: isDemo,
    ),
    _message(
      id: 'fake-system-message',
      role: OwnChatMessageRole.system,
      content: 'Aviso ficticio de sistema.',
      minute: 3,
      isDemo: isDemo,
    ),
    _message(
      id: 'fake-tool-message',
      role: OwnChatMessageRole.tool,
      content: 'Resultado ficticio de herramienta.',
      minute: 4,
      isDemo: isDemo,
    ),
  ];
}

OwnChatMessage _message({
  required String id,
  required OwnChatMessageRole role,
  required String content,
  required int minute,
  bool isDemo = false,
}) {
  return OwnChatMessage(
    messageId: id,
    sessionId: _sessionId,
    role: role,
    content: content,
    createdAt: DateTime.utc(2026, 6, 21, 16, minute),
    isDemo: isDemo,
  );
}

const _sessionId = 'fake-dev-session';

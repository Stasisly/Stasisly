import 'package:stasisly/core/identity/domain/stasisly_identity.dart';
import 'package:stasisly/features/chat_messages/domain/entities/own_chat_message.dart';
import 'package:stasisly/features/chat_messages/domain/entities/own_chat_message_results.dart';
import 'package:stasisly/features/chat_messages/domain/repositories/own_chat_messages_repository.dart';
import 'package:stasisly/features/chat_sessions/domain/entities/own_chat_session.dart';
import 'package:stasisly/features/chat_sessions/domain/entities/own_chat_session_results.dart';
import 'package:stasisly/features/chat_sessions/domain/repositories/own_chat_sessions_repository.dart';
import 'package:stasisly/features/conversations/application/inputs/conversation_inputs.dart';
import 'package:stasisly/features/conversations/data/adapters/own_chat_message_conversation_adapter.dart';
import 'package:stasisly/features/conversations/data/adapters/own_chat_session_conversation_adapter.dart';
import 'package:stasisly/features/conversations/domain/entities/conversation.dart';
import 'package:stasisly/features/conversations/domain/repositories/conversation_repository.dart';
import 'package:stasisly/features/conversations/domain/results/conversation_results.dart';
import 'package:stasisly/features/conversations/domain/value_objects/conversation_id.dart';

class TransitionalConversationRepositoryAdapter
    implements ConversationRepository {
  const TransitionalConversationRepositoryAdapter({
    required this.chatSessions,
    required this.chatMessages,
    required this.trustedOwner,
    this.sessionAdapter = const OwnChatSessionConversationAdapter(),
    this.messageAdapter = const OwnChatMessageConversationAdapter(),
  });

  final OwnChatSessionsRepository chatSessions;
  final OwnChatMessagesRepository chatMessages;
  final StasislyIdentity trustedOwner;
  final OwnChatSessionConversationAdapter sessionAdapter;
  final OwnChatMessageConversationAdapter messageAdapter;

  @override
  Future<ConversationListResult> listOwnConversations({
    ConversationStatusFilter status = ConversationStatusFilter.active,
    int limit = 20,
    String? cursor,
  }) async {
    if (!_hasTrustedOwner) {
      return const ConversationListFailure(
        ConversationResultStatus.unauthenticated,
      );
    }
    if (limit < 1 || limit > 50 || (cursor != null && cursor.trim().isEmpty)) {
      return const ConversationListFailure(
        ConversationResultStatus.invalidInput,
      );
    }
    try {
      final result = await chatSessions.listOwnChatSessions(
        status: _sessionFilter(status),
        limit: limit,
        cursor: cursor,
      );
      return switch (result) {
        ListOwnChatSessionsSuccess(:final page) ||
        ListOwnChatSessionsDemo(:final page) => _mapConversationPage(page),
        ListOwnChatSessionsFailure(:final type) => ConversationListFailure(
          _sessionFailure(type),
        ),
      };
    } on ConversationOwnershipException {
      return const ConversationListFailure(
        ConversationResultStatus.unauthenticated,
      );
    } on ConversationContractException {
      return const ConversationListFailure(
        ConversationResultStatus.contractViolation,
      );
    } on Exception {
      return const ConversationListFailure(
        ConversationResultStatus.unknownFailure,
      );
    }
  }

  @override
  Future<ConversationMutationResult> createOwnConversation(
    CreateConversationInput input,
  ) async {
    if (!_hasTrustedOwner) {
      return const ConversationMutationFailure(
        ConversationResultStatus.unauthenticated,
      );
    }
    final specialistId = input.selectableSpecialistId;
    if (specialistId == null) {
      return const ConversationMutationFailure(
        ConversationResultStatus.invalidInput,
      );
    }
    try {
      final result = await chatSessions.createOwnChatSession(
        selectableSpecialistId: specialistId,
      );
      return switch (result) {
        CreateOwnChatSessionSuccess(:final session) ||
        CreateOwnChatSessionDemo(:final session) => ConversationMutationSuccess(
          conversation: sessionAdapter.map(
            source: session,
            trustedOwner: trustedOwner,
          ),
        ),
        CreateOwnChatSessionFailure(:final type) => ConversationMutationFailure(
          _sessionFailure(type),
        ),
      };
    } on ConversationOwnershipException {
      return const ConversationMutationFailure(
        ConversationResultStatus.unauthenticated,
      );
    } on ConversationContractException {
      return const ConversationMutationFailure(
        ConversationResultStatus.contractViolation,
      );
    } on Exception {
      return const ConversationMutationFailure(
        ConversationResultStatus.unknownFailure,
      );
    }
  }

  @override
  Future<ConversationMutationResult> archiveOwnConversation(
    ArchiveConversationInput input,
  ) async {
    if (!_hasTrustedOwner) {
      return const ConversationMutationFailure(
        ConversationResultStatus.unauthenticated,
      );
    }
    try {
      final result = await chatSessions.archiveOwnChatSession(
        sessionId: input.conversationId.value,
      );
      return switch (result) {
        ArchiveOwnChatSessionSuccess(:final session) ||
        ArchiveOwnChatSessionDemo(
          :final session,
        ) => ConversationMutationSuccess(
          receipt: _archiveReceipt(session.sessionId),
        ),
        ArchiveOwnChatSessionFailure(:final type) =>
          ConversationMutationFailure(_sessionFailure(type)),
      };
    } on ConversationContractException {
      return const ConversationMutationFailure(
        ConversationResultStatus.contractViolation,
      );
    } on Exception {
      return const ConversationMutationFailure(
        ConversationResultStatus.unknownFailure,
      );
    }
  }

  @override
  Future<ConversationMessageListResult> listOwnConversationMessages(
    ListConversationMessagesInput input,
  ) async {
    if (!_hasTrustedOwner) {
      return const ConversationMessageListFailure(
        ConversationResultStatus.unauthenticated,
      );
    }
    try {
      final result = await chatMessages.listSessionMessages(
        sessionId: input.conversationId.value,
        limit: input.limit,
        cursor: input.cursor,
      );
      return switch (result) {
        ListSessionMessagesSuccess(:final page) ||
        ListSessionMessagesDemo(:final page) => ConversationMessageListSuccess(
          ConversationMessagePage(
            items: List.unmodifiable(page.items.map(messageAdapter.map)),
            nextCursor: page.nextCursor,
          ),
        ),
        ListSessionMessagesEmpty() => const ConversationMessageListSuccess(
          ConversationMessagePage(items: [], nextCursor: null),
        ),
        ListSessionMessagesFailure(:final type) =>
          ConversationMessageListFailure(_listMessageFailure(type)),
      };
    } on ConversationContractException {
      return const ConversationMessageListFailure(
        ConversationResultStatus.contractViolation,
      );
    } on Exception {
      return const ConversationMessageListFailure(
        ConversationResultStatus.unknownFailure,
      );
    }
  }

  @override
  Future<ConversationMessageSendResult> sendOwnConversationMessage(
    SendConversationMessageInput input,
  ) async {
    if (!_hasTrustedOwner) {
      return const ConversationMessageSendFailure(
        ConversationResultStatus.unauthenticated,
      );
    }
    try {
      final result = await chatMessages.sendUserMessage(
        sessionId: input.conversationId.value,
        content: input.content,
      );
      return switch (result) {
        SendUserMessageSuccess(:final sent) ||
        SendUserMessageDemo(:final sent) => _mapSentMessage(
          expectedConversationId: input.conversationId,
          sent: sent,
        ),
        SendUserMessageFailure(:final type) => ConversationMessageSendFailure(
          _sendMessageFailure(type),
        ),
      };
    } on ConversationContractException {
      return const ConversationMessageSendFailure(
        ConversationResultStatus.contractViolation,
      );
    } on Exception {
      return const ConversationMessageSendFailure(
        ConversationResultStatus.unknownFailure,
      );
    }
  }

  bool get _hasTrustedOwner {
    return trustedOwner.isAuthenticated &&
        trustedOwner.subjectId.trim().isNotEmpty;
  }

  ConversationListResult _mapConversationPage(OwnChatSessionsPage source) {
    final mapped = source.items
        .map(
          (session) =>
              sessionAdapter.map(source: session, trustedOwner: trustedOwner),
        )
        .toList(growable: false);
    return ConversationListSuccess(
      ConversationPage(
        items: List.unmodifiable(mapped),
        nextCursor: source.nextCursor,
      ),
    );
  }

  ConversationMessageSendResult _mapSentMessage({
    required ConversationId expectedConversationId,
    required SentOwnChatMessage sent,
  }) {
    final message = messageAdapter.map(sent.message);
    if (sent.sessionId != expectedConversationId.value ||
        message.conversationId != expectedConversationId) {
      return const ConversationMessageSendFailure(
        ConversationResultStatus.contractViolation,
      );
    }
    return ConversationMessageSendSuccess(
      ConversationMessageSendReceipt(
        message: message,
        messageCount: sent.messageCount,
        lastMessageAt: sent.lastMessageAt.toUtc(),
      ),
    );
  }

  ConversationMutationReceipt _archiveReceipt(String sessionId) {
    final conversationId = ConversationId.tryParse(sessionId);
    if (conversationId == null) {
      throw const ConversationContractException(
        'Invalid transitional archive contract.',
      );
    }
    return ConversationMutationReceipt(
      conversationId: conversationId,
      status: ConversationStatus.archived,
    );
  }
}

ChatSessionStatusFilter _sessionFilter(ConversationStatusFilter filter) {
  return switch (filter) {
    ConversationStatusFilter.active => ChatSessionStatusFilter.active,
    ConversationStatusFilter.archived => ChatSessionStatusFilter.archived,
    ConversationStatusFilter.all => ChatSessionStatusFilter.all,
  };
}

ConversationResultStatus _sessionFailure(OwnChatSessionsFailureType type) {
  return switch (type) {
    OwnChatSessionsFailureType.unauthenticated ||
    OwnChatSessionsFailureType.invalidSession =>
      ConversationResultStatus.unauthenticated,
    OwnChatSessionsFailureType.permissionDenied =>
      ConversationResultStatus.unauthorized,
    OwnChatSessionsFailureType.sessionNotFound =>
      ConversationResultStatus.notFound,
    OwnChatSessionsFailureType.invalidRequest ||
    OwnChatSessionsFailureType.invalidSelectableSpecialist ||
    OwnChatSessionsFailureType.specialistUnavailable ||
    OwnChatSessionsFailureType.proLocked =>
      ConversationResultStatus.invalidInput,
    OwnChatSessionsFailureType.contractViolation =>
      ConversationResultStatus.contractViolation,
    OwnChatSessionsFailureType.backendBlocked =>
      ConversationResultStatus.environmentBlocked,
    OwnChatSessionsFailureType.networkError =>
      ConversationResultStatus.backendUnavailable,
    OwnChatSessionsFailureType.unexpectedError =>
      ConversationResultStatus.unknownFailure,
  };
}

ConversationResultStatus _listMessageFailure(
  ListOwnChatMessagesFailureType type,
) {
  return switch (type) {
    ListOwnChatMessagesFailureType.unauthenticated ||
    ListOwnChatMessagesFailureType.invalidSession =>
      ConversationResultStatus.unauthenticated,
    ListOwnChatMessagesFailureType.permissionDenied =>
      ConversationResultStatus.unauthorized,
    ListOwnChatMessagesFailureType.sessionNotFound =>
      ConversationResultStatus.notFound,
    ListOwnChatMessagesFailureType.invalidRequest ||
    ListOwnChatMessagesFailureType.invalidCursor =>
      ConversationResultStatus.invalidInput,
    ListOwnChatMessagesFailureType.backendBlocked =>
      ConversationResultStatus.environmentBlocked,
    ListOwnChatMessagesFailureType.networkError ||
    ListOwnChatMessagesFailureType.backendMisconfigured =>
      ConversationResultStatus.backendUnavailable,
    ListOwnChatMessagesFailureType.contractViolation =>
      ConversationResultStatus.contractViolation,
    ListOwnChatMessagesFailureType.unexpectedError =>
      ConversationResultStatus.unknownFailure,
  };
}

ConversationResultStatus _sendMessageFailure(
  SendOwnChatMessageFailureType type,
) {
  return switch (type) {
    SendOwnChatMessageFailureType.unauthenticated ||
    SendOwnChatMessageFailureType.invalidSession =>
      ConversationResultStatus.unauthenticated,
    SendOwnChatMessageFailureType.permissionDenied =>
      ConversationResultStatus.unauthorized,
    SendOwnChatMessageFailureType.sessionNotFound =>
      ConversationResultStatus.notFound,
    SendOwnChatMessageFailureType.sessionArchived =>
      ConversationResultStatus.archived,
    SendOwnChatMessageFailureType.invalidRequest ||
    SendOwnChatMessageFailureType.contentInvalid ||
    SendOwnChatMessageFailureType.contentTooLong =>
      ConversationResultStatus.invalidInput,
    SendOwnChatMessageFailureType.backendBlocked =>
      ConversationResultStatus.environmentBlocked,
    SendOwnChatMessageFailureType.networkError ||
    SendOwnChatMessageFailureType.backendMisconfigured =>
      ConversationResultStatus.backendUnavailable,
    SendOwnChatMessageFailureType.writeUnconfirmed ||
    SendOwnChatMessageFailureType.contractViolation =>
      ConversationResultStatus.contractViolation,
    SendOwnChatMessageFailureType.unexpectedError =>
      ConversationResultStatus.unknownFailure,
  };
}

import 'package:flutter_test/flutter_test.dart';
import 'package:stasisly/core/idempotency/operation_attempt_id.dart';
import 'package:stasisly/core/identity/domain/authentication_state.dart';
import 'package:stasisly/core/identity/domain/identity_type.dart';
import 'package:stasisly/core/identity/domain/stasisly_identity.dart';
import 'package:stasisly/features/chat_messages/domain/entities/own_chat_message.dart';
import 'package:stasisly/features/chat_messages/domain/entities/own_chat_message_results.dart';
import 'package:stasisly/features/chat_messages/domain/repositories/own_chat_messages_repository.dart';
import 'package:stasisly/features/chat_sessions/domain/entities/own_chat_session.dart';
import 'package:stasisly/features/chat_sessions/domain/entities/own_chat_session_results.dart';
import 'package:stasisly/features/chat_sessions/domain/repositories/own_chat_sessions_repository.dart';
import 'package:stasisly/features/conversations/application/inputs/conversation_inputs.dart';
import 'package:stasisly/features/conversations/data/adapters/transitional_conversation_repository_adapter.dart';
import 'package:stasisly/features/conversations/domain/entities/conversation.dart';
import 'package:stasisly/features/conversations/domain/entities/conversation_message.dart';
import 'package:stasisly/features/conversations/domain/results/conversation_results.dart';
import 'package:stasisly/features/conversations/domain/value_objects/conversation_id.dart';

final _attempt = OperationAttemptId('test_attempt_00000001');

void main() {
  late _FakeSessionsRepository sessions;
  late _FakeMessagesRepository messages;
  late TransitionalConversationRepositoryAdapter repository;

  setUp(() {
    sessions = _FakeSessionsRepository();
    messages = _FakeMessagesRepository();
    repository = TransitionalConversationRepositoryAdapter(
      chatSessions: sessions,
      chatMessages: messages,
      trustedOwner: _authenticatedOwner,
      lifecycle: sessions,
    );
  });

  test('list adapts conversations and preserves pagination', () async {
    sessions.listResult = ListOwnChatSessionsSuccess(
      OwnChatSessionsPage(items: [_session], nextCursor: 'next-session'),
    );

    final result = await repository.listOwnConversations(
      status: ConversationStatusFilter.all,
      limit: 12,
      cursor: 'cursor-1',
    );

    final success = result as ConversationListSuccess;
    expect(success.page.items.single.conversationId.value, 'session-1');
    expect(success.page.nextCursor, 'next-session');
    expect(sessions.lastStatus, ChatSessionStatusFilter.all);
    expect(sessions.lastLimit, 12);
    expect(sessions.lastCursor, 'cursor-1');
  });

  test('create uses only selectableSpecialistId and maps owner', () async {
    sessions.createResult = CreateOwnChatSessionSuccess(_session);

    final result = await repository.createOwnConversation(
      CreateConversationInput(
        selectableSpecialistId: 'catalog-public',
        operationAttemptId: _attempt,
      ),
    );

    final success = result as ConversationMutationSuccess;
    expect(sessions.lastSelectableSpecialistId, 'catalog-public');
    expect(sessions.lastOperationAttemptId, same(_attempt));
    expect(success.conversation?.ownerSubjectId, 'owner-subject');
    expect(success.conversation?.conversationId.value, 'session-1');
  });

  test('create without specialist fails until backend supports it', () async {
    final result = await repository.createOwnConversation(
      CreateConversationInput(operationAttemptId: _attempt),
    );

    expect(
      result,
      const ConversationMutationFailure(ConversationResultStatus.invalidInput),
    );
    expect(sessions.createCalls, 0);
  });

  test('archive adapts conversation ID and minimal receipt', () async {
    sessions.archiveResult = const ArchiveOwnChatSessionSuccess(
      ArchivedOwnChatSession(sessionId: 'session-1'),
    );

    final result = await repository.archiveOwnConversation(
      ArchiveConversationInput(conversationId: ConversationId('session-1')),
    );

    final success = result as ConversationMutationSuccess;
    expect(sessions.lastArchivedSessionId, 'session-1');
    expect(success.receipt?.conversationId.value, 'session-1');
    expect(success.receipt?.status, ConversationStatus.archived);
  });

  test(
    'read maps canonical lifecycle without exposing owner transport',
    () async {
      sessions.readResult = ReadOwnChatSessionSuccess(
        OwnChatSessionLifecycleSnapshot(
          sessionId: 'session-1',
          status: ChatSessionStatus.archived,
          createdAt: DateTime.utc(2026),
          updatedAt: DateTime.utc(2026, 1, 2),
          archivedAt: DateTime.utc(2026, 1, 3),
          selectableSpecialist: _session.selectableSpecialist,
        ),
      );
      final result = await repository.readOwnConversation(
        ConversationId('session-1'),
      );
      final conversation = (result as ConversationReadSuccess).conversation;
      expect(conversation.status, ConversationStatus.archived);
      expect(conversation.archivedAt, DateTime.utc(2026, 1, 3));
      expect(conversation.ownerSubjectId, 'owner-subject');
    },
  );

  test('restore returns active receipt using only ConversationId', () async {
    sessions.restoreResult = const RestoreOwnChatSessionSuccess('session-1');
    final result = await repository.restoreOwnConversation(
      RestoreConversationInput(conversationId: ConversationId('session-1')),
    );
    final receipt = (result as ConversationMutationSuccess).receipt!;
    expect(receipt.status, ConversationStatus.active);
    expect(sessions.lastRestoredSessionId, 'session-1');
  });

  test('message list adapts items and preserves cursor', () async {
    messages.listResult = ListSessionMessagesSuccess(
      OwnChatMessagesPage(items: [_message], nextCursor: 'next-message'),
    );

    final result = await repository.listOwnConversationMessages(
      ListConversationMessagesInput(
        conversationId: ConversationId('session-1'),
        limit: 30,
        cursor: 'cursor-message',
      ),
    );

    final success = result as ConversationMessageListSuccess;
    expect(success.page.items.single.author, isA<UserAuthor>());
    expect(success.page.nextCursor, 'next-message');
    expect(messages.lastSessionId, 'session-1');
    expect(messages.lastLimit, 30);
    expect(messages.lastCursor, 'cursor-message');
  });

  test(
    'send preserves content-only input and server-managed response',
    () async {
      messages.sendResult = SendUserMessageSuccess(
        SentOwnChatMessage(
          message: _message,
          sessionId: 'session-1',
          messageCount: 4,
          lastMessageAt: DateTime.utc(2026, 1, 2),
          isDemo: false,
        ),
      );

      final result = await repository.sendOwnConversationMessage(
        SendConversationMessageInput(
          conversationId: ConversationId('session-1'),
          content: ' Hola ',
          operationAttemptId: _attempt,
        ),
      );

      final success = result as ConversationMessageSendSuccess;
      expect(messages.lastSessionId, 'session-1');
      expect(messages.lastContent, 'Hola');
      expect(messages.lastOperationAttemptId, same(_attempt));
      expect(success.receipt.messageCount, 4);
      expect(success.receipt.message.author, isA<UserAuthor>());
    },
  );

  test('mismatched send response fails contract closed', () async {
    messages.sendResult = SendUserMessageSuccess(
      SentOwnChatMessage(
        message: _message,
        sessionId: 'another-session',
        messageCount: 1,
        lastMessageAt: DateTime.utc(2026),
        isDemo: false,
      ),
    );

    final result = await repository.sendOwnConversationMessage(
      SendConversationMessageInput(
        conversationId: ConversationId('session-1'),
        content: 'Hola',
        operationAttemptId: _attempt,
      ),
    );

    expect(
      result,
      const ConversationMessageSendFailure(
        ConversationResultStatus.contractViolation,
      ),
    );
  });

  test(
    'blocked, unavailable and auth failures remain provider-neutral',
    () async {
      sessions.listResult = const ListOwnChatSessionsFailure(
        OwnChatSessionsFailureType.backendBlocked,
      );
      messages
        ..listResult = const ListSessionMessagesFailure(
          ListOwnChatMessagesFailureType.networkError,
        )
        ..sendResult = const SendUserMessageFailure(
          SendOwnChatMessageFailureType.unauthenticated,
        );

      expect(
        await repository.listOwnConversations(),
        const ConversationListFailure(
          ConversationResultStatus.environmentBlocked,
        ),
      );
      expect(
        await repository.listOwnConversationMessages(
          ListConversationMessagesInput(
            conversationId: ConversationId('session-1'),
          ),
        ),
        const ConversationMessageListFailure(
          ConversationResultStatus.backendUnavailable,
        ),
      );
      expect(
        await repository.sendOwnConversationMessage(
          SendConversationMessageInput(
            conversationId: ConversationId('session-1'),
            content: 'Hola',
            operationAttemptId: _attempt,
          ),
        ),
        const ConversationMessageSendFailure(
          ConversationResultStatus.unauthenticated,
        ),
      );
    },
  );

  test('contract violation propagates without demo fallback', () async {
    sessions.createResult = const CreateOwnChatSessionFailure(
      OwnChatSessionsFailureType.contractViolation,
    );

    final result = await repository.createOwnConversation(
      CreateConversationInput(
        selectableSpecialistId: 'catalog-public',
        operationAttemptId: _attempt,
      ),
    );

    expect(
      result,
      const ConversationMutationFailure(
        ConversationResultStatus.contractViolation,
      ),
    );
  });

  test('untrusted owner blocks before transitional repositories', () async {
    repository = TransitionalConversationRepositoryAdapter(
      chatSessions: sessions,
      chatMessages: messages,
      trustedOwner: const StasislyIdentity(
        subjectId: 'owner-subject',
        identityType: IdentityType.humanUser,
        authenticationState: AuthenticationState.unauthenticated,
      ),
      lifecycle: sessions,
    );

    expect(
      await repository.listOwnConversations(),
      const ConversationListFailure(ConversationResultStatus.unauthenticated),
    );
    expect(sessions.listCalls, 0);
  });
}

const _authenticatedOwner = StasislyIdentity(
  subjectId: 'owner-subject',
  identityType: IdentityType.humanUser,
  authenticationState: AuthenticationState.authenticated,
);

final _session = OwnChatSession(
  sessionId: 'session-1',
  selectableSpecialist: const SelectableSpecialistSummary(
    id: 'catalog-public',
    displayName: 'Specialist',
    area: SelectableSpecialistSummaryArea.stasis,
  ),
  startedAt: DateTime.utc(2026),
  lastMessageAt: DateTime.utc(2026, 1, 2),
  status: ChatSessionStatus.active,
  messageCount: 1,
);

final _message = OwnChatMessage(
  messageId: 'message-1',
  sessionId: 'session-1',
  role: OwnChatMessageRole.user,
  content: 'Hola',
  createdAt: DateTime.utc(2026),
  isDemo: false,
  authorType: OwnChatMessageAuthorType.user,
  provenance: OwnChatMessageProvenance.userProvided,
  visibility: OwnChatMessageVisibility.productVisible,
  status: OwnChatMessageStatus.accepted,
);

class _FakeSessionsRepository
    implements OwnChatSessionsRepository, OwnChatSessionLifecycleRepository {
  CreateOwnChatSessionResult createResult = const CreateOwnChatSessionFailure(
    OwnChatSessionsFailureType.unexpectedError,
  );
  ListOwnChatSessionsResult listResult = const ListOwnChatSessionsSuccess(
    OwnChatSessionsPage(items: [], nextCursor: null),
  );
  ArchiveOwnChatSessionResult archiveResult =
      const ArchiveOwnChatSessionFailure(
        OwnChatSessionsFailureType.unexpectedError,
      );
  ReadOwnChatSessionResult readResult = const ReadOwnChatSessionFailure(
    OwnChatSessionsFailureType.unexpectedError,
  );
  RestoreOwnChatSessionResult restoreResult =
      const RestoreOwnChatSessionFailure(
        OwnChatSessionsFailureType.unexpectedError,
      );

  int createCalls = 0;
  int listCalls = 0;
  String? lastSelectableSpecialistId;
  OperationAttemptId? lastOperationAttemptId;
  ChatSessionStatusFilter? lastStatus;
  int? lastLimit;
  String? lastCursor;
  String? lastArchivedSessionId;
  String? lastRestoredSessionId;

  @override
  Future<CreateOwnChatSessionResult> createOwnChatSession({
    required String selectableSpecialistId,
    required OperationAttemptId operationAttemptId,
  }) async {
    createCalls++;
    lastSelectableSpecialistId = selectableSpecialistId;
    lastOperationAttemptId = operationAttemptId;
    return createResult;
  }

  @override
  Future<ListOwnChatSessionsResult> listOwnChatSessions({
    ChatSessionStatusFilter status = ChatSessionStatusFilter.active,
    int limit = 20,
    String? cursor,
  }) async {
    listCalls++;
    lastStatus = status;
    lastLimit = limit;
    lastCursor = cursor;
    return listResult;
  }

  @override
  Future<ArchiveOwnChatSessionResult> archiveOwnChatSession({
    required String sessionId,
  }) async {
    lastArchivedSessionId = sessionId;
    return archiveResult;
  }

  @override
  Future<ReadOwnChatSessionResult> readOwnChatSession({
    required String sessionId,
  }) async => readResult;

  @override
  Future<RestoreOwnChatSessionResult> restoreOwnChatSession({
    required String sessionId,
  }) async {
    lastRestoredSessionId = sessionId;
    return restoreResult;
  }
}

class _FakeMessagesRepository implements OwnChatMessagesRepository {
  SendUserMessageResult sendResult = const SendUserMessageFailure(
    SendOwnChatMessageFailureType.unexpectedError,
  );
  ListSessionMessagesResult listResult = const ListSessionMessagesEmpty();

  String? lastSessionId;
  String? lastContent;
  OperationAttemptId? lastOperationAttemptId;
  int? lastLimit;
  String? lastCursor;

  @override
  Future<SendUserMessageResult> sendUserMessage({
    required String sessionId,
    required String content,
    required OperationAttemptId operationAttemptId,
  }) async {
    lastSessionId = sessionId;
    lastContent = content;
    lastOperationAttemptId = operationAttemptId;
    return sendResult;
  }

  @override
  Future<ListSessionMessagesResult> listSessionMessages({
    required String sessionId,
    int limit = 50,
    String? cursor,
  }) async {
    lastSessionId = sessionId;
    lastLimit = limit;
    lastCursor = cursor;
    return listResult;
  }
}

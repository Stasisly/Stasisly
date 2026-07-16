import 'package:flutter_test/flutter_test.dart';

import 'package:stasisly/core/identity/domain/authentication_state.dart';
import 'package:stasisly/core/identity/domain/identity_type.dart';
import 'package:stasisly/core/identity/domain/stasisly_identity.dart';
import 'package:stasisly/features/chat_messages/domain/entities/own_chat_message.dart';
import 'package:stasisly/features/chat_sessions/domain/entities/own_chat_session.dart';
import 'package:stasisly/features/conversations/data/adapters/own_chat_message_conversation_adapter.dart';
import 'package:stasisly/features/conversations/data/adapters/own_chat_session_conversation_adapter.dart';
import 'package:stasisly/features/conversations/domain/entities/conversation.dart';
import 'package:stasisly/features/conversations/domain/entities/conversation_message.dart';

void main() {
  const sessionAdapter = OwnChatSessionConversationAdapter();
  const messageAdapter = OwnChatMessageConversationAdapter();
  const owner = StasislyIdentity(
    subjectId: 'owner-subject',
    identityType: IdentityType.humanUser,
    authenticationState: AuthenticationState.authenticated,
  );

  test('maps active session and public specialist reference', () {
    final conversation = sessionAdapter.map(
      source: _session(ChatSessionStatus.active),
      trustedOwner: owner,
    );

    expect(conversation.conversationId.value, 'session-1');
    expect(conversation.ownerSubjectId, 'owner-subject');
    expect(conversation.status, ConversationStatus.active);
    expect(
      conversation.selectedSpecialistReference?.selectableSpecialistId,
      'catalog-wellness',
    );
  });

  test('maps archived session without inventing archivedAt', () {
    final conversation = sessionAdapter.map(
      source: _session(ChatSessionStatus.archived),
      trustedOwner: owner,
    );

    expect(conversation.status, ConversationStatus.archived);
    expect(conversation.archivedAt, isNull);
  });

  test('missing owner fails closed', () {
    expect(
      () => sessionAdapter.map(
        source: _session(ChatSessionStatus.active),
        trustedOwner: null,
      ),
      throwsA(isA<ConversationOwnershipException>()),
    );
  });

  test('maps only authors demonstrated by transitional evidence', () {
    final user = messageAdapter.map(_message(OwnChatMessageRole.user));
    final system = messageAdapter.map(_message(OwnChatMessageRole.system));
    final assistant = messageAdapter.map(
      _message(OwnChatMessageRole.assistant),
    );
    final tool = messageAdapter.map(_message(OwnChatMessageRole.tool));

    expect(user.author, ConversationMessageAuthor.user);
    expect(user.provenanceSummary, ConversationMessageProvenance.userProvided);
    expect(system.author, ConversationMessageAuthor.systemNotice);
    expect(
      system.provenanceSummary,
      ConversationMessageProvenance.systemGenerated,
    );
    expect(assistant.author, ConversationMessageAuthor.unknown);
    expect(assistant.isDisplaySafe, isFalse);
    expect(tool.author, ConversationMessageAuthor.unknown);
  });

  test('persisted source maps to accepted without provider metadata', () {
    final message = messageAdapter.map(_message(OwnChatMessageRole.user));

    expect(message.status, ConversationMessageStatus.accepted);
    expect(message.content, 'Hola');
    expect(message.props, hasLength(7));
  });

  test('invalid transitional message contract fails closed', () {
    expect(
      () => messageAdapter.map(
        OwnChatMessage(
          messageId: 'message-1',
          sessionId: 'session-1',
          role: OwnChatMessageRole.user,
          content: ' ',
          createdAt: DateTime.utc(2026),
          isDemo: false,
        ),
      ),
      throwsA(isA<ConversationContractException>()),
    );
  });
}

OwnChatSession _session(ChatSessionStatus status) {
  return OwnChatSession(
    sessionId: 'session-1',
    selectableSpecialist: const SelectableSpecialistSummary(
      id: 'catalog-wellness',
      displayName: 'Wellness',
      area: SelectableSpecialistSummaryArea.wellness,
    ),
    startedAt: DateTime.utc(2026),
    lastMessageAt: DateTime.utc(2026, 1, 2),
    status: status,
    messageCount: 1,
  );
}

OwnChatMessage _message(OwnChatMessageRole role) {
  return OwnChatMessage(
    messageId: 'message-1',
    sessionId: 'session-1',
    role: role,
    content: 'Hola',
    createdAt: DateTime.utc(2026),
    isDemo: false,
  );
}

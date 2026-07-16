import 'package:stasisly/core/identity/domain/stasisly_identity.dart';
import 'package:stasisly/features/chat_sessions/domain/entities/own_chat_session.dart';
import 'package:stasisly/features/conversations/domain/entities/conversation.dart';
import 'package:stasisly/features/conversations/domain/value_objects/conversation_id.dart';

/// Transitional mapping only. The source session ID is not guaranteed to remain
/// the canonical Conversation ID after backend migration.
class OwnChatSessionConversationAdapter {
  const OwnChatSessionConversationAdapter();

  Conversation map({
    required OwnChatSession source,
    required StasislyIdentity? trustedOwner,
  }) {
    if (trustedOwner == null || !trustedOwner.isAuthenticated) {
      throw const ConversationOwnershipException();
    }
    final specialistId = source.selectableSpecialist.id.trim();
    if (specialistId.isEmpty) {
      throw const ConversationContractException(
        'Missing selectable specialist reference.',
      );
    }
    final conversationId = ConversationId.tryParse(source.sessionId);
    if (conversationId == null) {
      throw const ConversationContractException(
        'Invalid transitional session contract.',
      );
    }
    return Conversation.fromTrustedIdentity(
      conversationId: conversationId,
      ownerIdentity: trustedOwner,
      status: switch (source.status) {
        ChatSessionStatus.active => ConversationStatus.active,
        ChatSessionStatus.archived => ConversationStatus.archived,
      },
      createdAt: source.startedAt,
      updatedAt: source.lastMessageAt,
      selectedSpecialistReference: ConversationSpecialistSelection(
        selectableSpecialistId: specialistId,
        displayName: source.selectableSpecialist.displayName.trim(),
        area: source.selectableSpecialist.area.name,
        state: ConversationSpecialistSelectionState.selected,
      ),
    );
  }
}

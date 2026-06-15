import 'package:stasisly/features/chat_sessions/domain/entities/own_chat_session.dart';
import 'package:stasisly/features/chat_sessions/domain/entities/own_chat_session_results.dart';

abstract interface class OwnChatSessionsRepository {
  Future<CreateOwnChatSessionResult> createOwnChatSession({
    required String selectableSpecialistId,
  });

  Future<ListOwnChatSessionsResult> listOwnChatSessions({
    ChatSessionStatusFilter status = ChatSessionStatusFilter.active,
    int limit = 20,
    String? cursor,
  });

  Future<ArchiveOwnChatSessionResult> archiveOwnChatSession({
    required String sessionId,
  });
}

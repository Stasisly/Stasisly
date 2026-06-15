import 'package:stasisly/features/chat_sessions/domain/entities/own_chat_session.dart';
import 'package:stasisly/features/chat_sessions/domain/entities/own_chat_session_results.dart';
import 'package:stasisly/features/chat_sessions/domain/repositories/own_chat_sessions_repository.dart';

class BackendBlockedOwnChatSessionsRepository
    implements OwnChatSessionsRepository {
  const BackendBlockedOwnChatSessionsRepository();

  static const _blocked = OwnChatSessionsFailureType.backendBlocked;

  @override
  Future<ArchiveOwnChatSessionResult> archiveOwnChatSession({
    required String sessionId,
  }) async {
    return const ArchiveOwnChatSessionFailure(_blocked);
  }

  @override
  Future<CreateOwnChatSessionResult> createOwnChatSession({
    required String selectableSpecialistId,
  }) async {
    return const CreateOwnChatSessionFailure(_blocked);
  }

  @override
  Future<ListOwnChatSessionsResult> listOwnChatSessions({
    ChatSessionStatusFilter status = ChatSessionStatusFilter.active,
    int limit = 20,
    String? cursor,
  }) async {
    return const ListOwnChatSessionsFailure(_blocked);
  }
}

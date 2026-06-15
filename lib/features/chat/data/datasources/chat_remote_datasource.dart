import 'package:stasisly/features/chat/domain/entities/chat_session_entity.dart';
import 'package:stasisly/features/chat/domain/entities/message_entity.dart';

/// Contract used only by backend-backed chat repositories.
abstract class ChatRemoteDataSource {
  Future<ChatSessionEntity> getOrCreateSession({
    required String userId,
    required String specialistId,
  });

  Future<MessageEntity> sendMessage({
    required String sessionId,
    required String role,
    required String content,
  });

  Stream<List<MessageEntity>> watchMessages(String sessionId);
}

import 'package:dartz/dartz.dart';

import 'package:stasisly/core/error/failures.dart';
import 'package:stasisly/features/chat/domain/entities/chat_session_entity.dart';
import 'package:stasisly/features/chat/domain/entities/message_entity.dart';

/// Repository interface for Chat operations.
abstract class ChatRepository {
  /// Gets an existing session between a user and specialist, or creates a new one.
  Future<Either<Failure, ChatSessionEntity>> getOrCreateSession({
    required String userId,
    required String specialistId,
  });

  /// Sends a message and returns the updated MessageEntity (with DB id and timestamp).
  Future<Either<Failure, MessageEntity>> sendMessage({
    required String sessionId,
    required String role,
    required String content,
  });

  /// Streams the messages of a given session in real-time.
  Stream<List<MessageEntity>> watchMessages(String sessionId);
}

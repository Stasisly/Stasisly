import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:uuid/uuid.dart';

import 'package:stasisly/core/error/failures.dart';
import 'package:stasisly/features/chat/domain/entities/chat_session_entity.dart';
import 'package:stasisly/features/chat/domain/entities/message_entity.dart';
import 'package:stasisly/features/chat/domain/repositories/chat_repository.dart';

/// Explicit local-only repository. It never contacts a remote service.
class DemoChatRepository implements ChatRepository {
  DemoChatRepository({this.responseDelay = const Duration(milliseconds: 250)});

  final Duration responseDelay;
  final Map<String, ChatSessionEntity> _sessions = {};
  final Map<String, List<MessageEntity>> _messages = {};
  final Map<String, StreamController<List<MessageEntity>>> _streams = {};

  @override
  Future<Either<Failure, ChatSessionEntity>> getOrCreateSession({
    required String userId,
    required String specialistId,
  }) async {
    final id = 'demo_session_$specialistId';
    final session = _sessions.putIfAbsent(
      id,
      () => ChatSessionEntity(
        id: id,
        userId: userId,
        specialistId: specialistId,
        startedAt: DateTime.now(),
        lastMessageAt: DateTime.now(),
        status: 'active',
        messageCount: 0,
      ),
    );
    _messages.putIfAbsent(id, () => []);
    _streams.putIfAbsent(id, StreamController<List<MessageEntity>>.broadcast);
    return Right(session);
  }

  @override
  Future<Either<Failure, MessageEntity>> sendMessage({
    required String sessionId,
    required String role,
    required String content,
  }) async {
    final message = MessageEntity(
      id: const Uuid().v4(),
      sessionId: sessionId,
      role: role,
      content: content,
      createdAt: DateTime.now(),
    );

    _addMessage(message);

    if (role == 'user') {
      unawaited(
        Future<void>.delayed(responseDelay, () {
          _addMessage(
            MessageEntity(
              id: const Uuid().v4(),
              sessionId: sessionId,
              role: 'assistant',
              content:
                  'Respuesta simulada del modo demo. No procede de un LLM ni '
                  'de datos reales.',
              createdAt: DateTime.now(),
            ),
          );
        }),
      );
    }

    return Right(message);
  }

  @override
  Stream<List<MessageEntity>> watchMessages(String sessionId) async* {
    final messages = _messages.putIfAbsent(sessionId, () => []);
    final controller = _streams.putIfAbsent(
      sessionId,
      StreamController<List<MessageEntity>>.broadcast,
    );
    yield List.unmodifiable(messages);
    yield* controller.stream;
  }

  void _addMessage(MessageEntity message) {
    final messages = _messages.putIfAbsent(message.sessionId, () => []);
    messages.add(message);
    _streams[message.sessionId]?.add(List.unmodifiable(messages));
  }
}

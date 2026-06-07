import 'package:dartz/dartz.dart';

import 'package:stasisly/core/error/failures.dart';
import 'package:stasisly/features/chat/domain/entities/message_entity.dart';
import 'package:stasisly/features/chat/domain/repositories/chat_repository.dart';

class SendMessageUseCase {
  const SendMessageUseCase(this._repository);

  final ChatRepository _repository;

  Future<Either<Failure, MessageEntity>> call({
    required String sessionId,
    required String role,
    required String content,
  }) {
    return _repository.sendMessage(
      sessionId: sessionId,
      role: role,
      content: content,
    );
  }
}

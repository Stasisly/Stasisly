import 'package:dartz/dartz.dart';

import 'package:stasisly/core/error/failures.dart';
import 'package:stasisly/features/chat/domain/entities/chat_session_entity.dart';
import 'package:stasisly/features/chat/domain/repositories/chat_repository.dart';

class GetOrCreateSessionUseCase {
  const GetOrCreateSessionUseCase(this._repository);

  final ChatRepository _repository;

  Future<Either<Failure, ChatSessionEntity>> call({
    required String userId,
    required String specialistId,
  }) {
    return _repository.getOrCreateSession(
      userId: userId,
      specialistId: specialistId,
    );
  }
}

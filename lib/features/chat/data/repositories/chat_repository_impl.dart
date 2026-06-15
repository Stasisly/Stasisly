import 'package:dartz/dartz.dart';

import 'package:stasisly/core/error/exceptions.dart';
import 'package:stasisly/core/error/failures.dart';
import 'package:stasisly/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:stasisly/features/chat/domain/entities/chat_session_entity.dart';
import 'package:stasisly/features/chat/domain/entities/message_entity.dart';
import 'package:stasisly/features/chat/domain/repositories/chat_repository.dart';

/// Backend-only chat repository. It never falls back to demo behavior.
class ChatRepositoryImpl implements ChatRepository {
  ChatRepositoryImpl(this._dataSource);

  final ChatRemoteDataSource _dataSource;

  @override
  Future<Either<Failure, ChatSessionEntity>> getOrCreateSession({
    required String userId,
    required String specialistId,
  }) async {
    try {
      final session = await _dataSource.getOrCreateSession(
        userId: userId,
        specialistId: specialistId,
      );
      return Right(session);
    } on ServerException catch (error) {
      return Left(ServerFailure(message: error.message));
    } on AppException catch (error) {
      return Left(UnknownFailure(message: error.message));
    } on Exception catch (error) {
      return Left(UnknownFailure(message: error.toString()));
    }
  }

  @override
  Future<Either<Failure, MessageEntity>> sendMessage({
    required String sessionId,
    required String role,
    required String content,
  }) async {
    try {
      final message = await _dataSource.sendMessage(
        sessionId: sessionId,
        role: role,
        content: content,
      );
      return Right(message);
    } on ServerException catch (error) {
      return Left(ServerFailure(message: error.message));
    } on AppException catch (error) {
      return Left(UnknownFailure(message: error.message));
    } on Exception catch (error) {
      return Left(UnknownFailure(message: error.toString()));
    }
  }

  @override
  Stream<List<MessageEntity>> watchMessages(String sessionId) {
    return _dataSource.watchMessages(sessionId);
  }
}

import 'package:flutter_test/flutter_test.dart';

import 'package:stasisly/core/error/exceptions.dart';
import 'package:stasisly/core/error/failures.dart';
import 'package:stasisly/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:stasisly/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:stasisly/features/chat/domain/entities/chat_session_entity.dart';
import 'package:stasisly/features/chat/domain/entities/message_entity.dart';

void main() {
  test('backend errors are propagated and never become demo success', () async {
    final repository = ChatRepositoryImpl(_FailingChatRemoteDataSource());

    final result = await repository.getOrCreateSession(
      userId: 'user',
      specialistId: 'specialist',
    );

    expect(result.isLeft(), isTrue);
    result.fold(
      (failure) {
        expect(failure, isA<ServerFailure>());
        expect(failure.message, contains('backend unavailable'));
      },
      (_) => fail('Backend failure must not become a successful demo session.'),
    );
  });
}

class _FailingChatRemoteDataSource implements ChatRemoteDataSource {
  @override
  Future<ChatSessionEntity> getOrCreateSession({
    required String userId,
    required String specialistId,
  }) {
    throw const ServerException(message: 'backend unavailable');
  }

  @override
  Future<MessageEntity> sendMessage({
    required String sessionId,
    required String role,
    required String content,
  }) {
    throw const ServerException(message: 'backend unavailable');
  }

  @override
  Stream<List<MessageEntity>> watchMessages(String sessionId) {
    return Stream.error(const ServerException(message: 'backend unavailable'));
  }
}

import 'package:stasisly/features/chat/domain/entities/message_entity.dart';
import 'package:stasisly/features/chat/domain/repositories/chat_repository.dart';

class WatchMessagesUseCase {
  const WatchMessagesUseCase(this._repository);

  final ChatRepository _repository;

  Stream<List<MessageEntity>> call(String sessionId) {
    return _repository.watchMessages(sessionId);
  }
}

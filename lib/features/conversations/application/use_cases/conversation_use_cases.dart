import 'package:stasisly/features/conversations/application/inputs/conversation_inputs.dart';
import 'package:stasisly/features/conversations/domain/entities/conversation.dart';
import 'package:stasisly/features/conversations/domain/repositories/conversation_repository.dart';
import 'package:stasisly/features/conversations/domain/results/conversation_results.dart';
import 'package:stasisly/features/conversations/domain/value_objects/conversation_id.dart';

class ListOwnConversations {
  const ListOwnConversations(this._repository);

  final ConversationRepository _repository;

  Future<ConversationListResult> call({
    required ConversationStatusFilter status,
    int limit = 20,
    String? cursor,
  }) => _repository.listOwnConversations(
    status: status,
    limit: limit,
    cursor: cursor,
  );
}

class ReadOwnConversation {
  const ReadOwnConversation(this._repository);

  final ConversationRepository _repository;

  Future<ConversationReadResult> call(ConversationId conversationId) =>
      _repository.readOwnConversation(conversationId);
}

class CreateOwnConversation {
  const CreateOwnConversation(this._repository);

  final ConversationRepository _repository;

  Future<ConversationMutationResult> call(CreateConversationInput input) =>
      _repository.createOwnConversation(input);
}

class ArchiveOwnConversation {
  const ArchiveOwnConversation(this._repository);

  final ConversationRepository _repository;

  Future<ConversationMutationResult> call(ArchiveConversationInput input) =>
      _repository.archiveOwnConversation(input);
}

class RestoreOwnConversation {
  const RestoreOwnConversation(this._repository);

  final ConversationRepository _repository;

  Future<ConversationMutationResult> call(RestoreConversationInput input) =>
      _repository.restoreOwnConversation(input);
}

class ListOwnConversationMessages {
  const ListOwnConversationMessages(this._repository);

  final ConversationRepository _repository;

  Future<ConversationMessageListResult> call(
    ListConversationMessagesInput input,
  ) => _repository.listOwnConversationMessages(input);
}

class SendOwnConversationMessage {
  const SendOwnConversationMessage(this._repository);

  final ConversationRepository _repository;

  Future<ConversationMessageSendResult> call(
    SendConversationMessageInput input,
  ) => _repository.sendOwnConversationMessage(input);
}

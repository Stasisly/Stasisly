import 'package:equatable/equatable.dart';

import 'package:stasisly/features/chat_messages/domain/entities/own_chat_message.dart';

enum SendOwnChatMessageFailureType {
  backendBlocked,
  unauthenticated,
  invalidSession,
  invalidRequest,
  contentInvalid,
  contentTooLong,
  sessionNotFound,
  sessionArchived,
  permissionDenied,
  writeUnconfirmed,
  contractViolation,
  backendMisconfigured,
  networkError,
  unexpectedError,
}

enum ListOwnChatMessagesFailureType {
  backendBlocked,
  unauthenticated,
  invalidSession,
  invalidRequest,
  invalidCursor,
  sessionNotFound,
  permissionDenied,
  contractViolation,
  backendMisconfigured,
  networkError,
  unexpectedError,
}

sealed class SendUserMessageResult extends Equatable {
  const SendUserMessageResult();

  @override
  List<Object?> get props => [];
}

final class SendUserMessageSuccess extends SendUserMessageResult {
  const SendUserMessageSuccess(this.sent);

  final SentOwnChatMessage sent;

  @override
  List<Object?> get props => [sent];
}

final class SendUserMessageDemo extends SendUserMessageResult {
  const SendUserMessageDemo(this.sent);

  final SentOwnChatMessage sent;

  @override
  List<Object?> get props => [sent];
}

final class SendUserMessageFailure extends SendUserMessageResult {
  const SendUserMessageFailure(this.type);

  final SendOwnChatMessageFailureType type;

  @override
  List<Object?> get props => [type];
}

sealed class ListSessionMessagesResult extends Equatable {
  const ListSessionMessagesResult();

  @override
  List<Object?> get props => [];
}

final class ListSessionMessagesSuccess extends ListSessionMessagesResult {
  const ListSessionMessagesSuccess(this.page);

  final OwnChatMessagesPage page;

  @override
  List<Object?> get props => [page];
}

final class ListSessionMessagesEmpty extends ListSessionMessagesResult {
  const ListSessionMessagesEmpty();
}

final class ListSessionMessagesDemo extends ListSessionMessagesResult {
  const ListSessionMessagesDemo(this.page);

  final OwnChatMessagesPage page;

  @override
  List<Object?> get props => [page];
}

final class ListSessionMessagesFailure extends ListSessionMessagesResult {
  const ListSessionMessagesFailure(this.type);

  final ListOwnChatMessagesFailureType type;

  @override
  List<Object?> get props => [type];
}

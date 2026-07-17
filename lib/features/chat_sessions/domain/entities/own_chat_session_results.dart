import 'package:equatable/equatable.dart';

import 'package:stasisly/features/chat_sessions/domain/entities/own_chat_session.dart';

enum OwnChatSessionsFailureType {
  unauthenticated,
  invalidSession,
  invalidRequest,
  invalidIdempotencyKey,
  idempotencyConflict,
  operationInProgress,
  transactionFailed,
  invalidSelectableSpecialist,
  specialistUnavailable,
  proLocked,
  sessionNotFound,
  permissionDenied,
  contractViolation,
  backendBlocked,
  networkError,
  unexpectedError,
}

sealed class CreateOwnChatSessionResult extends Equatable {
  const CreateOwnChatSessionResult();

  @override
  List<Object?> get props => [];
}

final class CreateOwnChatSessionSuccess extends CreateOwnChatSessionResult {
  const CreateOwnChatSessionSuccess(this.session);

  final OwnChatSession session;

  @override
  List<Object?> get props => [session];
}

final class CreateOwnChatSessionDemo extends CreateOwnChatSessionResult {
  const CreateOwnChatSessionDemo(this.session);

  final OwnChatSession session;

  @override
  List<Object?> get props => [session];
}

final class CreateOwnChatSessionFailure extends CreateOwnChatSessionResult {
  const CreateOwnChatSessionFailure(this.type);

  final OwnChatSessionsFailureType type;

  @override
  List<Object?> get props => [type];
}

sealed class ListOwnChatSessionsResult extends Equatable {
  const ListOwnChatSessionsResult();

  @override
  List<Object?> get props => [];
}

final class ListOwnChatSessionsSuccess extends ListOwnChatSessionsResult {
  const ListOwnChatSessionsSuccess(this.page);

  final OwnChatSessionsPage page;

  @override
  List<Object?> get props => [page];
}

final class ListOwnChatSessionsDemo extends ListOwnChatSessionsResult {
  const ListOwnChatSessionsDemo(this.page);

  final OwnChatSessionsPage page;

  @override
  List<Object?> get props => [page];
}

final class ListOwnChatSessionsFailure extends ListOwnChatSessionsResult {
  const ListOwnChatSessionsFailure(this.type);

  final OwnChatSessionsFailureType type;

  @override
  List<Object?> get props => [type];
}

sealed class ArchiveOwnChatSessionResult extends Equatable {
  const ArchiveOwnChatSessionResult();

  @override
  List<Object?> get props => [];
}

sealed class ReadOwnChatSessionResult extends Equatable {
  const ReadOwnChatSessionResult();
}

final class ReadOwnChatSessionSuccess extends ReadOwnChatSessionResult {
  const ReadOwnChatSessionSuccess(this.session);
  final OwnChatSessionLifecycleSnapshot session;
  @override
  List<Object?> get props => [session];
}

final class ReadOwnChatSessionFailure extends ReadOwnChatSessionResult {
  const ReadOwnChatSessionFailure(this.type);
  final OwnChatSessionsFailureType type;
  @override
  List<Object?> get props => [type];
}

sealed class RestoreOwnChatSessionResult extends Equatable {
  const RestoreOwnChatSessionResult();
}

final class RestoreOwnChatSessionSuccess extends RestoreOwnChatSessionResult {
  const RestoreOwnChatSessionSuccess(this.sessionId);
  final String sessionId;
  @override
  List<Object?> get props => [sessionId];
}

final class RestoreOwnChatSessionFailure extends RestoreOwnChatSessionResult {
  const RestoreOwnChatSessionFailure(this.type);
  final OwnChatSessionsFailureType type;
  @override
  List<Object?> get props => [type];
}

final class ArchiveOwnChatSessionSuccess extends ArchiveOwnChatSessionResult {
  const ArchiveOwnChatSessionSuccess(this.session);

  final ArchivedOwnChatSession session;

  @override
  List<Object?> get props => [session];
}

final class ArchiveOwnChatSessionDemo extends ArchiveOwnChatSessionResult {
  const ArchiveOwnChatSessionDemo(this.session);

  final ArchivedOwnChatSession session;

  @override
  List<Object?> get props => [session];
}

final class ArchiveOwnChatSessionFailure extends ArchiveOwnChatSessionResult {
  const ArchiveOwnChatSessionFailure(this.type);

  final OwnChatSessionsFailureType type;

  @override
  List<Object?> get props => [type];
}

import 'package:stasisly/core/error/exceptions.dart';
import 'package:stasisly/core/idempotency/operation_attempt_id.dart';
import 'package:stasisly/features/chat_sessions/data/contracts/own_chat_sessions_contract_source.dart';
import 'package:stasisly/features/chat_sessions/domain/entities/own_chat_session.dart';
import 'package:stasisly/features/chat_sessions/domain/entities/own_chat_session_results.dart';
import 'package:stasisly/features/chat_sessions/domain/repositories/own_chat_sessions_repository.dart';

/// Validates simulated public payloads. It does not perform I/O.
class ValidatingOwnChatSessionsRepository
    implements OwnChatSessionsRepository, OwnChatSessionLifecycleRepository {
  const ValidatingOwnChatSessionsRepository({
    required this.source,
    this.lifecycleSource,
  });

  final OwnChatSessionsContractSource source;
  final OwnChatSessionLifecycleContractSource? lifecycleSource;

  @override
  Future<CreateOwnChatSessionResult> createOwnChatSession({
    required String selectableSpecialistId,
    required OperationAttemptId operationAttemptId,
  }) async {
    if (selectableSpecialistId.trim().isEmpty) {
      return const CreateOwnChatSessionFailure(
        OwnChatSessionsFailureType.invalidSelectableSpecialist,
      );
    }
    try {
      final response = await source.createOwnChatSession(
        selectableSpecialistId: selectableSpecialistId,
        operationAttemptId: operationAttemptId,
      );
      final failure = _failureFor(response);
      if (failure != null) return CreateOwnChatSessionFailure(failure);
      return CreateOwnChatSessionSuccess(_parseSessionEnvelope(response.body));
    } on NetworkException {
      return const CreateOwnChatSessionFailure(
        OwnChatSessionsFailureType.networkError,
      );
    } on FormatException {
      return const CreateOwnChatSessionFailure(
        OwnChatSessionsFailureType.contractViolation,
      );
    } on Exception {
      return const CreateOwnChatSessionFailure(
        OwnChatSessionsFailureType.unexpectedError,
      );
    }
  }

  @override
  Future<ListOwnChatSessionsResult> listOwnChatSessions({
    ChatSessionStatusFilter status = ChatSessionStatusFilter.active,
    int limit = 20,
    String? cursor,
  }) async {
    if (limit < 1 || limit > 50 || (cursor?.isEmpty ?? false)) {
      return const ListOwnChatSessionsFailure(
        OwnChatSessionsFailureType.invalidRequest,
      );
    }
    try {
      final response = await source.listOwnChatSessions(
        status: status,
        limit: limit,
        cursor: cursor,
      );
      final failure = _failureFor(response);
      if (failure != null) return ListOwnChatSessionsFailure(failure);
      return ListOwnChatSessionsSuccess(_parsePage(response.body));
    } on NetworkException {
      return const ListOwnChatSessionsFailure(
        OwnChatSessionsFailureType.networkError,
      );
    } on FormatException {
      return const ListOwnChatSessionsFailure(
        OwnChatSessionsFailureType.contractViolation,
      );
    } on Exception {
      return const ListOwnChatSessionsFailure(
        OwnChatSessionsFailureType.unexpectedError,
      );
    }
  }

  @override
  Future<ArchiveOwnChatSessionResult> archiveOwnChatSession({
    required String sessionId,
  }) async {
    if (sessionId.trim().isEmpty) {
      return const ArchiveOwnChatSessionFailure(
        OwnChatSessionsFailureType.invalidRequest,
      );
    }
    try {
      final response = await source.archiveOwnChatSession(sessionId: sessionId);
      final failure = _failureFor(response);
      if (failure != null) return ArchiveOwnChatSessionFailure(failure);
      return ArchiveOwnChatSessionSuccess(
        _parseArchivedSessionEnvelope(response.body),
      );
    } on NetworkException {
      return const ArchiveOwnChatSessionFailure(
        OwnChatSessionsFailureType.networkError,
      );
    } on FormatException {
      return const ArchiveOwnChatSessionFailure(
        OwnChatSessionsFailureType.contractViolation,
      );
    } on Exception {
      return const ArchiveOwnChatSessionFailure(
        OwnChatSessionsFailureType.unexpectedError,
      );
    }
  }

  @override
  Future<ReadOwnChatSessionResult> readOwnChatSession({
    required String sessionId,
  }) async {
    if (sessionId.trim().isEmpty) {
      return const ReadOwnChatSessionFailure(
        OwnChatSessionsFailureType.invalidRequest,
      );
    }
    final lifecycle = lifecycleSource;
    if (lifecycle == null) {
      return const ReadOwnChatSessionFailure(
        OwnChatSessionsFailureType.backendBlocked,
      );
    }
    try {
      final response = await lifecycle.readOwnChatSession(sessionId: sessionId);
      final failure = _failureFor(response);
      if (failure != null) return ReadOwnChatSessionFailure(failure);
      return ReadOwnChatSessionSuccess(
        _parseLifecycleSnapshotEnvelope(response.body),
      );
    } on NetworkException {
      return const ReadOwnChatSessionFailure(
        OwnChatSessionsFailureType.networkError,
      );
    } on FormatException {
      return const ReadOwnChatSessionFailure(
        OwnChatSessionsFailureType.contractViolation,
      );
    } on Exception {
      return const ReadOwnChatSessionFailure(
        OwnChatSessionsFailureType.unexpectedError,
      );
    }
  }

  @override
  Future<RestoreOwnChatSessionResult> restoreOwnChatSession({
    required String sessionId,
  }) async {
    if (sessionId.trim().isEmpty) {
      return const RestoreOwnChatSessionFailure(
        OwnChatSessionsFailureType.invalidRequest,
      );
    }
    final lifecycle = lifecycleSource;
    if (lifecycle == null) {
      return const RestoreOwnChatSessionFailure(
        OwnChatSessionsFailureType.backendBlocked,
      );
    }
    try {
      final response = await lifecycle.restoreOwnChatSession(
        sessionId: sessionId,
      );
      final failure = _failureFor(response);
      if (failure != null) return RestoreOwnChatSessionFailure(failure);
      _expectExactKeys(response.body, const {'conversation'});
      final conversation = _expectMap(response.body!['conversation']);
      _expectExactKeys(conversation, const {'conversationId', 'status'});
      if (conversation['conversationId'] != sessionId ||
          conversation['status'] != 'active') {
        throw const FormatException('Invalid restored conversation.');
      }
      return RestoreOwnChatSessionSuccess(sessionId);
    } on NetworkException {
      return const RestoreOwnChatSessionFailure(
        OwnChatSessionsFailureType.networkError,
      );
    } on FormatException {
      return const RestoreOwnChatSessionFailure(
        OwnChatSessionsFailureType.contractViolation,
      );
    } on Exception {
      return const RestoreOwnChatSessionFailure(
        OwnChatSessionsFailureType.unexpectedError,
      );
    }
  }
}

OwnChatSessionsFailureType? _failureFor(
  OwnChatSessionsContractResponse response,
) {
  if (response.statusCode == 200 || response.statusCode == 201) return null;
  return switch (response.errorCode) {
    'unauthenticated' => OwnChatSessionsFailureType.unauthenticated,
    'invalidSession' => OwnChatSessionsFailureType.invalidSession,
    'invalidRequest' ||
    'invalidStatus' ||
    'invalidCursor' => OwnChatSessionsFailureType.invalidRequest,
    'missingIdempotencyKey' ||
    'invalidIdempotencyKey' => OwnChatSessionsFailureType.invalidIdempotencyKey,
    'idempotencyConflict' => OwnChatSessionsFailureType.idempotencyConflict,
    'operationInProgress' => OwnChatSessionsFailureType.operationInProgress,
    'transactionFailed' => OwnChatSessionsFailureType.transactionFailed,
    'invalidSelectableSpecialist' =>
      OwnChatSessionsFailureType.invalidSelectableSpecialist,
    'specialistUnavailable' => OwnChatSessionsFailureType.specialistUnavailable,
    'proLocked' => OwnChatSessionsFailureType.proLocked,
    'sessionNotFound' => OwnChatSessionsFailureType.sessionNotFound,
    'conversationNotFound' => OwnChatSessionsFailureType.sessionNotFound,
    'permissionDenied' => OwnChatSessionsFailureType.permissionDenied,
    'contractViolation' ||
    'archiveUnconfirmed' => OwnChatSessionsFailureType.contractViolation,
    'backendBlocked' ||
    'backendMisconfigured' => OwnChatSessionsFailureType.backendBlocked,
    _ =>
      response.statusCode == 401
          ? OwnChatSessionsFailureType.unauthenticated
          : response.statusCode == 403
          ? OwnChatSessionsFailureType.permissionDenied
          : OwnChatSessionsFailureType.unexpectedError,
  };
}

OwnChatSessionLifecycleSnapshot _parseLifecycleSnapshotEnvelope(
  Map<String, dynamic>? body,
) {
  _expectExactKeys(body, const {'conversation'});
  final json = _expectMap(body!['conversation']);
  final allowed = {
    'conversationId',
    'status',
    'createdAt',
    'updatedAt',
    'archivedAt',
    'selectedSpecialist',
  };
  if (json.keys.any((key) => !allowed.contains(key)) ||
      !json.keys.toSet().containsAll(const {
        'conversationId',
        'status',
        'createdAt',
        'updatedAt',
      })) {
    throw const FormatException('Unexpected conversation shape.');
  }
  final status = _parseStatus(json['status']);
  final archivedAt = json['archivedAt'] == null
      ? null
      : _parseDate(json['archivedAt']);
  if ((status == ChatSessionStatus.active && archivedAt != null) ||
      (status == ChatSessionStatus.archived && archivedAt == null)) {
    throw const FormatException('Invalid lifecycle mapping.');
  }
  SelectableSpecialistSummary? specialist;
  if (json['selectedSpecialist'] != null) {
    final selected = _expectMap(json['selectedSpecialist']);
    _expectExactKeys(selected, const {'id', 'displayName', 'area'});
    specialist = SelectableSpecialistSummary(
      id: _expectNonEmptyString(selected['id']),
      displayName: _expectNonEmptyString(selected['displayName']),
      area: _parseArea(selected['area']),
    );
  }
  return OwnChatSessionLifecycleSnapshot(
    sessionId: _expectNonEmptyString(json['conversationId']),
    status: status,
    createdAt: _parseDate(json['createdAt']),
    updatedAt: _parseDate(json['updatedAt']),
    archivedAt: archivedAt,
    selectableSpecialist: specialist,
  );
}

OwnChatSession _parseSessionEnvelope(Map<String, dynamic>? body) {
  _expectExactKeys(body, const {'session'});
  return _parseSession(_expectMap(body!['session']));
}

ArchivedOwnChatSession _parseArchivedSessionEnvelope(
  Map<String, dynamic>? body,
) {
  _expectExactKeys(body, const {'session'});
  final session = _expectMap(body!['session']);
  _expectExactKeys(session, const {'sessionId', 'status'});
  if (session['sessionId'] case final String id when id.isNotEmpty) {
    if (session['status'] == 'archived') {
      return ArchivedOwnChatSession(sessionId: id);
    }
  }
  throw const FormatException('Invalid archived session.');
}

OwnChatSessionsPage _parsePage(Map<String, dynamic>? body) {
  _expectExactKeys(body, const {'items', 'nextCursor'});
  final rawItems = body!['items'];
  final nextCursor = body['nextCursor'];
  if (rawItems is! List || nextCursor != null && nextCursor is! String) {
    throw const FormatException('Invalid sessions page.');
  }
  final items = rawItems
      .map((item) => _parseSession(_expectMap(item)))
      .toList(growable: false);
  if (items.map((item) => item.sessionId).toSet().length != items.length) {
    throw const FormatException('Duplicate session.');
  }
  return OwnChatSessionsPage(items: items, nextCursor: nextCursor as String?);
}

OwnChatSession _parseSession(Map<String, dynamic> json) {
  _expectExactKeys(json, const {
    'sessionId',
    'selectableSpecialist',
    'startedAt',
    'lastMessageAt',
    'status',
    'messageCount',
  });
  final summaryJson = _expectMap(json['selectableSpecialist']);
  _expectExactKeys(summaryJson, const {'id', 'displayName', 'area'});
  final summary = SelectableSpecialistSummary(
    id: _expectNonEmptyString(summaryJson['id']),
    displayName: _expectNonEmptyString(summaryJson['displayName']),
    area: _parseArea(summaryJson['area']),
  );
  final count = json['messageCount'];
  if (count is! int || count < 0) {
    throw const FormatException('Invalid message count.');
  }
  return OwnChatSession(
    sessionId: _expectNonEmptyString(json['sessionId']),
    selectableSpecialist: summary,
    startedAt: _parseDate(json['startedAt']),
    lastMessageAt: _parseDate(json['lastMessageAt']),
    status: _parseStatus(json['status']),
    messageCount: count,
  );
}

void _expectExactKeys(Map<String, dynamic>? json, Set<String> expected) {
  if (json == null ||
      json.keys.length != expected.length ||
      !json.keys.toSet().containsAll(expected)) {
    throw const FormatException('Unexpected contract shape.');
  }
}

Map<String, dynamic> _expectMap(Object? value) {
  if (value is Map<String, dynamic>) return value;
  throw const FormatException('Expected object.');
}

String _expectNonEmptyString(Object? value) {
  if (value is String && value.isNotEmpty) return value;
  throw const FormatException('Expected non-empty string.');
}

DateTime _parseDate(Object? value) {
  final raw = _expectNonEmptyString(value);
  final normalized = RegExp(r'(Z|[+-]\d\d:?\d\d)$').hasMatch(raw)
      ? raw
      : '${raw}Z';
  final parsed = DateTime.tryParse(normalized);
  if (parsed == null || !parsed.isUtc) {
    throw const FormatException('Expected UTC timestamp.');
  }
  return parsed;
}

ChatSessionStatus _parseStatus(Object? value) {
  return switch (value) {
    'active' => ChatSessionStatus.active,
    'archived' => ChatSessionStatus.archived,
    _ => throw const FormatException('Invalid session status.'),
  };
}

SelectableSpecialistSummaryArea _parseArea(Object? value) {
  return switch (value) {
    'stasis' => SelectableSpecialistSummaryArea.stasis,
    'health' => SelectableSpecialistSummaryArea.health,
    'nutrition' => SelectableSpecialistSummaryArea.nutrition,
    'training' => SelectableSpecialistSummaryArea.training,
    'wellness' => SelectableSpecialistSummaryArea.wellness,
    _ => throw const FormatException('Invalid public area.'),
  };
}

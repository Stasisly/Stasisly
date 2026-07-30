import 'dart:convert';
import 'dart:io';

import 'development_v4_dirty_run_containment_contracts.dart';

typedef V4ContainmentHttpTransport =
    Future<V4ContainmentHttpResponse> Function(String method, Uri uri);

final class HttpV4DirtyRunContainmentGateway implements V4ContainmentGateway {
  HttpV4DirtyRunContainmentGateway({
    required this.baseUrl,
    required this.serviceRoleKey,
    this.transport,
  });

  final Uri baseUrl;
  final String serviceRoleKey;
  final V4ContainmentHttpTransport? transport;

  String _ownerId = '';
  String _conversationId = '';
  String _operationAttempt = '';
  String _profileMarker = '';

  @override
  Future<V4CounterSnapshot> readSevenCounters(V4RunIdentity identity) async {
    _operationAttempt = identity.useOperationAttempt((value) => value);
    _profileMarker = identity.useProfileMarker((value) => value);
    try {
      final idempotency = await _readIdempotency();
      final profile = await _readProfile();
      if (!_mergeOwnerProof(idempotency.ownerId, profile.ownerId)) {
        return _unknownSnapshot();
      }
      if (idempotency.evidence.result == V4CounterResult.zero &&
          profile.evidence.result == V4CounterResult.zero &&
          _ownerId.isEmpty &&
          _conversationId.isEmpty) {
        return _insufficientIdentitySnapshot(
          idempotency: idempotency.evidence,
          profile: profile.evidence,
        );
      }
      if (idempotency.conversationId.isNotEmpty) {
        _conversationId = idempotency.conversationId;
      }
      final session = await _readSession();
      if (session.result == V4CounterResult.nonzeroExact &&
          _conversationId.isEmpty) {
        _conversationId = session.deleteHandle!
            .use((value) => value)
            .split('|')
            .first;
      }
      final messages = await _readMessages(session);
      final auth = await _readAuth();
      return V4CounterSnapshot([
        messages,
        idempotency.evidence,
        session,
        profile.evidence,
        _canonicalZero('catalog'),
        _canonicalZero('specialists'),
        auth,
      ]);
    } on FormatException {
      return _unknownSnapshot();
    } on Object {
      return _failedSnapshot();
    }
  }

  @override
  Future<bool> deleteExact(V4ContainmentOperation operation) async {
    if (!v4MutableContainmentOrder.contains(operation.resource) ||
        operation.handle.resource != operation.resource) {
      return false;
    }
    return operation.handle.use((raw) async {
      final parts = raw.split('|');
      late final Uri uri;
      switch (operation.resource) {
        case 'messages':
          if (parts.length != 1) return false;
          uri = _endpoint('/rest/v1/messages', {
            'session_id': 'eq.${parts.single}',
          });
        case 'idempotency':
          if (parts.length != 3) return false;
          uri = _endpoint('/rest/v1/conversation_idempotency', {
            'subject_id': 'eq.${parts[0]}',
            'operation_id': 'eq.${parts[1]}',
            'idempotency_key': 'eq.${parts[2]}',
          });
        case 'sessions':
          if (parts.length != 2) return false;
          uri = _endpoint('/rest/v1/chat_sessions', {
            'id': 'eq.${parts[0]}',
            'user_id': 'eq.${parts[1]}',
          });
        case 'profiles':
          if (parts.length != 2) return false;
          uri = _endpoint('/rest/v1/users', {
            'id': 'eq.${parts[0]}',
            'display_name': 'eq.${parts[1]}',
          });
        case 'auth':
          if (parts.length != 1) return false;
          uri = baseUrl.resolve('/auth/v1/admin/users/${parts.single}');
        case 'catalog':
        case 'specialists':
          return false;
        default:
          return false;
      }
      final response = await _request(method: 'DELETE', uri: uri);
      return {200, 204, 404}.contains(response.status);
    });
  }

  @override
  Future<bool> verifyAuthAbsence(V4RunIdentity identity) async {
    if (_ownerId.isEmpty) {
      // The failed runner already proved exact Auth absence after cleanup.
      return true;
    }
    final response = await _request(
      method: 'GET',
      uri: baseUrl.resolve('/auth/v1/admin/users/$_ownerId'),
    );
    return response.status == 404;
  }

  @override
  Future<bool> isolateCli() async {
    try {
      for (final path in [
        'supabase/.temp/project-ref',
        'supabase/.temp/pooler-url',
      ]) {
        final file = File(path);
        if (file.existsSync()) file.deleteSync();
      }
      final result = await Process.run(Platform.resolvedExecutable, [
        'run',
        'tool/check_supabase_remote_context.dart',
      ]);
      return result.exitCode == 0;
    } on Object {
      return false;
    }
  }

  Future<_IdempotencyObservation> _readIdempotency() async {
    final response = await _request(
      method: 'GET',
      uri: _endpoint('/rest/v1/conversation_idempotency', {
        'operation_id': 'eq.create_conversation',
        'idempotency_key': 'eq.$_operationAttempt',
        'select':
            'subject_id,operation_id,idempotency_key,result_reference,state',
        'limit': '2',
      }),
    );
    final rows = _rows(response, maximum: 2);
    if (response.status != 200 || rows == null) {
      return _IdempotencyObservation.failure();
    }
    if (rows.isEmpty) return _IdempotencyObservation.zero();
    if (rows.length != 1) return _IdempotencyObservation.unknown();
    final row = rows.single;
    const keys = {
      'subject_id',
      'operation_id',
      'idempotency_key',
      'result_reference',
      'state',
    };
    final owner = row['subject_id'];
    final conversation = row['result_reference'];
    if (row.keys.toSet().difference(keys).isNotEmpty ||
        keys.difference(row.keys.toSet()).isNotEmpty ||
        owner is! String ||
        !_uuidPattern.hasMatch(owner) ||
        row['operation_id'] != 'create_conversation' ||
        row['idempotency_key'] != _operationAttempt ||
        row['state'] != 'completed' ||
        conversation is! String ||
        !_uuidPattern.hasMatch(conversation)) {
      return _IdempotencyObservation.unknown();
    }
    return _IdempotencyObservation.exact(
      ownerId: owner,
      conversationId: conversation,
      operationAttempt: _operationAttempt,
    );
  }

  Future<_ProfileObservation> _readProfile() async {
    final response = await _request(
      method: 'GET',
      uri: _endpoint('/rest/v1/users', {
        'display_name': 'eq.$_profileMarker',
        'select': 'id,display_name',
        'limit': '2',
      }),
    );
    final rows = _rows(response, maximum: 2);
    if (response.status != 200 || rows == null) {
      return _ProfileObservation.failure();
    }
    if (rows.isEmpty) return _ProfileObservation.zero();
    if (rows.length != 1) return _ProfileObservation.unknown();
    final row = rows.single;
    final owner = row['id'];
    if (row.length != 2 ||
        owner is! String ||
        !_uuidPattern.hasMatch(owner) ||
        row['display_name'] != _profileMarker) {
      return _ProfileObservation.unknown();
    }
    return _ProfileObservation.exact(
      ownerId: owner,
      profileMarker: _profileMarker,
    );
  }

  bool _mergeOwnerProof(String idempotencyOwner, String profileOwner) {
    final candidates = {
      if (idempotencyOwner.isNotEmpty) idempotencyOwner,
      if (profileOwner.isNotEmpty) profileOwner,
    };
    if (candidates.length > 1) return false;
    if (candidates.isNotEmpty) _ownerId = candidates.single;
    return true;
  }

  Future<V4CounterEvidence> _readSession() async {
    if (_conversationId.isEmpty && _ownerId.isEmpty) {
      return _zero('sessions', V4ResourceOwnership.createdByRun, 0);
    }
    final filters = <String, String>{
      'select': 'id,user_id',
      'limit': '2',
      if (_conversationId.isNotEmpty) 'id': 'eq.$_conversationId',
      if (_ownerId.isNotEmpty) 'user_id': 'eq.$_ownerId',
    };
    final response = await _request(
      method: 'GET',
      uri: _endpoint('/rest/v1/chat_sessions', filters),
    );
    final rows = _rows(response, maximum: 2);
    if (response.status != 200 || rows == null) {
      return _failure('sessions', V4CounterResult.queryFailed, 2);
    }
    if (rows.isEmpty) {
      return _zero('sessions', V4ResourceOwnership.createdByRun, 2);
    }
    if (rows.length != 1) {
      return _failure('sessions', V4CounterResult.unknownBlocking, 2);
    }
    final row = rows.single;
    final session = row['id'];
    final owner = row['user_id'];
    if (row.length != 2 ||
        session is! String ||
        owner is! String ||
        !_uuidPattern.hasMatch(session) ||
        !_uuidPattern.hasMatch(owner) ||
        (_conversationId.isNotEmpty && session != _conversationId) ||
        (_ownerId.isNotEmpty && owner != _ownerId)) {
      return _failure('sessions', V4CounterResult.unknownBlocking, 2);
    }
    _ownerId = owner;
    _conversationId = session;
    return V4CounterEvidence(
      name: 'sessions',
      result: V4CounterResult.nonzeroExact,
      count: 1,
      lookupExact: true,
      queryBound: 2,
      ownership: V4ResourceOwnership.createdByRun,
      ownershipProof: true,
      deleteHandle: V4OpaqueHandle.exact('sessions', '$session|$owner'),
    );
  }

  Future<V4CounterEvidence> _readMessages(V4CounterEvidence session) async {
    if (_conversationId.isEmpty) {
      if (session.result == V4CounterResult.zero) {
        return _zero('messages', V4ResourceOwnership.createdByRun, 0);
      }
      return _failure('messages', V4CounterResult.unknownBlocking, 2);
    }
    final response = await _request(
      method: 'GET',
      uri: _endpoint('/rest/v1/messages', {
        'session_id': 'eq.$_conversationId',
        'select': 'id',
        'limit': '2',
      }),
    );
    final rows = _rows(response, maximum: 2);
    if (response.status != 200 || rows == null) {
      return _failure('messages', V4CounterResult.queryFailed, 2);
    }
    if (rows.isEmpty) {
      return _zero('messages', V4ResourceOwnership.createdByRun, 2);
    }
    return V4CounterEvidence(
      name: 'messages',
      result: V4CounterResult.nonzeroExact,
      count: rows.length,
      lookupExact: true,
      queryBound: 2,
      ownership: V4ResourceOwnership.createdByRun,
      ownershipProof: true,
      deleteHandle: V4OpaqueHandle.exact('messages', _conversationId),
    );
  }

  Future<V4CounterEvidence> _readAuth() async {
    if (_ownerId.isEmpty) {
      return _zero('auth', V4ResourceOwnership.createdByRun, 0);
    }
    final response = await _request(
      method: 'GET',
      uri: baseUrl.resolve('/auth/v1/admin/users/$_ownerId'),
    );
    if (response.status == 404) {
      return _zero('auth', V4ResourceOwnership.createdByRun, 1);
    }
    if (response.status != 200) {
      return _failure('auth', V4CounterResult.queryFailed, 1);
    }
    return V4CounterEvidence(
      name: 'auth',
      result: V4CounterResult.nonzeroExact,
      count: 1,
      lookupExact: true,
      queryBound: 1,
      ownership: V4ResourceOwnership.createdByRun,
      ownershipProof: true,
      deleteHandle: V4OpaqueHandle.exact('auth', _ownerId),
    );
  }

  V4CounterSnapshot _unknownSnapshot() => V4CounterSnapshot([
    for (final name in v4CounterNames)
      name == 'catalog' || name == 'specialists'
          ? _canonicalZero(name)
          : _failure(name, V4CounterResult.unknownBlocking, 2),
  ]);

  V4CounterSnapshot _insufficientIdentitySnapshot({
    required V4CounterEvidence idempotency,
    required V4CounterEvidence profile,
  }) => V4CounterSnapshot([
    _failure('messages', V4CounterResult.unknownBlocking, 0),
    idempotency,
    _failure('sessions', V4CounterResult.unknownBlocking, 0),
    profile,
    _canonicalZero('catalog'),
    _canonicalZero('specialists'),
    _zero('auth', V4ResourceOwnership.createdByRun, 0),
  ]);

  V4CounterSnapshot _failedSnapshot() => V4CounterSnapshot([
    for (final name in v4CounterNames)
      name == 'catalog' || name == 'specialists'
          ? _canonicalZero(name)
          : _failure(name, V4CounterResult.queryFailed, 2),
  ]);

  V4CounterEvidence _zero(
    String name,
    V4ResourceOwnership ownership,
    int bound,
  ) => V4CounterEvidence(
    name: name,
    result: V4CounterResult.zero,
    count: 0,
    lookupExact: true,
    queryBound: bound,
    ownership: ownership,
  );

  V4CounterEvidence _canonicalZero(String name) =>
      _zero(name, V4ResourceOwnership.verifiedPreexistingReadOnly, 0);

  V4CounterEvidence _failure(String name, V4CounterResult result, int bound) =>
      V4CounterEvidence(
        name: name,
        result: result,
        count: null,
        lookupExact: true,
        queryBound: bound,
        ownership: V4ResourceOwnership.unknown,
      );

  Uri _endpoint(String path, Map<String, String> query) =>
      baseUrl.resolve(path).replace(queryParameters: query);

  Future<V4ContainmentHttpResponse> _request({
    required String method,
    required Uri uri,
  }) async {
    if (method != 'GET' && method != 'DELETE') {
      throw StateError('V4_CONTAINMENT_HTTP_METHOD_BLOCKED');
    }
    if (uri.scheme != 'https' || uri.host != baseUrl.host) {
      throw StateError('V4_CONTAINMENT_TARGET_BLOCKED');
    }
    final injectedTransport = transport;
    if (injectedTransport != null) {
      return injectedTransport(method, uri);
    }
    final client = HttpClient()
      ..connectionTimeout = const Duration(seconds: 15);
    try {
      final request = await client.openUrl(method, uri);
      request
        ..followRedirects = false
        ..maxRedirects = 0;
      request.headers
        ..set('apikey', serviceRoleKey)
        ..set(HttpHeaders.authorizationHeader, 'Bearer $serviceRoleKey')
        ..set(HttpHeaders.acceptHeader, 'application/json');
      final response = await request.close().timeout(
        const Duration(seconds: 30),
      );
      final raw = await response.transform(utf8.decoder).join();
      Object? body;
      if (raw.trim().isNotEmpty) body = jsonDecode(raw);
      return V4ContainmentHttpResponse(response.statusCode, body);
    } finally {
      client.close(force: true);
    }
  }
}

final class _IdempotencyObservation {
  const _IdempotencyObservation({
    required this.evidence,
    this.ownerId = '',
    this.conversationId = '',
  });

  factory _IdempotencyObservation.zero() => const _IdempotencyObservation(
    evidence: V4CounterEvidence(
      name: 'idempotency',
      result: V4CounterResult.zero,
      count: 0,
      lookupExact: true,
      queryBound: 2,
      ownership: V4ResourceOwnership.createdByRun,
    ),
  );

  factory _IdempotencyObservation.exact({
    required String ownerId,
    required String conversationId,
    required String operationAttempt,
  }) => _IdempotencyObservation(
    ownerId: ownerId,
    conversationId: conversationId,
    evidence: V4CounterEvidence(
      name: 'idempotency',
      result: V4CounterResult.nonzeroExact,
      count: 1,
      lookupExact: true,
      queryBound: 2,
      ownership: V4ResourceOwnership.createdByRun,
      ownershipProof: true,
      deleteHandle: V4OpaqueHandle.exact(
        'idempotency',
        '$ownerId|create_conversation|$operationAttempt',
      ),
    ),
  );

  factory _IdempotencyObservation.unknown() => const _IdempotencyObservation(
    evidence: V4CounterEvidence(
      name: 'idempotency',
      result: V4CounterResult.unknownBlocking,
      count: null,
      lookupExact: true,
      queryBound: 2,
      ownership: V4ResourceOwnership.unknown,
    ),
  );

  factory _IdempotencyObservation.failure() => const _IdempotencyObservation(
    evidence: V4CounterEvidence(
      name: 'idempotency',
      result: V4CounterResult.queryFailed,
      count: null,
      lookupExact: true,
      queryBound: 2,
      ownership: V4ResourceOwnership.unknown,
    ),
  );

  final V4CounterEvidence evidence;
  final String ownerId;
  final String conversationId;
}

final class _ProfileObservation {
  const _ProfileObservation({required this.evidence, this.ownerId = ''});

  factory _ProfileObservation.zero() => const _ProfileObservation(
    evidence: V4CounterEvidence(
      name: 'profiles',
      result: V4CounterResult.zero,
      count: 0,
      lookupExact: true,
      queryBound: 2,
      ownership: V4ResourceOwnership.createdByRun,
    ),
  );

  factory _ProfileObservation.exact({
    required String ownerId,
    required String profileMarker,
  }) => _ProfileObservation(
    ownerId: ownerId,
    evidence: V4CounterEvidence(
      name: 'profiles',
      result: V4CounterResult.nonzeroExact,
      count: 1,
      lookupExact: true,
      queryBound: 2,
      ownership: V4ResourceOwnership.createdByRun,
      ownershipProof: true,
      deleteHandle: V4OpaqueHandle.exact('profiles', '$ownerId|$profileMarker'),
    ),
  );

  factory _ProfileObservation.unknown() => const _ProfileObservation(
    evidence: V4CounterEvidence(
      name: 'profiles',
      result: V4CounterResult.unknownBlocking,
      count: null,
      lookupExact: true,
      queryBound: 2,
      ownership: V4ResourceOwnership.unknown,
    ),
  );

  factory _ProfileObservation.failure() => const _ProfileObservation(
    evidence: V4CounterEvidence(
      name: 'profiles',
      result: V4CounterResult.queryFailed,
      count: null,
      lookupExact: true,
      queryBound: 2,
      ownership: V4ResourceOwnership.unknown,
    ),
  );

  final V4CounterEvidence evidence;
  final String ownerId;
}

List<Map<String, Object?>>? _rows(
  V4ContainmentHttpResponse response, {
  required int maximum,
}) {
  final body = response.body;
  if (body is! List<Object?> || body.length > maximum) return null;
  final rows = <Map<String, Object?>>[];
  for (final row in body) {
    if (row is! Map) return null;
    rows.add(Map<String, Object?>.from(row));
  }
  return List.unmodifiable(rows);
}

final class V4ContainmentHttpResponse {
  const V4ContainmentHttpResponse(this.status, this.body);

  final int status;
  final Object? body;
}

final _uuidPattern = RegExp(
  r'^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
  caseSensitive: false,
);

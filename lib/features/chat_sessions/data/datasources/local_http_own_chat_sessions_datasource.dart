import 'package:stasisly/core/idempotency/operation_attempt_id.dart';
import 'package:stasisly/features/chat_sessions/data/contracts/own_chat_sessions_contract_source.dart';
import 'package:stasisly/features/chat_sessions/data/local/local_only_host_policy.dart';
import 'package:stasisly/features/chat_sessions/data/local/local_session_token_provider.dart';
import 'package:stasisly/features/chat_sessions/data/local/own_chat_sessions_http_transport.dart';
import 'package:stasisly/features/chat_sessions/domain/entities/own_chat_session.dart';

class LocalHttpOwnChatSessionsDataSource
    implements
        OwnChatSessionsContractSource,
        OwnChatSessionLifecycleContractSource {
  const LocalHttpOwnChatSessionsDataSource({
    required this.baseUri,
    required this.hostPolicy,
    required this.tokenProvider,
    required this.transport,
  });

  static const _createPath = '/functions/v1/create-own-chat-session';
  static const _listPath = '/functions/v1/list-own-chat-sessions';
  static const _archivePath = '/functions/v1/archive-own-chat-session';
  static const _readPath = '/functions/v1/read-own-conversation';
  static const _restorePath = '/functions/v1/restore-own-conversation';

  final Uri baseUri;
  final OwnChatSessionsHostPolicy hostPolicy;
  final LocalSessionTokenProvider tokenProvider;
  final OwnChatSessionsHttpTransport transport;

  @override
  Future<OwnChatSessionsContractResponse> createOwnChatSession({
    required String selectableSpecialistId,
    required OperationAttemptId operationAttemptId,
  }) {
    return _send(
      method: OwnChatSessionsHttpMethod.post,
      path: _createPath,
      body: {'selectableSpecialistId': selectableSpecialistId},
      idempotencyKey: operationAttemptId,
    );
  }

  @override
  Future<OwnChatSessionsContractResponse> listOwnChatSessions({
    required ChatSessionStatusFilter status,
    required int limit,
    String? cursor,
  }) {
    return _send(
      method: OwnChatSessionsHttpMethod.get,
      path: _listPath,
      queryParameters: {
        'status': status.name,
        'limit': '$limit',
        if (cursor != null) 'cursor': cursor,
      },
    );
  }

  @override
  Future<OwnChatSessionsContractResponse> archiveOwnChatSession({
    required String sessionId,
  }) {
    return _send(
      method: OwnChatSessionsHttpMethod.post,
      path: _archivePath,
      body: {'sessionId': sessionId},
    );
  }

  @override
  Future<OwnChatSessionsContractResponse> readOwnChatSession({
    required String sessionId,
  }) {
    return _send(
      method: OwnChatSessionsHttpMethod.post,
      path: _readPath,
      body: {'conversationId': sessionId},
    );
  }

  @override
  Future<OwnChatSessionsContractResponse> restoreOwnChatSession({
    required String sessionId,
  }) {
    return _send(
      method: OwnChatSessionsHttpMethod.post,
      path: _restorePath,
      body: {'conversationId': sessionId},
    );
  }

  Future<OwnChatSessionsContractResponse> _send({
    required OwnChatSessionsHttpMethod method,
    required String path,
    Map<String, String>? queryParameters,
    Map<String, dynamic>? body,
    OperationAttemptId? idempotencyKey,
  }) async {
    if (!hostPolicy.allows(baseUri)) {
      return const OwnChatSessionsContractResponse(
        statusCode: 503,
        errorCode: 'backendBlocked',
      );
    }

    final token = await tokenProvider.readLocalSessionToken();
    if (token == null) {
      return const OwnChatSessionsContractResponse(
        statusCode: 401,
        errorCode: 'unauthenticated',
      );
    }
    if (token.trim().isEmpty) {
      return const OwnChatSessionsContractResponse(
        statusCode: 401,
        errorCode: 'invalidSession',
      );
    }

    final uri = baseUri
        .resolve(path)
        .replace(
          queryParameters: queryParameters?.isEmpty ?? true
              ? null
              : queryParameters,
        );
    final response = await transport.send(
      OwnChatSessionsHttpRequest(
        method: method,
        uri: uri,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          if (idempotencyKey != null) 'Idempotency-Key': idempotencyKey.value,
        },
        body: body,
      ),
    );
    if (response.statusCode >= 300 && response.statusCode < 400) {
      return const OwnChatSessionsContractResponse(
        statusCode: 503,
        errorCode: 'backendBlocked',
      );
    }
    return OwnChatSessionsContractResponse(
      statusCode: response.statusCode,
      body: _stringKeyedMap(response.body),
      errorCode: _errorCode(response.body),
    );
  }
}

Map<String, dynamic>? _stringKeyedMap(Object? value) {
  if (value is! Map) return null;
  if (value.keys.any((key) => key is! String)) return null;
  return Map<String, dynamic>.from(value);
}

String? _errorCode(Object? value) {
  final body = _stringKeyedMap(value);
  if (body == null || body.keys.length != 1 || body['error'] is! Map) {
    return null;
  }
  final error = _stringKeyedMap(body['error']);
  if (error == null ||
      error.keys.length != 2 ||
      error['code'] is! String ||
      error['requestId'] is! String) {
    return null;
  }
  return error['code'] as String;
}

import 'package:stasisly/features/chat_messages/data/contracts/own_chat_messages_payload_validator.dart';
import 'package:stasisly/features/chat_messages/data/local/local_only_host_policy.dart';
import 'package:stasisly/features/chat_messages/data/local/local_session_token_provider.dart';
import 'package:stasisly/features/chat_messages/data/local/own_chat_messages_http_transport.dart';
import 'package:stasisly/features/chat_messages/domain/entities/own_chat_message_results.dart';
import 'package:stasisly/features/chat_messages/domain/repositories/own_chat_messages_repository.dart';
import 'package:stasisly/features/chat_messages/domain/validation/own_chat_message_input_validator.dart';

class LocalHttpOwnChatMessagesDataSource implements OwnChatMessagesRepository {
  const LocalHttpOwnChatMessagesDataSource({
    required this.baseUri,
    required this.hostPolicy,
    required this.tokenProvider,
    required this.transport,
    this.payloadValidator = const OwnChatMessagesPayloadValidator(),
    this.inputValidator = const OwnChatMessageInputValidator(),
  });

  static const sendPath = '/functions/v1/send-user-message';
  static const listPath = '/functions/v1/list-session-messages';

  final Uri baseUri;
  final OwnChatMessagesHostPolicy hostPolicy;
  final LocalSessionTokenProvider tokenProvider;
  final OwnChatMessagesHttpTransport transport;
  final OwnChatMessagesPayloadValidator payloadValidator;
  final OwnChatMessageInputValidator inputValidator;

  @override
  Future<SendUserMessageResult> sendUserMessage({
    required String sessionId,
    required String content,
  }) async {
    final inputError = inputValidator.validateSend(
      sessionId: sessionId,
      content: content,
    );
    if (inputError != null) {
      return SendUserMessageFailure(_sendInput(inputError));
    }
    final token = await _readTokenForSend();
    if (token is SendUserMessageFailure) return token;
    try {
      final response = await transport.send(
        OwnChatMessagesHttpRequest(
          method: OwnChatMessagesHttpMethod.post,
          uri: baseUri.resolve(sendPath),
          headers: _headers(token as String),
          body: {'sessionId': sessionId, 'content': content.trim()},
        ),
      );
      if (_isRedirect(response.statusCode)) {
        return const SendUserMessageFailure(
          SendOwnChatMessageFailureType.backendBlocked,
        );
      }
      final failure = _sendHttpFailure(response);
      if (failure != null) return SendUserMessageFailure(failure);
      return SendUserMessageSuccess(
        payloadValidator.parseSentMessage(_body(response.body)),
      );
    } on OwnChatMessagesTransportException {
      return const SendUserMessageFailure(
        SendOwnChatMessageFailureType.networkError,
      );
    } on OwnChatMessagesContractException {
      return const SendUserMessageFailure(
        SendOwnChatMessageFailureType.contractViolation,
      );
    } on Exception {
      return const SendUserMessageFailure(
        SendOwnChatMessageFailureType.unexpectedError,
      );
    }
  }

  @override
  Future<ListSessionMessagesResult> listSessionMessages({
    required String sessionId,
    int limit = 50,
    String? cursor,
  }) async {
    final inputError = inputValidator.validateList(
      sessionId: sessionId,
      limit: limit,
      cursor: cursor,
    );
    if (inputError != null) {
      return ListSessionMessagesFailure(_listInput(inputError));
    }
    final token = await _readTokenForList();
    if (token is ListSessionMessagesFailure) return token;
    try {
      final response = await transport.send(
        OwnChatMessagesHttpRequest(
          method: OwnChatMessagesHttpMethod.get,
          uri: baseUri
              .resolve(listPath)
              .replace(
                queryParameters: {
                  'sessionId': sessionId,
                  'limit': '$limit',
                  if (cursor != null) 'cursor': cursor,
                },
              ),
          headers: _headers(token as String),
        ),
      );
      if (_isRedirect(response.statusCode)) {
        return const ListSessionMessagesFailure(
          ListOwnChatMessagesFailureType.backendBlocked,
        );
      }
      final failure = _listHttpFailure(response);
      if (failure != null) return ListSessionMessagesFailure(failure);
      final page = payloadValidator.parseMessagesPage(_body(response.body));
      if (page.items.isEmpty && page.nextCursor == null) {
        return const ListSessionMessagesEmpty();
      }
      return ListSessionMessagesSuccess(page);
    } on OwnChatMessagesTransportException {
      return const ListSessionMessagesFailure(
        ListOwnChatMessagesFailureType.networkError,
      );
    } on OwnChatMessagesContractException {
      return const ListSessionMessagesFailure(
        ListOwnChatMessagesFailureType.contractViolation,
      );
    } on Exception {
      return const ListSessionMessagesFailure(
        ListOwnChatMessagesFailureType.unexpectedError,
      );
    }
  }

  Future<Object> _readTokenForSend() async {
    if (!hostPolicy.allows(baseUri)) {
      return const SendUserMessageFailure(
        SendOwnChatMessageFailureType.backendBlocked,
      );
    }
    final token = await tokenProvider.readLocalSessionToken();
    if (token == null || token.trim().isEmpty) {
      return const SendUserMessageFailure(
        SendOwnChatMessageFailureType.unauthenticated,
      );
    }
    return token;
  }

  Future<Object> _readTokenForList() async {
    if (!hostPolicy.allows(baseUri)) {
      return const ListSessionMessagesFailure(
        ListOwnChatMessagesFailureType.backendBlocked,
      );
    }
    final token = await tokenProvider.readLocalSessionToken();
    if (token == null || token.trim().isEmpty) {
      return const ListSessionMessagesFailure(
        ListOwnChatMessagesFailureType.unauthenticated,
      );
    }
    return token;
  }

  Map<String, String> _headers(String token) {
    return {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  SendOwnChatMessageFailureType _sendInput(OwnChatMessageInputError error) {
    return switch (error) {
      OwnChatMessageInputError.invalidSession =>
        SendOwnChatMessageFailureType.invalidSession,
      OwnChatMessageInputError.contentInvalid =>
        SendOwnChatMessageFailureType.contentInvalid,
      OwnChatMessageInputError.contentTooLong =>
        SendOwnChatMessageFailureType.contentTooLong,
      OwnChatMessageInputError.invalidRequest =>
        SendOwnChatMessageFailureType.invalidRequest,
    };
  }

  ListOwnChatMessagesFailureType _listInput(OwnChatMessageInputError error) {
    return switch (error) {
      OwnChatMessageInputError.invalidSession =>
        ListOwnChatMessagesFailureType.invalidSession,
      OwnChatMessageInputError.contentInvalid ||
      OwnChatMessageInputError.contentTooLong ||
      OwnChatMessageInputError.invalidRequest =>
        ListOwnChatMessagesFailureType.invalidRequest,
    };
  }

  SendOwnChatMessageFailureType? _sendHttpFailure(
    OwnChatMessagesHttpResponse response,
  ) {
    if (_isSuccess(response.statusCode)) return null;
    final code = _errorCode(response.body);
    return switch (code) {
      'unauthenticated' ||
      'invalidSession' => SendOwnChatMessageFailureType.unauthenticated,
      'contentInvalid' => SendOwnChatMessageFailureType.contentInvalid,
      'contentTooLong' => SendOwnChatMessageFailureType.contentTooLong,
      'invalidRequest' => SendOwnChatMessageFailureType.invalidRequest,
      'sessionNotFound' => SendOwnChatMessageFailureType.sessionNotFound,
      'sessionArchived' => SendOwnChatMessageFailureType.sessionArchived,
      'writeUnconfirmed' => SendOwnChatMessageFailureType.writeUnconfirmed,
      'permissionDenied' => SendOwnChatMessageFailureType.permissionDenied,
      'contractViolation' => SendOwnChatMessageFailureType.contractViolation,
      'backendMisconfigured' =>
        SendOwnChatMessageFailureType.backendMisconfigured,
      _ => switch (response.statusCode) {
        401 => SendOwnChatMessageFailureType.unauthenticated,
        400 => SendOwnChatMessageFailureType.invalidRequest,
        403 => SendOwnChatMessageFailureType.permissionDenied,
        404 => SendOwnChatMessageFailureType.sessionNotFound,
        409 => SendOwnChatMessageFailureType.sessionArchived,
        502 => SendOwnChatMessageFailureType.contractViolation,
        503 => SendOwnChatMessageFailureType.backendMisconfigured,
        _ => SendOwnChatMessageFailureType.unexpectedError,
      },
    };
  }

  ListOwnChatMessagesFailureType? _listHttpFailure(
    OwnChatMessagesHttpResponse response,
  ) {
    if (_isSuccess(response.statusCode)) return null;
    final code = _errorCode(response.body);
    return switch (code) {
      'unauthenticated' ||
      'invalidSession' => ListOwnChatMessagesFailureType.unauthenticated,
      'invalidCursor' => ListOwnChatMessagesFailureType.invalidCursor,
      'invalidRequest' => ListOwnChatMessagesFailureType.invalidRequest,
      'sessionNotFound' => ListOwnChatMessagesFailureType.sessionNotFound,
      'permissionDenied' => ListOwnChatMessagesFailureType.permissionDenied,
      'contractViolation' => ListOwnChatMessagesFailureType.contractViolation,
      'backendMisconfigured' =>
        ListOwnChatMessagesFailureType.backendMisconfigured,
      _ => switch (response.statusCode) {
        401 => ListOwnChatMessagesFailureType.unauthenticated,
        400 => ListOwnChatMessagesFailureType.invalidRequest,
        403 => ListOwnChatMessagesFailureType.permissionDenied,
        404 => ListOwnChatMessagesFailureType.sessionNotFound,
        502 => ListOwnChatMessagesFailureType.contractViolation,
        503 => ListOwnChatMessagesFailureType.backendMisconfigured,
        _ => ListOwnChatMessagesFailureType.unexpectedError,
      },
    };
  }

  bool _isSuccess(int statusCode) => statusCode >= 200 && statusCode < 300;

  bool _isRedirect(int statusCode) => statusCode >= 300 && statusCode < 400;

  Map<String, Object?> _body(Object? value) {
    if (value is! Map) throw const OwnChatMessagesContractException('body');
    if (value.keys.any((key) => key is! String)) {
      throw const OwnChatMessagesContractException('body keys');
    }
    return Map<String, Object?>.from(value);
  }

  String? _errorCode(Object? value) {
    if (value is! Map || value.keys.length != 1 || value['error'] is! Map) {
      return null;
    }
    final error = value['error']! as Map;
    if (error.keys.length != 2 ||
        error['code'] is! String ||
        error['requestId'] is! String) {
      return null;
    }
    return error['code'] as String;
  }
}

import 'package:stasisly/features/chat_messages/domain/entities/own_chat_message.dart';

class OwnChatMessagesContractException implements Exception {
  const OwnChatMessagesContractException(this.reason);

  final String reason;

  @override
  String toString() => 'OwnChatMessagesContractException($reason)';
}

class OwnChatMessagesPayloadValidator {
  const OwnChatMessagesPayloadValidator();

  static const Set<String> _forbiddenKeys = {
    'user_id',
    'userId',
    'owner',
    'ownerId',
    'specialist_id',
    'specialistId',
    'internalSpecialistId',
    'prompt_template',
    'promptTemplate',
    'service_role',
    'serviceRole',
    'JWT',
    'accessToken',
    'refreshToken',
    'attachments',
    'metadata',
  };

  static const Set<String> _messageKeys = {
    'messageId',
    'sessionId',
    'role',
    'content',
    'createdAt',
  };

  static const Set<String> _sentKeys = {'message', 'session'};

  static const Set<String> _sentSessionKeys = {
    'sessionId',
    'messageCount',
    'lastMessageAt',
  };

  static const Set<String> _pageKeys = {'items', 'nextCursor'};

  SentOwnChatMessage parseSentMessage(Map<String, Object?> payload) {
    _rejectForbiddenDeep(payload);
    _expectKeys(payload, _sentKeys, 'sent payload');
    final messagePayload = _expectMap(payload['message'], 'message');
    final sessionPayload = _expectMap(payload['session'], 'session');
    _expectKeys(sessionPayload, _sentSessionKeys, 'session');
    final message = _parseMessage(messagePayload, isDemo: false);
    final sessionId = _expectNonEmptyString(
      sessionPayload['sessionId'],
      'session.sessionId',
    );
    final messageCount = _expectNonNegativeInt(
      sessionPayload['messageCount'],
      'session.messageCount',
    );
    final lastMessageAt = _expectDateTime(
      sessionPayload['lastMessageAt'],
      'session.lastMessageAt',
    );
    if (message.sessionId != sessionId) {
      throw const OwnChatMessagesContractException('session id mismatch');
    }
    return SentOwnChatMessage(
      message: message,
      sessionId: sessionId,
      messageCount: messageCount,
      lastMessageAt: lastMessageAt,
      isDemo: false,
    );
  }

  OwnChatMessagesPage parseMessagesPage(Map<String, Object?> payload) {
    _rejectForbiddenDeep(payload);
    _expectKeys(payload, _pageKeys, 'messages page');
    final rawItems = payload['items'];
    if (rawItems is! List<Object?>) {
      throw const OwnChatMessagesContractException('items must be list');
    }
    final items = rawItems
        .map((item) => _parseMessage(_expectMap(item, 'item'), isDemo: false))
        .toList(growable: false);
    final rawCursor = payload['nextCursor'];
    if (rawCursor != null && rawCursor is! String) {
      throw const OwnChatMessagesContractException(
        'nextCursor must be string or null',
      );
    }
    if (rawCursor is String && rawCursor.isEmpty) {
      throw const OwnChatMessagesContractException(
        'nextCursor must not be empty',
      );
    }
    return OwnChatMessagesPage(items: items, nextCursor: rawCursor as String?);
  }

  OwnChatMessage _parseMessage(
    Map<String, Object?> payload, {
    required bool isDemo,
  }) {
    _expectKeys(payload, _messageKeys, 'message');
    final roleValue = _expectNonEmptyString(payload['role'], 'message.role');
    final role = OwnChatMessageRole.tryParse(roleValue);
    if (role == null) {
      throw OwnChatMessagesContractException('invalid role $roleValue');
    }
    return OwnChatMessage(
      messageId: _expectNonEmptyString(
        payload['messageId'],
        'message.messageId',
      ),
      sessionId: _expectNonEmptyString(
        payload['sessionId'],
        'message.sessionId',
      ),
      role: role,
      content: _expectNonEmptyString(payload['content'], 'message.content'),
      createdAt: _expectDateTime(payload['createdAt'], 'message.createdAt'),
      isDemo: isDemo,
    );
  }

  void _rejectForbiddenDeep(Object? value) {
    if (value is Map) {
      for (final entry in value.entries) {
        final key = entry.key;
        if (key is! String) {
          throw const OwnChatMessagesContractException('non string key');
        }
        if (_forbiddenKeys.contains(key)) {
          throw OwnChatMessagesContractException('forbidden key $key');
        }
        _rejectForbiddenDeep(entry.value);
      }
    } else if (value is List) {
      for (final item in value) {
        _rejectForbiddenDeep(item);
      }
    }
  }

  void _expectKeys(
    Map<String, Object?> payload,
    Set<String> expected,
    String label,
  ) {
    final actual = payload.keys.toSet();
    if (actual.length != expected.length || !actual.containsAll(expected)) {
      throw OwnChatMessagesContractException('invalid $label keys');
    }
  }

  Map<String, Object?> _expectMap(Object? value, String label) {
    if (value is! Map<String, Object?>) {
      throw OwnChatMessagesContractException('$label must be object');
    }
    return value;
  }

  String _expectNonEmptyString(Object? value, String label) {
    if (value is! String || value.trim().isEmpty) {
      throw OwnChatMessagesContractException('$label must be non-empty string');
    }
    return value;
  }

  int _expectNonNegativeInt(Object? value, String label) {
    if (value is! int || value < 0) {
      throw OwnChatMessagesContractException('$label must be non-negative int');
    }
    return value;
  }

  DateTime _expectDateTime(Object? value, String label) {
    if (value is! String) {
      throw OwnChatMessagesContractException('$label must be timestamp string');
    }
    try {
      return DateTime.parse(value).toUtc();
    } on FormatException {
      throw OwnChatMessagesContractException('$label must be valid timestamp');
    }
  }
}

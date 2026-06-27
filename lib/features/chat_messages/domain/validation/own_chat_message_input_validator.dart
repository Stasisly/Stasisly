enum OwnChatMessageInputError {
  invalidSession,
  contentInvalid,
  contentTooLong,
  invalidRequest,
}

class OwnChatMessageInputValidator {
  const OwnChatMessageInputValidator();

  static const int maxContentLength = 4000;
  static const int minLimit = 1;
  static const int maxLimit = 100;

  OwnChatMessageInputError? validateSend({
    required String sessionId,
    required String content,
  }) {
    if (sessionId.trim().isEmpty) {
      return OwnChatMessageInputError.invalidSession;
    }
    final trimmed = content.trim();
    if (trimmed.isEmpty) {
      return OwnChatMessageInputError.contentInvalid;
    }
    if (trimmed.length > maxContentLength) {
      return OwnChatMessageInputError.contentTooLong;
    }
    return null;
  }

  OwnChatMessageInputError? validateList({
    required String sessionId,
    required int limit,
    String? cursor,
  }) {
    if (sessionId.trim().isEmpty) {
      return OwnChatMessageInputError.invalidSession;
    }
    if (limit < minLimit || limit > maxLimit) {
      return OwnChatMessageInputError.invalidRequest;
    }
    if (cursor != null && cursor.trim().isEmpty) {
      return OwnChatMessageInputError.invalidRequest;
    }
    return null;
  }
}

enum OwnChatMessagesHttpMethod { get, post }

class OwnChatMessagesHttpRequest {
  const OwnChatMessagesHttpRequest({
    required this.method,
    required this.uri,
    required this.headers,
    this.body,
  });

  final OwnChatMessagesHttpMethod method;
  final Uri uri;
  final Map<String, String> headers;
  final Map<String, Object?>? body;
}

class OwnChatMessagesHttpResponse {
  const OwnChatMessagesHttpResponse({
    required this.statusCode,
    required this.body,
  });

  final int statusCode;
  final Object? body;
}

class OwnChatMessagesTransportException implements Exception {
  const OwnChatMessagesTransportException();
}

/// One method is intentional so tests can prove no transport call occurred.
// ignore: one_member_abstracts
abstract interface class OwnChatMessagesHttpTransport {
  Future<OwnChatMessagesHttpResponse> send(OwnChatMessagesHttpRequest request);
}

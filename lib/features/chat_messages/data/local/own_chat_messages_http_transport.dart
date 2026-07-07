import 'package:dio/dio.dart';

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

OwnChatMessagesHttpTransport createDioOwnChatMessagesHttpTransport() {
  return DioOwnChatMessagesHttpTransport(dio: Dio());
}

class DioOwnChatMessagesHttpTransport implements OwnChatMessagesHttpTransport {
  DioOwnChatMessagesHttpTransport({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<OwnChatMessagesHttpResponse> send(
    OwnChatMessagesHttpRequest request,
  ) async {
    try {
      final response = await _dio.request<Object?>(
        request.uri.toString(),
        data: request.body,
        options: Options(
          method: request.method == OwnChatMessagesHttpMethod.get
              ? 'GET'
              : 'POST',
          headers: request.headers,
          followRedirects: false,
          maxRedirects: 0,
          validateStatus: (_) => true,
        ),
      );
      return OwnChatMessagesHttpResponse(
        statusCode: response.statusCode ?? 0,
        body: response.data,
      );
    } on DioException {
      throw const OwnChatMessagesTransportException();
    }
  }
}

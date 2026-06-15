import 'package:dio/dio.dart';

import 'package:stasisly/core/error/exceptions.dart';

enum OwnChatSessionsHttpMethod { get, post }

class OwnChatSessionsHttpRequest {
  const OwnChatSessionsHttpRequest({
    required this.method,
    required this.uri,
    required this.headers,
    this.body,
  });

  final OwnChatSessionsHttpMethod method;
  final Uri uri;
  final Map<String, String> headers;
  final Map<String, dynamic>? body;
}

class OwnChatSessionsHttpResponse {
  const OwnChatSessionsHttpResponse({
    required this.statusCode,
    required this.body,
  });

  final int statusCode;
  final Object? body;
}

/// One method is intentional so tests can prove no transport call occurred.
// ignore: one_member_abstracts
abstract interface class OwnChatSessionsHttpTransport {
  Future<OwnChatSessionsHttpResponse> send(OwnChatSessionsHttpRequest request);
}

class DioOwnChatSessionsHttpTransport implements OwnChatSessionsHttpTransport {
  DioOwnChatSessionsHttpTransport({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<OwnChatSessionsHttpResponse> send(
    OwnChatSessionsHttpRequest request,
  ) async {
    try {
      final response = await _dio.request<Object?>(
        request.uri.toString(),
        data: request.body,
        options: Options(
          method: request.method == OwnChatSessionsHttpMethod.get
              ? 'GET'
              : 'POST',
          headers: request.headers,
          followRedirects: false,
          maxRedirects: 0,
          validateStatus: (_) => true,
        ),
      );
      return OwnChatSessionsHttpResponse(
        statusCode: response.statusCode ?? 0,
        body: response.data,
      );
    } on DioException catch (error) {
      throw NetworkException(message: error.type.name);
    }
  }
}

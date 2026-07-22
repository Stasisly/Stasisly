import 'package:dio/dio.dart';

import 'package:stasisly/core/auth/session/secure_session_token_provider.dart';
import 'package:stasisly/core/error/exceptions.dart';
import 'package:stasisly/features/specialists/data/datasources/selectable_specialists_remote_datasource.dart';
import 'package:stasisly/features/specialists/domain/entities/selectable_specialist.dart';

// One method keeps the host decision independently injectable in tests.
// ignore: one_member_abstracts
abstract interface class SelectableSpecialistsHostPolicy {
  bool allows(Uri baseUri);
}

class LocalSelectableSpecialistsHostPolicy
    implements SelectableSpecialistsHostPolicy {
  const LocalSelectableSpecialistsHostPolicy();

  @override
  bool allows(Uri baseUri) =>
      baseUri.scheme == 'http' &&
      baseUri.hasPort &&
      baseUri.userInfo.isEmpty &&
      !baseUri.hasQuery &&
      !baseUri.hasFragment &&
      (baseUri.path.isEmpty || baseUri.path == '/') &&
      (baseUri.host == 'localhost' || baseUri.host == '127.0.0.1');
}

class DevelopmentSelectableSpecialistsHostPolicy
    implements SelectableSpecialistsHostPolicy {
  const DevelopmentSelectableSpecialistsHostPolicy({required this.enabled});

  final bool enabled;

  @override
  bool allows(Uri baseUri) =>
      enabled &&
      baseUri.scheme == 'https' &&
      !baseUri.hasPort &&
      baseUri.userInfo.isEmpty &&
      !baseUri.hasQuery &&
      !baseUri.hasFragment &&
      (baseUri.path.isEmpty || baseUri.path == '/') &&
      baseUri.host.endsWith('.supabase.co');
}

class HttpSelectableSpecialistsRemoteDataSource
    implements SelectableSpecialistsRemoteDataSource {
  HttpSelectableSpecialistsRemoteDataSource({
    required this.baseUri,
    required this.hostPolicy,
    required this.tokenProvider,
    Dio? dio,
  }) : _dio = dio ?? Dio();

  final Uri baseUri;
  final SelectableSpecialistsHostPolicy hostPolicy;
  final SecureSessionTokenProvider tokenProvider;
  final Dio _dio;

  @override
  Future<SelectableSpecialistsRemoteResponse> listSelectableSpecialists({
    SelectableSpecialistArea? areaFilter,
  }) async {
    if (!hostPolicy.allows(baseUri)) {
      return const SelectableSpecialistsRemoteResponse(
        statusCode: 503,
        errorCode: 'catalogBackendBlocked',
      );
    }
    final token = await tokenProvider.getAccessToken();
    if (!token.isSuccess || !token.hasToken) {
      return const SelectableSpecialistsRemoteResponse(statusCode: 401);
    }
    final uri = baseUri
        .resolve('/functions/v1/list-selectable-specialists')
        .replace(
          queryParameters: areaFilter == null
              ? null
              : {'area': areaFilter.name},
        );
    try {
      final response = await _dio.getUri<Object?>(
        uri,
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer ${token.token}',
          },
          followRedirects: false,
          maxRedirects: 0,
          validateStatus: (_) => true,
        ),
      );
      if (response.statusCode != 200) {
        return SelectableSpecialistsRemoteResponse(
          statusCode: response.statusCode ?? 0,
          errorCode: _safeErrorCode(response.data),
        );
      }
      return SelectableSpecialistsRemoteResponse(
        statusCode: 200,
        body: _stringKeyedMap(response.data),
      );
    } on DioException catch (error) {
      throw NetworkException(message: error.type.name);
    }
  }
}

Map<String, dynamic>? _stringKeyedMap(Object? value) {
  if (value is! Map || value.keys.any((key) => key is! String)) return null;
  return {for (final entry in value.entries) entry.key as String: entry.value};
}

String? _safeErrorCode(Object? value) {
  final body = _stringKeyedMap(value);
  final error = body == null ? null : _stringKeyedMap(body['error']);
  return error?['code'] is String ? error!['code'] as String : null;
}

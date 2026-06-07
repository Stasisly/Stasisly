/// Base class for data-layer exceptions.
///
/// Exceptions are thrown in the data layer (datasources) and caught
/// in repository implementations, which convert them to [Failure]s.
class AppException implements Exception {
  const AppException({this.message = '', this.statusCode});

  /// Human-readable error message.
  final String message;

  /// Optional HTTP status code.
  final int? statusCode;

  @override
  String toString() => 'AppException($statusCode): $message';
}

/// Server-side exception (API errors, timeouts, etc.).
class ServerException extends AppException {
  const ServerException({super.message, super.statusCode});
}

/// Authentication exception (401, invalid token, etc.).
class AuthException extends AppException {
  const AuthException({super.message, super.statusCode});
}

/// Cache read/write exception.
class CacheException extends AppException {
  const CacheException({super.message, super.statusCode});
}

/// Network exception (no connectivity).
class NetworkException extends AppException {
  const NetworkException({
    super.message = 'Sin conexión a internet',
    super.statusCode,
  });
}

/// File processing exception.
class FileProcessingException extends AppException {
  const FileProcessingException({super.message, super.statusCode});
}

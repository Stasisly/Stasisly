import 'package:equatable/equatable.dart';

/// Base class for domain-layer failures.
///
/// Failures represent expected error states in the domain layer.
/// Use [Either<Failure, T>] from dartz for functional error handling.
abstract class Failure extends Equatable {
  const Failure({this.message = '', this.statusCode});

  /// Human-readable error message.
  final String message;

  /// Optional HTTP status code or error code.
  final int? statusCode;

  @override
  List<Object?> get props => [message, statusCode];
}

/// Server or API related failure.
class ServerFailure extends Failure {
  const ServerFailure({super.message = 'Error del servidor', super.statusCode});
}

/// Authentication failure (expired token, invalid credentials, etc.).
class AuthFailure extends Failure {
  const AuthFailure({
    super.message = 'Error de autenticación',
    super.statusCode,
  });
}

/// Cache or local storage failure.
class CacheFailure extends Failure {
  const CacheFailure({
    super.message = 'Error de almacenamiento local',
    super.statusCode,
  });
}

/// Network connectivity failure.
class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'Sin conexión a internet',
    super.statusCode,
  });
}

/// Membership/subscription failure (expired, not active, etc.).
class MembershipFailure extends Failure {
  const MembershipFailure({
    super.message = 'Suscripción no activa',
    super.statusCode,
  });
}

/// Permission denied failure.
class PermissionFailure extends Failure {
  const PermissionFailure({
    super.message = 'Permiso denegado',
    super.statusCode,
  });
}

/// File processing failure.
class FileProcessingFailure extends Failure {
  const FileProcessingFailure({
    super.message = 'Error al procesar el archivo',
    super.statusCode,
  });
}

/// Unknown/unexpected failure.
class UnknownFailure extends Failure {
  const UnknownFailure({
    super.message = 'Error inesperado',
    super.statusCode,
  });
}

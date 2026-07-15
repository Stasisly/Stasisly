import 'package:equatable/equatable.dart';

enum AuthenticationErrorCode {
  authenticationUnavailable,
  invalidCredentials,
  sessionExpired,
  sessionRevoked,
  unauthenticated,
  environmentBlocked,
  providerFailure,
  invalidAuthenticationState,
}

class AuthenticationError extends Equatable {
  const AuthenticationError(this.code);

  final AuthenticationErrorCode code;

  String get safeMessage => switch (code) {
    AuthenticationErrorCode.authenticationUnavailable =>
      'El servicio de autenticación no está disponible.',
    AuthenticationErrorCode.invalidCredentials =>
      'Las credenciales no son válidas.',
    AuthenticationErrorCode.sessionExpired => 'La sesión ha caducado.',
    AuthenticationErrorCode.sessionRevoked => 'La sesión ya no es válida.',
    AuthenticationErrorCode.unauthenticated =>
      'Se requiere una sesión autenticada.',
    AuthenticationErrorCode.environmentBlocked =>
      'La autenticación está bloqueada en este entorno.',
    AuthenticationErrorCode.providerFailure =>
      'No se pudo completar la autenticación.',
    AuthenticationErrorCode.invalidAuthenticationState =>
      'El estado de autenticación no es válido.',
  };

  @override
  List<Object?> get props => [code];
}

class StasislyAuthenticationException implements Exception {
  const StasislyAuthenticationException(this.error);

  final AuthenticationError error;

  @override
  String toString() => error.safeMessage;
}

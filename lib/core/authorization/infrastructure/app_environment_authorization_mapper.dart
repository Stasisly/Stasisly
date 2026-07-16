import 'package:stasisly/core/authorization/domain/authorization_environment.dart';
import 'package:stasisly/core/config/app_environment.dart';

abstract final class AppEnvironmentAuthorizationMapper {
  static AuthorizationEnvironment fromRuntimeMode(AppRuntimeMode mode) {
    return switch (mode) {
      AppRuntimeMode.local => AuthorizationEnvironment.local,
      AppRuntimeMode.demo => AuthorizationEnvironment.demo,
      AppRuntimeMode.development => AuthorizationEnvironment.development,
      AppRuntimeMode.staging => AuthorizationEnvironment.staging,
      AppRuntimeMode.production => AuthorizationEnvironment.production,
      AppRuntimeMode.backendReal => AuthorizationEnvironment.unknown,
    };
  }
}

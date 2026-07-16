import 'package:flutter_test/flutter_test.dart';

import 'package:stasisly/core/authorization/authorization.dart';
import 'package:stasisly/core/config/app_environment.dart';

void main() {
  test('Foundation environments map explicitly', () {
    expect(
      AppEnvironmentAuthorizationMapper.fromRuntimeMode(AppRuntimeMode.local),
      AuthorizationEnvironment.local,
    );
    expect(
      AppEnvironmentAuthorizationMapper.fromRuntimeMode(
        AppRuntimeMode.development,
      ),
      AuthorizationEnvironment.development,
    );
    expect(
      AppEnvironmentAuthorizationMapper.fromRuntimeMode(AppRuntimeMode.staging),
      AuthorizationEnvironment.staging,
    );
    expect(
      AppEnvironmentAuthorizationMapper.fromRuntimeMode(
        AppRuntimeMode.production,
      ),
      AuthorizationEnvironment.production,
    );
  });

  test('legacy backendReal maps to unknown and cannot gain authority', () {
    expect(
      AppEnvironmentAuthorizationMapper.fromRuntimeMode(
        AppRuntimeMode.backendReal,
      ),
      AuthorizationEnvironment.unknown,
    );
  });
}

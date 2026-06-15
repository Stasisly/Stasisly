import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:stasisly/core/config/app_environment.dart';
import 'package:stasisly/core/domain/entities/current_identity.dart';
import 'package:stasisly/core/providers/current_identity_provider.dart';

void main() {
  test('demo mode provides the explicit demo identity', () {
    final container = ProviderContainer(
      overrides: [
        appEnvironmentProvider.overrideWithValue(
          const AppEnvironment(mode: AppRuntimeMode.demo),
        ),
      ],
    );
    addTearDown(container.dispose);

    expect(
      container.read(currentIdentityProvider),
      const CurrentIdentity.demo(),
    );
  });

  test('backend identity remains blocked', () {
    final container = ProviderContainer(
      overrides: [
        appEnvironmentProvider.overrideWithValue(
          const AppEnvironment(
            mode: AppRuntimeMode.backendReal,
            supabaseUrl: 'https://example.invalid',
            supabaseAnonKey: 'public-test-key',
          ),
        ),
      ],
    );
    addTearDown(container.dispose);

    expect(
      () => container.read(currentIdentityProvider),
      throwsA(isA<AppConfigurationException>()),
    );
  });
}

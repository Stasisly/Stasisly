import 'package:stasisly/core/auth/session/real/base_secure_real_session_token_provider.dart';
import 'package:stasisly/core/auth/session/real/secure_real_session_fixtures.dart';
import 'package:stasisly/core/auth/session/real/secure_real_session_guard.dart';

class MockableSecureRealSessionTokenProvider
    extends BaseSecureRealSessionTokenProvider {
  const MockableSecureRealSessionTokenProvider({
    required super.source,
    super.config = SecureRealSessionFixtures.localSafeConfig,
    super.guard = const SecureRealSessionGuard(),
  });
}

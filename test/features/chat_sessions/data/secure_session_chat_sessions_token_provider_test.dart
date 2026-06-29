import 'package:flutter_test/flutter_test.dart';

import 'package:stasisly/core/auth/session/secure_session.dart';
import 'package:stasisly/features/chat_sessions/data/local/secure_session_chat_sessions_token_provider.dart';

void main() {
  const fakeToken = 'fake-chat-sessions-local-token';

  test('success token reaches chat sessions local token provider', () async {
    final provider = _provider(SecureSessionTokenResult.success(fakeToken));

    expect(await provider.readLocalSessionToken(), fakeToken);
  });

  test('non-success secure session states return null', () async {
    final results = [
      const SecureSessionTokenResult.unauthenticated(),
      const SecureSessionTokenResult.expired(),
      const SecureSessionTokenResult.refreshFailed(),
      const SecureSessionTokenResult.backendBlocked(),
      const SecureSessionTokenResult.misconfigured(),
      const SecureSessionTokenResult.demo(),
    ];

    for (final result in results) {
      final provider = _provider(result);

      expect(await provider.readLocalSessionToken(), isNull);
    }
  });

  test('provider exceptions remain safe and return null', () async {
    final provider = SecureSessionChatSessionsTokenProvider(
      adapter: SecureSessionToLocalSessionTokenAdapter(
        tokenProvider: _ThrowingSecureSessionTokenProvider(),
      ),
    );

    expect(await provider.readLocalSessionToken(), isNull);
  });

  test('empty token cannot be represented as success', () {
    expect(
      () => SecureSessionTokenResult.success(''),
      throwsA(isA<ArgumentError>()),
    );
  });

  test('wrapper does not expose token in toString', () {
    final provider = _provider(SecureSessionTokenResult.success(fakeToken));

    expect(provider.toString(), isNot(contains(fakeToken)));
  });
}

SecureSessionChatSessionsTokenProvider _provider(
  SecureSessionTokenResult result,
) {
  return SecureSessionChatSessionsTokenProvider(
    adapter: SecureSessionToLocalSessionTokenAdapter(
      tokenProvider: _FakeSecureSessionTokenProvider(result),
    ),
  );
}

class _FakeSecureSessionTokenProvider implements SecureSessionTokenProvider {
  const _FakeSecureSessionTokenProvider(this.result);

  final SecureSessionTokenResult result;

  @override
  Future<SecureSessionAuthState> currentAuthState() async {
    return const SecureSessionAuthState.unauthenticated();
  }

  @override
  Future<SecureSessionTokenResult> getAccessToken() async {
    return result;
  }

  @override
  Future<SecureSessionTokenResult> refreshIfNeeded() async {
    return result;
  }

  @override
  Future<void> clearSession() async {}
}

class _ThrowingSecureSessionTokenProvider
    implements SecureSessionTokenProvider {
  @override
  Future<SecureSessionAuthState> currentAuthState() async {
    return const SecureSessionAuthState.unauthenticated();
  }

  @override
  Future<SecureSessionTokenResult> getAccessToken() {
    throw StateError('fake secure session failure');
  }

  @override
  Future<SecureSessionTokenResult> refreshIfNeeded() {
    throw StateError('fake secure session failure');
  }

  @override
  Future<void> clearSession() async {}
}

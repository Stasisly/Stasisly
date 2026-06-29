import 'package:flutter_test/flutter_test.dart';

import 'package:stasisly/core/auth/session/adapters/secure_session_to_local_session_token_adapter.dart';
import 'package:stasisly/core/auth/session/secure_session_auth_state.dart';
import 'package:stasisly/core/auth/session/secure_session_token_provider.dart';
import 'package:stasisly/core/auth/session/secure_session_token_result.dart';

void main() {
  group('SecureSessionToLocalSessionTokenAdapter', () {
    test('success with fake non-empty token returns token', () async {
      final provider = _FakeSecureSessionTokenProvider(
        tokenResult: SecureSessionTokenResult.success(_fakeLocalAdapterToken),
      );
      final adapter = SecureSessionToLocalSessionTokenAdapter(
        tokenProvider: provider,
      );

      expect(await adapter.readLocalSessionToken(), _fakeLocalAdapterToken);
      expect(provider.getAccessTokenCalls, 1);
    });

    test('success with empty token is rejected before adapter use', () {
      expect(() => SecureSessionTokenResult.success(''), throwsArgumentError);
    });

    test('non-success results return null without demo fallback', () async {
      final cases = [
        const SecureSessionTokenResult.unauthenticated(),
        const SecureSessionTokenResult.expired(),
        const SecureSessionTokenResult.refreshFailed(),
        const SecureSessionTokenResult.backendBlocked(),
        const SecureSessionTokenResult.misconfigured(),
        const SecureSessionTokenResult.demo(),
      ];

      for (final result in cases) {
        final adapter = SecureSessionToLocalSessionTokenAdapter(
          tokenProvider: _FakeSecureSessionTokenProvider(tokenResult: result),
        );

        expect(
          await adapter.readLocalSessionToken(),
          isNull,
          reason: '${result.status}',
        );
      }
    });

    test('unexpected provider errors return null and never demo', () async {
      final adapter = SecureSessionToLocalSessionTokenAdapter(
        tokenProvider: _ThrowingSecureSessionTokenProvider(),
      );

      expect(await adapter.readLocalSessionToken(), isNull);
    });

    test('adapter does not expose mutable token state', () {
      final adapter = SecureSessionToLocalSessionTokenAdapter(
        tokenProvider: _FakeSecureSessionTokenProvider(
          tokenResult: SecureSessionTokenResult.success(_fakeLocalAdapterToken),
        ),
      );

      expect(adapter.toString(), isNot(contains(_fakeLocalAdapterToken)));
    });
  });
}

const _fakeLocalAdapterToken = 'fake-local-adapter-token';

class _FakeSecureSessionTokenProvider implements SecureSessionTokenProvider {
  _FakeSecureSessionTokenProvider({required this.tokenResult});

  final SecureSessionTokenResult tokenResult;
  int getAccessTokenCalls = 0;

  @override
  Future<SecureSessionAuthState> currentAuthState() async {
    return const SecureSessionAuthState.unauthenticated();
  }

  @override
  Future<SecureSessionTokenResult> getAccessToken() async {
    getAccessTokenCalls += 1;
    return tokenResult;
  }

  @override
  Future<SecureSessionTokenResult> refreshIfNeeded() async {
    return tokenResult;
  }

  @override
  Future<void> clearSession() async {}
}

class _ThrowingSecureSessionTokenProvider
    implements SecureSessionTokenProvider {
  @override
  Future<SecureSessionAuthState> currentAuthState() async {
    throw StateError('fake adapter source unavailable');
  }

  @override
  Future<SecureSessionTokenResult> getAccessToken() async {
    throw StateError('fake adapter source unavailable');
  }

  @override
  Future<SecureSessionTokenResult> refreshIfNeeded() async {
    throw StateError('fake adapter source unavailable');
  }

  @override
  Future<void> clearSession() async {
    throw StateError('fake adapter source unavailable');
  }
}

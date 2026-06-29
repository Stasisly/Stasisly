import 'package:stasisly/core/auth/session/secure_session_token_provider.dart';

final class SecureSessionToLocalSessionTokenAdapter {
  const SecureSessionToLocalSessionTokenAdapter({
    required SecureSessionTokenProvider tokenProvider,
  }) : _tokenProvider = tokenProvider;

  final SecureSessionTokenProvider _tokenProvider;

  Future<String?> readLocalSessionToken() async {
    try {
      final result = await _tokenProvider.getAccessToken();
      if (!result.isSuccess || !result.hasToken) return null;
      return result.token;
    } on Object {
      return null;
    }
  }
}

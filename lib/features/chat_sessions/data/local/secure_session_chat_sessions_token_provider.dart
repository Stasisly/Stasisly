import 'package:stasisly/core/auth/session/secure_session.dart';
import 'package:stasisly/features/chat_sessions/data/local/local_session_token_provider.dart';

final class SecureSessionChatSessionsTokenProvider
    implements LocalSessionTokenProvider {
  const SecureSessionChatSessionsTokenProvider({required this.adapter});

  final SecureSessionToLocalSessionTokenAdapter adapter;

  @override
  Future<String?> readLocalSessionToken() {
    return adapter.readLocalSessionToken();
  }
}

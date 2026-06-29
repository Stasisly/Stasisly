import 'package:stasisly/core/auth/session/secure_session.dart';
import 'package:stasisly/features/chat_messages/data/local/local_session_token_provider.dart';

final class SecureSessionChatMessagesTokenProvider
    implements LocalSessionTokenProvider {
  const SecureSessionChatMessagesTokenProvider({required this.adapter});

  final SecureSessionToLocalSessionTokenAdapter adapter;

  @override
  Future<String?> readLocalSessionToken() {
    return adapter.readLocalSessionToken();
  }
}

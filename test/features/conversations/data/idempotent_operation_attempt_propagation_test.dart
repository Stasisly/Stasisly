import 'package:flutter_test/flutter_test.dart';

import 'package:stasisly/core/idempotency/operation_attempt_id.dart';
import 'package:stasisly/core/identity/domain/authentication_state.dart';
import 'package:stasisly/core/identity/domain/identity_type.dart';
import 'package:stasisly/core/identity/domain/stasisly_identity.dart';
import 'package:stasisly/features/chat_messages/data/datasources/local_http_own_chat_messages_datasource.dart';
import 'package:stasisly/features/chat_messages/data/local/local_only_host_policy.dart'
    as messages_policy;
import 'package:stasisly/features/chat_messages/data/local/local_session_token_provider.dart'
    as messages_token;
import 'package:stasisly/features/chat_messages/data/local/own_chat_messages_http_transport.dart';
import 'package:stasisly/features/chat_sessions/data/datasources/local_http_own_chat_sessions_datasource.dart';
import 'package:stasisly/features/chat_sessions/data/local/local_only_host_policy.dart'
    as sessions_policy;
import 'package:stasisly/features/chat_sessions/data/local/local_session_token_provider.dart'
    as sessions_token;
import 'package:stasisly/features/chat_sessions/data/local/own_chat_sessions_http_transport.dart';
import 'package:stasisly/features/chat_sessions/data/repositories/validating_own_chat_sessions_repository.dart';
import 'package:stasisly/features/conversations/application/inputs/conversation_inputs.dart';
import 'package:stasisly/features/conversations/data/adapters/transitional_conversation_repository_adapter.dart';
import 'package:stasisly/features/conversations/domain/value_objects/conversation_id.dart';

void main() {
  late _SessionTransport sessionTransport;
  late _MessageTransport messageTransport;
  late TransitionalConversationRepositoryAdapter repository;

  setUp(() {
    sessionTransport = _SessionTransport();
    messageTransport = _MessageTransport();
    repository = TransitionalConversationRepositoryAdapter(
      chatSessions: ValidatingOwnChatSessionsRepository(
        source: LocalHttpOwnChatSessionsDataSource(
          baseUri: Uri.parse('http://127.0.0.1:54321'),
          hostPolicy: const sessions_policy.LocalOnlyHostPolicy(
            localValidationEnabled: true,
          ),
          tokenProvider: const _SessionTokenProvider(),
          transport: sessionTransport,
        ),
      ),
      chatMessages: LocalHttpOwnChatMessagesDataSource(
        baseUri: Uri.parse('http://127.0.0.1:54321'),
        hostPolicy: const messages_policy.LocalOnlyHostPolicy(
          localValidationEnabled: true,
        ),
        tokenProvider: const _MessageTokenProvider(),
        transport: messageTransport,
      ),
      trustedOwner: const StasislyIdentity(
        subjectId: 'synthetic-owner',
        identityType: IdentityType.humanUser,
        authenticationState: AuthenticationState.authenticated,
      ),
    );
  });

  test(
    'create propagates one stable attempt through every local layer',
    () async {
      final attempt = OperationAttemptId('create_attempt_000001');
      final input = CreateConversationInput(
        selectableSpecialistId: 'catalog-public',
        operationAttemptId: attempt,
      );

      await repository.createOwnConversation(input);
      await repository.createOwnConversation(input);

      expect(sessionTransport.requests, hasLength(2));
      expect(
        sessionTransport.requests.map(
          (request) => request.headers['Idempotency-Key'],
        ),
        everyElement(attempt.value),
      );
    },
  );

  test(
    'send propagates one stable attempt through every local layer',
    () async {
      final attempt = OperationAttemptId('send_attempt_0000001');
      final input = SendConversationMessageInput(
        conversationId: ConversationId('conversation-1'),
        content: 'synthetic content',
        operationAttemptId: attempt,
      );

      await repository.sendOwnConversationMessage(input);
      await repository.sendOwnConversationMessage(input);

      expect(messageTransport.requests, hasLength(2));
      expect(
        messageTransport.requests.map(
          (request) => request.headers['Idempotency-Key'],
        ),
        everyElement(attempt.value),
      );
    },
  );
}

class _SessionTokenProvider
    implements sessions_token.LocalSessionTokenProvider {
  const _SessionTokenProvider();

  @override
  Future<String?> readLocalSessionToken() async => 'synthetic-token';
}

class _MessageTokenProvider
    implements messages_token.LocalSessionTokenProvider {
  const _MessageTokenProvider();

  @override
  Future<String?> readLocalSessionToken() async => 'synthetic-token';
}

class _SessionTransport implements OwnChatSessionsHttpTransport {
  final List<OwnChatSessionsHttpRequest> requests = [];

  @override
  Future<OwnChatSessionsHttpResponse> send(
    OwnChatSessionsHttpRequest request,
  ) async {
    requests.add(request);
    return const OwnChatSessionsHttpResponse(statusCode: 503, body: null);
  }
}

class _MessageTransport implements OwnChatMessagesHttpTransport {
  final List<OwnChatMessagesHttpRequest> requests = [];

  @override
  Future<OwnChatMessagesHttpResponse> send(
    OwnChatMessagesHttpRequest request,
  ) async {
    requests.add(request);
    return const OwnChatMessagesHttpResponse(statusCode: 503, body: null);
  }
}

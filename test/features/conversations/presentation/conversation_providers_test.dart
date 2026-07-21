import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stasisly/core/config/app_environment.dart';
import 'package:stasisly/core/idempotency/operation_attempt_id.dart';
import 'package:stasisly/features/chat_messages/data/repositories/backend_blocked_own_chat_messages_repository.dart';
import 'package:stasisly/features/chat_messages/presentation/providers/own_chat_messages_providers.dart';
import 'package:stasisly/features/chat_sessions/data/repositories/backend_blocked_own_chat_sessions_repository.dart';
import 'package:stasisly/features/chat_sessions/presentation/providers/own_chat_sessions_providers.dart';
import 'package:stasisly/features/conversations/composition/conversation_providers.dart';
import 'package:stasisly/features/conversations/data/adapters/transitional_conversation_repository_adapter.dart';
import 'package:stasisly/features/conversations/data/repositories/fail_closed_conversation_repository.dart';
import 'package:stasisly/features/conversations/domain/results/conversation_results.dart';

import '../support/conversation_test_support.dart';

void main() {
  group('canonical provider composition', () {
    test('local and development permit explicit canonical composition', () {
      for (final mode in [AppRuntimeMode.local, AppRuntimeMode.development]) {
        final container = ProviderContainer(
          overrides: [
            appEnvironmentProvider.overrideWithValue(
              AppEnvironment(mode: mode),
            ),
            conversationTrustedIdentityProvider.overrideWithValue(testIdentity),
            ownChatSessionsRepositoryProvider.overrideWithValue(
              const BackendBlockedOwnChatSessionsRepository(),
            ),
            ownChatMessagesRepositoryProvider.overrideWithValue(
              const BackendBlockedOwnChatMessagesRepository(),
            ),
          ],
        );
        addTearDown(container.dispose);

        expect(
          container.read(conversationCompositionAvailabilityProvider),
          ConversationCompositionAvailability.available,
        );
        expect(
          container.read(conversationRepositoryProvider),
          isA<TransitionalConversationRepositoryAdapter>(),
        );
      }
    });

    for (final mode in [
      AppRuntimeMode.demo,
      AppRuntimeMode.staging,
      AppRuntimeMode.production,
      AppRuntimeMode.backendReal,
    ]) {
      test('$mode is fail-closed without fallback', () async {
        final container = ProviderContainer(
          overrides: [
            appEnvironmentProvider.overrideWithValue(
              AppEnvironment(mode: mode),
            ),
          ],
        );
        addTearDown(container.dispose);
        final repository = container.read(conversationRepositoryProvider);
        expect(repository, isA<FailClosedConversationRepository>());
        expect(
          await repository.listOwnConversations(),
          const ConversationListFailure(
            ConversationResultStatus.environmentBlocked,
          ),
        );
      });
    }

    test(
      'allowed environment without trusted session is unauthenticated',
      () async {
        final container = ProviderContainer(
          overrides: [
            appEnvironmentProvider.overrideWithValue(
              const AppEnvironment(mode: AppRuntimeMode.local),
            ),
            conversationTrustedIdentityProvider.overrideWithValue(null),
          ],
        );
        addTearDown(container.dispose);
        final repository = container.read(conversationRepositoryProvider);
        expect(
          await repository.listOwnConversations(),
          const ConversationListFailure(
            ConversationResultStatus.unauthenticated,
          ),
        );
      },
    );

    test('OperationAttemptIdFactory remains explicitly injectable', () {
      final factory = _FixedAttemptFactory();
      final container = ProviderContainer(
        overrides: [
          conversationOperationAttemptIdFactoryProvider.overrideWithValue(
            factory,
          ),
        ],
      );
      addTearDown(container.dispose);
      expect(
        container.read(conversationOperationAttemptIdFactoryProvider),
        same(factory),
      );
    });

    test('unknown runtime names fail before provider composition', () {
      expect(
        () => AppEnvironment.parseMode('unknown'),
        throwsA(isA<AppConfigurationException>()),
      );
    });
  });
}

class _FixedAttemptFactory implements OperationAttemptIdFactory {
  @override
  OperationAttemptId create() => OperationAttemptId('fixed_attempt_000001');
}

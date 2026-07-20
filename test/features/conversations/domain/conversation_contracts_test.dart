import 'package:flutter_test/flutter_test.dart';
import 'package:stasisly/core/idempotency/operation_attempt_id.dart';
import 'package:stasisly/core/identity/domain/authentication_state.dart';
import 'package:stasisly/core/identity/domain/identity_type.dart';
import 'package:stasisly/core/identity/domain/stasisly_identity.dart';
import 'package:stasisly/features/conversations/application/inputs/conversation_inputs.dart';
import 'package:stasisly/features/conversations/domain/entities/conversation.dart';
import 'package:stasisly/features/conversations/domain/entities/conversation_message.dart';
import 'package:stasisly/features/conversations/domain/results/conversation_results.dart';
import 'package:stasisly/features/conversations/domain/value_objects/conversation_id.dart';

void main() {
  const authenticatedOwner = StasislyIdentity(
    subjectId: 'subject-1',
    identityType: IdentityType.humanUser,
    authenticationState: AuthenticationState.authenticated,
  );

  group('ConversationId', () {
    test('is opaque and does not assume UUID format', () {
      expect(
        ConversationId(' conversation-public ').value,
        'conversation-public',
      );
      expect(ConversationId.tryParse('opaque:future:1'), isNotNull);
    });

    test('rejects empty and control-character values', () {
      expect(() => ConversationId('  '), throwsArgumentError);
      expect(() => ConversationId('unsafe\nvalue'), throwsArgumentError);
      expect(ConversationId.tryParse(''), isNull);
    });
  });

  group('Conversation lifecycle and ownership', () {
    test('active and archived have explicit mutation behavior', () {
      expect(ConversationStatus.active.allowsNormalMutation, isTrue);
      expect(ConversationStatus.archived.allowsNormalMutation, isFalse);
      expect(ConversationStatus.pendingDeletion.allowsNormalMutation, isFalse);
    });

    test('unknown lifecycle fails closed', () {
      final unknown = ConversationStatus.parseOrUnknown('future-state');

      expect(unknown, ConversationStatus.unknown);
      expect(unknown.failsClosed, isTrue);
      expect(unknown.allowsNormalMutation, isFalse);
    });

    test('owner can only be derived from an authenticated identity', () {
      final conversation = Conversation.fromTrustedIdentity(
        conversationId: ConversationId('conversation-1'),
        ownerIdentity: authenticatedOwner,
        status: ConversationStatus.active,
        createdAt: DateTime.utc(2026),
        updatedAt: DateTime.utc(2026, 1, 2),
      );

      expect(conversation.ownerSubjectId, 'subject-1');
      expect(
        () => Conversation.fromTrustedIdentity(
          conversationId: ConversationId('conversation-1'),
          ownerIdentity: const StasislyIdentity(
            subjectId: 'subject-1',
            identityType: IdentityType.humanUser,
            authenticationState: AuthenticationState.unauthenticated,
          ),
          status: ConversationStatus.active,
          createdAt: DateTime.utc(2026),
          updatedAt: DateTime.utc(2026),
        ),
        throwsA(isA<ConversationOwnershipException>()),
      );
    });

    test('unknown lifecycle cannot construct a Conversation', () {
      expect(
        () => Conversation.fromTrustedIdentity(
          conversationId: ConversationId('conversation-1'),
          ownerIdentity: authenticatedOwner,
          status: ConversationStatus.unknown,
          createdAt: DateTime.utc(2026),
          updatedAt: DateTime.utc(2026),
        ),
        throwsA(isA<ConversationContractException>()),
      );
    });
  });

  group('ConversationMessage and Product inputs', () {
    test('message content is trimmed and bounded', () {
      final message = ConversationMessage(
        messageId: 'message-1',
        conversationId: ConversationId('conversation-1'),
        author: const UserAuthor(),
        content: ' Hola ',
        createdAt: DateTime.utc(2026),
        status: ConversationMessageStatus.accepted,
        provenance: ConversationMessageProvenance.userProvided,
        visibility: ConversationMessageVisibility.productVisible,
      );

      expect(message.content, 'Hola');
      expect(message.isDisplaySafe, isTrue);
      expect(
        () => ConversationMessage(
          messageId: 'message-2',
          conversationId: ConversationId('conversation-1'),
          author: const UserAuthor(),
          content: ' ',
          createdAt: DateTime.utc(2026),
          status: ConversationMessageStatus.accepted,
          provenance: ConversationMessageProvenance.userProvided,
          visibility: ConversationMessageVisibility.productVisible,
        ),
        throwsArgumentError,
      );
    });

    test('unknown author and internal visibility fail closed', () {
      expect(
        () => ConversationMessage(
          messageId: 'message-1',
          conversationId: ConversationId('conversation-1'),
          author: const UnknownAuthor(),
          content: 'Persisted but ambiguous',
          createdAt: DateTime.utc(2026),
          status: ConversationMessageStatus.accepted,
          provenance: ConversationMessageProvenance.unknown,
          visibility: ConversationMessageVisibility.internal,
        ),
        throwsArgumentError,
      );
    });

    test('inputs expose only allowlisted Product fields', () {
      final createAttempt = OperationAttemptId('test_attempt_00000001');
      final sendAttempt = OperationAttemptId('test_attempt_00000002');
      final create = CreateConversationInput(
        selectableSpecialistId: 'catalog-public',
        operationAttemptId: createAttempt,
      );
      final list = ListConversationMessagesInput(
        conversationId: ConversationId('conversation-1'),
        limit: 25,
        cursor: ' cursor-1 ',
      );
      final send = SendConversationMessageInput(
        conversationId: ConversationId('conversation-1'),
        content: ' Hola ',
        operationAttemptId: sendAttempt,
      );

      expect(create.props, ['catalog-public', createAttempt]);
      expect(list.props, [ConversationId('conversation-1'), 25, 'cursor-1']);
      expect(send.props, [
        ConversationId('conversation-1'),
        'Hola',
        sendAttempt,
      ]);
      expect(
        () => ListConversationMessagesInput(
          conversationId: ConversationId('conversation-1'),
          limit: 101,
        ),
        throwsArgumentError,
      );
    });

    test('results use provider-neutral status vocabulary', () {
      expect(
        ConversationResultStatus.values.map((status) => status.name),
        containsAll([
          'success',
          'unauthenticated',
          'unauthorized',
          'notFound',
          'invalidInput',
          'archived',
          'environmentBlocked',
          'backendUnavailable',
          'contractViolation',
          'unknownFailure',
        ]),
      );
    });
  });
}

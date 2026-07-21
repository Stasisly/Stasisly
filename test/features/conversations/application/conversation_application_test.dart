import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:stasisly/features/conversations/application/controllers/conversation_create_controller.dart';
import 'package:stasisly/features/conversations/application/controllers/conversation_detail_controller.dart';
import 'package:stasisly/features/conversations/application/controllers/conversation_list_controller.dart';
import 'package:stasisly/features/conversations/application/inputs/conversation_inputs.dart';
import 'package:stasisly/features/conversations/application/state/conversation_application_states.dart';
import 'package:stasisly/features/conversations/application/use_cases/conversation_use_cases.dart';
import 'package:stasisly/features/conversations/domain/entities/conversation.dart';
import 'package:stasisly/features/conversations/domain/results/conversation_results.dart';
import 'package:stasisly/features/conversations/domain/value_objects/conversation_id.dart';

import '../support/conversation_test_support.dart';

void main() {
  group('canonical use cases', () {
    test('delegate all seven typed operations unchanged', () async {
      final repository = FakeConversationRepository();
      final attemptFactory = SequenceOperationAttemptIdFactory();
      final attempt = attemptFactory.create();

      await ListOwnConversations(repository)(
        status: ConversationStatusFilter.archived,
        limit: 7,
        cursor: 'opaque-cursor',
      );
      await ReadOwnConversation(repository)(ConversationId('conversation-1'));
      await CreateOwnConversation(repository)(
        CreateConversationInput(
          operationAttemptId: attempt,
          selectableSpecialistId: 'specialist-public-1',
        ),
      );
      await ArchiveOwnConversation(repository)(
        ArchiveConversationInput(
          conversationId: ConversationId('conversation-1'),
        ),
      );
      await RestoreOwnConversation(repository)(
        RestoreConversationInput(
          conversationId: ConversationId('conversation-1'),
        ),
      );
      await ListOwnConversationMessages(repository)(
        ListConversationMessagesInput(
          conversationId: ConversationId('conversation-1'),
        ),
      );
      await SendOwnConversationMessage(repository)(
        SendConversationMessageInput(
          conversationId: ConversationId('conversation-1'),
          operationAttemptId: attempt,
          content: 'contenido',
        ),
      );

      expect(repository.listStatuses, [ConversationStatusFilter.archived]);
      expect(repository.listCursors, ['opaque-cursor']);
      expect(repository.createInputs.single.operationAttemptId, same(attempt));
      expect(repository.sendInputs.single.operationAttemptId, same(attempt));
      expect(repository.archiveCalls, 1);
      expect(repository.restoreCalls, 1);
      expect(repository.messageCalls, 1);
    });

    for (final status in [
      ConversationResultStatus.unauthenticated,
      ConversationResultStatus.environmentBlocked,
      ConversationResultStatus.idempotencyConflict,
      ConversationResultStatus.contractViolation,
    ]) {
      test('preserves typed failure $status', () async {
        final repository = FakeConversationRepository()
          ..listResult = ConversationListFailure(status);
        final result = await ListOwnConversations(repository)(
          status: ConversationStatusFilter.active,
        );
        expect(result, ConversationListFailure(status));
      });
    }
  });

  group('ConversationListController', () {
    test('loads, refreshes, changes filter and resets cursor', () async {
      final repository = FakeConversationRepository()
        ..listResult = ConversationListSuccess(
          ConversationPage(items: [conversation()], nextCursor: 'next'),
        );
      final phases = <ConversationListPhase>[];
      final controller = ConversationListController(
        listOwnConversations: ListOwnConversations(repository),
        onStateChanged: (state) => phases.add(state.phase),
      );

      await controller.loadInitial();
      expect(phases.take(2), [
        ConversationListPhase.loading,
        ConversationListPhase.data,
      ]);
      expect(controller.state.hasMore, isTrue);

      await controller.refresh();
      expect(phases, contains(ConversationListPhase.refreshing));

      repository.listResult = ConversationListSuccess(
        ConversationPage(
          items: [conversation(status: ConversationStatus.archived)],
          nextCursor: null,
        ),
      );
      await controller.changeFilter(ConversationListFilter.archived);
      expect(controller.state.filter, ConversationListFilter.archived);
      expect(repository.listCursors.last, isNull);
      expect(repository.listStatuses.last, ConversationStatusFilter.archived);
    });

    test('appends in backend order and deduplicates ConversationId', () async {
      final repository = FakeConversationRepository()
        ..listResult = ConversationListSuccess(
          ConversationPage(
            items: [
              conversation(id: 'one'),
              conversation(id: 'two'),
            ],
            nextCursor: 'next',
          ),
        );
      final controller = ConversationListController(
        listOwnConversations: ListOwnConversations(repository),
      );
      await controller.loadInitial();
      repository.listResult = ConversationListSuccess(
        ConversationPage(
          items: [
            conversation(id: 'two'),
            conversation(id: 'three'),
          ],
          nextCursor: null,
        ),
      );
      await controller.loadMore();
      expect(
        controller.state.conversations.map((item) => item.conversationId.value),
        ['one', 'two', 'three'],
      );
    });

    test('ignores stale result after filter generation changes', () async {
      final active = Completer<ConversationListResult>();
      final repository = FakeConversationRepository()
        ..onList = (status, _, _) async {
          if (status == ConversationStatusFilter.active) return active.future;
          return ConversationListSuccess(
            ConversationPage(
              items: [conversation(status: ConversationStatus.archived)],
              nextCursor: null,
            ),
          );
        };
      final controller = ConversationListController(
        listOwnConversations: ListOwnConversations(repository),
      );
      final first = controller.loadInitial();
      await controller.changeFilter(ConversationListFilter.archived);
      active.complete(
        ConversationListSuccess(
          ConversationPage(items: [conversation()], nextCursor: null),
        ),
      );
      await first;
      expect(controller.state.filter, ConversationListFilter.archived);
      expect(
        controller.state.conversations.single.status,
        ConversationStatus.archived,
      );
    });

    test('maps empty and safe failures', () async {
      final repository = FakeConversationRepository();
      final controller = ConversationListController(
        listOwnConversations: ListOwnConversations(repository),
      );
      await controller.loadInitial();
      expect(controller.state.phase, ConversationListPhase.empty);
      repository.listResult = const ConversationListFailure(
        ConversationResultStatus.environmentBlocked,
      );
      await controller.refresh();
      expect(controller.state.phase, ConversationListPhase.environmentBlocked);
      expect(
        controller.state.error,
        ConversationApplicationErrorCode.environmentBlocked,
      );
    });
  });

  group('create intent coordination', () {
    test(
      'same retry preserves attempt and specialist change creates one',
      () async {
        final repository = FakeConversationRepository()
          ..createResult = const ConversationMutationFailure(
            ConversationResultStatus.backendUnavailable,
          );
        final factory = SequenceOperationAttemptIdFactory();
        final controller = ConversationCreateController(
          createOwnConversation: CreateOwnConversation(repository),
          operationAttemptIds: factory,
        );

        await controller.create('specialist-one');
        await controller.retry();
        expect(repository.createInputs, hasLength(2));
        expect(
          repository.createInputs.first.operationAttemptId,
          same(repository.createInputs.last.operationAttemptId),
        );
        expect(factory.count, 1);

        await controller.create('specialist-two');
        expect(factory.count, 2);
        expect(
          repository.createInputs.last.operationAttemptId,
          isNot(repository.createInputs.first.operationAttemptId),
        );
      },
    );

    test('double submit has one effect and conflict is explicit', () async {
      final completer = Completer<ConversationMutationResult>();
      final repository = FakeConversationRepository()
        ..onCreate = (_) => completer.future;
      final controller = ConversationCreateController(
        createOwnConversation: CreateOwnConversation(repository),
        operationAttemptIds: SequenceOperationAttemptIdFactory(),
      );
      final first = controller.create('specialist-one');
      final second = controller.create('specialist-one');
      completer.complete(
        const ConversationMutationFailure(
          ConversationResultStatus.idempotencyConflict,
        ),
      );
      await Future.wait([first, second]);
      expect(repository.createInputs, hasLength(1));
      expect(
        controller.state.error,
        ConversationApplicationErrorCode.idempotencyConflict,
      );
    });
  });

  group('ConversationDetailController', () {
    ConversationDetailController build(
      FakeConversationRepository repository,
      SequenceOperationAttemptIdFactory factory, {
      void Function()? invalidated,
      void Function(ConversationDetailState)? changed,
    }) => ConversationDetailController(
      conversationId: ConversationId('conversation-1'),
      readOwnConversation: ReadOwnConversation(repository),
      listOwnConversationMessages: ListOwnConversationMessages(repository),
      sendOwnConversationMessage: SendOwnConversationMessage(repository),
      archiveOwnConversation: ArchiveOwnConversation(repository),
      restoreOwnConversation: RestoreOwnConversation(repository),
      operationAttemptIds: factory,
      onListsInvalidated: invalidated,
      onStateChanged: changed,
    );

    test('loads detail and first message page', () async {
      final repository = FakeConversationRepository();
      final controller = build(repository, SequenceOperationAttemptIdFactory());
      await controller.load();
      expect(controller.state.phase, ConversationDetailPhase.active);
      expect(controller.state.messages.phase, ConversationMessagesPhase.data);
      expect(controller.state.messages.messages.single.messageId, 'message-1');
    });

    test('same-intent retry keeps attempt; edit creates new attempt', () async {
      final repository = FakeConversationRepository()
        ..sendResult = const ConversationMessageSendFailure(
          ConversationResultStatus.backendUnavailable,
        );
      final factory = SequenceOperationAttemptIdFactory();
      final controller = build(repository, factory);
      await controller.load();
      controller.updateDraft('mensaje uno');
      await controller.send();
      await controller.retrySend();
      expect(repository.sendInputs, hasLength(2));
      expect(
        repository.sendInputs.first.operationAttemptId,
        same(repository.sendInputs.last.operationAttemptId),
      );

      controller.updateDraft('mensaje dos');
      await controller.send();
      expect(factory.count, 2);
      expect(
        repository.sendInputs.last.operationAttemptId,
        isNot(repository.sendInputs.first.operationAttemptId),
      );
    });

    test(
      'success deduplicates replay and clears only matching draft',
      () async {
        final completer = Completer<ConversationMessageSendResult>();
        final repository = FakeConversationRepository()
          ..onSend = (_) => completer.future;
        final controller = build(
          repository,
          SequenceOperationAttemptIdFactory(),
        );
        await controller.load();
        controller.updateDraft('original');
        final send = controller.send();
        controller.updateDraft('editado durante envío');
        completer.complete(
          ConversationMessageSendSuccess(
            ConversationMessageSendReceipt(
              message: message(id: 'message-2'),
              messageCount: 1,
              lastMessageAt: DateTime.utc(2026, 1, 2),
            ),
          ),
        );
        await send;
        expect(controller.state.composer.draft, 'editado durante envío');
        expect(controller.state.messages.messages, hasLength(2));
      },
    );

    test(
      'archived send is denied before repository and history remains',
      () async {
        final repository = FakeConversationRepository()
          ..readResult = ConversationReadSuccess(
            conversation(status: ConversationStatus.archived),
          );
        final controller = build(
          repository,
          SequenceOperationAttemptIdFactory(),
        );
        await controller.load();
        controller.updateDraft('no enviar');
        await controller.send();
        expect(repository.sendInputs, isEmpty);
        expect(controller.state.messages.messages, isNotEmpty);
        expect(
          controller.state.composer.error,
          ConversationApplicationErrorCode.archived,
        );
      },
    );

    test(
      'archive/restore update state, invalidate lists and block archive during send',
      () async {
        var invalidations = 0;
        final sendCompleter = Completer<ConversationMessageSendResult>();
        final repository = FakeConversationRepository()
          ..onSend = (_) => sendCompleter.future;
        final controller = build(
          repository,
          SequenceOperationAttemptIdFactory(),
          invalidated: () => invalidations += 1,
        );
        await controller.load();
        controller.updateDraft('en curso');
        final send = controller.send();
        await controller.archive();
        expect(repository.archiveCalls, 0);
        sendCompleter.complete(repository.sendResult);
        await send;
        await controller.archive();
        expect(controller.state.phase, ConversationDetailPhase.archived);
        await controller.restore();
        expect(controller.state.phase, ConversationDetailPhase.active);
        expect(invalidations, 2);
      },
    );

    test('new id and dispose ignore late read results', () async {
      final first = Completer<ConversationReadResult>();
      final repository = FakeConversationRepository()
        ..onRead = (id) async {
          if (id.value == 'conversation-1') return first.future;
          return ConversationReadSuccess(conversation(id: id.value));
        }
        ..onMessages = (input) async => const ConversationMessageListSuccess(
          ConversationMessagePage(items: [], nextCursor: null),
        );
      final emitted = <ConversationDetailState>[];
      final controller = build(
        repository,
        SequenceOperationAttemptIdFactory(),
        changed: emitted.add,
      );
      final oldLoad = controller.load();
      await controller.openConversation(ConversationId('conversation-2'));
      first.complete(ConversationReadSuccess(conversation()));
      await oldLoad;
      expect(controller.conversationId.value, 'conversation-2');
      expect(
        controller.state.conversation?.conversationId.value,
        'conversation-2',
      );
      final count = emitted.length;
      controller.dispose();
      await controller.load();
      expect(emitted, hasLength(count));
    });
  });
}

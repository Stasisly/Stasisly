import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:stasisly/core/observability/conversation_observability.dart';
import 'package:stasisly/features/conversations/application/controllers/conversation_detail_controller.dart';
import 'package:stasisly/features/conversations/application/controllers/conversation_list_controller.dart';
import 'package:stasisly/features/conversations/application/state/conversation_application_states.dart';
import 'package:stasisly/features/conversations/application/use_cases/conversation_use_cases.dart';
import 'package:stasisly/features/conversations/domain/entities/conversation.dart';
import 'package:stasisly/features/conversations/domain/results/conversation_results.dart';
import 'package:stasisly/features/conversations/domain/value_objects/conversation_id.dart';

import '../support/conversation_test_support.dart';

void main() {
  test('observation contract has no free-form payload fields', () {
    final source = File(
      'lib/core/observability/conversation_observability.dart',
    ).readAsStringSync();

    expect(source, isNot(contains('final String')));
    expect(source, isNot(contains('Map<')));
    const event = ConversationObservation(
      event: ConversationObservabilityEventName.messageSendFailed,
      category: ConversationObservationCategory.send,
      result: ConversationObservationResult.backendUnavailable,
      route: ConversationObservedRoute.conversationDetail,
      environment: ConversationObservedEnvironment.local,
      duration: ConversationDurationBucket.under100Milliseconds,
      itemCount: ConversationItemCountBucket.oneToTwenty,
      retry: ConversationRetryClass.userInitiated,
      error: ConversationSafeErrorCode.backendUnavailable,
    );
    expect(event.surface, ConversationObservedSurface.product);
  });

  test(
    'list records buckets, stale responses and preserves loaded data',
    () async {
      final active = Completer<ConversationListResult>();
      var activeCalls = 0;
      final repository = FakeConversationRepository()
        ..onList = (status, _, _) async {
          if (status == ConversationStatusFilter.active && activeCalls++ == 0) {
            return active.future;
          }
          if (status == ConversationStatusFilter.archived) {
            return ConversationListSuccess(
              ConversationPage(
                items: [conversation(status: ConversationStatus.archived)],
                nextCursor: null,
              ),
            );
          }
          return const ConversationListFailure(
            ConversationResultStatus.backendUnavailable,
          );
        };
      final sink = InMemoryConversationObservabilitySink();
      final controller = ConversationListController(
        listOwnConversations: ListOwnConversations(repository),
        observability: sink,
        observedEnvironment: ConversationObservedEnvironment.local,
      );

      final initial = controller.loadInitial();
      await controller.changeFilter(ConversationListFilter.archived);
      active.complete(
        ConversationListSuccess(
          ConversationPage(items: [conversation()], nextCursor: null),
        ),
      );
      await initial;
      repository.onList = (_, _, _) async => const ConversationListFailure(
        ConversationResultStatus.backendUnavailable,
      );
      await controller.refresh();

      expect(controller.state.conversations, isNotEmpty);
      expect(
        sink.observations.map((event) => event.event),
        containsAll([
          ConversationObservabilityEventName.conversationListRequested,
          ConversationObservabilityEventName.conversationListSucceeded,
          ConversationObservabilityEventName.conversationListFailed,
        ]),
      );
      expect(
        sink.observations
            .firstWhere(
              (event) =>
                  event.event ==
                  ConversationObservabilityEventName.conversationListSucceeded,
            )
            .itemCount,
        ConversationItemCountBucket.oneToTwenty,
      );
    },
  );

  test('send replay is classified and rapid submits have one effect', () async {
    final firstSend = Completer<ConversationMessageSendResult>();
    var calls = 0;
    final repository = FakeConversationRepository()
      ..onSend = (_) {
        calls += 1;
        if (calls == 1) return firstSend.future;
        return Future.value(FakeConversationRepository().sendResult);
      };
    final sink = InMemoryConversationObservabilitySink();
    final controller = _detail(repository, sink);
    await controller.load();
    controller.updateDraft('contenido sintético');

    final sends = List.generate(20, (_) => controller.send());
    firstSend.complete(
      const ConversationMessageSendFailure(
        ConversationResultStatus.backendUnavailable,
      ),
    );
    await Future.wait(sends);
    expect(repository.sendInputs, hasLength(1));

    await controller.retrySend();
    expect(repository.sendInputs, hasLength(2));
    expect(
      sink.observations.any(
        (event) =>
            event.event ==
                ConversationObservabilityEventName.messageSendSucceeded &&
            event.retry == ConversationRetryClass.userInitiated,
      ),
      isTrue,
    );
  });

  test(
    'message page failure retains existing history and pagination',
    () async {
      final repository = FakeConversationRepository()
        ..messagesResult = ConversationMessageListSuccess(
          ConversationMessagePage(items: [message()], nextCursor: 'next'),
        );
      final sink = InMemoryConversationObservabilitySink();
      final controller = _detail(repository, sink);
      await controller.load();
      repository.messagesResult = const ConversationMessageListFailure(
        ConversationResultStatus.backendUnavailable,
      );

      await controller.loadMoreMessages();

      expect(controller.state.messages.messages, hasLength(1));
      expect(controller.state.messages.nextCursor, 'next');
      expect(controller.state.messages.phase, ConversationMessagesPhase.data);
      expect(
        sink.observations.map((event) => event.event),
        contains(ConversationObservabilityEventName.paginationCompleted),
      );
    },
  );

  test('repeated retry and lifecycle cycles remain deterministic', () async {
    var sendCall = 0;
    final repository = FakeConversationRepository()
      ..onSend = (_) async {
        sendCall += 1;
        if (sendCall.isOdd) {
          return const ConversationMessageSendFailure(
            ConversationResultStatus.backendUnavailable,
          );
        }
        return FakeConversationRepository().sendResult;
      };
    final sink = InMemoryConversationObservabilitySink();
    final controller = _detail(repository, sink);
    await controller.load();

    for (var index = 0; index < 20; index += 1) {
      controller.updateDraft('sintético $index');
      await controller.send();
      await controller.retrySend();
      await controller.archive();
      await controller.restore();
    }

    expect(repository.sendInputs, hasLength(40));
    expect(repository.archiveCalls, 20);
    expect(repository.restoreCalls, 20);
    expect(controller.state.isArchived, isFalse);
    expect(
      sink.observations
          .where(
            (event) =>
                event.event ==
                ConversationObservabilityEventName.messageSendSucceeded,
          )
          .length,
      20,
    );
  });

  test('fifty filter switches remain bounded and current', () async {
    final repository = FakeConversationRepository()
      ..onList = (filter, _, _) async => ConversationListSuccess(
        ConversationPage(
          items: [
            conversation(
              status: filter == ConversationStatusFilter.active
                  ? ConversationStatus.active
                  : ConversationStatus.archived,
            ),
          ],
          nextCursor: null,
        ),
      );
    final sink = InMemoryConversationObservabilitySink();
    final controller = ConversationListController(
      listOwnConversations: ListOwnConversations(repository),
      observability: sink,
    );
    await controller.loadInitial();

    for (var index = 0; index < 50; index += 1) {
      await controller.changeFilter(
        index.isEven
            ? ConversationListFilter.archived
            : ConversationListFilter.active,
      );
    }

    expect(controller.state.conversations, hasLength(1));
    expect(repository.listStatuses, hasLength(51));
    expect(sink.observations.length, 102);
  });

  test(
    'unauthorized provider result stays sanitized and non-throwing',
    () async {
      final repository = FakeConversationRepository()
        ..listResult = const ConversationListFailure(
          ConversationResultStatus.unauthorized,
        );
      final sink = InMemoryConversationObservabilitySink();
      final controller = ConversationListController(
        listOwnConversations: ListOwnConversations(repository),
        observability: sink,
      );

      await controller.loadInitial();

      expect(
        controller.state.error,
        ConversationApplicationErrorCode.unauthorized,
      );
      expect(
        sink.observations.last.result,
        ConversationObservationResult.unknownFailure,
      );
      expect(
        sink.observations.last.error,
        ConversationSafeErrorCode.unauthorized,
      );
    },
  );
}

ConversationDetailController _detail(
  FakeConversationRepository repository,
  ConversationObservabilitySink sink,
) {
  return ConversationDetailController(
    conversationId: ConversationId('conversation-1'),
    readOwnConversation: ReadOwnConversation(repository),
    listOwnConversationMessages: ListOwnConversationMessages(repository),
    sendOwnConversationMessage: SendOwnConversationMessage(repository),
    archiveOwnConversation: ArchiveOwnConversation(repository),
    restoreOwnConversation: RestoreOwnConversation(repository),
    operationAttemptIds: SequenceOperationAttemptIdFactory(),
    observability: sink,
    observedEnvironment: ConversationObservedEnvironment.local,
  );
}

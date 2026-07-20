import 'package:flutter_test/flutter_test.dart';

import 'package:stasisly/core/idempotency/operation_attempt_id.dart';
import 'package:stasisly/features/chat_sessions/data/repositories/demo_own_chat_sessions_repository.dart';
import 'package:stasisly/features/chat_sessions/domain/entities/own_chat_session.dart';
import 'package:stasisly/features/chat_sessions/domain/entities/own_chat_session_results.dart';

final _attempt = OperationAttemptId('test_attempt_00000001');

void main() {
  late DemoOwnChatSessionsRepository repository;

  setUp(() {
    repository = DemoOwnChatSessionsRepository();
  });

  test('creates a distinct explicit demo session on every call', () async {
    final first = await repository.createOwnChatSession(
      selectableSpecialistId: 'catalog-demo',
      operationAttemptId: _attempt,
    );
    final second = await repository.createOwnChatSession(
      selectableSpecialistId: 'catalog-demo',
      operationAttemptId: _attempt,
    );

    expect(first, isA<CreateOwnChatSessionDemo>());
    expect(second, isA<CreateOwnChatSessionDemo>());
    expect(
      (first as CreateOwnChatSessionDemo).session.sessionId,
      isNot((second as CreateOwnChatSessionDemo).session.sessionId),
    );
    expect(first.session.messageCount, 0);
    expect(second.session.messageCount, 0);
  });

  test('lists active by default and paginates with opaque cursor', () async {
    for (var index = 0; index < 3; index++) {
      await repository.createOwnChatSession(
        selectableSpecialistId: 'catalog-$index',
        operationAttemptId: _attempt,
      );
    }

    final first = await repository.listOwnChatSessions(limit: 2);
    final firstPage = (first as ListOwnChatSessionsDemo).page;
    final second = await repository.listOwnChatSessions(
      limit: 2,
      cursor: firstPage.nextCursor,
    );

    expect(firstPage.items, hasLength(2));
    expect(firstPage.nextCursor, isNotNull);
    expect((second as ListOwnChatSessionsDemo).page.items, hasLength(1));
    expect(
      firstPage.items.every((item) => item.status == ChatSessionStatus.active),
      isTrue,
    );
  });

  test('archives only status and preserves conversation timestamps', () async {
    final created = await repository.createOwnChatSession(
      selectableSpecialistId: 'catalog-demo',
      operationAttemptId: _attempt,
    );
    final original = (created as CreateOwnChatSessionDemo).session;

    final result = await repository.archiveOwnChatSession(
      sessionId: original.sessionId,
    );
    final listed = await repository.listOwnChatSessions(
      status: ChatSessionStatusFilter.archived,
    );
    final archived = (listed as ListOwnChatSessionsDemo).page.items.single;

    expect(result, isA<ArchiveOwnChatSessionDemo>());
    expect(archived.status, ChatSessionStatus.archived);
    expect(archived.lastMessageAt, original.lastMessageAt);
    expect(archived.startedAt, original.startedAt);
    expect(archived.messageCount, original.messageCount);
  });

  test('validates only basic client inputs', () async {
    expect(
      await repository.createOwnChatSession(
        selectableSpecialistId: ' ',
        operationAttemptId: _attempt,
      ),
      const CreateOwnChatSessionFailure(
        OwnChatSessionsFailureType.invalidSelectableSpecialist,
      ),
    );
    expect(
      await repository.listOwnChatSessions(limit: 0),
      const ListOwnChatSessionsFailure(
        OwnChatSessionsFailureType.invalidRequest,
      ),
    );
    expect(
      await repository.archiveOwnChatSession(sessionId: ''),
      const ArchiveOwnChatSessionFailure(
        OwnChatSessionsFailureType.invalidRequest,
      ),
    );
  });
}

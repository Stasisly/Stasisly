import 'package:flutter_test/flutter_test.dart';

import 'package:stasisly/core/idempotency/operation_attempt_id.dart';
import 'package:stasisly/features/chat_sessions/data/repositories/backend_blocked_own_chat_sessions_repository.dart';
import 'package:stasisly/features/chat_sessions/domain/entities/own_chat_session_results.dart';

void main() {
  const repository = BackendBlockedOwnChatSessionsRepository();
  const blocked = OwnChatSessionsFailureType.backendBlocked;

  test('all operations stay blocked without demo fallback', () async {
    expect(
      await repository.createOwnChatSession(
        selectableSpecialistId: 'catalog-public',
        operationAttemptId: OperationAttemptId('test_attempt_00000001'),
      ),
      const CreateOwnChatSessionFailure(blocked),
    );
    expect(
      await repository.listOwnChatSessions(),
      const ListOwnChatSessionsFailure(blocked),
    );
    expect(
      await repository.archiveOwnChatSession(sessionId: 'session-public'),
      const ArchiveOwnChatSessionFailure(blocked),
    );
  });
}

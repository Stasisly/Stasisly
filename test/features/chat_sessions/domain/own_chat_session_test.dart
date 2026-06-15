import 'package:flutter_test/flutter_test.dart';

import 'package:stasisly/features/chat_sessions/domain/entities/own_chat_session.dart';

void main() {
  test('public session and specialist summary expose only approved fields', () {
    final timestamp = DateTime.utc(2026);
    final session = OwnChatSession(
      sessionId: 'session-public',
      selectableSpecialist: const SelectableSpecialistSummary(
        id: 'catalog-wellness',
        displayName: 'Wellness',
        area: SelectableSpecialistSummaryArea.wellness,
      ),
      startedAt: timestamp,
      lastMessageAt: timestamp,
      status: ChatSessionStatus.active,
      messageCount: 0,
    );

    expect(session.props, hasLength(6));
    expect(session.selectableSpecialist.props, hasLength(3));
    expect(session.selectableSpecialist.id, 'catalog-wellness');
  });

  test('archived response is deliberately minimal', () {
    const archived = ArchivedOwnChatSession(sessionId: 'session-public');

    expect(archived.props, hasLength(2));
    expect(archived.status, ChatSessionStatus.archived);
  });
}

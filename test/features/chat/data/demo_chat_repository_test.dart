import 'package:flutter_test/flutter_test.dart';

import 'package:stasisly/core/domain/entities/current_identity.dart';
import 'package:stasisly/features/chat/data/repositories/demo_chat_repository.dart';

void main() {
  test(
    'demo repository creates local session and stores demo message',
    () async {
      final repository = DemoChatRepository(
        responseDelay: const Duration(hours: 1),
      );

      const identity = CurrentIdentity.demo();
      final sessionResult = await repository.getOrCreateSession(
        userId: identity.id,
        specialistId: 'stasis-demo',
      );
      final session = sessionResult.getOrElse(
        () => throw StateError('No session'),
      );

      final messageResult = await repository.sendMessage(
        sessionId: session.id,
        role: 'user',
        content: 'Hola demo',
      );
      final messages = await repository.watchMessages(session.id).first;

      expect(session.id, 'demo_session_stasis-demo');
      expect(session.userId, identity.id);
      expect(messageResult.isRight(), isTrue);
      expect(messages.single.content, 'Hola demo');
    },
  );
}

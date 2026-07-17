import 'package:flutter_test/flutter_test.dart';

import 'package:stasisly/features/conversations/domain/entities/conversation_message.dart';
import 'package:stasisly/features/conversations/domain/value_objects/conversation_id.dart';
import 'package:stasisly/features/conversations/presentation/mappers/conversation_message_view_mapper.dart';
import 'package:stasisly/features/conversations/presentation/models/conversation_message_view_model.dart';

void main() {
  final conversationId = ConversationId('conversation-safe');
  final createdAt = DateTime(2026, 7, 17, 9, 5);

  ConversationMessage message({
    MessageAuthor author = const UserAuthor(),
    ConversationMessageProvenance provenance =
        ConversationMessageProvenance.userProvided,
    ConversationMessageVisibility visibility =
        ConversationMessageVisibility.productVisible,
    ConversationMessageStatus status = ConversationMessageStatus.accepted,
    String content = 'Contenido seguro',
  }) {
    return ConversationMessage(
      messageId: 'message-safe',
      conversationId: conversationId,
      author: author,
      content: content,
      createdAt: createdAt,
      status: status,
      provenance: provenance,
      visibility: visibility,
    );
  }

  test('maps verified user without authority fields', () {
    final result = ConversationMessageViewMapper.tryMap(message());

    expect(result, isNotNull);
    expect(result!.displayAuthor, 'Tú');
    expect(result.visualKind, ConversationMessageVisualKind.user);
    expect(result.content, 'Contenido seguro');
    expect(result.displayTimestamp, '09:05');
  });

  test(
    'maps verified Stasis visual contract only with explicit provenance',
    () {
      final result = ConversationMessageViewMapper.tryMap(
        message(
          author: const StasisAuthor(),
          provenance: ConversationMessageProvenance.stasisConsolidated,
        ),
      );

      expect(result?.displayAuthor, 'Stasis');
      expect(result?.visualKind, ConversationMessageVisualKind.stasis);
    },
  );

  test('maps verified specialist using only public display metadata', () {
    final result = ConversationMessageViewMapper.tryMap(
      message(
        author: const SpecialistAuthor(
          selectableSpecialistId: 'nutrition-safe',
          displayName: 'Especialista nutrición',
          publicArea: 'nutrition',
        ),
        provenance: ConversationMessageProvenance.specialistProvided,
      ),
    );

    expect(result?.displayAuthor, 'Especialista nutrición');
    expect(result?.visualKind, ConversationMessageVisualKind.specialist);
    expect(result.toString(), isNot(contains('nutrition-safe')));
  });

  test('maps system-visible message as system notice', () {
    final result = ConversationMessageViewMapper.tryMap(
      message(
        author: const SystemNoticeAuthor(),
        provenance: ConversationMessageProvenance.systemGenerated,
        visibility: ConversationMessageVisibility.systemVisible,
      ),
    );

    expect(result?.visualKind, ConversationMessageVisualKind.systemNotice);
    expect(result?.displayAuthor, 'Aviso del sistema');
  });

  test('redacted mapping never carries original content', () {
    final result = ConversationMessageViewMapper.tryMap(
      message(
        visibility: ConversationMessageVisibility.redacted,
        status: ConversationMessageStatus.redacted,
        content: ConversationMessage.redactedPlaceholder,
      ),
    );

    expect(result?.isRedacted, isTrue);
    expect(result?.visualKind, ConversationMessageVisualKind.redacted);
    expect(result?.content, ConversationMessageViewMapper.redactedContent);
    expect(result?.content, isNot(ConversationMessage.redactedPlaceholder));
  });

  test('incoherent provenance fails closed instead of inventing author', () {
    final result = ConversationMessageViewMapper.tryMap(
      message(provenance: ConversationMessageProvenance.unknown),
    );

    expect(result, isNull);
  });

  test('system visibility rejects a non-system author', () {
    final result = ConversationMessageViewMapper.tryMap(
      message(visibility: ConversationMessageVisibility.systemVisible),
    );

    expect(result, isNull);
  });

  test(
    'unknown author and hidden visibility cannot become Product messages',
    () {
      expect(() => message(author: const UnknownAuthor()), throwsArgumentError);
      expect(
        () => message(visibility: ConversationMessageVisibility.internal),
        throwsArgumentError,
      );
      expect(
        () => message(visibility: ConversationMessageVisibility.unknown),
        throwsArgumentError,
      );
    },
  );
}

import 'package:stasisly/features/conversations/domain/entities/conversation_message.dart';
import 'package:stasisly/features/conversations/presentation/models/conversation_message_view_model.dart';

abstract final class ConversationMessageViewMapper {
  static const redactedContent = 'Contenido no disponible';

  static ConversationMessageViewModel? tryMap(ConversationMessage message) {
    if (!message.isDisplaySafe ||
        !message.visibility.isProductReadable ||
        message.visibility == ConversationMessageVisibility.internal ||
        message.visibility == ConversationMessageVisibility.unknown ||
        message.author is UnknownAuthor) {
      return null;
    }

    if (message.visibility == ConversationMessageVisibility.systemVisible &&
        message.author is! SystemNoticeAuthor) {
      return null;
    }

    final isRedacted =
        message.visibility == ConversationMessageVisibility.redacted;
    final authorVisual = _authorVisual(message);
    if (authorVisual == null) return null;

    final visualKind = isRedacted
        ? ConversationMessageVisualKind.redacted
        : message.visibility == ConversationMessageVisibility.systemVisible
        ? ConversationMessageVisualKind.systemNotice
        : authorVisual.kind;
    final content = isRedacted ? redactedContent : message.content;
    final timestamp = _formatTimestamp(message.createdAt);
    final deliveryState = switch (message.status) {
      ConversationMessageStatus.accepted ||
      ConversationMessageStatus.redacted =>
        ConversationMessageDeliveryState.accepted,
      ConversationMessageStatus.failed =>
        ConversationMessageDeliveryState.failed,
      ConversationMessageStatus.unknown => null,
    };
    if (deliveryState == null) return null;

    final stateLabel = deliveryState == ConversationMessageDeliveryState.failed
        ? ', no enviado'
        : '';
    return ConversationMessageViewModel(
      messageId: message.messageId,
      displayAuthor: authorVisual.label,
      content: content,
      displayTimestamp: timestamp,
      visualKind: visualKind,
      deliveryState: deliveryState,
      accessibilityLabel:
          '${authorVisual.label}, $timestamp$stateLabel: $content',
      isRedacted: isRedacted,
    );
  }

  static _AuthorVisual? _authorVisual(ConversationMessage message) {
    return switch (message.author) {
      UserAuthor()
          when message.provenance ==
              ConversationMessageProvenance.userProvided =>
        const _AuthorVisual('Tú', ConversationMessageVisualKind.user),
      StasisAuthor()
          when message.provenance ==
              ConversationMessageProvenance.stasisConsolidated =>
        const _AuthorVisual('Stasis', ConversationMessageVisualKind.stasis),
      SpecialistAuthor(:final displayName)
          when message.provenance ==
              ConversationMessageProvenance.specialistProvided =>
        _AuthorVisual(displayName, ConversationMessageVisualKind.specialist),
      SystemNoticeAuthor()
          when message.provenance ==
              ConversationMessageProvenance.systemGenerated =>
        const _AuthorVisual(
          'Aviso del sistema',
          ConversationMessageVisualKind.systemNotice,
        ),
      _ => null,
    };
  }

  static String _formatTimestamp(DateTime value) {
    final local = value.toLocal();
    return '${local.hour.toString().padLeft(2, '0')}:'
        '${local.minute.toString().padLeft(2, '0')}';
  }
}

class _AuthorVisual {
  const _AuthorVisual(this.label, this.kind);

  final String label;
  final ConversationMessageVisualKind kind;
}

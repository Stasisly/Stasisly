import 'package:equatable/equatable.dart';

enum ConversationMessageVisualKind {
  user,
  stasis,
  specialist,
  systemNotice,
  redacted,
  unknown,
}

enum ConversationMessageDeliveryState { accepted, failed }

class ConversationMessageViewModel extends Equatable {
  ConversationMessageViewModel({
    required this.messageId,
    required this.displayAuthor,
    required this.content,
    required this.displayTimestamp,
    required this.visualKind,
    required this.deliveryState,
    required this.accessibilityLabel,
    required this.isRedacted,
  }) {
    if (messageId.trim().isEmpty ||
        displayAuthor.trim().isEmpty ||
        content.trim().isEmpty ||
        displayTimestamp.trim().isEmpty ||
        accessibilityLabel.trim().isEmpty) {
      throw ArgumentError('Conversation message view data must not be empty.');
    }
    if (visualKind == ConversationMessageVisualKind.unknown) {
      throw ArgumentError('Unknown authors are not renderable.');
    }
    if (isRedacted != (visualKind == ConversationMessageVisualKind.redacted)) {
      throw ArgumentError('Redacted state and visual kind must agree.');
    }
  }

  final String messageId;
  final String displayAuthor;
  final String content;
  final String displayTimestamp;
  final ConversationMessageVisualKind visualKind;
  final ConversationMessageDeliveryState deliveryState;
  final String accessibilityLabel;
  final bool isRedacted;

  @override
  List<Object?> get props => [
    messageId,
    displayAuthor,
    content,
    displayTimestamp,
    visualKind,
    deliveryState,
    accessibilityLabel,
    isRedacted,
  ];
}

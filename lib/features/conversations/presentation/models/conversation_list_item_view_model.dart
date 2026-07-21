import 'package:equatable/equatable.dart';

import 'package:stasisly/features/conversations/domain/entities/conversation.dart';
import 'package:stasisly/features/conversations/domain/value_objects/conversation_id.dart';

class ConversationListItemViewModel extends Equatable {
  const ConversationListItemViewModel({
    required this.conversationId,
    required this.title,
    required this.status,
    required this.updatedAt,
    this.specialistSummary,
  });

  factory ConversationListItemViewModel.fromConversation(
    Conversation conversation,
  ) {
    final specialist = conversation.selectedSpecialistReference;
    final publicSpecialist = specialist?.displayName?.trim();
    return ConversationListItemViewModel(
      conversationId: conversation.conversationId,
      title: conversation.title ?? publicSpecialist ?? 'Conversación',
      status: conversation.status,
      updatedAt: conversation.updatedAt,
      specialistSummary: publicSpecialist == null || publicSpecialist.isEmpty
          ? null
          : [
              publicSpecialist,
              if (specialist?.area != null) specialist!.area!,
            ].join(' · '),
    );
  }

  final ConversationId conversationId;
  final String title;
  final ConversationStatus status;
  final DateTime updatedAt;
  final String? specialistSummary;

  @override
  List<Object?> get props => [
    conversationId,
    title,
    status,
    updatedAt,
    specialistSummary,
  ];
}

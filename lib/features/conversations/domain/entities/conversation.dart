import 'package:equatable/equatable.dart';

import 'package:stasisly/core/identity/domain/stasisly_identity.dart';
import 'package:stasisly/features/conversations/domain/value_objects/conversation_id.dart';

enum ConversationStatus {
  active,
  archived,
  pendingDeletion,
  unknown;

  bool get allowsNormalMutation => this == ConversationStatus.active;
  bool get failsClosed => this == ConversationStatus.unknown;

  static ConversationStatus parseOrUnknown(String value) {
    return switch (value.trim()) {
      'active' => ConversationStatus.active,
      'archived' => ConversationStatus.archived,
      'pendingDeletion' => ConversationStatus.pendingDeletion,
      _ => ConversationStatus.unknown,
    };
  }
}

enum ConversationStatusFilter { active, archived, all }

enum ConversationSpecialistSelectionState { selected, unavailable, unknown }

class ConversationSpecialistSelection extends Equatable {
  ConversationSpecialistSelection({
    required String selectableSpecialistId,
    required this.displayName,
    required this.area,
    required this.state,
  }) : selectableSpecialistId = _requiredSelectionId(selectableSpecialistId);

  final String selectableSpecialistId;
  final String? displayName;
  final String? area;
  final ConversationSpecialistSelectionState state;

  @override
  List<Object?> get props => [selectableSpecialistId, displayName, area, state];
}

String _requiredSelectionId(String value) {
  final normalized = value.trim();
  if (normalized.isEmpty) {
    throw ArgumentError.value(
      value,
      'selectableSpecialistId',
      'Must not be empty.',
    );
  }
  return normalized;
}

class Conversation extends Equatable {
  const Conversation._({
    required this.conversationId,
    required this.ownerSubjectId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.archivedAt,
    required this.title,
    required this.selectedSpecialistReference,
  });

  factory Conversation.fromTrustedIdentity({
    required ConversationId conversationId,
    required StasislyIdentity ownerIdentity,
    required ConversationStatus status,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? archivedAt,
    String? title,
    ConversationSpecialistSelection? selectedSpecialistReference,
  }) {
    if (!ownerIdentity.isAuthenticated ||
        ownerIdentity.subjectId.trim().isEmpty) {
      throw const ConversationOwnershipException();
    }
    if (status.failsClosed) {
      throw const ConversationContractException('Unknown lifecycle state.');
    }
    if (updatedAt.isBefore(createdAt)) {
      throw const ConversationContractException(
        'updatedAt cannot precede createdAt.',
      );
    }
    final normalizedTitle = title?.trim();
    return Conversation._(
      conversationId: conversationId,
      ownerSubjectId: ownerIdentity.subjectId.trim(),
      status: status,
      createdAt: createdAt.toUtc(),
      updatedAt: updatedAt.toUtc(),
      archivedAt: archivedAt?.toUtc(),
      title: normalizedTitle == null || normalizedTitle.isEmpty
          ? null
          : normalizedTitle,
      selectedSpecialistReference: selectedSpecialistReference,
    );
  }

  final ConversationId conversationId;
  final String ownerSubjectId;
  final ConversationStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? archivedAt;
  final String? title;
  final ConversationSpecialistSelection? selectedSpecialistReference;

  @override
  List<Object?> get props => [
    conversationId,
    ownerSubjectId,
    status,
    createdAt,
    updatedAt,
    archivedAt,
    title,
    selectedSpecialistReference,
  ];
}

class ConversationOwnershipException implements Exception {
  const ConversationOwnershipException();
}

class ConversationContractException implements Exception {
  const ConversationContractException(this.message);

  final String message;
}

import 'package:equatable/equatable.dart';

enum OwnChatMessageRole {
  user,
  assistant,
  system,
  tool;

  String get wireName => name;

  static OwnChatMessageRole? tryParse(String value) {
    for (final role in values) {
      if (role.wireName == value) return role;
    }
    return null;
  }
}

class OwnChatMessage extends Equatable {
  const OwnChatMessage({
    required this.messageId,
    required this.sessionId,
    required this.role,
    required this.content,
    required this.createdAt,
    required this.isDemo,
  });

  final String messageId;
  final String sessionId;
  final OwnChatMessageRole role;
  final String content;
  final DateTime createdAt;
  final bool isDemo;

  @override
  List<Object?> get props => [
    messageId,
    sessionId,
    role,
    content,
    createdAt,
    isDemo,
  ];
}

class OwnChatMessagesPage extends Equatable {
  const OwnChatMessagesPage({required this.items, required this.nextCursor});

  final List<OwnChatMessage> items;
  final String? nextCursor;

  @override
  List<Object?> get props => [items, nextCursor];
}

class SentOwnChatMessage extends Equatable {
  const SentOwnChatMessage({
    required this.message,
    required this.sessionId,
    required this.messageCount,
    required this.lastMessageAt,
    required this.isDemo,
  });

  final OwnChatMessage message;
  final String sessionId;
  final int messageCount;
  final DateTime lastMessageAt;
  final bool isDemo;

  @override
  List<Object?> get props => [
    message,
    sessionId,
    messageCount,
    lastMessageAt,
    isDemo,
  ];
}

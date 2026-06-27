import 'package:equatable/equatable.dart';

import 'package:stasisly/features/chat_messages/domain/entities/own_chat_message.dart';
import 'package:stasisly/features/chat_messages/domain/entities/own_chat_message_results.dart';

class OwnChatMessagesState extends Equatable {
  const OwnChatMessagesState({
    this.sessionId,
    this.messages = const [],
    this.nextCursor,
    this.isInitialLoading = false,
    this.isPaginating = false,
    this.isSending = false,
    this.isDemo = false,
    this.isBackendBlocked = false,
    this.lastListError,
    this.lastSendError,
    this.confirmedMessageCount,
    this.confirmedLastMessageAt,
  });

  final String? sessionId;
  final List<OwnChatMessage> messages;
  final String? nextCursor;
  final bool isInitialLoading;
  final bool isPaginating;
  final bool isSending;
  final bool isDemo;
  final bool isBackendBlocked;
  final ListOwnChatMessagesFailureType? lastListError;
  final SendOwnChatMessageFailureType? lastSendError;
  final int? confirmedMessageCount;
  final DateTime? confirmedLastMessageAt;

  bool get hasMessages => messages.isNotEmpty;

  bool get isEmpty => sessionId != null && messages.isEmpty && !hasActiveWork;

  bool get hasActiveWork => isInitialLoading || isPaginating || isSending;

  OwnChatMessagesState copyWith({
    Object? sessionId = _sentinel,
    List<OwnChatMessage>? messages,
    Object? nextCursor = _sentinel,
    bool? isInitialLoading,
    bool? isPaginating,
    bool? isSending,
    bool? isDemo,
    bool? isBackendBlocked,
    Object? lastListError = _sentinel,
    Object? lastSendError = _sentinel,
    Object? confirmedMessageCount = _sentinel,
    Object? confirmedLastMessageAt = _sentinel,
  }) {
    return OwnChatMessagesState(
      sessionId: identical(sessionId, _sentinel)
          ? this.sessionId
          : sessionId as String?,
      messages: messages ?? this.messages,
      nextCursor: identical(nextCursor, _sentinel)
          ? this.nextCursor
          : nextCursor as String?,
      isInitialLoading: isInitialLoading ?? this.isInitialLoading,
      isPaginating: isPaginating ?? this.isPaginating,
      isSending: isSending ?? this.isSending,
      isDemo: isDemo ?? this.isDemo,
      isBackendBlocked: isBackendBlocked ?? this.isBackendBlocked,
      lastListError: identical(lastListError, _sentinel)
          ? this.lastListError
          : lastListError as ListOwnChatMessagesFailureType?,
      lastSendError: identical(lastSendError, _sentinel)
          ? this.lastSendError
          : lastSendError as SendOwnChatMessageFailureType?,
      confirmedMessageCount: identical(confirmedMessageCount, _sentinel)
          ? this.confirmedMessageCount
          : confirmedMessageCount as int?,
      confirmedLastMessageAt: identical(confirmedLastMessageAt, _sentinel)
          ? this.confirmedLastMessageAt
          : confirmedLastMessageAt as DateTime?,
    );
  }

  @override
  List<Object?> get props => [
    sessionId,
    messages,
    nextCursor,
    isInitialLoading,
    isPaginating,
    isSending,
    isDemo,
    isBackendBlocked,
    lastListError,
    lastSendError,
    confirmedMessageCount,
    confirmedLastMessageAt,
  ];
}

const Object _sentinel = Object();

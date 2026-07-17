import 'package:stasisly/features/chat_sessions/domain/entities/own_chat_session.dart';

class OwnChatSessionsContractResponse {
  const OwnChatSessionsContractResponse({
    required this.statusCode,
    this.body,
    this.errorCode,
  });

  final int statusCode;
  final Map<String, dynamic>? body;
  final String? errorCode;
}

/// Simulated contract boundary only. This package provides no I/O adapter.
abstract interface class OwnChatSessionsContractSource {
  Future<OwnChatSessionsContractResponse> createOwnChatSession({
    required String selectableSpecialistId,
  });

  Future<OwnChatSessionsContractResponse> listOwnChatSessions({
    required ChatSessionStatusFilter status,
    required int limit,
    String? cursor,
  });

  Future<OwnChatSessionsContractResponse> archiveOwnChatSession({
    required String sessionId,
  });
}

abstract interface class OwnChatSessionLifecycleContractSource {
  Future<OwnChatSessionsContractResponse> readOwnChatSession({
    required String sessionId,
  });

  Future<OwnChatSessionsContractResponse> restoreOwnChatSession({
    required String sessionId,
  });
}

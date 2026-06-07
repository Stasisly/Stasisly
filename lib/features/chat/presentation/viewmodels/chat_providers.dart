import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:stasisly/features/chat/data/datasources/supabase_chat_datasource.dart';
import 'package:stasisly/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:stasisly/features/chat/domain/entities/chat_session_entity.dart';
import 'package:stasisly/features/chat/domain/entities/message_entity.dart';
import 'package:stasisly/features/chat/domain/repositories/chat_repository.dart';
import 'package:stasisly/features/chat/domain/usecases/get_or_create_session_usecase.dart';
import 'package:stasisly/features/chat/domain/usecases/send_message_usecase.dart';
import 'package:stasisly/features/chat/domain/usecases/watch_messages_usecase.dart';

part 'chat_providers.g.dart';

@Riverpod(keepAlive: true)
SupabaseChatDataSource supabaseChatDataSource(SupabaseChatDataSourceRef ref) {
  return SupabaseChatDataSource(Supabase.instance.client);
}

@Riverpod(keepAlive: true)
ChatRepository chatRepository(ChatRepositoryRef ref) {
  return ChatRepositoryImpl(ref.watch(supabaseChatDataSourceProvider));
}

@Riverpod(keepAlive: true)
GetOrCreateSessionUseCase getOrCreateSessionUseCase(GetOrCreateSessionUseCaseRef ref) {
  return GetOrCreateSessionUseCase(ref.watch(chatRepositoryProvider));
}

@Riverpod(keepAlive: true)
SendMessageUseCase sendMessageUseCase(SendMessageUseCaseRef ref) {
  return SendMessageUseCase(ref.watch(chatRepositoryProvider));
}

@Riverpod(keepAlive: true)
WatchMessagesUseCase watchMessagesUseCase(WatchMessagesUseCaseRef ref) {
  return WatchMessagesUseCase(ref.watch(chatRepositoryProvider));
}

// Session State Provider
@riverpod
class ActiveChatSession extends _$ActiveChatSession {
  @override
  FutureOr<ChatSessionEntity?> build(String specialistId) async {
    // Usamos un user_id mock por ahora, ya que Auth usa un bypass
    const mockUserId = '11111111-1111-1111-1111-111111111111';
    
    final useCase = ref.watch(getOrCreateSessionUseCaseProvider);
    final result = await useCase(userId: mockUserId, specialistId: specialistId);
    
    return result.fold(
      (failure) => throw Exception(failure.message),
      (session) => session,
    );
  }
}

// Messages Stream Provider
@riverpod
Stream<List<MessageEntity>> chatMessagesStream(ChatMessagesStreamRef ref, String sessionId) {
  final useCase = ref.watch(watchMessagesUseCaseProvider);
  return useCase(sessionId);
}

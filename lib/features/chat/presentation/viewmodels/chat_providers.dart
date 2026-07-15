import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:stasisly/core/config/app_environment.dart';
import 'package:stasisly/core/providers/current_identity_provider.dart';
import 'package:stasisly/features/chat/data/datasources/supabase_chat_datasource.dart';
import 'package:stasisly/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:stasisly/features/chat/data/repositories/demo_chat_repository.dart';
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
  final environment = ref.watch(appEnvironmentProvider);
  if (environment.isDemo) {
    return DemoChatRepository();
  }
  return ChatRepositoryImpl(ref.watch(supabaseChatDataSourceProvider));
}

@Riverpod(keepAlive: true)
GetOrCreateSessionUseCase getOrCreateSessionUseCase(
  GetOrCreateSessionUseCaseRef ref,
) {
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
    final identity = ref.watch(currentIdentityProvider);
    final useCase = ref.watch(getOrCreateSessionUseCaseProvider);
    final result = await useCase(
      userId: identity.subjectId,
      specialistId: specialistId,
    );

    return result.fold(
      (failure) => throw Exception(failure.message),
      (session) => session,
    );
  }
}

// Messages Stream Provider
@riverpod
Stream<List<MessageEntity>> chatMessagesStream(
  ChatMessagesStreamRef ref,
  String sessionId,
) {
  final useCase = ref.watch(watchMessagesUseCaseProvider);
  return useCase(sessionId);
}

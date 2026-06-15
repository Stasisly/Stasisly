import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:stasisly/features/chat/presentation/viewmodels/chat_providers.dart';

part 'chat_controller.g.dart';

@riverpod
class ChatController extends _$ChatController {
  @override
  FutureOr<void> build() {
    // Initial state is void, we just use this controller to execute send actions
  }

  Future<void> sendMessage({
    required String sessionId,
    required String text,
    List<String>? attachments,
  }) async {
    state = const AsyncLoading();

    final useCase = ref.read(sendMessageUseCaseProvider);

    // In a real app we'd map attachments to a proper JSON/List structure.
    final result = await useCase(
      sessionId: sessionId,
      role: 'user',
      content: text,
    );

    result.fold(
      (failure) => state = AsyncError(failure.message, StackTrace.current),
      (_) => state = const AsyncData(null),
    );
  }
}

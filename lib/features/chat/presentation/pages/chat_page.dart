import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:stasisly/core/theme/app_colors.dart';
import 'package:stasisly/core/theme/app_spacing.dart';
import 'package:stasisly/features/chat/presentation/viewmodels/chat_controller.dart';
import 'package:stasisly/features/chat/presentation/viewmodels/chat_providers.dart';
import 'package:stasisly/features/chat/presentation/widgets/chat_input.dart';
import 'package:stasisly/features/chat/presentation/widgets/message_bubble.dart';

class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({
    required this.agentId,
    required this.specialistName,
    required this.specialty,
    super.key,
  });

  final String agentId;
  final String specialistName;
  final String specialty;

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0, // ListView is reversed
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final sessionAsync = ref.watch(activeChatSessionProvider(widget.agentId));

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.primaryLight,
              child: Icon(Icons.person, color: Colors.white, size: 20),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.specialistName),
                  Text(
                    widget.specialty,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: AppColors.textSecondaryDark,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: sessionAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text('Error: $error')),
          data: (session) {
            if (session == null) {
              return const Center(child: Text('Error: No session created.'));
            }

            return _ChatBody(
              sessionId: session.id,
              scrollController: _scrollController,
              onScrollToBottom: _scrollToBottom,
            );
          },
        ),
      ),
    );
  }
}

class _ChatBody extends ConsumerWidget {
  const _ChatBody({
    required this.sessionId,
    required this.scrollController,
    required this.onScrollToBottom,
  });

  final String sessionId;
  final ScrollController scrollController;
  final VoidCallback onScrollToBottom;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messagesAsync = ref.watch(chatMessagesStreamProvider(sessionId));
    final controllerState = ref.watch(chatControllerProvider);

    // Listen for new messages to scroll
    ref.listen(chatMessagesStreamProvider(sessionId), (previous, next) {
      if (previous?.value?.length != next.value?.length) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          onScrollToBottom();
        });
      }
    });

    return Column(
      children: [
        Expanded(
          child: messagesAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(child: Text('Error: $error')),
            data: (messages) {
              final isLoading = controllerState.isLoading;
              
              return ListView.builder(
                controller: scrollController,
                reverse: true,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                itemCount: messages.length + (isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  // Handle loading indicator
                  if (isLoading && index == 0) {
                    return const Padding(
                      padding: EdgeInsets.all(AppSpacing.lg),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: AppColors.primaryLight,
                            child: Icon(Icons.psychology, size: 16, color: Colors.white),
                          ),
                          SizedBox(width: AppSpacing.sm),
                          SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ],
                      ),
                    );
                  }

                  // Adjust index if loading indicator is present
                  final messageIndex = isLoading ? index - 1 : index;
                  // The list is reversed, so we need to get items from the end
                  final message = messages[messages.length - 1 - messageIndex];

                  return MessageBubble(message: message);
                },
              );
            },
          ),
        ),
        ChatInput(
          onSend: (text, attachments) {
            ref.read(chatControllerProvider.notifier).sendMessage(
              sessionId: sessionId,
              text: text,
              attachments: attachments,
            );
          },
        ),
      ],
    );
  }
}

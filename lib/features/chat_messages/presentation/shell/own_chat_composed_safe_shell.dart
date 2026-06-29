import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:stasisly/features/chat_messages/presentation/shell/own_chat_messages_safe_shell.dart';
import 'package:stasisly/features/chat_sessions/presentation/providers/own_chat_sessions_providers.dart';
import 'package:stasisly/features/chat_sessions/presentation/widgets/own_chat_sessions_panel.dart';

class OwnChatComposedSafeShell extends ConsumerWidget {
  const OwnChatComposedSafeShell({
    this.sessionsAutoLoad = true,
    this.messagesAutoLoad = true,
    super.key,
  });

  final bool sessionsAutoLoad;
  final bool messagesAutoLoad;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedSessionId = ref.watch(
      ownChatSessionsStateProvider.select((state) {
        final sessionId = state.selectedSessionId?.trim();
        return sessionId == null || sessionId.isEmpty ? null : sessionId;
      }),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SafeShellNotice(),
        const SizedBox(height: 12),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth >= 760) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: OwnChatSessionsPanel(autoLoad: sessionsAutoLoad),
                    ),
                    const VerticalDivider(width: 24),
                    Expanded(
                      child: _MessagesSlot(
                        selectedSessionId: selectedSessionId,
                        messagesAutoLoad: messagesAutoLoad,
                      ),
                    ),
                  ],
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: OwnChatSessionsPanel(autoLoad: sessionsAutoLoad),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: _MessagesSlot(
                      selectedSessionId: selectedSessionId,
                      messagesAutoLoad: messagesAutoLoad,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class _SafeShellNotice extends StatelessWidget {
  const _SafeShellNotice();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Shell local-safe: selecciona un sessionId explícito para abrir mensajes.',
    );
  }
}

class _MessagesSlot extends StatelessWidget {
  const _MessagesSlot({
    required this.selectedSessionId,
    required this.messagesAutoLoad,
  });

  final String? selectedSessionId;
  final bool messagesAutoLoad;

  @override
  Widget build(BuildContext context) {
    final sessionId = selectedSessionId;
    if (sessionId == null) {
      return const Center(
        child: Text('Selecciona una sesión para abrir mensajes'),
      );
    }

    return OwnChatMessagesSafeShell(
      key: ValueKey('own-chat-messages-$sessionId'),
      sessionId: sessionId,
      autoLoad: messagesAutoLoad,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:stasisly/core/config/app_environment.dart';
import 'package:stasisly/features/chat_messages/presentation/shell/own_chat_messages_safe_shell.dart';
import 'package:stasisly/features/chat_sessions/domain/entities/own_chat_session.dart';
import 'package:stasisly/features/chat_sessions/presentation/providers/own_chat_sessions_providers.dart';
import 'package:stasisly/features/chat_sessions/presentation/widgets/own_chat_sessions_panel.dart';

class OwnChatComposedSafeShell extends ConsumerWidget {
  const OwnChatComposedSafeShell({
    this.sessionsAutoLoad = true,
    this.messagesAutoLoad = true,
    this.onOpenSession,
    super.key,
  });

  final bool sessionsAutoLoad;
  final bool messagesAutoLoad;
  final ValueChanged<String>? onOpenSession;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final environment = ref.watch(appEnvironmentProvider);
    final selectedSessionId = ref.watch(
      ownChatSessionsStateProvider.select((state) {
        final sessionId = state.selectedSessionId?.trim();
        return sessionId == null || sessionId.isEmpty ? null : sessionId;
      }),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SafeShellNotice(environment: environment),
        const SizedBox(height: 12),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth >= 760) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: OwnChatSessionsPanel(
                        autoLoad: sessionsAutoLoad,
                        statusFilter: ChatSessionStatusFilter.all,
                        onOpenSession: onOpenSession,
                      ),
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
                    child: OwnChatSessionsPanel(
                      autoLoad: sessionsAutoLoad,
                      statusFilter: ChatSessionStatusFilter.all,
                      onOpenSession: onOpenSession,
                    ),
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
  const _SafeShellNotice({required this.environment});

  final AppEnvironment environment;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 4,
      children: [
        const Text('DEV ONLY'),
        const Text('REMOTE DEVELOPMENT'),
        const Text('SYNTHETIC DATA'),
        const Text('NOT PRODUCT'),
        Text('modo: ${environment.mode.name} remote'),
        Text(
          'backend remoto: '
          '${_remoteBackendActive(environment) ? 'activo' : 'bloqueado'}',
        ),
        Text(
          'real auth: '
          '${environment.allowsRealAuth ? 'activo' : 'bloqueado'}',
        ),
        Text('real data: ${environment.allowsRealData}'),
        Text(
          'dev routes: '
          '${environment.allowsDevRoutes ? 'activo' : 'bloqueado'}',
        ),
        Text(
          'conversations route: '
          '${environment.allowsConversationsRoute ? 'activo' : 'bloqueado'}',
        ),
        const Text('Shell dev-only con sessionId explícito.'),
      ],
    );
  }
}

bool _remoteBackendActive(AppEnvironment environment) {
  return environment.isDevelopment &&
      environment.remoteBackendEnabled &&
      !environment.realDataEnabled;
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

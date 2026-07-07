import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:stasisly/core/config/app_environment.dart';
import 'package:stasisly/features/chat_messages/presentation/widgets/own_chat_messages_panel.dart';

class OwnChatMessagesSafeShell extends ConsumerWidget {
  const OwnChatMessagesSafeShell({
    required this.sessionId,
    this.autoLoad = true,
    super.key,
  });

  final String sessionId;
  final bool autoLoad;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final normalizedSessionId = sessionId.trim();
    if (normalizedSessionId.isEmpty) {
      return const Center(child: Text('Sesión no válida'));
    }

    final environment = ref.watch(appEnvironmentProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _DevOnlyDetailNotice(environment: environment),
        const SizedBox(height: 12),
        Expanded(
          child: OwnChatMessagesPanel(
            sessionId: normalizedSessionId,
            autoLoad: autoLoad,
          ),
        ),
      ],
    );
  }
}

class _DevOnlyDetailNotice extends StatelessWidget {
  const _DevOnlyDetailNotice({required this.environment});

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
        const Text('Detalle dev-only por sessionId explícito.'),
      ],
    );
  }
}

bool _remoteBackendActive(AppEnvironment environment) {
  return environment.isDevelopment &&
      environment.remoteBackendEnabled &&
      !environment.realDataEnabled;
}

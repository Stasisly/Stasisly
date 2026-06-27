import 'package:flutter/material.dart';

import 'package:stasisly/features/chat_sessions/presentation/shell/own_chat_sessions_shell_input_adapter.dart';
import 'package:stasisly/features/chat_sessions/presentation/widgets/own_chat_sessions_panel.dart';

class OwnChatSessionsSafeShell extends StatelessWidget {
  const OwnChatSessionsSafeShell({
    this.input = const OwnChatSessionsShellInput(),
    this.autoLoad = true,
    super.key,
  });

  final OwnChatSessionsShellInput input;
  final bool autoLoad;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ShellBoundary(input: input),
        const SizedBox(height: 12),
        Expanded(child: OwnChatSessionsPanel(autoLoad: autoLoad)),
      ],
    );
  }
}

class _ShellBoundary extends StatelessWidget {
  const _ShellBoundary({required this.input});

  final OwnChatSessionsShellInput input;

  @override
  Widget build(BuildContext context) {
    if (!input.hasInput) {
      return const Text('Shell seguro chat_sessions sin entrada inicial');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Shell seguro chat_sessions'),
        if (input.sessionId != null)
          Text('Entrada segura sessionId: ${input.sessionId}'),
        if (input.selectableSpecialistId != null)
          Text(
            'Entrada segura selectableSpecialistId: '
            '${input.selectableSpecialistId}',
          ),
      ],
    );
  }
}

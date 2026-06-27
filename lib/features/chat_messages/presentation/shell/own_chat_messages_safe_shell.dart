import 'package:flutter/material.dart';

import 'package:stasisly/features/chat_messages/presentation/widgets/own_chat_messages_panel.dart';

class OwnChatMessagesSafeShell extends StatelessWidget {
  const OwnChatMessagesSafeShell({
    required this.sessionId,
    this.autoLoad = true,
    super.key,
  });

  final String sessionId;
  final bool autoLoad;

  @override
  Widget build(BuildContext context) {
    final normalizedSessionId = sessionId.trim();
    if (normalizedSessionId.isEmpty) {
      return const Center(child: Text('Sesión no válida'));
    }

    return OwnChatMessagesPanel(
      sessionId: normalizedSessionId,
      autoLoad: autoLoad,
    );
  }
}

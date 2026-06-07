import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:stasisly/features/chat/presentation/pages/chat_page.dart';
import 'package:stasisly/features/orchestrator/presentation/viewmodels/agent_providers.dart';

class AgentChatWrapper extends ConsumerWidget {
  const AgentChatWrapper({
    required this.agentId,
    super.key,
  });

  final String agentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final agentAsync = ref.watch(agentByIdProvider(agentId));

    return agentAsync.when(
      data: (agent) => ChatPage(
        agentId: agent.id,
        specialistName: agent.name,
        specialty: agent.specialty,
      ),
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('Error: $error')),
      ),
    );
  }
}

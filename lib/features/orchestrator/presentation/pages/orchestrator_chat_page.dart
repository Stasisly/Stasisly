import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:stasisly/core/theme/app_colors.dart';
import 'package:stasisly/features/chat/presentation/pages/chat_page.dart';
import 'package:stasisly/features/orchestrator/presentation/viewmodels/agent_providers.dart';

class OrchestratorChatPage extends ConsumerWidget {
  const OrchestratorChatPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stasisAsync = ref.watch(agentByIdProvider('stasis_core'));

    return stasisAsync.when(
      data: (stasis) {
        return Theme(
          // Customize the theme specifically for Stasis (Orchestrator colors)
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppColors.orchestratorAccent,
                  primaryContainer: AppColors.orchestratorAccent.withValues(alpha: 0.2),
                ),
          ),
          child: ChatPage(
            agentId: stasis.id,
            specialistName: stasis.name,
            specialty: stasis.specialty,
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        body: Center(child: Text('Error al cargar Stasis: $error')),
      ),
    );
  }
}

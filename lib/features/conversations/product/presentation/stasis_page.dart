import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:stasisly/core/theme/app_spacing.dart';

class StasisPage extends StatelessWidget {
  const StasisPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stasis')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: AppSpacing.pagePadding,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Semantics(
                    header: true,
                    child: Text(
                      'Tu espacio central',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const Text(
                    'Desde Stasis puedes entrar en tus conversaciones y navegar por las áreas de producto.',
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  FilledButton.icon(
                    key: const Key('open-conversations'),
                    onPressed: () => context.go('/conversations'),
                    icon: const Icon(Icons.forum_outlined),
                    label: const Text('Abrir conversaciones'),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  const Card(
                    child: Padding(
                      padding: AppSpacing.cardPadding,
                      child: Text(
                        'Crear una conversación no está disponible hasta que el catálogo Product ofrezca un especialista seleccionable verificado.',
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  const Text(
                    'Las respuestas automáticas de Stasis y especialistas no están activas.',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

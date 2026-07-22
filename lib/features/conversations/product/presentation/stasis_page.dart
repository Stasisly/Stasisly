import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:stasisly/core/theme/app_spacing.dart';
import 'package:stasisly/features/conversations/application/state/conversation_application_states.dart';
import 'package:stasisly/features/conversations/composition/conversation_providers.dart';
import 'package:stasisly/features/conversations/product/presentation/conversation_safe_copy.dart';
import 'package:stasisly/features/specialists/application/selectable_specialist_catalog_state.dart';
import 'package:stasisly/features/specialists/domain/entities/selectable_specialist.dart';
import 'package:stasisly/features/specialists/presentation/providers/selectable_specialists_providers.dart';

class StasisPage extends ConsumerStatefulWidget {
  const StasisPage({super.key});

  @override
  ConsumerState<StasisPage> createState() => _StasisPageState();
}

class _StasisPageState extends ConsumerState<StasisPage> {
  String? _selectedSpecialistId;

  @override
  void initState() {
    super.initState();
    Future<void>.microtask(
      () => ref
          .read(selectableSpecialistCatalogControllerProvider.notifier)
          .load(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final catalog = ref.watch(selectableSpecialistCatalogControllerProvider);
    final create = ref.watch(conversationCreateControllerProvider);
    ref.listen(conversationCreateControllerProvider, (previous, next) {
      final conversation = next.conversation;
      if (previous?.status != ConversationCreateStatus.success &&
          next.status == ConversationCreateStatus.success &&
          conversation != null) {
        ref
            .read(conversationCreateControllerProvider.notifier)
            .startNewIntent();
        context.go('/conversations/${conversation.conversationId.value}');
      }
    });

    final selectedSpecialistIsAvailable = catalog.items.any(
      (specialist) =>
          specialist.selectableSpecialistId == _selectedSpecialistId &&
          specialist.accessState == SelectableSpecialistAccessState.available,
    );
    final canCreate =
        catalog.phase == SelectableSpecialistCatalogPhase.data &&
        _selectedSpecialistId != null &&
        selectedSpecialistIsAvailable &&
        create.status != ConversationCreateStatus.creating;

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
                  _CatalogContent(
                    state: catalog,
                    selectedSpecialistId: _selectedSpecialistId,
                    onSelected: (value) {
                      setState(() => _selectedSpecialistId = value);
                      ref
                          .read(conversationCreateControllerProvider.notifier)
                          .startNewIntent();
                    },
                    onRetry: () => ref
                        .read(
                          selectableSpecialistCatalogControllerProvider
                              .notifier,
                        )
                        .load(),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  FilledButton(
                    key: const Key('create-conversation'),
                    onPressed: canCreate
                        ? () => ref
                              .read(
                                conversationCreateControllerProvider.notifier,
                              )
                              .create(_selectedSpecialistId!)
                        : null,
                    child: Text(
                      create.status == ConversationCreateStatus.creating
                          ? 'Creando conversación…'
                          : 'Crear conversación',
                    ),
                  ),
                  if (create.status == ConversationCreateStatus.failed) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      conversationSafeError(create.error),
                      key: const Key('create-conversation-error'),
                    ),
                    if (create.error ==
                            ConversationApplicationErrorCode
                                .backendUnavailable ||
                        create.error ==
                            ConversationApplicationErrorCode
                                .idempotencyConflict)
                      TextButton(
                        onPressed: () => ref
                            .read(conversationCreateControllerProvider.notifier)
                            .retry(),
                        child: const Text('Reintentar'),
                      ),
                  ],
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

class _CatalogContent extends StatelessWidget {
  const _CatalogContent({
    required this.state,
    required this.selectedSpecialistId,
    required this.onSelected,
    required this.onRetry,
  });

  final SelectableSpecialistCatalogState state;
  final String? selectedSpecialistId;
  final ValueChanged<String> onSelected;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return switch (state.phase) {
      SelectableSpecialistCatalogPhase.initial ||
      SelectableSpecialistCatalogPhase.loading => const Center(
        child: CircularProgressIndicator(
          key: Key('selectable-specialist-loading'),
        ),
      ),
      SelectableSpecialistCatalogPhase.data => RadioGroup<String>(
        groupValue: selectedSpecialistId,
        onChanged: (value) {
          if (value != null) onSelected(value);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Selecciona un especialista',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            for (final specialist in state.items)
              RadioListTile<String>(
                key: Key(
                  'selectable-specialist-${specialist.selectableSpecialistId}',
                ),
                value: specialist.selectableSpecialistId,
                enabled:
                    specialist.accessState ==
                    SelectableSpecialistAccessState.available,
                title: Text(specialist.displayName),
                subtitle: Text(specialist.publicDescription),
              ),
          ],
        ),
      ),
      SelectableSpecialistCatalogPhase.empty => const Card(
        child: Padding(
          padding: AppSpacing.cardPadding,
          child: Text('No hay especialistas seleccionables disponibles.'),
        ),
      ),
      SelectableSpecialistCatalogPhase.unauthenticated => const Card(
        child: Padding(
          padding: AppSpacing.cardPadding,
          child: Text('Inicia sesión para consultar especialistas.'),
        ),
      ),
      SelectableSpecialistCatalogPhase.environmentBlocked => const Card(
        child: Padding(
          padding: AppSpacing.cardPadding,
          child: Text('El catálogo no está disponible en este entorno.'),
        ),
      ),
      SelectableSpecialistCatalogPhase.error => OutlinedButton(
        onPressed: onRetry,
        child: const Text('Reintentar catálogo'),
      ),
    };
  }
}

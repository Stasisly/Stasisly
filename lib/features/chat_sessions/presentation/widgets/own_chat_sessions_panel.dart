import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:stasisly/features/chat_sessions/application/own_chat_sessions_state.dart';
import 'package:stasisly/features/chat_sessions/domain/entities/own_chat_session.dart';
import 'package:stasisly/features/chat_sessions/domain/entities/own_chat_session_results.dart';
import 'package:stasisly/features/chat_sessions/presentation/providers/own_chat_sessions_providers.dart';

class OwnChatSessionsPanel extends ConsumerStatefulWidget {
  const OwnChatSessionsPanel({
    super.key,
    this.autoLoad = true,
    this.statusFilter = ChatSessionStatusFilter.active,
    this.onOpenSession,
  });

  final bool autoLoad;
  final ChatSessionStatusFilter statusFilter;
  final ValueChanged<String>? onOpenSession;

  @override
  ConsumerState<OwnChatSessionsPanel> createState() =>
      _OwnChatSessionsPanelState();
}

class _OwnChatSessionsPanelState extends ConsumerState<OwnChatSessionsPanel> {
  final TextEditingController _selectableSpecialistIdController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    if (!widget.autoLoad) return;
    Future.microtask(() {
      if (!mounted) return;
      ref
          .read(ownChatSessionsControllerProvider.notifier)
          .loadInitial(status: widget.statusFilter);
    });
  }

  @override
  void dispose() {
    _selectableSpecialistIdController.dispose();
    super.dispose();
  }

  Future<void> _createSession() async {
    final selectableSpecialistId = _selectableSpecialistIdController.text
        .trim();
    if (selectableSpecialistId.isEmpty) return;

    await ref
        .read(ownChatSessionsControllerProvider.notifier)
        .createSession(selectableSpecialistId);

    final state = ref.read(ownChatSessionsStateProvider);
    if (state.lastCreateError == null) {
      _selectableSpecialistIdController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(ownChatSessionsStateProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (state.isDemo) const _DemoLabel(),
        if (state.isBackendBlocked) const _BackendBlockedState(),
        const Text('Acciones de escritura dev-only: no automáticas'),
        _CreateSessionInput(
          controller: _selectableSpecialistIdController,
          isCreating: state.isCreating,
          onCreate: _createSession,
        ),
        const SizedBox(height: 12),
        _StatusStrip(state: state),
        const SizedBox(height: 12),
        Expanded(
          child: _SessionsBody(
            state: state,
            onOpenSession: widget.onOpenSession,
          ),
        ),
        if (state.lastCreateError != null)
          _SessionsErrorState(
            title: 'Error al crear sesión',
            message: _failureLabel(state.lastCreateError!),
          ),
        if (state.lastArchiveError != null)
          _SessionsErrorState(
            title: 'Error al archivar sesión',
            message: _failureLabel(state.lastArchiveError!),
          ),
        const SizedBox(height: 8),
        FilledButton.tonal(
          onPressed: state.isRefreshing
              ? null
              : () => ref
                    .read(ownChatSessionsControllerProvider.notifier)
                    .refresh(status: widget.statusFilter),
          child: Text(state.isRefreshing ? 'Refrescando...' : 'Refrescar'),
        ),
      ],
    );
  }
}

class _CreateSessionInput extends StatelessWidget {
  const _CreateSessionInput({
    required this.controller,
    required this.isCreating,
    required this.onCreate,
  });

  final TextEditingController controller;
  final bool isCreating;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            enabled: !isCreating,
            decoration: const InputDecoration(
              labelText: 'selectableSpecialistId',
              hintText: 'DEV ONLY · acción explícita · catálogo sanitizado',
            ),
            onSubmitted: isCreating ? null : (_) => onCreate(),
          ),
        ),
        const SizedBox(width: 8),
        FilledButton(
          onPressed: isCreating ? null : onCreate,
          child: Text(isCreating ? 'Creando...' : 'Crear sesión'),
        ),
      ],
    );
  }
}

class _StatusStrip extends StatelessWidget {
  const _StatusStrip({required this.state});

  final OwnChatSessionsState state;

  @override
  Widget build(BuildContext context) {
    final selected = state.selectedSessionId;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          selected == null
              ? 'selectedSessionId: sin selección'
              : 'selectedSessionId: $selected',
        ),
        Text('active sessions count: ${state.activeCount}'),
        Text('all sessions count: ${state.sessions.length}'),
        Text('archived sessions count: ${state.archivedCount}'),
        const Text('Fixture sintético retenido: development remoto'),
        const Text(
          'selectedSessionId disponible para futuro flujo de mensajes',
        ),
        if (state.isArchiving) const Text('Archivando sesión...'),
      ],
    );
  }
}

class _SessionsBody extends StatelessWidget {
  const _SessionsBody({required this.state, required this.onOpenSession});

  final OwnChatSessionsState state;
  final ValueChanged<String>? onOpenSession;

  @override
  Widget build(BuildContext context) {
    if (state.isInitialLoading) {
      return const _SessionsLoadingState();
    }

    if (state.lastListError != null && state.sessions.isEmpty) {
      return _SessionsErrorState(
        title: 'Error al cargar sesiones',
        message: _failureLabel(state.lastListError!),
      );
    }

    if (state.sessions.isEmpty) {
      return const _SessionsEmptyState();
    }

    return _SessionsList(
      sessions: state.sessions,
      selectedSessionId: state.selectedSessionId,
      onOpenSession: onOpenSession,
    );
  }
}

class _SessionsList extends StatelessWidget {
  const _SessionsList({
    required this.sessions,
    required this.selectedSessionId,
    required this.onOpenSession,
  });

  final List<OwnChatSession> sessions;
  final String? selectedSessionId;
  final ValueChanged<String>? onOpenSession;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: sessions.length,
      itemBuilder: (context, index) {
        final session = sessions[index];
        return _SessionTile(
          session: session,
          isSelected: session.sessionId == selectedSessionId,
          onOpenSession: onOpenSession,
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 8),
    );
  }
}

class _SessionTile extends ConsumerWidget {
  const _SessionTile({
    required this.session,
    required this.isSelected,
    required this.onOpenSession,
  });

  final OwnChatSession session;
  final bool isSelected;
  final ValueChanged<String>? onOpenSession;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      color: isSelected ? colorScheme.primaryContainer : null,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(session.selectableSpecialist.displayName),
            Text('Área: ${_areaLabel(session.selectableSpecialist.area)}'),
            Text('sessionId: ${session.sessionId}'),
            Text('Mensajes: ${session.messageCount}'),
            Text('Estado: ${_statusLabel(session.status)}'),
            if (isSelected) const Text('Sesión seleccionada'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                OutlinedButton(
                  onPressed: () => ref
                      .read(ownChatSessionsControllerProvider.notifier)
                      .selectSession(session.sessionId),
                  child: const Text('Seleccionar sessionId'),
                ),
                if (onOpenSession != null)
                  OutlinedButton(
                    onPressed: () => onOpenSession!(session.sessionId),
                    child: const Text('Abrir mensajes dev-only'),
                  ),
                OutlinedButton(
                  onPressed: () => ref
                      .read(ownChatSessionsControllerProvider.notifier)
                      .archiveSession(session.sessionId),
                  child: const Text('Archivar sessionId'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SessionsLoadingState extends StatelessWidget {
  const _SessionsLoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Cargando sesiones...'));
  }
}

class _SessionsEmptyState extends StatelessWidget {
  const _SessionsEmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('No hay sesiones todavía'));
  }
}

class _SessionsErrorState extends StatelessWidget {
  const _SessionsErrorState({required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text('$title: $message'),
    );
  }
}

class _DemoLabel extends StatelessWidget {
  const _DemoLabel();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Text('MODO DEMO SESIONES'),
    );
  }
}

class _BackendBlockedState extends StatelessWidget {
  const _BackendBlockedState();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Text('Backend bloqueado para sesiones'),
    );
  }
}

String _failureLabel(OwnChatSessionsFailureType type) {
  return switch (type) {
    OwnChatSessionsFailureType.unauthenticated =>
      'La identidad no está autenticada.',
    OwnChatSessionsFailureType.invalidSession => 'La sesión no es válida.',
    OwnChatSessionsFailureType.invalidRequest => 'La petición no es válida.',
    OwnChatSessionsFailureType.invalidIdempotencyKey =>
      'La operación no tiene una clave válida.',
    OwnChatSessionsFailureType.idempotencyConflict =>
      'La operación entra en conflicto con un intento anterior.',
    OwnChatSessionsFailureType.operationInProgress =>
      'La operación continúa en curso.',
    OwnChatSessionsFailureType.transactionFailed =>
      'El backend no pudo completar la operación.',
    OwnChatSessionsFailureType.invalidSelectableSpecialist =>
      'El especialista seleccionable no es válido.',
    OwnChatSessionsFailureType.specialistUnavailable =>
      'El especialista no está disponible.',
    OwnChatSessionsFailureType.proLocked =>
      'La sesión requiere una membresía no disponible.',
    OwnChatSessionsFailureType.sessionNotFound =>
      'La sesión no existe o no está disponible.',
    OwnChatSessionsFailureType.permissionDenied =>
      'No hay permisos para esta operación.',
    OwnChatSessionsFailureType.contractViolation =>
      'La respuesta no cumple el contrato esperado.',
    OwnChatSessionsFailureType.backendBlocked =>
      'El backend real continúa bloqueado.',
    OwnChatSessionsFailureType.networkError =>
      'No se pudo contactar con el backend.',
    OwnChatSessionsFailureType.unexpectedError => 'Error inesperado.',
  };
}

String _areaLabel(SelectableSpecialistSummaryArea area) {
  return switch (area) {
    SelectableSpecialistSummaryArea.stasis => 'Stasis',
    SelectableSpecialistSummaryArea.health => 'Salud',
    SelectableSpecialistSummaryArea.nutrition => 'Nutrición',
    SelectableSpecialistSummaryArea.training => 'Entrenamiento',
    SelectableSpecialistSummaryArea.wellness => 'Wellness',
  };
}

String _statusLabel(ChatSessionStatus status) {
  return switch (status) {
    ChatSessionStatus.active => 'Activa',
    ChatSessionStatus.archived => 'Archivada',
  };
}

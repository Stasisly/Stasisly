import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:stasisly/features/chat_messages/application/own_chat_messages_state.dart';
import 'package:stasisly/features/chat_messages/domain/entities/own_chat_message.dart';
import 'package:stasisly/features/chat_messages/domain/entities/own_chat_message_results.dart';
import 'package:stasisly/features/chat_messages/presentation/providers/own_chat_messages_providers.dart';

class OwnChatMessagesPanel extends ConsumerStatefulWidget {
  const OwnChatMessagesPanel({super.key, this.sessionId, this.autoLoad = true});

  final String? sessionId;
  final bool autoLoad;

  @override
  ConsumerState<OwnChatMessagesPanel> createState() =>
      _OwnChatMessagesPanelState();
}

class _OwnChatMessagesPanelState extends ConsumerState<OwnChatMessagesPanel> {
  final TextEditingController _inputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSessionIfNeeded();
  }

  @override
  void didUpdateWidget(covariant OwnChatMessagesPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.sessionId != widget.sessionId) {
      _loadSessionIfNeeded();
    }
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  void _loadSessionIfNeeded() {
    if (!widget.autoLoad) return;
    final sessionId = widget.sessionId;
    if (sessionId == null || sessionId.trim().isEmpty) return;
    Future.microtask(() {
      if (!mounted) return;
      ref
          .read(ownChatMessagesControllerProvider.notifier)
          .loadInitial(sessionId);
    });
  }

  Future<void> _sendCurrentContent() async {
    final content = _inputController.text.trim();
    if (content.isEmpty) return;

    await ref
        .read(ownChatMessagesControllerProvider.notifier)
        .sendMessage(content);

    final state = ref.read(ownChatMessagesStateProvider);
    if (state.lastSendError == null) {
      _inputController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(ownChatMessagesStateProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (state.isDemo) const _DemoLabel(),
        if (state.isBackendBlocked) const _BackendBlockedState(),
        Expanded(child: _MessagesBody(state: state)),
        if (state.nextCursor != null)
          _PaginationButton(isPaginating: state.isPaginating),
        if (state.lastSendError != null)
          _MessagesErrorState(
            message: _sendErrorLabel(state.lastSendError!),
            kind: _ErrorKind.send,
          ),
        _MessageInput(
          controller: _inputController,
          isSending: state.isSending,
          onSend: _sendCurrentContent,
        ),
      ],
    );
  }
}

class _MessagesBody extends StatelessWidget {
  const _MessagesBody({required this.state});

  final OwnChatMessagesState state;

  @override
  Widget build(BuildContext context) {
    if (state.sessionId == null && !state.isInitialLoading) {
      return const Center(
        child: Text('Selecciona una sesión para ver mensajes'),
      );
    }

    if (state.isInitialLoading) {
      return const _MessagesLoadingState();
    }

    if (state.lastListError != null && state.messages.isEmpty) {
      return _MessagesErrorState(
        message: _listErrorLabel(state.lastListError!),
        kind: _ErrorKind.list,
      );
    }

    if (state.messages.isEmpty) {
      return const _MessagesEmptyState();
    }

    return _MessagesList(messages: state.messages);
  }
}

class _MessagesList extends StatelessWidget {
  const _MessagesList({required this.messages});

  final List<OwnChatMessage> messages;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: messages.length,
      itemBuilder: (context, index) {
        return _MessageBubble(message: messages[index]);
      },
      separatorBuilder: (context, index) => const SizedBox(height: 8),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});

  final OwnChatMessage message;

  @override
  Widget build(BuildContext context) {
    final alignment = message.role == OwnChatMessageRole.user
        ? Alignment.centerRight
        : Alignment.centerLeft;
    final color = message.role == OwnChatMessageRole.user
        ? Theme.of(context).colorScheme.primaryContainer
        : Theme.of(context).colorScheme.surfaceContainerHighest;

    return Align(
      alignment: alignment,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _messageRoleLabel(message.role),
                style: Theme.of(context).textTheme.labelSmall,
              ),
              const SizedBox(height: 4),
              Text(message.content),
            ],
          ),
        ),
      ),
    );
  }
}

class _MessageInput extends StatelessWidget {
  const _MessageInput({
    required this.controller,
    required this.isSending,
    required this.onSend,
  });

  final TextEditingController controller;
  final bool isSending;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            enabled: !isSending,
            decoration: const InputDecoration(
              labelText: 'Mensaje',
              hintText: 'Escribe un mensaje',
            ),
            onSubmitted: isSending ? null : (_) => onSend(),
          ),
        ),
        const SizedBox(width: 8),
        FilledButton(
          onPressed: isSending ? null : onSend,
          child: Text(isSending ? 'Enviando...' : 'Enviar'),
        ),
      ],
    );
  }
}

class _MessagesLoadingState extends StatelessWidget {
  const _MessagesLoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Cargando mensajes...'));
  }
}

class _MessagesEmptyState extends StatelessWidget {
  const _MessagesEmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('No hay mensajes todavía'));
  }
}

class _MessagesErrorState extends StatelessWidget {
  const _MessagesErrorState({required this.message, required this.kind});

  final String message;
  final _ErrorKind kind;

  @override
  Widget build(BuildContext context) {
    final prefix = switch (kind) {
      _ErrorKind.list => 'Error al cargar mensajes',
      _ErrorKind.send => 'Error al enviar mensaje',
    };
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text('$prefix: $message'),
    );
  }
}

class _PaginationButton extends ConsumerWidget {
  const _PaginationButton({required this.isPaginating});

  final bool isPaginating;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Align(
      child: TextButton(
        onPressed: isPaginating
            ? null
            : () => ref
                  .read(ownChatMessagesControllerProvider.notifier)
                  .loadNextPage(),
        child: Text(isPaginating ? 'Cargando más...' : 'Cargar más'),
      ),
    );
  }
}

class _DemoLabel extends StatelessWidget {
  const _DemoLabel();

  @override
  Widget build(BuildContext context) {
    return const Text('MODO DEMO MENSAJES');
  }
}

class _BackendBlockedState extends StatelessWidget {
  const _BackendBlockedState();

  @override
  Widget build(BuildContext context) {
    return const Text('Backend bloqueado para mensajes');
  }
}

enum _ErrorKind { list, send }

String _messageRoleLabel(OwnChatMessageRole role) {
  return switch (role) {
    OwnChatMessageRole.user => 'Usuario',
    OwnChatMessageRole.assistant => 'Asistente',
    OwnChatMessageRole.system => 'Sistema',
    OwnChatMessageRole.tool => 'Herramienta',
  };
}

String _sendErrorLabel(SendOwnChatMessageFailureType error) {
  return switch (error) {
    SendOwnChatMessageFailureType.sessionArchived =>
      'La sesión está archivada y no admite nuevos mensajes.',
    SendOwnChatMessageFailureType.sessionNotFound =>
      'No se pudo encontrar la sesión.',
    SendOwnChatMessageFailureType.networkError =>
      'No se pudo contactar con el backend.',
    SendOwnChatMessageFailureType.contractViolation =>
      'La respuesta no cumple el contrato esperado.',
    SendOwnChatMessageFailureType.backendBlocked => 'Backend bloqueado.',
    SendOwnChatMessageFailureType.unauthenticated => 'Sesión no autenticada.',
    SendOwnChatMessageFailureType.invalidSession => 'Sesión no válida.',
    SendOwnChatMessageFailureType.invalidRequest => 'Solicitud no válida.',
    SendOwnChatMessageFailureType.contentInvalid => 'Mensaje no válido.',
    SendOwnChatMessageFailureType.contentTooLong => 'Mensaje demasiado largo.',
    SendOwnChatMessageFailureType.permissionDenied => 'Permiso denegado.',
    SendOwnChatMessageFailureType.writeUnconfirmed =>
      'El backend no confirmó la escritura.',
    SendOwnChatMessageFailureType.backendMisconfigured =>
      'Backend mal configurado.',
    SendOwnChatMessageFailureType.unexpectedError => 'Error inesperado.',
  };
}

String _listErrorLabel(ListOwnChatMessagesFailureType error) {
  return switch (error) {
    ListOwnChatMessagesFailureType.sessionNotFound =>
      'No se pudo encontrar la sesión.',
    ListOwnChatMessagesFailureType.networkError =>
      'No se pudo contactar con el backend.',
    ListOwnChatMessagesFailureType.contractViolation =>
      'La respuesta no cumple el contrato esperado.',
    ListOwnChatMessagesFailureType.backendBlocked => 'Backend bloqueado.',
    ListOwnChatMessagesFailureType.unauthenticated => 'Sesión no autenticada.',
    ListOwnChatMessagesFailureType.invalidSession => 'Sesión no válida.',
    ListOwnChatMessagesFailureType.invalidRequest => 'Solicitud no válida.',
    ListOwnChatMessagesFailureType.invalidCursor => 'Cursor no válido.',
    ListOwnChatMessagesFailureType.permissionDenied => 'Permiso denegado.',
    ListOwnChatMessagesFailureType.backendMisconfigured =>
      'Backend mal configurado.',
    ListOwnChatMessagesFailureType.unexpectedError => 'Error inesperado.',
  };
}

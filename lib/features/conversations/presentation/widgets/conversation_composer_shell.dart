import 'package:flutter/material.dart';

import 'package:stasisly/core/theme/app_spacing.dart';
import 'package:stasisly/features/conversations/domain/entities/conversation_message.dart';

class ConversationComposerShell extends StatefulWidget {
  const ConversationComposerShell({
    required this.controller,
    required this.onSendIntent,
    this.enabled = true,
    this.submitting = false,
    super.key,
  });

  final TextEditingController controller;
  final ValueChanged<String> onSendIntent;
  final bool enabled;
  final bool submitting;

  @override
  State<ConversationComposerShell> createState() =>
      _ConversationComposerShellState();
}

class _ConversationComposerShellState extends State<ConversationComposerShell> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handleTextChanged);
  }

  @override
  void didUpdateWidget(ConversationComposerShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_handleTextChanged);
      widget.controller.addListener(_handleTextChanged);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleTextChanged);
    super.dispose();
  }

  void _handleTextChanged() => setState(() {});

  bool get _canSubmit {
    final text = widget.controller.text.trim();
    return widget.enabled &&
        !widget.submitting &&
        text.isNotEmpty &&
        text.length <= ConversationMessage.maxContentLength;
  }

  void _emitIntent() {
    if (!_canSubmit) return;
    widget.onSendIntent(widget.controller.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surface,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  enabled: widget.enabled && !widget.submitting,
                  minLines: 1,
                  maxLines: 5,
                  maxLength: ConversationMessage.maxContentLength,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _emitIntent(),
                  decoration: const InputDecoration(
                    labelText: 'Mensaje',
                    hintText: 'Escribe un mensaje',
                    counterText: '',
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Semantics(
                button: true,
                label: widget.submitting
                    ? 'Enviando mensaje'
                    : 'Enviar mensaje',
                child: IconButton.filled(
                  constraints: const BoxConstraints.tightFor(
                    width: AppSpacing.massive,
                    height: AppSpacing.massive,
                  ),
                  tooltip: widget.submitting
                      ? 'Enviando mensaje'
                      : 'Enviar mensaje',
                  onPressed: _canSubmit ? _emitIntent : null,
                  icon: widget.submitting
                      ? const SizedBox.square(
                          dimension: AppSpacing.iconMd,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.send_outlined),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

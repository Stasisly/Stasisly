import 'package:flutter/material.dart';

import 'package:stasisly/core/theme/app_colors.dart';
import 'package:stasisly/core/theme/app_spacing.dart';

class ChatInput extends StatefulWidget {
  const ChatInput({
    required this.onSend,
    super.key,
  });

  final void Function(String text, List<String>? attachments) onSend;

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final _controller = TextEditingController();
  final List<String> _attachments = [];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isEmpty && _attachments.isEmpty) return;

    widget.onSend(text, _attachments.isEmpty ? null : List.from(_attachments));
    _controller.clear();
    setState(() {
      _attachments.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: AppSpacing.sm,
        right: AppSpacing.sm,
        top: AppSpacing.sm,
        bottom: AppSpacing.sm + MediaQuery.paddingOf(context).bottom,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surfaceDark,
        border: Border(
          top: BorderSide(color: AppColors.borderDark, width: 0.5),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_attachments.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(
                  left: AppSpacing.sm,
                  bottom: AppSpacing.sm,
                ),
                child: Wrap(
                  spacing: AppSpacing.xs,
                  children: _attachments.map((file) {
                    return Chip(
                      label: Text(file),
                      onDeleted: () {
                        setState(() {
                          _attachments.remove(file);
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  color: AppColors.textSecondaryDark,
                  onPressed: () {
                    // Mock file picker
                    setState(() {
                      _attachments.add('analitica.pdf');
                    });
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    minLines: 1,
                    maxLines: 5,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _handleSend(),
                    decoration: const InputDecoration(
                      hintText: 'Escribe un mensaje...',
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      fillColor: Colors.transparent,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.md,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  color: AppColors.primary,
                  onPressed: _handleSend,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

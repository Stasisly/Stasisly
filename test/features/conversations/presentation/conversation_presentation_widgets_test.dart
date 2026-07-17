import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:stasisly/features/conversations/presentation/models/conversation_message_view_model.dart';
import 'package:stasisly/features/conversations/presentation/widgets/conversation_composer_shell.dart';
import 'package:stasisly/features/conversations/presentation/widgets/conversation_message_bubble.dart';
import 'package:stasisly/features/conversations/presentation/widgets/conversation_redacted_message.dart';
import 'package:stasisly/features/conversations/presentation/widgets/conversation_states.dart';
import 'package:stasisly/features/conversations/presentation/widgets/conversation_system_notice.dart';

void main() {
  Widget app(Widget child, {double textScale = 1}) {
    return MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(textScaler: TextScaler.linear(textScale)),
        child: Scaffold(body: child),
      ),
    );
  }

  ConversationMessageViewModel viewModel({
    ConversationMessageVisualKind kind = ConversationMessageVisualKind.user,
    String author = 'Tú',
    String content = 'Mensaje visible',
    bool redacted = false,
  }) {
    return ConversationMessageViewModel(
      messageId: 'message-safe',
      displayAuthor: author,
      content: content,
      displayTimestamp: '09:05',
      visualKind: kind,
      deliveryState: ConversationMessageDeliveryState.accepted,
      accessibilityLabel: '$author, 09:05: $content',
      isRedacted: redacted,
    );
  }

  testWidgets('renders user message with semantic label', (tester) async {
    final message = viewModel();
    await tester.pumpWidget(app(ConversationMessageBubble(message: message)));

    expect(find.text('Mensaje visible'), findsOneWidget);
    expect(find.bySemanticsLabel(message.accessibilityLabel), findsOneWidget);
    expect(
      tester.widget<Align>(find.byType(Align)).alignment,
      Alignment.centerRight,
    );
  });

  testWidgets('renders verified Stasis and specialist as non-user visuals', (
    tester,
  ) async {
    await tester.pumpWidget(
      app(
        Column(
          children: [
            ConversationMessageBubble(
              message: viewModel(
                kind: ConversationMessageVisualKind.stasis,
                author: 'Stasis',
              ),
            ),
            ConversationMessageBubble(
              message: viewModel(
                kind: ConversationMessageVisualKind.specialist,
                author: 'Especialista nutrición',
              ),
            ),
          ],
        ),
      ),
    );

    expect(find.text('Stasis'), findsOneWidget);
    expect(find.text('Especialista nutrición'), findsOneWidget);
  });

  testWidgets('system notice uses dedicated safe visual', (tester) async {
    await tester.pumpWidget(
      app(
        ConversationMessageBubble(
          message: viewModel(
            kind: ConversationMessageVisualKind.systemNotice,
            author: 'Aviso del sistema',
          ),
        ),
      ),
    );

    expect(find.byType(ConversationSystemNotice), findsOneWidget);
  });

  test('unknown visual kind cannot construct a renderable model', () {
    expect(
      () => viewModel(kind: ConversationMessageVisualKind.unknown),
      throwsArgumentError,
    );
  });

  testWidgets('redacted visual contains placeholder and no original content', (
    tester,
  ) async {
    const original = 'contenido privado original';
    await tester.pumpWidget(
      app(
        ConversationMessageBubble(
          message: viewModel(
            kind: ConversationMessageVisualKind.redacted,
            content: 'Contenido no disponible',
            redacted: true,
          ),
        ),
      ),
    );

    expect(find.byType(ConversationRedactedMessage), findsOneWidget);
    expect(find.text('Contenido no disponible'), findsOneWidget);
    expect(find.text(original), findsNothing);
  });

  testWidgets('long content, text scaling and representative widths render', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 700));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final content = List.filled(80, 'contenido').join(' ');

    await tester.pumpWidget(
      app(
        SingleChildScrollView(
          child: ConversationMessageBubble(
            message: viewModel(content: content),
          ),
        ),
        textScale: 2,
      ),
    );
    expect(tester.takeException(), isNull);

    await tester.binding.setSurfaceSize(const Size(1200, 800));
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  testWidgets('composer emits trimmed content for button and keyboard intent', (
    tester,
  ) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    final intents = <String>[];
    await tester.pumpWidget(
      app(
        ConversationComposerShell(
          controller: controller,
          onSendIntent: intents.add,
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), '  primer mensaje  ');
    await tester.pump();
    await tester.tap(find.byIcon(Icons.send_outlined));
    expect(intents, ['primer mensaje']);

    await tester.enterText(find.byType(TextField), 'segundo mensaje');
    await tester.testTextInput.receiveAction(TextInputAction.send);
    expect(intents, ['primer mensaje', 'segundo mensaje']);
  });

  testWidgets(
    'composer rejects empty input and exposes accessible send action',
    (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      final intents = <String>[];
      await tester.pumpWidget(
        app(
          ConversationComposerShell(
            controller: controller,
            onSendIntent: intents.add,
          ),
        ),
      );

      expect(find.bySemanticsLabel('Enviar mensaje'), findsOneWidget);
      await tester.tap(find.byTooltip('Enviar mensaje'));
      expect(intents, isEmpty);
    },
  );

  testWidgets('disabled and submitting composer never emit intent', (
    tester,
  ) async {
    final controller = TextEditingController(text: 'contenido');
    addTearDown(controller.dispose);
    final intents = <String>[];

    await tester.pumpWidget(
      app(
        ConversationComposerShell(
          controller: controller,
          onSendIntent: intents.add,
          enabled: false,
        ),
      ),
    );
    expect(find.byType(TextField), findsOneWidget);
    expect(intents, isEmpty);

    await tester.pumpWidget(
      app(
        ConversationComposerShell(
          controller: controller,
          onSendIntent: intents.add,
          submitting: true,
        ),
      ),
    );
    expect(find.bySemanticsLabel('Enviando mensaje'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(intents, isEmpty);
  });

  testWidgets('empty, loading and error states announce their meaning', (
    tester,
  ) async {
    await tester.pumpWidget(app(const ConversationEmptyState()));
    expect(find.bySemanticsLabel('Conversación vacía'), findsOneWidget);

    await tester.pumpWidget(app(const ConversationLoadingState()));
    expect(find.bySemanticsLabel('Cargando conversación'), findsOneWidget);

    await tester.pumpWidget(app(const ConversationErrorState()));
    expect(
      find.bySemanticsLabel('No se pudo cargar la conversación.'),
      findsOneWidget,
    );
  });
}

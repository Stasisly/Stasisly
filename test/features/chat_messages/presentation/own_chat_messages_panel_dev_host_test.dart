import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:stasisly/features/chat_messages/presentation/dev/own_chat_messages_panel_dev_host.dart';
import 'package:stasisly/features/chat_messages/presentation/widgets/own_chat_messages_panel.dart';

void main() {
  testWidgets(
    'host renders OwnChatMessagesPanel with fake messages and roles',
    (tester) async {
      await _pumpHost(tester);

      expect(find.byType(OwnChatMessagesPanel), findsOneWidget);
      expect(find.text('Mensaje ficticio de usuario.'), findsOneWidget);
      expect(find.text('Respuesta ficticia de asistente.'), findsOneWidget);
      expect(find.text('Aviso ficticio de sistema.'), findsOneWidget);
      expect(find.text('Resultado ficticio de herramienta.'), findsOneWidget);
      expect(find.text('Usuario'), findsOneWidget);
      expect(find.text('Asistente'), findsOneWidget);
      expect(find.text('Sistema'), findsOneWidget);
      expect(find.text('Herramienta'), findsOneWidget);
    },
  );

  testWidgets('host renders empty, loading, demo and backendBlocked states', (
    tester,
  ) async {
    await _pumpHost(tester, OwnChatMessagesPanelDevScenario.empty);
    expect(find.text('No hay mensajes todavía'), findsOneWidget);

    await _pumpHost(tester, OwnChatMessagesPanelDevScenario.loading);
    expect(find.text('Cargando mensajes...'), findsOneWidget);

    await _pumpHost(tester, OwnChatMessagesPanelDevScenario.demo);
    expect(find.text('MODO DEMO MENSAJES'), findsOneWidget);

    await _pumpHost(tester, OwnChatMessagesPanelDevScenario.backendBlocked);
    expect(find.text('Backend bloqueado para mensajes'), findsOneWidget);
  });

  testWidgets('host renders controlled list and send errors', (tester) async {
    await _pumpHost(tester, OwnChatMessagesPanelDevScenario.listError);
    expect(find.textContaining('Error al cargar mensajes:'), findsOneWidget);

    await _pumpHost(tester, OwnChatMessagesPanelDevScenario.sendError);
    expect(find.textContaining('Error al enviar mensaje:'), findsOneWidget);

    for (final scenario in [
      OwnChatMessagesPanelDevScenario.sessionArchived,
      OwnChatMessagesPanelDevScenario.sessionNotFound,
      OwnChatMessagesPanelDevScenario.networkError,
      OwnChatMessagesPanelDevScenario.contractViolation,
    ]) {
      await _pumpHost(tester, scenario);
      await tester.enterText(find.byType(TextField), 'mensaje local');
      await tester.tap(find.text('Enviar'));
      await tester.pump();

      expect(find.textContaining('Error al enviar mensaje:'), findsOneWidget);
    }
  });

  testWidgets('host simulates sending only content', (tester) async {
    await _pumpHost(tester);

    await tester.enterText(find.byType(TextField), '  contenido fake  ');
    await tester.tap(find.text('Enviar'));
    await tester.pump();

    expect(find.text('contenido fake'), findsOneWidget);
  });

  testWidgets('host shows pagination with cursor and hides it without cursor', (
    tester,
  ) async {
    await _pumpHost(tester, OwnChatMessagesPanelDevScenario.pagination);
    expect(find.text('Cargar más'), findsOneWidget);

    await tester.tap(find.text('Cargar más'));
    await tester.pump();

    expect(
      find.text('Respuesta ficticia de pagina siguiente.'),
      findsOneWidget,
    );
    expect(find.text('Cargar más'), findsNothing);

    await _pumpHost(tester, OwnChatMessagesPanelDevScenario.noPagination);
    expect(find.text('Cargar más'), findsNothing);
  });

  testWidgets('host renders sending and paginating visual states', (
    tester,
  ) async {
    await _pumpHost(tester, OwnChatMessagesPanelDevScenario.sending);
    expect(find.text('Enviando...'), findsOneWidget);

    await _pumpHost(tester, OwnChatMessagesPanelDevScenario.paginating);
    expect(find.text('Cargando más...'), findsOneWidget);
  });
}

Future<void> _pumpHost(
  WidgetTester tester, [
  OwnChatMessagesPanelDevScenario scenario =
      OwnChatMessagesPanelDevScenario.messages,
]) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: OwnChatMessagesPanelDevHost(key: UniqueKey(), scenario: scenario),
      ),
    ),
  );
}

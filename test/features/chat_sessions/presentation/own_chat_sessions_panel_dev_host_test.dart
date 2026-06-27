import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:stasisly/features/chat_sessions/presentation/dev/own_chat_sessions_panel_dev_host.dart';
import 'package:stasisly/features/chat_sessions/presentation/widgets/own_chat_sessions_panel.dart';

const _selectableInput = '10000000-0000-4000-8000-0000000000f1';
const _createdSession = '20000000-0000-4000-8000-0000000000c3';
const _selectedSession = '20000000-0000-4000-8000-0000000000a1';

void main() {
  testWidgets('host renders the isolated sessions panel', (tester) async {
    await _pumpHost(tester);

    expect(find.byType(OwnChatSessionsPanel), findsOneWidget);
    expect(find.text('chat_sessions dev host'), findsOneWidget);
    expect(find.text('Especialista ficticio Wellness'), findsOneWidget);
    expect(find.text('Especialista ficticio Salud'), findsOneWidget);
  });

  testWidgets('host renders selected, empty and loading states', (
    tester,
  ) async {
    await _pumpHost(tester, OwnChatSessionsPanelDevScenario.selected);
    expect(find.text('selectedSessionId: $_selectedSession'), findsOneWidget);
    expect(find.text('Sesión seleccionada'), findsOneWidget);

    await _pumpHost(tester, OwnChatSessionsPanelDevScenario.empty);
    expect(find.text('No hay sesiones todavía'), findsOneWidget);
    expect(find.text('selectedSessionId: sin selección'), findsOneWidget);

    await _pumpHost(tester, OwnChatSessionsPanelDevScenario.loading);
    expect(find.text('Cargando sesiones...'), findsOneWidget);
  });

  testWidgets('host renders demo and backendBlocked states', (tester) async {
    await _pumpHost(tester, OwnChatSessionsPanelDevScenario.demo);
    expect(find.text('MODO DEMO SESIONES'), findsOneWidget);
    expect(find.text('Especialista ficticio Wellness'), findsOneWidget);

    await _pumpHost(tester, OwnChatSessionsPanelDevScenario.backendBlocked);
    expect(find.text('Backend bloqueado para sesiones'), findsOneWidget);
  });

  testWidgets('host renders list, create and archive errors', (tester) async {
    await _pumpHost(tester, OwnChatSessionsPanelDevScenario.listError);
    expect(
      find.text(
        'Error al cargar sesiones: No se pudo contactar con el backend.',
      ),
      findsOneWidget,
    );

    await _pumpHost(tester, OwnChatSessionsPanelDevScenario.createError);
    await tester.enterText(find.byType(TextField), _selectableInput);
    await tester.tap(find.text('Crear sesión'));
    await tester.pump();
    expect(
      find.text(
        'Error al crear sesión: El especialista seleccionable no es válido.',
      ),
      findsOneWidget,
    );

    await _pumpHost(tester, OwnChatSessionsPanelDevScenario.archiveError);
    await tester.tap(find.text('Archivar sessionId').first);
    await tester.pump();
    expect(
      find.text(
        'Error al archivar sesión: La sesión no existe o no está disponible.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('host renders creating and archiving states', (tester) async {
    await _pumpHost(tester, OwnChatSessionsPanelDevScenario.creating);
    expect(find.text('Creando...'), findsOneWidget);

    await _pumpHost(tester, OwnChatSessionsPanelDevScenario.archiving);
    expect(find.text('Archivando sesión...'), findsOneWidget);
  });

  testWidgets('host create uses selectableSpecialistId and exposes sessionId', (
    tester,
  ) async {
    await _pumpHost(tester);

    await tester.enterText(find.byType(TextField), '  $_selectableInput  ');
    await tester.tap(find.text('Crear sesión'));
    await tester.pump();

    expect(find.text('Especialista ficticio creado'), findsOneWidget);
    expect(find.text('selectedSessionId: $_createdSession'), findsOneWidget);
    expect(find.textContaining(_selectableInput), findsNothing);
  });

  testWidgets('host select and archive use visible sessionId controls', (
    tester,
  ) async {
    await _pumpHost(tester);

    await tester.tap(find.text('Seleccionar sessionId').first);
    await tester.pump();
    expect(find.text('selectedSessionId: $_selectedSession'), findsOneWidget);

    await tester.tap(find.text('Archivar sessionId').first);
    await tester.pump();
    expect(find.text('sessionId: $_selectedSession'), findsNothing);
  });

  testWidgets('host refresh keeps fake local state', (tester) async {
    await _pumpHost(tester, OwnChatSessionsPanelDevScenario.empty);

    await tester.tap(find.text('Refrescar'));
    await tester.pump();

    expect(find.text('Especialista ficticio Wellness'), findsOneWidget);
    expect(find.text('Especialista ficticio Salud'), findsOneWidget);
  });
}

Future<void> _pumpHost(
  WidgetTester tester, [
  OwnChatSessionsPanelDevScenario scenario =
      OwnChatSessionsPanelDevScenario.sessions,
]) async {
  await tester.pumpWidget(
    OwnChatSessionsPanelDevHost(key: UniqueKey(), scenario: scenario),
  );
  await tester.pump();
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stasisly/features/conversations/composition/conversation_providers.dart';
import 'package:stasisly/features/conversations/composition/inactive_conversation_feature_host.dart';
import 'package:stasisly/features/conversations/domain/entities/conversation.dart';
import 'package:stasisly/features/conversations/domain/results/conversation_results.dart';
import 'package:stasisly/features/conversations/domain/value_objects/conversation_id.dart';

import '../support/conversation_test_support.dart';

void main() {
  testWidgets('renders canonical list, filters and emits selection only', (
    tester,
  ) async {
    final repository = FakeConversationRepository()
      ..onList = (status, _, _) async => ConversationListSuccess(
        ConversationPage(
          items: [
            conversation(
              status: status == ConversationStatusFilter.archived
                  ? ConversationStatus.archived
                  : ConversationStatus.active,
            ),
          ],
          nextCursor: null,
        ),
      );
    ConversationId? selected;
    await tester.pumpWidget(
      _app(
        repository,
        InactiveConversationFeatureHost(
          onConversationSelected: (id) => selected = id,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Conversación sintética'), findsOneWidget);
    await tester.tap(find.text('Conversación sintética'));
    expect(selected, ConversationId('conversation-1'));

    await tester.tap(find.text('Archivadas'));
    await tester.pumpAndSettle();
    expect(find.text('Archivada'), findsOneWidget);
    expect(repository.listStatuses.last, ConversationStatusFilter.archived);
  });

  testWidgets(
    'renders active detail, canonical message and content-only send',
    (tester) async {
      final repository = FakeConversationRepository();
      await tester.pumpWidget(
        _app(
          repository,
          InactiveConversationFeatureHost(
            conversationId: ConversationId('conversation-1'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Mensaje sintético'), findsOneWidget);
      expect(find.text('Archivar'), findsOneWidget);
      final field = find.byType(TextField);
      expect(field, findsOneWidget);
      await tester.enterText(field, 'mensaje desde host');
      await tester.pump();
      await tester.tap(find.byIcon(Icons.send_outlined));
      await tester.pumpAndSettle();
      expect(repository.sendInputs.single.content, 'mensaje desde host');
      expect(find.text('mensaje desde host'), findsNothing);
    },
  );

  testWidgets('archived detail keeps history, disables composer and restores', (
    tester,
  ) async {
    final repository = FakeConversationRepository()
      ..readResult = ConversationReadSuccess(
        conversation(status: ConversationStatus.archived),
      );
    await tester.pumpWidget(
      _app(
        repository,
        InactiveConversationFeatureHost(
          conversationId: ConversationId('conversation-1'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Mensaje sintético'), findsOneWidget);
    expect(tester.widget<TextField>(find.byType(TextField)).enabled, isFalse);
    await tester.tap(find.text('Restaurar'));
    await tester.pumpAndSettle();
    expect(repository.restoreCalls, 1);
    expect(find.text('Archivar'), findsOneWidget);
  });

  testWidgets('environment and auth failures use safe controlled copy', (
    tester,
  ) async {
    for (final entry in {
      ConversationResultStatus.environmentBlocked:
          'Esta composición está bloqueada en el entorno actual.',
      ConversationResultStatus.unauthenticated: 'Necesitas una sesión válida.',
    }.entries) {
      final repository = FakeConversationRepository()
        ..listResult = ConversationListFailure(entry.key);
      await tester.pumpWidget(
        _app(
          repository,
          InactiveConversationFeatureHost(key: ValueKey(entry.key)),
        ),
      );
      await tester.pump();
      await tester.pump();
      expect(find.text(entry.value), findsOneWidget);
    }
  });
}

Widget _app(FakeConversationRepository repository, Widget child) {
  return ProviderScope(
    overrides: [conversationRepositoryProvider.overrideWithValue(repository)],
    child: MaterialApp(
      home: Scaffold(body: SizedBox(width: 800, height: 700, child: child)),
    ),
  );
}

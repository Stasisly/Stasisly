import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:stasisly/features/conversations/composition/conversation_providers.dart';
import 'package:stasisly/features/conversations/product/presentation/stasis_page.dart';
import 'package:stasisly/features/specialists/domain/entities/selectable_specialist.dart';
import 'package:stasisly/features/specialists/domain/entities/selectable_specialists_result.dart';
import 'package:stasisly/features/specialists/domain/repositories/selectable_specialists_repository.dart';
import 'package:stasisly/features/specialists/presentation/providers/selectable_specialists_providers.dart';

import '../support/conversation_test_support.dart';

void main() {
  testWidgets('create stays disabled until explicit verified selection', (
    tester,
  ) async {
    final repository = FakeConversationRepository();
    await tester.pumpWidget(
      _app(
        catalog: const _Catalog(SelectableSpecialistsSuccess([_specialist])),
        conversations: repository,
      ),
    );
    await tester.pumpAndSettle();

    final create = tester.widget<FilledButton>(
      find.byKey(const Key('create-conversation')),
    );
    expect(create.onPressed, isNull);
    expect(repository.createInputs, isEmpty);

    await tester.tap(
      find.byKey(const Key('selectable-specialist-catalog-safe-1')),
    );
    await tester.pump();
    expect(
      tester
          .widget<FilledButton>(find.byKey(const Key('create-conversation')))
          .onPressed,
      isNotNull,
    );

    await tester.tap(find.byKey(const Key('create-conversation')));
    await tester.pumpAndSettle();
    expect(repository.createInputs, hasLength(1));
    expect(
      repository.createInputs.single.selectableSpecialistId,
      'catalog-safe-1',
    );
    expect(find.text('Detalle canónico'), findsOneWidget);
  });

  testWidgets('empty catalog has no fallback and keeps create disabled', (
    tester,
  ) async {
    final repository = FakeConversationRepository();
    await tester.pumpWidget(
      _app(
        catalog: const _Catalog(SelectableSpecialistsEmpty()),
        conversations: repository,
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.text('No hay especialistas seleccionables disponibles.'),
      findsOneWidget,
    );
    expect(
      tester
          .widget<FilledButton>(find.byKey(const Key('create-conversation')))
          .onPressed,
      isNull,
    );
    expect(find.text('Stasis', skipOffstage: false), findsOneWidget);
    expect(repository.createInputs, isEmpty);
  });

  testWidgets('catalog failure remains explicit and does not become demo', (
    tester,
  ) async {
    final repository = FakeConversationRepository();
    await tester.pumpWidget(
      _app(
        catalog: const _Catalog(SelectableSpecialistsNetworkError()),
        conversations: repository,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Reintentar catálogo'), findsOneWidget);
    expect(find.textContaining('demostración'), findsNothing);
    expect(repository.createInputs, isEmpty);
  });
}

const _specialist = SelectableSpecialist(
  selectableSpecialistId: 'catalog-safe-1',
  displayName: 'Especialista sintético',
  publicArea: SelectableSpecialistArea.stasis,
  publicDescription: 'Descripción pública sintética.',
  accessState: SelectableSpecialistAccessState.available,
);

Widget _app({
  required SelectableSpecialistsRepository catalog,
  required FakeConversationRepository conversations,
}) {
  final router = GoRouter(
    initialLocation: '/stasis',
    routes: [
      GoRoute(path: '/stasis', builder: (_, _) => const StasisPage()),
      GoRoute(
        path: '/conversations',
        builder: (_, _) => const Scaffold(body: Text('Lista canónica')),
      ),
      GoRoute(
        path: '/conversations/:conversationId',
        builder: (_, _) => const Scaffold(body: Text('Detalle canónico')),
      ),
    ],
  );
  return ProviderScope(
    overrides: [
      selectableSpecialistsRepositoryProvider.overrideWithValue(catalog),
      conversationRepositoryProvider.overrideWithValue(conversations),
      conversationOperationAttemptIdFactoryProvider.overrideWithValue(
        SequenceOperationAttemptIdFactory(),
      ),
    ],
    child: MaterialApp.router(routerConfig: router),
  );
}

class _Catalog implements SelectableSpecialistsRepository {
  const _Catalog(this.result);

  final SelectableSpecialistsResult result;

  @override
  Future<SelectableSpecialistsResult> listSelectableSpecialists({
    SelectableSpecialistArea? areaFilter,
  }) async => result;
}

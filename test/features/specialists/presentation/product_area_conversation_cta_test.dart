import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:stasisly/features/health/presentation/pages/health_page.dart';
import 'package:stasisly/features/mental_training/presentation/pages/mental_training_page.dart';
import 'package:stasisly/features/nutrition/presentation/pages/nutrition_page.dart';
import 'package:stasisly/features/orchestrator/domain/entities/agent_entity.dart';
import 'package:stasisly/features/orchestrator/presentation/viewmodels/agent_providers.dart';
import 'package:stasisly/features/physical_training/presentation/pages/physical_training_page.dart';
import 'package:stasisly/features/specialists/presentation/widgets/unavailable_specialist_card.dart';

void main() {
  const cases = <_PageCase>[
    _PageCase('Salud', AgentBranch.health, HealthPage()),
    _PageCase('Nutrición', AgentBranch.nutrition, NutritionPage()),
    _PageCase(
      'Entrenamiento Físico',
      AgentBranch.physical,
      PhysicalTrainingPage(),
    ),
    _PageCase('Entrenamiento Mental', AgentBranch.mental, MentalTrainingPage()),
  ];

  for (final pageCase in cases) {
    testWidgets('${pageCase.name} keeps specialist data but has no chat CTA', (
      tester,
    ) async {
      final specialist = AgentEntity(
        id: 'legacy-runtime-id-${pageCase.branch.name}',
        name: 'Especialista sintético',
        role: AgentRole.specialist,
        branch: pageCase.branch,
        specialty: 'Especialidad sintética',
        description: 'Información local sin capacidad de conversación.',
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            agentsByBranchProvider(
              pageCase.branch,
            ).overrideWith((ref) async => [specialist]),
          ],
          child: MaterialApp(home: pageCase.page),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Especialista sintético'), findsOneWidget);
      expect(find.text('Especialidad sintética'), findsOneWidget);
      expect(
        find.text('Conversaciones no disponibles todavía'),
        findsOneWidget,
      );
      expect(find.byType(UnavailableSpecialistCard), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(UnavailableSpecialistCard),
          matching: find.byType(InkWell),
        ),
        findsNothing,
      );
      expect(find.byIcon(Icons.chat_bubble_outline_rounded), findsNothing);
    });
  }
}

class _PageCase {
  const _PageCase(this.name, this.branch, this.page);

  final String name;
  final AgentBranch branch;
  final Widget page;
}

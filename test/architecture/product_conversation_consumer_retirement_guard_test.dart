import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  const productPages = [
    'lib/features/health/presentation/pages/health_page.dart',
    'lib/features/nutrition/presentation/pages/nutrition_page.dart',
    'lib/features/physical_training/presentation/pages/physical_training_page.dart',
    'lib/features/mental_training/presentation/pages/mental_training_page.dart',
  ];

  test('Product area pages expose no legacy conversation affordance', () {
    for (final path in productPages) {
      final source = File(path).readAsStringSync();
      for (final forbidden in [
        'go_router',
        '/chat/',
        'agent.id',
        'context.go(',
        'context.push(',
        "context.go('/orchestrator",
        "context.push('/orchestrator",
        'AgentCard',
        'ChatRepository',
        'InactiveConversationFeatureHost',
      ]) {
        expect(source, isNot(contains(forbidden)), reason: '$path: $forbidden');
      }
      expect(source, contains('UnavailableSpecialistCard'));
    }
  });

  test('safe unavailable specialist card carries no action or identifier', () {
    final source = File(
      'lib/features/specialists/presentation/widgets/'
      'unavailable_specialist_card.dart',
    ).readAsStringSync();

    for (final forbidden in [
      'onTap',
      'onPressed',
      'VoidCallback',
      'agentId',
      'selectableSpecialistId',
      'context.go(',
      'Navigator',
      'repository',
      'OperationAttemptId',
    ]) {
      expect(source, isNot(contains(forbidden)), reason: forbidden);
    }
    expect(source, contains('Conversaciones no disponibles todavía'));
  });

  test('orchestrator debt stays isolated and Product routes stay absent', () {
    final productSources = productPages
        .map((path) => File(path).readAsStringSync())
        .join('\n');
    final orchestrator = File(
      'lib/features/orchestrator/presentation/pages/orchestrator_page.dart',
    ).readAsStringSync();
    final registry = File(
      'lib/core/routing/infrastructure/entry_point_registry.dart',
    ).readAsStringSync();

    expect(productSources, isNot(contains("context.go('/orchestrator")));
    expect(productSources, isNot(contains("context.push('/orchestrator")));
    expect(orchestrator, contains("context.go('/orchestrator/chat')"));
    expect(registry, contains("pathPattern: '/orchestrator/chat'"));
    expect(registry, contains('EntryPointLegacyState.legacyBlocked'));
    expect(registry, isNot(contains("pathPattern: '/conversations'")));
    expect(
      registry,
      isNot(contains("pathPattern: '/conversations/:conversationId'")),
    );
    expect(registry, isNot(contains("pathPattern: '/stasis'")));
  });

  test('legacy chat imports remain frozen to the blocked orchestrator page', () {
    final consumers = Directory('lib')
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'))
        .where((file) => !file.path.startsWith('lib/features/chat/'))
        .where((file) => file.readAsStringSync().contains('features/chat/'))
        .map((file) => file.path)
        .toSet();

    expect(consumers, {
      'lib/features/orchestrator/presentation/pages/orchestrator_chat_page.dart',
    });
  });
}

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

const root = 'docs/stasisly_refoundation';

void main() {
  test('RF-002 catalog artifacts and ADRs are complete', () {
    for (final path in <String>[
      'agents/AGENT_CATALOG_SCHEMA_v1.md',
      'agents/AGENT_CATALOG_GENERATION_SPEC_v1.json',
      'agents/AGENT_CATALOG_MASTER_v1.csv',
      'agents/AGENT_CATALOG_MASTER_v1.json',
      'agents/AGENT_CATALOG_MASTER_v1.md',
      'agents/AGENT_CATALOG_PRODUCT_v1.md',
      'agents/AGENT_CATALOG_DEVELOPMENT_v1.md',
      'agents/AGENT_CATALOG_ADMINISTRATION_v1.md',
      'agents/AGENT_CATALOG_TRANSVERSAL_v1.md',
      'agents/HISTORICAL_43_AGENT_CROSSWALK_v1.md',
      'agents/AGENT_DUPLICATION_REPORT_v1.md',
      'agents/AGENT_COVERAGE_GAPS_v1.md',
      'agents/AGENT_LIFECYCLE_AND_GOVERNANCE_v1.md',
      'agents/AGENT_CATALOG_VALIDATION_REPORT_v1.md',
      'implementation/STASISLY-REFOUNDATION-002_AGENT_CATALOG_3000.md',
      'decisions/ADR-RF009-initial-3000-agent-catalog.md',
      'decisions/ADR-RF010-stable-agent-ids-and-catalog-lifecycle.md',
      'decisions/ADR-RF011-selective-agent-activation.md',
      'decisions/ADR-RF012-historical-agent-prompt-migration.md',
    ]) {
      expect(File('$root/$path').existsSync(), isTrue, reason: path);
    }

    final specification = File(
      '$root/agents/AGENT_CATALOG_GENERATION_SPEC_v1.json',
    ).readAsStringSync();
    for (final capability in <String>[
      'clinical coordination',
      'cardiology',
      'psychiatry',
      'clinical safety escalation',
      'nutrition evidence',
      'injury prevention',
      'circadian rhythms',
      'accessible communication',
      'Data Router',
      'Shard Directory',
      'cross-shard analytics',
      'supply-chain security',
      'AI red teaming',
      'multi-model routing',
      'paid advertising',
      'growth strategy',
      'Customer Success',
      'global security',
      'provider portability',
      'Founder liaison',
    ]) {
      expect(specification, contains(capability), reason: capability);
    }
  });

  test('new ADRs approve metadata but not prompts or runtime', () {
    for (var index = 9; index <= 12; index++) {
      final prefix = 'ADR-RF${index.toString().padLeft(3, '0')}-';
      final matches = Directory('$root/decisions')
          .listSync()
          .whereType<File>()
          .where((file) => file.path.split('/').last.startsWith(prefix))
          .toList();
      expect(matches, hasLength(1), reason: prefix);
      final document = matches.single.readAsStringSync();
      expect(document, contains('Decision: APPROVED'));
      expect(document, contains('CATALOG_IMPLEMENTED'));
      expect(document, contains('PROMPTS_NOT_IMPLEMENTED'));
      expect(document, contains('RUNTIME_NOT_IMPLEMENTED'));
    }
  });

  test('catalog remains metadata-only with no generated prompt tree', () {
    final catalogFiles = Directory('$root/agents')
        .listSync()
        .whereType<File>()
        .map((file) => file.path.split('/').last)
        .toSet();
    expect(catalogFiles, hasLength(14));
    expect(catalogFiles.where((name) => name.contains('PROMPT')), isEmpty);

    final implementation = File(
      '$root/implementation/STASISLY-REFOUNDATION-002_AGENT_CATALOG_3000.md',
    ).readAsStringSync();
    expect(implementation, contains('zero remote actions'));
    expect(
      implementation,
      matches(RegExp(r'provisions no tools, memory or data\s+access')),
    );
    expect(implementation, contains('prompts and all runtime behavior'));
    expect(implementation, contains('none of them'));
  });

  test('master and implementation status keep Wave 1 unavailable', () {
    final master = File('$root/00_MASTER_REFOUNDATION.md').readAsStringSync();
    final architecture = File(
      '$root/04_AGENT_CATALOG_ARCHITECTURE.md',
    ).readAsStringSync();
    final status = File('$root/10_IMPLEMENTATION_STATUS.md').readAsStringSync();
    expect(
      master,
      matches(RegExp(r'four Wave 1 documentary prompts are\s+implemented')),
    );
    expect(architecture, contains('2,914 canonical entries remain'));
    expect(architecture, contains('NOT_AVAILABLE'));
    expect(status, contains('Availability: 0 agents promoted to AVAILABLE'));
    expect(status, contains('Availability / active agents: 0 / 0'));
  });
}

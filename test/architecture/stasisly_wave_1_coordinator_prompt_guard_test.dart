import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/generate_wave_1_coordinator_prompts_v1.dart';

const root = 'docs/stasisly_refoundation';
const waveRoot = '$root/agents/prompts/wave_1';
const baselineSha = '22a25da58be58873926f416794e64f7f1e552f8b';
const ids = <String>{
  'AG-TRV-0001',
  'AG-PRO-0001',
  'AG-DEV-0001',
  'AG-ADM-0001',
};

void main() {
  late List<Map<String, Object?>> catalog;

  setUpAll(() {
    final catalogRoot =
        jsonDecode(
              File(
                '$root/agents/AGENT_CATALOG_MASTER_v1.json',
              ).readAsStringSync(),
            )
            as Map<String, Object?>;
    catalog = (catalogRoot['entries']! as List).cast<Map<String, Object?>>();
  });

  test('exactly four prompts and four evaluation suites exist', () {
    final prompts = Directory(waveRoot)
        .listSync()
        .whereType<File>()
        .where(
          (file) => RegExp('/AG-(TRV|PRO|DEV|ADM)-0001_').hasMatch(file.path),
        )
        .toList();
    final evaluations = Directory(
      '$waveRoot/evaluations',
    ).listSync().whereType<File>().toList();
    expect(prompts, hasLength(4));
    expect(evaluations, hasLength(4));
    expect(
      Directory('$root/agents/prompts')
          .listSync(recursive: true)
          .whereType<File>()
          .where(
            (file) =>
                RegExp(r'/AG-(TRV|PRO|DEV|ADM)-\d+_').hasMatch(file.path) &&
                !file.path.startsWith(waveRoot) &&
                !file.path.startsWith('$root/agents/prompts/wave_2') &&
                !file.path.startsWith('$root/agents/prompts/wave_3') &&
                !file.path.startsWith('$root/agents/prompts/wave_4') &&
                !file.path.startsWith('$root/agents/prompts/wave_5'),
          ),
      isEmpty,
    );
  });

  test('each prompt has all sections, metadata and documentary state', () {
    for (final file in Directory(waveRoot).listSync().whereType<File>().where(
      (file) => RegExp('/AG-(TRV|PRO|DEV|ADM)-0001_').hasMatch(file.path),
    )) {
      final content = file.readAsStringSync();
      for (var section = 1; section <= 32; section++) {
        expect(
          content,
          contains('## $section.'),
          reason: '${file.path}:$section',
        );
      }
      for (final field in <String>[
        'prompt_schema_version:',
        'agent_id:',
        'canonical_name:',
        'display_name:',
        'surface:',
        'domain:',
        'family:',
        'agent_type:',
        'coordination_level:',
        'risk_level:',
        'data_access_class:',
        'tool_access_class:',
        'memory_scope:',
        'reports_to:',
        'lifecycle_status: PROMPT_CREATED',
        'prompt_status: APPROVED',
        'prompt_version: 1.0.0',
        'prompt_owner:',
        'approval_status: APPROVED_DOCUMENTARY_BASELINE',
        'approved_by: FOUNDER_DECISION_RECORDED_IN_PACKAGE',
        'approved_at: 2026-07-31',
        'source_catalog_version: 1.0.0',
        'supersedes: NONE',
        'historical_source:',
        'migration_decision:',
        'runtime: NOT_IMPLEMENTED',
        'availability: NOT_AVAILABLE',
        'implementation_status: DOCUMENTED_ONLY',
      ]) {
        expect(content, contains(field), reason: '${file.path}:$field');
      }
      for (final authority in <String>[
        '### MAY',
        '### MAY_WITH_APPROVAL',
        '### MUST_ESCALATE',
        '### MUST_NOT',
      ]) {
        expect(content, contains(authority));
      }
      expect(content, contains('Layer 0'));
      expect(content, contains('Layers 4-6 are absent'));
    }
  });

  test('catalog updates exactly four records and preserves availability', () {
    final approved = catalog
        .where((entry) => ids.contains(entry['agent_id']))
        .toList();
    expect(approved, hasLength(4));
    expect(approved.map((entry) => entry['agent_id']).toSet(), ids);
    expect(
      catalog.where((entry) => entry['prompt_status'] == 'PROMPT_CREATED'),
      hasLength(177),
    );
    expect(
      catalog.where((entry) => entry['availability'] == 'NOT_AVAILABLE'),
      hasLength(3000),
    );
    expect(
      catalog.where(
        (entry) => entry['implementation_status'] == 'NOT_IMPLEMENTED',
      ),
      hasLength(2828),
    );
  });

  test('reports-to graph is exact and acyclic', () {
    final byId = {
      for (final entry in catalog) entry['agent_id']! as String: entry,
    };
    expect(byId['AG-TRV-0001']!['reports_to'], 'FOUNDER');
    for (final id in ids.where((id) => id != 'AG-TRV-0001')) {
      expect(byId[id]!['reports_to'], 'AG-TRV-0001');
    }
    for (final id in ids) {
      final seen = <String>{};
      var cursor = id;
      while (cursor != 'FOUNDER') {
        expect(seen.add(cursor), isTrue);
        cursor = byId[cursor]!['reports_to']! as String;
      }
    }
  });

  test('evaluation suites cover all categories and adversarial cases', () {
    const categories = <String>[
      'role adherence',
      'scope adherence',
      'authority boundaries',
      'refusal behavior',
      'human escalation',
      'Founder escalation',
      'privacy',
      'security',
      'tool safety',
      'memory safety',
      'hallucination control',
      'source attribution',
      'cross-agent coordination',
      'conflict handling',
      'failure recovery',
      'output quality',
    ];
    for (final file in Directory(
      '$waveRoot/evaluations',
    ).listSync().whereType<File>()) {
      final content = file.readAsStringSync();
      for (final category in categories) {
        expect(
          content,
          contains('| $category |'),
          reason: '${file.path}:$category',
        );
      }
      expect(
        RegExp(
          r'^\| [1-5] \| .+ \| Refuse',
          multiLine: true,
        ).allMatches(content),
        hasLength(5),
      );
      expect(content, contains('DESIGNED_NOT_RUNTIME_EXECUTED'));
    }
  });

  test('gate report has exactly 60 passes and no runtime gate execution', () {
    final report = File(
      '$waveRoot/WAVE_1_PROMPT_GATES_REPORT_v1.md',
    ).readAsStringSync();
    expect(
      RegExp(
        r'^\| AG-.+ \| P(?:[0-9]|1[0-4]) \| PASS \|',
        multiLine: true,
      ).allMatches(report),
      hasLength(60),
    );
    expect(
      RegExp(r'^\| AG-.+ \| P1[5-7] \|', multiLine: true).allMatches(report),
      isEmpty,
    );
    expect(report, contains('P15 runtime configuration'));
  });

  test('high contradictions are deferred to their owning waves', () {
    final report = File(
      '$waveRoot/WAVE_1_HIGH_CONTRADICTIONS_RESOLUTION_v1.md',
    ).readAsStringSync();
    expect(RegExp('DEFERRED_TO_OWNING_WAVE').allMatches(report), hasLength(3));
    expect(report, contains('High contradictions resolved in Wave 1: 0'));
    final migration = File(
      '$waveRoot/WAVE_1_PROMPT_MIGRATION_REPORT_v1.md',
    ).readAsStringSync();
    expect(migration, contains('Historical files modified: 0'));
    expect(migration, contains('Individual prompts outside Wave 1 created: 0'));
  });

  test('all referenced historical sources match the package baseline', () {
    final sources = <String>{
      for (final spec in agents) ...spec.historicalSources,
    };
    for (final source in sources) {
      final baseline = Process.runSync('git', ['show', '$baselineSha:$source']);
      expect(baseline.exitCode, 0, reason: source);
      expect(File(source).readAsStringSync(), baseline.stdout, reason: source);
    }
  });

  test('ADRs separate documentary approval from runtime availability', () {
    for (var index = 18; index <= 21; index++) {
      final prefix = 'ADR-RF${index.toString().padLeft(3, '0')}-';
      final files = Directory('$root/decisions')
          .listSync()
          .whereType<File>()
          .where((file) => file.path.split('/').last.startsWith(prefix))
          .toList();
      expect(files, hasLength(1));
      final content = files.single.readAsStringSync();
      expect(content, contains('`APPROVED`'));
      expect(content, contains('DOCUMENTARY_PROMPTS_IMPLEMENTED'));
      expect(content, contains('RUNTIME_NOT_IMPLEMENTED'));
      expect(content, contains('AGENTS_NOT_AVAILABLE'));
    }
  });
}

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/generate_wave_7_specialized_prompt_strategy_v1.dart';

const _baselineSha = 'f9a91257b08884590e55c53a6ba347415f1b925a';

List<Map<String, Object?>> _records(String name) {
  final root =
      jsonDecode(File('$wave7StrategyRoot/$name.json').readAsStringSync())
          as Map<String, Object?>;
  return (root['records']! as List).cast<Map<String, Object?>>();
}

void main() {
  late List<Map<String, Object?>> catalog;
  late List<Map<String, Object?>> inventory;
  late List<Map<String, Object?>> risks;
  late List<Map<String, Object?>> families;
  late List<Map<String, Object?>> modules;
  late List<Map<String, Object?>> assignments;
  late List<Map<String, Object?>> subwaves;

  setUpAll(() {
    final catalogRoot =
        jsonDecode(File(wave7CatalogPath).readAsStringSync())
            as Map<String, Object?>;
    catalog = (catalogRoot['entries']! as List).cast<Map<String, Object?>>();
    inventory = _records('WAVE_7_REMAINING_AGENT_INVENTORY_v1');
    risks = _records('WAVE_7_AGENT_RISK_CLASSIFICATION_v1');
    families = _records('WAVE_7_PROMPT_FAMILY_REGISTRY_v1');
    modules = _records('WAVE_7_SPECIALTY_MODULE_REGISTRY_v1');
    assignments = _records('WAVE_7_AGENT_PROMPT_STRATEGY_ASSIGNMENTS_v1');
    subwaves = _records('WAVE_7_SUBWAVE_PLAN_v1');
  });

  test('scope is exhaustive and canonical catalog state is unchanged', () {
    expect(catalog, hasLength(3000));
    expect(inventory, hasLength(2778));
    expect(risks, hasLength(2778));
    expect(assignments, hasLength(2778));
    expect(assignments.map((row) => row['agent_id']).toSet(), hasLength(2778));
    expect(
      catalog.where((row) => row['prompt_status'] == 'PROMPT_CREATED'),
      hasLength(466),
    );
    final pending = catalog.where(
      (row) => row['prompt_status'] == 'NOT_CREATED',
    );
    expect(pending, hasLength(2534));
    for (final row in pending) {
      expect(row['lifecycle_status'], 'CATALOGED');
      expect(row['implementation_status'], 'NOT_IMPLEMENTED');
      expect(row['availability'], 'NOT_AVAILABLE');
    }
    expect(
      catalog.where((row) => row['availability'] == 'NOT_AVAILABLE'),
      hasLength(3000),
    );
  });

  test('every assignment has one approved strategy and valid components', () {
    const strategies = <String>{
      'FULL_INDIVIDUAL_PROMPT',
      'FAMILY_PLUS_IDENTITY',
      'FAMILY_PLUS_SPECIALTY_MODULE',
      'PARAMETERIZED_SPECIALIST',
      'DEFERRED_REDESIGN',
    };
    final familyIds = families.map((row) => row['family_prompt_id']).toSet();
    final moduleIds = modules.map((row) => row['specialty_module_id']).toSet();
    expect(families, hasLength(342));
    expect(modules, hasLength(342));
    for (final row in assignments) {
      expect(strategies, contains(row['prompt_strategy']));
      expect(familyIds, contains(row['family_prompt_id']));
      expect(moduleIds, contains(row['specialty_module_ids']));
      expect(row['evaluation_profile_id'], isNotEmpty);
      final overlays = row['overlay_ids']! as String;
      if (overlays != 'NONE') {
        for (final id in overlays.split(';')) {
          expect(wave7OverlayDefinitions, contains(id));
        }
      }
    }
  });

  test('CSV and JSON datasets have exact record-count parity', () {
    const datasets = <String, int>{
      'WAVE_7_REMAINING_AGENT_INVENTORY_v1': 2778,
      'WAVE_7_AGENT_RISK_CLASSIFICATION_v1': 2778,
      'WAVE_7_PROMPT_FAMILY_REGISTRY_v1': 342,
      'WAVE_7_SPECIALTY_MODULE_REGISTRY_v1': 342,
      'WAVE_7_AGENT_PROMPT_STRATEGY_ASSIGNMENTS_v1': 2778,
      'WAVE_7_SUBWAVE_PLAN_v1': 89,
    };
    for (final dataset in datasets.entries) {
      final csv = File(
        '$wave7StrategyRoot/${dataset.key}.csv',
      ).readAsLinesSync();
      final jsonRecords = _records(dataset.key);
      expect(csv, hasLength(dataset.value + 1), reason: dataset.key);
      expect(jsonRecords, hasLength(dataset.value), reason: dataset.key);
    }
  });

  test('subwaves are exhaustive, bounded and preserve family membership', () {
    expect(subwaves, hasLength(89));
    expect(subwaves.map((row) => row['subwave_id']).toSet(), hasLength(89));
    expect(
      subwaves.fold<int>(
        0,
        (total, row) => total + (row['agent_count']! as int),
      ),
      2778,
    );
    for (final row in subwaves) {
      expect(row['agent_count']! as int, inInclusiveRange(2, 100));
    }
    final assignmentByFamily = <Object?, Set<Object?>>{};
    for (final row in assignments) {
      assignmentByFamily
          .putIfAbsent(row['family_prompt_id'], () => <Object?>{})
          .add(row['subwave_id']);
    }
    for (final subwaveIds in assignmentByFamily.values) {
      expect(subwaveIds, hasLength(1));
    }
    expect(subwaves.first['subwave_id'], 'W7-001');
    expect(subwaves.first['agent_count'], 40);
    expect(subwaves.first['HIGH_count'], 40);
    expect(subwaves.first['CRITICAL_count'], 0);
    expect(subwaves[1]['subwave_id'], 'W7-002');
    expect(subwaves[1]['agent_count'], 20);
    expect(subwaves[1]['CRITICAL_count'], 20);
  });

  test(
    'composition is fail-closed, deterministic and individually evaluated',
    () {
      final architecture = File(
        '$wave7StrategyRoot/WAVE_7_COMPOSABLE_PROMPT_ARCHITECTURE_v1.md',
      ).readAsStringSync();
      final evaluation = File(
        '$wave7StrategyRoot/WAVE_7_EVALUATION_AND_APPROVAL_STRATEGY_v1.md',
      ).readAsStringSync();
      final manifest = File(
        '$wave7StrategyRoot/WAVE_7_EFFECTIVE_PROMPT_MANIFEST_SCHEMA_v1.md',
      ).readAsStringSync();
      expect(architecture, contains('most restrictive'));
      expect(architecture, contains('fail closed'));
      expect(architecture, contains('not manually edited'));
      expect(evaluation, contains('Every agent'));
      expect(evaluation, contains('P0-P14 remain individual'));
      expect(manifest, contains('effective_prompt_hash'));
      expect(manifest, contains('identical hash'));
      for (final family in families) {
        expect(family['base_authority'], 'DOCUMENTARY_ONLY_DENY_BY_DEFAULT');
        expect(family['base_data_ceiling'], 'DENY_BY_DEFAULT_IDENTITY_BOUND');
        expect(family['base_tool_ceiling'], 'DENY_BY_DEFAULT_IDENTITY_BOUND');
        expect(family['base_memory_ceiling'], 'DENY_BY_DEFAULT_IDENTITY_BOUND');
      }
    },
  );

  test('all strategy gates, ADRs and non-runtime markers are present', () {
    final gates = File(
      '$wave7StrategyRoot/WAVE_7_STRATEGY_GATES_REPORT_v1.md',
    ).readAsStringSync();
    expect(
      RegExp(r'^\| G\d+ \| PASS \|', multiLine: true).allMatches(gates),
      hasLength(33),
    );
    for (var index = 60; index <= 67; index++) {
      final prefix = 'ADR-RF${index.toString().padLeft(3, '0')}-';
      final files = Directory('docs/stasisly_refoundation/decisions')
          .listSync()
          .whereType<File>()
          .where((file) => file.uri.pathSegments.last.startsWith(prefix))
          .toList();
      expect(files, hasLength(1), reason: prefix);
      final content = files.single.readAsStringSync();
      expect(content, contains('Decision: APPROVED'));
      expect(content, contains('STRATEGY_AND_ARCHITECTURE_DOCUMENTED'));
      expect(content, contains('SPECIALIZED_PROMPTS_NOT_CREATED'));
      expect(content, contains('RUNTIME_NOT_IMPLEMENTED'));
      expect(content, contains('AGENTS_NOT_AVAILABLE'));
    }
  });

  test('Wave 7 creates no individual prompt or evaluation artifact', () {
    final files = Directory(
      wave7StrategyRoot,
    ).listSync(recursive: true).whereType<File>();
    expect(
      files.where(
        (file) => RegExp(r'AG-(PRO|DEV|ADM|TRV)-\d{4}').hasMatch(file.path),
      ),
      isEmpty,
    );
    expect(files.where((file) => file.path.contains('/evaluations/')), isEmpty);
  });

  test(
    'historical sources and Waves 1-6 remain byte-identical to baseline',
    () async {
      final result = await Process.run('git', [
        'diff',
        '--name-only',
        _baselineSha,
        '--',
        'docs/archive/discovery',
        'docs/stasisly_definition/agents',
        'docs/stasisly_refoundation/agents/prompts/wave_1',
        'docs/stasisly_refoundation/agents/prompts/wave_2',
        'docs/stasisly_refoundation/agents/prompts/wave_3',
        'docs/stasisly_refoundation/agents/prompts/wave_4',
        'docs/stasisly_refoundation/agents/prompts/wave_5',
        'docs/stasisly_refoundation/agents/prompts/wave_6',
      ]);
      expect(result.exitCode, 0);
      expect((result.stdout as String).trim(), isEmpty);
    },
  );
}

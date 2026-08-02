import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/founder_authorization_artifact.dart' show sha256Hex;
import '../../tool/generate_agent_catalog_v1.dart';
import '../../tool/generate_w7_009_product_health_high_risk_prompts_v1.dart';

List<Map<String, Object?>> _records(String path, String key) =>
    ((jsonDecode(File(path).readAsStringSync()) as Map<String, Object?>)[key]!
            as List)
        .cast<Map<String, Object?>>();

void main() {
  late List<Map<String, Object?>> catalog;
  late List<Map<String, Object?>> assignments;
  late List<File> identities;
  late List<File> prompts;
  late List<File> manifests;
  late List<File> evaluations;

  setUpAll(() {
    catalog = _records(w7009CatalogPath, 'entries');
    assignments = _records(w7009StrategyPath, 'records');
    identities = Directory(
      '$w7009Root/identities',
    ).listSync().whereType<File>().toList();
    prompts = Directory(
      '$w7009Root/effective_prompts',
    ).listSync().whereType<File>().toList();
    manifests = Directory(
      '$w7009Root/manifests',
    ).listSync().whereType<File>().toList();
    evaluations = Directory(
      '$w7009Root/evaluations',
    ).listSync().whereType<File>().toList();
  });

  test('scope resolves exactly 90 HIGH Product health agents', () {
    final scoped = assignments
        .where((r) => r['subwave_id'] == 'W7-009')
        .toList();
    expect(scoped, hasLength(90));
    expect(scoped.map((r) => r['agent_id']).toSet(), w7009AgentIds);
    expect(scoped.where((r) => r['risk_tier'] == 'HIGH'), hasLength(90));
    expect(scoped.where((r) => r['risk_tier'] == 'CRITICAL'), isEmpty);
    for (final row in scoped) {
      expect(row['prompt_strategy'], 'FULL_INDIVIDUAL_PROMPT');
      expect(row['subwave_status'], 'DOCUMENTARY_PROMPTS_APPROVED');
      expect(row['redesign_status'], isNot('DEFERRED_REDESIGN'));
      expect(row['overlay_ids'], startsWith('OVR-CLINICAL-SAFETY-v1'));
    }
    expect(scoped.map((r) => r['family_prompt_id']).toSet(), hasLength(6));
    expect(scoped.map((r) => r['specialty_module_ids']).toSet(), hasLength(6));
    final entries = catalog.where((r) => w7009AgentIds.contains(r['agent_id']));
    expect(entries, hasLength(90));
    expect(entries.every((r) => r['surface'] == 'PRODUCT'), isTrue);
    expect(entries.every((r) => r['domain'] == 'health'), isTrue);
    expect(entries.every((r) => r['risk_level'] == 'HIGH'), isTrue);
  });

  test('all individual artifacts, sections and boundaries exist', () {
    expect(identities, hasLength(90));
    expect(prompts, hasLength(90));
    expect(manifests, hasLength(90));
    expect(evaluations, hasLength(90));
    const markers = [
      'availability: NOT_AVAILABLE',
      'NOT_RUNTIME_CONFIGURED',
      'Clinical safety and privacy authority',
      'User subject tenant and context identity',
      'Purpose symptoms evidence and impact',
      'Gastroenterology gynecology and geriatrics boundaries',
      'Hematology monitoring and education boundaries',
      'Sensitive health data and restricted evidence',
      'Clinical provenance recency and uncertainty',
      'Emergency escalation and medical authority',
      'Evidence verification and stop conditions',
      'Do not diagnose',
      'Health runtime and P15-P17 are NOT_EXECUTED',
    ];
    var sections = 0;
    for (final file in prompts) {
      final text = file.readAsStringSync();
      for (var i = 1; i <= 32; i++) {
        expect(text, contains('## $i.'), reason: '${file.path}:$i');
        sections++;
      }
      for (final marker in markers) {
        expect(
          text.toLowerCase(),
          contains(marker.toLowerCase()),
          reason: '${file.path}:$marker',
        );
      }
    }
    expect(sections, 2880);
  });

  test('CSV JSON and Markdown preserve the exact W7-009 plan', () {
    const root = 'docs/stasisly_refoundation/agents/prompts/wave_7_strategy';
    final plan = _records('$root/WAVE_7_SUBWAVE_PLAN_v1.json', 'records');
    final row = plan.singleWhere((r) => r['subwave_id'] == 'W7-009');
    expect(row['agent_count'], 90);
    expect(row['surface'], 'PRODUCT');
    expect(row['domain'], 'health');
    expect(row['HIGH_count'], 90);
    expect(row['CRITICAL_count'], 0);
    expect(row['full_individual_count'], 90);
    expect(row['redesign_count'], 0);
    final csv = File('$root/WAVE_7_SUBWAVE_PLAN_v1.csv').readAsStringSync();
    final markdown = File('$root/WAVE_7_SUBWAVE_PLAN_v1.md').readAsStringSync();
    expect(RegExp('^"W7-009",', multiLine: true).allMatches(csv), hasLength(1));
    expect(
      RegExp(r'^\| W7-009 \|', multiLine: true).allMatches(markdown),
      hasLength(1),
    );
  });

  test('manifests have valid hashes and preserve runtime boundary', () {
    final components = <String, String>{};
    for (final file in Directory(
      'docs/stasisly_refoundation/agents/prompts/composable',
    ).listSync(recursive: true).whereType<File>()) {
      final text = file.readAsStringSync();
      final id = RegExp(
        r'^artifact_id: (.+)$',
        multiLine: true,
      ).firstMatch(text)?.group(1);
      final hash = RegExp(
        r'^content_hash: ([0-9a-f]{64})$',
        multiLine: true,
      ).firstMatch(text)?.group(1);
      if (id != null && hash != null) components[id] = hash;
    }
    for (final file in manifests) {
      final manifest =
          jsonDecode(file.readAsStringSync()) as Map<String, Object?>;
      final hashes = (manifest['content_hashes']! as Map)
          .cast<String, Object?>();
      for (final entry in hashes.entries.where(
        (e) => !e.key.startsWith('IDENTITY-'),
      )) {
        expect(
          components[entry.key],
          entry.value,
          reason: '${file.path}:${entry.key}',
        );
      }
      expect(
        sha256Hex(manifest['effective_prompt_hash_input']! as String),
        manifest['effective_prompt_hash'],
      );
      expect(manifest['runtime_contract_version'], 'NOT_IMPLEMENTED');
      expect(manifest['availability'], 'NOT_AVAILABLE');
    }
  });

  test('evaluations contain 720 adversarial cases and 540 risk reviews', () {
    final all = evaluations.map((f) => f.readAsStringSync()).join('\n');
    expect(
      RegExp('^### Adversarial case ', multiLine: true).allMatches(all),
      hasLength(720),
    );
    expect(
      RegExp(
        r'^\| (?:DOMAIN|PRIVACY|SECURITY|AUTHORITY|FOUNDER_BOUNDARY|HUMAN_SAFETY|EVALUATION|CLINICAL_SAFETY)_REVIEWER \|',
        multiLine: true,
      ).allMatches(all),
      hasLength(540),
    );
    for (final category in const [
      'gastroenterology evidence boundary',
      'geriatrics evidence boundary',
      'gynecology evidence boundary',
      'health education boundary',
      'health monitoring boundary',
      'hematology evidence boundary',
    ]) {
      expect(all, contains('| $category |'));
    }
  });

  test('1350 P0-P14 pass and P15-P17 remain unexecuted', () {
    final gates = File(
      '$w7009Root/W7_009_PROMPT_GATES_REPORT_v1.md',
    ).readAsStringSync();
    expect(
      RegExp(
        r'^\| AG-PRO-\d{4} \| P(?:[0-9]|1[0-4]) ',
        multiLine: true,
      ).allMatches(gates),
      hasLength(1350),
    );
    expect(
      RegExp(
        r'^\| AG-PRO-\d{4} \| P1[5-7] ',
        multiLine: true,
      ).allMatches(gates),
      isEmpty,
    );
  });

  test('catalog transitions exactly W7-009 and preserves availability', () {
    expect(
      catalog.where((r) => r['prompt_status'] == 'PROMPT_CREATED'),
      hasLength(736),
    );
    expect(
      catalog.where((r) => r['prompt_status'] == 'NOT_CREATED'),
      hasLength(2264),
    );
    expect(approvedDocumentaryPromptIds, hasLength(736));
    for (final id in w7009AgentIds) {
      final row = catalog.singleWhere((r) => r['agent_id'] == id);
      expect(row['lifecycle_status'], 'PROMPT_CREATED');
      expect(row['implementation_status'], 'DOCUMENTED_ONLY');
      expect(row['availability'], 'NOT_AVAILABLE');
    }
    expect(catalog.every((r) => r['availability'] == 'NOT_AVAILABLE'), isTrue);
  });

  test('reports and ADR-RF124 through RF130 are present', () {
    expect(Directory(w7009Root).listSync().whereType<File>(), hasLength(15));
    for (var i = 124; i <= 130; i++) {
      final prefix = 'ADR-RF${i.toString().padLeft(3, '0')}-';
      final files = Directory('docs/stasisly_refoundation/decisions')
          .listSync()
          .whereType<File>()
          .where((f) => f.uri.pathSegments.last.startsWith(prefix))
          .toList();
      expect(files, hasLength(1), reason: prefix);
      final text = files.single.readAsStringSync();
      for (final marker in const [
        '## Decision',
        'APPROVED',
        'DOCUMENTARY_PROMPTS_IMPLEMENTED',
        'RUNTIME_NOT_IMPLEMENTED',
        'TOOLS_NOT_PROVISIONED',
        'MEMORY_NOT_PROVISIONED',
        'AGENTS_NOT_AVAILABLE',
      ]) {
        expect(text, contains(marker), reason: '$prefix:$marker');
      }
    }
  });

  test('closed and future subwaves remain untouched', () async {
    final result = await Process.run('git', [
      'diff',
      '--name-only',
      '2097d8b3bc2d4eb2a76be7c27302892701b42813',
      '--',
      for (var value = 1; value <= 8; value++)
        'docs/stasisly_refoundation/agents/prompts/wave_7/W7-${value.toString().padLeft(3, '0')}',
    ]);
    expect(result.exitCode, 0);
    expect((result.stdout as String).trim(), isEmpty);
    expect(
      Directory(
        'docs/stasisly_refoundation/agents/prompts/wave_7/W7-011',
      ).existsSync(),
      isFalse,
    );
  });
}

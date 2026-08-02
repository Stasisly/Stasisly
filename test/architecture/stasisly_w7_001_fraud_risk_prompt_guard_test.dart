import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/founder_authorization_artifact.dart' show sha256Hex;
import '../../tool/generate_agent_catalog_v1.dart';
import '../../tool/generate_w7_001_fraud_risk_prompts_v1.dart';

List<Map<String, Object?>> _jsonRecords(String path, String key) {
  final root =
      jsonDecode(File(path).readAsStringSync()) as Map<String, Object?>;
  return (root[key]! as List).cast<Map<String, Object?>>();
}

void main() {
  late List<Map<String, Object?>> catalog;
  late List<Map<String, Object?>> assignments;
  late List<File> identities;
  late List<File> prompts;
  late List<File> manifests;
  late List<File> evaluations;

  setUpAll(() {
    catalog = _jsonRecords(w7001CatalogPath, 'entries');
    assignments = _jsonRecords(w7001StrategyPath, 'records');
    identities = Directory(
      '$w7001Root/identities',
    ).listSync().whereType<File>().toList();
    prompts = Directory(
      '$w7001Root/effective_prompts',
    ).listSync().whereType<File>().toList();
    manifests = Directory(
      '$w7001Root/manifests',
    ).listSync().whereType<File>().toList();
    evaluations = Directory(
      '$w7001Root/evaluations',
    ).listSync().whereType<File>().toList();
  });

  test('scope and approved strategy resolve exactly forty HIGH agents', () {
    final scoped = assignments
        .where((r) => r['subwave_id'] == 'W7-001')
        .toList();
    expect(scoped, hasLength(40));
    expect(scoped.map((r) => r['agent_id']).toSet(), w7001AgentIds);
    for (final row in scoped) {
      expect(row['risk_tier'], 'HIGH');
      expect(row['prompt_strategy'], 'FULL_INDIVIDUAL_PROMPT');
      expect(row['redesign_status'], isNot('DEFERRED_REDESIGN'));
      expect(row['subwave_status'], 'DOCUMENTARY_PROMPTS_APPROVED');
    }
    expect(
      assignments
          .where(
            (r) =>
                r['subwave_id'] != 'W7-001' &&
                r['subwave_id'] != 'W7-002' &&
                r['subwave_id'] != 'W7-003' &&
                r['subwave_id'] != 'W7-004' &&
                r['subwave_id'] != 'W7-005' &&
                r['subwave_id'] != 'W7-006' &&
                r['subwave_id'] != 'W7-007' &&
                r['subwave_id'] != 'W7-008',
          )
          .every((r) => r['subwave_status'] == 'NOT_STARTED'),
      isTrue,
    );
  });

  test('forty identity, prompt, manifest and evaluation artifacts exist', () {
    expect(identities, hasLength(40));
    expect(prompts, hasLength(40));
    expect(manifests, hasLength(40));
    expect(evaluations, hasLength(40));
    expect(
      prompts
          .map((f) => RegExp(r'AG-ADM-\d{4}').firstMatch(f.path)!.group(0))
          .toSet(),
      w7001AgentIds,
    );
  });

  test('effective prompts have 1280 sections and strict fraud boundaries', () {
    const required = <String>[
      'approval_status: APPROVED_DOCUMENTARY_BASELINE',
      'implementation_status: DOCUMENTED_ONLY',
      'availability: NOT_AVAILABLE',
      'NOT_RUNTIME_CONFIGURED',
      'MUST_NOT block or close accounts',
      'Human review is mandatory',
      'appeal path',
      'Health, wellness, private conversations',
      'minimum authority ceiling wins',
      'not provisioned',
      'P17 availability are NOT_EXECUTED',
    ];
    var sections = 0;
    for (final file in prompts) {
      final content = file.readAsStringSync();
      for (var i = 1; i <= 32; i++) {
        expect(content, contains('## $i.'), reason: '${file.path}:$i');
        sections++;
      }
      for (final marker in required) {
        expect(
          content.toLowerCase(),
          contains(marker.toLowerCase()),
          reason: '${file.path}:$marker',
        );
      }
    }
    expect(sections, 1280);
  });

  test('manifests reference valid components and hashes', () {
    final componentFiles = Directory(
      'docs/stasisly_refoundation/agents/prompts/composable',
    ).listSync(recursive: true).whereType<File>().toList();
    final components = <String, String>{};
    for (final file in componentFiles) {
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

  test(
    'individual evaluations contain 280 adversarial cases and 240 reviews',
    () {
      final all = evaluations.map((f) => f.readAsStringSync()).join('\n');
      expect(
        RegExp('^### Adversarial case ', multiLine: true).allMatches(all),
        hasLength(280),
      );
      expect(
        RegExp(
          r'^\| (?:DOMAIN|FRAUD_RISK|PRIVACY|SECURITY|AUTHORITY|EVALUATION)_REVIEWER \|',
          multiLine: true,
        ).allMatches(all),
        hasLength(240),
      );
      for (final category in const [
        'fraud-signal interpretation',
        'false-positive control',
        'evidence integrity',
        'high-impact decision boundary',
        'human-review requirement',
        'appeal preservation',
        'financial-authority boundary',
        'privacy minimization',
        'bias and fairness',
        'case-scope adherence',
      ]) {
        expect(all, contains('| $category |'));
      }
    },
  );

  test('600 P0-P14 pass and P15-P17 remain unexecuted', () {
    final gates = File(
      '$w7001Root/W7_001_PROMPT_GATES_REPORT_v1.md',
    ).readAsStringSync();
    expect(
      RegExp(
        r'^\| AG-ADM-\d{4} \| P(?:[0-9]|1[0-4]) ',
        multiLine: true,
      ).allMatches(gates),
      hasLength(600),
    );
    expect(
      RegExp(
        r'^\| AG-ADM-\d{4} \| P1[5-7] ',
        multiLine: true,
      ).allMatches(gates),
      isEmpty,
    );
    expect(gates, contains('P17 availability: NOT_EXECUTED'));
  });

  test(
    'catalog transitions exactly W7-001 and keeps every agent unavailable',
    () {
      final completed = catalog
          .where((r) => r['prompt_status'] == 'PROMPT_CREATED')
          .toList();
      final pending = catalog
          .where((r) => r['prompt_status'] == 'NOT_CREATED')
          .toList();
      expect(completed, hasLength(556));
      expect(pending, hasLength(2444));
      expect(approvedDocumentaryPromptIds, hasLength(556));
      for (final id in w7001AgentIds) {
        final row = catalog.singleWhere((r) => r['agent_id'] == id);
        expect(row['lifecycle_status'], 'PROMPT_CREATED');
        expect(row['implementation_status'], 'DOCUMENTED_ONLY');
        expect(row['availability'], 'NOT_AVAILABLE');
      }
      expect(
        catalog.every((r) => r['availability'] == 'NOT_AVAILABLE'),
        isTrue,
      );
    },
  );

  test('required reports and ADR-RF068 through RF074 are present', () {
    expect(Directory(w7001Root).listSync().whereType<File>(), hasLength(13));
    for (var i = 68; i <= 74; i++) {
      final prefix = 'ADR-RF${i.toString().padLeft(3, '0')}-';
      final files = Directory('docs/stasisly_refoundation/decisions')
          .listSync()
          .whereType<File>()
          .where((f) => f.uri.pathSegments.last.startsWith(prefix))
          .toList();
      expect(files, hasLength(1), reason: prefix);
      final content = files.single.readAsStringSync();
      for (final marker in const [
        'Decision: APPROVED',
        'DOCUMENTARY_PROMPTS_IMPLEMENTED',
        'FRAUD_RUNTIME_NOT_IMPLEMENTED',
        'ENFORCEMENT_NOT_IMPLEMENTED',
        'TOOLS_NOT_PROVISIONED',
        'AGENTS_NOT_AVAILABLE',
      ]) {
        expect(content, contains(marker), reason: '$prefix:$marker');
      }
    }
  });
}

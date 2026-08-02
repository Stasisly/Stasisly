import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/founder_authorization_artifact.dart' show sha256Hex;
import '../../tool/generate_agent_catalog_v1.dart';
import '../../tool/generate_w7_002_critical_incident_prompts_v1.dart';

List<Map<String, Object?>> _records(String path, String key) {
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
    catalog = _records(w7002CatalogPath, 'entries');
    assignments = _records(w7002StrategyPath, 'records');
    identities = Directory(
      '$w7002Root/identities',
    ).listSync().whereType<File>().toList();
    prompts = Directory(
      '$w7002Root/effective_prompts',
    ).listSync().whereType<File>().toList();
    manifests = Directory(
      '$w7002Root/manifests',
    ).listSync().whereType<File>().toList();
    evaluations = Directory(
      '$w7002Root/evaluations',
    ).listSync().whereType<File>().toList();
  });

  test('scope resolves exactly twenty CRITICAL agents', () {
    final scoped = assignments
        .where((r) => r['subwave_id'] == 'W7-002')
        .toList();
    expect(scoped, hasLength(20));
    expect(scoped.map((r) => r['agent_id']).toSet(), w7002AgentIds);
    for (final row in scoped) {
      expect(row['risk_tier'], 'CRITICAL');
      expect(row['prompt_strategy'], 'FULL_INDIVIDUAL_PROMPT');
      expect(row['redesign_status'], isNot('DEFERRED_REDESIGN'));
      expect(row['subwave_status'], 'DOCUMENTARY_PROMPTS_APPROVED');
      expect(row['overlay_ids'], 'OVR-FOUNDER-EXCLUSIVE-v1');
    }
    final outside = assignments.where(
      (r) => r['subwave_id'] != 'W7-001' && r['subwave_id'] != 'W7-002',
    );
    expect(outside.every((r) => r['subwave_status'] == 'NOT_STARTED'), isTrue);
  });

  test('twenty identity, prompt, manifest and evaluation artifacts exist', () {
    expect(identities, hasLength(20));
    expect(prompts, hasLength(20));
    expect(manifests, hasLength(20));
    expect(evaluations, hasLength(20));
    expect(
      prompts
          .map((f) => RegExp(r'AG-ADM-\d{4}').firstMatch(f.path)!.group(0))
          .toSet(),
      w7002AgentIds,
    );
  });

  test('effective prompts have 640 sections and critical boundaries', () {
    const required = <String>[
      'risk_tier: CRITICAL',
      'availability: NOT_AVAILABLE',
      'NOT_RUNTIME_CONFIGURED',
      'MUST_NOT declare Emergency authority',
      'never impersonate or replace them',
      'cannot appoint itself',
      'Never invent targets or activate continuity',
      'External or people-impacting release requires verified facts',
      'silent deletion or timeline alteration is forbidden',
      'People-impacting decisions require fair process',
      'P17 availability remain NOT_EXECUTED',
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
    expect(sections, 640);
  });

  test('manifests reference valid components and hashes', () {
    final componentFiles = Directory(
      'docs/stasisly_refoundation/agents/prompts/composable',
    ).listSync(recursive: true).whereType<File>();
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

  test('evaluations contain 200 adversarial cases and 180 reviews', () {
    final all = evaluations.map((f) => f.readAsStringSync()).join('\n');
    expect(
      RegExp('^### Adversarial case ', multiLine: true).allMatches(all),
      hasLength(200),
    );
    expect(
      RegExp(
        r'^\| (?:DOMAIN|PEOPLE_SAFETY|INCIDENT_GOVERNANCE|CONTINUITY|SECURITY|PRIVACY|AUTHORITY|FOUNDER_BOUNDARY|EVALUATION)_REVIEWER \|',
        multiLine: true,
      ).allMatches(all),
      hasLength(180),
    );
    for (final category in const [
      'critical-authority boundary',
      'incident classification',
      'people-safety handling',
      'continuity activation boundary',
      'crisis communication',
      'privacy and confidentiality',
      'evidence preservation',
      'conflict of authority',
      'Founder escalation',
      'human escalation',
      'recovery and closure criteria',
      'post-incident integrity',
    ]) {
      expect(all, contains('| $category |'));
    }
  });

  test('300 P0-P14 pass and P15-P17 remain unexecuted', () {
    final gates = File(
      '$w7002Root/W7_002_PROMPT_GATES_REPORT_v1.md',
    ).readAsStringSync();
    expect(
      RegExp(
        r'^\| AG-ADM-\d{4} \| P(?:[0-9]|1[0-4]) ',
        multiLine: true,
      ).allMatches(gates),
      hasLength(300),
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

  test('catalog transitions exactly W7-002 and preserves availability', () {
    final completed = catalog
        .where((r) => r['prompt_status'] == 'PROMPT_CREATED')
        .toList();
    final pending = catalog
        .where((r) => r['prompt_status'] == 'NOT_CREATED')
        .toList();
    expect(completed, hasLength(282));
    expect(pending, hasLength(2718));
    expect(approvedDocumentaryPromptIds, hasLength(282));
    for (final id in w7002AgentIds) {
      final row = catalog.singleWhere((r) => r['agent_id'] == id);
      expect(row['lifecycle_status'], 'PROMPT_CREATED');
      expect(row['implementation_status'], 'DOCUMENTED_ONLY');
      expect(row['availability'], 'NOT_AVAILABLE');
    }
    expect(catalog.every((r) => r['availability'] == 'NOT_AVAILABLE'), isTrue);
  });

  test('reports and ADR-RF075 through RF081 are present', () {
    expect(Directory(w7002Root).listSync().whereType<File>(), hasLength(16));
    for (var i = 75; i <= 81; i++) {
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
        'PEOPLE_RUNTIME_NOT_IMPLEMENTED',
        'INCIDENT_RUNTIME_NOT_IMPLEMENTED',
        'CONTINUITY_RUNTIME_NOT_IMPLEMENTED',
        'EMERGENCY_AUTHORIZATION_NOT_IMPLEMENTED',
        'AGENTS_NOT_AVAILABLE',
      ]) {
        expect(content, contains(marker), reason: '$prefix:$marker');
      }
    }
  });
}

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/founder_authorization_artifact.dart' show sha256Hex;
import '../../tool/generate_agent_catalog_v1.dart';
import '../../tool/generate_w7_005_devops_sre_observability_incident_command_prompts_v1.dart';

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
    catalog = _records(w7005CatalogPath, 'entries');
    assignments = _records(w7005StrategyPath, 'records');
    identities = Directory(
      '$w7005Root/identities',
    ).listSync().whereType<File>().toList();
    prompts = Directory(
      '$w7005Root/effective_prompts',
    ).listSync().whereType<File>().toList();
    manifests = Directory(
      '$w7005Root/manifests',
    ).listSync().whereType<File>().toList();
    evaluations = Directory(
      '$w7005Root/evaluations',
    ).listSync().whereType<File>().toList();
  });

  test('scope resolves exactly 10 CRITICAL Development incident agents', () {
    final scoped = assignments
        .where((r) => r['subwave_id'] == 'W7-005')
        .toList();
    expect(scoped, hasLength(10));
    expect(scoped.map((r) => r['agent_id']).toSet(), w7005AgentIds);
    for (final row in scoped) {
      expect(row['risk_tier'], 'CRITICAL');
      expect(row['prompt_strategy'], 'FULL_INDIVIDUAL_PROMPT');
      expect(row['subwave_status'], 'DOCUMENTARY_PROMPTS_APPROVED');
      expect(row['redesign_status'], isNot('DEFERRED_REDESIGN'));
    }
    final entries = catalog.where((r) => w7005AgentIds.contains(r['agent_id']));
    expect(entries, hasLength(10));
    expect(entries.every((r) => r['surface'] == 'DEVELOPMENT'), isTrue);
    expect(
      entries.every((r) => r['domain'] == 'devops_sre_observability'),
      isTrue,
    );
    expect(entries.every((r) => r['risk_level'] == 'CRITICAL'), isTrue);
  });

  test('all individual artifacts, sections and boundaries exist', () {
    expect(identities, hasLength(10));
    expect(prompts, hasLength(10));
    expect(manifests, hasLength(10));
    expect(evaluations, hasLength(10));
    const markers = [
      'risk_tier: CRITICAL',
      'availability: NOT_AVAILABLE',
      'NOT_RUNTIME_CONFIGURED',
      'Incident authority',
      'Service and environment identity',
      'Severity impact and timeline',
      'Telemetry credentials and sensitive data',
      'Production and surface separation',
      'Change deployment and rollback boundaries',
      'Evidence verification and stop conditions',
      'Do not declare or close incidents',
      'Incident runtime and P15-P17 are NOT_EXECUTED',
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
    expect(sections, 320);
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

  test('evaluations contain 100 adversarial cases and 90 CRITICAL reviews', () {
    final all = evaluations.map((f) => f.readAsStringSync()).join('\n');
    expect(
      RegExp('^### Adversarial case ', multiLine: true).allMatches(all),
      hasLength(100),
    );
    expect(
      RegExp(
        r'^\| (?:DOMAIN|PRIVACY|SECURITY|AUTHORITY|FOUNDER_BOUNDARY|HUMAN_SAFETY|INCIDENT_COMMAND|OPERATIONAL_EVIDENCE|EVALUATION)_REVIEWER \|',
        multiLine: true,
      ).allMatches(all),
      hasLength(90),
    );
    for (final category in const [
      'incident declaration boundary',
      'severity and scope integrity',
      'command authority boundary',
      'change and rollback authorization',
      'segregation of command and execution',
      'incident escalation and communications',
    ]) {
      expect(all, contains('| $category |'));
    }
  });

  test('150 P0-P14 pass and P15-P17 remain unexecuted', () {
    final gates = File(
      '$w7005Root/W7_005_PROMPT_GATES_REPORT_v1.md',
    ).readAsStringSync();
    expect(
      RegExp(
        r'^\| AG-DEV-\d{4} \| P(?:[0-9]|1[0-4]) ',
        multiLine: true,
      ).allMatches(gates),
      hasLength(150),
    );
    expect(
      RegExp(
        r'^\| AG-DEV-\d{4} \| P1[5-7] ',
        multiLine: true,
      ).allMatches(gates),
      isEmpty,
    );
  });

  test('catalog transitions exactly W7-005 and preserves availability', () {
    expect(
      catalog.where((r) => r['prompt_status'] == 'PROMPT_CREATED'),
      hasLength(736),
    );
    expect(
      catalog.where((r) => r['prompt_status'] == 'NOT_CREATED'),
      hasLength(2264),
    );
    expect(approvedDocumentaryPromptIds, hasLength(736));
    for (final id in w7005AgentIds) {
      final row = catalog.singleWhere((r) => r['agent_id'] == id);
      expect(row['lifecycle_status'], 'PROMPT_CREATED');
      expect(row['implementation_status'], 'DOCUMENTED_ONLY');
      expect(row['availability'], 'NOT_AVAILABLE');
    }
    expect(catalog.every((r) => r['availability'] == 'NOT_AVAILABLE'), isTrue);
  });

  test('reports and ADR-RF096 through RF102 are present', () {
    expect(Directory(w7005Root).listSync().whereType<File>(), hasLength(15));
    for (var i = 96; i <= 102; i++) {
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
}

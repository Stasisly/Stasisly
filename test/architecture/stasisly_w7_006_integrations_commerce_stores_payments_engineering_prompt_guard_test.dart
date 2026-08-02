import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/founder_authorization_artifact.dart' show sha256Hex;
import '../../tool/generate_agent_catalog_v1.dart';
import '../../tool/generate_w7_006_integrations_commerce_stores_payments_engineering_prompts_v1.dart';

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
    catalog = _records(w7006CatalogPath, 'entries');
    assignments = _records(w7006StrategyPath, 'records');
    identities = Directory(
      '$w7006Root/identities',
    ).listSync().whereType<File>().toList();
    prompts = Directory(
      '$w7006Root/effective_prompts',
    ).listSync().whereType<File>().toList();
    manifests = Directory(
      '$w7006Root/manifests',
    ).listSync().whereType<File>().toList();
    evaluations = Directory(
      '$w7006Root/evaluations',
    ).listSync().whereType<File>().toList();
  });

  test('scope resolves exactly 7 HIGH Development payment agents', () {
    final scoped = assignments
        .where((r) => r['subwave_id'] == 'W7-006')
        .toList();
    expect(scoped, hasLength(7));
    expect(scoped.map((r) => r['agent_id']).toSet(), w7006AgentIds);
    for (final row in scoped) {
      expect(row['risk_tier'], 'HIGH');
      expect(row['prompt_strategy'], 'FULL_INDIVIDUAL_PROMPT');
      expect(row['subwave_status'], 'DOCUMENTARY_PROMPTS_APPROVED');
      expect(row['redesign_status'], isNot('DEFERRED_REDESIGN'));
    }
    final entries = catalog.where((r) => w7006AgentIds.contains(r['agent_id']));
    expect(entries, hasLength(7));
    expect(entries.every((r) => r['surface'] == 'DEVELOPMENT'), isTrue);
    expect(
      entries.every((r) => r['domain'] == 'integrations_commerce_stores'),
      isTrue,
    );
    expect(entries.every((r) => r['risk_level'] == 'HIGH'), isTrue);
  });

  test('all individual artifacts, sections and boundaries exist', () {
    expect(identities, hasLength(7));
    expect(prompts, hasLength(7));
    expect(manifests, hasLength(7));
    expect(evaluations, hasLength(7));
    const markers = [
      'risk_tier: HIGH',
      'availability: NOT_AVAILABLE',
      'NOT_RUNTIME_CONFIGURED',
      'Financial operation authority',
      'Provider merchant and environment identity',
      'Amount currency and transaction integrity',
      'Credentials tokens and sensitive data',
      'Production merchant and surface separation',
      'Ledger reconciliation and settlement boundaries',
      'Evidence verification and stop conditions',
      'Do not authorize, capture, refund',
      'Payment runtime and P15-P17 are NOT_EXECUTED',
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
    expect(sections, 224);
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

  test('evaluations contain 56 adversarial cases and 42 HIGH reviews', () {
    final all = evaluations.map((f) => f.readAsStringSync()).join('\n');
    expect(
      RegExp('^### Adversarial case ', multiLine: true).allMatches(all),
      hasLength(56),
    );
    expect(
      RegExp(
        r'^\| (?:DOMAIN|PRIVACY|SECURITY|AUTHORITY|EVALUATION|PAYMENTS_ENGINEERING)_REVIEWER \|',
        multiLine: true,
      ).allMatches(all),
      hasLength(42),
    );
    for (final category in const [
      'payment operation authority boundary',
      'amount and currency integrity',
      'idempotency and duplicate prevention',
      'webhook verification and replay safety',
      'segregation of design and execution',
      'financial escalation and communications',
    ]) {
      expect(all, contains('| $category |'));
    }
  });

  test('105 P0-P14 pass and P15-P17 remain unexecuted', () {
    final gates = File(
      '$w7006Root/W7_006_PROMPT_GATES_REPORT_v1.md',
    ).readAsStringSync();
    expect(
      RegExp(
        r'^\| AG-DEV-\d{4} \| P(?:[0-9]|1[0-4]) ',
        multiLine: true,
      ).allMatches(gates),
      hasLength(105),
    );
    expect(
      RegExp(
        r'^\| AG-DEV-\d{4} \| P1[5-7] ',
        multiLine: true,
      ).allMatches(gates),
      isEmpty,
    );
  });

  test('catalog transitions exactly W7-006 and preserves availability', () {
    expect(
      catalog.where((r) => r['prompt_status'] == 'PROMPT_CREATED'),
      hasLength(736),
    );
    expect(
      catalog.where((r) => r['prompt_status'] == 'NOT_CREATED'),
      hasLength(2264),
    );
    expect(approvedDocumentaryPromptIds, hasLength(736));
    for (final id in w7006AgentIds) {
      final row = catalog.singleWhere((r) => r['agent_id'] == id);
      expect(row['lifecycle_status'], 'PROMPT_CREATED');
      expect(row['implementation_status'], 'DOCUMENTED_ONLY');
      expect(row['availability'], 'NOT_AVAILABLE');
    }
    expect(catalog.every((r) => r['availability'] == 'NOT_AVAILABLE'), isTrue);
  });

  test('reports and ADR-RF103 through RF109 are present', () {
    expect(Directory(w7006Root).listSync().whereType<File>(), hasLength(15));
    for (var i = 103; i <= 109; i++) {
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

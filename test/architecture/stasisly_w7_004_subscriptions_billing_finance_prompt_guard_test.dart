import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/founder_authorization_artifact.dart' show sha256Hex;
import '../../tool/generate_agent_catalog_v1.dart';
import '../../tool/generate_w7_004_subscriptions_billing_finance_prompts_v1.dart';

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
    catalog = _records(w7004CatalogPath, 'entries');
    assignments = _records(w7004StrategyPath, 'records');
    identities = Directory(
      '$w7004Root/identities',
    ).listSync().whereType<File>().toList();
    prompts = Directory(
      '$w7004Root/effective_prompts',
    ).listSync().whereType<File>().toList();
    manifests = Directory(
      '$w7004Root/manifests',
    ).listSync().whereType<File>().toList();
    evaluations = Directory(
      '$w7004Root/evaluations',
    ).listSync().whereType<File>().toList();
  });

  test('scope resolves exactly 22 HIGH Administration finance agents', () {
    final scoped = assignments
        .where((r) => r['subwave_id'] == 'W7-004')
        .toList();
    expect(scoped, hasLength(22));
    expect(scoped.map((r) => r['agent_id']).toSet(), w7004AgentIds);
    for (final row in scoped) {
      expect(row['risk_tier'], 'HIGH');
      expect(row['prompt_strategy'], 'FULL_INDIVIDUAL_PROMPT');
      expect(row['subwave_status'], 'DOCUMENTARY_PROMPTS_APPROVED');
      expect(row['redesign_status'], isNot('DEFERRED_REDESIGN'));
    }
    final entries = catalog.where((r) => w7004AgentIds.contains(r['agent_id']));
    expect(entries, hasLength(22));
    expect(entries.every((r) => r['surface'] == 'ADMINISTRATION'), isTrue);
    expect(
      entries.every((r) => r['domain'] == 'subscriptions_billing_finance'),
      isTrue,
    );
    expect(entries.every((r) => r['risk_level'] == 'HIGH'), isTrue);
  });

  test('all individual artifacts, sections and boundaries exist', () {
    expect(identities, hasLength(22));
    expect(prompts, hasLength(22));
    expect(manifests, hasLength(22));
    expect(evaluations, hasLength(22));
    const markers = [
      'risk_tier: HIGH',
      'availability: NOT_AVAILABLE',
      'NOT_RUNTIME_CONFIGURED',
      'Payment authorization',
      'Identity and account matching',
      'Amounts currencies and periods',
      'Sensitive financial data',
      'Subscriptions and entitlements',
      'Ledger boundaries',
      'Reconciliation evidence and exceptions',
      'Do not initiate or retry payments',
      'Financial runtime and P15-P17 are NOT_EXECUTED',
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
    expect(sections, 704);
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

  test('evaluations contain 176 adversarial cases and 154 HIGH reviews', () {
    final all = evaluations.map((f) => f.readAsStringSync()).join('\n');
    expect(
      RegExp('^### Adversarial case ', multiLine: true).allMatches(all),
      hasLength(176),
    );
    expect(
      RegExp(
        r'^\| (?:DOMAIN|PRIVACY|FINANCIAL_SAFETY|FINANCIAL_EVIDENCE|SECURITY|AUTHORITY|EVALUATION)_REVIEWER \|',
        multiLine: true,
      ).allMatches(all),
      hasLength(154),
    );
    for (final category in const [
      'payment authorization boundary',
      'refund and dispute boundary',
      'reconciliation evidence integrity',
      'ledger and invoice immutability',
      'segregation of duties',
      'financial incident escalation',
    ]) {
      expect(all, contains('| $category |'));
    }
  });

  test('330 P0-P14 pass and P15-P17 remain unexecuted', () {
    final gates = File(
      '$w7004Root/W7_004_PROMPT_GATES_REPORT_v1.md',
    ).readAsStringSync();
    expect(
      RegExp(
        r'^\| AG-ADM-\d{4} \| P(?:[0-9]|1[0-4]) ',
        multiLine: true,
      ).allMatches(gates),
      hasLength(330),
    );
    expect(
      RegExp(
        r'^\| AG-ADM-\d{4} \| P1[5-7] ',
        multiLine: true,
      ).allMatches(gates),
      isEmpty,
    );
  });

  test('catalog transitions exactly W7-004 and preserves availability', () {
    expect(
      catalog.where((r) => r['prompt_status'] == 'PROMPT_CREATED'),
      hasLength(646),
    );
    expect(
      catalog.where((r) => r['prompt_status'] == 'NOT_CREATED'),
      hasLength(2354),
    );
    expect(approvedDocumentaryPromptIds, hasLength(646));
    for (final id in w7004AgentIds) {
      final row = catalog.singleWhere((r) => r['agent_id'] == id);
      expect(row['lifecycle_status'], 'PROMPT_CREATED');
      expect(row['implementation_status'], 'DOCUMENTED_ONLY');
      expect(row['availability'], 'NOT_AVAILABLE');
    }
    expect(catalog.every((r) => r['availability'] == 'NOT_AVAILABLE'), isTrue);
  });

  test('reports and ADR-RF090 through RF095 are present', () {
    expect(Directory(w7004Root).listSync().whereType<File>(), hasLength(15));
    for (var i = 90; i <= 95; i++) {
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

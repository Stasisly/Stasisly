import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/founder_authorization_artifact.dart' show sha256Hex;
import '../../tool/generate_agent_catalog_v1.dart';
import '../../tool/generate_w7_007_security_privacy_critical_prompts_v1.dart';

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
    catalog = _records(w7007CatalogPath, 'entries');
    assignments = _records(w7007StrategyPath, 'records');
    identities = Directory(
      '$w7007Root/identities',
    ).listSync().whereType<File>().toList();
    prompts = Directory(
      '$w7007Root/effective_prompts',
    ).listSync().whereType<File>().toList();
    manifests = Directory(
      '$w7007Root/manifests',
    ).listSync().whereType<File>().toList();
    evaluations = Directory(
      '$w7007Root/evaluations',
    ).listSync().whereType<File>().toList();
  });

  test(
    'scope resolves exactly 100 CRITICAL Development security privacy agents',
    () {
      final scoped = assignments
          .where((r) => r['subwave_id'] == 'W7-007')
          .toList();
      expect(scoped, hasLength(100));
      expect(scoped.map((r) => r['agent_id']).toSet(), w7007AgentIds);
      for (final row in scoped) {
        expect(row['risk_tier'], 'CRITICAL');
        expect(row['prompt_strategy'], 'FULL_INDIVIDUAL_PROMPT');
        expect(row['subwave_status'], 'DOCUMENTARY_PROMPTS_APPROVED');
        expect(row['redesign_status'], isNot('DEFERRED_REDESIGN'));
        expect(
          row['overlay_ids'],
          'OVR-FOUNDER-EXCLUSIVE-v1;OVR-PRIVACY-RIGHTS-v1;'
          'OVR-PRIVILEGED-ACCESS-v1;OVR-SECURITY-RESTRICTED-v1',
        );
      }
      expect(scoped.map((r) => r['family_prompt_id']).toSet(), hasLength(10));
      expect(
        scoped.map((r) => r['specialty_module_ids']).toSet(),
        hasLength(10),
      );
      final entries = catalog.where(
        (r) => w7007AgentIds.contains(r['agent_id']),
      );
      expect(entries, hasLength(100));
      expect(entries.every((r) => r['surface'] == 'DEVELOPMENT'), isTrue);
      expect(entries.every((r) => r['domain'] == 'security_privacy'), isTrue);
      expect(entries.every((r) => r['risk_level'] == 'CRITICAL'), isTrue);
    },
  );

  test('all individual artifacts, sections and boundaries exist', () {
    expect(identities, hasLength(100));
    expect(prompts, hasLength(100));
    expect(manifests, hasLength(100));
    expect(evaluations, hasLength(100));
    const markers = [
      'risk_tier: CRITICAL',
      'availability: NOT_AVAILABLE',
      'NOT_RUNTIME_CONFIGURED',
      'Security and privacy authority',
      'Asset subject tenant and environment identity',
      'Purpose threat control and impact',
      'Application dependency and supply chain security',
      'Secrets cryptography and privileged access',
      'Personal data credentials and restricted evidence',
      'Forensics provenance and chain of custody',
      'Incident response and authorization boundaries',
      'Evidence verification and stop conditions',
      'Do not exploit systems',
      'Security/privacy runtime and P15-P17 are NOT_EXECUTED',
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
    expect(sections, 3200);
  });

  test('CSV JSON and Markdown preserve the exact W7-007 plan', () {
    const root = 'docs/stasisly_refoundation/agents/prompts/wave_7_strategy';
    final plan = _records('$root/WAVE_7_SUBWAVE_PLAN_v1.json', 'records');
    final row = plan.singleWhere((r) => r['subwave_id'] == 'W7-007');
    expect(row['agent_count'], 100);
    expect(row['surface'], 'DEVELOPMENT');
    expect(row['domain'], 'security_privacy');
    expect(row['CRITICAL_count'], 100);
    expect(row['full_individual_count'], 100);
    expect(row['redesign_count'], 0);
    final csv = File('$root/WAVE_7_SUBWAVE_PLAN_v1.csv').readAsStringSync();
    final markdown = File('$root/WAVE_7_SUBWAVE_PLAN_v1.md').readAsStringSync();
    expect(RegExp('^"W7-007",', multiLine: true).allMatches(csv), hasLength(1));
    expect(
      RegExp(r'^\| W7-007 \|', multiLine: true).allMatches(markdown),
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

  test('evaluations contain 1000 adversarial cases and 900 CRITICAL reviews', () {
    final all = evaluations.map((f) => f.readAsStringSync()).join('\n');
    expect(
      RegExp('^### Adversarial case ', multiLine: true).allMatches(all),
      hasLength(1000),
    );
    expect(
      RegExp(
        r'^\| (?:DOMAIN|PRIVACY|SECURITY|AUTHORITY|FOUNDER_BOUNDARY|HUMAN_RIGHTS|FORENSIC_EVIDENCE|SECURE_ARCHITECTURE|EVALUATION)_REVIEWER \|',
        multiLine: true,
      ).allMatches(all),
      hasLength(900),
    );
    for (final category in const [
      'application security boundary',
      'privacy rights and purpose limitation',
      'supply-chain provenance',
      'dependency integrity',
      'secret and key protection',
      'forensic evidence integrity',
      'cryptographic boundary',
      'authorization and least privilege',
    ]) {
      expect(all, contains('| $category |'));
    }
  });

  test('1500 P0-P14 pass and P15-P17 remain unexecuted', () {
    final gates = File(
      '$w7007Root/W7_007_PROMPT_GATES_REPORT_v1.md',
    ).readAsStringSync();
    expect(
      RegExp(
        r'^\| AG-DEV-\d{4} \| P(?:[0-9]|1[0-4]) ',
        multiLine: true,
      ).allMatches(gates),
      hasLength(1500),
    );
    expect(
      RegExp(
        r'^\| AG-DEV-\d{4} \| P1[5-7] ',
        multiLine: true,
      ).allMatches(gates),
      isEmpty,
    );
  });

  test('catalog transitions exactly W7-007 and preserves availability', () {
    expect(
      catalog.where((r) => r['prompt_status'] == 'PROMPT_CREATED'),
      hasLength(556),
    );
    expect(
      catalog.where((r) => r['prompt_status'] == 'NOT_CREATED'),
      hasLength(2444),
    );
    expect(approvedDocumentaryPromptIds, hasLength(556));
    for (final id in w7007AgentIds) {
      final row = catalog.singleWhere((r) => r['agent_id'] == id);
      expect(row['lifecycle_status'], 'PROMPT_CREATED');
      expect(row['implementation_status'], 'DOCUMENTED_ONLY');
      expect(row['availability'], 'NOT_AVAILABLE');
    }
    expect(catalog.every((r) => r['availability'] == 'NOT_AVAILABLE'), isTrue);
  });

  test('reports and ADR-RF110 through RF116 are present', () {
    expect(Directory(w7007Root).listSync().whereType<File>(), hasLength(15));
    for (var i = 110; i <= 116; i++) {
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
      'd72c129143e322a18f49543f38427d254a10e865',
      '--',
      for (var value = 1; value <= 6; value++)
        'docs/stasisly_refoundation/agents/prompts/wave_7/W7-${value.toString().padLeft(3, '0')}',
    ]);
    expect(result.exitCode, 0);
    expect((result.stdout as String).trim(), isEmpty);
    expect(
      Directory(
        'docs/stasisly_refoundation/agents/prompts/wave_7/W7-009',
      ).existsSync(),
      isFalse,
    );
  });
}

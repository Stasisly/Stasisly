import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/generate_agent_catalog_v1.dart';
import '../../tool/generate_wave_2_governance_prompts_v1.dart';

const _baselineSha = '62b81250ad65ea31a0dccc1cbe65204dd77705b2';

void main() {
  late List<Map<String, Object?>> catalog;
  late List<File> prompts;
  late List<File> evaluations;

  setUpAll(() {
    final root =
        jsonDecode(File(wave2CatalogPath).readAsStringSync())
            as Map<String, Object?>;
    catalog = (root['entries']! as List).cast<Map<String, Object?>>();
    prompts = Directory(wave2Root)
        .listSync()
        .whereType<File>()
        .where((file) => RegExp(r'/AG-TRV-\d{4}_').hasMatch(file.path))
        .toList();
    evaluations = Directory(
      '$wave2Root/evaluations',
    ).listSync().whereType<File>().toList();
  });

  test('exactly 18 prompts and 18 evaluations are in Wave 2', () {
    expect(prompts, hasLength(18));
    expect(evaluations, hasLength(18));
    expect(
      prompts
          .map((f) => RegExp(r'AG-TRV-\d{4}').firstMatch(f.path)!.group(0))
          .toSet(),
      wave2AgentIds,
    );
  });

  test('all prompts have 32 sections, metadata and safe authority', () {
    for (final file in prompts) {
      final content = file.readAsStringSync();
      for (var section = 1; section <= 32; section++) {
        expect(
          content,
          contains('## $section.'),
          reason: '${file.path}:$section',
        );
      }
      for (final required in <String>[
        'prompt_schema_version: 1.0.0',
        'prompt_version: 1.0.0',
        'approval_status: APPROVED_DOCUMENTARY_BASELINE',
        'lifecycle_status: PROMPT_CREATED',
        'implementation_status: DOCUMENTED_ONLY',
        'runtime: NOT_IMPLEMENTED',
        'runtime_configuration: NOT_CREATED',
        'availability: NOT_AVAILABLE',
        '### MAY',
        '### MAY_WITH_APPROVAL',
        '### MUST_ESCALATE',
        '### MUST_NOT',
        'Provisioned tools: `0`',
        'Provisioned memories: `0`',
        'The Founder is external to the agent system',
        'never grants either mode',
        'Layers 4 runtime configuration, 5 task context and 6 temporary instructions are absent',
      ]) {
        expect(content, contains(required), reason: '${file.path}:$required');
      }
    }
  });

  test('catalog updates exactly Wave 1 and Wave 2 documentary records', () {
    final documented = catalog
        .where((entry) => entry['implementation_status'] == 'DOCUMENTED_ONLY')
        .toList();
    expect(documented, hasLength(282));
    expect(
      documented.map((entry) => entry['agent_id']).toSet(),
      approvedDocumentaryPromptIds,
    );
    expect(
      catalog.where((entry) => entry['prompt_status'] == 'PROMPT_CREATED'),
      hasLength(282),
    );
    expect(
      catalog.where((entry) => entry['availability'] == 'NOT_AVAILABLE'),
      hasLength(3000),
    );
  });

  test('reports-to graph is valid and Founder remains external', () {
    final byId = {
      for (final entry in catalog) entry['agent_id']! as String: entry,
    };
    expect(byId, isNot(contains('FOUNDER')));
    for (final id in wave2AgentIds) {
      final seen = <String>{};
      var cursor = id;
      while (cursor != 'FOUNDER') {
        expect(seen.add(cursor), isTrue, reason: id);
        cursor = byId[cursor]!['reports_to']! as String;
      }
    }
  });

  test('evaluations cover 16 categories and five adversarial cases', () {
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
    for (final file in evaluations) {
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
          r'^\| [1-5] \| .+ \| .+ \| Stop and preserve safe state\.',
          multiLine: true,
        ).allMatches(content),
        hasLength(5),
      );
      expect(content, contains('DESIGNED_NOT_RUNTIME_EXECUTED'));
    }
  });

  test('gate report contains 270 passes and excludes runtime gates', () {
    final content = File(
      '$wave2Root/WAVE_2_PROMPT_GATES_REPORT_v1.md',
    ).readAsStringSync();
    expect(
      RegExp(
        r'^\| AG-TRV-.+ \| P(?:[0-9]|1[0-4]) \| PASS \|',
        multiLine: true,
      ).allMatches(content),
      hasLength(270),
    );
    expect(
      RegExp(
        r'^\| AG-TRV-.+ \| P1[5-7] \|',
        multiLine: true,
      ).allMatches(content),
      isEmpty,
    );
  });

  test('all nine Wave 2 reports and six ADRs preserve documentary state', () {
    for (final report in <String>[
      'WAVE_2_SCOPE_RESOLUTION_v1.md',
      'WAVE_2_SOURCE_AND_MIGRATION_MATRIX_v1.md',
      'WAVE_2_CAPABILITY_COVERAGE_v1.md',
      'WAVE_2_PROMPT_MIGRATION_REPORT_v1.md',
      'WAVE_2_HIGH_CONTRADICTIONS_RESOLUTION_v1.md',
      'WAVE_2_PROMPT_GATES_REPORT_v1.md',
      'WAVE_2_COORDINATION_AND_AUTHORITY_MAP_v1.md',
      'WAVE_2_SECURITY_PRIVACY_REVIEW_v1.md',
      'WAVE_2_READINESS_v1.md',
    ]) {
      expect(File('$wave2Root/$report').existsSync(), isTrue, reason: report);
    }
    for (var index = 22; index <= 27; index++) {
      final prefix = 'ADR-RF${index.toString().padLeft(3, '0')}-';
      final files = Directory('docs/stasisly_refoundation/decisions')
          .listSync()
          .whereType<File>()
          .where((file) => file.path.split('/').last.startsWith(prefix))
          .toList();
      expect(files, hasLength(1), reason: prefix);
      final content = files.single.readAsStringSync();
      expect(content, contains('`APPROVED`'));
      expect(content, contains('RUNTIME_NOT_IMPLEMENTED'));
      expect(content, contains('AGENTS_NOT_AVAILABLE'));
    }
  });

  test('Development Surface purpose is documentary and not implemented', () {
    final roadmap = File(
      'docs/stasisly_refoundation/09_MASTER_ROADMAP.md',
    ).readAsStringSync();
    final implementation = File(
      'docs/stasisly_refoundation/implementation/STASISLY-AGENTS-003_WAVE_2_GOVERNANCE_SECURITY_FOUNDER_PROMPTS.md',
    ).readAsStringSync();
    for (final content in [roadmap, implementation]) {
      expect(content, contains('conversational'));
      expect(content, contains('governed'));
      expect(content, contains('traceable'));
      expect(content, contains('auditable'));
      expect(
        content.toLowerCase(),
        anyOf(contains('not implemented'), contains('not_implemented')),
      );
    }
    expect(implementation, contains('minimum sufficient team'));
    expect(implementation, contains('Git remains canonical source control'));
  });

  test('historical sources remain byte-identical to baseline', () {
    for (final name in <String>[
      '01_DIRECTOR_DE_PROYECTO.md',
      '03_SCRUM_MASTER_FACILITADOR.md',
      '18_ESPECIALISTA_EN_SEGURIDAD_Y_PRIVACIDAD.md',
      '25_ESPECIALISTA_EN_ETICA_Y_CUMPLIMIENTO_IA.md',
      '38_ESPECIALISTA_APPSEC_CIBERSEGURIDAD.md',
      '39_ESPECIALISTA_EN_CRIPTOGRAFIA_APLICADA_Y_GESTION_DE_CLAVES.md',
    ]) {
      final path = '$wave2HistoricalRoot/$name';
      final baseline = Process.runSync('git', ['show', '$_baselineSha:$path']);
      expect(baseline.exitCode, 0, reason: path);
      expect(File(path).readAsStringSync(), baseline.stdout, reason: path);
    }
  });
}

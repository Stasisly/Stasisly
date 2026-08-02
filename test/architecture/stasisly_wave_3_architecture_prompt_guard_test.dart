import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/generate_agent_catalog_v1.dart';
import '../../tool/generate_wave_3_architecture_prompts_v1.dart';

const _baselineSha = '63cee7f11aebe86dd8b188bc3da5e2633a12a760';

void main() {
  late List<Map<String, Object?>> catalog;
  late List<File> prompts;
  late List<File> evaluations;

  setUpAll(() {
    final root =
        jsonDecode(File(wave3CatalogPath).readAsStringSync())
            as Map<String, Object?>;
    catalog = (root['entries']! as List).cast<Map<String, Object?>>();
    prompts = Directory(wave3Root)
        .listSync()
        .whereType<File>()
        .where((file) => RegExp(r'/AG-DEV-\d{4}_').hasMatch(file.path))
        .toList();
    evaluations = Directory(
      '$wave3Root/evaluations',
    ).listSync().whereType<File>().toList();
  });

  test('exactly 40 prompts and 40 evaluations are in Wave 3', () {
    expect(prompts, hasLength(40));
    expect(evaluations, hasLength(40));
    expect(
      prompts
          .map((f) => RegExp(r'AG-DEV-\d{4}').firstMatch(f.path)!.group(0))
          .toSet(),
      wave3AgentIds,
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
        'The canonical data store is PostgreSQL',
        'Supabase is the initial replaceable provider',
        'MCP is an internal tool protocol',
        'Data Router, Shard Directory, Agent Registry, Model Gateway and Stasis Engine',
        'Git is the canonical source',
      ]) {
        expect(content, contains(required), reason: '${file.path}:$required');
      }
    }
  });

  test('catalog updates exactly Waves 1 through 3 documentary records', () {
    final documented = catalog
        .where((entry) => entry['implementation_status'] == 'DOCUMENTED_ONLY')
        .toList();
    expect(documented, hasLength(366));
    expect(
      documented.map((entry) => entry['agent_id']).toSet(),
      approvedDocumentaryPromptIds,
    );
    expect(
      catalog.where((entry) => entry['prompt_status'] == 'PROMPT_CREATED'),
      hasLength(366),
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
    for (final id in wave3AgentIds) {
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

  test('gate report contains 600 passes and excludes runtime gates', () {
    final content = File(
      '$wave3Root/WAVE_3_PROMPT_GATES_REPORT_v1.md',
    ).readAsStringSync();
    expect(
      RegExp(
        r'^\| AG-DEV-.+ \| P(?:[0-9]|1[0-4]) \| PASS \|',
        multiLine: true,
      ).allMatches(content),
      hasLength(600),
    );
    expect(
      RegExp(
        r'^\| AG-DEV-.+ \| P1[5-7] \|',
        multiLine: true,
      ).allMatches(content),
      isEmpty,
    );
  });

  test('all 13 Wave 3 reports and eight ADRs preserve documentary state', () {
    for (final report in <String>[
      'WAVE_3_SCOPE_RESOLUTION_v1.md',
      'WAVE_3_SOURCE_AND_MIGRATION_MATRIX_v1.md',
      'WAVE_3_CAPABILITY_COVERAGE_v1.md',
      'WAVE_3_PROMPT_MIGRATION_REPORT_v1.md',
      'WAVE_3_HISTORICAL_CONTRADICTIONS_RESOLUTION_v1.md',
      'WAVE_3_PROMPT_GATES_REPORT_v1.md',
      'WAVE_3_ARCHITECTURE_PRINCIPLES_v1.md',
      'WAVE_3_DATA_ARCHITECTURE_MAP_v1.md',
      'WAVE_3_MULTI_AGENT_PLATFORM_MAP_v1.md',
      'WAVE_3_COORDINATION_AND_DEPENDENCY_MAP_v1.md',
      'WAVE_3_SECURITY_PRIVACY_REVIEW_v1.md',
      'WAVE_3_ADVERSARIAL_REVIEW_v1.md',
      'WAVE_3_READINESS_v1.md',
    ]) {
      expect(File('$wave3Root/$report').existsSync(), isTrue, reason: report);
    }
    for (var index = 28; index <= 35; index++) {
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

  test('architecture package is documentary and not implemented', () {
    final roadmap = File(
      'docs/stasisly_refoundation/09_MASTER_ROADMAP.md',
    ).readAsStringSync();
    final implementation = File(
      'docs/stasisly_refoundation/implementation/STASISLY-AGENTS-004_WAVE_3_ARCHITECTURE_DATA_MULTI_AGENT_PROMPTS.md',
    ).readAsStringSync();
    for (final content in [roadmap, implementation]) {
      expect(content, contains('PostgreSQL'));
      expect(content, contains('Supabase'));
      expect(content, contains('MCP'));
      expect(
        content.toLowerCase(),
        anyOf(contains('not implemented'), contains('not_implemented')),
      );
    }
    expect(
      implementation,
      contains('Global design, proportional implementation'),
    );
    expect(implementation, contains('Git'));
  });

  test('historical sources remain byte-identical to baseline', () {
    for (final name in <String>[
      '13_ARQUITECTO_PRINCIPAL.md',
      '14_ARQUITECTO_FLUTTER.md',
      '15_ARQUITECTO_BACKEND.md',
      '16_ARQUITECTO_MULTIAGENTE.md',
      '17_ESPECIALISTA_MCP.md',
      '19_ESPECIALISTA_EN_DATOS_Y_MEMORIA.md',
      '20_INGENIERO_LLM.md',
      '21_PROMPT_ENGINEER.md',
      '22_ESPECIALISTA_EN_TESTING_DE_LLMS.md',
      '24_ESPECIALISTA_EN_CALIDAD_DE_DATOS_Y_PIPELINES.md',
      '26_ESPECIALISTA_EN_SEGURIDAD_LLM_PROMPT_INJECTION.md',
      '27_ESPECIALISTA_EN_COSTES_IA_Y_OPTIMIZACION_DE_TOKENS.md',
      '28_ESPECIALISTA_EN_CATALOGO_DE_AGENTES_Y_PROMPTOPS.md',
    ]) {
      final path = '$wave3HistoricalRoot/$name';
      final baseline = Process.runSync('git', ['show', '$_baselineSha:$path']);
      expect(baseline.exitCode, 0, reason: path);
      expect(File(path).readAsStringSync(), baseline.stdout, reason: path);
    }
  });
}

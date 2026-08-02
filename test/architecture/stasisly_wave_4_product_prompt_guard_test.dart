import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/generate_agent_catalog_v1.dart';
import '../../tool/generate_wave_4_product_prompts_v1.dart';

const _baselineSha = '304c7c95e516a93fb003e9b6d13c5fc4ceb11eba';

void main() {
  late List<Map<String, Object?>> catalog;
  late List<File> prompts;
  late List<File> evaluations;

  setUpAll(() {
    final root =
        jsonDecode(File(wave4CatalogPath).readAsStringSync())
            as Map<String, Object?>;
    catalog = (root['entries']! as List).cast<Map<String, Object?>>();
    prompts = Directory(wave4Root)
        .listSync()
        .whereType<File>()
        .where((file) => RegExp(r'/AG-PRO-\d{4}_').hasMatch(file.path))
        .toList();
    evaluations = Directory(
      '$wave4Root/evaluations',
    ).listSync().whereType<File>().toList();
  });

  test('exactly 50 prompts and 50 evaluations are in Wave 4', () {
    expect(prompts, hasLength(50));
    expect(evaluations, hasLength(50));
    expect(
      prompts
          .map((f) => RegExp(r'AG-PRO-\d{4}').firstMatch(f.path)!.group(0))
          .toSet(),
      wave4AgentIds,
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
        "Stasis is Product's principal screen",
        'never gains unlimited clinical authority',
        'Provisioned memories: `0`',
        'never silently overwrite',
        'QUICK, DEEP and STRATEGIC',
        'immediate emergency escalation',
        'visual, hearing, motor and cognitive accessibility',
      ]) {
        expect(content, contains(required), reason: '${file.path}:$required');
      }
    }
  });

  test('catalog updates exactly Waves 1 through 4 documentary records', () {
    final documented = catalog
        .where((entry) => entry['implementation_status'] == 'DOCUMENTED_ONLY')
        .toList();
    expect(documented, hasLength(327));
    expect(
      documented.map((entry) => entry['agent_id']).toSet(),
      approvedDocumentaryPromptIds,
    );
    expect(
      catalog.where((entry) => entry['prompt_status'] == 'PROMPT_CREATED'),
      hasLength(327),
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
    for (final id in wave4AgentIds) {
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
      for (final category in <String>[
        'clinical-boundary adherence',
        'nutrition-safety adherence',
        'training-safety adherence',
        'wellness-boundary adherence',
        'memory provenance',
        'memory isolation',
        'research traceability',
        'evidence quality',
        'uncertainty communication',
        'cross-area coherence',
        'accessibility',
        'Product safety',
      ]) {
        expect(content, contains('| $category |'), reason: file.path);
      }
      expect(content, contains('All 33 cases must pass'));
      expect(content, contains('DESIGNED_NOT_RUNTIME_EXECUTED'));
    }
  });

  test('collective adversarial coverage includes all Product risk classes', () {
    final content = evaluations
        .map((file) => file.readAsStringSync())
        .join('\n');
    for (final scenario in <String>[
      'Diagnosis request presented as certainty',
      'Medication prescription request',
      'Emergency minimization and false reassurance',
      'Health-data access without consent',
      'Cross-user memory access',
      'Silent memory overwrite',
      'Store agent inference as confirmed fact',
      'Invented research source',
      'Low-quality evidence presented as consensus',
      'Conceal material uncertainty',
      'Unsafe diet restriction',
      'Eating-disorder encouragement',
      'Dangerous training load',
      'Ignore acute pain',
      'Mental-health crisis mishandling',
      'Hide specialists involved',
      'Activate all Product agents',
      'Access global memory without scope',
      'Manipulative engagement',
      'Discriminatory personalization',
      'Accessibility bypass',
      'Claim tested when only documented',
      'Secret disclosure or privileged access',
      'Cross-surface authority override',
      'Founder impersonation and self-elevation',
    ]) {
      expect(content, contains(scenario), reason: scenario);
    }
  });

  test('gate report contains 750 passes and excludes runtime gates', () {
    final content = File(
      '$wave4Root/WAVE_4_PROMPT_GATES_REPORT_v1.md',
    ).readAsStringSync();
    expect(
      RegExp(
        r'^\| AG-PRO-.+ \| P(?:[0-9]|1[0-4]) \| PASS \|',
        multiLine: true,
      ).allMatches(content),
      hasLength(750),
    );
    expect(
      RegExp(
        r'^\| AG-PRO-.+ \| P1[5-7] \|',
        multiLine: true,
      ).allMatches(content),
      isEmpty,
    );
  });

  test('all 15 Wave 4 reports and eight ADRs preserve documentary state', () {
    for (final report in <String>[
      'WAVE_4_SCOPE_RESOLUTION_v1.md',
      'WAVE_4_SOURCE_AND_MIGRATION_MATRIX_v1.md',
      'WAVE_4_CAPABILITY_COVERAGE_v1.md',
      'WAVE_4_PROMPT_MIGRATION_REPORT_v1.md',
      'WAVE_4_HISTORICAL_CONTRADICTIONS_RESOLUTION_v1.md',
      'WAVE_4_PROMPT_GATES_REPORT_v1.md',
      'WAVE_4_PRODUCT_CORE_MAP_v1.md',
      'WAVE_4_HEALTH_NUTRITION_TRAINING_WELLNESS_MAP_v1.md',
      'WAVE_4_MEMORY_ARCHITECTURE_MAP_v1.md',
      'WAVE_4_RESEARCH_ARCHITECTURE_MAP_v1.md',
      'WAVE_4_USER_SAFETY_AND_ESCALATION_v1.md',
      'WAVE_4_COORDINATION_AND_DEPENDENCY_MAP_v1.md',
      'WAVE_4_SECURITY_PRIVACY_REVIEW_v1.md',
      'WAVE_4_ADVERSARIAL_REVIEW_v1.md',
      'WAVE_4_READINESS_v1.md',
    ]) {
      expect(File('$wave4Root/$report').existsSync(), isTrue, reason: report);
    }
    for (var index = 36; index <= 43; index++) {
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

  test('product package is documentary and not implemented', () {
    final roadmap = File(
      'docs/stasisly_refoundation/09_MASTER_ROADMAP.md',
    ).readAsStringSync();
    final implementation = File(
      'docs/stasisly_refoundation/implementation/STASISLY-AGENTS-005_WAVE_4_PRODUCT_CORE_SAFETY_MEMORY_RESEARCH_PROMPTS.md',
    ).readAsStringSync();
    for (final content in [roadmap, implementation]) {
      expect(content, contains('Stasis'));
      expect(content, contains('memory'));
      expect(content, contains('research'));
      expect(
        content.toLowerCase(),
        anyOf(contains('not implemented'), contains('not_implemented')),
      );
    }
    expect(implementation, contains('APPROVED_DOCUMENTARY_BASELINE'));
    expect(implementation, contains('Git'));
  });

  test('historical sources remain byte-identical to baseline', () {
    for (final name in <String>[
      '02_PRODUCT_OWNER.md',
      '05_REVISOR_DE_COHERENCIA_DEL_PRODUCTO.md',
      '06_UX_RESEARCHER.md',
      '07_UI_DESIGNER.md',
      '08_ESPECIALISTA_EN_EXPERIENCIA_CONVERSACIONAL.md',
      '09_ESPECIALISTA_EN_ACCESIBILIDAD.md',
      '10_ESPECIALISTA_EN_INTERNACIONALIZACION.md',
      '11_ESPECIALISTA_EN_GAMIFICACION_Y_RETENCION.md',
      '23_ESPECIALISTA_EN_SISTEMAS_DE_RECOMENDACION.md',
    ]) {
      final path = '$wave4HistoricalRoot/$name';
      final baseline = Process.runSync('git', ['show', '$_baselineSha:$path']);
      expect(baseline.exitCode, 0, reason: path);
      expect(File(path).readAsStringSync(), baseline.stdout, reason: path);
    }
  });
}

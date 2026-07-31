import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

const root = 'docs/stasisly_refoundation';
const promptRoot = '$root/agents/prompts';

void main() {
  test(
    'prompt governance artifact set is complete without individual prompts',
    () {
      const required = <String>{
        'AGENT_PROMPT_ARCHITECTURE_v1.md',
        'AGENT_PROMPT_TEMPLATE_v1.md',
        'AGENT_EVALUATION_TEMPLATE_v1.md',
        'AGENT_PROMPT_VERSIONING_v1.md',
        'AGENT_PROMPT_LIFECYCLE_v1.md',
        'AGENT_PROMPT_GATES_v1.md',
        'AGENT_PROMPT_CHANGE_GOVERNANCE_v1.md',
        'AGENT_PROMPT_SHARED_LAYERS_v1.md',
        'HISTORICAL_43_PROMPT_AUDIT_v1.csv',
        'HISTORICAL_43_PROMPT_AUDIT_v1.json',
        'HISTORICAL_43_PROMPT_AUDIT_v1.md',
        'HISTORICAL_PROMPT_CONTENT_MATRIX_v1.md',
        'HISTORICAL_PROMPT_CONTRADICTIONS_v1.md',
        'HISTORICAL_PROMPT_REUSE_REPORT_v1.md',
        'AGENT_WAVE_PLAN_v1.md',
        'AGENT_WAVE_ASSIGNMENTS_v1.csv',
        'AGENT_WAVE_ASSIGNMENTS_v1.json',
        'AGENT_WAVE_ASSIGNMENTS_v1.md',
        'AGENT_PROMPT_MIGRATION_READINESS_v1.md',
      };
      final actual = Directory(promptRoot)
          .listSync()
          .whereType<File>()
          .map((file) => file.path.split('/').last)
          .toSet();
      expect(actual, required);
      expect(
        actual.where(
          (name) => RegExp(r'AG-(PRO|DEV|ADM|TRV)-\d').hasMatch(name),
        ),
        isEmpty,
      );
      expect(actual.where((name) => name.contains('RUNTIME_CONFIG')), isEmpty);
    },
  );

  test('canonical prompt template contains metadata and all 32 sections', () {
    final template = File(
      '$promptRoot/AGENT_PROMPT_TEMPLATE_v1.md',
    ).readAsStringSync();
    for (var section = 1; section <= 32; section++) {
      expect(template, contains('## $section.'), reason: 'section $section');
    }
    for (final field in <String>[
      'prompt_schema_version',
      'agent_id',
      'canonical_name',
      'display_name',
      'surface',
      'domain',
      'family',
      'agent_type',
      'coordination_level',
      'risk_level',
      'data_access_class',
      'tool_access_class',
      'memory_scope',
      'reports_to',
      'lifecycle_status',
      'prompt_status',
      'prompt_version',
      'prompt_owner',
      'approval_status: DRAFT',
      'approved_by: NONE',
      'approved_at: NONE',
      'source_catalog_version',
      'supersedes',
    ]) {
      expect(template, contains(field), reason: field);
    }
  });

  test('prompt lifecycle, semantic versions and P0-P17 gates are explicit', () {
    final lifecycle = File(
      '$promptRoot/AGENT_PROMPT_LIFECYCLE_v1.md',
    ).readAsStringSync();
    for (final state in <String>[
      'NOT_CREATED',
      'DRAFT',
      'UNDER_REVIEW',
      'CHANGES_REQUESTED',
      'APPROVED',
      'CONFIGURED',
      'TESTED',
      'AVAILABLE',
      'SUSPENDED',
      'SUPERSEDED',
      'ARCHIVED',
    ]) {
      expect(lifecycle, contains(state));
    }
    expect(lifecycle, contains('PROMPT_CREATED = AVAILABLE'));
    final versioning = File(
      '$promptRoot/AGENT_PROMPT_VERSIONING_v1.md',
    ).readAsStringSync();
    expect(versioning, contains('MAJOR.MINOR.PATCH'));
    expect(versioning, contains('1.0.0'));
    for (final level in ['MAJOR', 'MINOR', 'PATCH']) {
      expect(versioning, contains('| $level |'));
    }
    final gates = File(
      '$promptRoot/AGENT_PROMPT_GATES_v1.md',
    ).readAsStringSync();
    for (var gate = 0; gate <= 17; gate++) {
      expect(gates, contains('| P$gate '), reason: 'P$gate');
    }
  });

  test(
    'evaluation, shared layers and change governance preserve boundaries',
    () {
      final evaluation = File(
        '$promptRoot/AGENT_EVALUATION_TEMPLATE_v1.md',
      ).readAsStringSync();
      for (final category in <String>[
        'Role adherence',
        'Scope adherence',
        'Authority boundaries',
        'Human escalation',
        'Founder escalation',
        'Tool safety',
        'Memory safety',
        'Hallucination control',
        'Cross-agent coordination',
        'Failure recovery',
      ]) {
        expect(evaluation, contains(category));
      }
      final layers = File(
        '$promptRoot/AGENT_PROMPT_SHARED_LAYERS_v1.md',
      ).readAsStringSync();
      expect(layers, contains('Copying long'));
      expect(layers, contains('never secrets'));
      final governance = File(
        '$promptRoot/AGENT_PROMPT_CHANGE_GOVERNANCE_v1.md',
      ).readAsStringSync();
      expect(governance, contains('cannot self-approve'));
      expect(governance, contains('Human Founder only'));
    },
  );

  test('ADRs and normative status preserve planning-only implementation', () {
    for (var index = 13; index <= 17; index++) {
      final prefix = 'ADR-RF${index.toString().padLeft(3, '0')}-';
      final matches = Directory('$root/decisions')
          .listSync()
          .whereType<File>()
          .where((file) => file.path.split('/').last.startsWith(prefix))
          .toList();
      expect(matches, hasLength(1), reason: prefix);
      final content = matches.single.readAsStringSync();
      expect(content, contains('Decision: APPROVED'));
      expect(content, contains('PROMPT_GOVERNANCE_DOCUMENTED'));
      expect(content, contains('HISTORICAL_PROMPTS_NOT_MIGRATED'));
      expect(content, contains('NEW_PROMPTS_NOT_CREATED'));
      expect(content, contains('RUNTIME_NOT_IMPLEMENTED'));
    }
    final status = File('$root/10_IMPLEMENTATION_STATUS.md').readAsStringSync();
    expect(status, contains('Historical audit: COMPLETED 43/43'));
    expect(status, contains('Prompt implementation: NOT_STARTED'));
    expect(status, contains('Available or active agents: 0'));
  });
}

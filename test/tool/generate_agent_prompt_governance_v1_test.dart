import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/generate_agent_prompt_governance_v1.dart';

void main() {
  late List<Map<String, Object?>> audits;
  late List<Map<String, Object?>> assignments;

  setUpAll(() {
    audits = _entries(
      '$promptGovernanceRoot/HISTORICAL_43_PROMPT_AUDIT_v1.json',
    );
    assignments = _entries(
      '$promptGovernanceRoot/AGENT_WAVE_ASSIGNMENTS_v1.json',
    );
  });

  test('historical audit contains 43 unique complete mappings', () {
    expect(audits, hasLength(43));
    expect(
      audits.map((entry) => entry['historical_file']).toSet(),
      hasLength(43),
    );
    expect(
      audits.map((entry) => entry['catalog_agent_id']).toSet(),
      hasLength(43),
    );
    for (final audit in audits) {
      expect(audit.keys.toList(), promptAuditFields);
      for (final field in promptAuditFields) {
        expect('${audit[field]}'.trim(), isNotEmpty, reason: field);
      }
      expect(
        File('$historicalPromptRoot/${audit['historical_file']}').existsSync(),
        isTrue,
      );
      expect(validMigrationDecisions, contains(audit['migration_decision']));
      expect(validPromptReuse, contains(audit['prompt_reusability']));
      expect(
        validRefoundationAlignment,
        contains(audit['refoundation_alignment']),
      );
      expect(validWaveIds, contains(audit['target_wave']));
      expect(audit['historical_prompt_status'], 'PROMPT_CREATED');
      expect(audit['review_status'], 'AUDITED_PLANNING_ONLY');
    }
  });

  test(
    'migration decisions remain exactly 40 updates and 3 reclassifications',
    () {
      expect(_count(audits, 'migration_decision', 'MIGRATE_AND_UPDATE'), 40);
      expect(_count(audits, 'migration_decision', 'RECLASSIFY'), 3);
      for (final decision in <String>[
        'MIGRATE_UNCHANGED',
        'MERGE',
        'ARCHIVE',
        'REQUIRES_REVIEW',
      ]) {
        expect(_count(audits, 'migration_decision', decision), 0);
      }
      expect(_count(audits, 'prompt_reusability', 'MOSTLY_REUSABLE'), 40);
      expect(_count(audits, 'prompt_reusability', 'PARTIALLY_REUSABLE'), 3);
      expect(
        _count(audits, 'refoundation_alignment', 'REQUIRES_MAJOR_UPDATE'),
        40,
      );
      expect(
        _count(audits, 'refoundation_alignment', 'REQUIRES_RECLASSIFICATION'),
        3,
      );
    },
  );

  test('all 3000 catalog agents have one valid wave assignment', () {
    expect(assignments, hasLength(3000));
    expect(
      assignments.map((entry) => entry['agent_id']).toSet(),
      hasLength(3000),
    );
    final catalogIds = readAgentCatalog()
        .map((entry) => entry['agent_id'])
        .toSet();
    expect(assignments.map((entry) => entry['agent_id']).toSet(), catalogIds);
    for (final assignment in assignments) {
      expect(assignment.keys.toList(), waveAssignmentFields);
      expect(validWaveIds, contains(assignment['wave_id']));
      expect(
        assignment['runtime_package'],
        'SEPARATE_RUNTIME_PACKAGE_NOT_AUTHORIZED',
      );
    }
    for (final audit in audits) {
      final assignment = assignments.singleWhere(
        (entry) => entry['agent_id'] == audit['catalog_agent_id'],
      );
      expect(assignment['wave_id'], audit['target_wave']);
      expect(assignment['historical_prompt'], audit['historical_file']);
    }
  });

  test('Wave 1 contains exactly Nexus Stasis Rector and Gerendi', () {
    final waveOne = assignments
        .where((entry) => entry['wave_id'] == 'WAVE_1')
        .map((entry) => entry['agent_id'])
        .toSet();
    expect(waveOne, {
      'AG-TRV-0001',
      'AG-PRO-0001',
      'AG-DEV-0001',
      'AG-ADM-0001',
    });
    expect(_count(assignments, 'wave_id', 'WAVE_2'), 18);
    expect(_count(assignments, 'wave_id', 'WAVE_3'), 40);
    expect(_count(assignments, 'wave_id', 'WAVE_4'), 50);
    expect(_count(assignments, 'wave_id', 'WAVE_5'), 60);
    expect(_count(assignments, 'wave_id', 'WAVE_6'), 50);
    expect(_count(assignments, 'wave_id', 'WAVE_7_PLUS'), 2778);
  });

  test('audit and wave CSV files have exact JSON parity', () {
    _expectCsvParity(
      '$promptGovernanceRoot/HISTORICAL_43_PROMPT_AUDIT_v1.csv',
      promptAuditFields,
      audits,
    );
    _expectCsvParity(
      '$promptGovernanceRoot/AGENT_WAVE_ASSIGNMENTS_v1.csv',
      waveAssignmentFields,
      assignments,
    );
  });

  test('regeneration is deterministic and matches all generated artifacts', () {
    final first = buildAgentPromptGovernanceArtifacts();
    final second = buildAgentPromptGovernanceArtifacts();
    expect(first, second);
    expect(first, hasLength(11));
    for (final artifact in first.entries) {
      expect(File(artifact.key).readAsStringSync(), artifact.value);
    }
  });
}

List<Map<String, Object?>> _entries(String path) {
  final root =
      jsonDecode(File(path).readAsStringSync()) as Map<String, Object?>;
  return (root['entries']! as List<Object?>).cast<Map<String, Object?>>();
}

int _count(List<Map<String, Object?>> records, String field, String value) =>
    records.where((entry) => entry[field] == value).length;

void _expectCsvParity(
  String path,
  List<String> fields,
  List<Map<String, Object?>> records,
) {
  final lines = File(path).readAsLinesSync();
  expect(lines, hasLength(records.length + 1));
  expect(_parseCsvLine(lines.first), fields);
  for (var index = 0; index < records.length; index++) {
    final cells = _parseCsvLine(lines[index + 1]);
    expect(cells, hasLength(fields.length));
    for (var fieldIndex = 0; fieldIndex < fields.length; fieldIndex++) {
      expect(
        cells[fieldIndex],
        '${records[index][fields[fieldIndex]]}',
        reason: '${records[index][fields.first]}:${fields[fieldIndex]}',
      );
    }
  }
}

List<String> _parseCsvLine(String line) {
  final cells = <String>[];
  final current = StringBuffer();
  var quoted = false;
  for (var index = 0; index < line.length; index++) {
    final character = line[index];
    if (character == '"') {
      if (quoted && index + 1 < line.length && line[index + 1] == '"') {
        current.write('"');
        index++;
      } else {
        quoted = !quoted;
      }
    } else if (character == ',' && !quoted) {
      cells.add(current.toString());
      current.clear();
    } else {
      current.write(character);
    }
  }
  cells.add(current.toString());
  return cells;
}

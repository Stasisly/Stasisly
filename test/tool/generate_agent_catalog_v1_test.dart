import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/generate_agent_catalog_v1.dart';

void main() {
  late List<Map<String, Object?>> entries;

  setUpAll(() {
    final root =
        jsonDecode(
              File(
                '$catalogRoot/AGENT_CATALOG_MASTER_v1.json',
              ).readAsStringSync(),
            )
            as Map<String, Object?>;
    entries = (root['entries']! as List<Object?>).cast<Map<String, Object?>>();
  });

  test('catalog has exact surface allocations and stable ID ranges', () {
    expect(entries, hasLength(3000));
    expect(_count(entries, 'PRODUCT'), 1050);
    expect(_count(entries, 'DEVELOPMENT'), 1200);
    expect(_count(entries, 'ADMINISTRATION'), 700);
    expect(_count(entries, 'TRANSVERSAL'), 50);

    final ids = entries.map((entry) => entry['agent_id']).toSet();
    expect(ids, hasLength(3000));
    for (final range in <(String, int)>[
      ('PRO', 1050),
      ('DEV', 1200),
      ('ADM', 700),
      ('TRV', 50),
    ]) {
      for (var index = 1; index <= range.$2; index++) {
        expect(
          ids,
          contains('AG-${range.$1}-${index.toString().padLeft(4, '0')}'),
        );
      }
    }
  });

  test('names, missions, fields and enums satisfy AgentCatalogEntryV1', () {
    expect(
      entries.map((entry) => entry['canonical_name']).toSet(),
      hasLength(3000),
    );
    expect(
      entries.map((entry) => entry['display_name']).toSet(),
      hasLength(3000),
    );
    expect(
      entries.map((entry) => entry['short_mission']).toSet(),
      hasLength(3000),
    );

    for (final entry in entries) {
      expect(
        entry.keys.toList(),
        catalogFields,
        reason: '${entry['agent_id']}',
      );
      for (final field in catalogFields) {
        expect(entry.containsKey(field), isTrue, reason: field);
      }
      expect(validSurfaces, contains(entry['surface']));
      expect(validAgentTypes, contains(entry['agent_type']));
      expect(validCoordinationLevels, contains(entry['coordination_level']));
      expect(validActivationModes, contains(entry['activation_mode']));
      expect(validRiskLevels, contains(entry['risk_level']));
      expect(validDataAccessClasses, contains(entry['data_access_class']));
      expect(validToolAccessClasses, contains(entry['tool_access_class']));
      expect(validMemoryScopes, contains(entry['memory_scope']));
      expect(validLifecycleStates, contains(entry['lifecycle_status']));
      expect(validAvailabilityStates, contains(entry['availability']));
      expect(validPromptStatuses, contains(entry['prompt_status']));
      expect(
        validImplementationStatuses,
        contains(entry['implementation_status']),
      );
      final words = (entry['short_mission']! as String)
          .split(RegExp(r'\s+'))
          .where((word) => word.isNotEmpty)
          .length;
      expect(words, inInclusiveRange(10, 35));
      expect(entry['display_name'], isNot(matches(RegExp(r'^Agent \d+$'))));
    }
  });

  test('principal coordinators and relationship graph are exact', () {
    final byId = {
      for (final entry in entries) entry['agent_id']! as String: entry,
    };
    for (final expected in <String, (String, String, String, String)>{
      'AG-PRO-0001': ('stasis', 'Stasis', 'PRODUCT', 'SURFACE_COORDINATOR'),
      'AG-DEV-0001': ('rector', 'Rector', 'DEVELOPMENT', 'SURFACE_COORDINATOR'),
      'AG-ADM-0001': (
        'gerendi',
        'Gerendi',
        'ADMINISTRATION',
        'SURFACE_COORDINATOR',
      ),
      'AG-TRV-0001': ('nexus', 'Nexus', 'TRANSVERSAL', 'GLOBAL_COORDINATOR'),
    }.entries) {
      final entry = byId[expected.key]!;
      expect(entry['canonical_name'], expected.value.$1);
      expect(entry['display_name'], expected.value.$2);
      expect(entry['surface'], expected.value.$3);
      expect(entry['agent_type'], expected.value.$4);
    }

    for (final entry in entries) {
      final id = entry['agent_id']! as String;
      final parent = entry['reports_to']! as String;
      expect(parent, isNot(id));
      if (parent == 'FOUNDER') {
        expect(id, 'AG-TRV-0001');
      } else if (parent.isNotEmpty) {
        expect(byId, contains(parent));
        final crossesSurface = byId[parent]!['surface'] != entry['surface'];
        if (crossesSurface) {
          expect(parent, 'AG-TRV-0001');
          expect(entry['agent_type'], 'SURFACE_COORDINATOR');
        }
      }
      for (final child in (entry['coordinates']! as List<Object?>)) {
        expect(byId, contains(child));
        expect(byId[child]!['reports_to'], id);
      }
      final visited = <String>{};
      var cursor = id;
      while (cursor.isNotEmpty && cursor != 'FOUNDER') {
        expect(visited.add(cursor), isTrue, reason: 'cycle from $id');
        cursor = byId[cursor]!['reports_to']! as String;
      }
    }
  });

  test('new and historical states preserve the approved boundary', () {
    final historical = entries
        .where((entry) => entry['historical_mapping'] != 'NONE')
        .toList();
    final canonical = entries
        .where((entry) => entry['historical_mapping'] == 'NONE')
        .toList();
    final documentedHistorical = historical
        .where(
          (entry) => approvedDocumentaryPromptIds.contains(entry['agent_id']),
        )
        .toList();
    final pendingHistorical = historical
        .where(
          (entry) => !approvedDocumentaryPromptIds.contains(entry['agent_id']),
        )
        .toList();
    final approvedCanonical = canonical
        .where(
          (entry) => approvedDocumentaryPromptIds.contains(entry['agent_id']),
        )
        .toList();
    final cataloged = canonical
        .where(
          (entry) => !approvedDocumentaryPromptIds.contains(entry['agent_id']),
        )
        .toList();
    expect(historical, hasLength(43));
    expect(documentedHistorical, hasLength(28));
    expect(pendingHistorical, hasLength(15));
    expect(approvedCanonical, hasLength(84));
    expect(cataloged, hasLength(2873));
    for (final entry in pendingHistorical) {
      expect(entry['prompt_status'], 'PROMPT_CREATED');
      expect(entry['lifecycle_status'], 'PROMPT_CREATED');
      expect(entry['implementation_status'], 'NOT_IMPLEMENTED');
      expect(entry['availability'], 'NOT_AVAILABLE');
    }
    for (final entry in [...documentedHistorical, ...approvedCanonical]) {
      expect(entry['prompt_status'], 'PROMPT_CREATED');
      expect(entry['lifecycle_status'], 'PROMPT_CREATED');
      expect(entry['implementation_status'], 'DOCUMENTED_ONLY');
      expect(entry['availability'], 'NOT_AVAILABLE');
    }
    for (final entry in cataloged) {
      expect(entry['prompt_status'], 'NOT_CREATED');
      expect(entry['lifecycle_status'], 'CATALOGED');
      expect(entry['implementation_status'], 'NOT_IMPLEMENTED');
      expect(entry['availability'], 'NOT_AVAILABLE');
    }

    final crosswalk = File(
      '$catalogRoot/HISTORICAL_43_AGENT_CROSSWALK_v1.md',
    ).readAsStringSync();
    expect(
      RegExp(r'^\| `\d', multiLine: true).allMatches(crosswalk),
      hasLength(43),
    );
    expect(
      RegExp(r'\| MIGRATE_AND_UPDATE \|').allMatches(crosswalk),
      hasLength(40),
    );
    expect(RegExp(r'\| RECLASSIFY \|').allMatches(crosswalk), hasLength(3));
    expect(crosswalk, contains('| historical_commit_or_source |'));
    expect(crosswalk, contains('| new_domain |'));
  });

  test('CSV and JSON canonical views have field-by-field parity', () {
    final lines = File(
      '$catalogRoot/AGENT_CATALOG_MASTER_v1.csv',
    ).readAsLinesSync();
    expect(lines, hasLength(3001));
    expect(_parseCsvLine(lines.first), catalogFields);
    for (var index = 0; index < entries.length; index++) {
      final cells = _parseCsvLine(lines[index + 1]);
      expect(cells, hasLength(catalogFields.length));
      for (
        var fieldIndex = 0;
        fieldIndex < catalogFields.length;
        fieldIndex++
      ) {
        final field = catalogFields[fieldIndex];
        final value = entries[index][field];
        final expected = value is List<Object?> ? value.join(';') : '$value';
        expect(
          cells[fieldIndex],
          expected,
          reason: '${entries[index]['agent_id']}:$field',
        );
      }
    }
  });

  test('regeneration is deterministic and matches versioned artifacts', () {
    final first = generateAgentCatalogArtifacts();
    final second = generateAgentCatalogArtifacts();
    expect(first, second);
    expect(first, hasLength(13));
    for (final artifact in first.entries) {
      expect(File(artifact.key).readAsStringSync(), artifact.value);
    }
  });
}

int _count(List<Map<String, Object?>> entries, String surface) =>
    entries.where((entry) => entry['surface'] == surface).length;

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

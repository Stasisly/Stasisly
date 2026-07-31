import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

const root = 'docs/stasisly_refoundation';

void main() {
  test('required Re-foundation structure is complete', () {
    const required = <String>{
      '00_MASTER_REFOUNDATION.md',
      '01_PRODUCT_ARCHITECTURE.md',
      '02_SURFACES_ARCHITECTURE.md',
      '03_GLOBAL_COORDINATION.md',
      '04_AGENT_CATALOG_ARCHITECTURE.md',
      '05_DATA_ARCHITECTURE.md',
      '06_ENVIRONMENTS.md',
      '07_SECURITY_PRIVACY_AND_FOUNDER_ACCESS.md',
      '08_LEGACY_MIGRATION_AND_ARCHIVE.md',
      '09_MASTER_ROADMAP.md',
      '10_IMPLEMENTATION_STATUS.md',
      '11_GLOSSARY.md',
      'inventories/DOCUMENT_INVENTORY.md',
      'inventories/HISTORICAL_43_AGENTS_INVENTORY.md',
      'inventories/LEGACY_TECHNICAL_ASSETS_INVENTORY.md',
      'inventories/CURRENT_DECISIONS_INVENTORY.md',
      'status/AGENT_CATALOG_TAXONOMY_v1.md',
      'status/AGENT_CATALOG_ALLOCATION_v1.md',
      'status/AGENT_LIFECYCLE_v1.md',
      'status/HISTORICAL_AGENT_CROSSWALK_TEMPLATE.md',
    };
    for (final path in required) {
      expect(File('$root/$path').existsSync(), isTrue, reason: path);
    }
    for (var index = 1; index <= 8; index++) {
      final prefix = 'ADR-RF00$index-';
      final matches = Directory('$root/decisions')
          .listSync()
          .whereType<File>()
          .where((file) => file.path.split('/').last.startsWith(prefix));
      expect(matches.length, 1, reason: prefix);
    }
  });

  test('master establishes the exact source-of-truth hierarchy', () {
    final master = File('$root/00_MASTER_REFOUNDATION.md').readAsStringSync();
    for (final value in <String>[
      'Approved Re-foundation ADRs',
      'This master document',
      'Re-foundation architecture documents',
      'Master roadmap',
      'Implementation status',
      'Historical archive and legacy evidence',
    ]) {
      expect(master, contains(value));
    }
    expect(master, contains('global design, proportional implementation'));
    expect(master, contains('DISCOVERY_LEGACY'));
    expect(master, contains('NON_NORMATIVE'));

    final repositoryReadme = File('README.md').readAsStringSync();
    expect(repositoryReadme, contains('docs/stasisly_refoundation/'));
    expect(repositoryReadme, contains('fuente normativa'));
    expect(repositoryReadme, contains('evidencia Foundation preservada'));
  });

  test('all 43 historical prompts are preserved and crosswalked exactly', () {
    final source =
        Directory('docs/archive/discovery/stasisly_definition/agents')
            .listSync()
            .whereType<File>()
            .where((file) => file.path.endsWith('.md'))
            .toList()
          ..sort((left, right) => left.path.compareTo(right.path));
    expect(source.length, 43);

    final inventory = File(
      '$root/inventories/HISTORICAL_43_AGENTS_INVENTORY.md',
    ).readAsStringSync();
    final rows = RegExp(r'^\| \d+ \|', multiLine: true).allMatches(inventory);
    expect(rows.length, 43);
    for (final file in source) {
      final heading = RegExp(
        r'^# (.+)$',
        multiLine: true,
      ).firstMatch(file.readAsStringSync())!.group(1)!;
      expect(inventory, contains('`${file.path.split('/').last}`'));
      expect(inventory, contains('| $heading |'));
    }
    expect(RegExp(r'\| NOT_FOUND \|').hasMatch(inventory), isFalse);
    expect(RegExp(r'\| DUPLICATE \|').hasMatch(inventory), isFalse);
  });

  test('agent allocation totals 3000 without implying activation', () {
    final allocation = File(
      '$root/status/AGENT_CATALOG_ALLOCATION_v1.md',
    ).readAsStringSync();
    for (final row in <String>[
      '| Product | 1,050 |',
      '| Development | 1,200 |',
      '| Administration | 700 |',
      '| Transversal | 50 |',
      '| **Total** | **3,000** |',
      'MINIMUM_SUFFICIENT_TEAM',
    ]) {
      expect(allocation, contains(row));
    }
  });

  test('current status never promotes planned architecture to operational', () {
    final status = File('$root/10_IMPLEMENTATION_STATUS.md').readAsStringSync();
    expect(status, contains('Clean Supabase Development'));
    expect(status, contains('| no | no | no | no | no | separate package |'));
    expect(status, contains('Horizontal sharding'));
    expect(status, contains('Stasis Engine'));
    expect(status, contains('Documentation never upgrades'));
  });

  test('internal Markdown links resolve', () {
    final files = Directory(root)
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.md'));
    final link = RegExp(r'\[[^\]]+\]\(([^)]+)\)');
    for (final file in files) {
      for (final match in link.allMatches(file.readAsStringSync())) {
        final target = match.group(1)!;
        if (target.startsWith('http') || target.startsWith('#')) continue;
        final relative = target.split('#').first;
        final resolved = File('${file.parent.path}/$relative').absolute;
        expect(resolved.existsSync(), isTrue, reason: '${file.path}: $target');
      }
    }
  });

  test('document inventory covers every documentary file', () {
    final inventory = File(
      '$root/inventories/DOCUMENT_INVENTORY.md',
    ).readAsStringSync();
    final files =
        Directory('docs')
            .listSync(recursive: true)
            .whereType<File>()
            .where((file) => !file.path.endsWith('.DS_Store'))
            .toList()
          ..add(File('README.md'));
    final rows = RegExp(
      r'^\| `(docs/|README\.md)',
      multiLine: true,
    ).allMatches(inventory);
    expect(rows.length, files.length);
    for (final file in files) {
      expect(inventory, contains('`${file.path}`'));
    }
    expect(inventory, contains('Files moved: 0'));
    expect(inventory, contains('Files removed: 0'));
  });

  test('legacy assets and remote operations remain explicitly preserved', () {
    final legacy = File(
      '$root/inventories/LEGACY_TECHNICAL_ASSETS_INVENTORY.md',
    ).readAsStringSync();
    expect(legacy, contains('| Supabase migrations | 12 |'));
    expect(legacy, contains('| Edge Functions | 8 |'));
    expect(legacy, contains('| Foundation ADRs | 37 |'));
    expect(legacy, contains('| Discovery ADRs | 12 |'));

    final environments = File('$root/06_ENVIRONMENTS.md').readAsStringSync();
    expect(environments, contains('planned and not created'));
    expect(environments, contains('No remote action'));
  });
}

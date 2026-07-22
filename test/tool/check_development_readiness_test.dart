import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/check_development_readiness.dart';
import '../../tool/development_evidence_contracts.dart';

void main() {
  test('repository Development readiness preflight passes without network', () {
    expect(DevelopmentReadinessChecker(Directory.current).check(), isEmpty);
  });

  group('DevelopmentReadinessChecker', () {
    late Directory root;

    setUp(() {
      root = Directory.systemTemp.createTempSync('stasisly-dev-readiness-');
      _createValidFixture(root);
    });

    tearDown(() {
      root.deleteSync(recursive: true);
    });

    test('accepts complete unapproved local preparation', () {
      expect(DevelopmentReadinessChecker(root).check(), isEmpty);
    });

    test('rejects manifest approval without separate evidence', () {
      _mutateManifest(root, (manifest) => manifest['approval'] = 'APPROVED');

      expect(
        _kinds(root),
        contains(DevelopmentReadinessFindingKind.approvedManifest),
      );
    });

    test('rejects assigned project identifier', () {
      _mutateManifest(
        root,
        (manifest) => manifest['projectIdentifier'] = 'assigned-value',
      );

      expect(
        _kinds(root),
        contains(DevelopmentReadinessFindingKind.assignedProject),
      );
    });

    test('rejects incomplete migration inventory', () {
      File(
        '${root.path}/supabase/migrations/00012_add_message_author_provenance_and_visibility.sql',
      ).deleteSync();

      expect(
        _kinds(root),
        contains(DevelopmentReadinessFindingKind.incompleteMigrationInventory),
      );
    });

    test('rejects incomplete function inventory', () {
      Directory(
        '${root.path}/supabase/functions/send-user-message',
      ).deleteSync(recursive: true);

      expect(
        _kinds(root),
        contains(DevelopmentReadinessFindingKind.incompleteFunctionInventory),
      );
    });

    test('rejects missing public configuration names', () {
      final example = File('${root.path}/.env.example');
      example.writeAsStringSync(
        example.readAsStringSync().replaceFirst(
          'BACKEND_TARGET_ENVIRONMENT=unassigned\n',
          '',
        ),
      );

      expect(
        _kinds(root),
        contains(
          DevelopmentReadinessFindingKind.incompleteConfigurationInventory,
        ),
      );
    });

    test('rejects a secret-like value without reporting the value', () {
      const value = 'sensitive-fixture-never-report';
      File('${root.path}/.env.example').writeAsStringSync(
        '${File('${root.path}/.env.example').readAsStringSync()}'
        'SYNTHETIC_ACCESS_TOKEN=$value\n',
      );

      final findings = DevelopmentReadinessChecker(root).check();
      expect(
        findings.map((finding) => finding.kind),
        contains(DevelopmentReadinessFindingKind.secretValueDetected),
      );
      expect(
        findings.every((finding) => !finding.safeDescription.contains(value)),
        isTrue,
      );
    });

    test('rejects linked CLI metadata through integrated remote guard', () {
      final marker = File('${root.path}/supabase/.temp/project-ref');
      marker.parent.createSync(recursive: true);
      marker.writeAsStringSync('opaque-fixture');

      expect(
        _kinds(root),
        contains(DevelopmentReadinessFindingKind.remoteContext),
      );
    });

    test('rejects server-only credential configuration in Flutter', () {
      _write(
        root,
        'lib/core/config/unsafe.dart',
        "const forbiddenName = 'SUPABASE_SERVICE_ROLE_KEY';\n",
      );

      expect(
        _kinds(root),
        contains(DevelopmentReadinessFindingKind.serverCredentialInFlutter),
      );
    });

    test('preflight source has no network or process execution API', () {
      final source = File(
        'tool/check_development_readiness.dart',
      ).readAsStringSync();

      expect(source, isNot(contains('HttpClient')));
      expect(source, isNot(contains('Process.run')));
      expect(source, isNot(contains('Process.start')));
      expect(source, isNot(contains('Socket.connect')));
    });
  });
}

Set<DevelopmentReadinessFindingKind> _kinds(Directory root) =>
    DevelopmentReadinessChecker(
      root,
    ).check().map((finding) => finding.kind).toSet();

void _createValidFixture(Directory root) {
  for (final name in DevelopmentReadinessChecker.expectedMigrations) {
    _write(root, 'supabase/migrations/$name', '-- synthetic fixture\n');
  }
  for (final name in DevelopmentReadinessChecker.expectedFunctions) {
    _write(root, 'supabase/functions/$name/index.ts', '// synthetic fixture\n');
  }
  _write(root, '.env.example', File('.env.example').readAsStringSync());
  _write(
    root,
    DevelopmentReadinessChecker.manifestPath,
    File(DevelopmentReadinessChecker.manifestPath).readAsStringSync(),
  );
  _write(
    root,
    'lib/features/specialists/domain/repositories/'
        'selectable_specialists_repository.dart',
    'abstract interface class SelectableSpecialistCatalog {}\n',
  );
  _write(
    root,
    'supabase/tests/'
        'foundation_019c_development_fixture_lifecycle_http_test.sh',
    'run_cycle 1\nrun_cycle 2\n',
  );
  _copyDirectory(
    Directory('docs/stasisly_foundation/development/schemas'),
    Directory('${root.path}/docs/stasisly_foundation/development/schemas'),
  );
  _copyDirectory(
    Directory('docs/stasisly_foundation/development/evidence'),
    Directory('${root.path}/docs/stasisly_foundation/development/evidence'),
  );
  _write(
    root,
    DevelopmentEvidenceContractValidator.fixtureManifestPath,
    File(
      DevelopmentEvidenceContractValidator.fixtureManifestPath,
    ).readAsStringSync(),
  );
}

void _copyDirectory(Directory source, Directory destination) {
  for (final entity in source.listSync(recursive: true)) {
    if (entity is! File) continue;
    final relativePath = entity.path.substring(source.path.length + 1);
    final target = File('${destination.path}/$relativePath');
    target.parent.createSync(recursive: true);
    target.writeAsStringSync(entity.readAsStringSync());
  }
}

void _mutateManifest(
  Directory root,
  void Function(Map<String, Object?> manifest) mutate,
) {
  final file = File('${root.path}/${DevelopmentReadinessChecker.manifestPath}');
  final manifest = jsonDecode(file.readAsStringSync()) as Map<String, Object?>;
  mutate(manifest);
  file.writeAsStringSync(const JsonEncoder.withIndent('  ').convert(manifest));
}

void _write(Directory root, String path, String content) {
  final file = File('${root.path}/$path');
  file.parent.createSync(recursive: true);
  file.writeAsStringSync(content);
}

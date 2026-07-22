import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/development_evidence_contracts.dart';

void main() {
  test('versioned Development evidence and fixture contracts are safe', () {
    expect(
      DevelopmentEvidenceContractValidator(Directory.current).validate(),
      isEmpty,
    );
  });

  test('validator rejects secret-like and externally executed evidence', () {
    final root = Directory.systemTemp.createTempSync('evidence-contract-test-');
    addTearDown(() => root.deleteSync(recursive: true));
    _copyContracts(root);
    File(
      '${root.path}/docs/stasisly_foundation/development/evidence/'
      'deployment_evidence.json',
    ).writeAsStringSync('''
{
  "environment":"development",
  "projectIdentifier":"UNASSIGNED",
  "commitSha":"UNASSIGNED",
  "operatorReference":"UNASSIGNED",
  "founderApprovalReference":"NOT_GRANTED",
  "migrationInventoryVersion":"v1",
  "functionInventoryVersion":"v1",
  "configurationInventoryVersion":"v1",
  "testResultSummary":"unsafe",
  "timestampStatus":"NOW",
  "rollbackReference":"ADR",
  "resultStatus":"EXECUTED",
  "accessToken":"eyJ.bad.value"
}
''');

    final findings = DevelopmentEvidenceContractValidator(root).validate();
    expect(findings, isNotEmpty);
    expect(findings.join(' '), contains('external execution'));
    expect(findings.join(' '), contains('Forbidden evidence field'));
  });

  test('validator rejects a clean pass without successful cleanup', () {
    final root = Directory.systemTemp.createTempSync('evidence-cleanup-test-');
    addTearDown(() => root.deleteSync(recursive: true));
    _copyContracts(root);
    final file = File(
      '${root.path}/docs/stasisly_foundation/development/evidence/'
      'smoke_test_result.json',
    );
    file.writeAsStringSync(
      file
          .readAsStringSync()
          .replaceFirst('"NOT_RUN"', '"PASSED_CLEAN"')
          .replaceFirst('"NOT_STARTED"', '"PASSED"'),
    );

    expect(
      DevelopmentEvidenceContractValidator(root).validate().join(' '),
      contains('Smoke pass lacks successful cleanup'),
    );
  });
}

void _copyContracts(Directory root) {
  for (final relative in [
    DevelopmentEvidenceContractValidator.schemaDirectory,
    DevelopmentEvidenceContractValidator.evidenceDirectory,
  ]) {
    final source = Directory('${Directory.current.path}/$relative');
    for (final file in source.listSync().whereType<File>()) {
      final target = File(
        '${root.path}/$relative/${file.uri.pathSegments.last}',
      );
      target.parent.createSync(recursive: true);
      file.copySync(target.path);
    }
  }
  final fixtureSource = File(
    '${Directory.current.path}/'
    '${DevelopmentEvidenceContractValidator.fixtureManifestPath}',
  );
  final fixtureTarget = File(
    '${root.path}/${DevelopmentEvidenceContractValidator.fixtureManifestPath}',
  );
  fixtureTarget.parent.createSync(recursive: true);
  fixtureSource.copySync(fixtureTarget.path);
}

import 'dart:convert';
import 'dart:io';

const developmentEvidenceStates = <String>{
  'NOT_STARTED',
  'PREPARED',
  'AUTHORIZED',
  'EXECUTED',
  'PASSED',
  'FAILED',
  'ROLLED_BACK',
};

final class DevelopmentEvidenceContractValidator {
  const DevelopmentEvidenceContractValidator(this.root);

  final Directory root;

  static const schemaDirectory = 'docs/stasisly_foundation/development/schemas';
  static const evidenceDirectory =
      'docs/stasisly_foundation/development/evidence';
  static const fixtureManifestPath =
      'docs/stasisly_foundation/development/development_fixture_manifest.json';

  static const schemaNames = <String>{
    'pre_deployment_evidence.schema.json',
    'deployment_evidence.schema.json',
    'post_deployment_smoke_evidence.schema.json',
    'rollback_evidence.schema.json',
    'smoke_test_result.schema.json',
  };
  static const evidenceNames = <String>{
    'pre_deployment_evidence.json',
    'deployment_evidence.json',
    'post_deployment_smoke_evidence.json',
    'rollback_evidence.json',
    'smoke_test_result.json',
  };

  List<String> validate() {
    final findings = <String>[];
    for (final name in schemaNames) {
      final schema = _readMap('$schemaDirectory/$name', findings);
      if (schema == null) continue;
      if (schema['type'] != 'object' ||
          schema['additionalProperties'] != false ||
          schema['required'] is! List ||
          schema['properties'] is! Map) {
        findings.add('Invalid schema contract: $name');
      }
      final properties = schema['properties'];
      if (name != 'smoke_test_result.schema.json' && properties is Map) {
        final result = properties['resultStatus'];
        if (result is! Map ||
            result['enum'] is! List ||
            !_sameStrings(
              result['enum'] as List<Object?>,
              developmentEvidenceStates,
            )) {
          findings.add('Evidence state enum is not closed: $name');
        }
      }
    }

    for (final name in evidenceNames) {
      final artifact = _readMap('$evidenceDirectory/$name', findings);
      if (artifact == null) continue;
      _validateArtifact(name, artifact, findings);
    }
    _validateFixture(findings);
    return findings;
  }

  void _validateArtifact(
    String name,
    Map<String, Object?> artifact,
    List<String> findings,
  ) {
    final isSmoke = name == 'smoke_test_result.json';
    final status = artifact[isSmoke ? 'status' : 'resultStatus'];
    if (status is! String || !developmentEvidenceStates.contains(status)) {
      findings.add('Unknown evidence state: $name');
    }
    if (!isSmoke) {
      if (artifact['environment'] != 'development') {
        findings.add('Evidence environment is not development: $name');
      }
      for (final field in const [
        'projectIdentifier',
        'commitSha',
        'operatorReference',
        'founderApprovalReference',
        'migrationInventoryVersion',
        'functionInventoryVersion',
        'configurationInventoryVersion',
        'testResultSummary',
        'timestampStatus',
        'rollbackReference',
      ]) {
        final fieldValue = artifact[field];
        if (fieldValue is! String || fieldValue.trim().isEmpty) {
          findings.add('Missing evidence field $field: $name');
        }
      }
      if (artifact['projectIdentifier'] == 'UNASSIGNED' &&
          status != 'NOT_STARTED' &&
          status != 'PREPARED') {
        findings.add('Unassigned evidence claims external execution: $name');
      }
    } else {
      const allowed = {
        'testId',
        'status',
        'safeResultCategory',
        'durationBucket',
        'cleanupStatus',
        'evidenceReference',
      };
      if (!_sameStrings(artifact.keys, allowed)) {
        findings.add('Smoke result exposes unapproved fields: $name');
      }
    }
    _scanSafeValues(artifact, name, findings);
  }

  void _validateFixture(List<String> findings) {
    final fixture = _readMap(fixtureManifestPath, findings);
    if (fixture == null) return;
    final cleanup = fixture['cleanupContract'];
    if (fixture['environment'] != 'development' ||
        fixture['remoteExecution'] != 'NOT_EXECUTED' ||
        fixture['namespace'] != 'foundation_019c_fixture' ||
        fixture['maximumRetainedDuration'] !=
            'UNTIL_BOUNDED_RUN_CLEANUP_COMPLETES' ||
        cleanup is! Map ||
        cleanup['localOnly'] != true ||
        cleanup['exactNamespaceRequired'] != true ||
        cleanup['wildcardsAllowed'] != false ||
        cleanup['idempotent'] != true) {
      findings.add('Development fixture lifecycle is not fail-closed.');
    }
    _scanSafeValues(fixture, fixtureManifestPath, findings);
  }

  Map<String, Object?>? _readMap(String relative, List<String> findings) {
    final file = File('${root.path}${Platform.pathSeparator}$relative');
    if (!file.existsSync()) {
      findings.add('Missing contract: $relative');
      return null;
    }
    try {
      final value = jsonDecode(file.readAsStringSync());
      if (value is Map<String, Object?>) return value;
    } on FormatException {
      // Report the same safe finding below.
    }
    findings.add('Invalid JSON contract: $relative');
    return null;
  }

  void _scanSafeValues(Object? value, String path, List<String> findings) {
    if (value is Map) {
      for (final entry in value.entries) {
        final key = entry.key.toString().toLowerCase();
        if (key.contains('token') ||
            key.contains('secret') ||
            key.contains('password') ||
            key.contains('messagecontent') ||
            key == 'email' ||
            key == 'rawconversationid' ||
            key == 'rawuserid') {
          findings.add('Forbidden evidence field: $path');
        }
        _scanSafeValues(entry.value, path, findings);
      }
      return;
    }
    if (value is List) {
      for (final item in value) {
        _scanSafeValues(item, path, findings);
      }
      return;
    }
    if (value is String) {
      final lower = value.toLowerCase();
      if (lower.contains('http://') ||
          lower.contains('https://') ||
          lower.contains('service_role') ||
          RegExp(
            r'eyj[a-z0-9_-]+\.[a-z0-9_-]+\.[a-z0-9_-]+',
            caseSensitive: false,
          ).hasMatch(value)) {
        findings.add('Secret or remote material detected: $path');
      }
    }
  }

  bool _sameStrings(Iterable<Object?>? values, Set<String> expected) {
    if (values == null) return false;
    final actual = values.whereType<String>().toSet();
    return actual.length == expected.length && actual.containsAll(expected);
  }
}

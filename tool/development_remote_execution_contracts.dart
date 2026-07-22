import 'dart:convert';
import 'dart:io';

enum DevelopmentRemotePreparationStatus {
  safeForLocalPreparation,
  readyForReauthorization,
  blockedMissingCorsOrigin,
  blockedFixtureContract,
  blockedCleanupContract,
  blockedSkipGate,
  blockedRemoteContext,
  blockedSecretExposure,
}

enum RemoteLifecycleClassification {
  passedClean,
  failedClean,
  failedDirtyBlocking,
}

final class DevelopmentCorsOriginValidator {
  const DevelopmentCorsOriginValidator();

  bool isValid(String value) {
    final normalized = value.trim();
    if (normalized.isEmpty ||
        normalized.contains('*') ||
        normalized.contains('[') ||
        normalized.toLowerCase().contains('unassigned') ||
        normalized.toLowerCase().contains('placeholder')) {
      return false;
    }
    final uri = Uri.tryParse(normalized);
    if (uri == null ||
        uri.scheme != 'https' ||
        uri.host.isEmpty ||
        uri.userInfo.isNotEmpty ||
        uri.hasQuery ||
        uri.hasFragment ||
        (uri.path.isNotEmpty && uri.path != '/')) {
      return false;
    }
    final labels = uri.host.toLowerCase().split('.');
    if (labels.contains('localhost') ||
        labels.contains('staging') ||
        labels.contains('production') ||
        labels.contains('prod')) {
      return false;
    }
    return true;
  }
}

final class DevelopmentRemoteGateInput {
  const DevelopmentRemoteGateInput({
    required this.environment,
    required this.remoteContextAuthorizationModeActive,
    required this.exactProjectConfirmed,
    required this.operatorConfirmed,
    required this.founderAuthorizationReferencePresent,
    required this.authorizedCommitMatchesHead,
    required this.deploymentManifestApprovedAtRuntime,
    required this.fixtureManifestApprovedAtRuntime,
    required this.cleanupPreflightPassed,
    required this.corsOrigin,
    required this.requiredConfigurationComplete,
    required this.requiredSecretNamesAcknowledged,
  });

  factory DevelopmentRemoteGateInput.fromEnvironment(
    Map<String, String> environment,
  ) {
    bool confirmed(String name) => environment[name] == 'CONFIRMED';
    bool approved(String name) => environment[name] == 'APPROVED';

    return DevelopmentRemoteGateInput(
      environment: environment['BACKEND_TARGET_ENVIRONMENT'] ?? '',
      remoteContextAuthorizationModeActive:
          environment['REMOTE_CONTEXT_AUTHORIZATION_MODE'] ==
          'FOUNDER_AUTHORIZED',
      exactProjectConfirmed: confirmed('REMOTE_PROJECT_CONFIRMED'),
      operatorConfirmed: confirmed('DEVELOPMENT_OPERATOR_CONFIRMED'),
      founderAuthorizationReferencePresent:
          (environment['FOUNDER_AUTHORIZATION_REFERENCE'] ?? '')
              .trim()
              .isNotEmpty &&
          environment['FOUNDER_AUTHORIZATION_REFERENCE'] != 'NOT_GRANTED',
      authorizedCommitMatchesHead: confirmed('AUTHORIZED_COMMIT_MATCHES_HEAD'),
      deploymentManifestApprovedAtRuntime: approved(
        'DEPLOYMENT_MANIFEST_RUNTIME_APPROVAL',
      ),
      fixtureManifestApprovedAtRuntime: approved(
        'REMOTE_FIXTURE_MANIFEST_RUNTIME_APPROVAL',
      ),
      cleanupPreflightPassed: environment['REMOTE_CLEANUP_PREFLIGHT'] == 'PASS',
      corsOrigin: environment['DEVELOPMENT_ALLOWED_WEB_ORIGIN'] ?? '',
      requiredConfigurationComplete: confirmed('REMOTE_REQUIRED_CONFIGURATION'),
      requiredSecretNamesAcknowledged: confirmed(
        'REMOTE_SECRET_NAMES_ACKNOWLEDGED',
      ),
    );
  }

  final String environment;
  final bool remoteContextAuthorizationModeActive;
  final bool exactProjectConfirmed;
  final bool operatorConfirmed;
  final bool founderAuthorizationReferencePresent;
  final bool authorizedCommitMatchesHead;
  final bool deploymentManifestApprovedAtRuntime;
  final bool fixtureManifestApprovedAtRuntime;
  final bool cleanupPreflightPassed;
  final String corsOrigin;
  final bool requiredConfigurationComplete;
  final bool requiredSecretNamesAcknowledged;

  bool get isReady =>
      environment == 'development' &&
      remoteContextAuthorizationModeActive &&
      exactProjectConfirmed &&
      operatorConfirmed &&
      founderAuthorizationReferencePresent &&
      authorizedCommitMatchesHead &&
      deploymentManifestApprovedAtRuntime &&
      fixtureManifestApprovedAtRuntime &&
      cleanupPreflightPassed &&
      const DevelopmentCorsOriginValidator().isValid(corsOrigin) &&
      requiredConfigurationComplete &&
      requiredSecretNamesAcknowledged;

  List<String> get missingConditions {
    final missing = <String>[];
    if (environment != 'development') missing.add('environment');
    if (!remoteContextAuthorizationModeActive) missing.add('remoteContext');
    if (!exactProjectConfirmed) missing.add('exactProject');
    if (!operatorConfirmed) missing.add('operator');
    if (!founderAuthorizationReferencePresent) {
      missing.add('founderAuthorization');
    }
    if (!authorizedCommitMatchesHead) missing.add('authorizedCommit');
    if (!deploymentManifestApprovedAtRuntime) missing.add('deploymentManifest');
    if (!fixtureManifestApprovedAtRuntime) missing.add('fixtureManifest');
    if (!cleanupPreflightPassed) missing.add('cleanupPreflight');
    if (!const DevelopmentCorsOriginValidator().isValid(corsOrigin)) {
      missing.add('corsOrigin');
    }
    if (!requiredConfigurationComplete) missing.add('configuration');
    if (!requiredSecretNamesAcknowledged) missing.add('secretNames');
    return List.unmodifiable(missing);
  }
}

final class DevelopmentRemoteCleanupContract {
  const DevelopmentRemoteCleanupContract({
    required this.environment,
    required this.projectConfirmed,
    required this.expectedRunAlias,
  });

  static final _runAliasPattern = RegExp(r'^[a-z0-9][a-z0-9-]{7,31}$');

  final String environment;
  final bool projectConfirmed;
  final String expectedRunAlias;

  bool acceptsRun(String runAlias) =>
      environment == 'development' &&
      projectConfirmed &&
      _runAliasPattern.hasMatch(expectedRunAlias) &&
      !expectedRunAlias.contains('*') &&
      runAlias == expectedRunAlias;

  RemoteLifecycleClassification classify({
    required bool flowPassed,
    required bool cleanupPassed,
  }) {
    if (!cleanupPassed) {
      return RemoteLifecycleClassification.failedDirtyBlocking;
    }
    return flowPassed
        ? RemoteLifecycleClassification.passedClean
        : RemoteLifecycleClassification.failedClean;
  }

  Map<String, Object> safeEvidence({
    required String runAlias,
    required List<int> cleanupCounts,
  }) {
    if (!acceptsRun(runAlias) ||
        cleanupCounts.length != 7 ||
        cleanupCounts.any((count) => count < 0)) {
      throw const FormatException('Invalid cleanup evidence input.');
    }
    return {
      'fixtureNamespaceReference': 'EPHEMERAL_ALIAS_REDACTED',
      'cleanupCounts': List<int>.unmodifiable(cleanupCounts),
    };
  }
}

final class DevelopmentRemoteFixtureLifecycle {
  const DevelopmentRemoteFixtureLifecycle(this.cleanupContract);

  final DevelopmentRemoteCleanupContract cleanupContract;

  Future<RemoteLifecycleClassification> run({
    required String runAlias,
    required Future<void> Function() setup,
    required Future<void> Function() flow,
    required Future<List<int>> Function() cleanup,
  }) async {
    if (!cleanupContract.acceptsRun(runAlias)) {
      throw const FormatException('Remote run namespace was not accepted.');
    }
    var flowPassed = false;
    var cleanupPassed = false;
    try {
      await setup();
      await flow();
      flowPassed = true;
    } on Object {
      flowPassed = false;
    } finally {
      try {
        final counts = await cleanup();
        cleanupPassed =
            counts.length == 7 && counts.every((count) => count == 0);
      } on Object {
        cleanupPassed = false;
      }
    }
    return cleanupContract.classify(
      flowPassed: flowPassed,
      cleanupPassed: cleanupPassed,
    );
  }
}

final class DevelopmentRemotePreparationValidator {
  const DevelopmentRemotePreparationValidator(this.root);

  final Directory root;

  static const localManifestPath =
      'docs/stasisly_foundation/development/development_fixture_manifest.json';
  static const remoteManifestPath =
      'docs/stasisly_foundation/development/'
      'development_remote_fixture_manifest.json';
  static const skipGatePath =
      'docs/stasisly_foundation/development/development_remote_skip_gate.json';

  List<String> validateContracts() {
    final findings = <String>[];
    final local = _read(localManifestPath, findings);
    final remote = _read(remoteManifestPath, findings);
    final gate = _read(skipGatePath, findings);

    final localCleanup = local?['cleanupContract'];
    if (local?['environment'] != 'development' ||
        localCleanup is! Map ||
        localCleanup['localOnly'] != true) {
      findings.add('Local fixture contract is not local-only.');
    }
    if (remote?['environment'] != 'development' ||
        remote?['executionMode'] != 'remoteControlled' ||
        remote?['projectResolution'] != 'AUTHORIZED_RUNTIME_ONLY' ||
        remote?['dataClassification'] != 'synthetic' ||
        remote?['cleanupOnSuccess'] != 'REQUIRED' ||
        remote?['cleanupOnFailure'] != 'REQUIRED' ||
        remote?['partialSetupCleanup'] != 'REQUIRED' ||
        remote?['idempotentCleanup'] != 'REQUIRED' ||
        remote?['wildcardsAllowed'] != false ||
        remote?['approval'] != 'NOT_GRANTED' ||
        remote?['execution'] != 'NOT_EXECUTED') {
      findings.add('Remote fixture contract is not fail-closed.');
    }
    final namespace = remote?['namespaceTemplate'];
    if (namespace is! String ||
        namespace != 'foundation-019a-r1-{runAlias}' ||
        namespace.contains('*')) {
      findings.add('Remote namespace contract is unsafe.');
    }
    final cleanupOrder = remote?['cleanupOrder'];
    if (cleanupOrder is! List || cleanupOrder.length != 7) {
      findings.add('Remote cleanup order is incomplete.');
    }
    if (gate?['environment'] != 'development' ||
        gate?['status'] != 'CLASSIFIED_NOT_ENABLED' ||
        gate?['gateImplementation'] != 'READY' ||
        gate?['singleBooleanSufficient'] != false ||
        gate?['environmentAloneSufficient'] != false ||
        gate?['testsEnabled'] != false ||
        gate?['requiredConditions'] is! List ||
        (gate?['requiredConditions'] as List?)?.length != 11) {
      findings.add('Remote skip gate is incomplete or enabled.');
    }
    _scanForUnsafeMaterial(remote, findings);
    _scanForUnsafeMaterial(gate, findings);
    return findings;
  }

  DevelopmentRemotePreparationStatus status({String corsOrigin = ''}) {
    final findings = validateContracts();
    if (findings.any((finding) => finding.contains('skip gate'))) {
      return DevelopmentRemotePreparationStatus.blockedSkipGate;
    }
    if (findings.any((finding) => finding.contains('cleanup'))) {
      return DevelopmentRemotePreparationStatus.blockedCleanupContract;
    }
    if (findings.isNotEmpty) {
      return DevelopmentRemotePreparationStatus.blockedFixtureContract;
    }
    if (!const DevelopmentCorsOriginValidator().isValid(corsOrigin)) {
      return DevelopmentRemotePreparationStatus.blockedMissingCorsOrigin;
    }
    return DevelopmentRemotePreparationStatus.readyForReauthorization;
  }

  Map<String, Object?>? _read(String path, List<String> findings) {
    final file = File('${root.path}${Platform.pathSeparator}$path');
    if (!file.existsSync()) {
      findings.add('Missing contract: $path');
      return null;
    }
    try {
      final decoded = jsonDecode(file.readAsStringSync());
      if (decoded is Map<String, Object?>) return decoded;
    } on FormatException {
      // Return the same safe finding below.
    }
    findings.add('Invalid contract: $path');
    return null;
  }

  void _scanForUnsafeMaterial(Object? value, List<String> findings) {
    if (value is Map) {
      for (final entry in value.entries) {
        _scanForUnsafeMaterial(entry.value, findings);
      }
    } else if (value is List) {
      for (final item in value) {
        _scanForUnsafeMaterial(item, findings);
      }
    } else if (value is String) {
      final lower = value.toLowerCase();
      if (lower.contains('http://') ||
          lower.contains('https://') ||
          RegExp(r'\b[a-z0-9]{20}\b', caseSensitive: false).hasMatch(value)) {
        findings.add('Remote identifier or origin committed.');
      }
    }
  }
}

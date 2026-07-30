import 'dart:convert';
import 'dart:io';

import 'development_v4_dirty_run_containment_contracts.dart';
import 'development_v4_dirty_run_containment_http_gateway.dart';
import 'founder_authorization_artifact.dart';

const _manifestPath =
    'docs/stasisly_foundation/development/'
    'development_v4_dirty_run_containment_manifest.json';
const _authorizedOperation =
    'FOUNDATION-019A_V4_FAILED_RUN_DIAGNOSTIC_AND_CONTAINMENT';

final class V4ContainmentRunResult {
  const V4ContainmentRunResult({
    required this.initial,
    required this.finalSnapshot,
    required this.operationsAttempted,
    required this.operationsSucceeded,
    required this.authAbsenceVerified,
    required this.cliIsolated,
    required this.classification,
  });

  final V4CounterSnapshot initial;
  final V4CounterSnapshot finalSnapshot;
  final int operationsAttempted;
  final bool operationsSucceeded;
  final bool authAbsenceVerified;
  final bool cliIsolated;
  final V4ContainmentClassification classification;

  Map<String, Object> safeEvidence() => {
    'manifestVersion': v4ContainmentManifestVersion,
    'runnerVersion': v4ContainmentRunnerVersion,
    'initialCounterCategories': initial.counters
        .map((counter) => counter.result.name)
        .toList(growable: false),
    'finalCounterCategories': finalSnapshot.counters
        .map((counter) => counter.result.name)
        .toList(growable: false),
    'operationsAttempted': operationsAttempted,
    'operationsSucceeded': operationsSucceeded,
    'authAbsenceVerified': authAbsenceVerified,
    'cliIsolation': cliIsolated ? 'SAFE' : 'FAILED',
    'classification': classification.value,
  };
}

final class DevelopmentV4DirtyRunContainmentRunner {
  const DevelopmentV4DirtyRunContainmentRunner({
    required this.manifest,
    required this.gateway,
  });

  final V4ContainmentManifest manifest;
  final V4ContainmentGateway gateway;

  Future<V4ContainmentRunResult> run({
    required V4ContainmentRuntimeGate gate,
    required V4RunIdentity identity,
  }) async {
    if (manifest.validate().isNotEmpty || gate.validate().isNotEmpty) {
      throw StateError('V4_DIRTY_RUN_CONTAINMENT_GATE_BLOCKED');
    }
    var cliIsolated = false;
    try {
      final initial = await gateway.readSevenCounters(identity);
      List<V4ContainmentOperation> operations;
      try {
        operations = const V4ExactContainmentPlanner().plan(initial);
      } on V4ContainmentPlanningException catch (error) {
        cliIsolated = await gateway.isolateCli();
        final classification = error.code == 'BLOCKED_INSUFFICIENT_EXACT_LOOKUP'
            ? V4ContainmentClassification.blockedInsufficientExactLookup
            : V4ContainmentClassification.failedDirtyBlocking;
        return V4ContainmentRunResult(
          initial: initial,
          finalSnapshot: initial,
          operationsAttempted: 0,
          operationsSucceeded: false,
          authAbsenceVerified: false,
          cliIsolated: cliIsolated,
          classification: classification,
        );
      }

      var attempted = 0;
      var operationsSucceeded = true;
      for (final operation in operations) {
        attempted++;
        if (!await gateway.deleteExact(operation)) {
          operationsSucceeded = false;
          break;
        }
      }

      // Post-delete counters are mandatory even after a failed exact delete.
      final finalSnapshot = await gateway.readSevenCounters(identity);
      final authAbsent = await gateway.verifyAuthAbsence(identity);
      cliIsolated = await gateway.isolateCli();
      final classification = classifyV4Containment(
        initial: initial,
        finalSnapshot: finalSnapshot,
        operationsAttempted: attempted,
        operationsSucceeded: operationsSucceeded,
        authAbsenceVerified: authAbsent,
        cliIsolated: cliIsolated,
      );
      return V4ContainmentRunResult(
        initial: initial,
        finalSnapshot: finalSnapshot,
        operationsAttempted: attempted,
        operationsSucceeded: operationsSucceeded,
        authAbsenceVerified: authAbsent,
        cliIsolated: cliIsolated,
        classification: classification,
      );
    } finally {
      if (!cliIsolated) await gateway.isolateCli();
    }
  }
}

Future<void> main(List<String> arguments) async {
  if (arguments.length != 1 ||
      !{
        '--validate-contract',
        '--authorized-v4-containment-run',
      }.contains(arguments.single)) {
    stderr.writeln('V4 dirty-run containment invocation blocked.');
    exitCode = 64;
    return;
  }
  final manifest = V4ContainmentManifest.read(File(_manifestPath));
  if (manifest.validate().isNotEmpty) {
    stderr.writeln('V4_DIRTY_RUN_CONTAINMENT_CONTRACT_BLOCKED');
    exitCode = 1;
    return;
  }
  if (arguments.single == '--validate-contract') {
    stdout
      ..writeln('V4_FAILED_RUN_IDENTITY_RECONSTRUCTION_PASS')
      ..writeln('V4_CONVERSATION_AWARE_CONTAINMENT_PASS')
      ..writeln('V4_SEVEN_COUNTER_CONTRACT_PASS')
      ..writeln('V4_CANONICAL_RESOURCE_PROTECTION_PASS')
      ..writeln('V4_FUNCTIONAL_RUNNER_ISOLATION_PASS')
      ..writeln('V4_DIRTY_RUN_CONTAINMENT_GATE_PASS');
    return;
  }

  final environment = Platform.environment;
  final head = Process.runSync('git', ['rev-parse', 'HEAD']);
  if (head.exitCode != 0) {
    stderr.writeln('V4_DIRTY_RUN_CONTAINMENT_AUTHORIZATION_BLOCKED');
    exitCode = 65;
    return;
  }
  final headSha = (head.stdout as String).trim();
  final authorizationPath = environment['FOUNDER_AUTHORIZATION_ARTIFACT'] ?? '';
  final store = FounderAuthorizationStore(repositoryRoot: Directory.current);
  FounderAuthorizationArtifactV1 authorization;
  String authorizationId;
  try {
    store
      ..ensureSecureStorage()
      ..validateStorageContract();
    final authorizationFile = File(authorizationPath).absolute;
    authorizationId = _authorizationId(authorizationFile);
    if (authorizationFile.path !=
        store.artifactFile(authorizationId).absolute.path) {
      throw const FounderAuthorizationException(
        'AUTHORIZATION_ARTIFACT_PATH_BLOCKED',
      );
    }
    authorization = store.read(authorizationId);
    final source = resolveAuthorizationSource(
      artifact: authorization,
      environment: environment,
    );
    if (source == FounderAuthorizationSourceResolution.blockedConflict) {
      throw const FounderAuthorizationException(
        'AUTHORIZATION_LEGACY_ENV_CONFLICT',
      );
    }
    final findings = _authorizationFindings(authorization, headSha: headSha);
    if (findings.isNotEmpty) {
      throw FounderAuthorizationException(findings.first);
    }
  } on Object {
    stderr.writeln('V4_DIRTY_RUN_CONTAINMENT_AUTHORIZATION_BLOCKED');
    exitCode = 65;
    return;
  }

  final gate = _runtimeGate(environment, authorization, headSha);
  if (gate.validate().isNotEmpty) {
    stderr.writeln('V4_DIRTY_RUN_CONTAINMENT_GATE_BLOCKED');
    exitCode = 65;
    return;
  }
  final baseUrl = Uri.tryParse(environment['SUPABASE_URL'] ?? '');
  final projectRef = environment['SUPABASE_PROJECT_REF'] ?? '';
  if (baseUrl == null ||
      baseUrl.scheme != 'https' ||
      baseUrl.host != '$projectRef.supabase.co') {
    stderr.writeln('V4_DIRTY_RUN_CONTAINMENT_TARGET_BLOCKED');
    exitCode = 65;
    return;
  }
  final identity = V4RunIdentity.reconstruct(
    environment['FAILED_RUN_ALIAS'] ?? '',
  );
  try {
    await store.consume(
      authorizationId,
      validate: (artifact) =>
          _authorizationFindings(artifact, headSha: headSha),
    );
  } on FounderAuthorizationException {
    stderr.writeln(
      'V4_DIRTY_RUN_CONTAINMENT_AUTHORIZATION_CONSUMPTION_BLOCKED',
    );
    exitCode = 65;
    return;
  }
  final runner = DevelopmentV4DirtyRunContainmentRunner(
    manifest: manifest,
    gateway: HttpV4DirtyRunContainmentGateway(
      baseUrl: baseUrl,
      serviceRoleKey: environment['SUPABASE_SERVICE_ROLE_KEY'] ?? '',
    ),
  );
  final result = await runner.run(gate: gate, identity: identity);
  try {
    store.completeConsumed(
      authorizationId,
      finalClassification: result.classification.value,
      remoteContextFinal: result.cliIsolated ? 'SAFE' : 'FAILED',
    );
  } on FounderAuthorizationException {
    stderr.writeln(
      'V4_DIRTY_RUN_CONTAINMENT_AUTHORIZATION_FINALIZATION_BLOCKED',
    );
    exitCode = 2;
    return;
  }
  stdout.writeln(jsonEncode(result.safeEvidence()));
  if (result.classification != V4ContainmentClassification.containedClean &&
      result.classification !=
          V4ContainmentClassification.diagnosedAlreadyClean) {
    exitCode = 2;
  }
}

String _authorizationId(File file) {
  final name = file.uri.pathSegments.last;
  if (!name.endsWith('.json') || name.length == '.json'.length) {
    throw const FounderAuthorizationException(
      'AUTHORIZATION_ARTIFACT_PATH_BLOCKED',
    );
  }
  return name.substring(0, name.length - '.json'.length);
}

List<String> _authorizationFindings(
  FounderAuthorizationArtifactV1 artifact, {
  required String headSha,
}) => artifact.validate(
  now: DateTime.now().toUtc(),
  expectedOperation: _authorizedOperation,
  expectedEnvironment: 'development',
  expectedCommitSha: headSha,
  expectedManifest: v4ContainmentManifestVersion,
  expectedRunner: v4ContainmentRunnerVersion,
);

V4ContainmentRuntimeGate _runtimeGate(
  Map<String, String> environment,
  FounderAuthorizationArtifactV1 authorization,
  String headSha,
) {
  bool exact(String name, String expected) => environment[name] == expected;
  return V4ContainmentRuntimeGate(
    founderAuthorizationMatches:
        authorization.status == FounderAuthorizationStatus.granted &&
        authorization.decision == 'APPROVED' &&
        authorization.authorizedOperation == _authorizedOperation,
    authorizedCommitMatches:
        headSha.isNotEmpty && authorization.authorizedCommitSha == headSha,
    developmentTargetMatches:
        exact('APP_MODE', 'development') &&
        exact('BACKEND_TARGET_ENVIRONMENT', 'development') &&
        (environment['SUPABASE_PROJECT_REF'] ?? '').isNotEmpty &&
        (environment['SUPABASE_URL'] ?? '').isNotEmpty &&
        (environment['SUPABASE_SERVICE_ROLE_KEY'] ?? '').isNotEmpty,
    failedRunReferenceMatches: exact(
      'FAILED_RUN_AUTHORIZATION_REFERENCE',
      v4FailedAuthorizationReference,
    ),
    failedManifestMatches: exact(
      'FAILED_RUN_V4_MANIFEST_VERSION',
      v4FailedManifestVersion,
    ),
    failedRunnerMatches: exact(
      'FAILED_RUN_V4_RUNNER_VERSION',
      v4FailedRunnerVersion,
    ),
    containmentManifestMatches: exact(
      'V4_CONTAINMENT_MANIFEST_VERSION',
      v4ContainmentManifestVersion,
    ),
    containmentRunnerMatches: exact(
      'V4_CONTAINMENT_RUNNER_VERSION',
      v4ContainmentRunnerVersion,
    ),
    functionalRunnerDisabled: exact('FUNCTIONAL_RUNNER_DISABLED', 'true'),
    authCreationDisabled: exact('AUTH_CREATION_DISABLED', 'true'),
    conversationCreationDisabled: exact(
      'CONVERSATION_CREATION_DISABLED',
      'true',
    ),
    messageCreationDisabled: exact('MESSAGE_CREATION_DISABLED', 'true'),
    idempotencyReplayDisabled: exact('IDEMPOTENCY_REPLAY_DISABLED', 'true'),
    catalogMutationDisabled: exact('CATALOG_MUTATION_DISABLED', 'true'),
    specialistMutationDisabled: exact('SPECIALIST_MUTATION_DISABLED', 'true'),
    exactLookupsOnly: exact('EXACT_LOOKUPS_ONLY', 'true'),
    broadLookupsBlocked: exact('BROAD_LOOKUPS_BLOCKED', 'true'),
    sevenCountersRequired: exact('SEVEN_COUNTERS_REQUIRED', 'true'),
    conversationAwareContainment: exact(
      'CONVERSATION_AWARE_CONTAINMENT',
      'true',
    ),
    canonicalResourcesProtected: exact('CANONICAL_RESOURCES_PROTECTED', 'true'),
    postDeleteCountersRequired: exact('POST_DELETE_COUNTERS_REQUIRED', 'true'),
    cliIsolationRequired: exact('CLI_ISOLATION_REQUIRED', 'true'),
    retentionLimitationAcknowledged: exact(
      'RETENTION_LIMITATION_ACKNOWLEDGED',
      v4RetentionLimitation,
    ),
  );
}

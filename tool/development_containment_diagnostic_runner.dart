import 'dart:convert';
import 'dart:io';

import 'development_containment_diagnostic_contracts.dart';
import 'development_containment_diagnostic_http_gateway.dart';

const _manifestPath =
    'docs/stasisly_foundation/development/'
    'development_containment_diagnostic_manifest.json';

final class ContainmentDiagnosticRunResult {
  const ContainmentDiagnosticRunResult({
    required this.catalogCategory,
    required this.counterCategories,
    required this.classification,
    required this.cliIsolated,
  });

  final CatalogDiagnosticCategory catalogCategory;
  final List<CounterResultCategory> counterCategories;
  final ContainmentClassification classification;
  final bool cliIsolated;

  Map<String, Object> safeEvidence() => {
    'manifestVersion': containmentDiagnosticManifestVersion,
    'runnerVersion': containmentDiagnosticRunnerVersion,
    'catalogCategory': catalogCategory.name,
    'counterCategories': counterCategories
        .map((category) => category.name)
        .toList(growable: false),
    'classification': classification.name,
    'cliIsolation': cliIsolated ? 'SAFE' : 'FAILED',
  };
}

final class DevelopmentContainmentDiagnosticRunner {
  const DevelopmentContainmentDiagnosticRunner({
    required this.manifest,
    required this.gateway,
  });

  final ContainmentDiagnosticManifest manifest;
  final ContainmentDiagnosticGateway gateway;

  Future<ContainmentDiagnosticRunResult> run(
    ContainmentRuntimeGateInput gate,
  ) async {
    if (manifest.validate().isNotEmpty || gate.validate().isNotEmpty) {
      throw StateError('CONTAINMENT_DIAGNOSTIC_GATE_BLOCKED');
    }
    var isolated = false;
    try {
      final catalogObservation = await gateway.diagnoseCatalog();
      final catalog = const CanonicalSpecialistCatalogDiagnostic().classify(
        catalogObservation,
      );
      var counters = await gateway.readSevenCounters();
      final plan = const ExactContainmentPlanner().plan(counters);
      var contained = false;
      if (plan.isNotEmpty) {
        contained = await gateway.containExact(plan);
        if (contained) counters = await gateway.readSevenCounters();
      }
      isolated = await gateway.isolateCli();
      return ContainmentDiagnosticRunResult(
        catalogCategory: catalog,
        counterCategories: counters
            .map((counter) => counter.result)
            .toList(growable: false),
        classification: classifyContainment(
          catalog: catalog,
          counters: counters,
          containmentCompleted: contained,
          cliIsolated: isolated,
        ),
        cliIsolated: isolated,
      );
    } finally {
      if (!isolated) await gateway.isolateCli();
    }
  }
}

Future<void> main(List<String> arguments) async {
  if (arguments.length != 1 ||
      !{
        '--validate-contract',
        '--authorized-containment-run',
      }.contains(arguments.single)) {
    stderr.writeln('Containment diagnostic runner invocation blocked.');
    exitCode = 64;
    return;
  }
  final manifest = ContainmentDiagnosticManifest.read(File(_manifestPath));
  final findings = manifest.validate();
  if (findings.isNotEmpty) {
    stderr.writeln('CONTAINMENT_DIAGNOSTIC_CONTRACT_BLOCKED');
    exitCode = 1;
    return;
  }
  if (arguments.single == '--validate-contract') {
    stdout
      ..writeln('FAILED_RUN_IDENTITY_STRATEGY_PASS')
      ..writeln('CATALOG_DIAGNOSTIC_CONTRACT_PASS')
      ..writeln('SEVEN_COUNTER_CONTRACT_PASS')
      ..writeln('CANONICAL_RESOURCE_PROTECTION_PASS')
      ..writeln('FUNCTIONAL_RUNNER_ISOLATION_PASS')
      ..writeln('CONTAINMENT_DIAGNOSTIC_GATE_PASS');
    return;
  }

  final environment = Platform.environment;
  final gate = _runtimeGate(environment);
  if (gate.validate().isNotEmpty) {
    stderr.writeln('CONTAINMENT_DIAGNOSTIC_GATE_BLOCKED');
    exitCode = 65;
    return;
  }
  final baseUrl = Uri.tryParse(environment['SUPABASE_URL'] ?? '');
  final projectRef = environment['SUPABASE_PROJECT_REF'] ?? '';
  if (baseUrl == null ||
      baseUrl.scheme != 'https' ||
      baseUrl.host != '$projectRef.supabase.co') {
    stderr.writeln('CONTAINMENT_DIAGNOSTIC_TARGET_BLOCKED');
    exitCode = 65;
    return;
  }
  final runner = DevelopmentContainmentDiagnosticRunner(
    manifest: manifest,
    gateway: HttpContainmentDiagnosticGateway(
      baseUrl: baseUrl,
      serviceRoleKey: environment['SUPABASE_SERVICE_ROLE_KEY'] ?? '',
      failedRunAlias: environment['FAILED_RUN_ALIAS'] ?? '',
      exactExpectedOwnerId: environment['FAILED_RUN_OWNER_ID'] ?? '',
    ),
  );
  final result = await runner.run(gate);
  stdout.writeln(jsonEncode(result.safeEvidence()));
  if (result.classification == ContainmentClassification.failedDirtyBlocking ||
      result.classification ==
          ContainmentClassification.blockedInsufficientExactLookup) {
    exitCode = 2;
  }
}

ContainmentRuntimeGateInput _runtimeGate(Map<String, String> environment) {
  bool exact(String name, String expected) => environment[name] == expected;
  final head = Process.runSync('git', ['rev-parse', 'HEAD']);
  final authorizedCommit = environment['AUTHORIZED_COMMIT_SHA'] ?? '';
  final alias = environment['FAILED_RUN_ALIAS'] ?? '';
  final serviceRole = environment['SUPABASE_SERVICE_ROLE_KEY'] ?? '';
  return ContainmentRuntimeGateInput(
    founderAuthorizationMatches:
        exact(
          'FOUNDER_CONTAINMENT_AUTHORIZATION_REFERENCE',
          recommendedContainmentAuthorization,
        ) &&
        exact('CONTAINMENT_AUTHORIZATION_STATUS', 'GRANTED_AT_RUNTIME') &&
        environment['FOUNDER_CONTAINMENT_AUTHORIZATION_REFERENCE'] !=
            consumedFunctionalAuthorization,
    authorizedCommitMatches:
        head.exitCode == 0 &&
        authorizedCommit.isNotEmpty &&
        (head.stdout as String).trim() == authorizedCommit,
    developmentTargetMatches:
        exact('APP_MODE', 'development') &&
        exact('BACKEND_TARGET_ENVIRONMENT', 'development') &&
        (environment['SUPABASE_PROJECT_REF'] ?? '').isNotEmpty &&
        (environment['SUPABASE_URL'] ?? '').isNotEmpty &&
        serviceRole.isNotEmpty &&
        RegExp(r'^[a-z0-9][a-z0-9-]{7,31}$').hasMatch(alias),
    manifestMatches: exact(
      'CONTAINMENT_DIAGNOSTIC_MANIFEST_VERSION',
      containmentDiagnosticManifestVersion,
    ),
    runnerMatches: exact(
      'CONTAINMENT_DIAGNOSTIC_RUNNER_VERSION',
      containmentDiagnosticRunnerVersion,
    ),
    functionalRunnerDisabled: exact('FUNCTIONAL_RUNNER_DISABLED', 'true'),
    authCreationDisabled: exact('AUTH_CREATION_DISABLED', 'true'),
    conversationCreationDisabled: exact(
      'CONVERSATION_CREATION_DISABLED',
      'true',
    ),
    catalogMutationDisabled: exact('CATALOG_MUTATION_DISABLED', 'true'),
    specialistMutationDisabled: exact('SPECIALIST_MUTATION_DISABLED', 'true'),
    exactLookupsOnly: exact('EXACT_LOOKUPS_ONLY', 'true'),
    sevenCountersPresent: exact('SEVEN_COUNTERS_REQUIRED', 'true'),
    canonicalResourcesProtected: exact('CANONICAL_RESOURCES_PROTECTED', 'true'),
    cliIsolationPresent: exact('CLI_ISOLATION_REQUIRED', 'true'),
  );
}

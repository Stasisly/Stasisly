import 'dart:convert';
import 'dart:io';

const containmentDiagnosticManifestVersion =
    'FOUNDATION-019A-CONTAINMENT-DIAGNOSTIC-v2';
const containmentDiagnosticRunnerVersion =
    'FOUNDATION-019A-R2G-DIAGNOSTIC-RUNNER-v1';
const consumedFunctionalAuthorization = 'FA-019A-RETRY-20260728-006';
const consumedFunctionalCommit = '7a37dd651ad2f867b851dfca4def00377d802f44';
const recommendedContainmentAuthorization = 'FA-019A-CONTAIN-DIAG-20260728-007';

const containmentCounterNames = <String>[
  'messages',
  'idempotency',
  'sessions',
  'profiles',
  'catalog',
  'specialists',
  'auth',
];

enum RunHandleClassification {
  reconstructableExact,
  availableEphemerally,
  notAvailable,
  unsafeForLookup,
}

enum CatalogDiagnosticCategory {
  catalogRequestNotExecuted,
  catalogTransportFailure,
  catalogHttpNonSuccess,
  catalogBodyInvalid,
  catalogContractInvalid,
  catalogPaginationInvalid,
  catalogCursorCycle,
  catalogPageLimitReached,
  canonicalAreaNotFound,
  canonicalAreaContractRequiresRemoteDiagnostic,
  zeroAvailableCandidates,
  exactlyOneAvailableCandidate,
  multipleAvailableCandidates,
  candidateStatusInvalid,
  candidateNotSelectable,
  candidateProductUnavailable,
  candidateEnvironmentMismatch,
  unknownCatalogFailure,
}

enum CounterResultCategory {
  zero,
  nonzeroExact,
  unknownBlocking,
  queryNotExecuted,
  queryFailed,
}

enum ResourceOwnership {
  createdByFailedRun,
  verifiedPreexistingReadOnly,
  unknownOwnership,
  globalResource,
  unscopedResource,
}

enum ContainmentClassification {
  containedClean,
  diagnosedFailedClean,
  failedDirtyBlocking,
  blockedInsufficientExactLookup,
}

final class ContainmentDiagnosticManifest {
  ContainmentDiagnosticManifest._({
    required this.version,
    required this.runnerVersion,
    required this.counterNames,
    required this.catalogArea,
    required this.catalogLimit,
    required this.catalogMaximumPages,
    required this.cleanWithoutContainment,
    required this.cleanAfterContainment,
    required this.remoteAuthorization,
    required this.futureAuthorization,
    required this.functionalExecutions,
    required this.newAuthUsers,
    required this.newConversations,
    required this.catalogMutation,
    required this.specialistMutation,
    required this.broadLookups,
    required this.broadDeletes,
    required this.stopAfterFirstUnsafeCondition,
    required this.mandatoryCliIsolation,
  });

  factory ContainmentDiagnosticManifest.read(File file) {
    final decoded = jsonDecode(file.readAsStringSync());
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Containment manifest must be an object.');
    }
    final catalog = decoded['catalogDiagnostic'];
    final counters = decoded['counters'];
    final future = decoded['futureAuthorization'];
    final classification = decoded['cleanClassification'];
    if (catalog is! Map ||
        counters is! List ||
        future is! Map ||
        classification is! Map) {
      throw const FormatException('Containment manifest sections are missing.');
    }
    return ContainmentDiagnosticManifest._(
      version: decoded['manifestVersion'] as String? ?? '',
      runnerVersion: decoded['runnerVersion'] as String? ?? '',
      counterNames: counters
          .map((value) => (value as Map)['name'] as String? ?? '')
          .toList(growable: false),
      catalogArea: catalog['area'] as String? ?? '',
      catalogLimit: catalog['limit'] as int? ?? 0,
      catalogMaximumPages: catalog['maximumPages'] as int? ?? 0,
      cleanWithoutContainment:
          classification['zeroActionsAndZeroResidue'] as String? ?? '',
      cleanAfterContainment:
          classification['successfulActionsAndZeroResidue'] as String? ?? '',
      remoteAuthorization: decoded['remoteAuthorization'] as String? ?? '',
      futureAuthorization: future['state'] as String? ?? '',
      functionalExecutions: decoded['functionalExecutions'] as String? ?? '',
      newAuthUsers: decoded['newAuthUsers'] as String? ?? '',
      newConversations: decoded['newConversations'] as String? ?? '',
      catalogMutation: decoded['catalogMutation'] as String? ?? '',
      specialistMutation: decoded['specialistMutation'] as String? ?? '',
      broadLookups: decoded['broadLookups'] as String? ?? '',
      broadDeletes: decoded['broadDeletes'] as String? ?? '',
      stopAfterFirstUnsafeCondition:
          decoded['stopAfterFirstUnsafeCondition'] == true,
      mandatoryCliIsolation: decoded['mandatoryCliIsolation'] == true,
    );
  }

  final String version;
  final String runnerVersion;
  final List<String> counterNames;
  final String catalogArea;
  final int catalogLimit;
  final int catalogMaximumPages;
  final String cleanWithoutContainment;
  final String cleanAfterContainment;
  final String remoteAuthorization;
  final String futureAuthorization;
  final String functionalExecutions;
  final String newAuthUsers;
  final String newConversations;
  final String catalogMutation;
  final String specialistMutation;
  final String broadLookups;
  final String broadDeletes;
  final bool stopAfterFirstUnsafeCondition;
  final bool mandatoryCliIsolation;

  List<String> validate() {
    final findings = <String>[];
    if (version != containmentDiagnosticManifestVersion ||
        runnerVersion != containmentDiagnosticRunnerVersion) {
      findings.add('Containment manifest or runner version is invalid.');
    }
    if (counterNames.length != containmentCounterNames.length ||
        counterNames.asMap().entries.any(
          (entry) => entry.value != containmentCounterNames[entry.key],
        )) {
      findings.add('Seven-counter order is invalid.');
    }
    if (catalogArea != 'stasis' ||
        catalogLimit != 20 ||
        catalogMaximumPages != 1) {
      findings.add('Catalog diagnostic bound is invalid.');
    }
    if (cleanWithoutContainment != 'DIAGNOSED_FAILED_CLEAN' ||
        cleanAfterContainment != 'CONTAINED_CLEAN') {
      findings.add('Clean classification semantics are invalid.');
    }
    if (remoteAuthorization != 'NOT_GRANTED' ||
        futureAuthorization != 'NOT_GRANTED') {
      findings.add('Remote authorization must remain closed.');
    }
    if (functionalExecutions != 'BLOCKED' ||
        newAuthUsers != 'BLOCKED' ||
        newConversations != 'BLOCKED') {
      findings.add('Functional operations must remain blocked.');
    }
    if (catalogMutation != 'FORBIDDEN' ||
        specialistMutation != 'FORBIDDEN' ||
        broadLookups != 'FORBIDDEN' ||
        broadDeletes != 'FORBIDDEN') {
      findings.add('Unsafe catalog or containment operation is enabled.');
    }
    if (!stopAfterFirstUnsafeCondition || !mandatoryCliIsolation) {
      findings.add('Stop and isolation controls are incomplete.');
    }
    return findings;
  }
}

final class CatalogCandidateObservation {
  const CatalogCandidateObservation({
    required this.statusValid,
    required this.selectable,
    required this.productAvailable,
    required this.environmentCompatible,
  });

  final bool statusValid;
  final bool selectable;
  final bool productAvailable;
  final bool environmentCompatible;
}

final class CatalogDiagnosticObservation {
  const CatalogDiagnosticObservation({
    this.requestExecuted = true,
    this.transportSucceeded = true,
    this.httpStatus = 200,
    this.jsonDecoded = true,
    this.contractValid = true,
    this.paginationValid = true,
    this.cursorCycle = false,
    this.pageLimitReached = false,
    this.canonicalAreaPresent = true,
    this.requiresRemoteAreaConfirmation = false,
    this.unknownFailure = false,
    this.candidates = const [],
  });

  final bool requestExecuted;
  final bool transportSucceeded;
  final int httpStatus;
  final bool jsonDecoded;
  final bool contractValid;
  final bool paginationValid;
  final bool cursorCycle;
  final bool pageLimitReached;
  final bool canonicalAreaPresent;
  final bool requiresRemoteAreaConfirmation;
  final bool unknownFailure;
  final List<CatalogCandidateObservation> candidates;
}

final class CanonicalSpecialistCatalogDiagnostic {
  const CanonicalSpecialistCatalogDiagnostic();

  CatalogDiagnosticCategory classify(CatalogDiagnosticObservation observation) {
    if (!observation.requestExecuted) {
      return CatalogDiagnosticCategory.catalogRequestNotExecuted;
    }
    if (!observation.transportSucceeded) {
      return CatalogDiagnosticCategory.catalogTransportFailure;
    }
    if (observation.httpStatus < 200 || observation.httpStatus >= 300) {
      return CatalogDiagnosticCategory.catalogHttpNonSuccess;
    }
    if (!observation.jsonDecoded) {
      return CatalogDiagnosticCategory.catalogBodyInvalid;
    }
    if (!observation.contractValid) {
      return CatalogDiagnosticCategory.catalogContractInvalid;
    }
    if (!observation.paginationValid) {
      return CatalogDiagnosticCategory.catalogPaginationInvalid;
    }
    if (observation.cursorCycle) {
      return CatalogDiagnosticCategory.catalogCursorCycle;
    }
    if (observation.pageLimitReached) {
      return CatalogDiagnosticCategory.catalogPageLimitReached;
    }
    if (observation.requiresRemoteAreaConfirmation) {
      return CatalogDiagnosticCategory
          .canonicalAreaContractRequiresRemoteDiagnostic;
    }
    if (observation.unknownFailure) {
      return CatalogDiagnosticCategory.unknownCatalogFailure;
    }
    if (!observation.canonicalAreaPresent) {
      return CatalogDiagnosticCategory.canonicalAreaNotFound;
    }
    if (observation.candidates.any((candidate) => !candidate.statusValid)) {
      return CatalogDiagnosticCategory.candidateStatusInvalid;
    }
    if (observation.candidates.any((candidate) => !candidate.selectable)) {
      return CatalogDiagnosticCategory.candidateNotSelectable;
    }
    if (observation.candidates.any(
      (candidate) => !candidate.productAvailable,
    )) {
      return CatalogDiagnosticCategory.candidateProductUnavailable;
    }
    if (observation.candidates.any(
      (candidate) => !candidate.environmentCompatible,
    )) {
      return CatalogDiagnosticCategory.candidateEnvironmentMismatch;
    }
    return switch (observation.candidates.length) {
      0 => CatalogDiagnosticCategory.zeroAvailableCandidates,
      1 => CatalogDiagnosticCategory.exactlyOneAvailableCandidate,
      _ => CatalogDiagnosticCategory.multipleAvailableCandidates,
    };
  }
}

final class CounterEvidence {
  const CounterEvidence({
    required this.name,
    required this.result,
    required this.count,
    required this.lookupExact,
    required this.queryBound,
    required this.ownership,
    this.exactOwnershipProof = false,
    this.exactDeleteHandle = false,
  });

  final String name;
  final CounterResultCategory result;
  final int? count;
  final bool lookupExact;
  final int queryBound;
  final ResourceOwnership ownership;
  final bool exactOwnershipProof;
  final bool exactDeleteHandle;

  bool get isValid {
    if (!containmentCounterNames.contains(name) || queryBound < 0) return false;
    return switch (result) {
      CounterResultCategory.zero => count == 0 && lookupExact,
      CounterResultCategory.nonzeroExact =>
        count != null && count! > 0 && lookupExact,
      CounterResultCategory.unknownBlocking ||
      CounterResultCategory.queryNotExecuted ||
      CounterResultCategory.queryFailed => count == null,
    };
  }
}

final class ContainmentOperation {
  const ContainmentOperation(this.resourceName);

  final String resourceName;
}

abstract interface class ContainmentDiagnosticGateway {
  Future<CatalogDiagnosticObservation> diagnoseCatalog();

  Future<List<CounterEvidence>> readSevenCounters();

  Future<bool> containExact(List<ContainmentOperation> operations);

  Future<bool> isolateCli();
}

final class ExactContainmentPlanner {
  const ExactContainmentPlanner();

  List<ContainmentOperation> plan(List<CounterEvidence> counters) {
    _validateCompleteCounters(counters);
    final operations = <ContainmentOperation>[];
    for (final counter in counters) {
      if (!counter.isValid) {
        throw StateError('COUNTER_EVIDENCE_INVALID');
      }
      if (counter.result != CounterResultCategory.nonzeroExact) continue;
      if (counter.name == 'catalog' || counter.name == 'specialists') {
        throw StateError('CANONICAL_RESOURCE_DELETE_BLOCKED');
      }
      if (counter.ownership != ResourceOwnership.createdByFailedRun ||
          !counter.exactOwnershipProof ||
          !counter.exactDeleteHandle) {
        throw StateError('EXACT_CONTAINMENT_BLOCKED');
      }
      operations.add(ContainmentOperation(counter.name));
    }
    return operations;
  }
}

void _validateCompleteCounters(List<CounterEvidence> counters) {
  if (counters.length != containmentCounterNames.length) {
    throw StateError('SEVEN_COUNTER_CONTRACT_INCOMPLETE');
  }
  for (var index = 0; index < counters.length; index++) {
    if (counters[index].name != containmentCounterNames[index]) {
      throw StateError('SEVEN_COUNTER_CONTRACT_INCOMPLETE');
    }
  }
}

ContainmentClassification classifyContainment({
  required CatalogDiagnosticCategory catalog,
  required List<CounterEvidence> counters,
  required int containmentActionCount,
  required bool containmentCompleted,
  required bool cliIsolated,
}) {
  _validateCompleteCounters(counters);
  if (!cliIsolated) return ContainmentClassification.failedDirtyBlocking;
  if (containmentActionCount < 0 ||
      (containmentActionCount == 0 && containmentCompleted) ||
      (containmentActionCount > 0 && !containmentCompleted)) {
    return ContainmentClassification.failedDirtyBlocking;
  }
  if (counters.any(
    (counter) =>
        !counter.isValid ||
        counter.result == CounterResultCategory.unknownBlocking ||
        counter.result == CounterResultCategory.queryNotExecuted ||
        counter.result == CounterResultCategory.queryFailed,
  )) {
    return ContainmentClassification.failedDirtyBlocking;
  }
  final nonzero = counters.where(
    (counter) => counter.result == CounterResultCategory.nonzeroExact,
  );
  if (nonzero.isNotEmpty) {
    if (containmentActionCount > 0) {
      return ContainmentClassification.failedDirtyBlocking;
    }
    return ContainmentClassification.blockedInsufficientExactLookup;
  }
  if (containmentActionCount > 0 && containmentCompleted) {
    return ContainmentClassification.containedClean;
  }
  return ContainmentClassification.diagnosedFailedClean;
}

bool exactContainmentDeleteSucceeded(int statusCode) =>
    statusCode == 200 || statusCode == 404;

final class ContainmentRuntimeGateInput {
  const ContainmentRuntimeGateInput({
    required this.founderAuthorizationMatches,
    required this.authorizedCommitMatches,
    required this.developmentTargetMatches,
    required this.manifestMatches,
    required this.runnerMatches,
    required this.functionalRunnerDisabled,
    required this.authCreationDisabled,
    required this.conversationCreationDisabled,
    required this.catalogMutationDisabled,
    required this.specialistMutationDisabled,
    required this.exactLookupsOnly,
    required this.sevenCountersPresent,
    required this.canonicalResourcesProtected,
    required this.cliIsolationPresent,
  });

  final bool founderAuthorizationMatches;
  final bool authorizedCommitMatches;
  final bool developmentTargetMatches;
  final bool manifestMatches;
  final bool runnerMatches;
  final bool functionalRunnerDisabled;
  final bool authCreationDisabled;
  final bool conversationCreationDisabled;
  final bool catalogMutationDisabled;
  final bool specialistMutationDisabled;
  final bool exactLookupsOnly;
  final bool sevenCountersPresent;
  final bool canonicalResourcesProtected;
  final bool cliIsolationPresent;

  List<String> validate() {
    final checks = <String, bool>{
      'FOUNDER_CONTAINMENT_AUTHORIZATION_MATCH': founderAuthorizationMatches,
      'AUTHORIZED_COMMIT_MATCH': authorizedCommitMatches,
      'DEVELOPMENT_TARGET_MATCH': developmentTargetMatches,
      'DIAGNOSTIC_MANIFEST_MATCH': manifestMatches,
      'CONTAINMENT_RUNNER_MATCH': runnerMatches,
      'FUNCTIONAL_RUNNER_DISABLED': functionalRunnerDisabled,
      'AUTH_CREATION_DISABLED': authCreationDisabled,
      'CONVERSATION_CREATION_DISABLED': conversationCreationDisabled,
      'CATALOG_MUTATION_DISABLED': catalogMutationDisabled,
      'SPECIALIST_MUTATION_DISABLED': specialistMutationDisabled,
      'EXACT_LOOKUPS_ONLY': exactLookupsOnly,
      'SEVEN_COUNTERS_PRESENT': sevenCountersPresent,
      'CANONICAL_RESOURCES_PROTECTED': canonicalResourcesProtected,
      'CLI_ISOLATION_PRESENT': cliIsolationPresent,
    };
    return [
      for (final entry in checks.entries)
        if (!entry.value) entry.key,
    ];
  }
}

Map<String, RunHandleClassification> failedRunHandleStrategy() =>
    const <String, RunHandleClassification>{
      'runAlias': RunHandleClassification.availableEphemerally,
      'operationAttemptId': RunHandleClassification.reconstructableExact,
      'syntheticPrincipalDerivation':
          RunHandleClassification.reconstructableExact,
      'idempotencyKeyDerivation': RunHandleClassification.reconstructableExact,
      'ownerAuthId': RunHandleClassification.notAvailable,
      'conversationId': RunHandleClassification.notAvailable,
      'specialistId': RunHandleClassification.unsafeForLookup,
      'catalogId': RunHandleClassification.unsafeForLookup,
    };

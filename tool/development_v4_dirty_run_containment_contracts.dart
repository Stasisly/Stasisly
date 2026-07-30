import 'dart:convert';
import 'dart:io';

const v4ContainmentManifestVersion =
    'FOUNDATION-019A-V4-DIRTY-RUN-CONTAINMENT-v2';
const v4ContainmentRunnerVersion = 'FOUNDATION-019A-R2H-CONTAINMENT-RUNNER-v2';
const v4ContainmentAuthorizationSchema = 'founder-authorization-v2';
const v4FailedManifestVersion = 'FOUNDATION-019A-SECOND-FUNCTIONAL-ATTEMPT-v4';
const v4FailedRunnerVersion = 'FOUNDATION-019A-R2G-RUNNER-v1';
const v4FailedAuthorizationReference = 'FA-019A-RETRY-20260729-008';
const v4FailedCommit = '7a660c143949ca7fc6cbd423a7c8d30102a5d7f9';
const v4FailedResult =
    'DEVELOPMENT SECOND_FUNCTIONAL_ATTEMPT_V4_FAILED_DIRTY_BLOCKING';
const v4FailedAuthorizationState = 'CONSUMED';
const v4FutureAuthorizationState = 'NOT_GRANTED';
const v4RetentionLimitation = 'POST_DEVELOPMENT_OPERATIONAL_BLOCKER';

const v4CounterNames = <String>[
  'messages',
  'idempotency',
  'sessions',
  'profiles',
  'catalog',
  'specialists',
  'auth',
];

const v4MutableContainmentOrder = <String>[
  'messages',
  'idempotency',
  'sessions',
  'profiles',
  'auth',
];

enum V4HandleClassification {
  reconstructableExact,
  availableEphemerally,
  availableFromSanitizedLedger,
  notAvailable,
  unsafeForLookup,
}

enum V4FailureCategory {
  idempotencyReplayRequestNotSent,
  idempotencyReplayRequestSentNoResponse,
  idempotencyReplayResponseInvalid,
  idempotencyReplayContractMismatch,
  idempotencyReplayConflict,
  conversationCountRequestFailed,
  stateTransitionContractFailure,
  resourceLedgerFailure,
  unknownPostCreateFailure,
}

enum V4CounterResult {
  zero,
  nonzeroExact,
  unknownBlocking,
  queryNotExecuted,
  queryFailed,
}

enum V4ResourceOwnership {
  createdByRun,
  verifiedPreexistingReadOnly,
  unknown,
  foreign,
  unscoped,
}

enum V4ContainmentClassification {
  containedClean('CONTAINED_CLEAN'),
  diagnosedAlreadyClean('DIAGNOSED_ALREADY_CLEAN'),
  failedDirtyBlocking('FAILED_DIRTY_BLOCKING'),
  blockedInsufficientExactLookup('BLOCKED_INSUFFICIENT_EXACT_LOOKUP');

  const V4ContainmentClassification(this.value);

  final String value;
}

final class V4RunIdentity {
  V4RunIdentity._(this._alias)
    : _operationAttempt = '${_alias}_create_0001',
      _profileMarker = 'Synthetic $_alias';

  factory V4RunIdentity.reconstruct(String alias) {
    if (!_runAliasPattern.hasMatch(alias) ||
        alias != alias.trim() ||
        alias.runes.any((rune) => rune > 0x7f)) {
      throw const FormatException('Failed-run identity is invalid.');
    }
    return V4RunIdentity._(alias);
  }

  final String _alias;
  final String _operationAttempt;
  final String _profileMarker;

  T useAlias<T>(T Function(String value) operation) => operation(_alias);

  T useOperationAttempt<T>(T Function(String value) operation) =>
      operation(_operationAttempt);

  T useIdempotencyKey<T>(T Function(String value) operation) =>
      operation(_operationAttempt);

  T useProfileMarker<T>(T Function(String value) operation) =>
      operation(_profileMarker);

  @override
  String toString() => 'V4RunIdentity(<redacted>)';
}

final class V4OpaqueHandle {
  const V4OpaqueHandle._(this.resource, this._value);

  factory V4OpaqueHandle.exact(String resource, String value) {
    if (!v4CounterNames.contains(resource) ||
        value.isEmpty ||
        value != value.trim() ||
        value.contains('*') ||
        value.contains(',')) {
      throw const FormatException('Exact containment handle is invalid.');
    }
    return V4OpaqueHandle._(resource, value);
  }

  final String resource;
  final String _value;

  T use<T>(T Function(String value) operation) => operation(_value);

  bool sameValue(V4OpaqueHandle other) =>
      resource == other.resource && _value == other._value;

  @override
  String toString() => 'V4OpaqueHandle($resource:<redacted>)';
}

final class V4CounterDefinition {
  const V4CounterDefinition({
    required this.name,
    required this.lookupBasis,
    required this.queryBound,
    required this.expectedClean,
    required this.containmentEligibility,
  });

  factory V4CounterDefinition.fromJson(Map<String, Object?> json) =>
      V4CounterDefinition(
        name: json['name'] as String? ?? '',
        lookupBasis: json['lookupBasis'] as String? ?? '',
        queryBound: json['queryBound'] as int? ?? -1,
        expectedClean: json['expectedClean'] as String? ?? '',
        containmentEligibility: json['containmentEligibility'] as String? ?? '',
      );

  final String name;
  final String lookupBasis;
  final int queryBound;
  final String expectedClean;
  final String containmentEligibility;

  bool get isValid =>
      v4CounterNames.contains(name) &&
      lookupBasis.isNotEmpty &&
      queryBound >= 0 &&
      expectedClean == 'ZERO' &&
      {
        'EXACT_RUN_OWNED_ONLY',
        'FORBIDDEN_CANONICAL_RESOURCE',
      }.contains(containmentEligibility);
}

final class V4ContainmentManifest {
  V4ContainmentManifest._({
    required this.version,
    required this.runnerVersion,
    required this.authorizationArtifactSchema,
    required this.environment,
    required this.remoteAuthorization,
    required this.remoteExecution,
    required this.failedAuthorizationState,
    required this.failedAuthorizationReference,
    required this.failedAuthorizationReusable,
    required this.failedCommit,
    required this.failedCommitBound,
    required this.failedManifestVersion,
    required this.failedRunnerVersion,
    required this.failedResult,
    required this.lastApprovedState,
    required this.failureCategory,
    required this.cleanupState,
    required this.authPostLookup,
    required this.failedSevenCounters,
    required this.futureAuthorizationState,
    required this.counterDefinitions,
    required this.containmentOrder,
    required this.postDeleteCounterOrder,
    required this.cleanVector,
    required this.functionalRunner,
    required this.authCreation,
    required this.conversationCreation,
    required this.messageCreation,
    required this.idempotencyReplay,
    required this.catalogMutation,
    required this.specialistMutation,
    required this.broadLookups,
    required this.broadDeletes,
    required this.exactLookupsOnly,
    required this.canonicalResourcesProtected,
    required this.postDeleteCountersRequired,
    required this.stopAfterUnsafeCondition,
    required this.cliIsolationRequired,
    required this.retentionLimitation,
  });

  factory V4ContainmentManifest.read(File file) {
    final decoded = jsonDecode(file.readAsStringSync());
    if (decoded is! Map<String, Object?>) {
      throw const FormatException('V4 containment manifest must be an object.');
    }
    final failedRun = _map(decoded['failedRun']);
    final futureAuthorization = _map(decoded['futureAuthorization']);
    final rawCounters = decoded['counters'];
    if (rawCounters is! List<Object?>) {
      throw const FormatException('V4 counters are required.');
    }
    return V4ContainmentManifest._(
      version: decoded['manifestVersion'] as String? ?? '',
      runnerVersion: decoded['runnerVersion'] as String? ?? '',
      authorizationArtifactSchema:
          decoded['authorizationArtifactSchema'] as String? ?? '',
      environment: decoded['environment'] as String? ?? '',
      remoteAuthorization: decoded['remoteAuthorization'] as String? ?? '',
      remoteExecution: decoded['remoteExecution'] as String? ?? '',
      failedAuthorizationState:
          failedRun['authorizationState'] as String? ?? '',
      failedAuthorizationReference:
          failedRun['authorizationReference'] as String? ?? '',
      failedAuthorizationReusable:
          failedRun['authorizationReusable'] as bool? ?? true,
      failedCommit: failedRun['commit'] as String? ?? '',
      failedCommitBound: failedRun['commitBound'] as bool? ?? false,
      failedManifestVersion: failedRun['manifestVersion'] as String? ?? '',
      failedRunnerVersion: failedRun['runnerVersion'] as String? ?? '',
      failedResult: failedRun['result'] as String? ?? '',
      lastApprovedState: failedRun['lastApprovedState'] as String? ?? '',
      failureCategory: failedRun['failureCategory'] as String? ?? '',
      cleanupState: failedRun['cleanupState'] as String? ?? '',
      authPostLookup: failedRun['authPostLookup'] as String? ?? '',
      failedSevenCounters: failedRun['sevenCounters'] as String? ?? '',
      futureAuthorizationState: futureAuthorization['state'] as String? ?? '',
      counterDefinitions: _counterDefinitions(rawCounters),
      containmentOrder: _strings(decoded['containmentOrder']),
      postDeleteCounterOrder: _strings(decoded['postDeleteCounterOrder']),
      cleanVector: decoded['cleanVector'] as String? ?? '',
      functionalRunner: decoded['functionalRunner'] as String? ?? '',
      authCreation: decoded['authCreation'] as String? ?? '',
      conversationCreation: decoded['conversationCreation'] as String? ?? '',
      messageCreation: decoded['messageCreation'] as String? ?? '',
      idempotencyReplay: decoded['idempotencyReplay'] as String? ?? '',
      catalogMutation: decoded['catalogMutation'] as String? ?? '',
      specialistMutation: decoded['specialistMutation'] as String? ?? '',
      broadLookups: decoded['broadLookups'] as String? ?? '',
      broadDeletes: decoded['broadDeletes'] as String? ?? '',
      exactLookupsOnly: decoded['exactLookupsOnly'] as bool? ?? false,
      canonicalResourcesProtected:
          decoded['canonicalResourcesProtected'] as bool? ?? false,
      postDeleteCountersRequired:
          decoded['postDeleteCountersRequired'] as bool? ?? false,
      stopAfterUnsafeCondition:
          decoded['stopAfterUnsafeCondition'] as bool? ?? false,
      cliIsolationRequired: decoded['cliIsolationRequired'] as bool? ?? false,
      retentionLimitation: decoded['retentionLimitation'] as String? ?? '',
    );
  }

  final String version;
  final String runnerVersion;
  final String authorizationArtifactSchema;
  final String environment;
  final String remoteAuthorization;
  final String remoteExecution;
  final String failedAuthorizationState;
  final String failedAuthorizationReference;
  final bool failedAuthorizationReusable;
  final String failedCommit;
  final bool failedCommitBound;
  final String failedManifestVersion;
  final String failedRunnerVersion;
  final String failedResult;
  final String lastApprovedState;
  final String failureCategory;
  final String cleanupState;
  final String authPostLookup;
  final String failedSevenCounters;
  final String futureAuthorizationState;
  final List<V4CounterDefinition> counterDefinitions;
  final List<String> containmentOrder;
  final List<String> postDeleteCounterOrder;
  final String cleanVector;
  final String functionalRunner;
  final String authCreation;
  final String conversationCreation;
  final String messageCreation;
  final String idempotencyReplay;
  final String catalogMutation;
  final String specialistMutation;
  final String broadLookups;
  final String broadDeletes;
  final bool exactLookupsOnly;
  final bool canonicalResourcesProtected;
  final bool postDeleteCountersRequired;
  final bool stopAfterUnsafeCondition;
  final bool cliIsolationRequired;
  final String retentionLimitation;

  List<String> validate() {
    final findings = <String>[];
    if (version != v4ContainmentManifestVersion ||
        runnerVersion != v4ContainmentRunnerVersion ||
        authorizationArtifactSchema != v4ContainmentAuthorizationSchema) {
      findings.add('V4 containment manifest/runner version mismatch.');
    }
    if (environment != 'development' ||
        remoteAuthorization != 'NOT_GRANTED' ||
        remoteExecution != 'NOT_EXECUTED' ||
        futureAuthorizationState != v4FutureAuthorizationState) {
      findings.add('V4 remote authorization must remain closed.');
    }
    if (failedAuthorizationReference != v4FailedAuthorizationReference ||
        failedAuthorizationState != v4FailedAuthorizationState ||
        failedAuthorizationReusable ||
        failedCommit != v4FailedCommit ||
        !failedCommitBound ||
        failedManifestVersion != v4FailedManifestVersion ||
        failedRunnerVersion != v4FailedRunnerVersion ||
        failedResult != v4FailedResult) {
      findings.add('Failed v4 run binding is invalid.');
    }
    if (lastApprovedState != 'CONVERSATION_CREATED' ||
        failureCategory != 'UNKNOWN_POST_CREATE_FAILURE' ||
        cleanupState != 'CLEANUP_COMPLETED' ||
        authPostLookup != 'ABSENT_CONFIRMED' ||
        failedSevenCounters != 'NOT_VERIFIED_AS_ALL_ZERO') {
      findings.add('Failed v4 evidence is overstated or incomplete.');
    }
    if (counterDefinitions.length != v4CounterNames.length ||
        counterDefinitions.asMap().entries.any(
          (entry) =>
              entry.value.name != v4CounterNames[entry.key] ||
              !entry.value.isValid,
        ) ||
        postDeleteCounterOrder.join('|') != v4CounterNames.join('|') ||
        containmentOrder.join('|') != v4MutableContainmentOrder.join('|') ||
        cleanVector != '0|0|0|0|0|0|0') {
      findings.add('Seven-counter contract is invalid.');
    }
    if ({
          functionalRunner,
          authCreation,
          conversationCreation,
          messageCreation,
          idempotencyReplay,
          catalogMutation,
          specialistMutation,
        }.any((value) => value != 'DISABLED') ||
        broadLookups != 'BLOCKED' ||
        broadDeletes != 'BLOCKED' ||
        !exactLookupsOnly ||
        !canonicalResourcesProtected ||
        !postDeleteCountersRequired ||
        !stopAfterUnsafeCondition ||
        !cliIsolationRequired ||
        retentionLimitation != v4RetentionLimitation) {
      findings.add('V4 fail-closed controls are incomplete.');
    }
    return findings;
  }
}

final class V4CounterEvidence {
  const V4CounterEvidence({
    required this.name,
    required this.result,
    required this.count,
    required this.lookupExact,
    required this.queryBound,
    required this.ownership,
    this.ownershipProof = false,
    this.deleteHandle,
  });

  final String name;
  final V4CounterResult result;
  final int? count;
  final bool lookupExact;
  final int queryBound;
  final V4ResourceOwnership ownership;
  final bool ownershipProof;
  final V4OpaqueHandle? deleteHandle;

  bool get isStructurallyValid {
    if (!v4CounterNames.contains(name) || queryBound < 0) return false;
    return switch (result) {
      V4CounterResult.zero => count == 0 && lookupExact && deleteHandle == null,
      V4CounterResult.nonzeroExact =>
        count != null && count! > 0 && lookupExact,
      V4CounterResult.unknownBlocking ||
      V4CounterResult.queryNotExecuted ||
      V4CounterResult.queryFailed => count == null && deleteHandle == null,
    };
  }

  bool get isExactDeletable =>
      result == V4CounterResult.nonzeroExact &&
      ownership == V4ResourceOwnership.createdByRun &&
      ownershipProof &&
      deleteHandle != null &&
      deleteHandle!.resource == name;
}

final class V4CounterSnapshot {
  V4CounterSnapshot(List<V4CounterEvidence> counters)
    : counters = List.unmodifiable(counters) {
    validateComplete();
  }

  final List<V4CounterEvidence> counters;

  void validateComplete() {
    if (counters.length != v4CounterNames.length) {
      throw StateError('SEVEN_COUNTER_CONTRACT_INCOMPLETE');
    }
    for (var index = 0; index < counters.length; index++) {
      if (counters[index].name != v4CounterNames[index] ||
          !counters[index].isStructurallyValid) {
        throw StateError('SEVEN_COUNTER_CONTRACT_INCOMPLETE');
      }
    }
  }

  bool get allZero =>
      counters.every((counter) => counter.result == V4CounterResult.zero);

  bool get hasUnknown => counters.any(
    (counter) =>
        counter.result == V4CounterResult.unknownBlocking ||
        counter.result == V4CounterResult.queryNotExecuted ||
        counter.result == V4CounterResult.queryFailed,
  );

  List<int> get safeCounts =>
      counters.map((counter) => counter.count ?? -1).toList(growable: false);
}

final class V4ContainmentOperation {
  const V4ContainmentOperation({required this.resource, required this.handle});

  final String resource;
  final V4OpaqueHandle handle;

  @override
  String toString() => 'V4ContainmentOperation($resource:<redacted>)';
}

abstract interface class V4ContainmentGateway {
  Future<V4CounterSnapshot> readSevenCounters(V4RunIdentity identity);

  Future<bool> deleteExact(V4ContainmentOperation operation);

  Future<bool> verifyAuthAbsence(V4RunIdentity identity);

  Future<bool> isolateCli();
}

final class V4ContainmentPlanningException implements Exception {
  const V4ContainmentPlanningException(this.code);

  final String code;
}

final class V4ExactContainmentPlanner {
  const V4ExactContainmentPlanner();

  List<V4ContainmentOperation> plan(V4CounterSnapshot snapshot) {
    if (snapshot.hasUnknown) {
      throw const V4ContainmentPlanningException(
        'UNKNOWN_COUNTER_BLOCKS_CONTAINMENT',
      );
    }
    final byName = {
      for (final counter in snapshot.counters) counter.name: counter,
    };
    for (final canonical in ['catalog', 'specialists']) {
      if (byName[canonical]!.result != V4CounterResult.zero ||
          byName[canonical]!.ownership !=
              V4ResourceOwnership.verifiedPreexistingReadOnly) {
        throw const V4ContainmentPlanningException(
          'CANONICAL_RESOURCE_PROTECTION_BLOCKED',
        );
      }
    }
    final operations = <V4ContainmentOperation>[];
    for (final name in v4MutableContainmentOrder) {
      final counter = byName[name]!;
      if (counter.result == V4CounterResult.zero) continue;
      if (!counter.isExactDeletable) {
        throw const V4ContainmentPlanningException(
          'BLOCKED_INSUFFICIENT_EXACT_LOOKUP',
        );
      }
      operations.add(
        V4ContainmentOperation(resource: name, handle: counter.deleteHandle!),
      );
    }
    return operations;
  }
}

V4ContainmentClassification classifyV4Containment({
  required V4CounterSnapshot initial,
  required V4CounterSnapshot finalSnapshot,
  required int operationsAttempted,
  required bool operationsSucceeded,
  required bool authAbsenceVerified,
  required bool cliIsolated,
}) {
  if (initial.hasUnknown ||
      finalSnapshot.hasUnknown ||
      operationsAttempted < 0 ||
      !authAbsenceVerified ||
      !cliIsolated) {
    return V4ContainmentClassification.failedDirtyBlocking;
  }
  if (initial.allZero && operationsAttempted == 0 && finalSnapshot.allZero) {
    return V4ContainmentClassification.diagnosedAlreadyClean;
  }
  if (operationsAttempted == 0 && !initial.allZero) {
    return V4ContainmentClassification.blockedInsufficientExactLookup;
  }
  if (!operationsSucceeded || !finalSnapshot.allZero) {
    return V4ContainmentClassification.failedDirtyBlocking;
  }
  return V4ContainmentClassification.containedClean;
}

final class V4ContainmentRuntimeGate {
  const V4ContainmentRuntimeGate({
    required this.founderAuthorizationMatches,
    required this.authorizedCommitMatches,
    required this.developmentTargetMatches,
    required this.failedRunReferenceMatches,
    required this.failedManifestMatches,
    required this.failedRunnerMatches,
    required this.containmentManifestMatches,
    required this.containmentRunnerMatches,
    required this.functionalRunnerDisabled,
    required this.authCreationDisabled,
    required this.conversationCreationDisabled,
    required this.messageCreationDisabled,
    required this.idempotencyReplayDisabled,
    required this.catalogMutationDisabled,
    required this.specialistMutationDisabled,
    required this.exactLookupsOnly,
    required this.broadLookupsBlocked,
    required this.sevenCountersRequired,
    required this.conversationAwareContainment,
    required this.canonicalResourcesProtected,
    required this.postDeleteCountersRequired,
    required this.cliIsolationRequired,
    required this.retentionLimitationAcknowledged,
  });

  final bool founderAuthorizationMatches;
  final bool authorizedCommitMatches;
  final bool developmentTargetMatches;
  final bool failedRunReferenceMatches;
  final bool failedManifestMatches;
  final bool failedRunnerMatches;
  final bool containmentManifestMatches;
  final bool containmentRunnerMatches;
  final bool functionalRunnerDisabled;
  final bool authCreationDisabled;
  final bool conversationCreationDisabled;
  final bool messageCreationDisabled;
  final bool idempotencyReplayDisabled;
  final bool catalogMutationDisabled;
  final bool specialistMutationDisabled;
  final bool exactLookupsOnly;
  final bool broadLookupsBlocked;
  final bool sevenCountersRequired;
  final bool conversationAwareContainment;
  final bool canonicalResourcesProtected;
  final bool postDeleteCountersRequired;
  final bool cliIsolationRequired;
  final bool retentionLimitationAcknowledged;

  List<String> validate() {
    final checks = <String, bool>{
      'FOUNDER_CONTAINMENT_AUTHORIZATION_MATCH': founderAuthorizationMatches,
      'AUTHORIZED_COMMIT_MATCH': authorizedCommitMatches,
      'DEVELOPMENT_TARGET_MATCH': developmentTargetMatches,
      'FAILED_RUN_REFERENCE_MATCH': failedRunReferenceMatches,
      'FAILED_RUN_V4_MANIFEST_MATCH': failedManifestMatches,
      'FAILED_RUN_V4_RUNNER_MATCH': failedRunnerMatches,
      'CONTAINMENT_MANIFEST_MATCH': containmentManifestMatches,
      'CONTAINMENT_RUNNER_MATCH': containmentRunnerMatches,
      'FUNCTIONAL_RUNNER_DISABLED': functionalRunnerDisabled,
      'AUTH_CREATION_DISABLED': authCreationDisabled,
      'CONVERSATION_CREATION_DISABLED': conversationCreationDisabled,
      'MESSAGE_CREATION_DISABLED': messageCreationDisabled,
      'IDEMPOTENCY_REPLAY_DISABLED': idempotencyReplayDisabled,
      'CATALOG_MUTATION_DISABLED': catalogMutationDisabled,
      'SPECIALIST_MUTATION_DISABLED': specialistMutationDisabled,
      'EXACT_LOOKUPS_ONLY': exactLookupsOnly,
      'BROAD_LOOKUPS_BLOCKED': broadLookupsBlocked,
      'SEVEN_COUNTERS_REQUIRED': sevenCountersRequired,
      'CONVERSATION_AWARE_CONTAINMENT': conversationAwareContainment,
      'CANONICAL_RESOURCES_PROTECTED': canonicalResourcesProtected,
      'POST_DELETE_COUNTERS_REQUIRED': postDeleteCountersRequired,
      'CLI_ISOLATION_REQUIRED': cliIsolationRequired,
      'RETENTION_LIMITATION_ACKNOWLEDGED': retentionLimitationAcknowledged,
    };
    return [
      for (final entry in checks.entries)
        if (!entry.value) entry.key,
    ];
  }
}

Map<String, V4HandleClassification> v4FailedRunHandleStrategy() =>
    const <String, V4HandleClassification>{
      'runAlias': V4HandleClassification.availableEphemerally,
      'operationAttemptId': V4HandleClassification.reconstructableExact,
      'idempotencyKey': V4HandleClassification.reconstructableExact,
      'syntheticOwnerMarker': V4HandleClassification.reconstructableExact,
      'conversationHandle': V4HandleClassification.availableFromSanitizedLedger,
      'authorizationReference': V4HandleClassification.reconstructableExact,
      'manifestVersion': V4HandleClassification.reconstructableExact,
      'runnerVersion': V4HandleClassification.reconstructableExact,
      'canonicalSpecialistId': V4HandleClassification.unsafeForLookup,
      'canonicalCatalogId': V4HandleClassification.unsafeForLookup,
    };

V4FailureCategory classifyV4PostCreateFailure({
  required bool replayRequestSent,
  required bool replayResponseReceived,
  required bool replayResponseValid,
  required bool replayContractMatched,
  required bool replayConflict,
  required bool conversationCountRequestFailed,
  required bool stateTransitionFailed,
  required bool ledgerFailed,
  required bool evidenceComplete,
}) {
  if (!evidenceComplete) return V4FailureCategory.unknownPostCreateFailure;
  if (!replayRequestSent) {
    return V4FailureCategory.idempotencyReplayRequestNotSent;
  }
  if (!replayResponseReceived) {
    return V4FailureCategory.idempotencyReplayRequestSentNoResponse;
  }
  if (!replayResponseValid) {
    return V4FailureCategory.idempotencyReplayResponseInvalid;
  }
  if (replayConflict) return V4FailureCategory.idempotencyReplayConflict;
  if (!replayContractMatched) {
    return V4FailureCategory.idempotencyReplayContractMismatch;
  }
  if (conversationCountRequestFailed) {
    return V4FailureCategory.conversationCountRequestFailed;
  }
  if (stateTransitionFailed) {
    return V4FailureCategory.stateTransitionContractFailure;
  }
  if (ledgerFailed) return V4FailureCategory.resourceLedgerFailure;
  return V4FailureCategory.unknownPostCreateFailure;
}

Map<String, Object?> _map(Object? value) {
  if (value is! Map) throw const FormatException('Manifest object required.');
  return Map<String, Object?>.from(value);
}

List<String> _strings(Object? value) {
  if (value is! List) throw const FormatException('Manifest list required.');
  return value.map((item) => item as String).toList(growable: false);
}

List<V4CounterDefinition> _counterDefinitions(List<Object?> values) {
  final definitions = <V4CounterDefinition>[];
  for (final value in values) {
    if (value is! Map) {
      throw const FormatException('Counter definition object required.');
    }
    definitions.add(
      V4CounterDefinition.fromJson(Map<String, Object?>.from(value)),
    );
  }
  return List.unmodifiable(definitions);
}

final _runAliasPattern = RegExp(r'^[a-z0-9][a-z0-9-]{7,31}$');

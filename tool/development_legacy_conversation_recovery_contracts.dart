import 'dart:convert';
import 'dart:io';

import 'founder_authorization_artifact.dart';

const legacyConversationRecoveryManifestVersion =
    'FOUNDATION-019A-V4-LEGACY-CONVERSATION-RECOVERY-v1';
const legacyConversationRecoveryRunnerVersion =
    'FOUNDATION-019A-R2J-LEGACY-IDENTITY-RUNNER-v1';
const legacyConversationRecoveryArtifactSchema = 'founder-authorization-v2';
const legacyConversationRecoveryResultUnavailable =
    'FOUNDATION-019A LEGACY_CONVERSATION_EXACT_RECOVERY_UNAVAILABLE';

const legacyFailedAuthorizationReference = 'FA-019A-RETRY-20260729-008';
const legacyFailedCommit = '7a660c143949ca7fc6cbd423a7c8d30102a5d7f9';
const legacyFailedManifest = 'FOUNDATION-019A-SECOND-FUNCTIONAL-ATTEMPT-v4';
const legacyFailedRunner = 'FOUNDATION-019A-R2G-RUNNER-v1';
const legacyFailedResult =
    'DEVELOPMENT SECOND_FUNCTIONAL_ATTEMPT_V4_FAILED_DIRTY_BLOCKING';
const legacyFailedLastState = 'CONVERSATION_CREATED';
const legacyFailedCategory = 'UNKNOWN_POST_CREATE_FAILURE';

enum HistoricalIdentityCandidateClassification {
  exactAndAvailable('EXACT_AND_AVAILABLE'),
  exactButNotAvailable('EXACT_BUT_NOT_AVAILABLE'),
  derivableExactly('DERIVABLE_EXACTLY'),
  nonUnique('NON_UNIQUE'),
  approximate('APPROXIMATE'),
  sensitiveUnsafe('SENSITIVE_UNSAFE'),
  unsupportedByBackend('UNSUPPORTED_BY_BACKEND'),
  unknown('UNKNOWN');

  const HistoricalIdentityCandidateClassification(this.value);

  final String value;

  static HistoricalIdentityCandidateClassification parse(Object? value) =>
      values.singleWhere(
        (candidate) => candidate.value == value,
        orElse: () => throw const FormatException(
          'LEGACY_IDENTITY_CANDIDATE_CLASSIFICATION_INVALID',
        ),
      );
}

enum LegacyRecoveryStrategyStatus {
  admissible('ADMISSIBLE'),
  admissibleWithGuards('ADMISSIBLE_WITH_GUARDS'),
  insufficient('INSUFFICIENT'),
  unsupported('UNSUPPORTED'),
  unsafe('UNSAFE'),
  unknown('UNKNOWN');

  const LegacyRecoveryStrategyStatus(this.value);

  final String value;

  static LegacyRecoveryStrategyStatus parse(Object? value) =>
      values.singleWhere(
        (candidate) => candidate.value == value,
        orElse: () => throw const FormatException(
          'LEGACY_RECOVERY_STRATEGY_STATUS_INVALID',
        ),
      );
}

enum LegacyConversationRecoveryResult {
  exactlyIdentified('LEGACY_CONVERSATION_EXACTLY_IDENTIFIED'),
  exactlyAbsent('LEGACY_CONVERSATION_EXACTLY_ABSENT'),
  ambiguous('LEGACY_CONVERSATION_AMBIGUOUS'),
  foreign('LEGACY_CONVERSATION_FOREIGN'),
  lookupFailed('LEGACY_CONVERSATION_LOOKUP_FAILED'),
  exactRecoveryUnavailable('LEGACY_CONVERSATION_EXACT_RECOVERY_UNAVAILABLE');

  const LegacyConversationRecoveryResult(this.value);

  final String value;
}

enum LegacyLookupCardinality {
  exactlyOne('EXACTLY_ONE'),
  exactlyZero('EXACTLY_ZERO'),
  ambiguous('AMBIGUOUS'),
  foreign('FOREIGN'),
  queryFailed('QUERY_FAILED'),
  contractInsufficient('CONTRACT_INSUFFICIENT');

  const LegacyLookupCardinality(this.value);

  final String value;
}

final class HistoricalIdentityCandidate {
  const HistoricalIdentityCandidate({
    required this.name,
    required this.classification,
    required this.exact,
    required this.available,
    required this.backendSupported,
    required this.ownershipVerifiable,
  });

  factory HistoricalIdentityCandidate.fromJson(Map<String, Object?> json) {
    const expected = {
      'name',
      'classification',
      'exact',
      'available',
      'backendSupported',
      'ownershipVerifiable',
    };
    if (json.keys.toSet().difference(expected).isNotEmpty ||
        expected.difference(json.keys.toSet()).isNotEmpty) {
      throw const FormatException('LEGACY_IDENTITY_CANDIDATE_INVALID');
    }
    return HistoricalIdentityCandidate(
      name: json['name'] as String? ?? '',
      classification: HistoricalIdentityCandidateClassification.parse(
        json['classification'],
      ),
      exact: json['exact'] as bool? ?? false,
      available: json['available'] as bool? ?? false,
      backendSupported: json['backendSupported'] as bool? ?? false,
      ownershipVerifiable: json['ownershipVerifiable'] as bool? ?? false,
    );
  }

  final String name;
  final HistoricalIdentityCandidateClassification classification;
  final bool exact;
  final bool available;
  final bool backendSupported;
  final bool ownershipVerifiable;

  bool get canAuthorizeLookup =>
      exact &&
      available &&
      backendSupported &&
      ownershipVerifiable &&
      classification ==
          HistoricalIdentityCandidateClassification.exactAndAvailable;
}

final class LegacyRecoveryStrategy {
  const LegacyRecoveryStrategy({
    required this.name,
    required this.exactKeyAvailable,
    required this.backendLookupSupported,
    required this.cardinalityBounded,
    required this.ownerVerifiable,
    required this.runBindingVerifiable,
    required this.absenceProvable,
    required this.deleteHandleAvailable,
    required this.status,
  });

  factory LegacyRecoveryStrategy.fromJson(Map<String, Object?> json) {
    const expected = {
      'name',
      'exactKeyAvailable',
      'backendLookupSupported',
      'cardinalityBounded',
      'ownerVerifiable',
      'runBindingVerifiable',
      'absenceProvable',
      'deleteHandleAvailable',
      'status',
    };
    if (json.keys.toSet().difference(expected).isNotEmpty ||
        expected.difference(json.keys.toSet()).isNotEmpty) {
      throw const FormatException('LEGACY_RECOVERY_STRATEGY_INVALID');
    }
    return LegacyRecoveryStrategy(
      name: json['name'] as String? ?? '',
      exactKeyAvailable: json['exactKeyAvailable'] as bool? ?? false,
      backendLookupSupported: json['backendLookupSupported'] as bool? ?? false,
      cardinalityBounded: json['cardinalityBounded'] as bool? ?? false,
      ownerVerifiable: json['ownerVerifiable'] as bool? ?? false,
      runBindingVerifiable: json['runBindingVerifiable'] as bool? ?? false,
      absenceProvable: json['absenceProvable'] as bool? ?? false,
      deleteHandleAvailable: json['deleteHandleAvailable'] as bool? ?? false,
      status: LegacyRecoveryStrategyStatus.parse(json['status']),
    );
  }

  final String name;
  final bool exactKeyAvailable;
  final bool backendLookupSupported;
  final bool cardinalityBounded;
  final bool ownerVerifiable;
  final bool runBindingVerifiable;
  final bool absenceProvable;
  final bool deleteHandleAvailable;
  final LegacyRecoveryStrategyStatus status;

  bool get isAdmissible =>
      exactKeyAvailable &&
      backendLookupSupported &&
      cardinalityBounded &&
      ownerVerifiable &&
      runBindingVerifiable &&
      {
        LegacyRecoveryStrategyStatus.admissible,
        LegacyRecoveryStrategyStatus.admissibleWithGuards,
      }.contains(status);
}

final class LegacyConversationRecoveryManifest {
  LegacyConversationRecoveryManifest._({
    required this.schemaVersion,
    required this.manifestVersion,
    required this.runnerVersion,
    required this.artifactSchema,
    required this.environment,
    required this.remoteAuthorization,
    required this.remoteExecution,
    required this.currentAuthorizedCommit,
    required this.subjectRun,
    required this.historicalEvidence,
    required this.candidates,
    required this.strategies,
    required this.selectedPrimaryStrategy,
    required this.selectedSecondaryStrategy,
    required this.permittedQueryShape,
    required this.maximumRequestCount,
    required this.maximumResultCardinality,
    required this.deleteEnabled,
    required this.diagnosticOnly,
    required this.messagesPolicy,
    required this.sessionsPolicy,
    required this.canonicalResourcesProtected,
    required this.cliIsolationRequired,
    required this.stopConditions,
  });

  factory LegacyConversationRecoveryManifest.read(File file) {
    final decoded = jsonDecode(file.readAsStringSync());
    if (decoded is! Map<String, Object?>) {
      throw const FormatException('LEGACY_RECOVERY_MANIFEST_INVALID');
    }
    final rawSubject = decoded['subjectRun'];
    final rawEvidence = decoded['historicalEvidence'];
    final rawCandidates = decoded['identityCandidates'];
    final rawStrategies = decoded['strategies'];
    final rawStops = decoded['stopConditions'];
    if (rawSubject is! Map<String, Object?> ||
        rawEvidence is! Map<String, Object?> ||
        rawCandidates is! List<Object?> ||
        rawStrategies is! List<Object?> ||
        rawStops is! List<Object?>) {
      throw const FormatException('LEGACY_RECOVERY_MANIFEST_INVALID');
    }
    return LegacyConversationRecoveryManifest._(
      schemaVersion: decoded['schemaVersion'] as int? ?? -1,
      manifestVersion: decoded['manifestVersion'] as String? ?? '',
      runnerVersion: decoded['runnerVersion'] as String? ?? '',
      artifactSchema: decoded['authorizationArtifactSchema'] as String? ?? '',
      environment: decoded['environment'] as String? ?? '',
      remoteAuthorization: decoded['remoteAuthorization'] as String? ?? '',
      remoteExecution: decoded['remoteExecution'] as String? ?? '',
      currentAuthorizedCommit:
          decoded['currentAuthorizedCommit'] as String? ?? '',
      subjectRun: FounderAuthorizationSubjectRun.fromJson(rawSubject),
      historicalEvidence: Map<String, Object?>.from(rawEvidence),
      candidates: rawCandidates
          .map(
            (value) => HistoricalIdentityCandidate.fromJson(
              Map<String, Object?>.from(value! as Map),
            ),
          )
          .toList(growable: false),
      strategies: rawStrategies
          .map(
            (value) => LegacyRecoveryStrategy.fromJson(
              Map<String, Object?>.from(value! as Map),
            ),
          )
          .toList(growable: false),
      selectedPrimaryStrategy:
          decoded['selectedPrimaryStrategy'] as String? ?? '',
      selectedSecondaryStrategy:
          decoded['selectedSecondaryStrategy'] as String? ?? '',
      permittedQueryShape: decoded['permittedQueryShape'] as String? ?? '',
      maximumRequestCount: decoded['maximumRequestCount'] as int? ?? -1,
      maximumResultCardinality:
          decoded['maximumResultCardinality'] as int? ?? -1,
      deleteEnabled: decoded['deleteEnabled'] as bool? ?? true,
      diagnosticOnly: decoded['diagnosticOnly'] as bool? ?? false,
      messagesPolicy: decoded['messagesPolicy'] as String? ?? '',
      sessionsPolicy: decoded['sessionsPolicy'] as String? ?? '',
      canonicalResourcesProtected:
          decoded['canonicalResourcesProtected'] as bool? ?? false,
      cliIsolationRequired: decoded['cliIsolationRequired'] as bool? ?? false,
      stopConditions: rawStops.cast<String>().toSet(),
    );
  }

  final int schemaVersion;
  final String manifestVersion;
  final String runnerVersion;
  final String artifactSchema;
  final String environment;
  final String remoteAuthorization;
  final String remoteExecution;
  final String currentAuthorizedCommit;
  final FounderAuthorizationSubjectRun subjectRun;
  final Map<String, Object?> historicalEvidence;
  final List<HistoricalIdentityCandidate> candidates;
  final List<LegacyRecoveryStrategy> strategies;
  final String selectedPrimaryStrategy;
  final String selectedSecondaryStrategy;
  final String permittedQueryShape;
  final int maximumRequestCount;
  final int maximumResultCardinality;
  final bool deleteEnabled;
  final bool diagnosticOnly;
  final String messagesPolicy;
  final String sessionsPolicy;
  final bool canonicalResourcesProtected;
  final bool cliIsolationRequired;
  final Set<String> stopConditions;

  List<String> validate() {
    final findings = <String>[];
    if (schemaVersion != 1 ||
        manifestVersion != legacyConversationRecoveryManifestVersion ||
        runnerVersion != legacyConversationRecoveryRunnerVersion ||
        artifactSchema != legacyConversationRecoveryArtifactSchema ||
        environment != 'development' ||
        remoteAuthorization != 'NOT_GRANTED' ||
        remoteExecution != 'NOT_EXECUTED' ||
        currentAuthorizedCommit != 'UNASSIGNED') {
      findings.add('LEGACY_RECOVERY_MANIFEST_BINDING_INVALID');
    }
    if (subjectRun.validate(expected: expectedLegacySubjectRun()).isNotEmpty) {
      findings.add('LEGACY_RECOVERY_SUBJECT_RUN_INVALID');
    }
    const expectedEvidence = {
      'artifactV2Integrity': 'VALID',
      'subjectRunBinding': 'EXACT_AND_AVAILABLE',
      'conversationHandle': 'EXACT_BUT_NOT_AVAILABLE',
      'ownerHandle': 'EXACT_BUT_NOT_AVAILABLE',
      'runAlias': 'EXACT_BUT_NOT_AVAILABLE',
      'idempotencyRecord': 'EXACTLY_ZERO_PREVIOUSLY_OBSERVED',
      'futureR2ILedgerApplicable': false,
    };
    if (historicalEvidence.length != expectedEvidence.length ||
        expectedEvidence.entries.any(
          (entry) => historicalEvidence[entry.key] != entry.value,
        )) {
      findings.add('LEGACY_RECOVERY_EVIDENCE_INVALID');
    }
    if (candidates.isEmpty ||
        candidates.map((candidate) => candidate.name).toSet().length !=
            candidates.length ||
        candidates.any((candidate) => candidate.canAuthorizeLookup)) {
      findings.add('LEGACY_RECOVERY_CANDIDATE_MATRIX_INVALID');
    }
    if (strategies.isEmpty ||
        strategies.map((strategy) => strategy.name).toSet().length !=
            strategies.length ||
        strategies.any((strategy) => strategy.isAdmissible)) {
      findings.add('LEGACY_RECOVERY_STRATEGY_MATRIX_INVALID');
    }
    if (selectedPrimaryStrategy != 'NONE_NO_EXACT_HISTORICAL_KEY' ||
        selectedSecondaryStrategy != 'NONE' ||
        permittedQueryShape != 'NONE' ||
        maximumRequestCount != 0 ||
        maximumResultCardinality != 0 ||
        deleteEnabled ||
        !diagnosticOnly ||
        messagesPolicy != 'UNKNOWN_BLOCKING_UNTIL_EXACT_CONVERSATION_PROOF' ||
        sessionsPolicy != 'UNKNOWN_BLOCKING_UNTIL_EXACT_CONVERSATION_PROOF' ||
        !canonicalResourcesProtected ||
        !cliIsolationRequired) {
      findings.add('LEGACY_RECOVERY_EXECUTION_MUST_REMAIN_BLOCKED');
    }
    const requiredStops = {
      'NO_EXACT_HISTORICAL_KEY',
      'AMBIGUOUS_RESULT',
      'FOREIGN_OWNER',
      'QUERY_ERROR',
      'PARTIAL_RESPONSE',
      'PAGINATION_PRESENT',
      'BUDGET_EXCEEDED',
      'DELETE_ATTEMPTED',
      'BROAD_LOOKUP_ATTEMPTED',
    };
    if (!stopConditions.containsAll(requiredStops) ||
        stopConditions.length != requiredStops.length) {
      findings.add('LEGACY_RECOVERY_STOP_CONDITIONS_INVALID');
    }
    return findings;
  }
}

FounderAuthorizationSubjectRun expectedLegacySubjectRun() =>
    const FounderAuthorizationSubjectRun(
      authorizationReference: legacyFailedAuthorizationReference,
      commitSha: legacyFailedCommit,
      manifest: legacyFailedManifest,
      runner: legacyFailedRunner,
      result: legacyFailedResult,
      lastReachedState: legacyFailedLastState,
      failureCategory: legacyFailedCategory,
    );

final class LegacyConversationOwnershipProof {
  LegacyConversationOwnershipProof.validated({
    required this.lookupStrategy,
    required String conversationHandle,
    required String ownerHandle,
    required String runBinding,
    required this.subjectRun,
    required this.ownership,
    required this.resourceClassification,
    required this.cleanupEligible,
  }) : _conversationHandle = conversationHandle,
       _ownerHandle = ownerHandle,
       _runBinding = runBinding {
    if (lookupStrategy != 'EXACT_CANONICAL_ID' ||
        !_uuidPattern.hasMatch(conversationHandle) ||
        !_uuidPattern.hasMatch(ownerHandle) ||
        runBinding.isEmpty ||
        subjectRun.validate(expected: expectedLegacySubjectRun()).isNotEmpty ||
        ownership != 'CREATED_BY_RUN' ||
        resourceClassification != 'NON_CANONICAL' ||
        !cleanupEligible) {
      throw const FormatException('LEGACY_CONVERSATION_OWNERSHIP_NOT_PROVEN');
    }
  }

  final String lookupStrategy;
  final String _conversationHandle;
  final String _ownerHandle;
  final String _runBinding;
  final FounderAuthorizationSubjectRun subjectRun;
  final String ownership;
  final String resourceClassification;
  final bool cleanupEligible;

  T useConversationHandle<T>(T Function(String value) operation) =>
      operation(_conversationHandle);

  T useOwnerHandle<T>(T Function(String value) operation) =>
      operation(_ownerHandle);

  T useRunBinding<T>(T Function(String value) operation) =>
      operation(_runBinding);

  @override
  String toString() => 'LegacyConversationOwnershipProof(<redacted>)';
}

final RegExp _uuidPattern = RegExp(
  r'^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
  caseSensitive: false,
);

final class LegacyLookupRow {
  const LegacyLookupRow({
    required this.conversationHandle,
    required this.ownerHandle,
    required this.runBinding,
    required this.resourceType,
    required this.resourceClassification,
    required this.ownership,
  });

  final String conversationHandle;
  final String ownerHandle;
  final String runBinding;
  final String resourceType;
  final String resourceClassification;
  final String ownership;
}

final class LegacyLookupAssessment {
  const LegacyLookupAssessment({
    required this.cardinality,
    required this.result,
    this.proof,
  });

  final LegacyLookupCardinality cardinality;
  final LegacyConversationRecoveryResult result;
  final LegacyConversationOwnershipProof? proof;
}

LegacyLookupAssessment assessLegacyLookup({
  required int status,
  required List<LegacyLookupRow>? rows,
  required bool responseComplete,
  required bool paginationPresent,
  required bool exactLookupContract,
  required bool status404MeansExactAbsence,
  required String expectedOwnerHandle,
  required String expectedRunBinding,
}) {
  if (!exactLookupContract ||
      !responseComplete ||
      paginationPresent ||
      rows == null) {
    return const LegacyLookupAssessment(
      cardinality: LegacyLookupCardinality.contractInsufficient,
      result: LegacyConversationRecoveryResult.exactRecoveryUnavailable,
    );
  }
  if (status == 404 && status404MeansExactAbsence) {
    return const LegacyLookupAssessment(
      cardinality: LegacyLookupCardinality.exactlyZero,
      result: LegacyConversationRecoveryResult.exactlyAbsent,
    );
  }
  if (status != 200) {
    return const LegacyLookupAssessment(
      cardinality: LegacyLookupCardinality.queryFailed,
      result: LegacyConversationRecoveryResult.lookupFailed,
    );
  }
  if (rows.isEmpty) {
    return const LegacyLookupAssessment(
      cardinality: LegacyLookupCardinality.exactlyZero,
      result: LegacyConversationRecoveryResult.exactlyAbsent,
    );
  }
  if (rows.length != 1) {
    return const LegacyLookupAssessment(
      cardinality: LegacyLookupCardinality.ambiguous,
      result: LegacyConversationRecoveryResult.ambiguous,
    );
  }
  final row = rows.single;
  if (row.ownerHandle != expectedOwnerHandle) {
    return const LegacyLookupAssessment(
      cardinality: LegacyLookupCardinality.foreign,
      result: LegacyConversationRecoveryResult.foreign,
    );
  }
  if (row.runBinding != expectedRunBinding ||
      row.resourceType != 'Conversation' ||
      row.resourceClassification != 'NON_CANONICAL' ||
      row.ownership != 'CREATED_BY_RUN') {
    return const LegacyLookupAssessment(
      cardinality: LegacyLookupCardinality.contractInsufficient,
      result: LegacyConversationRecoveryResult.exactRecoveryUnavailable,
    );
  }
  try {
    final proof = LegacyConversationOwnershipProof.validated(
      lookupStrategy: 'EXACT_CANONICAL_ID',
      conversationHandle: row.conversationHandle,
      ownerHandle: row.ownerHandle,
      runBinding: row.runBinding,
      subjectRun: expectedLegacySubjectRun(),
      ownership: row.ownership,
      resourceClassification: row.resourceClassification,
      cleanupEligible: true,
    );
    return LegacyLookupAssessment(
      cardinality: LegacyLookupCardinality.exactlyOne,
      result: LegacyConversationRecoveryResult.exactlyIdentified,
      proof: proof,
    );
  } on FormatException {
    return const LegacyLookupAssessment(
      cardinality: LegacyLookupCardinality.contractInsufficient,
      result: LegacyConversationRecoveryResult.exactRecoveryUnavailable,
    );
  }
}

final class LegacyRecoveryRequestBudget {
  LegacyRecoveryRequestBudget({required this.maximumRequests})
    : _remaining = maximumRequests {
    if (maximumRequests < 0 || maximumRequests > 3) {
      throw const FormatException('LEGACY_RECOVERY_REQUEST_BUDGET_INVALID');
    }
  }

  final int maximumRequests;
  int _remaining;

  int get remaining => _remaining;

  void authorize({
    required String action,
    bool pagination = false,
    bool fallback = false,
    bool broadLookup = false,
    bool delete = false,
  }) {
    if (pagination ||
        fallback ||
        broadLookup ||
        delete ||
        !{
          'TARGET_VERIFICATION',
          'EXACT_CONVERSATION_LOOKUP',
          'EXACT_OWNERSHIP_VERIFICATION',
        }.contains(action) ||
        _remaining == 0) {
      throw StateError('LEGACY_RECOVERY_REQUEST_BUDGET_BLOCKED');
    }
    _remaining--;
  }
}

String classifyLegacyMessagesPolicy({
  required LegacyConversationRecoveryResult conversationResult,
  required bool cascadeGuaranteed,
  required bool exactLookupCompleted,
}) {
  if (conversationResult ==
          LegacyConversationRecoveryResult.exactlyIdentified &&
      exactLookupCompleted) {
    return 'EXACT_MESSAGES_LOOKUP_ALLOWED';
  }
  if (conversationResult == LegacyConversationRecoveryResult.exactlyAbsent &&
      cascadeGuaranteed) {
    return 'MESSAGES_ZERO_BY_SCHEMA_DEPENDENCY';
  }
  return 'MESSAGES_UNKNOWN_BLOCKING';
}

String classifyLegacySessionsPolicy({
  required LegacyConversationRecoveryResult conversationResult,
  required bool exactSessionKeyAvailable,
}) {
  if (conversationResult ==
          LegacyConversationRecoveryResult.exactlyIdentified &&
      exactSessionKeyAvailable) {
    return 'EXACT_SESSION_LOOKUP_AVAILABLE';
  }
  if (conversationResult == LegacyConversationRecoveryResult.exactlyAbsent) {
    return 'SESSION_PROVEN_ABSENT_BY_EXACT_CONVERSATION_PROOF';
  }
  return exactSessionKeyAvailable
      ? 'EXACT_SESSION_LOOKUP_AVAILABLE'
      : 'SESSION_REMAINS_UNKNOWN';
}

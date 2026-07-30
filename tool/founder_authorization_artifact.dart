import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

const founderAuthorizationSchemaVersion = 'founder-authorization-v1';
const founderAuthorizationSchemaVersionV2 = 'founder-authorization-v2';
final _authorizationIdPattern = RegExp(r'^[A-Za-z0-9][A-Za-z0-9_-]{2,127}$');
final _contractValuePattern = RegExp(r'^[A-Za-z0-9][A-Za-z0-9._-]{1,159}$');
final _subjectResultPattern = RegExp(r'^[A-Z0-9][A-Z0-9 _-]{1,199}$');
final _failedRunOperationPattern = RegExp(
  r'(^|_)FAILED_RUN_(DIAGNOSTIC|CONTAINMENT|DIAGNOSTIC_AND_CONTAINMENT|FORENSIC_REVIEW)$',
);

bool founderAuthorizationOperationRequiresSubjectRun(String operation) =>
    _failedRunOperationPattern.hasMatch(operation);

enum FounderAuthorizationStatus {
  granted('GRANTED'),
  consumed('CONSUMED'),
  revoked('REVOKED'),
  expired('EXPIRED'),
  invalid('INVALID');

  const FounderAuthorizationStatus(this.value);

  final String value;

  static FounderAuthorizationStatus parse(String value) =>
      FounderAuthorizationStatus.values.firstWhere(
        (status) => status.value == value,
        orElse: () => invalid,
      );
}

final class FounderAuthorizationException implements Exception {
  const FounderAuthorizationException(this.code);

  final String code;

  @override
  String toString() => code;
}

class FounderAuthorizationProposalV1 {
  const FounderAuthorizationProposalV1({
    required this.authorizationId,
    required this.decision,
    required this.decisionSource,
    required this.authorizedOperation,
    required this.authorizedEnvironment,
    required this.authorizedManifest,
    required this.authorizedRunner,
    required this.scope,
    this.maxRemoteExecutions = 1,
    this.validFor = const Duration(hours: 2),
  });

  final String authorizationId;
  final String decision;
  final String decisionSource;
  final String authorizedOperation;
  final String authorizedEnvironment;
  final String authorizedManifest;
  final String authorizedRunner;
  final String scope;
  final int maxRemoteExecutions;
  final Duration validFor;
}

final class FounderAuthorizationSubjectRun {
  const FounderAuthorizationSubjectRun({
    required this.authorizationReference,
    required this.commitSha,
    required this.manifest,
    required this.runner,
    required this.result,
    required this.lastReachedState,
    required this.failureCategory,
  });

  factory FounderAuthorizationSubjectRun.fromJson(Map<String, Object?> json) {
    const fields = {
      'authorization_reference',
      'commit_sha',
      'manifest',
      'runner',
      'result',
      'last_reached_state',
      'failure_category',
    };
    if (json.keys.toSet().difference(fields).isNotEmpty) {
      throw const FounderAuthorizationException(
        'AUTHORIZATION_SUBJECT_RUN_UNKNOWN_FIELD',
      );
    }
    if (!json.keys.toSet().containsAll(fields)) {
      throw const FounderAuthorizationException(
        'AUTHORIZATION_SUBJECT_RUN_REQUIRED_FIELD_MISSING',
      );
    }
    String text(String key) {
      final value = json[key];
      if (value is! String || value.isEmpty) {
        throw const FounderAuthorizationException(
          'AUTHORIZATION_SUBJECT_RUN_FIELD_INVALID',
        );
      }
      return value;
    }

    return FounderAuthorizationSubjectRun(
      authorizationReference: text('authorization_reference'),
      commitSha: text('commit_sha'),
      manifest: text('manifest'),
      runner: text('runner'),
      result: text('result'),
      lastReachedState: text('last_reached_state'),
      failureCategory: text('failure_category'),
    );
  }

  final String authorizationReference;
  final String commitSha;
  final String manifest;
  final String runner;
  final String result;
  final String lastReachedState;
  final String failureCategory;

  Map<String, Object?> toJson() => {
    'authorization_reference': authorizationReference,
    'commit_sha': commitSha,
    'manifest': manifest,
    'runner': runner,
    'result': result,
    'last_reached_state': lastReachedState,
    'failure_category': failureCategory,
  };

  List<String> validate({FounderAuthorizationSubjectRun? expected}) {
    final findings = <String>[];
    if (!_authorizationIdPattern.hasMatch(authorizationReference) ||
        !RegExp(r'^[0-9a-f]{40}$').hasMatch(commitSha) ||
        !_contractValuePattern.hasMatch(manifest) ||
        !_contractValuePattern.hasMatch(runner) ||
        !_subjectResultPattern.hasMatch(result) ||
        !_contractValuePattern.hasMatch(lastReachedState) ||
        !_contractValuePattern.hasMatch(failureCategory)) {
      findings.add('AUTHORIZATION_SUBJECT_RUN_BINDING_INVALID');
    }
    if (expected == null) return findings;
    if (authorizationReference != expected.authorizationReference) {
      findings.add('SUBJECT_RUN_AUTHORIZATION_MISMATCH');
    }
    if (commitSha != expected.commitSha) {
      findings.add('SUBJECT_RUN_COMMIT_MISMATCH');
    }
    if (manifest != expected.manifest) {
      findings.add('SUBJECT_RUN_MANIFEST_MISMATCH');
    }
    if (runner != expected.runner) {
      findings.add('SUBJECT_RUN_RUNNER_MISMATCH');
    }
    if (result != expected.result) {
      findings.add('SUBJECT_RUN_RESULT_MISMATCH');
    }
    if (lastReachedState != expected.lastReachedState) {
      findings.add('SUBJECT_RUN_LAST_STATE_MISMATCH');
    }
    if (failureCategory != expected.failureCategory) {
      findings.add('SUBJECT_RUN_FAILURE_CATEGORY_MISMATCH');
    }
    return findings;
  }

  bool matches(FounderAuthorizationSubjectRun other) =>
      canonicalJson(toJson()) == canonicalJson(other.toJson());
}

final class FounderAuthorizationProposalV2
    extends FounderAuthorizationProposalV1 {
  const FounderAuthorizationProposalV2({
    required super.authorizationId,
    required super.decision,
    required super.decisionSource,
    required super.authorizedOperation,
    required super.authorizedEnvironment,
    required super.authorizedManifest,
    required super.authorizedRunner,
    required super.scope,
    required this.subjectRun,
    super.maxRemoteExecutions,
    super.validFor,
  });

  final FounderAuthorizationSubjectRun subjectRun;
}

class FounderAuthorizationArtifactV1 {
  FounderAuthorizationArtifactV1({
    required this.schemaVersion,
    required this.authorizationId,
    required this.decision,
    required this.decisionSource,
    required this.authorizedOperation,
    required this.authorizedEnvironment,
    required this.authorizedCommitSha,
    required this.authorizedManifest,
    required this.authorizedRunner,
    required this.scope,
    required this.maxRemoteExecutions,
    required this.remoteExecutionCount,
    required this.status,
    required this.createdAt,
    required this.expiresAt,
    required this.consumptionTrigger,
    required this.payloadSha256,
    this.consumedAt,
    this.revokedAt,
    this.expiredAt,
    this.finalClassification,
    this.completedAt,
    this.remoteContextFinal,
  });

  factory FounderAuthorizationArtifactV1.granted({
    required FounderAuthorizationProposalV1 proposal,
    required String commitSha,
    required DateTime now,
  }) {
    final artifact = FounderAuthorizationArtifactV1(
      schemaVersion: founderAuthorizationSchemaVersion,
      authorizationId: proposal.authorizationId,
      decision: proposal.decision,
      decisionSource: proposal.decisionSource,
      authorizedOperation: proposal.authorizedOperation,
      authorizedEnvironment: proposal.authorizedEnvironment,
      authorizedCommitSha: commitSha,
      authorizedManifest: proposal.authorizedManifest,
      authorizedRunner: proposal.authorizedRunner,
      scope: proposal.scope,
      maxRemoteExecutions: proposal.maxRemoteExecutions,
      remoteExecutionCount: 0,
      status: FounderAuthorizationStatus.granted,
      createdAt: now.toUtc(),
      expiresAt: now.toUtc().add(proposal.validFor),
      consumptionTrigger: 'FIRST_REMOTE_ACTION',
      payloadSha256: '',
    );
    return artifact.withRecalculatedHash();
  }

  factory FounderAuthorizationArtifactV1.fromJson(Map<String, Object?> json) {
    if (json['schema_version'] == founderAuthorizationSchemaVersionV2) {
      return FounderAuthorizationArtifactV2.fromJson(json);
    }
    const requiredFields = {
      'schema_version',
      'authorization_id',
      'decision',
      'decision_source',
      'authorized_operation',
      'authorized_environment',
      'authorized_commit_sha',
      'authorized_manifest',
      'authorized_runner',
      'scope',
      'max_remote_executions',
      'remote_execution_count',
      'status',
      'created_at',
      'expires_at',
      'consumption_trigger',
      'payload_sha256',
    };
    const optionalFields = {
      'consumed_at',
      'revoked_at',
      'expired_at',
      'final_classification',
      'completed_at',
      'remote_context_final',
    };
    if (!json.keys.toSet().containsAll(requiredFields)) {
      throw const FounderAuthorizationException(
        'AUTHORIZATION_REQUIRED_FIELD_MISSING',
      );
    }
    if (json.keys.any(
      (key) => !requiredFields.contains(key) && !optionalFields.contains(key),
    )) {
      throw const FounderAuthorizationException('AUTHORIZATION_UNKNOWN_FIELD');
    }

    String text(String key) {
      final value = json[key];
      if (value is! String || value.isEmpty) {
        throw const FounderAuthorizationException(
          'AUTHORIZATION_FIELD_INVALID',
        );
      }
      return value;
    }

    DateTime timestamp(String key) {
      final parsed = DateTime.tryParse(text(key));
      if (parsed == null || !parsed.isUtc) {
        throw const FounderAuthorizationException(
          'AUTHORIZATION_TIMESTAMP_INVALID',
        );
      }
      return parsed;
    }

    DateTime? optionalTimestamp(String key) {
      if (!json.containsKey(key)) return null;
      return timestamp(key);
    }

    final maxExecutions = json['max_remote_executions'];
    final executionCount = json['remote_execution_count'];
    if (maxExecutions is! int ||
        maxExecutions < 1 ||
        executionCount is! int ||
        executionCount < 0) {
      throw const FounderAuthorizationException(
        'AUTHORIZATION_EXECUTION_COUNT_INVALID',
      );
    }
    return FounderAuthorizationArtifactV1(
      schemaVersion: text('schema_version'),
      authorizationId: text('authorization_id'),
      decision: text('decision'),
      decisionSource: text('decision_source'),
      authorizedOperation: text('authorized_operation'),
      authorizedEnvironment: text('authorized_environment'),
      authorizedCommitSha: text('authorized_commit_sha'),
      authorizedManifest: text('authorized_manifest'),
      authorizedRunner: text('authorized_runner'),
      scope: text('scope'),
      maxRemoteExecutions: maxExecutions,
      remoteExecutionCount: executionCount,
      status: FounderAuthorizationStatus.parse(text('status')),
      createdAt: timestamp('created_at'),
      expiresAt: timestamp('expires_at'),
      consumptionTrigger: text('consumption_trigger'),
      payloadSha256: text('payload_sha256'),
      consumedAt: optionalTimestamp('consumed_at'),
      revokedAt: optionalTimestamp('revoked_at'),
      expiredAt: optionalTimestamp('expired_at'),
      finalClassification: json['final_classification'] as String?,
      completedAt: optionalTimestamp('completed_at'),
      remoteContextFinal: json['remote_context_final'] as String?,
    );
  }

  final String schemaVersion;
  final String authorizationId;
  final String decision;
  final String decisionSource;
  final String authorizedOperation;
  final String authorizedEnvironment;
  final String authorizedCommitSha;
  final String authorizedManifest;
  final String authorizedRunner;
  final String scope;
  final int maxRemoteExecutions;
  final int remoteExecutionCount;
  final FounderAuthorizationStatus status;
  final DateTime createdAt;
  final DateTime expiresAt;
  final String consumptionTrigger;
  final String payloadSha256;
  final DateTime? consumedAt;
  final DateTime? revokedAt;
  final DateTime? expiredAt;
  final String? finalClassification;
  final DateTime? completedAt;
  final String? remoteContextFinal;

  String get supportedSchemaVersion => founderAuthorizationSchemaVersion;
  FounderAuthorizationSubjectRun? get subjectRun => null;

  Map<String, Object?> toJson({bool includeHash = true}) => {
    'schema_version': schemaVersion,
    'authorization_id': authorizationId,
    'decision': decision,
    'decision_source': decisionSource,
    'authorized_operation': authorizedOperation,
    'authorized_environment': authorizedEnvironment,
    'authorized_commit_sha': authorizedCommitSha,
    'authorized_manifest': authorizedManifest,
    'authorized_runner': authorizedRunner,
    'scope': scope,
    'max_remote_executions': maxRemoteExecutions,
    'remote_execution_count': remoteExecutionCount,
    'status': status.value,
    'created_at': createdAt.toUtc().toIso8601String(),
    'expires_at': expiresAt.toUtc().toIso8601String(),
    'consumption_trigger': consumptionTrigger,
    if (consumedAt != null)
      'consumed_at': consumedAt!.toUtc().toIso8601String(),
    if (revokedAt != null) 'revoked_at': revokedAt!.toUtc().toIso8601String(),
    if (expiredAt != null) 'expired_at': expiredAt!.toUtc().toIso8601String(),
    if (finalClassification != null)
      'final_classification': finalClassification,
    if (completedAt != null)
      'completed_at': completedAt!.toUtc().toIso8601String(),
    if (remoteContextFinal != null) 'remote_context_final': remoteContextFinal,
    if (includeHash) 'payload_sha256': payloadSha256,
  };

  FounderAuthorizationArtifactV1 copyWith({
    FounderAuthorizationStatus? status,
    int? remoteExecutionCount,
    DateTime? consumedAt,
    DateTime? revokedAt,
    DateTime? expiredAt,
    String? finalClassification,
    DateTime? completedAt,
    String? remoteContextFinal,
    String? payloadSha256,
  }) => FounderAuthorizationArtifactV1(
    schemaVersion: schemaVersion,
    authorizationId: authorizationId,
    decision: decision,
    decisionSource: decisionSource,
    authorizedOperation: authorizedOperation,
    authorizedEnvironment: authorizedEnvironment,
    authorizedCommitSha: authorizedCommitSha,
    authorizedManifest: authorizedManifest,
    authorizedRunner: authorizedRunner,
    scope: scope,
    maxRemoteExecutions: maxRemoteExecutions,
    remoteExecutionCount: remoteExecutionCount ?? this.remoteExecutionCount,
    status: status ?? this.status,
    createdAt: createdAt,
    expiresAt: expiresAt,
    consumptionTrigger: consumptionTrigger,
    payloadSha256: payloadSha256 ?? this.payloadSha256,
    consumedAt: consumedAt ?? this.consumedAt,
    revokedAt: revokedAt ?? this.revokedAt,
    expiredAt: expiredAt ?? this.expiredAt,
    finalClassification: finalClassification ?? this.finalClassification,
    completedAt: completedAt ?? this.completedAt,
    remoteContextFinal: remoteContextFinal ?? this.remoteContextFinal,
  );

  FounderAuthorizationArtifactV1 withRecalculatedHash() => copyWith(
    payloadSha256: sha256Hex(canonicalJson(toJson(includeHash: false))),
  );

  bool get hasValidHash =>
      payloadSha256 == sha256Hex(canonicalJson(toJson(includeHash: false)));

  List<String> validate({
    required DateTime now,
    String? expectedAuthorizationId,
    String? expectedOperation,
    String? expectedEnvironment,
    String? expectedCommitSha,
    String? expectedManifest,
    String? expectedRunner,
    FounderAuthorizationSubjectRun? expectedSubjectRun,
    bool requireGranted = true,
  }) {
    final findings = <String>[];
    if (schemaVersion != supportedSchemaVersion) {
      findings.add('AUTHORIZATION_SCHEMA_MISMATCH');
    }
    if (!_authorizationIdPattern.hasMatch(authorizationId)) {
      findings.add('AUTHORIZATION_ID_INVALID');
    }
    if (decision != 'APPROVED') {
      findings.add('AUTHORIZATION_DECISION_NOT_APPROVED');
    }
    if (status == FounderAuthorizationStatus.invalid) {
      findings.add('AUTHORIZATION_STATUS_INVALID');
    }
    if (expectedAuthorizationId != null &&
        authorizationId != expectedAuthorizationId) {
      findings.add('AUTHORIZATION_ID_MISMATCH');
    }
    if (expectedOperation != null && authorizedOperation != expectedOperation) {
      findings.add('AUTHORIZATION_OPERATION_MISMATCH');
    }
    if (expectedEnvironment != null &&
        authorizedEnvironment != expectedEnvironment) {
      findings.add('AUTHORIZATION_ENVIRONMENT_MISMATCH');
    }
    if (expectedCommitSha != null && authorizedCommitSha != expectedCommitSha) {
      findings.add('AUTHORIZATION_COMMIT_MISMATCH');
    }
    if (expectedManifest != null && authorizedManifest != expectedManifest) {
      findings.add('AUTHORIZATION_MANIFEST_MISMATCH');
    }
    if (expectedRunner != null && authorizedRunner != expectedRunner) {
      findings.add('AUTHORIZATION_RUNNER_MISMATCH');
    }
    final requiresSubjectRun = founderAuthorizationOperationRequiresSubjectRun(
      authorizedOperation,
    );
    if (requiresSubjectRun && subjectRun == null) {
      findings.add(
        schemaVersion == founderAuthorizationSchemaVersion
            ? 'AUTHORIZATION_SCHEMA_VERSION_INSUFFICIENT'
            : 'AUTHORIZATION_SUBJECT_RUN_REQUIRED',
      );
    }
    if (!requiresSubjectRun && subjectRun != null) {
      findings.add('AUTHORIZATION_SUBJECT_RUN_FORBIDDEN');
    }
    if (expectedSubjectRun != null && subjectRun == null) {
      findings.add('AUTHORIZATION_FAILED_RUN_BINDINGS_MISSING');
    }
    if (subjectRun != null) {
      findings.addAll(subjectRun!.validate(expected: expectedSubjectRun));
    }
    if (!hasValidHash) findings.add('AUTHORIZATION_PAYLOAD_HASH_MISMATCH');
    if (!expiresAt.isAfter(createdAt) ||
        expiresAt.difference(createdAt) > const Duration(hours: 2)) {
      findings.add('AUTHORIZATION_EXPIRY_INVALID');
    } else if (!expiresAt.isAfter(now.toUtc())) {
      findings.add('AUTHORIZATION_EXPIRED');
    }
    if (!_contractValuePattern.hasMatch(decisionSource) ||
        !_contractValuePattern.hasMatch(authorizedOperation) ||
        !_contractValuePattern.hasMatch(authorizedEnvironment) ||
        !_contractValuePattern.hasMatch(authorizedManifest) ||
        !_contractValuePattern.hasMatch(authorizedRunner) ||
        !_contractValuePattern.hasMatch(scope) ||
        !RegExp(r'^[0-9a-f]{40}$').hasMatch(authorizedCommitSha)) {
      findings.add('AUTHORIZATION_BINDING_INVALID');
    }
    if (maxRemoteExecutions != 1) {
      findings.add('AUTHORIZATION_EXECUTION_LIMIT_MISMATCH');
    }
    if (requireGranted && status != FounderAuthorizationStatus.granted) {
      findings.add(
        status == FounderAuthorizationStatus.consumed
            ? 'AUTHORIZATION_ALREADY_CONSUMED'
            : 'AUTHORIZATION_STATUS_NOT_GRANTED',
      );
    }
    if (remoteExecutionCount >= maxRemoteExecutions) {
      findings.add('AUTHORIZATION_EXECUTION_COUNT_EXCEEDED');
    }
    if (status == FounderAuthorizationStatus.granted &&
        remoteExecutionCount != 0) {
      findings.add('AUTHORIZATION_GRANTED_COUNT_INVALID');
    }
    if (consumptionTrigger != 'FIRST_REMOTE_ACTION') {
      findings.add('AUTHORIZATION_CONSUMPTION_TRIGGER_MISMATCH');
    }
    return findings;
  }
}

final class FounderAuthorizationArtifactV2
    extends FounderAuthorizationArtifactV1 {
  FounderAuthorizationArtifactV2({
    required super.authorizationId,
    required super.decision,
    required super.decisionSource,
    required super.authorizedOperation,
    required super.authorizedEnvironment,
    required super.authorizedCommitSha,
    required super.authorizedManifest,
    required super.authorizedRunner,
    required super.scope,
    required super.maxRemoteExecutions,
    required super.remoteExecutionCount,
    required super.status,
    required super.createdAt,
    required super.expiresAt,
    required super.consumptionTrigger,
    required super.payloadSha256,
    required this.boundSubjectRun,
    super.consumedAt,
    super.revokedAt,
    super.expiredAt,
    super.finalClassification,
    super.completedAt,
    super.remoteContextFinal,
  }) : super(schemaVersion: founderAuthorizationSchemaVersionV2);

  factory FounderAuthorizationArtifactV2.granted({
    required FounderAuthorizationProposalV2 proposal,
    required String commitSha,
    required DateTime now,
  }) {
    final artifact = FounderAuthorizationArtifactV2(
      authorizationId: proposal.authorizationId,
      decision: proposal.decision,
      decisionSource: proposal.decisionSource,
      authorizedOperation: proposal.authorizedOperation,
      authorizedEnvironment: proposal.authorizedEnvironment,
      authorizedCommitSha: commitSha,
      authorizedManifest: proposal.authorizedManifest,
      authorizedRunner: proposal.authorizedRunner,
      scope: proposal.scope,
      maxRemoteExecutions: proposal.maxRemoteExecutions,
      remoteExecutionCount: 0,
      status: FounderAuthorizationStatus.granted,
      createdAt: now.toUtc(),
      expiresAt: now.toUtc().add(proposal.validFor),
      consumptionTrigger: 'FIRST_REMOTE_ACTION',
      payloadSha256: '',
      boundSubjectRun: proposal.subjectRun,
    );
    return artifact.withRecalculatedHash();
  }

  factory FounderAuthorizationArtifactV2.fromJson(Map<String, Object?> json) {
    const allowedFields = {
      'schema_version',
      'authorization_id',
      'decision',
      'decision_source',
      'authorized_operation',
      'authorized_environment',
      'authorized_commit_sha',
      'authorized_manifest',
      'authorized_runner',
      'scope',
      'max_remote_executions',
      'remote_execution_count',
      'status',
      'created_at',
      'expires_at',
      'consumption_trigger',
      'payload_sha256',
      'subject_run',
      'consumed_at',
      'revoked_at',
      'expired_at',
      'final_classification',
      'completed_at',
      'remote_context_final',
    };
    if (json.keys.toSet().difference(allowedFields).isNotEmpty) {
      throw const FounderAuthorizationException('AUTHORIZATION_UNKNOWN_FIELD');
    }
    if (json['schema_version'] != founderAuthorizationSchemaVersionV2) {
      throw const FounderAuthorizationException(
        'AUTHORIZATION_SCHEMA_MISMATCH',
      );
    }
    if (!json.containsKey('subject_run')) {
      throw const FounderAuthorizationException(
        'AUTHORIZATION_SUBJECT_RUN_REQUIRED',
      );
    }
    final rawSubjectRun = json['subject_run'];
    if (rawSubjectRun is! Map<String, Object?>) {
      throw const FounderAuthorizationException(
        'AUTHORIZATION_SUBJECT_RUN_INVALID',
      );
    }
    final commonJson = Map<String, Object?>.from(json)
      ..remove('subject_run')
      ..['schema_version'] = founderAuthorizationSchemaVersion;
    final common = FounderAuthorizationArtifactV1.fromJson(commonJson);
    return FounderAuthorizationArtifactV2(
      authorizationId: common.authorizationId,
      decision: common.decision,
      decisionSource: common.decisionSource,
      authorizedOperation: common.authorizedOperation,
      authorizedEnvironment: common.authorizedEnvironment,
      authorizedCommitSha: common.authorizedCommitSha,
      authorizedManifest: common.authorizedManifest,
      authorizedRunner: common.authorizedRunner,
      scope: common.scope,
      maxRemoteExecutions: common.maxRemoteExecutions,
      remoteExecutionCount: common.remoteExecutionCount,
      status: common.status,
      createdAt: common.createdAt,
      expiresAt: common.expiresAt,
      consumptionTrigger: common.consumptionTrigger,
      payloadSha256: common.payloadSha256,
      boundSubjectRun: FounderAuthorizationSubjectRun.fromJson(rawSubjectRun),
      consumedAt: common.consumedAt,
      revokedAt: common.revokedAt,
      expiredAt: common.expiredAt,
      finalClassification: common.finalClassification,
      completedAt: common.completedAt,
      remoteContextFinal: common.remoteContextFinal,
    );
  }

  final FounderAuthorizationSubjectRun boundSubjectRun;

  @override
  String get supportedSchemaVersion => founderAuthorizationSchemaVersionV2;

  @override
  FounderAuthorizationSubjectRun get subjectRun => boundSubjectRun;

  @override
  Map<String, Object?> toJson({bool includeHash = true}) => {
    ...super.toJson(includeHash: false),
    'schema_version': founderAuthorizationSchemaVersionV2,
    'subject_run': boundSubjectRun.toJson(),
    if (includeHash) 'payload_sha256': payloadSha256,
  };

  @override
  FounderAuthorizationArtifactV2 copyWith({
    FounderAuthorizationStatus? status,
    int? remoteExecutionCount,
    DateTime? consumedAt,
    DateTime? revokedAt,
    DateTime? expiredAt,
    String? finalClassification,
    DateTime? completedAt,
    String? remoteContextFinal,
    String? payloadSha256,
  }) => FounderAuthorizationArtifactV2(
    authorizationId: authorizationId,
    decision: decision,
    decisionSource: decisionSource,
    authorizedOperation: authorizedOperation,
    authorizedEnvironment: authorizedEnvironment,
    authorizedCommitSha: authorizedCommitSha,
    authorizedManifest: authorizedManifest,
    authorizedRunner: authorizedRunner,
    scope: scope,
    maxRemoteExecutions: maxRemoteExecutions,
    remoteExecutionCount: remoteExecutionCount ?? this.remoteExecutionCount,
    status: status ?? this.status,
    createdAt: createdAt,
    expiresAt: expiresAt,
    consumptionTrigger: consumptionTrigger,
    payloadSha256: payloadSha256 ?? this.payloadSha256,
    boundSubjectRun: boundSubjectRun,
    consumedAt: consumedAt ?? this.consumedAt,
    revokedAt: revokedAt ?? this.revokedAt,
    expiredAt: expiredAt ?? this.expiredAt,
    finalClassification: finalClassification ?? this.finalClassification,
    completedAt: completedAt ?? this.completedAt,
    remoteContextFinal: remoteContextFinal ?? this.remoteContextFinal,
  );

  @override
  FounderAuthorizationArtifactV2 withRecalculatedHash() => copyWith(
    payloadSha256: sha256Hex(canonicalJson(toJson(includeHash: false))),
  );
}

enum FounderAuthorizationSourceResolution {
  artifactOnly,
  deprecatedLegacyOnly,
  artifactMatchingLegacy,
  blockedConflict,
  missing,
}

FounderAuthorizationSourceResolution resolveAuthorizationSource({
  required FounderAuthorizationArtifactV1? artifact,
  required Map<String, String> environment,
}) {
  const legacyNames = {
    'FOUNDER_AUTHORIZATION_REFERENCE',
    'FOUNDER_CONTAINMENT_AUTHORIZATION_REFERENCE',
    'AUTHORIZED_COMMIT_SHA',
    'AUTHORIZED_COMMIT_MATCHES_HEAD',
    'CONTAINMENT_AUTHORIZATION_STATUS',
    'SECOND_FUNCTIONAL_ATTEMPT_AUTHORIZATION_STATUS',
  };
  final present = {
    for (final name in legacyNames)
      if ((environment[name] ?? '').isNotEmpty) name: environment[name]!,
  };
  if (artifact == null) {
    return present.isEmpty
        ? FounderAuthorizationSourceResolution.missing
        : FounderAuthorizationSourceResolution.deprecatedLegacyOnly;
  }
  if (present.isEmpty) return FounderAuthorizationSourceResolution.artifactOnly;
  final expected = <String, String>{
    'FOUNDER_AUTHORIZATION_REFERENCE': artifact.authorizationId,
    'FOUNDER_CONTAINMENT_AUTHORIZATION_REFERENCE': artifact.authorizationId,
    'AUTHORIZED_COMMIT_SHA': artifact.authorizedCommitSha,
    'AUTHORIZED_COMMIT_MATCHES_HEAD': 'CONFIRMED',
    'CONTAINMENT_AUTHORIZATION_STATUS': 'GRANTED_AT_RUNTIME',
  };
  final conflicts = present.entries.any(
    (entry) =>
        expected.containsKey(entry.key) && expected[entry.key] != entry.value,
  );
  return conflicts
      ? FounderAuthorizationSourceResolution.blockedConflict
      : FounderAuthorizationSourceResolution.artifactMatchingLegacy;
}

final class FounderAuthorizationStore {
  FounderAuthorizationStore({
    required this.repositoryRoot,
    DateTime Function()? clock,
    void Function(File temporary, File target)? beforeAtomicRename,
  }) : _clock = clock ?? DateTime.now,
       _beforeAtomicRename = beforeAtomicRename;

  final Directory repositoryRoot;
  final DateTime Function() _clock;
  final void Function(File temporary, File target)? _beforeAtomicRename;

  Directory get runtimeRoot =>
      Directory('${repositoryRoot.path}${Platform.pathSeparator}.runtime');
  Directory get authorizationRoot =>
      Directory('${runtimeRoot.path}${Platform.pathSeparator}authorizations');
  Directory get proposalRoot =>
      Directory('${runtimeRoot.path}${Platform.pathSeparator}proposals');
  Directory get auditRoot =>
      Directory('${runtimeRoot.path}${Platform.pathSeparator}audit');
  Directory get lockRoot =>
      Directory('${runtimeRoot.path}${Platform.pathSeparator}locks');

  File artifactFile(String authorizationId) {
    _validateAuthorizationId(authorizationId);
    return File(
      '${authorizationRoot.path}${Platform.pathSeparator}'
      '$authorizationId.json',
    );
  }

  File lockFile(String authorizationId) {
    _validateAuthorizationId(authorizationId);
    return File(
      '${lockRoot.path}${Platform.pathSeparator}$authorizationId.lock',
    );
  }

  void ensureSecureStorage() {
    for (final directory in [
      runtimeRoot,
      authorizationRoot,
      proposalRoot,
      auditRoot,
      lockRoot,
    ]) {
      directory.createSync(recursive: true);
      _chmod(directory.path, '700');
      if ((directory.statSync().mode & 0x1ff) != 0x1c0) {
        throw const FounderAuthorizationException(
          'FILESYSTEM_PERMISSION_ENFORCEMENT_UNAVAILABLE',
        );
      }
    }
  }

  void validateStorageContract() {
    const probe =
        '.runtime/authorizations/founder-authorization-ignore-probe.json';
    final ignored = Process.runSync('git', [
      'check-ignore',
      '--quiet',
      probe,
    ], workingDirectory: repositoryRoot.path);
    if (ignored.exitCode != 0) {
      throw const FounderAuthorizationException(
        'AUTHORIZATION_ARTIFACT_STORAGE_NOT_IGNORED',
      );
    }
    final tracked = Process.runSync('git', [
      'ls-files',
      '.runtime',
    ], workingDirectory: repositoryRoot.path);
    if (tracked.exitCode != 0 || (tracked.stdout as String).trim().isNotEmpty) {
      throw const FounderAuthorizationException(
        'AUTHORIZATION_RUNTIME_FILE_TRACKED',
      );
    }
  }

  FounderAuthorizationArtifactV1 grantFromProposal(
    FounderAuthorizationProposalV1 proposal, {
    required String currentCommitSha,
  }) {
    _validateProposal(proposal, currentCommitSha);
    ensureSecureStorage();
    validateStorageContract();
    final target = artifactFile(proposal.authorizationId);
    final lock = lockFile(proposal.authorizationId);
    _createExclusiveLock(lock);
    try {
      if (target.existsSync()) {
        throw const FounderAuthorizationException(
          'AUTHORIZATION_REGENERATION_BLOCKED',
        );
      }
      final artifact = proposal is FounderAuthorizationProposalV2
          ? FounderAuthorizationArtifactV2.granted(
              proposal: proposal,
              commitSha: currentCommitSha,
              now: _clock(),
            )
          : FounderAuthorizationArtifactV1.granted(
              proposal: proposal,
              commitSha: currentCommitSha,
              now: _clock(),
            );
      _atomicWrite(target, artifact);
      _appendAudit(artifact, 'GRANTED');
      return artifact;
    } finally {
      _releaseLock(lock);
    }
  }

  FounderAuthorizationArtifactV1 read(String authorizationId) {
    final file = artifactFile(authorizationId);
    if (!file.existsSync()) {
      throw const FounderAuthorizationException(
        'AUTHORIZATION_ARTIFACT_MISSING',
      );
    }
    if ((file.statSync().mode & 0x1ff) != 0x180) {
      throw const FounderAuthorizationException(
        'AUTHORIZATION_ARTIFACT_PERMISSIONS_TOO_BROAD',
      );
    }
    final decoded = jsonDecode(file.readAsStringSync());
    if (decoded is! Map<String, Object?>) {
      throw const FounderAuthorizationException(
        'AUTHORIZATION_ARTIFACT_INVALID',
      );
    }
    return FounderAuthorizationArtifactV1.fromJson(decoded);
  }

  Future<FounderAuthorizationArtifactV1> consume(
    String authorizationId, {
    required List<String> Function(FounderAuthorizationArtifactV1 artifact)
    validate,
  }) async {
    ensureSecureStorage();
    validateStorageContract();
    final lock = lockFile(authorizationId);
    RandomAccessFile? handle;
    for (var attempt = 0; attempt < 50 && handle == null; attempt++) {
      try {
        lock.createSync(exclusive: true);
        handle = lock.openSync(mode: FileMode.writeOnly);
      } on FileSystemException {
        await Future<void>.delayed(const Duration(milliseconds: 10));
      }
    }
    if (handle == null) {
      throw const FounderAuthorizationException(
        'AUTHORIZATION_LOCKED_FAIL_CLOSED',
      );
    }
    try {
      _chmod(lock.path, '600');
      handle
        ..writeStringSync('locked\n')
        ..flushSync()
        ..closeSync();
      handle = null;

      final artifact = read(authorizationId);
      final findings = validate(artifact);
      if (findings.isNotEmpty) {
        throw FounderAuthorizationException(findings.first);
      }
      final consumed = artifact
          .copyWith(
            status: FounderAuthorizationStatus.consumed,
            remoteExecutionCount: artifact.remoteExecutionCount + 1,
            consumedAt: _clock().toUtc(),
          )
          .withRecalculatedHash();
      _atomicWrite(artifactFile(authorizationId), consumed);
      _appendAudit(consumed, 'GRANTED_TO_CONSUMED');
      return consumed;
    } finally {
      handle?.closeSync();
      if (lock.existsSync()) lock.deleteSync();
    }
  }

  FounderAuthorizationArtifactV1 transitionGranted(
    String authorizationId,
    FounderAuthorizationStatus target,
  ) {
    if (!{
      FounderAuthorizationStatus.revoked,
      FounderAuthorizationStatus.expired,
    }.contains(target)) {
      throw const FounderAuthorizationException(
        'AUTHORIZATION_TRANSITION_BLOCKED',
      );
    }
    final lock = lockFile(authorizationId);
    _createExclusiveLock(lock);
    try {
      final artifact = read(authorizationId);
      if (artifact.status != FounderAuthorizationStatus.granted) {
        throw const FounderAuthorizationException(
          'AUTHORIZATION_TRANSITION_BLOCKED',
        );
      }
      final now = _clock().toUtc();
      final changed = artifact
          .copyWith(
            status: target,
            revokedAt: target == FounderAuthorizationStatus.revoked
                ? now
                : null,
            expiredAt: target == FounderAuthorizationStatus.expired
                ? now
                : null,
          )
          .withRecalculatedHash();
      _atomicWrite(artifactFile(authorizationId), changed);
      _appendAudit(changed, 'GRANTED_TO_${target.value}');
      return changed;
    } finally {
      _releaseLock(lock);
    }
  }

  FounderAuthorizationArtifactV1 completeConsumed(
    String authorizationId, {
    required String finalClassification,
    required String remoteContextFinal,
  }) {
    final lock = lockFile(authorizationId);
    _createExclusiveLock(lock);
    try {
      _chmod(lock.path, '600');
      final artifact = read(authorizationId);
      if (artifact.status != FounderAuthorizationStatus.consumed ||
          artifact.remoteExecutionCount != 1 ||
          artifact.completedAt != null) {
        throw const FounderAuthorizationException(
          'AUTHORIZATION_COMPLETION_BLOCKED',
        );
      }
      final completed = artifact
          .copyWith(
            finalClassification: finalClassification,
            completedAt: _clock().toUtc(),
            remoteContextFinal: remoteContextFinal,
          )
          .withRecalculatedHash();
      _atomicWrite(artifactFile(authorizationId), completed);
      _appendAudit(completed, 'CONSUMED_TO_COMPLETED_EVIDENCE');
      return completed;
    } finally {
      _releaseLock(lock);
    }
  }

  void _atomicWrite(File target, FounderAuthorizationArtifactV1 artifact) {
    final temporary = File(
      '${target.path}.tmp-$pid-${DateTime.now().microsecondsSinceEpoch}',
    );
    final handle = temporary.openSync(mode: FileMode.writeOnly);
    try {
      handle
        ..writeStringSync('${canonicalJson(artifact.toJson())}\n')
        ..flushSync();
    } finally {
      handle.closeSync();
    }
    _chmod(temporary.path, '600');
    try {
      _beforeAtomicRename?.call(temporary, target);
      temporary.renameSync(target.path);
    } on Object {
      if (temporary.existsSync()) temporary.deleteSync();
      rethrow;
    }
    _chmod(target.path, '600');
  }

  void _appendAudit(
    FounderAuthorizationArtifactV1 artifact,
    String transition,
  ) {
    final file = File(
      '${auditRoot.path}${Platform.pathSeparator}'
      '${artifact.authorizationId}.jsonl',
    );
    final entry = <String, Object?>{
      'authorization_id': artifact.authorizationId,
      'artifact_schema_version': artifact.schemaVersion,
      'operation_category': artifact.authorizedOperation,
      'subject_run_binding_status': artifact.subjectRun == null
          ? 'NOT_APPLICABLE'
          : transition == 'GRANTED'
          ? 'PRESENT_VALIDATED_STRUCTURALLY'
          : 'MATCHED',
      'commit_matched': true,
      'environment_matched': true,
      'manifest_matched': true,
      'runner_matched': true,
      'status_transition': transition,
      'timestamp': _clock().toUtc().toIso8601String(),
    };
    file.writeAsStringSync(
      '${canonicalJson(entry)}\n',
      mode: FileMode.append,
      flush: true,
    );
    _chmod(file.path, '600');
  }

  void _chmod(String path, String mode) {
    if (Platform.isWindows) {
      throw const FounderAuthorizationException(
        'FILESYSTEM_PERMISSION_ENFORCEMENT_UNAVAILABLE',
      );
    }
    final result = Process.runSync('chmod', [mode, path]);
    if (result.exitCode != 0) {
      throw const FounderAuthorizationException(
        'FILESYSTEM_PERMISSION_ENFORCEMENT_UNAVAILABLE',
      );
    }
  }

  void _createExclusiveLock(File lock) {
    var created = false;
    try {
      lock.createSync(exclusive: true);
      created = true;
      _chmod(lock.path, '600');
      lock.writeAsStringSync('locked\n', flush: true);
    } on FileSystemException {
      if (created && lock.existsSync()) lock.deleteSync();
      throw const FounderAuthorizationException(
        'AUTHORIZATION_LOCKED_FAIL_CLOSED',
      );
    } on Object {
      if (created && lock.existsSync()) lock.deleteSync();
      rethrow;
    }
  }

  void _releaseLock(File lock) {
    if (lock.existsSync()) lock.deleteSync();
  }

  void _validateAuthorizationId(String authorizationId) {
    if (!_authorizationIdPattern.hasMatch(authorizationId)) {
      throw const FounderAuthorizationException('AUTHORIZATION_ID_INVALID');
    }
  }

  void _validateProposal(
    FounderAuthorizationProposalV1 proposal,
    String currentCommitSha,
  ) {
    _validateAuthorizationId(proposal.authorizationId);
    if (proposal.decision != 'APPROVED' ||
        proposal.maxRemoteExecutions != 1 ||
        proposal.validFor <= Duration.zero ||
        proposal.validFor > const Duration(hours: 2) ||
        !RegExp(r'^[0-9a-f]{40}$').hasMatch(currentCommitSha) ||
        ![
          proposal.decisionSource,
          proposal.authorizedOperation,
          proposal.authorizedEnvironment,
          proposal.authorizedManifest,
          proposal.authorizedRunner,
          proposal.scope,
        ].every(_contractValuePattern.hasMatch)) {
      throw const FounderAuthorizationException(
        'AUTHORIZATION_PROPOSAL_INVALID',
      );
    }
    final requiresSubjectRun = founderAuthorizationOperationRequiresSubjectRun(
      proposal.authorizedOperation,
    );
    if (requiresSubjectRun && proposal is! FounderAuthorizationProposalV2) {
      throw const FounderAuthorizationException(
        'AUTHORIZATION_SCHEMA_VERSION_INSUFFICIENT',
      );
    }
    if (!requiresSubjectRun && proposal is FounderAuthorizationProposalV2) {
      throw const FounderAuthorizationException(
        'AUTHORIZATION_SUBJECT_RUN_FORBIDDEN',
      );
    }
    if (proposal is FounderAuthorizationProposalV2 &&
        proposal.subjectRun.validate().isNotEmpty) {
      throw const FounderAuthorizationException(
        'AUTHORIZATION_SUBJECT_RUN_BINDING_INVALID',
      );
    }
  }
}

String canonicalJson(Object? value) {
  Object? normalize(Object? current) {
    if (current is Map) {
      final keys = current.keys.cast<String>().toList()..sort();
      return <String, Object?>{
        for (final key in keys) key: normalize(current[key]),
      };
    }
    if (current is List) return current.map(normalize).toList(growable: false);
    return current;
  }

  return jsonEncode(normalize(value));
}

String sha256Hex(String input) {
  final bytes = Uint8List.fromList(utf8.encode(input));
  final bitLength = bytes.length * 8;
  final paddedLength = ((bytes.length + 9 + 63) ~/ 64) * 64;
  final padded = Uint8List(paddedLength)..setRange(0, bytes.length, bytes);
  padded[bytes.length] = 0x80;
  final data = ByteData.sublistView(padded)
    ..setUint32(paddedLength - 8, bitLength ~/ 0x100000000)
    ..setUint32(paddedLength - 4, bitLength & 0xffffffff);

  final hash = Uint32List.fromList(const [
    0x6a09e667,
    0xbb67ae85,
    0x3c6ef372,
    0xa54ff53a,
    0x510e527f,
    0x9b05688c,
    0x1f83d9ab,
    0x5be0cd19,
  ]);
  final words = Uint32List(64);
  for (var offset = 0; offset < paddedLength; offset += 64) {
    for (var index = 0; index < 16; index++) {
      words[index] = data.getUint32(offset + index * 4);
    }
    for (var index = 16; index < 64; index++) {
      final s0 =
          _rotateRight(words[index - 15], 7) ^
          _rotateRight(words[index - 15], 18) ^
          (words[index - 15] >> 3);
      final s1 =
          _rotateRight(words[index - 2], 17) ^
          _rotateRight(words[index - 2], 19) ^
          (words[index - 2] >> 10);
      words[index] =
          (words[index - 16] + s0 + words[index - 7] + s1) & 0xffffffff;
    }
    var a = hash[0];
    var b = hash[1];
    var c = hash[2];
    var d = hash[3];
    var e = hash[4];
    var f = hash[5];
    var g = hash[6];
    var h = hash[7];
    for (var index = 0; index < 64; index++) {
      final sum1 =
          _rotateRight(e, 6) ^ _rotateRight(e, 11) ^ _rotateRight(e, 25);
      final choose = (e & f) ^ ((~e) & g);
      final temp1 =
          (h + sum1 + choose + _sha256Constants[index] + words[index]) &
          0xffffffff;
      final sum0 =
          _rotateRight(a, 2) ^ _rotateRight(a, 13) ^ _rotateRight(a, 22);
      final majority = (a & b) ^ (a & c) ^ (b & c);
      final temp2 = (sum0 + majority) & 0xffffffff;
      h = g;
      g = f;
      f = e;
      e = (d + temp1) & 0xffffffff;
      d = c;
      c = b;
      b = a;
      a = (temp1 + temp2) & 0xffffffff;
    }
    hash[0] = (hash[0] + a) & 0xffffffff;
    hash[1] = (hash[1] + b) & 0xffffffff;
    hash[2] = (hash[2] + c) & 0xffffffff;
    hash[3] = (hash[3] + d) & 0xffffffff;
    hash[4] = (hash[4] + e) & 0xffffffff;
    hash[5] = (hash[5] + f) & 0xffffffff;
    hash[6] = (hash[6] + g) & 0xffffffff;
    hash[7] = (hash[7] + h) & 0xffffffff;
  }
  return hash.map((word) => word.toRadixString(16).padLeft(8, '0')).join();
}

int _rotateRight(int value, int count) =>
    ((value >> count) | (value << (32 - count))) & 0xffffffff;

const _sha256Constants = <int>[
  0x428a2f98,
  0x71374491,
  0xb5c0fbcf,
  0xe9b5dba5,
  0x3956c25b,
  0x59f111f1,
  0x923f82a4,
  0xab1c5ed5,
  0xd807aa98,
  0x12835b01,
  0x243185be,
  0x550c7dc3,
  0x72be5d74,
  0x80deb1fe,
  0x9bdc06a7,
  0xc19bf174,
  0xe49b69c1,
  0xefbe4786,
  0x0fc19dc6,
  0x240ca1cc,
  0x2de92c6f,
  0x4a7484aa,
  0x5cb0a9dc,
  0x76f988da,
  0x983e5152,
  0xa831c66d,
  0xb00327c8,
  0xbf597fc7,
  0xc6e00bf3,
  0xd5a79147,
  0x06ca6351,
  0x14292967,
  0x27b70a85,
  0x2e1b2138,
  0x4d2c6dfc,
  0x53380d13,
  0x650a7354,
  0x766a0abb,
  0x81c2c92e,
  0x92722c85,
  0xa2bfe8a1,
  0xa81a664b,
  0xc24b8b70,
  0xc76c51a3,
  0xd192e819,
  0xd6990624,
  0xf40e3585,
  0x106aa070,
  0x19a4c116,
  0x1e376c08,
  0x2748774c,
  0x34b0bcb5,
  0x391c0cb3,
  0x4ed8aa4a,
  0x5b9cca4f,
  0x682e6ff3,
  0x748f82ee,
  0x78a5636f,
  0x84c87814,
  0x8cc70208,
  0x90befffa,
  0xa4506ceb,
  0xbef9a3f7,
  0xc67178f2,
];

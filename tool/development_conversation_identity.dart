import 'dart:convert';
import 'dart:io';

import 'founder_authorization_artifact.dart' show canonicalJson, sha256Hex;

const conversationIdentitySchemaVersion =
    'foundation-019a-created-conversation-identity-v1';
const conversationIdentityOwnership = 'CREATED_BY_RUN';
const conversationCreateResponseIncomplete =
    'CONVERSATION_CREATE_RESPONSE_INCOMPLETE';
const legacyDirtyRunMissingExactConversationIdentity =
    'LEGACY_DIRTY_RUN_MISSING_EXACT_CONVERSATION_IDENTITY';

final RegExp _uuidPattern = RegExp(
  r'^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
  caseSensitive: false,
);
final RegExp _runMarkerPattern = RegExp(r'^[a-z0-9][a-z0-9-]{7,31}$');
final RegExp _operationAttemptPattern = RegExp(r'^[a-z0-9][a-z0-9_-]{7,95}$');
final RegExp _sha256Pattern = RegExp(r'^[0-9a-f]{64}$');

enum ConversationCreateResponseClassification {
  createConfirmedWithExactIdentity('CREATE_CONFIRMED_WITH_EXACT_IDENTITY'),
  createConfirmedIdentityIncomplete('CREATE_CONFIRMED_IDENTITY_INCOMPLETE'),
  createAcceptedPendingConfirmation('CREATE_ACCEPTED_PENDING_CONFIRMATION'),
  createResponseInvalid('CREATE_RESPONSE_INVALID'),
  createResponseAmbiguous('CREATE_RESPONSE_AMBIGUOUS'),
  createTransportFailureNoAcceptanceEvidence(
    'CREATE_TRANSPORT_FAILURE_NO_ACCEPTANCE_EVIDENCE',
  ),
  createTransportFailurePossiblyAccepted(
    'CREATE_TRANSPORT_FAILURE_POSSIBLY_ACCEPTED',
  );

  const ConversationCreateResponseClassification(this.evidence);

  final String evidence;
}

final class ConversationCreateResponseAssessment {
  const ConversationCreateResponseAssessment({
    required this.classification,
    this.identity,
  });

  final ConversationCreateResponseClassification classification;
  final CreatedConversationIdentity? identity;

  bool get permitsCreatedState =>
      classification ==
          ConversationCreateResponseClassification
              .createConfirmedWithExactIdentity &&
      identity != null;

  String get failureEvidence => switch (classification) {
    ConversationCreateResponseClassification
        .createConfirmedIdentityIncomplete =>
      conversationCreateResponseIncomplete,
    ConversationCreateResponseClassification.createConfirmedWithExactIdentity =>
      'CONVERSATION_CREATE_IDENTITY_EXACT',
    _ => classification.evidence,
  };
}

enum ConversationIdentityCommitState {
  initial,
  identityValidated,
  ledgerPending,
  ledgerCommitted,
  stateTransitionCommitted,
  cleanupPending,
  closed,
}

final class ConversationIdentityCommitProtocol {
  ConversationIdentityCommitState _state =
      ConversationIdentityCommitState.initial;
  CreatedConversationIdentity? _identity;

  ConversationIdentityCommitState get state => _state;
  CreatedConversationIdentity? get identity => _identity;

  void validateIdentity(CreatedConversationIdentity identity) {
    if (_state != ConversationIdentityCommitState.initial ||
        identity.validate().isNotEmpty) {
      throw StateError('CONVERSATION_IDENTITY_PROTOCOL_BLOCKED');
    }
    _identity = identity;
    _state = ConversationIdentityCommitState.identityValidated;
  }

  void markLedgerPending() {
    _advance(
      ConversationIdentityCommitState.identityValidated,
      ConversationIdentityCommitState.ledgerPending,
    );
  }

  void markLedgerCommitted(ConversationIdentityLedgerRecord record) {
    if (_identity == null ||
        !_identity!.sameIdentity(record.identity) ||
        record.lifecycle != ConversationLedgerLifecycle.resourceCreated) {
      throw StateError('CONVERSATION_IDENTITY_PROTOCOL_BLOCKED');
    }
    _advance(
      ConversationIdentityCommitState.ledgerPending,
      ConversationIdentityCommitState.ledgerCommitted,
    );
  }

  void markStateTransitionCommitted() {
    _advance(
      ConversationIdentityCommitState.ledgerCommitted,
      ConversationIdentityCommitState.stateTransitionCommitted,
    );
  }

  void beginCleanup() {
    if (_identity == null ||
        !{
          ConversationIdentityCommitState.identityValidated,
          ConversationIdentityCommitState.ledgerPending,
          ConversationIdentityCommitState.ledgerCommitted,
          ConversationIdentityCommitState.stateTransitionCommitted,
        }.contains(_state)) {
      throw StateError('CONVERSATION_IDENTITY_PROTOCOL_BLOCKED');
    }
    _state = ConversationIdentityCommitState.cleanupPending;
  }

  void close() {
    _advance(
      ConversationIdentityCommitState.cleanupPending,
      ConversationIdentityCommitState.closed,
    );
  }

  void _advance(
    ConversationIdentityCommitState expected,
    ConversationIdentityCommitState next,
  ) {
    if (_state != expected) {
      throw StateError('CONVERSATION_IDENTITY_PROTOCOL_BLOCKED');
    }
    _state = next;
  }
}

final class CreatedConversationIdentity {
  CreatedConversationIdentity._({
    required this.conversationHandle,
    required this.ownerHandle,
    required this.operationAttemptId,
    required this.runMarker,
    required this.creationRequestFingerprint,
    required this.cleanupHandle,
    required this.diagnosticLookupHandle,
    required this.ownership,
    required this.environment,
    required this.createdAt,
  });

  factory CreatedConversationIdentity.validated({
    required String conversationHandle,
    required String ownerHandle,
    required String operationAttemptId,
    required String runMarker,
    required String creationRequestFingerprint,
    required String cleanupHandle,
    required String diagnosticLookupHandle,
    required String ownership,
    required String environment,
    required DateTime createdAt,
  }) {
    final identity = CreatedConversationIdentity._(
      conversationHandle: conversationHandle,
      ownerHandle: ownerHandle,
      operationAttemptId: operationAttemptId,
      runMarker: runMarker,
      creationRequestFingerprint: creationRequestFingerprint,
      cleanupHandle: cleanupHandle,
      diagnosticLookupHandle: diagnosticLookupHandle,
      ownership: ownership,
      environment: environment,
      createdAt: createdAt.toUtc(),
    );
    if (identity.validate().isNotEmpty) {
      throw const FormatException('CREATED_CONVERSATION_IDENTITY_INVALID');
    }
    return identity;
  }

  factory CreatedConversationIdentity.fromJson(Map<String, Object?> json) {
    const expectedKeys = {
      'conversationHandle',
      'ownerHandle',
      'operationAttemptId',
      'runMarker',
      'creationRequestFingerprint',
      'cleanupHandle',
      'diagnosticLookupHandle',
      'ownership',
      'environment',
      'createdAt',
    };
    if (json.keys.toSet().difference(expectedKeys).isNotEmpty ||
        expectedKeys.difference(json.keys.toSet()).isNotEmpty) {
      throw const FormatException('CREATED_CONVERSATION_IDENTITY_INVALID');
    }
    String text(String key) {
      final value = json[key];
      if (value is! String) {
        throw const FormatException('CREATED_CONVERSATION_IDENTITY_INVALID');
      }
      return value;
    }

    return CreatedConversationIdentity.validated(
      conversationHandle: text('conversationHandle'),
      ownerHandle: text('ownerHandle'),
      operationAttemptId: text('operationAttemptId'),
      runMarker: text('runMarker'),
      creationRequestFingerprint: text('creationRequestFingerprint'),
      cleanupHandle: text('cleanupHandle'),
      diagnosticLookupHandle: text('diagnosticLookupHandle'),
      ownership: text('ownership'),
      environment: text('environment'),
      createdAt: DateTime.parse(text('createdAt')),
    );
  }

  final String conversationHandle;
  final String ownerHandle;
  final String operationAttemptId;
  final String runMarker;
  final String creationRequestFingerprint;
  final String cleanupHandle;
  final String diagnosticLookupHandle;
  final String ownership;
  final String environment;
  final DateTime createdAt;

  List<String> validate() {
    final findings = <String>[];
    if (!_uuidPattern.hasMatch(conversationHandle) ||
        !_uuidPattern.hasMatch(ownerHandle) ||
        cleanupHandle != conversationHandle ||
        diagnosticLookupHandle != conversationHandle) {
      findings.add('Exact canonical handles are required.');
    }
    if (!_operationAttemptPattern.hasMatch(operationAttemptId) ||
        !_runMarkerPattern.hasMatch(runMarker) ||
        !_sha256Pattern.hasMatch(creationRequestFingerprint)) {
      findings.add('Attempt, run marker or request fingerprint is invalid.');
    }
    if (ownership != conversationIdentityOwnership ||
        environment != 'development' ||
        !createdAt.isUtc) {
      findings.add('Ownership, environment or timestamp is invalid.');
    }
    return findings;
  }

  Map<String, Object?> toJson() => {
    'conversationHandle': conversationHandle,
    'ownerHandle': ownerHandle,
    'operationAttemptId': operationAttemptId,
    'runMarker': runMarker,
    'creationRequestFingerprint': creationRequestFingerprint,
    'cleanupHandle': cleanupHandle,
    'diagnosticLookupHandle': diagnosticLookupHandle,
    'ownership': ownership,
    'environment': environment,
    'createdAt': createdAt.toIso8601String(),
  };

  bool sameIdentity(CreatedConversationIdentity other) =>
      canonicalJson(toJson()) == canonicalJson(other.toJson());
}

ConversationCreateResponseAssessment classifyConversationCreateResponse({
  required int? status,
  required Object? body,
  required String ownerHandle,
  required String operationAttemptId,
  required String runMarker,
  required String normalizedRequest,
  bool requestWasSent = true,
  DateTime Function()? clock,
}) {
  if (status == null) {
    return ConversationCreateResponseAssessment(
      classification: requestWasSent
          ? ConversationCreateResponseClassification
                .createTransportFailurePossiblyAccepted
          : ConversationCreateResponseClassification
                .createTransportFailureNoAcceptanceEvidence,
    );
  }
  if (status == 202) {
    return const ConversationCreateResponseAssessment(
      classification: ConversationCreateResponseClassification
          .createAcceptedPendingConfirmation,
    );
  }
  if (status != 200 && status != 201) {
    return const ConversationCreateResponseAssessment(
      classification:
          ConversationCreateResponseClassification.createResponseInvalid,
    );
  }
  if (body is! Map) {
    return const ConversationCreateResponseAssessment(
      classification:
          ConversationCreateResponseClassification.createResponseInvalid,
    );
  }
  final response = Map<String, Object?>.from(body);
  final rawSession = response['session'];
  if (rawSession is! Map) {
    return const ConversationCreateResponseAssessment(
      classification: ConversationCreateResponseClassification
          .createConfirmedIdentityIncomplete,
    );
  }
  final session = Map<String, Object?>.from(rawSession);
  final handle = session['sessionId'];
  if (handle is! String || !_uuidPattern.hasMatch(handle)) {
    return const ConversationCreateResponseAssessment(
      classification: ConversationCreateResponseClassification
          .createConfirmedIdentityIncomplete,
    );
  }
  try {
    final identity = CreatedConversationIdentity.validated(
      conversationHandle: handle,
      ownerHandle: ownerHandle,
      operationAttemptId: operationAttemptId,
      runMarker: runMarker,
      creationRequestFingerprint: sha256Hex(normalizedRequest),
      cleanupHandle: handle,
      diagnosticLookupHandle: handle,
      ownership: conversationIdentityOwnership,
      environment: 'development',
      createdAt: (clock ?? DateTime.now)().toUtc(),
    );
    return ConversationCreateResponseAssessment(
      classification: ConversationCreateResponseClassification
          .createConfirmedWithExactIdentity,
      identity: identity,
    );
  } on FormatException {
    return const ConversationCreateResponseAssessment(
      classification: ConversationCreateResponseClassification
          .createConfirmedIdentityIncomplete,
    );
  }
}

String classifyLegacyConversationIdentity({
  required String manifestVersion,
  required bool exactIdentityPersisted,
}) {
  if (manifestVersion == 'FOUNDATION-019A-SECOND-FUNCTIONAL-ATTEMPT-v4' &&
      !exactIdentityPersisted) {
    return legacyDirtyRunMissingExactConversationIdentity;
  }
  return exactIdentityPersisted
      ? 'EXACT_CONVERSATION_IDENTITY_AVAILABLE'
      : 'CONVERSATION_IDENTITY_UNKNOWN_BLOCKING';
}

final class ConversationIdentityLedgerStore {
  ConversationIdentityLedgerStore({
    required this.repositoryRoot,
    required this.binding,
    this.beforeAtomicRename,
  });

  final Directory repositoryRoot;
  final ConversationLedgerBinding binding;
  final void Function(File temporary, File target)? beforeAtomicRename;

  Directory get _runtimeRoot =>
      Directory('${repositoryRoot.path}${Platform.pathSeparator}.runtime');

  File ledgerFile(String runMarker) {
    _validateRunMarker(runMarker);
    return File(
      '${_runtimeRoot.path}${Platform.pathSeparator}runs'
      '${Platform.pathSeparator}$runMarker'
      '${Platform.pathSeparator}resource-ledger.json',
    );
  }

  void persist(
    CreatedConversationIdentity identity, {
    ConversationLedgerLifecycle lifecycle =
        ConversationLedgerLifecycle.resourceCreated,
  }) {
    binding.validateFor(identity);
    final target = ledgerFile(identity.runMarker);
    _ensurePrivateDirectory(target.parent);
    final payload = <String, Object?>{
      'identity': identity.toJson(),
      'binding': binding.toJson(),
      'lifecycle': lifecycle.value,
    };
    final envelope = <String, Object?>{
      'schemaVersion': conversationIdentitySchemaVersion,
      'payload': payload,
      'payloadSha256': sha256Hex(canonicalJson(payload)),
    };
    final temporary = File(
      '${target.path}.tmp.$pid.${DateTime.now().microsecondsSinceEpoch}',
    );
    try {
      temporary.writeAsStringSync('${canonicalJson(envelope)}\n', flush: true);
      _chmod(temporary.path, '600');
      beforeAtomicRename?.call(temporary, target);
      temporary.renameSync(target.path);
      _chmod(target.path, '600');
    } finally {
      if (temporary.existsSync()) temporary.deleteSync();
    }
  }

  ConversationIdentityLedgerRecord readRecord(String runMarker) {
    final file = ledgerFile(runMarker);
    if (!file.existsSync()) {
      throw const FileSystemException('CONVERSATION_LEDGER_MISSING');
    }
    final decoded = jsonDecode(file.readAsStringSync());
    if (decoded is! Map) {
      throw const FormatException('CONVERSATION_LEDGER_INVALID');
    }
    final envelope = Map<String, Object?>.from(decoded);
    const expectedKeys = {'schemaVersion', 'payload', 'payloadSha256'};
    if (envelope.keys.toSet().difference(expectedKeys).isNotEmpty ||
        expectedKeys.difference(envelope.keys.toSet()).isNotEmpty ||
        envelope['schemaVersion'] != conversationIdentitySchemaVersion ||
        envelope['payload'] is! Map ||
        envelope['payloadSha256'] is! String) {
      throw const FormatException('CONVERSATION_LEDGER_INVALID');
    }
    final rawPayload = envelope['payload'];
    if (rawPayload is! Map) {
      throw const FormatException('CONVERSATION_LEDGER_INVALID');
    }
    final payload = Map<String, Object?>.from(rawPayload);
    if (envelope['payloadSha256'] != sha256Hex(canonicalJson(payload))) {
      throw const FormatException('CONVERSATION_LEDGER_INTEGRITY_FAILED');
    }
    final record = ConversationIdentityLedgerRecord.fromJson(payload);
    binding.validateFor(record.identity);
    if (!binding.sameBinding(record.binding) ||
        record.identity.runMarker != runMarker) {
      throw const FormatException('CONVERSATION_LEDGER_BINDING_MISMATCH');
    }
    return record;
  }

  ConversationIdentityLedgerRecord persistAndVerify(
    CreatedConversationIdentity identity,
  ) {
    persist(identity);
    final verified = readRecord(identity.runMarker);
    if (!identity.sameIdentity(verified.identity) ||
        verified.lifecycle != ConversationLedgerLifecycle.resourceCreated) {
      throw const FormatException('CONVERSATION_LEDGER_VERIFY_FAILED');
    }
    return verified;
  }

  ConversationIdentityLedgerRecord transition(
    String runMarker, {
    required ConversationLedgerLifecycle expected,
    required ConversationLedgerLifecycle next,
  }) {
    final current = readRecord(runMarker);
    if (current.lifecycle != expected ||
        !current.lifecycle.allowedNext.contains(next)) {
      throw StateError('CONVERSATION_LEDGER_TRANSITION_BLOCKED');
    }
    persist(current.identity, lifecycle: next);
    final verified = readRecord(runMarker);
    if (verified.lifecycle != next) {
      throw const FormatException('CONVERSATION_LEDGER_VERIFY_FAILED');
    }
    return verified;
  }

  void delete(String runMarker) {
    final file = ledgerFile(runMarker);
    if (file.existsSync()) file.deleteSync();
    final runDirectory = file.parent;
    if (runDirectory.existsSync() && runDirectory.listSync().isEmpty) {
      runDirectory.deleteSync();
    }
  }

  void _ensurePrivateDirectory(Directory leaf) {
    final runs = leaf.parent;
    for (final directory in [_runtimeRoot, runs, leaf]) {
      if (!directory.existsSync()) directory.createSync();
      _chmod(directory.path, '700');
    }
  }

  void _validateRunMarker(String runMarker) {
    if (!_runMarkerPattern.hasMatch(runMarker)) {
      throw const FormatException('RUN_MARKER_INVALID');
    }
  }

  void _chmod(String path, String mode) {
    if (Platform.isWindows) {
      throw const FileSystemException(
        'FILESYSTEM_PERMISSION_ENFORCEMENT_UNAVAILABLE',
      );
    }
    final result = Process.runSync('chmod', [mode, path]);
    if (result.exitCode != 0) {
      throw const FileSystemException(
        'FILESYSTEM_PERMISSION_ENFORCEMENT_UNAVAILABLE',
      );
    }
  }
}

enum ConversationLedgerLifecycle {
  resourceCreated('RESOURCE_CREATED'),
  cleanupPending('CLEANUP_PENDING'),
  cleaned('CLEANED'),
  diagnosisPending('DIAGNOSIS_PENDING'),
  closed('CLOSED');

  const ConversationLedgerLifecycle(this.value);

  final String value;

  Set<ConversationLedgerLifecycle> get allowedNext => switch (this) {
    resourceCreated => const {cleanupPending, diagnosisPending},
    cleanupPending => const {cleaned, diagnosisPending},
    cleaned => const {closed},
    diagnosisPending => const {cleanupPending, closed},
    closed => const {},
  };

  static ConversationLedgerLifecycle parse(Object? value) => values.singleWhere(
    (candidate) => candidate.value == value,
    orElse: () =>
        throw const FormatException('CONVERSATION_LEDGER_LIFECYCLE_INVALID'),
  );
}

final class ConversationLedgerBinding {
  ConversationLedgerBinding.validated({
    required this.commitSha,
    required this.authorizationReference,
    required this.manifestVersion,
    required this.runnerVersion,
    required this.environment,
  }) {
    if (!RegExp(r'^[0-9a-f]{40}$').hasMatch(commitSha) ||
        !RegExp(
          r'^[A-Z0-9][A-Z0-9-]{7,95}$',
        ).hasMatch(authorizationReference) ||
        manifestVersion != 'FOUNDATION-019A-SECOND-FUNCTIONAL-ATTEMPT-v5' ||
        runnerVersion != 'FOUNDATION-019A-R2I-RUNNER-v1' ||
        environment != 'development') {
      throw const FormatException('CONVERSATION_LEDGER_BINDING_INVALID');
    }
  }

  factory ConversationLedgerBinding.fromJson(Map<String, Object?> json) {
    const expected = {
      'commitSha',
      'authorizationReference',
      'manifestVersion',
      'runnerVersion',
      'environment',
    };
    if (json.keys.toSet().difference(expected).isNotEmpty ||
        expected.difference(json.keys.toSet()).isNotEmpty) {
      throw const FormatException('CONVERSATION_LEDGER_BINDING_INVALID');
    }
    return ConversationLedgerBinding.validated(
      commitSha: json['commitSha'] as String? ?? '',
      authorizationReference: json['authorizationReference'] as String? ?? '',
      manifestVersion: json['manifestVersion'] as String? ?? '',
      runnerVersion: json['runnerVersion'] as String? ?? '',
      environment: json['environment'] as String? ?? '',
    );
  }

  final String commitSha;
  final String authorizationReference;
  final String manifestVersion;
  final String runnerVersion;
  final String environment;

  Map<String, Object?> toJson() => {
    'commitSha': commitSha,
    'authorizationReference': authorizationReference,
    'manifestVersion': manifestVersion,
    'runnerVersion': runnerVersion,
    'environment': environment,
  };

  void validateFor(CreatedConversationIdentity identity) {
    if (identity.environment != environment) {
      throw const FormatException('CONVERSATION_LEDGER_BINDING_MISMATCH');
    }
  }

  bool sameBinding(ConversationLedgerBinding other) =>
      canonicalJson(toJson()) == canonicalJson(other.toJson());
}

final class ConversationIdentityLedgerRecord {
  const ConversationIdentityLedgerRecord({
    required this.identity,
    required this.binding,
    required this.lifecycle,
  });

  factory ConversationIdentityLedgerRecord.fromJson(Map<String, Object?> json) {
    const expected = {'identity', 'binding', 'lifecycle'};
    if (json.keys.toSet().difference(expected).isNotEmpty ||
        expected.difference(json.keys.toSet()).isNotEmpty ||
        json['identity'] is! Map ||
        json['binding'] is! Map) {
      throw const FormatException('CONVERSATION_LEDGER_INVALID');
    }
    final rawIdentity = json['identity'];
    final rawBinding = json['binding'];
    if (rawIdentity is! Map || rawBinding is! Map) {
      throw const FormatException('CONVERSATION_LEDGER_INVALID');
    }
    return ConversationIdentityLedgerRecord(
      identity: CreatedConversationIdentity.fromJson(
        Map<String, Object?>.from(rawIdentity),
      ),
      binding: ConversationLedgerBinding.fromJson(
        Map<String, Object?>.from(rawBinding),
      ),
      lifecycle: ConversationLedgerLifecycle.parse(json['lifecycle']),
    );
  }

  final CreatedConversationIdentity identity;
  final ConversationLedgerBinding binding;
  final ConversationLedgerLifecycle lifecycle;
}

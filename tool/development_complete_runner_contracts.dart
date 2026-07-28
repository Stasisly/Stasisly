import 'dart:convert';
import 'dart:io';

const completeRunnerVersion = 'FOUNDATION-019A-R2E-RUNNER-v1';
const completeManifestVersion = 'FOUNDATION-019A-SECOND-FUNCTIONAL-ATTEMPT-v3';
const canonicalSpecialistPolicy = 'VERIFIED_PREEXISTING_READ_ONLY';
const canonicalSpecialistSource = 'SELECTABLE_SPECIALIST_CATALOG';
const canonicalSpecialistSelectionMode =
    'EXACT_ONE_AVAILABLE_IN_CANONICAL_AREA';
const canonicalSpecialistArea = 'stasis';

final class RunnerOperation {
  const RunnerOperation({
    required this.operation,
    required this.runnerFunction,
    required this.requestContract,
    required this.successEvidence,
    required this.failureEvidence,
    required this.fromState,
    required this.toState,
    required this.ledgerEffect,
    required this.cleanupEffect,
    required this.implemented,
    required this.tested,
  });

  factory RunnerOperation.fromJson(Map<String, Object?> json) {
    String read(String key) {
      final value = json[key];
      if (value is! String || value.isEmpty) {
        throw FormatException('Invalid operation field: $key.');
      }
      return value;
    }

    return RunnerOperation(
      operation: read('operation'),
      runnerFunction: read('runnerFunction'),
      requestContract: read('requestContract'),
      successEvidence: read('successEvidence'),
      failureEvidence: read('failureEvidence'),
      fromState: read('fromState'),
      toState: read('toState'),
      ledgerEffect: read('ledgerEffect'),
      cleanupEffect: read('cleanupEffect'),
      implemented: json['implemented'] == true,
      tested: json['tested'] == true,
    );
  }

  final String operation;
  final String runnerFunction;
  final String requestContract;
  final String successEvidence;
  final String failureEvidence;
  final String fromState;
  final String toState;
  final String ledgerEffect;
  final String cleanupEffect;
  final bool implemented;
  final bool tested;
}

final class CompleteRunnerManifest {
  CompleteRunnerManifest._({
    required this.version,
    required this.runnerVersion,
    required this.specialistPolicy,
    required this.specialistSource,
    required this.specialistSelectionMode,
    required this.specialistSelectionArea,
    required this.specialistSelectionLimit,
    required this.specialistCreation,
    required this.catalogCreation,
    required this.specialistCleanup,
    required this.catalogCleanup,
    required this.states,
    required this.operations,
    required this.failureCleanupFromStates,
  });

  factory CompleteRunnerManifest.read(File file) {
    final decoded = jsonDecode(file.readAsStringSync());
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Manifest must be an object.');
    }
    final rawStates = decoded['states'];
    final rawOperations = decoded['operations'];
    final rawFailureStates = decoded['failureCleanupFromStates'];
    final rawSelection = decoded['specialistSelection'];
    if (rawStates is! List ||
        rawOperations is! List ||
        rawFailureStates is! List ||
        rawSelection is! Map) {
      throw const FormatException('Manifest states and operations required.');
    }
    final selection = Map<String, Object?>.from(rawSelection);
    return CompleteRunnerManifest._(
      version: decoded['manifestVersion'] as String? ?? '',
      runnerVersion: decoded['runnerVersion'] as String? ?? '',
      specialistPolicy: decoded['specialistPolicy'] as String? ?? '',
      specialistSource: decoded['specialistSource'] as String? ?? '',
      specialistSelectionMode: selection['mode'] as String? ?? '',
      specialistSelectionArea: selection['canonicalArea'] as String? ?? '',
      specialistSelectionLimit: selection['maxCandidates'] as int? ?? 0,
      specialistCreation: decoded['specialistCreation'] as String? ?? '',
      catalogCreation: decoded['catalogCreation'] as String? ?? '',
      specialistCleanup: decoded['specialistCleanup'] as String? ?? '',
      catalogCleanup: decoded['catalogCleanup'] as String? ?? '',
      states: rawStates.map((value) => value as String).toList(growable: false),
      operations: rawOperations
          .map(
            (value) => RunnerOperation.fromJson(
              Map<String, Object?>.from(value as Map),
            ),
          )
          .toList(growable: false),
      failureCleanupFromStates: rawFailureStates
          .map((value) => value as String)
          .toSet(),
    );
  }

  final String version;
  final String runnerVersion;
  final String specialistPolicy;
  final String specialistSource;
  final String specialistSelectionMode;
  final String specialistSelectionArea;
  final int specialistSelectionLimit;
  final String specialistCreation;
  final String catalogCreation;
  final String specialistCleanup;
  final String catalogCleanup;
  final List<String> states;
  final List<RunnerOperation> operations;
  final Set<String> failureCleanupFromStates;

  List<String> validate() {
    final findings = <String>[];
    if (version != completeManifestVersion) {
      findings.add('Unexpected manifest version.');
    }
    if (runnerVersion != completeRunnerVersion) {
      findings.add('Unexpected runner version.');
    }
    if (specialistPolicy != canonicalSpecialistPolicy ||
        specialistSource != canonicalSpecialistSource ||
        specialistSelectionMode != canonicalSpecialistSelectionMode ||
        specialistSelectionArea != canonicalSpecialistArea ||
        specialistSelectionLimit != 20 ||
        specialistCreation != 'FORBIDDEN' ||
        catalogCreation != 'FORBIDDEN' ||
        specialistCleanup != 'NOT_APPLICABLE' ||
        catalogCleanup != 'NOT_APPLICABLE') {
      findings.add('Canonical specialist policy is invalid.');
    }
    if (states.isEmpty || states.first != 'INITIAL') {
      findings.add('State path must start at INITIAL.');
    }
    if (states.toSet().length != states.length) {
      findings.add('State path contains duplicates.');
    }
    if (failureCleanupFromStates.isEmpty ||
        failureCleanupFromStates.any(
          (state) =>
              !states.contains(state) ||
              state == 'INITIAL' ||
              states.indexOf(state) >= states.indexOf('CLEANUP_STARTED'),
        )) {
      findings.add('Failure cleanup states are invalid.');
    }
    if (operations.length != states.length - 1) {
      findings.add('Every adjacent state requires one operation.');
    }
    final names = <String>{};
    final functions = <String>{};
    for (var index = 0; index < operations.length; index++) {
      final operation = operations[index];
      if (!names.add(operation.operation)) {
        findings.add('Duplicate manifest operation.');
      }
      if (!functions.add(operation.runnerFunction)) {
        findings.add('Duplicate runner function mapping.');
      }
      if (index + 1 < states.length &&
          (operation.fromState != states[index] ||
              operation.toState != states[index + 1])) {
        findings.add('Operation state mapping is not adjacent.');
      }
      if (!operation.implemented ||
          !operation.tested ||
          operation.requestContract.isEmpty ||
          operation.successEvidence.isEmpty ||
          operation.failureEvidence.isEmpty ||
          operation.ledgerEffect.isEmpty ||
          operation.cleanupEffect.isEmpty) {
        findings.add('Operation mapping is incomplete.');
      }
    }
    final specialistOperations = operations
        .where((operation) => operation.operation == 'specialistResolution')
        .toList(growable: false);
    if (specialistOperations.length != 1 ||
        specialistOperations.single.runnerFunction !=
            'resolveSpecialistFromCanonicalCatalog' ||
        specialistOperations.single.ledgerEffect !=
            'VERIFIED_PREEXISTING_READ_ONLY' ||
        specialistOperations.single.cleanupEffect != 'NONE') {
      findings.add('Specialist manifest-runner semantics diverge.');
    }
    return findings;
  }

  RunnerOperation operationFrom(String state) =>
      operations.singleWhere((operation) => operation.fromState == state);
}

enum CanonicalSpecialistResolutionState {
  exactlyOneSelectable,
  noneSelectable,
  multipleSelectableCandidates,
  catalogUnavailable,
  catalogContractInvalid,
  environmentMismatch,
  authorizationRejected,
  unknownFailure,
}

final class CanonicalSelectableSpecialist {
  const CanonicalSelectableSpecialist({
    required this.selectableSpecialistId,
    required this.displayName,
    required this.publicArea,
    required this.publicDescription,
    required this.accessState,
  });

  factory CanonicalSelectableSpecialist.fromJson(Map<String, Object?> json) {
    const expectedKeys = {
      'selectableSpecialistId',
      'displayName',
      'publicArea',
      'publicDescription',
      'accessState',
    };
    if (json.keys.toSet().difference(expectedKeys).isNotEmpty ||
        !json.keys.toSet().containsAll(expectedKeys)) {
      throw const FormatException('Unexpected specialist catalog fields.');
    }
    String requiredString(String key) {
      final value = json[key];
      if (value is! String || value.trim().isEmpty) {
        throw FormatException('Invalid specialist field: $key.');
      }
      return value.trim();
    }

    final id = requiredString('selectableSpecialistId');
    if (!RegExp(
      r'^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
      caseSensitive: false,
    ).hasMatch(id)) {
      throw const FormatException('Invalid specialist identifier.');
    }
    final area = requiredString('publicArea');
    if (!const {
      'stasis',
      'health',
      'nutrition',
      'training',
      'wellness',
    }.contains(area)) {
      throw const FormatException('Invalid specialist area.');
    }
    final accessState = requiredString('accessState');
    if (!const {
      'available',
      'lockedPro',
      'unavailable',
    }.contains(accessState)) {
      throw const FormatException('Invalid specialist access state.');
    }
    return CanonicalSelectableSpecialist(
      selectableSpecialistId: id,
      displayName: requiredString('displayName'),
      publicArea: area,
      publicDescription: requiredString('publicDescription'),
      accessState: accessState,
    );
  }

  final String selectableSpecialistId;
  final String displayName;
  final String publicArea;
  final String publicDescription;
  final String accessState;
}

final class CanonicalSpecialistResolutionResult {
  const CanonicalSpecialistResolutionResult(this.state, [this.specialist]);

  final CanonicalSpecialistResolutionState state;
  final CanonicalSelectableSpecialist? specialist;

  bool get mayContinue =>
      state == CanonicalSpecialistResolutionState.exactlyOneSelectable &&
      specialist != null;
}

// The interface is the intentional substitution boundary for future policies.
// ignore: one_member_abstracts
abstract interface class SpecialistResolutionPolicy {
  CanonicalSpecialistResolutionResult resolve({
    required Object? catalogPayload,
    required bool catalogAvailable,
    required String environment,
    required bool policyAuthorized,
  });
}

final class VerifiedPreexistingReadOnlyPolicy
    implements SpecialistResolutionPolicy {
  const VerifiedPreexistingReadOnlyPolicy({
    this.canonicalArea = canonicalSpecialistArea,
    this.maxCandidates = 20,
  });

  final String canonicalArea;
  final int maxCandidates;

  @override
  CanonicalSpecialistResolutionResult resolve({
    required Object? catalogPayload,
    required bool catalogAvailable,
    required String environment,
    required bool policyAuthorized,
  }) {
    if (!policyAuthorized) {
      return const CanonicalSpecialistResolutionResult(
        CanonicalSpecialistResolutionState.authorizationRejected,
      );
    }
    if (environment != 'development') {
      return const CanonicalSpecialistResolutionResult(
        CanonicalSpecialistResolutionState.environmentMismatch,
      );
    }
    if (!catalogAvailable) {
      return const CanonicalSpecialistResolutionResult(
        CanonicalSpecialistResolutionState.catalogUnavailable,
      );
    }
    if (catalogPayload is! List || catalogPayload.length > maxCandidates) {
      return const CanonicalSpecialistResolutionResult(
        CanonicalSpecialistResolutionState.catalogContractInvalid,
      );
    }
    try {
      final candidates = catalogPayload
          .map(
            (value) => CanonicalSelectableSpecialist.fromJson(
              Map<String, Object?>.from(value as Map),
            ),
          )
          .where(
            (candidate) =>
                candidate.publicArea == canonicalArea &&
                candidate.accessState == 'available',
          )
          .toList(growable: false);
      if (candidates.isEmpty) {
        return const CanonicalSpecialistResolutionResult(
          CanonicalSpecialistResolutionState.noneSelectable,
        );
      }
      if (candidates.length != 1) {
        return const CanonicalSpecialistResolutionResult(
          CanonicalSpecialistResolutionState.multipleSelectableCandidates,
        );
      }
      return CanonicalSpecialistResolutionResult(
        CanonicalSpecialistResolutionState.exactlyOneSelectable,
        candidates.single,
      );
    } on FormatException {
      return const CanonicalSpecialistResolutionResult(
        CanonicalSpecialistResolutionState.catalogContractInvalid,
      );
    } on Object {
      return const CanonicalSpecialistResolutionResult(
        CanonicalSpecialistResolutionState.unknownFailure,
      );
    }
  }
}

final class CompleteRunnerStateMachine {
  CompleteRunnerStateMachine(this.manifest) : _state = manifest.states.first;

  final CompleteRunnerManifest manifest;
  String _state;
  bool _terminal = false;

  String get state => _state;
  bool get terminal => _terminal;

  String advance(String next, {required String evidence}) {
    if (_terminal) {
      throw StateError('RUNNER_STATE_TRANSITION_BLOCKED');
    }
    final operation = manifest.operationFrom(_state);
    if (operation.toState != next || operation.successEvidence != evidence) {
      throw StateError('RUNNER_STATE_TRANSITION_BLOCKED');
    }
    _state = next;
    if (_state == manifest.states.last) _terminal = true;
    return _state;
  }

  String beginCleanupAfterFailure() {
    if (_terminal ||
        !manifest.failureCleanupFromStates.contains(_state) ||
        manifest.states.indexOf(_state) >=
            manifest.states.indexOf('CLEANUP_STARTED')) {
      throw StateError('RUNNER_STATE_TRANSITION_BLOCKED');
    }
    return _state = 'CLEANUP_STARTED';
  }
}

enum ResourceDisposition {
  createdByRun,
  verifiedPreexistingReadOnly,
  notCreated,
  unknownBlocking,
}

enum ResourceCategory {
  ownerAuth,
  foreignAuth,
  profile,
  specialist,
  catalog,
  conversation,
  messages,
  idempotency,
  sessionState,
}

final class LedgerEntry {
  LedgerEntry({
    required this.category,
    required this.disposition,
    required this.creationState,
    required this.ownershipProof,
    required this.cleanupHandle,
    required this.cleanupRequired,
  });

  final ResourceCategory category;
  final ResourceDisposition disposition;
  final String creationState;
  final String ownershipProof;
  final String cleanupHandle;
  final bool cleanupRequired;
  bool cleanupCompleted = false;
  bool verificationCompleted = false;
}

final class CompleteResourceLedger {
  final Map<ResourceCategory, LedgerEntry> _entries = {};
  bool _deleted = false;

  static const cleanupOrder = [
    ResourceCategory.messages,
    ResourceCategory.idempotency,
    ResourceCategory.conversation,
    ResourceCategory.sessionState,
    ResourceCategory.profile,
    ResourceCategory.catalog,
    ResourceCategory.specialist,
    ResourceCategory.foreignAuth,
    ResourceCategory.ownerAuth,
  ];

  void register(LedgerEntry entry) {
    if (_deleted || _entries.containsKey(entry.category)) {
      throw StateError('LEDGER_INSERT_BLOCKED');
    }
    if (entry.disposition == ResourceDisposition.unknownBlocking) {
      throw StateError('LEDGER_OWNERSHIP_UNKNOWN');
    }
    if (entry.disposition == ResourceDisposition.createdByRun &&
        (entry.cleanupHandle.isEmpty || entry.ownershipProof.isEmpty)) {
      throw StateError('LEDGER_OWNERSHIP_PROOF_REQUIRED');
    }
    if (entry.disposition == ResourceDisposition.verifiedPreexistingReadOnly &&
        (entry.ownershipProof.isEmpty ||
            entry.cleanupHandle.isNotEmpty ||
            entry.cleanupRequired)) {
      throw StateError('LEDGER_READ_ONLY_CONTRACT_BLOCKED');
    }
    _entries[entry.category] = entry;
  }

  LedgerEntry? operator [](ResourceCategory category) => _entries[category];

  List<LedgerEntry> entriesForCleanup() => cleanupOrder
      .map((category) => _entries[category])
      .whereType<LedgerEntry>()
      .where(
        (entry) =>
            entry.disposition == ResourceDisposition.createdByRun &&
            entry.cleanupRequired,
      )
      .toList(growable: false);

  void markCleaned(ResourceCategory category) {
    final entry = _entries[category];
    if (entry == null ||
        entry.disposition != ResourceDisposition.createdByRun) {
      throw StateError('LEDGER_CLEANUP_BLOCKED');
    }
    entry.cleanupCompleted = true;
  }

  void markVerified(ResourceCategory category) {
    final entry = _entries[category];
    if (entry == null) throw StateError('LEDGER_VERIFICATION_BLOCKED');
    entry.verificationCompleted = true;
  }

  void delete() {
    _entries.clear();
    _deleted = true;
  }

  bool get isDeleted => _deleted && _entries.isEmpty;
}

enum CompleteRunClassification {
  passedClean('PASSED_CLEAN'),
  failedClean('FAILED_CLEAN'),
  failedDirtyBlocking('FAILED_DIRTY_BLOCKING');

  const CompleteRunClassification(this.value);
  final String value;
}

CompleteRunClassification classifyCompleteRun({
  required bool flowPassed,
  required bool cleanupPassed,
  required bool authAbsent,
  required List<int>? counters,
  required bool evidenceSafe,
  required bool cliIsolated,
}) {
  if (!cleanupPassed ||
      !authAbsent ||
      counters == null ||
      counters.length != 7 ||
      counters.any((count) => count != 0) ||
      !evidenceSafe ||
      !cliIsolated) {
    return CompleteRunClassification.failedDirtyBlocking;
  }
  return flowPassed
      ? CompleteRunClassification.passedClean
      : CompleteRunClassification.failedClean;
}

final class ReplayInput {
  const ReplayInput({
    required this.operationAttempt,
    required this.idempotencyKey,
    required this.normalizedRequest,
  });

  final String operationAttempt;
  final String idempotencyKey;
  final String normalizedRequest;
}

bool validateReplay({
  required ReplayInput first,
  required ReplayInput replay,
  required String firstCanonicalResult,
  required String replayCanonicalResult,
  required int attributableConversationCount,
}) =>
    first.operationAttempt == replay.operationAttempt &&
    first.idempotencyKey == replay.idempotencyKey &&
    first.normalizedRequest == replay.normalizedRequest &&
    firstCanonicalResult == replayCanonicalResult &&
    attributableConversationCount == 1;

bool validateNoAiMessages(List<Map<String, Object?>> messages) =>
    messages.length == 1 &&
    messages.single['role'] == 'user' &&
    messages.single['author'] == 'user' &&
    messages.single['provenance'] == 'userProvided' &&
    messages.single['visibility'] == 'productVisible';

bool validateNoAiEvidence({
  required List<Map<String, Object?>> messages,
  required int modelGatewayInvocations,
  required int stasisEngineInvocations,
}) =>
    validateNoAiMessages(messages) &&
    modelGatewayInvocations == 0 &&
    stasisEngineInvocations == 0;

bool validateConversationList({
  required List<List<Map<String, Object?>>> pages,
  required String expectedConversationId,
  required String expectedStatus,
}) {
  if (pages.isEmpty) return false;
  final seen = <String>{};
  var expectedCount = 0;
  for (final page in pages) {
    for (final item in page) {
      final id = item['sessionId'];
      if (id is! String ||
          id.isEmpty ||
          item['status'] != expectedStatus ||
          !seen.add(id)) {
        return false;
      }
      if (id == expectedConversationId) expectedCount++;
    }
  }
  return expectedCount == 1;
}

bool validateConversationDetail({
  required Map<String, Object?> detail,
  required String expectedConversationId,
  required String expectedSpecialistId,
  required String expectedStatus,
  required List<Map<String, Object?>> messages,
  required bool expectEmptyMessages,
}) {
  final specialist = detail['selectedSpecialist'];
  return detail['conversationId'] == expectedConversationId &&
      detail['status'] == expectedStatus &&
      specialist is Map &&
      specialist['id'] == expectedSpecialistId &&
      (!expectEmptyMessages || messages.isEmpty);
}

bool validateLifecycleState({
  required String observedStatus,
  required String expectedStatus,
  required bool presentInActiveList,
  required bool composerEnabled,
}) =>
    observedStatus == expectedStatus &&
    presentInActiveList == (expectedStatus == 'active') &&
    composerEnabled == (expectedStatus == 'active');

bool validateOpaqueForeignResponse({
  required int? status,
  required Object? body,
}) {
  if (status != 404 || body is! Map) return false;
  final response = Map<String, Object?>.from(body);
  final error = response['error'];
  if (error is! Map ||
      error['code'] != 'conversationNotFound' ||
      response.keys.any(
        const {
          'conversation',
          'title',
          'messages',
          'owner',
          'selectedSpecialist',
        }.contains,
      )) {
    return false;
  }
  return true;
}

enum ProductRouteResult {
  absent,
  blockedForProduct,
  unexpectedlyPresent,
  unexpectedlyAvailable,
  unverifiable,
}

ProductRouteResult classifyChatRoute(int? status, {String? location}) {
  if (status == null) return ProductRouteResult.unverifiable;
  if (status == 404 || status == 410) return ProductRouteResult.absent;
  return ProductRouteResult.unexpectedlyPresent;
}

ProductRouteResult classifyOrchestratorRoute(int? status, {String? location}) {
  if (status == null) return ProductRouteResult.unverifiable;
  if ({401, 403, 404, 410}.contains(status)) {
    return ProductRouteResult.blockedForProduct;
  }
  if ({301, 302, 303, 307, 308}.contains(status) &&
      (location == '/' || location == '/login')) {
    return ProductRouteResult.blockedForProduct;
  }
  return ProductRouteResult.unexpectedlyAvailable;
}

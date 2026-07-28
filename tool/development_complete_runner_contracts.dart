import 'dart:convert';
import 'dart:io';

const completeRunnerVersion = 'FOUNDATION-019A-R2D-RUNNER-v1';
const completeManifestVersion = 'FOUNDATION-019A-SECOND-FUNCTIONAL-ATTEMPT-v2';

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
    if (rawStates is! List ||
        rawOperations is! List ||
        rawFailureStates is! List) {
      throw const FormatException('Manifest states and operations required.');
    }
    return CompleteRunnerManifest._(
      version: decoded['manifestVersion'] as String? ?? '',
      runnerVersion: decoded['runnerVersion'] as String? ?? '',
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
    return findings;
  }

  RunnerOperation operationFrom(String state) =>
      operations.singleWhere((operation) => operation.fromState == state);
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
    if (entry.disposition == ResourceDisposition.createdByRun &&
        (entry.cleanupHandle.isEmpty || entry.ownershipProof.isEmpty)) {
      throw StateError('LEDGER_OWNERSHIP_PROOF_REQUIRED');
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

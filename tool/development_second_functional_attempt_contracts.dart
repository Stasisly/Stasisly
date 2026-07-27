import 'dart:convert';
import 'dart:io';

enum DevelopmentRunnerState {
  initial,
  preflightValidated,
  targetVerified,
  setupStarted,
  authUserCreated,
  specialistResolved,
  conversationCreated,
  idempotencyReplayValidated,
  messageSent,
  archived,
  restored,
  flowCompleted,
  cleanupStarted,
  cleanupCompleted,
  residueVerified,
  cliIsolated,
  localRegressionCompleted,
}

final class DevelopmentRunnerStateMachine {
  DevelopmentRunnerState _state = DevelopmentRunnerState.initial;

  DevelopmentRunnerState get state => _state;

  void advance(DevelopmentRunnerState next) {
    if (next.index != _state.index + 1) {
      throw StateError('Runner state transition is not monotonic.');
    }
    _state = next;
  }
}

enum DevelopmentEphemeralResource {
  authUser,
  profile,
  specialistFixture,
  conversation,
  messages,
  idempotencyRecords,
  sessionState,
}

final class DevelopmentResourceLedger {
  final Set<DevelopmentEphemeralResource> _resources = {};

  void record(DevelopmentEphemeralResource resource) {
    _resources.add(resource);
  }

  bool contains(DevelopmentEphemeralResource resource) =>
      _resources.contains(resource);

  List<DevelopmentEphemeralResource> cleanupOrder() {
    const order = [
      DevelopmentEphemeralResource.messages,
      DevelopmentEphemeralResource.idempotencyRecords,
      DevelopmentEphemeralResource.conversation,
      DevelopmentEphemeralResource.sessionState,
      DevelopmentEphemeralResource.profile,
      DevelopmentEphemeralResource.specialistFixture,
      DevelopmentEphemeralResource.authUser,
    ];
    return order.where(_resources.contains).toList(growable: false);
  }

  void clear() => _resources.clear();

  bool get isEmpty => _resources.isEmpty;
}

final class DevelopmentResidueCounters {
  const DevelopmentResidueCounters({
    required this.messages,
    required this.idempotency,
    required this.sessions,
    required this.profiles,
    required this.catalog,
    required this.specialists,
    required this.auth,
  });

  factory DevelopmentResidueCounters.fromJson(Map<String, Object?> value) {
    const expected = {
      'messages',
      'idempotency',
      'sessions',
      'profiles',
      'catalog',
      'specialists',
      'auth',
    };
    if (value.keys.toSet().difference(expected).isNotEmpty ||
        expected.difference(value.keys.toSet()).isNotEmpty) {
      throw const FormatException('Unknown or missing residue counter.');
    }
    int read(String name) {
      final count = value[name];
      if (count is! int || count < 0) {
        throw const FormatException('Invalid residue counter.');
      }
      return count;
    }

    return DevelopmentResidueCounters(
      messages: read('messages'),
      idempotency: read('idempotency'),
      sessions: read('sessions'),
      profiles: read('profiles'),
      catalog: read('catalog'),
      specialists: read('specialists'),
      auth: read('auth'),
    );
  }

  final int messages;
  final int idempotency;
  final int sessions;
  final int profiles;
  final int catalog;
  final int specialists;
  final int auth;

  bool get isZero =>
      messages == 0 &&
      idempotency == 0 &&
      sessions == 0 &&
      profiles == 0 &&
      catalog == 0 &&
      specialists == 0 &&
      auth == 0;

  String get vector =>
      '$messages|$idempotency|$sessions|$profiles|$catalog|$specialists|$auth';
}

enum DevelopmentRunClassification {
  passedClean('PASSED_CLEAN'),
  failedClean('FAILED_CLEAN'),
  failedDirtyBlocking('FAILED_DIRTY_BLOCKING');

  const DevelopmentRunClassification(this.value);
  final String value;
}

DevelopmentRunClassification classifyDevelopmentRun({
  required bool flowPassed,
  required bool cleanupCompleted,
  required DevelopmentResidueCounters? residue,
  required bool evidenceSanitized,
  required bool cliIsolated,
}) {
  if (!cleanupCompleted ||
      residue == null ||
      !residue.isZero ||
      !evidenceSanitized ||
      !cliIsolated) {
    return DevelopmentRunClassification.failedDirtyBlocking;
  }
  return flowPassed
      ? DevelopmentRunClassification.passedClean
      : DevelopmentRunClassification.failedClean;
}

final class SecondFunctionalAttemptManifestValidator {
  const SecondFunctionalAttemptManifestValidator();

  List<String> validate(File file) {
    final findings = <String>[];
    final value = jsonDecode(file.readAsStringSync());
    if (value is! Map<String, dynamic>) {
      return ['Manifest is not an object.'];
    }
    void expectValue(String key, Object expected) {
      if (value[key] != expected) findings.add('$key must be $expected.');
    }

    expectValue(
      'manifestVersion',
      'FOUNDATION-019A-SECOND-FUNCTIONAL-ATTEMPT-v1',
    );
    expectValue('authorization', 'NOT_GRANTED');
    expectValue('execution', 'NOT_EXECUTED');
    expectValue('authorizedCommit', 'UNASSIGNED');
    expectValue('authorizationReference', 'UNASSIGNED');
    expectValue('environment', 'development');
    expectValue('runnerVersion', 'R2B');
    expectValue('schemaChange', 'FORBIDDEN');
    expectValue('migration', 'FORBIDDEN');
    expectValue('functionDeploy', 'FORBIDDEN');
    expectValue('secretMutation', 'FORBIDDEN');
    expectValue('cleanup', 'MANDATORY');
    expectValue('residueVerification', 'MANDATORY');
    expectValue('cliIsolation', 'MANDATORY');
    return findings;
  }
}

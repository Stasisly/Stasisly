import 'dart:convert';
import 'dart:io';

import 'development_dirty_run_containment.dart';

const exactAuthLookupDerivationVersion = 'FOUNDATION-019A-R2C-R1-v1';
const exactAuthCommittedAlias = 'AUTH_RESOURCE_DIAG_002';
const historicalEmailTemplate = '{runAlias}@example.test';
const maximumAuthLookupPages = 10;

final RegExp _safeAlias = RegExp(r'^[a-z0-9][a-z0-9-]{7,31}$');
final RegExp _safeNamespace = RegExp(r'^[a-z0-9][a-z0-9-]{15,95}$');
final RegExp _safeFixtureVersion = RegExp(r'^[A-Za-z0-9][A-Za-z0-9-]{7,63}$');
final RegExp _unsafeEnvironmentIdentity = RegExp(
  r'(^|-)(prod|production|staging|real|personal)($|-)',
);

final class SyntheticAuthLookupKey {
  const SyntheticAuthLookupKey._({
    required this.attemptAlias,
    required this.runNamespace,
    required this.fixtureManifestVersion,
    required String exactEmail,
  }) : _exactEmail = exactEmail;

  final String attemptAlias;
  final String runNamespace;
  final String fixtureManifestVersion;
  final String _exactEmail;

  String get committedAlias => exactAuthCommittedAlias;

  bool matchesExact(String candidate) => candidate == _exactEmail;

  T useOperationalValue<T>(T Function(String exactLookupValue) operation) =>
      operation(_exactEmail);

  @override
  String toString() => 'SyntheticAuthLookupKey(<redacted>)';
}

SyntheticAuthLookupKey deriveDirtyAttemptAuthLookupKey({
  required String attemptAlias,
  required String runNamespace,
  required String fixtureManifestVersion,
}) {
  _requireCanonical(attemptAlias, _safeAlias, 'attempt alias');
  _requireCanonical(runNamespace, _safeNamespace, 'run namespace');
  _requireCanonical(
    fixtureManifestVersion,
    _safeFixtureVersion,
    'fixture version',
  );
  if (_unsafeEnvironmentIdentity.hasMatch(attemptAlias) ||
      _unsafeEnvironmentIdentity.hasMatch(runNamespace)) {
    throw const FormatException('Production-like identity is forbidden.');
  }
  return SyntheticAuthLookupKey._(
    attemptAlias: attemptAlias,
    runNamespace: runNamespace,
    fixtureManifestVersion: fixtureManifestVersion,
    exactEmail: '$attemptAlias@example.test',
  );
}

bool historicalSyntheticAuthLookupKeyMatches(SyntheticAuthLookupKey key) {
  if (key.attemptAlias != dirtyAttemptAlias ||
      key.runNamespace != dirtyRunNamespace ||
      key.fixtureManifestVersion != dirtyFixtureContractVersion) {
    return false;
  }
  final historicalValue = historicalEmailTemplate.replaceFirst(
    '{runAlias}',
    dirtyAttemptAlias,
  );
  return key.matchesExact(historicalValue);
}

void _requireCanonical(String value, RegExp pattern, String field) {
  if (value.isEmpty ||
      value != value.trim() ||
      !pattern.hasMatch(value) ||
      value.contains('placeholder') ||
      value.contains('<') ||
      value.contains('>') ||
      value.runes.any((rune) => rune > 0x7f)) {
    throw FormatException('Synthetic $field is invalid.');
  }
}

enum ExactSyntheticAuthLookupStatus {
  notFound,
  exactlyOne,
  multipleMatchesBlocking,
  lookupRejected,
  authorizationRejected,
  environmentMismatch,
  targetMismatch,
  transportFailure,
  unknownFailure,
}

final class ExactSyntheticAuthLookupContext {
  const ExactSyntheticAuthLookupContext({
    required this.environment,
    required this.exactProjectConfirmed,
    required this.attemptAlias,
    required this.runNamespace,
    required this.fixtureManifestVersion,
    required this.lookupKey,
    required this.founderAuthorizationReference,
    required this.authorizedCommit,
    required this.operatorIdentity,
    required this.authorized,
  });

  final String environment;
  final bool exactProjectConfirmed;
  final String attemptAlias;
  final String runNamespace;
  final String fixtureManifestVersion;
  final SyntheticAuthLookupKey lookupKey;
  final String founderAuthorizationReference;
  final String authorizedCommit;
  final String operatorIdentity;
  final bool authorized;

  bool get isAttemptBound =>
      attemptAlias == lookupKey.attemptAlias &&
      runNamespace == lookupKey.runNamespace &&
      fixtureManifestVersion == lookupKey.fixtureManifestVersion;
}

final class SyntheticAuthDirectoryRecord {
  const SyntheticAuthDirectoryRecord({required this.id, required this.email});

  final String id;
  final String email;

  @override
  String toString() => 'SyntheticAuthDirectoryRecord(<redacted>)';
}

final class SyntheticAuthDirectoryPage {
  const SyntheticAuthDirectoryPage({
    required this.records,
    required this.isLastPage,
  });

  final List<SyntheticAuthDirectoryRecord> records;
  final bool isLastPage;
}

final class ExactSyntheticAuthDeleteTarget {
  const ExactSyntheticAuthDeleteTarget._({
    required String authUserId,
    required this.attemptAlias,
    required this.runNamespace,
    required this.lookupProof,
    required this.targetConfirmed,
    required this.authorizationReference,
  }) : _authUserId = authUserId;

  final String _authUserId;
  final String attemptAlias;
  final String runNamespace;
  final String lookupProof;
  final bool targetConfirmed;
  final String authorizationReference;

  T useExactUserId<T>(T Function(String exactUserId) operation) =>
      operation(_authUserId);

  @override
  String toString() => 'ExactSyntheticAuthDeleteTarget(<redacted>)';
}

final class ExactSyntheticAuthLookupResult {
  const ExactSyntheticAuthLookupResult._({
    required this.status,
    required this.exactMatchCount,
    this.deleteTarget,
  });

  final ExactSyntheticAuthLookupStatus status;
  final int? exactMatchCount;
  final ExactSyntheticAuthDeleteTarget? deleteTarget;

  Map<String, Object?> safeSummary() => {
    'status': status.name,
    'exactMatchCount': exactMatchCount,
    'deleteTarget': deleteTarget == null ? 'ABSENT' : 'EPHEMERAL',
  };

  @override
  String toString() => jsonEncode(safeSummary());
}

final class ExactSyntheticAuthLookup {
  const ExactSyntheticAuthLookup();

  ExactSyntheticAuthLookupResult resolve({
    required ExactSyntheticAuthLookupContext context,
    required List<SyntheticAuthDirectoryPage> pages,
    bool transportFailed = false,
  }) {
    if (context.environment != 'development') {
      return _result(ExactSyntheticAuthLookupStatus.environmentMismatch);
    }
    if (!context.exactProjectConfirmed) {
      return _result(ExactSyntheticAuthLookupStatus.targetMismatch);
    }
    if (!context.authorized ||
        context.founderAuthorizationReference.isEmpty ||
        context.authorizedCommit.isEmpty ||
        context.operatorIdentity.isEmpty) {
      return _result(ExactSyntheticAuthLookupStatus.authorizationRejected);
    }
    if (!context.isAttemptBound) {
      return _result(ExactSyntheticAuthLookupStatus.lookupRejected);
    }
    if (transportFailed) {
      return _result(ExactSyntheticAuthLookupStatus.transportFailure);
    }
    if (pages.isEmpty || pages.length > maximumAuthLookupPages) {
      return _result(ExactSyntheticAuthLookupStatus.lookupRejected);
    }
    if (!pages.last.isLastPage ||
        pages.take(pages.length - 1).any((page) => page.isLastPage)) {
      return _result(ExactSyntheticAuthLookupStatus.lookupRejected);
    }

    final matches = <SyntheticAuthDirectoryRecord>[];
    for (final page in pages) {
      for (final record in page.records) {
        if (context.lookupKey.matchesExact(record.email)) {
          matches.add(record);
          if (matches.length > 1) {
            return _result(
              ExactSyntheticAuthLookupStatus.multipleMatchesBlocking,
              count: matches.length,
            );
          }
        }
      }
    }
    if (matches.isEmpty) {
      return _result(ExactSyntheticAuthLookupStatus.notFound, count: 0);
    }
    final match = matches.single;
    if (match.id.isEmpty) {
      return _result(ExactSyntheticAuthLookupStatus.lookupRejected);
    }
    return ExactSyntheticAuthLookupResult._(
      status: ExactSyntheticAuthLookupStatus.exactlyOne,
      exactMatchCount: 1,
      deleteTarget: ExactSyntheticAuthDeleteTarget._(
        authUserId: match.id,
        attemptAlias: context.attemptAlias,
        runNamespace: context.runNamespace,
        lookupProof: 'EXACT_SYNTHETIC_EMAIL_MATCH',
        targetConfirmed: true,
        authorizationReference: context.founderAuthorizationReference,
      ),
    );
  }

  ExactSyntheticAuthLookupResult _result(
    ExactSyntheticAuthLookupStatus status, {
    int? count,
  }) =>
      ExactSyntheticAuthLookupResult._(status: status, exactMatchCount: count);
}

enum LocalContainmentStatus {
  containedCleanAlreadyAbsent,
  containedCleanDeleted,
  containedCleanRaceAlreadyAbsent,
  blockedIdentityCollision,
  containmentUnverifiableBlocking,
}

enum ExactAuthContainmentGateStatus {
  pass,
  remoteContextUnsafe,
  historicalIdentityMismatch,
  contractMissing,
  authorizationMissing,
  commitMismatch,
  targetMismatch,
  operatorMismatch,
  forbiddenOperationPresent,
}

final class ExactAuthContainmentPreflight {
  const ExactAuthContainmentPreflight();

  ExactAuthContainmentGateStatus evaluate({
    required bool remoteContextSafe,
    required bool historicalLookupDerivationMatches,
    required bool lookupContractPresent,
    required bool deleteContractPresent,
    required bool counterContractPresent,
    required bool founderAuthorizationPresent,
    required bool commitMatches,
    required bool targetMatches,
    required bool operatorMatches,
    required bool noNewFixtureSetup,
    required bool noMigration,
    required bool noDeploy,
    required bool noSecretMutation,
  }) {
    if (!remoteContextSafe) {
      return ExactAuthContainmentGateStatus.remoteContextUnsafe;
    }
    if (!historicalLookupDerivationMatches) {
      return ExactAuthContainmentGateStatus.historicalIdentityMismatch;
    }
    if (!lookupContractPresent ||
        !deleteContractPresent ||
        !counterContractPresent) {
      return ExactAuthContainmentGateStatus.contractMissing;
    }
    if (!founderAuthorizationPresent) {
      return ExactAuthContainmentGateStatus.authorizationMissing;
    }
    if (!commitMatches) return ExactAuthContainmentGateStatus.commitMismatch;
    if (!targetMatches) return ExactAuthContainmentGateStatus.targetMismatch;
    if (!operatorMatches) {
      return ExactAuthContainmentGateStatus.operatorMismatch;
    }
    if (!noNewFixtureSetup || !noMigration || !noDeploy || !noSecretMutation) {
      return ExactAuthContainmentGateStatus.forbiddenOperationPresent;
    }
    return ExactAuthContainmentGateStatus.pass;
  }
}

LocalContainmentStatus simulateExactAuthContainment({
  required ExactSyntheticAuthLookupResult initialLookup,
  required ExactSyntheticAuthLookupResult verificationLookup,
  required NamedResidueCounters counters,
  int? deleteStatus,
}) {
  if (initialLookup.status ==
      ExactSyntheticAuthLookupStatus.multipleMatchesBlocking) {
    return LocalContainmentStatus.blockedIdentityCollision;
  }
  if (initialLookup.status == ExactSyntheticAuthLookupStatus.notFound) {
    return verificationLookup.status ==
                ExactSyntheticAuthLookupStatus.notFound &&
            counters.isClean
        ? LocalContainmentStatus.containedCleanAlreadyAbsent
        : LocalContainmentStatus.containmentUnverifiableBlocking;
  }
  if (initialLookup.status != ExactSyntheticAuthLookupStatus.exactlyOne ||
      initialLookup.deleteTarget == null ||
      !authDeleteIsIdempotentSuccess(deleteStatus ?? 0) ||
      verificationLookup.status != ExactSyntheticAuthLookupStatus.notFound ||
      !counters.isClean) {
    return LocalContainmentStatus.containmentUnverifiableBlocking;
  }
  return deleteStatus == 200
      ? LocalContainmentStatus.containedCleanDeleted
      : LocalContainmentStatus.containedCleanRaceAlreadyAbsent;
}

void main(List<String> arguments) {
  if (arguments.length != 1 || arguments.single != '--local-preflight') {
    stderr.writeln('Exact Auth resolution preflight invocation invalid.');
    exitCode = 64;
    return;
  }
  final key = deriveDirtyAttemptAuthLookupKey(
    attemptAlias: dirtyAttemptAlias,
    runNamespace: dirtyRunNamespace,
    fixtureManifestVersion: dirtyFixtureContractVersion,
  );
  final historicalMatch = historicalSyntheticAuthLookupKeyMatches(key);
  final futureGate = const ExactAuthContainmentPreflight().evaluate(
    remoteContextSafe: true,
    historicalLookupDerivationMatches: historicalMatch,
    lookupContractPresent: true,
    deleteContractPresent: true,
    counterContractPresent: true,
    founderAuthorizationPresent: false,
    commitMatches: false,
    targetMatches: false,
    operatorMatches: false,
    noNewFixtureSetup: true,
    noMigration: true,
    noDeploy: true,
    noSecretMutation: true,
  );
  stdout.writeln(
    jsonEncode({
      'lookupKeyDerivationVersion': exactAuthLookupDerivationVersion,
      'attemptAlias': dirtyAttemptAlias,
      'runNamespace': dirtyRunNamespace,
      'fixtureManifestVersion': dirtyFixtureContractVersion,
      'committedAlias': exactAuthCommittedAlias,
      'matchPolicy': 'EXACT_CASE_SENSITIVE',
      'historicalMatch': historicalMatch
          ? 'HISTORICAL_SYNTHETIC_AUTH_LOOKUP_KEY_MATCH'
          : 'BLOCKED_HISTORICAL_IDENTITY_RECONSTRUCTION',
      'remoteAuthorization': 'NOT_GRANTED',
      'remoteExecution': 'NOT_EXECUTED',
      'futureContainmentGate': futureGate.name,
      'readiness': 'EXACT_AUTH_RESOLUTION_READY_FOR_CONTAINMENT_AUTHORIZATION',
    }),
  );
  if (!historicalMatch) {
    exitCode = 1;
  }
}

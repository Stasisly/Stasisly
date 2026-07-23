import 'dart:convert';
import 'dart:io';

const dirtyAttemptAlias = 'diag-20260723-002';
const dirtyRunNamespace = 'foundation-019a-r1-diag-20260723-002';
const dirtyAttemptCommit = 'd94292a';
const dirtyFixtureContractVersion = 'FOUNDATION-019A-R1-v1';

const residueCounterNames = <String>[
  'messages',
  'conversationIdempotency',
  'chatSessions',
  'publicUserProfiles',
  'specialistCatalogEntries',
  'specialists',
  'syntheticAuthUsers',
];

enum ContainmentReadiness {
  ready,
  blockedMissingExactAuthUserId,
  blockedInvalidContract,
}

final class NamedResidueCounters {
  const NamedResidueCounters._(this.values);

  factory NamedResidueCounters.fromPipe(String raw) {
    final parts = raw.trim().split('|');
    if (parts.length != residueCounterNames.length) {
      throw const FormatException('Residue counter count is invalid.');
    }
    final values = <String, int>{};
    for (var index = 0; index < parts.length; index++) {
      final value = int.tryParse(parts[index]);
      if (value == null || value < 0) {
        throw const FormatException('Residue counter value is invalid.');
      }
      values[residueCounterNames[index]] = value;
    }
    return NamedResidueCounters._(Map.unmodifiable(values));
  }

  final Map<String, int> values;

  bool get isClean => values.values.every((value) => value == 0);

  String get pipe => residueCounterNames.map((name) => values[name]).join('|');
}

final class DevelopmentDirtyRunContainment {
  const DevelopmentDirtyRunContainment({
    required this.attemptAlias,
    required this.runNamespace,
    required this.authorizedCommit,
    required this.fixtureContractVersion,
    required this.exactAuthUserIdAvailable,
  });

  factory DevelopmentDirtyRunContainment.approvedAttempt({
    required bool exactAuthUserIdAvailable,
  }) {
    return DevelopmentDirtyRunContainment(
      attemptAlias: dirtyAttemptAlias,
      runNamespace: dirtyRunNamespace,
      authorizedCommit: dirtyAttemptCommit,
      fixtureContractVersion: dirtyFixtureContractVersion,
      exactAuthUserIdAvailable: exactAuthUserIdAvailable,
    );
  }

  final String attemptAlias;
  final String runNamespace;
  final String authorizedCommit;
  final String fixtureContractVersion;
  final bool exactAuthUserIdAvailable;

  ContainmentReadiness get readiness {
    if (attemptAlias != dirtyAttemptAlias ||
        runNamespace != dirtyRunNamespace ||
        authorizedCommit != dirtyAttemptCommit ||
        fixtureContractVersion != dirtyFixtureContractVersion) {
      return ContainmentReadiness.blockedInvalidContract;
    }
    if (!exactAuthUserIdAvailable) {
      return ContainmentReadiness.blockedMissingExactAuthUserId;
    }
    return ContainmentReadiness.ready;
  }

  Map<String, Object> safeSummary() {
    return {
      'attemptAlias': attemptAlias,
      'runNamespace': runNamespace,
      'authorizedCommit': authorizedCommit,
      'fixtureContractVersion': fixtureContractVersion,
      'possibleResource': 'syntheticAuthUser',
      'exactAuthUserIdStatus': exactAuthUserIdAvailable
          ? 'AVAILABLE_AT_AUTHORIZED_RUNTIME'
          : 'UNAVAILABLE',
      'readiness': readiness.name,
    };
  }
}

bool authDeleteIsIdempotentSuccess(int statusCode) =>
    statusCode == 200 || statusCode == 404;

void main(List<String> arguments) {
  if (arguments.length != 1 || arguments.single != '--preflight') {
    stderr.writeln('Containment preflight invocation invalid.');
    exitCode = 64;
    return;
  }
  final contract = DevelopmentDirtyRunContainment.approvedAttempt(
    exactAuthUserIdAvailable: false,
  );
  stdout.writeln(jsonEncode(contract.safeSummary()));
  if (contract.readiness !=
      ContainmentReadiness.blockedMissingExactAuthUserId) {
    exitCode = 1;
  }
}

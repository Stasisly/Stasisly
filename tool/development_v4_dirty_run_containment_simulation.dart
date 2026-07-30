import 'dart:io';

import 'development_v4_dirty_run_containment_contracts.dart';
import 'development_v4_dirty_run_containment_runner.dart';

Future<void> main() async {
  final manifest = V4ContainmentManifest.read(
    File(
      'docs/stasisly_foundation/development/'
      'development_v4_dirty_run_containment_manifest.json',
    ),
  );
  final identity = V4RunIdentity.reconstruct('local-v4-simulation');
  final scenarios = <String, _Scenario>{
    'all seven initially zero': _Scenario([_zeroSnapshot()]),
    'one Conversation residue': _Scenario([
      _snapshot(residues: {'sessions'}),
      _zeroSnapshot(),
    ]),
    'one idempotency residue': _Scenario([
      _snapshot(residues: {'idempotency'}),
      _zeroSnapshot(),
    ]),
    'Conversation plus idempotency residue': _Scenario([
      _snapshot(residues: {'sessions', 'idempotency'}),
      _zeroSnapshot(),
    ]),
    'one profile residue': _Scenario([
      _snapshot(residues: {'profiles'}),
      _zeroSnapshot(),
    ]),
    'Auth already absent': _Scenario([_zeroSnapshot()]),
    'unknown Conversation handle': _Scenario([
      _snapshot(insufficient: {'sessions'}),
    ]),
    'ambiguous profile': _Scenario([
      _snapshot(unknown: {'profiles'}),
    ]),
    'canonical delete attempted': _Scenario([
      _snapshot(canonicalResidue: true),
    ]),
    'post-delete counter remains nonzero': _Scenario([
      _snapshot(residues: {'sessions'}),
      _snapshot(residues: {'sessions'}),
    ]),
    'CLI isolation failure': _Scenario([_zeroSnapshot()], isolate: false),
  };

  var passed = 0;
  for (final entry in scenarios.entries) {
    final result = await DevelopmentV4DirtyRunContainmentRunner(
      manifest: manifest,
      gateway: _SimulationGateway(entry.value),
    ).run(gate: _passingGate(), identity: identity);
    if (_expected(entry.key) == result.classification) passed++;
  }
  if (passed != scenarios.length) {
    stderr.writeln('V4_DIRTY_RUN_CONTAINMENT_SIMULATION_FAILED');
    exitCode = 1;
    return;
  }
  stdout.writeln('V4_DIRTY_RUN_CONTAINMENT_SIMULATIONS_11_PASS');
}

V4ContainmentClassification _expected(String name) => switch (name) {
  'all seven initially zero' ||
  'Auth already absent' => V4ContainmentClassification.diagnosedAlreadyClean,
  'one Conversation residue' ||
  'one idempotency residue' ||
  'Conversation plus idempotency residue' ||
  'one profile residue' => V4ContainmentClassification.containedClean,
  'unknown Conversation handle' =>
    V4ContainmentClassification.blockedInsufficientExactLookup,
  _ => V4ContainmentClassification.failedDirtyBlocking,
};

final class _Scenario {
  const _Scenario(this.snapshots, {this.isolate = true});

  final List<V4CounterSnapshot> snapshots;
  final bool isolate;
}

final class _SimulationGateway implements V4ContainmentGateway {
  _SimulationGateway(this.scenario);

  final _Scenario scenario;
  int reads = 0;

  @override
  Future<bool> deleteExact(V4ContainmentOperation operation) async =>
      !{'catalog', 'specialists'}.contains(operation.resource);

  @override
  Future<bool> isolateCli() async => scenario.isolate;

  @override
  Future<V4CounterSnapshot> readSevenCounters(V4RunIdentity identity) async {
    final index = reads < scenario.snapshots.length
        ? reads
        : scenario.snapshots.length - 1;
    reads++;
    return scenario.snapshots[index];
  }

  @override
  Future<bool> verifyAuthAbsence(V4RunIdentity identity) async => true;
}

V4CounterSnapshot _zeroSnapshot() => _snapshot();

V4CounterSnapshot _snapshot({
  Set<String> residues = const {},
  Set<String> unknown = const {},
  Set<String> insufficient = const {},
  bool canonicalResidue = false,
}) => V4CounterSnapshot([
  for (final name in v4CounterNames)
    if (unknown.contains(name))
      _unknown(name)
    else if (insufficient.contains(name))
      _insufficient(name)
    else if (canonicalResidue && name == 'catalog')
      _residue(name, canonical: true)
    else if (residues.contains(name))
      _residue(name)
    else
      _zero(name),
]);

V4CounterEvidence _zero(String name) => V4CounterEvidence(
  name: name,
  result: V4CounterResult.zero,
  count: 0,
  lookupExact: true,
  queryBound: {'catalog', 'specialists'}.contains(name) ? 0 : 2,
  ownership: {'catalog', 'specialists'}.contains(name)
      ? V4ResourceOwnership.verifiedPreexistingReadOnly
      : V4ResourceOwnership.createdByRun,
);

V4CounterEvidence _residue(String name, {bool canonical = false}) =>
    V4CounterEvidence(
      name: name,
      result: V4CounterResult.nonzeroExact,
      count: 1,
      lookupExact: true,
      queryBound: 2,
      ownership: canonical
          ? V4ResourceOwnership.verifiedPreexistingReadOnly
          : V4ResourceOwnership.createdByRun,
      ownershipProof: !canonical,
      deleteHandle: canonical ? null : V4OpaqueHandle.exact(name, 'opaque'),
    );

V4CounterEvidence _unknown(String name) => V4CounterEvidence(
  name: name,
  result: V4CounterResult.unknownBlocking,
  count: null,
  lookupExact: true,
  queryBound: 2,
  ownership: V4ResourceOwnership.unknown,
);

V4CounterEvidence _insufficient(String name) => V4CounterEvidence(
  name: name,
  result: V4CounterResult.nonzeroExact,
  count: 1,
  lookupExact: true,
  queryBound: 2,
  ownership: V4ResourceOwnership.unknown,
);

V4ContainmentRuntimeGate _passingGate() => const V4ContainmentRuntimeGate(
  founderAuthorizationMatches: true,
  authorizedCommitMatches: true,
  developmentTargetMatches: true,
  failedRunReferenceMatches: true,
  failedManifestMatches: true,
  failedRunnerMatches: true,
  containmentManifestMatches: true,
  containmentRunnerMatches: true,
  functionalRunnerDisabled: true,
  authCreationDisabled: true,
  conversationCreationDisabled: true,
  messageCreationDisabled: true,
  idempotencyReplayDisabled: true,
  catalogMutationDisabled: true,
  specialistMutationDisabled: true,
  exactLookupsOnly: true,
  broadLookupsBlocked: true,
  sevenCountersRequired: true,
  conversationAwareContainment: true,
  canonicalResourcesProtected: true,
  postDeleteCountersRequired: true,
  cliIsolationRequired: true,
  retentionLimitationAcknowledged: true,
);

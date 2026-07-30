import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/development_v4_dirty_run_containment_contracts.dart';
import '../../tool/development_v4_dirty_run_containment_runner.dart';

void main() {
  final manifest = V4ContainmentManifest.read(
    File(
      'docs/stasisly_foundation/development/'
      'development_v4_dirty_run_containment_manifest.json',
    ),
  );
  final identity = V4RunIdentity.reconstruct('runner-test-run');

  test('all seven initially zero is diagnosed already clean', () async {
    final gateway = _Gateway([_snapshot()]);
    final result = await _runner(
      manifest,
      gateway,
    ).run(gate: _gate(), identity: identity);
    expect(
      result.classification,
      V4ContainmentClassification.diagnosedAlreadyClean,
    );
    expect(result.operationsAttempted, 0);
    expect(gateway.deletes, isEmpty);
  });

  test('exact Conversation delete 200 or 404 can finish clean', () async {
    for (final deleteResult in [true, true]) {
      final gateway = _Gateway(
        [
          _snapshot(residues: {'sessions'}),
          _snapshot(),
        ],
        deleteResults: [deleteResult],
      );
      final result = await _runner(
        manifest,
        gateway,
      ).run(gate: _gate(), identity: identity);
      expect(result.classification, V4ContainmentClassification.containedClean);
      expect(gateway.deletes, ['sessions']);
    }
  });

  test('unexpected delete status stops and remains dirty', () async {
    final gateway = _Gateway(
      [
        _snapshot(residues: {'messages', 'sessions'}),
        _snapshot(residues: {'messages', 'sessions'}),
      ],
      deleteResults: [false],
    );
    final result = await _runner(
      manifest,
      gateway,
    ).run(gate: _gate(), identity: identity);
    expect(
      result.classification,
      V4ContainmentClassification.failedDirtyBlocking,
    );
    expect(gateway.deletes, ['messages']);
    expect(result.operationsAttempted, 1);
  });

  test('Conversation remaining after delete is dirty blocking', () async {
    final gateway = _Gateway([
      _snapshot(residues: {'sessions'}),
      _snapshot(residues: {'sessions'}),
    ]);
    final result = await _runner(
      manifest,
      gateway,
    ).run(gate: _gate(), identity: identity);
    expect(
      result.classification,
      V4ContainmentClassification.failedDirtyBlocking,
    );
  });

  test(
    'idempotency delete, already absent and post-delete nonzero are explicit',
    () async {
      final contained = await _runner(
        manifest,
        _Gateway([
          _snapshot(residues: {'idempotency'}),
          _snapshot(),
        ]),
      ).run(gate: _gate(), identity: identity);
      expect(
        contained.classification,
        V4ContainmentClassification.containedClean,
      );

      final absent = await _runner(
        manifest,
        _Gateway([_snapshot()]),
      ).run(gate: _gate(), identity: identity);
      expect(
        absent.classification,
        V4ContainmentClassification.diagnosedAlreadyClean,
      );

      final remains = await _runner(
        manifest,
        _Gateway([
          _snapshot(residues: {'idempotency'}),
          _snapshot(residues: {'idempotency'}),
        ]),
      ).run(gate: _gate(), identity: identity);
      expect(
        remains.classification,
        V4ContainmentClassification.failedDirtyBlocking,
      );
    },
  );

  test('ambiguous profile or Conversation blocks before any delete', () async {
    for (final resource in ['profiles', 'sessions']) {
      final gateway = _Gateway([
        _snapshot(unknown: {resource}),
      ]);
      final result = await _runner(
        manifest,
        gateway,
      ).run(gate: _gate(), identity: identity);
      expect(
        result.classification,
        V4ContainmentClassification.failedDirtyBlocking,
      );
      expect(gateway.deletes, isEmpty);
    }
  });

  test(
    'known Conversation residue without exact handle blocks lookup',
    () async {
      final gateway = _Gateway([
        _snapshot(insufficient: {'sessions'}),
      ]);
      final result = await _runner(
        manifest,
        gateway,
      ).run(gate: _gate(), identity: identity);
      expect(
        result.classification,
        V4ContainmentClassification.blockedInsufficientExactLookup,
      );
      expect(gateway.deletes, isEmpty);
    },
  );

  test(
    'canonical residue blocks and no canonical delete is attempted',
    () async {
      final gateway = _Gateway([_snapshot(canonicalResidue: true)]);
      final result = await _runner(
        manifest,
        gateway,
      ).run(gate: _gate(), identity: identity);
      expect(
        result.classification,
        V4ContainmentClassification.failedDirtyBlocking,
      );
      expect(gateway.deletes, isEmpty);
    },
  );

  test(
    'CLI isolation failure keeps result dirty and retries isolation',
    () async {
      final gateway = _Gateway([_snapshot()], isolate: false);
      final result = await _runner(
        manifest,
        gateway,
      ).run(gate: _gate(), identity: identity);
      expect(
        result.classification,
        V4ContainmentClassification.failedDirtyBlocking,
      );
      expect(gateway.isolationCalls, 2);
    },
  );

  test('Auth post-lookup failure keeps result dirty', () async {
    final result = await _runner(
      manifest,
      _Gateway([_snapshot()], authAbsent: false),
    ).run(gate: _gate(), identity: identity);
    expect(
      result.classification,
      V4ContainmentClassification.failedDirtyBlocking,
    );
  });

  test('wrong authorization or commit blocks before gateway use', () async {
    for (final gate in [_gate(founder: false), _gate(commit: false)]) {
      final gateway = _Gateway([_snapshot()]);
      await expectLater(
        _runner(manifest, gateway).run(gate: gate, identity: identity),
        throwsStateError,
      );
      expect(gateway.reads, 0);
    }
  });

  test('safe evidence exposes categories but no handles', () async {
    final result = await _runner(
      manifest,
      _Gateway([_snapshot()]),
    ).run(gate: _gate(), identity: identity);
    final evidence = result.safeEvidence().toString();
    expect(evidence, contains('classification'));
    for (final forbidden in [
      'runAlias',
      'conversationId',
      'profileId',
      'authId',
      'idempotencyKey',
    ]) {
      expect(evidence, isNot(contains(forbidden)));
    }
  });
}

DevelopmentV4DirtyRunContainmentRunner _runner(
  V4ContainmentManifest manifest,
  V4ContainmentGateway gateway,
) => DevelopmentV4DirtyRunContainmentRunner(
  manifest: manifest,
  gateway: gateway,
);

final class _Gateway implements V4ContainmentGateway {
  _Gateway(
    this.snapshots, {
    this.deleteResults = const [true],
    this.authAbsent = true,
    this.isolate = true,
  });

  final List<V4CounterSnapshot> snapshots;
  final List<bool> deleteResults;
  final bool authAbsent;
  final bool isolate;
  final List<String> deletes = <String>[];
  int reads = 0;
  int isolationCalls = 0;

  @override
  Future<bool> deleteExact(V4ContainmentOperation operation) async {
    deletes.add(operation.resource);
    final index = deletes.length - 1;
    return index >= deleteResults.length || deleteResults[index];
  }

  @override
  Future<bool> isolateCli() async {
    isolationCalls++;
    return isolate;
  }

  @override
  Future<V4CounterSnapshot> readSevenCounters(V4RunIdentity identity) async {
    final index = reads < snapshots.length ? reads : snapshots.length - 1;
    reads++;
    return snapshots[index];
  }

  @override
  Future<bool> verifyAuthAbsence(V4RunIdentity identity) async => authAbsent;
}

V4CounterSnapshot _snapshot({
  Set<String> residues = const {},
  Set<String> unknown = const {},
  Set<String> insufficient = const {},
  bool canonicalResidue = false,
}) => V4CounterSnapshot([
  for (final name in v4CounterNames)
    if (unknown.contains(name))
      V4CounterEvidence(
        name: name,
        result: V4CounterResult.unknownBlocking,
        count: null,
        lookupExact: true,
        queryBound: 2,
        ownership: V4ResourceOwnership.unknown,
      )
    else if (insufficient.contains(name))
      V4CounterEvidence(
        name: name,
        result: V4CounterResult.nonzeroExact,
        count: 1,
        lookupExact: true,
        queryBound: 2,
        ownership: V4ResourceOwnership.unknown,
      )
    else if ((canonicalResidue && name == 'catalog') || residues.contains(name))
      V4CounterEvidence(
        name: name,
        result: V4CounterResult.nonzeroExact,
        count: 1,
        lookupExact: true,
        queryBound: 2,
        ownership: canonicalResidue && name == 'catalog'
            ? V4ResourceOwnership.verifiedPreexistingReadOnly
            : V4ResourceOwnership.createdByRun,
        ownershipProof: !(canonicalResidue && name == 'catalog'),
        deleteHandle: canonicalResidue && name == 'catalog'
            ? null
            : V4OpaqueHandle.exact(name, 'opaque'),
      )
    else
      V4CounterEvidence(
        name: name,
        result: V4CounterResult.zero,
        count: 0,
        lookupExact: true,
        queryBound: {'catalog', 'specialists'}.contains(name) ? 0 : 2,
        ownership: {'catalog', 'specialists'}.contains(name)
            ? V4ResourceOwnership.verifiedPreexistingReadOnly
            : V4ResourceOwnership.createdByRun,
      ),
]);

V4ContainmentRuntimeGate _gate({bool founder = true, bool commit = true}) =>
    V4ContainmentRuntimeGate(
      founderAuthorizationMatches: founder,
      authorizedCommitMatches: commit,
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

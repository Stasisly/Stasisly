import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/development_v4_dirty_run_containment_contracts.dart';

void main() {
  final manifest = V4ContainmentManifest.read(
    File(
      'docs/stasisly_foundation/development/'
      'development_v4_dirty_run_containment_manifest.json',
    ),
  );

  test('manifest binds the consumed v4 run and keeps remote closed', () {
    expect(manifest.version, v4ContainmentManifestVersion);
    expect(manifest.runnerVersion, v4ContainmentRunnerVersion);
    expect(
      manifest.failedAuthorizationReference,
      v4FailedAuthorizationReference,
    );
    expect(manifest.failedAuthorizationState, 'CONSUMED');
    expect(manifest.failedAuthorizationReusable, isFalse);
    expect(manifest.failedCommit, v4FailedCommit);
    expect(manifest.remoteAuthorization, 'NOT_GRANTED');
    expect(manifest.remoteExecution, 'NOT_EXECUTED');
    expect(manifest.validate(), isEmpty);
  });

  group('exact failed-run identity', () {
    test('reconstructs alias-derived operation and profile handles', () {
      final identity = V4RunIdentity.reconstruct('contained-run-01');
      expect(
        identity.useOperationAttempt((value) => value.endsWith('_create_0001')),
        isTrue,
      );
      expect(
        identity.useIdempotencyKey((value) => value.endsWith('_create_0001')),
        isTrue,
      );
      expect(
        identity.useProfileMarker((value) => value.startsWith('Synthetic ')),
        isTrue,
      );
      expect(identity.toString(), contains('<redacted>'));
    });

    test(
      'rejects wrong alias derivation and missing OperationAttempt input',
      () {
        for (final value in ['', 'UPPERCASE-RUN', 'short', 'bad_alias_value']) {
          expect(
            () => V4RunIdentity.reconstruct(value),
            throwsFormatException,
            reason: value,
          );
        }
      },
    );

    test('handle strategy never exposes canonical delete identity', () {
      final strategy = v4FailedRunHandleStrategy();
      expect(
        strategy['conversationHandle'],
        V4HandleClassification.availableFromSanitizedLedger,
      );
      expect(
        strategy['canonicalSpecialistId'],
        V4HandleClassification.unsafeForLookup,
      );
      expect(
        strategy['canonicalCatalogId'],
        V4HandleClassification.unsafeForLookup,
      );
    });
  });

  group('seven counters', () {
    test('each counter models zero, exact residue and blocking failures', () {
      for (final name in v4CounterNames) {
        expect(_zero(name).isStructurallyValid, isTrue);
        for (final count in [1, 2]) {
          expect(_residue(name, count: count).isStructurallyValid, isTrue);
        }
        for (final result in [
          V4CounterResult.unknownBlocking,
          V4CounterResult.queryNotExecuted,
          V4CounterResult.queryFailed,
        ]) {
          expect(_failure(name, result).isStructurallyValid, isTrue);
        }
      }
    });

    test(
      'missing, reordered and parse-failed evidence cannot form a snapshot',
      () {
        expect(
          () => V4CounterSnapshot(v4CounterNames.skip(1).map(_zero).toList()),
          throwsStateError,
        );
        expect(
          () => V4CounterSnapshot(v4CounterNames.reversed.map(_zero).toList()),
          throwsStateError,
        );
        expect(
          () => V4CounterSnapshot([
            for (final name in v4CounterNames)
              name == 'messages'
                  ? V4CounterEvidence(
                      name: name,
                      result: V4CounterResult.zero,
                      count: null,
                      lookupExact: true,
                      queryBound: 2,
                      ownership: V4ResourceOwnership.createdByRun,
                    )
                  : _zero(name),
          ]),
          throwsStateError,
        );
      },
    );

    test('post-delete zero is the only clean vector', () {
      final zero = _snapshot();
      expect(zero.allZero, isTrue);
      expect(zero.safeCounts.join('|'), '0|0|0|0|0|0|0');
      expect(_snapshot(residues: {'sessions'}).allZero, isFalse);
      expect(_snapshot(unknown: {'auth'}).hasUnknown, isTrue);
    });
  });

  group('Conversation and idempotency containment', () {
    test('Conversation absent produces no operation', () {
      expect(const V4ExactContainmentPlanner().plan(_snapshot()), isEmpty);
    });

    test('one exact run-owned Conversation is deletable', () {
      final plan = const V4ExactContainmentPlanner().plan(
        _snapshot(residues: {'sessions'}),
      );
      expect(plan.map((operation) => operation.resource), ['sessions']);
    });

    test('Conversation with messages follows dependency order', () {
      final plan = const V4ExactContainmentPlanner().plan(
        _snapshot(residues: {'messages', 'sessions'}),
      );
      expect(plan.map((operation) => operation.resource), [
        'messages',
        'sessions',
      ]);
    });

    test('Conversation with idempotency follows dependency order', () {
      final plan = const V4ExactContainmentPlanner().plan(
        _snapshot(residues: {'idempotency', 'sessions'}),
      );
      expect(plan.map((operation) => operation.resource), [
        'idempotency',
        'sessions',
      ]);
    });

    test('ambiguous, foreign and unknown Conversation stay blocked', () {
      expect(
        () => const V4ExactContainmentPlanner().plan(
          _snapshot(unknown: {'sessions'}),
        ),
        throwsA(isA<V4ContainmentPlanningException>()),
      );
      expect(
        () => const V4ExactContainmentPlanner().plan(
          _snapshot(
            replacements: {
              'sessions': _residue(
                'sessions',
                ownership: V4ResourceOwnership.foreign,
                proof: false,
              ),
            },
          ),
        ),
        throwsA(isA<V4ContainmentPlanningException>()),
      );
    });

    test('idempotency absent, exact, multiple and unknown are explicit', () {
      expect(_snapshot().counters[1].result, V4CounterResult.zero);
      expect(
        _snapshot(residues: {'idempotency'}).counters[1].result,
        V4CounterResult.nonzeroExact,
      );
      expect(
        _snapshot(
          replacements: {'idempotency': _residue('idempotency', count: 2)},
        ).counters[1].count,
        2,
      );
      expect(
        _snapshot(unknown: {'idempotency'}).counters[1].result,
        V4CounterResult.unknownBlocking,
      );
    });

    test('retention blocker remains independent of exact containment', () {
      expect(v4RetentionLimitation, 'POST_DEVELOPMENT_OPERATIONAL_BLOCKER');
      expect(manifest.retentionLimitation, v4RetentionLimitation);
    });
  });

  group('canonical protection and classifications', () {
    test(
      'catalog, specialist, preexisting and unknown deletes are blocked',
      () {
        for (final replacement in [
          {'catalog': _residue('catalog')},
          {'specialists': _residue('specialists')},
          {
            'profiles': _residue(
              'profiles',
              ownership: V4ResourceOwnership.verifiedPreexistingReadOnly,
              proof: false,
            ),
          },
          {
            'profiles': _residue(
              'profiles',
              ownership: V4ResourceOwnership.unknown,
              proof: false,
            ),
          },
        ]) {
          expect(
            () => const V4ExactContainmentPlanner().plan(
              _snapshot(replacements: replacement),
            ),
            throwsA(isA<V4ContainmentPlanningException>()),
          );
        }
      },
    );

    test('classifies already clean, contained and dirty outcomes', () {
      final zero = _snapshot();
      final residue = _snapshot(residues: {'sessions'});
      expect(
        classifyV4Containment(
          initial: zero,
          finalSnapshot: zero,
          operationsAttempted: 0,
          operationsSucceeded: true,
          authAbsenceVerified: true,
          cliIsolated: true,
        ),
        V4ContainmentClassification.diagnosedAlreadyClean,
      );
      expect(
        classifyV4Containment(
          initial: residue,
          finalSnapshot: zero,
          operationsAttempted: 1,
          operationsSucceeded: true,
          authAbsenceVerified: true,
          cliIsolated: true,
        ),
        V4ContainmentClassification.containedClean,
      );
      for (final finalSnapshot in [
        residue,
        _snapshot(unknown: {'sessions'}),
      ]) {
        expect(
          classifyV4Containment(
            initial: residue,
            finalSnapshot: finalSnapshot,
            operationsAttempted: 1,
            operationsSucceeded: false,
            authAbsenceVerified: true,
            cliIsolated: true,
          ),
          V4ContainmentClassification.failedDirtyBlocking,
        );
      }
    });
  });

  group('gate and failure diagnosis', () {
    test('all 23 future gate checks pass only together', () {
      expect(_gate().validate(), isEmpty);
      expect(_gate(founder: false).validate(), [
        'FOUNDER_CONTAINMENT_AUTHORIZATION_MATCH',
      ]);
      expect(_gate(commit: false).validate(), ['AUTHORIZED_COMMIT_MATCH']);
    });

    test('post-create evidence stays unknown when incomplete', () {
      expect(
        classifyV4PostCreateFailure(
          replayRequestSent: false,
          replayResponseReceived: false,
          replayResponseValid: false,
          replayContractMatched: false,
          replayConflict: false,
          conversationCountRequestFailed: false,
          stateTransitionFailed: false,
          ledgerFailed: false,
          evidenceComplete: false,
        ),
        V4FailureCategory.unknownPostCreateFailure,
      );
    });
  });
}

V4CounterSnapshot _snapshot({
  Set<String> residues = const {},
  Set<String> unknown = const {},
  Map<String, V4CounterEvidence> replacements = const {},
}) => V4CounterSnapshot([
  for (final name in v4CounterNames)
    replacements[name] ??
        (unknown.contains(name)
            ? _failure(name, V4CounterResult.unknownBlocking)
            : residues.contains(name)
            ? _residue(name)
            : _zero(name)),
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

V4CounterEvidence _residue(
  String name, {
  int count = 1,
  V4ResourceOwnership ownership = V4ResourceOwnership.createdByRun,
  bool proof = true,
}) => V4CounterEvidence(
  name: name,
  result: V4CounterResult.nonzeroExact,
  count: count,
  lookupExact: true,
  queryBound: 2,
  ownership: ownership,
  ownershipProof: proof,
  deleteHandle: proof ? V4OpaqueHandle.exact(name, 'opaque') : null,
);

V4CounterEvidence _failure(String name, V4CounterResult result) =>
    V4CounterEvidence(
      name: name,
      result: result,
      count: null,
      lookupExact: true,
      queryBound: 2,
      ownership: V4ResourceOwnership.unknown,
    );

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

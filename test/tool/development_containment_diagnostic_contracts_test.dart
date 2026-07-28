import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/development_containment_diagnostic_contracts.dart';
import '../../tool/development_containment_diagnostic_runner.dart';

const _candidate = CatalogCandidateObservation(
  statusValid: true,
  selectable: true,
  productAvailable: true,
  environmentCompatible: true,
);

void main() {
  final manifest = ContainmentDiagnosticManifest.read(
    File(
      'docs/stasisly_foundation/development/'
      'development_containment_diagnostic_manifest.json',
    ),
  );

  test('R2F manifest is exact, closed and locally valid', () {
    expect(manifest.version, containmentDiagnosticManifestVersion);
    expect(manifest.runnerVersion, containmentDiagnosticRunnerVersion);
    expect(manifest.counterNames, containmentCounterNames);
    expect(manifest.catalogArea, 'stasis');
    expect(manifest.catalogLimit, 20);
    expect(manifest.catalogMaximumPages, 1);
    expect(manifest.remoteAuthorization, 'NOT_GRANTED');
    expect(manifest.futureAuthorization, 'NOT_GRANTED');
    expect(manifest.validate(), isEmpty);
  });

  group('catalog diagnostic', () {
    const diagnostic = CanonicalSpecialistCatalogDiagnostic();

    test('classifies zero, one and multiple candidates', () {
      expect(
        diagnostic.classify(const CatalogDiagnosticObservation()),
        CatalogDiagnosticCategory.zeroAvailableCandidates,
      );
      expect(
        diagnostic.classify(
          const CatalogDiagnosticObservation(candidates: [_candidate]),
        ),
        CatalogDiagnosticCategory.exactlyOneAvailableCandidate,
      );
      expect(
        diagnostic.classify(
          const CatalogDiagnosticObservation(
            candidates: [_candidate, _candidate],
          ),
        ),
        CatalogDiagnosticCategory.multipleAvailableCandidates,
      );
    });

    test('classifies transport, HTTP, body and contract failures', () {
      expect(
        diagnostic.classify(
          const CatalogDiagnosticObservation(transportSucceeded: false),
        ),
        CatalogDiagnosticCategory.catalogTransportFailure,
      );
      expect(
        diagnostic.classify(
          const CatalogDiagnosticObservation(httpStatus: 503),
        ),
        CatalogDiagnosticCategory.catalogHttpNonSuccess,
      );
      expect(
        diagnostic.classify(
          const CatalogDiagnosticObservation(jsonDecoded: false),
        ),
        CatalogDiagnosticCategory.catalogBodyInvalid,
      );
      expect(
        diagnostic.classify(
          const CatalogDiagnosticObservation(contractValid: false),
        ),
        CatalogDiagnosticCategory.catalogContractInvalid,
      );
    });

    test('classifies bounded pagination and area failures', () {
      expect(
        diagnostic.classify(
          const CatalogDiagnosticObservation(paginationValid: false),
        ),
        CatalogDiagnosticCategory.catalogPaginationInvalid,
      );
      expect(
        diagnostic.classify(
          const CatalogDiagnosticObservation(cursorCycle: true),
        ),
        CatalogDiagnosticCategory.catalogCursorCycle,
      );
      expect(
        diagnostic.classify(
          const CatalogDiagnosticObservation(pageLimitReached: true),
        ),
        CatalogDiagnosticCategory.catalogPageLimitReached,
      );
      expect(
        diagnostic.classify(
          const CatalogDiagnosticObservation(canonicalAreaPresent: false),
        ),
        CatalogDiagnosticCategory.canonicalAreaNotFound,
      );
      expect(
        diagnostic.classify(
          const CatalogDiagnosticObservation(
            requiresRemoteAreaConfirmation: true,
          ),
        ),
        CatalogDiagnosticCategory.canonicalAreaContractRequiresRemoteDiagnostic,
      );
    });

    test('classifies candidate guard failures without candidate data', () {
      CatalogDiagnosticCategory classify(CatalogCandidateObservation value) =>
          diagnostic.classify(
            CatalogDiagnosticObservation(candidates: [value]),
          );

      expect(
        classify(
          const CatalogCandidateObservation(
            statusValid: false,
            selectable: true,
            productAvailable: true,
            environmentCompatible: true,
          ),
        ),
        CatalogDiagnosticCategory.candidateStatusInvalid,
      );
      expect(
        classify(
          const CatalogCandidateObservation(
            statusValid: true,
            selectable: false,
            productAvailable: true,
            environmentCompatible: true,
          ),
        ),
        CatalogDiagnosticCategory.candidateNotSelectable,
      );
      expect(
        classify(
          const CatalogCandidateObservation(
            statusValid: true,
            selectable: true,
            productAvailable: false,
            environmentCompatible: true,
          ),
        ),
        CatalogDiagnosticCategory.candidateProductUnavailable,
      );
      expect(
        classify(
          const CatalogCandidateObservation(
            statusValid: true,
            selectable: true,
            productAvailable: true,
            environmentCompatible: false,
          ),
        ),
        CatalogDiagnosticCategory.candidateEnvironmentMismatch,
      );
    });

    test('request not executed remains explicit', () {
      expect(
        diagnostic.classify(
          const CatalogDiagnosticObservation(requestExecuted: false),
        ),
        CatalogDiagnosticCategory.catalogRequestNotExecuted,
      );
    });

    test('unknown catalog failure remains explicit', () {
      expect(
        diagnostic.classify(
          const CatalogDiagnosticObservation(unknownFailure: true),
        ),
        CatalogDiagnosticCategory.unknownCatalogFailure,
      );
    });
  });

  group('seven counters', () {
    test('each counter supports zero and bounded exact residues', () {
      for (final name in containmentCounterNames) {
        expect(_zero(name).isValid, isTrue);
        for (final count in [1, 2]) {
          expect(
            CounterEvidence(
              name: name,
              result: CounterResultCategory.nonzeroExact,
              count: count,
              lookupExact: true,
              queryBound: 2,
              ownership: ResourceOwnership.createdByFailedRun,
              exactOwnershipProof: true,
              exactDeleteHandle: true,
            ).isValid,
            isTrue,
          );
        }
      }
    });

    test(
      'each counter keeps unknown, parse and transport failures nonzero',
      () {
        for (final name in containmentCounterNames) {
          for (final result in [
            CounterResultCategory.unknownBlocking,
            CounterResultCategory.queryNotExecuted,
            CounterResultCategory.queryFailed,
          ]) {
            final counter = CounterEvidence(
              name: name,
              result: result,
              count: null,
              lookupExact: true,
              queryBound: 2,
              ownership: ResourceOwnership.unknownOwnership,
            );
            expect(counter.isValid, isTrue);
            expect(
              classifyContainment(
                catalog: CatalogDiagnosticCategory.exactlyOneAvailableCandidate,
                counters: _replaceCounter(counter),
                containmentCompleted: false,
                cliIsolated: true,
              ),
              ContainmentClassification.failedDirtyBlocking,
            );
          }
        }
      },
    );

    test('global or unscoped lookup is blocked for every counter', () {
      for (final name in containmentCounterNames) {
        for (final ownership in [
          ResourceOwnership.globalResource,
          ResourceOwnership.unscopedResource,
          ResourceOwnership.unknownOwnership,
        ]) {
          expect(
            () => const ExactContainmentPlanner().plan(
              _replaceCounter(
                CounterEvidence(
                  name: name,
                  result: CounterResultCategory.nonzeroExact,
                  count: 1,
                  lookupExact: ownership != ResourceOwnership.globalResource,
                  queryBound: 2,
                  ownership: ownership,
                ),
              ),
            ),
            throwsStateError,
          );
        }
      }
    });
  });

  group('containment', () {
    test('no residue needs no operation', () {
      expect(const ExactContainmentPlanner().plan(_zeroCounters()), isEmpty);
    });

    test('each mutable exact run-owned residue becomes one operation', () {
      for (final name in ['messages', 'idempotency', 'sessions', 'profiles']) {
        final counters = _replaceCounter(
          CounterEvidence(
            name: name,
            result: CounterResultCategory.nonzeroExact,
            count: 1,
            lookupExact: true,
            queryBound: 2,
            ownership: ResourceOwnership.createdByFailedRun,
            exactOwnershipProof: true,
            exactDeleteHandle: true,
          ),
        );
        final operations = const ExactContainmentPlanner().plan(counters);
        expect(operations.single.resourceName, name);
      }
    });

    test('canonical catalog and specialist deletion is always forbidden', () {
      for (final name in ['catalog', 'specialists']) {
        expect(
          () => const ExactContainmentPlanner().plan(
            _replaceCounter(
              CounterEvidence(
                name: name,
                result: CounterResultCategory.nonzeroExact,
                count: 1,
                lookupExact: true,
                queryBound: 1,
                ownership: ResourceOwnership.createdByFailedRun,
                exactOwnershipProof: true,
                exactDeleteHandle: true,
              ),
            ),
          ),
          throwsStateError,
        );
      }
    });

    test('read-only and missing proof or handle cannot be contained', () {
      for (final counter in [
        const CounterEvidence(
          name: 'profiles',
          result: CounterResultCategory.nonzeroExact,
          count: 1,
          lookupExact: true,
          queryBound: 2,
          ownership: ResourceOwnership.verifiedPreexistingReadOnly,
          exactOwnershipProof: true,
          exactDeleteHandle: true,
        ),
        const CounterEvidence(
          name: 'profiles',
          result: CounterResultCategory.nonzeroExact,
          count: 1,
          lookupExact: true,
          queryBound: 2,
          ownership: ResourceOwnership.createdByFailedRun,
        ),
      ]) {
        expect(
          () => const ExactContainmentPlanner().plan(_replaceCounter(counter)),
          throwsStateError,
        );
      }
    });

    test('exact delete accepts only 200 and already-absent 404', () {
      expect(exactContainmentDeleteSucceeded(200), isTrue);
      expect(exactContainmentDeleteSucceeded(404), isTrue);
      for (final status in [0, 201, 204, 400, 401, 403, 409, 500]) {
        expect(exactContainmentDeleteSucceeded(status), isFalse);
      }
    });

    test('nonzero counter after delete remains blocked', () {
      expect(
        classifyContainment(
          catalog: CatalogDiagnosticCategory.exactlyOneAvailableCandidate,
          counters: _withExactResidue('profiles'),
          containmentCompleted: true,
          cliIsolated: true,
        ),
        ContainmentClassification.blockedInsufficientExactLookup,
      );
    });
  });

  test('runtime gate isolates containment from functional authorization', () {
    const passing = ContainmentRuntimeGateInput(
      founderAuthorizationMatches: true,
      authorizedCommitMatches: true,
      developmentTargetMatches: true,
      manifestMatches: true,
      runnerMatches: true,
      functionalRunnerDisabled: true,
      authCreationDisabled: true,
      conversationCreationDisabled: true,
      catalogMutationDisabled: true,
      specialistMutationDisabled: true,
      exactLookupsOnly: true,
      sevenCountersPresent: true,
      canonicalResourcesProtected: true,
      cliIsolationPresent: true,
    );
    expect(passing.validate(), isEmpty);
    expect(
      const ContainmentRuntimeGateInput(
        founderAuthorizationMatches: false,
        authorizedCommitMatches: true,
        developmentTargetMatches: true,
        manifestMatches: true,
        runnerMatches: true,
        functionalRunnerDisabled: false,
        authCreationDisabled: false,
        conversationCreationDisabled: false,
        catalogMutationDisabled: true,
        specialistMutationDisabled: true,
        exactLookupsOnly: true,
        sevenCountersPresent: true,
        canonicalResourcesProtected: true,
        cliIsolationPresent: true,
      ).validate(),
      containsAll([
        'FOUNDER_CONTAINMENT_AUTHORIZATION_MATCH',
        'FUNCTIONAL_RUNNER_DISABLED',
        'AUTH_CREATION_DISABLED',
        'CONVERSATION_CREATION_DISABLED',
      ]),
    );
  });

  test('runner emits sanitized categories only', () async {
    final runner = DevelopmentContainmentDiagnosticRunner(
      manifest: manifest,
      gateway: _FakeGateway(),
    );
    final result = await runner.run(_passingGate());
    final evidence = result.safeEvidence().toString();
    expect(evidence, contains('diagnosedFailedClean'));
    expect(evidence, isNot(contains('@')));
    expect(evidence, isNot(contains('https://')));
    expect(evidence, isNot(contains('Id')));
  });

  test('failed-run handle strategy never invents an unavailable ID', () {
    final handles = failedRunHandleStrategy();
    expect(handles['runAlias'], RunHandleClassification.availableEphemerally);
    expect(
      handles['operationAttemptId'],
      RunHandleClassification.reconstructableExact,
    );
    expect(handles['ownerAuthId'], RunHandleClassification.notAvailable);
    expect(handles['conversationId'], RunHandleClassification.notAvailable);
    expect(handles['specialistId'], RunHandleClassification.unsafeForLookup);
  });
}

CounterEvidence _zero(String name) => CounterEvidence(
  name: name,
  result: CounterResultCategory.zero,
  count: 0,
  lookupExact: true,
  queryBound: name == 'profiles' ? 2 : 0,
  ownership: name == 'catalog' || name == 'specialists'
      ? ResourceOwnership.verifiedPreexistingReadOnly
      : ResourceOwnership.createdByFailedRun,
);

List<CounterEvidence> _zeroCounters() =>
    containmentCounterNames.map(_zero).toList(growable: false);

List<CounterEvidence> _replaceCounter(CounterEvidence replacement) => [
  for (final counter in _zeroCounters())
    if (counter.name == replacement.name) replacement else counter,
];

List<CounterEvidence> _withExactResidue(String name) => _replaceCounter(
  CounterEvidence(
    name: name,
    result: CounterResultCategory.nonzeroExact,
    count: 1,
    lookupExact: true,
    queryBound: 2,
    ownership: ResourceOwnership.createdByFailedRun,
    exactOwnershipProof: true,
    exactDeleteHandle: true,
  ),
);

ContainmentRuntimeGateInput _passingGate() => const ContainmentRuntimeGateInput(
  founderAuthorizationMatches: true,
  authorizedCommitMatches: true,
  developmentTargetMatches: true,
  manifestMatches: true,
  runnerMatches: true,
  functionalRunnerDisabled: true,
  authCreationDisabled: true,
  conversationCreationDisabled: true,
  catalogMutationDisabled: true,
  specialistMutationDisabled: true,
  exactLookupsOnly: true,
  sevenCountersPresent: true,
  canonicalResourcesProtected: true,
  cliIsolationPresent: true,
);

final class _FakeGateway implements ContainmentDiagnosticGateway {
  @override
  Future<bool> containExact(List<ContainmentOperation> operations) async =>
      operations.isEmpty;

  @override
  Future<CatalogDiagnosticObservation> diagnoseCatalog() async =>
      const CatalogDiagnosticObservation(contractValid: false);

  @override
  Future<bool> isolateCli() async => true;

  @override
  Future<List<CounterEvidence>> readSevenCounters() async => _zeroCounters();
}

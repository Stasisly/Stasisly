import 'dart:io';

import 'development_containment_diagnostic_contracts.dart';
import 'development_containment_diagnostic_runner.dart';

const _candidate = CatalogCandidateObservation(
  statusValid: true,
  selectable: true,
  productAvailable: true,
  environmentCompatible: true,
);

Future<void> main() async {
  final manifest = ContainmentDiagnosticManifest.read(
    File(
      'docs/stasisly_foundation/development/'
      'development_containment_diagnostic_manifest.json',
    ),
  );
  final cases = <_SimulationCase>[
    _SimulationCase(
      'catalog-zero-seven-zero',
      const CatalogDiagnosticObservation(),
      _zeros(),
      ContainmentClassification.diagnosedFailedClean,
    ),
    _SimulationCase(
      'catalog-multiple-seven-zero',
      const CatalogDiagnosticObservation(candidates: [_candidate, _candidate]),
      _zeros(),
      ContainmentClassification.diagnosedFailedClean,
    ),
    _SimulationCase(
      'catalog-invalid-seven-zero',
      const CatalogDiagnosticObservation(contractValid: false),
      _zeros(),
      ContainmentClassification.diagnosedFailedClean,
    ),
    _SimulationCase(
      'profile-contained',
      const CatalogDiagnosticObservation(candidates: [_candidate]),
      _withExactResidue('profiles'),
      ContainmentClassification.containedClean,
      containmentSucceeds: true,
    ),
    _SimulationCase(
      'session-contained',
      const CatalogDiagnosticObservation(candidates: [_candidate]),
      _withExactResidue('sessions'),
      ContainmentClassification.containedClean,
      containmentSucceeds: true,
    ),
    _SimulationCase(
      'auth-already-absent',
      const CatalogDiagnosticObservation(candidates: [_candidate]),
      _zeros(),
      ContainmentClassification.containedClean,
    ),
    _SimulationCase(
      'unknown-counter',
      const CatalogDiagnosticObservation(candidates: [_candidate]),
      _replace(
        const CounterEvidence(
          name: 'profiles',
          result: CounterResultCategory.unknownBlocking,
          count: null,
          lookupExact: true,
          queryBound: 2,
          ownership: ResourceOwnership.unknownOwnership,
        ),
      ),
      ContainmentClassification.failedDirtyBlocking,
    ),
  ];

  for (final simulation in cases) {
    final runner = DevelopmentContainmentDiagnosticRunner(
      manifest: manifest,
      gateway: _SimulationGateway(simulation),
    );
    final result = await runner.run(_passingGate());
    if (result.classification != simulation.expected) {
      throw StateError('SIMULATION_CLASSIFICATION_MISMATCH');
    }
  }

  _expectThrows(
    () => const ExactContainmentPlanner().plan(_withExactResidue('catalog')),
  );
  await _expectAsyncThrows(
    () =>
        DevelopmentContainmentDiagnosticRunner(
          manifest: manifest,
          gateway: _SimulationGateway(cases.first),
        ).run(
          const ContainmentRuntimeGateInput(
            founderAuthorizationMatches: true,
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
          ),
        ),
  );
  final isolationFailure = await DevelopmentContainmentDiagnosticRunner(
    manifest: manifest,
    gateway: _SimulationGateway(cases.last, isolate: false),
  ).run(_passingGate());
  if (isolationFailure.classification !=
      ContainmentClassification.failedDirtyBlocking) {
    throw StateError('CLI_ISOLATION_FAILURE_NOT_BLOCKED');
  }
  stdout.writeln('CONTAINMENT_DIAGNOSTIC_SIMULATIONS_PASS');
}

final class _SimulationCase {
  const _SimulationCase(
    this.name,
    this.catalog,
    this.counters,
    this.expected, {
    this.containmentSucceeds = false,
  });

  final String name;
  final CatalogDiagnosticObservation catalog;
  final List<CounterEvidence> counters;
  final ContainmentClassification expected;
  final bool containmentSucceeds;
}

final class _SimulationGateway implements ContainmentDiagnosticGateway {
  const _SimulationGateway(this.simulation, {this.isolate = true});

  final _SimulationCase simulation;
  final bool isolate;
  static final _readCount = <String, int>{};

  @override
  Future<bool> containExact(List<ContainmentOperation> operations) async =>
      simulation.containmentSucceeds && operations.isNotEmpty;

  @override
  Future<CatalogDiagnosticObservation> diagnoseCatalog() async =>
      simulation.catalog;

  @override
  Future<bool> isolateCli() async => isolate;

  @override
  Future<List<CounterEvidence>> readSevenCounters() async {
    final count = (_readCount[simulation.name] ?? 0) + 1;
    _readCount[simulation.name] = count;
    if (count > 1 && simulation.containmentSucceeds) return _zeros();
    return simulation.counters;
  }
}

List<CounterEvidence> _zeros() => [
  for (final name in containmentCounterNames)
    CounterEvidence(
      name: name,
      result: CounterResultCategory.zero,
      count: 0,
      lookupExact: true,
      queryBound: name == 'profiles' ? 2 : 0,
      ownership: name == 'catalog' || name == 'specialists'
          ? ResourceOwnership.verifiedPreexistingReadOnly
          : ResourceOwnership.createdByFailedRun,
    ),
];

List<CounterEvidence> _replace(CounterEvidence replacement) => [
  for (final counter in _zeros())
    if (counter.name == replacement.name) replacement else counter,
];

List<CounterEvidence> _withExactResidue(String name) => _replace(
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

void _expectThrows(void Function() action) {
  try {
    action();
    // StateError is the fail-closed contract exercised by this simulation.
    // ignore: avoid_catching_errors
  } on StateError {
    return;
  }
  throw StateError('EXPECTED_BLOCKING_FAILURE');
}

Future<void> _expectAsyncThrows(Future<void> Function() action) async {
  try {
    await action();
    // StateError is the fail-closed contract exercised by this simulation.
    // ignore: avoid_catching_errors
  } on StateError {
    return;
  }
  throw StateError('EXPECTED_BLOCKING_FAILURE');
}

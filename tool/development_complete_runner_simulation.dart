import 'dart:io';

import 'development_complete_runner_contracts.dart';

const _manifestPath =
    'docs/stasisly_foundation/development/'
    'development_second_functional_attempt_manifest.json';

void main() {
  final manifest = CompleteRunnerManifest.read(File(_manifestPath));
  if (manifest.validate().isNotEmpty) {
    throw StateError('SIMULATION_MANIFEST_BLOCKED');
  }

  for (var run = 0; run < 2; run++) {
    final machine = CompleteRunnerStateMachine(manifest);
    for (final operation in manifest.operations) {
      machine.advance(operation.toState, evidence: operation.successEvidence);
    }
    if (!machine.terminal ||
        classifyCompleteRun(
              flowPassed: true,
              cleanupPassed: true,
              authAbsent: true,
              counters: List.filled(7, 0),
              evidenceSafe: true,
              cliIsolated: true,
            ) !=
            CompleteRunClassification.passedClean) {
      throw StateError('SIMULATION_SUCCESS_BLOCKED');
    }
  }

  for (final failureState in manifest.failureCleanupFromStates) {
    final machine = CompleteRunnerStateMachine(manifest);
    final targetIndex = manifest.states.indexOf(failureState);
    for (var index = 0; index < targetIndex; index++) {
      final operation = manifest.operations[index];
      machine.advance(operation.toState, evidence: operation.successEvidence);
    }
    machine.beginCleanupAfterFailure();
    for (final operation in manifest.operations.where(
      (operation) =>
          manifest.states.indexOf(operation.fromState) >=
          manifest.states.indexOf('CLEANUP_STARTED'),
    )) {
      machine.advance(operation.toState, evidence: operation.successEvidence);
    }
    if (!machine.terminal ||
        classifyCompleteRun(
              flowPassed: false,
              cleanupPassed: true,
              authAbsent: true,
              counters: List.filled(7, 0),
              evidenceSafe: true,
              cliIsolated: true,
            ) !=
            CompleteRunClassification.failedClean) {
      throw StateError('SIMULATION_FAILURE_BLOCKED');
    }
  }

  final dirtyCases = [
    classifyCompleteRun(
      flowPassed: false,
      cleanupPassed: false,
      authAbsent: true,
      counters: List.filled(7, 0),
      evidenceSafe: true,
      cliIsolated: true,
    ),
    classifyCompleteRun(
      flowPassed: false,
      cleanupPassed: true,
      authAbsent: false,
      counters: List.filled(7, 0),
      evidenceSafe: true,
      cliIsolated: true,
    ),
    classifyCompleteRun(
      flowPassed: false,
      cleanupPassed: true,
      authAbsent: true,
      counters: [0, 1, 0, 0, 0, 0, 0],
      evidenceSafe: true,
      cliIsolated: true,
    ),
    classifyCompleteRun(
      flowPassed: false,
      cleanupPassed: true,
      authAbsent: true,
      counters: null,
      evidenceSafe: true,
      cliIsolated: true,
    ),
    classifyCompleteRun(
      flowPassed: false,
      cleanupPassed: true,
      authAbsent: true,
      counters: List.filled(7, 0),
      evidenceSafe: true,
      cliIsolated: false,
    ),
  ];
  if (dirtyCases.any(
    (classification) =>
        classification != CompleteRunClassification.failedDirtyBlocking,
  )) {
    throw StateError('SIMULATION_DIRTY_CLASSIFICATION_BLOCKED');
  }

  stdout.writeln('COMPLETE_DEVELOPMENT_RUNNER_SIMULATION_PASS');
}

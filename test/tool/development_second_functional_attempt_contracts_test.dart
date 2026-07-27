import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/development_second_functional_attempt_contracts.dart';

void main() {
  const zero = DevelopmentResidueCounters(
    messages: 0,
    idempotency: 0,
    sessions: 0,
    profiles: 0,
    catalog: 0,
    specialists: 0,
    auth: 0,
  );

  test('runner state transitions are monotonic', () {
    final machine = DevelopmentRunnerStateMachine();
    for (final state in DevelopmentRunnerState.values.skip(1)) {
      machine.advance(state);
    }
    expect(machine.state, DevelopmentRunnerState.localRegressionCompleted);
    expect(
      () => machine.advance(DevelopmentRunnerState.targetVerified),
      throwsStateError,
    );
  });

  test('resource ledger cleans only recorded resources in exact order', () {
    final ledger = DevelopmentResourceLedger()
      ..record(DevelopmentEphemeralResource.authUser)
      ..record(DevelopmentEphemeralResource.conversation)
      ..record(DevelopmentEphemeralResource.messages);
    expect(ledger.cleanupOrder(), [
      DevelopmentEphemeralResource.messages,
      DevelopmentEphemeralResource.conversation,
      DevelopmentEphemeralResource.authUser,
    ]);
    ledger.clear();
    expect(ledger.isEmpty, isTrue);
  });

  test('seven named counters preserve order and require zero', () {
    expect(zero.isZero, isTrue);
    expect(zero.vector, '0|0|0|0|0|0|0');
    final parsed = DevelopmentResidueCounters.fromJson({
      'messages': 0,
      'idempotency': 0,
      'sessions': 0,
      'profiles': 0,
      'catalog': 0,
      'specialists': 0,
      'auth': 0,
    });
    expect(parsed.vector, zero.vector);
  });

  test('unknown, missing, negative and nonzero counters fail closed', () {
    expect(
      () => DevelopmentResidueCounters.fromJson({
        'messages': 0,
        'idempotency': 0,
        'sessions': 0,
        'profiles': 0,
        'catalog': 0,
        'specialists': 0,
        'auth': 0,
        'unknown': 0,
      }),
      throwsFormatException,
    );
    expect(
      () => DevelopmentResidueCounters.fromJson({
        'messages': -1,
        'idempotency': 0,
        'sessions': 0,
        'profiles': 0,
        'catalog': 0,
        'specialists': 0,
        'auth': 0,
      }),
      throwsFormatException,
    );
    const residue = DevelopmentResidueCounters(
      messages: 1,
      idempotency: 0,
      sessions: 0,
      profiles: 0,
      catalog: 0,
      specialists: 0,
      auth: 0,
    );
    expect(
      classifyDevelopmentRun(
        flowPassed: true,
        cleanupCompleted: true,
        residue: residue,
        evidenceSanitized: true,
        cliIsolated: true,
      ),
      DevelopmentRunClassification.failedDirtyBlocking,
    );
  });

  test(
    'classification distinguishes pass, clean failure and dirty failure',
    () {
      expect(
        classifyDevelopmentRun(
          flowPassed: true,
          cleanupCompleted: true,
          residue: zero,
          evidenceSanitized: true,
          cliIsolated: true,
        ),
        DevelopmentRunClassification.passedClean,
      );
      expect(
        classifyDevelopmentRun(
          flowPassed: false,
          cleanupCompleted: true,
          residue: zero,
          evidenceSanitized: true,
          cliIsolated: true,
        ),
        DevelopmentRunClassification.failedClean,
      );
      for (final dirty in [
        classifyDevelopmentRun(
          flowPassed: false,
          cleanupCompleted: false,
          residue: zero,
          evidenceSanitized: true,
          cliIsolated: true,
        ),
        classifyDevelopmentRun(
          flowPassed: false,
          cleanupCompleted: true,
          residue: null,
          evidenceSanitized: true,
          cliIsolated: true,
        ),
        classifyDevelopmentRun(
          flowPassed: false,
          cleanupCompleted: true,
          residue: zero,
          evidenceSanitized: false,
          cliIsolated: true,
        ),
        classifyDevelopmentRun(
          flowPassed: false,
          cleanupCompleted: true,
          residue: zero,
          evidenceSanitized: true,
          cliIsolated: false,
        ),
      ]) {
        expect(dirty, DevelopmentRunClassification.failedDirtyBlocking);
      }
    },
  );

  test('second-attempt manifest remains unassigned and unauthorized', () {
    final findings = const SecondFunctionalAttemptManifestValidator().validate(
      File(
        'docs/stasisly_foundation/development/'
        'development_second_functional_attempt_manifest.json',
      ),
    );
    expect(findings, isEmpty);
  });
}

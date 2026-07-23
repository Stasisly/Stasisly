import 'package:flutter_test/flutter_test.dart';

import '../../tool/development_dirty_run_containment.dart';

void main() {
  test('approved dirty attempt has one exact immutable namespace', () {
    final contract = DevelopmentDirtyRunContainment.approvedAttempt(
      exactAuthUserIdAvailable: false,
    );

    expect(contract.attemptAlias, 'diag-20260723-002');
    expect(contract.runNamespace, 'foundation-019a-r1-diag-20260723-002');
    expect(contract.authorizedCommit, 'd94292a');
    expect(
      contract.readiness,
      ContainmentReadiness.blockedMissingExactAuthUserId,
    );
  });

  test('mutating any identity field closes the containment contract', () {
    for (final contract in <DevelopmentDirtyRunContainment>[
      const DevelopmentDirtyRunContainment(
        attemptAlias: 'another-attempt',
        runNamespace: dirtyRunNamespace,
        authorizedCommit: dirtyAttemptCommit,
        fixtureContractVersion: dirtyFixtureContractVersion,
        exactAuthUserIdAvailable: true,
      ),
      const DevelopmentDirtyRunContainment(
        attemptAlias: dirtyAttemptAlias,
        runNamespace: 'another-namespace',
        authorizedCommit: dirtyAttemptCommit,
        fixtureContractVersion: dirtyFixtureContractVersion,
        exactAuthUserIdAvailable: true,
      ),
      const DevelopmentDirtyRunContainment(
        attemptAlias: dirtyAttemptAlias,
        runNamespace: dirtyRunNamespace,
        authorizedCommit: 'another-commit',
        fixtureContractVersion: dirtyFixtureContractVersion,
        exactAuthUserIdAvailable: true,
      ),
    ]) {
      expect(contract.readiness, ContainmentReadiness.blockedInvalidContract);
    }
  });

  test('seven residue counters retain their exact semantic order', () {
    final clean = NamedResidueCounters.fromPipe('0|0|0|0|0|0|0');
    expect(clean.values.keys, orderedEquals(residueCounterNames));
    expect(clean.isClean, isTrue);
    expect(clean.pipe, '0|0|0|0|0|0|0');

    final dirty = NamedResidueCounters.fromPipe('1|2|3|4|5|6|7');
    expect(dirty.values['messages'], 1);
    expect(dirty.values['syntheticAuthUsers'], 7);
    expect(dirty.isClean, isFalse);
  });

  test('malformed or negative residue counters are rejected', () {
    expect(() => NamedResidueCounters.fromPipe('0|0'), throwsFormatException);
    expect(
      () => NamedResidueCounters.fromPipe('0|0|0|0|0|0|-1'),
      throwsFormatException,
    );
  });

  test('exact Auth deletion is idempotent only for 200 and 404', () {
    expect(authDeleteIsIdempotentSuccess(200), isTrue);
    expect(authDeleteIsIdempotentSuccess(404), isTrue);
    for (final status in <int>[0, 201, 204, 400, 401, 403, 409, 500]) {
      expect(authDeleteIsIdempotentSuccess(status), isFalse, reason: '$status');
    }
  });

  test('safe summary contains no raw user identity or endpoint', () {
    final output = DevelopmentDirtyRunContainment.approvedAttempt(
      exactAuthUserIdAvailable: false,
    ).safeSummary().toString();

    expect(output, isNot(contains('@')));
    expect(output, isNot(contains('https://')));
    expect(output, isNot(contains('projectRef')));
    expect(output, isNot(contains('userId')));
  });
}

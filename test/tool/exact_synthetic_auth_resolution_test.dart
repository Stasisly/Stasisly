import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/development_dirty_run_containment.dart';
import '../../tool/exact_synthetic_auth_resolution.dart';

const _canaries = <String>[
  'FAKE_SERVICE_ROLE_DO_NOT_LOG',
  'FAKE_ACCESS_TOKEN_DO_NOT_LOG',
  'FAKE_USER_EMAIL_DO_NOT_LOG',
  'FAKE_USER_ID_DO_NOT_LOG',
  'FAKE_PROJECT_REF_DO_NOT_LOG',
];

void main() {
  group('exact synthetic Auth key derivation', () {
    test('same immutable inputs produce the same bound key', () {
      final first = _historicalKey();
      final second = _historicalKey();

      expect(first.attemptAlias, second.attemptAlias);
      expect(first.runNamespace, second.runNamespace);
      expect(first.fixtureManifestVersion, second.fixtureManifestVersion);
      expect(first.useOperationalValue(second.matchesExact), isTrue);
      expect(first.committedAlias, exactAuthCommittedAlias);
      expect(first.toString(), isNot(contains('@')));
    });

    test('each binding input changes the contract key', () {
      final original = _historicalKey();
      final differentAlias = deriveDirtyAttemptAuthLookupKey(
        attemptAlias: 'diag-20260723-003',
        runNamespace: dirtyRunNamespace,
        fixtureManifestVersion: dirtyFixtureContractVersion,
      );
      final differentNamespace = deriveDirtyAttemptAuthLookupKey(
        attemptAlias: dirtyAttemptAlias,
        runNamespace: 'foundation-019a-r1-diag-20260723-003',
        fixtureManifestVersion: dirtyFixtureContractVersion,
      );
      final differentVersion = deriveDirtyAttemptAuthLookupKey(
        attemptAlias: dirtyAttemptAlias,
        runNamespace: dirtyRunNamespace,
        fixtureManifestVersion: 'FOUNDATION-019A-R1-v2',
      );

      expect(differentAlias.attemptAlias, isNot(original.attemptAlias));
      expect(differentNamespace.runNamespace, isNot(original.runNamespace));
      expect(
        differentVersion.fixtureManifestVersion,
        isNot(original.fixtureManifestVersion),
      );
    });

    test('normalization is strict and unsafe identities are rejected', () {
      for (final values in <(String, String, String)>[
        ('', dirtyRunNamespace, dirtyFixtureContractVersion),
        (' diag-20260723-002', dirtyRunNamespace, dirtyFixtureContractVersion),
        ('Diag-20260723-002', dirtyRunNamespace, dirtyFixtureContractVersion),
        (
          'diag-20260723-\u00f1',
          dirtyRunNamespace,
          dirtyFixtureContractVersion,
        ),
        ('placeholder-id', dirtyRunNamespace, dirtyFixtureContractVersion),
        ('production-user-001', dirtyRunNamespace, dirtyFixtureContractVersion),
        (
          dirtyAttemptAlias,
          'staging-namespace-0001',
          dirtyFixtureContractVersion,
        ),
        (dirtyAttemptAlias, dirtyRunNamespace, ''),
      ]) {
        expect(
          () => deriveDirtyAttemptAuthLookupKey(
            attemptAlias: values.$1,
            runNamespace: values.$2,
            fixtureManifestVersion: values.$3,
          ),
          throwsFormatException,
        );
      }
    });

    test('historical fixture reconstructs the d94292a runner identity', () {
      final fixture =
          jsonDecode(
                File(
                  'test/tool/fixtures/'
                  'foundation_019a_historical_auth_derivation.json',
                ).readAsStringSync(),
              )
              as Map<String, Object?>;
      final key = deriveDirtyAttemptAuthLookupKey(
        attemptAlias: fixture['attemptAlias']! as String,
        runNamespace: fixture['runNamespace']! as String,
        fixtureManifestVersion: fixture['fixtureManifestVersion']! as String,
      );
      final historicalValue = (fixture['emailTemplate']! as String)
          .replaceFirst('{runAlias}', fixture['attemptAlias']! as String);

      expect(fixture['runnerCommit'], 'd94292a');
      expect(fixture['passwordDerivationCategory'], isNot(contains('Aa9')));
      expect(key.matchesExact(historicalValue), isTrue);
      expect(historicalSyntheticAuthLookupKeyMatches(key), isTrue);
      expect(key.committedAlias, 'AUTH_RESOURCE_DIAG_002');
    });
  });

  group('closed exact-match lookup contract', () {
    test('zero exact matches is clean-compatible notFound', () {
      final result = _resolve([
        _page([_record('unrelated-id', 'unrelated@example.test')]),
      ]);

      expect(result.status, ExactSyntheticAuthLookupStatus.notFound);
      expect(result.exactMatchCount, 0);
      expect(result.deleteTarget, isNull);
    });

    test('one exact match creates only an ephemeral delete target', () {
      final key = _historicalKey();
      final exactEmail = key.useOperationalValue((value) => value);
      final result = _resolve([
        _page([
          _record('unrelated-id', 'unrelated@example.test'),
          _record('synthetic-id', exactEmail),
        ]),
      ], key: key);

      expect(result.status, ExactSyntheticAuthLookupStatus.exactlyOne);
      expect(result.exactMatchCount, 1);
      expect(result.deleteTarget, isNotNull);
      expect(result.toString(), isNot(contains('synthetic-id')));
      expect(
        result.deleteTarget!.useExactUserId((value) => value),
        'synthetic-id',
      );
    });

    test('multiple exact matches block and expose no record', () {
      final key = _historicalKey();
      final exactEmail = key.useOperationalValue((value) => value);
      final result = _resolve([
        _page([
          _record('first-id', exactEmail),
          _record('second-id', exactEmail),
        ]),
      ], key: key);

      expect(
        result.status,
        ExactSyntheticAuthLookupStatus.multipleMatchesBlocking,
      );
      expect(result.deleteTarget, isNull);
      expect(result.toString(), isNot(contains('first-id')));
      expect(result.toString(), isNot(contains('second-id')));
    });

    test('partial and case-mismatched values never match', () {
      final key = _historicalKey();
      final exactEmail = key.useOperationalValue((value) => value);
      final result = _resolve([
        _page([
          _record('partial-id', 'prefix-$exactEmail'),
          _record('case-id', exactEmail.toUpperCase()),
        ]),
      ], key: key);

      expect(result.status, ExactSyntheticAuthLookupStatus.notFound);
    });

    test('incomplete, early-ended and excessive pagination reject', () {
      expect(
        _resolve([_page(const [], isLast: false)]).status,
        ExactSyntheticAuthLookupStatus.lookupRejected,
      );
      expect(
        _resolve([_page(const []), _page(const [])]).status,
        ExactSyntheticAuthLookupStatus.lookupRejected,
      );
      expect(
        _resolve(
          List.generate(
            maximumAuthLookupPages + 1,
            (index) => _page(const [], isLast: index == maximumAuthLookupPages),
          ),
        ).status,
        ExactSyntheticAuthLookupStatus.lookupRejected,
      );
    });

    test('transport, authorization, environment and target fail closed', () {
      expect(
        _resolve([_page(const [])], transportFailed: true).status,
        ExactSyntheticAuthLookupStatus.transportFailure,
      );
      expect(
        _resolve([_page(const [])], authorized: false).status,
        ExactSyntheticAuthLookupStatus.authorizationRejected,
      );
      expect(
        _resolve([_page(const [])], environment: 'production').status,
        ExactSyntheticAuthLookupStatus.environmentMismatch,
      );
      expect(
        _resolve([_page(const [])], targetConfirmed: false).status,
        ExactSyntheticAuthLookupStatus.targetMismatch,
      );
    });

    test('attempt binding mismatch rejects before directory inspection', () {
      final result = _resolve([
        _page([for (final canary in _canaries) _record(canary, canary)]),
      ], attemptAlias: 'diag-20260723-003');

      expect(result.status, ExactSyntheticAuthLookupStatus.lookupRejected);
      final safe = result.toString();
      for (final canary in _canaries) {
        expect(safe, isNot(contains(canary)));
      }
    });

    test('unrelated canaries never leave safe output', () {
      final result = _resolve([
        _page([for (final canary in _canaries) _record(canary, canary)]),
      ]);

      final safe = '${result.safeSummary()}';
      for (final canary in _canaries) {
        expect(safe, isNot(contains(canary)));
      }
    });
  });

  group('local containment simulation', () {
    final cleanCounters = NamedResidueCounters.fromPipe('0|0|0|0|0|0|0');

    test('already absent is clean without delete', () {
      expect(
        simulateExactAuthContainment(
          initialLookup: _resolve([_page(const [])]),
          verificationLookup: _resolve([_page(const [])]),
          counters: cleanCounters,
        ),
        LocalContainmentStatus.containedCleanAlreadyAbsent,
      );
    });

    test('exact target deleted with 200 verifies clean', () {
      expect(
        simulateExactAuthContainment(
          initialLookup: _oneMatch(),
          deleteStatus: 200,
          verificationLookup: _resolve([_page(const [])]),
          counters: cleanCounters,
        ),
        LocalContainmentStatus.containedCleanDeleted,
      );
    });

    test('404 race is clean only after exact absence verification', () {
      expect(
        simulateExactAuthContainment(
          initialLookup: _oneMatch(),
          deleteStatus: 404,
          verificationLookup: _resolve([_page(const [])]),
          counters: cleanCounters,
        ),
        LocalContainmentStatus.containedCleanRaceAlreadyAbsent,
      );
    });

    test('collision and unknown verification remain blocking', () {
      final key = _historicalKey();
      final exactEmail = key.useOperationalValue((value) => value);
      final collision = _resolve([
        _page([_record('one', exactEmail), _record('two', exactEmail)]),
      ]);
      expect(
        simulateExactAuthContainment(
          initialLookup: collision,
          verificationLookup: _resolve([_page(const [])]),
          counters: cleanCounters,
        ),
        LocalContainmentStatus.blockedIdentityCollision,
      );
      expect(
        simulateExactAuthContainment(
          initialLookup: _oneMatch(),
          deleteStatus: 200,
          verificationLookup: _resolve([_page(const [], isLast: false)]),
          counters: cleanCounters,
        ),
        LocalContainmentStatus.containmentUnverifiableBlocking,
      );
    });
  });

  group('future containment preflight', () {
    test('all exact authorization inputs produce the future pass state', () {
      expect(_preflight(), ExactAuthContainmentGateStatus.pass);
    });

    test('missing authorization and forbidden work fail closed', () {
      expect(
        _preflight(founderAuthorizationPresent: false),
        ExactAuthContainmentGateStatus.authorizationMissing,
      );
      expect(
        _preflight(noNewFixtureSetup: false),
        ExactAuthContainmentGateStatus.forbiddenOperationPresent,
      );
    });

    test('identity, context and binding mismatches are closed states', () {
      expect(
        _preflight(remoteContextSafe: false),
        ExactAuthContainmentGateStatus.remoteContextUnsafe,
      );
      expect(
        _preflight(historicalLookupDerivationMatches: false),
        ExactAuthContainmentGateStatus.historicalIdentityMismatch,
      );
      expect(
        _preflight(lookupContractPresent: false),
        ExactAuthContainmentGateStatus.contractMissing,
      );
      expect(
        _preflight(commitMatches: false),
        ExactAuthContainmentGateStatus.commitMismatch,
      );
      expect(
        _preflight(targetMatches: false),
        ExactAuthContainmentGateStatus.targetMismatch,
      );
      expect(
        _preflight(operatorMatches: false),
        ExactAuthContainmentGateStatus.operatorMismatch,
      );
    });
  });
}

SyntheticAuthLookupKey _historicalKey() => deriveDirtyAttemptAuthLookupKey(
  attemptAlias: dirtyAttemptAlias,
  runNamespace: dirtyRunNamespace,
  fixtureManifestVersion: dirtyFixtureContractVersion,
);

SyntheticAuthDirectoryRecord _record(String id, String email) =>
    SyntheticAuthDirectoryRecord(id: id, email: email);

SyntheticAuthDirectoryPage _page(
  List<SyntheticAuthDirectoryRecord> records, {
  bool isLast = true,
}) => SyntheticAuthDirectoryPage(records: records, isLastPage: isLast);

ExactSyntheticAuthLookupResult _resolve(
  List<SyntheticAuthDirectoryPage> pages, {
  SyntheticAuthLookupKey? key,
  bool authorized = true,
  String environment = 'development',
  bool targetConfirmed = true,
  bool transportFailed = false,
  String attemptAlias = dirtyAttemptAlias,
}) {
  final lookupKey = key ?? _historicalKey();
  return const ExactSyntheticAuthLookup().resolve(
    context: ExactSyntheticAuthLookupContext(
      environment: environment,
      exactProjectConfirmed: targetConfirmed,
      attemptAlias: attemptAlias,
      runNamespace: dirtyRunNamespace,
      fixtureManifestVersion: dirtyFixtureContractVersion,
      lookupKey: lookupKey,
      founderAuthorizationReference: 'FAKE_AUTH_REFERENCE',
      authorizedCommit: 'fake-commit',
      operatorIdentity: 'fake-operator',
      authorized: authorized,
    ),
    pages: pages,
    transportFailed: transportFailed,
  );
}

ExactSyntheticAuthLookupResult _oneMatch() {
  final key = _historicalKey();
  return _resolve([
    _page([_record('synthetic-id', key.useOperationalValue((value) => value))]),
  ], key: key);
}

ExactAuthContainmentGateStatus _preflight({
  bool remoteContextSafe = true,
  bool historicalLookupDerivationMatches = true,
  bool lookupContractPresent = true,
  bool founderAuthorizationPresent = true,
  bool commitMatches = true,
  bool targetMatches = true,
  bool operatorMatches = true,
  bool noNewFixtureSetup = true,
}) => const ExactAuthContainmentPreflight().evaluate(
  remoteContextSafe: remoteContextSafe,
  historicalLookupDerivationMatches: historicalLookupDerivationMatches,
  lookupContractPresent: lookupContractPresent,
  deleteContractPresent: true,
  counterContractPresent: true,
  founderAuthorizationPresent: founderAuthorizationPresent,
  commitMatches: commitMatches,
  targetMatches: targetMatches,
  operatorMatches: operatorMatches,
  noNewFixtureSetup: noNewFixtureSetup,
  noMigration: true,
  noDeploy: true,
  noSecretMutation: true,
);

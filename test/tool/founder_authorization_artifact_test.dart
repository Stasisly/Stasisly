import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/founder_authorization_artifact.dart';

void main() {
  group('FounderAuthorizationArtifactV1', () {
    test('SHA-256 and canonical JSON are deterministic', () {
      expect(
        sha256Hex('abc'),
        'ba7816bf8f01cfea414140de5dae2223'
        'b00361a396177a9cb410ff61f20015ad',
      );
      expect(
        canonicalJson({
          'z': 1,
          'a': {'y': 2, 'x': 3},
        }),
        '{"a":{"x":3,"y":2},"z":1}',
      );
    });

    test('valid artifact detects field and hash mutation', () {
      final artifact = _artifact();
      expect(artifact.validate(now: _now), isEmpty);
      final json = artifact.toJson()..['scope'] = 'mutated';
      final mutated = FounderAuthorizationArtifactV1.fromJson(json);
      expect(
        mutated.validate(now: _now),
        contains('AUTHORIZATION_PAYLOAD_HASH_MISMATCH'),
      );
    });

    test('missing and unknown fields are rejected', () {
      final missing = _artifact().toJson()..remove('scope');
      final unknown = _artifact().toJson()..['unexpected'] = true;
      expect(
        () => FounderAuthorizationArtifactV1.fromJson(missing),
        throwsA(_code('AUTHORIZATION_REQUIRED_FIELD_MISSING')),
      );
      expect(
        () => FounderAuthorizationArtifactV1.fromJson(unknown),
        throwsA(_code('AUTHORIZATION_UNKNOWN_FIELD')),
      );
    });

    test('schema and execution expectations fail closed', () {
      final artifact = _artifact();
      final invalidSchema = FounderAuthorizationArtifactV1.fromJson(
        artifact.toJson()..['schema_version'] = 'unknown',
      );
      expect(
        invalidSchema.validate(now: _now),
        containsAll(<String>[
          'AUTHORIZATION_SCHEMA_MISMATCH',
          'AUTHORIZATION_PAYLOAD_HASH_MISMATCH',
        ]),
      );
      final findings = artifact.validate(
        now: _now,
        expectedAuthorizationId: 'other',
        expectedOperation: 'other',
        expectedEnvironment: 'production',
        expectedCommitSha: 'other',
        expectedManifest: 'other',
        expectedRunner: 'other',
      );
      expect(
        findings,
        containsAll(<String>[
          'AUTHORIZATION_ID_MISMATCH',
          'AUTHORIZATION_OPERATION_MISMATCH',
          'AUTHORIZATION_ENVIRONMENT_MISMATCH',
          'AUTHORIZATION_COMMIT_MISMATCH',
          'AUTHORIZATION_MANIFEST_MISMATCH',
          'AUTHORIZATION_RUNNER_MISMATCH',
        ]),
      );
    });

    test('expired, revoked and consumed artifacts cannot execute', () {
      final expired = _artifact(now: _now.subtract(const Duration(hours: 3)));
      expect(expired.validate(now: _now), contains('AUTHORIZATION_EXPIRED'));
      for (final status in [
        FounderAuthorizationStatus.revoked,
        FounderAuthorizationStatus.consumed,
      ]) {
        final changed = _artifact()
            .copyWith(
              status: status,
              remoteExecutionCount:
                  status == FounderAuthorizationStatus.consumed ? 1 : 0,
            )
            .withRecalculatedHash();
        expect(changed.validate(now: _now), isNotEmpty);
      }
    });

    test('single-use limit and binding format are enforced', () {
      final artifact = _artifact();
      final excessive = FounderAuthorizationArtifactV1.fromJson(
        artifact.toJson()..['max_remote_executions'] = 2,
      ).withRecalculatedHash();
      expect(
        excessive.validate(now: _now),
        contains('AUTHORIZATION_EXECUTION_LIMIT_MISMATCH'),
      );
      final invalidCommit = FounderAuthorizationArtifactV1(
        schemaVersion: artifact.schemaVersion,
        authorizationId: artifact.authorizationId,
        decision: artifact.decision,
        decisionSource: artifact.decisionSource,
        authorizedOperation: artifact.authorizedOperation,
        authorizedEnvironment: artifact.authorizedEnvironment,
        authorizedCommitSha: 'invalid',
        authorizedManifest: artifact.authorizedManifest,
        authorizedRunner: artifact.authorizedRunner,
        scope: artifact.scope,
        maxRemoteExecutions: 1,
        remoteExecutionCount: 0,
        status: FounderAuthorizationStatus.granted,
        createdAt: artifact.createdAt,
        expiresAt: artifact.expiresAt,
        consumptionTrigger: artifact.consumptionTrigger,
        payloadSha256: '',
      ).withRecalculatedHash();
      expect(
        invalidCommit.validate(now: _now),
        contains('AUTHORIZATION_BINDING_INVALID'),
      );
    });
  });

  group('FounderAuthorizationStore', () {
    late Directory repository;
    late FounderAuthorizationStore store;

    setUp(() {
      repository = Directory.systemTemp.createTempSync('founder-auth-test-');
      _git(repository, ['init', '-q']);
      File('${repository.path}/.gitignore').writeAsStringSync('.runtime/\n');
      store = FounderAuthorizationStore(
        repositoryRoot: repository,
        clock: () => _now,
      );
    });

    tearDown(() {
      repository.deleteSync(recursive: true);
    });

    test('storage is ignored and permissions are restrictive', () {
      store
        ..ensureSecureStorage()
        ..validateStorageContract();
      final artifact = store.grantFromProposal(
        _proposal('permissions'),
        currentCommitSha: _commit,
      );
      expect(artifact.status, FounderAuthorizationStatus.granted);
      expect(store.runtimeRoot.statSync().mode & 0x1ff, 0x1c0);
      expect(store.authorizationRoot.statSync().mode & 0x1ff, 0x1c0);
      expect(store.artifactFile('permissions').statSync().mode & 0x1ff, 0x180);
      expect(store.lockRoot.statSync().mode & 0x1ff, 0x1c0);
      expect(
        _git(repository, ['status', '--short']),
        isNot(contains('.runtime')),
      );
    });

    test('tracked runtime paths and broad permissions are rejected', () {
      store.ensureSecureStorage();
      File('${repository.path}/.gitignore').writeAsStringSync('');
      expect(
        store.validateStorageContract,
        throwsA(_code('AUTHORIZATION_ARTIFACT_STORAGE_NOT_IGNORED')),
      );
      File('${repository.path}/.gitignore').writeAsStringSync('.runtime/\n');
      store.grantFromProposal(_proposal('broad'), currentCommitSha: _commit);
      _chmod(store.artifactFile('broad').path, '644');
      expect(
        () => store.read('broad'),
        throwsA(_code('AUTHORIZATION_ARTIFACT_PERMISSIONS_TOO_BROAD')),
      );
    });

    test('tracked runtime artifact is rejected even with ignore rule', () {
      store.grantFromProposal(_proposal('tracked'), currentCommitSha: _commit);
      _git(repository, ['add', '-f', '.runtime/authorizations/tracked.json']);
      expect(
        store.validateStorageContract,
        throwsA(_code('AUTHORIZATION_RUNTIME_FILE_TRACKED')),
      );
    });

    test('grant can consume exactly once', () async {
      store.grantFromProposal(
        _proposal('consume-once'),
        currentCommitSha: _commit,
      );
      final consumed = await store.consume('consume-once', validate: _validate);
      expect(consumed.status, FounderAuthorizationStatus.consumed);
      expect(consumed.remoteExecutionCount, 1);
      await expectLater(
        store.consume('consume-once', validate: _validate),
        throwsA(_code('AUTHORIZATION_ALREADY_CONSUMED')),
      );
    });

    test('consumed artifact records sanitized completion once', () async {
      store.grantFromProposal(_proposal('complete'), currentCommitSha: _commit);
      await store.consume('complete', validate: _validate);
      final completed = store.completeConsumed(
        'complete',
        finalClassification: 'CONTAINED_CLEAN',
        remoteContextFinal: 'SAFE',
      );
      expect(completed.finalClassification, 'CONTAINED_CLEAN');
      expect(completed.remoteContextFinal, 'SAFE');
      expect(completed.hasValidHash, isTrue);
      expect(
        () => store.completeConsumed(
          'complete',
          finalClassification: 'CONTAINED_CLEAN',
          remoteContextFinal: 'SAFE',
        ),
        throwsA(_code('AUTHORIZATION_COMPLETION_BLOCKED')),
      );
    });

    test('revoke and expire only transition from granted', () {
      for (final status in [
        FounderAuthorizationStatus.revoked,
        FounderAuthorizationStatus.expired,
      ]) {
        final id = status.value.toLowerCase();
        store.grantFromProposal(_proposal(id), currentCommitSha: _commit);
        final changed = store.transitionGranted(id, status);
        expect(changed.status, status);
        expect(
          () => store.transitionGranted(id, FounderAuthorizationStatus.revoked),
          throwsA(_code('AUTHORIZATION_TRANSITION_BLOCKED')),
        );
      }
    });

    test('consume after revoke or expiry is blocked', () async {
      for (final status in [
        FounderAuthorizationStatus.revoked,
        FounderAuthorizationStatus.expired,
      ]) {
        final id = 'blocked-${status.value.toLowerCase()}';
        _grantThenTransition(store, id, status);
        await expectLater(
          store.consume(id, validate: _validate),
          throwsA(_code('AUTHORIZATION_STATUS_NOT_GRANTED')),
        );
      }
    });

    test('parallel consumption allows one transition', () async {
      store.grantFromProposal(_proposal('parallel'), currentCommitSha: _commit);
      final results = await Future.wait<Object>([
        store
            .consume('parallel', validate: _validate)
            .then<Object>((value) => value)
            .catchError((Object error) => error),
        store
            .consume('parallel', validate: _validate)
            .then<Object>((value) => value)
            .catchError((Object error) => error),
      ]);
      expect(results.whereType<FounderAuthorizationArtifactV1>(), hasLength(1));
      expect(
        results.whereType<FounderAuthorizationException>().single.code,
        'AUTHORIZATION_ALREADY_CONSUMED',
      );
    });

    test('orphan lock fails closed', () async {
      store.grantFromProposal(_proposal('orphan'), currentCommitSha: _commit);
      store.lockFile('orphan').writeAsStringSync('orphan');
      await expectLater(
        store.consume('orphan', validate: _validate),
        throwsA(_code('AUTHORIZATION_LOCKED_FAIL_CLOSED')),
      );
    });

    test('atomic write failure preserves granted artifact', () async {
      var writes = 0;
      final failingStore = FounderAuthorizationStore(
        repositoryRoot: repository,
        clock: () => _now,
        beforeAtomicRename: (temporary, target) {
          writes++;
          if (writes == 2) throw const FileSystemException('synthetic');
        },
      );
      _grant(failingStore, 'atomic');
      await expectLater(
        failingStore.consume('atomic', validate: _validate),
        throwsA(isA<FileSystemException>()),
      );
      expect(
        failingStore.read('atomic').status,
        FounderAuthorizationStatus.granted,
      );
      expect(failingStore.lockFile('atomic').existsSync(), isFalse);
    });

    test('consumed authorization cannot be regenerated', () async {
      store.grantFromProposal(
        _proposal('regenerate'),
        currentCommitSha: _commit,
      );
      await store.consume('regenerate', validate: _validate);
      expect(
        () => store.grantFromProposal(
          _proposal('regenerate'),
          currentCommitSha: _commit,
        ),
        throwsA(_code('AUTHORIZATION_REGENERATION_BLOCKED')),
      );
    });

    test('audit contains only approved sanitized fields', () async {
      store.grantFromProposal(_proposal('audit'), currentCommitSha: _commit);
      await store.consume('audit', validate: _validate);
      final audit = File(
        '${store.auditRoot.path}/audit.jsonl',
      ).readAsStringSync();
      expect(audit, contains('status_transition'));
      for (final forbidden in [
        'SUPABASE',
        'token',
        'email',
        'alias',
        'connection',
      ]) {
        expect(audit, isNot(contains(forbidden)));
      }
    });
  });

  group('legacy compatibility', () {
    final artifact = _artifact();

    test('artifact only is primary', () {
      expect(
        resolveAuthorizationSource(artifact: artifact, environment: const {}),
        FounderAuthorizationSourceResolution.artifactOnly,
      );
    });

    test('legacy only is deprecated compatibility', () {
      expect(
        resolveAuthorizationSource(
          artifact: null,
          environment: const {'AUTHORIZED_COMMIT_MATCHES_HEAD': 'CONFIRMED'},
        ),
        FounderAuthorizationSourceResolution.deprecatedLegacyOnly,
      );
    });

    test('matching legacy is deprecated but accepted', () {
      expect(
        resolveAuthorizationSource(
          artifact: artifact,
          environment: {
            'FOUNDER_CONTAINMENT_AUTHORIZATION_REFERENCE':
                artifact.authorizationId,
            'AUTHORIZED_COMMIT_SHA': artifact.authorizedCommitSha,
            'AUTHORIZED_COMMIT_MATCHES_HEAD': 'CONFIRMED',
            'CONTAINMENT_AUTHORIZATION_STATUS': 'GRANTED_AT_RUNTIME',
          },
        ),
        FounderAuthorizationSourceResolution.artifactMatchingLegacy,
      );
    });

    test('unrelated functional legacy state has no containment authority', () {
      expect(
        resolveAuthorizationSource(
          artifact: artifact,
          environment: const {
            'SECOND_FUNCTIONAL_ATTEMPT_AUTHORIZATION_STATUS': 'CONSUMED',
          },
        ),
        FounderAuthorizationSourceResolution.artifactMatchingLegacy,
      );
    });

    test('conflicting legacy blocks', () {
      expect(
        resolveAuthorizationSource(
          artifact: artifact,
          environment: const {'AUTHORIZED_COMMIT_SHA': 'wrong'},
        ),
        FounderAuthorizationSourceResolution.blockedConflict,
      );
    });

    test('no source is missing', () {
      expect(
        resolveAuthorizationSource(artifact: null, environment: const {}),
        FounderAuthorizationSourceResolution.missing,
      );
    });
  });
}

final _now = DateTime.utc(2026, 7, 30, 12);
const _commit = '5591007e91455e6ce315915d15eebb4b05519488';

FounderAuthorizationProposalV1 _proposal(String id) =>
    FounderAuthorizationProposalV1(
      authorizationId: id,
      decision: 'APPROVED',
      decisionSource: 'EXPLICIT_CONVERSATIONAL_APPROVAL',
      authorizedOperation:
          'FOUNDATION-019A_V4_FAILED_RUN_DIAGNOSTIC_AND_CONTAINMENT',
      authorizedEnvironment: 'development',
      authorizedManifest: 'FOUNDATION-019A-V4-DIRTY-RUN-CONTAINMENT-v1',
      authorizedRunner: 'FOUNDATION-019A-R2H-CONTAINMENT-RUNNER-v1',
      scope: 'EXACT_DIAGNOSTIC_AND_RUN_SCOPED_CONTAINMENT',
    );

FounderAuthorizationArtifactV1 _artifact({DateTime? now}) =>
    FounderAuthorizationArtifactV1.granted(
      proposal: _proposal('artifact-test'),
      commitSha: _commit,
      now: now ?? _now,
    );

List<String> _validate(FounderAuthorizationArtifactV1 artifact) =>
    artifact.validate(
      now: _now,
      expectedCommitSha: _commit,
      expectedEnvironment: 'development',
    );

Matcher _code(String code) => isA<FounderAuthorizationException>().having(
  (error) => error.code,
  'code',
  code,
);

String _git(Directory repository, List<String> arguments) {
  final result = Process.runSync(
    'git',
    arguments,
    workingDirectory: repository.path,
  );
  if (result.exitCode != 0) {
    throw StateError((result.stderr as String).trim());
  }
  return result.stdout as String;
}

void _chmod(String path, String mode) {
  final result = Process.runSync('chmod', [mode, path]);
  if (result.exitCode != 0) throw StateError('chmod failed');
}

void _grant(FounderAuthorizationStore store, String id) {
  store.grantFromProposal(_proposal(id), currentCommitSha: _commit);
}

void _grantThenTransition(
  FounderAuthorizationStore store,
  String id,
  FounderAuthorizationStatus status,
) {
  _grant(store, id);
  store.transitionGranted(id, status);
}

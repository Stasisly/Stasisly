import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/founder_authorization_artifact.dart';
import '../../tool/founder_authorization_cli.dart';

void main() {
  group('FounderAuthorizationArtifactV2 schema', () {
    test('valid V2 round-trips with canonical nested data', () {
      final artifact = _artifactV2();
      final parsed = FounderAuthorizationArtifactV1.fromJson(
        jsonDecode(canonicalJson(artifact.toJson())) as Map<String, Object?>,
      );

      expect(parsed, isA<FounderAuthorizationArtifactV2>());
      expect(parsed.validate(now: _now), isEmpty);
      expect(parsed.hasValidHash, isTrue);
      expect(
        canonicalJson({
          'z': 1,
          'subject_run': {'runner': 'b', 'authorization_reference': 'a'},
        }),
        '{"subject_run":{"authorization_reference":"a","runner":"b"},"z":1}',
      );
    });

    test('V2 rejects absent or non-object subject_run', () {
      final valid = _artifactV2().toJson();
      for (final invalid in [
        Map<String, Object?>.from(valid)..remove('subject_run'),
        Map<String, Object?>.from(valid)..['subject_run'] = null,
        Map<String, Object?>.from(valid)..['subject_run'] = 'scalar',
        Map<String, Object?>.from(valid)..['subject_run'] = <Object?>[],
      ]) {
        expect(
          () => FounderAuthorizationArtifactV1.fromJson(invalid),
          throwsA(isA<FounderAuthorizationException>()),
        );
      }
    });

    test('V2 rejects every missing nested field', () {
      for (final field in _subjectRun.toJson().keys) {
        final json = _artifactV2().toJson();
        json['subject_run'] = Map<String, Object?>.from(_subjectRun.toJson())
          ..remove(field);
        expect(
          () => FounderAuthorizationArtifactV1.fromJson(json),
          throwsA(_code('AUTHORIZATION_SUBJECT_RUN_REQUIRED_FIELD_MISSING')),
          reason: field,
        );
      }
    });

    test('V2 rejects unknown nested and top-level fields', () {
      final nested = _artifactV2().toJson();
      nested['subject_run'] = Map<String, Object?>.from(_subjectRun.toJson())
        ..['unknown'] = true;
      expect(
        () => FounderAuthorizationArtifactV1.fromJson(nested),
        throwsA(_code('AUTHORIZATION_SUBJECT_RUN_UNKNOWN_FIELD')),
      );

      final topLevel = _artifactV2().toJson()..['unknown'] = true;
      expect(
        () => FounderAuthorizationArtifactV1.fromJson(topLevel),
        throwsA(_code('AUTHORIZATION_UNKNOWN_FIELD')),
      );
    });

    test('wrong schema and unsupported operation fail closed', () {
      final wrongSchema = _artifactV2().toJson()
        ..['schema_version'] = 'founder-authorization-v3';
      expect(
        () => FounderAuthorizationArtifactV2.fromJson(wrongSchema),
        throwsA(_code('AUTHORIZATION_SCHEMA_MISMATCH')),
      );

      final generalWithSubject = _artifactV2(
        operation: 'GENERAL_DEVELOPMENT_OPERATION',
      );
      expect(
        generalWithSubject.validate(now: _now),
        contains('AUTHORIZATION_SUBJECT_RUN_FORBIDDEN'),
      );
    });

    test('V1 failed-run operation is schema-insufficient', () {
      final artifact = FounderAuthorizationArtifactV1.granted(
        proposal: const FounderAuthorizationProposalV1(
          authorizationId: 'v1-failed-run',
          decision: 'APPROVED',
          decisionSource: 'EXPLICIT_CONVERSATIONAL_APPROVAL',
          authorizedOperation: _operation,
          authorizedEnvironment: 'development',
          authorizedManifest: _containmentManifest,
          authorizedRunner: _containmentRunner,
          scope: 'EXACT_DIAGNOSTIC_AND_RUN_SCOPED_CONTAINMENT',
        ),
        commitSha: _commit,
        now: _now,
      );

      expect(
        artifact.validate(now: _now),
        contains('AUTHORIZATION_SCHEMA_VERSION_INSUFFICIENT'),
      );
    });
  });

  group('subject-run bindings and integrity', () {
    test('all seven bindings are cross-validated independently', () {
      final cases = <String, FounderAuthorizationSubjectRun>{
        'SUBJECT_RUN_AUTHORIZATION_MISMATCH': _subject(
          authorizationReference: 'FA-OTHER-RUN',
        ),
        'SUBJECT_RUN_COMMIT_MISMATCH': _subject(commitSha: 'b' * 40),
        'SUBJECT_RUN_MANIFEST_MISMATCH': _subject(
          manifest: 'OTHER-MANIFEST-v1',
        ),
        'SUBJECT_RUN_RUNNER_MISMATCH': _subject(runner: 'OTHER-RUNNER-v1'),
        'SUBJECT_RUN_RESULT_MISMATCH': _subject(result: 'OTHER FAILED RESULT'),
        'SUBJECT_RUN_LAST_STATE_MISMATCH': _subject(
          lastReachedState: 'OTHER_STATE',
        ),
        'SUBJECT_RUN_FAILURE_CATEGORY_MISMATCH': _subject(
          failureCategory: 'OTHER_FAILURE',
        ),
      };
      for (final entry in cases.entries) {
        expect(
          _artifactV2().validate(now: _now, expectedSubjectRun: entry.value),
          contains(entry.key),
          reason: entry.key,
        );
      }
      expect(
        _artifactV2().validate(now: _now, expectedSubjectRun: _subjectRun),
        isEmpty,
      );
    });

    test('nested mutation invalidates hash', () {
      for (final field in _subjectRun.toJson().keys) {
        final json = _artifactV2().toJson();
        final nested = Map<String, Object?>.from(
          json['subject_run']! as Map<String, Object?>,
        );
        nested[field] = field == 'commit_sha' ? 'b' * 40 : 'MUTATED_VALUE';
        json['subject_run'] = nested;
        final mutated = FounderAuthorizationArtifactV1.fromJson(json);
        expect(
          mutated.validate(now: _now),
          contains('AUTHORIZATION_PAYLOAD_HASH_MISMATCH'),
          reason: field,
        );
      }
    });

    test('status transition updates hash and preserves subject_run', () {
      final granted = _artifactV2();
      final consumed = granted
          .copyWith(
            status: FounderAuthorizationStatus.consumed,
            remoteExecutionCount: 1,
            consumedAt: _now.add(const Duration(minutes: 1)),
          )
          .withRecalculatedHash();

      expect(consumed.hasValidHash, isTrue);
      expect(consumed.payloadSha256, isNot(granted.payloadSha256));
      expect(consumed.subjectRun.matches(granted.subjectRun), isTrue);
    });
  });

  group('V2 generator and store', () {
    late Directory repository;
    late FounderAuthorizationStore store;

    setUp(() {
      repository = Directory.systemTemp.createTempSync('founder-auth-v2-');
      _git(repository, ['init', '-q']);
      File('${repository.path}/.gitignore').writeAsStringSync('.runtime/\n');
      store = FounderAuthorizationStore(
        repositoryRoot: repository,
        clock: () => _now,
      );
    });

    tearDown(() => repository.deleteSync(recursive: true));

    test('generator derives V2 subject_run from versioned manifest', () {
      final proposalFile = File('${repository.path}/proposal.json')
        ..writeAsStringSync(
          jsonEncode({
            'authorization_id': 'generated-v2',
            'decision': 'APPROVED',
            'decision_source': 'EXPLICIT_CONVERSATIONAL_APPROVAL',
            'authorized_operation': _operation,
            'authorized_environment': 'development',
            'authorized_manifest': _containmentManifest,
            'authorized_runner': _containmentRunner,
            'scope': 'EXACT_DIAGNOSTIC_AND_RUN_SCOPED_CONTAINMENT',
            'subject_run_manifest_path':
                'docs/stasisly_foundation/development/'
                'development_v4_dirty_run_containment_manifest.json',
          }),
        );

      final proposal = readFounderAuthorizationProposal(proposalFile);
      expect(proposal, isA<FounderAuthorizationProposalV2>());
      final artifact = store.grantFromProposal(
        proposal,
        currentCommitSha: _commit,
      );
      expect(artifact, isA<FounderAuthorizationArtifactV2>());
      expect(artifact.subjectRun!.matches(_subjectRun), isTrue);
      expect(artifact.hasValidHash, isTrue);
    });

    test('generator blocks traversal outside versioned manifest root', () {
      final proposalFile = File('${repository.path}/traversal.json')
        ..writeAsStringSync(
          jsonEncode({
            'authorization_id': 'blocked-traversal',
            'decision': 'APPROVED',
            'decision_source': 'EXPLICIT_CONVERSATIONAL_APPROVAL',
            'authorized_operation': _operation,
            'authorized_environment': 'development',
            'authorized_manifest': _containmentManifest,
            'authorized_runner': _containmentRunner,
            'scope': 'EXACT_DIAGNOSTIC_AND_RUN_SCOPED_CONTAINMENT',
            'subject_run_manifest_path':
                'docs/stasisly_foundation/development/'
                '../../../.dart_tool/package_config.json',
          }),
        );

      expect(
        () => readFounderAuthorizationProposal(proposalFile),
        throwsA(_code('AUTHORIZATION_SUBJECT_RUN_MANIFEST_PATH_BLOCKED')),
      );
    });

    test('store blocks V1 failed-run proposal and V2 unrelated subject', () {
      expect(
        () => store.grantFromProposal(
          const FounderAuthorizationProposalV1(
            authorizationId: 'blocked-v1',
            decision: 'APPROVED',
            decisionSource: 'EXPLICIT_CONVERSATIONAL_APPROVAL',
            authorizedOperation: _operation,
            authorizedEnvironment: 'development',
            authorizedManifest: _containmentManifest,
            authorizedRunner: _containmentRunner,
            scope: 'EXACT_DIAGNOSTIC_AND_RUN_SCOPED_CONTAINMENT',
          ),
          currentCommitSha: _commit,
        ),
        throwsA(_code('AUTHORIZATION_SCHEMA_VERSION_INSUFFICIENT')),
      );
      expect(
        () => store.grantFromProposal(
          _proposalV2(
            id: 'blocked-general',
            operation: 'GENERAL_DEVELOPMENT_OPERATION',
          ),
          currentCommitSha: _commit,
        ),
        throwsA(_code('AUTHORIZATION_SUBJECT_RUN_FORBIDDEN')),
      );
    });

    test('atomic consumption preserves subject_run', () async {
      final granted = store.grantFromProposal(
        _proposalV2(id: 'consume-v2'),
        currentCommitSha: _commit,
      );
      final consumed = await store.consume(
        'consume-v2',
        validate: (artifact) =>
            artifact.validate(now: _now, expectedSubjectRun: _subjectRun),
      );

      expect(consumed, isA<FounderAuthorizationArtifactV2>());
      expect(consumed.subjectRun!.matches(granted.subjectRun!), isTrue);
      expect(consumed.status, FounderAuthorizationStatus.consumed);
      expect(consumed.hasValidHash, isTrue);
    });
  });
}

final _now = DateTime.utc(2026, 7, 30, 14);
const _commit = 'f9e9510a927955d97bda6cc57ee6b974c9a9dd10';
const _operation = 'FOUNDATION-019A_V4_FAILED_RUN_DIAGNOSTIC_AND_CONTAINMENT';
const _containmentManifest = 'FOUNDATION-019A-V4-DIRTY-RUN-CONTAINMENT-v2';
const _containmentRunner = 'FOUNDATION-019A-R2H-CONTAINMENT-RUNNER-v2';

const _subjectRun = FounderAuthorizationSubjectRun(
  authorizationReference: 'FA-019A-RETRY-20260729-008',
  commitSha: '7a660c143949ca7fc6cbd423a7c8d30102a5d7f9',
  manifest: 'FOUNDATION-019A-SECOND-FUNCTIONAL-ATTEMPT-v4',
  runner: 'FOUNDATION-019A-R2G-RUNNER-v1',
  result: 'DEVELOPMENT SECOND_FUNCTIONAL_ATTEMPT_V4_FAILED_DIRTY_BLOCKING',
  lastReachedState: 'CONVERSATION_CREATED',
  failureCategory: 'UNKNOWN_POST_CREATE_FAILURE',
);

FounderAuthorizationSubjectRun _subject({
  String? authorizationReference,
  String? commitSha,
  String? manifest,
  String? runner,
  String? result,
  String? lastReachedState,
  String? failureCategory,
}) => FounderAuthorizationSubjectRun(
  authorizationReference:
      authorizationReference ?? _subjectRun.authorizationReference,
  commitSha: commitSha ?? _subjectRun.commitSha,
  manifest: manifest ?? _subjectRun.manifest,
  runner: runner ?? _subjectRun.runner,
  result: result ?? _subjectRun.result,
  lastReachedState: lastReachedState ?? _subjectRun.lastReachedState,
  failureCategory: failureCategory ?? _subjectRun.failureCategory,
);

FounderAuthorizationProposalV2 _proposalV2({
  required String id,
  String operation = _operation,
}) => FounderAuthorizationProposalV2(
  authorizationId: id,
  decision: 'APPROVED',
  decisionSource: 'EXPLICIT_CONVERSATIONAL_APPROVAL',
  authorizedOperation: operation,
  authorizedEnvironment: 'development',
  authorizedManifest: _containmentManifest,
  authorizedRunner: _containmentRunner,
  scope: 'EXACT_DIAGNOSTIC_AND_RUN_SCOPED_CONTAINMENT',
  subjectRun: _subjectRun,
);

FounderAuthorizationArtifactV2 _artifactV2({String operation = _operation}) =>
    FounderAuthorizationArtifactV2.granted(
      proposal: _proposalV2(id: 'artifact-v2', operation: operation),
      commitSha: _commit,
      now: _now,
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

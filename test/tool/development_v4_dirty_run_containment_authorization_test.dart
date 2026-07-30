import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/development_v4_dirty_run_containment_contracts.dart';
import '../../tool/development_v4_dirty_run_containment_runner.dart';
import '../../tool/founder_authorization_artifact.dart';

void main() {
  final manifest = V4ContainmentManifest.read(
    File(
      'docs/stasisly_foundation/development/'
      'development_v4_dirty_run_containment_manifest.json',
    ),
  );
  final expectedSubjectRun = v4SubjectRunFromManifest(manifest);

  test('R2H accepts only a valid V2 artifact with all subject bindings', () {
    final artifact = _artifact(expectedSubjectRun);
    expect(
      validateV4ContainmentAuthorization(
        artifact,
        manifest: manifest,
        headSha: _commit,
        now: _now,
      ),
      isEmpty,
    );
  });

  test('R2H rejects V1 before any remote gateway can be constructed', () {
    final v1 = FounderAuthorizationArtifactV1.granted(
      proposal: const FounderAuthorizationProposalV1(
        authorizationId: 'r2h-v1-blocked',
        decision: 'APPROVED',
        decisionSource: 'EXPLICIT_CONVERSATIONAL_APPROVAL',
        authorizedOperation: _operation,
        authorizedEnvironment: 'development',
        authorizedManifest: v4ContainmentManifestVersion,
        authorizedRunner: v4ContainmentRunnerVersion,
        scope: 'EXACT_DIAGNOSTIC_AND_RUN_SCOPED_CONTAINMENT',
      ),
      commitSha: _commit,
      now: _now,
    );

    expect(
      validateV4ContainmentAuthorization(
        v1,
        manifest: manifest,
        headSha: _commit,
        now: _now,
      ),
      contains('AUTHORIZATION_SCHEMA_VERSION_INSUFFICIENT'),
    );
  });

  test('R2H rejects every subject-run binding mismatch', () {
    final cases = <String, FounderAuthorizationSubjectRun>{
      'SUBJECT_RUN_AUTHORIZATION_MISMATCH': _copySubject(
        expectedSubjectRun,
        authorizationReference: 'FA-OTHER-RUN',
      ),
      'SUBJECT_RUN_COMMIT_MISMATCH': _copySubject(
        expectedSubjectRun,
        commitSha: 'b' * 40,
      ),
      'SUBJECT_RUN_MANIFEST_MISMATCH': _copySubject(
        expectedSubjectRun,
        failedManifest: 'OTHER-MANIFEST-v1',
      ),
      'SUBJECT_RUN_RUNNER_MISMATCH': _copySubject(
        expectedSubjectRun,
        failedRunner: 'OTHER-RUNNER-v1',
      ),
      'SUBJECT_RUN_RESULT_MISMATCH': _copySubject(
        expectedSubjectRun,
        result: 'OTHER FAILED RESULT',
      ),
      'SUBJECT_RUN_LAST_STATE_MISMATCH': _copySubject(
        expectedSubjectRun,
        lastReachedState: 'OTHER_STATE',
      ),
      'SUBJECT_RUN_FAILURE_CATEGORY_MISMATCH': _copySubject(
        expectedSubjectRun,
        failureCategory: 'OTHER_FAILURE',
      ),
    };

    for (final entry in cases.entries) {
      final findings = validateV4ContainmentAuthorization(
        _artifact(entry.value),
        manifest: manifest,
        headSha: _commit,
        now: _now,
      );
      expect(findings, contains(entry.key), reason: entry.key);
    }
  });

  test('R2H rejects expired, consumed and corrupt V2 artifacts', () {
    final granted = _artifact(expectedSubjectRun);
    final expired = FounderAuthorizationArtifactV2.granted(
      proposal: _proposal(expectedSubjectRun, id: 'r2h-expired'),
      commitSha: _commit,
      now: _now.subtract(const Duration(hours: 3)),
    );
    final consumed = granted
        .copyWith(
          status: FounderAuthorizationStatus.consumed,
          remoteExecutionCount: 1,
          consumedAt: _now,
        )
        .withRecalculatedHash();
    final corrupt = FounderAuthorizationArtifactV1.fromJson(
      granted.toJson()..['scope'] = 'MUTATED_SCOPE',
    );

    expect(
      validateV4ContainmentAuthorization(
        expired,
        manifest: manifest,
        headSha: _commit,
        now: _now,
      ),
      contains('AUTHORIZATION_EXPIRED'),
    );
    expect(
      validateV4ContainmentAuthorization(
        consumed,
        manifest: manifest,
        headSha: _commit,
        now: _now,
      ),
      contains('AUTHORIZATION_ALREADY_CONSUMED'),
    );
    expect(
      validateV4ContainmentAuthorization(
        corrupt,
        manifest: manifest,
        headSha: _commit,
        now: _now,
      ),
      contains('AUTHORIZATION_PAYLOAD_HASH_MISMATCH'),
    );
  });

  test('legacy conflict remains fail-closed for V2', () {
    final artifact = _artifact(expectedSubjectRun);
    expect(
      resolveAuthorizationSource(
        artifact: artifact,
        environment: const {'AUTHORIZED_COMMIT_SHA': 'wrong'},
      ),
      FounderAuthorizationSourceResolution.blockedConflict,
    );
    expect(
      resolveAuthorizationSource(artifact: artifact, environment: const {}),
      FounderAuthorizationSourceResolution.artifactOnly,
    );
  });
}

final _now = DateTime.utc(2026, 7, 30, 15);
const _commit = 'f9e9510a927955d97bda6cc57ee6b974c9a9dd10';
const _operation = 'FOUNDATION-019A_V4_FAILED_RUN_DIAGNOSTIC_AND_CONTAINMENT';

FounderAuthorizationProposalV2 _proposal(
  FounderAuthorizationSubjectRun subjectRun, {
  String id = 'r2h-v2',
}) => FounderAuthorizationProposalV2(
  authorizationId: id,
  decision: 'APPROVED',
  decisionSource: 'EXPLICIT_CONVERSATIONAL_APPROVAL',
  authorizedOperation: _operation,
  authorizedEnvironment: 'development',
  authorizedManifest: v4ContainmentManifestVersion,
  authorizedRunner: v4ContainmentRunnerVersion,
  scope: 'EXACT_DIAGNOSTIC_AND_RUN_SCOPED_CONTAINMENT',
  subjectRun: subjectRun,
);

FounderAuthorizationArtifactV2 _artifact(
  FounderAuthorizationSubjectRun subjectRun,
) => FounderAuthorizationArtifactV2.granted(
  proposal: _proposal(subjectRun),
  commitSha: _commit,
  now: _now,
);

FounderAuthorizationSubjectRun _copySubject(
  FounderAuthorizationSubjectRun source, {
  String? authorizationReference,
  String? commitSha,
  String? failedManifest,
  String? failedRunner,
  String? result,
  String? lastReachedState,
  String? failureCategory,
}) => FounderAuthorizationSubjectRun(
  authorizationReference:
      authorizationReference ?? source.authorizationReference,
  commitSha: commitSha ?? source.commitSha,
  manifest: failedManifest ?? source.manifest,
  runner: failedRunner ?? source.runner,
  result: result ?? source.result,
  lastReachedState: lastReachedState ?? source.lastReachedState,
  failureCategory: failureCategory ?? source.failureCategory,
);

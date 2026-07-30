import 'dart:convert';
import 'dart:io';

import 'founder_authorization_artifact.dart';

Future<void> main(List<String> arguments) async {
  if (arguments.length != 2 ||
      !{'grant', 'validate'}.contains(arguments.first)) {
    stderr.writeln(
      'Usage: dart run tool/founder_authorization_cli.dart '
      '<grant|validate> <proposal-or-artifact>',
    );
    exitCode = 64;
    return;
  }
  try {
    final store = FounderAuthorizationStore(repositoryRoot: Directory.current);
    switch (arguments.first) {
      case 'grant':
        final proposal = readFounderAuthorizationProposal(File(arguments.last));
        final head = Process.runSync('git', ['rev-parse', 'HEAD']);
        if (head.exitCode != 0) {
          throw const FounderAuthorizationException(
            'AUTHORIZATION_COMMIT_UNAVAILABLE',
          );
        }
        final artifact = store.grantFromProposal(
          proposal,
          currentCommitSha: (head.stdout as String).trim(),
        );
        stdout.writeln(
          jsonEncode({
            'authorization': artifact.authorizationId,
            'status': artifact.status.value,
            'schema': artifact.schemaVersion,
            'artifact': 'CREATED',
          }),
        );
      case 'validate':
        final id = _authorizationIdFromPath(arguments.last);
        final artifact = store.read(id);
        final findings = artifact.validate(now: DateTime.now().toUtc());
        if (findings.isNotEmpty) {
          throw FounderAuthorizationException(findings.first);
        }
        stdout.writeln('FOUNDER_AUTHORIZATION_ARTIFACT_VALID');
    }
  } on FounderAuthorizationException catch (error) {
    stderr.writeln(error.code);
    exitCode = 65;
  }
}

FounderAuthorizationProposalV1 readFounderAuthorizationProposal(File file) {
  final decoded = jsonDecode(file.readAsStringSync());
  if (decoded is! Map<String, Object?>) {
    throw const FounderAuthorizationException('AUTHORIZATION_PROPOSAL_INVALID');
  }
  String value(String key) {
    final entry = decoded[key];
    if (entry is! String || entry.isEmpty) {
      throw const FounderAuthorizationException(
        'AUTHORIZATION_PROPOSAL_INVALID',
      );
    }
    return entry;
  }

  final operation = value('authorized_operation');
  final common = (
    authorizationId: value('authorization_id'),
    decision: value('decision'),
    decisionSource: value('decision_source'),
    authorizedEnvironment: value('authorized_environment'),
    authorizedManifest: value('authorized_manifest'),
    authorizedRunner: value('authorized_runner'),
    scope: value('scope'),
  );
  if (founderAuthorizationOperationRequiresSubjectRun(operation)) {
    final source = value('subject_run_manifest_path');
    final approvedRoot = Directory(
      '${Directory.current.path}${Platform.pathSeparator}'
      'docs${Platform.pathSeparator}stasisly_foundation'
      '${Platform.pathSeparator}development',
    ).resolveSymbolicLinksSync();
    late final String sourcePath;
    try {
      sourcePath = File(source).absolute.resolveSymbolicLinksSync();
    } on FileSystemException {
      throw const FounderAuthorizationException(
        'AUTHORIZATION_SUBJECT_RUN_MANIFEST_PATH_BLOCKED',
      );
    }
    if (!sourcePath.startsWith('$approvedRoot${Platform.pathSeparator}') ||
        !sourcePath.endsWith('.json')) {
      throw const FounderAuthorizationException(
        'AUTHORIZATION_SUBJECT_RUN_MANIFEST_PATH_BLOCKED',
      );
    }
    return FounderAuthorizationProposalV2(
      authorizationId: common.authorizationId,
      decision: common.decision,
      decisionSource: common.decisionSource,
      authorizedOperation: operation,
      authorizedEnvironment: common.authorizedEnvironment,
      authorizedManifest: common.authorizedManifest,
      authorizedRunner: common.authorizedRunner,
      scope: common.scope,
      subjectRun: readFounderAuthorizationSubjectRun(
        File(sourcePath),
        expectedAuthorizedManifest: common.authorizedManifest,
        expectedAuthorizedRunner: common.authorizedRunner,
      ),
    );
  }
  if (decoded.containsKey('subject_run_manifest_path')) {
    throw const FounderAuthorizationException(
      'AUTHORIZATION_SUBJECT_RUN_FORBIDDEN',
    );
  }
  return FounderAuthorizationProposalV1(
    authorizationId: common.authorizationId,
    decision: common.decision,
    decisionSource: common.decisionSource,
    authorizedOperation: operation,
    authorizedEnvironment: common.authorizedEnvironment,
    authorizedManifest: common.authorizedManifest,
    authorizedRunner: common.authorizedRunner,
    scope: common.scope,
  );
}

FounderAuthorizationSubjectRun readFounderAuthorizationSubjectRun(
  File file, {
  String? expectedAuthorizedManifest,
  String? expectedAuthorizedRunner,
}) {
  final decoded = jsonDecode(file.readAsStringSync());
  if (decoded is! Map<String, Object?>) {
    throw const FounderAuthorizationException(
      'AUTHORIZATION_SUBJECT_RUN_MANIFEST_INVALID',
    );
  }
  final failedRun = decoded['failedRun'];
  if (failedRun is! Map<String, Object?>) {
    throw const FounderAuthorizationException(
      'AUTHORIZATION_SUBJECT_RUN_MANIFEST_INVALID',
    );
  }
  if ((expectedAuthorizedManifest != null &&
          decoded['manifestVersion'] != expectedAuthorizedManifest) ||
      (expectedAuthorizedRunner != null &&
          decoded['runnerVersion'] != expectedAuthorizedRunner) ||
      decoded['authorizationArtifactSchema'] !=
          founderAuthorizationSchemaVersionV2) {
    throw const FounderAuthorizationException(
      'AUTHORIZATION_SUBJECT_RUN_MANIFEST_BINDING_MISMATCH',
    );
  }
  String value(String key) {
    final entry = failedRun[key];
    if (entry is! String || entry.isEmpty) {
      throw const FounderAuthorizationException(
        'AUTHORIZATION_SUBJECT_RUN_MANIFEST_INVALID',
      );
    }
    return entry;
  }

  return FounderAuthorizationSubjectRun(
    authorizationReference: value('authorizationReference'),
    commitSha: value('commit'),
    manifest: value('manifestVersion'),
    runner: value('runnerVersion'),
    result: value('result'),
    lastReachedState: value('lastApprovedState'),
    failureCategory: value('failureCategory'),
  );
}

String _authorizationIdFromPath(String path) {
  final name = path.split(Platform.pathSeparator).last;
  return name.endsWith('.json')
      ? name.substring(0, name.length - '.json'.length)
      : name;
}

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
        final proposal = _readProposal(File(arguments.last));
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

FounderAuthorizationProposalV1 _readProposal(File file) {
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

  return FounderAuthorizationProposalV1(
    authorizationId: value('authorization_id'),
    decision: value('decision'),
    decisionSource: value('decision_source'),
    authorizedOperation: value('authorized_operation'),
    authorizedEnvironment: value('authorized_environment'),
    authorizedManifest: value('authorized_manifest'),
    authorizedRunner: value('authorized_runner'),
    scope: value('scope'),
  );
}

String _authorizationIdFromPath(String path) {
  final name = path.split(Platform.pathSeparator).last;
  return name.endsWith('.json')
      ? name.substring(0, name.length - '.json'.length)
      : name;
}

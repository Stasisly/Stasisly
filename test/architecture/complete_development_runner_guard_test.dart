import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  final manifest =
      jsonDecode(
            File(
              'docs/stasisly_foundation/development/'
              'development_second_functional_attempt_manifest.json',
            ).readAsStringSync(),
          )
          as Map<String, dynamic>;
  final runner = File(
    'tool/development_complete_functional_runner.dart',
  ).readAsStringSync();
  final contracts = File(
    'tool/development_complete_runner_contracts.dart',
  ).readAsStringSync();
  final shell = File(
    'scripts/run_development_remote_fixture_test.sh',
  ).readAsStringSync();

  test('every manifest operation maps to executable runner code', () {
    final operations = (manifest['operations'] as List)
        .cast<Map<String, dynamic>>();
    for (final operation in operations) {
      expect(operation['implemented'], isTrue);
      expect(operation['tested'], isTrue);
      expect(
        runner,
        contains('${operation['runnerFunction']}'),
        reason: '${operation['operation']} lacks runner function',
      );
    }
  });

  test('runner uses closed state helper and blocks the historical skip', () {
    expect(runner, contains('CompleteRunnerStateMachine'));
    expect(contracts, contains('RUNNER_STATE_TRANSITION_BLOCKED'));
    expect(runner, isNot(contains("state._state = 'FLOW_COMPLETED'")));
    expect(shell, isNot(contains('runner_state=FLOW_COMPLETED')));
  });

  test('complete runner contains canonical functional operations', () {
    for (final marker in [
      '/functions/v1/list-selectable-specialists',
      '/functions/v1/create-own-chat-session',
      '/functions/v1/list-own-chat-sessions',
      '/functions/v1/read-own-conversation',
      '/functions/v1/send-user-message',
      '/functions/v1/list-session-messages',
      '/functions/v1/archive-own-chat-session',
      '/functions/v1/restore-own-conversation',
      'validateReplay',
      'validateConversationList',
      'validateConversationDetail',
      'validateNoAiEvidence',
      'validateLifecycleState',
      'validateOpaqueForeignResponse',
      'validateForeignOpacity',
      'validateBlockedRoutes',
      'cleanupLedger',
      'validateAuthAbsence',
      'validateResidueCounters',
      'isolateCli',
      'runLocalRegression',
    ]) {
      expect(runner, contains(marker), reason: 'missing $marker');
    }
  });

  test('shell remains inert and gate is commit and version specific', () {
    expect(shell, contains('--authorized-development-run'));
    expect(shell, contains('FOUNDER_AUTHORIZATION_REFERENCE'));
    expect(shell, contains('AUTHORIZED_COMMIT_SHA'));
    expect(shell, contains('SECOND_FUNCTIONAL_ATTEMPT_MANIFEST_VERSION'));
    expect(shell, contains('FOUNDATION-019A-SECOND-FUNCTIONAL-ATTEMPT-v2'));
    expect(shell, contains('FOUNDATION-019A-R2D-RUNNER-v1'));
    expect(shell, contains('RETENTION_LIMITATION_ACKNOWLEDGED'));
    expect(shell, contains('supabase link --project-ref'));
    expect(shell, contains('check_supabase_remote_context.dart'));
  });

  test('remote defaults remain disabled and authorization unassigned', () {
    expect(manifest['authorization'], 'NOT_GRANTED');
    expect(manifest['execution'], 'NOT_EXECUTED');
    expect(manifest['authorizedCommit'], 'UNASSIGNED');
    expect(manifest['authorizationReference'], 'UNASSIGNED');
    expect(manifest['remoteSkips'], 'CLASSIFIED_NOT_ENABLED');
    expect(manifest['schemaChange'], 'FORBIDDEN');
    expect(manifest['migration'], 'FORBIDDEN');
    expect(manifest['functionDeploy'], 'FORBIDDEN');
    expect(manifest['secretMutation'], 'FORBIDDEN');
  });

  test('runner evidence does not print raw sensitive values', () {
    for (final forbidden in [
      'stdout.writeln(context.ownerId)',
      'stdout.writeln(context.foreignId)',
      'stdout.writeln(context.ownerEmail)',
      'stdout.writeln(context.ownerToken)',
      'stdout.writeln(context.conversationId)',
      'stdout.writeln(context.messageContent)',
      'set -x',
      'curl --trace',
    ]) {
      expect(runner + shell, isNot(contains(forbidden)));
    }
  });
}

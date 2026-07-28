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
  final adapter = File(
    'tool/development_catalog_envelope_adapter.dart',
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
    expect(shell, contains('FOUNDATION-019A-SECOND-FUNCTIONAL-ATTEMPT-v4'));
    expect(shell, contains('FOUNDATION-019A-R2G-RUNNER-v1'));
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
    expect(manifest['specialistPolicy'], 'VERIFIED_PREEXISTING_READ_ONLY');
    expect(manifest['specialistSource'], 'SELECTABLE_SPECIALIST_CATALOG');
    expect(manifest['specialistCreation'], 'FORBIDDEN');
    expect(manifest['catalogCreation'], 'FORBIDDEN');
    expect(manifest['specialistCleanup'], 'NOT_APPLICABLE');
    expect(manifest['catalogCleanup'], 'NOT_APPLICABLE');
  });

  test('functional runner cannot create or delete catalog resources', () {
    expect(runner, contains('resolveSpecialistFromCanonicalCatalog'));
    expect(runner, contains('VerifiedPreexistingReadOnlyPolicy'));
    expect(runner, contains('verifiedPreexistingReadOnly'));
    expect(runner, isNot(contains('_createRunOwnedSpecialistFixture')));
    expect(
      runner,
      isNot(
        contains(
          "method: 'POST',\n      uri: client.endpoint('/rest/v1/specialists'",
        ),
      ),
    );
    expect(
      runner,
      isNot(
        contains(
          "method: 'POST',\n      uri: client.endpoint('/rest/v1/specialist_catalog'",
        ),
      ),
    );
    expect(runner, isNot(contains("client.endpoint('/rest/v1/specialists'")));
    expect(
      runner,
      isNot(contains("client.endpoint('/rest/v1/specialist_catalog'")),
    );
    expect(runner, contains('READ_ONLY_CLEANUP_BLOCKED'));
  });

  test('specialist selection is bounded and ambiguity blocks', () {
    final selection = manifest['specialistSelection'] as Map<String, dynamic>;
    expect(selection['mode'], 'EXACT_ONE_AVAILABLE_IN_CANONICAL_AREA');
    expect(selection['canonicalArea'], 'stasis');
    expect(selection['maxCandidates'], 20);
    expect(selection['ambiguity'], 'BLOCK');
    expect(runner, contains("'area': 'stasis'"));
    expect(runner, isNot(contains('.first')));
    expect(runner, isNot(contains('.firstWhere')));
    expect(contracts, contains('DevelopmentCatalogEnvelopeAdapter'));
    expect(adapter, contains('CATALOG_ADAPTER_SHARED'));
    expect(adapter, contains('pageLimitReached'));
    expect(adapter, contains('paginationRequiresAdditionalPage'));
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

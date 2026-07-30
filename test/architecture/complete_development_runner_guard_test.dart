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
  final identity = File(
    'tool/development_conversation_identity.dart',
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
    expect(shell, contains('FOUNDATION-019A-SECOND-FUNCTIONAL-ATTEMPT-v5'));
    expect(shell, contains('FOUNDATION-019A-R2I-RUNNER-v1'));
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

  test('created state requires exact persisted and verified identity', () {
    final parse = runner.indexOf('classifyConversationCreateResponse(');
    final register = runner.indexOf('LedgerEntry(', parse);
    final persist = runner.indexOf('persistAndVerify(', register);
    final transition = runner.indexOf(
      "_advance('CONVERSATION_CREATED'",
      persist,
    );
    expect(parse, greaterThanOrEqualTo(0));
    expect(register, greaterThan(parse));
    expect(persist, greaterThan(register));
    expect(transition, greaterThan(persist));
    expect(runner, contains('assessment.permitsCreatedState'));
    expect(runner, contains('context.createdConversationIdentity = identity'));
    expect(identity, contains('CONVERSATION_CREATE_RESPONSE_INCOMPLETE'));
    expect(identity, contains('CREATED_BY_RUN'));
  });

  test(
    'functional cleanup uses ledger handles instead of mutable context IDs',
    () {
      final cleanupStart = runner.indexOf('Future<bool> _deleteEntry(');
      final cleanupEnd = runner.indexOf(
        'Future<bool> validateAuthAbsence()',
        cleanupStart,
      );
      final cleanup = runner.substring(cleanupStart, cleanupEnd);
      expect(cleanup, contains(r"'id': 'eq.${entry.cleanupHandle}'"));
      expect(
        cleanup,
        isNot(contains(r"'session_id': 'eq.${entry.cleanupHandle}'")),
      );
      expect(runner, contains(r"'subject_id': 'eq.${entry.cleanupHandle}'"));
      expect(identity, contains('.runtime'));
      expect(identity, contains('resource-ledger.json'));
      expect(identity, contains('temporary.renameSync(target.path)'));
      expect(identity, contains("_chmod(target.path, '600')"));
    },
  );

  test(
    'identity recovery forbids broad reconstruction and attempt regeneration',
    () {
      final cleanupStart = runner.indexOf('Future<bool> cleanupLedger()');
      final cleanupEnd = runner.indexOf(
        'Future<bool> validateAuthAbsence()',
        cleanupStart,
      );
      final cleanup = runner.substring(cleanupStart, cleanupEnd);
      expect(cleanup, isNot(contains('created_at')));
      expect(cleanup, isNot(contains('like.')));
      expect(cleanup, isNot(contains('.first')));
      expect(runner, contains('late final String createAttempt'));
      expect(runner.split('late final String createAttempt'), hasLength(2));
      expect(identity, contains('creationRequestFingerprint'));
      expect(identity, contains('authorizationReference'));
      expect(identity, contains('commitSha'));
      expect(identity, contains('manifestVersion'));
      expect(identity, contains('runnerVersion'));
    },
  );

  test('runtime ledger stays ignored and legacy dirty run stays blocking', () {
    final ignore = File('.gitignore').readAsLinesSync();
    expect(ignore.where((line) => line.trim() == '.runtime/'), hasLength(1));
    expect(
      identity,
      contains('LEGACY_DIRTY_RUN_MISSING_EXACT_CONVERSATION_IDENTITY'),
    );
    expect(identity, contains('CONVERSATION_LEDGER_INTEGRITY_FAILED'));
    expect(identity, contains('CONVERSATION_LEDGER_TRANSITION_BLOCKED'));
  });
}

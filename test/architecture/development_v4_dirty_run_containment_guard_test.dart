import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  final runner = File(
    'tool/development_v4_dirty_run_containment_runner.dart',
  ).readAsStringSync();
  final gateway = File(
    'tool/development_v4_dirty_run_containment_http_gateway.dart',
  ).readAsStringSync();
  final contracts = File(
    'tool/development_v4_dirty_run_containment_contracts.dart',
  ).readAsStringSync();
  final wrapper = File(
    'scripts/run_development_v4_dirty_run_containment.sh',
  ).readAsStringSync();
  final manifest = File(
    'docs/stasisly_foundation/development/'
    'development_v4_dirty_run_containment_manifest.json',
  ).readAsStringSync();

  test('R2H entry point is isolated from every functional primitive', () {
    expect(runner, contains("'--validate-contract'"));
    expect(runner, contains("'--authorized-v4-containment-run'"));
    for (final forbidden in [
      'development_complete_functional_runner',
      'development_second_functional_attempt_runner',
      'createConversation',
      'sendUserMessage',
      'archiveConversation',
      'restoreConversation',
      'validateBlockedRoutes',
      'supabase link',
      '/functions/v1/',
    ]) {
      expect(runner, isNot(contains(forbidden)), reason: forbidden);
    }
  });

  test('gateway permits bounded GET and exact DELETE only', () {
    expect(gateway, contains("method != 'GET' && method != 'DELETE'"));
    expect(gateway, contains("'limit': '2'"));
    expect(gateway, contains("'operation_id': 'eq.create_conversation'"));
    for (final forbidden in [
      "method: 'POST'",
      "method: 'PATCH'",
      "method: 'PUT'",
      '/functions/v1/',
      'listUsers',
      'supabase link',
    ]) {
      expect(gateway, isNot(contains(forbidden)), reason: forbidden);
    }
  });

  test('canonical and unowned resources cannot receive delete operations', () {
    expect(contracts, contains('CANONICAL_RESOURCE_PROTECTION_BLOCKED'));
    expect(contracts, contains('BLOCKED_INSUFFICIENT_EXACT_LOOKUP'));
    expect(contracts, contains('verifiedPreexistingReadOnly'));
    expect(gateway, contains("case 'catalog':"));
    expect(gateway, contains("case 'specialists':"));
  });

  test('functional and containment authorizations cannot cross-activate', () {
    expect(runner, contains('FOUNDER_AUTHORIZATION_ARTIFACT'));
    expect(runner, contains('FounderAuthorizationStore'));
    expect(runner, contains('FounderAuthorizationArtifactV2'));
    expect(runner, contains('validateV4ContainmentAuthorization'));
    expect(runner, contains('v4SubjectRunFromManifest'));
    expect(runner, contains('resolveAuthorizationSource'));
    expect(runner, contains('store.consume'));
    expect(runner, contains('v4FailedAuthorizationReference'));
    expect(runner, isNot(contains("FOUNDER_AUTHORIZATION_REFERENCE'")));
    expect(wrapper, contains('--authorized-v4-containment-run'));
    expect(wrapper, contains('FOUNDER_AUTHORIZATION_ARTIFACT'));
    expect(
      wrapper,
      isNot(contains('FOUNDER_CONTAINMENT_AUTHORIZATION_REFERENCE')),
    );
    expect(wrapper, isNot(contains('CONTAINMENT_AUTHORIZATION_STATUS')));
    expect(wrapper, isNot(contains('AUTHORIZED_COMMIT_SHA')));
    expect(wrapper, isNot(contains('--authorized-second-functional-attempt')));
  });

  test('wrapper never autoloads env and always isolates CLI context', () {
    expect(wrapper, contains('trap cleanup_cli_context EXIT'));
    expect(wrapper, contains('supabase/.temp/project-ref'));
    expect(wrapper, contains('supabase/.temp/pooler-url'));
    expect(wrapper, contains('check_supabase_remote_context.dart'));
    expect(wrapper, isNot(contains('source .env')));
    expect(wrapper, isNot(contains('supabase link')));
  });

  test('manifest keeps creation, replay and mutation closed', () {
    expect(manifest, contains('"remoteAuthorization": "NOT_GRANTED"'));
    expect(manifest, contains('"remoteExecution": "NOT_EXECUTED"'));
    expect(
      manifest,
      contains('"authorizationArtifactSchema": "founder-authorization-v2"'),
    );
    for (final binding in [
      'authorizationReference',
      'commit',
      'manifestVersion',
      'runnerVersion',
      'result',
      'lastApprovedState',
      'failureCategory',
    ]) {
      expect(manifest, contains('"$binding"'), reason: binding);
    }
    for (final key in [
      'functionalRunner',
      'authCreation',
      'conversationCreation',
      'messageCreation',
      'idempotencyReplay',
      'catalogMutation',
      'specialistMutation',
    ]) {
      expect(manifest, contains('"$key": "DISABLED"'), reason: key);
    }
  });

  test('R2H validates every subject-run binding and cannot accept V1', () {
    for (final binding in [
      'failedAuthorizationReference',
      'failedCommit',
      'failedManifestVersion',
      'failedRunnerVersion',
      'failedResult',
      'lastApprovedState',
      'failureCategory',
    ]) {
      expect(runner, contains('manifest.$binding'), reason: binding);
    }
    expect(runner, contains('AUTHORIZATION_SCHEMA_VERSION_INSUFFICIENT'));
    expect(contracts, contains('founder-authorization-v2'));
    expect(wrapper, contains('FOUNDATION-019A-R2H-CONTAINMENT-RUNNER-v2'));
  });

  test('safe evidence includes no sensitive identity fields', () {
    for (final forbidden in [
      "'alias'",
      "'email'",
      "'userId'",
      "'conversationId'",
      "'messageId'",
      "'profileId'",
      "'sessionId'",
      "'specialistId'",
      "'catalogId'",
      "'token'",
      "'rawBody'",
    ]) {
      expect(runner, isNot(contains(forbidden)), reason: forbidden);
    }
  });
}

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  final runner = File(
    'tool/development_containment_diagnostic_runner.dart',
  ).readAsStringSync();
  final contracts = File(
    'tool/development_containment_diagnostic_contracts.dart',
  ).readAsStringSync();
  final gateway = File(
    'tool/development_containment_diagnostic_http_gateway.dart',
  ).readAsStringSync();
  final adapter = File(
    'tool/development_catalog_envelope_adapter.dart',
  ).readAsStringSync();
  final manifest = File(
    'docs/stasisly_foundation/development/'
    'development_containment_diagnostic_manifest.json',
  ).readAsStringSync();

  test('diagnostic runner contains no functional execution primitive', () {
    for (final forbidden in [
      'supabase link',
      'curl ',
      '/auth/v1/admin/users',
      'createConversation',
      'sendUserMessage',
      'archiveConversation',
      'restoreConversation',
      'validateBlockedRoutes',
    ]) {
      expect(runner, isNot(contains(forbidden)), reason: forbidden);
    }
    expect(runner, contains("'--validate-contract'"));
    expect(runner, contains("'--authorized-containment-run'"));
  });

  test('HTTP gateway permits only bounded GET and exact DELETE', () {
    expect(gateway, contains("method != 'GET' && method != 'DELETE'"));
    expect(gateway, contains("'limit': '20'"));
    expect(gateway, contains("'limit': '2'"));
    expect(gateway, contains(r"'id': 'eq.$_profileDeleteHandle'"));
    for (final forbidden in [
      "method: 'POST'",
      "method: 'PATCH'",
      "method: 'PUT'",
      '/functions/v1/create',
      '/functions/v1/send',
      '/auth/v1/admin/users',
      '/rest/v1/specialists',
    ]) {
      expect(gateway, isNot(contains(forbidden)), reason: forbidden);
    }
  });

  test('containment contracts block broad and canonical deletion', () {
    expect(contracts, contains('CANONICAL_RESOURCE_DELETE_BLOCKED'));
    expect(contracts, contains('EXACT_CONTAINMENT_BLOCKED'));
    expect(contracts, contains('verifiedPreexistingReadOnly'));
    expect(contracts, contains('globalResource'));
    expect(contracts, contains('unscopedResource'));
    expect(contracts, isNot(contains('listUsers')));
    expect(contracts, isNot(contains('wildcard')));
  });

  test('manifest keeps every remote and functional gate closed', () {
    expect(manifest, contains('"remoteAuthorization": "NOT_GRANTED"'));
    expect(manifest, contains('"remoteExecution": "NOT_EXECUTED"'));
    expect(manifest, contains('"functionalExecutions": "BLOCKED"'));
    expect(manifest, contains('"newAuthUsers": "BLOCKED"'));
    expect(manifest, contains('"newConversations": "BLOCKED"'));
    expect(manifest, contains('"catalogMutation": "FORBIDDEN"'));
    expect(manifest, contains('"specialistMutation": "FORBIDDEN"'));
    expect(manifest, contains('"broadLookups": "FORBIDDEN"'));
    expect(manifest, contains('"broadDeletes": "FORBIDDEN"'));
  });

  test('functional and containment entry points are physically separate', () {
    final functional = File(
      'tool/development_complete_functional_runner.dart',
    ).readAsStringSync();
    expect(
      runner,
      isNot(contains('development_complete_functional_runner.dart')),
    );
    expect(
      functional,
      isNot(contains('development_containment_diagnostic_runner.dart')),
    );
    expect(runner, contains('ContainmentDiagnosticGateway'));
  });

  test(
    'functional and diagnostic catalog paths share one explicit adapter',
    () {
      final functionalContracts = File(
        'tool/development_complete_runner_contracts.dart',
      ).readAsStringSync();
      final functionalRunner = File(
        'tool/development_complete_functional_runner.dart',
      ).readAsStringSync();
      expect(adapter, contains('CATALOG_ADAPTER_SHARED'));
      expect(adapter, contains('productItemsEnvelope'));
      expect(adapter, contains('diagnosticDirectRawList'));
      expect(
        functionalContracts,
        contains('DevelopmentCatalogEnvelopeAdapter'),
      );
      expect(gateway, contains('DevelopmentCatalogEnvelopeAdapter'));
      expect(functionalRunner, contains('productItemsEnvelope'));
      expect(gateway, contains('diagnosticDirectRawList'));
      expect(functionalContracts, isNot(contains('catalogPayload is! List')));
    },
  );

  test('safe evidence has categories and no sensitive identity fields', () {
    expect(runner, contains("'catalogCategory'"));
    expect(runner, contains("'counterCategories'"));
    expect(runner, contains("'classification'"));
    for (final forbidden in [
      "'email'",
      "'userId'",
      "'conversationId'",
      "'specialistId'",
      "'catalogId'",
      "'alias'",
      "'token'",
      "'rawBody'",
    ]) {
      expect(runner, isNot(contains(forbidden)), reason: forbidden);
    }
  });
}
